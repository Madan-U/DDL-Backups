-- Object: PROCEDURE dbo.rpt_Acc_ListFamily
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_Acc_ListFamily    Script Date: 04/13/2003 12:09:05 PM ******/

/****** Object:  Stored Procedure dbo.rpt_Acc_ListFamily    Script Date: 04/07/2003 6:22:43 PM ******/
/****** Object:  Stored Procedure dbo.rpt_Acc_ListFamily Script Date: 02/18/2003 10:37:40 AM ******/
---------------------------------------------------------------------------------------------------------
--		PROC TO LIST CLIENTS ACC TO LOGIN FOR THE DB - ACCOUNT
---------------------------------------------------------------------------------------------------------
--WRITTEN BY				:			SGK
--DATE					:			Feb 05 2003
---------------------------------------------------------------------------------------------------------
--				MODIFICATION HISTORY
---------------------------------------------------------------------------------------------------------
--	.1	BY	:	SGK			ON	:	Feb 05 2003
---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE rpt_Acc_ListFamily
	@STATUSID VARCHAR(15),
	@STATUSNAME VARCHAR(25),
	@WHATTOLOOKFOR VARCHAR(25),	--	PARTIAL/COMPLETE/NULL STRING - FORMS THE BASIS FOR THE SEARCH
	@WHICHWAY VARCHAR(1),		--	> OR <, DEPENDING ON HOW THE ABOVE STRING IS TO BE COMPARED TO THE BELOW ONE.
	@COMPARETOWHAT VARCHAR(25),	--	PARTIAL/COMPLETE/NULL STRING TO INDICATE THE UPPER/LOWER LIMIT OF THE SEARCH.
	@ACCAT varchar(3),		--	Account Category
	@SHAREDB varchar(50)		-- 	Name of Share Database

AS

DECLARE
@strSQL VarChar(2500),
@@Inaccat varchar(3)

select @@inaccat = rtrim(convert(varchar,convert(int,@accat)+100,3))

--SET DEFAULT VALUES
SET @WHATTOLOOKFOR = @WHATTOLOOKFOR + "%"
/* SET @BOOKTYPE = @BOOKTYPE + "%" */

--BROKER LOGIN
If  @STATUSID="BROKER"
Begin
	Set @strSQL = "SELECT "
	Set @strSQL = @strSQL + "DISTINCT "
	Set @strSQL = @strSQL + " c1.family "
	Set @strSQL = @strSQL + " FROM acmast a, " + rtrim(@SHAREDB) + ".dbo.client1 c1, " + rtrim(@SHAREDB) + ".dbo.client2 c2 "
	Set @strSQL = @strSQL + " WHERE c1.cl_code = c2.cl_code AND a.cltcode = c2.party_code AND "
	Set @strSQL = @strSQL + " c1.family LIKE '" + @WHATTOLOOKFOR + "' "

--	TO GET A VALUE GREATER/LESSER THAN ANOTHER.
--	USEFUL WHILE TAKING FROM-TO TYPE SELECTIONS
	If @WHICHWAY = ">"
	Begin
		Set @strSQL = @strSQL + " AND "
		Set @strSQL = @strSQL + " c1.family >= '" + @COMPARETOWHAT + "' "
	End
	Else
	Begin
		If @WHICHWAY = "<"
		Begin
			Set @strSQL = @strSQL + " AND "
			Set @strSQL = @strSQL + " c1.family  <= '" + @COMPARETOWHAT + "' "
		End
	End
	Set @strSQL = @strSQL + "ORDER BY "
	Set @strSQL = @strSQL + " c1.family "
End

--BRANCH LOGIN
IF @STATUSID="BRANCH"
Begin
	Set @strSQL = "SELECT "
	Set @strSQL = @strSQL + "DISTINCT "
	Set @strSQL = @strSQL + " c1.family "
	Set @strSQL = @strSQL + " FROM acmast a, " + rtrim(@SHAREDB) + ".dbo.client1 c1, " + rtrim(@SHAREDB) + ".dbo.client2 c2 "
	Set @strSQL = @strSQL + " WHERE c1.cl_code = c2.cl_code AND a.cltcode = c2.party_code AND "
	Set @strSQL = @strSQL + " (branchcode LIKE '" + @STATUSNAME + "' OR branchcode = 'ALL') AND " 
	Set @strSQL = @strSQL + " c1.family LIKE '" + @WHATTOLOOKFOR + "' "

