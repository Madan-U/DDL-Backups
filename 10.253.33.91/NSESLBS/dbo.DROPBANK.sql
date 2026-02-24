-- Object: PROCEDURE dbo.DROPBANK
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE DROPBANK
(
      @bank_id    varchar(16)
)
AS
   DECLARE
		@Result int,
		@BranchCur Cursor,
		@share_db   varchar(50),
		@share_server varchar(50),
		@SQL Varchar(2000),
		@SB_COUNT INT
CREATE TABLE #BANKEXIST (BANKID VARCHAR(16))
Set @BranchCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
Open @BranchCur
Fetch Next From @BranchCur into @share_db,@share_server
While @@Fetch_Status = 0       
	BEGIN
		SELECT @SB_COUNT = COUNT(1) FROM #BANKEXIST
		IF @SB_COUNT = 0
			BEGIN
				SET @SQL = "DELETE " + @share_server + "." + @share_db + ".DBO.BANK"
                                                    SET @SQL =  @SQL + " where BANKID = '" + @bank_id  + "'"
                                                    -- PRINT @SQL
				EXEC (@SQL)
				IF @@ERROR <> 0
					BEGIN
						RETURN
					END
			END
	     TRUNCATE TABLE #BANKEXIST
         Fetch Next From @BranchCur into @share_db,@share_server
	END     
Close @BranchCur  
DeAllocate @BranchCur

GO
