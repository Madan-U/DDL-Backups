-- Object: PROCEDURE dbo.Rpt_proc_netposition
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




/****** Object:  Stored Procedure Dbo.rpt_proc_netposition    Script Date: 01/15/2005 1:44:14 Pm ******/

/****** Object:  Stored Procedure Dbo.rpt_proc_netposition    Script Date: 10/29/2004 12:01:43 Pm ******/


/****** Object:  Stored Procedure Dbo.rpt_proc_netposition    Script Date: 12/16/2003 2:31:57 Pm ******/


Create    Proc
Rpt_proc_netposition

@strstatusid Varchar (20),
@strstatusname Varchar (20),

@stridentifier Varchar(20),
@strsearchstring Varchar(50),

@strreportfor Varchar(25),
@strfromcode Varchar(25),
@strtocode Varchar(25),
@strfrompartycode Varchar(25),
@strtopartycode Varchar(25),
@strfromdate Varchar(25),
@strtodate Varchar(25),
@strinsttype Varchar(25),
@strsymbol Varchar(25),
@strexpirydate Varchar(25),
@stroptiontype Varchar(25),
@strstrikeprice Money,
@strauctionpart Varchar(25),

@strcategory Varchar(50),
@strdummy002 Varchar(25),
@strdummy003 Varchar(25),
@strdummy004 Varchar(25),
@strdummy005 Varchar(25),
@strdummy006 Varchar(25),
@strdummy007 Varchar(25),
@strdummy008 Varchar(25),
@strdummy009 Varchar(25),
@blnfromupdatepage Varchar(25)

As

Declare
	@strsql Varchar(8000),
	@strwhattolist Varchar(50)

	Set @strinsttype = @strinsttype+"%" 

	If (@strreportfor = 'region')  Begin Set @strwhattolist = "region" End
	If (@strreportfor = 'branch')  Begin Set @strwhattolist = "branch_cd" End
	If (@strreportfor = 'subbroker')  Begin Set @strwhattolist = "sub_broker" End
	If (@strreportfor = 'trader')  Begin Set @strwhattolist = "trader" End
	If (@strreportfor = 'family')  Begin Set @strwhattolist = "family" End
	If (@strreportfor = 'client')  Begin Set @strwhattolist = "party_code" End
	If (@strreportfor = 'category')  Begin Set @strwhattolist = "category" End

	--if (@blnfromupdatepage = 'false')
	--begin
		--from Code
		If (@stridentifier = 'fromcode')
		Begin
			Set @strsql = "select Distinct " + @strwhattolist + " As From_code From Rmsallsegment Where "
			Set @strsql = @strsql + @strwhattolist + " Like '" + @strsearchstring + "%' "
		
			If @strtocode <> '' Begin Set @strsql = @strsql + " And " + @strwhattolist + " <= '" + @strtocode + "' " End
			
			If (@strfromdate <> '') Begin Set @strsql = @strsql + " And Sauda_date >= '" + @strfromdate + " 00:00:00' " End
			If (@strtodate <> '') Begin Set @strsql = @strsql + " And Sauda_date <= '" + @strtodate + " 23:59:59' " End
		End

		--to Code
		If (@stridentifier = 'tocode')
		Begin
			Set @strsql = "select Distinct " + @strwhattolist + " As From_code From Rmsallsegment Where "
			Set @strsql = @strsql + @strwhattolist + " Like '" + @strsearchstring + "%' "
		
			If @strfromcode <> '' Begin Set @strsql = @strsql + " And " + @strwhattolist + " >= '" + @strfromcode + "' " End
			
			If (@strfromdate <> '') Begin Set @strsql = @strsql + " And Sauda_date >= '" + @strfromdate + " 00:00:00' " End
			If (@strtodate <> '') Begin Set @strsql = @strsql + " And Sauda_date <= '" + @strtodate + " 23:59:59' " End
		End

		--from Date
		If (@stridentifier = 'fromdate')
		Begin
			--set @strwhattolist = 'sauda_date'
			Set @strsql = "select Distinct Sauda_date, Convert(varchar, Sauda_date, 103) As From_code From Rmsallsegment Where "
			Set @strsql = @strsql + "sauda_date Like '" + @strsearchstring + "%' "
		
			If @strtodate <> '' Begin Set @strsql = @strsql + " And Sauda_date <= '" + @strtodate + " 23:59:59' " End
		
			If (@strfromcode <> '') Begin Set @strsql = @strsql + " And " + @strwhattolist + " >= '" + @strfromcode + "' " End
			If (@strtocode <> '') Begin Set @strsql = @strsql + " And " + @strwhattolist + " <= '" + @strtocode + "' " End
		End

		If (@stridentifier = 'category')
		Begin
			--set @strwhattolist = 'sauda_date'
			Set @strsql = "select Distinct Category=categorycode  From Rmsallsegment Where "
			Set @strsql = @strsql + "sauda_date Like '" + @strsearchstring + "%' "
		
			If @strtodate <> '' Begin Set @strsql = @strsql + " And Sauda_date <= '" + @strtodate + " 23:59:59' " End
		
			If (@strfromcode <> '') Begin Set @strsql = @strsql + " And " + @strwhattolist + " >= '" + @strfromcode + "' " End
			If (@strtocode <> '') Begin Set @strsql = @strsql + " And " + @strwhattolist + " <= '" + @strtocode + "' " End
		End
	
		Set @strsql = @strsql + "and Branch_cd Like (case When '" + @strstatusid + "' = 'branch' Then '" + @strstatusname + "' Else '%' End) "
		Set @strsql = @strsql + "and Sub_broker Like (case When '" + @strstatusid + "' = 'subbroker' Then '" + @strstatusname + "' Else '%' End) "
		Set @strsql = @strsql + "and Trader Like (case When '" + @strstatusid + "' = 'trader' Then '" + @strstatusname + "' Else '%' End) "
		Set @strsql = @strsql + "and Family Like (case When '" + @strstatusid + "' = 'family' Then '" + @strstatusname + "' Else '%' End) "
		Set @strsql = @strsql + "and Region Like (case When '" + @strstatusid + "' = 'region' Then '" + @strstatusname + "' Else '%' End) "
		Set @strsql = @strsql + "and Area Like (case When '" + @strstatusid + "' = 'area' Then '" + @strstatusname + "' Else '%' End) "
		Set @strsql = @strsql + "and Party_code Like (case When '" + @strstatusid + "' = 'client' Then '" + @strstatusname + "' Else '%' End) "
		
	Set @strsql = @strsql + "order By (1)"
/*
	Print @stridentifier + '-->identifier'
	Print @strsearchstring + '-->search String'
	Print @strreportfor + '-->report For'
	Print @strfromcode + '-->from Code'
	Print @strtocode + '-->to Code'
	Print @strfrompartycode + '-->from Party Code'
	Print @strtopartycode + '-->to Party Code'
	Print @strfromdate + '-->from Date'
	Print @strtodate + '-->to Date'
	Print @strinsttype + '-->inst. Type'
	Print @strsymbol + '-->symbol'
	Print @strexpirydate + '-->expiry Date'
	Print @stroptiontype + '-->option Type'
	Print Convert(varchar, @strstrikeprice) + '-->strike Price'
	Print @strauctionpart + '-->auc Part'

	Print @strsql
*/
	Exec(@strsql)

GO
