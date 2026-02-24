-- Object: PROCEDURE dbo.CBO_TESTMULTISERVER1
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE    PROCEDURE [dbo].[CBO_TESTMULTISERVER1]
(
      @Bankid  varchar(20),
@BankName  varchar(20),
@BranchName  varchar(20)
       
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
		@SQL Varchar(2000),
		@AR_COUNT INT
CREATE TABLE #REGIONEXIST (Bankid VARCHAR(20))
Set @BranchCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
Open @BranchCur
Fetch Next From @BranchCur into @share_db,@share_server
While @@Fetch_Status = 0       
	BEGIN
		SET @SQL = "INSERT INTO #REGIONEXIST (Bankid) SELECT Bankid FROM " + @share_server + "." + @share_db + ".DBO.pobank WHERE Bankid = '" + @Bankid + "'"
		--PRINT @SQL
	    EXEC(@SQL)
		SELECT @AR_COUNT = COUNT(1) FROM #REGIONEXIST
		IF @AR_COUNT = 0
			BEGIN
				SET @SQL = "INSERT INTO " + @share_server + "." + @share_db + ".DBO.pobank "
				SET @SQL = @SQL + "(Bankid, Bank_Name, Branch_Name) "
				SET @SQL = @SQL + "VALUES ('" + @Bankid + "', '" + @BankName + "', '" + @BranchName  + "')"
				--PRINT @SQL
				EXEC(@SQL)
				IF @@ERROR <> 0
					BEGIN
						RETURN
					END
			END
		TRUNCATE TABLE #REGIONEXIST
		Fetch Next From @BranchCur into @share_db,@share_server
	END     
Close @BranchCur  
DeAllocate @BranchCur

GO
