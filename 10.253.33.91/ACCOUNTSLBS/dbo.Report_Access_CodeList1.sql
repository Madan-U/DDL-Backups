-- Object: PROCEDURE dbo.Report_Access_CodeList1
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

---------------------------------------------------------------------------------------------------------
--  Proc To List Clients Acc To Login For The Db - Account
---------------------------------------------------------------------------------------------------------
CREATE   Procedure Report_Access_CodeList1
 @Statusid Varchar(15), 
 @Statusname Varchar(25), 
 @Whattolookfor Varchar(25), -- Partial/complete/null String - Forms The Basis For The Search
 @Whichway Varchar(1),  -- > Or <, Depending On How The Above String Is To Be Compared To The Below One.
 @Comparetowhat Varchar(25), -- Partial/complete/null String To Indicate The Upper/lower Limit Of The Search.
 @Accat Varchar(3),  -- Account Category
 @Lookforname Varchar(25) -- Partial/complete/null String - Forms The Basis For The Search
As
Declare
@Strsql Varchar(2500), 
@@Inaccat Varchar(3)
Select @@Inaccat = Rtrim(Convert(Varchar, Convert(Int, @Accat)+100, 3))
--set Default Values
Set @Whattolookfor = @Whattolookfor + "%"
/* Set @Booktype = @Booktype + "%" */
--broker Login
If  lower(@Statusid) = "broker"
Begin
 Set @Strsql = "select "
 --Set @Strsql = @Strsql + "distinct Cltcode, Acname, Branchcode "
 Set @Strsql = @Strsql + "distinct Cltcode=Cltcode+' - '+Acname, Branchcode "
 Set @Strsql = @Strsql + "from Acmast "
 Set @Strsql = @Strsql + "where "
        If Len(Rtrim(@Whattolookfor)) <> 0 And Len(Rtrim(@Lookforname)) <> 0 
           Begin
    Set @Strsql = @Strsql + " ( Cltcode Like '" + @Whattolookfor + "' And Acname Like '" + @Lookforname + "%') And (Accat Like '" + @Accat  + "%' Or Accat Like '" + @@Inaccat + "%' " 
    End
        Else
           If Len(Rtrim(@Lookforname)) <> 0 
               Begin
                  Set @Strsql = @Strsql + " ( Cltcode Like '" + @Whattolookfor + "' Or Acname Like '" + @Lookforname + "%') And (Accat Like '" + @Accat  + "%' Or Accat Like '" + @@Inaccat + "%' " 
               End
           Else
               Begin
                  Set @Strsql = @Strsql + " ( Cltcode Like '" + @Whattolookfor + "' Or Acname Like '" + @Whattolookfor + "') And (Accat Like '" + @Accat  + "%' Or Accat Like '" + @@Inaccat + "%' " 
               End
        If Rtrim(@Accat) = '3'
           Begin
  Select @Strsql = @Strsql + " Or Accat In ( '14', '18', '114', '118'))" 
           End
        Else
           Begin
  Select @Strsql = @Strsql + " )" 
           End
-- To Get A Value Greater/lesser Than Another.
-- Useful While Taking From-to Type Selections 
 If @Whichway = ">"
 Begin
  Set @Strsql = @Strsql + " And "
  Set @Strsql = @Strsql + " Cltcode > = '" + @Comparetowhat + "' "
 End
 Else
 Begin
  If @Whichway = "<"
  Begin
   Set @Strsql = @Strsql + " And "
   Set @Strsql = @Strsql + " Cltcode < = '" + @Comparetowhat + "' "
  End
 End
 Set @Strsql = @Strsql + "order By Cltcode, Branchcode "
End
--branch Login
If lower(@Statusid) = "branch"
Begin
 Set @Strsql = "select "
 Set @Strsql = @Strsql + "distinct "
 Set @Strsql = @Strsql + " Cltcode = Cltcode+' - '+Acname, "
-- Set @Strsql = @Strsql + " Acname, "
 Set @Strsql = @Strsql + " Branchcode "
 Set @Strsql = @Strsql + "from "
 Set @Strsql = @Strsql + " Acmast "
 Set @Strsql = @Strsql + "where "
 Set @Strsql = @Strsql + " Cltcode Like '" + @Whattolookfor + "' And "
 Set @Strsql = @Strsql + " (Branchcode Like '" + @Statusname + "' Or Branchcode = 'All') And (Accat Like '" + @Accat  + "%' Or Accat Like '" + @@Inaccat + "%' " 
        If Rtrim(@Accat) = '3'
           Begin
  Select @Strsql = @Strsql + " Or Accat In ( '14', '18', '114', '118'))" 
           End
        Else
           Begin
  Select @Strsql = @Strsql + " )" 
           End
