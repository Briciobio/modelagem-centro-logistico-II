-- =====================================================================
-- ENTREGA 2 — Modelagem de Banco de Dados (2026-2)
-- Organização: JV Indústria / JVX Grupo (Jacareí-SP) — MySQL 8.0.16+
-- Dados fictícios, baseados nas linhas e produtos do site da empresa.
--
-- Problemas (P) e regras (RN) citados nas consultas
-- (ajuste os códigos conforme o seu README):
--   P1 Ruptura de estoque de produto acabado     P4 Paradas de máquina sem controle
--   P2 Falta de matéria-prima para produzir      P5 Cancelamentos sem acompanhamento
--   P3 Atrasos entre pedido, saída e entrega     P6 Falta de visão de faturamento
--   RN01 Documento e e-mail do cliente únicos    RN06 Pedido expedido tem nota fiscal
--   RN02 Todo pedido pertence a um cliente       RN07 Lote vencido não é estoque disponível
--   RN03 Cancelado tem data de cancelamento      RN08 Produção só em máquina homologada
--   RN04 Todo pedido tem ao menos um item        RN09 Todo produto tem fórmula vigente
--   RN05 valor_total = itens + taxa de entrega   RN10 Retirada não paga taxa de entrega
-- =====================================================================

-- 1. CREATE DATABASE
DROP DATABASE IF EXISTS jv_industria;
CREATE DATABASE jv_industria CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE jv_industria;
SET NAMES utf8mb4;

-- 2. CREATE TABLE

CREATE TABLE cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  documento VARCHAR(20) NOT NULL,
  canal ENUM('revenda','construtora','exportacao') NOT NULL,
  endereco VARCHAR(200),
  telefone VARCHAR(20),
  email VARCHAR(120) NOT NULL,
  CONSTRAINT uq_cliente_documento UNIQUE (documento),
  CONSTRAINT uq_cliente_email UNIQUE (email)
) ENGINE=InnoDB;

CREATE TABLE pedido (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  valor_total DECIMAL(12,2) NOT NULL,
  tipo_pagamento ENUM('pix','boleto','transferencia','cartao_credito','faturado_28_dias') NOT NULL,
  endereco_entrega VARCHAR(200) DEFAULT 'retirada',
  status ENUM('em espera','em produção','pronto','enviado','entregue','cancelado') NOT NULL DEFAULT 'em espera',
  data_emissao DATETIME NOT NULL,
  data_prevista DATE NOT NULL,
  data_saida DATETIME,
  taxa_entrega DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  data_cancelamento DATETIME
) ENGINE=InnoDB;

CREATE TABLE item_pedido (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL,
  preco_praticado DECIMAL(10,2) NOT NULL,
  CONSTRAINT uq_item_pedido_produto UNIQUE (id_pedido, id_produto)
) ENGINE=InnoDB;

CREATE TABLE nota_fiscal (
  id_nota INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  data_emissao DATETIME NOT NULL,
  status_nota BOOLEAN NOT NULL,
  CONSTRAINT uq_nota_pedido UNIQUE (id_pedido)
) ENGINE=InnoDB;

CREATE TABLE produto (
  id_produto INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  linha ENUM('Super Tinta','Texturium','Rejuntei') NOT NULL,
  descricao VARCHAR(255) NOT NULL,
  preco_tabela DECIMAL(10,2) NOT NULL,
  quantidade_minima INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE estoque (
  id_estoque INT AUTO_INCREMENT PRIMARY KEY,
  localizacao VARCHAR(120) NOT NULL,
  capacidade_max INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE lote (
  id_lote INT AUTO_INCREMENT PRIMARY KEY,
  codigo_lote VARCHAR(20) NOT NULL,
  id_produto INT NOT NULL,
  id_estoque INT NOT NULL,
  data_validade DATE,
  quantidade_produto INT NOT NULL,
  data_fabricacao DATETIME,
  CONSTRAINT uq_lote_codigo UNIQUE (codigo_lote)
) ENGINE=InnoDB;

CREATE TABLE maquina (
  id_maquina INT AUTO_INCREMENT PRIMARY KEY,
  status ENUM('ativa','manutencao','inativa') NOT NULL DEFAULT 'ativa',
  tipo VARCHAR(80) NOT NULL,
  capacidade_max INT
) ENGINE=InnoDB;

CREATE TABLE formula (
  id_formula INT AUTO_INCREMENT PRIMARY KEY,
  id_produto INT NOT NULL,
  versao VARCHAR(10) NOT NULL,
  status INT NOT NULL,
  data_inicio DATE NOT NULL,
  data_fim DATE,
  CONSTRAINT uq_formula_produto_versao UNIQUE (id_produto, versao)
) ENGINE=InnoDB;

CREATE TABLE materia_prima (
  id_materia_prima INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  descricao VARCHAR(255) NOT NULL,
  unidade_medida VARCHAR(10) NOT NULL DEFAULT 'kg',
  quantidade INT NOT NULL DEFAULT 1,
  quantidade_minima INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE fornecedor (
  id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  descricao VARCHAR(255),
  cnpj VARCHAR(18) NOT NULL,
  CONSTRAINT uq_fornecedor_cnpj UNIQUE (cnpj)
) ENGINE=InnoDB;

CREATE TABLE veiculo (
  id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
  placa VARCHAR(8) NOT NULL,
  modelo VARCHAR(80) NOT NULL,
  CONSTRAINT uq_veiculo_placa UNIQUE (placa)
) ENGINE=InnoDB;

CREATE TABLE entrega (
  id_entrega INT AUTO_INCREMENT PRIMARY KEY,
  data_entrega DATETIME NOT NULL,
  codigo_rastreio VARCHAR(30) NOT NULL,
  id_pedido INT NOT NULL,
  id_veiculo INT,
  CONSTRAINT uq_entrega_rastreio UNIQUE (codigo_rastreio)
) ENGINE=InnoDB;

CREATE TABLE producao (
  id_producao INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT,
  id_produto INT NOT NULL,
  id_formula INT NOT NULL,
  id_maquina INT NOT NULL,
  quantidade INT NOT NULL,
  data_inicio DATETIME NOT NULL,
  data_fim DATETIME
) ENGINE=InnoDB;

CREATE TABLE movimento_estoque (
  id_movimento INT AUTO_INCREMENT PRIMARY KEY,
  id_estoque INT NOT NULL,
  id_lote INT NOT NULL,
  quantidade INT NOT NULL,
  motivo VARCHAR(120) NOT NULL,
  data DATETIME NOT NULL,
  tipo ENUM('entrada','saida','ajuste') NOT NULL
) ENGINE=InnoDB;

CREATE TABLE comprar_materia (
  id_comprar INT AUTO_INCREMENT PRIMARY KEY,
  id_materia INT NOT NULL,
  id_fornecedor INT NOT NULL,
  quantidade DECIMAL(12,2) NOT NULL,
  valor DECIMAL(12,2) NOT NULL,
  data_compra DATE NOT NULL,
  comprovante_link VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE formula_materia (
  id_formula_materia INT AUTO_INCREMENT PRIMARY KEY,
  id_formula INT NOT NULL,
  id_materia INT NOT NULL,
  quantidade DECIMAL(10,3) NOT NULL,
  unidade_medida VARCHAR(10) NOT NULL,
  ordem INT NOT NULL,
  CONSTRAINT uq_formula_materia UNIQUE (id_formula, id_materia),
  CONSTRAINT uq_formula_ordem UNIQUE (id_formula, ordem)
) ENGINE=InnoDB;

CREATE TABLE formula_maquina (
  id_formula_maquina INT AUTO_INCREMENT PRIMARY KEY,
  id_formula INT NOT NULL,
  id_maquina INT NOT NULL,
  CONSTRAINT uq_formula_maquina UNIQUE (id_formula, id_maquina)
) ENGINE=InnoDB;

CREATE TABLE parada_manutencao (
  id_parada INT AUTO_INCREMENT PRIMARY KEY,
  id_maquina INT NOT NULL,
  data DATETIME NOT NULL,
  data_fim DATETIME,
  descricao VARCHAR(200) NOT NULL,
  status ENUM('aberta','em andamento','concluida') NOT NULL
) ENGINE=InnoDB;

CREATE TABLE embalagem (
  id_embalagem INT AUTO_INCREMENT PRIMARY KEY,
  id_produto INT NOT NULL,
  status ENUM('ativa','descontinuada') NOT NULL,
  tipo VARCHAR(60) NOT NULL,
  altura DECIMAL(6,2) NOT NULL,
  largura DECIMAL(6,2) NOT NULL,
  profundidade DECIMAL(6,2) NOT NULL,
  unidade_medida VARCHAR(5) NOT NULL DEFAULT 'cm'
) ENGINE=InnoDB;


-- 3. CONSTRAINTS (PK, NOT NULL, UNIQUE e DEFAULT estão no CREATE TABLE)

-- 3.1 Chaves estrangeiras
ALTER TABLE pedido ADD CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente);
ALTER TABLE item_pedido ADD CONSTRAINT fk_item_pedido FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido);
ALTER TABLE item_pedido ADD CONSTRAINT fk_item_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto);
ALTER TABLE nota_fiscal ADD CONSTRAINT fk_nota_pedido FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido);
ALTER TABLE lote ADD CONSTRAINT fk_lote_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto);
ALTER TABLE lote ADD CONSTRAINT fk_lote_estoque FOREIGN KEY (id_estoque) REFERENCES estoque (id_estoque);
ALTER TABLE formula ADD CONSTRAINT fk_formula_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto);
ALTER TABLE entrega ADD CONSTRAINT fk_entrega_pedido FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido);
ALTER TABLE entrega ADD CONSTRAINT fk_entrega_veiculo FOREIGN KEY (id_veiculo) REFERENCES veiculo (id_veiculo);
ALTER TABLE producao ADD CONSTRAINT fk_producao_pedido FOREIGN KEY (id_pedido) REFERENCES pedido (id_pedido);
ALTER TABLE producao ADD CONSTRAINT fk_producao_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto);
ALTER TABLE producao ADD CONSTRAINT fk_producao_formula FOREIGN KEY (id_formula) REFERENCES formula (id_formula);
ALTER TABLE producao ADD CONSTRAINT fk_producao_maquina FOREIGN KEY (id_maquina) REFERENCES maquina (id_maquina);
ALTER TABLE movimento_estoque ADD CONSTRAINT fk_movimento_estoque FOREIGN KEY (id_estoque) REFERENCES estoque (id_estoque);
ALTER TABLE movimento_estoque ADD CONSTRAINT fk_movimento_lote FOREIGN KEY (id_lote) REFERENCES lote (id_lote);
ALTER TABLE comprar_materia ADD CONSTRAINT fk_compra_materia FOREIGN KEY (id_materia) REFERENCES materia_prima (id_materia_prima);
ALTER TABLE comprar_materia ADD CONSTRAINT fk_compra_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES fornecedor (id_fornecedor);
ALTER TABLE formula_materia ADD CONSTRAINT fk_formula_materia_formula FOREIGN KEY (id_formula) REFERENCES formula (id_formula);
ALTER TABLE formula_materia ADD CONSTRAINT fk_formula_materia_materia FOREIGN KEY (id_materia) REFERENCES materia_prima (id_materia_prima);
ALTER TABLE formula_maquina ADD CONSTRAINT fk_formula_maquina_formula FOREIGN KEY (id_formula) REFERENCES formula (id_formula);
ALTER TABLE formula_maquina ADD CONSTRAINT fk_formula_maquina_maquina FOREIGN KEY (id_maquina) REFERENCES maquina (id_maquina);
ALTER TABLE parada_manutencao ADD CONSTRAINT fk_parada_maquina FOREIGN KEY (id_maquina) REFERENCES maquina (id_maquina);
ALTER TABLE embalagem ADD CONSTRAINT fk_embalagem_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto);

