# Entrega II - Modelo lógico, implementação SQL e apresentação final.
### Modelagem de um sistema de gestão de informações para uma organização de pequeno porte

---

## Metadados

| **Nomes** | **RGM** |
|---|---|
| [Erick da Silva Elias](https://github.com/erickdasilvaelias) | 47676779 |
| [Fabricio Coutinho](https://github.com/Briciobio) | 4795228 |
| [Henry Amaral Pires](https://github.com/HenryPires505) | 49937707
| [Marcella Flandes Souza De Mello](https://github.com/marcellaflandes) | 48386278 |
| [Matheus Mendes Fagundes](https://github.com/Matheus-212) | 48296457 |

---

# 1. Relatório Técnico Final

## 1.1 Revisão do Modelo Conceitual

### 1.1.1 Caracterização da organização

A **JV Indústria** é uma empresa privada com fins lucrativos, situada em Jacareí, no estado de São Paulo, e dedicada à fabricação de materiais para construção civil. Seu processo inclui a produção de argamassas, massas, texturas e outros revestimentos, predominantemente de acordo com as encomendas dos clientes. Para fins de demonstração do banco de dados, o SQL utiliza produtos fictícios das linhas **Super Tinta**, **Texturium** e **Rejuntei**.

Segundo o levantamento inicial, a organização possui **30 funcionários diretos**, distribuídos em 19 colaboradores na produção, 4 no setor administrativo, 3 no laboratório, 2 na expedição e 2 no estoque de embalagens. São realizadas aproximadamente **25 cargas de entrega por semana**. Esse volume operacional envolve cadastro de clientes, emissão de pedidos, definição de fórmulas, separação de matérias-primas, produção, conferência de lotes, expedição, emissão de notas fiscais e transporte.

**Identificação e contato:**

- **Endereço:** Av. Ademar Pereira de Barros, 876 — Jardim Santa Maria, Jacareí/SP.
- **Site institucional:** <https://jvindustria.com.br/>.
- **Telefone:** (12) 3958-3431.
- **E-mail:** adm2@jvindustria.com.br.
- **Responsável mencionada no levantamento:** Eliane Silveira do Carmo.

A escolha da organização decorreu do acesso aos responsáveis e à rotina operacional, favorecido pelo vínculo familiar de um dos integrantes do grupo. A natureza industrial da empresa permite estudar a integração entre vendas, fabricação, estoque, equipamentos, faturamento e entregas em um único modelo relacional.

**Registro fotográfico da organização:**

![Registro fotográfico da fachada da JV Indústria](levantamento/membro_na_fachada.jpeg)

*Figura 1 — Registro fotográfico na entrada da JV Indústria, em Jacareí/SP. Fonte: acervo do grupo.*

### 1.1.2 Problemas e necessidades de informação

Os problemas foram identificados pelos códigos **P1 a P6**, adotados nas consultas gerenciais do SQL. Cada problema está associado a estruturas de dados e a pelo menos uma consulta específica.

| Código | Problema de gestão | Informações necessárias | Consultas relacionadas |
|---|---|---|---|
| **P1** | Risco de ruptura ou divergência no estoque de produtos acabados. | Produtos, lotes, saldos, validade, localização e movimentações. | **G03**, **G13** |
| **P2** | Falta de matéria-prima para atender à produção. | Saldos e limites mínimos de insumos, fornecedores e registros de compra. | **G04**, **G11** |
| **P3** | Atrasos nas etapas entre pedido, saída da fábrica e entrega. | Datas de emissão, previsão, saída e entrega dos pedidos. | **G05**, **G06** |
| **P4** | Dificuldade de analisar paradas e utilização das máquinas. | Máquinas, datas de interrupção, duração das paradas e produção realizada. | **G09**, **G10** |
| **P5** | Necessidade de acompanhar a frequência de cancelamentos. | Situações dos pedidos, datas de emissão e cancelamento. | **G07** |
| **P6** | Visão insuficiente do desempenho comercial e do valor dos pedidos. | Clientes, itens, produtos, canais comerciais, valores e períodos. | **G01**, **G02**, **G08**, **G12** |

O escopo dos dados inclui também fórmulas, matérias-primas, fornecedores, embalagens, veículos, notas fiscais e registros de produção. Compras negociadas por e-mail e fichas detalhadas de manutenção terceirizada permanecem fora da operação informatizada descrita pela entrevistada, embora haja no banco registros cadastrais e históricos associados a essas atividades.

### 1.1.3 Entrevista e levantamento da organização

O levantamento inicial foi realizado com acesso à organização e à responsável citada na Entrega 1. As informações complementares obtidas em **08/11/2026**, por mensagem, permitiram detalhar o armazenamento das matérias-primas, a organização de lotes, a manutenção terceirizada, o registro de compras e a movimentação para a expedição.

| Aspecto | Procedimento informado pela organização |
|---|---|
| Armazenamento de matérias-primas | Cada material possui um local fixo, identificado, no almoxarifado, para reduzir erros durante a separação. |
| Lotes por cliente e pedido | Os lotes destinados ao mesmo cliente são agrupados fisicamente, a fim de serem entregues juntos no pedido correspondente. |
| Manutenção | Executada por prestadores terceirizados; o mecânico registra em ficha física o equipamento, o defeito encontrado e os materiais utilizados no reparo. |
| Numeração de pedidos do cliente | Em geral, os clientes utilizam um número de pedido para cada nota fiscal. A operação admite diferentes números externos, identificados por item, quando necessário. |
| Compras | As negociações e solicitações de compra são feitas diretamente por e-mail. |
| Entrada de insumos | Após o recebimento, a matéria-prima é lançada no controle e armazenada no almoxarifado. |
| Expedição | O produto acabado é encaminhado ao setor de expedição para conferência e entrega. |

As informações complementares representam **declarações recebidas por mensagem**, não observações presenciais adicionais. A fotografia da fachada apresentada na seção 1.1.1 documenta a identificação visual da organização, mas, por si só, não comprova a realização da entrevista no ambiente da empresa. O relato de levantamento e eventuais fotos da entrevista presencial devem ser mantidos como evidências separadas no repositório, conforme as orientações da Entrega 2.

### 1.1.4 Processos de negócio

1. **Cadastro de clientes e produtos:** registro dos dados de identificação, contato, segmento comercial e catálogo de produtos, com descrição, linha, preço de referência e estoque mínimo.
2. **Recebimento de pedidos:** associação ao cliente, forma de pagamento, endereço de entrega ou retirada, valor total, taxa de transporte, datas e status; cada pedido contém itens com produto, quantidade e preço praticado.
3. **Preparação das fórmulas:** identificação do produto, versão vigente e composição por matérias-primas, com quantidades, unidades e ordem de adição.
4. **Separação de matérias-primas:** retirada dos insumos de suas posições fixas no almoxarifado, de acordo com a composição de cada fórmula.
5. **Programação e fabricação:** utilização de máquinas compatíveis com a fórmula e registro da quantidade produzida, datas, máquina, produto e, quando associado, pedido de origem.
6. **Formação e armazenamento de lotes:** identificação de código, produto, quantidade, data de fabricação, validade e setor de armazenamento.
7. **Movimentação de estoque e expedição:** registro de entradas, saídas e ajustes de lotes, permitindo acompanhar os estoques de produtos acabados e o encaminhamento para a expedição.
8. **Faturamento e entregas:** associação de notas fiscais aos pedidos, registro de entregas, código de rastreamento e veículo utilizado.
9. **Relacionamento com fornecedores:** cadastro dos fornecedores e histórico das matérias-primas adquiridas; o contato e a contratação de compras permanecem externos ao sistema.
10. **Acompanhamento das máquinas:** cadastro de equipamentos, produção e histórico resumido de paradas; o detalhamento dos reparos permanece nas fichas físicas dos prestadores terceirizados.

**Fluxo principal:** recebimento do pedido → identificação dos itens → emissão/consulta da fórmula → separação de insumos → fabricação → registro e armazenamento de lotes → expedição → nota fiscal → transporte e entrega.

### 1.1.5 Requisitos funcionais

| Código | Requisito funcional | Dados e estruturas correspondentes |
|---|---|---|
| **RF01** | Cadastrar, consultar e atualizar clientes, incluindo identificação, documento, canal de atuação, endereço, telefone e e-mail. | `cliente` |
| **RF02** | Cadastrar produtos e suas linhas, descrições, preços e quantidades mínimas. | `produto` |
| **RF03** | Registrar pedidos com cliente, data de emissão, previsão, forma de pagamento, status, endereço, taxa de entrega e valor total. | `pedido` |
| **RF04** | Registrar os itens de cada pedido, com produto, quantidade solicitada e preço praticado. | `item_pedido`, `pedido`, `produto` |
| **RF05** | Cadastrar fórmulas e vincular seus componentes por quantidade, unidade de medida e ordem de utilização. | `formula`, `formula_materia`, `materia_prima` |
| **RF06** | Identificar máquinas aptas a trabalhar com cada fórmula. | `maquina`, `formula_maquina` |
| **RF07** | Registrar produções com produto, fórmula, máquina, quantidade, datas e pedido de origem, quando informado. | `producao` |
| **RF08** | Cadastrar lotes e controlar quantidades, fabricação, validade e local de armazenamento. | `lote`, `produto`, `estoque` |
| **RF09** | Registrar entradas, saídas e ajustes de lotes com quantidade, motivo e data. | `movimento_estoque`, `lote` |
| **RF10** | Cadastrar fornecedores e manter registros de aquisições de matérias-primas. | `fornecedor`, `comprar_materia`, `materia_prima` |
| **RF11** | Registrar notas fiscais vinculadas aos pedidos. | `nota_fiscal`, `pedido` |
| **RF12** | Registrar entregas, rastreamento e veículos. | `entrega`, `veiculo`, `pedido` |
| **RF13** | Consultar situação das máquinas e paradas registradas. | `maquina`, `parada_manutencao` |
| **RF14** | Executar consultas gerenciais de estoque, matéria-prima, prazo, cancelamento, produção, fornecedores e vendas. | **G01–G13** |
| **RF15** | Executar consultas de auditoria para identificar inconformidades de pedidos, lotes, fórmulas e máquinas. | **A01–A06** |

O processo físico mantém duas necessidades complementares: identificar a posição individual de cada matéria-prima e relacionar vários números externos de pedido de cliente a uma mesma nota. Esses dados **não possuem campos específicos** no SQL documentado, de modo que os procedimentos permanecem externos à estrutura relacional atual.

### 1.1.6 Requisitos não funcionais

| Código | Requisito não funcional | Finalidade |
|---|---|---|
| **RNF01** | Integridade referencial por chaves estrangeiras. | Manter consistência entre os cadastros e operações. |
| **RNF02** | Restrições de tipo, domínio, unicidade e valores permitidos. | Prevenir valores inválidos e duplicações indevidas. |
| **RNF03** | Proteção de dados por permissões de acesso e práticas compatíveis com a LGPD. | Restringir a exposição de informações cadastrais e comerciais. |
| **RNF04** | Consultas com desempenho adequado ao volume operacional. | Apoiar o atendimento, a produção e a expedição. |
| **RNF05** | Rotinas de backup e recuperação dos dados. | Favorecer continuidade e recuperação em caso de falhas. |
| **RNF06** | Utilização de registros fictícios nas demonstrações acadêmicas. | Preservar dados privados da organização e de seus clientes. |

RNF03, RNF04 e RNF05 representam requisitos de operação e infraestrutura; não são comprovados somente pela estrutura do script SQL.

### 1.1.7 Regras de negócio

Os códigos **RN01–RN10** correspondem às regras referenciadas no cabeçalho e nas consultas de auditoria do script da Entrega 2.

| Código | Regra de negócio | Implementação ou verificação |
|---|---|---|
| **RN01** | Documento e e-mail do cliente devem ser únicos. | Restrições `UNIQUE` em `cliente`. |
| **RN02** | Todo pedido deve estar associado a um cliente cadastrado. | `pedido.id_cliente NOT NULL` e chave estrangeira. |
| **RN03** | Todo pedido cancelado deve registrar uma data de cancelamento válida. | `CHECK` do status e da data de cancelamento. |
| **RN04** | Todo pedido deve possuir pelo menos um item. | Verificação pela consulta **A02**; não existe restrição entre tabelas que imponha o mínimo. |
| **RN05** | O valor total do pedido corresponde à soma dos itens e à taxa de entrega. | Verificação pela consulta **A03**. |
| **RN06** | Pedidos enviados ou entregues devem estar associados à nota fiscal. | Verificação pela consulta **A01**. |
| **RN07** | Lotes vencidos não compõem o estoque disponível para venda. | Tratamento na consulta **G03** e verificação pela **A04**. |
| **RN08** | A produção deve utilizar uma máquina homologada para sua fórmula. | Relação `formula_maquina` e verificação pela consulta **A05**. |
| **RN09** | Todo produto deve possuir uma fórmula vigente. | Verificação pela consulta **A06**. |
| **RN10** | Pedidos com retirada no estabelecimento não devem pagar taxa de entrega. | Restrição `CHECK` em `pedido`. |

**Procedimentos operacionais adicionais:** as matérias-primas são separadas de posições fixas no almoxarifado; os lotes do mesmo pedido são agrupados para expedição; as compras são tratadas por e-mail; a manutenção é terceirizada e documentada em papel; e o produto concluído é encaminhado à expedição. Essas práticas integram a realidade organizacional, mas não são todas impostas por restrições SQL.

O SQL também contém validações para quantidades positivas, valores monetários não negativos, capacidade de estoques e máquinas, dimensões de embalagens, coerência entre datas e unicidade de relacionamentos associativos.

### 1.1.8 Revisão do DER conceitual

![Diagrama Entidade-Relacionamento conceitual da JV Indústria](levantamento/der_conceitual.png)

| Elemento de modelagem | Representação no modelo implementado | Justificativa |
|---|---|---|
| Pedido e produto | `item_pedido`, com quantidade e preço praticado. | Representar os itens comerciais de cada encomenda. |
| Fórmula e matéria-prima | `formula_materia`, com quantidade, unidade e ordem. | Documentar a composição de cada fórmula sem repetir insumos numa única coluna. |
| Fórmula e máquina | `formula_maquina`. | Identificar máquinas homologadas para uso da fórmula. |
| Produção, fórmula e máquina | Chaves estrangeiras de `producao` para `formula` e `maquina`. | Permitir rastrear o equipamento e a fórmula registrados em cada produção. |
| Movimentação e lote | Chave estrangeira `movimento_estoque.id_lote`. | Identificar o lote envolvido em cada entrada, saída ou ajuste. |
| Produtos e embalagens | `embalagem.id_produto`. | Documentar os tipos e as dimensões das embalagens cadastradas. |
| Pedido e nota fiscal | `nota_fiscal.id_pedido` com `UNIQUE`. | Permitir, na implementação atual, no máximo uma nota por pedido. |

**Limites de representação:** `lote` não possui uma referência direta ao pedido ou à produção que o originou; `materia_prima` não apresenta atributo para sua posição física individual; os números externos de pedido do cliente não são armazenados por item; e a manutenção terceirizada é representada somente por paradas resumidas. Essas diferenças delimitam o alcance do banco implementado em relação ao processo descrito na entrevista.

O DER conceitual segue a distinção entre **entidades, atributos, relacionamentos e cardinalidades**. As chaves estrangeiras pertencem ao modelo lógico, e o modelo visual deve utilizar a notação do **brModelo** conforme a atividade.

---

## 1.2 Conversão do Modelo Conceitual para o Modelo Lógico

O esquema SQL compreende **20 tabelas**. As entidades principais são `cliente`, `pedido`, `nota_fiscal`, `produto`, `estoque`, `lote`, `maquina`, `formula`, `materia_prima`, `fornecedor`, `veiculo`, `entrega`, `producao`, `movimento_estoque`, `parada_manutencao` e `embalagem`. As relações entre entidades foram complementadas pelas tabelas `item_pedido`, `comprar_materia`, `formula_materia` e `formula_maquina`.

A conversão adotou os seguintes critérios:

- **Entidades em tabelas:** cada conjunto de dados possui identificador numérico próprio, geralmente `INT AUTO_INCREMENT`.
- **Atributos em colunas:** identificadores e quantidades em `INT`; valores em `DECIMAL`; textos em `VARCHAR`; datas em `DATE` ou `DATETIME`; situações e categorias restritas em `ENUM`.
- **Relacionamentos 1:N:** representados por chave estrangeira no lado N, como um cliente para diversos pedidos, um produto para diversos lotes e uma máquina para diversas produções.
- **Relacionamentos N:N:** representados por tabelas associativas, como os itens que conectam pedidos e produtos, a composição de fórmulas e a homologação entre fórmulas e máquinas.
- **Relacionamento 1:1 opcional:** o campo `nota_fiscal.id_pedido` é único, permitindo no máximo uma nota fiscal para cada pedido, sem exigir nota em todo pedido.
- **Generalização/especialização:** não foi utilizada estrutura específica de herança no esquema implementado.

Os relacionamentos são documentados com suas chaves estrangeiras e regras de integridade, mantendo separadas as informações cadastrais das operações comerciais e produtivas.

## 1.3 Definição de Chaves Primárias e Estrangeiras

| Tabela | Chave primária (PK) | Chaves estrangeiras (FK) |
|---|---|---|
| `cliente` | `id_cliente` | — |
| `pedido` | `id_pedido` | `id_cliente → cliente.id_cliente` |
| `item_pedido` | `id_item` | `id_pedido → pedido.id_pedido`; `id_produto → produto.id_produto` |
| `nota_fiscal` | `id_nota` | `id_pedido → pedido.id_pedido` |
| `produto` | `id_produto` | — |
| `estoque` | `id_estoque` | — |
| `lote` | `id_lote` | `id_produto → produto.id_produto`; `id_estoque → estoque.id_estoque` |
| `maquina` | `id_maquina` | — |
| `formula` | `id_formula` | `id_produto → produto.id_produto` |
| `materia_prima` | `id_materia_prima` | — |
| `fornecedor` | `id_fornecedor` | — |
| `veiculo` | `id_veiculo` | — |
| `entrega` | `id_entrega` | `id_pedido → pedido.id_pedido`; `id_veiculo → veiculo.id_veiculo` |
| `producao` | `id_producao` | `id_pedido → pedido.id_pedido`; `id_produto → produto.id_produto`; `id_formula → formula.id_formula`; `id_maquina → maquina.id_maquina` |
| `movimento_estoque` | `id_movimento` | `id_estoque → estoque.id_estoque`; `id_lote → lote.id_lote` |
| `comprar_materia` | `id_comprar` | `id_materia → materia_prima.id_materia_prima`; `id_fornecedor → fornecedor.id_fornecedor` |
| `formula_materia` | `id_formula_materia` | `id_formula → formula.id_formula`; `id_materia → materia_prima.id_materia_prima` |
| `formula_maquina` | `id_formula_maquina` | `id_formula → formula.id_formula`; `id_maquina → maquina.id_maquina` |
| `parada_manutencao` | `id_parada` | `id_maquina → maquina.id_maquina` |
| `embalagem` | `id_embalagem` | `id_produto → produto.id_produto` |

## 1.4 Processo de Normalização (1FN, 2FN e 3FN)

**Primeira Forma Normal (1FN).** A estrutura organiza os valores em colunas de domínio simples e utiliza tabelas relacionadas em vez de listas de produtos, matérias-primas ou máquinas em um único campo. A separação de `item_pedido`, `formula_materia` e `formula_maquina` é um exemplo dessa organização.

**Segunda Forma Normal (2FN).** Os atributos de cada tabela se referem ao registro identificado por sua chave primária. As tabelas associativas utilizam identificadores próprios e restrições de unicidade sobre combinações relevantes, evitando duplicação de pares de pedido/produto, fórmula/insumo e fórmula/máquina.

**Terceira Forma Normal (3FN).** Dados de clientes, produtos, matérias-primas, fornecedores e máquinas são mantidos em tabelas separadas, em lugar de serem reproduzidos a cada pedido ou produção. As relações são estabelecidas por identificadores, reduzindo redundância e o risco de inconsistência na atualização de cadastros.

A normalização se aplica à estrutura relacional, mas não substitui a auditoria de regras entre tabelas. Por exemplo, `pedido.valor_total` e o valor calculado pelos itens podem divergir, situação verificada em **A03**. Os saldos mantidos em `lote` e as movimentações correspondentes também demandam procedimentos de conciliação. Não se pressupõe validação formal de todas as dependências funcionais apenas a partir dessas descrições.

## 1.5 Justificativas Técnicas das Decisões

**Chaves primárias.** As PKs numéricas garantem a identificação inequívoca dos registros e facilitam a associação entre tabelas, mesmo quando nomes e descrições são atualizados.

**Chaves estrangeiras.** As FKs preservam a integridade referencial em relações como pedido–cliente, item–produto, lote–estoque, produção–fórmula, produção–máquina e movimento–lote.

**Restrições de unicidade.** Os campos `cliente.documento`, `cliente.email`, `fornecedor.cnpj`, `veiculo.placa`, `entrega.codigo_rastreio` e `lote.codigo_lote` possuem restrições `UNIQUE`. Também são únicas as combinações `item_pedido(id_pedido, id_produto)`, `formula(id_produto, versao)`, `formula_materia(id_formula, id_materia)`, `formula_materia(id_formula, ordem)` e `formula_maquina(id_formula, id_maquina)`. O campo `nota_fiscal.id_pedido` também é único.

**Restrições de domínio.** As colunas `ENUM` delimitam categorias de clientes, linhas de produtos, status de pedidos, máquinas, paradas e embalagens, formas de pagamento e tipos de movimentação. `NOT NULL` e `DEFAULT` definem a obrigatoriedade e os valores iniciais dos campos necessários.

**Restrições de verificação.** O script contém **31 restrições `CHECK`**, para condições como quantidade positiva de itens, produção e movimentos; valores monetários não negativos; datas coerentes; dimensões positivas; retirada sem taxa de entrega (**RN10**); e data de cancelamento consistente (**RN03**).

**Regras de integridade auditadas.** As condições que dependem da comparação entre várias tabelas são avaliadas pelas consultas **A01–A06**, incluindo a presença de nota em pedidos expedidos (**RN06**), a existência de itens (**RN04**), a soma do pedido (**RN05**), os lotes vencidos (**RN07**), a compatibilidade entre fórmula e máquina (**RN08**) e a existência de fórmula vigente (**RN09**). Essas consultas identificam exceções, mas não impedem todas elas automaticamente.

**Separação entre processos externos e registros internos.** O histórico `comprar_materia` guarda informações de fornecedor, insumo, quantidade, valor, data e comprovante, mas não substitui a negociação por e-mail. `parada_manutencao` descreve interrupções de máquina, sem substituir a ficha detalhada de manutenção do prestador.

## 1.6 Proposta de Arquitetura Analítica para BI e IA

O banco de dados permite consultas operacionais e gerenciais por meio do SQL. Os resultados podem servir de base a painéis de **Business Intelligence (BI)**, com indicadores para o acompanhamento de estoque, fornecedores, máquinas, pedidos e desempenho comercial. As aplicações de inteligência artificial são possibilidades de evolução analítica, e não funcionalidades implantadas no script.

### Indicadores gerenciais (KPIs)

| Indicador | Cálculo e periodicidade de análise | Consulta |
|---|---|---|
| Valor mensal de pedidos não cancelados | Soma de `pedido.valor_total` por mês de emissão, excluindo cancelados. Análise mensal. | **G01** |
| Ticket médio mensal dos pedidos não cancelados | Média de `pedido.valor_total` por mês de emissão. Análise mensal. | **G01** |
| Saldo de produto acabado abaixo do mínimo | Soma de saldos dos lotes não vencidos comparada a `produto.quantidade_minima`. Acompanhamento diário. | **G03** |
| Déficit de matérias-primas | `quantidade_minima - quantidade`, para insumos abaixo do mínimo. Acompanhamento diário. | **G04** |
| Prazo médio de emissão até saída | Média das horas entre `data_emissao` e `data_saida`, dividida por 24, agrupada pelo mês de emissão. Análise mensal. | **G05** |
| Percentual de entregas dentro do prazo | Entregas realizadas até `data_prevista` ÷ entregas registradas como concluídas × 100. Análise mensal. | **G06** |
| Taxa de cancelamento | Pedidos com status `cancelado` ÷ todos os pedidos do mês × 100. Análise mensal. | **G07** |
| Duração acumulada das paradas por máquina | Soma das horas entre início e fim das paradas, usando a data atual para as ainda abertas. Acompanhamento por máquina. | **G09** |
| Quantidade produzida por máquina e produto | Soma de `producao.quantidade` agrupada por máquina/produto. Análise operacional. | **G10** |
| Valor de aquisições por fornecedor | Soma de `comprar_materia.valor` por fornecedor. Análise por histórico registrado. | **G11** |
| Saldo líquido de movimentação por produto | Entradas menos saídas e ajustes registrados, agrupados por produto. Análise periódica. | **G13** |

Os valores de **G01** representam os pedidos não cancelados, independentemente da confirmação de recebimento financeiro. Por isso, o indicador constitui uma visão comercial de faturamento por pedidos, e não uma apuração contábil de receita recebida. O histórico de compras e de paradas também deve ser interpretado como o conjunto de registros efetivamente incluídos no banco.

### Rastreabilidade entre problemas, dados e consultas

| Problema | Tabelas envolvidas | Consultas gerenciais |
|---|---|---|
| **P1 — Estoque de produtos acabados** | `produto`, `lote`, `estoque`, `movimento_estoque` | **G03**, **G13** |
| **P2 — Matérias-primas e suprimentos** | `materia_prima`, `comprar_materia`, `fornecedor` | **G04**, **G11** |
| **P3 — Prazos operacionais** | `pedido`, `entrega` | **G05**, **G06** |
| **P4 — Paradas e produção** | `maquina`, `parada_manutencao`, `producao`, `produto` | **G09**, **G10** |
| **P5 — Cancelamentos** | `pedido` | **G07** |
| **P6 — Análise comercial** | `cliente`, `pedido`, `item_pedido`, `produto` | **G01**, **G02**, **G08**, **G12** |

### Aplicações futuras de BI e IA

**Business Intelligence:** painéis com evolução mensal dos pedidos, linhas de produtos por canal comercial, níveis críticos de estoque, percentual de entregas pontuais, cancelamentos e horas de parada por máquina.

**Inteligência artificial:** previsão de demanda de matérias-primas a partir de históricos de pedidos, identificação de padrões de atrasos, estimativa de risco de falta de estoque e detecção de divergências entre valores declarados e calculados. A aplicação desses modelos dependeria de amostras históricas suficientes, qualidade dos registros e avaliação de eventuais erros e vieses.

---

# 2. Modelo Lógico Relacional

O modelo lógico traduz as entidades e os relacionamentos da modelagem conceitual em um esquema com **20 tabelas**, **chaves primárias**, **chaves estrangeiras** e tipos de dados definidos para MySQL. As tabelas podem ser organizadas pelos seguintes domínios:

| Domínio | Tabelas |
|---|---|
| Comercial e faturamento | `cliente`, `pedido`, `item_pedido`, `nota_fiscal`, `produto`, `embalagem` |
| Produção e formulação | `formula`, `formula_materia`, `formula_maquina`, `producao`, `maquina`, `parada_manutencao` |
| Suprimentos | `materia_prima`, `fornecedor`, `comprar_materia` |
| Estoque e logística | `estoque`, `lote`, `movimento_estoque`, `veiculo`, `entrega` |

A descrição das chaves encontra-se na seção **1.3** e as restrições de integridade na seção **1.5**. O arquivo [der_conceitual.png](der_conceitual.png) corresponde ao diagrama conceitual da primeira entrega; a representação visual do **modelo lógico na notação brModelo** constitui um artefato distinto, com tabelas, colunas, tipos, PKs, FKs e cardinalidades.

---

# 3. Script SQL Completo

**Arquivo da implementação da Entrega 2:** [script (1).sql](script%20%281%29.sql)

O banco de dados foi estruturado para **MySQL 8.0.16 ou superior**. O arquivo contempla **20 tabelas**, **23 chaves estrangeiras** e **31 restrições `CHECK`**, além de chaves primárias, valores padrão e restrições de unicidade. Os dados utilizados nas instruções `INSERT` são fictícios.

A sequência do arquivo compreende criação de tabelas, configuração de restrições, inserção da massa de dados, consultas com `JOIN`, operações `UPDATE` e `DELETE`, consultas gerenciais e consultas de auditoria.

| Componente | Quantidade | Identificação |
|---|---:|---|
| Tabelas criadas | **20** | `CREATE TABLE` |
| Chaves estrangeiras | **23** | `ALTER TABLE ... FOREIGN KEY` |
| Restrições de verificação | **31** | `ALTER TABLE ... CHECK` |
| Consultas demonstrativas com `JOIN` | **5** | **S01–S05** |
| Exemplos de atualização | **4 operações identificadas** | **U01–U04** |
| Exemplos de exclusão | **2** | **D01–D02** |
| Consultas gerenciais | **13** | **G01–G13** |
| Consultas de auditoria | **6** | **A01–A06** |

O arquivo inicia diretamente na definição das tabelas, **sem `CREATE DATABASE` ou `USE`**. Assim, sua execução pressupõe a seleção prévia de um banco no MySQL. A documentação descreve a implementação contida no arquivo; a demonstração de execução no SGBD é uma etapa distinta.

## 3.1 Consultas gerenciais

| Código | Pergunta gerencial | Problema atendido |
|---|---|---|
| **G01** | Qual o valor total, o número e o ticket médio dos pedidos não cancelados por mês? | P6 |
| **G02** | Quais são os cinco clientes com maior valor acumulado de pedidos? | P6 |
| **G03** | Quais produtos estão abaixo do estoque mínimo, sem contar lotes vencidos? | P1 |
| **G04** | Quais matérias-primas estão abaixo do mínimo e qual foi o último fornecedor registrado? | P2 |
| **G05** | Qual o prazo médio entre emissão do pedido e saída da fábrica por mês? | P3 |
| **G06** | Qual o percentual de pedidos entregues no prazo por mês? | P3 |
| **G07** | Qual a taxa de cancelamento mensal? | P5 |
| **G08** | Qual o valor vendido por linha de produto e canal comercial? | P6 |
| **G09** | Quantas paradas e horas de interrupção cada máquina registrou? | P4 |
| **G10** | Qual foi a quantidade produzida por máquina e produto? | P4 |
| **G11** | Quanto foi gasto em compras registradas para cada fornecedor? | P2 |
| **G12** | Quais clientes cadastrados nunca fizeram pedidos? | P6 |
| **G13** | Qual o saldo líquido das movimentações de estoque por produto? | P1 |

## 3.2 Consultas de auditoria

| Código | Verificação executada | Regra associada |
|---|---|---|
| **A01** | Localizar pedidos enviados ou entregues sem nota fiscal. | **RN06** |
| **A02** | Localizar pedidos sem nenhum item. | **RN04** |
| **A03** | Localizar pedidos com valor total divergente da soma dos itens mais a taxa de entrega. | **RN05** |
| **A04** | Localizar lotes vencidos que permanecem com saldo em estoque. | **RN07** |
| **A05** | Localizar produções realizadas em máquinas não homologadas para a fórmula usada. | **RN08** |
| **A06** | Localizar produtos sem fórmula vigente. | **RN09** |

As consultas de auditoria retornam registros que violam as condições verificadas. A ausência de linhas representa apenas a ausência de inconsistências **detectadas por aquela consulta** na base analisada, não uma certificação de integridade de todo o processo.

---

# 4. Massa de Dados

A massa de dados foi construída com informações **fictícias** inspiradas no tipo de operação da JV Indústria, sem utilizar dados pessoais reais dos clientes. O conjunto inclui pedidos em diferentes situações, lotes vencidos, matérias-primas abaixo do mínimo, fornecedores com diferentes volumes de compras e máquinas com registros de paradas.

| Conjunto de registros | Quantidade inserida |
|---|---:|
| Clientes | 31 |
| Produtos | 10 |
| Embalagens | 13 |
| Estoques/setores | 3 |
| Máquinas | 8 |
| Veículos | 4 |
| Fornecedores | 8 |
| Matérias-primas | 18 |
| Fórmulas | 10 |
| Componentes de fórmulas | 98 |
| Máquinas homologadas por fórmula | 14 |
| Registros de parada | 11 |
| Compras de matérias-primas | 26 |
| Lotes de produtos acabados | 16 |
| Movimentações de estoque | 34 |
| Pedidos | 34 |
| Itens de pedido | 99 |
| Notas fiscais | 26 |
| Entregas | 23 |
| Registros de produção | 36 |

Esses valores representam as instruções de inserção do arquivo SQL. Como o script também executa operações `UPDATE` e `DELETE`, os estados finais de algumas tabelas diferem dos valores inseridos inicialmente: há exclusão do cliente fictício de teste e de embalagens descontinuadas, além de atualizações de preços, status de máquinas, pedidos e saldo de uma matéria-prima.

O volume de **34 pedidos** e **23 entregas** constitui uma amostra de demonstração distribuída por diferentes datas, não o registro integral das cerca de **25 cargas semanais** da operação real. A variedade dos registros favorece a avaliação das consultas gerenciais e dos cenários de auditoria sem reproduzir informações privadas da empresa.

---

# 5. Repositório GitHub

O repositório constitui o meio de entrega do projeto, tendo como documento principal o **`README.md` localizado na raiz da branch `main`**. Os artefatos técnicos são mantidos em arquivos separados, com referências no relatório.

| Artefato | Finalidade |
|---|---|
| `README.md` | Relatório técnico da Entrega 2. |
| `der.pdf` | Modelo conceitual utilizado na primeira etapa. |
| `imagens/der_conceitual.png` | Imagem do DER conceitual apresentada na seção 1.1.8. |
| `imagens/fachada_jv_industria.jpeg` | Registro fotográfico da organização apresentado na seção 1.1.1. |
| Modelo lógico relacional | Diagrama visual com tabelas, tipos, PKs, FKs e cardinalidades, na notação solicitada. |
| Dicionário de dados | Descrição de atributos, tipos, chaves, obrigatoriedade, unicidade, valores permitidos e valores padrão. |
| `levantamento/levantamento.md` | Relato organizado da entrevista, separado da documentação de implementação. |
| Outras evidências em JPG/PNG | Registros adicionais da visita e da entrevista no local, quando disponíveis. |
| `script (1).sql` | Implementação MySQL e massa de dados fictícios utilizada neste relatório. |
| Apresentação final | Síntese executiva do problema, solução, implementação e resultados gerenciais. |

O dicionário de dados é exigido em **um único arquivo HTML**, exceto para turmas de **GTI**, nas quais o formato previsto é **um único arquivo Markdown**. O histórico de *commits* do GitHub documenta a evolução e a colaboração dos integrantes do grupo.

---

# 6. Uso de Inteligência Artificial

Ferramentas de inteligência artificial generativa foram utilizadas como apoio à organização de informações, à redação técnica e à elaboração de partes do código SQL. As informações sobre a operação da JV Indústria tiveram como referência o levantamento da organização, e as consultas SQL correspondem às estruturas implementadas no arquivo entregue.

### 6.1 Histórico da Entrega 1

| Item | Registro |
|------|------------------|
| **Ferramenta e etapa** | Claude (Anthropic) — utilizado ao longo de toda a Entrega 1: estruturação do modelo conceitual, elaboração de um diagrama ER inicial de exemplo, organização do README a partir do esqueleto da disciplina, revisão de seções específicas (Processos de Negócio, Requisitos do Sistema, Regras de Negócio, Modelagem Conceitual, Justificativa Técnica) e orientação técnica sobre uso do GitHub (criação de repositório, permissões de colaborador, formatação Markdown, anexação de imagens). |
| **Motivação** | O grupo recorreu à IA para ter um ponto de partida estruturado do README, entender a notação de modelagem ER/DER (BR e Crow's Foot), esclarecer dúvidas práticas sobre uso do GitHub (Markdown, colaboradores, upload de arquivos) e receber apoio na redação técnica de seções como a Justificativa Técnica. |
| **Prompt(s) utilizados** | "preciso criar um banco de dados sobre uma empresa escolhida, que foi um centro logístico, e antes, preciso fazer um diagrama no br modelo ou db design, como posso fazer?"; "baseado no que eu disse, preciso criar um readme.md"; "consegue preencher cada área com informações fictícias de uma empresa fictícia para eu ver como deve ficar?"; "eu preciso criar esse arquivo no github, e como o trabalho é em grupo, me indicaram fazer diretamente por ele..."; "Produtos: massa corrida / Rejunte / Massa acrílica... [descrição do processo produtivo real]"; "na seção 2, como que fica os simbolos"; "na seção 4?"; "na seção 3 (Requisitos do sistema) oque exatamente devo escrever?"; entre outros prompts de dúvidas pontuais sobre formatação e uso do GitHub. |
| **Resposta recebida** | A IA gerou uma estrutura completa de README.md alinhada ao esqueleto da disciplina, um exemplo ilustrativo com uma empresa fictícia (posteriormente identificado como inadequado, pois o enunciado exige organização real), orientações passo a passo sobre GitHub (criação de repositório, adição de colaboradores, upload de arquivos e imagens), e sugestões de conteúdo para as seções de Processos de Negócio, Requisitos Funcionais/Não Funcionais, Regras de Negócio e Justificativa Técnica, adaptadas à operação real da empresa a partir das informações fornecidas pelo grupo. |
| **Fontes consultadas e verificadas** | A IA não citou fontes externas nas respostas técnicas de modelagem; o conteúdo foi baseado em conhecimento geral de modelagem de dados (ER/DER, notação BR, Markdown, GitHub). Todo o conteúdo específico da empresa (processos, produtos, fluxo de produção) foi validado pelo grupo com base na visita de campo realizada, não em informações fornecidas pela IA. |
| **Trechos rejeitados ou corrigidos** | O grupo rejeitou integralmente o primeiro modelo sugerido pela IA (baseado em uma empresa fictícia genérica de distribuição/centro logístico, com entidades como Fornecedor, Item_Pedido, Veículo padrão), substituindo por um modelo específico da operação real da JV Indústria, que envolve fabricação sob encomenda (entidades como Formula, Matéria_Prima, Máquina, Lote, Produção). O Dicionário de Dados e o DER final foram construídos pelo grupo com base no processo real, não no exemplo genérico inicial. |
| **Justificativa da escolha final** | O grupo optou por manter a estrutura geral de organização do README sugerida pela IA (por seguir fielmente o esqueleto da disciplina), mas substituiu todo o conteúdo específico — entidades, atributos, relacionamentos, regras de negócio e justificativa técnica — pelas informações reais levantadas na visita à empresa, garantindo que o trabalho reflita a operação observada e não um modelo genérico. |
| **Reflexão crítica** | A IA inicialmente sugeriu, sem que o grupo tivesse explicitado a exigência do enunciado, uma modelagem para uma empresa totalmente fictícia — o que não atende ao requisito de organização real e pesquisada em campo. Esse ponto só foi corrigido porque a própria IA identificou a inconsistência ao ler o esqueleto da entrega e alertou o grupo, reforçando a importância de revisar cuidadosamente as instruções da disciplina antes de aceitar sugestões de IA. Além disso, a IA não teve acesso direto ao board do Figma nem ao repositório do GitHub (por restrições de acesso automatizado), então parte da leitura de diagramas foi feita a partir de prints de tela, o que pode ter gerado pequenas imprecisões na transcrição de cardinalidades — exigindo conferência manual do grupo contra o diagrama original. |

---

**Uso adicional (integrante responsável pela entrevista de campo):**

| Item | Registro |
|------|------------------|
| **Ferramenta e etapa** | ChatGPT (OpenAI) — organização do levantamento bruto de informações coletado na entrevista de campo (transcrição de falas do responsável entrevistado) em categorias (Entidades, Processos, Dados/Regras), com referência de origem de cada trecho. |
| **Motivação** | O levantamento de campo foi registrado de forma corrida/desestruturada (mensagens de texto); o grupo recorreu à IA para organizar esse material bruto em categorias úteis à modelagem, sem perder nenhuma informação relatada. |
| **Prompt(s) utilizados** | "Vou te enviar várias mensagens. Quero que você organize todo esse conteúdo de forma clara e estruturada... Organize por categorias: Entidades, Processos e Dados/Outras informações... Indique a referência de qual mensagem veio cada informação" (seguido da transcrição bruta da entrevista). |
| **Resposta recebida** | Documento estruturado com o levantamento organizado em Entidades, Processos, Dados/Regras de Negócio (numeradas RN01–RN26) e um fluxo geral da produção, cada trecho referenciado à fala original do entrevistado. |
| **Fontes consultadas e verificadas** | Nenhuma fonte externa; a IA apenas reorganizou informações fornecidas diretamente pelo grupo a partir da entrevista de campo, sem adicionar conteúdo próprio. |
| **Trechos rejeitados ou corrigidos** | O levantamento original do ChatGPT sugeria tratar "Envase" e "Pallet" como entidades próprias do modelo; o grupo optou por representá-los como etapas do processo produtivo, e não como entidades independentes, para evitar granularidade excessiva no MER. Após a finalização do DER pelo grupo no Figma, algumas cardinalidades e nomes de relacionamentos ainda estão sendo revisados (ex.: cardinalidade entre Fornecedores e Matéria_Prima, e o nome de um relacionamento entre Expedição e Veículo).|
| **Justificativa da escolha final** | A organização por categorias (Entidades/Processos/Regras) facilitou a transição direta desse levantamento para o MER e o dicionário de dados, mantendo rastreabilidade da fala original de onde cada regra foi extraída. |
| **Reflexão crítica** | Como a IA apenas reorganiza e não valida o conteúdo, cabe ao grupo confirmar que nenhuma informação foi mal interpretada na reorganização — por exemplo, distinguir corretamente entre regras aplicáveis a "faturamento" e a "retirada com pagamento à vista", que têm condições diferentes. |

### 6.2 Apoio à elaboração do script SQL — Entrega 2

| Item | Registro de utilização |
|---|---|
| **Ferramenta e etapa** | **ChatGPT (OpenAI)** — apoio à criação e organização de consultas em `script (1).sql`, especialmente consultas **gerenciais G01–G13** e de **auditoria A01–A06**. |
| **Motivação** | Estruturar perguntas de gestão e verificações de regras de negócio utilizando dados de pedidos, itens, clientes, produção, máquinas, matérias-primas, estoque e entregas. |
| **Solicitações à IA** | Formulação de consultas para identificar falta de produtos e de matérias-primas, prazos de entrega, cancelamentos, faturamento por período, paradas de máquinas e inconsistências de integridade. **O texto literal dos prompts usados na criação dessas consultas não integra os registros disponíveis nesta documentação.** |
| **Resposta obtida** | Expressões SQL com `SELECT`, `JOIN`, `GROUP BY`, agregações, subconsultas e condições de verificação, organizadas em dois conjuntos: consultas gerenciais e consultas de auditoria. |
| **Materiais de referência** | Requisitos, regras de negócio e estruturas de tabelas da JV Indústria, além do enunciado da Entrega 2. |
| **Análise crítica** | Consultas sugeridas por IA podem apresentar divergências entre regras operacionais e campos disponíveis. Sua aplicação requer conferência de chaves, filtros, cálculos e resultados no MySQL. |
| **Resultado incorporado** | Conjunto de **13 consultas gerenciais** e **6 consultas de auditoria**, identificadas pelos códigos **G01–G13** e **A01–A06**, presentes no script da Entrega 2. |

### 6.3 Apoio à elaboração do README.md — Entrega 2

| Item | Registro de utilização |
|---|---|
| **Ferramenta e etapa** | **ChatGPT (OpenAI)** — elaboração e revisão do relatório técnico em Markdown, com apoio à organização das seções e compatibilização das descrições com o arquivo SQL. |
| **Motivação** | Seguir a estrutura exigida pelo professor, aproveitar a documentação da Entrega 1 e incorporar as informações complementares da entrevista. |
| **Prompts utilizados** | “faça baseado nisso tambem”; “e essa sera uma segunda verção do readme.me”; “não mexa no script.sql não altere nada dele”; “tira as partes de ‘Comentario’ como se estivese dizendo o que você(o chat Gpt) está fazendo e atualiza a parte do script.sql para esse aquirvo [...]”. |
| **Resposta obtida** | Organização das seções de caracterização, requisitos, regras, modelagem lógica, normalização, consultas, massa de dados, arquitetura analítica, documentação e apresentação final. |
| **Fontes utilizadas** | README da Entrega 1, DER conceitual, arquivo `script (1).sql`, esqueleto e slides de orientação da Entrega 2 e informações da entrevista. |
| **Adaptações e decisões** | Adequação dos códigos de problemas (**P1–P6**), regras (**RN01–RN10**) e consultas (**G01–G13** e **A01–A06**) aos identificadores do SQL utilizado; separação entre controles implementados e procedimentos externos. |
| **Reflexão crítica** | A IA auxilia a produzir texto e organizar a implementação, mas pode descrever relações ou funcionalidades inexistentes. A correspondência entre o README, as tabelas do SQL e o processo observado é o critério principal de revisão. |

---

# 7. Apresentação Corporativa Final

A apresentação executiva está estruturada como um **pitch de 8 minutos**, seguido pela defesa oral do modelo lógico, conforme os critérios da disciplina.

| Etapa | Tempo previsto | Conteúdo |
|---|---:|---|
| **1. O problema da organização** | 1 min | Porte da JV Indústria e necessidades P1–P6 relacionadas à produção, estoque, prazos e gestão. |
| **2. A solução proposta** | 45 s | Integração dos dados comerciais, operacionais e logísticos por banco relacional. |
| **3. O modelo lógico** | 1 min 15 s | Estrutura de 20 tabelas, relacionamentos, PKs, FKs e tabelas associativas. |
| **4. O SQL rodando** | 1 min 15 s | Demonstração das tabelas, da massa fictícia e de comandos SQL no MySQL. |
| **5. Consultas gerenciais e de auditoria** | 1 min 45 s | Exemplos de **G03** (estoque), **G06** (pontualidade), **A02** (pedidos sem itens) e **A05** (máquina não homologada). |
| **6. Potencial para BI e IA** | 1 min | Indicadores, painéis de acompanhamento e análises preditivas possíveis. |
| **7. Benefícios para a decisão** | 1 min | Identificação de riscos de abastecimento, atrasos, paradas, cancelamentos e desempenho comercial. |
| **Total** | **8 min** | A defesa do modelo acontece após a apresentação. |

O banco relacional oferece informações estruturadas para acompanhar o funcionamento da JV Indústria e fundamentar decisões sobre insumos, produção, estoque e atendimento aos clientes. As consultas gerenciais transformam registros em indicadores, enquanto as consultas de auditoria identificam situações que precisam de avaliação. A integração dos dados constitui também uma base para futuras soluções de BI e IA.