-- To Get A Value Greater/lesser Than Another.
-- Useful While Taking From-to Type Selections
 If @Whichway = ">"
 Begin
  Set @Strsql = @Strsql + " And "
  Set @Strsql = @Strsql + " Cltcode > = '" + @Comparetowhat + "' "
 End
 Else
 Begin
  If @Whichway = "<"
  Begin
   Set @Strsql = @Strsql + " And "
   Set @Strsql = @Strsql + " Cltcode < = '" + @Comparetowhat + "' "
  End
 End
 Set @Strsql = @Strsql + "order By "
 Set @Strsql = @Strsql + " Cltcode, "
 Set @Strsql = @Strsql + " Branchcode "
End
--sub-broker Login
If lower(@Statusid) = "subbroker"
Begin
 Set @Strsql = "select "
 Set @Strsql = @Strsql + "distinct "
 Set @Strsql = @Strsql + " Cltcode = A.Cltcode+' - '+A.Acname, "
-- Set @Strsql = @Strsql + " A.Acname, "
 Set @Strsql = @Strsql + " C1.Sub_broker "
 Set @Strsql = @Strsql + "from "
 Set @Strsql = @Strsql + " Acmast A, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client1 C1, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client2 C2, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Subbrokers S "
 Set @Strsql = @Strsql + "where "
 Set @Strsql = @Strsql + " C1.Cl_code = C2.Cl_code And "
 Set @Strsql = @Strsql + " A.Cltcode = C2.Party_code And "
 Set @Strsql = @Strsql + " C1.Sub_broker = S.Sub_broker And "
 Set @Strsql = @Strsql + " C1.Sub_broker Like '" + @Statusname + "' And "
 Set @Strsql = @Strsql + " Cltcode Like '" + @Whattolookfor + "' "
-- To Get A Value Greater/lesser Than Another.
-- Useful While Taking From-to Type Selections
 If @Whichway = ">"
 Begin
  Set @Strsql = @Strsql + " And "
  Set @Strsql = @Strsql + " Cltcode > = '" + @Comparetowhat + "' "
 End
 Else
 Begin
  If @Whichway = "<"
  Begin
   Set @Strsql = @Strsql + " And "
   Set @Strsql = @Strsql + " Cltcode < = '" + @Comparetowhat + "' "
  End
 End
 Set @Strsql = @Strsql + "order By "
 Set @Strsql = @Strsql + " A.Cltcode, "
 Set @Strsql = @Strsql + " C1.Sub_broker "
End
--trader Login
If lower(@Statusid) = "trader"
Begin
 Set @Strsql = "select "
 Set @Strsql = @Strsql + "distinct "
 Set @Strsql = @Strsql + " Cltcode = A.Cltcode+' - '+A.Acname, "
-- Set @Strsql = @Strsql + " A.Acname, "
 Set @Strsql = @Strsql + " C1.Trader "
 Set @Strsql = @Strsql + "from "
 Set @Strsql = @Strsql + " Acmast A, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client1 C1, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client2 C2, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Branches S "
 Set @Strsql = @Strsql + "where "
 Set @Strsql = @Strsql + " C1.Cl_code = C2.Cl_code And "
 Set @Strsql = @Strsql + " A.Cltcode = C2.Party_code And "
 /*set @Strsql = @Strsql + " C1.Trader = S.Branch_cd And "*/
             Set @Strsql = @Strsql + " C1.Branch_cd = S.Branch_cd And "
 Set @Strsql = @Strsql + " C1.Trader Like '" + @Statusname + "' And "
 Set @Strsql = @Strsql + " Cltcode Like '" + @Whattolookfor + "' "
-- To Get A Value Greater/lesser Than Another.
-- Useful While Taking From-to Type Selections
 If @Whichway = ">"
 Begin
  Set @Strsql = @Strsql + " And "
  Set @Strsql = @Strsql + " Cltcode > = '" + @Comparetowhat + "' "
 End
 Else
 Begin
  If @Whichway = "<"
  Begin
   Set @Strsql = @Strsql + " And "
   Set @Strsql = @Strsql + " Cltcode < = '" + @Comparetowhat + "' "
  End
 End
 Set @Strsql = @Strsql + "order By "
 Set @Strsql = @Strsql + " A.Cltcode, "
 Set @Strsql = @Strsql + " C1.Trader "
End
--family Login
If lower(@Statusid) = "family"
Begin
 Set @Strsql = "select "
 Set @Strsql = @Strsql + "distinct "
 Set @Strsql = @Strsql + " Cltcode = A.Cltcode+' - '+A.Acname, "
-- Set @Strsql = @Strsql + " A.Acname, "
 Set @Strsql = @Strsql + " C1.Family "
 Set @Strsql = @Strsql + "from "
 Set @Strsql = @Strsql + " Acmast A, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client1 C1, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client2 C2 "
 Set @Strsql = @Strsql + "where "
 Set @Strsql = @Strsql + " C1.Cl_code = C2.Cl_code And "
 Set @Strsql = @Strsql + " A.Cltcode = C2.Party_code And "
 Set @Strsql = @Strsql + " C1.Family Like '" + @Statusname + "' And "
 Set @Strsql = @Strsql + " Cltcode Like '" + @Whattolookfor + "' "
