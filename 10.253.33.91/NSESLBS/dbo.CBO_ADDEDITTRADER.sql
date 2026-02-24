-- Object: PROCEDURE dbo.CBO_ADDEDITTRADER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure CBO_ADDEDITTRADER
(
      @shortname       varchar(20),
      @longname        varchar(50),
      @branchcode      varchar(50),
      @add1            varchar(25),
      @add2            varchar(25),
      @city            varchar(20),
      @state           char(15),
      @nation          char(15),
      @zip             char(15),
      @phone1          char(15),
      @phone2          char(15),
      @fax             char(15),
      @email           char(50),
      @securitynet     varchar(1),
      @moneynet        char(1),
      @comperc         money, 
      @terminalid      varchar(10),
      @flag	           varchar(1),
      @STATUSID        VARCHAR(25),
      @STATUSNAME      VARCHAR(25),
      @remote          char(1)='',
      @excisereg       char(1)='',
      @contperson      char(25)='',
      @dtrader         char(1)=''

 )
 AS
	IF @STATUSID <> 'BROKER'
	BEGIN
		RAISERROR ('This Procedure is accessible to Broker', 16, 1)
		RETURN
	END
	IF @FLAG <> 'A' AND @FLAG <> 'E' AND @FLAG <> 'D'
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
		CREATE TABLE #TRADEREXIST (SHORT_NAME VARCHAR(10))
		Set @BranchCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
		Open @BranchCur
		Fetch Next From @BranchCur into @share_db,@share_server
		While @@Fetch_Status = 0       
			BEGIN
				IF @flag = 'A'
				BEGIN
					SET @SQL = "INSERT INTO #TRADEREXIST (SHORT_NAME) SELECT SHORT_NAME  FROM " + @share_server + "." + @share_db + ".DBO.BRANCHES WHERE SHORT_NAME = '" + @shortname + "'"
					--PRINT @SQL
					EXEC(@SQL)
					SELECT @SB_COUNT = COUNT(1) FROM #TRADEREXIST
				  --END
				IF @SB_COUNT = 0
				BEGIN
					SET @SQL = "INSERT INTO " + @share_server + "." + @share_db + ".DBO.BRANCHES	"
					SET @SQL = @SQL + "(SHORT_NAME ,LONG_NAME,BRANCH_CD,ADDRESS1, ADDRESS2,CITY, STATE, NATION, ZIP, PHONE1, PHONE2,FAX,EMAIL,SECURITY_NET,MONEY_NET,COM_PERC,TERMINAL_ID,REMOTE,EXCISE_REG,CONTACT_PERSON,DEFTRADER) "
					SET @SQL = @SQL + "VALUES ('" + @shortname  + "', '" + @longname + "', '" + @branchcode + "', '" + @add1 + "', '" + @add2 + "', '" + @city  + "', '" + @state + "', '" + @nation + "', '" + @zip + "','" + @phone1 + "', '" + @phone2 + "','" + @fax + "',  '" + @email + "','" + Case When @securitynet = 'Y' Then '1' Else '0' End + "', '" + @moneynet + "', " + Convert(Varchar(20), @comperc)  + ",'" + @terminalid + "', '" + @remote + "','" + @excisereg + "','" + @contperson + "','"+ @dtrader +"')"
					--PRINT @SQL
				  EXEC(@SQL)
				End
        End
			  Else IF @flag = 'E'
				BEGIN
					SET @SQL = "UPDATE " + @share_server + "." + @share_db + ".DBO.BRANCHES	"
					SET @SQL = @SQL + " SET SHORT_NAME='" + @shortname + "',LONG_NAME='" + @longname + "',BRANCH_CD='" + @branchcode + "',ADDRESS1='" + @add1 + "',ADDRESS2='" + @add2 + "',CITY='" + @city+ "',STATE='" + @state + "',NATION='" + @nation + "',ZIP='" + @zip + "',PHONE1='" + @phone1 + "',PHONE2='" + @phone2 +  "',FAX='" + @fax + "',EMAIL='"+ @email +"',SECURITY_NET='" + Case When @securitynet = 'Y' Then '1' Else '0' End + "',MONEY_NET='"+  @moneynet +"',COM_PERC=" + CONVERT(VARCHAR(20),@comperc) + ",TERMINAL_ID='"+ @terminalid +"',REMOTE='" + @remote + "',EXCISE_REG='"+  @excisereg +"',CONTACT_PERSON='"+ @contperson +"',DEFTRADER='"+ @dtrader +"'WHERE SHORT_NAME='"+  @shortname + "'"
					--print(@SQL)
                                                                  EXEC(@SQL)
				END
        TRUNCATE TABLE #TRADEREXIST
		    Fetch Next From @BranchCur into @share_db,@share_server
			END
			Close @BranchCur  
			DeAllocate @BranchCur

GO
