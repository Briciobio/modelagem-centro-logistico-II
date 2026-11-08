# Levantamento de requisitos do sistema

## Cadastro de clientes

### 1. Quais dados são usados para o cadastro de um cliente?

São cadastrados:

-   Nome ou razão social;
-   CPF ou CNPJ;
-   Endereço;
-   Telefone;
-   E-mail.

### 2. Existem limitações para os clientes na hora do pedido?

Sim. Para pedidos com faturamento, o cliente precisa estar com o nome
limpo, sem restrições, e o pedido deve ter valor mínimo de R\$ 800,00.

Para pagamento à vista e retirada pelo próprio cliente, não há essas
restrições.

### 3. Como é feita a verificação de restrições do cliente?

A checagem é realizada manualmente no site do Serasa.

Não foi informado se o resultado dessa consulta é registrado no sistema
por meio de integração ou apenas pelo operador.

## Pedidos

### 4. Quais informações são registradas em um pedido?

A quantidade solicitada pelo cliente é registrada no pedido.

Também é possível identificar o produto solicitado por sua descrição ou
por seu código interno.

### 5. Quais informações são consultadas para localizar um pedido?

Não foi informado exatamente quais campos são utilizados para a busca.
Sabe-se que os produtos podem ser identificados por descrição ou código
interno.

É necessário confirmar se o pedido também possui número, cliente, data
ou outros campos utilizados para localização.

### 6. Os pedidos possuem status?

Sim. O pedido possui status.

Inicialmente, ele fica como orçamento enquanto está em produção e
posteriormente passa a ser considerado pedido faturado quando o cliente
vem retirar.

### 7. Os pedidos possuem data e número de identificação?

Não foi informado se existe um número único de identificação do pedido
nem quais datas são registradas.

### 8. Os pedidos podem ser alterados ou cancelados?

Sim. Os pedidos podem ser alterados ou cancelados, desde que isso seja
informado com antecedência suficiente para que a produção ainda não
tenha sido iniciada.

### 9. O que acontece se um pedido for cancelado depois que as matérias-primas já foram separadas?

Não foi informado especificamente o procedimento para matérias-primas
separadas, mas foi informado que, em determinados casos de cancelamento,
o produto acabado permanece em estoque para ser entregue posteriormente.

Esse caso é raro e ocorre principalmente com grandes clientes que
possuem pedidos mensais e suspendem temporariamente uma entrega.

### 10. Um pedido pode ser atendido por mais de um lote?

Sim.

Quando a quantidade solicitada é maior que a capacidade da máquina, são
realizadas várias produções, cada uma com sua própria fórmula e lote.

Por exemplo: se uma máquina tem capacidade de 3 toneladas e o cliente
solicita 1.200 baldes de 25 kg, podem ser necessárias 10 fórmulas e 10
lotes diferentes.

## Produtos e fórmulas

### 11. Como os produtos são identificados no sistema?

Os produtos podem ser identificados pela:

-   Descrição do produto;
-   Código interno.

### 12. Quais atributos identificam um produto?

Foi informado que a identificação ocorre principalmente pela descrição e
pelo código interno.

Existem também informações relacionadas à embalagem, fórmula, lote e
validade durante o processo produtivo.

### 13. Cada produto possui uma fórmula própria?

Sim. Cada produto possui sua própria fórmula, que não muda.

### 14. Um produto pode ter mais de uma fórmula?

Não foi indicado que um mesmo produto tenha fórmulas diferentes. A
informação fornecida é que cada produto possui sua fórmula própria e
fixa.

### 15. O que a fórmula contém?

A fórmula contém a descrição, item por item, das matérias-primas
utilizadas para produzir o produto final.

O sistema consegue mostrar tudo o que foi utilizado na produção por meio
do cadastro da fórmula.

### 16. O sistema consegue informar quais matérias-primas foram utilizadas em uma produção?

Sim. O sistema mostra os itens utilizados na fabricação do produto,
conforme a fórmula cadastrada.

## Matérias-primas e fornecedores

### 17. Como as matérias-primas entram no sistema?

As matérias-primas entram no sistema por meio da importação do XML da
nota fiscal do fornecedor.

### 18. É necessário cadastrar os fornecedores?

Sim. Os fornecedores precisam ser cadastrados.