-- 3.2 CHECK
ALTER TABLE cliente ADD CONSTRAINT chk_cliente_nome CHECK (CHAR_LENGTH(nome) >= 3);
ALTER TABLE cliente ADD CONSTRAINT chk_cliente_email CHECK (email LIKE '%_@_%.%');

ALTER TABLE pedido ADD CONSTRAINT chk_pedido_valor CHECK (valor_total >= 0);
ALTER TABLE pedido ADD CONSTRAINT chk_pedido_taxa CHECK (taxa_entrega >= 0);
ALTER TABLE pedido ADD CONSTRAINT chk_pedido_prevista CHECK (data_prevista >= DATE(data_emissao));
ALTER TABLE pedido ADD CONSTRAINT chk_pedido_saida CHECK (data_saida IS NULL OR data_saida >= data_emissao);
ALTER TABLE pedido ADD CONSTRAINT chk_pedido_status_saida CHECK (status NOT IN ('enviado','entregue') OR data_saida IS NOT NULL);
ALTER TABLE pedido ADD CONSTRAINT chk_pedido_cancelamento CHECK (
  (status = 'cancelado' AND data_cancelamento IS NOT NULL AND data_cancelamento >= data_emissao)
  OR (status <> 'cancelado' AND data_cancelamento IS NULL));
ALTER TABLE pedido ADD CONSTRAINT chk_pedido_retirada CHECK (endereco_entrega IS NULL OR endereco_entrega <> 'retirada' OR taxa_entrega = 0);

ALTER TABLE item_pedido ADD CONSTRAINT chk_item_quantidade CHECK (quantidade > 0);
ALTER TABLE item_pedido ADD CONSTRAINT chk_item_preco CHECK (preco_praticado >= 0);

ALTER TABLE produto ADD CONSTRAINT chk_produto_preco CHECK (preco_tabela > 0);
ALTER TABLE produto ADD CONSTRAINT chk_produto_minimo CHECK (quantidade_minima >= 0);

ALTER TABLE estoque ADD CONSTRAINT chk_estoque_capacidade CHECK (capacidade_max > 0);
ALTER TABLE lote ADD CONSTRAINT chk_lote_quantidade CHECK (quantidade_produto >= 0);
ALTER TABLE lote ADD CONSTRAINT chk_lote_validade CHECK (data_validade IS NULL OR data_fabricacao IS NULL OR data_validade >= DATE(data_fabricacao));

ALTER TABLE maquina ADD CONSTRAINT chk_maquina_capacidade CHECK (capacidade_max IS NULL OR capacidade_max > 0);

ALTER TABLE formula ADD CONSTRAINT chk_formula_status CHECK (status IN (0, 1));
ALTER TABLE formula ADD CONSTRAINT chk_formula_datas CHECK (data_fim IS NULL OR data_fim >= data_inicio);
ALTER TABLE formula ADD CONSTRAINT chk_formula_vigente CHECK (status = 0 OR data_fim IS NULL);

ALTER TABLE materia_prima ADD CONSTRAINT chk_materia_quantidade CHECK (quantidade >= 0 AND quantidade_minima >= 0);
ALTER TABLE fornecedor ADD CONSTRAINT chk_fornecedor_cnpj CHECK (CHAR_LENGTH(cnpj) = 18);
ALTER TABLE veiculo ADD CONSTRAINT chk_veiculo_placa CHECK (CHAR_LENGTH(placa) = 7);

ALTER TABLE producao ADD CONSTRAINT chk_producao_quantidade CHECK (quantidade > 0);
ALTER TABLE producao ADD CONSTRAINT chk_producao_datas CHECK (data_fim IS NULL OR data_fim >= data_inicio);
ALTER TABLE movimento_estoque ADD CONSTRAINT chk_movimento_quantidade CHECK (quantidade > 0);
ALTER TABLE comprar_materia ADD CONSTRAINT chk_compra_valores CHECK (quantidade > 0 AND valor > 0);
ALTER TABLE formula_materia ADD CONSTRAINT chk_formula_materia_qtd CHECK (quantidade > 0 AND ordem > 0);

ALTER TABLE parada_manutencao ADD CONSTRAINT chk_parada_datas CHECK (data_fim IS NULL OR data_fim >= data);
ALTER TABLE parada_manutencao ADD CONSTRAINT chk_parada_concluida CHECK (status <> 'concluida' OR data_fim IS NOT NULL);

ALTER TABLE embalagem ADD CONSTRAINT chk_embalagem_dimensoes CHECK (altura > 0 AND largura > 0 AND profundidade > 0);


-- =====================================================================
-- 4. INSERT INTO — massa de dados (fictícia e coerente com a JV Indústria)
-- =====================================================================
-- Observação: a ordem respeita as chaves estrangeiras (tabelas-pai primeiro).

-- 4.1 Clientes
INSERT INTO cliente (id_cliente, nome, documento, canal, endereco, telefone, email) VALUES
  (1, 'Depósito Paraíba Materiais', '41.007.919/0001-94', 'revenda', 'Av. Brasil, 137 - Jardim Esperança, São José dos Campos/SP', '(12) 5555-1001', 'contato@deposito-paraiba-materiais.exemplo.com.br'),
  (2, 'Casa & Obra São José', '41.015.838/0001-36', 'revenda', 'Rua Sete de Setembro, 174 - Vila Industrial, Taubaté/SP', '(12) 5555-1002', 'contato@casa-obra-sao-jose.exemplo.com.br'),
  (3, 'Tintas do Vale Comércio', '41.023.757/0001-88', 'revenda', 'Av. Independência, 211 - Jardim América, Caçapava/SP', '(12) 5555-1003', 'contato@tintas-do-vale-comercio.exemplo.com.br'),
  (4, 'Constru Jacareí Materiais', '41.031.676/0001-20', 'revenda', 'Rua XV de Novembro, 248 - Cidade Nova, Pindamonhangaba/SP', '(12) 5555-1004', 'contato@constru-jacarei-materiais.exemplo.com.br'),
  (5, 'Mega Cor Tintas', '41.039.595/0001-76', 'revenda', 'Av. Cassiano Ricardo, 285 - Vila Garcia, Guaratinguetá/SP', '(12) 5555-1005', 'contato@mega-cor-tintas.exemplo.com.br'),
  (6, 'Ponto da Tinta Taubaté', '41.047.514/0001-80', 'revenda', 'Rua Barão do Rio Branco, 322 - Jardim das Indústrias, Lorena/SP', '(12) 5555-1006', 'contato@ponto-da-tinta-taubate.exemplo.com.br'),
  (7, 'Materiais Serra Azul', '41.055.433/0001-21', 'revenda', 'Av. Anchieta, 359 - Bela Vista, Santa Branca/SP', '(12) 5555-1007', 'contato@materiais-serra-azul.exemplo.com.br'),
  (8, 'Loja do Pedreiro Caçapava', '41.063.352/0001-73', 'revenda', 'Rua Dom Pedro I, 396 - Parque Industrial, Jambeiro/SP', '(12) 5555-1008', 'contato@loja-do-pedreiro-cacapava.exemplo.com.br'),
  (9, 'Rede Reforma Fácil', '41.071.271/0001-15', 'revenda', 'Rua das Acácias, 433 - Centro, Jacareí/SP', '(12) 5555-1009', 'contato@rede-reforma-facil.exemplo.com.br'),
  (10, 'Casa Nova Acabamentos', '41.079.190/0001-61', 'revenda', 'Av. Getúlio Vargas, 470 - Jardim Esperança, São José dos Campos/SP', '(12) 5555-1010', 'contato@casa-nova-acabamentos.exemplo.com.br'),
  (11, 'Cor Viva Distribuidora', '41.087.109/0001-95', 'revenda', 'Rua Quinze de Agosto, 507 - Vila Industrial, Taubaté/SP', '(12) 5555-1011', 'contato@cor-viva-distribuidora.exemplo.com.br'),
  (12, 'Pinta Mais Tintas', '41.095.028/0001-37', 'revenda', 'Rua das Palmeiras, 544 - Jardim América, Caçapava/SP', '(12) 5555-1012', 'contato@pinta-mais-tintas.exemplo.com.br'),
  (13, 'Vale Tintas e Revestimentos', '41.102.947/0001-90', 'revenda', 'Av. Brasil, 581 - Cidade Nova, Pindamonhangaba/SP', '(12) 5555-1013', 'contato@vale-tintas-e-revestimentos.exemplo.com.br'),
  (14, 'Depósito Santa Maria Construção', '41.110.866/0001-32', 'revenda', 'Rua Sete de Setembro, 618 - Vila Garcia, Guaratinguetá/SP', '(12) 5555-1014', 'contato@deposito-santa-maria-construcao.exemplo.com.br'),
  (15, 'Tintas Express Guará', '41.118.785/0001-89', 'revenda', 'Av. Independência, 655 - Jardim das Indústrias, Lorena/SP', '(12) 5555-1015', 'contato@tintas-express-guara.exemplo.com.br'),
  (16, 'Casa do Acabamento Vale', '41.126.704/0001-92', 'revenda', 'Rua XV de Novembro, 692 - Bela Vista, Santa Branca/SP', '(12) 5555-1016', 'contato@casa-do-acabamento-vale.exemplo.com.br'),
  (17, 'Depósito Bela Vista', '41.134.623/0001-34', 'revenda', 'Av. Cassiano Ricardo, 729 - Parque Industrial, Jambeiro/SP', '(12) 5555-1017', 'contato@deposito-bela-vista.exemplo.com.br'),
  (18, 'Construtora Horizonte Vale', '41.142.542/0001-86', 'construtora', 'Rua Barão do Rio Branco, 766 - Centro, Jacareí/SP', '(12) 5555-1018', 'contato@construtora-horizonte-vale.exemplo.com.br'),
  (19, 'Engenharia Planalto', '41.150.461/0001-28', 'construtora', 'Av. Anchieta, 803 - Jardim Esperança, São José dos Campos/SP', '(12) 5555-1019', 'contato@engenharia-planalto.exemplo.com.br'),
  (20, 'JB Empreendimentos Imobiliários', '41.158.380/0001-74', 'construtora', 'Rua Dom Pedro I, 840 - Vila Industrial, Taubaté/SP', '(12) 5555-1020', 'contato@jb-empreendimentos-imobiliarios.exemplo.com.br'),
  (21, 'Construtora Rio Claro', '41.166.299/0001-36', 'construtora', 'Rua das Acácias, 877 - Jardim América, Caçapava/SP', '(12) 5555-1021', 'contato@construtora-rio-claro.exemplo.com.br'),
  (22, 'Obras e Projetos Mantiqueira', '41.174.218/0001-40', 'construtora', 'Av. Getúlio Vargas, 914 - Cidade Nova, Pindamonhangaba/SP', '(12) 5555-1022', 'contato@obras-e-projetos-mantiqueira.exemplo.com.br'),
  (23, 'Construtora Alvorada', '41.182.137/0001-91', 'construtora', 'Rua Quinze de Agosto, 951 - Vila Garcia, Guaratinguetá/SP', '(12) 5555-1023', 'contato@construtora-alvorada.exemplo.com.br'),
  (24, 'Gomes & Andrade Engenharia', '41.190.056/0001-33', 'construtora', 'Rua das Palmeiras, 988 - Jardim das Indústrias, Lorena/SP', '(12) 5555-1024', 'contato@gomes-andrade-engenharia.exemplo.com.br'),
  (25, 'Residencial Vista Verde Construções', '41.197.975/0001-39', 'construtora', 'Av. Brasil, 1025 - Bela Vista, Santa Branca/SP', '(12) 5555-1025', 'contato@residencial-vista-verde-construcoes.exemplo.com.br'),
  (26, 'Construtora Paraíba do Sul', '41.205.894/0001-33', 'construtora', 'Rua Sete de Setembro, 1062 - Parque Industrial, Jambeiro/SP', '(12) 5555-1026', 'contato@construtora-paraiba-do-sul.exemplo.com.br'),
  (27, 'Studio Reformas & Acabamentos', '41.213.813/0001-47', 'construtora', 'Av. Independência, 1099 - Centro, Jacareí/SP', '(12) 5555-1027', 'contato@studio-reformas-acabamentos.exemplo.com.br'),
  (28, 'Distribuidora Andina S.A. (Chile)', 'CL-76543210-5', 'exportacao', 'Av. Providencia 1234, Santiago, Chile', '+56 2 5555-0001', 'compras@distribuidora-andina-s-a-chile.exemplo.com'),
  (29, 'Pinturas del Plata S.R.L. (Argentina)', 'AR-30-71234567-1', 'exportacao', 'Calle Defensa 567, Buenos Aires, Argentina', '+54 11 5555-0002', 'compras@pinturas-del-plata-s-r-l-argentina.exemplo.com'),
  (30, 'Importadora Guaraní S.A. (Paraguai)', 'PY-80012345-6', 'exportacao', 'Av. Mariscal López 890, Assunção, Paraguai', '+595 21 555-0003', 'compras@importadora-guarani-s-a-paraguai.exemplo.com'),
  (31, 'Cadastro duplicado - teste de exclusão', '00.000.000/0001-91', 'revenda', NULL, NULL, 'teste.duplicado@exemplo.com.br');

