-- Object: PROCEDURE dbo.srpt_AccodeList
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


  
    
/****** Object:  Stored Procedure dbo.rpt_Acc_ListClient    Script Date: 04/13/2003 12:09:05 PM ******/        
---------------------------------------------------------------------------------------------------------        
--  PROC TO LIST CLIENTS ACC TO LOGIN FOR THE DB - ACCOUNT        
---------------------------------------------------------------------------------------------------------        
        
CREATE PROCEDURE srpt_AccodeList        
 @STATUSID VARCHAR(15),        
 @STATUSNAME VARCHAR(25),        
 @WHATTOLOOKFOR VARCHAR(25), -- PARTIAL/COMPLETE/NULL STRING - FORMS THE BASIS FOR THE SEARCH        
 @WHICHWAY VARCHAR(1),  -- > OR <, DEPENDING ON HOW THE ABOVE STRING IS TO BE COMPARED TO THE BELOW ONE.        
 @COMPARETOWHAT VARCHAR(25), -- PARTIAL/COMPLETE/NULL STRING TO INDICATE THE UPPER/LOWER LIMIT OF THE SEARCH.        
 @ACCAT varchar(3),  -- Account Category        
 @LOOKFORNAME VARCHAR(25) -- PARTIAL/COMPLETE/NULL STRING - FORMS THE BASIS FOR THE SEARCH        
AS        
        
DECLARE        
@strSQL VarChar(2500),        
@@Inaccat varchar(3)        
        
        
Set @STATUSID = LTrim(RTrim(@STATUSID))        
Set @STATUSNAME = LTrim(RTrim(@STATUSNAME))        
Set @WHATTOLOOKFOR = LTrim(RTrim(@WHATTOLOOKFOR))        
Set @WHICHWAY = LTrim(RTrim(@WHICHWAY))        
Set @COMPARETOWHAT = LTrim(RTrim(@COMPARETOWHAT))        
Set @ACCAT = LTrim(RTrim(@ACCAT))        
Set @LOOKFORNAME = LTrim(RTrim(@LOOKFORNAME))        
        
select @@inaccat = rtrim(convert(varchar,convert(int,@accat)+100,3))        

IF @WHATTOLOOKFOR <> ''        
BEGIN
--SET DEFAULT VALUES        
SET @WHATTOLOOKFOR = @WHATTOLOOKFOR + '%'        
/* SET @BOOKTYPE = @BOOKTYPE + "%" */        
        
--BROKER LOGIN        
If  @STATUSID='BROKER'        
Begin        
 Set @strSQL = 'SELECT '        
 Set @strSQL = @strSQL + 'DISTINCT a.cltcode, acname=isnull(b.sbname,a.acname) , branchcode '        
 Set @strSQL = @strSQL + 'FROM acmast a left outer join sebiinsp_sbnameswap b on a.cltcode=b.cltcode '        
 Set @strSQL = @strSQL + 'WHERE a.cltcode not like ''21%'' and a.cltcode not in (select gl_code from angelfo.accountfo.dbo.SEBIINSP_NTS with (nolock)) and '        
        if len(rtrim(@WHATTOLOOKFOR)) <> 0 and len(rtrim(@LOOKFORNAME)) <> 0         
           begin        
    Set @strSQL = @strSQL + ' ( a.cltcode LIKE ''' + @WHATTOLOOKFOR + ''' and acname LIKE ''' + @LOOKFORNAME + '%'') and (accat LIKE ''' + @ACCAT  + '%'' or accat like ''' + @@inaccat + '%'' '         
    end        
        else        
           if len(rtrim(@LOOKFORNAME)) <> 0         
               begin        
                  Set @strSQL = @strSQL + ' ( a.cltcode LIKE ''' + @WHATTOLOOKFOR + ''' or acname LIKE ''' + @LOOKFORNAME + '%'') and (accat LIKE ''' + @ACCAT  + '%'' or accat like ''' + @@inaccat + '%'' '         
               end        
           else        
               begin        
                  Set @strSQL = @strSQL + ' ( a.cltcode LIKE ''' + @WHATTOLOOKFOR + ''' or acname LIKE ''' + @WHATTOLOOKFOR + ''') and (accat LIKE ''' + @ACCAT  + '%'' or accat like ''' + @@inaccat + '%'' '         
               end        
        if rtrim(@accat) = '3'        
           begin        
  select @strSQL = @strSQL + ' or accat in ( ''14'',''18'',''114'',''118''))'         
           end        
        else        
           begin        
  select @strSQL = @strSQL + ' )'         
           end        
        
-- TO GET A VALUE GREATER/LESSER THAN ANOTHER.        
-- USEFUL WHILE TAKING FROM-TO TYPE SELECTIONS         
 If @WHICHWAY = '>'        
 Begin        
  Set @strSQL = @strSQL + ' AND '        
  Set @strSQL = @strSQL + ' a.cltcode >= ''' + @COMPARETOWHAT + ''' '        
 End        
 Else        
 Begin        
  If @WHICHWAY = '<'        
  Begin        
   Set @strSQL = @strSQL + ' AND '        
   Set @strSQL = @strSQL + ' a.cltcode <= ''' + @COMPARETOWHAT + ''''        
  End        
 End        
        
 Set @strSQL = @strSQL + 'ORDER BY a.cltcode, branchcode '        
End        
        
      
Set @strSQL = ' Set Transaction Isolation Level Read Uncommitted ' + @strSQL + ' OPTION  (FAST 10)'        
END
ELSE
begin
 Set @strSQL = 'SELECT '        
 Set @strSQL = @strSQL + 'DISTINCT cltcode, acname , branchcode '        
 Set @strSQL = @strSQL + 'FROM acmast where 1=2'
end        
Print @strSQL        
Exec (@strSQL)

GO
