-- Object: PROCEDURE dbo.CBO_DROPSUBBROKER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE CBO_DROPSUBBROKER
(
      @subbroker  varchar(10),
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
		@BranchCur Cursor,
		@share_db   varchar(50),
		@share_server varchar(50),
		@SQL Varchar(2000),
		@SB_COUNT INT
CREATE TABLE #SUBROKEREXIST (SUB_BROKER VARCHAR(10))
Set @BranchCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
Open @BranchCur
Fetch Next From @BranchCur into @share_db,@share_server
While @@Fetch_Status = 0       
	BEGIN
		SELECT @SB_COUNT = COUNT(1) FROM #SUBROKEREXIST
		IF @SB_COUNT = 0
			BEGIN
				SET @SQL = "DELETE " + @share_server + "." + @share_db + ".DBO.SUBBROKERS "
                SET @SQL =  @SQL + " where SUB_BROKER = '" + @subbroker + "'"
                --PRINT @SQL
				EXEC (@SQL)
				IF @@ERROR <> 0
					BEGIN
						RETURN
					END
			END
	     TRUNCATE TABLE #SUBROKEREXIST
         Fetch Next From @BranchCur into @share_db,@share_server
	END     
Close @BranchCur  
DeAllocate @BranchCur

GO
