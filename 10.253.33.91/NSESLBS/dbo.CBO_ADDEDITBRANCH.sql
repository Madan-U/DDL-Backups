-- Object: PROCEDURE dbo.CBO_ADDEDITBRANCH
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE procedure [dbo].[CBO_ADDEDITBRANCH]
(
      @branchcode       varchar(20),
      @branch           varchar(80),
      @add1             varchar(100),
      @add2             varchar(100),
      @city             varchar(40),
      @state            varchar(30),
      @nation           varchar(30),
      @zip              varchar(30),
      @phone1           varchar(30),
      @phone2           varchar(30),
      @fax              varchar(30),
      @email            varchar(100),
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
      @longname         varchar(100)=''
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
		@SB_COUNT INT
		CREATE TABLE #BRANCHEXIT (BRANCH_CODE VARCHAR(20))
		Set @BranchCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
		Open @BranchCur
		Fetch Next From @BranchCur into @share_db,@share_server
		While @@Fetch_Status = 0       
			BEGIN
				IF @flag = 'A'
				BEGIN
					SET @SQL = "INSERT INTO #BRANCHEXIT (BRANCH_CODE) SELECT BRANCH_CODE FROM " + @share_server + "." + @share_db + ".DBO.BRANCH WHERE BRANCH_CODE = '" + @branchcode + "'"
					--PRINT @SQL
					EXEC(@SQL)
					SELECT @SB_COUNT = COUNT(1) FROM #BRANCHEXIT
				  --END
				IF @SB_COUNT = 0
				BEGIN
					SET @SQL = "INSERT INTO " + @share_server + "." + @share_db + ".DBO.BRANCH	"
					SET @SQL = @SQL + "(BRANCH_CODE, BRANCH,ADDRESS1, ADDRESS2,CITY, STATE, NATION, ZIP,PHONE1, PHONE2, FAX,EMAIL,REMOTE, SECURITY_NET,MONEY_NET,EXCISE_REG, CONTACT_PERSON,PREFIX, REMPARTYCODE,LONG_NAME) "
          --SET @SQL = @SQL + "(BRANCH_CODE, BRANCH,ADDRESS1, ADDRESS2,CITY, STATE, NATION, ZIP,PHONE1, PHONE2, FAX,EMAIL,REMOTE, SECURITY_NET,MONEY_NET,EXCISE_REG, CONTACT_PERSON,PREFIX, REMPARTYCODE) "
					SET @SQL = @SQL + "VALUES ('" + @branchcode  + "', '" + @branch + "', '" + @add1 + "', '" + @add2 + "', '" + @city  + "', '" + @state + "', '" + @nation + "', '" + @zip + "', '" + @phone1 + "', '" + @phone2 + "', '" + @fax + "', '" + @email + "',  '" + CONVERT(VARCHAR(1),@remote) + "', '" + CONVERT(VARCHAR(1),@securitynet) + "'," + CONVERT(VARCHAR(1),@moneynet) + ",'" + @excisereg + "', '" + @contperson + "', '" + @prefix + "',  '" + @rparty_code + "', '" + @longname + "')"
          --SET @SQL = @SQL + "VALUES ('" + @branchcode  + "', '" + @branch + "', '" + @add1 + "', '" + @add2 + "', '" + @city  + "', '" + @state + "', '" + @nation + "', '" + @zip + "', '" + @phone1 + "', '" + @phone2 + "', '" + @fax + "', '" + @email + "',  '" + CONVERT(VARCHAR(1),@remote) + "', '" + CONVERT(VARCHAR(1),@securitynet) + "'," + CONVERT(VARCHAR(1),@moneynet) + ",'" + @excisereg + "', '" + @contperson + "', '" + @prefix + "',  '" + @rparty_code + "')"
					--PRINT @SQL
				  EXEC(@SQL)
				End
        End
			  Else IF @flag = 'E'
				BEGIN
					SET @SQL = "UPDATE " + @share_server + "." + @share_db + ".DBO.BRANCH"
					SET @SQL = @SQL + " SET BRANCH_CODE='" + @branchcode + "',BRANCH='" + @branch + "',ADDRESS1='" + @add1 + "',ADDRESS2='" + @add2 + "',CITY='" + @city+ "',STATE='" + @state + "',NATION='" + @nation + "',ZIP='" + @zip + "',PHONE1='" + @phone1 + "',PHONE2='" + @phone2 +  "',FAX='" + @fax + "',EMAIL='"+ @email +"',REMOTE=" + CONVERT(VARCHAR(1),@remote) + ",SECURITY_NET=" + CONVERT(VARCHAR(1),@securitynet) +",MONEY_NET="+ CONVERT(VARCHAR(1),@moneynet) +",EXCISE_REG='"+ @excisereg +"', CONTACT_PERSON='"+ @contperson +"', PREFIX='"+ @prefix +"',REMPARTYCODE='"+ @rparty_code +"',LONG_NAME='"+ @longname +"'WHERE BRANCH_CODE='"+ @branchcode + "'"
					--print(@SQL)
          EXEC(@SQL)
				END
        TRUNCATE TABLE #BRANCHEXIT
		    Fetch Next From @BranchCur into @share_db,@share_server
			END
			Close @BranchCur  
			DeAllocate @BranchCur

GO
