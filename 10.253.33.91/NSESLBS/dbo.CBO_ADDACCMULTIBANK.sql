-- Object: PROCEDURE dbo.CBO_ADDACCMULTIBANK
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



--select * from ACCOUNT.DBO.multibankid where DEFAULTBANK='1'
--select * from  CLIENT_DETAILS
--select * from client4
--select * from ACCOUNT.DBO.multibankid

--INSERT INTO ACCOUNT.DBO.multibankid(CLTCODE,BANKID,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK)VALUES('0A141','','111','SAVING','PRADIP',0)

--SELECT * FROM MSAJAG.DBO.POBANK

--clientCode, BankName, BranchName, AccountNo, AccountType, ChequeName, DefaultID, flag, statusId, statusName
CREATE                               procedure CBO_ADDACCMULTIBANK
(
      @clientCode       varchar(10),
      @BankName          varchar(50),
      @BranchName             varchar(40),
      @AccountNo            varchar(16),
      @AccountType           varchar(16),
      @ChequeName            varchar(16),
      @DefaultID           CHAR(1),
      @FLAG             VARCHAR(1),
      @statusId            varchar(30)='BROKER',
      @statusName           varchar(30)='BROKER'
     
 )
 AS
	
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	
        
	DECLARE
                @SQLVAR  VARCHAR(16),
                @SQLVAR1  VARCHAR(16),
                @SQLVAR2  VARCHAR(16),
                @SQLVAR3  VARCHAR(16),
                @SQLVAR4  VARCHAR(16),
                @SQLVAR5  VARCHAR(16),
                @Result int,
		@BranchCur Cursor,
		@share_db   varchar(50),
		@AccountDB Varchar(50),
		@share_server varchar(50),
		@AccountServer Varchar(50),
		@SQL Varchar(2000),
                @SQL1 Varchar(2000),
                @SQL2 Varchar(2000),
		@SB_COUNT INT
		CREATE TABLE #BANKEXIT (BANK_NAME VARCHAR(80))
		Set @BranchCur = Cursor for  Select sharedb,shareserver,AccountDb, AccountServer From Pradnya.dbo.multicompany where primaryserver = 1
		Open @BranchCur
		Fetch Next From @BranchCur into @share_db,@share_server, @AccountDB, @AccountServer
		While @@Fetch_Status = 0  
      BEGIN
                if   @FLAG ='A'   
		BEGIN
                                         
					SET @SQL = "INSERT INTO #BANKEXIT (BANK_NAME) SELECT BANK_NAME FROM " + @share_server + "." + @share_db + ".DBO.POBANK WHERE BANK_NAME = '" + @BankName  + "'AND BRANCH_NAME='"+@BranchName  +"'"
					EXEC(@SQL)
					SELECT @SB_COUNT = COUNT(1) FROM #BANKEXIT
				IF @SB_COUNT = 0
				BEGIN
					SET @SQL = "INSERT INTO " + @share_server + "." + @share_db + ".DBO.POBANK	"
					SET @SQL = @SQL + "(BANK_NAME, BRANCH_NAME) "
					SET @SQL = @SQL + "VALUES ('" + @BankName   + "', '" + @BranchName + "')"
					--PRINT @SQL
				  EXEC(@SQL)
	                          End


                           BEGIN 
                                 CREATE TABLE #TEMP1 (CLTCODE VARCHAR(10),ACCNO VARCHAR(16))
                                 SET @SQL = "INSERT INTO #TEMP1 SELECT CLTCODE,ACCNO  FROM " +  @AccountServer + "." + @AccountDB + ".DBO.MULTIBANKID WHERE DEFAULTBANK = '1'"
	                          EXEC(@SQL)
		                 SELECT @SQLVAR1 = CLTCODE , @SQLVAR5 =ACCNO FROM #TEMP1
				 DROP TABLE #TEMP1
		    
                               IF @DefaultID  = 1

		                BEGIN
                                             SET @SQL = "UPDATE " + @AccountServer + "." + @AccountDB + ".DBO.MultiBankId  "
	                                     SET @SQL = @SQL + "SET DEFAULTBANK='0' "
        	                             SET @SQL = @SQL + "WHERE CLTCODE = '" +  @SQLVAR1  + "'AND ACCNO='" + @SQLVAR5  + "'"
                                             SET @SQL1="DELETE FROM " + @share_server + "." + @share_db + ".DBO.CLIENT4 WHERE Cl_code='" + @clientCode + "' AND Depository in('SAVING','CURRENT')"
                                             EXEC(@SQL)
                                             EXEC(@SQL1)
           	                  END
                            END
                        BEGIN 
                                  CREATE TABLE #TEMP (BANKID INT)
                                  SET @SQL = "INSERT INTO #TEMP SELECT BANKID FROM " + @share_server + "." + @share_db + ".DBO.POBANK WHERE BANK_NAME = '" + @BankName + "'AND BRANCH_NAME='"+@BranchName  +"'"
				
                                   EXEC(@SQL)
		                  SELECT @SQLVAR = BANKID FROM #TEMP
				  DROP TABLE #TEMP
		    
  
		                 BEGIN
                                SET @SQL = "INSERT INTO " + @AccountServer + "." + @AccountDB + ".DBO.MULTIBANKID"
                                SET @SQL = @SQL + "(CLTCODE,BANKID,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK) "
        	                SET @SQL = @SQL + "VALUES ('" +  @clientCode     + "', '" + @SQLVAR + "','" + @AccountNo  + "','" + @AccountType  + "','" + @ChequeName  + "','" + @DefaultID  + "')"
                                EXEC(@SQL)
           	                END
                        END
                END
               Else IF @FLAG= 'D'
                  BEGIN 
                                  CREATE TABLE #TEMP2 (BANKID INT)
                                  SET @SQL = "INSERT INTO #TEMP2 SELECT BANKID FROM " + @share_server + "." + @share_db + ".DBO.POBANK WHERE BANK_NAME = '" + @BankName + "'AND BRANCH_NAME='"+@BranchName  +"'"
				
                                   EXEC(@SQL)
		                  SELECT @SQLVAR2 = BANKID FROM #TEMP2
				  DROP TABLE #TEMP2
                        BEGIN
				SET @SQL = "DELETE " + @AccountServer  + "." + @AccountDB  + ".DBO.MULTIBANKID"
				SET @SQL = @SQL + " WHERE CLTCODE='"+@clientCode+"' AND AccNo='"+ @AccountNo +"' AND BankId='"+ @SQLVAR2 +"'"
				EXEC(@SQL)
			END
                   END
              Else IF @FLAG= 'E'
		
