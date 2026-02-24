-- Object: PROCEDURE dbo.srpt_Acc_ListClient_Report
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE [dbo].[srpt_Acc_ListClient_Report]                    
 @STATUSID VARCHAR(15),                          
 @STATUSNAME VARCHAR(25),                          
 @WHATTOLOOKFOR VARCHAR(25), -- PARTIAL/COMPLETE/NULL STRING - FORMS THE BASIS FOR THE SEARCH                          
 @WHICHWAY VARCHAR(1),  -- > OR <, DEPENDING ON HOW THE ABOVE STRING IS TO BE COMPARED TO THE BELOW ONE.                          
 @COMPARETOWHAT VARCHAR(25), -- PARTIAL/COMPLETE/NULL STRING TO INDICATE THE UPPER/LOWER LIMIT OF THE SEARCH.                          
 @ACCAT VARCHAR(3)   -- Account Category                          
                          
AS              
DECLARE                          
@strSQL VarChar(2500),                          
@@Inaccat varchar(3)                          
                          
select @@inaccat = rtrim(convert(varchar,convert(int,@accat)+100,3))                          
                          
--SET DEFAULT VALUES                          
--SET @WHATTOLOOKFOR = @WHATTOLOOKFOR + "%"                          
/* SET @BOOKTYPE = @BOOKTYPE + "%" */                          
                          
--BROKER LOGIN                          
If  @STATUSID='BROKER'                          
Begin                          
 Set @strSQL = 'SELECT '                          
 Set @strSQL = @strSQL + 'DISTINCT '                          
 Set @strSQL = @strSQL + ' a.cltcode, '                          
 Set @strSQL = @strSQL + ' acname=isnull(b.sbname,a.acname), '                          
 Set @strSQL = @strSQL + ' branchcode '                          
 Set @strSQL = @strSQL + 'FROM '                          
 Set @strSQL = @strSQL + ' acmast a left outer join sebiinsp_sbnameswap b on a.cltcode=b.cltcode  '                          
 Set @strSQL = @strSQL + 'WHERE '                          
 Set @strSQL = @strSQL + ' a.cltcode >= ''' + @WHATTOLOOKFOR + ''' AND '                          
 Set @strSQL = @strSQL + ' a.cltcode <= ''' + @COMPARETOWHAT + ''' AND '                          
 Set @strSQL = @strSQL + ' a.CLTCODE NOT IN (select gl_code from angelfo.accountfo.dbo.SEBIINSP_NTS with (nolock)) AND '  
 Set @strSQL = @strSQL + ' (accat LIKE ''' + @ACCAT  + '%'' or accat LIKE ''' + @@Inaccat + '%'' '                            
        if rtrim(@accat) = '3'                          
           begin                          
  select @strSQL = @strSQL + ' or accat in ( ''14'',''18'',''114'',''118''))'                           
           end                          
        else                          
           begin                          
  select @strSQL = @strSQL + ' )'                           
           end                          
                          
 Set @strSQL = @strSQL + ' ORDER BY '                          
 Set @strSQL = @strSQL + ' cltcode, '                          
 Set @strSQL = @strSQL + ' branchcode '                          
End                          
                      
                      
 Set @strSQL ='set transaction isolation level read uncommitted '+ @strSQL + ' OPTION  (FAST 10)'                          
                          
Print @strSQL                          
Exec (@strSQL)               
              
SET ANSI_NULLS ON

GO
