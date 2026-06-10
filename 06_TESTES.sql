/* ============================================================
   TESTES - Sistema de E-commerce 
   Demonstracao dos Triggers e Procedures em funcionamento.
   ============================================================ */


/* ----------------------------------------------------------
   1. VERIFICACAO DOS OBJETOS CRIADOS
   ---------------------------------------------------------- */

-- Triggers criados 
SELECT RDB$TRIGGER_NAME     AS trigger_nome,
       RDB$RELATION_NAME    AS tabela
FROM RDB$TRIGGERS
WHERE RDB$SYSTEM_FLAG = 0
ORDER BY RDB$TRIGGER_NAME;

-- Procedures criadas 
SELECT RDB$PROCEDURE_NAME   AS procedure_nome
FROM RDB$PROCEDURES
WHERE RDB$SYSTEM_FLAG = 0
ORDER BY RDB$PROCEDURE_NAME;


/* ============================================================
   TESTES DE TRIGGERS
   ============================================================ */


/* ----------------------------------------------------------
   TRIGGER 1 - trg_corrigir_subtotal
   Insere item com subtotal incorreto (0).
   O trigger corrige para quantidade * preco_unitario.
   ---------------------------------------------------------- */

-- Estado antes 
SELECT id_pedido, valor_total FROM pedido WHERE id_pedido = 1;

-- Insere com subtotal errado 
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal)
VALUES (1, 3, 2, 599.00, 0);

-- Resultado: subtotal deve ser 1198.00 
SELECT id_item, id_produto, quantidade, preco_unitario, subtotal
FROM item_pedido
WHERE id_pedido = 1 AND id_produto = 3;


/* ----------------------------------------------------------
   TRIGGER 2 - trg_recalcular_total_insert
   Apos o insert acima, valor_total do pedido 1
   deve ter sido atualizado automaticamente.
   ---------------------------------------------------------- */

-- Resultado: valor_total deve ser 3849.80 + 1198.00 = 5047.80 
SELECT id_pedido, valor_total FROM pedido WHERE id_pedido = 1;


/* ----------------------------------------------------------
   TRIGGER 3 - trg_recalcular_total_delete
   Remove o item inserido anteriormente.
   O valor_total do pedido deve voltar ao original.
   ---------------------------------------------------------- */

DELETE FROM item_pedido
WHERE id_pedido = 1 AND id_produto = 3;

-- Resultado: valor_total deve voltar para 3849.80 
SELECT id_pedido, valor_total FROM pedido WHERE id_pedido = 1;


/* ----------------------------------------------------------
   TRIGGER 4 - trg_proteger_preco_historico
   Tenta alterar o preco_unitario de um item ja registrado.
   O trigger ignora a alteracao e mantém o preco original.
   ---------------------------------------------------------- */

-- Estado antes 
SELECT id_item, preco_unitario, subtotal FROM item_pedido WHERE id_item = 1;

-- Tentativa de alteracao 
UPDATE item_pedido SET preco_unitario = 1.00 WHERE id_item = 1;

-- Resultado: preco_unitario deve continuar 3499.90 
SELECT id_item, preco_unitario, subtotal FROM item_pedido WHERE id_item = 1;


/* ----------------------------------------------------------
   TRIGGER 5 - trg_bloquear_retrocesso_status
   Testa o ciclo de vida do pedido em tres cenarios.
   ---------------------------------------------------------- */

-- Cenario A: pedido 2 esta 'enviado', tenta voltar para 'pendente' 
UPDATE pedido SET status = 'pendente' WHERE id_pedido = 2;

-- Resultado: status deve continuar 'enviado' 
SELECT id_pedido, status FROM pedido WHERE id_pedido = 2;

-- Cenario B: avanco valido de 'enviado' para 'entregue' 
UPDATE pedido SET status = 'entregue' WHERE id_pedido = 2;

-- Resultado: status deve ser 'entregue' 
SELECT id_pedido, status FROM pedido WHERE id_pedido = 2;

-- Cenario C: pedido entregue nao pode ser alterado 
UPDATE pedido SET status = 'pago' WHERE id_pedido = 2;

-- Resultado: status deve continuar 'entregue' 
SELECT id_pedido, status FROM pedido WHERE id_pedido = 2;


/* ============================================================
   TESTES DE PROCEDURES
   ============================================================ */


/* ----------------------------------------------------------
   PROCEDURE 1 - sp_registrar_pagamento
   Pedido 3 esta 'pendente' com valor_total de 189.50.
   Registra o pagamento exato e o status deve mudar para 'pago'.
   ---------------------------------------------------------- */

-- Estado antes 
SELECT id_pedido, status, valor_total FROM pedido WHERE id_pedido = 3;
SELECT id_pagamento, forma_pagamento, valor, status FROM pagamento WHERE id_pedido = 3;

-- Registra o pagamento 
EXECUTE PROCEDURE sp_registrar_pagamento(3, 'pix', 189.50);

-- Resultado: status do pedido deve ser 'pago' 
SELECT id_pedido, status, valor_total FROM pedido WHERE id_pedido = 3;

-- Resultado: novo pagamento aprovado deve aparecer 
SELECT id_pagamento, forma_pagamento, valor, status FROM pagamento WHERE id_pedido = 3;


/* ----------------------------------------------------------
   PROCEDURE 1b - sp_registrar_pagamento (erro esperado)
   Tenta registrar pagamento em pedido cancelado.
   A procedure deve retornar mensagem de erro.
   ---------------------------------------------------------- */

EXECUTE PROCEDURE sp_registrar_pagamento(7, 'pix', 379.90);


/* ----------------------------------------------------------
   PROCEDURE 2 - sp_cancelar_pedido
   Cancela o pedido 9 que esta 'pendente'.
   Estoque do produto deve ser devolvido e
   pagamento deve ser estornado.
   ---------------------------------------------------------- */

-- Estado antes
SELECT id_pedido, status FROM pedido WHERE id_pedido = 9;
SELECT id_produto, nome, estoque FROM produto WHERE id_produto = 13;
SELECT id_pagamento, valor, status FROM pagamento WHERE id_pedido = 9;

-- Cancela o pedido
EXECUTE PROCEDURE sp_cancelar_pedido(9);

-- Resultado: pedido deve estar 'cancelado' 
SELECT id_pedido, status FROM pedido WHERE id_pedido = 9;

-- Resultado: estoque do produto deve ter voltado 
SELECT id_produto, nome, estoque FROM produto WHERE id_produto = 13;

-- Resultado: pagamento deve estar 'estornado' 
SELECT id_pagamento, valor, status FROM pagamento WHERE id_pedido = 9;


/* ----------------------------------------------------------
   PROCEDURE 2b - sp_cancelar_pedido (erro esperado)
   Tenta cancelar pedido 2 que esta 'entregue'.
   A procedure deve retornar mensagem de erro.
   ---------------------------------------------------------- */

EXECUTE PROCEDURE sp_cancelar_pedido(2);


/* ----------------------------------------------------------
   PROCEDURE 3 - sp_relatorio_vendas
   Gera resumo executivo de vendas do periodo completo.
   ---------------------------------------------------------- */

EXECUTE PROCEDURE sp_relatorio_vendas(
    CAST('2024-01-01 00:00:00' AS TIMESTAMP),
    CAST('2026-12-31 23:59:59' AS TIMESTAMP)
);