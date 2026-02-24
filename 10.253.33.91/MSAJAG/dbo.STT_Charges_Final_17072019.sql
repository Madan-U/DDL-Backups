-- Object: PROCEDURE dbo.STT_Charges_Final_17072019
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



  
  
  
     
                       
create PROC [dbo].[STT_Charges_Final_17072019] (                        
 @Sett_Type VARCHAR(2)                        
 ,@Sauda_Date VARCHAR(11)                        
 ,@FromParty VARCHAR(10)                        
 ,@ToParty VARCHAR(10)                        
 ,@fContract VARCHAR(7) = '0'                        
 ,@tContract VARCHAR(7) = '9999999'                        
 ,@processOn INT = 0                        
 )                        
AS                        
DECLARE @Party_Code VARCHAR(10)                        
 ,@Amt NUMERIC(18, 4)                        
 ,@Trade_No VARCHAR(14)                        
 ,@Order_No VARCHAR(16)                        
 ,@TrdBuyTrans NUMERIC(18, 4)                        
 ,@TrdSellTrans NUMERIC(18, 4)                        
 ,@DelBuyTrans NUMERIC(18, 4)                        
 ,@DelSellTrans NUMERIC(18, 4),                        
  @ETFSELLTRANS  NUMERIC(18,4)                        
 ,@SETTFLAG INT                        
 ,@ISETTFLAG INT                        
 ,@STTCur CURSOR                        
                        
SELECT @SETTFLAG = ISNULL(COUNT(1), 0)                        
FROM (                        
 SELECT TOP 1 *                        
 FROM SETTLEMENT                        
 WHERE SAUDA_DATE LIKE @SAUDA_DATE + '%'                        
  AND SETT_TYPE = @SETT_TYPE                        
  AND auctionpart NOT IN (                        
   'AP'                        
   ,'AR'                        
   ,'FP'                        
   ,'FL'                        
   ,'FA'                        
   ,'FC'                        
   )                        
  AND TRADE_NO NOT LIKE '%C%'                        
 ) A                        
                        
SELECT @ISETTFLAG = ISNULL(COUNT(1), 0)                        
FROM (                        
 SELECT TOP 1 *                        
 FROM ISETTLEMENT                        
 WHERE SAUDA_DATE LIKE @SAUDA_DATE + '%'                        
  AND SETT_TYPE = @SETT_TYPE                        
  AND TRADE_NO NOT LIKE '%C%'                        
 ) A                        
                        
IF @SETTFLAG = 1                        
 OR @ISETTFLAG = 1                        
