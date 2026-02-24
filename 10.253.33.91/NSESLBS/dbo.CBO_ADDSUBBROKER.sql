-- Object: PROCEDURE dbo.CBO_ADDSUBBROKER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE CBO_ADDSUBBROKER
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
      @rparty_code     varchar(10)      
)
AS
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
		SET @SQL = "INSERT INTO #SUBBROKEREXIST (SUB_BROKER) SELECT SUB_BROKER FROM " + @share_server + "." + @share_db + ".DBO.SubBrokers WHERE SUB_BROKER = '" + @subbroker + "'"
		PRINT @SQL
	    EXEC(@SQL)
		SELECT @SB_COUNT = COUNT(1) FROM #SUBBROKEREXIST
		IF @SB_COUNT = 0
			BEGIN
				SET @SQL = "INSERT INTO " + @share_server + "." + @share_db + ".DBO.SUBBROKERS	"
				SET @SQL = @SQL + "(SUB_BROKER, NAME,ADDRESS1, ADDRESS2,CITY, STATE, NATION, ZIP, FAX, PHONE1, PHONE2,REG_NO,REGISTERED, MAIN_SUB,EMAIL,COM_PERC,BRANCH_CODE, CONTACT_PERSON, REMPARTYCODE) "
				SET @SQL = @SQL + "VALUES ('" + @subbroker  + "', '" + @name + "', '" + @add1 + "', '" + @add2 + "', '" + @city  + "', '" + @state + "', '" + @nation + "', '" + @zip + "', '" + @fax + "', '" + @phone1 + "', '" + @phone2 + "', '" + @regno + "', '" + Case When @registered = 'Y' Then '1' Else '0' End + "', '" + @mainsub + "', '" + @email + "', " + Convert(Varchar(20), @comperc)  + ", '" + @branchcode + "', '" + @contperson + "', '" + @rparty_code + "')"
				--PRINT @SQL
				EXEC(@SQL)
				IF @@ERROR <> 0
					BEGIN
						RETURN
					END
			END
		TRUNCATE TABLE #SUBBROKEREXIST
		Fetch Next From @BranchCur into @share_db,@share_server
	END     
Close @BranchCur  
DeAllocate @BranchCur

GO
