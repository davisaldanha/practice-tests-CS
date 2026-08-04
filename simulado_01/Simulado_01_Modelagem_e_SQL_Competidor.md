# Simulado Cronometrado nº 1
## Modelagem de Dados Avançada e SQL — Fechamento da Semana 1
### Duração total: 2 horas | Sem consulta a material teórico

---

## 1. Instruções gerais para o aluno

Este simulado avalia sua capacidade de modelar um sistema a partir de um caso de negócio e de escrever SQL avançado com correção e eficiência, dentro de um tempo limitado — as duas competências trabalhadas na Semana 1.

**Entregáveis esperados ao final das 2h:**
1. Documento (texto ou diagrama) com o modelo entidade-relacionamento da Parte 1, notação livre (Crow's Foot ou textual), DDL físico final e uma justificativa curta de normalização.
2. Arquivo `.sql` com as 10 consultas da Parte 2, testadas e funcionando no banco fornecido.

Priorize **entregar tudo funcional**, mesmo que de forma mais simples, a tentar a solução perfeita e não terminar. Gestão de tempo é um dos critérios avaliados.

---

## 2. Parte 1 — Caso de Modelagem (sugestão: 60 minutos)

### Estudo de caso: AutoCenter Prime — Oficina Mecânica Multimarcas

A AutoCenter Prime é uma oficina mecânica que atende clientes pessoa física e deseja informatizar sua gestão. Você foi contratado(a) para modelar o banco de dados do sistema. Leia atentamente o enunciado — algumas regras de negócio estão implícitas e fazem parte do desafio identificá-las.

> A oficina atende **clientes**, que podem possuir **um ou mais veículos** cadastrados (placa, modelo, marca, ano, cor). Um veículo pertence a apenas um cliente por vez, mas pode trocar de dono ao longo do tempo (o histórico de donos anteriores não precisa ser mantido nesta primeira versão).
>
> Quando um cliente traz um veículo para manutenção, é aberta uma **ordem de serviço (OS)**, contendo data de abertura, data de conclusão prevista, data de conclusão real e status (Aberta, Em andamento, Aguardando peça, Concluída, Cancelada). Uma OS está sempre associada a exatamente um veículo.
>
> Cada OS pode conter **vários serviços realizados** (ex.: troca de óleo, alinhamento, revisão de freios), cada um com seu próprio valor de mão de obra, e também pode consumir **várias peças do estoque**, cada uma com quantidade utilizada e preço no momento da utilização (o preço pode mudar depois, mas a OS deve manter o valor cobrado na época).
>
> Os **serviços** oferecidos pela oficina fazem parte de um catálogo fixo (nome do serviço, tempo médio estimado, valor padrão de mão de obra), que pode ser reaproveitado em várias OS.
>
> As **peças** ficam no estoque, cada uma vinculada a um único **fornecedor principal**, com controle de quantidade disponível e preço de custo atual. Um fornecedor pode fornecer diversas peças.
>
> Cada OS é executada por **um ou mais mecânicos**. Cada mecânico tem uma ou mais **especialidades** (ex.: motor, elétrica, funilaria), e uma especialidade pode ser dominada por vários mecânicos. Os mecânicos possuem uma hierarquia interna: cada mecânico (exceto o mecânico-chefe) tem **um mecânico responsável/supervisor**, que também é um mecânico da própria oficina.
>
> Ao final do atendimento, o cliente pode deixar uma **avaliação** da OS (nota de 1 a 5 e comentário opcional). Nem toda OS recebe avaliação, e cada OS pode receber no máximo uma avaliação.

### O que entregar

**a) Lista de entidades** com seus atributos, indicando chave primária (PK) e chaves estrangeiras (FK).

**b) Diagrama ou representação textual do DER**, deixando claras as cardinalidades de cada relacionamento (1:1, 1:N, N:N) e identificando:
   - Pelo menos uma entidade associativa (para resolver um relacionamento N:N);
   - O autorrelacionamento (hierarquia de mecânicos);
   - Como você tratou a regra "a OS deve manter o valor da peça/serviço cobrado na época", mesmo que o preço mude depois.