-- 4.2 Produtos
INSERT INTO produto (id_produto, nome, linha, descricao, preco_tabela, quantidade_minima) VALUES
  (1, 'Super Tinta Econômica 18 L', 'Super Tinta', 'Tinta acrílica de uso interno, com ótima cobertura e o melhor custo-benefício da linha.', 189.90, 120),
  (2, 'Super Tinta Standard 18 L', 'Super Tinta', 'Acrílica fosca para uso interno e externo, com antimofo e mais resistência.', 289.90, 150),
  (3, 'Super Tinta Premium 18 L', 'Super Tinta', 'Topo da linha: lavável, antimofo e com excelente acabamento, para dentro e fora.', 389.90, 150),
  (4, 'Texturium Cimento Queimado 25 kg', 'Texturium', 'Efeito cimento queimado pronto para aplicar, com ação hidrorrepelente, para dentro e fora.', 329.00, 80),
  (5, 'Texturium Fundo Selador Acrílico 18 L', 'Texturium', 'Selador 2 em 1 para textura e tinta: prepara, corrige e protege a superfície.', 219.90, 80),
  (6, 'Texturium Textura Acrílica Premium 25 kg', 'Texturium', 'Textura acrílica premium com alta hidrorrepelência, resistente a intempéries.', 279.90, 100),
  (7, 'Rejuntei Rejunte Acrílico 1 kg', 'Rejuntei', 'Rejunte acrílico flexível e impermeável, pronto para uso, para áreas secas e molhadas.', 24.90, 600),
  (8, 'Rejuntei Rejunte Acrílico 5 kg', 'Rejuntei', 'Rejunte acrílico flexível e impermeável, pronto para uso, para áreas secas e molhadas.', 99.90, 300),
  (9, 'Rejuntei Rejunte Acrílico 20 kg', 'Rejuntei', 'Rejunte acrílico flexível e impermeável, pronto para uso, para áreas secas e molhadas.', 349.90, 100),
  (10, 'Rejuntei Pinta Rejunte 500 g', 'Rejuntei', 'Restauração de rejunte: devolve a cor da junta sem quebrar nem remover o revestimento.', 29.90, 200);

-- 4.3 Embalagens
INSERT INTO embalagem (id_embalagem, id_produto, status, tipo, altura, largura, profundidade, unidade_medida) VALUES
  (1, 1, 'ativa', 'Balde plástico 18 L', 35.5, 29.0, 29.0, 'cm'),
  (2, 1, 'descontinuada', 'Lata metálica 18 L', 36.0, 28.0, 28.0, 'cm'),
  (3, 2, 'ativa', 'Balde plástico 18 L', 35.5, 29.0, 29.0, 'cm'),
  (4, 3, 'ativa', 'Balde plástico 18 L', 35.5, 29.0, 29.0, 'cm'),
  (5, 4, 'ativa', 'Balde plástico 25 kg', 36.0, 32.0, 32.0, 'cm'),
  (6, 5, 'ativa', 'Balde plástico 18 L', 35.5, 29.0, 29.0, 'cm'),
  (7, 6, 'ativa', 'Balde plástico 25 kg', 37.0, 33.0, 33.0, 'cm'),
  (8, 7, 'ativa', 'Saco plástico 1 kg', 22.0, 14.0, 6.0, 'cm'),
  (9, 7, 'ativa', 'Caixa de papelão com 12 unidades', 25.0, 30.0, 24.0, 'cm'),
  (10, 8, 'ativa', 'Balde plástico 5 kg', 19.0, 20.0, 20.0, 'cm'),
  (11, 9, 'ativa', 'Balde plástico 20 kg', 36.0, 30.0, 30.0, 'cm'),
  (12, 10, 'ativa', 'Pote plástico 500 g', 10.0, 9.0, 9.0, 'cm'),
  (13, 10, 'ativa', 'Caixa de papelão com 24 unidades', 22.0, 28.0, 20.0, 'cm');

-- 4.4 Estoques
INSERT INTO estoque (id_estoque, localizacao, capacidade_max) VALUES
  (1, 'Galpão 1 - Produto acabado (paletes)', 6000),
  (2, 'Galpão 1 - Prateleiras de estocagem', 4000),
  (3, 'Área de separação e expedição', 800);

-- 4.5 Máquinas
INSERT INTO maquina (id_maquina, status, tipo, capacidade_max) VALUES
  (1, 'ativa', 'Tanque de mistura (dispersor) 2000 L', 2000),
  (2, 'ativa', 'Tanque de mistura (dispersor) 1000 L', 1000),
  (3, 'ativa', 'Misturador de massas para texturas', 1500),
  (4, 'ativa', 'Misturador de rejuntes', 800),
  (5, 'ativa', 'Envasadora de líquidos', 600),
  (6, 'ativa', 'Envasadora de pastas e massas', 400),
  (7, 'manutencao', 'Seladora de caixas', 300),
  (8, 'inativa', 'Tanque de mistura reserva', 500);

-- 4.6 Veículos
INSERT INTO veiculo (id_veiculo, placa, modelo) VALUES
  (1, 'FRT1A23', 'Mercedes-Benz Accelo 1016'),
  (2, 'GHJ4B56', 'Volkswagen Delivery Express'),
  (3, 'KLM7C89', 'Fiat Ducato Cargo'),
  (4, 'PQR2D34', 'Volvo VM 270 (carreta)');

-- 4.7 Fornecedores
INSERT INTO fornecedor (id_fornecedor, nome, descricao, cnpj) VALUES
  (1, 'Alfa Resinas Industriais Ltda', 'Resinas acrílicas', '51.000.001/0001-77'),
  (2, 'Brasil Pigmentos e Titânio S.A.', 'Dióxido de titânio e pigmentos', '51.000.002/0001-11'),
  (3, 'Mineração Serra Branca Ltda', 'Cargas minerais (carbonato, caulim, areia)', '51.000.003/0001-66'),
  (4, 'Cimentos e Cargas do Vale Ltda', 'Cimento branco e areia de quartzo', '51.000.004/0001-00'),
  (5, 'Aditivos Químicos Paraíba Ltda', 'Dispersantes, espessantes e aditivos', '51.000.005/0001-55'),
  (6, 'Biocidas e Conservantes Sul Ltda', 'Biocidas e fungicidas', '51.000.006/0001-08'),
  (7, 'Química Sudeste Distribuidora Ltda', 'Distribuidor de químicos (fornecedor alternativo)', '51.000.007/0001-44'),
  (8, 'Pigmentos Cor Forte Ltda', 'Pigmentos especiais (sem compras no período)', '51.000.008/0001-99');

-- 4.8 Matérias-primas
INSERT INTO materia_prima (id_materia_prima, nome, descricao, unidade_medida, quantidade, quantidade_minima) VALUES
  (1, 'Água desmineralizada', 'Solvente principal das tintas e texturas à base d''água', 'L', 20000, 5000),
  (2, 'Resina acrílica estireno-acrílica', 'Ligante das tintas e texturas', 'kg', 6200, 3000),
  (3, 'Dióxido de titânio', 'Pigmento branco, responsável pela cobertura', 'kg', 2400, 1500),
  (4, 'Carbonato de cálcio', 'Carga mineral para tintas e texturas', 'kg', 18000, 8000),
  (5, 'Caulim', 'Carga mineral que melhora a cobertura e o acabamento', 'kg', 5200, 2000),
  (6, 'Dispersante', 'Aditivo que estabiliza a dispersão de pigmentos e cargas', 'kg', 380, 150),
  (7, 'Espessante celulósico', 'Aditivo que controla a viscosidade', 'kg', 120, 200),
  (8, 'Antiespumante', 'Aditivo que evita a formação de espuma na mistura', 'kg', 210, 100),
  (9, 'Biocida conservante', 'Conservante para o produto na embalagem', 'kg', 160, 80),
  (10, 'Fungicida antimofo', 'Proteção do filme seco contra mofo', 'kg', 60, 150),
  (11, 'Coalescente', 'Auxilia a formação do filme de tinta', 'kg', 310, 150),
  (12, 'Pigmento óxido de ferro', 'Pigmento para as texturas e o cimento queimado', 'kg', 420, 200),
  (13, 'Areia de quartzo fina', 'Carga granulada das texturas', 'kg', 15000, 6000),
  (14, 'Cimento branco', 'Base mineral do efeito cimento queimado', 'kg', 7000, 3000),
  (15, 'Aditivo hidrorrepelente', 'Confere repelência à água ao produto aplicado', 'kg', 240, 120),
  (16, 'Resina acrílica flexível para rejunte', 'Ligante flexível do rejunte acrílico', 'kg', 1800, 2000),
  (17, 'Pigmento para rejunte', 'Pigmento das cores de rejunte', 'kg', 330, 150),
  (18, 'Carbonato de cálcio micronizado', 'Carga fina do rejunte', 'kg', 9500, 4000);

-- 4.9 Fórmulas
INSERT INTO formula (id_formula, id_produto, versao, status, data_inicio, data_fim) VALUES
  (1, 1, 'v2.0', 1, '2025-03-01', NULL),
  (2, 2, 'v2.0', 1, '2025-03-01', NULL),
  (3, 3, 'v2.0', 1, '2025-03-01', NULL),
  (4, 4, 'v1.0', 1, '2024-06-01', NULL),
  (5, 5, 'v1.0', 1, '2024-06-01', NULL),
  (6, 6, 'v1.0', 1, '2024-06-01', NULL),
  (7, 7, 'v2.0', 1, '2025-03-01', NULL),
  (8, 8, 'v2.0', 1, '2025-03-01', NULL),
  (9, 9, 'v2.0', 1, '2025-03-01', NULL),
  (10, 10, 'v0.9', 0, '2026-06-01', '2026-10-15');

