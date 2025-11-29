-- View que mostra as vendas realizadas, incluindo cliente, produto, quantidade, pedido e fatura

CREATE OR REPLACE VIEW vendas AS -- Cria ou substitui a view chamada vendas
	SELECT CL.nome_cliente AS Cliente, PR.nome_produto AS Produto, PE.qtde AS Quantidade, PE.id_pedido AS Pedido, PR.preco * PE.qtde AS Fatura -- Seleciona o nome do cliente, nome do produto, quantidade, id do pedido e calcula a fatura
	FROM pedidos PE -- da tabela pedidos com alias PE
	INNER JOIN Clientes CL -- Faz o Inner Join com a tabela clientes com alias CL
	ON PE.cod_cliente = CL.id_cliente -- Condição de junção onde o código do cliente em pedidos é igual ao id do cliente em clientes
	INNER JOIN Produtos PR -- Faz o Inner Join com a tabela produtos com alias PR
	ON PE.cod_produto = PR.id_produto; -- Condição de junção onde o código do produto em pedidos é igual ao id do produto em produtos

SELECT Cliente, SUM(Fatura) -- Seleciona o cliente e a soma das faturas
FROM vendas -- da view vendas
GROUP BY Cliente; -- Agrupa os resultados pelo cliente

ALTER VIEW vendas RENAME TO faturas; -- Renomeia a view vendas para faturas

SELECT * FROM faturas; -- Seleciona todos os dados da view faturas

DROP VIEW IF EXISTS faturas CASCADE; -- Remove a view faturas se existir, junto com dependências