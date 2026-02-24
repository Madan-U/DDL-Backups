-- Object: PROCEDURE dbo.check1
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure check1
	(
	 @partycode varchar(16)
	) 
AS
 DECLARE
    @SQLVAR  int,
		@SQL Varchar(2000),
		@SB_COUNT INT
    BEGIN 
        CREATE TABLE #TEMP (FLD INT)
        SET @SQL = "INSERT INTO #TEMP SELECT COUNT(1) FROM CLIENT2 WHERE PARTY_CODE = '" + @partycode + "'"
				--print(@SQL)
        EXEC(@SQL)
		    SELECT @SQLVAR = FLD FROM #TEMP
        DROP TABLE #TEMP
        IF @SQLVAR <> 0
		       BEGIN
               SET @SQL = "SELECT DISTINCT SCRIP_CD FROM SCRIP2"
               EXEC(@SQL)
            END
			    END

GO