--	TO GET A VALUE GREATER/LESSER THAN ANOTHER.
--	USEFUL WHILE TAKING FROM-TO TYPE SELECTIONS
	If @WHICHWAY = ">"
	Begin
		Set @strSQL = @strSQL + " AND "
		Set @strSQL = @strSQL + " c1.family >= '" + @COMPARETOWHAT + "' "
	End
	Else
	Begin
		If @WHICHWAY = "<"
		Begin
			Set @strSQL = @strSQL + " AND "
			Set @strSQL = @strSQL + " c1.family  <= '" + @COMPARETOWHAT + "' "
		End
	End
	Set @strSQL = @strSQL + "ORDER BY "
	Set @strSQL = @strSQL + " c1.family "
End

--SUB-BROKER LOGIN
IF @STATUSID="SUBBROKER"
Begin
	Set @strSQL = "SELECT "
	Set @strSQL = @strSQL + "DISTINCT "
	Set @strSQL = @strSQL + " c1.family "
	Set @strSQL = @strSQL + " FROM acmast a, " + rtrim(@SHAREDB) + ".dbo.client1 c1, " + rtrim(@SHAREDB) + ".dbo.client2 c2, "
	Set @strSQL = @strSQL + " WHERE c1.cl_code = c2.cl_code AND a.cltcode = c2.party_code AND "
	Set @strSQL = @strSQL + " c1.sub_broker = s.sub_broker AND "
	Set @strSQL = @strSQL + " c1.family LIKE '" + @WHATTOLOOKFOR + "' "

--	TO GET A VALUE GREATER/LESSER THAN ANOTHER.
--	USEFUL WHILE TAKING FROM-TO TYPE SELECTIONS
	If @WHICHWAY = ">"
	Begin
		Set @strSQL = @strSQL + " AND "
		Set @strSQL = @strSQL + " c1.family >= '" + @COMPARETOWHAT + "' "
	End
	Else
	Begin
		If @WHICHWAY = "<"
		Begin
			Set @strSQL = @strSQL + " AND "
			Set @strSQL = @strSQL + " c1.family  <= '" + @COMPARETOWHAT + "' "
		End
	End
	Set @strSQL = @strSQL + "ORDER BY "
	Set @strSQL = @strSQL + " c1.family "
End

--TRADER LOGIN
If @STATUSID="TRADER"
Begin
	Set @strSQL = "SELECT "
	Set @strSQL = @strSQL + "DISTINCT "
	Set @strSQL = @strSQL + " c1.family "
	Set @strSQL = @strSQL + " FROM acmast a, " + rtrim(@SHAREDB) + ".dbo.client1 c1, " + rtrim(@SHAREDB) + ".dbo.client2 c2, "
	Set @strSQL = @strSQL + rtrim(@SHAREDB) + ".dbo.branches b " 
	Set @strSQL = @strSQL + " WHERE c1.cl_code = c2.cl_code AND a.cltcode = c2.party_code AND "
	Set @strSQL = @strSQL + " c1.trader = s.branch_cd AND c1.trader LIKE '" + @STATUSNAME + "' AND "
	Set @strSQL = @strSQL + " c1.family LIKE '" + @WHATTOLOOKFOR + "' "

--	TO GET A VALUE GREATER/LESSER THAN ANOTHER.
--	USEFUL WHILE TAKING FROM-TO TYPE SELECTIONS
	If @WHICHWAY = ">"
	Begin
		Set @strSQL = @strSQL + " AND "
		Set @strSQL = @strSQL + " c1.family >= '" + @COMPARETOWHAT + "' "
	End
	Else
	Begin
		If @WHICHWAY = "<"
		Begin
			Set @strSQL = @strSQL + " AND "
			Set @strSQL = @strSQL + " c1.family  <= '" + @COMPARETOWHAT + "' "
		End
	End
	Set @strSQL = @strSQL + "ORDER BY "
	Set @strSQL = @strSQL + " c1.family "
End

Set @strSQL = @strSQL + "	OPTION  (FAST 10)"

Print @strSQL
Exec (@strSQL)

GO
