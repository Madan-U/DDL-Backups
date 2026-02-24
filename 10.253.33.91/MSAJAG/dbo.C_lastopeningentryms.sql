-- Object: PROCEDURE dbo.C_lastopeningentryms
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc C_lastopeningentryms (@sdt Varchar(11), @accountdb Varchar(20),@accountdbserver Varchar(50))    
As    
Declare @@vtyp Varchar(2)    
DECLARE @SQL VARCHAR(2000)  
  
Set @@vtyp = '18'    
SET @SQL = 'select Distinct Isnull(left(convert(varchar,vdt,109),11),'''') Vdt From ' + @accountdbserver + '.' + @accountdb + '.dbo.marginledger'  
SET @SQL = @SQL + ' Where Vtyp = ''' + @@vtyp + ''' AND Vdt < ''' + @sdt + ''''  
Exec (@SQL)

GO
