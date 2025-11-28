-- Inner Join entre as tabelas clientes, pedidos e produtos

-- Código 1
SELECT id_cliente, nome_cliente -- Seleciona dados dos clientes
FROM clientes -- da tabela clientes
INNER JOIN pedidos -- Faz o Inner Join com a tabela pedidos
ON pedidos.cod_cliente=clientes.id_cliente -- Condição de junção onde o código do cliente em pedidos é igual ao id do cliente em clientes
INNER JOIN produtos -- Faz o Inner Join com a tabela produtos
ON pedidos.cod_produto=produtos.nome_produto; -- Condição de junção onde o código do produto em pedidos é igual ao nome do produto em produtos

-- Código 2

SELECT pedidos.id_pedido, produtos.nome_produto, pedidos.qtde -- Seleciona dados dos pedidos e produtos
FROM pedidos -- da tabela pedidos
INNER JOIN produtos -- Faz o Inner Join com a tabela produtos
ON pedidos.cod_produto=produtos.id_produto; -- Condição de junção onde o código do produto em pedidos é igual ao id do produto em produtos

-- Código 3

SELECT PE.id_pedido, PR.nome_produto, CL.nome_cliente -- Seleciona dados dos pedidos, produtos e clientes
FROM pedidos PE -- da tabela pedidos com alias PE
INNER JOIN produtos PR -- Faz o Inner Join com a tabela produtos com alias PR
ON PE.cod_produto=PR.id_produto -- Condição de junção onde o código do produto em pedidos é igual ao id do produto em produtos
INNER JOIN clientes CL -- Faz o Inner Join com a tabela clientes com alias CL
ON PE.cod_produto=CL.id_cliente -- Condição de junção onde o código do produto em pedidos é igual ao id do cliente em clientes
WHERE CL.id_cliente = 1; -- Filtra os resultados para o cliente com id 1
