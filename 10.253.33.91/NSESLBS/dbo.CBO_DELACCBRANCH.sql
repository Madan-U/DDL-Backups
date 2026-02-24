-- Object: PROCEDURE dbo.CBO_DELACCBRANCH
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE CBO_DELACCBRANCH
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
    @SQLVAR  int,
		@Result int,
		@BranchCur Cursor,
		@share_db   varchar(50),
		@AccountDB Varchar(50),
		@share_server varchar(50),
		@AccountServer Varchar(50),
		@SQL Varchar(2000),
		@SB_COUNT INT
		CREATE TABLE #BRANCHEXIT (BRANCH_CODE VARCHAR(80))
		Set @BranchCur = Cursor for  Select sharedb,shareserver,AccountDb, AccountServer From Pradnya.dbo.multicompany where primaryserver = 1
		Open @BranchCur
		Fetch Next From @BranchCur into @share_db,@share_server, @AccountDB, @AccountServer
		While @@Fetch_Status = 0
  BEGIN
		SELECT @SB_COUNT = COUNT(1) FROM #BRANCHEXIT
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
         BEGIN
           SET @SQL = "DELETE " + @AccountServer + "." + @AccountDB + ".DBO.COSTMAST"
           SET @SQL =  @SQL + " where COSTNAME = '" + @BRANCHCODE  + "'"
           --PRINT @SQL
				   EXEC (@SQL)
			   END
        BEGIN
           SET @SQL = "DELETE " + @AccountServer + "." + @AccountDB + ".DBO.BRANCHACCOUNTS"
           SET @SQL =  @SQL + " where BRANCHNAME = '" + @BRANCHCODE  + "'"
           --PRINT @SQL
				   EXEC (@SQL)
			   END
         BEGIN
           SET @SQL = "DELETE " + @AccountServer + "." + @AccountDB + ".DBO.ACMAST"
           SET @SQL =  @SQL + " where ACNAME = '" + @BRANCHCODE  + "'"
           --PRINT @SQL
				   EXEC (@SQL)
			   END
       TRUNCATE TABLE #BRANCHEXIT
       Fetch Next From @BranchCur into @share_db,@share_server, @AccountDB, @AccountServer
	    END     
Close @BranchCur  
DeAllocate @BranchCur

GO
