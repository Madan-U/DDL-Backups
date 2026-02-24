-- Object: PROCEDURE dbo.ProcRemisierBrokerageSharing
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE ProcRemisierBrokerageSharing                        
(  
 @Sett_No Varchar(7),   
 @Sett_Type Varchar(2)  
)                        
AS                        
BEGIN  
 --SET NOCOUNT ON                         
 DECLARE   
  @FromDate Varchar(11),                        
  @ToDate       Varchar(11),                        
  @Funds_Payin  Varchar(11),                         
  @Funds_Payout Varchar(11),                        
  @TDSPercentage  NUMERIC(10,4)  
  
 SELECT  @FromDate  = Left(Start_Date,11),              
  @ToDate    = Left(End_Date,11),                        
  @Funds_Payin    = Left(Funds_Payin,11),                        
  @Funds_Payout   = Left(Funds_Payout,11),  
  @TDSPercentage = ISNULL(TDSPercentage, 5.61)  
 FROM REM_SETT_MST                         
 WHERE SETT_NO = @SETT_NO                        
 AND SETT_TYPE = @SETT_TYPE                        
   AND ISNULL(STATUS, '') <> 'C'  
  
 --- For the given settlement is not in open position then do not calculate the remisier brokerage sharing             
 IF @FromDate IS NULL  
  RETURN  
  
 --- Check For the selected settlement whether the bill has been posted or not?   
 IF EXISTS (SELECT 1 FROM REM_ACCBILL WHERE BROK_SHARED_SETTNO = @SETT_NO AND BILL_POSTED = 1)  
  RETURN  
  
 BEGIN TRANSACTION RemisierBrokerage  
  
 SELECT DISTINCT B.* INTO #BROKTABLE                         
  FROM NSEFO.DBO.BROKTABLE B, RemisierBrokerageMaster RM, RemisierBrokerageScheme R                        
  WHERE R.FutTableNo = Table_No                        
  or R.OptTableNo = Table_No                        
  or R.OptExTableNo = Table_No                        
  or R.FutFinalTableNo = Table_No                        
  And (RM.Segment = 'FUTURES' OR RM.Segment = 'ALL')  
  And RM.SchemeID = R.SchemeID                       
  AND RM.FromDate BETWEEN @FromDate AND @ToDate  
  
print @FromDate   
print @ToDate  
/*
 ---- Remisier All Party List  
 SELECT  
  R.RemType,   
  R.RemPartyCd,  
  R.SchemeOrSlab,  
  C1.Branch_Cd AS BranchCode,   
  C1.Sub_Broker AS SubBroker,   
  C2.Party_Code AS PartyCode,    
  R.SchemeID,   
  R.FromDate,   
  R.ToDate,  
  R.Segment,  
  R.BrokType  
 INTO #RemisierAllParty  
 FROM RemisierBrokerageMaster R, Client1 AS C1, Client2 AS C2   
 WHERE   
  C1.Cl_Code = C2.Cl_Code  
  AND C1.Branch_Cd = CASE  WHEN R.RemType = 'BR' THEN R.RemCode ELSE C1.Branch_Cd END  
  AND C1.Sub_Broker = CASE WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN R.RemCode  
           ELSE C1.Sub_Broker END  
  AND C2.Party_Code = CASE WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN C2.Party_Code   
           WHEN R.RemType = 'BR' THEN C2.Party_Code END  
  AND R.EntityCode = 'ALL'   
  --AND R.FromDate BETWEEN @FromDate AND @ToDate  
  AND R.FromDate<=@FromDate AND @ToDate <= R.ToDate  
   
 --- Remisier Specific Party List  
 SELECT   
  R.RemType,  
  R.RemPartyCd,  
  R.SchemeOrSlab,  
  C1.Branch_Cd AS BranchCode,   
  C1.Sub_Broker AS SubBroker,   
  C2.Party_Code AS PartyCode,    
  R.SchemeID,   
  R.FromDate,   
  R.ToDate,  
  R.Segment,  
  R.BrokType  
 INTO #RemisierSpecificParty  
 FROM RemisierBrokerageMaster R, Client1 AS C1, Client2 AS C2  
 WHERE   
  C1.Cl_Code = C2.Cl_Code  
  AND C1.Branch_Cd = CASE WHEN R.RemType = 'BR' THEN R.RemCode ELSE C1.Branch_Cd END  
  AND C1.Sub_Broker = CASE --WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN R.RemCode  
             WHEN R.RemType = 'SUB' AND R.EntityCode <> 'ALL' THEN C1.Sub_Broker  
             WHEN R.RemType = 'BR'  AND R.EntityCode <> 'ALL' THEN R.EntityCode   
           ELSE C1.Sub_Broker END  
  AND C2.Party_Code = CASE --WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN C2.Party_Code   
           WHEN R.RemType = 'SUB' AND R.EntityCode <> 'ALL' THEN R.EntityCode  
           WHEN R.RemType = 'BR' THEN C2.Party_Code END  
  AND R.EntityCode <> 'ALL'   
  --AND R.FromDate BETWEEN @FromDate AND @ToDate  
 AND R.FromDate<=@FromDate AND @ToDate <= R.ToDate  
  
 --- Remisier Blocked Partt List  
 SELECT   
  CASE R.RemType WHEN 'PARTY' THEN 'SUB'   
       WHEN 'SUB' THEN 'BR'  
       WHEN 'BR' THEN 'BR'   
  END AS SubBrokerOrBranch,  
  C1.Branch_Cd AS BranchCode,   
  C1.Sub_Broker AS SubBroker,   
  C2.Party_Code AS PartyCode,    
  R.FromDate,   
  R.ToDate,  
  R.Segment  
 INTO #RemisierBlockedParty  
 FROM RemisierBrokerageBlocked R, Client1 AS C1, Client2 AS C2  
 WHERE   
  C1.Cl_Code = C2.Cl_Code  
  AND C1.Branch_Cd =  CASE WHEN R.RemType = 'BR' THEN R.RemCode ELSE C1.Branch_Cd END  
  AND C1.Sub_Broker = CASE WHEN R.RemType = 'SUB' THEN R.RemCode ELSE C1.Sub_Broker END  
  AND C2.Party_Code = CASE WHEN R.RemType = 'PARTY' THEN R.RemCode ELSE C2.Party_Code END  
  --AND R.FromDate BETWEEN @FromDate AND @ToDate  
  AND R.FromDate<=@FromDate AND @ToDate <= R.ToDate  
*/

 SELECT  
  R.RemType,   
  R.RemPartyCd,  
  R.SchemeOrSlab,  
  C1.Branch_Cd AS BranchCode,   
  C1.Sub_Broker AS SubBroker,   
  C1.Party_Code AS PartyCode,    
  R.SchemeID,   
  R.FromDate,   
  R.ToDate,  
  R.Segment,  
  R.BrokType  
 INTO #RemisierAllParty  
 FROM RemisierBrokerageMaster R, Client_Details AS C1   
 WHERE   
  C1.Cl_Code = C1.Cl_Code  
  AND C1.Branch_Cd = CASE  WHEN R.RemType = 'BR' THEN R.RemCode ELSE C1.Branch_Cd END  
  AND C1.Sub_Broker = CASE WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN R.RemCode  
           ELSE C1.Sub_Broker END  
  AND C1.Party_Code = CASE WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN C1.Party_Code   
           WHEN R.RemType = 'BR' THEN C1.Party_Code END  
  AND R.EntityCode = 'ALL'   
  --AND R.FromDate BETWEEN @FromDate AND @ToDate  
  AND R.FromDate<=@FromDate AND @ToDate <= R.ToDate  
   
 --- Remisier Specific Party List  
 SELECT   
  R.RemType,  
  R.RemPartyCd,  
  R.SchemeOrSlab,  
  C1.Branch_Cd AS BranchCode,   
  C1.Sub_Broker AS SubBroker,   
  C1.Party_Code AS PartyCode,    
  R.SchemeID,   
  R.FromDate,   
  R.ToDate,  
  R.Segment,  
  R.BrokType  
 INTO #RemisierSpecificParty  
 FROM RemisierBrokerageMaster R, Client_Details AS C1 
 WHERE   
  C1.Cl_Code = C1.Cl_Code  
  AND C1.Branch_Cd = CASE WHEN R.RemType = 'BR' THEN R.RemCode ELSE C1.Branch_Cd END  
  AND C1.Sub_Broker = CASE --WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN R.RemCode  
             WHEN R.RemType = 'SUB' AND R.EntityCode <> 'ALL' THEN C1.Sub_Broker  
             WHEN R.RemType = 'BR'  AND R.EntityCode <> 'ALL' THEN R.EntityCode   
           ELSE C1.Sub_Broker END  
  AND C1.Party_Code = CASE --WHEN R.RemType = 'SUB' AND R.EntityCode = 'ALL' THEN C1.Party_Code   
           WHEN R.RemType = 'SUB' AND R.EntityCode <> 'ALL' THEN R.EntityCode  
           WHEN R.RemType = 'BR' THEN C1.Party_Code END  
  AND R.EntityCode <> 'ALL'   
  --AND R.FromDate BETWEEN @FromDate AND @ToDate  
 AND R.FromDate<=@FromDate AND @ToDate <= R.ToDate  
  
 --- Remisier Blocked Partt List  
 SELECT   
  CASE R.RemType WHEN 'PARTY' THEN 'SUB'   
       WHEN 'SUB' THEN 'BR'  
       WHEN 'BR' THEN 'BR'   
  END AS SubBrokerOrBranch,  
  C1.Branch_Cd AS BranchCode,   
  C1.Sub_Broker AS SubBroker,   
  C1.Party_Code AS PartyCode,    
  R.FromDate,   
  R.ToDate,  
  R.Segment  
 INTO #RemisierBlockedParty  
 FROM RemisierBrokerageBlocked R, Client_Details AS C1 
 WHERE   
  C1.Cl_Code = C1.Cl_Code  
  AND C1.Branch_Cd =  CASE WHEN R.RemType = 'BR' THEN R.RemCode ELSE C1.Branch_Cd END  
  AND C1.Sub_Broker = CASE WHEN R.RemType = 'SUB' THEN R.RemCode ELSE C1.Sub_Broker END  
  AND C1.Party_Code = CASE WHEN R.RemType = 'PARTY' THEN R.RemCode ELSE C1.Party_Code END  
  --AND R.FromDate BETWEEN @FromDate AND @ToDate  
  AND R.FromDate<=@FromDate AND @ToDate <= R.ToDate  
  
 --- All Remisier Party List  
 SELECT PartyCode INTO #PARTYLIST FROM #RemisierAllParty   
 UNION   
 SELECT PartyCode FROM #RemisierSpecificParty  
  
