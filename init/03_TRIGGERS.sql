/* ============================================================
   TRIGGERS - Sistema de E-commerce 
   Para uso via script de inicializacao do Docker
   ============================================================ */


/* ----------------------------------------------------------
   TRG1. CORRIGIR SUBTOTAL AUTOMATICAMENTE AO INSERIR ITEM
   Motivo: garante subtotal = quantidade * preco_unitario
           independente do valor enviado pela aplicacao.
   ---------------------------------------------------------- */
SET TERM ~ ;

CREATE TRIGGER trg_corrigir_subtotal
FOR item_pedido
BEFORE INSERT
AS
BEGIN
    NEW.subtotal = NEW.quantidade * NEW.preco_unitario;
END~

SET TERM ; ~

COMMIT;


/* ----------------------------------------------------------
   TRG2. RECALCULAR VALOR_TOTAL DO PEDIDO APOS INSERT DE ITEM
   Motivo: mantém valor_total do pedido sempre sincronizado
           com a soma real dos subtotais dos itens.
   ---------------------------------------------------------- */
SET TERM ~ ;

CREATE TRIGGER trg_recalcular_total_insert
FOR item_pedido
AFTER INSERT
AS
BEGIN
    UPDATE pedido
    SET valor_total = (
        SELECT COALESCE(SUM(subtotal), 0)
        FROM item_pedido
        WHERE id_pedido = NEW.id_pedido
    )
    WHERE id_pedido = NEW.id_pedido;
END~

SET TERM ; ~

COMMIT;


/* ----------------------------------------------------------
   TRG3. RECALCULAR VALOR_TOTAL DO PEDIDO APOS DELETE DE ITEM
   Motivo: se um item for removido, o total do pedido deve
           ser recalculado imediatamente.
   ---------------------------------------------------------- */
SET TERM ~ ;

CREATE TRIGGER trg_recalcular_total_delete
FOR item_pedido
AFTER DELETE
AS
BEGIN
    UPDATE pedido
    SET valor_total = (
        SELECT COALESCE(SUM(subtotal), 0)
        FROM item_pedido
        WHERE id_pedido = OLD.id_pedido
    )
    WHERE id_pedido = OLD.id_pedido;
END~

SET TERM ; ~

COMMIT;


/* ----------------------------------------------------------
   TRG4. PROTEGER PRECO_UNITARIO APOS INSERCAO
   Motivo: preco_unitario e o preco congelado no momento da
           compra. Alteracao corromperia o historico financeiro.
           Se a quantidade mudar, o subtotal e recalculado
           mantendo o preco original.
   ---------------------------------------------------------- */
SET TERM ~ ;

CREATE TRIGGER trg_proteger_preco_historico
FOR item_pedido
BEFORE UPDATE
AS
BEGIN
    NEW.preco_unitario = OLD.preco_unitario;
    NEW.subtotal = NEW.quantidade * OLD.preco_unitario;
END~

SET TERM ; ~

COMMIT;


/* ----------------------------------------------------------
   TRG5. BLOQUEAR RETROCESSO DE STATUS DO PEDIDO
   Motivo: o ciclo de vida do pedido e unidirecional.
   Fluxo : pendente -> pago -> enviado -> entregue
                                       -> cancelado
   ---------------------------------------------------------- */
SET TERM ~ ;

CREATE TRIGGER trg_bloquear_retrocesso_status
FOR pedido
BEFORE UPDATE
AS
BEGIN
    -- Pedido entregue ou cancelado: nenhuma alteracao permitida 
    IF (OLD.status = 'entregue' OR OLD.status = 'cancelado') THEN
    BEGIN
        NEW.status      = OLD.status;
        NEW.valor_total = OLD.valor_total;
        NEW.id_cliente  = OLD.id_cliente;
        NEW.id_endereco = OLD.id_endereco;
    END

    -- Pedido enviado: so pode ir para entregue ou cancelado
    IF (OLD.status = 'enviado' AND
        NEW.status <> 'entregue' AND NEW.status <> 'cancelado') THEN
        NEW.status = OLD.status;

    -- Pedido pago: so pode ir para enviado ou cancelado
    IF (OLD.status = 'pago' AND
        NEW.status <> 'enviado' AND NEW.status <> 'cancelado') THEN
        NEW.status = OLD.status;
END~

SET TERM ; ~

COMMIT;