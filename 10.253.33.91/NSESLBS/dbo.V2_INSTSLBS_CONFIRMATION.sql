-- Object: PROCEDURE dbo.V2_INSTSLBS_CONFIRMATION
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE PROC [dbo].[V2_INSTSLBS_CONFIRMATION] (
	@STATUSID VARCHAR(15),
	@STATUSNAME VARCHAR(25),
	@SAUDA_DATE VARCHAR(11),
	@SETT_NO VARCHAR(7),
	@SETT_TYPE VARCHAR(2),
	@FROMPARTY_CODE VARCHAR(10),
	@TOPARTY_CODE VARCHAR(10),
	@FROMBRANCH VARCHAR(10),
	@TOBRANCH VARCHAR(10),
	@FROMSUB_BROKER VARCHAR(10),
	@TOSUB_BROKER VARCHAR(10),
	@FROMCONTRACTNO VARCHAR(12),
	@TOCONTRACTNO VARCHAR(12),
	@CONTFLAG VARCHAR(10),
	@TRADEONFLAG INT = 0
	)
AS
/*    
 EXEC V2_INSTSLBS_CONFIRMATION 'broker','broker','Jul  3 2017','2017063','S','0','ZZ','','zzzzzzzzzzzz','','zzzzzzzzzzzz','','','CONTRACT'     
  EXEC V2_INSTSLBS_CONFIRMATION 'broker','broker','Jul  3 2017','2017063','S','0','ZZ','','zzzzzzzzzzzz','','zzzzzzzzzzzz','','',''     
    
*/
DECLARE @ColName VARCHAR(6),
	@SDT DATETIME,
	@STAMPDUTY NUMERIC(8, 6)

SELECT @SDT = Convert(DATETIME, @SAUDA_DATE)

SELECT @STAMPDUTY = Broker_Note
FROM TAXES
WHERE Trans_Cat = 'DEL'

IF @FromContractno = ''
BEGIN
	SET @FromContractno = 000000000
END

IF @ToContractno = ''
BEGIN
	SET @ToContractno = 999999999
END

SELECT @ColName = ''

IF @CONTFLAG = 'CONTRACT'
	SELECT @ColName = Rpt_Code
	FROM V2_SLBSMEMO_PRINTING
	WHERE Rpt_Type = 'ORDER'
		AND Rpt_PrintFlag = 1
ELSE
	SELECT @ColName = Rpt_Code
	FROM V2_SLBSMEMO_PRINTING
	WHERE Rpt_Type = 'ORDER'
		AND Rpt_PrintFlag_Digi = 1

--SET NOCOUNT ON                                             
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Contractno,
	Billno,
	Trade_No,
	Party_Code,
	Scrip_Cd,
	Tradeqty,
	Series,
	Order_No,
	Marketrate = Convert(NUMERIC(18, 9), Marketrate),
	Sauda_Date,
	Sell_Buy,
	Settflag,
	Brokapplied,
	SCHEME,
	Netrate,
	Amount,
	Ins_Chrg,
	Turn_Tax,
	Other_Chrg,
	Sebi_Tax,
	Broker_Chrg,
	Service_Tax,
	Billflag,
	Sett_No,
	Nbrokapp,
	Nsertax,
	N_Netrate,
	Sett_Type,
	Tmark,
	cpid
INTO #SETT
FROM ISETTLEMENT
WHERE 1 = 2

INSERT INTO #SETT
SELECT Contractno,
	Billno = 0,
	Trade_No = max(Pradnya.DBO.ReplaceTradeNo(Trade_No)),
	Party_Code,
	Scrip_Cd,
	Tradeqty = Sum(TradeQty),
	Series,
	Order_No = MAX(order_no),
	Marketrate = Sum(Marketrate * tradeqty) / Sum(tradeqty),
	Sauda_Date = MAX(Sauda_date),
	Sell_Buy,
	Settflag,
	Brokapplied = sum(tradeqty * brokapplied),
	SCHEME = (
		CASE 
			WHEN SETT_TYPE = 'S'
				AND SELL_BUY = 2
				THEN 0
			WHEN SETT_TYPE = 'B'
				AND SELL_BUY = 1
				THEN 0
			ELSE SCHEME
			END
		),
	Netrate = sum(tradeqty * netrate) / SUM(TRADEQTY),
	Amount = Sum(Amount),
	Ins_Chrg = Sum(Ins_Chrg),
	Turn_Tax = Sum(Turn_Tax),
	Other_Chrg = Sum(Other_Chrg),
	Sebi_Tax = Sum(Sebi_Tax),
	Broker_Chrg = Sum(Broker_Chrg),
	Service_Tax = Sum(Service_Tax),
	Billflag,
	Sett_No,
	Nbrokapp = sum(tradeqty * nbrokapp),
	Nsertax = Sum(Nsertax),
	N_Netrate = sum(tradeqty * n_netrate) / SUM(TRADEQTY),
	Sett_Type,
	Tmark,
	cpid = MIN(cpid)
FROM ISETTLEMENT
WHERE SETT_TYPE = @SETT_TYPE
	AND SAUDA_DATE LIKE @SAUDA_DATE + '%'
	AND AUCTIONPART NOT IN (
		'AP',
		'AR'
		)
	AND MarketRate > 0
	AND tradeqty > 0
	AND PARTY_CODE >= @FROMPARTY_CODE
	AND PARTY_CODE <= @TOPARTY_CODE
	AND Contractno BETWEEN @FromContractno
		AND @ToContractno
GROUP BY Contractno,
	--Pradnya.DBO.ReplaceTradeNo(Trade_No),                                                
	Party_Code,
	Scrip_Cd,
	Series,
	--Order_No,                                          
	Marketrate,
	--Sauda_Date,                                          
	Sell_Buy,
	Settflag,
	Billflag,
	Sett_No,
	Sett_Type,
	Tmark,
	--CPID,                                      
	SCHEME

SELECT DISTINCT BSECODE,
	Scrip_Cd = SCRIP_CODE,
	S2.Series,
	Short_Name = SHORT_NAME + '-' + M.FILLER1 + '-' + REPLACE(CONVERT(VARCHAR, CONVERT(DATETIME, EXPIRY_DATE), 106), ' ', '') + '-' + M.ISIN,
	SCRIP_CODE = CONVERT(VARCHAR, M.PRODUCT_ID),
	EXPIRY_DATE
INTO #Scrip
FROM BSEDB.DBO.Scrip1 S1,
	BSEDB.DBO.Scrip2 S2,
	#Sett S,
	SLB_CONTRACT_MASTER M
WHERE S1.CO_CODE = S2.CO_CODE
	AND S2.SERIES = S1.SERIES
	AND S2.BSECODE = CONVERT(VARCHAR, M.PRODUCT_ID)
	AND S.SCRIP_CD = CONVERT(VARCHAR, M.SCRIP_CODE)

DECLARE @predate VARCHAR(11)

SELECT @predate = left(max(SYSDATE), 11)
FROM BSEDB.DBO.CLOSING C(NOLOCK)
WHERE SYSDATE < @SAUDA_DATE

SELECT C.SCRIP_CD,
	CL_RATE,
	SLBSCRIP = S.Scrip_Cd
INTO #CLOSING
FROM BSEDB.DBO.CLOSING C(NOLOCK),
	#SCRIP S
WHERE SYSDATE BETWEEN @predate
		AND @predate + ' 23:59'
	AND S.SCRIP_CODE = C.SCRIP_cD

CREATE CLUSTERED INDEX [scr] ON [dbo].[#Scrip] (
	[SCRIP_CD],
	[SERIES]
	)

/*=========================================================================                                                                              
                /*FOR THE #SETT*/                                             
                =========================================================================*/
SELECT C2.PARTY_CODE,
	C1.LONG_NAME,
	C1.L_ADDRESS1,
	C1.L_ADDRESS2,
	C1.L_ADDRESS3,
	C1.L_CITY,
	C1.L_STATE,
	C1.L_ZIP,
	C1.BRANCH_CD,
	C1.SUB_BROKER,
	C1.TRADER,
	C1.PAN_GIR_NO,
	C1.OFF_PHONE1,
	C1.OFF_PHONE2,
	PRINTF,
	MAPIDID = Convert(VARCHAR(20), ''),
	UCC_CODE = Convert(VARCHAR(20), ''),
	C2.SERVICE_CHRG,
	BROKERNOTE,
	TURNOVER_TAX,
	SEBI_TURN_TAX,
	C2.OTHER_CHRG,
	INSURANCE_CHRG,
	SEBI_NO = FD_Code,
	Participant_Code = BankId,
	Cl_Type
INTO #CLIENTMASTER
FROM CLIENT1 C1 WITH (NOLOCK),
	CLIENT2 C2 WITH (NOLOCK)
WHERE C2.CL_CODE = C1.CL_CODE
	AND C2.PARTY_CODE BETWEEN @FROMPARTY_CODE
		AND @TOPARTY_CODE
	AND @STATUSNAME = (
		CASE 
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
			ELSE 'BROKER'
			END
		)
	AND BRANCH_CD >= @FROMBRANCH
	AND BRANCH_CD <= @TOBRANCH
	AND SUB_BROKER >= @FROMSUB_BROKER
	AND SUB_BROKER <= @TOSUB_BROKER
	AND C2.PARTY_CODE IN (
		SELECT DISTINCT PARTY_CODE
		FROM #SETT
		)