-- 4.10 Composição das fórmulas
INSERT INTO formula_materia (id_formula_materia, id_formula, id_materia, quantidade, unidade_medida, ordem) VALUES
  (1, 1, 1, 38.000, 'kg', 1),
  (2, 1, 2, 11.000, 'kg', 2),
  (3, 1, 3, 6.000, 'kg', 3),
  (4, 1, 4, 33.000, 'kg', 4),
  (5, 1, 5, 10.000, 'kg', 5),
  (6, 1, 6, 0.800, 'kg', 6),
  (7, 1, 7, 0.600, 'kg', 7),
  (8, 1, 8, 0.300, 'kg', 8),
  (9, 1, 9, 0.300, 'kg', 9),
  (10, 2, 1, 34.000, 'kg', 1),
  (11, 2, 2, 15.000, 'kg', 2),
  (12, 2, 3, 9.000, 'kg', 3),
  (13, 2, 4, 31.000, 'kg', 4),
  (14, 2, 5, 8.000, 'kg', 5),
  (15, 2, 6, 0.900, 'kg', 6),
  (16, 2, 7, 0.600, 'kg', 7),
  (17, 2, 8, 0.300, 'kg', 8),
  (18, 2, 9, 0.300, 'kg', 9),
  (19, 2, 10, 0.400, 'kg', 10),
  (20, 2, 11, 0.500, 'kg', 11),
  (21, 3, 1, 30.000, 'kg', 1),
  (22, 3, 2, 20.000, 'kg', 2),
  (23, 3, 3, 12.000, 'kg', 3),
  (24, 3, 4, 28.400, 'kg', 4),
  (25, 3, 5, 6.000, 'kg', 5),
  (26, 3, 6, 1.000, 'kg', 6),
  (27, 3, 7, 0.700, 'kg', 7),
  (28, 3, 8, 0.300, 'kg', 8),
  (29, 3, 9, 0.300, 'kg', 9),
  (30, 3, 10, 0.500, 'kg', 10),
  (31, 3, 11, 0.800, 'kg', 11),
  (32, 4, 1, 8.000, 'kg', 1),
  (33, 4, 2, 14.000, 'kg', 2),
  (34, 4, 14, 25.000, 'kg', 3),
  (35, 4, 13, 20.000, 'kg', 4),
  (36, 4, 18, 29.400, 'kg', 5),
  (37, 4, 15, 1.500, 'kg', 6),
  (38, 4, 12, 0.500, 'kg', 7),
  (39, 4, 7, 0.300, 'kg', 8),
  (40, 4, 8, 0.300, 'kg', 9),
  (41, 4, 9, 0.300, 'kg', 10),
  (42, 4, 6, 0.700, 'kg', 11),
  (43, 5, 1, 50.000, 'kg', 1),
  (44, 5, 2, 22.000, 'kg', 2),
  (45, 5, 4, 24.600, 'kg', 3),
  (46, 5, 6, 0.800, 'kg', 4),
  (47, 5, 7, 0.500, 'kg', 5),
  (48, 5, 8, 0.300, 'kg', 6),
  (49, 5, 9, 0.300, 'kg', 7),
  (50, 5, 11, 1.000, 'kg', 8),
  (51, 5, 10, 0.500, 'kg', 9),
  (52, 6, 1, 12.000, 'kg', 1),
  (53, 6, 2, 22.000, 'kg', 2),
  (54, 6, 3, 5.000, 'kg', 3),
  (55, 6, 4, 20.000, 'kg', 4),
  (56, 6, 13, 37.000, 'kg', 5),
  (57, 6, 15, 1.200, 'kg', 6),
  (58, 6, 6, 0.800, 'kg', 7),
  (59, 6, 7, 0.500, 'kg', 8),
  (60, 6, 8, 0.300, 'kg', 9),
  (61, 6, 9, 0.300, 'kg', 10),
  (62, 6, 11, 0.900, 'kg', 11),
  (63, 7, 16, 28.000, 'kg', 1),
  (64, 7, 18, 57.200, 'kg', 2),
  (65, 7, 17, 4.000, 'kg', 3),
  (66, 7, 1, 8.000, 'kg', 4),
  (67, 7, 7, 0.600, 'kg', 5),
  (68, 7, 9, 0.300, 'kg', 6),
  (69, 7, 15, 1.000, 'kg', 7),
  (70, 7, 8, 0.300, 'kg', 8),
  (71, 7, 6, 0.600, 'kg', 9),
  (72, 8, 16, 28.000, 'kg', 1),
  (73, 8, 18, 57.200, 'kg', 2),
  (74, 8, 17, 4.000, 'kg', 3),
  (75, 8, 1, 8.000, 'kg', 4),
  (76, 8, 7, 0.600, 'kg', 5),
  (77, 8, 9, 0.300, 'kg', 6),
  (78, 8, 15, 1.000, 'kg', 7),
  (79, 8, 8, 0.300, 'kg', 8),
  (80, 8, 6, 0.600, 'kg', 9),
  (81, 9, 16, 28.000, 'kg', 1),
  (82, 9, 18, 57.200, 'kg', 2),
  (83, 9, 17, 4.000, 'kg', 3),
  (84, 9, 1, 8.000, 'kg', 4),
  (85, 9, 7, 0.600, 'kg', 5),
  (86, 9, 9, 0.300, 'kg', 6),
  (87, 9, 15, 1.000, 'kg', 7),
  (88, 9, 8, 0.300, 'kg', 8),
  (89, 9, 6, 0.600, 'kg', 9),
  (90, 10, 1, 45.000, 'kg', 1),
  (91, 10, 16, 30.000, 'kg', 2),
  (92, 10, 17, 8.000, 'kg', 3),
  (93, 10, 3, 5.000, 'kg', 4),
  (94, 10, 4, 10.000, 'kg', 5),
  (95, 10, 7, 0.800, 'kg', 6),
  (96, 10, 9, 0.300, 'kg', 7),
  (97, 10, 8, 0.300, 'kg', 8),
  (98, 10, 6, 0.600, 'kg', 9);

-- 4.11 Máquinas homologadas por fórmula
INSERT INTO formula_maquina (id_formula_maquina, id_formula, id_maquina) VALUES
  (1, 1, 1),
  (2, 1, 2),
  (3, 2, 1),
  (4, 2, 2),
  (5, 3, 1),
  (6, 3, 2),
  (7, 4, 3),
  (8, 5, 1),
  (9, 5, 2),
  (10, 6, 3),
  (11, 7, 4),
  (12, 8, 4),
  (13, 9, 4),
  (14, 10, 4);

-- 4.12 Paradas de manutenção
INSERT INTO parada_manutencao (id_parada, id_maquina, data, data_fim, descricao, status) VALUES
  (1, 1, '2026-07-14 08:00:00', '2026-07-14 17:00:00', 'Troca de rolamento do eixo do dispersor', 'concluida'),
  (2, 2, '2026-08-04 08:00:00', '2026-08-05 12:00:00', 'Calibração das células de carga', 'concluida'),
  (3, 3, '2026-08-19 08:00:00', '2026-08-20 16:00:00', 'Troca de pás do misturador de massas', 'concluida'),
  (4, 4, '2026-09-02 07:00:00', '2026-09-02 15:00:00', 'Limpeza e lubrificação preventiva', 'concluida'),
  (5, 5, '2026-09-09 09:00:00', '2026-09-09 14:00:00', 'Substituição dos bicos de envase', 'concluida'),
  (6, 2, '2026-09-14 08:00:00', '2026-09-16 17:00:00', 'Reparo no motor do tanque de mistura', 'concluida'),
  (7, 6, '2026-10-01 08:00:00', '2026-10-01 13:00:00', 'Ajuste do dosador de pastas', 'concluida'),
  (8, 3, '2026-10-09 13:00:00', '2026-10-09 17:00:00', 'Inspeção elétrica do painel', 'concluida'),
  (9, 1, '2026-10-21 08:00:00', '2026-10-21 17:00:00', 'Manutenção preventiva trimestral', 'concluida'),
  (10, 7, '2026-11-03 08:30:00', NULL, 'Falha no sistema de aquecimento da seladora', 'em andamento'),
  (11, 5, '2026-11-07 10:00:00', NULL, 'Vazamento na vedação do cabeçote de envase', 'aberta');

-- 4.13 Compras de matéria-prima
INSERT INTO comprar_materia (id_comprar, id_materia, id_fornecedor, quantidade, valor, data_compra, comprovante_link) VALUES
  (1, 7, 7, 100.00, 3010.00, '2026-06-15', 'https://exemplo.com.br/comprovantes/COMP-2026-0001.pdf'),
  (2, 8, 7, 200.00, 4127.20, '2026-06-20', 'https://exemplo.com.br/comprovantes/COMP-2026-0002.pdf'),
  (3, 13, 4, 12000.00, 4061.40, '2026-06-20', 'https://exemplo.com.br/comprovantes/COMP-2026-0003.pdf'),
  (4, 10, 6, 200.00, 9926.40, '2026-06-22', 'https://exemplo.com.br/comprovantes/COMP-2026-0004.pdf'),
  (5, 2, 1, 2000.00, 17518.00, '2026-07-07', 'https://exemplo.com.br/comprovantes/COMP-2026-0005.pdf'),
  (6, 17, 2, 500.00, 8469.00, '2026-07-10', 'https://exemplo.com.br/comprovantes/COMP-2026-0006.pdf'),
  (7, 16, 1, 2000.00, 24804.00, '2026-07-11', 'https://exemplo.com.br/comprovantes/COMP-2026-0007.pdf'),
  (8, 12, 2, 200.00, 2947.20, '2026-07-13', 'https://exemplo.com.br/comprovantes/COMP-2026-0008.pdf'),
  (9, 14, 4, 8000.00, 17690.40, '2026-07-16', 'https://exemplo.com.br/comprovantes/COMP-2026-0009.pdf'),
  (10, 13, 4, 12000.00, 4284.00, '2026-07-23', 'https://exemplo.com.br/comprovantes/COMP-2026-0010.pdf'),
  (11, 3, 2, 200.00, 2825.20, '2026-07-28', 'https://exemplo.com.br/comprovantes/COMP-2026-0011.pdf'),
  (12, 11, 7, 200.00, 4068.00, '2026-08-16', 'https://exemplo.com.br/comprovantes/COMP-2026-0012.pdf'),
  (13, 9, 6, 300.00, 10909.50, '2026-08-31', 'https://exemplo.com.br/comprovantes/COMP-2026-0013.pdf'),
  (14, 18, 3, 12000.00, 8080.80, '2026-08-31', 'https://exemplo.com.br/comprovantes/COMP-2026-0014.pdf'),
  (15, 6, 5, 500.00, 6048.00, '2026-09-05', 'https://exemplo.com.br/comprovantes/COMP-2026-0015.pdf'),
  (16, 2, 1, 3000.00, 29298.00, '2026-09-21', 'https://exemplo.com.br/comprovantes/COMP-2026-0016.pdf'),
  (17, 4, 3, 12000.00, 5535.00, '2026-09-25', 'https://exemplo.com.br/comprovantes/COMP-2026-0017.pdf'),
  (18, 17, 2, 300.00, 5113.80, '2026-09-26', 'https://exemplo.com.br/comprovantes/COMP-2026-0018.pdf'),
  (19, 15, 5, 300.00, 8252.40, '2026-09-28', 'https://exemplo.com.br/comprovantes/COMP-2026-0019.pdf'),
  (20, 8, 7, 300.00, 6157.80, '2026-09-30', 'https://exemplo.com.br/comprovantes/COMP-2026-0020.pdf'),
  (21, 14, 4, 10000.00, 22533.00, '2026-10-06', 'https://exemplo.com.br/comprovantes/COMP-2026-0021.pdf'),
  (22, 15, 5, 300.00, 7729.80, '2026-10-06', 'https://exemplo.com.br/comprovantes/COMP-2026-0022.pdf'),
  (23, 4, 3, 8000.00, 3510.00, '2026-10-12', 'https://exemplo.com.br/comprovantes/COMP-2026-0023.pdf'),
  (24, 5, 3, 10000.00, 9531.00, '2026-10-25', 'https://exemplo.com.br/comprovantes/COMP-2026-0024.pdf'),
  (25, 12, 2, 200.00, 3152.00, '2026-10-28', 'https://exemplo.com.br/comprovantes/COMP-2026-0025.pdf'),
  (26, 18, 3, 8000.00, 5706.40, '2026-10-30', 'https://exemplo.com.br/comprovantes/COMP-2026-0026.pdf');