BEGIN
                    BEGIN 
                                 CREATE TABLE #TEMP4 (CLTCODE VARCHAR(10))
                                 SET @SQL = "INSERT INTO #TEMP4 SELECT CLTCODE  FROM " +  @AccountServer + "." + @AccountDB + ".DBO.MULTIBANKID WHERE DEFAULTBANK = '1'"
	                          EXEC(@SQL)
		                 SELECT @SQLVAR4 = CLTCODE FROM #TEMP4
				 DROP TABLE #TEMP4
		    
                               IF @DefaultID  = 1

		                BEGIN
                                             SET @SQL = "UPDATE " + @AccountServer + "." + @AccountDB + ".DBO.MultiBankId  "
	                                     SET @SQL = @SQL + "SET DEFAULTBANK='0' "
        	                             SET @SQL = @SQL + "WHERE CLTCODE = '" +  @clientCode   + "'"
                                             SET @SQL1="DELETE FROM " + @share_server + "." + @share_db + ".DBO.CLIENT4 WHERE Cl_code='" + @clientCode + "' AND Depository in('SAVING','CURRENT')"
                                             SET @SQL2 = "UPDATE " + @AccountServer + "." + @AccountDB + ".DBO.MultiBankId  "
	                                     SET @SQL2 = @SQL2 + "SET DEFAULTBANK='1' "
        	                             SET @SQL2 = @SQL2+ "WHERE CLTCODE = '" +   @clientCode  + "'AND AccNo='"+ @AccountNo +"'"
                                              EXEC(@SQL)
                                             EXEC(@SQL1)
                                             EXEC(@SQL2)
           	                  END
                       END                        



                BEGIN 


			CREATE TABLE #TEMP3 (BANKID INT)
			SET @SQL = "INSERT INTO #TEMP3 SELECT BANKID FROM " + @share_server + "." + @share_db + ".DBO.POBANK WHERE BANK_NAME = '" + @BankName + "'AND BRANCH_NAME='"+@BranchName  +"'"
			
			EXEC(@SQL)
			PRINT @SQL
			SELECT @SQLVAR3 = BANKID FROM #TEMP3
			PRINT @SQLVAR3
			DROP TABLE #TEMP3
			BEGIN
				SET @SQL=''
				SET @SQL = "UPDATE " + @AccountServer + "." + @AccountDB + ".DBO.MultiBankId  "
				SET @SQL = @SQL + "SET DEFAULTBANK='"+@DefaultID+"' , ChequeName='" +  @ChequeName  + "'"
				SET @SQL = @SQL + "WHERE CLTCODE = '" +  @clientCode + "' AND AccNo='" +  @AccountNo  + "' AND BankId='" +  @SQLVAR3 + "'"
				EXEC(@SQL)
			END
		END
END
     				  TRUNCATE TABLE #BANKEXIT
			    Fetch Next From @BranchCur into @share_db,@share_server, @AccountDB, @AccountServer
				 END
			Close @BranchCur  
			DeAllocate @BranchCur
--select * from client4

GO
