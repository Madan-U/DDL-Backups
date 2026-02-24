-- Object: PROCEDURE dbo.CBO_DELBRANCH
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE CBO_DELBRANCH
(
      @BRANCHCODE       varchar(80),
      @STATUSID        VARCHAR(25),
      @STATUSNAME      VARCHAR(25)
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
CREATE TABLE #BRANCHEXIST (BRANCH_CODE VARCHAR(80))
Set @BranchCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
Open @BranchCur
Fetch Next From @BranchCur into @share_db,@share_server
While @@Fetch_Status = 0       
	BEGIN
		SELECT @SB_COUNT = COUNT(1) FROM #BRANCHEXIST
		IF @SB_COUNT = 0
			BEGIN
				SET @SQL = "DELETE " + @share_server + "." + @share_db + ".DBO.BRANCH"
                SET @SQL =  @SQL + " where BRANCH_CODE = '" + @BRANCHCODE  + "'"
                --PRINT @SQL
				EXEC (@SQL)
				IF @@ERROR <> 0
					BEGIN
						RETURN
					END
			END
	     TRUNCATE TABLE #BRANCHEXIST
         Fetch Next From @BranchCur into @share_db,@share_server
	END     
Close @BranchCur  
DeAllocate @BranchCur

GO