-- 4.14 Lotes de produto acabado
INSERT INTO lote (id_lote, codigo_lote, id_produto, id_estoque, data_validade, quantidade_produto, data_fabricacao) VALUES
  (1, 'L2026-001', 1, 1, '2028-08-12', 260, '2026-08-12 16:00:00'),
  (2, 'L2026-002', 1, 1, '2028-10-05', 300, '2026-10-05 16:00:00'),
  (3, 'L2026-003', 2, 1, '2028-09-02', 220, '2026-09-02 16:00:00'),
  (4, 'L2026-004', 2, 2, '2028-10-20', 180, '2026-10-20 16:00:00'),
  (5, 'L2026-005', 3, 2, '2028-08-25', 70, '2026-08-25 16:00:00'),
  (6, 'L2026-006', 3, 3, '2028-10-28', 25, '2026-10-28 16:00:00'),
  (7, 'L2026-007', 4, 2, '2027-09-15', 130, '2026-09-15 16:00:00'),
  (8, 'L2026-008', 4, 2, '2027-10-30', 90, '2026-10-30 16:00:00'),
  (9, 'L2026-009', 5, 1, '2028-09-18', 140, '2026-09-18 16:00:00'),
  (10, 'L2024-010', 5, 2, '2026-10-02', 25, '2024-10-02 16:00:00'),
  (11, 'L2026-011', 6, 1, '2027-10-08', 160, '2026-10-08 16:00:00'),
  (12, 'L2026-012', 7, 2, '2027-09-10', 900, '2026-09-10 16:00:00'),
  (13, 'L2025-013', 7, 2, '2026-03-10', 40, '2025-03-10 16:00:00'),
  (14, 'L2026-014', 8, 2, '2027-10-12', 420, '2026-10-12 16:00:00'),
  (15, 'L2026-015', 9, 1, '2027-09-22', 60, '2026-09-22 16:00:00'),
  (16, 'L2026-016', 10, 3, '2027-09-28', 140, '2026-09-28 16:00:00');

-- 4.15 Movimentações de estoque
INSERT INTO movimento_estoque (id_movimento, id_estoque, id_lote, quantidade, motivo, data, tipo) VALUES
  (1, 1, 1, 520, 'Entrada de produção - lote L2026-001', '2026-08-12 17:00:00', 'entrada'),
  (2, 1, 1, 260, 'Expedição de pedidos - lote L2026-001', '2026-09-03 11:00:00', 'saida'),
  (3, 1, 2, 360, 'Entrada de produção - lote L2026-002', '2026-10-05 17:00:00', 'entrada'),
  (4, 1, 2, 60, 'Expedição de pedidos - lote L2026-002', '2026-10-14 11:00:00', 'saida'),
  (5, 1, 3, 420, 'Entrada de produção - lote L2026-003', '2026-09-02 17:00:00', 'entrada'),
  (6, 1, 3, 194, 'Expedição de pedidos - lote L2026-003', '2026-09-27 11:00:00', 'saida'),
  (7, 1, 3, 6, 'Ajuste de inventário: avaria no manuseio', '2026-09-29 15:30:00', 'ajuste'),
  (8, 2, 4, 200, 'Entrada de produção - lote L2026-004', '2026-10-20 17:00:00', 'entrada'),
  (9, 2, 4, 20, 'Expedição de pedidos - lote L2026-004', '2026-11-07 11:00:00', 'saida'),
  (10, 2, 5, 330, 'Entrada de produção - lote L2026-005', '2026-08-25 17:00:00', 'entrada'),
  (11, 2, 5, 260, 'Expedição de pedidos - lote L2026-005', '2026-09-07 11:00:00', 'saida'),
  (12, 3, 6, 40, 'Entrada de produção - lote L2026-006', '2026-10-28 17:00:00', 'entrada'),
  (13, 3, 6, 15, 'Expedição de pedidos - lote L2026-006', '2026-11-07 11:00:00', 'saida'),
  (14, 2, 7, 180, 'Entrada de produção - lote L2026-007', '2026-09-15 17:00:00', 'entrada'),
  (15, 2, 7, 50, 'Expedição de pedidos - lote L2026-007', '2026-10-01 11:00:00', 'saida'),
  (16, 2, 8, 100, 'Entrada de produção - lote L2026-008', '2026-10-30 17:00:00', 'entrada'),
  (17, 2, 8, 10, 'Expedição de pedidos - lote L2026-008', '2026-11-07 11:00:00', 'saida'),
  (18, 1, 9, 200, 'Entrada de produção - lote L2026-009', '2026-09-18 17:00:00', 'entrada'),
  (19, 1, 9, 60, 'Expedição de pedidos - lote L2026-009', '2026-09-23 11:00:00', 'saida'),
  (20, 2, 10, 85, 'Entrada de produção - lote L2024-010', '2024-10-02 17:00:00', 'entrada'),
  (21, 2, 10, 60, 'Expedição de pedidos - lote L2024-010', '2024-10-22 11:00:00', 'saida'),
  (22, 1, 11, 210, 'Entrada de produção - lote L2026-011', '2026-10-08 17:00:00', 'entrada'),
  (23, 1, 11, 50, 'Expedição de pedidos - lote L2026-011', '2026-10-29 11:00:00', 'saida'),
  (24, 2, 12, 1500, 'Entrada de produção - lote L2026-012', '2026-09-10 17:00:00', 'entrada'),
  (25, 2, 12, 588, 'Expedição de pedidos - lote L2026-012', '2026-09-29 11:00:00', 'saida'),
  (26, 2, 12, 12, 'Ajuste de inventário: avaria no manuseio', '2026-10-01 15:30:00', 'ajuste'),
  (27, 2, 13, 340, 'Entrada de produção - lote L2025-013', '2025-03-10 17:00:00', 'entrada'),
  (28, 2, 13, 300, 'Expedição de pedidos - lote L2025-013', '2025-03-23 11:00:00', 'saida'),
  (29, 2, 14, 700, 'Entrada de produção - lote L2026-014', '2026-10-12 17:00:00', 'entrada'),
  (30, 2, 14, 280, 'Expedição de pedidos - lote L2026-014', '2026-10-28 11:00:00', 'saida'),
  (31, 1, 15, 140, 'Entrada de produção - lote L2026-015', '2026-09-22 17:00:00', 'entrada'),
  (32, 1, 15, 80, 'Expedição de pedidos - lote L2026-015', '2026-10-12 11:00:00', 'saida'),
  (33, 3, 16, 260, 'Entrada de produção - lote L2026-016', '2026-09-28 17:00:00', 'entrada'),
  (34, 3, 16, 120, 'Expedição de pedidos - lote L2026-016', '2026-10-07 11:00:00', 'saida');

