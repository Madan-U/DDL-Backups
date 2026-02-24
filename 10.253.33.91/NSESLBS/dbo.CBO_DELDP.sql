-- Object: PROCEDURE dbo.CBO_DELDP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE    PROCEDURE CBO_DELDP
(
      @BANKID  varchar(20),
      @STATUSID VARCHAR(25),
      @STATUSNAME VARCHAR(25)
)
AS
IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END

   DECLARE
		@Result int,
		@DPCur Cursor,
		@share_db   varchar(50),
		@share_server varchar(50),
		@SQL Varchar(2000),
		@DP_COUNT INT
CREATE TABLE #DPEXIST (BANKID VARCHAR(20))
Set @DPCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
Open @DPCur
Fetch Next From @DPCur into @share_db,@share_server
While @@Fetch_Status = 0       
	BEGIN
		SELECT @DP_COUNT = COUNT(1) FROM #DPEXIST
		IF @DP_COUNT = 0
			BEGIN
				SET @SQL = "DELETE " + @share_server + "." + @share_db + ".DBO.BANK "
                SET @SQL =  @SQL + " where BankId = '" + @BANKID + "'"
                --PRINT @SQL
				EXEC (@SQL)
				IF @@ERROR <> 0
					BEGIN
						RETURN
					END
			END
	     TRUNCATE TABLE #DPEXIST 
         Fetch Next From @DPCur into @share_db,@share_server
	END     
Close @DPCur  
DeAllocate @DPCur

GO
