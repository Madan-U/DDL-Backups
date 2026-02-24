-- Object: PROCEDURE dbo.CBO_TESTMultiSERVER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------








CREATE       PROCEDURE [dbo].[CBO_TESTMultiSERVER]
(
      @userid  varchar(20),
      @partycode       varchar(50),
      @tmark  varchar(10) ,
       @scheme  varchar(10) ,
       @procli  varchar(10) ,
       @exceptparty  varchar(10) 
)
AS
/*
	BEGIN TRAN
	EXEC CBO_ADDREGION 'TEST', 'TEST', 'MUMBAI'
	ROLLBACK
*/
DECLARE
		@Result int,
		@BranchCur Cursor,
		@share_db   varchar(50),
		@share_server varchar(50),
		@SQL Varchar(2000)--,
		--@AR_COUNT INT
--CREATE TABLE #TERMEXIST (USERID VARCHAR(20))
Set @BranchCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
Open @BranchCur
Fetch Next From @BranchCur into @share_db,@share_server
While @@Fetch_Status = 0       
	BEGIN
		--SET @SQL = "INSERT INTO #TERMEXIST (USERID) SELECT USERID FROM " + @share_server + "." + @share_db + ".DBO.termparty WHERE USERID = '" + @userid  + "'"
		--PRINT @SQL
	   ----- EXEC(@SQL)
		--SELECT @AR_COUNT = COUNT(1) FROM #TERMEXIST
		--IF (1)---@AR_COUNT = 0
			--BEGIN
				SET @SQL = "INSERT INTO " + @share_server + "." + @share_db + ".DBO.TERMPARTY "
				SET @SQL = @SQL + "(USERID, PARTY_CODE, TMARK,SCHEME,PROCLI,EXCEPTPARTY) "
				SET @SQL = @SQL + "VALUES ('" + @userid  + "'," +  @partycode + "'," + @tmark + "', '" +  @scheme + "', '" + @procli + "','" + @exceptparty  + "')"
				--PRINT @SQL
				EXEC(@SQL)
				--IF @@ERROR <> 0
					--BEGIN
						--RETURN
					--END
			--END
		--TRUNCATE TABLE #TERMEXIST
		Fetch Next From @BranchCur into @share_db,@share_server
	END     
Close @BranchCur  
DeAllocate @BranchCur

GO
