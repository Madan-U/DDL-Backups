-- Object: PROCEDURE dbo.C_checkopeningentryms
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc C_checkopeningentryms (@sdt Varchar(11), @ldt Varchar(11), @accountdb Varchar(20),@accountdbserver Varchar(50))    
As    
DECLARE @SQL VARCHAR(2000)  
  
Declare @@vtyp Varchar(2)    
Set @@vtyp = '18'    
SET @SQL = 'select Distinct Isnull(left(convert(varchar,vdt,109),11),'''') Vdt From ' + @accountdbserver + '.' + @accountdb + '.dbo.marginledger'  
SET @SQL = @SQL + ' Where Vtyp = ''' + @@vtyp + ''' AND Vdt >= ''' + @sdt + ''' And Vdt <= ''' + @ldt +  ' 23:59:59'''  
Exec (@SQL)

GO