Select * from #PARTYLIST  
  
 --- Data From BSEDB.SETTLEMENT  
 SELECT S.SETT_NO,                        
        S.SETT_TYPE,                        
        S.PARTY_CODE,                        
        S.SCRIP_CD,                        
        S.SERIES,                        
        S.SAUDA_DATE,                        
        S.TRADE_NO,                        
        S.ORDER_NO,                        
        S.SELL_BUY,                        
        S.TRADEQTY,                        
        S.MARKETRATE,                        
        BROKAPPLIED,                        
        NBROKAPP,                        
        BILLFLAG,                        
        REMCODE = SUB_BROKER,                        
        BRANCH_CD,                        
        REM_BROKAPPLIED = CONVERT(NUMERIC(18,4),0),                        
        REM_NBROKAPP = CONVERT(NUMERIC(18,4),0),                        
        STATUS = '0',                        
        SLABTYPE = CONVERT(VARCHAR(10),''),                        
        FROMDATE = CONVERT(DATETIME,@FromDate),                        
        TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                        
        REMPARTYCD = CONVERT(VARCHAR(10),''),                    
        EXCHANGEID = 'BSECM',    
    SCHEMEID = CONVERT(INT, 0),  
    SCHEMEORSLAB = CONVERT(VARCHAR(7),''),  -- SCHEME/SLAB  
    REMTYPE = CONVERT(VARCHAR(3),'')    -- SUB/BR  
   -- BROKTYPE = CONVERT(VARCHAR(10),'')        -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT  
 INTO   #REMBROK                        
 FROM   BSEDB.DBO.CLIENT1 C1,                        
        BSEDB.DBO.CLIENT2 C2,                        
        BSEDB.DBO.SETTLEMENT S,   
    #PARTYLIST P  
 WHERE    
   S.SAUDA_DATE >= @FromDate                        
        AND S.SAUDA_DATE <= @ToDate + ' 23:59'                        
       AND C1.CL_CODE = C2.CL_CODE                        
       AND C2.PARTY_CODE = S.PARTY_CODE                        
       AND AUCTIONPART NOT IN ('AP',                        
                                'AR',                        
                                'FP',                        
                                'FS',                        
                                'FA',                        
                                'FC',                        
                                'FL')                        
   AND S.PARTY_CODE = P.PARTYCODE    
  
 --- Data From BSEDB.HISTORY                       
 INSERT INTO   #REMBROK                        
 SELECT S.SETT_NO,                        
        S.SETT_TYPE,                        
        S.PARTY_CODE,                        
        S.SCRIP_CD,                        
        S.SERIES,                        
        S.SAUDA_DATE,                        
        S.TRADE_NO,                        
        S.ORDER_NO,                        
        S.SELL_BUY,                        
    S.TRADEQTY,                        
        S.MARKETRATE,                        
        BROKAPPLIED,                 
        NBROKAPP,                        
        BILLFLAG,                        
        REMCODE = SUB_BROKER,                       
        BRANCH_CD,                        
        REM_BROKAPPLIED = CONVERT(NUMERIC(18,4),0),                        
        REM_NBROKAPP = CONVERT(NUMERIC(18,4),0),                        
        STATUS = '0',                        
     SLABTYPE = CONVERT(VARCHAR(10),''),             
        FROMDATE = CONVERT(DATETIME,@FromDate),                        
        TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                        
        REMPARTYCD = CONVERT(VARCHAR(10),''),                    
        EXCHANGEID = 'BSECM' ,    
    SCHEMEID = CONVERT(INT, 0),  
    SCHEMEORSLAB = CONVERT(VARCHAR(7),''),  -- SCHEME/SLAB  
    REMTYPE = CONVERT(VARCHAR(3),'')    -- SUB/BR  
   -- BROKTYPE = CONVERT(VARCHAR(10),'')        -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT                       
 FROM   BSEDB.DBO.CLIENT1 C1,                        
        BSEDB.DBO.CLIENT2 C2,                        
        BSEDB.DBO.HISTORY S,  
    #PARTYLIST P  
 WHERE    
   S.SAUDA_DATE >= @FromDate                        
        AND S.SAUDA_DATE <= @ToDate + ' 23:59'                        
       AND C1.CL_CODE = C2.CL_CODE                        
       AND C2.PARTY_CODE = S.PARTY_CODE                        
       AND AUCTIONPART NOT IN ('AP',                        
                                'AR',                        
                                'FP',                        
                                'FS',                        
                                'FA',                        
                                'FC',                        
                                'FL')                        
   AND S.PARTY_CODE = P.PARTYCODE    
  
 --- Data From MSAJAG.SETTLEMENT                         
 INSERT INTO #REMBROK                        
 SELECT S.SETT_NO,                        
        S.SETT_TYPE,                        
        S.PARTY_CODE,                        
        S.SCRIP_CD,                        
        S.SERIES,                        
        S.SAUDA_DATE,                        
        S.TRADE_NO,                        
        S.ORDER_NO,                        
        S.SELL_BUY,                        
        S.TRADEQTY,                        
        S.MARKETRATE,                        
        BROKAPPLIED,                        
        NBROKAPP,                        
        BILLFLAG,                        
        REMCODE = SUB_BROKER,                        
        BRANCH_CD,                        
        REM_BROKAPPLIED = CONVERT(NUMERIC(18,4),0),                        
        REM_NBROKAPP = CONVERT(NUMERIC(18,4),0),                        
        STATUS = '0',                        
        SLABTYPE = CONVERT(VARCHAR(10),''),                        
        FROMDATE = CONVERT(DATETIME,@FromDate),                        
        TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                        
        REMPARTYCD = CONVERT(VARCHAR(10),''),                    
        EXCHANGEID = 'NSECM',    
    SCHEMEID = CONVERT(INT, 0),  
    SCHEMEORSLAB = CONVERT(VARCHAR(7),''),  -- SCHEME/SLAB  
    REMTYPE = CONVERT(VARCHAR(3),'')    -- SUB/BR  
   -- BROKTYPE = CONVERT(VARCHAR(10),'')        -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT                          
 FROM   CLIENT1 C1,                        
        CLIENT2 C2,                        
        SETTLEMENT S,  
    #PARTYLIST P  
 WHERE    
   S.SAUDA_DATE >= @FromDate                        
        AND S.SAUDA_DATE <= @ToDate + ' 23:59'                        
       AND C1.CL_CODE = C2.CL_CODE                        
       AND C2.PARTY_CODE = S.PARTY_CODE                        
       AND AUCTIONPART NOT IN ('AP',                        
                                'AR',                        
                                'FP',                        
                                'FS',                        
                                'FA',                        
                                'FC',                        
                 'FL')                        
   AND S.PARTY_CODE = P.PARTYCODE    
  
 --- Data From MSAJAG.HISTORY                 
 INSERT INTO #REMBROK                        
 SELECT S.SETT_NO,                        
        S.SETT_TYPE,   
        S.PARTY_CODE,                        
        S.SCRIP_CD,                        
        S.SERIES,                        
        S.SAUDA_DATE,                        
        S.TRADE_NO,                        
    S.ORDER_NO,                  
        S.SELL_BUY,                        
        S.TRADEQTY,                        
        S.MARKETRATE,                        
        BROKAPPLIED,                        
        NBROKAPP,                        
        BILLFLAG,                        
        REMCODE = SUB_BROKER,                        
        BRANCH_CD,                        
        REM_BROKAPPLIED = CONVERT(NUMERIC(18,4),0),                        
        REM_NBROKAPP = CONVERT(NUMERIC(18,4),0),                        
        STATUS = '0',                        
        SLABTYPE = CONVERT(VARCHAR(10),''),                        
        FROMDATE = CONVERT(DATETIME,@FromDate),                        
        TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                        
        REMPARTYCD = CONVERT(VARCHAR(10),''),                    
        EXCHANGEID = 'NSECM',    
    SCHEMEID = CONVERT(INT, 0),  
    SCHEMEORSLAB = CONVERT(VARCHAR(7),''),  -- SCHEME/SLAB  
    REMTYPE = CONVERT(VARCHAR(3),'')    -- SUB/BR  
   -- BROKTYPE = CONVERT(VARCHAR(10),'')        -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT                         
 FROM   CLIENT1 C1,                        
        CLIENT2 C2,                        
        HISTORY S,  
    #PARTYLIST P  
 WHERE    
   S.SAUDA_DATE >= @FromDate                        
        AND S.SAUDA_DATE <= @ToDate + ' 23:59'                        
       AND C1.CL_CODE = C2.CL_CODE                        
       AND C2.PARTY_CODE = S.PARTY_CODE                        
       AND AUCTIONPART NOT IN ('AP',                        
                                'AR',                        
                                'FP',                        
                                'FS',                        
                                'FA',                        
                                'FC',                        
                                'FL')                        
   AND S.PARTY_CODE = P.PARTYCODE    
  
 --- Data From NSEFO.FOSETTLEMENT                         
 SELECT S.PARTY_CODE, INST_TYPE, SYMBOL, EXPIRYDATE, STRIKE_PRICE, OPTION_TYPE, AUCTIONPART, SETTFLAG,                          
  SAUDA_DATE, TRADE_NO, ORDER_NO, SELL_BUY,                   
  TRADEQTY, PRICE, BROKERAGE=BROKAPPLIED*TRADEQTY,                         
  REMCODE = SUB_BROKER, BRANCH_CD,                         
  REM_BROKAPPLIED=CONVERT(NUMERIC(18,4),0), REM_NBROKAPP=CONVERT(NUMERIC(18,4),0), Status = '0',                        
  SLABTYPE=CONVERT(VARCHAR(10),''),                        
  FROMDATE = CONVERT(DATETIME,@FromDate),                         
  TODATE = CONVERT(DATETIME,@ToDate + ' 23:59:59'),                        
  MPRICE = STRIKE_PRICE+PRICE,                        
  MULTIPLIER = 1,                        
  REMPARTYCD = CONVERT(VARCHAR(10),''),                     
  EXCHANGEID = 'NSEFO',    
  SCHEMEID = CONVERT(INT, 0),  
  SCHEMEORSLAB = CONVERT(VARCHAR(7),''),  -- SCHEME/SLAB  
  REMTYPE = CONVERT(VARCHAR(3),'')    -- SUB/BR  
  -- BROKTYPE = CONVERT(VARCHAR(10),'')        -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT                       
 INTO #FOREMBROK                        
 FROM NSEFO.DBO.CLIENT1 C1, NSEFO.DBO.CLIENT2 C2, NSEFO.DBO.FOSETTLEMENT S, #PARTYLIST P                        
 WHERE   
  S.SAUDA_DATE >= @FromDate                        
   AND S.SAUDA_DATE <= @ToDate + ' 23:59'                        
  AND C1.CL_CODE = C2.CL_CODE                        
  AND C2.PARTY_CODE = S.PARTY_CODE                        
  AND AUCTIONPART <> 'CA'   
      AND PRICE > 0      
  AND S.PARTY_CODE = P.PARTYCODE    
                  
 --- Update SchemeID For All Party (For CAPITAL MARKET & SUB BROKER Only)  
 UPDATE #REMBROK SET  
   SLABTYPE = R.BrokType, -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT  
   SCHEMEID = R.SchemeID,  
   SCHEMEORSLAB = R.SchemeOrSlab, -- SCHEME/SLAB  
   REMTYPE = R.RemType, -- SUB/BR  
   REMPARTYCD = R.RemPartyCd  
 FROM #REMBROK A, #RemisierAllParty R  
 WHERE  
  A.Party_Code = R.PartyCode AND  
  A.Sauda_Date BETWEEN R.FromDate AND R.ToDate AND  
  (R.Segment = 'CAPITAL' OR R.Segment = 'ALL') AND  
  R.RemType = 'SUB'  
  
 --- Overright SchemeID For Specific Party (For CAPITAL MARKET & SUB BROKER Only)  
 UPDATE #REMBROK SET  
   SLABTYPE = R.BrokType, -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT  
   SCHEMEID = R.SchemeID,  
   SCHEMEORSLAB = R.SchemeOrSlab, -- SCHEME/SLAB  
   REMTYPE = R.RemType, -- SUB/BR  
   REMPARTYCD = R.RemPartyCd  
 FROM #REMBROK A, #RemisierSpecificParty R  
 WHERE  
  A.Party_Code = R.PartyCode AND  
  A.Sauda_Date BETWEEN R.FromDate AND R.ToDate AND  
  (R.Segment = 'CAPITAL' OR R.Segment = 'ALL') AND  
  R.RemType = 'SUB'  
  
-- --  --- Update SchemeID With Zero For Blocked Parties (For CAPITAL MARKET & SUB BROKER Only)  
-- --  UPDATE #REMBROK SET  
-- --    SLABTYPE = '', -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT  
-- --    SCHEMEID = 0,  
-- --    SCHEMEORSLAB = '', -- SCHEME/SLAB  
-- --    REMTYPE = '', -- SUB/BR  
-- --    REMPARTYCD = ''  
-- --  FROM #REMBROK A, #RemisierBlockedParty R  
-- --  WHERE  
-- --   A.Party_Code = R.PartyCode AND  
-- --   A.Sauda_Date BETWEEN R.FromDate AND R.ToDate AND  
-- --   (R.Segment = 'CAPITAL' OR R.Segment = 'ALL') AND  
-- --   R.SubBrokerOrBranch = 'SUB'  
  
 --- If any party is excluded for the SUB brokerage sharing then the same Party should be excluded for BR sharing also.   
 DELETE FROM #REMBROK   
  WHERE Party_Code IN ( SELECT PartyCode FROM #RemisierBlockedParty   
            WHERE @FromDate >= FromDate AND @ToDate <= ToDate AND SubBrokerOrBranch = 'SUB')  
  
--- Update SchemeID For All Party (For CAPITAL FUTURES & SUB BROKER Only)  
 UPDATE #FOREMBROK SET  
   SLABTYPE = R.BrokType, -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT  
   SCHEMEID = R.SchemeID,  
   SCHEMEORSLAB = R.SchemeOrSlab, -- SCHEME/SLAB  
   REMTYPE = R.RemType, -- SUB/BR  
   REMPARTYCD = R.RemPartyCd  
 FROM #FOREMBROK A, #RemisierAllParty R  
 WHERE  
  A.Party_Code = R.PartyCode AND  
  A.Sauda_Date BETWEEN R.FromDate AND R.ToDate AND  
  (R.Segment = 'FUTURES' OR R.Segment = 'ALL') AND  
  R.RemType = 'SUB'  
  
 --- Overright SchemeID For Specific Party (For FUTURES MARKET & SUB BROKER Only)  
 UPDATE #FOREMBROK SET  
   SLABTYPE = R.BrokType, -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT  
   SCHEMEID = R.SchemeID,  
   SCHEMEORSLAB = R.SchemeOrSlab, -- SCHEME/SLAB  
   REMTYPE = R.RemType, -- SUB/BR  
   REMPARTYCD = R.RemPartyCd  
 FROM #FOREMBROK A, #RemisierSpecificParty R  
 WHERE  
  A.Party_Code = R.PartyCode AND  
  A.Sauda_Date BETWEEN R.FromDate AND R.ToDate AND  
  (R.Segment = 'FUTURES' OR R.Segment = 'ALL') AND  
  R.RemType = 'SUB'  
  