-- To Get A Value Greater/lesser Than Another.
-- Useful While Taking From-to Type Selections
 If @Whichway = ">"
 Begin
  Set @Strsql = @Strsql + " And "
  Set @Strsql = @Strsql + " Cltcode > = '" + @Comparetowhat + "' "
 End
 Else
 Begin
  If @Whichway = "<"
  Begin
   Set @Strsql = @Strsql + " And "
   Set @Strsql = @Strsql + " Cltcode < = '" + @Comparetowhat + "' "
  End
 End
 Set @Strsql = @Strsql + "order By "
 Set @Strsql = @Strsql + " A.Cltcode, "
 Set @Strsql = @Strsql + " C1.Family "
End
If lower(@Statusid) = "client"
Begin
 Set @Strsql = "select "
 Set @Strsql = @Strsql + "distinct "
 Set @Strsql = @Strsql + " Cltcode = A.Cltcode+' - '+A.Acname, "
-- Set @Strsql = @Strsql + " A.Acname "
 Set @Strsql = @Strsql + "from "
 Set @Strsql = @Strsql + " Acmast A, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client1 C1, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client2 C2 "
 Set @Strsql = @Strsql + "where "
 Set @Strsql = @Strsql + " C1.Cl_code = C2.Cl_code And "
 Set @Strsql = @Strsql + " A.Cltcode = C2.Party_code And "
 Set @Strsql = @Strsql + " Cltcode Like '" + @Statusname + "' "
 Set @Strsql = @Strsql + "order By "
 Set @Strsql = @Strsql + " A.Cltcode "
End
If lower(@Statusid) = "region"
Begin
 Set @Strsql = "select "
 Set @Strsql = @Strsql + "distinct "
 Set @Strsql = @Strsql + " Cltcode = A.Cltcode+' - '+A.Acname, "
-- Set @Strsql = @Strsql + " A.Acname "
 Set @Strsql = @Strsql + "from "
 Set @Strsql = @Strsql + " Acmast A, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client1 C1, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client2 C2 "
 Set @Strsql = @Strsql + "where "
 Set @Strsql = @Strsql + " C1.Cl_code = C2.Cl_code And "
 Set @Strsql = @Strsql + " A.Cltcode = C2.Party_code And "
 Set @Strsql = @Strsql + " C1.Region Like '" + @Statusname + "' And "
 Set @Strsql = @Strsql + " Cltcode Like '" + @Whattolookfor + "' "
-- To Get A Value Greater/lesser Than Another.
-- Useful While Taking From-to Type Selections
 If @Whichway = ">"
 Begin
  Set @Strsql = @Strsql + " And "
  Set @Strsql = @Strsql + " Cltcode > = '" + @Comparetowhat + "' "
 End
 Else
 Begin
  If @Whichway = "<"
  Begin
   Set @Strsql = @Strsql + " And "
   Set @Strsql = @Strsql + " Cltcode < = '" + @Comparetowhat + "' "
  End
 End
 Set @Strsql = @Strsql + "order By "
 Set @Strsql = @Strsql + " A.Cltcode "
End
If lower(@Statusid) = "area"
Begin
 Set @Strsql = "select "
 Set @Strsql = @Strsql + "distinct "
 Set @Strsql = @Strsql + " Cltcode = A.Cltcode+' - '+A.Acname, "
-- Set @Strsql = @Strsql + " A.Acname "
 Set @Strsql = @Strsql + "from "
 Set @Strsql = @Strsql + " Acmast A, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client1 C1, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client2 C2 "
 Set @Strsql = @Strsql + "where "
 Set @Strsql = @Strsql + " C1.Cl_code = C2.Cl_code And "
 Set @Strsql = @Strsql + " A.Cltcode = C2.Party_code And "
 Set @Strsql = @Strsql + " C1.Area Like '" + @Statusname + "' And "
 Set @Strsql = @Strsql + " Cltcode Like '" + @Whattolookfor + "' "
-- To Get A Value Greater/lesser Than Another.
-- Useful While Taking From-to Type Selections
 If @Whichway = ">"
 Begin
  Set @Strsql = @Strsql + " And "
  Set @Strsql = @Strsql + " Cltcode > = '" + @Comparetowhat + "' "
 End
 Else
 Begin
  If @Whichway = "<"
  Begin
   Set @Strsql = @Strsql + " And "
   Set @Strsql = @Strsql + " Cltcode < = '" + @Comparetowhat + "' "
  End
 End
 Set @Strsql = @Strsql + "order By "
 Set @Strsql = @Strsql + " A.Cltcode "
End
 Set @Strsql = @Strsql + " Option  (Fast 10)"
Print @Strsql
Exec (@Strsql)

GO
