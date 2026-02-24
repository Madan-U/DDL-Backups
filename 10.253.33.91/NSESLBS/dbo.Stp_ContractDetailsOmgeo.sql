-- Object: PROCEDURE dbo.Stp_ContractDetailsOmgeo
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


/*

imp_blim
keys,MSINDIA,DAMLSG,,1225,,1
block_detail,INFO-LTD,"3I INFOTECH LIMITED",SEDOL,26-Apr-06,00:00,B,5000.00,456,28-Apr-06,INR,CH,2280000.00,A,9100.00,1.82,0.40,N,Y,A,1
fi_detail , , , , , , , , , , , , , , , , , , N, , , , N, N
brk_comment,"Exchange:- BSE, Settlement Period:- 26 Apr 2006 TO 26 Apr 2006, Segment:- Demat, Settlement Type:- Through Clearing House"
brk_delivery,INDIA-DIR-B,IND,EQU,UNIVERSAL,
prorate,0.00,0.00,2280.00,0.00,9100.00,0.00,N

*/

CREATE PROCEDURE Stp_ContractDetailsOmgeo
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
  		@@ExchIdendifierNSE VarChar(10)

	DECLARE @T_ContractDetails TABLE(
		PartyCode	VARCHAR(10) DEFAULT(''),
		Exchange VARCHAR(20) DEFAULT(''),
		ContractNo VARCHAR(20) DEFAULT(''),
		TradeDate DATETIME,
		SettlementDate DATETIME,
		BrokRatePerShare	NUMERIC(28,4) DEFAULT(0),
		BrokPercentagePerShare	NUMERIC(28,4) DEFAULT(0),
		MktRate	NUMERIC(28,4) DEFAULT(0),
		NetRate	NUMERIC(28,4) DEFAULT(0),
		BuySellFlag CHAR(1) DEFAULT(''),
		ScripCode VARCHAR(15) DEFAULT(''),	
		DeliveryType VARCHAR(15) DEFAULT(''),	
		TradeQty INT DEFAULT(0),
		ScripCusipNo VARCHAR(20) DEFAULT(''),
		ScripName VARCHAR(100) DEFAULT(''),
		ScripMarketLot INT DEFAULT(0),
		SettlementNo VARCHAR(20) DEFAULT(''),
		SettlementType VARCHAR(20) DEFAULT(''),
		Series VARCHAR(5) DEFAULT(''),
		DealAmount	NUMERIC(28,4) DEFAULT(0),
		BrokerageAmount	NUMERIC(28,4) DEFAULT(0),
		STT	NUMERIC(28,4) DEFAULT(0),
		ScripAggregated CHAR(1) DEFAULT('N')
		)

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

	---- Contract Details Data From ISettlement (CH Trades)
	INSERT INTO @T_ContractDetails (
		PartyCode,
		Exchange,
		ContractNo,
		TradeDate,
		BrokRatePerShare,
		MktRate,
		NetRate,
		BuySellFlag,
		ScripCode,
		DeliveryType,
		TradeQty,
		ScripCusipNo,
		ScripName,
		ScripMarketLot,
		SettlementNo,
		SettlementType,
		Series,
		DealAmount,
		BrokerageAmount,
		STT,
		ScripAggregated
		)

	SELECT
		PartyCode = I.Party_Code,
		Exchange = @ExchangeCode,				--- NSE=>01; BSE=>02
		ContractNo = I.ContractNo,
		TradeDate = Convert(CHAR(11), I.Sauda_Date, 109),	--I.Sauda_Date,
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
		BuySellFlag = CASE Sell_Buy WHEN 1 THEN 'B' ELSE 'S' END,
		ScripCode = I.Scrip_Cd,
		DeliveryType = 'CH',
		TradeQty = Sum(I.Tradeqty),
		ScripCusipNo = '',
		ScripName = '',
		ScripMarketLot = 0,
		SettlementNo = I.Sett_No,
		SettlementType = I.Sett_Type,
		Series = I.Series,
		DealAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))*Sum(I.Tradeqty),4))),   
		BrokerageAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Service_chrg = 1   
	                      Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))  
	         Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))  
	                     End),4))),   
		STT = CONVERT(VARCHAR,CONVERT(NUMERIC(18,0),round((Case When Insurance_chrg = 1   
	                   Then Round(Sum(I.Ins_Chrg),0)  
	                    Else 0  
	                   End),4))),
		ScripAggregated  = CASE WHEN I.Dummy2 = 1 THEN 'Y' ELSE 'N' END

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
		Convert(CHAR(11), I.Sauda_Date, 109), --I.Sauda_Date,
		CASE Sell_Buy WHEN 1 THEN 'B' ELSE 'S' END,
		I.Sett_No,
		I.Sett_Type,
		I.Scrip_Cd,
		I.Series,
		T.Brokerage,
		C2.Service_chrg,
		I.Sell_Buy,
		I.Scrip_Cd,
		C2.Insurance_chrg,
		CASE WHEN I.Dummy2 = 1 THEN 'Y' ELSE 'N' END
		Order By I.Party_code,ContractNo,I.scrip_cd  

	---- Contract Details Data From Settlement (DVP Trades)
	INSERT INTO @T_ContractDetails (
		PartyCode,
		Exchange,
		ContractNo,
		TradeDate,
		BrokRatePerShare,
		MktRate,
		NetRate,
		BuySellFlag,
		ScripCode,
		DeliveryType,
		TradeQty,
		ScripCusipNo,
		ScripName,
		ScripMarketLot,
		SettlementNo,
		SettlementType,
		Series,
		DealAmount,
		BrokerageAmount,
		STT,
		ScripAggregated
		)

	SELECT
		PartyCode = I.Party_Code,
		Exchange = @ExchangeCode,				--- NSE=>01; BSE=>02
		ContractNo = I.ContractNo,
		TradeDate = Convert(CHAR(11), I.Sauda_Date, 109),	--I.Sauda_Date,
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
		BuySellFlag = CASE Sell_Buy WHEN 1 THEN 'B' ELSE 'S' END,
		ScripCode = I.Scrip_Cd,
		DeliveryType = 'DVP',
		TradeQty = Sum(I.Tradeqty),
		ScripCusipNo = '',
		ScripName = '',
		ScripMarketLot = 0,
		SettlementNo = I.Sett_No,
		SettlementType = I.Sett_Type,
		Series = I.Series,
		DealAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Sum(Round(I.MarketRate,Convert(integer,T.marketrate)) * I.Tradeqty)/(Case When Sum(I.Tradeqty)>0 Then Sum(I.Tradeqty) Else 1 End))*Sum(I.Tradeqty),4))),   
		BrokerageAmount = CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),round((Case When Service_chrg = 1   
	                      Then Round(Sum(I.Brokapplied* I.Tradeqty)+Sum(I.Service_tax),Convert(integer,T.brokerage))  
	         Else Round(Sum(I.Brokapplied* I.Tradeqty),Convert(integer,T.brokerage))  
	                     End),4))),   
		STT = CONVERT(VARCHAR,CONVERT(NUMERIC(18,0),round((Case When Insurance_chrg = 1   
	                   Then Round(Sum(I.Ins_Chrg),0)  
	                    Else 0  
	                   End),4))),
		ScripAggregated  = CASE WHEN I.Dummy2 = 1 THEN 'Y' ELSE 'N' END

		From Settlement I, Client1 C1, Client2 C2, InstClient_Tbl T 
		Where ContractNo Between @@FromContract and @@ToContract and Sauda_Date Like @FromDate + '%'    
		and I.Party_Code Between @@FromParty and @@ToParty and
		Tradeqty <> 0 and I.Party_Code = T.PartyCode  
		and I.Party_Code =  C2.Party_Code AND C1.Cl_Code = C2.Cl_Code -- And C2.Dummy6 = 'NSEIT' 
		and C1.Cl_Type = 'INS'  
		and C1.Family like (Case When @GroupCode = '' Then '%' Else @GroupCode End)  
		GROUP BY
		I.Party_Code,
		I.ContractNo,
		Convert(CHAR(11), I.Sauda_Date, 109), --I.Sauda_Date,
		CASE Sell_Buy WHEN 1 THEN 'B' ELSE 'S' END,
		I.Sett_No,
		I.Sett_Type,
		I.Scrip_Cd,
		I.Series,
		T.Brokerage,
		C2.Service_chrg,
		I.Sell_Buy,
		I.Scrip_Cd,
		C2.Insurance_chrg,
		CASE WHEN I.Dummy2 = 1 THEN 'Y' ELSE 'N' END
		Order By I.Party_code,ContractNo,I.scrip_cd  
	
	IF @BulkOrIncr = 'INCR'			---- If the export option is for incremental contracts, then remove the already exported contracts
		DELETE @T_ContractDetails FROM @T_ContractDetails A, Stp_Header_new B WHERE A.ContractNo = B.ContractNo AND B.Serviceprovider = 'OMGEO'

	---- UPDATE Minimum Trade Time From Settlement Table
	UPDATE @T_ContractDetails SET TradeDate = B.TradeDateTime FROM @T_ContractDetails A, (
		SELECT PartyCode =I.Party_Code, ContractNo = I.ContractNo, TradeDateTime = Min(I.Sauda_Date) 
		FROM Isettlement I, 	@T_ContractDetails A WHERE A.ContractNo = I.ContractNo AND A.PartyCode = I.Party_Code
		GROUP BY I.ContractNo, I.Party_Code) B
	WHERE A.ContractNo =  B.ContractNo AND A.PartyCode = B.PartyCode
 