**c) Justificativa de normalização (texto curto, 1 parágrafo por forma normal):** explique como seu modelo atende 1FN, 2FN e 3FN, citando pelo menos uma anomalia (de inserção, atualização ou exclusão) que seria criada se você tivesse modelado de forma denormalizada.

**d) Script DDL** (`CREATE TABLE`) do modelo físico final, com tipos de dados adequados, `PRIMARY KEY`, `FOREIGN KEY` e constraints relevantes (`NOT NULL`, `UNIQUE`, `CHECK` quando aplicável).

---

## 3. Parte 2 — SQL Avançado (sugestão: 60 minutos)

Use o banco de dados **`loja_analytics`**, já carregado no seu ambiente com o script abaixo (fornecido pelo treinador). Escreva e teste as 10 consultas solicitadas.

### Script de criação e carga (ambiente do aluno — já deve estar disponível)

```sql
CREATE DATABASE IF NOT EXISTS loja_analytics;
USE loja_analytics;

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome_categoria VARCHAR(100) NOT NULL,
    id_categoria_pai INT NULL,
    FOREIGN KEY (id_categoria_pai) REFERENCES categorias(id_categoria)
);

CREATE TABLE produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(150) NOT NULL,
    id_categoria INT NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque_atual INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    cidade VARCHAR(100),
    estado CHAR(2),
    data_cadastro DATE NOT NULL
);

CREATE TABLE funcionarios (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    id_supervisor INT NULL,
    salario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_supervisor) REFERENCES funcionarios(id_funcionario)
);

CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    data_pedido DATE NOT NULL,
    status VARCHAR(20) NOT NULL, -- 'Concluído', 'Cancelado', 'Pendente'
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE itens_pedido (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

CREATE TABLE avaliacoes (
    id_avaliacao INT PRIMARY KEY AUTO_INCREMENT,
    id_produto INT NOT NULL,
    id_cliente INT NOT NULL,
    nota INT NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario VARCHAR(255),
    data_avaliacao DATE NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Categorias (hierarquia de 3 níveis)
INSERT INTO categorias (id_categoria, nome_categoria, id_categoria_pai) VALUES
(1, 'Eletrônicos', NULL),
(2, 'Eletrodomésticos', NULL),
(3, 'Smartphones', 1),
(4, 'Notebooks', 1),
(5, 'Acessórios para Celular', 3),
(6, 'Geladeiras', 2);

-- Produtos
INSERT INTO produtos (id_produto, nome_produto, id_categoria, preco, estoque_atual) VALUES
(1, 'Smartphone Alpha X', 3, 2500.00, 20),
(2, 'Smartphone Alpha Lite', 3, 1500.00, 15),
(3, 'Capa Protetora Alpha', 5, 60.00, 100),
(4, 'Carregador Turbo 30W', 5, 90.00, 80),
(5, 'Notebook Pro 14', 4, 5200.00, 10),
(6, 'Notebook Basic 14', 4, 3200.00, 12),
(7, 'Geladeira Frost 400L', 6, 3800.00, 5),
(8, 'Geladeira Duplex 350L', 6, 3300.00, 6);

-- Clientes (Cliente 5 e 6 nunca compraram)
INSERT INTO clientes (id_cliente, nome, email, cidade, estado, data_cadastro) VALUES
(1, 'Ana Souza', 'ana@email.com', 'Fortaleza', 'CE', '2025-01-10'),
(2, 'Bruno Lima', 'bruno@email.com', 'Fortaleza', 'CE', '2025-02-15'),
(3, 'Carla Dias', 'carla@email.com', 'Recife', 'PE', '2025-03-05'),
(4, 'Diego Alves', 'diego@email.com', 'São Paulo', 'SP', '2025-01-20'),
(5, 'Elisa Melo', 'elisa@email.com', 'Fortaleza', 'CE', '2025-05-01'),
(6, 'Felipe Rocha', 'felipe@email.com', 'Recife', 'PE', '2025-06-10');

-- Funcionários (hierarquia: Diretor > Gerente > Vendedores)
INSERT INTO funcionarios (id_funcionario, nome, cargo, id_supervisor, salario) VALUES
(1, 'Marcos Diretor', 'Diretor', NULL, 15000.00),
(2, 'Paula Gerente', 'Gerente', 1, 9000.00),
(3, 'João Vendedor', 'Vendedor', 2, 3000.00),
(4, 'Rita Vendedora', 'Vendedor', 2, 3200.00);

-- Pedidos
INSERT INTO pedidos (id_pedido, id_cliente, data_pedido, status) VALUES
(1, 1, '2026-01-15', 'Concluído'),
(2, 1, '2026-02-10', 'Concluído'),
(3, 2, '2026-01-22', 'Concluído'),
(4, 2, '2026-03-01', 'Cancelado'),
(5, 3, '2026-02-18', 'Concluído'),
(6, 3, '2026-04-05', 'Concluído'),
(7, 3, '2026-05-12', 'Concluído'),
(8, 4, '2026-03-20', 'Concluído'),
(9, 1, '2026-05-25', 'Concluído'),
(10, 3, '2026-06-01', 'Concluído');

-- Itens de pedido
INSERT INTO itens_pedido (id_item, id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 1, 2500.00),
(2, 1, 3, 2, 60.00),
(3, 2, 4, 1, 90.00),
(4, 3, 5, 1, 5200.00),
(5, 4, 2, 1, 1500.00),
(6, 5, 7, 1, 3800.00),
(7, 6, 2, 2, 1500.00),
(8, 6, 3, 1, 60.00),
(9, 7, 8, 1, 3300.00),
(10, 8, 6, 1, 3200.00),
(11, 9, 1, 1, 2500.00),
(12, 10, 2, 1, 1500.00),
(13, 10, 4, 3, 90.00);

-- Avaliações (produtos 6, 7 e 8 nunca foram avaliados)
INSERT INTO avaliacoes (id_avaliacao, id_produto, id_cliente, nota, comentario, data_avaliacao) VALUES
(1, 1, 1, 5, 'Excelente aparelho', '2026-01-20'),
(2, 1, 4, 4, 'Muito bom', '2026-03-25'),
(3, 2, 2, 3, 'Bateria mediana', '2026-01-30'),
(4, 5, 3, 5, 'Ótimo para trabalho', '2026-02-25'),
(5, 3, 3, 4, NULL, '2026-02-20');
```

