-- Object: PROCEDURE dbo.ADD_MULTISERVER_MULTIBANK
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------






CREATE           PROCEDURE ADD_MULTISERVER_MULTIBANK
(
      @cltcode varchar(20),
      @ACCONT_NO varchar(10),
      @ACCONT_TYPE varchar(10),
      @CHEQE_NAME varchar(10),
      @DEFAULT char(10)     
)
AS
DECLARE
		@Result int,
		@MultiBankCur Cursor,
		@Account_db   varchar(50),
                @Account_server  varchar(50),
		@SQL Varchar(2000),
		@SB_COUNT INT
CREATE TABLE #MULTIBANKEXIST (Cltcode1 VARCHAR(10))
Set @MultiBankCur = Cursor for  Select  ACCOUNTDB,ACCOUNTSERVER From Pradnya.dbo.multicompany where primaryserver = 1
Open @MultiBankCur
Fetch Next From @MultiBankCur into @Account_db,@Account_server
While @@Fetch_Status = 0       
	BEGIN
		SET @SQL = "INSERT INTO #MULTIBANKEXIST  (Cltcode1 ) SELECT Cltcode FROM " + @Account_server + "." + @Account_db + ".DBO.multibankid WHERE Cltcode = '" + @cltcode + "'"
		--PRINT @SQL
	   EXEC(@SQL)
		SELECT @SB_COUNT = COUNT(1) FROM #MULTIBANKEXIST
		IF @SB_COUNT = 0
			BEGIN
				SET @SQL = "INSERT INTO " + @Account_server + "." +@Account_db + ".DBO.multibankid"
				SET @SQL= @SQL + "(Cltcode, AccNo, AccType, ChequeName, DefaultBank) "
				SET @SQL =@SQL + "VALUES ( '" + @cltcode+ "','" + @ACCONT_NO+ "','" +  @ACCONT_TYPE+ "','" + @CHEQE_NAME+ "','" + @DEFAULT+ "')"
				--PRINT @SQL
				EXEC(@SQL)
				IF @@ERROR <> 0
					BEGIN
						RETURN
					END
			END
                
		TRUNCATE TABLE #MULTIBANKEXIST
		Fetch Next From @MultiBankCur into @Account_db,@Account_server
	END     
Close @MultiBankCur
DeAllocate @MultiBankCur

GO
