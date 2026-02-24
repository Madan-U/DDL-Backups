-- Object: PROCEDURE dbo.ADD_MULTISERVER_MULTIBANK1
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------








create       PROCEDURE [dbo].[ADD_MULTISERVER_MULTIBANK1]
(
      @cltcode varchar(20),
   
      @ACCONT_NO varchar(10),
      @ACCONT_TYPE varchar(10),
      @CHEQE_NAME varchar(10),
      @DEFAULT char(10)
)
AS
/*
	BEGIN TRAN
	EXEC ADD_MULTISERVER_AREA 'TEST', 'TEST', 'MUMBAI'
	ROLLBACK
*/
DECLARE
		@MultiBankCur Cursor,
		--@Exch_nage   varchar(50),
               -- @Segmen_t   varchar(50),
                @Account_db   varchar(50),
                @Account_server  varchar(50),
                @share_db   varchar(50),
		@share_server varchar(50),
		--@SQL Varchar(2000),
               -- @SQLFIRST Varchar(2000),
                @SQLSECOND Varchar(2000)
		

Set @MultiBankCur = Cursor for  Select  SHAREDB,SHARESERVER,ACCOUNTDB,ACCOUNTSERVER,DEFAULTDB From Pradnya.dbo.multicompany where primaryserver = 1
Open @MultiBankCur
Fetch Next From @MultiBankCur into @share_db,@share_server,@Account_db,@Account_server--,@Exch_nage,@Segmen_t   
While @@Fetch_Status = 0       
	BEGIN
		
		--SELECT @AR_COUNT =  SELECT COUNT(1) FROM "" + @Account_server + "." + @Account_db + ".DBO.ACMAST WHERE Cltcode = '" + @Cltcode + "'
		--IF @AR_COUNT = 0
			--BEGIN
				--SET @SQL = "INSERT INTO " + @Account_server + "." + @Account_db +  "DBO.ACMAST "
				--SET @SQL = @SQL + "(Cltcode) "
				--SET @SQL = @SQL + "VALUES ( '" + @cltcode + "')"
				--PRINT @SQL
				--EXEC(@SQL)
				--IF @@ERROR <> 0
				--BEGIN
					--	RETURN
				---	END
			--END
                     --  BEGIN
				--SET @SQLFIRST  = "INSERT INTO " + @share_server + "." + @share_db +  "dbo.pobank "
				--SET @SQLFIRST = @SQLFIRST  + "(Bank_Name,Branch_Name) "
				--SET @SQLFIRST  = @SQLFIRST + "VALUES ( '" + @BANK  + "','" +@BRANCH_NAME  + "')"
				--PRINT @SQL
				--EXEC( @SQLFIRST)
				--IF @@ERROR <> 0
					--BEGIN
					--	RETURN
					--END
			--END
                       BEGIN
				SET @SQLSECOND = "INSERT INTO " + @Account_server + "." + @Account_db +  "DBO.multibankid "
				SET @SQLSECOND= @SQLSECOND + "(Cltcode, AccNo, AccType, ChequeName, DefaultBank) "
				SET @SQLSECOND =@SQLSECOND + "VALUES ( '" + @cltcode+ "','" + @ACCONT_NO+ "','" +  @ACCONT_TYPE+ "','" + @CHEQE_NAME+ "','" + @DEFAULT+ "')"
				--PRINT @SQL
				EXEC(@SQLSECOND)
				IF @@ERROR <> 0
					BEGIN
						RETURN
					END
			END

                        
		
		Fetch Next From @MultiBankCur into @share_db,@share_server,@Account_db,@Account_server--,@Exch_nage,@Segmen_t   
	END     
Close @MultiBankCur  
DeAllocate @MultiBankCur

GO
