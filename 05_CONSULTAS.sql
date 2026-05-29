/* ============================================================
   CONSULTAS - Sistema de E-commerce (Firebird 5.0)
   Cada consulta responde uma pergunta real de negocio.
   Tabelas: cliente, endereco, categoria, produto,
            produto_categoria, pedido, item_pedido,
            pagamento, avaliacao
   ============================================================ */


/* ----------------------------------------------------------
   C1. FATURAMENTO POR STATUS DE PEDIDO
   Pergunta: Qual o volume e receita em cada etapa do funil?
   ---------------------------------------------------------- */
SELECT
    p.status,
    COUNT(p.id_pedido)          AS qtd_pedidos,
    SUM(p.valor_total)          AS receita_total,
    AVG(p.valor_total)          AS ticket_medio,
    MIN(p.valor_total)          AS menor_pedido,
    MAX(p.valor_total)          AS maior_pedido
FROM pedido p
GROUP BY p.status
ORDER BY receita_total DESC;


/* ----------------------------------------------------------
   C2. RANKING DE PRODUTOS MAIS VENDIDOS
   Pergunta: Quais produtos geram mais receita?
   Obs: exclui pedidos cancelados do calculo.
   ---------------------------------------------------------- */
SELECT
    pr.id_produto,
    pr.nome                     AS produto,
    COUNT(ip.id_item)           AS vezes_vendido,
    SUM(ip.quantidade)          AS unidades_vendidas,
    SUM(ip.subtotal)            AS receita_gerada,
    AVG(ip.preco_unitario)      AS preco_medio_praticado,
    pr.preco                    AS preco_atual_catalogo
FROM produto pr
JOIN item_pedido ip ON ip.id_produto = pr.id_produto
JOIN pedido      pe ON pe.id_pedido  = ip.id_pedido
WHERE pe.status <> 'cancelado'
GROUP BY pr.id_produto, pr.nome, pr.preco
ORDER BY receita_gerada DESC;


/* ----------------------------------------------------------
   C3. CLIENTES VIP
   Pergunta: Quem sao os clientes que mais gastaram?
   Obs: considera apenas pedidos confirmados.
   ---------------------------------------------------------- */
SELECT
    c.id_cliente,
    c.nome,
    c.email,
    COUNT(DISTINCT p.id_pedido) AS total_pedidos,
    SUM(p.valor_total)          AS total_gasto,
    AVG(p.valor_total)          AS ticket_medio,
    MAX(p.data_pedido)          AS ultima_compra
FROM cliente c
JOIN pedido p ON p.id_cliente = c.id_cliente
WHERE p.status IN ('pago', 'enviado', 'entregue')
GROUP BY c.id_cliente, c.nome, c.email
ORDER BY total_gasto DESC;


/* ----------------------------------------------------------
   C4. ANALISE DE FORMAS DE PAGAMENTO
   Pergunta: Qual meio de pagamento move mais dinheiro?
   ---------------------------------------------------------- */
SELECT
    pg.forma_pagamento,
    pg.status                   AS status_pagamento,
    COUNT(pg.id_pagamento)      AS qtd_transacoes,
    SUM(pg.valor)               AS valor_total,
    AVG(pg.valor)               AS valor_medio
FROM pagamento pg
GROUP BY pg.forma_pagamento, pg.status
ORDER BY pg.forma_pagamento, valor_total DESC;


/* ----------------------------------------------------------
   C5. REPUTACAO DOS PRODUTOS
   Pergunta: Quais produtos tem melhor e pior avaliacao?
   Obs: usa LEFT JOIN para incluir produtos sem avaliacao.
        avaliacao se liga a item_pedido pelo id_item.
   ---------------------------------------------------------- */
SELECT
    pr.id_produto,
    pr.nome                     AS produto,
    COUNT(av.id_avaliacao)      AS total_avaliacoes,
    AVG(av.nota)                AS nota_media,
    MIN(av.nota)                AS pior_nota,
    MAX(av.nota)                AS melhor_nota,
    SUM(ip.quantidade)          AS unidades_vendidas
FROM produto pr
LEFT JOIN item_pedido ip ON ip.id_produto = pr.id_produto
LEFT JOIN avaliacao   av ON av.id_item    = ip.id_item
GROUP BY pr.id_produto, pr.nome
HAVING COUNT(av.id_avaliacao) > 0
ORDER BY nota_media DESC, total_avaliacoes DESC;


/* ----------------------------------------------------------
   C6. ALERTA DE ESTOQUE BAIXO
   Pergunta: Quais produtos ativos precisam de reposicao?
   Obs: considera estoque abaixo de 10 unidades.
   ---------------------------------------------------------- */
SELECT
    pr.id_produto,
    pr.nome,
    pr.estoque,
    pr.preco
FROM produto pr
WHERE pr.ativo = TRUE
  AND pr.estoque < 10
ORDER BY pr.estoque ASC;


