-- Object: PROCEDURE dbo.CBO_ADDEDITACCBRANCH
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure CBO_ADDEDITACCBRANCH
(
      @branchcode       varchar(80),
      @branch           varchar(20),
      @add1             varchar(100),
      @add2             varchar(100),
      @city             varchar(100),
      @state            varchar(40),
      @nation           varchar(30),
      @zip              varchar(30),
      @phone1           varchar(30),
      @phone2           varchar(30),
      @fax              varchar(30),
      @email            varchar(30),
      @remote           bit,
      @securitynet      bit,
      @moneynet         bit,
      @excisereg        varchar(60),
      @contperson       varchar(100),
      @prefix           varchar(3), 
      @rparty_code      varchar(10),
      @flag	            varchar(1),
      @STATUSID         VARCHAR(25),
      @STATUSNAME       VARCHAR(25),
      @maincontrolac    varchar(10)='HOCTRL',
      @longname         varchar(10)=''
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
				IF @flag = 'A'       
				BEGIN
					SET @SQL = "INSERT INTO #BRANCHEXIT (BRANCH_CODE) SELECT BRANCH_CODE FROM " + @share_server + "." + @share_db + ".DBO.BRANCH WHERE BRANCH_CODE = '" + @branchcode + "'"
					--PRINT(@SQL)
          EXEC(@SQL)
					SELECT @SB_COUNT = COUNT(1) FROM #BRANCHEXIT
					IF @SB_COUNT = 0
					BEGIN
						SET @SQL = "INSERT INTO " + @share_server + "." + @share_db + ".DBO.BRANCH	"
						SET @SQL = @SQL + "(BRANCH_CODE, BRANCH,ADDRESS1, ADDRESS2,CITY, STATE, NATION, ZIP,PHONE1, PHONE2, FAX,EMAIL,REMOTE, SECURITY_NET,MONEY_NET,EXCISE_REG, CONTACT_PERSON,PREFIX, REMPARTYCODE,LONG_NAME) "
						SET @SQL = @SQL + "VALUES ('" + @branchcode  + "', '" + @branch + "', '" + @add1 + "', '" + @add2 + "', '" + @city  + "', '" + @state + "', '" + @nation + "', '" + @zip + "', '" + @phone1 + "', '" + @phone2 + "', '" + @fax + "', '" + @email + "',  '" + CONVERT(VARCHAR(1),@remote) + "', '" + CONVERT(VARCHAR(1),@securitynet) + "'," + CONVERT(VARCHAR(1),@moneynet) + ",'" + @excisereg + "', '" + @contperson + "', '" + @prefix + "',  '" + @rparty_code + "' ,'" + @longname + "')"
						--PRINT @SQL
					  EXEC(@SQL)
					End
	      END
        CREATE TABLE #TEMP (FLD INT)
        SET @SQL = "INSERT INTO #TEMP SELECT COUNT(1) FROM " + @AccountServer + "." + @AccountDB + ".DBO.COSTMAST WHERE COSTNAME = '" + @branchcode + "'"
				--print(@SQL)
        EXEC(@SQL)
		    SELECT @SQLVAR = FLD FROM #TEMP
				DROP TABLE #TEMP
					IF @SQLVAR = 0
						BEGIN
              SET @SQL = "INSERT INTO " + @AccountServer + "." + @AccountDB + ".DBO.COSTMAST"
              SET @SQL = @SQL  + " SELECT " + " '" + @branchcode + "' , ISNULL(MAX(COSTCODE)+1, 1), '1', '10000000000'" 
              SET @SQL = @SQL + " FROM " + @AccountServer + "." + @AccountDB + ".DBO.COSTMAST"
              --PRINT(@SQL)
              EXEC(@SQL)
            END
		    CREATE TABLE #TEMP1 (FLD INT)
        SET @SQL= "INSERT INTO #TEMP1 SELECT COUNT(1) FROM " + @AccountServer + "." + @AccountDB + ".DBO.BRANCHACCOUNTS WHERE BRANCHNAME = '" + @branchcode + "'"
				--PRINT(@SQL)
				EXEC(@SQL)
		    SELECT @SQLVAR = FLD FROM #TEMP1
				DROP TABLE #TEMP1
				IF @SQLVAR = 0
					BEGIN
						SET @SQL = "INSERT INTO " + @AccountServer + "." + @AccountDB + ".DBO.BRANCHACCOUNTS VALUES "
						SET @SQL = @SQL  + "('" + @branchcode + "',(Case When Len(LTrim(RTrim(' " + @BranchCode + " ')) + 'CTRL') > 10 Then LTrim(RTrim(' " + @BranchCode + " ')) Else (LTrim(RTrim(' " + @BranchCode + " ')) + 'CTRL') End),'" + @maincontrolac +"',0)" 
						--PRINT(@SQL)
						exec(@SQL)   
					END
	   		CREATE TABLE #TEMP2 (FLD INT)
				SET @SQL = "INSERT INTO #TEMP2 SELECT COUNT(1) FROM  " + @AccountServer + "." + @AccountDB + ".DBO.ACMAST  WHERE ACNAME = '" + (Case When Len(LTrim(RTrim('"+ @BranchCode +"')) + 'CTRL') > 10 Then LTrim(RTrim('"+ @BranchCode +"')) Else (LTrim(RTrim('"+ @BranchCode +"')) + 'CTRL') End) + "'"
				--PRINT(@SQL)
				EXEC(@SQL)
				SELECT @SQLVAR = FLD FROM #TEMP2
				DROP TABLE #TEMP2
				IF @SQLVAR = 0
					BEGIN
						SET @SQL = "INSERT INTO " + @AccountServer + "." + @AccountDB + ".DBO.ACMAST"
						SET @SQL = @SQL + " SELECT " + "LTRIM(RTRIM('"+ @branchcode +"')) + ' CONTROL A/C',LTRIM(RTRIM('"+ @branchcode +"')) + ' CONTROL A/C','ASSET','4','', (Case When Len(LTrim(RTrim('"+ @branchcode +"')) + 'CTRL') > 10 Then LTrim(RTrim('"+ @branchcode +"')) Else (LTrim(RTrim('"+ @branchcode +"')) + 'CTRL') End),'', 'A0000000000', '','0',LTRIM(RTRIM('"+ @branchcode + "')), '0','C', '',	'', ''"
						--PRINT(@SQL) 
						EXEC(@SQL) 
					END  
				Else IF @flag = 'E'
					BEGIN
						SET @SQL = "UPDATE " + @share_server + "." + @share_db + ".DBO.BRANCH"
						SET @SQL = @SQL + " SET BRANCH_CODE='" + @branchcode + "',BRANCH='" + @branch + "',ADDRESS1='" + @add1 + "',ADDRESS2='" + @add2 + "',CITY='" + @city+ "',STATE='" + @state + "',NATION='" + @nation + "',ZIP='" + @zip + "',PHONE1='" + @phone1 + "',PHONE2='" + @phone2 +  "',FAX='" + @fax + "',EMAIL='"+ @email +"',REMOTE='" + CONVERT(VARCHAR(1),@remote) + "',SECURITY_NET='" + CONVERT(VARCHAR(1),@securitynet) +"',MONEY_NET='"+ CONVERT(VARCHAR(1),@moneynet) +"',EXCISE_REG='"+ @excisereg +"', CONTACT_PERSON='"+ @contperson +"', PREFIX='"+ @contperson +"',REMPARTYCODE='"+ @rparty_code +"',LONG_NAME='"+ @longname +"'WHERE BRANCH_CODE='"+ @branchcode + "'"
						--print(@SQL)
						EXEC(@SQL)
					END
				TRUNCATE TABLE #BRANCHEXIT
				Fetch Next From @BranchCur into @share_db,@share_server, @AccountDB, @AccountServer
			End
				Close @BranchCur  
				DeAllocate @BranchCur

GO
