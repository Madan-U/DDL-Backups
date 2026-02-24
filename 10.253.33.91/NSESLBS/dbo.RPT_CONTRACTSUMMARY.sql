-- Object: PROCEDURE dbo.RPT_CONTRACTSUMMARY
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  PROC RPT_CONTRACTSUMMARY(
	@STATUSID VARCHAR(15),
	@STATUSNAME VARCHAR(25), 
	@FROMDATE VARCHAR(11),
	@TODATE VARCHAR(11),
	@FROMPARTY VARCHAR(15),
	@TOPARTY VARCHAR(15),
	@FROMBRANCH VARCHAR(15),
	@TOBRANCH VARCHAR(15),
	@CLIENTTYPE VARCHAR(5)
	)
	
	AS

        SET NOCOUNT ON 

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	--EXEC RPT_CONTRACTSUMMARY 'BROKER','BROKER','JAN  1 2004','JAN  1 2007','0','ZZZZZZ','0','ZZZZZZZ','ALL'

	SELECT 
		PARTY_CODE,
		C1.BRANCH_CD,
		CL_TYPE,
		C1.LONG_NAME,
                C2.SERVICE_CHRG, 
                BROKERNOTE, 
                TURNOVER_TAX, 
                SEBI_TURN_TAX, 
                C2.OTHER_CHRG, 
                INSURANCE_CHRG,
		BRANCH = ISNULL(BRANCH,'')

	INTO 	#CLIENTMASTER	
	FROM
		CLIENT1 C1 WITH(NOLOCK)
			LEFT OUTER JOIN 
			BRANCH ON (BRANCH_CODE = BRANCH_CD),
		CLIENT2 C2 WITH(NOLOCK)
	WHERE
		C1.CL_CODE = C2.CL_CODE
		AND C2.PARTY_CODE >= @FROMPARTY
		AND C2.PARTY_CODE <= @TOPARTY
		AND BRANCH_CD >= @FROMBRANCH
		AND BRANCH_CD <= @TOBRANCH
		And C1.CL_TYPE Like 
		(CASE 
			When @CLIENTTYPE='ALL' 
			Then '%' 
			Else @CLIENTTYPE 
			End)
                AND @STATUSNAME = 
		(CASE 
                        WHEN @STATUSID = 'BRANCH' 
                        THEN C1.BRANCH_CD 
                        WHEN @STATUSID = 'SUBBROKER' 
                        THEN C1.SUB_BROKER 
                        WHEN @STATUSID = 'TRADER' 
                        THEN C1.TRADER 
                        WHEN @STATUSID = 'FAMILY' 
                        THEN C1.FAMILY 
                        WHEN @STATUSID = 'AREA' 
                        THEN C1.AREA 
                        WHEN @STATUSID = 'REGION' 
                        THEN C1.REGION 
                        WHEN @STATUSID = 'CLIENT' 
                        THEN C2.PARTY_CODE 
                        ELSE 'BROKER' END)



	SELECT 
		ContractNo, 
		s.Party_code, 
		s.Sett_no, 
		branch_cd,
		cl_type,
		s.sett_type,
		Brokerage = sum(NBrokApp*TradeQty),
		ServTax = sum(NSertax),
		Amount = sum(tradeqty*N_NetRate),
		PurchaseBrokerage =
			SUM(Case When Sell_Buy = 1 
				Then NBrokApp*TradeQty + 
				(Case When Service_Chrg =1 
					Then NSertax 
					Else 0 
					End) 
				Else 0 
				End),
		SellBrokerage = 
			SUM(Case When Sell_Buy = 2 
				Then NBrokApp*TradeQty + 
				(Case When Service_Chrg =1 
					Then NSertax 
					Else 0 
					End) 
				Else 0 
				End), 
		PurchaseAmount = 
			SUM(Case When Sell_Buy = 1 
				Then N_NetRate*TradeQty + 
				(Case When Service_Chrg <> 2 
					Then NSertax 
					Else 0 
					End) + 
				(Case When Insurance_Chrg = 1 
					Then Ins_chrg 
					Else 0 
					End) + 
				(Case When Turnover_tax = 1 
					Then turn_tax 
					Else 0 
					End) +
		                (CASE 
		                        WHEN BROKERNOTE = 1 
		                        THEN BROKER_CHRG 
		                        ELSE 0 
					END) +
				(CASE 
		                        WHEN SEBI_TURN_TAX = 1 
		                        THEN SEBI_TAX 
		                        ELSE 0 
					END) +			
				(CASE 
		                        WHEN C.OTHER_CHRG = 1 
		                        THEN S.OTHER_CHRG 
		                        ELSE 0 
					END ) 
				Else 0 
				End), 
		SellAmount = 
			SUM(Case When Sell_Buy = 2 
				Then N_NetRate*TradeQty - 
				(Case When Service_Chrg <> 2 
					Then NSertax 
					Else 0 
					End) - 
				(Case When Insurance_Chrg = 1 
					Then Ins_chrg 
					Else 0 
					End) - 
				(Case When Turnover_tax = 1 
					Then turn_tax 
					Else 0 
					End) -
		                (CASE 
		                        WHEN BROKERNOTE = 1 
		                        THEN BROKER_CHRG 
		                        ELSE 0 
					END) -
				(CASE 
		                        WHEN SEBI_TURN_TAX = 1 
		                        THEN SEBI_TAX 
		                        ELSE 0 
					END) -			
				(CASE 
		                        WHEN C.OTHER_CHRG = 1 
		                        THEN S.OTHER_CHRG 
		                        ELSE 0 
					END) 
				Else 0 
				End), 
		Partyname = C.Long_name,
		Flag = 2,
                BROKER_CHRG = SUM( 
                CASE 
                        WHEN BROKERNOTE = 1 
                        THEN BROKER_CHRG 
                        ELSE 0 END), 
                TURN_TAX = SUM( 
                CASE 
                        WHEN TURNOVER_TAX = 1 
                        THEN TURN_TAX 
                        ELSE 0 END ), 
                SEBI_TAX = SUM( 
                CASE 
                        WHEN SEBI_TURN_TAX = 1 
                        THEN SEBI_TAX 
                        ELSE 0 END ), 
                OTHER_CHRG = SUM( 
                CASE 
                        WHEN C.OTHER_CHRG = 1 
                        THEN S.OTHER_CHRG 
                        ELSE 0 END ) , 
                INS_CHRG = SUM( 
                CASE 
                        WHEN INSURANCE_CHRG = 1                         THEN INS_CHRG 
                        ELSE 0 END ), 
                SERVICE_TAX = SUM( 
                CASE 
                        WHEN SERVICE_CHRG = 0 
                        THEN NSERTAX 
                        ELSE 0 END ), 
		Tradedate = left(convert(varchar,sauda_date,109),11),
		PayIn = convert(varchar(11),sec_payin,103),
		PayOut = convert(varchar(11),sec_payout,103),
		BranchName = ISNULL(Branch,'')
		--Sell_Buy

	FROM 
		SETTLEMENT S WITH(NOLOCK),
		SETT_MST M WITH(NOLOCK), 
		#CLIENTMASTER C WITH(NOLOCK)

	WHERE 
		S.Sett_No = M.Sett_No 
		And S.Sett_Type = M.Sett_Type 
		And s.party_code = C.party_code
		And s.tradeqty > 0
		And Sauda_date >= @FROMDATE
		And Sauda_date <= @TODATE + ' 23:59' 
		And AuctionPart Not in ('AP','AR','FA','FC','FS','FL','FP')

	GROUP BY 
		Cl_type,
		branch_cd, 
		s.Party_code, 
		s.Sett_no,
		s.sett_type,
		left(convert(varchar,sauda_date,109),11),
		convert(varchar(11),sec_payin,103),
		convert(varchar(11),sec_payout,103),
		ContractNo,
		C.Long_name,
		ISNULL(Branch,'')
		--Sell_Buy


     /*-------*/
	UNION
     /*-------*/

	SELECT 
		ContractNo, 
		s.Party_code, 
		s.Sett_no, 
		branch_cd,
		cl_type,
		s.sett_type,
		Brokerage = sum(NBrokApp*TradeQty),
		ServTax = sum(NSertax),
		Amount = sum(tradeqty*N_NetRate),
		PurchaseBrokerage =
			SUM(Case When Sell_Buy = 1 
				Then NBrokApp*TradeQty + 
				(Case When Service_Chrg =1 
					Then NSertax 
					Else 0 
					End) 
				Else 0 
				End),
		SellBrokerage = 
			SUM(Case When Sell_Buy = 2 
				Then NBrokApp*TradeQty + 
				(Case When Service_Chrg =1 
					Then NSertax 
					Else 0 
					End) 
				Else 0 
				End), 
		PurchaseAmount = 
			SUM(Case When Sell_Buy = 1 
				Then N_NetRate*TradeQty + 
				(Case When Service_Chrg <> 2 
					Then NSertax 
					Else 0 
					End) + 
				(Case When Insurance_Chrg = 1 
					Then Ins_chrg 
					Else 0 
					End) + 
				(Case When Turnover_tax = 1 
					Then turn_tax 
					Else 0 
					End) +
		                (CASE 
		                        WHEN BROKERNOTE = 1 
		                        THEN BROKER_CHRG 
		                        ELSE 0 
					END) +
				(CASE 
		                        WHEN SEBI_TURN_TAX = 1 
		                        THEN SEBI_TAX 
		                        ELSE 0 
					END) +			
				(CASE 
		                        WHEN C.OTHER_CHRG = 1 
		                        THEN S.OTHER_CHRG 
		                        ELSE 0 
					END ) 
				Else 0 
				End), 
		SellAmount = 
			SUM(Case When Sell_Buy = 2 
				Then N_NetRate*TradeQty - 
				(Case When Service_Chrg <> 2 
					Then NSertax 
					Else 0 
					End) - 
				(Case When Insurance_Chrg = 1 
					Then Ins_chrg 
					Else 0 
					End) - 
				(Case When Turnover_tax = 1 
					Then turn_tax 
					Else 0 
					End) -
		                (CASE 
		                        WHEN BROKERNOTE = 1 
		                        THEN BROKER_CHRG 
		                        ELSE 0 
					END) -
				(CASE 
		                        WHEN SEBI_TURN_TAX = 1 
		                        THEN SEBI_TAX 
		                        ELSE 0 
					END) -			
				(CASE 
		                        WHEN C.OTHER_CHRG = 1 
		                        THEN S.OTHER_CHRG 
		                        ELSE 0 
					END) 
				Else 0 
				End), 
		Partyname = C.Long_name,
		Flag = 2,
                BROKER_CHRG = SUM( 
                CASE 
                        WHEN BROKERNOTE = 1 
                        THEN BROKER_CHRG 
                        ELSE 0 END), 
                TURN_TAX = SUM( 
                CASE 
                        WHEN TURNOVER_TAX = 1 
                        THEN TURN_TAX 
                        ELSE 0 END ), 
                SEBI_TAX = SUM( 
                CASE 
                        WHEN SEBI_TURN_TAX = 1 
                        THEN SEBI_TAX 
                        ELSE 0 END ), 
                OTHER_CHRG = SUM( 
                CASE 
                        WHEN C.OTHER_CHRG = 1 
                        THEN S.OTHER_CHRG 
                        ELSE 0 END ) , 
                INS_CHRG = SUM( 
                CASE 
                        WHEN INSURANCE_CHRG = 1                         THEN INS_CHRG 
                        ELSE 0 END ), 
                SERVICE_TAX = SUM( 
                CASE 
                        WHEN SERVICE_CHRG = 0 
                        THEN NSERTAX 
                        ELSE 0 END ), 
		Tradedate = left(convert(varchar,sauda_date,109),11),
		PayIn = convert(varchar(11),sec_payin,103),
		PayOut = convert(varchar(11),sec_payout,103),
		BranchName = ISNULL(Branch,'')
		--Sell_Buy

	FROM 
		ISETTLEMENT S WITH(NOLOCK),
		SETT_MST M WITH(NOLOCK), 
		#CLIENTMASTER C WITH(NOLOCK)

	WHERE 
		S.Sett_No = M.Sett_No 
		And S.Sett_Type = M.Sett_Type 
		And s.party_code = C.party_code
		And s.tradeqty > 0
		And Sauda_date >= @FROMDATE
		And Sauda_date <= @TODATE + ' 23:59' 
		And AuctionPart Not in ('AP','AR','FA','FC','FS','FL','FP')

	GROUP BY 
		Cl_type,
		branch_cd, 
		s.Party_code, 
		s.Sett_no,
		s.sett_type,
		left(convert(varchar,sauda_date,109),11),
		convert(varchar(11),sec_payin,103),
		convert(varchar(11),sec_payout,103),
		ContractNo,
		C.Long_name,
		ISNULL(Branch,'')
		--Sell_Buy


     /*-------*/
	UNION
     /*-------*/

	SELECT 
		ContractNo, 
		s.Party_code, 
		s.Sett_no, 
		branch_cd,
		cl_type,
		s.sett_type,
		Brokerage = sum(NBrokApp*TradeQty),
		ServTax = sum(NSertax),
		Amount = sum(tradeqty*N_NetRate),
		PurchaseBrokerage =
			SUM(Case When Sell_Buy = 1 
				Then NBrokApp*TradeQty + 
				(Case When Service_Chrg =1 
					Then NSertax 
					Else 0 
					End) 
				Else 0 
				End),
		SellBrokerage = 
			SUM(Case When Sell_Buy = 2 
				Then NBrokApp*TradeQty + 
				(Case When Service_Chrg =1 
					Then NSertax 
					Else 0 
					End) 
				Else 0 
				End), 
		PurchaseAmount = 
			SUM(Case When Sell_Buy = 1 
				Then N_NetRate*TradeQty + 
				(Case When Service_Chrg <> 2 
					Then NSertax 
					Else 0 
					End) + 
				(Case When Insurance_Chrg = 1 
					Then Ins_chrg 
					Else 0 
					End) + 
				(Case When Turnover_tax = 1 
					Then turn_tax 
					Else 0 
					End) +
		                (CASE 
		                        WHEN BROKERNOTE = 1 
		                        THEN BROKER_CHRG 
		                        ELSE 0 
					END) +
				(CASE 
		                        WHEN SEBI_TURN_TAX = 1 
		                        THEN SEBI_TAX 
		                        ELSE 0 
					END) +			
				(CASE 
		                        WHEN C.OTHER_CHRG = 1 
		                        THEN S.OTHER_CHRG 
		                        ELSE 0 
					END ) 
				Else 0 
				End), 
		SellAmount = 
			SUM(Case When Sell_Buy = 2 
				Then N_NetRate*TradeQty - 
				(Case When Service_Chrg <> 2 
					Then NSertax 
					Else 0 
					End) - 
				(Case When Insurance_Chrg = 1 
					Then Ins_chrg 
					Else 0 
					End) - 
				(Case When Turnover_tax = 1 
					Then turn_tax 
					Else 0 
					End) -
		                (CASE 
		                        WHEN BROKERNOTE = 1 
		                        THEN BROKER_CHRG 
		                        ELSE 0 
					END) -
				(CASE 
		                        WHEN SEBI_TURN_TAX = 1 
		                        THEN SEBI_TAX 
		                        ELSE 0 
					END) -			
				(CASE 
		                        WHEN C.OTHER_CHRG = 1 
		                        THEN S.OTHER_CHRG 
		                        ELSE 0 
					END) 
				Else 0 
				End), 
		Partyname = C.Long_name,
		Flag = 2,
                BROKER_CHRG = SUM( 
                CASE 
                        WHEN BROKERNOTE = 1 
                        THEN BROKER_CHRG 
                        ELSE 0 END), 
                TURN_TAX = SUM( 
                CASE 
                        WHEN TURNOVER_TAX = 1 
                        THEN TURN_TAX 
                        ELSE 0 END ), 
                SEBI_TAX = SUM( 
                CASE 
                        WHEN SEBI_TURN_TAX = 1 
                        THEN SEBI_TAX 
                        ELSE 0 END ), 
                OTHER_CHRG = SUM( 
                CASE 
                        WHEN C.OTHER_CHRG = 1 
                        THEN S.OTHER_CHRG 
                        ELSE 0 END ) , 
                INS_CHRG = SUM( 
                CASE 
                        WHEN INSURANCE_CHRG = 1                         THEN INS_CHRG 
                        ELSE 0 END ), 
                SERVICE_TAX = SUM( 
                CASE 
                        WHEN SERVICE_CHRG = 0 
                        THEN NSERTAX 
                        ELSE 0 END ), 
		Tradedate = left(convert(varchar,sauda_date,109),11),
		PayIn = convert(varchar(11),sec_payin,103),
		PayOut = convert(varchar(11),sec_payout,103),
		BranchName = ISNULL(Branch,'')
		--Sell_Buy

	FROM 
		HISTORY S WITH(NOLOCK),
		SETT_MST M WITH(NOLOCK), 
		#CLIENTMASTER C WITH(NOLOCK)

	WHERE 
		S.Sett_No = M.Sett_No 
		And S.Sett_Type = M.Sett_Type 
		And s.party_code = C.party_code
		And s.tradeqty > 0
		And Sauda_date >= @FROMDATE
		And Sauda_date <= @TODATE + ' 23:59' 
		And AuctionPart Not in ('AP','AR','FA','FC','FS','FL','FP')

	GROUP BY 
		Cl_type,
		branch_cd, 
		s.Party_code, 
		s.Sett_no,
		s.sett_type,
		left(convert(varchar,sauda_date,109),11),
		convert(varchar(11),sec_payin,103),
		convert(varchar(11),sec_payout,103),
		ContractNo,
		C.Long_name,
		ISNULL(Branch,'')
		--Sell_Buy


     /*-------*/
	UNION
     /*-------*/

	SELECT 
		ContractNo, 
		s.Party_code, 
		s.Sett_no, 
		branch_cd,
		cl_type,
		s.sett_type,
		Brokerage = sum(NBrokApp*TradeQty),
		ServTax = sum(NSertax),
		Amount = sum(tradeqty*N_NetRate),
		PurchaseBrokerage =
			SUM(Case When Sell_Buy = 1 
				Then NBrokApp*TradeQty + 
				(Case When Service_Chrg =1 
					Then NSertax 
					Else 0 
					End) 
				Else 0 
				End),
		SellBrokerage = 
			SUM(Case When Sell_Buy = 2 
				Then NBrokApp*TradeQty + 
				(Case When Service_Chrg =1 
					Then NSertax 
					Else 0 
					End) 
				Else 0 
				End), 
		PurchaseAmount = 
			SUM(Case When Sell_Buy = 1 
				Then N_NetRate*TradeQty + 
				(Case When Service_Chrg <> 2 
					Then NSertax 
					Else 0 
					End) + 
				(Case When Insurance_Chrg = 1 
					Then Ins_chrg 
					Else 0 
					End) + 
				(Case When Turnover_tax = 1 
					Then turn_tax 
					Else 0 
					End) +
		                (CASE 
		                        WHEN BROKERNOTE = 1 
		                        THEN BROKER_CHRG 
		                        ELSE 0 
					END) +
				(CASE 
		                        WHEN SEBI_TURN_TAX = 1 
		                        THEN SEBI_TAX 
		                        ELSE 0 
					END) +			
				(CASE 
		                        WHEN C.OTHER_CHRG = 1 
		                        THEN S.OTHER_CHRG 
		                        ELSE 0 
					END ) 
				Else 0 
				End), 
		SellAmount = 
			SUM(Case When Sell_Buy = 2 
				Then N_NetRate*TradeQty - 
				(Case When Service_Chrg <> 2 
					Then NSertax 
					Else 0 
					End) - 
				(Case When Insurance_Chrg = 1 
					Then Ins_chrg 
					Else 0 
					End) - 
				(Case When Turnover_tax = 1 
					Then turn_tax 
					Else 0 
					End) -
		                (CASE 
		                        WHEN BROKERNOTE = 1 
		                        THEN BROKER_CHRG 
		                        ELSE 0 
					END) -
				(CASE 
		                        WHEN SEBI_TURN_TAX = 1 
		                        THEN SEBI_TAX 
		                        ELSE 0 
					END) -			
				(CASE 
		                        WHEN C.OTHER_CHRG = 1 
		                        THEN S.OTHER_CHRG 
		                        ELSE 0 
					END) 
				Else 0 
				End), 
		Partyname = C.Long_name,
		Flag = 2,
                BROKER_CHRG = SUM( 
                CASE 
                        WHEN BROKERNOTE = 1 
                        THEN BROKER_CHRG 
                        ELSE 0 END), 
                TURN_TAX = SUM( 
                CASE 
                        WHEN TURNOVER_TAX = 1 
                        THEN TURN_TAX 
                        ELSE 0 END ), 
                SEBI_TAX = SUM( 
                CASE 
                        WHEN SEBI_TURN_TAX = 1 
                        THEN SEBI_TAX 
                        ELSE 0 END ), 
                OTHER_CHRG = SUM( 
                CASE 
                        WHEN C.OTHER_CHRG = 1 
                        THEN S.OTHER_CHRG 
                        ELSE 0 END ) , 
                INS_CHRG = SUM( 
                CASE 
                        WHEN INSURANCE_CHRG = 1                         THEN INS_CHRG 
                        ELSE 0 END ), 
                SERVICE_TAX = SUM( 
                CASE 
                        WHEN SERVICE_CHRG = 0 
                        THEN NSERTAX 
                        ELSE 0 END ), 
		Tradedate = left(convert(varchar,sauda_date,109),11),
		PayIn = convert(varchar(11),sec_payin,103),
		PayOut = convert(varchar(11),sec_payout,103),
		BranchName = ISNULL(Branch,'')
		--Sell_Buy

	FROM 
		IHISTORY S WITH(NOLOCK),
		SETT_MST M WITH(NOLOCK), 
		#CLIENTMASTER C WITH(NOLOCK)

	WHERE 
		S.Sett_No = M.Sett_No 
		And S.Sett_Type = M.Sett_Type 
		And s.party_code = C.party_code
		And s.tradeqty > 0
		And Sauda_date >= @FROMDATE
		And Sauda_date <= @TODATE + ' 23:59' 
		And AuctionPart Not in ('AP','AR','FA','FC','FS','FL','FP')

	GROUP BY 
		Cl_type,
		branch_cd, 
		s.Party_code, 
		s.Sett_no,
		s.sett_type,
		left(convert(varchar,sauda_date,109),11),
		convert(varchar(11),sec_payin,103),
		convert(varchar(11),sec_payout,103),
		ContractNo,
		C.Long_name,
		ISNULL(Branch,'')
		--Sell_Buy


	ORDER BY
		S.SETT_NO,
		BRANCH_CD,
		S.PARTY_CODE,		
		CONTRACTNO

GO
