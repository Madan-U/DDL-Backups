-- Object: PROCEDURE dbo.FoShortFallAdjustment
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  PROC FoShortFallAdjustment  
 (  
  @mdate varchar(11)   
 ) AS      
BEGIN            
      
  DECLARE @Party_Code varchar(10),       
   @ShortFallMargin numeric(18,4),      
   @ShortFallAdjusted numeric(18,4),      
   @IDColumn Int,       
   @HoldAmtAfterHairCut numeric(18,4),      
   @ShortFallMarginAdjusted numeric(18,4),      
   @ShortFallMarginAdjustedNSE  numeric(18,4),      
   @ShortFallMarginAdjustedBSE  numeric(18,4),      
   @ShortFallMarginAdjustedPOA  numeric(18,4),      
   @Exchange VarChar(3),      
   @Segment VarChar(7),    
   @Isin Varchar(12),     
   @Cl_Rate numeric(18,4),     
   @AdjustmentPriorityFlag int    
       
  CREATE TABLE #HOLD       
  (      
   IDColumn INT IDENTITY,      
   Sno numeric,      
   Exchange VarChar(3),      
   Segment VarChar(7),      
   InternalExchange VarChar(3),      
   Sett_No varchar(7),      
   Sett_Type varchar(2),      
   Party_Code varchar(10),      
   Cl_Type varchar(5),      
   Group_Cd varchar(20),      
   Scrip_Cd varchar(12),      
   Scrip_Name VarChar(150),  
   Series varchar(3),      
   Isin  varchar(20),      
   HoldQty numeric,      
   BDPType varchar(10),      
   BDpid varchar(16),      
   BDdpid varchar(16),      
   Cl_Rate numeric(18,4),      
   HoldAmt numeric(18,4),      
   HairCutPercentage numeric(18,4),      
   HoldAmtAfterHairCut numeric(18,4),      
   RMSExcessAmount numeric(18,4),      
   ShortFallAdjusted Bit Default(0),      
   AdjustmentPriorityFlag SmallInt        
  )      
       
  CREATE TABLE #MarginShortFallAdjusted      
  (      
   Party_Code varchar(10),       
   ShortFallMargin numeric(18,4),      
   RMSExcessAmount numeric(18,4),      
   ShortFallMarginAdjusted numeric(18,4) Default(0),      
   ShortFallMarginAdjustedNSE numeric(18,4) Default(0),      
   ShortFallMarginAdjustedBSE numeric(18,4) Default(0),      
   ShortFallMarginAdjustedPOA numeric(18,4) Default(0)      
  )      
       
  CREATE TABLE #LatestClosingPrice      
  (               
       Scrip_Cd varchar(12),               
       Series varchar(3),              
       Cl_Rate numeric(18,4),               
       SysDate DateTime        
  )                                                                                                                
  
 /*Remove the existing record in FoClientMarginReliable*/        
 DELETE MsaJag.DBO.FoClientMarginReliable WHERE margindate LIKE @mdate + '%'        
    
 INSERT  INTO MsaJag.DBO.FoClientMarginReliable     
 (    
  Party_Code,    
  Short_Name,    
  Margindate,    
  Billamount,    
  Ledgeramount,    
  Cash_Coll,    
  Noncash_Coll,    
  Initialmargin,    
  Lst_Update_Dt,    
  Mtmmargin,    
  ShortFallMargin    
 )    
 SELECT    
  Party_Code,    
  Short_Name,    
  Margindate,    
  Billamount,    
  Ledgeramount,    
  Cash_Coll,    
  Noncash_Coll,    
  Initialmargin,    
  Lst_Update_Dt,    
  Mtmmargin,    
  ShortFallMargin  
 FROM /*PrimaryServer.*/nsefo.DBO.FoClientMarginReliable        
 ORDER BY party_code        
     
  --- Collect the ShortFallParty & ShortFallAmout      
  INSERT INTO #MarginShortFallAdjusted      
  (      
   Party_Code,      
   ShortFallMargin      
  )      
  SELECT Party_Code,       
   abs(ShortFallMargin)      
   FROM MSAJAG.DBO.FoClientMarginReliable       
   WHERE Margindate LIKE @mdate +'%'       
   AND ShortFallMargin < 0      
       
  -------- Consider the RMS excess amount      
  UPDATE #MarginShortFallAdjusted SET RMSExcessAmount = B.NB_Allowed       
   FROM #MarginShortFallAdjusted AS A, MsaJag.Dbo.RMSAllSegment AS B      
   WHERE Sauda_Date LIKE @mdate +'%'  AND A.Party_Code = B.Party_Code      
   And B.NB_Allowed > 0       
       
  --- Remove records where NBAllowed is -ve       
  DELETE #MarginShortFallAdjusted WHERE RMSExcessAmount <= 0      
       
  --- HOLDING FROM MSAJAG      
  INSERT INTO #HOLD(          
   Sno,      
   Exchange,      
   Segment,      
   InternalExchange,      
   Sett_No,      
   Sett_Type,      
   Party_Code,      
   Scrip_Cd,      
   Series,      
   Isin,      
   HoldQty,      
   BDPType,      
   BDpid,      
   BDdpid,      
   Cl_Rate,      
   HoldAmt,      
   AdjustmentPriorityFlag      
   )      
  SELECT       
   D.SNO,       
   P.EXCHANGE,       
   P.SEGMENT,       
   InternalExchange = 'NSE',      
   SETT_NO,       
   SETT_TYPE,       
   PARTY_CODE,      
   SCRIP_CD,       
   SERIES,       
   CertNo As Isin,      
   QTY,      
   BDPType,      
   BDPID,       
   BCLTDPID,           
   0 ASCL_RATE ,       
   0 AS HOLDAMT,      
   AdjustmentPriorityFlag = (CASE WHEN P.EXCHANGE = 'NSE' THEN 1 ELSE 2 END)      
  FROM MSAJAG.DBO.DELTRANS D, MSAJAG.DBO.DELIVERYDP P          
  WHERE D.PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #MarginShortFallAdjusted)      
  AND D.TRTYPE = 904       
  AND DESCRIPTION NOT LIKE '%PLEDGE%'       
  AND P.ACCOUNTTYPE NOT IN ('POOL', 'MAR')      
  --AND P.EXCHANGE = 'NSE'       
  AND P.SEGMENT = 'CAPITAL'      
  AND D.BDPTYPE = P.DPTYPE      
  AND D.BDPID = P.DPID      
  AND D.BCLTDPID = P.DPCLTNO      
  AND DRCR = 'D' AND FILLER2 = 1           
  AND DELIVERED = '0'       
  AND SHARETYPE = 'DEMAT'      
  AND CertNo IN (SELECT DISTINCT ISIN FROM FoMarginAdjustmentScripHairCut WHERE Active = 1      
   AND @mdate BETWEEN EffectiveFromDate AND EffectiveEndDate)      
       
   --- HOLDING FROM BSEDB      
   INSERT INTO #HOLD(          
   Sno,      
   Exchange,      
   Segment,      
   InternalExchange,      
   Sett_No,      
   Sett_Type,      
   Party_Code,      
   Scrip_Cd,      
   Series,      
   Isin,      
   HoldQty,      
   BDPType,      
   BDpid,      
   BDdpid,      
   Cl_Rate,      
   HoldAmt,      
   AdjustmentPriorityFlag      
   )      
  SELECT       
   D.SNO,       
   P.EXCHANGE,       
   P.SEGMENT,       
   InternalExchange = 'BSE',      
   SETT_NO,       
   SETT_TYPE,       
   PARTY_CODE,      
   SCRIP_CD,       
   SERIES,       
   CertNo As Isin,      
   QTY,      
   BDPType,      
   BDPID,       
   BCLTDPID,           
   0 ASCL_RATE ,       
   0 AS HOLDAMT,      
   AdjustmentPriorityFlag = (CASE WHEN P.EXCHANGE = 'NSE' THEN 1 ELSE 2 END)           
  FROM BSEDB.DBO.DELTRANS D, BSEDB.DBO.DELIVERYDP P          
  WHERE D.PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #MarginShortFallAdjusted)      
  AND D.TRTYPE = 904       
  AND DESCRIPTION NOT LIKE '%PLEDGE%'       
  AND P.ACCOUNTTYPE NOT IN ('POOL', 'MAR')      
  --AND P.EXCHANGE = 'BSE'       
  AND P.SEGMENT = 'CAPITAL'      
  AND D.BDPTYPE = P.DPTYPE      
  AND D.BDPID = P.DPID      
  AND D.BCLTDPID = P.DPCLTNO      
  AND DRCR = 'D' AND FILLER2 = 1           
  AND DELIVERED = '0'       
  AND SHARETYPE = 'DEMAT'      
  AND CertNo IN (SELECT DISTINCT ISIN FROM FoMarginAdjustmentScripHairCut WHERE Active = 1      
   AND @mdate BETWEEN EffectiveFromDate AND EffectiveEndDate)      
       
  --- Get Partywise POA-DPID      
  SELECT       
   Party_Code,       
       DPType,      
   DPID,      
   CltDPNo      
  INTO #DefaultDP      
  FROM MsaJag.Dbo.MultiCltID       
  WHERE DEF = 1  AND PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #MarginShortFallAdjusted)      
       
  --- Update ScripCode with ISIN in MSAJAG      
  UPDATE MsaJag.Dbo.DelCDSLBalance SET SCRIP_CD = B.SCRIP_CD, SERIES = B.SERIES      
   FROM MsaJag.DBO.DelCDSLBalance AS A, MsaJag.DBO.MultiISIN AS B      
   WHERE A.SCRIP_CD = 'Scrip' AND A.ISIN = B.ISIN       
       
  --- Update ScripCode with ISIN IN BSEDB      
  UPDATE MsaJag.Dbo.DelCDSLBalance SET SCRIP_CD = B.SCRIP_CD, SERIES = B.SERIES      
   FROM MsaJag.DBO.DelCDSLBalance AS A, BseDb.DBO.MultiISIN AS B      
   WHERE A.SCRIP_CD = 'Scrip' AND A.ISIN = B.ISIN       
       
  --- FREE HOLDING FROM MSAJAG      
  INSERT INTO #HOLD(          
   Sno,      
   Exchange,      
   Segment,      
   InternalExchange,      
   Sett_No,      
   Sett_Type,      
   Party_Code,      
   Scrip_Cd,      
   Series,      
   Isin,      
   HoldQty,      
   BDPType,      
   BDpid,      
   BDdpid,      
   Cl_Rate,      
   HoldAmt,      
   AdjustmentPriorityFlag      
   )      
  SELECT    
   '0' AS SNO,       
   'NSE' AS EXCHANGE,       
   'FREEBAL' AS SEGMENT,       
   InternalExchange = 'POA',      
   '0' AS SETT_NO,       
   '0' AS SETT_TYPE,       
   B.PARTY_CODE,      
   A.SCRIP_CD,       
   A.SERIES,       
   A.Isin,      
   A.TotalBalance AS QTY,      
   B.DPType AS BDPType,      
   A.DPID AS BDPID,       
   A.CltDPID AS BCLTDPID,           
   0 ASCL_RATE ,       
   0 AS HOLDAMT,      
   3 AS AdjustmentPriorityFlag           
  FROM MsaJag.Dbo.DelCDSLBalance AS A, #DefaultDP AS B      
   WHERE A.DPID = B.DPID AND A.CltDPID = B.CltDPNo AND A.Scrip_Cd <> 'Scrip'      
   AND A.ISIN IN (SELECT DISTINCT ISIN FROM FoMarginAdjustmentScripHairCut WHERE Active = 1      
   AND @mdate BETWEEN EffectiveFromDate AND EffectiveEndDate)      
        
  --- CLOSING PRICE FROM MSAJAG       
    INSERT INTO  #LatestClosingPrice      
  (      
       Scrip_Cd,               
       Series,               
       Cl_Rate,               
       SysDate               
  )      
  SELECT      
       Scrip_Cd,               
       CASE WHEN Series IN('EQ', 'BE') THEN 'EQ' ELSE Series END,               
       Cl_Rate,               
       SysDate               
    FROM /*primaryserver.*/MSAJAG.DBO.Closing C WITH(NOLOCK)              
    WHERE SYSDATE =               
          (              
                SELECT               
                      MAX(SYSDATE)               
                FROM /*primaryserver.*/MSAJAG.DBO.Closing WITH(NOLOCK)               
                WHERE SCRIP_CD = C.SCRIP_CD                
                AND SERIES = CASE WHEN C.SERIES In ('BE', 'EQ') THEN 'EQ' ELSE C.SERIES END                     
          )              
       
  --- CLOSING PRICE FROM BSEDB      
   INSERT INTO  #LatestClosingPrice      
  (      
       Scrip_Cd,               
       Series,               
       Cl_Rate,               
       SysDate               
  )      
    SELECT               
       Scrip_Cd,               
       Series,               
       Cl_Rate,               
       SysDate               
    FROM /*primaryserver.*/BSEDB.DBO.Closing C WITH(NOLOCK)              
    WHERE SYSDATE =               
          (              
                SELECT               
                      MAX(SYSDATE)               
                FROM /*primaryserver.*/BSEDB.DBO.Closing WITH(NOLOCK)               
                WHERE SCRIP_CD = C.SCRIP_CD                
                      And SERIES = C.SERIES               
          )              
           
  UPDATE #HOLD SET CL_RATE = C.CL_RATE, HOLDAMT = HOLDQTY * C.CL_RATE,          
   HOLDQTY = HOLDQTY      
   FROM #LatestClosingPrice C          
   WHERE C.Scrip_Cd = #HOLD.Scrip_Cd                          
   And C.Series = (Case When #HOLD.Series In ('EQ', 'BE')           
          Then 'EQ'           
          Else #HOLD.Series           
     End)         
        
 /*      Change the logic to get the Hair Cut Percentage      
       
  UPDATE #HOLD SET cl_type = C.Cl_Type, Group_Cd = C.C_Group FROM #HOLD AS H, MSAJAG.DBO.Client_Details AS C      
   WHERE H.Party_Code = C.Party_Code      
       
  SELECT DISTINCT exchange, party_code, segment, scrip_cd, cl_type, series, group_cd, HairCutPercentage  INTO #HairCut FROM #HOLD      
       
  UPDATE #HairCut SET HairCutPercentage =       
   DBO.GetSecurityHairCutPercentage (@mdate, party_code, cl_type, group_cd, exchange, segment, scrip_cd, series)      
       
       
  UPDATE #HOLD SET HairCutPercentage = B.HairCutPercentage      
   FROM #HOLD AS A, #HairCut AS B      
   WHERE A.exchange = B.exchange      
   AND A.party_code = B.party_code      
   AND A.segment = B.segment      
   AND A.scrip_cd = B.scrip_cd      
   AND A.series = B.series      
   AND A.cl_type = B.cl_type      
   AND A.group_cd = B.group_cd      
 */      
       
       
  UPDATE #HOLD SET HairCutPercentage = Haircut FROM #HOLD AS A, MsaJag.Dbo.FoMarginAdjustmentScripHairCut AS B      
   WHERE A.ISIN = B.ISIN  AND B.Active = 1      
   AND @mDate BETWEEN EffectiveFromDate AND EffectiveEndDate      
       
  UPDATE #HOLD SET      
   HoldAmtAfterHairCut = CASE WHEN ISNULL(HairCutPercentage, 0) > 0 THEN (HoldAmt - (HoldAmt*HairCutPercentage/100)) ELSE HoldAmt END      
       
  --- Cursor ShortFallParty List  (Adjustment can be allowed minimum of ShortFallMargin, RMSExcessAmount)      
  DECLARE ShortFallAdjustment CURSOR FOR       
    SELECT Party_Code, CASE WHEN ShortFallMargin < RMSExcessAmount THEN ShortFallMargin ELSE RMSExcessAmount END AS ShortFallMargin  FROM #MarginShortFallAdjusted ORDER BY Party_Code      
       
  OPEN  ShortFallAdjustment      
  FETCH ShortFallAdjustment INTO @Party_Code, @ShortFallMargin       
  WHILE @@FETCH_STATUS = 0      
  BEGIN      
   -- Reset ShortFallMarginAdjusted with zero      
   SET @ShortFallMarginAdjusted = 0      
   SET @ShortFallMarginAdjustedNSE = 0      
   SET @ShortFallMarginAdjustedBSE = 0      
   SET @ShortFallMarginAdjustedPOA = 0      
       
   --- Cursor For Holding      
  DECLARE Hold CURSOR FOR     
  SELECT HoldAmtAfterHairCut = sum(HoldAmtAfterHairCut), Exchange, Segment, IsIn, cl_Rate, AdjustmentPriorityFlag    
  FROM #HOLD       
    WHERE Party_Code = @Party_Code    
    AND HoldAmtAfterHairCut > 0      
    GROUP BY IsIn, Exchange, Segment, cl_Rate, AdjustmentPriorityFlag    
    --HAVING SUM(HoldAmtAfterHairCut) <= @ShortFallMargin   -- STOCK Should not split...  
     
    ORDER BY AdjustmentPriorityFlag ASC, CL_RATE DESC --- For Free Balance Segment is 'FREEBAL' (Free balance adjustment should be last priority)      
       
   OPEN Hold      
   FETCH Hold INTO @HoldAmtAfterHairCut, @Exchange, @Segment, @Isin, @Cl_Rate, @AdjustmentPriorityFlag    
   WHILE @@FETCH_STATUS = 0 AND @ShortFallMargin > 0      
   BEGIN      
    --IF @HoldAmtAfterHairCut <=  @ShortFallMargin         
    --BEGIN      
     UPDATE #HOLD SET ShortFallAdjusted = 1     
     WHERE Exchange = @Exchange     
    AND Segment = @Segment    
    AND ISIN = @Isin   
   AND Party_Code = @Party_Code    
          AND HoldAmtAfterHairCut > 0  
         
     SET @ShortFallMargin = @ShortFallMargin - @HoldAmtAfterHairCut      
     SET @ShortFallMarginAdjusted = @ShortFallMarginAdjusted + @HoldAmtAfterHairCut      
       
     IF @Exchange = 'NSE' AND @Segment = 'CAPITAL'       
      SET @ShortFallMarginAdjustedNSE = @ShortFallMarginAdjustedNSE + @HoldAmtAfterHairCut      
     ELSE IF @Exchange = 'BSE' AND @Segment = 'CAPITAL'       
      SET @ShortFallMarginAdjustedBSE = @ShortFallMarginAdjustedBSE + @HoldAmtAfterHairCut      
     ELSE IF @Segment = 'FREEBAL'       
      SET @ShortFallMarginAdjustedPOA = @ShortFallMarginAdjustedPOA + @HoldAmtAfterHairCut      
    --END       
   FETCH Hold INTO @HoldAmtAfterHairCut, @Exchange, @Segment, @Isin, @Cl_Rate, @AdjustmentPriorityFlag       
   END --- Cursor For Holding      
   CLOSE Hold      
   DEALLOCATE Hold      
       
   UPDATE #MarginShortFallAdjusted SET       
    ShortFallMarginAdjusted = @ShortFallMarginAdjusted ,      
    ShortFallMarginAdjustedNSE = @ShortFallMarginAdjustedNSE,      
    ShortFallMarginAdjustedBSE = @ShortFallMarginAdjustedBSE,      
    ShortFallMarginAdjustedPOA = @ShortFallMarginAdjustedPOA      
   WHERE Party_Code = @Party_Code      
       
   FETCH ShortFallAdjustment INTO @Party_Code, @ShortFallMargin       
  END --- Cursor ShortFallParty List      
       
  CLOSE ShortFallAdjustment      
  DEALLOCATE ShortFallAdjustment      
       
  --- UPDATE TRTYPE IN DETLTRANS TABLE (MSAJAG)      
  UPDATE MSAJAG.DBO.DELTRANS SET TRTYPE = 1002 FROM #HOLD AS A, MSAJAG.DBO.DELTRANS  AS B       
   WHERE A.ShortFallAdjusted = 1       
   AND A.Sno = B.Sno AND InternalExchange = 'NSE'      
       
  --- UPDATE TRTYPE IN DETLTRANS TABLE (BSEDB)      
  UPDATE BSEDB.DBO.DELTRANS SET TRTYPE = 1002 FROM #HOLD AS A, BSEDB.DBO.DELTRANS  AS B       
   WHERE A.ShortFallAdjusted = 1       
   AND A.Sno = B.Sno AND InternalExchange = 'BSE'      
       
  --- Update the ShortFallAdjustedMargin      
  UPDATE MSAJAG.DBO.FoClientMarginReliable SET       
   RMSExcessAmount = B.RMSExcessAmount,      
   ShortFallMarginAdjustedNSE = B.ShortFallMarginAdjustedNSE,      
   ShortFallMarginAdjustedBSE = B.ShortFallMarginAdjustedBSE,       
   ShortFallMarginAdjustedPOA = B.ShortFallMarginAdjustedPOA       
   FROM MSAJAG.DBO.FoClientMarginReliable AS A, #MarginShortFallAdjusted AS B      
   WHERE A.Margindate LIKE @mdate +'%' AND A.Party_Code = B.Party_Code      
   
 INSERT INTO MSAJAG.DBO.FoMarginShortFallAdjusted       
  (      
   Margindate,  
   Exchange,  
   Segment,  
   InternalExchange,  
   SNo,  
   Sett_No,  
   Sett_Type,  
   Party_Code,  
   Scrip_Cd,  
   Series,  
   Isin,  
   HoldQty,  
   BDPType,  
   BDpid,  
   BDdpid,  
   Cl_Rate,  
   HoldAmt,  
   HairCutPercentage,  
   AdjustedAmtAfterHairCut  
  )      
 SELECT  
   Convert(DateTime, @mdate, 103) AS Margindate,      
   Exchange,  
   Segment,  
   InternalExchange,  
   SNo,  
   Sett_No,  
   Sett_Type,  
   Party_Code,  
   Scrip_Cd,  
   Series,  
   Isin,  
   HoldQty,  
   BDPType,  
   BDpid,  
   BDdpid,  
   Cl_Rate,  
   HoldAmt,  
   HairCutPercentage,  
   AdjustedAmtAfterHairCut = HoldAmtAfterHairCut  
  FROM #HOLD      
  WHERE ShortFallAdjusted = 1       
  
 UPDATE #HOLD SET Scrip_Name = S1.Short_Name   
  FROM #HOLD AS A, MsaJag.Dbo.Scrip1 AS S1, MsaJag.Dbo.Scrip2 AS S2   
  WHERE S2.Scrip_Cd = A.Scrip_Cd AND S1.Co_Code = S2.Co_Code   
   
 UPDATE #HOLD SET Scrip_Name = S1.Short_Name   
  FROM #HOLD AS A, BseDb.Dbo.Scrip1 AS S1, BseDb.Dbo.Scrip2 AS S2   
  WHERE ISNull(A.Scrip_Name, '') <> '' AND S2.Scrip_Cd = A.Scrip_Cd AND S1.Co_Code = S2.Co_Code   
            
  INSERT INTO MSAJAG.DBO.FoPOAMarginShortFallAdjusted      
  (      
   Sett_No,      
   Sett_Type,      
   Party_Code,      
   ScripName,      
   Scrip_Cd,      
   Series,      
   Qty,      
   IsIn,      
   Exchg,      
   ScripCode,      
   ToRecQty,      
   Balance,      
   DpType,      
   DpId,      
   CltDpId,      
   POAFlag,      
   Start_Date,      
   Status      
  )      
  SELECT       
   Sett_No,      
   Sett_Type,      
   Party_Code,      
   Scrip_Name,      
   Scrip_Cd,      
   Series,      
   HoldQty,      
   IsIn,      
   Exchange AS Exchg,      
   Scrip_Cd AS ScripCode,      
   HoldQty AS ToRecQty,      
   HoldQty AS Balance,      
   BDpType AS DPType,      
   BDpid AS DpId,      
   BDdpid AS CltDpId,      
   1 AS POAFlag,      
   Convert(DateTime, @mdate, 103) AS Start_Date,      
   'ShortFall Adjusted' AS Status      
   FROM #HOLD      
   WHERE ShortFallAdjusted = 1       
   AND Segment = 'FREEBAL'      
  
 -- --  SELECT * FROM #MarginShortFallAdjusted      
 -- --  SELECT * FROM #HOLD      
      
END      
        
/*      
      
EXEC FoShortFallAdjustment 'JUL 24 2007'      
  
     
*/

GO
