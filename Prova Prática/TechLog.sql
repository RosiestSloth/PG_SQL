CREATE DATABASE TechLog; -- Criação da base de dados Comente a linha caso dê erro de criação

CREATE SCHEMA IF NOT EXISTS provapratica;

SET search_path TO provapratica, public;

-- 2.1. Tabela de Clientes
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome_cliente VARCHAR(200) NOT NULL,
    email_cliente VARCHAR(100) NOT NULL UNIQUE,
    data_cadastro TIMESTAMP WITHOUT TIME ZONE 
);

-- 2.2. Tabela de Produtos
CREATE TABLE produtos (
    id_produto SERIAL PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    preco_unitario NUMERIC(10, 2) NOT NULL CHECK (preco_unitario >= 0.01),
    qtde_estoque INTEGER NOT NULL CHECK (qtde_estoque >= 0)
);

-- 2.3. Tabela de Pedidos (Master)
CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL REFERENCES clientes(id_cliente),
    data_pedido TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    status_pedido VARCHAR(50) NOT NULL DEFAULT 'PENDENTE' 
        CHECK (status_pedido IN ('PENDENTE', 'PROCESSANDO', 'ENVIADO', 'ENTREGUE', 'CANCELADO')),
    valor_total NUMERIC(10, 2) NOT NULL DEFAULT 0.00
);

-- 2.4. Tabela de Itens do Pedido (Detalhe)
CREATE TABLE itens_pedido (
    id_item SERIAL PRIMARY KEY,
    id_pedido INTEGER NOT NULL REFERENCES pedidos(id_pedido),
    id_produto INTEGER NOT NULL REFERENCES produtos(id_produto),
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_venda NUMERIC(10, 2) NOT NULL,
    UNIQUE (id_pedido, id_produto) 
);

-- 3.1. Inserção de Clientes
INSERT INTO clientes (nome_cliente, email_cliente) VALUES
('Ana Silva', 'ana.silva@email.com'),
('Bruno Costa', 'bruno.c@email.com'),
('Carla Diniz', 'carla.d@email.com');

-- 3.2. Inserção de Produtos
INSERT INTO produtos (nome_produto, preco_unitario, qtde_estoque) VALUES
('Webcam HD 1080p', 120.50, 50),
('Mouse Sem Fio Ergonomico', 45.00, 150),
('Teclado Mecânico RGB', 350.99, 30),
('Monitor LED 27 polegadas', 1199.00, 10);

-- 3.3. Inserção de Pedidos (depende dos IDs de clientes)
INSERT INTO pedidos (id_cliente, status_pedido, valor_total) VALUES
(1, 'ENTREGUE', 165.50), 
(2, 'PROCESSANDO', 350.99), 
(1, 'PENDENTE', 1199.00), 
(3, 'ENVIADO', 45.00);

-- 3.4. Inserção de Itens do Pedido (depende dos IDs de pedidos e produtos)
-- Pedido 1 (Ana):
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_venda) VALUES
(1, 2, 1, 45.00),   
(1, 1, 1, 120.50);  

-- Pedido 2 (Bruno):
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_venda) VALUES
(2, 3, 1, 350.99); 

-- Pedido 3 (Ana):
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_venda) VALUES
(3, 4, 1, 1199.00);

-- Pedido 4 (Carla):
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_venda) VALUES
(4, 2, 1, 45.00);

SELECT 
    nome_produto,
    preco_unitario,
    qtde_estoque
FROM 
    produtos
WHERE 
    preco_unitario > 100.00
ORDER BY 
    preco_unitario DESC;

CREATE VIEW "provapratica".vw_pedidos
 AS
SELECT
		p.id_pedido,
		c.nome_cliente,
		p.data_pedido,
		p.status_pedido,
		p.valor_total
	FROM 
		pedidos p
	INNER JOIN 
		clientes c ON p.id_cliente = c.id_cliente
	WHERE
		p.status_pedido NOT IN ('ENTREGUE', 'CANCELADO')
	ORDER BY 
		p.data_pedido;

ALTER TABLE "provapratica".vw_pedidos
    OWNER TO postgres;
	
SELECT * FROM "provapratica".vw_pedidos;

-- Transations 
BEGIN;

    -- 1. Inserção de um Novo Produto
    INSERT INTO produtos (nome_produto, preco_unitario, qtde_estoque) 
    VALUES ('Cadeira Gamer Ergonômica', 899.90, 5) 
    RETURNING id_produto; -- ID 5 será retornado

    -- 2. Atualização de Estoque de um Produto Existente (Mouse)
    UPDATE produtos
    SET qtde_estoque = qtde_estoque - 50 -- Reduz 50 unidades
    WHERE nome_produto = 'Mouse Sem Fio Ergonomico';

-- Se as operações acima foram bem-sucedidas, confirma:
COMMIT;

-- Transação de inserção de produto
BEGIN;

    -- 1. Inserção de um Novo Produto
    INSERT INTO produtos (nome_produto, preco_unitario, qtde_estoque) 
    VALUES ('Cadeira Gamer Ergonômica', 899.90, 5) 
    RETURNING id_produto; -- ID 5 será retornado

    -- 2. Atualização de Estoque de um Produto Existente (Mouse)
    UPDATE produtos
    SET qtde_estoque = qtde_estoque - 50 -- Reduz 50 unidades
    WHERE nome_produto = 'Mouse Sem Fio Ergonomico';

-- Se as operações acima foram bem-sucedidas, confirma:
ROLLBACK;

SELECT * FROM vw_pedidos; -- Seleciona a view de pedidos