### 19. É necessário controlar o preço de custo dos insumos?

Sim. O cadastro dos fornecedores é necessário também para controlar os
preços dos insumos.

### 20. O consumo da fórmula é sempre exato?

O consumo é calculado de acordo com a quantidade necessária para
fabricar o pedido.

Podem ocorrer perdas ou desperdícios, mas são considerados mínimos, pois
a quantidade utilizada é bem calculada para a fabricação do pedido.

Não foi informado, porém, como essas perdas são registradas no sistema.

## Produção

### 21. Como é organizada a produção?

A produção segue, de forma geral, estas etapas:

1.  Separação das matérias-primas;
2.  Envio das matérias-primas para a máquina batedora;
3.  Mistura dos componentes;
4.  Envio da mistura para a máquina responsável pelo produto;
5.  Envase do produto;
6.  Liberação do produto;
7.  Organização nos pallets;
8.  Aplicação do stretch;
9.  Envio para a expedição;
10. Baixa dos componentes da fórmula;
11. Entrada do produto acabado no estoque.

### 22. Quais informações são registradas quando uma produção acontece?

Cada produção recebe:

-   Número da produção;
-   Lote;
-   Data de fabricação;
-   Validade dos produtos;
-   Informações relacionadas à fórmula utilizada.

### 23. A produção possui número de identificação?

Sim. Toda produção recebe um número próprio.

### 24. A produção possui lote?

Sim. Cada produção recebe um lote.

### 25. Como o lote é gerado?

O lote é gerado manualmente, mas segue uma sequência previamente
estabelecida para cada cliente.

Cada cliente possui sua própria sequência de lotes, o que ajuda a manter
o padrão e facilitar a identificação de possíveis problemas de
qualidade.

### 26. Para que serve o controle de lote?

O controle de lote facilita:

-   A identificação dos produtos;
-   A identificação de produtos eventualmente avariados;
-   A investigação de possíveis problemas de qualidade;
-   O rastreamento em caso de reclamação.

Além disso, são retiradas amostras de cada lote, que ficam retidas para
análise caso exista alguma reclamação.

### 27. A produção registra a data de fabricação?

Sim. A data de fabricação é registrada.

Também é registrada a validade do produto.

### 28. Como a capacidade das máquinas influencia a produção?

Cada máquina possui uma capacidade determinada.

Quando a quantidade do pedido ultrapassa a capacidade da máquina, é
necessário dividir a produção em várias fórmulas/produções, cada uma com
um lote diferente.

## Relação entre pedidos, fórmulas e produção

### 29. Como é a relação entre produção e pedido?

A produção é realizada para atender à quantidade solicitada no pedido.

A fórmula determina a quantidade de matérias-primas e embalagens
necessárias para produzir a quantidade solicitada.

### 30. Um pedido grande pode gerar várias produções?

Sim. Caso a quantidade solicitada seja maior que a capacidade da
máquina, o pedido é dividido em várias produções.

Cada produção terá sua própria fórmula/lote.

### 31. O sistema consegue informar qual pedido gerou determinada produção?

Não foi respondido explicitamente.

Pelas informações fornecidas, existe uma relação entre pedido, fórmula e
produção, mas é necessário confirmar se o sistema mantém essa relação de
forma rastreável, permitindo consultar qual pedido originou determinada
produção.

## Embalagens

### 32. Os produtos são vendidos e armazenados em embalagens padronizadas?

Sim. Os produtos são vendidos e armazenados em embalagens padrão.

Exemplos:

-   Baldes de 18 L;
-   Latas de 18 L;
-   Barricas de 25 kg;
-   Baldes de 25 kg;
-   Galões de 3,6 L;
-   Potes de 1 kg.

### 33. Como o cliente informa a quantidade que deseja comprar?

O cliente solicita a quantidade por unidade de embalagem.

A fórmula determina automaticamente a quantidade em kg e a quantidade de
embalagens necessárias para realizar a produção do pedido.

## Estoques

### 34. Como funciona o controle de estoque?

Após a produção, é realizada a baixa das matérias-primas utilizadas na
fórmula e o produto acabado entra automaticamente no estoque do sistema.

### 35. Como é possível consultar a quantidade disponível de um produto?

