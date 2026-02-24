-- Object: PROCEDURE dbo.Stp_ContractDetailsISO515
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


/*
{IFN515}{INB011247633}{INCUS003}{
:16R:GENL
:20C::SEME//A010001176.
:23G:NEWM
:98A::PREP//20070627
:22F::TRTR//TRAD
:16R:LINK
:20C::PREV//DUMMY
:16S:LINK
:16S:GENL
:16R:CONFDET
:98A::TRAD//20070627
:98A::SETT//20070629
:90B::DEAL//ACTU/INR758,1400
:92A::CORA//+1,2800
:94B::TRAD//EXCH/100002519
:22H::BUSE//BUYI
:22H::PAYM//FREE
:16R:CONFPRTY
:95Q::INVE//INP000000373
:97A::SAFE//10034224
:16S:CONFPRTY
:36B::CONF//UNIT/228,
:35B:ISIN INE391D01019
:70E::TPRO//DR/0708062
:16S:CONFDET
:16R:SETDET
:22F::SETR//TRAD
:16R:SETPRTY
:95Q::SELL//INB011247633
:16S:SETPRTY
:16R:SETPRTY
:95Q::DEAG//100002303
:16S:SETPRTY
:16R:AMT
:19A::DEAL//INR172855,9200
:16S:AMT
:16R:AMT
:19A::EXEC//INR291,8400
:16S:AMT
:16R:AMT
:19A::TRAX//INR0,0000
:16S:AMT
:16R:AMT
:19A::COUN//INR216,0000
:16S:AMT
:16R:AMT
:19A::SETT//INR173363,7600
:16S:AMT
:16S:SETDET
:16R:OTHRPRTY
:95Q::EXCH//ORDER DETAILS
:70D::PART//0000000000000043
228,
758,1440
20070627 122855
:20C::PROC//0000000018864003
:16S:OTHRPRTY
-}

-------------------------------------------
Select * From Stp_Header_new Where ServiceProvider = 'NSEIT'
Select ExchangeCode, MemberCode, * From Owner
--------------------------------------------
*/

