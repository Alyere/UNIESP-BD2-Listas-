
-- LISTA 02: SUBQUERIES E CTEs




-- Questão 1: 
SELECT nome AS cliente
FROM clientes 
WHERE id IN (
    -
    SELECT v.cliente_id 
    FROM vendas v
    INNER JOIN itens_venda iv ON v.id = iv.venda_id
    INNER JOIN produtos p ON iv.produto_id = p.id
    WHERE p.nome ILIKE '%ração%'
);                 



-- Questão 2:

-- 
UPDATE vendas SET valor_total = 132.00 WHERE cliente_id = 20; 
UPDATE vendas SET valor_total = 350.00 WHERE cliente_id = 21; 

-- 2. 
WITH MediaCompras AS (
    SELECT cliente_id, AVG(valor_total) AS media_gasta
    FROM vendas
    GROUP BY cliente_id
)
SELECT 
    c.nome AS cliente, 
    m.media_gasta
FROM clientes c
INNER JOIN MediaCompras m ON c.id = m.cliente_id
WHERE CAST(m.media_gasta AS DECIMAL) > 200.00;                      


-- Questão 3: 
SELECT p.nome AS produto, total.qtd_vendida
FROM produtos p
INNER JOIN (
    SELECT produto_id, SUM(quantidade) AS qtd_vendida
    FROM itens_venda
    GROUP BY produto_id
) AS total ON p.id = total.produto_id
WHERE total.qtd_vendida > 2;                                          



-- Questão 4: 
WITH TotalAgendamentos AS (
    SELECT servico_id, COUNT(*) AS qtd
    FROM agendamentos 
    GROUP BY servico_id
)
SELECT s.nome AS servico, t.qtd AS total_agendado
FROM servicos s
INNER JOIN TotalAgendamentos t ON s.id = t.servico_id
ORDER BY t.qtd DESC 
LIMIT 3;                                      



-- Questão 5: 
WITH GastoPorCliente AS (
    SELECT cliente_id, SUM(valor_total) AS total_gasto FROM vendas GROUP BY cliente_id
),
MediaGeral AS (
    SELECT AVG(total_gasto) AS media_total FROM GastoPorCliente
),
ContagemPets AS (
    SELECT cliente_id, COUNT(*) AS qtd_pets FROM pets GROUP BY cliente_id
)
SELECT c.nome
FROM clientes c
JOIN GastoPorCliente g ON c.id = g.cliente_id
JOIN ContagemPets p ON c.id = p.cliente_id
WHERE g.total_gasto > (SELECT media_total FROM MediaGeral)
AND p.qtd_pets > 1;