Ao informar o código do produto, o sistema apresenta a quantidade
disponível em estoque.

A quantidade também é apresentada durante a emissão da nota fiscal,
quando o item é selecionado.

### 36. Quais informações são consultadas para saber quanto produto existe no estoque?

Principalmente o código do produto, que permite consultar a quantidade
disponível.

### 37. Quais são os estoques existentes?

Pelas informações fornecidas, é possível identificar pelo menos:

-   Estoque de matérias-primas/insumos, que recebe os materiais
    utilizados na produção;
-   Estoque de produtos acabados, que recebe os produtos após a
    fabricação e liberação.

Não foi informado se existem outros estoques separados, como estoque de
produtos em processo, embalagens ou produtos avariados.

### 38. O que é armazenado como informação no estoque?

Para os produtos acabados, são controlados principalmente:

-   Produto;
-   Quantidade;
-   Lote;
-   Validade;
-   Data de fabricação.

Também existe a informação dos insumos utilizados na produção por meio
da fórmula.

### 39. Como os estoques se relacionam com a produção?

Quando a produção acontece, os componentes utilizados na fórmula são
baixados e o produto acabado é incluído no estoque.

### 40. O sistema consegue responder "de onde veio esse produto que está no estoque?"

Há informações de lote, produção, fórmula e matérias-primas utilizadas,
o que permite rastreabilidade.

Entretanto, não foi confirmado explicitamente se o sistema permite
consultar diretamente, a partir de um produto em estoque, a produção que
o originou.

## Expedição, nota fiscal e entrega

### 41. Como funciona a expedição?

Após o produto ser liberado:

1.  Ele é colocado no pallet;
2.  Recebe o stretch;
3.  É encaminhado para a expedição;
4.  O produto acabado fica disponível no estoque;
5.  Posteriormente ocorre a retirada ou entrega ao cliente.

### 42. Como são realizadas as entregas?

São utilizados dois modelos:

-   Frota própria para entregas dentro do Estado de São Paulo;
-   Transportadoras terceirizadas para entregas no restante do país.

### 43. Quais informações de transporte são registradas?

As informações sobre transporte ficam apenas no rodapé da nota fiscal.

Foi informado que não é mencionado o valor do frete na nota.

Não foi informado se o sistema controla separadamente placa do veículo,
motorista e transportadora.

### 44. O que acontece na emissão da nota fiscal?

Na emissão da nota, o sistema identifica o item e apresenta a quantidade
existente em estoque.

## Usuários e controle de acesso

### 45. Quais são os perfis de usuários do sistema?

Os usuários são divididos conforme os setores:

-   Funcionários da separação de matérias-primas;
-   Funcionários de cada máquina da linha de produção;
-   Funcionários da expedição;
-   ADM.

### 46. Todos os usuários podem acessar todas as áreas do sistema?

Não.

Cada usuário acessa somente o seu respectivo setor e é bloqueado para
acessar os demais.

### 47. O sistema registra quem realizou cada operação?

Sim.

Cada usuário possui um cadastro pessoal com login e senha próprios.

Quando o sistema é utilizado, fica registrado no rodapé qual usuário
realizou a operação naquele setor.

### 48. Existe histórico/auditoria das operações?

Sim, existe identificação do usuário que utilizou o sistema por meio de
seu login e senha.

Não foi especificado, porém, quais operações ficam armazenadas no
histórico nem por quanto tempo esses registros são mantidos.

## Rastreabilidade

### 49. Quais registros precisam estar relacionados entre si?

Com base nas informações fornecidas, é importante relacionar pelo menos:

**Cliente → Pedido → Produto → Fórmula → Produção → Lote →
Matérias-primas → Estoque → Expedição/Nota**

Essa relação permite acompanhar o produto desde o pedido até sua
produção, armazenamento e entrega.

### 50. Se for perguntado "qual pedido gerou essa produção?", o sistema consegue mostrar?

Não foi confirmado explicitamente. Essa relação deve ser validada.

### 51. Se for perguntado "quais matérias-primas foram usadas nessa produção?", o sistema consegue mostrar?

Sim. O sistema possui a fórmula cadastrada com a descrição dos itens
utilizados para produzir o produto final.

### 52. Se for perguntado "de onde veio esse produto que está no estoque?", o sistema consegue mostrar?

