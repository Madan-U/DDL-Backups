-- Object: PROCEDURE dbo.CI_MULTIBANK_DELETION
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE [dbo].[CI_MULTIBANK_DELETION] (@CLTCODE VARCHAR(10),@ACCNO VARCHAR(20),@BANKNAME VARCHAR(100),@BR_ADD VARCHAR(100))
AS

INSERT INTO CI_bank_Deletion VALUES (@CLTCODE,@ACCNO,@BANKNAME,@BR_ADD,GETDATE())

SELECT ShareServer,ShareDb ,AccountDb into #1
FROM PRADNYA.DBO.multicompany   WHERE ShareServer <> 'ANGELDEMAT'

Alter table #1 add Id int Not nULL identity(1,1)

Select * From #1

Declare @i int,@Max int
DECLARE @SQL VARCHAR(1000)

DECLARE @Shareserver varchar(20),@ShareDb varchar(15),@AccountDb varchar(15)
Set @i =1

Select @Max=Count(*) from #1
While @i<@Max
	Begin
		Select @Shareserver=ShareServer,@ShareDb=ShareDb ,@AccountDb=AccountDb From #1 where Id =@i
		IF @SHARESERVER ='ANAND1'
			BEGIN 
				SET @SQL = 'DELETE FROM '+ @ShareDb +'.DBO.CLIENT4 WHERE  ' 
				SET @SQL = @SQL + ' CLTCODE = '''+@CLTCODE +''' AND CLTDPID ='''+@ACCNO +''' AND DEPOSITORY NOT IN (''CDSL'',''NSDL'') '
   
				SET @SQL = @SQL + ' DELETE FROM '+ @AccountDb+' .DBO.MULTICLTID WHERE CLTCODE = '''+@CLTCODE + ''' ' 
				SET @SQL = @SQL + ' AND CLTDPID = '''+ @ACCNO + ''' '
			END
		ELSE 
			BEGIN 
				SET @SQL = 'DELETE FROM '+ @Shareserver +'.'+ @ShareDb +'.DBO.CLIENT4 WHERE  ' 
				SET @SQL = @SQL + ' CLTCODE = '''+@CLTCODE +''' AND CLTDPID ='''+@ACCNO +''' AND DEPOSITORY NOT IN (''CDSL'',''NSDL'') '
   
				SET @SQL = @SQL + ' DELETE FROM '+ @Shareserver +'.'+  @AccountDb+' .DBO.MULTICLTID WHERE CLTCODE = '''+@CLTCODE + ''' ' 
				SET @SQL = @SQL + ' AND CLTDPID = '''+ @ACCNO + ''' '
			END

		PRINT @SQL
		Set @i=@i+1
	END
 
    DELETE from ANGELFO.BBO_FA.DBO.MULTIBANKID  WHERE CLTCODE = @CLTCODE AND ACCNO=@ACCNO
    DELETE from ANGELFO.BBO_FA.DBO.MULTIBANKID_OTHER  WHERE CLTCODE = @CLTCODE AND ACCNO=@ACCNO
  
    DELETE FROM ABVSCITRUS.CRMDB_A.DBO.CLIENT_BANK_MAPP WHERE  PARTY_CODE = @CLTCODE AND ACNUM=@ACCNO AND NEW_BANK_BRANCH =@BANKNAME

GO