-- 4.16 Pedidos
INSERT INTO pedido (id_pedido, id_cliente, valor_total, tipo_pagamento, endereco_entrega, status, data_emissao, data_prevista, data_saida, taxa_entrega, data_cancelamento) VALUES
  (1, 21, 3548.06, 'faturado_28_dias', 'Canteiro de obras - Rua das Acácias, 832, Caçapava/SP', 'entregue', '2026-07-20 15:55:00', '2026-07-29', '2026-07-25 15:55:00', 111.00, NULL),
  (2, 4, 25741.30, 'faturado_28_dias', 'retirada', 'entregue', '2026-07-29 10:00:00', '2026-08-07', '2026-07-31 11:00:00', 0.00, NULL),
  (3, 5, 36502.82, 'pix', 'retirada', 'entregue', '2026-08-07 12:00:00', '2026-08-16', '2026-08-10 12:00:00', 0.00, NULL),
  (4, 29, 99830.48, 'transferencia', 'Calle Defensa 567, Buenos Aires, Argentina', 'entregue', '2026-08-10 15:00:00', '2026-09-07', '2026-08-17 14:00:00', 2569.00, NULL),
  (5, 11, 18363.74, 'boleto', 'Rua Quinze de Agosto, 507 - Vila Industrial, Taubaté/SP', 'cancelado', '2026-08-26 16:25:00', '2026-09-04', NULL, 0.00, '2026-08-28 18:25:00'),
  (6, 20, 2483.27, 'transferencia', 'Canteiro de obras - Rua XV de Novembro, 495, Taubaté/SP', 'entregue', '2026-08-27 10:40:00', '2026-09-05', '2026-08-30 12:40:00', 134.00, NULL),
  (7, 24, 10878.59, 'boleto', 'Canteiro de obras - Av. Independência, 25, Lorena/SP', 'entregue', '2026-08-31 11:00:00', '2026-09-09', '2026-09-04 13:00:00', 0.00, NULL),
  (8, 17, 26211.60, 'boleto', 'Av. Cassiano Ricardo, 729 - Parque Industrial, Jambeiro/SP', 'entregue', '2026-09-01 15:55:00', '2026-09-10', '2026-09-05 17:55:00', 0.00, NULL),
  (9, 19, 8080.02, 'faturado_28_dias', 'Canteiro de obras - Rua Quinze de Agosto, 841, São José dos Campos/SP', 'cancelado', '2026-09-03 15:40:00', '2026-09-12', NULL, 0.00, '2026-09-06 17:40:00'),
  (10, 11, 22016.16, 'boleto', 'Rua Quinze de Agosto, 507 - Vila Industrial, Taubaté/SP', 'entregue', '2026-09-09 16:40:00', '2026-09-18', '2026-09-13 17:40:00', 0.00, NULL),
  (11, 28, 233101.00, 'transferencia', 'Av. Providencia 1234, Santiago, Chile', 'entregue', '2026-09-10 08:25:00', '2026-10-08', '2026-09-19 09:25:00', 3015.00, NULL),
  (12, 22, 7546.49, 'faturado_28_dias', 'Canteiro de obras - Rua das Palmeiras, 575, Pindamonhangaba/SP', 'entregue', '2026-09-10 14:25:00', '2026-09-19', '2026-09-14 13:25:00', 0.00, NULL),
  (13, 4, 25396.38, 'boleto', 'Rua XV de Novembro, 248 - Cidade Nova, Pindamonhangaba/SP', 'entregue', '2026-09-11 15:55:00', '2026-09-20', '2026-09-13 15:55:00', 0.00, NULL),
  (14, 11, 33052.78, 'faturado_28_dias', 'Rua Quinze de Agosto, 507 - Vila Industrial, Taubaté/SP', 'entregue', '2026-09-28 15:40:00', '2026-10-07', '2026-10-03 16:40:00', 0.00, NULL),
  (15, 14, 43000.43, 'faturado_28_dias', 'Rua Sete de Setembro, 618 - Vila Garcia, Guaratinguetá/SP', 'entregue', '2026-09-29 16:00:00', '2026-10-08', '2026-10-03 15:00:00', 0.00, NULL),
  (16, 13, 22229.71, 'cartao_credito', 'Av. Brasil, 581 - Cidade Nova, Pindamonhangaba/SP', 'entregue', '2026-09-30 14:40:00', '2026-10-09', '2026-10-04 14:40:00', 0.00, NULL),
  (17, 5, 28438.53, 'cartao_credito', 'Av. Cassiano Ricardo, 285 - Vila Garcia, Guaratinguetá/SP', 'cancelado', '2026-09-30 16:25:00', '2026-10-09', NULL, 0.00, '2026-10-03 18:25:00'),
  (18, 21, 2179.01, 'transferencia', 'Canteiro de obras - Rua das Palmeiras, 887, Caçapava/SP', 'entregue', '2026-10-07 15:40:00', '2026-10-16', '2026-10-10 16:40:00', 251.00, NULL),
  (19, 24, 11623.71, 'boleto', 'Canteiro de obras - Rua Quinze de Agosto, 678, Lorena/SP', 'entregue', '2026-10-12 08:55:00', '2026-10-21', '2026-10-16 08:55:00', 0.00, NULL),
  (20, 14, 7617.06, 'cartao_credito', 'Rua Sete de Setembro, 618 - Vila Garcia, Guaratinguetá/SP', 'cancelado', '2026-10-12 14:40:00', '2026-10-21', NULL, 0.00, '2026-10-13 16:40:00'),
  (21, 5, 35539.58, 'pix', 'Av. Cassiano Ricardo, 285 - Vila Garcia, Guaratinguetá/SP', 'entregue', '2026-10-16 15:00:00', '2026-10-25', '2026-10-20 17:00:00', 0.00, NULL),
  (22, 23, 10983.87, 'faturado_28_dias', 'Canteiro de obras - Rua das Acácias, 692, Guaratinguetá/SP', 'entregue', '2026-10-20 09:40:00', '2026-10-29', '2026-10-25 11:40:00', 0.00, NULL),
  (23, 29, 221848.04, 'transferencia', 'Calle Defensa 567, Buenos Aires, Argentina', 'enviado', '2026-10-26 11:25:00', '2026-11-23', '2026-11-02 12:25:00', 3318.00, NULL),
  (24, 9, 14875.37, 'boleto', 'Rua das Acácias, 433 - Centro, Jacareí/SP', 'entregue', '2026-10-26 16:25:00', '2026-11-04', '2026-10-31 17:25:00', 0.00, NULL),
  (25, 6, 21975.68, 'boleto', 'Rua Barão do Rio Branco, 322 - Jardim das Indústrias, Lorena/SP', 'entregue', '2026-10-27 15:25:00', '2026-11-05', '2026-11-01 17:25:00', 0.00, NULL),
  (26, 9, 29924.06, 'boleto', 'Rua das Acácias, 433 - Centro, Jacareí/SP', 'entregue', '2026-10-30 13:25:00', '2026-11-08', '2026-11-01 13:25:00', 0.00, NULL),
  (27, 5, 29041.40, 'faturado_28_dias', 'Av. Cassiano Ricardo, 285 - Vila Garcia, Guaratinguetá/SP', 'entregue', '2026-11-02 10:55:00', '2026-11-11', '2026-11-04 10:55:00', 0.00, NULL),
  (28, 4, 12496.19, 'faturado_28_dias', 'Rua XV de Novembro, 248 - Cidade Nova, Pindamonhangaba/SP', 'enviado', '2026-11-02 14:00:00', '2026-11-11', '2026-11-07 15:00:00', 0.00, NULL),
  (29, 26, 10046.82, 'faturado_28_dias', 'Canteiro de obras - Rua Sete de Setembro, 797, Jambeiro/SP', 'enviado', '2026-11-02 16:40:00', '2026-11-11', '2026-11-06 18:40:00', 0.00, NULL),
  (30, 26, 13450.83, 'faturado_28_dias', 'Canteiro de obras - Av. Independência, 830, Jambeiro/SP', 'pronto', '2026-11-03 16:25:00', '2026-11-12', NULL, 0.00, NULL),
  (31, 13, 22172.01, 'boleto', 'Av. Brasil, 581 - Cidade Nova, Pindamonhangaba/SP', 'em espera', '2026-11-06 13:00:00', '2026-11-15', NULL, 0.00, NULL),
  (32, 5, 25982.37, 'faturado_28_dias', 'Av. Cassiano Ricardo, 285 - Vila Garcia, Guaratinguetá/SP', 'em espera', '2026-11-06 13:40:00', '2026-11-15', NULL, 0.00, NULL),
  (33, 17, 33598.50, 'boleto', 'Av. Cassiano Ricardo, 729 - Parque Industrial, Jambeiro/SP', 'em espera', '2026-11-06 16:00:00', '2026-11-15', NULL, 0.00, NULL),
  (34, 1, 0.00, 'pix', 'retirada', 'em espera', '2026-11-06 17:20:00', '2026-11-14', NULL, 0.00, NULL);

-- 4.17 Itens dos pedidos
INSERT INTO item_pedido (id_item, id_pedido, id_produto, quantidade, preco_praticado) VALUES
  (1, 1, 9, 11, 312.46),
  (2, 2, 1, 41, 160.28),
  (3, 2, 6, 42, 237.08),
  (4, 2, 8, 106, 86.91),
  (5, 3, 3, 24, 324.01),
  (6, 3, 9, 12, 281.32),
  (7, 3, 4, 34, 280.31),
  (8, 3, 8, 33, 80.12),
  (9, 3, 1, 84, 156.86),
  (10, 4, 8, 340, 93.01),
  (11, 4, 9, 96, 325.41),
  (12, 4, 2, 128, 268.74),
  (13, 5, 3, 31, 336.48),
  (14, 5, 9, 26, 305.11),
  (15, 6, 8, 27, 87.01),
  (16, 7, 2, 36, 263.23),
  (17, 7, 5, 7, 200.33),
  (18, 8, 6, 34, 236.52),
  (19, 8, 3, 54, 336.48),
  (20, 9, 3, 9, 357.54),
  (21, 9, 1, 18, 164.45),
  (22, 9, 9, 6, 317.01),
  (23, 10, 3, 18, 324.79),
  (24, 10, 5, 28, 183.18),
  (25, 10, 9, 10, 281.67),
  (26, 10, 1, 54, 152.30),
  (27, 11, 3, 188, 359.10),
  (28, 11, 8, 464, 94.31),
  (29, 11, 2, 284, 273.38),
  (30, 11, 9, 124, 332.06),
  (31, 12, 6, 7, 245.75),
  (32, 12, 3, 17, 342.72),
  (33, 13, 10, 40, 24.76),
  (34, 13, 5, 36, 182.52),
  (35, 13, 1, 77, 161.98),
  (36, 13, 4, 20, 268.14),
  (37, 14, 9, 40, 288.67),
  (38, 14, 8, 110, 84.62),
  (39, 14, 7, 274, 20.27),
  (40, 14, 3, 20, 332.19),
  (41, 15, 1, 70, 166.35),
  (42, 15, 4, 26, 278.01),
  (43, 15, 3, 35, 322.45),
  (44, 15, 6, 24, 232.32),
  (45, 15, 9, 24, 297.76),
  (46, 16, 1, 46, 153.25),
  (47, 16, 6, 35, 236.24),
  (48, 16, 7, 127, 20.19),
  (49, 16, 8, 42, 87.91),
  (50, 16, 10, 26, 25.21),
  (51, 17, 2, 73, 239.75),
  (52, 17, 3, 34, 321.67),
  (53, 18, 8, 21, 91.81),
  (54, 19, 3, 7, 355.98),
  (55, 19, 2, 35, 260.91),
  (56, 20, 6, 18, 243.51),
  (57, 20, 8, 39, 82.92),
  (58, 21, 8, 41, 86.41),
  (59, 21, 6, 31, 229.80),
  (60, 21, 2, 52, 235.69),
  (61, 21, 1, 79, 159.71),
  (62, 22, 6, 15, 254.71),
  (63, 22, 8, 42, 88.21),
  (64, 22, 3, 10, 345.84),
  (65, 23, 2, 264, 275.12),
  (66, 23, 8, 404, 93.81),
  (67, 23, 3, 140, 356.76),
  (68, 23, 1, 328, 176.99),
  (69, 24, 7, 75, 21.76),
  (70, 24, 6, 23, 224.20),
  (71, 24, 9, 27, 299.51),
  (72, 25, 2, 26, 249.89),
  (73, 25, 5, 41, 184.94),
  (74, 25, 6, 35, 225.60),
  (75, 26, 10, 34, 25.27),
  (76, 26, 3, 63, 328.30),
  (77, 26, 5, 47, 178.34),
  (78, 27, 6, 42, 229.52),
  (79, 27, 10, 65, 25.92),
  (80, 27, 9, 11, 297.76),
  (81, 27, 3, 26, 312.70),
  (82, 27, 5, 35, 180.32),
  (83, 28, 9, 34, 304.06),
  (84, 28, 10, 85, 25.39),
  (85, 29, 2, 38, 264.39),
  (86, 30, 4, 15, 292.81),
  (87, 30, 2, 36, 251.63),
  (88, 31, 7, 215, 21.02),
  (89, 31, 9, 14, 300.21),
  (90, 31, 4, 20, 284.26),
  (91, 31, 2, 31, 250.47),
  (92, 32, 8, 118, 80.32),
  (93, 32, 3, 29, 332.97),
  (94, 32, 9, 23, 297.76),
  (95, 33, 7, 190, 19.99),
  (96, 33, 3, 18, 313.87),
  (97, 33, 6, 34, 237.08),
  (98, 33, 2, 56, 239.46),
  (99, 33, 8, 33, 81.22);

-- 4.18 Notas fiscais
INSERT INTO nota_fiscal (id_nota, id_pedido, data_emissao, status_nota) VALUES
  (1, 1, '2026-07-25 12:55:00', TRUE),
  (2, 2, '2026-07-31 08:00:00', TRUE),
  (3, 3, '2026-08-10 09:00:00', TRUE),
  (4, 4, '2026-08-17 11:00:00', TRUE),
  (5, 5, '2026-08-27 19:25:00', FALSE),
  (6, 6, '2026-08-30 09:40:00', TRUE),
  (7, 7, '2026-09-04 10:00:00', TRUE),
  (8, 8, '2026-09-05 14:55:00', TRUE),
  (9, 9, '2026-09-04 18:40:00', FALSE),
  (10, 10, '2026-09-13 14:40:00', TRUE),
  (11, 11, '2026-09-19 06:25:00', TRUE),
  (12, 12, '2026-09-14 10:25:00', TRUE),
  (13, 13, '2026-09-13 12:55:00', TRUE),
  (14, 14, '2026-10-03 13:40:00', TRUE),
  (15, 15, '2026-10-03 12:00:00', TRUE),
  (16, 16, '2026-10-04 11:40:00', TRUE),
  (17, 18, '2026-10-10 13:40:00', TRUE),
  (18, 19, '2026-10-16 05:55:00', TRUE),
  (19, 21, '2026-10-20 14:00:00', TRUE),
  (20, 22, '2026-10-25 08:40:00', TRUE),
  (21, 23, '2026-11-02 09:25:00', TRUE),
  (22, 24, '2026-10-31 14:25:00', TRUE),
  (23, 25, '2026-11-01 14:25:00', TRUE),
  (24, 26, '2026-11-01 10:25:00', TRUE),
  (25, 27, '2026-11-04 07:55:00', TRUE),
  (26, 30, '2026-11-05 18:25:00', TRUE);

