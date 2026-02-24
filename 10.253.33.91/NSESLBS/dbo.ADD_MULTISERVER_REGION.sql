-- Object: PROCEDURE dbo.ADD_MULTISERVER_REGION
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE ADD_MULTISERVER_REGION
(
      @region_code  varchar(20),
      @desc       varchar(50),
      @code_bran  varchar(10) 
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
CREATE TABLE #REGIONEXIST (REGIONCODE VARCHAR(20))
Set @BranchCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
Open @BranchCur
Fetch Next From @BranchCur into @share_db,@share_server
While @@Fetch_Status = 0       
	BEGIN
		SET @SQL = "INSERT INTO #REGIONEXIST (REGIONCODE) SELECT REGIONCODE FROM " + @share_server + "." + @share_db + ".DBO.REGION WHERE REGIONCODE = '" + @region_code + "' AND BRANCH_CODE = '" + @code_bran + "'"
		--PRINT @SQL
	    EXEC(@SQL)
		SELECT @AR_COUNT = COUNT(1) FROM #REGIONEXIST
		IF @AR_COUNT = 0
			BEGIN
				SET @SQL = "INSERT INTO " + @share_server + "." + @share_db + ".DBO.REGION "
				SET @SQL = @SQL + "(REGIONCODE, DESCRIPTION, BRANCH_CODE) "
				SET @SQL = @SQL + "VALUES ('" + @region_code + "', '" + @desc + "', '" + @code_bran + "')"
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
