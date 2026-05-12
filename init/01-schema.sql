/* ============================================================
   Script de inicializacao do banco projetobd2
   Executado automaticamente na primeira subida do container.
   Coloque aqui o DDL do seu projeto (tabelas, dominios, FKs).
   ============================================================ */

SET NAMES UTF8;

/* Exemplo - remova/ajuste conforme seu modelo ----------------- */

CREATE TABLE EXEMPLO_ALUNO (
    ID          INTEGER NOT NULL PRIMARY KEY,
    MATRICULA   VARCHAR(20) NOT NULL UNIQUE,
    NOME        VARCHAR(120) NOT NULL,
    CRIADO_EM   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE SEQ_EXEMPLO_ALUNO;

SET TERM ^ ;
CREATE TRIGGER TRG_EXEMPLO_ALUNO_BI FOR EXEMPLO_ALUNO
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
    IF (NEW.ID IS NULL) THEN
        NEW.ID = NEXT VALUE FOR SEQ_EXEMPLO_ALUNO;
END^
SET TERM ; ^

COMMIT;
