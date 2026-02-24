-- Object: PROCEDURE dbo.EDITBANKLOCATE
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE procedure EDITBANKLOCATE
(
      @type            varchar(2),
      @cheque          varchar(10),
      @flag	           varchar(1),
      @STATUSID        VARCHAR(25),
      @STATUSNAME      VARCHAR(25)
 )
 AS
	IF @STATUSID <> 'BROKER'
	BEGIN
		RAISERROR ('This Procedure is accessible to Broker', 16, 1)
		RETURN
	END
	--IF @FLAG <> 'A' AND @FLAG <> 'E'
             IF @FLAG <> 'E' 
	BEGIN
		RAISERROR ('Add/Edit Flags Not Set Properly', 16, 1)
		RETURN
	END
  DECLARE
   @SQL Varchar(2000)
		BEGIN
		    SET  @SQL = "UPDATE banklocat"
                               SET @SQL = @SQL + " SET CHEQUE='" + @cheque + "'WHERE TYPE='"+ @type  + "'"
                              --print @SQL
                              EXEC(@SQL)
      
	            END

GO
