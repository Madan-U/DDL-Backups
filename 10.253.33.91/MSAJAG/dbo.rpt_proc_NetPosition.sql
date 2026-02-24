-- Object: PROCEDURE dbo.rpt_proc_NetPosition
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC rpt_proc_NetPosition

@strStatusID VarChar (20),
@strStatusName VarChar (20),

@strIdentifier VarChar(20),
@strSearchString VarChar(50),

@strReportFor VarChar(25),
@strFromCode VarChar(25),
@strToCode VarChar(25),
@strFromPartyCode VarChar(25),
@strToPartyCode VarChar(25),
@strFromDate VarChar(25),
@strToDate VarChar(25),
@strInstType VarChar(25),
@strSymbol VarChar(25),
@strExpiryDate VarChar(25),
@strOptionType VarChar(25),
@strStrikePrice Money,
@strAuctionPart VarChar(25),

@strDummy001 VarChar(25),
@strDummy002 VarChar(25),
@strDummy003 VarChar(25),
@strDummy004 VarChar(25),
@strDummy005 VarChar(25),
@strDummy006 VarChar(25),
@strDummy007 VarChar(25),
@strDummy008 VarChar(25),
@strDummy009 VarChar(25),
@blnFromUpdatePage VarChar(25)

AS

Declare
	@strSQL VarChar(8000),
	@strWhatToList VarChar(50)

	Set @strInstType = @strInstType+"%" 

	If (@strReportFor = 'REGION')  Begin Set @strWhatToList = "region" End
	If (@strReportFor = 'BRANCH')  Begin Set @strWhatToList = "branch_cd" End
	If (@strReportFor = 'SUBBROKER')  Begin Set @strWhatToList = "sub_broker" End
	If (@strReportFor = 'TRADER')  Begin Set @strWhatToList = "trader" End
	If (@strReportFor = 'FAMILY')  Begin Set @strWhatToList = "family" End
	If (@strReportFor = 'CLIENT')  Begin Set @strWhatToList = "party_code" End

	--If (@blnFromUpdatePage = 'FALSE')
	--Begin
		--FROM CODE
		If (@strIdentifier = 'FROMCODE')
		Begin
			Set @strSQL = "SELECT DISTINCT " + @strWhatToList + " AS from_code FROM RMSALLSEGMENT WHERE "
			Set @strSQL = @strSQL + @strWhatToList + " LIKE '" + @strSearchString + "%' "
		
			If @strToCode <> '' Begin Set @strSQL = @strSQL + " AND " + @strWhatToList + " <= '" + @strToCode + "' " End
			
			If (@strFromDate <> '') Begin Set @strSQL = @strSQL + " AND sauda_date >= '" + @strFromDate + " 00:00:00' " End
			If (@strToDate <> '') Begin Set @strSQL = @strSQL + " AND sauda_date <= '" + @strToDate + " 23:59:59' " End
		End

		--TO CODE
		If (@strIdentifier = 'TOCODE')
		Begin
			Set @strSQL = "SELECT DISTINCT " + @strWhatToList + " AS from_code FROM RMSALLSEGMENT WHERE "
			Set @strSQL = @strSQL + @strWhatToList + " LIKE '" + @strSearchString + "%' "
		
			If @strFromCode <> '' Begin Set @strSQL = @strSQL + " AND " + @strWhatToList + " >= '" + @strFromCode + "' " End
			
			If (@strFromDate <> '') Begin Set @strSQL = @strSQL + " AND sauda_date >= '" + @strFromDate + " 00:00:00' " End
			If (@strToDate <> '') Begin Set @strSQL = @strSQL + " AND sauda_date <= '" + @strToDate + " 23:59:59' " End
		End

		--FROM DATE
		If (@strIdentifier = 'FROMDATE')
		Begin
			--Set @strWhatToList = 'sauda_date'
			Set @strSQL = "SELECT DISTINCT sauda_date, Convert(VarChar, sauda_date, 103) AS from_code FROM RMSALLSEGMENT WHERE "
			Set @strSQL = @strSQL + "sauda_date LIKE '" + @strSearchString + "%' "
		
			If @strToDate <> '' Begin Set @strSQL = @strSQL + " AND sauda_date <= '" + @strToDate + " 23:59:59' " End
		
			If (@strFromCode <> '') Begin Set @strSQL = @strSQL + " AND " + @strWhatToList + " >= '" + @strFromCode + "' " End
			If (@strToCode <> '') Begin Set @strSQL = @strSQL + " AND " + @strWhatToList + " <= '" + @strToCode + "' " End
		End
	
		Set @strSQL = @strSQL + "AND branch_cd LIKE (Case When '" + @strStatusID + "' = 'branch' Then '" + @strStatusName + "' Else '%' End) "
		Set @strSQL = @strSQL + "AND sub_broker LIKE (Case When '" + @strStatusID + "' = 'subbroker' Then '" + @strStatusName + "' Else '%' End) "
		Set @strSQL = @strSQL + "AND trader LIKE (Case When '" + @strStatusID + "' = 'trader' Then '" + @strStatusName + "' Else '%' End) "
		Set @strSQL = @strSQL + "AND family LIKE (Case When '" + @strStatusID + "' = 'family' Then '" + @strStatusName + "' Else '%' End) "
		Set @strSQL = @strSQL + "AND party_code LIKE (Case When '" + @strStatusID + "' = 'client' Then '" + @strStatusName + "' Else '%' End) "
		
	Set @strSQL = @strSQL + "ORDER BY (1)"

	Print @strIdentifier + '-->Identifier'
	Print @strSearchString + '-->Search String'
	Print @strReportFor + '-->Report For'
	Print @strFromCode + '-->From Code'
	Print @strToCode + '-->To Code'
	Print @strFromPartyCode + '-->From Party Code'
	Print @strToPartyCode + '-->To Party Code'
	Print @strFromDate + '-->From Date'
	Print @strToDate + '-->To Date'
	Print @strInstType + '-->Inst. Type'
	Print @strSymbol + '-->Symbol'
	Print @strExpiryDate + '-->Expiry Date'
	Print @strOptionType + '-->Option Type'
	Print Convert(VarChar, @strStrikePrice) + '-->Strike Price'
	Print @strAuctionPart + '-->Auc Part'

	Print @strSQL
	Exec(@strSQL)

GO
