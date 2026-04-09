
-- LISTA 01: JOINS


-- Questão 1: Pets e seus donos Utilizando INNER JOIN

SELECT 
    p.nome AS nome_do_pet, 
    p.especie, 
    p.raca, 
    c.nome AS nome_do_dono, 
    c.telefone
FROM pets p
INNER JOIN clientes c ON p.cliente_id = c.id;

-- --------------------------------------------------------------------

-- Questão 2: Relatório Completo de Vendas
 
SELECT
    c.nome AS cliente,
    v.data_venda,
    pr.nome AS produto,
    iv.quantidade,
    iv.preco_unitario,
    (iv.quantidade * iv.preco_unitario) AS subtotal
FROM vendas v
INNER JOIN clientes c     ON v.cliente_id = c.id
INNER JOIN itens_venda iv ON v.id = iv.venda_id
INNER JOIN produtos pr    ON iv.produto_id = pr.id
ORDER BY v.data_venda DESC;             

-- --------------------------------------------------------------------

-- Questão 3: Compras por Cliente LEFT JOIN e COALESCE

SELECT 
    c.nome AS cliente,
    COALESCE(COUNT(v.id), 0) AS total_de_compras
FROM clientes c
LEFT JOIN vendas v ON c.id = v.cliente_id
GROUP BY c.id, c.nome
ORDER BY total_de_compras DESC; 

-- --------------------------------------------------------------------

-- Questão 4: Top 3 serviços mais agendados (Utilizando CTE)
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