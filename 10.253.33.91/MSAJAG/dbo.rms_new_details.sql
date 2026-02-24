-- Object: PROCEDURE dbo.rms_new_details
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


--sp_helptext rpt_proc_NetPosition

--sp_helptext rms_new_details

--WRITTEN BY						:			Animesh
--START DATE						: 			Mar 31 2003.

-------------------------------------------------------------------------------------------------------------------
--				MODIFICATION HISTORY
-------------------------------------------------------------------------------------------------------------------
--	.1	By Animesh On Mar 31 2003
--	**********************************************
--	WRITE MODIFICATION SUMMARY HERE
--	**********************************************
-------------------------------------------------------------------------------------------------------------------

CREATE PROC
rms_new_details

	@ReportName VarChar(50),
	@StatusID VarChar(20),
	@StatusName VarChar(50),

	@FromDate VarChar(11),
	@ToDate VarChar(11),
	@WhatCode varChar(20),		--REGION/BROKER/BRANCH/SUBBROKER/TRADER/FAMILY/CLIENT
	@FromCode VarChar(20),
	@ToCode VarChar(20),

	@FromPartyCode VarChar(20),	--]--> FOR THE FROM AND TO PARTY CODES
	@ToPartyCode VarChar(20),	--]--> IF THE LEVEL IS ANYTHING OTHER THAN 'PARTY/CLIENT'

	@OneOrMany VarChar(20),

	@Dummy001 VarChar(50),
	@Dummy002 VarChar(50),
	@Dummy003 VarChar(50),
	@Dummy004 VarChar(50),
	@Dummy005 VarChar(50),
	@Dummy006 VarChar(50),
	@Dummy007 VarChar(50),
	@Dummy008 VarChar(50),
	@Dummy009 VarChar(50),
	@Dummy010 VarChar(50)
AS

