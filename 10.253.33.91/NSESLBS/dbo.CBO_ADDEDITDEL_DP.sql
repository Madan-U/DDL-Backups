-- Object: PROCEDURE dbo.CBO_ADDEDITDEL_DP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





CREATE   PROCEDURE [dbo].[CBO_ADDEDITDEL_DP]
(
      @bank_id       varchar(16),
      @bank_name     varchar(60),
      @add1          varchar(60),
      @add2          varchar(60),
      @city          varchar(40),
      @pin_code      varchar(20),
      @phone_1       varchar(20),
      @phone_2       varchar(20),
      @phone_3       varchar(20),
      @phone_4       varchar(20),
      @fax_1         varchar(40),
      @fax_2         varchar(20),
      @e_mail        varchar(50),
      @bank_type     varchar(5),
      @flag	     varchar(1),
      @STATUSID VARCHAR(25),
      @STATUSNAME VARCHAR(25)
)
/*
	BEGIN TRAN
	EXEC CBO_ADDEDITDEL_DP 'ASADIHG', 'HDFC', '', '', '', '', '', '', '', '', '', '', '', '', 'A', 'BROKER', 'BROKER'
	ROLLBACK
*/
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
		@DPCur Cursor,
		@share_db   varchar(50),
		@share_server varchar(50),
		@SQL Varchar(2000),
		@SB_COUNT INT
CREATE TABLE #BANKEXIST (BANKID VARCHAR(16))
Set @DPCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
Open @DPCur
Fetch Next From @DPCur into @share_db,@share_server
While @@Fetch_Status = 0       
	BEGIN
		If @Flag = 'A'
			Begin
				
				
			        						
			        SET @SQL = "INSERT INTO #BANKEXIST (BANKID) SELECT BANKID FROM " + @share_server + "." + @share_db + ".DBO.BANK WHERE BANKID = '" + @bank_id + "'"
			        --PRINT @SQL
				EXEC(@SQL)
				SELECT @SB_COUNT = COUNT(1) FROM #BANKEXIST
				IF @SB_COUNT = 0
					BEGIN	
		       			SET @SQL = "INSERT INTO " + @share_server + "." + @share_db + ".DBO.BANK"
						SET @SQL = @SQL + "(BANKID,BANKNAME,ADDRESS1, ADDRESS2,CITY,PINCODE,PHONE1,PHONE2,PHONE3, PHONE4, FAX1,FAX2,EMAIL, BANKTYPE) "
						SET @SQL = @SQL + "VALUES ('" + @bank_id + "', '" + @bank_name + "', '" + @add1 + "', '" + @add2 + "', '" + @city  + "', '" + @pin_code + "', '" + @phone_1 + "', '" + @phone_2 + "', '" + @phone_3 + "', '" + @phone_4 + "', '" + @fax_1 + "', '" + @fax_2 + "', '" + @e_mail + "', '" + @bank_type + "')"
						--PRINT @SQL
						EXEC(@SQL)
					END	
			End
		Else IF @flag = 'E'
			BEGIN
				SET @SQL = "DELETE " + @share_server + "." + @share_db + ".DBO.BANK"
				SET @SQL = @SQL + " WHERE BANKID='"+@bank_id+"'"
				EXEC(@SQL)
                                SET @SQL = "INSERT INTO " + @share_server + "." + @share_db + ".DBO.BANK"
				SET @SQL = @SQL + "(BANKID,BANKNAME,ADDRESS1, ADDRESS2,CITY,PINCODE,PHONE1,PHONE2,PHONE3, PHONE4, FAX1,FAX2,EMAIL, BANKTYPE) "
				SET @SQL = @SQL + "VALUES ('" + @bank_id + "', '" + @bank_name + "', '" + @add1 + "', '" + @add2 + "', '" + @city  + "', '" + @pin_code + "', '" + @phone_1 + "', '" + @phone_2 + "', '" + @phone_3 + "', '" + @phone_4 + "', '" + @fax_1 + "', '" + @fax_2 + "', '" + @e_mail + "', '" + @bank_type + "')"
				--PRINT @SQL
				EXEC(@SQL)
				--PRINT @SQL
			END
		Else IF @flag ='D'
			BEGIN
				SET @SQL = "DELETE " + @share_server + "." + @share_db + ".DBO.BANK"
				SET @SQL = @SQL + " WHERE BANKID='"+@bank_id+"'"
				EXEC(@SQL)
			END
		TRUNCATE TABLE #BANKEXIST
		Fetch Next From @DPCur into @share_db,@share_server
	END     
Close @DPCur  
DeAllocate @DPCur

GO