-- 4.19 Entregas
INSERT INTO entrega (id_entrega, data_entrega, codigo_rastreio, id_pedido, id_veiculo) VALUES
  (1, '2026-07-28 15:55:00', 'JVX26000001', 1, NULL),
  (2, '2026-09-03 15:00:00', 'JVX26000002', 4, 4),
  (3, '2026-09-02 15:40:00', 'JVX26000003', 6, 1),
  (4, '2026-09-06 16:00:00', 'JVX26000004', 7, 1),
  (5, '2026-09-09 18:55:00', 'JVX26000005', 8, 3),
  (6, '2026-09-17 19:40:00', 'JVX26000006', 10, NULL),
  (7, '2026-10-04 09:25:00', 'JVX26000007', 11, 4),
  (8, '2026-09-18 13:25:00', 'JVX26000008', 12, 2),
  (9, '2026-09-19 16:55:00', 'JVX26000009', 13, 2),
  (10, '2026-10-05 16:40:00', 'JVX26000010', 14, NULL),
  (11, '2026-10-07 16:00:00', 'JVX26000011', 15, 2),
  (12, '2026-10-06 15:40:00', 'JVX26000012', 16, 2),
  (13, '2026-10-13 18:40:00', 'JVX26000013', 18, NULL),
  (14, '2026-10-20 09:55:00', 'JVX26000014', 19, 2),
  (15, '2026-10-29 18:00:00', 'JVX26000015', 21, 1),
  (16, '2026-11-02 12:40:00', 'JVX26000016', 22, 1),
  (17, '2026-11-13 15:25:00', 'JVX26000017', 23, NULL),
  (18, '2026-11-02 20:25:00', 'JVX26000018', 24, 3),
  (19, '2026-11-04 17:25:00', 'JVX26000019', 25, 1),
  (20, '2026-11-04 16:25:00', 'JVX26000020', 26, 1),
  (21, '2026-11-08 11:55:00', 'JVX26000021', 27, 1),
  (22, '2026-11-09 18:00:00', 'JVX26000022', 28, NULL),
  (23, '2026-11-09 20:40:00', 'JVX26000023', 29, NULL);

-- 4.20 Produção
INSERT INTO producao (id_producao, id_pedido, id_produto, id_formula, id_maquina, quantidade, data_inicio, data_fim) VALUES
  (1, NULL, 5, 5, 1, 85, '2024-10-02 08:00:00', '2024-10-02 16:00:00'),
  (2, NULL, 7, 7, 4, 340, '2025-03-10 08:00:00', '2025-03-10 16:00:00'),
  (3, 1, 9, 9, 4, 11, '2026-07-21 08:00:00', '2026-07-21 17:00:00'),
  (4, 3, 1, 1, 2, 84, '2026-08-08 07:00:00', '2026-08-08 15:00:00'),
  (5, NULL, 1, 1, 1, 520, '2026-08-12 08:00:00', '2026-08-12 16:00:00'),
  (6, NULL, 3, 3, 3, 330, '2026-08-25 08:00:00', '2026-08-25 16:00:00'),
  (7, 7, 5, 5, 2, 7, '2026-09-01 07:00:00', '2026-09-01 12:00:00'),
  (8, 7, 2, 2, 1, 36, '2026-09-01 09:00:00', '2026-09-01 16:00:00'),
  (9, NULL, 2, 2, 1, 420, '2026-09-02 08:00:00', '2026-09-02 16:00:00'),
  (10, NULL, 7, 7, 4, 1500, '2026-09-10 08:00:00', '2026-09-10 16:00:00'),
  (11, 11, 8, 8, 4, 464, '2026-09-11 07:00:00', '2026-09-11 13:00:00'),
  (12, 11, 2, 2, 1, 284, '2026-09-11 07:00:00', '2026-09-11 12:00:00'),
  (13, 11, 3, 3, 1, 188, '2026-09-11 09:00:00', '2026-09-11 15:00:00'),
  (14, 13, 4, 4, 3, 20, '2026-09-12 08:00:00', '2026-09-12 17:00:00'),
  (15, 13, 10, 10, 4, 40, '2026-09-12 10:00:00', '2026-09-12 16:00:00'),
  (16, NULL, 4, 4, 3, 180, '2026-09-15 08:00:00', '2026-09-15 16:00:00'),
  (17, NULL, 5, 5, 2, 200, '2026-09-18 08:00:00', '2026-09-18 16:00:00'),
  (18, NULL, 9, 9, 4, 140, '2026-09-22 08:00:00', '2026-09-22 16:00:00'),
  (19, NULL, 10, 10, 4, 260, '2026-09-28 08:00:00', '2026-09-28 16:00:00'),
  (20, 15, 9, 9, 4, 24, '2026-09-30 08:00:00', '2026-09-30 16:00:00'),
  (21, 16, 7, 7, 4, 127, '2026-10-01 09:00:00', '2026-10-01 16:00:00'),
  (22, NULL, 1, 1, 2, 360, '2026-10-05 08:00:00', '2026-10-05 16:00:00'),
  (23, NULL, 6, 6, 3, 210, '2026-10-08 08:00:00', '2026-10-08 16:00:00'),
  (24, NULL, 8, 8, 4, 700, '2026-10-12 08:00:00', '2026-10-12 16:00:00'),
  (25, 19, 2, 2, 2, 35, '2026-10-13 07:00:00', '2026-10-13 16:00:00'),
  (26, NULL, 2, 2, 2, 200, '2026-10-20 08:00:00', '2026-10-20 16:00:00'),
  (27, 23, 3, 3, 1, 140, '2026-10-27 07:00:00', '2026-10-27 14:00:00'),
  (28, 24, 6, 6, 3, 23, '2026-10-27 08:00:00', '2026-10-27 13:00:00'),
  (29, NULL, 3, 3, 1, 40, '2026-10-28 08:00:00', '2026-10-28 16:00:00'),
  (30, 25, 6, 6, 3, 35, '2026-10-28 10:00:00', '2026-10-28 19:00:00'),
  (31, NULL, 4, 4, 3, 100, '2026-10-30 08:00:00', '2026-10-30 16:00:00'),
  (32, 27, 3, 3, 1, 26, '2026-11-03 08:00:00', '2026-11-03 16:00:00'),
  (33, 27, 5, 5, 2, 35, '2026-11-03 08:00:00', '2026-11-03 13:00:00'),
  (34, 29, 2, 2, 1, 38, '2026-11-03 08:00:00', '2026-11-03 17:00:00'),
  (35, 28, 9, 9, 4, 34, '2026-11-03 09:00:00', '2026-11-03 18:00:00'),
  (36, 30, 2, 2, 2, 36, '2026-11-04 09:00:00', '2026-11-04 15:00:00');


-- =====================================================================
-- 5. SELECT com JOIN
-- =====================================================================

-- S01 — Itens dos 20 pedidos mais recentes, com cliente e produto
SELECT p.id_pedido, p.data_emissao, c.nome AS cliente, pr.nome AS produto,
       ip.quantidade, ip.preco_praticado,
       (ip.quantidade * ip.preco_praticado) AS subtotal
FROM pedido p
JOIN cliente c ON c.id_cliente = p.id_cliente
JOIN item_pedido ip ON ip.id_pedido = p.id_pedido
JOIN produto pr ON pr.id_produto = ip.id_produto
ORDER BY p.data_emissao DESC, p.id_pedido, pr.nome
LIMIT 20;

-- S02 — Rastreio dos pedidos expedidos: nota fiscal, entrega e veículo
SELECT p.id_pedido, p.status, p.data_saida, nf.id_nota, nf.status_nota,
       e.codigo_rastreio, e.data_entrega, v.placa
FROM pedido p
LEFT JOIN nota_fiscal nf ON nf.id_pedido = p.id_pedido
LEFT JOIN entrega e ON e.id_pedido = p.id_pedido
LEFT JOIN veiculo v ON v.id_veiculo = e.id_veiculo
WHERE p.status IN ('enviado', 'entregue')
ORDER BY p.data_saida DESC
LIMIT 15;

-- S03 — Receita de cada produto: fórmula vigente e matérias-primas, em ordem de adição
SELECT pr.nome AS produto, f.versao, fm.ordem, mp.nome AS materia_prima,
       fm.quantidade, fm.unidade_medida
FROM formula f
JOIN produto pr ON pr.id_produto = f.id_produto
JOIN formula_materia fm ON fm.id_formula = f.id_formula
JOIN materia_prima mp ON mp.id_materia_prima = fm.id_materia
WHERE f.status = 1
ORDER BY pr.id_produto, fm.ordem;

-- S04 — Lotes de produto acabado e onde estão guardados
SELECT l.codigo_lote, pr.nome AS produto, es.localizacao,
       l.quantidade_produto, l.data_fabricacao, l.data_validade
FROM lote l
JOIN produto pr ON pr.id_produto = l.id_produto
JOIN estoque es ON es.id_estoque = l.id_estoque
ORDER BY pr.id_produto, l.data_fabricacao;

-- S05 — Compras de matéria-prima com fornecedor
SELECT cm.data_compra, mp.nome AS materia_prima, fo.nome AS fornecedor,
       cm.quantidade, mp.unidade_medida, cm.valor,
       ROUND(cm.valor / cm.quantidade, 2) AS preco_unitario
FROM comprar_materia cm
JOIN materia_prima mp ON mp.id_materia_prima = cm.id_materia
JOIN fornecedor fo ON fo.id_fornecedor = cm.id_fornecedor
ORDER BY cm.data_compra DESC
LIMIT 15;

-- =====================================================================
-- 6. UPDATE e DELETE
-- =====================================================================

-- U01 — Reajuste de 5% na tabela de preços da linha Rejuntei
UPDATE produto
SET preco_tabela = ROUND(preco_tabela * 1.05, 2)
WHERE linha = 'Rejuntei';

-- U02 — Manutenção da envasadora de líquidos começou: parada em andamento e máquina em manutenção
UPDATE parada_manutencao SET status = 'em andamento' WHERE id_parada = 11;
UPDATE maquina SET status = 'manutencao' WHERE id_maquina = 5;

-- U03 — Pedido em espera entra na fila de produção
UPDATE pedido SET status = 'em produção' WHERE id_pedido = 31 AND status = 'em espera';

-- U04 — Chegada de dispersante: soma 100 kg ao saldo da matéria-prima
UPDATE materia_prima SET quantidade = quantidade + 100 WHERE id_materia_prima = 6;

-- D01 — Exclui o cadastro duplicado de cliente (só se não tiver nenhum pedido)
DELETE FROM cliente
WHERE id_cliente = 31
  AND NOT EXISTS (SELECT 1 FROM pedido WHERE pedido.id_cliente = cliente.id_cliente);

-- D02 — Remove do cadastro as embalagens descontinuadas
DELETE FROM embalagem WHERE status = 'descontinuada';

-- =====================================================================
-- 7. CONSULTAS GERENCIAIS (G) E DE AUDITORIA (A)
-- =====================================================================

-- ---------------------------------------------------------------------
-- GERENCIAIS
-- ---------------------------------------------------------------------

-- G01 — Qual o faturamento, o número de pedidos e o ticket médio por mês?
-- Atende: P6 (falta de visão de faturamento) · KPI: faturamento mensal e ticket médio
SELECT DATE_FORMAT(p.data_emissao, '%Y-%m') AS mes,
       COUNT(*) AS qtd_pedidos,
       SUM(p.valor_total) AS faturamento,
       ROUND(AVG(p.valor_total), 2) AS ticket_medio