CREATE PROCEDURE Stp_ContractDetailsISO515
(
	@FromDate Varchar(11),  
	@ToDate Varchar(11),  
	@FromContract Varchar(7),  
	@ToContract Varchar(7),  
	@FromParty VarCHAR(10),  
	@ToParty VarCHAR(10),  
	@BatchNo Varchar(7),  
	@MemberCode Varchar(15),  
	@BrokerSebiRegNo Varchar(12),  
	@ExchangeCode Varchar(4),  
	@SettlementDate Varchar(11),  
	@Remark Varchar(210),  
	@GroupCode VarCHAR(10),
	@UserName Varchar(50),
	@BulkOrIncr VarChar(4) = 'BULK'
)
AS  
BEGIN
	SET NOCOUNT ON

	DECLARE  
		@@FromParty VarCHAR(10),  
		@@ToParty VarCHAR(10),  
		@@FromContract Varchar(7),  
		@@ToContract Varchar(7),
		@@ExchIdendifierBSE VarChar(10),
  		@@ExchIdendifierNSE VarChar(10),
		@@NSECHID VarChar(10),
		@@BSECHID VarChar(10)

	DECLARE @T_ContractDetails TABLE (
		PartyCode	VARCHAR(10) DEFAULT(''),
		ClientFmCode VARCHAR(10) DEFAULT(''),
		ClientMapinOrUCC VARCHAR(20) DEFAULT(''),
		Exchange VARCHAR(20) DEFAULT(''),
		ContractNo VARCHAR(20) DEFAULT(''),
		TradeDate VARCHAR(8) DEFAULT(''), 				--- YYYYMMDD
		TradeTime VARCHAR(8) DEFAULT(''), 				--- HHMMSS
		SettlementDate VARCHAR(8) DEFAULT(''),			--- YYYYMMDD
		BrokRatePerShare NUMERIC(28,4) DEFAULT(0),
		MktRate	NUMERIC(28,4) DEFAULT(0),		-- Trade Rate
		NetRate	NUMERIC(28,4) DEFAULT(0),		-- Net Rate
		BuySellFlag VARCHAR(4) DEFAULT(''),	--(BUYI/SELL)
		ScripCode VARCHAR(15) DEFAULT(''),	
		TradeType VARCHAR(6) DEFAULT(''),	--(CH/DVP)
		TradeQty	INT DEFAULT(0),
		Custodiancode VARCHAR(20) DEFAULT(''),
		ScripISIN VARCHAR(20) DEFAULT(''),
		ScripCompanyName VARCHAR(150) DEFAULT(''),
		SegmentType	VARCHAR(20) DEFAULT(''),--	Rolling => DR;  Inter FII => DI; Auction Rolling => AR; Trade to Trade => TT;	Others => OT
		SettlementNo VARCHAR(20) DEFAULT(''),
		SettlementType VARCHAR(5) DEFAULT(''),
		Series VARCHAR(5) DEFAULT(''),
		PartySebiRegNo	VARCHAR(20) DEFAULT(''),-- (MAPIN No.)
		Remark 				VARCHAR(35) DEFAULT(''),---(Free Entry 35Chrs)
		DeliveryType VARCHAR(20) DEFAULT(''),
-- -- 					(for Purchase "REAG" for sale "DEAG")
-- -- 					BOISL for BSE (For Clearing House Trades)
-- -- 					NSCCL for NSE (For Clearing House Trades)
-- -- 					SEBI No. for (For Hand Delivery Trades)
		DealAmount NUMERIC(28,4) DEFAULT(0),
		BrokerageAmount NUMERIC(28,4) DEFAULT(0),
		ServiceTax NUMERIC(28,4) DEFAULT(0),
		STT	NUMERIC(28,4) DEFAULT(0),
		SettlementAmount NUMERIC(28,4) DEFAULT(0),			
		TradeRefNo VARCHAR(20) DEFAULT(''),
		OrderNo	VARCHAR(20) DEFAULT(''),
		OrderDate VARCHAR(8)	DEFAULT(''),	--- YYYMMDD
		OrderTime VARCHAR(6)	DEFAULT('')	--- HHMMSS 
		)

	-- For NSE:100013573 and BSE:100002519
	SET @@ExchIdendifierBSE = '100002519'
	SET @@ExchIdendifierNSE = '100013573'
	SET @@NSECHID = '100013581'
 	SET @@BSECHID = '100002303'

	--- Party Selection	  
	Select @@FromParty =  @FromParty  
	Select @@ToParty = @ToParty  
	If Ltrim(Rtrim(@@FromParty)) = '' And Ltrim(Rtrim(@@ToParty)) = ''  
	Begin  
	 Select @@FromParty = Min(Party_Code), @@ToParty = Max(Party_Code)  From Client2  
	End  
	  
	--- Contract No Selection
	Select @@FromContract =  @FromContract  
	Select @@ToContract = @ToContract  
	If Ltrim(Rtrim(@@FromContract)) = '' And Ltrim(Rtrim(@@ToContract)) = ''  
	Begin  
	 Select @@FromContract = '0000000',  @@ToContract = '9999999'  
	End  

	---- Contract Details Data From ISettlement
	INSERT INTO @T_ContractDetails (
		PartyCode,
		ClientMapinOrUCC,
		Exchange,
		ContractNo,
		TradeDate,
		--TradeTime,
		SettlementDate,
		BrokRatePerShare,
		MktRate,
		NetRate,
		BuySellFlag,
		ScripCode,
		TradeType,
		TradeQty,
		ScripISIN,
		ScripCompanyName,
		SegmentType,
		SettlementNo,
		SettlementType,
		Series,
		PartySebiRegNo,
		DeliveryType,
		DealAmount,
		BrokerageAmount,
		ServiceTax,
		STT,
		SettlementAmount
-- -- 		TradeRefNo,
-- -- 		OrderNo,
-- -- 		OrderDate,
-- -- 		OrderTime
		)

	SELECT
		PartyCode = I.Party_Code,
		ClientMapinOrUCC = '',
		Exchange = CASE @ExchangeCode WHEN 'BSE' THEN '01' WHEN 'NSE' THEN '02' END,				--- NSE=>01; BSE=>02
		ContractNo = I.ContractNo,
		TradeDate = CONVERT(CHAR, I.Sauda_Date, 112),
		--TradeTime = CONVERT(CHAR, I.Sauda_Date, 108),
		SettlementDate  = '',
		BrokRatePerShare = CONVERT  
								(  
								 NUMERIC(18,4),  
								 Case When Sum(I.Tradeqty) > 0 Then  
								 (  
								  CONVERT(NUMERIC(18,4),round((Case When Service_chrg = 1   
								  Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))  
								  Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))  
								  End),4))/Sum(I.Tradeqty)  
								 )  
								 Else  
								 0  
								 End  
								),  
		MktRate = CONVERT(VARCHAR,CONVERT(NUMERIC(18,4),round((Sum(I.MarketRate * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)),4))),   
		NetRate = CONVERT(VARCHAR,CONVERT(NUMERIC(18,4),round((Sum(I.NetRate * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)),4))),   
		BuySellFlag = CASE Sell_Buy WHEN 1 THEN 'BUYI' ELSE 'SELL' END,
		ScripCode = I.Scrip_Cd,
		TradeType = 'CH',
		TradeQty = Sum(I.Tradeqty),
		ScripISIN = '',
		ScripCompanyName = '',
		SegmentType = (Case  --	Rolling => DR;  Inter FII => DI; Auction Rolling => AR; Trade to Trade => TT;	Others => OT
				          When  I.Sett_Type in( 'N', 'D') Then (CASE WHEN I.Scrip_Cd Like '6%' Or I.Series IN ('BL', 'BT', 'IL') THEN 'DI' ELSE 'DR' END)  
				 			 When  I.Sett_Type in( 'W', 'C') Then 'TT'  
				          When  I.Sett_Type in ('A', 'AD') Then 'AR' Else 'OT' End),   
		SettlementNo = I.Sett_No,
		SettlementType = I.Sett_Type,
		Series = I.Series,
		PartySebiRegNo = '',
		DeliveryType = CASE @ExchangeCode WHEN 'NSE' THEN @@NSECHID WHEN 'BSE' THEN @@BSECHID END,
		DealAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))*Sum(I.Tradeqty),4))),   
		BrokerageAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Service_chrg = 1   
	                      Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))  
	         Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))  
	                     End),4))),   
		ServiceTax = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Service_chrg = 0   
	                   Then Sum(I.Service_tax)   
	                    Else 0  
	                   End),4))),   
		STT = CONVERT(VARCHAR,CONVERT(NUMERIC(18,0),round((Case When Insurance_chrg = 1   
	                   Then Round(Sum(I.Ins_Chrg),0)  
	                    Else 0  
	                   End),4))),   
		SettlementAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Sell_Buy = 1   
								   Then (Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)) * Sum(I.Tradeqty)  
								        + (Case When Service_chrg = 1   
								                              Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))  
								         Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))  
								                       End)  
								        + (Case When Service_chrg = 0   
								                                Then Sum(I.Service_tax)   
								                    Else 0  
								                         End) + (Case When Insurance_chrg = 1   
								                                Then Round(Sum(I.Ins_Chrg),0)  
								                    Else 0  
								                         End)   
								   Else (Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)) * Sum(I.Tradeqty)   
								        - (Case When Service_chrg = 1   
								                              Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))  
								         Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))  
								                       End)  
								        - (Case When Service_chrg = 0   
								                                Then Sum(I.Service_tax)   
								                    Else 0  
								                         End) - (Case When Insurance_chrg = 1   
								                                Then Round(Sum(I.Ins_Chrg),0)  
								                    Else 0  
								                         End)   
								  End ),4)))  
		--TradeRefNo = Trade_No,
		--OrderNo = Order_No,
		--OrderDate = CONVERT(CHAR, CONVERT(DATETIME, CPID, 103), 112),
		--OrderTime = REPLACE(CONVERT(CHAR, CONVERT(DATETIME, CPID, 103), 108), ':', '')
		From Isettlement I, Client1 C1, Client2 C2, InstClient_Tbl T 
		Where ContractNo Between @@FromContract and @@ToContract and Sauda_Date Like @FromDate + '%'    
		and I.Party_Code Between @@FromParty and @@ToParty and
		Tradeqty <> 0 and I.Party_Code = T.PartyCode  
		and I.Party_Code =  C2.Party_Code AND C1.Cl_Code = C2.Cl_Code -- And C2.Dummy6 = 'NSEIT' 
		and C1.Cl_Type = 'INS'  
		and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)  
		GROUP BY
		I.Party_Code,
		I.ContractNo,
		CONVERT(CHAR, I.Sauda_Date, 112),
		CASE Sell_Buy WHEN 1 THEN 'BUYI' ELSE 'SELL' END,
		(Case  When  I.Sett_Type in( 'N', 'D') Then (CASE WHEN I.SERIES = 'IL' THEN 'DI' ELSE 'DR' END)  
				 When  I.Sett_Type in( 'W', 'C') Then 'TT'  
		       When  I.Sett_Type in ('A', 'AD') Then 'AR' Else 'OT' End),   
		I.Sett_No,
		I.Sett_Type,
		I.Scrip_Cd,
		I.Series,