/* ----------------------------------------------------------
   C7. AUDITORIA FINANCEIRA
   Pergunta: Existem pedidos onde o total pago nao bate
             com o valor_total registrado?
   Obs: compara valor_total do pedido com a soma dos
        pagamentos aprovados. Diferenca > 0.01 indica
        inconsistencia.
   ---------------------------------------------------------- */
SELECT
    pe.id_pedido,
    c.nome                          AS cliente,
    pe.status                       AS status_pedido,
    pe.valor_total                  AS valor_pedido,
    COALESCE(SUM(pg.valor), 0)      AS total_pago,
    pe.valor_total
        - COALESCE(SUM(pg.valor), 0) AS diferenca
FROM pedido pe
JOIN cliente    c  ON c.id_cliente  = pe.id_cliente
LEFT JOIN pagamento pg ON pg.id_pedido = pe.id_pedido
                      AND pg.status    = 'aprovado'
GROUP BY pe.id_pedido, c.nome, pe.status, pe.valor_total
HAVING ABS(pe.valor_total - COALESCE(SUM(pg.valor), 0)) > 0.01
ORDER BY diferenca DESC;


/* ----------------------------------------------------------
   C8. RECEITA POR CATEGORIA
   Pergunta: Quais categorias de produtos geram mais receita?
   ---------------------------------------------------------- */
SELECT
    cat.nome                        AS categoria,
    COUNT(DISTINCT pr.id_produto)   AS produtos_na_categoria,
    COUNT(DISTINCT ip.id_item)      AS itens_vendidos,
    COALESCE(SUM(ip.subtotal), 0)   AS receita_categoria
FROM categoria cat
JOIN produto_categoria pc ON pc.id_categoria = cat.id_categoria
JOIN produto           pr ON pr.id_produto   = pc.id_produto
LEFT JOIN item_pedido  ip ON ip.id_produto   = pr.id_produto
LEFT JOIN pedido       pe ON pe.id_pedido    = ip.id_pedido
                         AND pe.status <> 'cancelado'
GROUP BY cat.nome
ORDER BY receita_categoria DESC;


/* ----------------------------------------------------------
   C9. DETALHAMENTO COMPLETO DE UM PEDIDO
   Pergunta: Qual o detalhamento do pedido de id = 1?
   Obs: altere o valor no WHERE para consultar outro pedido.
        Exibe itens, avaliacoes e pagamentos do pedido.
   ---------------------------------------------------------- */
SELECT
    pe.id_pedido,
    pe.data_pedido,
    pe.status                       AS status_pedido,
    pe.valor_total,
    c.nome                          AS cliente,
    c.email,
    e.logradouro || ', ' || e.numero
        || ' - ' || e.bairro
        || ', ' || e.cidade
        || '/' || e.uf              AS endereco_entrega,
    pr.nome                         AS produto,
    ip.quantidade,
    ip.preco_unitario,
    ip.subtotal,
    av.nota                         AS nota_avaliacao,
    av.comentario                   AS comentario_avaliacao,
    pg.forma_pagamento,
    pg.valor                        AS valor_pago,
    pg.status                       AS status_pagamento
FROM pedido      pe
JOIN cliente      c  ON c.id_cliente  = pe.id_cliente
JOIN endereco     e  ON e.id_endereco = pe.id_endereco
JOIN item_pedido  ip ON ip.id_pedido  = pe.id_pedido
JOIN produto      pr ON pr.id_produto = ip.id_produto
LEFT JOIN avaliacao  av ON av.id_item   = ip.id_item
LEFT JOIN pagamento  pg ON pg.id_pedido = pe.id_pedido
WHERE pe.id_pedido = 1
ORDER BY ip.id_item, pg.id_pagamento;


/* ----------------------------------------------------------
   C10. CLIENTES INATIVOS
   Pergunta: Quais clientes nunca compraram ou nao compram
             ha mais de 90 dias?
   Obs: subtrai datas como inteiro no Firebird — o resultado
        e a diferenca em dias.
   ---------------------------------------------------------- */
SELECT
    c.id_cliente,
    c.nome,
    c.email,
    c.telefone,
    c.data_cadastro,
    MAX(pe.data_pedido)             AS ultima_compra,
    CASE
        WHEN MAX(pe.data_pedido) IS NULL THEN 'Nunca comprou'
        ELSE 'Inativo ha mais de 90 dias'
    END                             AS situacao
FROM cliente c
LEFT JOIN pedido pe ON pe.id_cliente = c.id_cliente
                   AND pe.status    <> 'cancelado'
GROUP BY c.id_cliente, c.nome, c.email, c.telefone, c.data_cadastro
HAVING MAX(pe.data_pedido) IS NULL
    OR (CAST(CURRENT_TIMESTAMP AS DATE) - CAST(MAX(pe.data_pedido) AS DATE)) > 90
ORDER BY ultima_compra ASC NULLS FIRST;