BEGIN                        
 BEGIN TRAN                        
                        
 SELECT @TrdBuyTrans = 0                        
                        
 SELECT @TrdSellTrans = 0                        
                        
 SELECT @DelSellTrans = 0                        
                        
 SELECT @DelBuyTrans = 0                        
                        
 SELECT @ETFSELLTRANS = 0                        
                        
 TRUNCATE TABLE STT_AniSett_Temp                        
                        
 TRUNCATE TABLE STT_AniISett_Temp                        
                        
 TRUNCATE TABLE STT_AniSettOrg_Temp                        
                        
 TRUNCATE TABLE STT_SettSTTOrg_Temp                        
                        
 TRUNCATE TABLE STT_AniSettRound_Temp                        
                        
 TRUNCATE TABLE STT_SettSTTParty_Temp                        
                        
 TRUNCATE TABLE STT_AniSettRoundOrg_Temp                        
                         
 TRUNCATE TABLE STT_SettSTTPartyOrg_Temp                        
                        
 TRUNCATE TABLE STT_AniISettRound_Temp                        
                        
 TRUNCATE TABLE STT_ISettSTTParty_Temp                        
                        
 TRUNCATE TABLE STT_SETT_TABLE                        
                        
 TRUNCATE TABLE STT_ISETT_TABLE                        
                        
 /* NOW GETTING GLOBAL VALUES */                        
 SELECT @TrdBuyTrans = TrdBuyTrans                        
  ,@TrdSellTrans = TrdSellTrans                        
  ,@DelBuyTrans = DelBuyTrans                        
  ,@DelSellTrans = DelSellTrans                        
  ,@ETFSELLTRANS = ETFSELLTRANS                        
 FROM Globals                        
 WHERE year_start_dt <= @Sauda_Date                        
  AND year_end_dt >= @Sauda_Date                        
                        
 IF (                      
   @TrdBuyTrans > 0                        
   OR @TrdSellTrans > 0                        
   OR @DelSellTrans > 0                        
   OR @DelBuyTrans > 0                        
   OR @ETFSELLTRANS > 0                        
   )                        
 BEGIN                        
  SELECT @FROMPARTY = ISNULL(MIN(PARENTCODE), @FROMPARTY)                        
  FROM CLIENT2                        
  WHERE (                        
 PARTY_CODE >= @FROMPARTY                        
    AND PARTY_CODE <= @TOPARTY                        
    )                        
   OR (                        
    PARENTCODE >= @FROMPARTY                        
    AND PARENTCODE <= @TOPARTY                    )                        
                        
  SELECT @TOPARTY = ISNULL(MAX(PARENTCODE), @TOPARTY)                        
  FROM CLIENT2                        
  WHERE (                        
    PARTY_CODE >= @FROMPARTY                        
    AND PARTY_CODE <= @TOPARTY                 
    )                        
   OR (                        
    PARENTCODE >= @FROMPARTY                        
    AND PARENTCODE <= @TOPARTY                        
    )                        
                        
  TRUNCATE TABLE STT_SETTLEMENT                        
                        
  INSERT INTO STT_SETTLEMENT                  
  SELECT SrNo                        
   ,Contractno                        
   ,Billno                        
   ,Trade_No                        
   ,PARENTCODE                        
   ,Scrip_Cd                        
   ,User_Id                        
   ,Tradeqty                        
   ,Auctionpart                        
   ,Markettype                        
   ,Series                        
   ,Order_No                     
   ,Marketrate                        
   ,Sauda_Date                        
   ,S.Table_No                        
   ,Line_No                        
   ,Val_Perc                        
   ,Normal                        
   ,Day_Puc                        
   ,Day_Sales                        
   ,Sett_Purch                        
   ,Sett_Sales                        
   ,Sell_Buy                        
   ,Settflag                        
   ,Brokapplied                        
   ,Netrate                        
   ,Amount                        
   ,Ins_Chrg                        
   ,Turn_Tax                        
   ,S.Other_Chrg                        
   ,Sebi_Tax                        
   ,Broker_Chrg                        
   ,Service_Tax                        
   ,Trade_Amount                        
   ,Billflag                        
   ,Sett_No                        
   ,Nbrokapp                        
   ,Nsertax                        
   ,N_Netrate                        
   ,Sett_Type                        
   ,Partipantcode                        
   ,STATUS                        
   ,Pro_Cli                        
   ,Cpid                        
   ,Instrument                        
   ,Booktype                        
   ,Branch_Id                        
   ,Tmark                        
   ,Scheme = s.party_code                       
   ,S.Dummy1                        
   ,S.Dummy2                        
  FROM SETTLEMENT S                        
   ,CLIENT2 C2                        
  WHERE SAUDA_DATE LIKE @SAUDA_DATE + '%'                        
   AND S.PARTY_CODE = C2.PARTY_CODE                        
   AND PARENTCODE BETWEEN @FROMPARTY                        
    AND @TOPARTY                        
   AND CONTRACTNO BETWEEN @FCONTRACT                        
    AND @TCONTRACT                        
   AND AUCTIONPART NOT IN (                        
    'AP'                        
    ,'AR'                        
    ,'FP'                        
,'FL'                        
    ,'FA'                        
    ,'FC'                        
    )                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND TRADE_NO NOT LIKE '%C%'                        
                        
  EXEC RearrangeTrdflag_STT                        
                        
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                        
             
  INSERT INTO STT_SETT_TABLE                        
  SELECT Sauda_date                        
   ,ContractNo                        
   ,Trade_no                        
   ,Order_no                        
   ,sett_no                        
   ,sett_type                        
   ,Party_Code                        
   ,Scrip_Cd                        
   ,Series                        
   ,Sell_buy                        
   ,Tradeqty                        
   ,MarketRate                        
   ,AuctionPart                        
   ,User_id                        
   ,Settflag                        
   ,Ins_chrg = 0                        
   ,branch_id                        
   ,SRNO                        
  FROM STT_SETTLEMENT                      
                
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED             
          
        
                        
  INSERT INTO STT_ISETT_TABLE                        
  SELECT Sauda_date                        
   ,ContractNo                        
   ,Trade_no                        
   ,Order_no                        
   ,sett_no                        
   ,sett_type                        
   ,Party_Code                        
   ,Scrip_Cd                        
   ,Series                        
   ,Sell_buy                        
   ,Tradeqty                        
   ,MarketRate                        
   ,AuctionPart                        
   ,User_id                        
   ,Settflag                        
   ,Ins_chrg = 0                        
   ,branch_id                        
   ,SRNO                        
  FROM ISettlement WITH (                        
    INDEX (STT_INDEX)                        
    ,NOLOCK                        
    )                        
  WHERE sauda_date LIKE @Sauda_Date + '%'                        
   AND Party_Code BETWEEN @FromParty                        
    AND @ToParty                        
   AND ContractNo BETWEEN @fContract                        
    AND @tContract                        
   AND auctionpart NOT IN (                        
    'AP'                        
    ,'AR'                        
,'FP'                        
    ,'FL'                        
    ,'FA'                        
    ,'FC'                        
    )                        
   AND sett_type = @sett_type                        
   AND TRADE_NO NOT LIKE '%C%'                        
                        
  IF Upper(LTrim(RTrim(@Sett_Type))) = 'N'                        
   OR Upper(LTrim(RTrim(@Sett_Type))) = 'D'                        
   OR Upper(LTrim(RTrim(@Sett_Type))) = 'H'                        
   OR Upper(LTrim(RTrim(@Sett_Type))) = 'T'      
   OR Upper(LTrim(RTrim(@Sett_Type))) = 'BX'  
    Or Upper(LTrim(RTrim(@Sett_Type))) = 'DX'      
   OR Upper(LTrim(RTrim(@Sett_Type))) = 'TX'      
  -- OR Upper(LTrim(RTrim(@Sett_Type))) = 'BX'      
     
  BEGIN                        
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                        
                        
   INSERT INTO STT_AniSett_Temp                        
   SELECT Sett_No                        
    ,Sett_Type                        
    ,ContractNo                        
    ,Party_Code                        
    ,Scrip_CD                        
    ,Series                        
    ,TrdVal = Round(Sum(TradeQty * MarketRate) / Sum(TradeQty), 4)                        
   FROM STT_SETT_TABLE WITH (                        
     INDEX (STT_INDEX)                        
     ,NOLOCK                        
     )                        
   WHERE TradeQty > 0        
         
   GROUP BY Sett_No                        
    ,Sett_Type                        
    ,ContractNo                        
    ,Party_Code                        
    ,Scrip_CD                        
    ,Series          
            
                     
                       
   UPDATE STT_SETT_TABLE                        
   SET Ins_Chrg = (                        
     CASE                         
      WHEN STT_SETT_TABLE.settflag IN (                   
        1                        
        ,4                        
        ,5                        
        )                        
       THEN (                        
         CASE                         
          WHEN Sell_buy = 1                        
           THEN Round(TradeQty * TrdVal * @DelBuyTrans / 100, 4)                        
      ELSE Round(TradeQty * TrdVal * @DelSellTrans / 100, 4)                        
          END                        
         )                        
      WHEN STT_SETT_TABLE.SettFlag IN (                        
        2                        
        ,3                        
        )                        
       AND STT_SETT_TABLE.Sell_buy = 2                        
       THEN Round(TradeQty * TrdVal * @TrdSellTrans / 100, 4)                        
     ELSE 0                        
      END                        
     )                        
   FROM STT_AniSett_Temp A                        
   WHERE STT_SETT_TABLE.Sett_No = A.Sett_No                        
    AND STT_SETT_TABLE.Sett_Type = A.Sett_Type                        
    AND STT_SETT_TABLE.Party_Code = A.Party_Code                        
    AND STT_SETT_TABLE.Scrip_CD = A.Scrip_CD                        
    AND STT_SETT_TABLE.SERIES = A.SERIES                        
    AND STT_SETT_TABLE.ContractNo = A.ContractNo         
                        
    UPDATE STT_SETT_TABLE                                            
    SET                                             
     INS_CHRG = (CASE WHEN SELL_BUY = 1                                                
      THEN 0                                                
      ELSE ROUND(TRADEQTY * TRDVAL * @ETFSELLTRANS / 100,4)                                                
     END)                                    
    FROM                                             
     STT_ANISETT_TEMP A                                               
    WHERE                                             
     STT_SETT_TABLE.SETT_NO = A.SETT_NO                                         
     AND STT_SETT_TABLE.SETT_TYPE = A.SETT_TYPE                                                
     AND STT_SETT_TABLE.PARTY_CODE = A.PARTY_CODE                                               
     AND STT_SETT_TABLE.SCRIP_CD = A.SCRIP_CD                                                
     AND STT_SETT_TABLE.SERIES = A.SERIES                              
     AND STT_SETT_TABLE.CONTRACTNO = A.CONTRACTNO                                               
     -- AND STT_SETT_TABLE.TRADE_NO NOT LIKE '%C%'                       
  AND STT_SETT_TABLE.SETTFLAG IN (1,4,5)                         
  AND exists (SELECT SCRIP_CD FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO                         
          AND STT_SETT_TABLE.SCRIP_CD = TBL_STT_SCRIP.SCRIP_CD AND STT_SETT_TABLE.SERIES = TBL_STT_SCRIP.SERIES AND CHARGE_FLAG = 1)                        
  AND @ETFSELLTRANS > 0                        
                        
   -- INS SETTLEMENT                                                   
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                        
                        
   INSERT INTO STT_AniISett_Temp                        
   SELECT Sett_No                        
    ,Sett_Type                        
    ,ContractNo                        
    ,Party_Code                        
    ,Scrip_CD                        
    ,Series                        
    ,TrdVal = Round(Sum(TradeQty * MarketRate) / Sum(TradeQty), 4)             
   FROM STT_ISETT_TABLE WITH (                        
     INDEX (STT_INDEX)                        
     ,NOLOCK                        
     )                        
   WHERE TradeQty > 0                        
   -- And Trade_No Not Like '%C%'                                              
   GROUP BY Sett_No                        
    ,Sett_Type                        
    ,ContractNo                        
    ,Party_Code                        
    ,Scrip_CD                        
    ,Series                        
                        
   UPDATE STT_ISETT_TABLE                        
   SET Ins_Chrg = (                        
     CASE                         
      WHEN Sell_buy = 1                        
       THEN Round(TradeQty * TrdVal * @DelBuyTrans / 100, 4)                        
      ELSE Round(TradeQty * TrdVal * @DelSellTrans / 100, 4)                        
      END                        
     )                        
   FROM STT_AniISett_Temp A                        
   WHERE STT_ISETT_TABLE.Sett_No = A.Sett_No                        
    AND STT_ISETT_TABLE.Sett_Type = A.Sett_Type                        
    AND STT_ISETT_TABLE.Party_Code = A.Party_Code               
    AND STT_ISETT_TABLE.Scrip_CD = A.Scrip_CD                        
    AND STT_ISETT_TABLE.SERIES = A.SERIES                        
    -- And STT_ISETT_TABLE.Trade_No Not Like '%C%'                                                          
    AND STT_ISETT_TABLE.ContractNo = A.ContractNo                        
                        
    UPDATE STT_ISETT_TABLE                                             
    SET                                             
     INS_CHRG =  (CASE WHEN SELL_BUY = 1 THEN 0                                                
        ELSE ROUND(TRADEQTY * TRDVAL * @ETFSELLTRANS / 100,4)                                                
       END)                                                
    FROM STT_ANIISETT_TEMP A                                             
    WHERE                                             
     STT_ISETT_TABLE.SETT_NO = A.SETT_NO                                             
     AND STT_ISETT_TABLE.SETT_TYPE = A.SETT_TYPE                                                
     AND STT_ISETT_TABLE.PARTY_CODE = A.PARTY_CODE                                             
     AND STT_ISETT_TABLE.SCRIP_CD = A.SCRIP_CD                                                
     AND STT_ISETT_TABLE.SERIES = A.SERIES                              
     -- AND STT_ISETT_TABLE.TRADE_NO NOT LIKE '%C%'                                                
     AND STT_ISETT_TABLE.CONTRACTNO = A.CONTRACTNO                         
  AND exists (SELECT SCRIP_CD FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO                         
          AND STT_ISETT_TABLE.SCRIP_CD = TBL_STT_SCRIP.SCRIP_CD AND STT_ISETT_TABLE.SERIES = TBL_STT_SCRIP.SERIES AND CHARGE_FLAG = 1)                        
  AND @ETFSELLTRANS > 0                          
                        
   /* For Terminal Mapping */     