-- -- 		Trade_No,
-- -- 		Order_No,
-- -- 		CONVERT(CHAR, CONVERT(DATETIME, CPID, 103), 112),
-- -- 		REPLACE(CONVERT(CHAR, CONVERT(DATETIME, CPID, 103), 108), ':', ''),
		T.Brokerage,
		C2.Service_chrg,
		I.Sell_Buy,
		I.Scrip_Cd,
		C2.Insurance_chrg
		Order By I.Party_code,ContractNo,I.scrip_cd  

	---- Contract Details Data From Settlement
	INSERT INTO @T_ContractDetails (
		PartyCode,
		ClientMapinOrUCC,
		Exchange,
		ContractNo,
		TradeDate,
		--TradeTime,
		SettlementDate,
		BrokRatePerShare,
		MktRate,
		NetRate,
		BuySellFlag,
		ScripCode,
		TradeType,
		TradeQty,
		ScripISIN,
		ScripCompanyName,
		SegmentType,
		SettlementNo,
		SettlementType,
		Series,
		PartySebiRegNo,
		DeliveryType,
		DealAmount,
		BrokerageAmount,
		ServiceTax,
		STT,
		SettlementAmount
-- -- 		TradeRefNo,
-- -- 		OrderNo,
-- -- 		OrderDate,
-- -- 		OrderTime
		)

	SELECT
		PartyCode = I.Party_Code,
		ClientMapinOrUCC = '',
		Exchange = CASE @ExchangeCode WHEN 'BSE' THEN '01' WHEN 'NSE' THEN '02' END,				--- NSE=>01; BSE=>02
		ContractNo = I.ContractNo,
		TradeDate = CONVERT(CHAR, I.Sauda_Date, 112),
		--TradeTime = CONVERT(CHAR, I.Sauda_Date, 108),
		SettlementDate  = '',
		BrokRatePerShare = CONVERT  
								(  
								 NUMERIC(18,4),  
								 Case When Sum(I.Tradeqty) > 0 Then  
								 (  
								  CONVERT(NUMERIC(18,4),round((Case When Service_chrg = 1   
								  Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))  
								  Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))  
								  End),4))/Sum(I.Tradeqty)  
								 )  
								 Else  
								 0  
								 End  
								),  
		MktRate = CONVERT(VARCHAR,CONVERT(NUMERIC(18,4),round((Sum(I.MarketRate * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)),4))),   
		NetRate = CONVERT(VARCHAR,CONVERT(NUMERIC(18,4),round((Sum(I.NetRate * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)),4))),   
		BuySellFlag = CASE Sell_Buy WHEN 1 THEN 'BUYI' ELSE 'SELL' END,
		ScripCode = I.Scrip_Cd,
		TradeType = 'NORMAL',
		TradeQty = Sum(I.Tradeqty),
		ScripISIN = '',
		ScripCompanyName = '',
		SegmentType = (Case  --	Rolling => DR;  Inter FII => DI; Auction Rolling => AR; Trade to Trade => TT;	Others => OT
				          When  I.Sett_Type in( 'N', 'D') Then (CASE WHEN I.Scrip_Cd Like '6%' Or I.Series IN ('BL', 'BT', 'IL') THEN 'DI' ELSE 'DR' END)  
				 			 When  I.Sett_Type in( 'W', 'C') Then 'TT'  
				          When  I.Sett_Type in ('A', 'AD') Then 'AR' Else 'OT' End),   
		SettlementNo = I.Sett_No,
		SettlementType = I.Sett_Type,
		Series = I.Series,
		PartySebiRegNo = '',
		DeliveryType = @BrokerSebiRegNo, --CASE @ExchangeCode WHEN 'NSE' THEN 'NSCCL' WHEN 'BSE' THEN 'BOISL' END,
		DealAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))*Sum(I.Tradeqty),4))),   
		BrokerageAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Service_chrg = 1   
	                      Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))  
	         Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))  
	                     End),4))),   
		ServiceTax = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Service_chrg = 0   
	                   Then Sum(I.Service_tax)   
	                    Else 0  
	                   End),4))),   
		STT = CONVERT(VARCHAR,CONVERT(NUMERIC(18,0),round((Case When Insurance_chrg = 1   
	                   Then Round(Sum(I.Ins_Chrg),0)  
	                    Else 0  
	                   End),4))),   
		SettlementAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Sell_Buy = 1   
								   Then (Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)) * Sum(I.Tradeqty)  
								        + (Case When Service_chrg = 1   
								                              Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))  
								         Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))  
								                       End)  
								        + (Case When Service_chrg = 0   
								                                Then Sum(I.Service_tax)   
								                    Else 0  
								                         End) + (Case When Insurance_chrg = 1   
								                                Then Round(Sum(I.Ins_Chrg),0)  
								                    Else 0  
								                         End)   
								   Else (Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End)) * Sum(I.Tradeqty)   
								        - (Case When Service_chrg = 1   
								                              Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))  
								         Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))  
								                       End)  
								        - (Case When Service_chrg = 0   
								                                Then Sum(I.Service_tax)   
								                    Else 0  
								                         End) - (Case When Insurance_chrg = 1   
								                                Then Round(Sum(I.Ins_Chrg),0)  
								                    Else 0  
								                         End)   
								  End ),4)))  
		--TradeRefNo = Trade_No,
		--OrderNo = Order_No,
		--OrderDate = CONVERT(CHAR, CONVERT(DATETIME, CPID, 103), 112),
		--OrderTime = REPLACE(CONVERT(CHAR, CONVERT(DATETIME, CPID, 103), 108), ':', '')
		From settlement I, Client1 C1, Client2 C2, InstClient_Tbl T 
		Where ContractNo Between @@FromContract and @@ToContract and Sauda_Date Like @FromDate + '%'    
		and I.Party_Code Between @@FromParty and @@ToParty and
		Tradeqty <> 0 and I.Party_Code = T.PartyCode  
		and I.Party_Code =  C2.Party_Code AND C1.Cl_Code = C2.Cl_Code -- And C2.Dummy6 = 'NSEIT' 
		and C1.Cl_Type = 'INS'  
		and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)  
		GROUP BY
		I.Party_Code,
		I.ContractNo,
		CONVERT(CHAR, I.Sauda_Date, 112),
		CASE Sell_Buy WHEN 1 THEN 'BUYI' ELSE 'SELL' END,
		(Case  When  I.Sett_Type in( 'N', 'D') Then (CASE WHEN I.SERIES = 'IL' THEN 'DI' ELSE 'DR' END)  
				 When  I.Sett_Type in( 'W', 'C') Then 'TT'  
		       When  I.Sett_Type in ('A', 'AD') Then 'AR' Else 'OT' End),   
		I.Sett_No,
		I.Sett_Type,
		I.Scrip_Cd,
		I.Series,