FROM pedido p
WHERE p.status <> 'cancelado'
GROUP BY DATE_FORMAT(p.data_emissao, '%Y-%m')
ORDER BY mes;

-- G02 — Quais os 5 clientes que mais compraram?
-- Atende: P6 (falta de visão por cliente)
SELECT c.id_cliente, c.nome, c.canal,
       COUNT(p.id_pedido) AS qtd_pedidos,
       SUM(p.valor_total) AS receita
FROM cliente c
JOIN pedido p ON p.id_cliente = c.id_cliente
WHERE p.status <> 'cancelado'
GROUP BY c.id_cliente, c.nome, c.canal
ORDER BY receita DESC
LIMIT 5;

-- G03 — Quais produtos estão abaixo do estoque mínimo? (lotes vencidos não contam)
-- Atende: P1 (ruptura de estoque de produto acabado) · Regra: RN07
SELECT pr.id_produto, pr.nome, pr.quantidade_minima,
       COALESCE(SUM(l.quantidade_produto), 0) AS saldo_disponivel,
       pr.quantidade_minima - COALESCE(SUM(l.quantidade_produto), 0) AS falta
FROM produto pr
LEFT JOIN lote l ON l.id_produto = pr.id_produto
                AND (l.data_validade IS NULL OR l.data_validade >= CURDATE())
GROUP BY pr.id_produto, pr.nome, pr.quantidade_minima
HAVING COALESCE(SUM(l.quantidade_produto), 0) < pr.quantidade_minima
ORDER BY falta DESC;

-- G04 — Quais matérias-primas estão abaixo do mínimo e quem foi o último fornecedor?
-- Atende: P2 (falta de matéria-prima para produzir)
SELECT mp.id_materia_prima, mp.nome, mp.quantidade, mp.quantidade_minima, mp.unidade_medida,
       mp.quantidade_minima - mp.quantidade AS falta,
       (SELECT fo.nome
          FROM comprar_materia cm
          JOIN fornecedor fo ON fo.id_fornecedor = cm.id_fornecedor
         WHERE cm.id_materia = mp.id_materia_prima
         ORDER BY cm.data_compra DESC
         LIMIT 1) AS ultimo_fornecedor
FROM materia_prima mp
WHERE mp.quantidade < mp.quantidade_minima
ORDER BY falta DESC;

-- G05 — Quantos dias, em média, entre a emissão do pedido e a saída da fábrica, por mês?
-- Atende: P3 (atrasos) · KPI: tempo médio entre emissão e saída (por mês)
SELECT DATE_FORMAT(p.data_emissao, '%Y-%m') AS mes,
       COUNT(*) AS pedidos_expedidos,
       ROUND(AVG(TIMESTAMPDIFF(HOUR, p.data_emissao, p.data_saida)) / 24, 1) AS dias_medios_ate_saida
FROM pedido p
WHERE p.data_saida IS NOT NULL
GROUP BY DATE_FORMAT(p.data_emissao, '%Y-%m')
ORDER BY mes;

-- G06 — Qual o percentual de pedidos entregues dentro do prazo, por mês?
-- Atende: P3 (atrasos) · KPI: % de entregas no prazo = entregues até data_prevista / entregues
SELECT DATE_FORMAT(p.data_emissao, '%Y-%m') AS mes,
       COUNT(*) AS entregas,
       SUM(CASE WHEN DATE(e.data_entrega) <= p.data_prevista THEN 1 ELSE 0 END) AS no_prazo,
       ROUND(100 * SUM(CASE WHEN DATE(e.data_entrega) <= p.data_prevista THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_no_prazo
FROM pedido p
JOIN entrega e ON e.id_pedido = p.id_pedido
WHERE p.status = 'entregue'
GROUP BY DATE_FORMAT(p.data_emissao, '%Y-%m')
ORDER BY mes;

-- G07 — Qual a taxa de cancelamento de pedidos por mês?
-- Atende: P5 (cancelamentos sem acompanhamento) · KPI: % de pedidos cancelados
SELECT DATE_FORMAT(p.data_emissao, '%Y-%m') AS mes,
       COUNT(*) AS pedidos,
       SUM(CASE WHEN p.status = 'cancelado' THEN 1 ELSE 0 END) AS cancelados,
       ROUND(100 * SUM(CASE WHEN p.status = 'cancelado' THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_cancelamento
FROM pedido p
GROUP BY DATE_FORMAT(p.data_emissao, '%Y-%m')
ORDER BY mes;

-- G08 — Quanto cada linha vendeu em cada canal (revenda, construtora, exportação)?
-- Atende: P6 (falta de visão por linha e canal)
SELECT pr.linha, c.canal,
       SUM(ip.quantidade) AS unidades,
       SUM(ip.quantidade * ip.preco_praticado) AS receita_itens
FROM item_pedido ip
JOIN pedido p ON p.id_pedido = ip.id_pedido
JOIN produto pr ON pr.id_produto = ip.id_produto
JOIN cliente c ON c.id_cliente = p.id_cliente
WHERE p.status <> 'cancelado'
GROUP BY pr.linha, c.canal
ORDER BY pr.linha, receita_itens DESC;

-- G09 — Quantas paradas e quantas horas parada cada máquina teve?
-- Atende: P4 (paradas sem controle) · KPI: horas de parada por máquina
SELECT m.id_maquina, m.tipo, m.status,
       COUNT(pm.id_parada) AS qtd_paradas,
       ROUND(SUM(TIMESTAMPDIFF(MINUTE, pm.data, COALESCE(pm.data_fim, NOW()))) / 60, 1) AS horas_parada
FROM maquina m
LEFT JOIN parada_manutencao pm ON pm.id_maquina = m.id_maquina
GROUP BY m.id_maquina, m.tipo, m.status
ORDER BY horas_parada DESC;

-- G10 — Quanto cada máquina produziu de cada produto?
-- Atende: P4 (uso das máquinas)
SELECT m.id_maquina, m.tipo AS maquina, pr.nome AS produto,
       COUNT(*) AS ordens, SUM(pd.quantidade) AS unidades
FROM producao pd
JOIN produto pr ON pr.id_produto = pd.id_produto
JOIN maquina m ON m.id_maquina = pd.id_maquina
GROUP BY m.id_maquina, m.tipo, pr.id_produto, pr.nome
ORDER BY m.id_maquina, unidades DESC;

-- G11 — Quanto foi gasto com cada fornecedor?
-- Atende: P2 (compras de matéria-prima)
SELECT fo.id_fornecedor, fo.nome,
       COUNT(cm.id_comprar) AS qtd_compras,
       COALESCE(SUM(cm.valor), 0) AS total_gasto
FROM fornecedor fo
LEFT JOIN comprar_materia cm ON cm.id_fornecedor = fo.id_fornecedor
GROUP BY fo.id_fornecedor, fo.nome
ORDER BY total_gasto DESC;

-- G12 — Quais clientes cadastrados nunca fizeram um pedido?
-- Atende: P6 (visão por cliente) · ação comercial de reativação
SELECT c.id_cliente, c.nome, c.canal, c.email
FROM cliente c
LEFT JOIN pedido p ON p.id_cliente = c.id_cliente
WHERE p.id_pedido IS NULL
ORDER BY c.nome;

-- G13 — Qual a movimentação líquida de estoque (entradas menos saídas e ajustes) por produto?
-- Atende: P1 (ruptura de estoque de produto acabado)
SELECT pr.id_produto, pr.nome,
       SUM(CASE WHEN me.tipo = 'entrada' THEN me.quantidade ELSE 0 END) AS entradas,
       SUM(CASE WHEN me.tipo IN ('saida', 'ajuste') THEN me.quantidade ELSE 0 END) AS saidas_e_ajustes,
       SUM(CASE WHEN me.tipo = 'entrada' THEN me.quantidade ELSE -me.quantidade END) AS saldo_liquido
FROM movimento_estoque me
JOIN lote l ON l.id_lote = me.id_lote
JOIN produto pr ON pr.id_produto = l.id_produto
GROUP BY pr.id_produto, pr.nome
ORDER BY saldo_liquido;

-- ---------------------------------------------------------------------
-- AUDITORIA (conferem as regras de negócio; devolvem as linhas que as violam)
-- ---------------------------------------------------------------------

-- A01 — Existe pedido enviado ou entregue sem nota fiscal?
-- Verifica: RN06 (pedido expedido tem nota fiscal)
SELECT p.id_pedido, p.status, p.data_saida, p.valor_total
FROM pedido p
LEFT JOIN nota_fiscal nf ON nf.id_pedido = p.id_pedido
WHERE p.status IN ('enviado', 'entregue')
  AND nf.id_nota IS NULL
ORDER BY p.id_pedido;

-- A02 — Existe pedido sem nenhum item?
-- Verifica: RN04 (todo pedido tem ao menos um item)
SELECT p.id_pedido, p.status, p.data_emissao, p.valor_total
FROM pedido p
LEFT JOIN item_pedido ip ON ip.id_pedido = p.id_pedido
WHERE ip.id_item IS NULL
ORDER BY p.id_pedido;

-- A03 — Existe pedido cujo valor total difere da soma dos itens mais a taxa de entrega?
-- Verifica: RN05 (valor_total = itens + taxa)
SELECT p.id_pedido, p.valor_total,
       ROUND(SUM(ip.quantidade * ip.preco_praticado) + p.taxa_entrega, 2) AS valor_calculado,
       ROUND(p.valor_total - (SUM(ip.quantidade * ip.preco_praticado) + p.taxa_entrega), 2) AS diferenca
FROM pedido p
JOIN item_pedido ip ON ip.id_pedido = p.id_pedido
GROUP BY p.id_pedido, p.valor_total, p.taxa_entrega
HAVING ABS(p.valor_total - (SUM(ip.quantidade * ip.preco_praticado) + p.taxa_entrega)) > 0.01
ORDER BY p.id_pedido;

-- A04 — Existe lote vencido ainda com saldo em estoque?
-- Verifica: RN07 (lote vencido não é estoque disponível)
SELECT l.codigo_lote, pr.nome AS produto, es.localizacao, l.data_validade, l.quantidade_produto
FROM lote l
JOIN produto pr ON pr.id_produto = l.id_produto
JOIN estoque es ON es.id_estoque = l.id_estoque
WHERE l.data_validade < CURDATE()
  AND l.quantidade_produto > 0
ORDER BY l.data_validade;

-- A05 — Existe produção em máquina que não é homologada para a fórmula usada?
-- Verifica: RN08 (produção só em máquina homologada)
SELECT pd.id_producao, pr.nome AS produto, f.versao, m.tipo AS maquina, pd.data_inicio
FROM producao pd
JOIN produto pr ON pr.id_produto = pd.id_produto
JOIN formula f ON f.id_formula = pd.id_formula
JOIN maquina m ON m.id_maquina = pd.id_maquina
LEFT JOIN formula_maquina fm ON fm.id_formula = pd.id_formula AND fm.id_maquina = pd.id_maquina
WHERE fm.id_formula_maquina IS NULL
ORDER BY pd.data_inicio;

-- A06 — Existe produto sem fórmula vigente?
-- Verifica: RN09 (todo produto tem fórmula vigente)
SELECT pr.id_produto, pr.nome, pr.linha
FROM produto pr
WHERE NOT EXISTS (SELECT 1 FROM formula f WHERE f.id_produto = pr.id_produto AND f.status = 1)
ORDER BY pr.id_produto;