/*                          
   INSERT INTO STT_AniSettOrg_Temp                        
   SELECT Sett_No                        
    ,Sett_Type                        
    ,ContractNo                        
    ,Branch_id                        
    ,Party_Code                        
    ,Scrip_CD                        
    ,Series                        
    ,TrdVal = IsNull(Round(Sum(TradeQty * MarketRate) / Sum(TradeQty), 4), 0)                        
    ,PQtyDel = (                        
     CASE                         
      WHEN Sum(CASE                         
      WHEN Sell_Buy = 1                        
          THEN TradeQty                        
         ELSE 0                        
         END) > Sum(CASE                         
         WHEN Sell_Buy = 2                        
          THEN TradeQty                        
         ELSE 0                        
         END)                        
 THEN Sum(CASE                         
          WHEN Sell_Buy = 1                        
           THEN TradeQty                        
          ELSE 0                        
          END) - Sum(CASE                         
          WHEN Sell_Buy = 2                        
           THEN TradeQty                        
          ELSE 0                        
          END)                        
      ELSE 0                        
      END                        
     )                        
    ,SQtyDel = (                        
     CASE                         
      WHEN Sum(CASE                         
         WHEN Sell_Buy = 2                        
          THEN TradeQty                        
         ELSE 0                        
         END) > Sum(CASE                         
         WHEN Sell_Buy = 1                        
          THEN TradeQty                        
         ELSE 0                        
         END)                        
       THEN Sum(CASE                         
          WHEN Sell_Buy = 2                        
           THEN TradeQty           
          ELSE 0                        
          END) - Sum(CASE                         
          WHEN Sell_Buy = 1                        
           THEN TradeQty                        
          ELSE 0                        
          END)                        
      ELSE 0                        
      END                        
     )                        
    ,SQtyTrd = (                        
     CASE                         
      WHEN Sum(CASE                         
         WHEN Sell_Buy = 1                        
          THEN TradeQty                        
         ELSE 0                        
         END) >= Sum(CASE                         
         WHEN Sell_Buy = 2                        
          THEN TradeQty                        
         ELSE 0                        
         END)                        
       THEN Sum(CASE                         
          WHEN Sell_Buy = 2                        
           THEN TradeQty                        
          ELSE 0                        
          END)                        
      ELSE Sum(CASE                         
         WHEN Sell_Buy = 1                        
          THEN TradeQty                        
         ELSE 0                        
         END)                        
      END                        
     )                        
    ,PSTTDEL = Convert(NUMERIC(18, 4), 4)                        
    ,SSTTDEL = Convert(NUMERIC(18, 4), 4)                        
    ,SSTTTRD = Convert(NUMERIC(18, 4), 4)                        
    ,TotalTax = Convert(NUMERIC(18, 4), 4)                        
   FROM STT_SETT_TABLE WITH (                        
     INDEX (STT_INDEX)                        
     ,NOLOCK                        
     )                        
   WHERE TradeQty > 0                        
    --AND Trade_No Not Like '%C%'                                                               
    AND User_Id IN (                    
     SELECT UserId                        
     FROM TermParty                        
     WHERE UserId = ''                        
     )                        
   GROUP BY Sett_No                        
    ,Sett_Type                        
    ,ContractNo                        
    ,Branch_id                        
    ,Party_Code                        
    ,Scrip_CD                        
    ,Series                        
*/    
                        
   UPDATE STT_AniSettOrg_Temp                        
   SET PSTTDEL = Round(PQtyDel * TrdVal * @DelBuyTrans / 100, 4)                        
    ,SSTTDEL = Round(SQtyDel * TrdVal * @DelSellTrans / 100, 4)                        
    ,SSTTTRD = Round(SQtyTrd * TrdVal * @TrdSellTrans / 100, 4)                        
    ,TotalTax = Round(PQtyDel * TrdVal * @DelBuyTrans / 100, 4) + Round(SQtyDel * TrdVal * @DelSellTrans / 100, 4) + Round(SQtyTrd * TrdVal * @TrdSellTrans / 100, 4)                        
                        
 UPDATE STT_ANISETTORG_TEMP                                             
    SET PSTTDEL = 0, SSTTDEL  = ROUND(SQTYDEL*TRDVAL*@ETFSELLTRANS/100,4),                         
 TOTALTAX =  ROUND(SQTYDEL*TRDVAL*@ETFSELLTRANS/100,4) + SSTTTRD                        
 WHERE exists (SELECT SCRIP_CD FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO                         
          AND STT_ANISETTORG_TEMP.SCRIP_CD = TBL_STT_SCRIP.SCRIP_CD AND STT_ANISETTORG_TEMP.SERIES = TBL_STT_SCRIP.SERIES AND CHARGE_FLAG = 1)                        
 AND @ETFSELLTRANS > 0         