-- --  --- Update SchemeID With Zero For Blocked Parties (For FUTURES MARKET & SUB BROKER Only)  
-- --  UPDATE #FOREMBROK SET  
-- --    SLABTYPE = '', -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT  
-- --    SCHEMEID = 0,  
-- --    SCHEMEORSLAB = '', -- SCHEME/SLAB  
-- --    REMTYPE = '', -- SUB/BR  
-- --    REMPARTYCD = ''  
-- --  FROM #FOREMBROK A, #RemisierBlockedParty R  
-- --  WHERE  
-- --   A.Party_Code = R.PartyCode AND  
-- --   A.Sauda_Date BETWEEN R.FromDate AND R.ToDate AND  
-- --   (R.Segment = 'FUTURES' OR R.Segment = 'ALL') AND  
-- --   R.SubBrokerOrBranch = 'SUB'  
  
 --- If any party is excluded for the SUB brokerage sharing then the same Party should be excluded for BR sharing also.   
 DELETE FROM #FOREMBROK   
  WHERE Party_Code IN ( SELECT PartyCode FROM #RemisierBlockedParty   
            WHERE @FromDate >= FromDate AND @ToDate <= ToDate AND SubBrokerOrBranch = 'SUB')  
  
 -- Update Remisier Trading Brokerage For Scheme For Capital Market  
 UPDATE #REMBROK  SET REM_BROKAPPLIED =                      
       (CASE                         
                   WHEN #REMBROK.STATUS = 'N' THEN 0                        
       ELSE (CASE                         
                        WHEN (#REMBROK.BILLFLAG = 1                        
                              AND BROKTABLE.VAL_PERC = 'V'           
                              AND SELL_BUY = 1) THEN  /* broktable.Normal */                        
                              ((Floor((BROKTABLE.NORMAL * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))         
                  WHEN (#REMBROK.BILLFLAG = 1              
                              AND BROKTABLE.VAL_PERC = 'V'                        
                           AND SELL_BUY = 2) THEN /* broktable.Normal  */                        
                             ((Floor((BROKTABLE.NORMAL * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))          
                        WHEN (#REMBROK.BILLFLAG = 1                        
                              AND BROKTABLE.VAL_PERC = 'P'                        
                              AND SELL_BUY = 1) THEN ((Floor((((BROKTABLE.NORMAL / 100) * #REMBROK.MARKETRATE) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                        
                        WHEN (#REMBROK.BILLFLAG = 1                        
                              AND BROKTABLE.VAL_PERC = 'P'                        
                           AND SELL_BUY = 2) THEN /* round((broktable.Normal /100 )* #REMBROK.marketrate,BrokTable.Round_To)         */                        
                          ((Floor((((BROKTABLE.NORMAL / 100) * #REMBROK.MARKETRATE) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                        
                        WHEN (#REMBROK.BILLFLAG = 2                        
                              AND BROKTABLE.VAL_PERC = 'V') THEN /* ((broktable.day_puc)) */                        
                             ((Floor((((BROKTABLE.DAY_PUC)) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))     
                        WHEN (#REMBROK.BILLFLAG = 2                        
                           AND BROKTABLE.VAL_PERC = 'P') THEN /* round((broktable.day_puc/100) * #REMBROK.marketrate,BrokTable.Round_To)  */                        
                             ((Floor((((BROKTABLE.DAY_PUC / 100) * #REMBROK.MARKETRATE) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                        
                        WHEN (#REMBROK.BILLFLAG = 3                        
                              AND BROKTABLE.VAL_PERC = 'V') THEN /* broktable.day_sales */                        
                             ((Floor((BROKTABLE.DAY_SALES * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))       
                        WHEN (#REMBROK.BILLFLAG = 3                        
                              AND BROKTABLE.VAL_PERC = 'P') THEN /*round((broktable.day_sales/ 100) * #REMBROK.marketrate ,BrokTable.Round_To) */                        
                             ((Floor((((BROKTABLE.DAY_SALES / 100) * #REMBROK.MARKETRATE) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                        
                        WHEN (#REMBROK.BILLFLAG = 4                      
                              AND BROKTABLE.VAL_PERC = 'V') THEN /* broktable.sett_purch  */                        
           ((Floor((BROKTABLE.SETT_PURCH * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))            
                        WHEN (#REMBROK.BILLFLAG = 4                        
                              AND BROKTABLE.VAL_PERC = 'P') THEN /* round((broktable.sett_purch/100) * #REMBROK.marketrate ,BrokTable.Round_To) */                        
                             ((Floor((((BROKTABLE.SETT_PURCH / 100) * #REMBROK.MARKETRATE) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                        
                        WHEN (#REMBROK.BILLFLAG = 5                        
                              AND BROKTABLE.VAL_PERC = 'V') THEN /* broktable.sett_sales */                        
                             ((Floor((BROKTABLE.SETT_SALES * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))      
                        WHEN (#REMBROK.BILLFLAG = 5                        
                              AND BROKTABLE.VAL_PERC = 'P') THEN /* round((broktable.sett_sales/100) * #REMBROK.marketrate ,BrokTable.Round_To)*/                        
                             ((Floor((((BROKTABLE.SETT_SALES / 100) * #REMBROK.MARKETRATE) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                        
                        ELSE 0                        
                      END)                        
                 END)                        
 FROM   BROKTABLE,                        
        #REMBROK,                        
    RemisierBrokerageScheme R,  
        (SELECT   SETT_NO,                        
                  SETT_TYPE,                        
                  PARTY_CODE,                    
                  SCRIP_CD,                        
                  SERIES,                        
                  PQTY = SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END),                        
                  SQTY = SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END),                        
                  PRATE = (CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END) > 0        
                                  THEN SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY * MARKETRATE ELSE 0 END) /                        
                                        SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE 0 END)                        
                          ELSE 0 END),        
  
                   SRATE = (CASE WHEN SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END) > 0        
                                  THEN SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY * MARKETRATE ELSE 0 END) /                        
                                        SUM(CASE WHEN SELL_BUY = 2 THEN TRADEQTY ELSE 0 END)                        
                          ELSE 0 END)        
         FROM     #REMBROK                        
         GROUP BY SETT_NO,                        
                  SETT_TYPE,                        
                  PARTY_CODE,                        
                  SCRIP_CD,                        
                  SERIES) C                        
 WHERE    
  #REMBROK.SchemeID > 0   
  AND #REMBROK.SchemeID = R.SchemeID  
  AND #REMBROK.SchemeOrSlab = 'SCHEME'  
  AND C.SETT_NO = #REMBROK.SETT_NO                        
  AND C.SETT_TYPE = #REMBROK.SETT_TYPE                        
  AND C.SETT_TYPE = #REMBROK.SETT_TYPE                        
  AND C.SCRIP_CD = #REMBROK.SCRIP_CD                        
  AND C.SERIES = #REMBROK.SERIES                        
  AND TRDTABLENO = BROKTABLE.TABLE_NO                        
  AND BILLFLAG IN (2, 3)                        
  AND BROKTABLE.LINE_NO =   
    (Case When R.Brokscheme = 2  Then (Select Min(Broktable.Line_No) From Broktable     
         Where R.TrdTableNo = Broktable.Table_No    
         And Trd_Del =   
    (Case When C.Pqty = C.Sqty     
          Then (Case When C.Prate > = C.Srate     
                     Then (Case When #REMBROK.Sell_Buy = 1  Then 'F' Else 'S' End )    
         Else    
         (Case When ( #REMBROK.Sell_Buy = 2 ) Then 'F' Else 'S'  End )         
            End)    
     Else (Case When C.Pqty > = C.Sqty     
                Then (Case When ( #REMBROK.Sell_Buy = 1 ) Then 'F' Else 'S' End )    
                Else    
                (Case When ( #REMBROK.Sell_Buy = 2 ) Then 'F' Else 'S' End )  
               End )    
         End )    
     And #REMBROK.SchemeID = R.SchemeID       
         And #REMBROK.Marketrate <= Broktable.Upper_Lim)     
     Else     
     (Case When R.Brokscheme = 1 Then (Select Min(Broktable.Line_No) From Broktable     
        Where R.TrdTableNo = Broktable.Table_No                                                      
           And Trd_Del =   
    (Case When C.Pqty > = C.Sqty     
            Then (Case When #REMBROK.Sell_Buy = 1 Then 'F' Else 'S' End )    
           Else    
                (Case When ( #REMBROK.Sell_Buy = 2 ) Then 'F' Else 'S' End )         
           End )    
           And #REMBROK.SchemeID = R.SchemeID         
           And #REMBROK.Marketrate < = Broktable.Upper_Lim)               
      Else (Case When R.Brokscheme = 3 Then (Select Min(Broktable.Line_No) From Broktable     
          Where R.TrdTableNo = Broktable.Table_No    
            And Trd_Del =   
     (Case When C.Pqty > C.Sqty     
                 Then (Case When #REMBROK.Sell_Buy = 1 Then 'F' Else 'S' End )    
                 Else    
                      (Case When #REMBROK.Sell_Buy = 2 Then 'F' Else 'S' End )   
            End )    
            And #REMBROK.SchemeID = R.SchemeID        
            And #REMBROK.Marketrate < = Broktable.Upper_Lim)               
      Else     
      (Select Min(Broktable.Line_No) From Broktable     
          Where R.TrdTableNo = Broktable.Table_No    
            And #REMBROK.SchemeID = R.SchemeID             
            And #REMBROK.Marketrate < = Broktable.Upper_Lim )     
       End )    
     End )    
  End )    
 ------------------------ End of Remisier Trading Brokerage Updation  
  
 ---- Update Remisier Delivery Brokerage                         
 UPDATE #REMBROK                        
 SET    REM_NBROKAPP = (CASE                         
                          WHEN (BROKTABLE.VAL_PERC = 'V') THEN ((Floor((BROKTABLE.NORMAL * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                        
                          WHEN (BROKTABLE.VAL_PERC = 'P') THEN ((Floor((((BROKTABLE.NORMAL / 100) *#REMBROK.MARKETRATE) * Power(10,BROKTABLE.ROUND_TO) + BROKTABLE.ROFIG + BROKTABLE.ERRNUM) / (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) * (BROKTABLE.ROFIG + BROKTABLE.NOZERO)) / Power(10,BROKTABLE.ROUND_TO))                        
                          ELSE BROKAPPLIED                        
                        END)     
 FROM   BROKTABLE,                        
        #REMBROK,                        
    RemisierBrokerageScheme R                         
 WHERE  #REMBROK.SchemeID > 0  
    AND #REMBROK.SchemeID = R.SchemeID                         
    AND #REMBROK.SchemeOrSlab = 'SCHEME'  
        AND R.DELTABLENO = BROKTABLE.TABLE_NO                        
        AND BROKTABLE.LINE_NO = (SELECT MIN(BROKTABLE.LINE_NO) FROM BROKTABLE WHERE DELTABLENO = BROKTABLE.TABLE_NO  AND TRD_DEL = 'D'                        
                    AND  #REMBROK.SchemeID = R.SchemeID AND #REMBROK.MARKETRATE <= BROKTABLE.UPPER_LIM)             
        AND #REMBROK.BILLFLAG IN (1,4,5)                        
  
 ---- Update Remisier Brokerage NSEFO Trades                         
 Update #FOREMBROK set                           
  REM_BROKAPPLIED =                        
   (((case when ( #FOREMBROK.SettFlag = 1 and broktable.val_perc ='V' and #FOREMBROK.sell_buy = 1)                          
   Then ((floor(( broktable.Normal*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                            
    (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ))/power(10,broktable.round_to))                          
   when ( #FOREMBROK.SettFlag = 1 and broktable.val_perc ='V' and #FOREMBROK.sell_buy = 2)                  
   Then ((floor(( broktable.Normal*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                            
    (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ))/power(10,broktable.round_to))                          
   when ( #FOREMBROK.SettFlag = 1 and broktable.val_perc ='P' and #FOREMBROK.sell_buy = 1)                          
   Then ((floor((((broktable.Normal*MultiPlier /100 ) * MPrice)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /                            
    (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))                          
   when ( #FOREMBROK.SettFlag = 1 and broktable.val_perc ='P' and #FOREMBROK.sell_buy = 2)                          
   Then                           
    ((floor(( ((broktable.Normal*MultiPlier /100 )* MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                            
    (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                           
    power(10,broktable.round_to))                          
   when (#FOREMBROK.SettFlag = 2  and broktable.val_perc ='V' )       Then                           
    ((floor(( ((Broktable.Day_puc*MultiPlier))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                            
    (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                           
    power(10,broktable.round_to))                          
   when (#FOREMBROK.SettFlag = 2  and broktable.val_perc ='P' )                           
   Then                           
    ((floor(( ((Broktable.Day_puc*MultiPlier/100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                            
    (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                           
    power(10,broktable.round_to))                          
   when (#FOREMBROK.SettFlag = 3  and broktable.val_perc ='V' )                          
   Then                           
    ((floor(( Broktable.day_sales*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                            
    (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                           
    power(10,broktable.round_to))                          
   when (#FOREMBROK.SettFlag = 3  and broktable.val_perc ='P' )                          
   Then                         
    ((floor(( ((Broktable.day_sales*MultiPlier/ 100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                            
    (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                           
    power(10,broktable.round_to))                          
   when ( #FOREMBROK.SettFlag = 4  and broktable.val_perc ='V' )                          
   Then                           
    ((floor(( Broktable.Sett_purch*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                           
    (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                           
    power(10,broktable.round_to))                          
   when ( #FOREMBROK.SettFlag = 4  and broktable.val_perc ='P' )                          
   Then                           
    ((floor(( ((Broktable.Sett_purch*MultiPlier/100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                            
    (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                           
    power(10,broktable.round_to))                          
   when ( #FOREMBROK.SettFlag = 5  and broktable.val_perc ='V' )                          
   Then                           
    ((floor(( Broktable.Sett_sales*MultiPlier * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                            
    (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                           
    power(10,broktable.round_to))                          
   when ( #FOREMBROK.SettFlag = 5  and broktable.val_perc ='P' )                          
   Then                           
    ((floor(( ((Broktable.Sett_sales*MultiPlier/100) * MPrice) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                            
    (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                           
    power(10,broktable.round_to))                          
         when (#FOREMBROK.SettFlag = 8  and broktable.val_perc ='V' )                         
                                     Then                         
           ((floor(( ((MultiPlier*broktable.Sett_purch))  * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
           (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
           power(10,broktable.round_to))                        
                               when (#FOREMBROK.SettFlag = 8  and broktable.val_perc ='P' )                         
                                      Then                         
           ((floor(( ((MultiPlier*Broktable.Sett_purch/100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
           (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
           power(10,broktable.round_to))                        
                             
         when (#FOREMBROK.SettFlag = 9  and broktable.val_perc ='V' )                        
                                      Then                         
           ((floor(( MultiPlier*Broktable.Sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
           (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
           power(10,broktable.round_to))                        
                           when (#FOREMBROK.SettFlag = 9  and broktable.val_perc ='P' )                        
                                      Then                         
           ((floor(( ((MultiPlier*Broktable.Sett_sales/ 100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
           (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
           power(10,broktable.round_to))                   
                         when ( #FOREMBROK.SettFlag = 6  and broktable.val_perc ='V' )                        
  Then                         
           ((floor((MultiPlier* Broktable.Sett_purch * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
           (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
      power(10,broktable.round_to))                        
                                  when ( #FOREMBROK.SettFlag = 6  and broktable.val_perc ='P' )                        
                                 Then                         
  ((floor(( ((MultiPlier*Broktable.Sett_purch/100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
           (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
           power(10,broktable.round_to))                        
                      when ( #FOREMBROK.SettFlag = 7  and broktable.val_perc ='V' )                        
                                      Then                         
           ((floor((MultiPlier* Broktable.Sett_sales * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
           (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
           power(10,broktable.round_to))                        
                      when ( #FOREMBROK.SettFlag = 7  and broktable.val_perc ='P' )                        
                                      Then                         
           ((floor(( ((MultiPlier*Broktable.Sett_sales/100) * (MPrice)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /                          
           (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  /                         
           power(10,broktable.round_to))                        
   Else  0                           
   End                           
  )))                      
 FROM                         
  #BROKTABLE BrokTable,                        
  #FOREMBROK,                        
  RemisierBrokerageScheme R,   
    ( SELECT RemCode,inst_type,symbol,expirydate,                          
    PQty=SUM(Case When Sell_buy = 1 Then TradeQty Else 0 End),                          
    SQty=SUM(Case When Sell_buy = 2 Then TradeQty Else 0 End),                          
    PRate=(Case When SUM(Case When Sell_buy = 1 Then TradeQty Else 0 End) > 0                        
           Then SUM(Case When Sell_buy = 1 Then TradeQty*Price Else 0 End) /                        
         SUM(Case When Sell_buy = 1 Then TradeQty Else 0 End)                        
           Else 0 End),                          
    SRate=(Case When SUM(Case When Sell_buy = 2 Then TradeQty Else 0 End) > 0                        
           Then SUM(Case When Sell_buy = 2 Then TradeQty*Price Else 0 End) /                        
         SUM(Case When Sell_buy = 2 Then TradeQty Else 0 End)                        
           Else 0 End),                          
    SDate=Left(Convert(Varchar,sauda_date,109),11),option_type,strike_price,AuctionPart                        
    FROM #FOREMBROK                        
    GROUP BY RemCode,inst_type,symbol,expirydate,Left(Convert(Varchar,sauda_date,109),11),option_type,strike_price,AuctionPart                        
        ) S                        
 WHERE                        
  #FOREMBROK.RemCode = S.RemCode and                         
  #FOREMBROK.SchemeID > 0 and                          
    #FOREMBROK.SchemeID  = R.SchemeID and  
  #FOREMBROK.SchemeOrSlab = 'SCHEME' and  
  #FOREMBROK.AuctionPart = S.AuctionPart and                          
  #FOREMBROK.inst_type=S.inst_type and                         
  #FOREMBROK.symbol=S.symbol and                          
  #FOREMBROK.expirydate=S.expirydate  AND                          
  #FOREMBROK.strike_price = s.strike_price and                                          
  #FOREMBROK.option_type = s.option_type and                        
  --#FOREMBROK.sauda_date between From_Date and To_Date and                         
  --R.RECTYPE = 'FUTURES' And                         
  #FOREMBROK.sauda_date like S.sdate + '%' AND                          
  Broktable.Table_no = (                         
     CASE                         
         WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = ''                        
         THEN FutTableNo                        
         WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = 'EA'                        
         THEN FutFinalTableNo                         
         WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart <> 'EA'                        
       THEN OptTableNo                        
         WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart = 'EA'                        
  THEN OptExTableNo                        
     END                         
     )                         
     AND Broktable.Line_no = (                         
     CASE                  
         WHEN BrokScheme  = 1                        
         THEN                         
         (                         
         SELECT                         
             Min(Broktable.line_no)                         
  FROM #BROKTABLE Broktable                         
         WHERE Broktable.Table_no =(                         
             CASE                         
                 WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = ''                        
  THEN FutTableNo                        
          WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = 'EA'                        
          THEN FutFinalTableNo                         
          WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart <> 'EA'                        
          THEN OptTableNo                        
          WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart = 'EA'                        
   THEN OptExTableNo           
             END                         
             )                         
             AND Trd_Del = (                         
             CASE                         
                 WHEN ((s.Pqty >= s.Sqty)                         
                 AND #FOREMBROK.Settflag in (1,2,3,4,5))                         
                 THEN (                    
                 CASE                         
                     WHEN ( #FOREMBROK.Sell_Buy = 1 )                         
                     THEN 'F'                         
                     ELSE 'S'                         
                 END                         
                 )                         
                 WHEN #FOREMBROK.Settflag in(6,7)                         
                 THEN 'S'                         
                 WHEN #FOREMBROK.Settflag in(8,9)                         
                 THEN 'F'                         
                 WHEN ((s.Pqty < s.Sqty)                         
                 AND #FOREMBROK.Settflag in (1,2,3,4,5))                         
                 THEN (                         
        CASE                         
                     WHEN ( #FOREMBROK.Sell_Buy = 2 )                         
                     THEN 'F'                         
                     ELSE 'S'                         
                 END                         
                 )                         
                 WHEN #FOREMBROK.Settflag in(6,7)                         
                 THEN 'S'                         
                 WHEN #FOREMBROK.Settflag in(8,9)                         
                 THEN 'F'                         
                 WHEN #FOREMBROK.settflag = 0                         
                 THEN 'F'                         
             END                         
             )                         
             AND #FOREMBROK.RemCode = s.RemCode                         
          AND MPrice <= Broktable.upper_lim                         
      )                         
         WHEN BrokScheme = 3                    
         THEN                         
         (                         
         SELECT                         
             min(Broktable.line_no)                         
         FROM #BROKTABLE broktable                         
         WHERE Broktable.table_no = (                         
             CASE    WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = ''                        
   THEN FutTableNo                        
   WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = 'EA'                        
   THEN FutFinalTableNo                         
   WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart <> 'EA'                        
   THEN OptTableNo                        
   WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart = 'EA'                        
   THEN OptExTableNo                        
             END                         
             )                         
             AND Trd_Del = (                 
             CASE                         
                 WHEN ((s.Pqty > s.Sqty)                         
                 AND #FOREMBROK.Settflag in (1,2,3,4,5))                         
                 THEN (                         
                 CASE                         
                     WHEN ( #FOREMBROK.Sell_Buy = 1 )                         
                     THEN 'F'                         
                     ELSE 'S'                         
                 END                         
                 )                         
                 WHEN #FOREMBROK.Settflag in(6,7)                         
                 THEN 'S'                         
                 WHEN #FOREMBROK.Settflag in(8,9)                         
                 THEN 'F'                         
                 WHEN ((s.Pqty <= s.Sqty)                         
                 AND #FOREMBROK.Settflag in (1,2,3,4,5))                         
                 THEN (                         
                 CASE                         
    WHEN ( #FOREMBROK.Sell_Buy = 2 )                         
                     THEN 'F'                         
                     ELSE 'S'         
                 END                         
                 )                         
                 WHEN #FOREMBROK.Settflag in(6,7)                         
                 THEN 'S'                         
                 WHEN #FOREMBROK.Settflag in(8,9)                         
                 THEN 'F'                         
                 WHEN #FOREMBROK.settflag = 0                         
                 THEN 'F'                         
          END                         
             )                         
             AND #FOREMBROK.RemCode = s.RemCode                         
             AND MPrice <= Broktable.upper_lim                         
         )                         
         WHEN BrokScheme = 2                        
         THEN                         
         (                         
         SELECT                         
             min(Broktable.line_no)                         
         FROM #BROKTABLE broktable                         
         WHERE Broktable.table_no = (                         
             CASE                         
   WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = ''                        
   THEN FutTableNo                        
   WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = 'EA'                        
   THEN FutFinalTableNo                         
   WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart <> 'EA'                        
   THEN OptTableNo                        
   WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart = 'EA'                        
   THEN OptExTableNo                        
             END                
             )                         
             AND Trd_Del = (Case When S.Pqty = S.Sqty                         
        Then (Case When S.Prate >= S.Srate                         
                   Then (Case When #FOREMBROK.Sell_Buy = 1                        
                              Then 'F'                         
     Else 'S'                        
                  End )                        
            Else                        
                               (Case When ( #FOREMBROK.Sell_Buy = 2 )                         
                                       Then 'F'                        
                              Else 'S'                        
                         End )                             
                    End)                        
                             Else (Case When S.Pqty >= S.Sqty                         
                                               Then (Case When ( #FOREMBROK.Sell_Buy = 1 )                         
                                                          Then 'F'                          
                                                          Else 'S'                        
                                                     End )                        
                                               Else                        
                                                    (Case When ( #FOREMBROK.Sell_Buy = 2 )                         
        Then 'F'                          
                                           Else 'S'                        
                                                     End )                             
                   End )                        
                  End )                         
             AND #FOREMBROK.RemCode = S.RemCode                         
             AND MPrice <= Broktable.upper_lim                         
         )                         
         ELSE                         
         (                         
         SELECT                         
             min(line_no)                         
         FROM #BROKTABLE broktable                         
         WHERE MPrice <= Broktable.upper_lim                         
             AND broktable.table_no = (                         
             CASE                         
   WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = ''                        
   THEN FutTableNo                        
   WHEN Left(S.Inst_Type,3) = 'FUT' And #FOREMBROK.AuctionPart = 'EA'                        
   THEN FutFinalTableNo                         
   WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart <> 'EA'                        
   THEN OptTableNo                        
   WHEN Left(S.Inst_Type,3) = 'OPT' And #FOREMBROK.AuctionPart = 'EA'                     
   THEN OptExTableNo                        
             END                         
             )                         
         )                         
     END                         
     )                          
 ------ End of Remisier Brokerage For FOTrades Updation  
                 
 SELECT PARTY_CODE,INST_TYPE,SYMBOL,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,AUCTIONPART,                
 SAUDA_DATE,TRADE_NO=Pradnya.DBO.ReplaceTradeNo(Trade_No),ORDER_NO,                
 SELL_BUY,TRADEQTY=Sum(TRADEQTY),PRICE,Brokerage=Sum(Brokerage),                
 REMCODE,BRANCH_CD,REM_Brokerage=Sum(REM_BROKAPPLIED*TradeQty),                
 REM_NBROKAPP=0,Status,SLABTYPE,FROMDATE,                
 TODATE,MPrice,Multiplier,REMPARTYCD,EXCHANGEID, SCHEMEID, SCHEMEORSLAB, REMTYPE                
 INTO #FOREMBROK_1 From #FOREMBROK                
 GROUP BY PARTY_CODE,INST_TYPE,SYMBOL,EXPIRYDATE,STRIKE_PRICE,OPTION_TYPE,AUCTIONPART,                
 SAUDA_DATE,Pradnya.DBO.ReplaceTradeNo(Trade_No),ORDER_NO,                
 SELL_BUY,PRICE,REMCODE,BRANCH_CD,Status,SLABTYPE,FROMDATE,                
 TODATE,MPrice,Multiplier,REMPARTYCD,EXCHANGEID, SCHEMEID, SCHEMEORSLAB, REMTYPE                  
  
  
   ---------- Update NSEFO Brokerage From  NSEFO.DBO.CHARGES_DETAIL Table                 
 UPDATE                   
  #FOREMBROK_1                  
 SET                  
  Brokerage = (Case When Sell_Buy =1 then CD_Tot_BuyBrok Else CD_Tot_SellBrok End)                
 FROM                  
  NSEFO.DBO.CHARGES_DETAIL                  
 WHERE                  
  Convert(Varchar,CD_Sauda_Date,103) = Convert(Varchar,Sauda_Date,103)                  
  And CD_Party_Code = #FOREMBROK_1.Party_Code                   
  And CD_Inst_Type = Inst_Type                
  And CD_Symbol = Symbol                  
  And Convert(Varchar,CD_Expiry_Date,106) = Convert(Varchar,ExpiryDate,106)                  
  And CD_Option_Type = Option_Type                  
  And CD_Strike_Price = Strike_Price                  
  And CD_Trade_No = Trade_No                  
  And CD_Order_No = Order_No                 
  
 ---- Club #REMBROK (CAPITAL) & #FOREMBROK (FUTURES) into Single Table #REMBROK_1  
 SELECT    
  REMCODE,                        
      BRANCH_CD,                        
      SLABTYPE,                        
      TURNOVER = SUM(TURNOVER),                    
     NSECMBrok = Sum(NSECMBrok),                    
  BSECMBrok = Sum(BSECMBrok),               
  NSEFOBrok = Sum(NSEFOBrok),                             
    CL_BROKERAGE = SUM(CL_BROKERAGE),                        
    REM_BROKERAGE = SUM(REM_BROKERAGE),                        
    REM_PAYBROKERAGE = SUM(REM_PAYBROKERAGE),                        
    BALANCE_BROKERAGE = SUM(BALANCE_BROKERAGE),                        
    FROMDATE, TODATE,                        
    REMPARTYCD,          
    REM_NSECMBrok  = SUM(CASE WHEN EXCHANGEID = 'NSECM' THEN REM_PAYBROKERAGE ELSE 0 END),          
    REM_BSECMBrok  = SUM(CASE WHEN EXCHANGEID = 'BSECM' THEN REM_PAYBROKERAGE ELSE 0 END),          
    REM_NSEFOBrok  = SUM(CASE WHEN EXCHANGEID = 'NSEFO' THEN REM_PAYBROKERAGE ELSE 0 END),          
  CASE SCHEMEORSLAB WHEN 'SCHEME' THEN 0 ELSE SCHEMEID END AS SCHEMEID,  
  CASE SCHEMEORSLAB WHEN 'SCHEME' THEN CONVERT(VARCHAR(7),'') ELSE CONVERT(VARCHAR(7), SCHEMEORSLAB) END AS  SCHEMEORSLAB,   -- SCHEME/SLAB  
  -- --   --SLABTYPE,    -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT  
  REMTYPE         -- SUB/BR  
 INTO     #REMBROK_1                         
 FROM (          
   SELECT     
    REMCODE,                        
          BRANCH_CD,                     
          SLABTYPE,                        
          TURNOVER = SUM(TRADEQTY * MARKETRATE),                     
          NSECMBrok = Sum(Case When EXCHANGEID = 'NSECM' Then TRADEQTY * NBROKAPP Else 0 End),                    
          BSECMBrok = Sum(Case When EXCHANGEID = 'BSECM' Then TRADEQTY * NBROKAPP Else 0 End),                     
          NSEFOBrok = 0,                                
          CL_BROKERAGE = SUM(TRADEQTY * NBROKAPP),                        
          REM_BROKERAGE = SUM(TRADEQTY * REM_BROKAPPLIED) + SUM(TRADEQTY * REM_NBROKAPP),                        
          REM_PAYBROKERAGE = (CASE                         
                                WHEN SLABTYPE = 'CUT-OFF-1' THEN (CASE                         
                                WHEN SUM(TRADEQTY * NBROKAPP) > (SUM(TRADEQTY * REM_BROKAPPLIED) + SUM(TRADEQTY * REM_NBROKAPP)) THEN SUM(TRADEQTY * NBROKAPP) - (SUM(TRADEQTY * REM_BROKAPPLIED) + SUM(TRADEQTY * REM_NBROKAPP))                        
                                                                    ELSE 0  
                         END)                        
                                WHEN SLABTYPE = 'CUT-OFF-2' THEN (CASE                         
                                                                    WHEN SUM(TRADEQTY * NBROKAPP) > (SUM(TRADEQTY * REM_BROKAPPLIED) + SUM(TRADEQTY * REM_NBROKAPP)) THEN SUM(TRADEQTY * REM_BROKAPPLIED) + SUM(TRADEQTY * REM_NBROKAPP)                      
  
  
                                                                    ELSE SUM(TRADEQTY * NBROKAPP)  
                        END)                        
                                ELSE 0                        
                              END),                        
          BALANCE_BROKERAGE = CONVERT(NUMERIC(18,4),0),     
          FROMDATE,                        
          TODATE,                        
          REMPARTYCD,          
          EXCHANGEID,  
    CASE SCHEMEORSLAB WHEN 'SCHEME' THEN 0 ELSE SCHEMEID END AS SCHEMEID,  
    CASE SCHEMEORSLAB WHEN 'SCHEME' THEN CONVERT(VARCHAR(7),'') ELSE CONVERT(VARCHAR(7), SCHEMEORSLAB) END AS  SCHEMEORSLAB,   -- SCHEME/SLAB  
-- --     SCHEMEID,  
-- --     SCHEMEORSLAB,   -- SCHEME/SLAB  
-- --     --SLABTYPE,    -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT  
    REMTYPE         -- SUB/BR  
          
 FROM     #REMBROK                        
 GROUP BY    
    REMCODE,                        
          BRANCH_CD,                        
          SLABTYPE,                        
          FROMDATE,                        
          TODATE,                        
          REMPARTYCD,          
      EXCHANGEID,  
    CASE SCHEMEORSLAB WHEN 'SCHEME' THEN 0 ELSE SCHEMEID END ,  
    CASE SCHEMEORSLAB WHEN 'SCHEME' THEN CONVERT(VARCHAR(7),'') ELSE CONVERT(VARCHAR(7), SCHEMEORSLAB) END,    -- SCHEME/SLAB  
-- --     SCHEMEID,  
-- --     SCHEMEORSLAB,   -- SCHEME/SLAB  
-- --     --SLABTYPE,    -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT  
     REMTYPE         -- SUB/BR  
  
 UNION ALL                        
                         
 SELECT     
    REMCODE,                        
          BRANCH_CD,                        
        SLABTYPE,                        
          TURNOVER = SUM(TRADEQTY * PRICE),     
      NSECMBrok = 0,                    
      BSECMBrok = 0,                     
        NSEFOBrok = Sum(Case When EXCHANGEID = 'NSEFO' Then Brokerage Else 0 End),                         
        CL_BROKERAGE = SUM(Brokerage),                        
          REM_BROKERAGE = SUM(REM_Brokerage),                        
          REM_PAYBROKERAGE = (CASE                         
                                WHEN SLABTYPE = 'CUT-OFF-1' THEN (CASE                         
                                                                    WHEN SUM(Brokerage) > SUM(REM_Brokerage) THEN SUM(Brokerage) - SUM(REM_Brokerage)                        
                                 ELSE 0                        
                                                                  END)                        
                                WHEN SLABTYPE = 'CUT-OFF-2' THEN (CASE                         
                                                                    WHEN SUM(Brokerage) > SUM(REM_Brokerage) THEN SUM(REM_Brokerage)                        
                                                                    ELSE SUM(Brokerage)                        
                                                                  END)                        
                                ELSE 0                        
                              END),                        
          BALANCE_BROKERAGE = CONVERT(NUMERIC(18,4),0),                        
          FROMDATE,                        
          TODATE,                        
          REMPARTYCD,          
      EXCHANGEID,  
    CASE SCHEMEORSLAB WHEN 'SCHEME' THEN 0 ELSE SCHEMEID END AS SCHEMEID,  
    CASE SCHEMEORSLAB WHEN 'SCHEME' THEN CONVERT(VARCHAR(7),'') ELSE CONVERT(VARCHAR(7), SCHEMEORSLAB) END AS  SCHEMEORSLAB,   -- SCHEME/SLAB  
-- --     SCHEMEID,  
-- --     SCHEMEORSLAB,   -- SCHEME/SLAB  
-- --     --SLABTYPE,    -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT  
     REMTYPE         -- SUB/BR  
 FROM     #FOREMBROK_1            
 GROUP BY   
    REMCODE,           
          BRANCH_CD,     
    SLABTYPE,                     
          FROMDATE,                        
          TODATE,           
      REMPARTYCD,          
      EXCHANGEID,  
    CASE SCHEMEORSLAB WHEN 'SCHEME' THEN 0 ELSE SCHEMEID END  ,  
    CASE SCHEMEORSLAB WHEN 'SCHEME' THEN CONVERT(VARCHAR(7),'') ELSE CONVERT(VARCHAR(7), SCHEMEORSLAB) END,    -- SCHEME/SLAB  
-- --     SCHEMEID,  
-- --     SCHEMEORSLAB,   -- SCHEME/SLAB  
-- --     SLABTYPE,    -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT  
      REMTYPE         -- SUB/BR  
      ) A           
 GROUP BY   
    REMCODE,                        
          BRANCH_CD,                        
          SLABTYPE,                        
      FROMDATE,                        
      TODATE,                        
      REMPARTYCD,  
    CASE SCHEMEORSLAB WHEN 'SCHEME' THEN 0 ELSE SCHEMEID END ,  
    CASE SCHEMEORSLAB WHEN 'SCHEME' THEN CONVERT(VARCHAR(7),'') ELSE CONVERT(VARCHAR(7), SCHEMEORSLAB) END,    -- SCHEME/SLAB  
-- --     SCHEMEID,  
-- --     SCHEMEORSLAB,   -- SCHEME/SLAB  
-- --     --SLABTYPE,    -- CUT-OFF-1/CUT-OFF-2/INCR/FLAT  
      REMTYPE         -- SUB/BR  
  
 --- Update the Balance Brokerage              
 UPDATE #REMBROK_1 SET BALANCE_BROKERAGE = CL_BROKERAGE - REM_PAYBROKERAGE                        
  
  
select * from #REMBROK  
  
 --------------  Updating of Flat Brokerage For SubBroker                         
 SELECT     
    CASE WHEN R.SCHEMEORSLAB = 'SLAB' AND R.SLABTYPE = 'INCR' THEN R.SCHEMEID ELSE 0 END AS SCHEMEID,   
    R.REMCODE,                        
          R.BRANCH_CD,                        
          SHARE_PER = ISNULL(SHAREPER,0),                    
    NSECMBrok = Sum(NSECMBrok),                    
    BSECMBrok = Sum(BSECMBrok),                     
    NSEFOBrok = Sum(NSEFOBrok),                        
          CL_BROKERAGE = SUM(CL_BROKERAGE),                        
          REM_PAYBROKERAGE = SUM(REM_PAYBROKERAGE) +   
          (CASE WHEN ValPerc = 'P' THEN   
                   SUM(BALANCE_BROKERAGE) * (CASE WHEN ISNULL(SHAREPER,0) > 0 THEN ISNULL(SHAREPER,0) / 100 ELSE 0 END)  
             ELSE ISNULL(SHAREPER,0)   
           END) ,                         
          BALANCE_BROKERAGE = SUM(BALANCE_BROKERAGE) -   
           (CASE WHEN ValPerc = 'P' THEN   
                   SUM(BALANCE_BROKERAGE) * (CASE WHEN ISNULL(SHAREPER,0) > 0 THEN ISNULL(SHAREPER,0) / 100 ELSE 0 END)  
              ELSE ISNULL(SHAREPER,0)   
                            END),   
          R.REMTYPE, --ISNULL(S.REMTYPE,'SUB'),                        
          R.FROMDATE,                        
          R.TODATE,                        
          R.REMPARTYCD, --= ISNULL(S.REMPARTYCD, R.REMPARTYCD),                  
        R.SLABTYPE, --= ISNULL(S.BrokType,R.SLABTYPE),          
      REM_NSECMBrok = SUM(CASE WHEN R.SchemeOrSlab = 'SCHEME' THEN REM_NSECMBrok ELSE 0 END),          
      REM_BSECMBrok = SUM(CASE WHEN R.SchemeOrSlab = 'SCHEME' THEN REM_BSECMBrok ELSE 0 END),          
      REM_NSEFOBrok = SUM(CASE WHEN R.SchemeOrSlab = 'SCHEME' THEN REM_NSEFOBrok ELSE 0 END)          
 INTO     #REMBROK_2                        
 FROM     #REMBROK_1 R         
      LEFT OUTER JOIN RemisierBrokerageScheme S                         
                ON (R.SchemeID = S.SchemeID AND R.SlabType ='FLAT')--R.SchemeOrSlab = 'SLAB')  
 GROUP BY   
    CASE WHEN R.SCHEMEORSLAB = 'SLAB' AND R.SLABTYPE = 'INCR' THEN R.SCHEMEID ELSE 0 END ,   
      R.REMCODE,                        
          R.BRANCH_CD,                        
          SHAREPER,                        
          LOWERLIMIT,                        
          UPPERLIMIT,                        
          R.REMTYPE,                        
          R.FROMDATE,                        
          R.TODATE,                        
          --ISNULL(S.REMPARTYCD, R.REMPARTYCD),                  
        --ISNULL(S.BrokType,R.SLABTYPE)          
          R.REMPARTYCD,   
        R.SLABTYPE,  
    ValPerc   
 HAVING   SUM(BALANCE_BROKERAGE) BETWEEN ISNULL(LOWERLIMIT,0) AND ISNULL(UPPERLIMIT,9999999999)                        
  
 --------------  Updating of Flat Brokerage For SubBroker  
 DECLARE  @REMCUR               CURSOR,                        
          @REMCODE              VARCHAR(10),                        
          @CUR_REMCODE          VARCHAR(10),                        
       @BRANCH_CD            VARCHAR(10),                        
          @CUR_BRANCH_CD        VARCHAR(10),                        
      @REM_PARTYCODE        VARCHAR(10),                        
      @CUR_REM_PARTYCODE    VARCHAR(10),                        
          @SHARE_PER            NUMERIC(18,4),                        
      @BALANCE_BROKERAGE    NUMERIC(18,4),                        
          @REM_BROKERAGE        NUMERIC(18,4),                        
          @CURBALANCE_BROKERAGE NUMERIC(18,4),                        
          @REMTYPE              VARCHAR(10),                        
          @LOWER_LIMIT          NUMERIC(18,4),                        
          @UPPER_LIMIT          NUMERIC(18,4),                        
          @SCHEMEID      INT,  
    @CUR_SCHEMEID    INT,  
    @VALPERC            VARCHAR(10)                        
               
 SET @REMCUR = CURSOR FOR SELECT R.SCHEMEID,  
             R.REMCODE,                        
                                 R.BRANCH_CD,                        
                       SHARE_PER = ISNULL(S.SHAREPER,0),                        
                                 BALANCE_BROKERAGE,                        
                                 REMTYPE, -- = ISNULL(R.REMTYPE,'SUB'),                        
                                 LOWER_LIMIT = ISNULL(LOWERLIMIT,0),                        
                                 UPPER_LIMIT = ISNULL(UPPERLIMIT,9999999999),                        
                          REMPARTYCD, --, = ISNULL(S.REMPARTYCD,R.REMPARTYCD)                        
             VALPERC  
                          FROM   #REMBROK_2 R                        
                                 LEFT OUTER JOIN RemisierBrokerageScheme S                        
                                   ON (R.SchemeID = S.SchemeID)                        
                          WHERE  R.REMTYPE = 'SUB' AND SLABTYPE = 'INCR'      
        ORDER BY R.BRANCH_CD, R.REMCODE, LOWERLIMIT        
                         
 OPEN @REMCUR                        
                         
 FETCH NEXT FROM @REMCUR           
 INTO @SCHEMEID,  
    @REMCODE,                        
      @BRANCH_CD,                        
      @SHARE_PER,                        
      @BALANCE_BROKERAGE,                        
      @REMTYPE,                        
      @LOWER_LIMIT,                        
      @UPPER_LIMIT,                        
      @REM_PARTYCODE,  
    @VALPERC                        
                         
 WHILE @@FETCH_STATUS = 0                        
   BEGIN                         
   --SELECT @BRANCH_CD, @SHARE_PER, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT                        
     SET @CUR_BRANCH_CD = @BRANCH_CD                        
     SET @CUR_REMCODE = @REMCODE  
   SET @CUR_SCHEMEID = @SCHEMEID                   
    SET @CUR_REM_PARTYCODE = @REM_PARTYCODE                        
     SET @REM_BROKERAGE = 0                        
     SET @CURBALANCE_BROKERAGE = @BALANCE_BROKERAGE                        
     IF @BALANCE_BROKERAGE > 0                        
        AND @SHARE_PER > 0                        
       BEGIN                        
         WHILE @CUR_REMCODE = @REMCODE                        
               AND @CUR_BRANCH_CD = @BRANCH_CD                        
       AND @CUR_SCHEMEID = @SCHEMEID   
       AND @CUR_REM_PARTYCODE = @REM_PARTYCODE   
               AND @@FETCH_STATUS = 0                        
           BEGIN                        
             IF @CUR_REMCODE = @REMCODE  
      AND @CUR_SCHEMEID = @SCHEMEID                        
                AND @CUR_REM_PARTYCODE = @REM_PARTYCODE                        
                AND @BALANCE_BROKERAGE > 0                        
                AND @CURBALANCE_BROKERAGE > 0                        
                AND @SHARE_PER > 0                        
                AND @@FETCH_STATUS = 0                        
               BEGIN       
                 IF @BALANCE_BROKERAGE >= @UPPER_LIMIT                        
                   BEGIN                        
         IF @VALPERC = 'P'  
                       SET @REM_BROKERAGE = @REM_BROKERAGE + ((@UPPER_LIMIT - @LOWER_LIMIT) * @SHARE_PER / 100)                        
        ELSE --- 'V'  
                       SET @REM_BROKERAGE = @REM_BROKERAGE + @SHARE_PER  
  
                     SET @CURBALANCE_BROKERAGE = @CURBALANCE_BROKERAGE - (@UPPER_LIMIT - @LOWER_LIMIT)                        
                     IF @CURBALANCE_BROKERAGE < 0                        
                       SET @CURBALANCE_BROKERAGE = 0                        
                   END                        
                 ELSE                        
                   BEGIN        
         IF @VALPERC = 'P'                   
                       SET @REM_BROKERAGE = @REM_BROKERAGE + @CURBALANCE_BROKERAGE * @SHARE_PER / 100                        
         ELSE  --- 'V'  
                       SET @REM_BROKERAGE = @REM_BROKERAGE + @SHARE_PER   
  
                     SET @CURBALANCE_BROKERAGE = 0                       
                     SET @BALANCE_BROKERAGE = 0               
                   END                        
               END                        
               --SELECT @REMCODE, @BRANCH_CD, @SHARE_PER, @CURBALANCE_BROKERAGE, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT, @REM_BROKERAGE                        
             FETCH NEXT FROM @REMCUR                        
             INTO @SCHEMEID,   
        @REMCODE,                        
                  @BRANCH_CD,                        
                  @SHARE_PER,                        
                  @BALANCE_BROKERAGE,                        
                  @REMTYPE,                        
                  @LOWER_LIMIT,                        
                  @UPPER_LIMIT,                        
              @REM_PARTYCODE,  
        @VALPERC                        
           END                        
         UPDATE #REMBROK_2                        
         SET    REM_PAYBROKERAGE = @REM_BROKERAGE,                        
                BALANCE_BROKERAGE = BALANCE_BROKERAGE - @REM_BROKERAGE--,                        
            --REMPARTYCD = @CUR_REM_PARTYCODE, SlabType = 'INCR'                        
         WHERE  REMCODE = @CUR_REMCODE                        
                AND BRANCH_CD = @CUR_BRANCH_CD    
      AND SCHEMEID = @SCHEMEID                      
      AND REMPARTYCD = @CUR_REM_PARTYCODE  
                AND REMTYPE = 'SUB'                        
       END                        
     ELSE                        
       BEGIN                        
       --SELECT @REMCODE, @BRANCH_CD, @SHARE_PER, @CURBALANCE_BROKERAGE, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT, @REM_BROKERAGE                        
         FETCH NEXT FROM @REMCUR                        
         INTO @SCHEMEID,   
      @REMCODE,                        
              @BRANCH_CD,                        
              @SHARE_PER,                        
              @BALANCE_BROKERAGE,                        
              @REMTYPE,                   
              @LOWER_LIMIT,                        
              @UPPER_LIMIT,                        
         @REM_PARTYCODE,  
      @VALPERC                         
       END                        
   END       
  
----------------------------------  
 UPDATE #REMBROK_2 SET   
  Rem_NSECMBrok = NSECMBrok*Rem_PayBrokerage/(NSECMBrok+BSECMBrok+NSEFOBrok),  
  Rem_BSECMBrok = BSECMBrok*Rem_PayBrokerage/(NSECMBrok+BSECMBrok+NSEFOBrok),  
  Rem_NSEFOBrok = NSEFoBrok*Rem_PayBrokerage/(NSECMBrok+BSECMBrok+NSEFOBrok)  
  
 --- Update the Balance Brokerage              
 UPDATE #REMBROK_2 SET BALANCE_BROKERAGE = CL_BROKERAGE - REM_PAYBROKERAGE                        
  
 ---BRANCH BROKERAGE SHARING   
 SELECT   
  BRANCH_CD,   
  REMCODE,   
  FROMDATE,  
  TODATE,  
  SUM(NSECMBROK) AS NSECMBROK,   
  SUM(BSECMBROK) AS BSECMBROK,   
  SUM(NSEFOBROK) AS NSEFOBROK,   
  SUM(NSECMBROK + BSECMBROK - REM_NSECMBROK - REM_BSECMBROK) AS BALANCE_BROKERAGE_CAPITAL,   
  SUM(NSEFOBROK - REM_NSEFOBROK) AS BALANCE_BROKERAGE_FUTURES,   
  SUM(BALANCE_BROKERAGE) AS BALANCE_BROKERAGE,  
  SUM(REM_NSECMBROK + REM_BSECMBROK) AS REM_PAYBROKERAGE_CAPITAL,  
  SUM(REM_NSEFOBROK) AS REM_PAYBROKERAGE_FUTURES,   
  REMPARTYCD = CONVERT(VARCHAR(10), ''),  
  SHARE_PER_CAPITAL = CONVERT(NUMERIC(18,4),0),  
  SHARE_PER_FUTURES = CONVERT(NUMERIC(18,4),0),  
  SCHEMEID_CAPITAL = CONVERT(INT, ''),  
  SCHEMEID_FUTURES = CONVERT(INT, ''),  
  SLABTYPE_CAPITAL = CONVERT(VARCHAR(10), ''),  --FLAT/INCR  
  SLABTYPE_FUTURES = CONVERT(VARCHAR(10), '')  --FLAT/INCR  
  INTO #REMBROK_2BR  
 FROM #REMBROK_2  
 GROUP BY   
  BRANCH_CD,   
  REMCODE,   
  FROMDATE,  
  TODATE  
  
 --- Update SchemeID For All Sub Broker (For CAPITAL & FUTURES MARKET - BRANCHS Only)  
 UPDATE #REMBROK_2BR SET  
   SLABTYPE_CAPITAL = CASE  WHEN R.SEGMENT = 'CAPITAL' OR R.SEGMENT = 'ALL' THEN R.BrokType ELSE '' END,   
   SLABTYPE_FUTURES = CASE WHEN R.SEGMENT = 'FUTURES' OR R.SEGMENT = 'ALL' THEN R.BrokType ELSE '' END,   
   SCHEMEID_CAPITAL = CASE WHEN R.SEGMENT = 'CAPITAL' OR R.SEGMENT = 'ALL' THEN R.SchemeID ELSE 0 END,   
   SCHEMEID_FUTURES = CASE WHEN R.SEGMENT = 'FUTURES' OR R.SEGMENT = 'ALL' THEN R.SchemeID ELSE 0 END,   
   REMPARTYCD = R.RemPartyCd   
 FROM #REMBROK_2BR A, #RemisierAllParty R  
 WHERE  
  A.BRANCH_CD = R.BRANCHCODE AND  
  A.REMCODE = R.SUBBROKER AND   
  A.FROMDATE >= R.FROMDATE AND   
  A.TODATE <= A.TODATE AND  
  R.REMTYPE = 'BR'  
  
 --- Overright SchemeID For Specific Sub Broker (For CAPITAL & FUTURES MARKET - BRANCHS Only)  
 UPDATE #REMBROK_2BR SET  
   SLABTYPE_CAPITAL = CASE  WHEN R.SEGMENT = 'CAPITAL' OR R.SEGMENT = 'ALL' THEN R.BrokType ELSE '' END,   
   SLABTYPE_FUTURES = CASE WHEN R.SEGMENT = 'FUTURES' OR R.SEGMENT = 'ALL' THEN R.BrokType ELSE ''END,   
   SCHEMEID_CAPITAL = CASE WHEN R.SEGMENT = 'CAPITAL' OR R.SEGMENT = 'ALL' THEN R.SchemeID ELSE 0 END,   
   SCHEMEID_FUTURES = CASE WHEN R.SEGMENT = 'FUTURES' OR R.SEGMENT = 'ALL' THEN R.SchemeID ELSE 0 END,   
   REMPARTYCD = R.RemPartyCd   
 FROM #REMBROK_2BR A, #RemisierSpecificParty R  
 WHERE  
  A.BRANCH_CD = R.BRANCHCODE AND  
  A.REMCODE = R.SUBBROKER AND   
  A.FROMDATE >= R.FROMDATE AND   
  A.TODATE <= A.TODATE AND  
  R.REMTYPE = 'BR'  
  
 --- Update SchemeID With Zero For Blocked Sub Brokers (For CAPITAL & FUTURES MARKET & BRANCHS Only)  
 UPDATE #REMBROK_2BR SET  
   SLABTYPE_CAPITAL = CASE  WHEN R.SEGMENT = 'CAPITAL' OR R.SEGMENT = 'ALL' THEN '' END,   
   SLABTYPE_FUTURES = CASE WHEN R.SEGMENT = 'FUTURES' OR R.SEGMENT = 'ALL' THEN ''END,   
   SCHEMEID_CAPITAL = CASE WHEN R.SEGMENT = 'CAPITAL' OR R.SEGMENT = 'ALL' THEN 0 END,   
   SCHEMEID_FUTURES = CASE WHEN R.SEGMENT = 'FUTURES' OR R.SEGMENT = 'ALL' THEN 0 END,   
   REMPARTYCD = ''   
 FROM #REMBROK_2BR A, #RemisierBlockedParty R  
 WHERE  
  A.BRANCH_CD = R.BRANCHCODE AND  
  A.REMCODE = R.SUBBROKER AND   
  A.FROMDATE >= R.FROMDATE AND   
  A.TODATE <= A.TODATE AND  
  R.SubBrokerOrBranch = 'BR'   
  
 ---BRANCH BROKERAGE SHARING AFTER SCHEME ID UPDATION  
 SELECT   
  BRANCH_CD,   
  FROMDATE,  
  TODATE,  
  REMPARTYCD,   
-- --   SUM(NSECMBROK) AS NSECMBROK,   
-- --   SUM(BSECMBROK) AS BSECMBROK,   
-- --   SUM(NSEFOBROK) AS NSEFOBROK,   
  SUM(CASE WHEN SCHEMEID_CAPITAL <> 0 THEN NSECMBROK ELSE 0 END) AS NSECMBROK,   
  SUM(CASE WHEN SCHEMEID_CAPITAL <> 0 THEN BSECMBROK ELSE 0 END) AS BSECMBROK,   
  SUM(CASE WHEN SCHEMEID_FUTURES <> 0 THEN NSEFOBROK ELSE 0 END) AS NSEFOBROK,   
  SUM(CASE WHEN SCHEMEID_CAPITAL <> 0 THEN BALANCE_BROKERAGE_CAPITAL ELSE 0 END) AS BALANCE_BROKERAGE_CAPITAL,   
  SUM(CASE WHEN SCHEMEID_FUTURES <> 0 THEN BALANCE_BROKERAGE_FUTURES ELSE 0 END) AS BALANCE_BROKERAGE_FUTURES,   
  --SUM(BALANCE_BROKERAGE) AS BALANCE_BROKERAGE,  
  SUM(CASE WHEN SCHEMEID_CAPITAL <> 0 THEN BALANCE_BROKERAGE_CAPITAL WHEN SCHEMEID_FUTURES <> 0 THEN BALANCE_BROKERAGE_FUTURES ELSE 0 END) AS BALANCE_BROKERAGE,   
-- --   SUM(REM_PAYBROKERAGE_CAPITAL) AS REM_PAYBROKERAGE_CAPITAL_SUB,  
-- --   SUM(REM_PAYBROKERAGE_FUTURES) AS REM_PAYBROKERAGE_FUTURES_SUB,  
  REM_PAYBROKERAGE_CAPITAL = CONVERT(NUMERIC(18,4),0),  
  REM_PAYBROKERAGE_FUTURES = CONVERT(NUMERIC(18,4),0),  
  REM_PAYBROKERAGE_CAPITAL_BR = CONVERT(NUMERIC(18,4),0),  
  REM_PAYBROKERAGE_FUTURES_BR = CONVERT(NUMERIC(18,4),0),  
  SHARE_PER_CAPITAL,  
  SHARE_PER_FUTURES,  
  SCHEMEID_CAPITAL,  
  SCHEMEID_FUTURES,  
  SLABTYPE_CAPITAL,  --FLAT/INCR  
  SLABTYPE_FUTURES --FLAT/INCR  
 INTO #REMBROK_3BR  
 FROM #REMBROK_2BR  
 WHERE SCHEMEID_CAPITAL > 0 OR SCHEMEID_FUTURES > 0  
 GROUP BY   
  BRANCH_CD,   
  FROMDATE,  
  TODATE,  
  REMPARTYCD,  
  SHARE_PER_CAPITAL,  
  SHARE_PER_FUTURES,  
  SCHEMEID_CAPITAL,  
  SCHEMEID_FUTURES,  
  SLABTYPE_CAPITAL,  --FLAT/INCR  
  SLABTYPE_FUTURES --FLAT/INCR  
  
 -- (CASE WHEN ValPerc = 'P' THEN   
 --- UPDATE FLAT BROKERAGE FOR CAPITAL MARKET FOR CAPITAL & FUTURES HAS DIFFERENT SCHEMES  
 UPDATE #REMBROK_3BR SET  
   REM_PAYBROKERAGE_CAPITAL = (BALANCE_BROKERAGE_CAPITAL) *   
            (CASE WHEN ValPerc = 'P' THEN (CASE WHEN ISNULL(R.SHAREPER, 0) > 0 THEN ISNULL(R.SHAREPER,0)/100 ELSE 0 END )  
                ELSE ISNULL(R.SHAREPER, 0)  
             END),  
  -- BALANCE_BROKERAGE_CAPITAL = (BALANCE_BROKERAGE_CAPITAL) - (BALANCE_BROKERAGE_CAPITAL) * (CASE WHEN ISNULL(R.SHAREPER, 0) > 0 THEN ISNULL(R.SHAREPER,0)/100 ELSE 0 END ),  
   SHARE_PER_CAPITAL = ISNULL(SHAREPER, 0)  
 FROM #REMBROK_3BR AS A, REMISIERBROKERAGESCHEME AS R  
 WHERE A.SCHEMEID_CAPITAL > 0   
  AND SLABTYPE_CAPITAL = 'FLAT'  
  AND A.SCHEMEID_CAPITAL <> A.SCHEMEID_FUTURES  
  AND A.SCHEMEID_CAPITAL = R. SCHEMEID  
  AND BALANCE_BROKERAGE BETWEEN ISNULL(LOWERLIMIT,0)  AND ISNULL(UPPERLIMIT,9999999999)     
  
 --- UPDATE FLAT BROKERAGE FOR FUTURES MARKET FOR CAPITAL & FUTURES HAS DIFFERENT SCHEMES  
 UPDATE #REMBROK_3BR SET  
   REM_PAYBROKERAGE_FUTURES = (BALANCE_BROKERAGE_FUTURES) *   
            (CASE WHEN ValPerc = 'P' THEN (CASE WHEN ISNULL(R.SHAREPER, 0) > 0 THEN ISNULL(R.SHAREPER,0)/100 ELSE 0 END )  
              ELSE ISNULL(R.SHAREPER, 0)  
            END),     
  -- BALANCE_BROKERAGE_FUTURES = (BALANCE_BROKERAGE_FUTURES) - (BALANCE_BROKERAGE_FUTURES) * (CASE WHEN ISNULL(R.SHAREPER, 0) > 0 THEN ISNULL(R.SHAREPER,0)/100 ELSE 0 END ),  
   SHARE_PER_FUTURES = ISNULL(SHAREPER, 0)  
 FROM #REMBROK_3BR AS A, REMISIERBROKERAGESCHEME AS R   
 WHERE A.SCHEMEID_FUTURES > 0   
  AND SLABTYPE_FUTURES = 'FLAT'  
  AND A.SCHEMEID_CAPITAL <> A.SCHEMEID_FUTURES  
  AND A.SCHEMEID_FUTURES = R. SCHEMEID  
  AND BALANCE_BROKERAGE BETWEEN ISNULL(LOWERLIMIT,0)  AND ISNULL(UPPERLIMIT,9999999999)     
  
 UPDATE #REMBROK_3BR SET   
  BALANCE_BROKERAGE_CAPITAL = BALANCE_BROKERAGE_CAPITAL - REM_PAYBROKERAGE_CAPITAL ,  
  BALANCE_BROKERAGE_FUTURES = BALANCE_BROKERAGE_FUTURES - REM_PAYBROKERAGE_FUTURES  ,  
  BALANCE_BROKERAGE = (BALANCE_BROKERAGE_CAPITAL - REM_PAYBROKERAGE_CAPITAL ) +  (BALANCE_BROKERAGE_FUTURES - REM_PAYBROKERAGE_FUTURES )  
  
 --- UPDATE FLAT BROKERAGE FOR FUTURES MARKET FOR CAPITAL & FUTURES HAS SAME SCHEMES  
 UPDATE #REMBROK_3BR SET  
   REM_PAYBROKERAGE_CAPITAL = (CASE WHEN ValPerc = 'P' THEN (BALANCE_BROKERAGE_CAPITAL)*   
                       ((BALANCE_BROKERAGE_CAPITAL + BALANCE_BROKERAGE_FUTURES) * (CASE WHEN ISNULL(R.SHAREPER, 0) > 0 THEN ISNULL(R.SHAREPER,0)/100 ELSE 0 END ))   
                ELSE ISNULL(R.SHAREPER, 0)  
             END) / (BALANCE_BROKERAGE_CAPITAL + BALANCE_BROKERAGE_FUTURES),  
   REM_PAYBROKERAGE_FUTURES = (CASE WHEN ValPerc = 'P' THEN (BALANCE_BROKERAGE_FUTURES)*   
                      ((BALANCE_BROKERAGE_CAPITAL + BALANCE_BROKERAGE_FUTURES) * (CASE WHEN ISNULL(R.SHAREPER, 0) > 0 THEN ISNULL(R.SHAREPER,0)/100 ELSE 0 END ))   
              ELSE ISNULL(R.SHAREPER, 0)  
             END) / (BALANCE_BROKERAGE_CAPITAL + BALANCE_BROKERAGE_FUTURES),  
   SHARE_PER_CAPITAL = ISNULL(SHAREPER, 0),  
   SHARE_PER_FUTURES = ISNULL(SHAREPER, 0)  
 FROM #REMBROK_3BR AS A, REMISIERBROKERAGESCHEME AS R  
 WHERE A.SCHEMEID_CAPITAL > 0 AND SCHEMEID_FUTURES > 0   
  AND SLABTYPE_CAPITAL = 'FLAT'  
  AND A.SCHEMEID_CAPITAL = A.SCHEMEID_FUTURES  
  AND A.SCHEMEID_CAPITAL = R.SCHEMEID  
  AND BALANCE_BROKERAGE BETWEEN ISNULL(LOWERLIMIT,0)  AND ISNULL(UPPERLIMIT,9999999999)     
  
 --- BROKERAGE FOR BRANCH - CAPITAL                                               
 SET @REMCUR = CURSOR FOR SELECT R.SCHEMEID_CAPITAL,  
            R.BRANCH_CD,                        
                                SHARE_PER = Isnull(S.SHAREPER,0),                        
                                BALANCE_BROKERAGE_CAPITAL,                    
                                REMTYPE = 'BR',                        
                                LOWER_LIMIT = Isnull(LOWERLIMIT,0),                        
                                UPPER_LIMIT = Isnull(UPPERLIMIT,9999999999),                        
                      REMPARTYCD,  
            VALPERC  
                         FROM   #REMBROK_3BR R, REMISIERBROKERAGESCHEME AS S                        
         WHERE R.SCHEMEID_CAPITAL > 0   
           AND SLABTYPE_CAPITAL = 'INCR'  
           AND R.SCHEMEID_CAPITAL <> R.SCHEMEID_FUTURES  
           AND R.SCHEMEID_CAPITAL = S.SCHEMEID  
             ORDER BY R.BRANCH_CD, LOWER_LIMIT        
 OPEN @REMCUR                        
             
 FETCH NEXT FROM @REMCUR                        
 INTO @SCHEMEID,  
    @BRANCH_CD,                        
      @SHARE_PER,                        
      @BALANCE_BROKERAGE,                        
      @REMTYPE,                        
      @LOWER_LIMIT,                        
      @UPPER_LIMIT,                    
      @REM_PARTYCODE,  
    @VALPERC                 
         
 WHILE @@FETCH_STATUS = 0            
 BEGIN                         
    SET @CUR_BRANCH_CD = @BRANCH_CD                        
   SET @CUR_REM_PARTYCODE = @REM_PARTYCODE   
  SET @CUR_SCHEMEID = @SCHEMEID                      
    SET @REM_BROKERAGE = 0                        
    SET @CURBALANCE_BROKERAGE = @BALANCE_BROKERAGE                        
    IF @BALANCE_BROKERAGE > 0 AND @SHARE_PER > 0                        
       BEGIN                        
         WHILE @CUR_BRANCH_CD = @BRANCH_CD                        
       AND @CUR_SCHEMEID = @SCHEMEID  
               AND @@FETCH_STATUS = 0                        
           BEGIN                        
             IF @CUR_BRANCH_CD = @BRANCH_CD                        
      AND @CUR_SCHEMEID = @SCHEMEID  
                AND @BALANCE_BROKERAGE > 0                        
                AND @CURBALANCE_BROKERAGE > 0                        
                AND @SHARE_PER > 0                        
                AND @@FETCH_STATUS = 0                        
               BEGIN                        
       IF @BALANCE_BROKERAGE >= @UPPER_LIMIT                        
                   BEGIN  
         IF @VALPERC = 'P'                         
                       SET @REM_BROKERAGE = @REM_BROKERAGE + ((@UPPER_LIMIT - @LOWER_LIMIT) * @SHARE_PER / 100)                        
         ELSE  -- 'V'  
                       SET @REM_BROKERAGE = @REM_BROKERAGE + @SHARE_PER   
                     SET @CURBALANCE_BROKERAGE = @CURBALANCE_BROKERAGE - (@UPPER_LIMIT - @LOWER_LIMIT)                        
                     IF @CURBALANCE_BROKERAGE < 0                        
                       SET @CURBALANCE_BROKERAGE = 0                        
                   END                        
                 ELSE                        
                   BEGIN                 
         IF @VALPERC = 'P'                                
                      SET @REM_BROKERAGE = @REM_BROKERAGE + @CURBALANCE_BROKERAGE * @SHARE_PER / 100                        
         ELSE  -- 'V'  
                      SET @REM_BROKERAGE = @REM_BROKERAGE + @SHARE_PER   
  
                     SET @CURBALANCE_BROKERAGE = 0                        
                     SET @BALANCE_BROKERAGE = 0                        
                   END                        
       END                        
              --SELECT @BRANCH_CD, @SHARE_PER, @CURBALANCE_BROKERAGE, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT, @REM_BROKERAGE                        
            FETCH NEXT FROM @REMCUR                        
            INTO @SCHEMEID,  
       @BRANCH_CD,                        
                 @SHARE_PER,                        
                 @BALANCE_BROKERAGE,                        
                 @REMTYPE,                        
                 @LOWER_LIMIT,                        
                 @UPPER_LIMIT,                        
           @REM_PARTYCODE,  
       @VALPERC                        
          END                        
        UPDATE #REMBROK_3BR                        
        SET    REM_PAYBROKERAGE_CAPITAL = @REM_BROKERAGE,                        
               BALANCE_BROKERAGE_CAPITAL = BALANCE_BROKERAGE_CAPITAL - @REM_BROKERAGE                        
        WHERE  BRANCH_CD = @CUR_BRANCH_CD                        
               AND SCHEMEID_CAPITAL = @CUR_SCHEMEID                                              
      END                        
    ELSE                        
      BEGIN                        
        FETCH NEXT FROM @REMCUR                        
        INTO @SCHEMEID,  
     @BRANCH_CD,                        
             @SHARE_PER,                        
             @BALANCE_BROKERAGE,                        
             @REMTYPE,                        
             @LOWER_LIMIT,                        
             @UPPER_LIMIT,                        
          @REM_PARTYCODE,  
     @VALPERC                        
      END                        
  END                        
  
 --- BROKERAGE FOR BRANCH - FUTURES                                               
 SET @REMCUR = CURSOR FOR SELECT R.SCHEMEID_FUTURES,  
            R.BRANCH_CD,                        
                                SHARE_PER = Isnull(S.SHAREPER,0),                        
                                BALANCE_BROKERAGE_FUTURES,                    
                                REMTYPE = 'BR',                        
                                LOWER_LIMIT = Isnull(LOWERLIMIT,0),                        
                                UPPER_LIMIT = Isnull(UPPERLIMIT,9999999999),                        
                      REMPARTYCD,  
            VALPERC  
                         FROM   #REMBROK_3BR R, REMISIERBROKERAGESCHEME AS S                        
         WHERE R.SCHEMEID_FUTURES > 0   
           AND SLABTYPE_FUTURES = 'INCR'  
           AND R.SCHEMEID_CAPITAL <> R.SCHEMEID_FUTURES  
           AND R.SCHEMEID_FUTURES = S.SCHEMEID  
             ORDER BY R.BRANCH_CD, LOWER_LIMIT        
 OPEN @REMCUR                        
             
 FETCH NEXT FROM @REMCUR                        
 INTO @SCHEMEID,  
    @BRANCH_CD,                        
      @SHARE_PER,                        
      @BALANCE_BROKERAGE,                        
      @REMTYPE,                        
      @LOWER_LIMIT,                        
      @UPPER_LIMIT,                    
      @REM_PARTYCODE,  
    @VALPERC                
         
 WHILE @@FETCH_STATUS = 0            
 BEGIN            
    SET @CUR_BRANCH_CD = @BRANCH_CD                        
   SET @CUR_REM_PARTYCODE = @REM_PARTYCODE   
  SET @CUR_SCHEMEID = @SCHEMEID                      
    SET @REM_BROKERAGE = 0                        
    SET @CURBALANCE_BROKERAGE = @BALANCE_BROKERAGE                        
    IF @BALANCE_BROKERAGE > 0 AND @SHARE_PER > 0                        
       BEGIN                        
         WHILE @CUR_BRANCH_CD = @BRANCH_CD                        
       AND @CUR_SCHEMEID = @SCHEMEID  
               AND @@FETCH_STATUS = 0                        
           BEGIN                        
             IF @CUR_BRANCH_CD = @BRANCH_CD                        
      AND @CUR_SCHEMEID = @SCHEMEID  
    AND @BALANCE_BROKERAGE > 0                        
                AND @CURBALANCE_BROKERAGE > 0                        
                AND @SHARE_PER > 0                        
                AND @@FETCH_STATUS = 0          
               BEGIN                        
       IF @BALANCE_BROKERAGE >= @UPPER_LIMIT                        
                   BEGIN             
         IF @VALPERC = 'P'                                           
                       SET @REM_BROKERAGE = @REM_BROKERAGE + ((@UPPER_LIMIT - @LOWER_LIMIT) * @SHARE_PER / 100)                        
         ELSE  --- 'V'  
                       SET @REM_BROKERAGE = @REM_BROKERAGE + @SHARE_PER   
  
                     SET @CURBALANCE_BROKERAGE = @CURBALANCE_BROKERAGE - (@UPPER_LIMIT - @LOWER_LIMIT)                        
                     IF @CURBALANCE_BROKERAGE < 0                        
                       SET @CURBALANCE_BROKERAGE = 0                        
                   END                        
                 ELSE                        
                   BEGIN                        
         IF @VALPERC = 'P'                                           
                       SET @REM_BROKERAGE = @REM_BROKERAGE + @CURBALANCE_BROKERAGE * @SHARE_PER / 100                        
         ELSE   -- 'V'  
                       SET @REM_BROKERAGE = @REM_BROKERAGE + @SHARE_PER   
   
                     SET @CURBALANCE_BROKERAGE = 0                        
                     SET @BALANCE_BROKERAGE = 0                        
                   END                        
       END                        
              --SELECT @BRANCH_CD, @SHARE_PER, @CURBALANCE_BROKERAGE, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT, @REM_BROKERAGE                        
            FETCH NEXT FROM @REMCUR                        
            INTO @SCHEMEID,  
       @BRANCH_CD,                        
                 @SHARE_PER,                        
                 @BALANCE_BROKERAGE,                        
                 @REMTYPE,                        
                 @LOWER_LIMIT,                        
                 @UPPER_LIMIT,                        
           @REM_PARTYCODE,  
       @VALPERC                        
          END          
        UPDATE #REMBROK_3BR                        
        SET    REM_PAYBROKERAGE_FUTURES = @REM_BROKERAGE,                        
               BALANCE_BROKERAGE_FUTURES = BALANCE_BROKERAGE_FUTURES - @REM_BROKERAGE                        
        WHERE  BRANCH_CD = @CUR_BRANCH_CD                        
               AND SCHEMEID_FUTURES = @CUR_SCHEMEID                                              
      END                        
    ELSE                        
      BEGIN                        
        FETCH NEXT FROM @REMCUR                        
        INTO @SCHEMEID,  
     @BRANCH_CD,                        
             @SHARE_PER,                        
             @BALANCE_BROKERAGE,                        
             @REMTYPE,                        
             @LOWER_LIMIT,                        
             @UPPER_LIMIT,                        
          @REM_PARTYCODE,  
     @VALPERC                        
      END                        
  END           
               
  
 --- BROKERAGE FOR BRANCH - CAPITAL & FUTURES HAS SAME SCHEMEID  
 SET @REMCUR = CURSOR FOR SELECT R.SCHEMEID_FUTURES,  
            R.BRANCH_CD,                        
                                SHARE_PER = Isnull(S.SHAREPER,0),  
                                BALANCE_BROKERAGE_CAPITAL + BALANCE_BROKERAGE_FUTURES,                    
                                REMTYPE = 'BR',                        
                                LOWER_LIMIT = Isnull(LOWERLIMIT,0),                        
                                UPPER_LIMIT = Isnull(UPPERLIMIT,9999999999),                        
                      REMPARTYCD,  
            VALPERC  
                         FROM   #REMBROK_3BR R, REMISIERBROKERAGESCHEME AS S                        
         WHERE R.SCHEMEID_FUTURES > 0   
           AND SLABTYPE_FUTURES = 'INCR'  
           AND R.SCHEMEID_CAPITAL = R.SCHEMEID_FUTURES  
           AND R.SCHEMEID_FUTURES = S.SCHEMEID  
             ORDER BY R.BRANCH_CD, LOWER_LIMIT        
 OPEN @REMCUR                        
             
 FETCH NEXT FROM @REMCUR                        
 INTO @SCHEMEID,  
    @BRANCH_CD,                        
      @SHARE_PER,                        
      @BALANCE_BROKERAGE,                        
      @REMTYPE,                        
      @LOWER_LIMIT,                        
      @UPPER_LIMIT,                    
      @REM_PARTYCODE,  
    @VALPERC                
         
 WHILE @@FETCH_STATUS = 0            
 BEGIN            
    SET @CUR_BRANCH_CD = @BRANCH_CD                        
   SET @CUR_REM_PARTYCODE = @REM_PARTYCODE   
  SET @CUR_SCHEMEID = @SCHEMEID                      
    SET @REM_BROKERAGE = 0                        
    SET @CURBALANCE_BROKERAGE = @BALANCE_BROKERAGE                        
    IF @BALANCE_BROKERAGE > 0 AND @SHARE_PER > 0                        
       BEGIN                        
         WHILE @CUR_BRANCH_CD = @BRANCH_CD                        
       AND @CUR_SCHEMEID = @SCHEMEID  
               AND @@FETCH_STATUS = 0                        
           BEGIN                        
             IF @CUR_BRANCH_CD = @BRANCH_CD                        
      AND @CUR_SCHEMEID = @SCHEMEID  
                AND @BALANCE_BROKERAGE > 0                        
                AND @CURBALANCE_BROKERAGE > 0                        
                AND @SHARE_PER > 0                        
                AND @@FETCH_STATUS = 0                        
               BEGIN                        
       IF @BALANCE_BROKERAGE >= @UPPER_LIMIT                        
                   BEGIN             
         IF @VALPERC = 'P'                                           
                       SET @REM_BROKERAGE = @REM_BROKERAGE + ((@UPPER_LIMIT - @LOWER_LIMIT) * @SHARE_PER / 100)                        
         ELSE  --- 'V'  
                       SET @REM_BROKERAGE = @REM_BROKERAGE + @SHARE_PER   
  
                     SET @CURBALANCE_BROKERAGE = @CURBALANCE_BROKERAGE - (@UPPER_LIMIT - @LOWER_LIMIT)                        
                     IF @CURBALANCE_BROKERAGE < 0                        
                       SET @CURBALANCE_BROKERAGE = 0                        
                   END                        
                 ELSE                        
                   BEGIN                        
         IF @VALPERC = 'P'                                           
                       SET @REM_BROKERAGE = @REM_BROKERAGE + @CURBALANCE_BROKERAGE * @SHARE_PER / 100                        
         ELSE   -- 'V'  
                       SET @REM_BROKERAGE = @REM_BROKERAGE + @SHARE_PER   
   
                     SET @CURBALANCE_BROKERAGE = 0                        
                     SET @BALANCE_BROKERAGE = 0                        
                   END                        
       END                        
              --SELECT @BRANCH_CD, @SHARE_PER, @CURBALANCE_BROKERAGE, @BALANCE_BROKERAGE, @REMTYPE, @FROMDATE, @TODATE, @LOWER_LIMIT, @UPPER_LIMIT, @REM_BROKERAGE                        
            FETCH NEXT FROM @REMCUR                        
            INTO @SCHEMEID,  
       @BRANCH_CD,                        
                 @SHARE_PER,                        
                 @BALANCE_BROKERAGE,                        
                 @REMTYPE,                        
                 @LOWER_LIMIT,                        
                 @UPPER_LIMIT,                        
           @REM_PARTYCODE,  
       @VALPERC                        
          END          
-- --         UPDATE #REMBROK_3BR                        
-- --         SET    REM_PAYBROKERAGE_FUTURES = @REM_BROKERAGE,                        
-- --                BALANCE_BROKERAGE_FUTURES = BALANCE_BROKERAGE_FUTURES - @REM_BROKERAGE                        
-- --         WHERE  BRANCH_CD = @CUR_BRANCH_CD                        
-- --                AND SCHEMEID_FUTURES = @CUR_SCHEMEID    
  
        UPDATE #REMBROK_3BR                        
        SET  REM_PAYBROKERAGE_FUTURES = (BALANCE_BROKERAGE_FUTURES * @REM_BROKERAGE) /(BALANCE_BROKERAGE_CAPITAL + BALANCE_BROKERAGE_FUTURES),                       
     REM_PAYBROKERAGE_CAPITAL = (BALANCE_BROKERAGE_CAPITAL * @REM_BROKERAGE) /(BALANCE_BROKERAGE_CAPITAL + BALANCE_BROKERAGE_FUTURES),                       
             BALANCE_BROKERAGE_FUTURES = BALANCE_BROKERAGE_FUTURES - (BALANCE_BROKERAGE_FUTURES * @REM_BROKERAGE) /(BALANCE_BROKERAGE_CAPITAL + BALANCE_BROKERAGE_FUTURES),  
             BALANCE_BROKERAGE_CAPITAL = BALANCE_BROKERAGE_CAPITAL - (BALANCE_BROKERAGE_CAPITAL * @REM_BROKERAGE) /(BALANCE_BROKERAGE_CAPITAL + BALANCE_BROKERAGE_FUTURES)  
        WHERE  BRANCH_CD = @CUR_BRANCH_CD                        
               AND SCHEMEID_FUTURES = @CUR_SCHEMEID                                              
  
      END                        
    ELSE                        
      BEGIN                        
        FETCH NEXT FROM @REMCUR                        
        INTO @SCHEMEID,  
     @BRANCH_CD,                        
             @SHARE_PER,                        
             @BALANCE_BROKERAGE,                        
             @REMTYPE,                        
             @LOWER_LIMIT,                        
             @UPPER_LIMIT,                        
          @REM_PARTYCODE,  
     @VALPERC                        
      END                        
  END                        
  
-- --  SELECT * FROM #REMBROK_2  
-- --  SELECT * FROM #REMBROK_2BR  
-- --  SELECT * FROM #REMBROK_3BR  
  
 INSERT INTO #REMBROK_2(  
  REMCODE,                        
  BRANCH_CD,           
  SHARE_PER,  
  NSECMBrok,  
  BSECMBrok,  
  NSEFOBrok,  
  CL_BROKERAGE,  
  REM_PAYBROKERAGE,  
  BALANCE_BROKERAGE,  
  REMTYPE,  
  FROMDATE,                        
  TODATE,                        
  REMPARTYCD,  
  SLABTYPE,  
  REM_NSECMBrok,  
  REM_BSECMBrok,  
  REM_NSEFOBrok)  
 SELECT    
  REMCODE = '',                        
  BRANCH_CD,           
  SHARE_PER = CASE WHEN SHARE_PER_CAPITAL <> 0 THEN SHARE_PER_CAPITAL ELSE SHARE_PER_FUTURES END,   
  NSECMBrok,   
  BSECMBrok,  
  NSEFOBrok ,  
  (NSECMBrok + BSECMBrok + NSEFOBrok) AS CL_BROKERAGE,  
  REM_PAYBROKERAGE = REM_PAYBROKERAGE_CAPITAL + REM_PAYBROKERAGE_FUTURES,             
  BALANCE_BROKERAGE = BALANCE_BROKERAGE_CAPITAL + BALANCE_BROKERAGE_FUTURES,  
  REMTYPE = 'BR',                        
  FROMDATE,                        
  TODATE,                        
  REMPARTYCD,  
  SLABTYPE = CASE WHEN SLABTYPE_CAPITAL <> '' THEN SLABTYPE_CAPITAL ELSE SLABTYPE_FUTURES END,  
  REM_NSECMBrok = 0,--REM_NSECMBrok,          
  REM_BSECMBrok = 0,--REM_BSECMBrok,          
  REM_NSEFOBrok = 0--REM_NSEFOBrok  
 FROM #REMBROK_3BR  
  
 --- UPDATE NSE/BSE/NSEFO REMISIER BROKERAGE SHARING   
 UPDATE #REMBROK_2 SET   
  Rem_NSECMBrok = NSECMBrok*Rem_PayBrokerage/(NSECMBrok+BSECMBrok+NSEFOBrok),  
  Rem_BSECMBrok = BSECMBrok*Rem_PayBrokerage/(NSECMBrok+BSECMBrok+NSEFOBrok),  
  Rem_NSEFOBrok = NSEFoBrok*Rem_PayBrokerage/(NSECMBrok+BSECMBrok+NSEFOBrok)  
  
 ---- REMOVE THE EXISTING RECORDS IN THE REM_TRANS_TABLE TABLE                     
 DELETE FROM REM_BROK_TRANS WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE                        
  
 --- INSERT THE NEW COMPUTED RECORDS FORM #REMBROK_2 TO REM_TRANS TABLE                     
 INSERT INTO REM_BROK_TRANS(  
  SETT_NO,  
  SETT_TYPE,  
  REMCODE,                        
  BRANCH_CD,                        
  SHARE_PER,  
  NSECMBROK,  
  BSECMBROK,  
  NSEFOBROK,  
  CL_BROKERAGE,  
  REM_PAYBROKERAGE,  
  BALANCE_BROKERAGE,  
  REMTYPE,  
  FROMDATE,                        
  TODATE,                        
  REMPARTYCD,   
  SLABTYPE,   
  REM_NSECMBROK,  
  REM_BSECMBROK,  
  REM_NSEFOBROK,  
  Rem_NSECMTds,  
  Rem_BSECMTds,  
  Rem_NSEFOTds,  
  TDSPercentage)  
 SELECT  
  SETT_NO = @SETT_NO,  
  SETT_TYPE = @SETT_TYPE,     
  R.REMCODE,                        
  R.BRANCH_CD,                        
  R.SHARE_PER,  
  R.NSECMBROK,  
  R.BSECMBROK,  
  R.NSEFOBROK,  
  R.CL_BROKERAGE,  
  R.REM_PAYBROKERAGE,  
  R.BALANCE_BROKERAGE,  
  R.REMTYPE,  
  R.FROMDATE,                        
  R.TODATE,                        
  R.REMPARTYCD,   
  R.SLABTYPE,   
  R.REM_NSECMBROK,  
  R.REM_BSECMBROK,  
  R.REM_NSEFOBROK,  
  Rem_NSECMTds = R.Rem_NSECMBrok * ISNULL(S.TDSPercentage, @TDSPercentage) / 100,    --- Appy the TDS from RemisierBrokerageTDS, If not found then apply global TDS  
  Rem_BSECMTds = R.Rem_BSECMBrok * ISNULL(S.TDSPercentage, @TDSPercentage) / 100,    
  Rem_NSEFOTds = R.Rem_NSEFOBrok * ISNULL(S.TDSPercentage, @TDSPercentage) / 100,  
    TDSPercentage = ISNULL(S.TDSPercentage, @TDSPercentage)  
 FROM #REMBROK_2 R             
      LEFT OUTER JOIN RemisierBrokerageTDS S                        
        ON (S.REMCODE = CASE R.REMTYPE WHEN 'BR' THEN R.BRANCH_CD ELSE R.REMCODE END  
    AND R.FROMDATE >= S.FROMDATE                        
            AND R.TODATE <= S.TODATE )  
      WHERE REM_PAYBROKERAGE > 0        
  
   
 EXEC ProcRemisierBrokerageAccBill @Sett_No, @Sett_Type, @FromDate, @ToDate  
  
                      
-- --   
-- --  SELECT * INTO ##REMBROK FROM #REMBROK  
-- --    
-- --  SELECT * INTO ##FOREMBROK  FROM #FOREMBROK  
-- --    
-- --  SELECT * INTO ##REMBROK_1  FROM #REMBROK_1  
-- --    
-- --  SELECT * INTO ##REMBROK_2  FROM #REMBROK_2  
-- --   
-- --  SELECT * INTO ##REMBROK_2BR FROM #REMBROK_2BR  
-- --    
-- --  SELECT * INTO ##REMBROK_3BR FROM #REMBROK_3BR  
  
 -----------------------------      
 DROP TABLE #REMBROK                         
                         
 DROP TABLE #REMBROK_1                         
                         
 DROP TABLE #REMBROK_2                         
                         
 DROP TABLE #FOREMBROK             
  
 COMMIT TRANSACTION RemisierBrokerage             
END  
  
/*  
  
EXEC ProcRemisierBrokerageSharing '2007008', 'RM'  
  
Select * From Rem_Brok_Trans  
  
Select * From Rem_AccBill  
  
SELECT NARRATION, AMT=SUM(CASE SELL_BUY WHEN 1 THEN -AMOUNT ELSE AMOUNT END) FROM REM_ACCBILL  
WHERE SETT_NO = '2006001'  
GROUP BY NARRATION  
  
*/

GO
