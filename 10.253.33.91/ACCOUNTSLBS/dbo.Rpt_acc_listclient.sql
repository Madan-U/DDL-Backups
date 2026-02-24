-- Object: PROCEDURE dbo.Rpt_acc_listclient
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

---------------------------------------------------------------------------------------------------------
--  Proc To List Clients Acc To Login For The Db - Account
---------------------------------------------------------------------------------------------------------
--written By    :   Sgk
--date     :   Feb 05 2003
---------------------------------------------------------------------------------------------------------
--    Modification History
---------------------------------------------------------------------------------------------------------
-- .1 By : Sgk   On : Feb 05 2003
---------------------------------------------------------------------------------------------------------
Create Procedure Rpt_acc_listclient
 @Statusid Varchar(15), 
 @Statusname Varchar(25), 
 @Whattolookfor Varchar(25), -- Partial/complete/null String - Forms The Basis For The Search
 @Whichway Varchar(1),  -- > Or <, Depending On How The Above String Is To Be Compared To The Below One.
 @Comparetowhat Varchar(25), -- Partial/complete/null String To Indicate The Upper/lower Limit Of The Search.
 @Accat Varchar(3)  -- Account Category
As
Declare
@Strsql Varchar(2500), 
@@Inaccat Varchar(3)
Select @@Inaccat = Rtrim(Convert(Varchar, Convert(Int, @Accat)+100, 3))
--set Default Values
Set @Whattolookfor = @Whattolookfor + "%"
/* Set @Booktype = @Booktype + "%" */
--broker Login
If  @Statusid = "broker"
Begin
 Set @Strsql = "select "
 Set @Strsql = @Strsql + "distinct "
 Set @Strsql = @Strsql + " Cltcode, "
 Set @Strsql = @Strsql + " Acname, "
 Set @Strsql = @Strsql + " Branchcode "
 Set @Strsql = @Strsql + "from "
 Set @Strsql = @Strsql + " Acmast "
 Set @Strsql = @Strsql + "where "
 Set @Strsql = @Strsql + " Cltcode Like '" + @Whattolookfor + "' And (Accat Like '" + @Accat  + "%' Or Accat Like '" + @@Inaccat + "%')" 
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
--branch Login
If @Statusid = "branch"
Begin
 Set @Strsql = "select "
 Set @Strsql = @Strsql + "distinct "
 Set @Strsql = @Strsql + " Cltcode, "
 Set @Strsql = @Strsql + " Acname, "
 Set @Strsql = @Strsql + " Branchcode "
 Set @Strsql = @Strsql + "from "
 Set @Strsql = @Strsql + " Acmast "
 Set @Strsql = @Strsql + "where "
 Set @Strsql = @Strsql + " Cltcode Like '" + @Whattolookfor + "' And "
 Set @Strsql = @Strsql + " (Branchcode Like '" + @Statusname + "' Or Branchcode = 'All') And (Accat Like '" + @Accat  + "%' Or Accat Like '" + @@Inaccat + "%')" 
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
If @Statusid = "subbroker"
Begin
 Set @Strsql = "select "
 Set @Strsql = @Strsql + "distinct "
 Set @Strsql = @Strsql + " A.Cltcode, "
 Set @Strsql = @Strsql + " A.Acname, "
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
If @Statusid = "trader"
Begin
 Set @Strsql = "select "
 Set @Strsql = @Strsql + "distinct "
 Set @Strsql = @Strsql + " A.Cltcode, "
 Set @Strsql = @Strsql + " A.Acname, "
 Set @Strsql = @Strsql + " C1.Trader "
 Set @Strsql = @Strsql + "from "
 Set @Strsql = @Strsql + " Acmast A, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client1 C1, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client2 C2, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Branches S "
 Set @Strsql = @Strsql + "where "
 Set @Strsql = @Strsql + " C1.Cl_code = C2.Cl_code And "
 Set @Strsql = @Strsql + " A.Cltcode = C2.Party_code And "
 Set @Strsql = @Strsql + " C1.Trader = S.Short_name  And "
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
If @Statusid = "family"
Begin
 Set @Strsql = "select "
 Set @Strsql = @Strsql + "distinct "
 Set @Strsql = @Strsql + " A.Cltcode, "
 Set @Strsql = @Strsql + " A.Acname, "
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
If @Statusid = "client"
Begin
 Set @Strsql = "select "
 Set @Strsql = @Strsql + "distinct "
 Set @Strsql = @Strsql + " A.Cltcode, "
 Set @Strsql = @Strsql + " A.Acname "
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
If @Statusid = "region"
Begin
 Set @Strsql = "select "
 Set @Strsql = @Strsql + "distinct "
 Set @Strsql = @Strsql + " A.Cltcode, "
 Set @Strsql = @Strsql + " A.Acname "
 Set @Strsql = @Strsql + "from "
 Set @Strsql = @Strsql + " Acmast A, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client1 C1, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client2 C2 "
 Set @Strsql = @Strsql + "where "
 Set @Strsql = @Strsql + " C1.Cl_code = C2.Cl_code And "
 Set @Strsql = @Strsql + " A.Cltcode = C2.Party_code And "
 Set @Strsql = @Strsql + " Region Like '" + @Statusname + "' And "
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
If @Statusid = "area"
Begin
 Set @Strsql = "select "
 Set @Strsql = @Strsql + "distinct "
 Set @Strsql = @Strsql + " A.Cltcode, "
 Set @Strsql = @Strsql + " A.Acname "
 Set @Strsql = @Strsql + "from "
 Set @Strsql = @Strsql + " Acmast A, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client1 C1, "
 Set @Strsql = @Strsql + " Msajag.Dbo.Client2 C2 "
 Set @Strsql = @Strsql + "where "
 Set @Strsql = @Strsql + " C1.Cl_code = C2.Cl_code And "
 Set @Strsql = @Strsql + " A.Cltcode = C2.Party_code And "
 Set @Strsql = @Strsql + " Region Like '" + @Statusname + "' And "
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