/*         
   INSERT INTO STT_SettSTTOrg_Temp                        
   SELECT Sett_No                        
    ,Sett_Type                        
 ,ContractNo                        
    ,Branch_id                        
    ,Party_Code                        
    ,Scrip_CD                        
    ,Series                        
    ,Trade_No = Min(SRNO)                        
   FROM STT_SETT_TABLE WITH (                        
     INDEX (STT_INDEX)                        
     ,NOLOCK                        
     )                        
   WHERE TradeQty > 0                        
    -- And Trade_No Not Like '%C%'                                           
    AND User_Id IN (                        
     SELECT UserId                        
     FROM TermParty                        
     WHERE UserId = ''                        
     )               GROUP BY Sett_No                        
    ,Sett_Type                        
    ,ContractNo                        
    ,Branch_id                        
    ,Party_Code                        
    ,Scrip_CD                        
    ,Series                        
*/    
    
/*                        
   UPDATE STT_SETT_TABLE                        
   SET Ins_Chrg = TotalTax                        
   FROM STT_AniSettOrg_Temp S                        
    ,STT_SettSttOrg_Temp A                        
   WHERE STT_SETT_TABLE.Sett_No = S.Sett_No                        
    AND STT_SETT_TABLE.Sett_Type = S.Sett_Type                        
    AND STT_SETT_TABLE.Scrip_Cd = S.Scrip_CD                        
    AND STT_SETT_TABLE.Series = S.Series                        
    AND STT_SETT_TABLE.Branch_id = S.Branch_id                        
 AND STT_SETT_TABLE.Sett_No = A.Sett_No                        
    AND STT_SETT_TABLE.Sett_Type = A.Sett_Type                        
    AND STT_SETT_TABLE.Scrip_Cd = A.Scrip_CD                        
    AND STT_SETT_TABLE.Series = A.Series                        
    AND STT_SETT_TABLE.Branch_id = A.Branch_Id                        
    -- And STT_SETT_TABLE.Trade_No Not Like '%C%'                                                   
    AND STT_SETT_TABLE.SRNO = A.Trade_No                        
    AND STT_SETT_TABLE.ContractNo = A.ContractNo                        
    AND User_Id IN (                        
     SELECT UserId                        
     FROM TermParty               WHERE UserId = ''                        
     )     
     */                       
  END                        
    
                        
  IF Upper(LTrim(RTrim(@Sett_Type))) = 'A'                        
   OR Upper(LTrim(RTrim(@Sett_Type))) = 'W'                        
   OR Upper(LTrim(RTrim(@Sett_Type))) = 'AD'                        
   OR Upper(LTrim(RTrim(@Sett_Type))) = 'C' 
   OR Upper(LTrim(RTrim(@Sett_Type))) = 'AF'                       
  BEGIN                        
   UPDATE STT_SETT_TABLE                        
   SET Ins_Chrg = (                        
    CASE                         
      WHEN Sell_buy = 1                        
       THEN Round(TradeQty * MarketRate * @DelBuyTrans / 100, 4)                        
      ELSE Round(TradeQty * MarketRate * @DelSellTrans / 100, 4)                        
      END                        
     )                        
   WHERE TradeQty > 0                        
                        
 UPDATE STT_SETT_TABLE          
    SET                                             
     INS_CHRG =  (CASE WHEN SELL_BUY = 1                                                 
        THEN 0                                            
        ELSE ROUND(TRADEQTY * MARKETRATE * @ETFSELLTRANS / 100,4)                                                
       END)                                                
    WHERE                                             
     exists (SELECT SCRIP_CD FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO                         
          AND STT_SETT_TABLE.SCRIP_CD = TBL_STT_SCRIP.SCRIP_CD AND STT_SETT_TABLE.SERIES = TBL_STT_SCRIP.SERIES AND CHARGE_FLAG = 1)                                            
    AND TRADEQTY > 0                                                
 AND @ETFSELLTRANS > 0                            
                        
   --And Trade_No Not Like '%C%'                                                      
   UPDATE STT_ISETT_TABLE                        
   SET Ins_Chrg = (                        
     CASE                         
      WHEN Sell_buy = 1                        
       THEN Round(TradeQty * MarketRate * @DelBuyTrans / 100, 4)                        
      ELSE Round(TradeQty * MarketRate * @DelSellTrans / 100, 4)                        
      END                        
     )                        
   WHERE TradeQty > 0        
    -- And Trade_No Not Like '%C%'                                                      
                        
 UPDATE STT_ISETT_TABLE                                             
    SET                                             
     INS_CHRG =  (CASE WHEN SELL_BUY = 1                                                 
        THEN 0                                            
        ELSE ROUND(TRADEQTY * MARKETRATE * @ETFSELLTRANS / 100,4)                                                
       END)                                                
    WHERE                                             
     exists (SELECT SCRIP_CD FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO                         
          AND STT_ISETT_TABLE.SCRIP_CD = TBL_STT_SCRIP.SCRIP_CD AND STT_ISETT_TABLE.SERIES = TBL_STT_SCRIP.SERIES AND CHARGE_FLAG = 1)                         
    AND TRADEQTY > 0                                                
 AND @ETFSELLTRANS > 0                           
                        
  END                        
      
  UPDATE STT_SETT_TABLE               
  SET Ins_chrg = 0       
  WHERE Left(Series, 1) NOT IN (                        
      'E'                        
      ,'B'                        
      ,'I'                        
      ,'X'                        
      ,'L'                        
      ,'S'          
      ,'R' ,  
      'D'             
      )         
                 
  UPDATE STT_SETT_TABLE               
  SET Ins_chrg = 0                   
  FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO                         
       AND STT_SETT_TABLE.SCRIP_CD = TBL_STT_SCRIP.SCRIP_CD AND STT_SETT_TABLE.SERIES = TBL_STT_SCRIP.SERIES AND CHARGE_FLAG = 0    
    
  UPDATE STT_ISETT_TABLE               
  SET Ins_chrg = 0       
  WHERE Left(Series, 1) NOT IN (                        
      'E'                        
      ,'B'                        
      ,'I'                        
      ,'X'                        
      ,'L'                        
      ,'S'          
      ,'R' ,  
      'D'             
      )         
                 
  UPDATE STT_ISETT_TABLE               
  SET Ins_chrg = 0                   
  FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO                         
       AND STT_ISETT_TABLE.SCRIP_CD = TBL_STT_SCRIP.SCRIP_CD     
       AND STT_ISETT_TABLE.SERIES = TBL_STT_SCRIP.SERIES AND CHARGE_FLAG = 0    
    
                        
  EXEC STT_InsertData_Detail @Sett_Type                        
   ,@Sauda_Date                        
   ,@FromParty                        
   ,@ToParty                        
                        
  IF Upper(LTrim(RTrim(@Sett_Type))) = 'N'                        
   OR Upper(LTrim(RTrim(@Sett_Type))) = 'D'                        
   OR Upper(LTrim(RTrim(@Sett_Type))) = 'H'                        
   OR Upper(LTrim(RTrim(@Sett_Type))) = 'T'      
   OR Upper(LTrim(RTrim(@Sett_Type))) = 'BX'  
    Or Upper(LTrim(RTrim(@Sett_Type))) = 'DX'      
   OR Upper(LTrim(RTrim(@Sett_Type))) = 'TX'      
   --OR Upper(LTrim(RTrim(@Sett_Type))) = 'BX'      
  BEGIN                        
   UPDATE STT_AniSettOrg_Temp                        
   SET TotalTax = 0                        
   WHERE (                        
     exists (SELECT SCRIP_CD FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO                         
           AND STT_ANISETTORG_TEMP.SCRIP_CD = TBL_STT_SCRIP.SCRIP_CD AND STT_ANISETTORG_TEMP.SERIES = TBL_STT_SCRIP.SERIES AND CHARGE_FLAG = 0))                                
    OR (                        
     Left(Series, 1) NOT IN (                        
      'E'                        
      ,'B'                        
      ,'I'                        
      ,'X'                        
      ,'L'                        
     ,'S'             
     ,'R' ,  
     'D'                    
      )                        
     )                        
                        
   INSERT INTO STT_ClientDetail                        
   SELECT 30                        
    ,Sett_no                        
    ,Sett_Type                        
    ,ContractNo                        
    ,Party_Code                        
    ,Scrip_Cd                        
 ,Series                        
    ,Sauda_Date = @Sauda_Date                        
    ,Branch_Id                        
    ,TrdVal                        
    ,PQtyDel                        
    ,PQtyDel * TrdVal                        
    ,PSttDel                        
    ,TrdVal                        
    ,SQtyDel                        
    ,SQtyDel * TrdVal                        
    ,SSttDel                        
    ,TrdVal                        
    ,SQtyTrd                        
    ,SQtyTrd * TrdVal                        
    ,SSttTrd                        
    ,TotalTax                        
   FROM STT_AniSettOrg_Temp                        
  END                        
                        
  /* Rounding for 1 Rs. Start with out terminal mapping */                        
  INSERT INTO STT_AniSettRound_Temp                        
  SELECT ContractNo                        
   ,Party_Code                        
   ,Sett_No                        
   ,Sett_Type                        
   ,ActChrg = Sum(ActChrg)                        
   ,TobeChrg = Round(Sum(TobeChrg), 0)                        
  FROM (                        
   SELECT ContractNo                        
    ,Party_Code                        
    ,Sett_No                        
    ,Sett_Type                        
    ,Scrip_Cd                        
    ,Series                        
    ,ActChrg = Sum(Ins_Chrg)                        
    ,TobeChrg = Sum(Ins_Chrg)                        
   FROM STT_SETT_TABLE WITH (                        
     INDEX (STT_INDEX)                        
     ,NOLOCK                        
     )                
   WHERE TradeQty > 0                        
    --And Trade_No Not Like '%C%'                                                          
                           
   GROUP BY ContractNo                        
    ,Party_Code                        
    ,Sett_No                        
    ,Sett_Type                        
    ,Scrip_Cd                        
    ,Series                        
   ) A                        
  GROUP BY ContractNo                        
   ,Party_Code                        
   ,Sett_No                        
   ,Sett_Type                        
                        
  INSERT INTO STT_SettSTTParty_Temp                        
  SELECT S.Sett_No                        
   ,S.Sett_Type                        
   ,S.ContractNo                        
   ,S.Party_Code                        
   ,Trade_No = Min(SRNO)                        
  FROM STT_SETT_TABLE s WITH (                        
    INDEX (STT_INDEX)                        
    ,NOLOCK                        
    )                        
   ,STT_AniSettRound_Temp A With(index(STT_rnd))                    
  WHERE A.Sett_No = S.Sett_No                        
   AND A.Sett_Type = S.Sett_Type                        
   AND A.Party_Code = S.Party_Code                        
   AND Ins_Chrg >= (                        
    CASE                         
     WHEN ToBeChrg - ActChrg < 0                        
      THEN abs(ToBeChrg - ActChrg)                        
     ELSE 0                        
     END                        
    )                        
   AND TradeQty > 0                        
   -- And Trade_No Not Like '%C%'                                                           
   AND Ins_Chrg > 0                        
   AND S.ContractNo = A.ContractNo                        
   AND S.ContractNo = A.ContractNo                        
  --And User_Id Not In ( Select UserId From TermParty Where UserId = '')---commited by suresh                                                
  GROUP BY S.Sett_No                       
   ,S.Sett_Type                        
   ,S.ContractNo                        
   ,S.Party_Code                        
                        
  UPDATE STT_SETT_TABLE                        
  SET Ins_Chrg = Ins_Chrg + (ToBeChrg - ActChrg)                        
  FROM STT_SettSTTParty_Temp A(NOLOCK)                        
   ,STT_AniSettRound_Temp S With(index(STT_rnd))  
  WHERE STT_SETT_TABLE.Sett_No = A.Sett_No                        
   AND STT_SETT_TABLE.Sett_Type = A.Sett_Type                        
   AND STT_SETT_TABLE.Party_Code = A.Party_Code                        
   AND STT_SETT_TABLE.Sett_No = S.Sett_No                        
   AND STT_SETT_TABLE.Sett_Type = S.Sett_Type                        
   AND STT_SETT_TABLE.Party_Code = S.Party_Code                        
   AND STT_SETT_TABLE.SRNO = A.Trade_No                        
   AND STT_SETT_TABLE.ContractNo = A.ContractNo                        
   AND S.ContractNo = A.ContractNo                        
   AND STT_SETT_TABLE.TradeQty > 0                        
   /*AND User_Id NOT IN (                        
    SELECT UserId                        
    FROM TermParty                        
    WHERE UserId = ''                        
    )  */                      
                        
  UPDATE STT_SETT_TABLE                        
  SET Ins_Chrg = 0                        
    FROM STT_AniSettRound_Temp A With(index(STT_rnd))                     
    WHERE STT_SETT_TABLE.Sett_No = A.Sett_No                        
     AND STT_SETT_TABLE.Sett_Type = A.Sett_Type                        
     AND STT_SETT_TABLE.Party_Code = A.Party_Code                        
     AND STT_SETT_TABLE.ContractNo = A.ContractNo                        
     AND TobeChrg = 0                        
  and TradeQty > 0                        
  /* AND User_Id NOT IN               
   (                        
    SELECT UserId                        
    FROM TermParty                        
    WHERE UserId = ''                     
 )*/               
  
   --And Trade_No Not Like '%C%'                                                                 
                        
  /* Rounding for 1 Rs. End Normal Clients with out terminal mapping*/                        
  /* Rounding for 1 Rs. Start Here with terminal mapping */         
  /*                   
  INSERT INTO STT_AniSettRoundOrg_Temp                        
  SELECT ContractNo                        
   ,Branch_Id                        
   ,Party_Code                        
   ,Sett_No                        
   ,Sett_Type                        
   ,ActChrg = Sum(ActChrg)                        
   ,TobeChrg = Round(Sum(TobeChrg), 0)       
  FROM (                        
   SELECT ContractNo                        
    ,Branch_Id                        
    ,Party_Code                        
    ,Sett_No                        
    ,Sett_Type                        
    ,Scrip_Cd                        
    ,Series                        
    ,ActChrg = Sum(Ins_Chrg)                        
    ,TobeChrg = Sum(Ins_Chrg)                        
   FROM STT_SETT_TABLE WITH (                        
     INDEX (STT_INDEX)                        
     ,NOLOCK                        
     )                        
   WHERE TradeQty > 0                        
    --And Trade_No Not Like '%C%'                                                           
    AND User_Id IN (                        
     SELECT UserId                        
     FROM TermParty                        
     WHERE UserId = ''                        
     )                        
   GROUP BY ContractNo                        
    ,Branch_Id                        
    ,Party_Code                        
    ,Sett_No                        
    ,Sett_Type                        
    ,Scrip_Cd                        
    ,Series                        
   ) A                        
  GROUP BY ContractNo                        
   ,Branch_Id                        
   ,Party_Code                        
   ,Sett_No                        
   ,Sett_Type                        
*/    
/*                        
  INSERT INTO STT_SettSTTPartyOrg_Temp                        
  SELECT S.Sett_No                       
   ,S.Sett_Type                        
   ,S.ContractNo                        
   ,S.Branch_Id                        
   ,S.Party_Code                        
   ,Trade_No = Min(SRNO)                        
  FROM STT_SETT_TABLE S(NOLOCK)                        
   ,STT_AniSettRoundOrg_Temp A                        
  WHERE A.Sett_Type = S.Sett_Type                        
   AND A.Sett_No = S.Sett_No                        
   AND A.Branch_Id = S.Branch_Id                        
   AND Ins_Chrg >= (                        
    CASE                
     WHEN ToBeChrg - ActChrg < 0                        
      THEN abs(ToBeChrg - ActChrg)                        
     ELSE 0                        
     END                        
    )                        
   AND Ins_Chrg > 0                        
   AND S.ContractNo = A.ContractNo                        
   AND s.TradeQty > 0                        
   -- And Trade_No Not Like '%C%'                                                           
   AND User_Id IN (                        
    SELECT UserId                        
    FROM TermParty                        
    WHERE UserId = ''                        
    )                        
  GROUP BY S.Sett_No                        
   ,S.Sett_Type                        
   ,S.ContractNo                        
   ,S.Branch_Id                        
   ,S.Party_Code                 
*/    
                        
  UPDATE STT_SETT_TABLE                        
  SET Ins_Chrg = Ins_Chrg + (ToBeChrg - ActChrg)                        
  FROM STT_SettSTTPartyOrg_Temp A                        
   ,STT_AniSettRoundOrg_Temp S                        
  WHERE STT_SETT_TABLE.Sett_No = A.Sett_No                        
   AND STT_SETT_TABLE.Sett_Type = A.Sett_Type           
   AND STT_SETT_TABLE.Branch_id = A.Branch_Id                        
   -- And STT_SETT_TABLE.Sett_No = S.Sett_No   ----commited by suresh                                                       
   -- And STT_SETT_TABLE.Sett_Type = S.Sett_Type  ----commited by suresh                                                                  
   -- And STT_SETT_TABLE.Branch_id = S.Branch_Id  ----commited by suresh                                                                   
   AND STT_SETT_TABLE.SRNO = A.Trade_No                        
   AND STT_SETT_TABLE.TradeQty > 0                        
   --And STT_SETT_TABLE.Trade_No Not Like '%C%'              
   AND STT_SETT_TABLE.ContractNo = A.ContractNo                        
                        
  --And S.ContractNo = A.ContractNo                                                          
  -- And User_Id In ( Select UserId From TermParty Where UserId = '')   ----commited by suresh    
  /*                                                                 
  UPDATE STT_SETT_TABLE                        
  SET Ins_Chrg = 0                        
  WHERE Branch_Id IN (                        
    SELECT Branch_Id                        
    FROM STT_AniSettRoundOrg_Temp A                        
    WHERE STT_SETT_TABLE.Sett_No = A.Sett_No                        
     AND STT_SETT_TABLE.Sett_Type = A.Sett_Type                        
     AND STT_SETT_TABLE.Branch_Id = A.Branch_Id                        
     AND STT_SETT_TABLE.ContractNo = A.ContractNo                        
     AND TobeChrg = 0                        
    )                        
   AND TradeQty > 0                        
   --And Trade_No Not Like '%C%'                                                           
   AND User_Id IN (                        
    SELECT UserId                        
    FROM TermParty                        
   WHERE UserId = ''                        
    )                        
*/    
                        
  /* Rounding for 1 Rs. End Here with terminal mapping */                        
  /* Rounding for 1 Rs. Start Here For Inst Trades */                        
  INSERT INTO STT_AniISettRound_Temp                        
  SELECT ContractNo               
   ,Party_Code                        
   ,Sett_No                        
   ,Sett_Type                        
   ,ActChrg = Sum(ActChrg)                        
   ,TobeChrg = Round(Sum(round(TobeChrg, 2)), 0)                        
  FROM (                        
   SELECT ContractNo                        
    ,Party_Code                        
    ,Sett_No                        
    ,Sett_Type                        
    ,Scrip_Cd                        
    ,Series                        
    ,ActChrg = Sum(Ins_Chrg)                        
    ,TobeChrg = Sum(Ins_Chrg)                        
   FROM STT_ISETT_TABLE WITH (                        
 INDEX (STT_INDEX)                        
     ,NOLOCK                        
     )                        
   WHERE TradeQty > 0                        
   --And Trade_No Not Like '%C%'                                                           
   GROUP BY ContractNo                        
    ,Party_Code                        
    ,Sett_No                        
    ,Sett_Type                        
    ,Scrip_Cd                        
    ,Series                        
   ) A                        
  GROUP BY ContractNo                        
   ,Party_Code                        
   ,Sett_No                        
   ,Sett_Type                        
                        
  INSERT INTO STT_ISettSTTParty_Temp                        
  SELECT S.Sett_No                        
   ,S.Sett_Type                        
   ,S.ContractNo                        
   ,S.Party_Code                        
   ,Trade_No = Min(SRNO)                        
  FROM STT_ISETT_TABLE S WITH (                        
    INDEX (STT_INDEX)                        
    ,NOLOCK                        
    )                        
   ,STT_AniISettRound_Temp A                        
  WHERE A.Sett_Type = S.Sett_Type                        
   AND A.Sett_No = S.Sett_No                        
   AND A.Party_Code = S.Party_Code                        
   AND Ins_Chrg >= (                        
    CASE                         
     WHEN ToBeChrg - ActChrg < 0                        
      THEN abs(ToBeChrg - ActChrg)                        
     ELSE 0                        
     END                        
    )                
   AND Ins_Chrg > 0                        
   AND TradeQty > 0                        
   --And S.Trade_No Not Like '%C%'            
   AND S.ContractNo = A.ContractNo                        
  GROUP BY S.Sett_No                        
   ,S.Sett_Type                        
  ,S.ContractNo                        
   ,S.Party_Code                        
                        
  UPDATE STT_ISETT_TABLE                        
  SET Ins_Chrg = Ins_Chrg + (ToBeChrg - ActChrg)                        
  FROM STT_ISettSTTParty_Temp A                        
   ,STT_AniISettRound_Temp S                        
  WHERE STT_ISETT_TABLE.Sett_No = A.Sett_No                        
   AND STT_ISETT_TABLE.Sett_Type = A.Sett_Type                        
   AND STT_ISETT_TABLE.Party_Code = A.Party_Code                        
   AND STT_ISETT_TABLE.Sett_No = S.Sett_No                        
   AND STT_ISETT_TABLE.Sett_Type = S.Sett_Type                        
   AND STT_ISETT_TABLE.Party_Code = S.Party_Code                        
   AND STT_ISETT_TABLE.SRNO = A.Trade_No                        
   AND STT_ISETT_TABLE.ContractNo = S.ContractNo                        
   AND TradeQty > 0                        
   --And STT_ISETT_TABLE.Trade_No Not Like '%C%'                                                           
   AND A.ContractNo = S.ContractNo                        
                        
  UPDATE STT_ISETT_TABLE                        
  SET Ins_Chrg = 0                        
  WHERE Party_Code IN (                        
    SELECT Party_Code                        
    FROM STT_AniISettRound_Temp A                        
    WHERE STT_ISETT_TABLE.Sett_No = A.Sett_No                        
     AND STT_ISETT_TABLE.Sett_Type = A.Sett_Type                        
     AND STT_ISETT_TABLE.Party_Code = A.Party_Code                        
     AND STT_ISETT_TABLE.ContractNo = A.ContractNo                        
     AND TobeChrg = 0                        
    )                        
   AND TradeQty > 0                        
   --And Trade_No Not Like '%C%'     
   /*                                                          
   AND User_Id NOT IN (                        
    SELECT UserId                        
    FROM TermParty                        
    WHERE UserId = ''                        
    )    */    
                        
  EXEC Stt_rounding_further @Sett_Type                        
   ,@Sauda_Date                        
   ,@FromParty                   
   ,@ToParty                        
                
  /* Rounding for 1 Rs. End Here For Inst Trades */                        
  EXEC STT_InsertData_Summary @Sett_Type                        
   ,@Sauda_Date                        
   ,@FromParty                        
   ,@ToParty                        
                        
                   
                  
