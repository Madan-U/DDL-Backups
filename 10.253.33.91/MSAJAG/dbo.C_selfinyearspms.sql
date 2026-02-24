-- Object: PROCEDURE dbo.C_selfinyearspms
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
CREATE Proc C_selfinyearspms (@effdate Varchar(11), @accountdb Varchar(20),@accountdbserver Varchar(50))    
As    
  
DECLARE @SQL VARCHAR(2000)  
SET @SQL = 'select Left(convert(varchar,sdtcur,109),11) Sdtcur, Left(convert(varchar,ldtcur,109),11) Ldtcur From '  
SET @SQL = @SQL + @accountdbserver + '.' + @accountdb + '.DBO.parameter Where ''' + @effdate+ ''' Between Sdtcur And Ldtcur'  
Exec (@SQL)

GO