Existem dados de produção, lote, fórmula e matérias-primas, portanto há
informações para rastreabilidade. Porém, não foi confirmado se o sistema
permite fazer essa consulta diretamente a partir do estoque.

## Pontos que ainda precisam ser confirmados

As respostas fornecidas deixam alguns requisitos importantes em aberto:

-   O pedido possui número único de identificação?
-   O pedido registra data de criação, alteração, produção, faturamento
    e cancelamento?
-   Quais campos podem ser usados para pesquisar/localizar um pedido?
-   Existe uma relação direta entre pedido e ordem/produção?
-   É possível consultar qual pedido originou determinado lote?
-   É possível consultar qual produção originou determinado produto em
    estoque?
-   Como são registradas as perdas/desperdícios de matérias-primas?
-   Se matérias-primas forem separadas e o pedido for cancelado, elas
    voltam automaticamente ao estoque?
-   Existem estoques separados para matéria-prima, produto em processo,
    produto acabado, embalagens e produtos avariados?
-   O sistema controla motorista, placa e transportadora ou apenas
    imprime essas informações na nota?
-   Como é registrada a aprovação do faturamento?
-   O sistema mantém histórico de alterações e cancelamentos de pedidos?
-   Quem pode alterar ou encerrar uma fórmula?
-   A checagem do Serasa fica registrada no sistema ou é apenas
    realizada externamente?
-   Como é controlada a validade dos lotes?
-   Como é registrada a amostra retida de cada lote?
-   O sistema controla a quantidade em unidades e também em kg/litros?
-   Como são tratadas diferenças entre a quantidade planejada e a
    quantidade efetivamente produzida?

------------------------------------------------------------------------

# Informações complementares --- respostas adicionais

As informações abaixo foram fornecidas posteriormente e complementam o
levantamento anterior. Elas foram organizadas em perguntas e respostas,
mantendo o sentido das respostas recebidas.

## Máquinas, produtos, entregas e produção

### 53. Uma máquina pode fabricar mais de um tipo de produto?

Sim.

### 54. Um produto pode possuir mais de uma apresentação de embalagem?

Sim.

### 55. Uma entrega pode transportar produtos de vários pedidos?

Sim.

### 56. O sistema cadastra veículos e motoristas?

Sim.

### 57. Uma produção pode atender a mais de um pedido?

Sim.

## Lotes e armazenamento

### 58. Um lote pode ser armazenado em locais diferentes?

Os produtos de um mesmo lote ficam armazenados juntos, pois são
destinados ao mesmo cliente e devem ser entregues juntos, no mesmo
pedido.

### 59. Uma matéria-prima pode estar distribuída em mais de um estoque?

Não. Cada matéria-prima é armazenada sempre no mesmo lugar, pois possui
um local definido para evitar erros na separação. Cada uma é
identificada e armazenada sempre no mesmo local.

## Manutenção

### 60. O sistema registra quem realizou cada manutenção?

Não. A manutenção é terceirizada e não é registrada no sistema; as
informações ficam em uma pasta.

A cada manutenção, o mecânico precisa preencher uma ficha informando:

-   Em qual equipamento foi realizada a manutenção;
-   O que foi utilizado para o reparo;
-   Qual defeito foi encontrado.

## Notas fiscais e pedidos

### 61. Uma nota fiscal pode conter mais de um pedido?

Sim. Embora os clientes prefiram enviar um número de pedido diferente
para cada nota fiscal, o sistema permite utilizar vários pedidos em uma
mesma nota.

Para isso, basta mencionar o número do pedido no campo **"Número de
pedido do cliente"** após a inclusão de cada item.

## Compra de embalagens e entrada de materiais

### 62. O sistema controla a compra de embalagens separadamente?

A compra não é feita pelo sistema. Ela é realizada diretamente por
e-mail.

Quando a matéria-prima chega, é dada entrada no sistema e ela fica
armazenada no setor de almoxarifado.

Após o produto ficar pronto, ele é transferido do estoque para a
expedição.

## Observação sobre a operação do sistema

Foi relatado que apenas uma pessoa sabe operar o sistema. Em uma
situação problemática, essa pessoa precisou resolver a questão sozinha e
acabou trabalhando no sábado e no domingo.
