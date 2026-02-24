-- Object: PROCEDURE dbo.rpt_Acc_ListClient_Report
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE [dbo].[rpt_Acc_ListClient_Report]  
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
If  @STATUSID="BROKER"        
Begin        
 Set @strSQL = "SELECT "        
 Set @strSQL = @strSQL + "DISTINCT "        
 Set @strSQL = @strSQL + " cltcode, "        
 Set @strSQL = @strSQL + " acname, "        
 Set @strSQL = @strSQL + " branchcode "        
 Set @strSQL = @strSQL + "FROM "        
 Set @strSQL = @strSQL + " acmast "        
 Set @strSQL = @strSQL + "WHERE "        
 Set @strSQL = @strSQL + " cltcode >= '" + @WHATTOLOOKFOR + "' AND "        
 Set @strSQL = @strSQL + " cltcode <= '" + @COMPARETOWHAT + "' AND "        
 Set @strSQL = @strSQL + " (accat LIKE '" + @ACCAT  + "%' or accat LIKE '" + @@Inaccat + "%' "          
        if rtrim(@accat) = '3'        
           begin        
  select @strSQL = @strSQL + " or accat in ( '14','18','114','118'))"         
           end        
        else        
           begin        
  select @strSQL = @strSQL + " )"         
           end        
        
 Set @strSQL = @strSQL + "ORDER BY "        
 Set @strSQL = @strSQL + " cltcode, "        
 Set @strSQL = @strSQL + " branchcode "        
End        
        
--BRANCH LOGIN        
IF @STATUSID="BRANCH"        
Begin        
 Set @strSQL = "SELECT "        
 Set @strSQL = @strSQL + "DISTINCT "        
 Set @strSQL = @strSQL + " cltcode, "        
 Set @strSQL = @strSQL + " acname, "        
 Set @strSQL = @strSQL + " branchcode "        
 Set @strSQL = @strSQL + "FROM "        
 Set @strSQL = @strSQL + " acmast "        
 Set @strSQL = @strSQL + "WHERE "        
        
 Set @strSQL = @strSQL + " cltcode >= '" + @WHATTOLOOKFOR + "' AND "        
 Set @strSQL = @strSQL + " (branchcode = '" + @STATUSNAME + "' OR branchcode = 'ALL') AND "        
 Set @strSQL = @strSQL + " cltcode <= '" + @COMPARETOWHAT + "' AND "        
 Set @strSQL = @strSQL + " (accat LIKE '" + @ACCAT  + "%' or accat LIKE '" + @@Inaccat + "%' "        
        if rtrim(@accat) = '3'        
           begin        
  select @strSQL = @strSQL + " or accat in ( '14','18','114','118'))"         
           end        
        else        
           begin        
  select @strSQL = @strSQL + " )"         
           end        
        
        
 Set @strSQL = @strSQL + "ORDER BY "        
 Set @strSQL = @strSQL + " cltcode, "        
 Set @strSQL = @strSQL + " branchcode "        
End        
        
--SUB-BROKER LOGIN        
IF @STATUSID="SUBBROKER"        
Begin        
 Set @strSQL = "SELECT "        
 Set @strSQL = @strSQL + "DISTINCT "        
 Set @strSQL = @strSQL + " a.cltcode, "        
 Set @strSQL = @strSQL + " a.acname, "        
 Set @strSQL = @strSQL + " c1.sub_broker "        
 Set @strSQL = @strSQL + "FROM "        
 Set @strSQL = @strSQL + " acmast a, "        
 Set @strSQL = @strSQL + " msajag.dbo.client1 c1, "        
 Set @strSQL = @strSQL + " msajag.dbo.client2 c2, "        
 Set @strSQL = @strSQL + " msajag.dbo.subbrokers s "        
 Set @strSQL = @strSQL + "WHERE "        
 Set @strSQL = @strSQL + " c1.cl_code = c2.cl_code AND "        
 Set @strSQL = @strSQL + " a.cltcode = c2.party_code AND "        
 Set @strSQL = @strSQL + " c1.sub_broker = s.sub_broker AND "        
 Set @strSQL = @strSQL + " c1.sub_broker LIKE '" + @STATUSNAME + "' AND "        
 Set @strSQL = @strSQL + " cltcode >= '" + @WHATTOLOOKFOR + "' AND "        
 Set @strSQL = @strSQL + " cltcode <= '" + @COMPARETOWHAT + "' "        
 Set @strSQL = @strSQL + "ORDER BY "        
 Set @strSQL = @strSQL + " a.cltcode, "        
 Set @strSQL = @strSQL + " c1.sub_broker "        
End        
        
