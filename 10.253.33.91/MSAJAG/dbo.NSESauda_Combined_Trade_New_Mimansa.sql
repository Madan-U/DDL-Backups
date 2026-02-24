-- Object: PROCEDURE dbo.NSESauda_Combined_Trade_New_Mimansa
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




-- =============================================
-- Author:		Arjun Singh
-- Create date: 
-- Description:	
-- =============================================
create Proc [dbo].[NSESauda_Combined_Trade_New_Mimansa]
(@fromdate datetime,
 @todate datetime ,@from_party_code varchar(15),@to_party_code varchar(15))
  --NSESauda_Combined_Trade '2018-04-01','2019-03-31','K78026','K78026'
AS
--return

 SELECT CL_CODE  INTO #CLIENT2 FROM CLIENT2 WHERE PARENTCODE >=@from_party_code AND PARENTCODE <@to_party_code

 CREATE INDEX #CL ON  #CLIENT2 (CL_CODE)


    SELECT Trade_Type, 
           EXCHANGE, 
           SETT_NO, 
           PARTY_CODE, 
           SAUDA_DATE, 
           TRD_DT, 
           SCRIP_CD = Replace(SCRIP_CD, ' ', ''), 
           SCRIPName = '', 
           Buy_qty = SUM(Buy_qty), 
           BuyMarketRate = ISNULL(SUM(BuyMarketRate * Buy_qty) / NULLIF(SUM(Buy_qty), 0), 0), 
           Sell_qty = SUM(Sell_qty), 
           SellMarketRate = ISNULL(SUM(SellMarketRate * Sell_qty) / NULLIF(SUM(Sell_qty), 0), 0), 
           BROKERAGE = SUM(BROKERAGE), 
           STT = SUM(STT), 
           Other_charges = SUM(STAMPDUTY) + SUM(SER_TAX) + SUM(TO_TAX) + SUM(SEBI_TAX) + SUM(other_chrg), 
           TO_TAX = SUM(TO_TAX), 
           SEBI_TAX = SUM(SEBI_TAX), 
           STAMPDUTY = SUM(STAMPDUTY), 
           SER_TAX = SUM(SER_TAX), 
           BILLFLAG = 0, 
           Grand_Total = CASE
                             WHEN Trade_Type = 'zzzzzzzzzzzz'
                             THEN(SUM(BROKERAGE) + SUM(STT) + (SUM(STAMPDUTY) + SUM(SER_TAX) + SUM(TO_TAX) + SUM(SEBI_TAX) + SUM(other_chrg))) * -1
                             ELSE(SUM(Sell_qty*SellMarketRate)) - (SUM(Buy_qty*BuyMarketRate)) - SUM(BROKERAGE) - SUM(STT) - (SUM(STAMPDUTY) + SUM(SER_TAX) + SUM(TO_TAX) + SUM(SEBI_TAX) + SUM(other_chrg))
                         END,
		  SETT_TYPE
    FROM
    (
        SELECT EXCHANGE = 'NSECM', 
               SETT_NO = S.SETT_NO, 
               PARTY_CODE=CASE
                        WHEN PARTY_CODE LIKE '98%'
                        THEN SUBSTRING(PARTY_CODE, 3, LEN(PARTY_CODE))
                        ELSE PARTY_CODE
                    END,  
               SAUDA_DATE = CAST(SAUDA_DATE AS DATE), 
               TRD_DT = CONVERT(VARCHAR(11), SAUDA_DATE, 103), 
               SCRIP_CD = LTRIM(RTRIM(SCRIP_CD)), 
               S.Series, 
               SCRIPName = '', 
               BILLFLAG, 
               Trade_Type = CASE
                                WHEN BILLFLAG IN('2', '3')
                                THEN 'Trading'
                                WHEN BILLFLAG IN('4', '5')
                                     AND S.Sett_type NOT IN('A', 'X')
                                THEN 'Delivery'
                                ELSE 'Auction'
                            END, 
               Buy_qty = ISNULL(CASE
                                    WHEN sell_buy = 1
                                    THEN SUM(Tradeqty)
                                END, ''), 
               BuyMarketRate = ISNULL(CASE
                                          WHEN sell_buy = 1
                                          THEN SUM(TRADEQTY * MARKETRATE) / NULLIF(SUM(TRADEQTY), 0)
                                      END, ''), 
               Sell_qty = ISNULL(CASE
                                     WHEN sell_buy = 2
                                     THEN SUM(Tradeqty)
                                 END, ''), 
               SellMarketRate = ISNULL(CASE
                                           WHEN sell_buy = 2
                                           THEN SUM(TRADEQTY * MARKETRATE) / NULLIF(SUM(TRADEQTY), 0)
                                       END, ''), 
               RATE = SUM(TRADEQTY * MARKETRATE) / NULLIF(SUM(TRADEQTY), 0), 
               TRADE_AMOUNT = SUM(TRADEQTY * MARKETRATE), 
               BKG_UNIT = SUM(TRADEQTY * NBROKAPP) / NULLIF(SUM(TRADEQTY), 0), 
               NET_RATE = SUM(TRADEQTY * N_NETRATE) / NULLIF(SUM(TRADEQTY), 0), 
               BROKERAGE = SUM(TRADEQTY * NBROKAPP), 
               STT = SUM(INS_CHRG), 
               TO_TAX = SUM(TURN_TAX), 
               SEBI_TAX = SUM(SEBI_TAX), 
               STAMPDUTY = SUM(BROKER_CHRG), 
               SER_TAX = SUM(NSERTAX),
			   other_chrg=SUM(other_chrg),
               order_no,
			   S.sett_type
        FROM MSAJAG.DBO.SETTLEMENT S WITH(NOLOCK),MSAJAG.DBO.SETT_MST M
        WHERE AuctionPart NOT IN('ar', 'ap','fa')
		AND START_DATE >=@FROMDATE AND Start_date <=@TODATE +' 23:59'
		AND S.SETT_NO=M.SETT_NO AND S.SETT_TYPE =M.SETT_TYPE
		AND PARTY_CODE IN (SELECT * FROM #CLIENT2)
		GROUP BY CASE
                        WHEN PARTY_CODE LIKE '98%'
                        THEN SUBSTRING(PARTY_CODE, 3, LEN(PARTY_CODE))
                        ELSE PARTY_CODE
                    END,  
                 CONVERT(VARCHAR(11), SAUDA_DATE, 103), 
                 SCRIP_CD, 
                 BILLFLAG, 
                 SELL_BUY, 
                 TMark, 
                 S.SETT_NO, 
                 S.SETT_TYPE, 
                 S.Series, 
                 order_no, 
                 SAUDA_DATE


		UNION ALL

		        SELECT EXCHANGE = 'NSECM', 
               SETT_NO = S.SETT_NO, 
               PARTY_CODE=CASE
                        WHEN PARTY_CODE LIKE '98%'
                        THEN SUBSTRING(PARTY_CODE, 3, LEN(PARTY_CODE))
                        ELSE PARTY_CODE
                    END,  
               SAUDA_DATE = CAST(SAUDA_DATE AS DATE), 
               TRD_DT = CONVERT(VARCHAR(11), SAUDA_DATE, 103), 
               SCRIP_CD = LTRIM(RTRIM(SCRIP_CD)), 
               S.Series, 
               SCRIPName = '', 
               BILLFLAG, 
               Trade_Type = CASE
                                WHEN BILLFLAG IN('2', '3')
                                THEN 'Trading'
                                WHEN BILLFLAG IN('4', '5')
                                     AND S.Sett_type NOT IN('A', 'X')
                                THEN 'Delivery'
                                ELSE 'Auction'
                            END, 
               Buy_qty = ISNULL(CASE
                                    WHEN sell_buy = 1
                                    THEN SUM(Tradeqty)
                                END, ''), 
               BuyMarketRate = ISNULL(CASE
                                          WHEN sell_buy = 1
                                          THEN SUM(TRADEQTY * MARKETRATE) / NULLIF(SUM(TRADEQTY), 0)
                                      END, ''), 
               Sell_qty = ISNULL(CASE
                                     WHEN sell_buy = 2
                                     THEN SUM(Tradeqty)
                                 END, ''), 
               SellMarketRate = ISNULL(CASE
                                           WHEN sell_buy = 2
                                           THEN SUM(TRADEQTY * MARKETRATE) / NULLIF(SUM(TRADEQTY), 0)
                                       END, ''), 
               RATE = SUM(TRADEQTY * MARKETRATE) / NULLIF(SUM(TRADEQTY), 0), 
               TRADE_AMOUNT = SUM(TRADEQTY * MARKETRATE), 
               BKG_UNIT = SUM(TRADEQTY * NBROKAPP) / NULLIF(SUM(TRADEQTY), 0), 
               NET_RATE = SUM(TRADEQTY * N_NETRATE) / NULLIF(SUM(TRADEQTY), 0), 
               BROKERAGE = SUM(TRADEQTY * NBROKAPP), 
               STT = SUM(INS_CHRG), 
               TO_TAX = SUM(TURN_TAX), 
               SEBI_TAX = SUM(SEBI_TAX), 
               STAMPDUTY = SUM(BROKER_CHRG), 
               SER_TAX = SUM(NSERTAX),
			   other_chrg=SUM(other_chrg),
               order_no,
			   S.sett_type
        FROM MSAJAG.DBO.HISTORY S WITH(NOLOCK),MSAJAG.DBO.SETT_MST M
        WHERE AuctionPart NOT IN('ar', 'ap','fa')
		AND START_DATE >=@FROMDATE AND Start_date <=@TODATE +' 23:59'
		AND S.SETT_NO=M.SETT_NO AND S.SETT_TYPE =M.SETT_TYPE
		AND PARTY_CODE IN (SELECT * FROM #CLIENT2)
        GROUP BY CASE
                        WHEN PARTY_CODE LIKE '98%'
                        THEN SUBSTRING(PARTY_CODE, 3, LEN(PARTY_CODE))
                        ELSE PARTY_CODE
                    END,   
                 CONVERT(VARCHAR(11), SAUDA_DATE, 103), 
                 SCRIP_CD, 
                 BILLFLAG, 
                 SELL_BUY, 
                 TMark, 
                 S.SETT_NO, 
                 S.SETT_TYPE, 
                 S.Series, 
                 order_no, 
                 SAUDA_DATE

        UNION all
        SELECT EXCHANGE = 'NSECM', 
               SETT_NO = CD_SETT_NO, 
               CD_PARTY_CODE=CASE
                        WHEN CD_PARTY_CODE LIKE '98%'
                        THEN SUBSTRING(CD_PARTY_CODE, 3, LEN(CD_PARTY_CODE))
                        ELSE CD_PARTY_CODE
                    END,  
               CD_SAUDA_DATE = CAST(CD_SAUDA_DATE AS DATE), 
               TRD_DT = CONVERT(VARCHAR(11), CD_SAUDA_DATE, 103), 
               CD_SCRIP_CD, 
               CD_SERIES, 
               SCRIPName = '', 
               BILLFLAG = 0, 
               Trade_Type = CASE
                                WHEN CD_SCRIP_CD = 'BROKERAGE'
                                THEN 'BROKERAGE'
                                WHEN CD_SCRIP_CD <> 'BROKERAGE'
                                     AND (SUM(CD_DelBuyBrokerage) <> 0
                                          OR SUM(CD_DelSellBrokerage) <> 0)
                                THEN 'Delivery'
                                ELSE 'Trading'
                            END, 
               Buy_qty = 0, 
               0, 
               Sell_qty = 0, 
               0, 
               RATE = 0, 
               TRADE_AMOUNT = 0, 
               BKG_UNIT = 0, 
               NET_RATE = 0, 
               BROKERAGE = SUM(CD_TOTALBROKERAGE), 
               STT = 0, 
               TO_TAX = 0, 
               SEBI_TAX = 0, 
               STAMPDUTY = 0, 
               SER_TAX = SUM(CD_TotalSerTax), 
			   other_chrg=0,
               CD_order_no,
			   CD_Sett_Type
        FROM MSAJAG.DBO.CHARGES_DETAIL WITH(NOLOCK)
		WHERE CD_Sauda_Date >=@fromdate AND CD_Sauda_Date <=@todate + ' 23:59'
		AND CD_Party_Code   IN (SELECT * FROM #CLIENT2)
		GROUP BY CASE
                        WHEN CD_PARTY_CODE LIKE '98%'
                        THEN SUBSTRING(CD_PARTY_CODE, 3, LEN(CD_PARTY_CODE))
                        ELSE CD_PARTY_CODE
                    END,  
                 CONVERT(VARCHAR(11), cd_SAUDA_DATE, 103), 
                 CD_SCRIP_CD, 
                 CD_SETT_NO, 
                 CD_SERIES, 
                 CD_order_no, 
                 CD_SAUDA_DATE,
				 CD_Sett_Type
    ) a
    GROUP BY EXCHANGE, 
             SETT_NO, 
             PARTY_CODE, 
             TRD_DT, 
             SCRIP_CD, 
             Trade_Type, 
             SAUDA_DATE,
			 SETT_TYPE

GO