CREATE CLUSTERED INDEX [PARTY] ON [dbo].[#CLIENTMASTER] ([PARTY_CODE])

UPDATE #CLIENTMASTER
SET MAPIDID = UC.MAPIDID,
	UCC_CODE = UC.UCC_CODE
FROM UCC_CLIENT UC
WHERE #CLIENTMASTER.PARTY_CODE = UC.PARTY_CODE

IF (@TRADEONFLAG = 1)
BEGIN
	DELETE
	FROM #CLIENTMASTER
	WHERE NOT EXISTS (
			SELECT PARTY_CODE
			FROM MSAJAG.DBO.CLIENT_MASTER_CKYC CM(NOLOCK)
			WHERE CM.PARTY_CODE = #CLIENTMASTER.PARTY_CODE
				AND CM.CLIENT_TRADE_TYPE = 'T'
			)
END
ELSE
BEGIN
	DELETE
	FROM #CLIENTMASTER
	WHERE EXISTS (
			SELECT PARTY_CODE
			FROM MSAJAG.DBO.CLIENT_MASTER_CKYC CM(NOLOCK)
			WHERE CM.PARTY_CODE = #CLIENTMASTER.PARTY_CODE
				AND CM.CLIENT_TRADE_TYPE = 'T'
			)
END

SELECT CONTRACTNO,
	S.PARTY_CODE,
	ORDER_NO,
	ORDER_TIME = (
		CASE 
			WHEN CPID = 'NIL'
				THEN '        '
			ELSE Right(CpId, 8)
			END
		),
	TM = CONVERT(VARCHAR, SAUDA_DATE, 108),
	TRADE_NO,
	SAUDA_DATE,
	S.SCRIP_CD,
	S.SERIES,
	SCRIPNAME = (
		CASE 
			WHEN LEFT(CONVERT(VARCHAR, SAUDA_DATE, 109), 11) <> @SAUDA_DATE
				THEN 'BF-'
			ELSE ''
			END
		) + S2.SHORT_NAME + '   ',
	SDT = CONVERT(VARCHAR, @SDT, 103),
	SELL_BUY,
	BROKER_CHRG = (
		CASE 
			WHEN BROKERNOTE = 1
				THEN BROKER_CHRG
			ELSE 0
			END
		),
	TURN_TAX = (
		CASE 
			WHEN TURNOVER_TAX = 1
				THEN TURN_TAX
			ELSE 0
			END
		),
	SEBI_TAX = (
		CASE 
			WHEN SEBI_TURN_TAX = 1
				THEN SEBI_TAX
			ELSE 0
			END
		),
	OTHER_CHRG = (
		CASE 
			WHEN C1.OTHER_CHRG = 1
				THEN S.OTHER_CHRG
			ELSE 0
			END
		),
	INS_CHRG = (
		CASE 
			WHEN INSURANCE_CHRG = 1
				THEN INS_CHRG
			ELSE 0
			END
		),
	SERVICE_TAX = (
		CASE 
			WHEN SERVICE_CHRG = 0
				THEN NSERTAX
			ELSE 0
			END
		),
	NSERTAX = (
		CASE 
			WHEN SERVICE_CHRG = 0
				THEN NSERTAX
			ELSE 0
			END
		),
	SAUDA_DATE1 = LEFT(CONVERT(VARCHAR, SAUDA_DATE, 109), 11),
	PQTY = (
		CASE 
			WHEN SELL_BUY = 1
				THEN TRADEQTY
			ELSE 0
			END
		),
	SQTY = (
		CASE 
			WHEN SELL_BUY = 2
				THEN TRADEQTY
			ELSE 0
			END
		),
	PRATE = (
		CASE 
			WHEN SELL_BUY = 1
				THEN MARKETRATE
			ELSE 0
			END
		),
	SRATE = (
		CASE 
			WHEN SELL_BUY = 2
				THEN MARKETRATE
			ELSE 0
			END
		),
	PBROK = (
		CASE 
			WHEN SELL_BUY = 1
				THEN NBROKAPP + (
						CASE 
							WHEN SERVICE_CHRG = 1
								THEN NSERTAX
							ELSE 0
							END
						)
			ELSE 0
			END
		),
	SBROK = (
		CASE 
			WHEN SELL_BUY = 2
				THEN NBROKAPP + (
						CASE 
							WHEN SERVICE_CHRG = 1
								THEN NSERTAX
							ELSE 0
							END
						)
			ELSE 0
			END
		),
	PSCHEME = (
		CASE 
			WHEN SELL_BUY = 1
				THEN S.SCHEME
			ELSE 0
			END
		),
	SSCHEME = (
		CASE 
			WHEN SELL_BUY = 2
				THEN S.SCHEME
			ELSE 0
			END
		),
	PSCHEMENETRATE = (
		CASE 
			WHEN SELL_BUY = 1
				THEN (S.SCHEME + S.MARKETRATE)
			ELSE 0
			END
		),
	SSCHEMENETRATE = (
		CASE 
			WHEN SELL_BUY = 2
				THEN (S.SCHEME + S.MARKETRATE)
			ELSE 0
			END
		),
	PNETRATE = (
		CASE 
			WHEN SELL_BUY = 1
				THEN N_NETRATE + (
						CASE 
							WHEN SERVICE_CHRG = 1
								THEN NSERTAX / TRADEQTY
							ELSE 0
							END
						)
			ELSE 0
			END
		),
	SNETRATE = (
		CASE 
			WHEN SELL_BUY = 2
				THEN N_NETRATE - (
						CASE 
							WHEN SERVICE_CHRG = 1
								THEN NSERTAX / TRADEQTY
							ELSE 0
							END
						)
			ELSE 0
			END
		),
	PAMT = (
		CASE 
			WHEN SELL_BUY = 1
				THEN TRADEQTY * (
						N_NETRATE + (
							CASE 
								WHEN SERVICE_CHRG = 1
									THEN NSERTAX / TRADEQTY
								ELSE 0
								END
							)
						)
			ELSE 0
			END
		),
	SAMT = (
		CASE 
			WHEN SELL_BUY = 2
				THEN TRADEQTY * (
						N_NETRATE - (
							CASE 
								WHEN SERVICE_CHRG = 1
									THEN NSERTAX / TRADEQTY
								ELSE 0
								END
							)
						)
			ELSE 0
			END
		),
	BROKERAGE = NBROKAPP + (
		CASE 
			WHEN SERVICE_CHRG = 1
				THEN NSERTAX
			ELSE 0
			END
		),
	PTOTCHARGE = (
		CASE 
			WHEN SELL_BUY = 1
				THEN NBROKAPP
			ELSE 0
			END
		),
	STOTCHARGE = (
		CASE 
			WHEN SELL_BUY = 2
				THEN NBROKAPP
			ELSE 0
			END
		),
	S.SETT_NO,
	S.SETT_TYPE,
	TRADETYPE = '  ',
	TMARK = CASE 
		WHEN BILLFLAG = 1
			OR BILLFLAG = 4
			OR BILLFLAG = 5
			THEN 'D'
		ELSE ''
		END,
	/*TO DISPLAY THE HEADER PART*/
	PARTYNAME = C1.LONG_NAME,
	C1.L_ADDRESS1,
	C1.L_ADDRESS2,
	C1.L_ADDRESS3,
	C1.L_CITY,
	C1.L_STATE,
	C1.L_ZIP,
	C1.SERVICE_CHRG,
	C1.BRANCH_CD,
	C1.SUB_BROKER,
	C1.TRADER,
	C1.PAN_GIR_NO,
	C1.OFF_PHONE1,
	C1.OFF_PHONE2,
	PRINTF,
	MAPIDID,
	UCC_CODE,
	ORDERFLAG = 0,
	SCRIPNAMEForOrderBy = S2.SHORT_NAME,
	SCRIPNAME1 = Convert(VARCHAR, (
			CASE 
				WHEN Cl_Type = 'NRI'
					THEN LTRIM(RTRIM(S2.SHORT_NAME)) + '_' + LTRIM(RTRIM(Sell_Buy))
				ELSE ''
				END
			), 52),
	SEBI_NO,
	Participant_Code,
	ActSell_buy = Sell_buy
INTO #CONTSETT
FROM #SETT S WITH (NOLOCK),
	#CLIENTMASTER C1 WITH (NOLOCK),
	SETT_MST M WITH (NOLOCK),
	#SCRIP S2
WHERE S.SETT_NO = @SETT_NO
	AND S.SETT_TYPE = @SETT_TYPE
	AND S.PARTY_CODE BETWEEN @FROMPARTY_CODE
		AND @TOPARTY_CODE
	AND S.SETT_NO = M.SETT_NO
	AND S.SETT_TYPE = M.SETT_TYPE
	AND M.END_DATE LIKE @SAUDA_DATE + '%'
	AND S2.SCRIP_CD = S.SCRIP_CD
	AND S.PARTY_CODE = C1.PARTY_CODE
	AND S.TRADEQTY > 0

UPDATE #CONTSETT
SET TRADETYPE = 'RO'
WHERE ORDER_NO IN (
		SELECT ORDER_NO
		FROM TRD_SETT_POS_ROLL
		WHERE SAUDA_DATE LIKE @SAUDA_DATE + '%'
		)

UPDATE #CONTSETT
SET TRADETYPE = 'RC'
WHERE ORDER_NO IN (
		SELECT ORDER_NO
		FROM TRD_SETT_POS
		WHERE SAUDA_DATE LIKE @SAUDA_DATE + '%'
			AND SELL_BUY > 2
		)
	AND TRADETYPE <> 'RO'

/*                                                          
UPDATE                                                     
 #CONTSETT                                             
SET                                                    
 Brokerage = (Case When Sell_Buy =1                                                 
     Then (Case When TMARK = '' Then CD_TrdBuyBrokerage Else CD_DelBuyBrokerage End)                                                
     Else (Case When TMARK = '' Then CD_TrdSellBrokerage Else CD_DelSellBrokerage End)                                                
       End)                                                
           + (Case When Service_Chrg = 1                                                 
     Then Case When Sell_Buy =1                                 
        Then (Case When TMARK = '' Then CD_TrdBuySerTax Else CD_DelBuySerTax End)                                                
        Else (Case When TMARK = '' Then CD_TrdSellSerTax Else CD_DelSellSerTax End)                                                
   End                                                    
            Else 0                                                 
       End),                                      
PTOTCHARGE=(Case When Sell_Buy =1                                                 
     Then (Case When TMARK = '' Then CD_TrdBuyBrokerage Else CD_DelBuyBrokerage End)                                                
     Else 0                                                
       End),                                      
STOTCHARGE=(Case When Sell_Buy =1                                                 
     Then 0                                                
     Else (Case When TMARK = '' Then CD_TrdSellBrokerage Else CD_DelSellBrokerage End)                                                
       End),                                                     
 Service_Tax = Service_Tax + (Case When Service_Chrg = 0                                                 
     Then Case When Sell_Buy =1                                                 
        Then (Case When TMARK = '' Then CD_TrdBuySerTax Else CD_DelBuySerTax End)                                        
     Else (Case When TMARK = '' Then CD_TrdSellSerTax Else CD_DelSellSerTax End)                                                
   End                                                    
            Else 0                                                 
       End),                                 
 NSerTax = NSerTax + (Case When Service_Chrg = 0                                                 
     Then Case When Sell_Buy =1                                                 
        Then (Case When TMARK = '' Then CD_TrdBuySerTax Else CD_DelBuySerTax End)                                                
        Else (Case When TMARK = '' Then CD_TrdSellSerTax Else CD_DelSellSerTax End)                                                
   End                                                    
            Else 0                                                 
       End),                                                
                                     
PAmt     = (Case When Sell_Buy =1                                 
     Then PAmt + (Case When TMARK = '' Then CD_TrdBuyBrokerage Else CD_DelBuyBrokerage End)                                                
     Else 0                                                
       End)                                                
           + (Case When Service_Chrg = 1                                                 
     Then Case When Sell_Buy =1                                                 
        Then (Case When TMARK = '' Then CD_TrdBuySerTax Else CD_DelBuySerTax End)                                                
        Else 0                                                
   End                                                    
            Else 0                                                 
       End),                                                
SAmt     = (Case When Sell_Buy = 2                                                
     Then SAmt - (Case When TMARK = '' Then CD_TrdSellBrokerage Else CD_DelSellBrokerage End)                                                
     Else 0                                                
       End)                                                
           + (Case When Service_Chrg = 1                                                 
     Then Case When Sell_Buy = 2                                                
        Then (Case When TMARK = '' Then CD_TrdSellSerTax Else CD_DelSellSerTax End)                                                
        Else 0                                                
   End                                                    
            Else 0                                                 
       End)                                                     
FROM                                                    
 CHARGES_DETAIL                                                    
WHERE                                              
 CD_Sett_No = #CONTSETT.Sett_No                                                  
 And CD_Sett_Type = #CONTSETT.Sett_Type                                                  
 And CD_Party_Code = #CONTSETT.Party_Code                                                     
 And CD_Scrip_Cd = #CONTSETT.Scrip_Cd                                                  
 And CD_Series = #CONTSETT.Series                                                  
 And CD_Trade_No = Trade_No                                                    
 And CD_Order_No = Order_No                                            
                                            
 INSERT                                               
INTO    #CONTSETT                                            
 SELECT  CONTRACTNO='0',                                                     
 S.CD_PARTY_CODE,                                                     
     CD_ORDER_NO,                                                     
                ORDER_TIME='',                                                     
                TM='',                                                     
                TRADE_NO='',                                                     
                CD_SAUDA_DATE,                                                     
                S.CD_SCRIP_CD,                                               
                S.CD_SERIES,                                                     
                SCRIPNAME = (                                                     
                CASE                                                  
                        WHEN LEFT(CONVERT(VARCHAR,CD_SAUDA_DATE,109),11) <> @SAUDA_DATE                                                     
                        THEN 'BF-'                                                     
                        ELSE '' END ) + ISNULL(S2.SHORT_NAME,'BROKERAGE') + '   ' ,                            
                SDT = CONVERT(VARCHAR,@SDT,103),                                                     
                SELL_BUY=1,                                                   
                BROKER_CHRG =0,                                                     
                TURN_TAX =0,                                                     
                SEBI_TAX =0,                                                     
                OTHER_CHRG =0,                                                     
                INS_CHRG =0,                     
                SERVICE_TAX = (                                                     
                CASE                                                     
                        WHEN SERVICE_CHRG = 0                                                     
  THEN CD_TrdBuySerTax+CD_DelBuySerTax+CD_TrdSellSerTax+CD_DelSellSerTax                                                  
ELSE 0 END ),                                                     
                NSERTAX = (                                                     
                CASE                                                     
                        WHEN SERVICE_CHRG = 0                                                     
                        THEN CD_TrdBuySerTax+CD_DelBuySerTax+CD_TrdSellSerTax+CD_DelSellSerTax                                          
                        ELSE 0 END ),                                                     
                SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,CD_SAUDA_DATE,109),11),                                                     
                PQTY = 0,                                                     
                SQTY = 0,                                                     
                PRATE = 0,                                                     
                SRATE = 0,                                                     
           PBROK = 0,                                                     
                SBROK = 0,                                       
                PSCHEME = 0,        
                SSCHEME = 0,                                      
PSCHEMENETRATE =0,                                             
                                            
  SSCHEMENETRATE =0,                                                                             
                PNETRATE =0,                                                     
                SNETRATE =0,                                                     
                PAMT =CD_TrdBuyBrokerage+CD_DelBuyBrokerage+CD_TrdSellBrokerage+CD_DelSellBrokerage+(                                                     
                CASE                                                  
                        WHEN SERVICE_CHRG = 1                                                      
                        THEN CD_TrdBuySerTax+CD_DelBuySerTax+CD_TrdSellSerTax+CD_DelSellSerTax                                                  
                        ELSE 0 END ),                                   
                SAMT =0,                                                     
                BROKERAGE = CD_TrdBuyBrokerage+CD_DelBuyBrokerage+CD_TrdSellBrokerage+CD_DelSellBrokerage+(                                                     
                CASE                                                     
                        WHEN SERVICE_CHRG = 1                                                      
 THEN CD_TrdBuySerTax+CD_DelBuySerTax+CD_TrdSellSerTax+CD_DelSellSerTax                                                  
                        ELSE 0 END ),                                                     
                0,                                                     
                0,                                                     
                TRADETYPE = '  ',                                                     
                TMARK     = ' ',                                                     
                --TO DISPLAY THE HEADER PART                                            
                PARTYNAME = C1.LONG_NAME,                                       
                C1.L_ADDRESS1,                                                     
                C1.L_ADDRESS2,                                                     
                C1.L_ADDRESS3,                                                     
                C1.L_CITY,                                                    
  C1.L_STATE,                                                     
                C1.L_ZIP,                                                     
                C1.SERVICE_CHRG,                                                     
                C1.BRANCH_CD ,                                            
           C1.SUB_BROKER,                                                     
          C1.TRADER,   
                C1.PAN_GIR_NO,                                                     
                C1.OFF_PHONE1,                                                     
                C1.OFF_PHONE2,                                                     
                PRINTF,                                                     
                MAPIDID,                                                     
  UCC_CODE,                         
                ORDERFLAG  = 4,                                                     
  SCRIPNAMEForOrderBy=ISNULL(S2.SHORT_NAME,'ZZZBROKERAGE'),                                                  
                SCRIPNAME1 = Convert(Varchar,(Case When Cl_Type = 'NRI'                                                     
       Then LTRIM(RTRIM(ISNULL(S2.SHORT_NAME,'BROKERAGE'))) + '_' + LTRIM(RTRIM(1))                                                     
              Else ''                                                     
         End), 52),                                                           
   SEBI_NO,                                                    
   Participant_Code,                                                    
   ActSell_buy = 1,      
                PSCHEME = 0,                                             
                SSCHEME = 0                                     
                                            
                        
        FROM    CHARGES_DETAIL S LEFT OUTER JOIN #SCRIP S2                                                    
 ON (    S2.SCRIP_CD  = S.CD_SCRIP_CD                                                     
             AND S2.SERIES    = S.CD_SERIES   ),                                                     
                #CLIENTMASTER C1                                                     
        WITH                                                       
                (                                                                 NOLOCK                                                       
                )                                                       
                ,                                                     
                SETT_MST M                                                     
        WITH                                                       
                (                                                       
   NOLOCK                                                       
                )                                                       
                                                                   
        WHERE   S.CD_SETT_NO       = @SETT_NO                                                     
                AND S.CD_SETT_TYPE = @SETT_TYPE        
                AND S.CD_PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE                                                     
                AND S.CD_SETT_NO   = M.SETT_NO                                                     
   AND S.CD_SETT_TYPE = M.SETT_TYPE                                                     
                AND M.END_DATE LIKE @SAUDA_DATE + '%'                                                     
                AND S.CD_PARTY_CODE = C1.PARTY_CODE                                                     
  AND CD_TrdBuyBrokerage+CD_DelBuyBrokerage+CD_TrdSellBrokerage+CD_DelSellBrokerage > 0                                                  
  AND CD_Trade_No = ''                                             
*/
/*=========================================================================                                                                      
                /* ND RECORD BROUGHT FORWARD FOR SAME DAY OR PREVIOUS DAYS */                                             
                =========================================================================*/
CREATE INDEX [DELPOS] ON [dbo].[#CONTSETT] (
	[SAUDA_DATE],
	[Sett_Type],
	[PARTY_CODE],
	[Scrip_Cd],
	[Series]
	)

SELECT CONTRACTNO,
	PARTY_CODE,
	ORDER_NO = '0000000000000000',
	ORDER_TIME = '        ',
	TM = '        ',
	TRADE_NO = '0000000000000000',
	SAUDA_DATE = LEFT(CONVERT(VARCHAR, SAUDA_DATE, 109), 11),
	SCRIP_CD,
	SERIES,
	SCRIPNAME = CONVERT(VARCHAR(100), SCRIPNAME),
	SDT,
	SELL_BUY,
	BROKER_CHRG = SUM(BROKER_CHRG),
	TURN_TAX = SUM(TURN_TAX),
	SEBI_TAX = SUM(SEBI_TAX),
	OTHER_CHRG = SUM(OTHER_CHRG),
	INS_CHRG = SUM(INS_CHRG),
	SERVICE_TAX = SUM(SERVICE_TAX),
	NSERTAX = SUM(NSERTAX),
	SAUDA_DATE1,
	PQTY = SUM(PQTY),
	SQTY = SUM(SQTY),
	PRATE = (
		CASE 
			WHEN SUM(PQTY) > 0
				THEN SUM(PRATE * PQTY) / SUM(PQTY)
			ELSE 0
			END
		),
	SRATE = (
		CASE 
			WHEN SUM(SQTY) > 0
				THEN SUM(SRATE * SQTY) / SUM(SQTY)
			ELSE 0
			END
		),
	PBROK = (
		CASE 
			WHEN SUM(PQTY) > 0
				THEN SUM(PBROK) * SUM(PQTY) / SUM(PQTY)
			ELSE 0
			END
		),
	SBROK = (
		CASE 
			WHEN SUM(SQTY) > 0
				THEN SUM(SBROK) * SUM(SQTY) / SUM(SQTY)
			ELSE 0
			END
		),
	PSCHEME = (
		CASE 
			WHEN SUM(PQTY) > 0
				THEN SUM(PSCHEME * PQTY) / SUM(PQTY)
			ELSE 0
			END
		),
	SSCHEME = (
		CASE 
			WHEN SUM(SQTY) > 0
				THEN SUM(SSCHEME * SQTY) / SUM(SQTY)
			ELSE 0
			END
		),
	PSCHEMENETRATE = (
		CASE 
			WHEN SUM(PQTY) > 0
				THEN SUM(PSCHEMENETRATE * PQTY) / SUM(PQTY)
			ELSE 0
			END
		),
	SSCHEMENETRATE = (
		CASE 
			WHEN SUM(SQTY) > 0
				THEN SUM(SSCHEMENETRATE * SQTY) / SUM(SQTY)
			ELSE 0
			END
		),
	PNETRATE = (
		CASE 
			WHEN SUM(PQTY) > 0
				THEN SUM(PAMT) / SUM(PQTY)
			ELSE 0
			END
		),
	SNETRATE = (
		CASE 
			WHEN SUM(SQTY) > 0
				THEN SUM(SRATE * SQTY) / SUM(SQTY)
			ELSE 0
			END
		),
	PAMT = SUM(PAMT),
	SAMT = SUM(SAMT),
	BROKERAGE = SUM(BROKERAGE),
	PTOTCHARGE = SUM(PTOTCHARGE),
	STOTCHARGE = SUM(STOTCHARGE),
	SETT_NO,
	SETT_TYPE,
	TRADETYPE,
	TMARK,
	PARTYNAME,
	L_ADDRESS1,
	L_ADDRESS2,
	L_ADDRESS3,
	L_CITY,
	L_STATE,
	L_ZIP,
	SERVICE_CHRG,
	BRANCH_CD,
	SUB_BROKER,
	TRADER,
	PAN_GIR_NO,
	OFF_PHONE1,
	OFF_PHONE2,
	PRINTF,
	MAPIDID,
	UCC_CODE,
	ORDERFLAG,
	SCRIPNAMEForOrderBy = CONVERT(VARCHAR(100), SCRIPNAMEForOrderBy),
	SCRIPNAME1,
	SEBI_NO,
	Participant_Code,
	ActSell_buy,
	ISIN = CONVERT(VARCHAR(12), ''),
	SLP = CONVERT(NUMERIC(18, 4), 0),
	RETURNSESSIONNO = CONVERT(VARCHAR(50), ''),
	RETURNSESSION_SETTDATE = CONVERT(VARCHAR(11), '')
INTO #CONTSETTNEW
FROM #CONTSETT WITH (NOLOCK)
WHERE PRINTF IN (
		'3',
		'4',
		'6'
		)
GROUP BY CONTRACTNO,
	PARTY_CODE,
	LEFT(CONVERT(VARCHAR, SAUDA_DATE, 109), 11),
	SCRIP_CD,
	SERIES,
	SCRIPNAME,
	SDT,
	SELL_BUY,
	SETT_NO,
	SETT_TYPE,
	SAUDA_DATE1,
	TRADETYPE,
	TMARK,
	PARTYNAME,
	L_ADDRESS1,
	L_ADDRESS2,
	L_ADDRESS3,
	L_CITY,
	L_STATE,
	L_ZIP,
	SERVICE_CHRG,
	BRANCH_CD,
	SUB_BROKER,
	TRADER,
	PAN_GIR_NO,
	OFF_PHONE1,
	OFF_PHONE2,
	PRINTF,
	MAPIDID,
	UCC_CODE,
	ORDERFLAG,
	SCRIPNAMEForOrderBy,
	SCRIPNAME1,
	SEBI_NO,
	Participant_Code,
	ActSell_buy

INSERT INTO #CONTSETTNEW
SELECT *,
	ISIN = CONVERT(VARCHAR(12), ''),
	SLP = CONVERT(NUMERIC(18, 4), 0),
	ReturnSessionNo = CONVERT(VARCHAR(12), ''),
	RETURNSESSION_SETTDATE = CONVERT(VARCHAR(11), '')
FROM #CONTSETT WITH (NOLOCK)
WHERE PRINTF NOT IN (
		'3',
		'4',
		'6'
		)

CREATE INDEX [DELPOS] ON [dbo].[#CONTSETTNEW] (
	[SAUDA_DATE],
	[Sett_Type],
	[PARTY_CODE],
	[Scrip_Cd],
	[Series]
	)

UPDATE #CONTSETTNEW
SET ORDER_NO = S.ORDER_NO,
	TM = CONVERT(VARCHAR, S.SAUDA_DATE, 108),
	TRADE_NO = S.TRADE_NO,
	ORDER_Time = S.ORDER_Time
FROM #CONTSETT S WITH (NOLOCK)
WHERE S.PRINTF = #CONTSETTNEW.PRINTF
	AND S.PRINTF IN (
		'3',
		'4',
		'6'
		)
	AND S.SAUDA_DATE LIKE @SAUDA_DATE + '%'
	AND S.SCRIP_CD = #CONTSETTNEW.SCRIP_CD
	AND S.SERIES = #CONTSETTNEW.SERIES
	AND S.PARTY_CODE = #CONTSETTNEW.PARTY_CODE
	AND S.CONTRACTNO = #CONTSETTNEW.CONTRACTNO
	AND S.ActSell_buy = #CONTSETTNEW.ActSell_buy
	AND S.SAUDA_DATE = (
		SELECT MIN(SAUDA_DATE)
		FROM #CONTSETT ISETT WITH (NOLOCK)
		WHERE PRINTF IN (
				'3',
				'4',
				'6'
				)
			AND ISETT.SAUDA_DATE LIKE @SAUDA_DATE + '%'
			AND S.SCRIP_CD = ISETT.SCRIP_CD
			AND S.SERIES = ISETT.SERIES
			AND S.PARTY_CODE = ISETT.PARTY_CODE
			AND S.CONTRACTNO = ISETT.CONTRACTNO
			AND S.ActSell_buy = ISETT.ActSell_buy
		)

UPDATE #CONTSETTNEW
SET SLP = #CLOSING.CL_RATE
FROM #CLOSING
WHERE #CONTSETTNEW.SCRIP_CD = #CLOSING.SLBSCRIP

UPDATE #CONTSETTNEW
SET ReturnSessionNo = dbo.CONVERTSETTNO(S.SETT_NO, 1) + '-' + LEFT(CONVERT(VARCHAR, EXPIRY_DATE, 109), 11),
RETURNSESSION_SETTDATE = LEFT(CONVERT(VARCHAR,S.SEC_PAYIN,109),11)  
FROM SETT_MST S,
	#SCRIP S1
WHERE S.SETT_TYPE = 'B'
	AND S.SEC_PAYIN = CONVERT(DATETIME, EXPIRY_DATE)
	AND S1.scrip_cd = #CONTSETTNEW.SCRIP_CD

UPDATE #CONTSETTNEW
SET Sett_No = dbo.CONVERTSETTNO(SETT_NO, 1)

ALTER TABLE #CONTSETTNEW ADD CGST NUMERIC(18, 6)

ALTER TABLE #CONTSETTNEW ADD SGST NUMERIC(18, 6)

ALTER TABLE #CONTSETTNEW ADD IGST NUMERIC(18, 6)

ALTER TABLE #CONTSETTNEW ADD UGST NUMERIC(18, 6)

ALTER TABLE #CONTSETTNEW ADD CLGSTNO VARCHAR(30)

ALTER TABLE #CONTSETTNEW ADD GSTFLAG INT DEFAULT(0)

ALTER TABLE #CONTSETTNEW ADD CGST_PER NUMERIC(18, 4)

ALTER TABLE #CONTSETTNEW ADD SGST_PER NUMERIC(18, 4)

ALTER TABLE #CONTSETTNEW ADD IGST_PER NUMERIC(18, 4)

ALTER TABLE #CONTSETTNEW ADD UGST_PER NUMERIC(18, 4)

ALTER TABLE #CONTSETTNEW ADD GST_PER NUMERIC(18, 4)

ALTER TABLE #CONTSETTNEW ADD TARGETSTATE VARCHAR(30)

ALTER TABLE #CONTSETTNEW ADD SOURCESTATE VARCHAR(30)

ALTER TABLE #CONTSETTNEW ADD STATE_CODE VARCHAR(30)

ALTER TABLE #CONTSETTNEW ADD DEAL_CLIENT_ADD VARCHAR(MAX)

ALTER TABLE #CONTSETTNEW ADD TGST_NO VARCHAR(30)

ALTER TABLE #CONTSETTNEW ADD TPAN_NO VARCHAR(30)

ALTER TABLE #CONTSETTNEW ADD TDESC_SERVICE VARCHAR(50)

ALTER TABLE #CONTSETTNEW ADD TACC_SERVICE_NO VARCHAR(50)

ALTER TABLE #CONTSETTNEW ADD TAXABLE_VALUE NUMERIC(18, 4)

ALTER TABLE #CONTSETTNEW ADD Brokerage_Incl NUMERIC(18, 4)

ALTER TABLE #CONTSETTNEW ADD STAMPDUTY_INCL NUMERIC(18, 4)

UPDATE #CONTSETTNEW
SET CGST = 0,
	SGST = 0,
	IGST = 0,
	UGST = 0,
	CLGSTNO = '',
	GSTFLAG = 0,
	CGST_PER = 0,
	SGST_PER = 0,
	IGST_PER = 0,
	UGST_PER = 0,
	GST_PER = 0,
	TARGETSTATE = '',
	SOURCESTATE = '',
	STATE_CODE = '',
	DEAL_CLIENT_ADD = '',
	TGST_NO = '',
	TDESC_SERVICE = '',
	TACC_SERVICE_NO = '',
	TAXABLE_VALUE = 0

UPDATE #CONTSETTNEW
SET L_ADDRESS1 = ISNULL(G.L_ADDRESS1, ''),
	L_ADDRESS2 = ISNULL(G.L_ADDRESS2, ''),
	L_ADDRESS3 = ISNULL(G.L_ADDRESS3, ''),
	L_STATE = ISNULL(G.L_STATE, ''),
	L_CITY = ISNULL(G.L_CITY, ''),
	L_ZIP = ISNULL(G.L_ZIP, ''),
	CLGSTNO = ISNULL(G.GST_NO, '')
FROM TBL_CLIENT_GST_DATA G(NOLOCK)
WHERE G.PARTY_CODE = #CONTSETTNEW.PARTY_CODE
	AND CONVERT(DATETIME, @SAUDA_DATE) BETWEEN G.EFF_FROM_DATE
		AND G.EFF_TO_DATE

SELECT G.PARTY_CODE,
	TARGETSTATE = G.L_STATE,
	SOURCESTATE = STATE,
	GST_PER = CONVERT(NUMERIC(18, 4), 0),
	CGST_PER = CONVERT(NUMERIC(18, 4), 0),
	IGST_PER = CONVERT(NUMERIC(18, 4), 0),
	SGST_PER = CONVERT(NUMERIC(18, 4), 0),
	UGST_PER = CONVERT(NUMERIC(18, 4), 0),
	P.SAUDA_DATE1,
	STATE_CODE = CONVERT(VARCHAR(20), ''),
	DEAL_CLIENT_ADD = L.ADDRESS1 + ' ' + L.ADDRESS2 + ' ' + L.CITY + ' ' + L.ZIP,
	TGST_NO = L.GST_NO
INTO #GSTDATA
FROM TBL_CLIENT_GST_DATA G,
	TBL_GST_LOCATION L,
	#CONTSETTNEW P
WHERE GST_LOCATION = LOC_CODE
	AND CONVERT(DATETIME, SAUDA_DATE1, 109) BETWEEN G.EFF_FROM_DATE
		AND G.EFF_TO_DATE
	AND G.PARTY_CODE = P.PARTY_CODE

INSERT INTO #GSTDATA
SELECT P.PARTY_CODE,
	TARGETSTATE = STATE,
	SOURCESTATE = STATE,
	GST_PER = CONVERT(NUMERIC(18, 4), 0),
	CGST_PER = CONVERT(NUMERIC(18, 4), 0),
	IGST_PER = CONVERT(NUMERIC(18, 4), 0),
	SGST_PER = CONVERT(NUMERIC(18, 4), 0),
	UGST_PER = CONVERT(NUMERIC(18, 4), 0),
	P.SAUDA_DATE1,
	STATE_CODE = '',
	DEAL_CLIENT_ADD = '',
	P.TGST_NO
FROM #CONTSETTNEW P,
	OWNER
WHERE NOT EXISTS (
		SELECT PARTY_CODE
		FROM #GSTDATA G
		WHERE P.PARTY_CODE = G.PARTY_CODE
			AND P.SAUDA_DATE1 = G.SAUDA_DATE1
		)

UPDATE #GSTDATA
SET TARGETSTATE = SOURCESTATE
WHERE TARGETSTATE NOT IN (
		SELECT STATE
		FROM STATE_MASTER
		WHERE STATE <> 'OTHER'
		)

UPDATE #GSTDATA
SET GST_PER = D.GST_PER,
	CGST_PER = (
		CASE 
			WHEN SOURCESTATE = TARGETSTATE
				THEN D.CGST_PER
			ELSE 0
			END
		),
	IGST_PER = (
		CASE 
			WHEN SOURCESTATE <> TARGETSTATE
				THEN D.IGST_PER
			ELSE 0
			END
		),
	SGST_PER = (
		CASE 
			WHEN SOURCESTATE = TARGETSTATE
				AND UTI_FLAG = 0
				THEN D.SGST_PER
			ELSE 0
			END
		),
	UGST_PER = (
		CASE 
			WHEN SOURCESTATE = TARGETSTATE
				AND UTI_FLAG = 1
				THEN D.UGST_PER
			ELSE 0
			END
		),
	STATE_CODE = ISNULL(D.STATE_CODE, '')
FROM TBL_STATE_GST_DATA D
WHERE D.STATE_NAME = SOURCESTATE
	AND CONVERT(DATETIME, SAUDA_DATE1, 103) BETWEEN EFF_FROM_DATE
		AND EFF_TO_DATE

UPDATE #CONTSETTNEW
SET CGST_PER = G.CGST_PER,
	IGST_PER = G.IGST_PER,
	SGST_PER = G.SGST_PER,
	UGST_PER = G.UGST_PER,
	GST_PER = G.GST_PER,
	CGST = (
		CASE 
			WHEN SERVICE_TAX > 0
				THEN SERVICE_TAX * G.CGST_PER / G.GST_PER
			ELSE 0
			END
		),
	SGST = (
		CASE 
			WHEN SERVICE_TAX > 0
				THEN SERVICE_TAX * G.SGST_PER / G.GST_PER
			ELSE 0
			END
		),
	IGST = (
		CASE 
			WHEN SERVICE_TAX > 0
				THEN SERVICE_TAX * G.IGST_PER / G.GST_PER
			ELSE 0
			END
		),
	UGST = (
		CASE 
			WHEN SERVICE_TAX > 0
				THEN SERVICE_TAX * G.UGST_PER / G.GST_PER
			ELSE 0
			END
		),
	GSTFLAG = 1,
	TARGETSTATE = G.TARGETSTATE,
	SOURCESTATE = G.SOURCESTATE,
	STATE_CODE = G.STATE_CODE,
	DEAL_CLIENT_ADD = G.DEAL_CLIENT_ADD,
	TGST_NO = G.TGST_NO
FROM #GSTDATA G
WHERE #CONTSETTNEW.PARTY_CODE = G.PARTY_CODE
	AND #CONTSETTNEW.SAUDA_DATE1 = G.SAUDA_DATE1
	AND G.GST_PER > 0

UPDATE #CONTSETTNEW
SET STAMPDUTY_INCL = ROUND(CASE 
			WHEN BROKER_CHRG = 0
				THEN ((PRATE + SRATE) * (PQTY + SQTY)) * @STAMPDUTY / 100
			ELSE STAMPDUTY_INCL
			END, 4),
	BROKERAGE_INCL = ROUND(CASE 
			WHEN BROKER_CHRG = 0
				THEN (BROKERAGE) - (((PRATE + SRATE) * (PQTY + SQTY)) * @STAMPDUTY / 100)
			ELSE (BROKERAGE)
			END, 4)
FROM #GSTDATA G
WHERE #CONTSETTNEW.PARTY_CODE = G.PARTY_CODE
	AND #CONTSETTNEW.SAUDA_DATE1 = G.SAUDA_DATE1
	AND G.GST_PER > 0
	AND SERVICE_TAX = 0

UPDATE #CONTSETTNEW
SET CGST_PER = G.CGST_PER,
	IGST_PER = G.IGST_PER,
	SGST_PER = G.SGST_PER,
	UGST_PER = G.UGST_PER,
	GST_PER = G.GST_PER,
	CGST = ((BROKERAGE_INCL) - (BROKERAGE_INCL) * 100 / (100 + G.GST_PER)) * G.CGST_PER / G.GST_PER,
	SGST = ((BROKERAGE_INCL) - (BROKERAGE_INCL) * 100 / (100 + G.GST_PER)) * G.SGST_PER / G.GST_PER,
	IGST = ((BROKERAGE_INCL) - (BROKERAGE_INCL) * 100 / (100 + G.GST_PER)) * G.IGST_PER / G.GST_PER,
	UGST = ((BROKERAGE_INCL) - (BROKERAGE_INCL) * 100 / (100 + G.GST_PER)) * G.UGST_PER / G.GST_PER,
	/*   
 BROKERAGE_INCL = ((PBROK+SBROK)-(PBROK+SBROK)*100/(100+G.GST_PER)),        
 STAMPDUTY_INCL = ((PRATE + SRATE) * (PQTY + SQTY)) * @STAMPDUTY / 100,    
 CGST = ((PBROK+SBROK)-(PBROK+SBROK) *100/(100+G.GST_PER)) * G.CGST_PER / G.GST_PER,        
 SGST = ((PBROK+SBROK)-(PBROK+SBROK) *100/(100+G.GST_PER)) * G.SGST_PER / G.GST_PER,        
 IGST = ((PBROK+SBROK)-(PBROK+SBROK) *100/(100+G.GST_PER)) * G.IGST_PER / G.GST_PER,        
 UGST = ((PBROK+SBROK)-(PBROK+SBROK) *100/(100+G.GST_PER)) * G.UGST_PER / G.GST_PER,        
 */
	GSTFLAG = 1,
	TARGETSTATE = G.TARGETSTATE,
	SOURCESTATE = G.SOURCESTATE,
	STATE_CODE = G.STATE_CODE,
	DEAL_CLIENT_ADD = G.DEAL_CLIENT_ADD,
	TGST_NO = G.TGST_NO
FROM #GSTDATA G
WHERE #CONTSETTNEW.PARTY_CODE = G.PARTY_CODE
	AND #CONTSETTNEW.SAUDA_DATE1 = G.SAUDA_DATE1
	AND G.GST_PER > 0
	AND SERVICE_TAX = 0

UPDATE #CONTSETTNEW
SET TPAN_NO = ISNULL(PANNO, ''),
	TDESC_SERVICE = ISNULL(SERVICE_DESCRIPTION, ''),
	TACC_SERVICE_NO = ISNULL(ACCOUNT_SERVICE_NO, '')
FROM OWNER (NOLOCK)

--### END GST CHANGES ###---        
IF (@CONTFLAG = 'CONTRACT')
BEGIN
	SELECT OrderByFlag = (
			CASE 
				WHEN @ColName = 'ORD_N'
					THEN PartyName
				WHEN @ColName = 'ORD_P'
					THEN Party_Code
				WHEN @ColName = 'ORD_BP'
					THEN RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(Party_Code))
				WHEN @ColName = 'ORD_BN'
					THEN RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(PartyName))
				WHEN @ColName = 'ORD_DP'
					THEN RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(Sub_Broker)) + RTrim(LTrim(Trader)) + RTrim(LTrim(Party_Code))
				WHEN @ColName = 'ORD_DN'
					THEN RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(Sub_Broker)) + RTrim(LTrim(Trader)) + RTrim(LTrim(PartyName))
				ELSE RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(Sub_Broker)) + RTrim(LTrim(Trader)) + RTrim(LTrim(Party_Code))
				END
			),
		CONTRACTNO,
		PARTY_CODE,
		ORDER_NO,
		ORDER_TIME,
		TM,
		TRADE_NO,
		SAUDA_DATE,
		#CONTSETTNEW.SCRIP_CD,
		#CONTSETTNEW.SERIES,
		SCRIPNAME = SCRIPNAME,
		--SCRIPNAME=#CONTSETTNEW.SCRIP_CD  + '-'+                
		--(select isin from msajag.dbo.multiisin a where a.scrip_cd=#CONTSETTNEW.SCRIP_CD                 
		--and valid=1 and series='EQ'),                                             
		PSCRIPNAME = (
			CASE 
				WHEN SELL_BUY = 1
					THEN SCRIPNAME
				ELSE ''
				END
			),
		SSCRIPNAME = (
			CASE 
				WHEN SELL_BUY = 2
					THEN SCRIPNAME
				ELSE ''
				END
			),
		SDT,
		SELL_BUY,
		BROKER_CHRG,
		TURN_TAX,
		PBROKER_CHRG = (
			CASE 
				WHEN SELL_BUY = 1
					THEN BROKER_CHRG
				ELSE 0
				END
			),
		SBROKER_CHRG = (
			CASE 
				WHEN SELL_BUY = 2
					THEN BROKER_CHRG
				ELSE 0
				END
			),
		PTURN_TAX = (
			CASE 
				WHEN SELL_BUY = 1
					THEN TURN_TAX
				ELSE 0
				END
			),
		STURN_TAX = (
			CASE 
				WHEN SELL_BUY = 2
					THEN TURN_TAX
				ELSE 0
				END
			),
		POTHER_CHRG = (
			CASE 
				WHEN SELL_BUY = 1
					THEN OTHER_CHRG
				ELSE 0
				END
			),
		SOTHER_CHRG = (
			CASE 
				WHEN SELL_BUY = 2
					THEN OTHER_CHRG
				ELSE 0
				END
			),
		SEBI_TAX,
		OTHER_CHRG,
		INS_CHRG,
		PINS_CHRG = (
			CASE 
				WHEN SELL_BUY = 1
					THEN INS_CHRG
				ELSE 0
				END
			),
		SINS_CHRG = (
			CASE 
				WHEN SELL_BUY = 2
					THEN INS_CHRG
				ELSE 0
				END
			),
		SERVICE_TAX,
		NSERTAX,
		PNSERTAX = (
			CASE 
				WHEN SELL_BUY = 1
					THEN NSERTAX
				ELSE 0
				END
			),
		SNSERTAX = (
			CASE 
				WHEN SELL_BUY = 2
					THEN NSERTAX
				ELSE 0
				END
			),
		SAUDA_DATE1,
		QTY = (PQTY + SQTY),
		PQTY,
		SQTY,
		RATE = PRATE + SRATE,
		PRATE,
		SRATE,
		BROK = PBROK + SBROK,
		PBROK,
		SBROK,
		PSCHEME,
		SSCHEME,
		SCHEME = (PSCHEME + SSCHEME),
		PSCHEMENETRATE,
		SSCHEMENETRATE,
		SCHEMENETRATE = (PSCHEMENETRATE + SSCHEMENETRATE),
		NETRATE = PNETRATE + SNETRATE,
		PNETRATE = PNETRATE + (
			CASE 
				WHEN Sell_Buy = 1
					THEN BROKERAGE / PQty
				ELSE 0
				END
			), --(CASE WHEN PQTY > 0 THEN PAMT/PQTY ELSE 0 END),                                  
		SNETRATE = SNETRATE - (
			CASE 
				WHEN Sell_Buy = 2
					THEN BROKERAGE / SQty
				ELSE 0
				END
			), --SRATE, --(CASE WHEN SQTY > 0 THEN (SRATE*SQTY)/SQTY ELSE 0 END),                                  
		AMT = (
			CASE 
				WHEN SELL_BUY = 1
					THEN - PAMT
				ELSE SAMT
				END
			),
		PAMT,
		SAMT,
		AMTSTT = (
			CASE 
				WHEN SELL_BUY = 1
					THEN - (PAMT + INS_CHRG)
				ELSE (SAMT - INS_CHRG)
				END
			),
		PAMTSTT = (
			CASE 
				WHEN SELL_BUY = 1
					THEN PAMT + INS_CHRG
				ELSE 0
				END
			),
		SAMTSTT = (
			CASE 
				WHEN SELL_BUY = 2
					THEN SAMT - INS_CHRG
				ELSE 0
				END
			),
		AMTSER = (
			CASE 
				WHEN SELL_BUY = 1
					THEN - (PAMT + NSERTAX)
				ELSE (SAMT - NSERTAX)
				END
			),
		PAMTSER = (
			CASE 
				WHEN SELL_BUY = 1
					THEN PAMT + NSERTAX
				ELSE 0
				END
			),
		SAMTSER = (
			CASE 
				WHEN SELL_BUY = 2
					THEN SAMT - NSERTAX
				ELSE 0
				END
			),
		AMTSERSTT = (
			CASE 
				WHEN SELL_BUY = 1
					THEN - (PAMT + NSERTAX + INS_CHRG)
				ELSE (SAMT - NSERTAX - INS_CHRG)
				END
			),
		PAMTSERSTT = (
			CASE 
				WHEN SELL_BUY = 1
					THEN PAMT + NSERTAX + INS_CHRG
				ELSE 0
				END
			),
		SAMTSERSTT = (
			CASE 
				WHEN SELL_BUY = 2
					THEN SAMT - NSERTAX - INS_CHRG
				ELSE 0
				END
			),
		AMTSERSTTSTAMPTRANS = (
			CASE 
				WHEN SELL_BUY = 1
					THEN - (PAMT + NSERTAX + INS_CHRG + BROKER_CHRG + TURN_TAX)
				ELSE (SAMT - NSERTAX - INS_CHRG - BROKER_CHRG - TURN_TAX)
				END
			),
		PAMTSERSTTSTAMPTRANS = (
			CASE 
				WHEN SELL_BUY = 1
					THEN PAMT + NSERTAX + INS_CHRG + BROKER_CHRG + TURN_TAX
				ELSE 0
				END
			),
		SAMTSERSTTSTAMPTRANS = (
			CASE 
				WHEN SELL_BUY = 2
					THEN SAMT - NSERTAX - INS_CHRG - BROKER_CHRG - TURN_TAX
				ELSE 0
				END
			),
		MARKETAMT = (
			CASE 
				WHEN SELL_BUY = 1
					THEN - (PRATE * PQTY) + (SRATE * SQTY)
				ELSE (PRATE * PQTY) + (SRATE * SQTY)
				END
			),
		PMARKETAMT = PRATE * PQTY,
		SMARKETAMT = SRATE * SQTY,
		BROKERAGE,
		PBROKERAGE = (
			CASE 
				WHEN SELL_BUY = 1
					THEN BROKERAGE
				ELSE 0
				END
			),
		SBROKERAGE = (
			CASE 
				WHEN SELL_BUY = 2
					THEN BROKERAGE
				ELSE 0
				END
			),
		PTOTCHARGE,
		STOTCHARGE,
		SETT_NO,
		SETT_TYPE,
		TRADETYPE = (
			CASE 
				WHEN RTRIM(LTRIM(TRADETYPE)) <> ''
					THEN '-(' + RTRIM(LTRIM(TRADETYPE)) + ')'
				ELSE '     '
				END
			),
		TMARK,
		PARTYNAME,
		L_ADDRESS1,
		L_ADDRESS2,
		L_ADDRESS3,
		L_CITY,
		L_STATE,
		L_ZIP,
		SERVICE_CHRG,
		BRANCH_CD,
		SUB_BROKER,
		TRADER,
		PAN_GIR_NO,
		OFF_PHONE1,
		OFF_PHONE2,
		PRINTF,
		MAPIDID,
		UCC_CODE,
		ORDERFLAG,
		SCRIPNAMEForOrderBy,
		SCRIPNAME1,
		ISIN,
		SEBI_NO,
		Participant_Code,
		SLP = SLP,
		ReturnSessionNo,
		RETURNSESSION_SETTDATE,
		PCGST = (
			CASE 
				WHEN SELL_BUY = 1
					THEN CGST
				ELSE 0
				END
			),
		SCGST = (
			CASE 
				WHEN SELL_BUY = 2
					THEN CGST
				ELSE 0
				END
			),
		PSGST = (
			CASE 
				WHEN SELL_BUY = 1
					THEN SGST
				ELSE 0
				END
			),
		SSGST = (
			CASE 
				WHEN SELL_BUY = 2
					THEN SGST
				ELSE 0
				END
			),
		PIGST = (
			CASE 
				WHEN SELL_BUY = 1
					THEN IGST
				ELSE 0
				END
			),
		SIGST = (
			CASE 
				WHEN SELL_BUY = 2
					THEN IGST
				ELSE 0
				END
			),
		PUGST = (
			CASE 
				WHEN SELL_BUY = 1
					THEN UGST
				ELSE 0
				END
			),
		SUGST = (
			CASE 
				WHEN SELL_BUY = 2
					THEN UGST
				ELSE 0
				END
			),
		PTAXABLE_VALUE = (
			CASE 
				WHEN SELL_BUY = 1
					THEN (
							CASE 
								WHEN BROKERAGE_INCL > 0
									THEN PBROK - STAMPDUTY_INCL - CGST - SGST - UGST - IGST
								ELSE PBROK
								END
							) + + (
							CASE 
								WHEN TURNOVER_AC = 1
									THEN TURN_TAX
								ELSE 0
								END
							) + (
							CASE 
								WHEN sebi_turn_ac = 1
									THEN SEBI_TAX
								ELSE 0
								END
							) + (
							CASE 
								WHEN broker_note_ac = 1
									THEN BROKER_CHRG
								ELSE 0
								END
							) + (
							CASE 
								WHEN other_chrg_ac = 1
									THEN OTHER_CHRG
								ELSE 0
								END
							) + (
							CASE 
								WHEN STT_TAX_AC = 1
									THEN INS_CHRG
								ELSE 0
								END
							)
				ELSE 0
				END
			),
		STAXABLE_VALUE = (
			CASE 
				WHEN SELL_BUY = 2
					THEN (
							CASE 
								WHEN BROKERAGE_INCL > 0
									THEN SBROK - STAMPDUTY_INCL - CGST - SGST - UGST - IGST
								ELSE SBROK
								END
							) + + (
							CASE 
								WHEN TURNOVER_AC = 1
									THEN TURN_TAX
								ELSE 0
								END
							) + (
							CASE 
								WHEN sebi_turn_ac = 1
									THEN SEBI_TAX
								ELSE 0
								END
							) + (
							CASE 
								WHEN broker_note_ac = 1
									THEN BROKER_CHRG
								ELSE 0
								END
							) + (
							CASE 
								WHEN other_chrg_ac = 1
									THEN OTHER_CHRG
								ELSE 0
								END
							) + (
							CASE 
								WHEN STT_TAX_AC = 1
									THEN INS_CHRG
								ELSE 0
								END
							)
				ELSE 0
				END
			),
		PSTAMPDUTYINCL = (
			CASE 
				WHEN Sell_Buy = 1
					THEN STAMPDUTY_INCL
				ELSE 0
				END
			),
		SSTAMPDUTYINCL = ISNULL((
				CASE 
					WHEN Sell_Buy = 2
						THEN STAMPDUTY_INCL
					ELSE 0
					END
				), 0.00),
		CLGSTNO,
		GSTFLAG,
		CGST_PER,
		SGST_PER,
		IGST_PER,
		UGST_PER,
		GST_PER,
		TARGETSTATE,
		SOURCESTATE,
		STATE_CODE,
		DEAL_CLIENT_ADD,
		TGST_NO,
		TDESC_SERVICE,
		TACC_SERVICE_NO,
		TPAN_NO,
		TRANS_TYPE = (
			CASE 
				WHEN SELL_BUY = 1
					THEN 'Borrow'
				ELSE 'LEND'
				END
			),
		TOTCHARGE = PTOTCHARGE + STOTCHARGE

	--, CLOSE_PRICE = CL_RATE                   
	FROM #CONTSETTNEW,
		(
			SELECT TURNOVER_AC = ISNULL(TURNOVER_AC, 0),
				sebi_turn_ac = ISNULL(sebi_turn_ac, 0),
				broker_note_ac = ISNULL(broker_note_ac, 0),
				other_chrg_ac = ISNULL(other_chrg_ac, 0),
				STT_TAX_AC = ISNULL(STT_TAX_AC, 0)
			FROM GLOBALS
			WHERE @SAUDA_DATE BETWEEN year_start_dt
					AND year_end_dt
			) G
	WHERE
		--SYSDATE LIKE @sauda_DATE + '%'                   
		--AND #CONTSETTNEW.SCRIP_CD = C.SCRIP_CD                        
		--AND C.SERIES IN ('EQ', 'BE')                         
		PRINTF NOT IN (
			'1',
			'2',
			'6'
			)
	ORDER BY OrderByFlag,
		BRANCH_CD,
		SUB_BROKER,
		TRADER,
		PARTY_CODE,
		PARTYNAME,
		ContractNo DESC,
		SCRIPNAMEForOrderBy,
		SCRIPNAME1,
		ORDERFLAG,
		SETT_NO,
		SETT_TYPE,
		TM,
		ORDER_NO,
		TRADE_NO