--TRADER LOGIN        
If @STATUSID="TRADER"        
Begin        
 Set @strSQL = "SELECT "        
 Set @strSQL = @strSQL + "DISTINCT "        
 Set @strSQL = @strSQL + " a.cltcode, "        
 Set @strSQL = @strSQL + " a.acname, "        
 Set @strSQL = @strSQL + " c1.trader "        
 Set @strSQL = @strSQL + "FROM "        
 Set @strSQL = @strSQL + " acmast a, "        
 Set @strSQL = @strSQL + " msajag.dbo.client1 c1, "        
 Set @strSQL = @strSQL + " msajag.dbo.client2 c2, "        
 Set @strSQL = @strSQL + " msajag.dbo.branches s "        
 Set @strSQL = @strSQL + "WHERE "        
 Set @strSQL = @strSQL + " c1.cl_code = c2.cl_code AND "        
 Set @strSQL = @strSQL + " a.cltcode = c2.party_code AND "        
 Set @strSQL = @strSQL + " c1.trader = s.branch_cd AND "        
 Set @strSQL = @strSQL + " c1.trader LIKE '" + @STATUSNAME + "' AND "        
 Set @strSQL = @strSQL + " cltcode >= '" + @WHATTOLOOKFOR + "' AND "        
 Set @strSQL = @strSQL + " cltcode <= '" + @COMPARETOWHAT + "' "        
 Set @strSQL = @strSQL + "ORDER BY "        
 Set @strSQL = @strSQL + " a.cltcode, "        
 Set @strSQL = @strSQL + " c1.trader "        
End        
        
--FAMILY LOGIN        
If @STATUSID="FAMILY"        
Begin        
 Set @strSQL = "SELECT "        
 Set @strSQL = @strSQL + "DISTINCT "        
 Set @strSQL = @strSQL + " a.cltcode, "        
 Set @strSQL = @strSQL + " a.acname, "        
 Set @strSQL = @strSQL + " c1.family "        
 Set @strSQL = @strSQL + "FROM "        
 Set @strSQL = @strSQL + " acmast a, "        
 Set @strSQL = @strSQL + " msajag.dbo.client1 c1, "        
 Set @strSQL = @strSQL + " msajag.dbo.client2 c2 "        
 Set @strSQL = @strSQL + "WHERE "        
 Set @strSQL = @strSQL + " c1.cl_code = c2.cl_code AND "        
 Set @strSQL = @strSQL + " a.cltcode = c2.party_code AND "        
 Set @strSQL = @strSQL + " c1.family LIKE '" + @STATUSNAME + "' AND "        
 Set @strSQL = @strSQL + " cltcode >= '" + @WHATTOLOOKFOR + "' AND "        
 Set @strSQL = @strSQL + " cltcode <= '" + @COMPARETOWHAT + "' "        
 Set @strSQL = @strSQL + "ORDER BY "        
 Set @strSQL = @strSQL + " a.cltcode, "        
 Set @strSQL = @strSQL + " c1.family "        
End        
        
If @STATUSID="CLIENT"        
Begin        
 Set @strSQL = "SELECT "        
 Set @strSQL = @strSQL + "DISTINCT "        
 Set @strSQL = @strSQL + " a.cltcode, "        
 Set @strSQL = @strSQL + " a.acname "        
 Set @strSQL = @strSQL + "FROM "        
 Set @strSQL = @strSQL + " acmast a, "        
 Set @strSQL = @strSQL + " msajag.dbo.client1 c1, "        
 Set @strSQL = @strSQL + " msajag.dbo.client2 c2 "        
 Set @strSQL = @strSQL + "WHERE "        
 Set @strSQL = @strSQL + " c1.cl_code = c2.cl_code AND "        
 Set @strSQL = @strSQL + " a.cltcode = c2.party_code AND "        
 Set @strSQL = @strSQL + " cltcode LIKE '" + @STATUSNAME + "' AND "        
 Set @strSQL = @strSQL + " cltcode >= '" + @WHATTOLOOKFOR + "' AND "        
 Set @strSQL = @strSQL + " cltcode <= '" + @COMPARETOWHAT + "' "        
 Set @strSQL = @strSQL + "ORDER BY "        
 Set @strSQL = @strSQL + " a.cltcode "        
End        
        