Declare

	@strSelect VarChar(8000),
	@strSelectTemp VarChar(8000),
	@strFrom VarChar(8000),
	@strWhere VarChar(8000),
	@strGroupBy VarChar(8000),
	@strOrderBy VarChar(8000),
	@strCompute VarChar(8000),
	@strComputeSub VarChar(8000),

	@IsSubLevel VarChar(3),
	@CodeID VarChar(20),
	@Comma VarChar(1)

	Set @strSelect = ''
	Set @strSelectTemp = ''
	Set @strFrom = ''
	Set @strWhere = ''
	Set @strGroupBy = ''
	Set @strOrderBy = ''
	Set @strCompute = ''
	Set @strComputeSub = ''
	Set @IsSubLevel = 'NO'	

	If (@ReportName <> '')
	Begin
		If ((@WhatCode = 'BROKER') OR (@WhatCode = 'CLIENT')) Begin Set @CodeID = 'party_code' End
		If (@WhatCode = 'BRANCH') Begin Set @CodeID = 'BRANCH_CD' End
		If (@WhatCode = 'SUBBROKER') Begin Set @CodeID = 'sub_broker' End
		If (@WhatCode = 'TRADER') Begin Set @CodeID = 'trader' End
		If (@WhatCode = 'FAMILY') Begin Set @CodeID = 'family' End
		
		Set @strSelect = @strSelect + "SELECT "
		Set @strCompute = @strCompute + "COMPUTE "

		If ((@OneOrMany = 'DETAIL') OR (@WhatCode = 'CLIENT'))
		Begin		
			If (@WhatCode = 'CLIENT') Begin Set @strSelect = @strSelect + "party_code, Left(party_name,25) AS party_name,NPercentScrip,NPercent,BPercentScrip,BPercent,SALES_PERSON,CUST_EXECUTIVE, " End
			If (@WhatCode = 'BRANCH') Begin Set @strSelect = @strSelect + "BRANCH_CD,party_code, Left(party_name,25) AS party_name,NPercentScrip,NPercent,BPercentScrip,BPercent,SALES_PERSON,CUST_EXECUTIVE, " End
			If (@WhatCode = 'SUBBROKER') Begin Set @strSelect = @strSelect + "sub_broker,party_code, Left(party_name,25) AS party_name,NPercentScrip,NPercent,BPercentScrip,BPercent,SALES_PERSON,CUST_EXECUTIVE, " End
			If (@WhatCode = 'TRADER') Begin Set @strSelect = @strSelect + "trader,party_code, Left(party_name,25) AS party_name,NPercentScrip,NPercent,BPercentScrip,BPercent,SALES_PERSON,CUST_EXECUTIVE, " End
			If (@WhatCode = 'FAMILY') Begin Set @strSelect = @strSelect + "family, Left(Familyname,25) AS familyname,party_code,Left(party_name,25) AS party_name,NPercentScrip,NPercent,BPercentScrip,BPercent,SALES_PERSON,CUST_EXECUTIVE, " End
		End
		Else /*If ((@OneOrMany = 'DETAIL') OR (@WhatCode = 'BROKER') OR (@WhatCode = 'CLIENT'))*/
		Begin /*Else OF If ((@OneOrMany = 'DETAIL') OR (@WhatCode = 'BROKER') OR (@WhatCode = 'CLIENT'))*/
			If (@WhatCode = 'CLIENT') Begin Set @strSelect = @strSelect + "party_code, Left(party_name,25) AS party_name,NPercentScrip,NPercent,BPercentScrip,BPercent,SALES_PERSON,CUST_EXECUTIVE, " End
			If (@WhatCode = 'BRANCH') Begin Set @strSelect = @strSelect + "BRANCH_CD, " End
			If (@WhatCode = 'SUBBROKER') Begin Set @strSelect = @strSelect + "sub_broker, " End
			If (@WhatCode = 'TRADER') Begin Set @strSelect = @strSelect + "trader, " End
			If (@WhatCode = 'FAMILY') Begin Set @strSelect = @strSelect + "family, Left(Familyname,25) AS familyname, " End
		End /*Else OF If ((@OneOrMany = 'DETAIL') OR (@WhatCode = 'BROKER') OR (@WhatCode = 'CLIENT'))*/

		--NON_CASH
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(NON_CASH) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS NON_CASH, "
		Set @strSelect = @strSelect + @strSelectTemp

		--CASH
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(CASH_DEPOSIT) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS CASH_DEPOSIT, "
		Set @strSelect = @strSelect + @strSelectTemp

		--TOT_COLLATERAL_NB
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(TOT_COLLATERAL_NB) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS TOT_COLLATERAL_NB, "
		Set @strSelect = @strSelect + @strSelectTemp
		
		--DebitAcc
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "isnull(sum(DebitValueAfterHairCut),0) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS DebitAcc, "
		Set @strSelect = @strSelect + @strSelectTemp

		--POAValue
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "isnull(sum(POAAfterHairCut),0) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS POAValue, "
		Set @strSelect = @strSelect + @strSelectTemp

		--PayIn
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "isnull(sum(PayinAfterHairCut),0) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS PayIn, "
		Set @strSelect = @strSelect + @strSelectTemp

		--CREDIT_LIMIT
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(CREDIT_LIMIT) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS CREDIT_LIMIT, "
		Set @strSelect = @strSelect + @strSelectTemp

		--NB_LEDGER_VOC_BAL
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(NB_LEDGER_VOC_BAL) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS NB_LEDGER_VOC_BAL, "
		Set @strSelect = @strSelect + @strSelectTemp

		--NB_LEDGER_EFF_BAL
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(NB_LEDGER_EFF_BAL) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS NB_LEDGER_EFF_BAL, "
		Set @strSelect = @strSelect + @strSelectTemp

		--NB_TOTAL_MTM
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(NB_TOTAL_MTM) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS NB_TOTAL_MTM, "
		Set @strSelect = @strSelect + @strSelectTemp

		--MTM_LOSSES
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(MTM_LOSSES) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS MTM_LOSSES, "
		Set @strSelect = @strSelect + @strSelectTemp

		--AVM
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(AVM) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS AVM, "
		Set @strSelect = @strSelect + @strSelectTemp

		--NB_DAY_PURCH
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(NB_DAY_PURCH) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS NB_DAY_PURCH, "
		Set @strSelect = @strSelect + @strSelectTemp

		--NB_DAY_SALES
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(NB_DAY_SALES) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS NB_DAY_SALES, "
		Set @strSelect = @strSelect + @strSelectTemp

		--NB_UPTO_DAY_EXP
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(NB_UPTO_DAY_EXP) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS NB_UPTO_DAY_EXP, "
		Set @strSelect = @strSelect + @strSelectTemp

		--NB_TOTAL_CURRENTGE
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(NB_TOTAL_CURRENTGE) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS NB_TOTAL_CURRENTGE, "
		Set @strSelect = @strSelect + @strSelectTemp

		--PRIVE GE NEW
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(N_PREV_GE+B_TOTAL_GE) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS PRIVE_GE, "
		Set @strSelect = @strSelect + @strSelectTemp

		--NB_EXCESS_SHORT
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(NB_EXCESS_SHORT) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS NB_EXCESS_SHORT, "
		Set @strSelect = @strSelect + @strSelectTemp

		--trdTurn
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(N_TRDTURNOVER+B_TRDTURNOVER) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS trdTurn, "
		Set @strSelect = @strSelect + @strSelectTemp

		--DelTurn
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(N_DELTURNOVER+B_DELTURNOVER) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), " 
		Set @strSelectTemp = @strSelectTemp + "AS DelTurn, "
		Set @strSelect = @strSelect + @strSelectTemp
		
		--NB_TURNOVER
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(NB_TURNOVER) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS NB_TURNOVER, "
		Set @strSelect = @strSelect + @strSelectTemp

		--NB_ALLOWED
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(NB_ALLOWED) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS NB_ALLOWED, "
		Set @strSelect = @strSelect + @strSelectTemp
		Set @strSelectTemp = ""

		--TotalAvgTurnOver
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(TotalAvgTurnOver) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")," 
		Set @strSelectTemp = @strSelectTemp + "AS TotalAvgTurnOver, "
		Set @strSelect = @strSelect + @strSelectTemp

		--LAST 15 DAYS
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "sum(NAvgTurnover15) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ")" 
		Set @strSelectTemp = @strSelectTemp + "AS LAST_15_DAYS "
		Set @strSelect = @strSelect + @strSelectTemp


		Set @strFrom = @strFrom + "FROM "
		Set @strFrom = @strFrom + "RMSALLSEGMENT "
	
		Set @strWhere = @strWhere + "WHERE "	
		If (@FromCode = '' AND @ToCode = '')
		Begin
			Set @strWhere = @strWhere + @CodeID + " LIKE '%' AND "
		End
		Else
		Begin
			Set @strWhere = @strWhere + @CodeID + " >= '" + @FromCode + "' AND "
			Set @strWhere = @strWhere + @CodeID + " <= '" + @ToCode + "' AND "
		End

		If (@FromDate = '' AND @ToDate = '')
		Begin
			Set @strWhere = @strWhere + "sauda_date LIKE '%' AND "
		End
		Else
		Begin
			Set @strWhere = @strWhere + "sauda_date >= '" + @FromDate + " 00:00:00' AND "
			Set @strWhere = @strWhere + "sauda_date <= '" + @ToDate + " 23:59:59' AND "
		End

		If ((@FromPartyCode <> '' AND @ToPartyCode <> ''))
		Begin
			Set @strWhere = @strWhere + "party_code >= '" + @FromPartyCode + "' AND "
			Set @strWhere = @strWhere + "party_code <= '" + @ToPartyCode + "' AND "
		End
		
		/*LOGIN CONDITIONS*/
		Set @strWhere = @strWhere + "BRANCH_CD LIKE (Case When '" + @StatusID + "' = 'branch' Then '" + @StatusName + "' Else '%' End) AND "
		Set @strWhere = @strWhere + "sub_broker LIKE (Case When '" + @StatusID + "' = 'subbroker' Then '" + @StatusName + "' Else '%' End) AND "
		Set @strWhere = @strWhere + "trader LIKE (Case When '" + @StatusID + "' = 'trader' Then '" + @StatusName + "' Else '%' End) AND "
		Set @strWhere = @strWhere + "family LIKE (Case When '" + @StatusID + "' = 'family' Then '" + @StatusName + "' Else '%' End) AND "
		Set @strWhere = @strWhere + "party_code LIKE (Case When '" + @StatusID + "' = 'client' Then '" + @StatusName + "' Else '%' End) "
		/*END - LOGIN CONDITIONS*/

		Set @Comma = ''

		Set @strGroupBy = @strGroupBy + @Comma
		
		If ((@OneOrMany = 'DETAIL') OR (@WhatCode = 'BROKER') OR (@WhatCode = 'CLIENT'))
		Begin
			If ((@WhatCode = 'BROKER') OR (@WhatCode = 'CLIENT')) Begin Set @strGroupBy = @strGroupBy + "party_code, party_name,NPercentScrip,NPercent,BPercentScrip,BPercent,SALES_PERSON,CUST_EXECUTIVE " End
			If (@WhatCode = 'BRANCH') Begin Set @strGroupBy = @strGroupBy + "BRANCH_CD,party_code, party_name,NPercentScrip,NPercent,BPercentScrip,BPercent,SALES_PERSON,CUST_EXECUTIVE " End
			If (@WhatCode = 'SUBBROKER') Begin Set @strGroupBy = @strGroupBy + "sub_broker,party_code, party_name,NPercentScrip,NPercent,BPercentScrip,BPercent,SALES_PERSON,CUST_EXECUTIVE " End
			If (@WhatCode = 'TRADER') Begin Set @strGroupBy = @strGroupBy + "trader,party_code, party_name,NPercentScrip,NPercent,BPercentScrip,BPercent,SALES_PERSON,CUST_EXECUTIVE " End
			If (@WhatCode = 'FAMILY') Begin Set @strGroupBy = @strGroupBy + "family,FamilyName,party_code, party_name,NPercentScrip,NPercent,BPercentScrip,BPercent,SALES_PERSON,CUST_EXECUTIVE " End
		End /*If (@OneOrMany = 'DETAIL')*/
		Else /*If (@OneOrMany = 'DETAIL')*/
		Begin /*Else OF If (@OneOrMany = 'DETAIL')*/
			If ((@WhatCode = 'BROKER') OR (@WhatCode = 'CLIENT')) Begin Set @strGroupBy = @strGroupBy + "party_code, party_name,NPercentScrip,NPercent,BPercentScrip,BPercent,SALES_PERSON,CUST_EXECUTIVE " End
			If (@WhatCode = 'BRANCH') Begin Set @strGroupBy = @strGroupBy + "BRANCH_CD " End
			If (@WhatCode = 'SUBBROKER') Begin Set @strGroupBy = @strGroupBy + "sub_broker " End
			If (@WhatCode = 'TRADER') Begin Set @strGroupBy = @strGroupBy + "trader " End
			If (@WhatCode = 'FAMILY') Begin Set @strGroupBy = @strGroupBy + "family,FamilyName " End
		End /*Else OF If (@OneOrMany = 'DETAIL')*/
		Set @strOrderBy = @strGroupBy
		Set @strGroupBy = "GROUP BY " + @strGroupBy
		Set @strOrderBy = "ORDER BY " + @strOrderBy

	End/*If (@ReportName = "SAUDASUMMARY")*/

	Print 'ReportName : ' + @ReportName
	Print 'StatusID : ' + @StatusID
	Print 'StatusName : ' + @StatusName
	
	Print 'FromDate : ' + @FromDate
	Print 'ToDate : ' + @ToDate
	Print 'WhatCode : ' + @WhatCode
	Print 'FromCode : ' + @FromCode
	Print 'ToCode : ' + @ToCode	
	
	Print 'Dummy001 : ' + @Dummy001
	Print 'Dummy002 : ' + @Dummy002
	Print 'Dummy003 : ' + @Dummy003
	Print 'Dummy004 : ' + @Dummy004
	Print 'Dummy005 : ' + @Dummy005
	Print 'Dummy006 : ' + @Dummy006
	Print 'Dummy007 : ' + @Dummy007
	Print 'Dummy008 : ' + @Dummy008
	Print 'Dummy009 : ' + @Dummy009
	Print 'Dummy010 : ' + @Dummy010

	Print '=============================================================================================='

	If @strComputeSub <> '' 
	Begin 
		Set @strComputeSub = "BY " + @strComputeSub 
		Set @strComputeSub = @strCompute + @strComputeSub
	End

	If (@IsSubLevel = 'YES')
	Begin
		Exec (@strSelect + @strFrom + @strWhere + @strGroupBy + @strOrderBy + @strComputeSub + @strCompute)
	End
	Else
	Begin
		Exec (@strSelect + @strFrom + @strWhere + @strGroupBy + @strOrderBy + @strCompute)
	End

	Print @strSelect + @strFrom + @strWhere + @strGroupBy + @strOrderBy + @strComputeSub + @strCompute

	Print @strSelect 
	Print @strFrom
	Print @strWhere
	Print @strGroupBy
	Print @strOrderBy
	Print @strComputeSub
	Print @strCompute

GO