-- -- 		Trade_No,
-- -- 		Order_No,
-- -- 		CONVERT(CHAR, CONVERT(DATETIME, CPID, 103), 112),
-- -- 		REPLACE(CONVERT(CHAR, CONVERT(DATETIME, CPID, 103), 108), ':', ''),
		T.Brokerage,
		C2.Service_chrg,
		I.Sell_Buy,
		I.Scrip_Cd,
		C2.Insurance_chrg
		Order By I.Party_code,ContractNo,I.scrip_cd  
	
	IF @BulkOrIncr = 'INCR'			---- If the export option is for incremental contracts, then remove the already exported contracts
		DELETE @T_ContractDetails FROM @T_ContractDetails A, Stp_Header_new B WHERE A.ContractNo = B.ContractNo AND B.Serviceprovider = 'ISO515'

	UPDATE @T_ContractDetails SET 
			ClientMapinOrUCC = CASE WHEN ISNULL(Mapin_ID, '') <> '' THEN ISNULL(MAPIN_ID, '') ELSE ISNULL(UCC_Code, '') END,
			PartySebiRegNo = REPLACE(sebi_regn_no,'/', ''),
			ClientFmCode = FmCode
			FROM @T_ContractDetails A, MSAJAG.DBO.CLIENT_DETAILS B WHERE A.PartyCode = B.Party_Code
		
	UPDATE @T_ContractDetails SET 
			SettlementDate = CASE WHEN @SettlementDate = '' THEN	RTRIM(CONVERT(CHAR, B.Sec_Payout, 112)) ELSE RTRIM(CONVERT(CHAR, CONVERT(DATETIME, @SettlementDate, 103), 112)) END
			FROM @T_ContractDetails A, Sett_Mst B WHERE A.SettlementNo = B.Sett_No AND A.SettlementType = B.Sett_Type

	UPDATE @T_ContractDetails SET 
			ScripISIN = B.ISIN
			FROM @T_ContractDetails A, Multiisin B WHERE A.ScripCode = B.Scrip_Cd AND B.Valid = 1

	UPDATE @T_ContractDetails SET 
			ScripCompanyName = S1.Long_Name
			FROM @T_ContractDetails A, Scrip1 S1, Scrip2 S2 
			WHERE A.ScripCode = S2.Scrip_Cd AND S1.Co_Code = S2.Co_Code AND A.Series = S2.Series

	INSERT INTO Stp_Header_new( 
		Serviceprovider,
		Batchno,
		Recordtype,
		Sebiregno,
		Status,
		Creationdate,
		Creationtime,
		Lastdatetime,
		Partycode,
		Contractno,
		Username,
		Gen_Method)
	SELECT		
		Serviceprovider ='ISO515',
		Batchno = @BatchNo,
		Recordtype = '515',
		Sebiregno = @BrokerSebiRegNo,
		Status = 'A',
		Creationdate = RTrim(CONVERT(CHAR, GetDate(), 112)),
		Creationtime = Replace(RTrim(CONVERT(CHAR, GetDate(), 108)), ':', ''),
		Lastdatetime = @ExchangeCode,
		Partycode = PartyCode,
		Contractno = ContractNo,
		Username = Left('(' + @FromDate + ')' + @UserName,25),
		Gen_Method = 1
	FROM @T_ContractDetails

	SET NOCOUNT OFF

	-- SELECT * FROM @T_ContractDetails  

	------ ISO-515 File Generation 
	IF @ExchangeCode = 'NSE'			--- 4 Decimals	
		SELECT 
			ContractNo,
			Message1 = '{IFN515}' + '{' + RTRim(@BrokerSebiRegNo) + '}{' + RTRim(ClientFmCode) + '}' + '[~]' + --{INB011247633}{INCUS003}				PartySebiRegNo
			'{' + '[~]' +
			':16R:' + 'GENL' + '[~]' + -- GENL 
			':20C:' + ':SEME//A'+ RTrim(Exchange) + RTRim(ContractNo) + '[~]' + --:SEME//A010001176.
			':23G:' + 'NEWM' + '[~]'  + --NEWM
			':98A:' + ':PREP//' + RTrim(CONVERT(CHAR, GetDate(), 112)) + '[~]' + --:PREP//20070627
			':22F:' + ':TRTR//TRAD' + '[~]'  + --:TRTR//TRAD
			':16R:' + 'LINK' + '[~]' + --LINK
			':20C:' + ':PREV//DUMMY' + '[~]' + --PREV//DUMMY
			':16S:' + 'LINK' + '[~]' + --LINK
			':16S:' + 'GENL' + '[~]' + --GENL
			':16R:' + 'CONFDET' + '[~]' + --CONFDET
			':98A:' + ':TRAD//' + RTrim(TradeDate) + '[~]' + --:TRAD//20070627
			':98A:' + ':SETT//' + RTrim(SettlementDate) + '[~]' + --:SETT//20070629
			':90B:' + ':DEAL//ACTU/INR' + RTRim(REPLACE(CONVERT(Char, MktRate),'.', ',')) + '[~]' + --:DEAL//ACTU/INR758,1400
			':92A:' + ':CORA//+' + RTRim(REPLACE(CONVERT(Char, BrokRatePerShare),'.', ',')) + '[~]' + --:CORA//+1,2800 
			':94B:' + ':TRAD//EXCH/' + CASE @ExchangeCode WHEN 'BSE' THEN @@ExchIdendifierBSE WHEN 'NSE' THEN @@ExchIdendifierNSE END + '[~]' + --:TRAD//EXCH/100002519 (For NSE:100013573 and BSE:100002519)
			':22H:' + ':BUSE//' + RTrim(BuySellFlag) + '[~]' + --:BUSE//BUYI
			':22H:' + ':PAYM//' + CASE TradeType WHEN 'CH' THEN 'FREE' ELSE 'APMT' END + '[~]' + --:PAYM//FREE
			':16R:' + 'CONFPRTY' + '[~]' + --CONFPRTY
			':95Q:' + ':INVE//' + RTrim(PartySebiRegNo) + '[~]' + --:INVE//INP000000373
			':97A:' + ':SAFE//' + RTrim(ClientMapinOrUCC) + '[~]' + --:SAFE//10034224
			':16S:' + 'CONFPRTY' + '[~]' + --CONFPRTY
			':36B:' + ':CONF//UNIT/' + RTRim(REPLACE(CONVERT(Char, TradeQty),'.', ',')) + ',' + '[~]' + --:CONF//UNIT/228,
			':35B:' + 'ISIN ' + RTrim(ScripISIN) + '[~]' + --ISIN INE391D01019
			':70E:' + ':TPRO//' + RTrim(SegmentType) + '/' + RTrim(SettlementNo) + '[~]' + --:TPRO//DR/0708062
			---':98C:' + ':PROC//' + RTRim(OrderDate) + '/' + RTrim(OrderTime) + '[~]' +  --- (Sample file not having)
			':16S:' + 'CONFDET' + '[~]' + --CONFDET
			':16R:' + 'SETDET' + '[~]' + --SETDET
			':22F:' + ':SETR//TRAD' + '[~]' + --:SETR//TRAD
			':16R:' + 'SETPRTY' + '[~]' + --SETPRTY
			':95Q:' + ':' + CASE BuySellFlag WHEN 'BUYI' THEN 'SELL' ELSE 'BUYR' END + '//' + RTRim(@BrokerSebiRegNo) + '[~]' + --:SELL//INB011247633
			--':70C:' + ':PACO//' + RTrim(@MemberCode) + '[~]' +  --- (Sample file not having) 
			CASE WHEN @Remark <> '' THEN ':70D:' + ':PART//' + RTrim(@Remark) + '[~]' ELSE '' END +  --- (Sample file not having)
			':16S:' + 'SETPRTY' + '[~]' + --SETPRTY
			':16R:' + 'SETPRTY' + '[~]' + --SETPRTY
			':95Q:' + ':' + CASE BuySellFlag WHEN 'BUYI' THEN 'DEAG' ELSE 'REAG' END + '//' + RTrim(DeliveryType) + '[~]' + --:DEAG//100002303
			':16S:' + 'SETPRTY' + '[~]' + --SETPRTY
			':16R:' + 'AMT' + '[~]' + --AMT
			':19A:' + ':DEAL//INR' + RTRim(REPLACE(CONVERT(Char, DealAmount),'.', ',')) + '[~]' + --:DEAL//INR172855,9200
			':16S:' + 'AMT' + '[~]' + --AMT
			':16R:' + 'AMT' + '[~]' + --AMT
			':19A:' + ':EXEC//INR' + RTRim(REPLACE(CONVERT(Char, BrokerageAmount),'.', ',')) + '[~]' + --:EXEC//INR291,8400
			':16S:' + 'AMT' + '[~]' + --AMT
			':16R:' + 'AMT' + '[~]' + --AMT
			':19A:' + ':TRAX//INR' + RTRim(REPLACE(CONVERT(Char, ServiceTax),'.', ',')) + '[~]' + --:TRAX//INR0,0000
			':16S:' + 'AMT' + '[~]' + --AMT
			':16R:' + 'AMT' + '[~]' + --AMT
			':19A:' + ':COUN//INR' + RTRim(REPLACE(CONVERT(Char, STT),'.', ',')) + '[~]' + --:COUN//INR216,0000
			':16S:' + 'AMT' + '[~]' + --AMT
			':16R:' + 'AMT' + '[~]' + --AMT
			':19A:' + ':SETT//INR' + RTRim(REPLACE(CONVERT(Char, SettlementAmount),'.', ',')) + '[~]' + --:SETT//INR173363,7600
			':16S:' + 'AMT' + '[~]' + --AMT
			':16S:' + 'SETDET' + '[~]' + --SETDET
			':16R:' + 'OTHRPRTY' + '[~]' + --OTHRPRTY
			':95Q:' + ':EXCH//ORDER DETAILS' + '[~]',  --:EXCH//ORDER DETAILS
	-- -- 		':70D:' + ':PART//' + Right(Replicate('0',15) + LTrim(RTRim(TradeRefNo)),16) + '[~]' + --:PART//0000000000000043
	-- -- 		RTRim(REPLACE(CONVERT(Char, TradeQty),'.', ','))  + '[~]' + -- 228,
	-- -- 		--RTRim(REPLACE(CONVERT(Char, NetRate),'.', ',')) + '[~]' + --758,1440
	-- -- 		RTRim(REPLACE(CONVERT(Char, MktRate),'.', ',')) + '[~]' + --758,1440
	-- -- 		RTRim(OrderDate) + ' ' + RTrim(OrderTime) + '[~]' + --20070627 122855
	-- -- 		':20C:' + ':PROC//' + Left(Replicate('0',15)+LTrim(RTrim(OrderNo)), 16) + '[~]' + --:PROC//0000000018864003
			Message2 = ':16S:OTHRPRTY' + '[~]', --
			Message3 = '-}'
		FROM  @T_ContractDetails 
	ELSE					--- BSE   2 DECIMALS		
		SELECT 
			ContractNo,
			Message1 = '{IFN515}' + '{' + RTRim(@BrokerSebiRegNo) + '}{' + RTRim(ClientFmCode) + '}' + '[~]' + --{INB011247633}{INCUS003}				PartySebiRegNo
			'{' + '[~]' +
			':16R:' + 'GENL' + '[~]' + -- GENL 
			':20C:' + ':SEME//A'+ RTrim(Exchange) + RTRim(ContractNo) + '[~]' + --:SEME//A010001176.
			':23G:' + 'NEWM' + '[~]'  + --NEWM
			':98A:' + ':PREP//' + RTrim(CONVERT(CHAR, GetDate(), 112)) + '[~]' + --:PREP//20070627
			':22F:' + ':TRTR//TRAD' + '[~]'  + --:TRTR//TRAD
			':16R:' + 'LINK' + '[~]' + --LINK
			':20C:' + ':PREV//DUMMY' + '[~]' + --PREV//DUMMY
			':16S:' + 'LINK' + '[~]' + --LINK
			':16S:' + 'GENL' + '[~]' + --GENL
			':16R:' + 'CONFDET' + '[~]' + --CONFDET
			':98A:' + ':TRAD//' + RTrim(TradeDate) + '[~]' + --:TRAD//20070627
			':98A:' + ':SETT//' + RTrim(SettlementDate) + '[~]' + --:SETT//20070629
			':90B:' + ':DEAL//ACTU/INR' + RTRim(REPLACE(CONVERT(Char, CONVERT(NUMERIC(24,2),MktRate)),'.', ',')) + '[~]' + --:DEAL//ACTU/INR758,1400
			':92A:' + ':CORA//+' + RTRim(REPLACE(CONVERT(Char, CONVERT(NUMERIC(24,2),BrokRatePerShare)),'.', ',')) + '[~]' + --:CORA//+1,2800 
			':94B:' + ':TRAD//EXCH/' + CASE @ExchangeCode WHEN 'BSE' THEN @@ExchIdendifierBSE WHEN 'NSE' THEN @@ExchIdendifierNSE END + '[~]' + --:TRAD//EXCH/100002519 (For NSE:100013573 and BSE:100002519)
			':22H:' + ':BUSE//' + RTrim(BuySellFlag) + '[~]' + --:BUSE//BUYI
			':22H:' + ':PAYM//' + CASE TradeType WHEN 'CH' THEN 'FREE' ELSE 'APMT' END + '[~]' + --:PAYM//FREE
			':16R:' + 'CONFPRTY' + '[~]' + --CONFPRTY
			':95Q:' + ':INVE//' + RTrim(PartySebiRegNo) + '[~]' + --:INVE//INP000000373
			':97A:' + ':SAFE//' + RTrim(ClientMapinOrUCC) + '[~]' + --:SAFE//10034224
			':16S:' + 'CONFPRTY' + '[~]' + --CONFPRTY
			':36B:' + ':CONF//UNIT/' + RTRim(REPLACE(CONVERT(Char, TradeQty),'.', ',')) + ',' + '[~]' + --:CONF//UNIT/228,
			':35B:' + 'ISIN ' + RTrim(ScripISIN) + '[~]' + --ISIN INE391D01019
			':70E:' + ':TPRO//' + RTrim(SegmentType) + '/' + RTrim(SettlementNo) + '[~]' + --:TPRO//DR/0708062
			---':98C:' + ':PROC//' + RTRim(OrderDate) + '/' + RTrim(OrderTime) + '[~]' +  --- (Sample file not having)
			':16S:' + 'CONFDET' + '[~]' + --CONFDET
			':16R:' + 'SETDET' + '[~]' + --SETDET
			':22F:' + ':SETR//TRAD' + '[~]' + --:SETR//TRAD
			':16R:' + 'SETPRTY' + '[~]' + --SETPRTY
			':95Q:' + ':' + CASE BuySellFlag WHEN 'BUYI' THEN 'SELL' ELSE 'BUYR' END + '//' + RTRim(@BrokerSebiRegNo) + '[~]' + --:SELL//INB011247633
			--':70C:' + ':PACO//' + RTrim(@MemberCode) + '[~]' +  --- (Sample file not having) 
			CASE WHEN @Remark <> '' THEN ':70D:' + ':PART//' + RTrim(@Remark) + '[~]' ELSE '' END +  --- (Sample file not having)
			':16S:' + 'SETPRTY' + '[~]' + --SETPRTY
			':16R:' + 'SETPRTY' + '[~]' + --SETPRTY
			':95Q:' + ':' + CASE BuySellFlag WHEN 'BUYI' THEN 'DEAG' ELSE 'REAG' END + '//' + RTrim(DeliveryType) + '[~]' + --:DEAG//100002303
			':16S:' + 'SETPRTY' + '[~]' + --SETPRTY
			':16R:' + 'AMT' + '[~]' + --AMT
			':19A:' + ':DEAL//INR' + RTRim(REPLACE(CONVERT(Char, CONVERT(NUMERIC(24,2),DealAmount)),'.', ',')) + '[~]' + --:DEAL//INR172855,9200
			':16S:' + 'AMT' + '[~]' + --AMT
			':16R:' + 'AMT' + '[~]' + --AMT
			':19A:' + ':EXEC//INR' + RTRim(REPLACE(CONVERT(Char, CONVERT(NUMERIC(24,2),BrokerageAmount)),'.', ',')) + '[~]' + --:EXEC//INR291,8400
			':16S:' + 'AMT' + '[~]' + --AMT
			':16R:' + 'AMT' + '[~]' + --AMT
			':19A:' + ':TRAX//INR' + RTRim(REPLACE(CONVERT(Char, CONVERT(NUMERIC(24,2),ServiceTax)),'.', ',')) + '[~]' + --:TRAX//INR0,0000
			':16S:' + 'AMT' + '[~]' + --AMT
			':16R:' + 'AMT' + '[~]' + --AMT
			':19A:' + ':COUN//INR' + RTRim(REPLACE(CONVERT(Char, CONVERT(NUMERIC(24,2),STT)),'.', ',')) + '[~]' + --:COUN//INR216,0000
			':16S:' + 'AMT' + '[~]' + --AMT
			':16R:' + 'AMT' + '[~]' + --AMT
			':19A:' + ':SETT//INR' + RTRim(REPLACE(CONVERT(Char, CONVERT(NUMERIC(24,2),SettlementAmount)),'.', ',')) + '[~]' + --:SETT//INR173363,7600
			':16S:' + 'AMT' + '[~]' + --AMT
			':16S:' + 'SETDET' + '[~]' + --SETDET
			':16R:' + 'OTHRPRTY' + '[~]' + --OTHRPRTY
			':95Q:' + ':EXCH//ORDER DETAILS' + '[~]',  --:EXCH//ORDER DETAILS
	-- -- 		':70D:' + ':PART//' + Right(Replicate('0',15) + LTrim(RTRim(TradeRefNo)),16) + '[~]' + --:PART//0000000000000043
	-- -- 		RTRim(REPLACE(CONVERT(Char, TradeQty),'.', ','))  + '[~]' + -- 228,
	-- -- 		--RTRim(REPLACE(CONVERT(Char, NetRate),'.', ',')) + '[~]' + --758,1440
	-- -- 		RTRim(REPLACE(CONVERT(Char, MktRate),'.', ',')) + '[~]' + --758,1440
	-- -- 		RTRim(OrderDate) + ' ' + RTrim(OrderTime) + '[~]' + --20070627 122855
	-- -- 		':20C:' + ':PROC//' + Left(Replicate('0',15)+LTrim(RTrim(OrderNo)), 16) + '[~]' + --:PROC//0000000018864003
			Message2 = ':16S:OTHRPRTY' + '[~]', --
			Message3 = '-}'
		FROM  @T_ContractDetails 

END

/*

SELECT * FROM ISETTLEMENT WHERE CONTRACTNO = '0000375'

EXEC Stp_ContractDetailsISO515 'MAY 28 2007', 'MAY 28 2007', '0000103', '0000103', '', '', '001',
												'07088', 'INB231074130', 'NSE', '', 'Remark', '', 'ASHOKS', 'BULK'

EXEC Stp_ContractDetailsISO515 'FEB 15 2006', 'FEB 15 2006', '0000375', '0000375', '', '', '001',
												'292', 'INB230781137', 'BSE', '', 'Remark', '', 'ASHOKS', 'BULK'

EXEC Stp_TradeDetailsISO515  'BSE', '0000375'

EXEC Stp_TradeDetailsISO515  'NSE', '0000103'

select * from owner

update Stp_Header_new SET UserName = '(MAY 28 2007)' + UserName WHERE ContractNo = '0000103'

*/

GO
