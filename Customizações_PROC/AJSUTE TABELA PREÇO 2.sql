WITH TAB_P2 AS (
    SELECT
        EXC.CODPROD AS CODPROD,
        EXC.VLRVENDA AS VLRVENDA,
        ITE.IDALIQICMS
    FROM TGFEXC EXC
        LEFT JOIN TGFITE ITE ON ITE.CODPROD = EXC.CODPROD
    WHERE 
        EXC.NUTAB = 485 AND
        ITE.NUNOTA = 188538
)
SELECT
    P2.CODPROD,
    P2.VLRVENDA AS VLRUNIT,
    PR.VLRVENDA,
    (CASE WHEN P.TEMIPIVENDA = 'S' THEN P2.VLRVENDA ELSE 0 END) AS BASEIPI,
    (CASE WHEN P.TEMIPIVENDA = 'S' THEN NVL(I.PERCENTUAL,0) ELSE 0 END) AS PERCIPI,
    (CASE WHEN P.TEMIPIVENDA = 'S' THEN (P2.VLRVENDA * I.PERCENTUAL / 100) ELSE 0 END) AS VLRIPI,
    (CASE WHEN ICM.ALIQSUBTRIB > 0 THEN ((P2.VLRVENDA + (CASE WHEN P.TEMIPIVENDA = 'S' THEN (P2.VLRVENDA * I.PERCENTUAL / 100) ELSE 0 END)) * (1+ICM.MARGLUCRO/100)) ELSE 0 END) AS BASESUBST,
    (CASE WHEN ICM.ALIQSUBTRIB > 0 THEN (((P2.VLRVENDA + (CASE WHEN P.TEMIPIVENDA = 'S' THEN (P2.VLRVENDA * I.PERCENTUAL / 100) ELSE 0 END)) * (1+ICM.MARGLUCRO/100) * ICM.ALIQSUBTRIB/100) - 
        (P2.VLRVENDA * ICM.ALIQUOTA / 100)) ELSE 0 END) AS VLRSUBST,
    (PR.VLRVENDA/(1+(((CASE WHEN ICM.ALIQSUBTRIB > 0 THEN (((P2.VLRVENDA + (CASE WHEN P.TEMIPIVENDA = 'S' THEN (P2.VLRVENDA * I.PERCENTUAL / 100) ELSE 0 END)) * (1+ICM.MARGLUCRO/100) * ICM.ALIQSUBTRIB/100) - 
        (P2.VLRVENDA * ICM.ALIQUOTA / 100)) ELSE 0 END)/P2.VLRVENDA)+((CASE WHEN P.TEMIPIVENDA = 'S' THEN NVL(I.PERCENTUAL,0) ELSE 0 END)/100)))) AS VLRBASE
FROM TAB_P2 P2
    INNER JOIN TGFPRO P ON P.CODPROD = P2.CODPROD
    LEFT JOIN AD_TGFPROTP PR ON PR.CODPROD = P.CODPROD
    LEFT JOIN TGFIPI I ON I.CODIPI = P.CODIPI
    LEFT JOIN TGFICM ICM ON ICM.IDALIQ = P2.IDALIQICMS
WHERE P.ATIVO = 'S'