/*If @STATUSID="REGION"        
Begin   

 Set @strSQL = "SELECT "        
 Set @strSQL = @strSQL + "DISTINCT "        
 Set @strSQL = @strSQL + " a.cltcode, "        
 Set @strSQL = @strSQL + " a.acname "        
 Set @strSQL = @strSQL + "FROM "        
 Set @strSQL = @strSQL + " acmast a, "        
 Set @strSQL = @strSQL + " msajag.dbo.client1 c1, "        
 Set @strSQL = @strSQL + " msajag.dbo.client2 c2 "        
 Set @strSQL = @strSQL + "WHERE "        
 Set @strSQL = @strSQL + " c1.cl_code = c2.cl_code AND "        
 Set @strSQL = @strSQL + " a.cltcode = c2.party_code AND "        
 Set @strSQL = @strSQL + " c1.region LIKE '" + @STATUSNAME + "' AND "        
 Set @strSQL = @strSQL + " cltcode >= '" + @WHATTOLOOKFOR + "' AND "        
 Set @strSQL = @strSQL + " cltcode <= '" + @COMPARETOWHAT + "' "        
 Set @strSQL = @strSQL + "ORDER BY "        
 Set @strSQL = @strSQL + " a.cltcode "        
End        
*/      
If @STATUSID="AREA"        
Begin        
 Set @strSQL = "SELECT "        
 Set @strSQL = @strSQL + "DISTINCT "        
 Set @strSQL = @strSQL + " a.cltcode, "        
 Set @strSQL = @strSQL + " a.acname "        
 Set @strSQL = @strSQL + "FROM "        
 Set @strSQL = @strSQL + " acmast a, "        
 Set @strSQL = @strSQL + " msajag.dbo.client1 c1, "        
 Set @strSQL = @strSQL + " msajag.dbo.client2 c2 "        
 Set @strSQL = @strSQL + "WHERE "        
 Set @strSQL = @strSQL + " c1.cl_code = c2.cl_code AND "        
 Set @strSQL = @strSQL + " a.cltcode = c2.party_code AND "        
 Set @strSQL = @strSQL + " c1.area LIKE '" + @STATUSNAME + "' AND "        
 Set @strSQL = @strSQL + " cltcode >= '" + @WHATTOLOOKFOR + "' AND "        
 Set @strSQL = @strSQL + " cltcode <= '" + @COMPARETOWHAT + "' "        
 Set @strSQL = @strSQL + "ORDER BY "        
 Set @strSQL = @strSQL + " a.cltcode "        
End        
      
If @STATUSID="REGION"        
Begin        
If @ACCAT = 3         
begin        
 Set @strSQL = "SELECT "                  
 Set @strSQL = @strSQL + "DISTINCT "                  
 Set @strSQL = @strSQL + " a.cltcode, "                  
 Set @strSQL = @strSQL + " a.acname "                  
 Set @strSQL = @strSQL + "FROM "                  
 Set @strSQL = @strSQL + " acmast a, "        
 Set @strSQL = @strSQL + " Msajag.dbo.region c1 "        
 Set @strSQL = @strSQL + " where (a.branchcode = c1.branch_code OR a.branchcode = 'ALL') AND"        
 Set @strSQL = @strSQL + " c1.regioncode LIKE '" + @STATUSNAME + "' AND "         
 Set @strSQL = @strSQL + " cltcode >= '" + @WHATTOLOOKFOR + "' AND "                  
 Set @strSQL = @strSQL + " cltcode <= '" + @COMPARETOWHAT + "' and accat in(3, 14, 18)"                  
 Set @strSQL = @strSQL + "ORDER BY "                  
 Set @strSQL = @strSQL + " a.cltcode "                  
        
end         
else                
BEGIN        
 Set @strSQL = "SELECT "                  
 Set @strSQL = @strSQL + "DISTINCT "                  
 Set @strSQL = @strSQL + " a.cltcode, "                  
 Set @strSQL = @strSQL + " a.acname "                  
 Set @strSQL = @strSQL + "FROM "                  
 Set @strSQL = @strSQL + " acmast a, "                  
 Set @strSQL = @strSQL + " Msajag.dbo.client1 c1, "                  
 Set @strSQL = @strSQL + " Msajag.dbo.client2 c2 "                  
 Set @strSQL = @strSQL + "WHERE "                  
 Set @strSQL = @strSQL + " c1.cl_code = c2.cl_code AND "                  
 Set @strSQL = @strSQL + " a.cltcode = c2.party_code AND "                  
 Set @strSQL = @strSQL + " c1.region LIKE '" + @STATUSNAME + "' AND "                  
 Set @strSQL = @strSQL + " cltcode >= '" + @WHATTOLOOKFOR + "' AND "                  
 Set @strSQL = @strSQL + " cltcode <= '" + @COMPARETOWHAT + "' "                  
 Set @strSQL = @strSQL + "ORDER BY "                  
 Set @strSQL = @strSQL + " a.cltcode "           
end         
End        
      
    
    
    
 Set @strSQL ='set transaction isolation level read uncommitted '+ @strSQL + " OPTION  (FAST 10)"        
        
Print @strSQL        
Exec (@strSQL)

GO