END
ELSE
BEGIN
	SELECT OrderByFlag = (
			CASE 
				WHEN @ColName = 'ORD_N'
					THEN PartyName
				WHEN @ColName = 'ORD_P'
					THEN Party_Code
				WHEN @ColName = 'ORD_BP'
					THEN RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(Party_Code))
				WHEN @ColName = 'ORD_BN'
					THEN RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(PartyName))
				WHEN @ColName = 'ORD_DP'
					THEN RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(Sub_Broker)) + RTrim(LTrim(Trader)) + RTrim(LTrim(Party_Code))
				WHEN @ColName = 'ORD_DN'
					THEN RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(Sub_Broker)) + RTrim(LTrim(Trader)) + RTrim(LTrim(PartyName))
				ELSE RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(Sub_Broker)) + RTrim(LTrim(Trader)) + RTrim(LTrim(Party_Code))
				END
			),
		CONTRACTNO,
		PARTY_CODE,
		ORDER_NO,
		ORDER_TIME,
		TM,
		TRADE_NO,
		SAUDA_DATE,
		#CONTSETTNEW.SCRIP_CD,
		#CONTSETTNEW.SERIES,
		/*        SCRIPNAME =SCRIPNAME + '-'+                 
(select isin from msajag.dbo.multiisin a where a.scrip_cd=#CONTSETTNEW.SCRIP_CD                 
and valid=1 and series='EQ'),                                         */
		SCRIPNAME = SCRIPNAME,
		PSCRIPNAME = (
			CASE 
				WHEN SELL_BUY = 1
					THEN SCRIPNAME
				ELSE ''
				END
			),
		SSCRIPNAME = (
			CASE 
				WHEN SELL_BUY = 2
					THEN SCRIPNAME
				ELSE ''
				END
			),
		SDT,
		SELL_BUY,
		BROKER_CHRG,
		TURN_TAX,
		PBROKER_CHRG = (
			CASE 
				WHEN SELL_BUY = 1
					THEN BROKER_CHRG
				ELSE 0
				END
			),
		SBROKER_CHRG = (
			CASE 
				WHEN SELL_BUY = 2
					THEN BROKER_CHRG
				ELSE 0
				END
			),
		PTURN_TAX = (
			CASE 
				WHEN SELL_BUY = 1
					THEN TURN_TAX
				ELSE 0
				END
			),
		STURN_TAX = (
			CASE 
				WHEN SELL_BUY = 2
					THEN TURN_TAX
				ELSE 0
				END
			),
		POTHER_CHRG = (
			CASE 
				WHEN SELL_BUY = 1
					THEN OTHER_CHRG
				ELSE 0
				END
			),
		SOTHER_CHRG = (
			CASE 
				WHEN SELL_BUY = 2
					THEN OTHER_CHRG
				ELSE 0
				END
			),
		SEBI_TAX,
		OTHER_CHRG,
		INS_CHRG,
		PINS_CHRG = (
			CASE 
				WHEN SELL_BUY = 1
					THEN INS_CHRG
				ELSE 0
				END
			),
		SINS_CHRG = (
			CASE 
				WHEN SELL_BUY = 2
					THEN INS_CHRG
				ELSE 0
				END
			),
		SERVICE_TAX,
		NSERTAX,
		PNSERTAX = (
			CASE 
				WHEN SELL_BUY = 1
					THEN NSERTAX
				ELSE 0
				END
			),
		SNSERTAX = (
			CASE 
				WHEN SELL_BUY = 2
					THEN NSERTAX
				ELSE 0
				END
			),
		SAUDA_DATE1,
		QTY = (PQTY + SQTY),
		PQTY,
		SQTY,
		RATE = PRATE + SRATE,
		PRATE,
		SRATE,
		BROK = PBROK + SBROK,
		PBROK,
		SBROK,
		PSCHEME,
		SSCHEME,
		SCHEME = (PSCHEME + SSCHEME),
		PSCHEMENETRATE,
		SSCHEMENETRATE,
		SCHEMENETRATE = (PSCHEMENETRATE + SSCHEMENETRATE),
		NETRATE = (
			CASE 
				WHEN SELL_BUY = 1
					THEN - PAMT
				ELSE SAMT
				END
			) / (PQTY + SQTY),
		--PNETRATE= pNETRATE,--(CASE WHEN PQTY > 0 THEN PAMT/PQTY ELSE 0 END),                                  
		--SNETRATE= SNETRATE,--SRATE, --(CASE WHEN SQTY > 0 THEN SAMT/SQTY ELSE 0 END),                                  
		PNETRATE = PNETRATE + (
			CASE 
				WHEN Sell_Buy = 1
					THEN BROKERAGE / PQty
				ELSE 0
				END
			), --(CASE WHEN PQTY > 0 THEN PAMT/PQTY ELSE 0 END),                                  
		SNETRATE = SNETRATE - (
			CASE 
				WHEN Sell_Buy = 2
					THEN BROKERAGE / SQty
				ELSE 0
				END
			), --SRATE, --(CASE WHEN SQTY > 0 THEN (SRATE*SQTY)/SQTY ELSE 0 END),                                  
		AMT = (
			CASE 
				WHEN SELL_BUY = 1
					THEN - PAMT
				ELSE SAMT
				END
			),
		PAMT,
		SAMT,
		AMTSTT = (
			CASE 
				WHEN SELL_BUY = 1
					THEN - (PAMT + INS_CHRG)
				ELSE (SAMT - INS_CHRG)
				END
			),
		PAMTSTT = (
			CASE 
				WHEN SELL_BUY = 1
					THEN PAMT + INS_CHRG
				ELSE 0
				END
			),
		SAMTSTT = (
			CASE 
				WHEN SELL_BUY = 2
					THEN SAMT - INS_CHRG
				ELSE 0
				END
			),
		AMTSER = (
			CASE 
				WHEN SELL_BUY = 1
					THEN - (PAMT + NSERTAX)
				ELSE (SAMT - NSERTAX)
				END
			),
		PAMTSER = (
			CASE 
				WHEN SELL_BUY = 1
					THEN PAMT + NSERTAX
				ELSE 0
				END
			),
		SAMTSER = (
			CASE 
				WHEN SELL_BUY = 2
					THEN SAMT - NSERTAX
				ELSE 0
				END
			),
		AMTSERSTT = (
			CASE 
				WHEN SELL_BUY = 1
					THEN - (PAMT + NSERTAX + INS_CHRG)
				ELSE (SAMT - NSERTAX - INS_CHRG)
				END
			),
		PAMTSERSTT = (
			CASE 
				WHEN SELL_BUY = 1
					THEN PAMT + NSERTAX + INS_CHRG
				ELSE 0
				END
			),
		SAMTSERSTT = (
			CASE 
				WHEN SELL_BUY = 2
					THEN SAMT - NSERTAX - INS_CHRG
				ELSE 0
				END
			),
		AMTSERSTTSTAMPTRANS = (
			CASE 
				WHEN SELL_BUY = 1
					THEN - (PAMT + NSERTAX + INS_CHRG + BROKER_CHRG + TURN_TAX)
				ELSE (SAMT - NSERTAX - INS_CHRG - BROKER_CHRG - TURN_TAX)
				END
			),
		PAMTSERSTTSTAMPTRANS = (
			CASE 
				WHEN SELL_BUY = 1
					THEN PAMT + NSERTAX + INS_CHRG + BROKER_CHRG + TURN_TAX
				ELSE 0
				END
			),
		SAMTSERSTTSTAMPTRANS = (
			CASE 
				WHEN SELL_BUY = 2
					THEN SAMT - NSERTAX - INS_CHRG - BROKER_CHRG - TURN_TAX
				ELSE 0
				END
			),
		MARKETAMT = (
			CASE 
				WHEN SELL_BUY = 1
					THEN - (PRATE * PQTY) + (SRATE * SQTY)
				ELSE (PRATE * PQTY) + (SRATE * SQTY)
				END
			),
		PMARKETAMT = PRATE * PQTY,
		SMARKETAMT = SRATE * SQTY,
		BROKERAGE,
		PBROKERAGE = (
			CASE 
				WHEN SELL_BUY = 1
					THEN BROKERAGE
				ELSE 0
				END
			),
		SBROKERAGE = (
			CASE 
				WHEN SELL_BUY = 2
					THEN BROKERAGE
				ELSE 0
				END
			),
		PTOTCHARGE,
		STOTCHARGE,
		SETT_NO,
		SETT_TYPE,
		TRADETYPE = (
			CASE 
				WHEN RTRIM(LTRIM(TRADETYPE)) <> ''
					THEN '-(' + RTRIM(LTRIM(TRADETYPE)) + ')'
				ELSE '     '
				END
			),
		TMARK,
		PARTYNAME,
		L_ADDRESS1,
		L_ADDRESS2,
		L_ADDRESS3,
		L_CITY,
		L_STATE,
		L_ZIP,
		SERVICE_CHRG,
		BRANCH_CD,
		SUB_BROKER,
		TRADER,
		PAN_GIR_NO,
		OFF_PHONE1,
		OFF_PHONE2,
		PRINTF,
		MAPIDID,
		UCC_CODE,
		ORDERFLAG,
		SCRIPNAMEForOrderBy,
		SCRIPNAME1,
		ISIN,
		SEBI_NO,
		Participant_Code,
		SLP = SLP,
		ReturnSessionNo,
		RETURNSESSION_SETTDATE,
		PCGST = (
			CASE 
				WHEN SELL_BUY = 1
					THEN CGST
				ELSE 0
				END
			),
		SCGST = (
			CASE 
				WHEN SELL_BUY = 2
					THEN CGST
				ELSE 0
				END
			),
		PSGST = (
			CASE 
				WHEN SELL_BUY = 1
					THEN SGST
				ELSE 0
				END
			),
		SSGST = (
			CASE 
				WHEN SELL_BUY = 2
					THEN SGST
				ELSE 0
				END
			),
		PIGST = (
			CASE 
				WHEN SELL_BUY = 1
					THEN IGST
				ELSE 0
				END
			),
		SIGST = (
			CASE 
				WHEN SELL_BUY = 2
					THEN IGST
				ELSE 0
				END
			),
		PUGST = (
			CASE 
				WHEN SELL_BUY = 1
					THEN UGST
				ELSE 0
				END
			),
		SUGST = (
			CASE 
				WHEN SELL_BUY = 2
					THEN UGST
				ELSE 0
				END
			),
		PTAXABLE_VALUE = (
			CASE 
				WHEN SELL_BUY = 1
					THEN (
							CASE 
								WHEN BROKERAGE_INCL > 0
									THEN PBROK - STAMPDUTY_INCL - CGST - SGST - UGST - IGST
								ELSE PBROK
								END
							) + + (
							CASE 
								WHEN TURNOVER_AC = 1
									THEN TURN_TAX
								ELSE 0
								END
							) + (
							CASE 
								WHEN sebi_turn_ac = 1
									THEN SEBI_TAX
								ELSE 0
								END
							) + (
							CASE 
								WHEN broker_note_ac = 1
									THEN BROKER_CHRG
								ELSE 0
								END
							) + (
							CASE 
								WHEN other_chrg_ac = 1
									THEN OTHER_CHRG
								ELSE 0
								END
							) + (
							CASE 
								WHEN STT_TAX_AC = 1
									THEN INS_CHRG
								ELSE 0
								END
							)
				ELSE 0
				END
			),
		STAXABLE_VALUE = (
			CASE 
				WHEN SELL_BUY = 2
					THEN (
							CASE 
								WHEN BROKERAGE_INCL > 0
									THEN SBROK - STAMPDUTY_INCL - CGST - SGST - UGST - IGST
								ELSE SBROK
								END
							) + + (
							CASE 
								WHEN TURNOVER_AC = 1
									THEN TURN_TAX
								ELSE 0
								END
							) + (
							CASE 
								WHEN sebi_turn_ac = 1
									THEN SEBI_TAX
								ELSE 0
								END
							) + (
							CASE 
								WHEN broker_note_ac = 1
									THEN BROKER_CHRG
								ELSE 0
								END
							) + (
							CASE 
								WHEN other_chrg_ac = 1
									THEN OTHER_CHRG
								ELSE 0
								END
							) + (
							CASE 
								WHEN STT_TAX_AC = 1
									THEN INS_CHRG
								ELSE 0
								END
							)
				ELSE 0
				END
			),
		PSTAMPDUTYINCL = (
			CASE 
				WHEN Sell_Buy = 1
					THEN STAMPDUTY_INCL
				ELSE 0
				END
			),
		SSTAMPDUTYINCL = ISNULL((
				CASE 
					WHEN Sell_Buy = 2
						THEN STAMPDUTY_INCL
					ELSE 0
					END
				), 0.00),
		CLGSTNO,
		GSTFLAG,
		CGST_PER,
		SGST_PER,
		IGST_PER,
		UGST_PER,
		GST_PER,
		TARGETSTATE,
		SOURCESTATE,
		STATE_CODE,
		DEAL_CLIENT_ADD,
		TGST_NO,
		TDESC_SERVICE,
		TACC_SERVICE_NO,
		TPAN_NO,
		TRANS_TYPE = (
			CASE 
				WHEN SELL_BUY = 1
					THEN 'Borrow'
				ELSE 'LEND'
				END
			),
		TOTCHARGE = PTOTCHARGE + STOTCHARGE

	--, CLOSE_PRICE = CL_RATE                   
	FROM #CONTSETTNEW,
		(
			SELECT TURNOVER_AC = ISNULL(TURNOVER_AC, 0),
				sebi_turn_ac = ISNULL(sebi_turn_ac, 0),
				broker_note_ac = ISNULL(broker_note_ac, 0),
				other_chrg_ac = ISNULL(other_chrg_ac, 0),
				STT_TAX_AC = ISNULL(STT_TAX_AC, 0)
			FROM GLOBALS
			WHERE @SAUDA_DATE BETWEEN year_start_dt
					AND year_end_dt
			) G
	--, MSAJAG.DBO.CLOSING C                        
	--WHERE                   
	--SYSDATE LIKE @sauda_DATE + '%'                   
	--AND #CONTSETTNEW.SCRIP_CD = C.SCRIP_CD                        
	--AND C.SERIES IN ('EQ', 'BE')                                     
	--WHERE   PRINTF NOT IN ('0','3')                                            
	ORDER BY OrderByFlag,
		BRANCH_CD,
		SUB_BROKER,
		TRADER,
		PARTY_CODE,
		PARTYNAME,
		ContractNo DESC,
		SCRIPNAMEForOrderBy,
		SCRIPNAME1,
		ORDERFLAG,
		SETT_NO,
		SETT_TYPE,
		TM,
		ORDER_NO,
		TRADE_NO
END
		-- Exec Rss_SPS_TerminalAddress @SAUDA_DATE,@SETT_NO,@SETT_TYPE,'NSESLBS'

GO
