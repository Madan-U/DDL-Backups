-- Object: PROCEDURE dbo.rpt_proc_FO_NewTurnOver
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





create     PROC
rpt_proc_FO_NewTurnOver
	@ReportName VarChar(50),
	@StatusID VarChar(20),
	@StatusName VarChar(50),
	@GroupLevel VarChar(10),	--FOR TOP LEVEL REPORT
	@GroupSubLevel VarChar(10),	--FOR SUBSEQUENT DRILL-DOWNS
	@OrderLevel VarChar(10),	--FOR TOP LEVEL REPORT - THIS VARIABLE MAY OR MAY NOT BE USED EVENTUALLY
	@OrderSubLevel VarChar(10),	--FOR SUBSEQUENT DRILL-DOWNS - THIS VARIABLE MAY OR MAY NOT BE USED EVENTUALLY
	@FromDate VarChar(11),
	@ToDate VarChar(11),
	@WhatCode varChar(20),		--REGION/BROKER/BRANCH/SUBBROKER/TRADER/FAMILY/CLIENT
	@FromCode VarChar(20),
	@ToCode VarChar(20),
	@FromPartyCode VarChar(20),	--]--> FOR THE FROM AND TO PARTY CODES
	@ToPartyCode VarChar(20),	--]--> IF THE LEVEL IS ANYTHING OTHER THAN 'PARTY/CLIENT'
	@OneOrMany VarChar(20),
	@InstType VarChar(20),		--]
	@OptionType VarChar(20),	--]
	@StrikePrice Money,		--]-->	PRIMARY SEARCH FIELDS.
	@ExpiryDate VarChar(11),	--]
	@Symbol VarChar(20),		--]
	--REPORT SPECIFIC SEARCH FEILDS
	--PLS DECALRE WITH PREFIX 'EX_' - (EX = EXTRA)				
	@Ex_BillType VarChar(1),	--(SINGLE/MULTIPLE) - BILL						]
	@Ex_AuctionPart VarChar(20),	--SAUDASUMMARY							]
	@Ex_ReportBy VarChar(20),	--(MKT PRICE/NET RATE) - SAUDASUMMARY				]-->	REPORT SPECIFIC
	@Ex_Rate VarChar(20),		--(PREMIUM/BOTH/STRIKE) - SAUDASUMMARY, TURNOVER		]-->	SEARCH FEILDS
	@Ex_MoneyType VarChar(1),	--(IN/AT/OUT) - IN THE MONEY						]
	@Ex_Position VarChar (1),	--(LONG/SHORT) - IN THE MONEY					]
	--END REPORT SPECIFIC SEARCH FEILDS
	@ULCLRate VarChar(50),
	@ClTransactions VarChar(50),
	@Dummy003 VarChar(50),
	@Dummy004 VarChar(50),
	@Dummy005 VarChar(50),
	@Dummy006 VarChar(50),
	@Dummy007 VarChar(50),
	@Dummy008 VarChar(50),
	@Dummy009 VarChar(50),
	@Dummy010 VarChar(50)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

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
	Set @InstType = @InstType+"%" 
	If @OptionType = '' Begin Set @OptionType = "%" End
	--If @StrikePrice = '', -1 IS PASSED FROM THE ASP PAGE
	If @ExpiryDate = '' Begin Set @ExpiryDate = "%" End
	If @Symbol = '' Begin Set @Symbol = "%" End
	
	If @Ex_AuctionPart = '' Begin Set @Ex_AuctionPart = "%" End
	If @Ex_ReportBy = '' Begin Set @Ex_ReportBy = "%" End
	If @Ex_Rate = '' Begin Set @Ex_Rate = "%" End
	Set @strSelect = ''
	Set @strSelectTemp = ''
	Set @strFrom = ''
	Set @strWhere = ''
	Set @strGroupBy = ''
	Set @strOrderBy = ''
	Set @strCompute = ''
	Set @strCompute = ''
	Set @strComputeSub = ''
	Set @IsSubLevel = 'NO'
	If (@FromDate = '' AND @ToDate = '')
	Begin 
		Select @FromDate = Left(Convert(Varchar,Max(Sauda_Date),109),11), @ToDate = Left(Convert(Varchar,Max(Sauda_Date),109),11) From FoBillValan (nolock)
	End 
	If (@ReportName = 'TURNOVER')
	Begin
		If ((@WhatCode = 'BROKER') OR (@WhatCode = 'CLIENT')) Begin Set @CodeID = 'party_code' End
		If (@WhatCode = 'REGION') Begin Set @CodeID = 'region' End
		If (@WhatCode = 'AREA') Begin Set @CodeID = 'Area' End
		If (@WhatCode = 'BRANCH') Begin Set @CodeID = 'branch_code' End
		If (@WhatCode = 'SUBBROKER') Begin Set @CodeID = 'sub_broker' End
		If (@WhatCode = 'TRADER') Begin Set @CodeID = 'trader' End
		If (@WhatCode = 'FAMILY') Begin Set @CodeID = 'family' End
		
		Set @strSelect = @strSelect + "SELECT "
		Set @strCompute = @strCompute + "COMPUTE "
		If ((@OneOrMany = 'DETAIL') OR (@WhatCode = 'CLIENT'))
		Begin
			Set @strSelectTemp = ''
			If (@GroupLevel = 'PARTY')
			Begin
				Set @strSelectTemp = @strSelectTemp + "party_code, max(Left(party_name,25)) AS party_name, max(client_type) as  client_type, max(email) as email, "
				If (@GroupSubLevel = 'SCRIP')
				Begin
					Set @strSelectTemp = @strSelectTemp + "symbol, inst_type, Convert(VarChar,expirydate,103) AS expirydate, strike_price, option_type, "
					Set @IsSubLevel = 'YES'
				End
				If (@GroupSubLevel = 'DATE')
				Begin
					Set @strSelectTemp = @strSelectTemp + "Convert(VarChar,sauda_date,103) AS sauda_date, "
					Set @IsSubLevel = 'YES'
				End
				If (@GroupSubLevel = 'INSTTYPE')
				Begin
					Set @strSelectTemp = @strSelectTemp + "inst_type, "
					Set @IsSubLevel = 'YES'
				End
				
				If (@IsSubLevel = 'YES')
				Begin
					Set @strComputeSub = @strComputeSub + "party_code "
				End
			End
			If (@GroupLevel = 'SCRIP')
			Begin
				Set @strSelectTemp = @strSelectTemp + "symbol, inst_type, Convert(VarChar,expirydate,103) AS expirydate, strike_price, option_type, "
				If (@GroupSubLevel = 'PARTY')
				Begin
					Set @strSelectTemp = @strSelectTemp + "party_code, max(Left(party_name,25)) AS party_name, max(client_type) as client_type, max(email) as email, "
					Set @IsSubLevel = 'YES'
				End
				If (@GroupSubLevel = 'DATE')
				Begin
					Set @strSelectTemp = @strSelectTemp + "Convert(VarChar,sauda_date,103) AS sauda_date, "
					Set @IsSubLevel = 'YES'
				End
				If (@GroupSubLevel = 'INSTTYPE')
				Begin
					Set @strSelectTemp = @strSelectTemp + "inst_type, "
					Set @IsSubLevel = 'YES'
				End
				If (@IsSubLevel = 'YES')
				Begin
					Set @strComputeSub = @strComputeSub + "symbol, inst_type, expirydate, strike_price, option_type "
				End
			End
	
			If (@GroupLevel = 'DATE')
			Begin
				Set @strSelectTemp = @strSelectTemp + "Convert(VarChar,sauda_date,103) AS sauda_date, "
				If (@GroupSubLevel = 'PARTY')
				Begin
					Set @strSelectTemp = @strSelectTemp + "party_code, max(Left(party_name,25)) AS party_name, max(client_type) as client_type, max(email) as email, "
					Set @IsSubLevel = 'YES'
				End
				If (@GroupSubLevel = 'SCRIP')
				Begin
					Set @strSelectTemp = @strSelectTemp + "symbol, inst_type, Convert(VarChar,expirydate,103) AS expirydate, strike_price, option_type, "
					Set @IsSubLevel = 'YES'
				End
				If (@GroupSubLevel = 'INSTTYPE')
				Begin
					Set @strSelectTemp = @strSelectTemp + "inst_type, "
					Set @IsSubLevel = 'YES'
				End
				If (@IsSubLevel = 'YES')
				Begin
					Set @strComputeSub = @strComputeSub + "sauda_date "
				End
			End
	
			If (@GroupLevel = 'INSTTYPE')
			Begin
				Set @strSelectTemp = @strSelectTemp + "inst_type, "
				If (@GroupSubLevel = 'PARTY')
				Begin
					Set @strSelectTemp = @strSelectTemp + "party_code, max(Left(party_name,25)) AS party_name, max(client_type) as  client_type, max(email) as email, "
					Set @IsSubLevel = 'YES'
				End
				If (@GroupSubLevel = 'SCRIP')
				Begin
					Set @strSelectTemp = @strSelectTemp + "symbol, inst_type, Convert(VarChar,expirydate,103) AS expirydate, strike_price, option_type, "
					Set @IsSubLevel = 'YES'
				End
				If (@GroupSubLevel = 'DATE')
				Begin
					Set @strSelectTemp = @strSelectTemp + "Convert(VarChar,sauda_date,103) AS sauda_date, "
					Set @IsSubLevel = 'YES'
				End
				If (@IsSubLevel = 'YES')
				Begin
					Set @strComputeSub = @strComputeSub + "inst_type "
				End
			End
	
			If (@GroupLevel = 'PSD')
			Begin
				Set @strSelectTemp = @strSelectTemp + "party_code, max(Left(party_name,25)) AS party_name,  max(client_type) as  client_type, max(email) as email, symbol, inst_type, Convert(VarChar,expirydate,103) AS expirydate, strike_price, "
				Set @strSelectTemp = @strSelectTemp + "option_type, Convert(VarChar,sauda_date,103) AS sauda_date, "
				Set @IsSubLevel = 'YES'
			End
			Set @strSelect = @strSelect + @strSelectTemp
			Set @strSelectTemp = ''
		End /*If ((@OneOrMany = 'DETAIL') OR (@WhatCode = 'BROKER') OR (@WhatCode = 'CLIENT'))*/
		Else /*If ((@OneOrMany = 'DETAIL') OR (@WhatCode = 'BROKER') OR (@WhatCode = 'CLIENT'))*/
		Begin /*Else OF If ((@OneOrMany = 'DETAIL') OR (@WhatCode = 'BROKER') OR (@WhatCode = 'CLIENT'))*/
			If (@WhatCode = 'CLIENT') Begin Set @strSelect = @strSelect + "party_code, max(Left(party_name,25)) AS party_name, max(client_type) as  client_type, max(email) as email, " End
			If (@WhatCode = 'REGION') Begin Set @strSelect = @strSelect + "region, " End
			If (@WhatCode = 'AREA') Begin Set @strSelect = @strSelect + "Area, " End
			If (@WhatCode = 'BRANCH') Begin Set @strSelect = @strSelect + "branch_code, " End
			If (@WhatCode = 'SUBBROKER') Begin Set @strSelect = @strSelect + "sub_broker, " End
			If (@WhatCode = 'TRADER') Begin Set @strSelect = @strSelect + "trader, " End
			If (@WhatCode = 'FAMILY') Begin Set @strSelect = @strSelect + "family, Left(Familyname,25) AS familyname, " End
		End /*Else OF If ((@OneOrMany = 'DETAIL') OR (@WhatCode = 'BROKER') OR (@WhatCode = 'CLIENT'))*/
		
		If (@Ex_Rate = 'MKTRATE')
		Begin
			--FUTURES TRADED VALUE - MKTRATE - COMMON
			Set @strSelectTemp = ''
			Set @strSelectTemp = @strSelectTemp + "(Sum(Case When inst_type LIKE 'FUT%' AND auctionpart <> 'EA'  AND auctionpart <> 'CA' "
			Set @strSelectTemp = @strSelectTemp + "Then IsNull(prate*pqty*Numerator/Denominator + srate*sqty*Numerator/Denominator,0) Else 0 End)) "
			Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
			Set @strSelectTemp = @strSelectTemp + "AS futurestradedvalue, "
			Set @strSelect = @strSelect + @strSelectTemp
			If (@Ex_ReportBy = 'STRIKE')
			Begin
				--OPTIONS TRADED AMT - MKTRATE + STRIKE
				Set @strSelectTemp = ''
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart <> 'EA' "
				Set @strSelectTemp = @strSelectTemp + "Then ((pqty+sqty)*strike_price*Numerator/Denominator) Else 0 End)) "
				Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* OPTIONS TRADED AMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
				Set @strSelectTemp = @strSelectTemp + "AS optionstradedvalue, "
				Set @strSelect = @strSelect + @strSelectTemp
				--EXCERCISE AMT - MKTRATE + EX/BOTH + STRIKE
				If (@ULCLRate = 'EX')
				Begin
					Set @strSelectTemp = ''
					Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA') "
					Set @strSelectTemp = @strSelectTemp + "Then (sqty*strike_price*Numerator/Denominator) Else 0 End)) "
					Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* EXCERCISE AMT - MKTRATE + EX/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
					Set @strSelectTemp = @strSelectTemp + "AS excercisevalue, "
					Set @strSelect = @strSelect + @strSelectTemp
					Set @strSelectTemp = '0 '
					Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
					Set @strSelectTemp = @strSelectTemp + "AS assignmentvalue, "
					Set @strSelect = @strSelect + @strSelectTemp
				End
				Else /*Of If (@ULCLRate = 'EX')*/
				Begin
					--ASSIGNED AMT - ASG/BOTH + STRIKE
					If (@ULCLRate = 'ASG')
					Begin
						Set @strSelectTemp = '0 '
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS excercisevalue, "
						Set @strSelect = @strSelect + @strSelectTemp
	
						Set @strSelectTemp = ''
						Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA')"
						Set @strSelectTemp = @strSelectTemp + "Then (pqty*strike_price*Numerator/Denominator) Else 0 End)) "
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* ASSIGNED AMT - ASG/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS assignmentvalue, "
						Set @strSelect = @strSelect + @strSelectTemp
					End
					Else /*Of If (@ULCLRate = 'ASG')*/
					--CONTROL WILL BE PASSED HERE IF 'BOTH' IS CHOOSEN FOR THE U/L Cl. Rate
 
					Begin
						Set @strSelectTemp = ''
						Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA') "
						Set @strSelectTemp = @strSelectTemp + "Then (sqty*strike_price*Numerator/Denominator) Else 0 End)) "
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* EXCERCISE AMT - MKTRATE + EX/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS excercisevalue, "
						Set @strSelect = @strSelect + @strSelectTemp
						Set @strSelectTemp = ''
						Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA')"
						Set @strSelectTemp = @strSelectTemp + "Then (pqty*strike_price*Numerator/Denominator) Else 0 End)) "
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* ASSIGNED AMT - ASG/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS assignmentvalue, "
						Set @strSelect = @strSelect + @strSelectTemp
					End /*Of the Else Of If (@ULCLRate = 'ASG')*/
				End /*Of The Else Of If (@ULCLRate = 'EX')*/
				Set @strSelectTemp = ''
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When inst_type LIKE 'FUT%' AND auctionpart = 'EA' AND auctionpart <> 'CA' "
				Set @strSelectTemp = @strSelectTemp + "Then IsNull(prate*pqty*Numerator/Denominator + srate*sqty*Numerator/Denominator,0) Else 0 End)) "
				Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
				Set @strSelectTemp = @strSelectTemp + "AS closeoutvalue, "
				Set @strSelect = @strSelect + @strSelectTemp
				Set @strSelectTemp = ''
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'FUT%' AND auctionpart <> 'CA' ) "
				Set @strSelectTemp = @strSelectTemp + "Then IsNull(prate*pqty*Numerator/Denominator + srate*sqty*Numerator/Denominator,0) Else 0 End)) + "
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' ) "
				Set @strSelectTemp = @strSelectTemp + "Then IsNull((pqty+sqty)*Strike_Price*Numerator/Denominator,0) Else 0 End))  "
				Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
				Set @strSelectTemp = @strSelectTemp + "AS total, "
				Set @strSelect = @strSelect + @strSelectTemp
			End
			If (@Ex_ReportBy = 'PRICE')
			Begin
				--OPTIONS TRADED AMT - MKTRATE + PRICE
				Set @strSelectTemp = ''
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart <> 'EA' "
				Set @strSelectTemp = @strSelectTemp + "Then (((pqty*prate*Numerator/Denominator)+(sqty*srate*Numerator/Denominator))) Else 0 End)) "
				Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* OPTIONS TRADED AMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
				Set @strSelectTemp = @strSelectTemp + "AS optionstradedvalue, "
				Set @strSelect = @strSelect + @strSelectTemp
				--EXCERCISE AMT - MKTRATE + EX/BOTH + PRICE
				If (@ULCLRate = 'EX')
				Begin
					Set @strSelectTemp = ''
					Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA') "
					Set @strSelectTemp = @strSelectTemp + "Then (sqty*srate*Numerator/Denominator) Else 0 End)) "
					Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* EXCERCISE AMT - MKTRATE + EX/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
					Set @strSelectTemp = @strSelectTemp + "AS excercisevalue, "
					Set @strSelect = @strSelect + @strSelectTemp
					Set @strSelectTemp = '0 '
					Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
					Set @strSelectTemp = @strSelectTemp + "AS assignmentvalue, "
					Set @strSelect = @strSelect + @strSelectTemp
				End
				Else /*Of If (@ULCLRate = 'EX')*/
				Begin
					--ASSIGNED AMT - ASG/BOTH + PRICE
					If (@ULCLRate = 'ASG')
					Begin
						Set @strSelectTemp = '0 '
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS excercisevalue, "
						Set @strSelect = @strSelect + @strSelectTemp
	
						Set @strSelectTemp = ''
						Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA')"
						Set @strSelectTemp = @strSelectTemp + "Then (pqty*prate) Else 0 End)) "
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* ASSIGNED AMT - ASG/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS assignmentvalue, "
						Set @strSelect = @strSelect + @strSelectTemp
					End
					Else /*Of If (@ULCLRate = 'ASG')*/
					--CONTROL WILL BE PASSED HERE IF 'BOTH' IS CHOOSEN FOR THE U/L Cl. Rate
 
					Begin
						Set @strSelectTemp = ''
						Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA') "
						Set @strSelectTemp = @strSelectTemp + "Then (sqty*srate*Numerator/Denominator) Else 0 End)) "
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* EXCERCISE AMT - MKTRATE + EX/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS excercisevalue, "
						Set @strSelect = @strSelect + @strSelectTemp
						Set @strSelectTemp = ''
						Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA')"
						Set @strSelectTemp = @strSelectTemp + "Then (pqty*prate*Numerator/Denominator) Else 0 End)) "
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* ASSIGNED AMT - ASG/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS assignmentvalue, "
						Set @strSelect = @strSelect + @strSelectTemp
					End /*Of the Else Of If (@ULCLRate = 'ASG')*/
				End /*Of The Else Of If (@ULCLRate = 'EX')*/
				Set @strSelectTemp = ''
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When inst_type LIKE 'FUT%' AND auctionpart = 'EA' AND auctionpart <> 'CA' "
				Set @strSelectTemp = @strSelectTemp + "Then IsNull(prate*pqty*Numerator/Denominator + srate*sqty*Numerator/Denominator,0) Else 0 End)) "
				Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
				Set @strSelectTemp = @strSelectTemp + "AS closeoutvalue, "
				Set @strSelect = @strSelect + @strSelectTemp
				Set @strSelectTemp = ''
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'FUT%' AND auctionpart <> 'CA' ) "
				Set @strSelectTemp = @strSelectTemp + "Then IsNull(prate*pqty*Numerator/Denominator + srate*sqty*Numerator/Denominator,0) Else 0 End)) + "
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' ) "
				Set @strSelectTemp = @strSelectTemp + "Then IsNull(prate*pqty*Numerator/Denominator + srate*sqty*Numerator/Denominator,0) Else 0 End))  "
				Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
				Set @strSelectTemp = @strSelectTemp + "AS total, "
				Set @strSelect = @strSelect + @strSelectTemp
			End
			If (@Ex_ReportBy = 'BOTH')
			Begin
				--OPTIONS TRADED AMT - MKTRATE + BOTH
				Set @strSelectTemp = ''
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart <> 'EA' "
				Set @strSelectTemp = @strSelectTemp + "Then (((pqty+sqty)*strike_price*Numerator/Denominator) + (pqty*prate*Numerator/Denominator)+(sqty*srate*Numerator/Denominator)) Else 0 End)) "
				Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* OPTIONS TRADED AMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
				Set @strSelectTemp = @strSelectTemp + "AS optionstradedvalue, "
				Set @strSelect = @strSelect + @strSelectTemp
				--EXCERCISE AMT - MKTRATE + EX/BOTH + BOTH
				If (@ULCLRate = 'EX')
				Begin
					Set @strSelectTemp = ''
					Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA') "
					Set @strSelectTemp = @strSelectTemp + "Then (sqty*(strike_price+SRate)*Numerator/Denominator) Else 0 End)) "
					Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* EXCERCISE AMT - MKTRATE + EX/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
					Set @strSelectTemp = @strSelectTemp + "AS excercisevalue, "
					Set @strSelect = @strSelect + @strSelectTemp
					Set @strSelectTemp = '0 '
					Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
					Set @strSelectTemp = @strSelectTemp + "AS assignmentvalue, "
					Set @strSelect = @strSelect + @strSelectTemp
				End
				Else /*Of If (@ULCLRate = 'EX')*/
				Begin
					--ASSIGNED AMT - ASG/BOTH + BOTH
					If (@ULCLRate = 'ASG')
					Begin
						Set @strSelectTemp = '0 '
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS excercisevalue, "
						Set @strSelect = @strSelect + @strSelectTemp
	
						Set @strSelectTemp = ''
						Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA')"
						Set @strSelectTemp = @strSelectTemp + "Then (pqty*(strike_price+PRate)*Numerator/Denominator) Else 0 End)) "
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* ASSIGNED AMT - ASG/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS assignmentvalue, "
						Set @strSelect = @strSelect + @strSelectTemp
					End
					Else /*Of If (@ULCLRate = 'ASG')*/
					--CONTROL WILL BE PASSED HERE IF 'BOTH' IS CHOOSEN FOR THE U/L Cl. Rate
 
					Begin
						Set @strSelectTemp = ''
						Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA') "
						Set @strSelectTemp = @strSelectTemp + "Then (sqty*(strike_price+SRate)*Numerator/Denominator) Else 0 End)) "
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* EXCERCISE AMT - MKTRATE + EX/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS excercisevalue, "
						Set @strSelect = @strSelect + @strSelectTemp
						Set @strSelectTemp = ''
						Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA')"
						Set @strSelectTemp = @strSelectTemp + "Then (pqty*(strike_price+pRate)*Numerator/Denominator) Else 0 End)) "
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* ASSIGNED AMT - ASG/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS assignmentvalue, "
						Set @strSelect = @strSelect + @strSelectTemp
					End /*Of the Else Of If (@ULCLRate = 'ASG')*/
				End /*Of The Else Of If (@ULCLRate = 'EX')*/
				Set @strSelectTemp = ''
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When inst_type LIKE 'FUT%' AND auctionpart = 'EA' AND auctionpart <> 'CA' "
				Set @strSelectTemp = @strSelectTemp + "Then IsNull(prate*pqty*Numerator/Denominator + srate*sqty*Numerator/Denominator,0) Else 0 End)) "
				Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
				Set @strSelectTemp = @strSelectTemp + "AS closeoutvalue, "
				Set @strSelect = @strSelect + @strSelectTemp
				Set @strSelectTemp = ''
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'FUT%' AND auctionpart <> 'CA' ) "
				Set @strSelectTemp = @strSelectTemp + "Then IsNull(prate*pqty*Numerator/Denominator + srate*sqty*Numerator/Denominator,0) Else 0 End)) + "
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' ) "
				Set @strSelectTemp = @strSelectTemp + "Then IsNull((prate+strike_Price)*pqty + (srate+strike_price)*sqty,0) Else 0 End))  "
				Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
				Set @strSelectTemp = @strSelectTemp + "AS total, "
				Set @strSelect = @strSelect + @strSelectTemp
			End
			If (@Ex_ReportBy = 'EXCHG')
			Begin
				--OPTIONS TRADED AMT - MKTRATE + BOTH
				Set @strSelectTemp = ''
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart <> 'EA' "
				Set @strSelectTemp = @strSelectTemp + "Then (((pqty*prate*Numerator/Denominator)+(sqty*srate*Numerator/Denominator))) Else 0 End)) "
				Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* OPTIONS TRADED AMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
				Set @strSelectTemp = @strSelectTemp + "AS optionstradedvalue, "
				Set @strSelect = @strSelect + @strSelectTemp
				--EXCERCISE AMT - MKTRATE + EX/BOTH + BOTH
				If (@ULCLRate = 'EX')
				Begin
					Set @strSelectTemp = ''
					Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA') "
					Set @strSelectTemp = @strSelectTemp + "Then (sqty*strike_price*Numerator/Denominator) Else 0 End)) "
					Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* EXCERCISE AMT - MKTRATE + EX/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
					Set @strSelectTemp = @strSelectTemp + "AS excercisevalue, "
					Set @strSelect = @strSelect + @strSelectTemp
					Set @strSelectTemp = '0 '
					Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
					Set @strSelectTemp = @strSelectTemp + "AS assignmentvalue, "
					Set @strSelect = @strSelect + @strSelectTemp
				End
				Else /*Of If (@ULCLRate = 'EX')*/
				Begin
					--ASSIGNED AMT - ASG/BOTH + BOTH
					If (@ULCLRate = 'ASG')
					Begin
						Set @strSelectTemp = '0 '
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS excercisevalue, "
						Set @strSelect = @strSelect + @strSelectTemp
	
						Set @strSelectTemp = ''
						Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA')"
						Set @strSelectTemp = @strSelectTemp + "Then (pqty*strike_price*Numerator/Denominator) Else 0 End)) "
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* ASSIGNED AMT - ASG/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS assignmentvalue, "
						Set @strSelect = @strSelect + @strSelectTemp
					End
					Else /*Of If (@ULCLRate = 'ASG')*/
					--CONTROL WILL BE PASSED HERE IF 'BOTH' IS CHOOSEN FOR THE U/L Cl. Rate
 
					Begin
						Set @strSelectTemp = ''
						Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type LIKE 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA') "
						Set @strSelectTemp = @strSelectTemp + "Then (sqty*strike_price*Numerator/Denominator) Else 0 End)) "
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* EXCERCISE AMT - MKTRATE + EX/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS excercisevalue, "
						Set @strSelect = @strSelect + @strSelectTemp
						Set @strSelectTemp = ''
						Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA')"
						Set @strSelectTemp = @strSelectTemp + "Then (pqty*strike_price*Numerator/Denominator) Else 0 End)) "
						Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* ASSIGNED AMT - ASG/BOTH + STRIKE */ "	--FOR THE SUB TOTAL
						Set @strSelectTemp = @strSelectTemp + "AS assignmentvalue, "
						Set @strSelect = @strSelect + @strSelectTemp
					End /*Of the Else Of If (@ULCLRate = 'ASG')*/
				End /*Of The Else Of If (@ULCLRate = 'EX')*/
				Set @strSelectTemp = ''
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When inst_type LIKE 'FUT%' AND auctionpart = 'EA' AND auctionpart <> 'CA' "
				Set @strSelectTemp = @strSelectTemp + "Then IsNull(prate*pqty*Numerator/Denominator + srate*sqty*Numerator/Denominator,0) Else 0 End)) "
				Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
				Set @strSelectTemp = @strSelectTemp + "AS closeoutvalue, "
				Set @strSelect = @strSelect + @strSelectTemp
				Set @strSelectTemp = ''
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'FUT%' AND auctionpart <> 'CA' ) "
				Set @strSelectTemp = @strSelectTemp + "Then IsNull(prate*pqty*Numerator/Denominator + srate*sqty*Numerator/Denominator,0) Else 0 End)) + "
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' AND auctionpart <> 'EA') "
				Set @strSelectTemp = @strSelectTemp + "Then IsNull(prate*pqty*Numerator/Denominator + srate*sqty*Numerator/Denominator,0) Else 0 End)) + "
				Set @strSelectTemp = @strSelectTemp + "(Sum(Case When (inst_type like 'OPT%' AND auctionpart <> 'CA' AND auctionpart = 'EA') "
				Set @strSelectTemp = @strSelectTemp + "Then IsNull(Strike_Price*pqty*Numerator/Denominator + Strike_Price*sqty*Numerator/Denominator,0) Else 0 End))  "
				Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* PAMT - MKTRATE + STRIKE */ "	--FOR THE SUB TOTAL
				Set @strSelectTemp = @strSelectTemp + "AS total, "
				Set @strSelect = @strSelect + @strSelectTemp
			End
		End	/*If (@Ex_Rate = 'NETRATE')*/
		--BROKERAGE
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "isnull(Sum(pbrokamt + sbrokamt),0) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* BROKERAGE */ "	--FOR THE SUB TOTAL
		Set @strSelectTemp = @strSelectTemp + "AS brokerage, "
		Set @strSelect = @strSelect + @strSelectTemp
		--SERVICE TAX
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "isnull(Sum(service_tax- ExSer_Tax),0) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* SERVICE TAX */ "	--FOR THE SUB TOTAL
		Set @strSelectTemp = @strSelectTemp + "AS servicetax, "
		Set @strSelect = @strSelect + @strSelectTemp
		--TURNOVER TAX
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "Sum(turn_tax) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* TURNOVER TAX */ "	--FOR THE SUB TOTAL
		Set @strSelectTemp = @strSelectTemp + "AS turnovertax, "
		Set @strSelect = @strSelect + @strSelectTemp
		--SEBI TAX
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "Sum(sebi_tax) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* SEBI TAX */ "	--FOR THE SUB TOTAL
		Set @strSelectTemp = @strSelectTemp + "AS sebitax, "
		Set @strSelect = @strSelect + @strSelectTemp
		--STAMP DUTY
		Set @strSelectTemp = ''
		Set @strSelectTemp = @strSelectTemp + "Sum(broker_note) "
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + "), /* STAMP DUTY */ "	--FOR THE SUB TOTAL
		Set @strSelectTemp = @strSelectTemp + "AS stampduty, "
		Set @strSelect = @strSelect + @strSelectTemp
		--CLEARING CHARGES
		Set @strSelectTemp = ''
		--Set @strSelectTemp = @strSelectTemp + "Sum(cl_chrg - excl_chrg) "
		Set @strSelectTemp = @strSelectTemp + "Sum(Other_Chrg) "      
		Set @strCompute = @strCompute + "Sum(" + @strSelectTemp + ") /* CLEARING CHARGES */ "	--FOR THE SUB TOTAL
		Set @strSelectTemp = @strSelectTemp + "AS clearingcharges "
		Set @strSelect = @strSelect + @strSelectTemp
		Set @strFrom = @strFrom + "FROM "
		Set @strFrom = @strFrom + "FoBillValan (nolock)"
	
		Set @strWhere = @strWhere + "WHERE "
		Set @strWhere = @strWhere + "tradetype = 'BT' AND "
	
		Set @strWhere = @strWhere + "inst_type LIKE '" + @InstType + "' AND "
		Set @strWhere = @strWhere + "option_type LIKE '" + @OptionType + "' AND "
		If (@StrikePrice > -1) Begin Set @strWhere = @strWhere + "strike_price = " + Convert(VarChar,@StrikePrice) + " AND " End
		Set @strWhere = @strWhere + "Left(Convert(VarChar,expirydate,109),11) LIKE '" + @ExpiryDate + "' AND "
		Set @strWhere = @strWhere + "symbol LIKE '" + @Symbol + "' AND "
		  If (@FromCode = '' AND @ToCode = '')      
		  Begin      
		   Set @strWhere = @strWhere + " isnull(" + @CodeID + ",'') LIKE '%' AND "      
		  End      
		  Else      
		  Begin      
		   Set @strWhere = @strWhere + " isnull(" +@CodeID + ",'') >= '" + @FromCode + "' AND "      
		   Set @strWhere = @strWhere + " isnull(" +@CodeID + ",'') <= '" + @ToCode + "' AND "      
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
	
	Set @strWhere = @strWhere + "'" + @STATUSNAME + "' = "
	Set @strWhere = @strWhere + "		(CASE "
	Set @strWhere = @strWhere + "			WHEN '" + @STATUSID +"' = 'BRANCH' THEN BRANCH_CODE"
	Set @strWhere = @strWhere + "			WHEN '" + @STATUSID +"' = 'SUBBROKER' THEN SUB_BROKER"
	Set @strWhere = @strWhere + "			WHEN '" + @STATUSID +"' = 'TRADER' THEN TRADER"
	Set @strWhere = @strWhere + "			WHEN '" + @STATUSID +"' = 'FAMILY' THEN FAMILY"
	Set @strWhere = @strWhere + "			WHEN '" + @STATUSID +"' = 'AREA' THEN AREA"
	Set @strWhere = @strWhere + "			WHEN '" + @STATUSID +"' = 'REGION' THEN REGION"
	Set @strWhere = @strWhere + "			WHEN '" + @STATUSID +"' = 'CLIENT' THEN PARTY_CODE"
	Set @strWhere = @strWhere + "			ELSE "
	Set @strWhere = @strWhere + "		'BROKER'"
	Set @strWhere = @strWhere + "		END)    "