### As 10 consultas

Escreva uma consulta SQL para cada item. Quando fizer sentido, use `AS` para nomear colunas calculadas de forma clara.

1. Liste os pedidos com status **'Concluído'**, mostrando nome do cliente, nome do produto, quantidade e valor total do item (`quantidade × preco_unitario`).

2. Liste **todos** os clientes (inclusive os que nunca compraram), mostrando a quantidade total de pedidos concluídos e o valor total gasto (0 para quem nunca comprou), ordenado do maior para o menor gasto.

3. Liste os produtos cujo preço está **acima da média de preço da sua própria categoria** (subquery correlacionada).

4. Usando uma **CTE recursiva**, liste a hierarquia completa de categorias (nome da categoria, nome da categoria pai — se houver — e o nível de profundidade: 0 para raiz, 1 para filha, 2 para neta).

5. Para **cada categoria**, identifique o produto mais vendido (maior soma de `quantidade` em `itens_pedido`, considerando apenas pedidos concluídos), usando `RANK()` ou `ROW_NUMBER()` com `PARTITION BY`. Retorne apenas o 1º colocado de cada categoria.

6. Liste os clientes que fizeram **mais de 2 pedidos concluídos**, mostrando a quantidade de pedidos e o ticket médio (valor médio por pedido), usando `GROUP BY` e `HAVING`.

7. Liste todos os funcionários com o **nome do seu supervisor** (autorrelacionamento/self join), garantindo que o Diretor apareça mesmo sem supervisor.

8. Liste os produtos que **nunca foram avaliados** (use `NOT EXISTS` ou `LEFT JOIN`/`IS NULL`).

9. Calcule o **total de vendas por mês** (considerando pedidos concluídos) e o **total acumulado (running total)** ao longo dos meses, usando uma window function (`SUM() OVER (ORDER BY ...)`).

10. Gere um relatório de **total vendido por categoria**, incluindo uma linha de **subtotal geral**, usando `GROUP BY ... WITH ROLLUP` (MySQL) ou `GROUP BY ROLLUP(...)` (PostgreSQL).