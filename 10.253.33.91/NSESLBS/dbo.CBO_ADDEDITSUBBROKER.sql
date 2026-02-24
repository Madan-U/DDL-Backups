-- Object: PROCEDURE dbo.CBO_ADDEDITSUBBROKER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure CBO_ADDEDITSUBBROKER
(
      @subbroker       varchar(10),
      @name            varchar(50),
      @add1            char(100),
      @add2            char(100),
      @city            char(20),
      @state           char(15),
      @nation          char(15),
      @zip             char(10),
      @fax             char(15),
      @phone1          char(15),
      @phone2          char(15),
      @regno           char(30),
      @registered      varchar(1),
      @mainsub         char(1),
      @email           char(50),
      @comperc         money, 
      @branchcode      varchar(10),
      @contperson      varchar(100), 
      @rparty_code     varchar(10),     
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
		CREATE TABLE #SUBBROKEREXIST (SUB_BROKER VARCHAR(10))
		Set @BranchCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
		Open @BranchCur
		Fetch Next From @BranchCur into @share_db,@share_server
		While @@Fetch_Status = 0       
			BEGIN
				IF @flag = 'A'
				BEGIN
					SET @SQL = "INSERT INTO #SUBBROKEREXIST (SUB_BROKER) SELECT SUB_BROKER FROM " + @share_server + "." + @share_db + ".DBO.SubBrokers WHERE SUB_BROKER = '" + @subbroker + "'"
					--PRINT @SQL
					EXEC(@SQL)
					SELECT @SB_COUNT = COUNT(1) FROM #SUBBROKEREXIST
				  --END
				IF @SB_COUNT = 0
				BEGIN
					SET @SQL = "INSERT INTO " + @share_server + "." + @share_db + ".DBO.SUBBROKERS	"
					SET @SQL = @SQL + "(SUB_BROKER, NAME,ADDRESS1, ADDRESS2,CITY, STATE, NATION, ZIP, FAX, PHONE1, PHONE2,REG_NO,REGISTERED, MAIN_SUB,EMAIL,COM_PERC,BRANCH_CODE, CONTACT_PERSON, REMPARTYCODE) "
					SET @SQL = @SQL + "VALUES ('" + @subbroker  + "', '" + @name + "', '" + @add1 + "', '" + @add2 + "', '" + @city  + "', '" + @state + "', '" + @nation + "', '" + @zip + "', '" + @fax + "', '" + @phone1 + "', '" + @phone2 + "', '" + @regno + "', '" + Case When @registered = 'Y' Then '1' Else '0' End + "', '" + @mainsub + "', '" + @email + "', " + Convert(Varchar(20), @comperc)  + ", '" + @branchcode + "', '" + @contperson + "', '" + @rparty_code + "')"
					--PRINT @SQL
				  EXEC(@SQL)
				End
        End
			  Else IF @flag = 'E'
				BEGIN
					SET @SQL = "UPDATE " + @share_server + "." + @share_db + ".DBO.SUBBROKERS"
					SET @SQL = @SQL + " SET SUB_BROKER='" + @subbroker + "',NAME='" + @name + "',ADDRESS1='" + @add1 + "',ADDRESS2='" + @add2 + "',CITY='" + @city+ "',STATE='" + @state + "',NATION='" + @nation + "',ZIP='" + @zip + "',FAX='" + @fax + "',PHONE1='" + @phone1 + "',PHONE2='" + @phone2 +  "',REG_NO='" + @regno + "',REGISTERED='" + Case When @registered = 'Y' Then '1' Else '0' End + "',MAIN_SUB='"+ @mainsub +"',EMAIL='"+ @email +"',COM_PERC=" + CONVERT(VARCHAR(20),@comperc) + ",BRANCH_CODE='"+ @branchcode +"' , CONTACT_PERSON='"+ @contperson +"',REMPARTYCODE='"+ @rparty_code +"'WHERE SUB_BROKER='"+ @subbroker + "'"
					--print(@SQL)
          EXEC(@SQL)
				END
        TRUNCATE TABLE #SUBBROKEREXIST
		    Fetch Next From @BranchCur into @share_db,@share_server
			END
			Close @BranchCur  
			DeAllocate @BranchCur

GO