SELECT DISTINCT PARTY_CODE  
INTO #SETT                            
FROM STT_SETT_TABLE                     
                  
INSERT INTO #SETT                            
SELECT DISTINCT PARTY_CODE  
FROM STT_ISETT_TABLE                    
  
CREATE CLUSTERED INDEX PARTYIDX ON #SETT (PARTY_CODE)  
  
TRUNCATE TABLE TRD_CLIENTTAXES_NEW                      
INSERT INTO TRD_CLIENTTAXES_NEW                            
SELECT C.*  FROM CLIENTTAXES_NEW C                      
WHERE @SAUDA_DATE BETWEEN FROMDATE AND TODATE                   
AND EXISTS (SELECT PARTY_CODE FROM #SETT   
   WHERE #SETT.PARTY_CODE = C.PARTY_CODE)                      
AND Insurance_Chrg = 0                   
/*                            
select * into #ClientTaxes_New                      
from clienttaxes_new where @Sauda_Date BETWEEN FromDate                        
   AND ToDate      AND Insurance_Chrg = 0                     
*/                  
                        
  UPDATE STT_SETT_TABLE                        
  SET Ins_Chrg = 0                        
  FROM TRD_CLIENTTAXES_NEW C                        
  WHERE STT_SETT_TABLE.Sauda_Date BETWEEN FromDate AND ToDate                             
   AND STT_SETT_TABLE.Party_Code = C.Party_Code                    
   AND TradeQty > 0            
   AND Insurance_Chrg = 0                        
                        
  UPDATE STT_ISETT_TABLE                        
  SET Ins_Chrg = 0                        
  FROM TRD_CLIENTTAXES_NEW C                        
 WHERE STT_ISETT_TABLE.Sauda_Date BETWEEN FromDate AND ToDate                       
   AND STT_ISETT_TABLE.Party_Code = C.Party_Code                    
   AND TradeQty > 0                        
   AND Insurance_Chrg = 0                        
                        
  /* NOW FINAL UPDATE IN SETTLEMENT TABLE*/                        
  UPDATE STT_SETTLEMENT                        
  SET Ins_Chrg = A.INS_CHRG                        
  FROM STT_SETT_TABLE A WITH                 
  (                
  --INDEX (STT_INDEX),                
    NOLOCK                        
    )                        
  WHERE STT_SETTLEMENT.SRNO = A.SRNO                        
                  
                    
  UPDATE SETTLEMENT                        
  SET INS_CHRG = A.INS_CHRG                        
  FROM (                        
   SELECT ORGSRNO                        
    ,INS_CHRG = SUM(INS_CHRG)                        
   FROM STT_SETTLEMENT                        
   GROUP BY ORGSRNO                        
   ) A                        
  WHERE SETTLEMENT.SRNO = A.ORGSRNO                        
                        
  UPDATE ISettlement                        
  SET Ins_Chrg = A.INS_CHRG                        
  FROM STT_ISETT_TABLE A WITH (                        
    INDEX (STT_INDEX)                        
    ,NOLOCK                        
    )                        
  WHERE ISettlement.SRNO = A.SRNO                        
                        
  /* PROCEDURE ENDS */                        
  TRUNCATE TABLE STT_SETT_TABLE                        
                        
  TRUNCATE TABLE STT_ISETT_TABLE                        
 END                        
                        
 EXEC PROC_TURNTAX_EXCEPTION @SETT_TYPE                        
  ,@SAUDA_DATE --add by umesh        
        
        
 EXEC BBGSETTBROKRECAL_ONLINE @Sett_Type  --- ADDED ON MAR 27 2015            
      
  ,@Sauda_Date              
      
  ,@FromParty              
      
  ,@ToParty      
                                            
                        
 EXEC PROC_SERVICE_TAX_UPDATE @Sett_Type                        
  ,@Sauda_Date                        
  ,@FromParty             
  ,@ToParty                        
                        
 EXEC CALCULATE_STAMP_DUTY @SETT_TYPE                        
  ,@SAUDA_DATE                        
  ,@FROMPARTY                        
  ,@TOPARTY                        
                        
 COMMIT                        
END

GO
