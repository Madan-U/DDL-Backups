-- Object: PROCEDURE dbo.ADD_MULTISERVER_POBANK
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





CREATE     PROCEDURE [dbo].[ADD_MULTISERVER_POBANK]
(
      
      @baname      varchar(50),
      @branchname  varchar(10) 
)
AS
/*
	BEGIN TRAN
	EXEC ADD_MULTISERVER_AREA 'TEST', 'TEST', 'MUMBAI'
	ROLLBACK
*/
DECLARE
		@Result int,
		@BranchCur Cursor,
		@share_db   varchar(50),
		@share_server varchar(50),
		@SQL Varchar(2000),
		@AR_COUNT INT
CREATE TABLE #BAREXIST (BANK_NAME VARCHAR(20))
Set @BranchCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
Open @BranchCur
Fetch Next From @BranchCur into @share_db,@share_server
While @@Fetch_Status = 0       
	BEGIN
		SET @SQL = "INSERT INTO #BAREXIST (BANK_NAME) SELECT BANK_NAME FROM " + @share_server + "." + @share_db + ".DBO.POBANK WHERE BANK_NAME = '" + @baname   + "' "
		--PRINT @SQL
	    EXEC(@SQL)
		SELECT @AR_COUNT = COUNT(1) FROM #BAREXIST
		IF @AR_COUNT = 0
			BEGIN
				SET @SQL = "INSERT INTO " + @share_server + "." + @share_db + ".DBO.POBANK "
				SET @SQL = @SQL + "( BANK_NAME, BRANCH_NAME) "
				SET @SQL = @SQL + "VALUES ( '" + @baname   + "', '" + @branchname + "')"
				--PRINT @SQL
				EXEC(@SQL)
				IF @@ERROR <> 0
					BEGIN
						RETURN
					END
			END
		TRUNCATE TABLE #BAREXIST
		Fetch Next From @BranchCur into @share_db,@share_server
	END     
Close @BranchCur  
DeAllocate @BranchCur

GO
