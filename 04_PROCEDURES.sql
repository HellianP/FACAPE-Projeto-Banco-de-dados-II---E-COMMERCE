/* ============================================================
   STORED PROCEDURES - Sistema de E-commerce 
   Para uso via script de inicializacao do Docker
   ============================================================ */


/* ----------------------------------------------------------
   SP1. REGISTRAR PAGAMENTO
   - Valida se o pedido existe e nao esta cancelado
   - Insere o pagamento com status 'aprovado'
   - Se a soma dos pagamentos cobrir valor_total: muda para 'pago'
   ---------------------------------------------------------- */
SET TERM ~ ;

CREATE PROCEDURE sp_registrar_pagamento (
    p_id_pedido       INTEGER,
    p_forma_pagamento VARCHAR(30),
    p_valor           DECIMAL(10,2)
)
RETURNS (
    o_id_pagamento  INTEGER,
    o_status_pedido VARCHAR(20),
    o_total_pago    DECIMAL(10,2),
    o_mensagem      VARCHAR(200)
)
AS
DECLARE VARIABLE v_valor_pedido DECIMAL(10,2);
DECLARE VARIABLE v_status       VARCHAR(20);
DECLARE VARIABLE v_total_pago   DECIMAL(10,2);
BEGIN
    SELECT valor_total, status
    FROM pedido
    WHERE id_pedido = :p_id_pedido
    INTO :v_valor_pedido, :v_status;

    IF (v_valor_pedido IS NULL) THEN
    BEGIN
        o_mensagem      = 'Erro: pedido nao encontrado.';
        o_id_pagamento  = NULL;
        o_status_pedido = NULL;
        o_total_pago    = NULL;
        SUSPEND;
        EXIT;
    END

    IF (v_status = 'cancelado') THEN
    BEGIN
        o_mensagem      = 'Erro: pedido cancelado nao aceita pagamentos.';
        o_id_pagamento  = NULL;
        o_status_pedido = v_status;
        o_total_pago    = NULL;
        SUSPEND;
        EXIT;
    END

    INSERT INTO pagamento (id_pedido, forma_pagamento, valor, status)
    VALUES (:p_id_pedido, :p_forma_pagamento, :p_valor, 'aprovado')
    RETURNING id_pagamento INTO :o_id_pagamento;

    SELECT COALESCE(SUM(valor), 0)
    FROM pagamento
    WHERE id_pedido = :p_id_pedido AND status = 'aprovado'
    INTO :v_total_pago;

    IF (v_status = 'pendente' AND v_total_pago >= v_valor_pedido) THEN
    BEGIN
        UPDATE pedido
        SET status = 'pago'
        WHERE id_pedido = :p_id_pedido;
        v_status = 'pago';
    END

    o_total_pago    = v_total_pago;
    o_status_pedido = v_status;
    o_mensagem      = 'Pagamento registrado. Status do pedido: ' || v_status;
    SUSPEND;
END~

SET TERM ; ~

COMMIT;


/* ----------------------------------------------------------
   SP2. CANCELAR PEDIDO
   - So cancela se status for 'pendente' ou 'pago'
   - Devolve o estoque de cada produto do pedido
   - Marca pagamentos aprovados como 'estornado'
   - Muda status do pedido para 'cancelado'
   ---------------------------------------------------------- */
SET TERM ~ ;

CREATE PROCEDURE sp_cancelar_pedido (
    p_id_pedido INTEGER
)
RETURNS (
    o_mensagem VARCHAR(200)
)
AS
DECLARE VARIABLE v_status  VARCHAR(20);
DECLARE VARIABLE v_id_prod INTEGER;
DECLARE VARIABLE v_qtd     INTEGER;
BEGIN
    SELECT status
    FROM pedido
    WHERE id_pedido = :p_id_pedido
    INTO :v_status;

    IF (v_status IS NULL) THEN
    BEGIN
        o_mensagem = 'Erro: pedido nao encontrado.';
        SUSPEND;
        EXIT;
    END

    IF (v_status NOT IN ('pendente', 'pago')) THEN
    BEGIN
        o_mensagem = 'Cancelamento nao permitido. Status atual: ' || v_status;
        SUSPEND;
        EXIT;
    END

    FOR SELECT id_produto, quantidade
        FROM item_pedido
        WHERE id_pedido = :p_id_pedido
        INTO :v_id_prod, :v_qtd
    DO
    BEGIN
        UPDATE produto
        SET estoque = estoque + :v_qtd
        WHERE id_produto = :v_id_prod;
    END

    UPDATE pagamento
    SET status = 'estornado'
    WHERE id_pedido = :p_id_pedido AND status = 'aprovado';

    UPDATE pedido
    SET status = 'cancelado'
    WHERE id_pedido = :p_id_pedido;

    o_mensagem = 'Pedido ' || p_id_pedido || ' cancelado. Estoque reposto e pagamentos estornados.';
    SUSPEND;
END~

SET TERM ; ~

COMMIT;


/* ----------------------------------------------------------
   SP3. RELATORIO DE VENDAS POR PERIODO
   - Total de pedidos e receita confirmada
   - Ticket medio
   - Produto mais vendido em receita
   - Forma de pagamento mais usada
   - Quantidade de pedidos cancelados
   ---------------------------------------------------------- */
SET TERM ~ ;

CREATE PROCEDURE sp_relatorio_vendas (
    p_data_inicio TIMESTAMP,
    p_data_fim    TIMESTAMP
)
RETURNS (
    o_total_pedidos      INTEGER,
    o_receita_confirmada DECIMAL(10,2),
    o_total_pago         DECIMAL(10,2),
    o_ticket_medio       DECIMAL(10,2),
    o_produto_top        VARCHAR(150),
    o_forma_pagto_top    VARCHAR(30),
    o_pedidos_cancelados INTEGER
)
AS
BEGIN
    SELECT
        COUNT(*),
        COALESCE(SUM(CASE WHEN status IN ('pago','enviado','entregue')
                          THEN valor_total ELSE 0 END), 0),
        COALESCE(SUM(CASE WHEN status IN ('pago','enviado','entregue')
                          THEN valor_total ELSE 0 END), 0),
        COALESCE(AVG(CASE WHEN status IN ('pago','enviado','entregue')
                          THEN valor_total END), 0),
        COALESCE(SUM(CASE WHEN status = 'cancelado' THEN 1 ELSE 0 END), 0)
    FROM pedido
    WHERE data_pedido BETWEEN :p_data_inicio AND :p_data_fim
    INTO :o_total_pedidos, :o_receita_confirmada,
         :o_total_pago, :o_ticket_medio, :o_pedidos_cancelados;

    SELECT FIRST 1 pr.nome
    FROM produto pr
    JOIN item_pedido ip ON ip.id_produto = pr.id_produto
    JOIN pedido      pe ON pe.id_pedido  = ip.id_pedido
    WHERE pe.data_pedido BETWEEN :p_data_inicio AND :p_data_fim
      AND pe.status <> 'cancelado'
    GROUP BY pr.nome
    ORDER BY SUM(ip.subtotal) DESC
    INTO :o_produto_top;

    SELECT FIRST 1 pg.forma_pagamento
    FROM pagamento pg
    JOIN pedido    pe ON pe.id_pedido = pg.id_pedido
    WHERE pe.data_pedido BETWEEN :p_data_inicio AND :p_data_fim
      AND pg.status = 'aprovado'
    GROUP BY pg.forma_pagamento
    ORDER BY SUM(pg.valor) DESC
    INTO :o_forma_pagto_top;

    SUSPEND;
END~

SET TERM ; ~

COMMIT;