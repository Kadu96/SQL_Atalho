WITH TAB_PRO AS (
    SELECT 
        CODPROD,
        GRUPOICMS,
        GRUPOICMS2,
        NCM,
        1723 AS TOP
    FROM TGFPRO
)
SELECT * FROM TAB_PRO TAB WHERE TAB.CODPROD = 37568

WITH TAB_ALIQ AS (
    SELECT
        I.IDALIQ, 
        I.CODTRIB,
        I.ALIQUOTA,
        I.ALIQSUBTRIB,
        I.TIPRESTRICAO, 
        I.TIPRESTRICAO2, 
        I.CODRESTRICAO, 
        I.CODRESTRICAO2,
        P.PRIORIDADE
    FROM TGFICM I, TGFPRI P
    WHERE I.UFORIG = 8
      AND I.UFDEST = 8
      AND I.TIPRESTRICAO = P.TIPRESTRICAO1
      AND I.TIPRESTRICAO2 = P.TIPRESTRICAO2
) 
SELECT IDALIQ FROM TAB_ALIQ 
WHERE 
    (PRIORIDADE = 560 AND CODRESTRICAO = 18 AND CODRESTRICAO2 = 1723) OR
    (PRIORIDADE = 563 AND CODRESTRICAO = 39231090 AND CODRESTRICAO2 = 18) OR
    (PRIORIDADE = 564 AND CODRESTRICAO = 1723 AND CODRESTRICAO2 = -1) OR
    (PRIORIDADE = 565 AND CODRESTRICAO IS NULL AND CODRESTRICAO2 = 39231090) OR
    (PRIORIDADE = 566 AND CODRESTRICAO IS NULL AND CODRESTRICAO2 = -1) OR
    (PRIORIDADE = 567 AND CODRESTRICAO = -1 AND CODRESTRICAO2 = -1) OR
    (PRIORIDADE = 568 AND CODRESTRICAO = 1723 AND CODRESTRICAO2 = 1)