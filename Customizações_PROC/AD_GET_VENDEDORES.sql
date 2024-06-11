--Função para retornar os vendedores que cada usuário pode visualizar
CREATE OR REPLACE FUNCTION "AD_GET_VENDEDORES"(
    pCodigoUsuario INT
) RETURN VARCHAR2 AS
    V_VENDEDORES VARCHAR2(999);

BEGIN
    FOR VEND IN (
        SELECT (
            CASE CODGRUPO
                WHEN 9 THEN 
                    (SELECT LISTAGG(CODVEND, ',') WITHIN GROUP (ORDER BY CODVEND) FROM TGFVEN WHERE CODVEND > 0)
                WHEN 12 THEN 
                    (SELECT LISTAGG(CODVEND, ',') WITHIN GROUP (ORDER BY CODVEND) FROM TGFVEN WHERE CODGER = (
                        SELECT CODVEND FROM TSIUSU WHERE CODUSU = pCodigoUsuario))
                ELSE LISTAGG(CODVEND, ',') WITHIN GROUP (ORDER BY CODVEND)
            END) AS LISTA_VENDEDORES
        FROM TSIUSU 
        WHERE CODUSU = pCodigoUsuario
        GROUP BY CODGRUPO, CODVEND
    ) LOOP
        V_VENDEDORES := VEND.LISTA_VENDEDORES;
    END LOOP;

    RETURN V_VENDEDORES;
END;