-- -- 	UPDATE @T_ContractDetails SET 
-- -- 			ClientMapinOrUCC = CASE WHEN ISNULL(Mapin_ID, '') <> '' THEN ISNULL(MAPIN_ID, '') ELSE ISNULL(UCC_Code, '') END,
-- -- 			PartySebiRegNo = sebi_regn_no
-- -- 			FROM @T_ContractDetails A, CLIENT_DETAILS B WHERE A.PartyCode = B.Party_Code

	UPDATE @T_ContractDetails SET 
			SettlementDate = RTRIM(CONVERT(CHAR, B.Sec_Payout, 112)) 
			FROM @T_ContractDetails A, Sett_Mst B WHERE A.SettlementNo = B.Sett_No AND A.SettlementType = B.Sett_Type

	UPDATE @T_ContractDetails SET 
			ScripName = S1.Long_Name,
			ScripMarketLot = S1.Market_Lot,
			ScripCusipNo = S2.RicCode
			FROM @T_ContractDetails A, Scrip1 S1, Scrip2 S2 
			WHERE A.ScripCode = S2.Scrip_Cd AND S1.Co_Code = S2.Co_Code AND A.Series = S2.Series

-- -- 	INSERT INTO Stp_Header_new( 
-- -- 		Serviceprovider,
-- -- 		Batchno,
-- -- 		Recordtype,
-- -- 		Sebiregno,
-- -- 		Status,
-- -- 		Creationdate,
-- -- 		Creationtime,
-- -- 		Lastdatetime,
-- -- 		Partycode,
-- -- 		Contractno,
-- -- 		Username,
-- -- 		Gen_Method)
-- -- 	SELECT		
-- -- 		Serviceprovider ='OMGEO',
-- -- 		Batchno = @BatchNo,
-- -- 		Recordtype = 0,
-- -- 		Sebiregno = @BrokerSebiRegNo,
-- -- 		Status = 'A',
-- -- 		Creationdate = RTrim(CONVERT(CHAR, GetDate(), 112)),
-- -- 		Creationtime = Replace(RTrim(CONVERT(CHAR, GetDate(), 108)), ':', ''),
-- -- 		Lastdatetime = @ExchangeCode,
-- -- 		Partycode = PartyCode,
-- -- 		Contractno = ContractNo,
-- -- 		Username = @UserName,
-- -- 		Gen_Method = 1
-- -- 	FROM @T_ContractDetails

	--SELECT * FROM @T_ContractDetails  

	UPDATE @T_ContractDetails SET BrokPercentagePerShare = CONVERT(NUMERIC(24,2), (BrokRatePerShare/100.00) )

	SET NOCOUNT OFF
	SELECT 
	'imp_blim'  + '[~]' + 
	'keys,MSINDIA,DAMLSG,,1225,,1'  + '[~]' + 
	'block_detail,' + RTrim(ScripCode) + ',"' + RTRIM(ScripName) + '",' + RTrim(ScripCusipNo) + ',' + LTRIM(RTRIM(REPLACE(CONVERT(VARCHAR,TradeDate,6),' ','-'))) + ',' +
		LTRIM(RTRIM(CONVERT(VARCHAR(5),TradeDate,108))) + ','+ RTRIM(BuySellFlag) +',' + LTRIM(RTRIM(CONVERT(CHAR,TradeQty))) +',' +
		LTRIM(RTRIM(CONVERT(CHAR,MktRate))) + ',' + LTRIM(RTRIM(REPLACE(CONVERT(VARCHAR,SettlementDate,6),' ','-'))) + ',INR,' + RTrim(DeliveryType) + 
		',' + LTRIM(RTRIM(CONVERT(CHAR,DealAmount))) + ',' + 'A,' + LTRIM(RTRIM(CONVERT(CHAR,BrokerageAmount))) + 
		',' + LTRIM(RTRIM(CONVERT(CHAR, BrokRatePerShare))) + ',' + LTRIM(RTRIM(CONVERT(CHAR, BrokPercentagePerShare))) + ',N,Y,' + 
		RTRIM(ScripAggregated) + ', '+ LTRIM(RTRIM(CONVERT(CHAR,ScripMarketLot)))  + '[~]' + 
	'fi_detail , , , , , , , , , , , , , , , , , , N, , , , N, N'  + '[~]' + 
	'brk_comment,"Exchange:- '+RTrim(Exchange)+ ', Settlement Period:- ' + LTRIM(RTRIM(CONVERT(VARCHAR(11),TradeDate,13))) +
		' TO ' + LTRIM(RTRIM(CONVERT(VARCHAR(11),TradeDate,13))) + ', Segment:- Demat, Settlement Type:- ' + 
		CASE DeliveryType WHEN 'CH' THEN 'Through Clearing House' ELSE 'DVP' END + '"' + '[~]' + 
	'brk_delivery,INDIA-DIR-B,IND,EQU,UNIVERSAL,'  + '[~]' + 
	'prorate,0.00,0.00,' + LTRIM(RTRIM(CONVERT(CHAR, STT))) + ',0.00,'+ LTRIM(RTRIM(CONVERT(CHAR, BrokerageAmount))) + 
	',0.00,N' + '[~]'  
	FROM @T_ContractDetails  

END

/*

select * from isettlement

EXEC Stp_ContractDetailsOmgeo 'MAY 25 2007', 'MAY 25 2007', '0000333', '0000333', '', '', '001',
												'07088', 'INB231074130', 'NSE', '', 'Remark', '', 'ASHOKS', 'BULK'

Select convert(char(11), getdate(), 109)


*/

GO
