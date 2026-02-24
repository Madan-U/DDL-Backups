-- Object: PROCEDURE dbo.ADDEDITAREA
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure ADDEDITAREA
(
      @area_code       varchar(20),
      @desc            varchar(50),
      @code_bran       varchar(10),   
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
	IF @FLAG <> 'A' AND @FLAG <> 'E'
	BEGIN
		RAISERROR ('Add/Edit Flags Not Set Properly', 16, 1)
		RETURN
	END
  DECLARE
		@Result int,
		@BranchCur Cursor,
		@share_db   varchar(50),
		@share_server varchar(50),
		@SQL Varchar(2000),
		@AR_COUNT INT
		CREATE TABLE #AREAEXIST(AREACODE VARCHAR(20))
		Set @BranchCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
		Open @BranchCur
		Fetch Next From @BranchCur into @share_db,@share_server
		While @@Fetch_Status = 0       
			BEGIN
			IF @flag = 'A'
				BEGIN
				SET @SQL = "INSERT INTO #AREAEXIST (AREACODE) SELECT AREACODE FROM " + @share_server + "." + @share_db + ".DBO.AREA WHERE AREACODE = '" + @area_code + "' AND BRANCH_CODE = '" + @code_bran + "'"
				--PRINT @SQL
				EXEC(@SQL)
				SELECT @AR_COUNT = COUNT(1) FROM #AREAEXIST
				--END
			IF @AR_COUNT = 0
				BEGIN
				SET @SQL = "INSERT INTO " + @share_server + "." + @share_db + ".DBO.AREA "
				SET @SQL = @SQL + "(AREACODE, DESCRIPTION, BRANCH_CODE)"
				SET @SQL = @SQL + "VALUES ('" + @area_code + "', '" + @desc + "', '" + @code_bran + "')"
				--PRINT @SQL
				EXEC(@SQL)
				End
			--End
			Else IF @flag = 'E'
				BEGIN
					SET @SQL = "UPDATE " + @share_server + "." + @share_db + ".DBO.AREA"
					SET @SQL = @SQL + " SET AREACODE='" + @area_code + "',DESCRIPTION='" + @desc + "',BRANCH_CODE='" + @code_bran + "'WHERE AREACODE='"+ @area_code + "''"
					--print(@SQL)
					EXEC(@SQL)
				END
        END
			TRUNCATE TABLE #AREAEXIST
			Fetch Next From @BranchCur into @share_db,@share_server
			END
		Close @BranchCur  
		DeAllocate @BranchCur

GO