/*END - LOGIN CONDITIONS*/
		Set @Comma = ''
		Set @strGroupBy = @strGroupBy + @Comma
		
		If ((@OneOrMany = 'DETAIL') OR (@WhatCode = 'BROKER') OR (@WhatCode = 'CLIENT'))
		Begin
			If (@GroupLevel = 'PARTY')
			Begin
				Set @strGroupBy = @strGroupBy + "party_code "
				Set @Comma = ', '
				If (@GroupSubLevel = 'SCRIP') Begin Set @strGroupBy = @strGroupBy + @Comma + "symbol, inst_type, expirydate, strike_price, option_type " End
				If (@GroupSubLevel = 'DATE') Begin Set @strGroupBy = @strGroupBy + @Comma + "sauda_date " End
				If (@GroupSubLevel = 'INSTTYPE') Begin Set @strGroupBy = @strGroupBy + @Comma + "inst_type " End
			End
			
			If (@GroupLevel = 'SCRIP')
			Begin
				Set @strGroupBy = @strGroupBy + "symbol, inst_type, expirydate, strike_price, option_type "
				Set @Comma = ', '
				If (@GroupSubLevel = 'PARTY') Begin Set @strGroupBy = @strGroupBy + @Comma + "party_code " End
				If (@GroupSubLevel = 'DATE') Begin Set @strGroupBy = @strGroupBy + @Comma + "sauda_date " End
				If (@GroupSubLevel = 'INSTTYPE') Begin Set @strGroupBy = @strGroupBy /*+ @Comma + "inst_type "*/ End
			End
	
			If (@GroupLevel = 'DATE')
			Begin
				Set @strGroupBy = @strGroupBy + "sauda_date "
				Set @Comma = ', '
				If (@GroupSubLevel = 'PARTY') Begin Set @strGroupBy = @strGroupBy + @Comma + "party_code " End
				If (@GroupSubLevel = 'SCRIP') Begin Set @strGroupBy = @strGroupBy + @Comma + "symbol, inst_type, expirydate, strike_price, option_type " End
				If (@GroupSubLevel = 'INSTTYPE') Begin Set @strGroupBy = @strGroupBy + @Comma + "inst_type " End
			End
	
			If (@GroupLevel = 'INSTTYPE')
			Begin
				Set @strGroupBy = @strGroupBy + "inst_type "
				Set @Comma = ', '
				If (@GroupSubLevel = 'PARTY') Begin Set @strGroupBy = @strGroupBy + @Comma + "party_code " End
				If (@GroupSubLevel = 'SCRIP') Begin Set @strGroupBy = @strGroupBy + @Comma + "symbol, expirydate, strike_price, option_type " End
				If (@GroupSubLevel = 'DATE') Begin Set @strGroupBy = @strGroupBy + @Comma + "sauda_date " End
			End
	
			If (@GroupLevel = 'PSD')
			Begin
				Set @strGroupBy = @strGroupBy + "party_code, symbol, inst_type, expirydate, strike_price, "
				Set @strGroupBy = @strGroupBy + "option_type, sauda_date "
			End
		End /*If (@OneOrMany = 'DETAIL')*/
		Else /*If (@OneOrMany = 'DETAIL')*/
		Begin /*Else OF If (@OneOrMany = 'DETAIL')*/
			If ((@WhatCode = 'BROKER') OR (@WhatCode = 'CLIENT')) Begin Set @strGroupBy = @strGroupBy + "party_code " End
			If (@WhatCode = 'REGION') Begin Set @strGroupBy = @strGroupBy + "region " End
			If (@WhatCode = 'AREA') Begin Set @strGroupBy = @strGroupBy + "Area " End
			If (@WhatCode = 'BRANCH') Begin Set @strGroupBy = @strGroupBy + "branch_code " End
			If (@WhatCode = 'SUBBROKER') Begin Set @strGroupBy = @strGroupBy + "sub_broker " End
			If (@WhatCode = 'TRADER') Begin Set @strGroupBy = @strGroupBy + "trader " End
			If (@WhatCode = 'FAMILY') Begin Set @strGroupBy = @strGroupBy + "family, familyname " End
		End /*Else OF If (@OneOrMany = 'DETAIL')*/
		Set @strOrderBy = @strGroupBy
		Set @strGroupBy = "GROUP BY " + @strGroupBy
		Set @strOrderBy = "ORDER BY " + @strOrderBy
	End/*If (@ReportName = "NETPOSITION")*/

	If @strComputeSub <> '' 
	Begin 
		Set @strComputeSub = "BY " + @strComputeSub 
		Set @strComputeSub = @strCompute + @strComputeSub
	End

	 If (@IsSubLevel = 'YES')      
	 Begin      
	  Print (@strSelect + @strFrom + '  ' + @strWhere + '  ' + @strGroupBy + '  ' + @strOrderBy + '  ' + @strComputeSub + '  ' + @strCompute)      
	  Exec (@strSelect + @strFrom + '  ' + @strWhere + '  ' + @strGroupBy + '  ' + @strOrderBy + '  ' + @strComputeSub + '  ' + @strCompute)      
	 End      
	 Else      
	 Begin      
	  Print (@strSelect + @strFrom + '  ' + @strWhere + '  ' +  @strGroupBy + '  ' + @strOrderBy + '  ' + @strCompute)      
	  Exec (@strSelect + @strFrom + '  ' + @strWhere + '  ' +  @strGroupBy + '  ' + @strOrderBy + '  ' + @strCompute)      
	 End

GO
