-- Object: PROCEDURE dbo.COMPUTE_DPC_CHARGES_08012013
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE [dbo].[COMPUTE_DPC_CHARGES_08012013]              
(              
 @FROM_DATE VARCHAR(11),              
 @TO_DATE VARCHAR(11),              
 @FROM_PARTY VARCHAR(10),              
 @TO_PARTY VARCHAR(10)              
)              
AS              
              
CREATE TABLE #DPC_CHARGES              
(              
 DPC_DATE DATETIME,              
 CLTCODE VARCHAR(10),              
 LONG_NAME VARCHAR(100),              
 BRANCH_CD VARCHAR(10),              
 SUB_BROKER VARCHAR(25),              
 TRADER VARCHAR(25),              
 REGION VARCHAR(20),              
 AREA VARCHAR(20),              
 CL_TYPE VARCHAR(10),              
 DPC_BALANCE MONEY,              
 LEDGER_BALANCE MONEY,              
 CASH_COLLATREAL MONEY,              
 NONCASH_COLLATREAL MONEY,              
 MARGIN_REQ MONEY,              
 AMOUNT_REV MONEY,              
 DPC_PERCENTE MONEY              
)              
              
/*              
CREATE TABLE #DPC_CHARGES_FINAL              
(              
 DPC_DATE DATETIME,              
 CLTCODE VARCHAR(10),              
 LONG_NAME VARCHAR(100),              
 BRANCH_CD VARCHAR(10),              
 SUB_BROKER VARCHAR(25),              
 TRADER VARCHAR(25),              
 REGION VARCHAR(20),              
 AREA VARCHAR(20),              
 CL_TYPE VARCHAR(10),              
 DPC_BALANCE MONEY,              
 LEDGER_BALANCE MONEY,              
 CASH_COLLATREAL MONEY,              
 NONCASH_COLLATREAL MONEY,              
 MARGIN_REQ MONEY,              
 DPC_CHARGE MONEY,              
 DPC_PERCENTE MONEY,              
 AMOUNT_REV MONEY              
)              
*/              
DECLARE              
 @@OPEN_DATE VARCHAR(11)              
               
SELECT               
 @@OPEN_DATE = CONVERT(VARCHAR(11), SDTCUR, 109)              
FROM               
 PARAMETER              
WHERE              
 @FROM_DATE BETWEEN SDTCUR AND LDTCUR              
              
/* TABLE TO MAINTAIN THE T + 2 AND T + 4 LBALANCES TO APPLY THE T + 4 DEBIT BALANCE LOGIC */              
CREATE TABLE #DEBIT_DEPC_BILLS              
(              
 CLTCODE VARCHAR(10),           
 T_DATE DATETIME,           
 T_2_DATE DATETIME,              
 T_4_DATE DATETIME,              
 BILL_AMOUNT MONEY,              
 VDT DATETIME              
)              
              
--, BRANCH_CD, SUB_BROKER, TRADER, REGION, AREA, CL_TYPE,               
              
              
INSERT INTO #DPC_CHARGES(DPC_DATE, CLTCODE, LONG_NAME, DPC_BALANCE, LEDGER_BALANCE, CASH_COLLATREAL, NONCASH_COLLATREAL, MARGIN_REQ, DPC_PERCENTE, BRANCH_CD, SUB_BROKER, TRADER, REGION, AREA, CL_TYPE, AMOUNT_REV)              
SELECT               
 BALDATE,               
 CLTCODE,               
 LONG_NAME,              
 SUM(DPC_BALANCE),               
 LEDGER_BALANCE = SUM(DPC_BALANCE),              
 SUM(CASH_COLLATREAL),               
 SUM(NONCASH_COLLATREAL),              
 SUM(MARGIN_REQ),              
 MAX(DPC_PERCENTE),              
 BRANCH_CD,               
 SUB_BROKER,               
 TRADER,               
 REGION,               
 AREA,               
 CL_TYPE,              
 AMOUNT_REV = 0              
FROM              
(              
 SELECT               
  BALDATE = @FROM_DATE,              
  CLTCODE,              
  LONG_NAME,              
  DPC_BALANCE = SUM(CASE DRCR WHEN 'D' THEN CASE WHEN VTYP <> 15 THEN VAMT ELSE 0 END ELSE -VAMT END),              
  CASH_COLLATREAL = 0,              
  NONCASH_COLLATREAL = 0,              
  MARGIN_REQ = 0,              
  DPC_PERCENTE = MAX(DEBIT_INT),              
  BRANCH_CD,               
  SUB_BROKER,               
  TRADER,               
  REGION,               
  AREA,               
  CL_TYPE              
 FROM              
  LEDGER L, .DBO.GET_DPC_CLIENTS(@FROM_PARTY, @TO_PARTY, @FROM_DATE) C              
 WHERE              
  L.CLTCODE = PARTY_CODE              
  AND VDT >= @@OPEN_DATE              
  AND VDT < @FROM_DATE              
 GROUP BY              
  CONVERT(DATETIME, CONVERT(VARCHAR(11), VDT, 109)),              
  CLTCODE,              
  LONG_NAME,              
  BRANCH_CD,               
  SUB_BROKER,               
  TRADER,               
  REGION,               
  AREA,               
  CL_TYPE              
 HAVING              
  SUM(CASE DRCR WHEN 'D' THEN CASE WHEN VTYP <> 15 THEN VAMT ELSE 0 END ELSE -VAMT END) <> 0              
                
 UNION ALL              
              
 SELECT               
  BALDATE = @FROM_DATE,              
  CLTCODE,              
  LONG_NAME,              
  DPC_BALANCE = SUM(VAMT),              
  CASH_COLLATREAL = 0,              
  NONCASH_COLLATREAL = 0,              
  MARGIN_REQ = 0,              
  DPC_PERCENTE = MAX(DEBIT_INT),              
  BRANCH_CD,               
  SUB_BROKER,               
  TRADER,               
  REGION,               
  AREA,               
  CL_TYPE              
 FROM              
  LEDGER L, .DBO.GET_DPC_CLIENTS(@FROM_PARTY, @TO_PARTY, @FROM_DATE) C              
 WHERE              
  L.CLTCODE = PARTY_CODE              
  AND EDT >= @@OPEN_DATE              
  AND EDT < @FROM_DATE              
  AND VTYP = 15 AND DRCR = 'D'              
 GROUP BY              
  CONVERT(DATETIME, CONVERT(VARCHAR(11), VDT, 109)),              
  CLTCODE,              
  LONG_NAME,              
  BRANCH_CD,               
  SUB_BROKER,               
  TRADER,               
  REGION,               
  AREA,               
  CL_TYPE              
 /*HAVING              
  SUM(CASE DRCR WHEN 'D' THEN CASE WHEN VTYP <> 15 THEN VAMT ELSE 0 END ELSE -VAMT END) <> 0      */        
                
 UNION ALL              
               
 SELECT               
  BALDATE = @FROM_DATE,              
  CLTCODE,              
  LONG_NAME,              
  DPC_BALANCE = SUM(-VAMT),              
  CASH_COLLATREAL = 0,              
  NONCASH_COLLATREAL = 0,              
  MARGIN_REQ = 0,              
  DPC_PERCENTE = MAX(DEBIT_INT),              
  BRANCH_CD,               
  SUB_BROKER,               
  TRADER,               
  REGION,               
  AREA,               
  CL_TYPE              
 FROM              
  LEDGER L, .DBO.GET_DPC_CLIENTS(@FROM_PARTY, @TO_PARTY, @FROM_DATE) C              
 WHERE              
  L.CLTCODE = PARTY_CODE              
  AND EDT >= @@OPEN_DATE              
  AND VDT < @@OPEN_DATE              
  AND VTYP = 15 AND DRCR = 'D'              
 GROUP BY              
  CONVERT(DATETIME, CONVERT(VARCHAR(11), VDT, 109)),              
  CLTCODE,              
  LONG_NAME,              
  BRANCH_CD,               
  SUB_BROKER,               
  TRADER,               
  REGION,               
  AREA,               
  CL_TYPE              
 /*HAVING              
  SUM(CASE DRCR WHEN 'D' THEN CASE WHEN VTYP <> 15 THEN VAMT ELSE 0 END ELSE -VAMT END) <> 0      */        
                
 UNION ALL                
                
 SELECT               
  BALDATE = CONVERT(DATETIME, CONVERT(VARCHAR(11), VDT, 109)),              
  CLTCODE,              
  LONG_NAME,              
  DPC_BALANCE = SUM(CASE DRCR WHEN 'D' THEN CASE WHEN VTYP <> 15 THEN VAMT ELSE 0 END ELSE -VAMT END),              
  CASH_COLLATREAL = 0,              
  NONCASH_COLLATREAL = 0,              
  MARGIN_REQ = 0,              
  DPC_PERCENTE = MAX(DEBIT_INT),              
  BRANCH_CD,               
  SUB_BROKER,               
  TRADER,               
  REGION,               
  AREA,               
  CL_TYPE              
 FROM              
  LEDGER L, .DBO.GET_DPC_CLIENTS(@FROM_PARTY, @TO_PARTY, @FROM_DATE) C              
 WHERE              
  L.CLTCODE = PARTY_CODE              
  AND VDT >= @FROM_DATE              
  AND VDT <= @TO_DATE + ' 23:59'              
 GROUP BY              
  CONVERT(DATETIME, CONVERT(VARCHAR(11), VDT, 109)),              
  CLTCODE,              
  LONG_NAME,              
  BRANCH_CD,               
  SUB_BROKER,               
  TRADER,               
  REGION,               
  AREA,               
  CL_TYPE              
) A              
GROUP BY              
 BALDATE,               
 CLTCODE,              
 LONG_NAME,              
 BRANCH_CD,               
 SUB_BROKER,             
 TRADER,               
 REGION,               
 AREA,               
 CL_TYPE        
       
 DECLARE              
 @EXCHANGE VARCHAR(10),              
 @SEGMENT VARCHAR(10),              
 @SHAREDB VARCHAR(10),              
 @GROUPID VARCHAR(10),              
 @@SQL VARCHAR(1000)              
               
SELECT @EXCHANGE = EXCHANGE, @SEGMENT = SEGMENT, @SHAREDB = SHAREDB, @GROUPID = GROUPID               
FROM dpc_MASTER_SETTING D               
WHERE EXISTS(SELECT EXCHANGE FROM OWNER O WHERE D.EXCHANGE = O.EXCHANGE AND D.SEGMENT = O.SEGMENT)      
         
             
               
INSERT INTO #DEBIT_DEPC_BILLS(CLTCODE, T_DATE, T_2_DATE, T_4_DATE, BILL_AMOUNT)              
SELECT               
 CLTCODE, [START_DATE], PAYIN_DATE, CASE WHEN @SEGMENT = 'FUTURES' THEN PAYIN_DATE ELSE END_DATE END, SUM(VAMT)              
FROM              
 LEDGER L, .DBO.GET_DPC_CLIENTS(@FROM_PARTY, @TO_PARTY, @FROM_DATE) C, MSAJAG.DBO.GET_SETT_CALENDER(@FROM_DATE, @TO_DATE, 4)              
WHERE               
 L.CLTCODE = PARTY_CODE              
 AND CONVERT(VARCHAR(11), VDT, 109) = CONVERT(VARCHAR(11), START_DATE, 109)              
 AND END_DATE >= @FROM_DATE              
 AND END_DATE <= @TO_DATE + ' 23:59'        
 AND VTYP = 15 AND DRCR = 'D'              
GROUP BY              
 CLTCODE, [START_DATE], PAYIN_DATE, END_DATE         
        
/*INSERT INTO #DPC_CHARGES(DPC_DATE, CLTCODE, LONG_NAME, DPC_BALANCE, LEDGER_BALANCE,         
CASH_COLLATREAL, NONCASH_COLLATREAL, MARGIN_REQ, DPC_PERCENTE, BRANCH_CD, SUB_BROKER,         
TRADER, REGION, AREA, CL_TYPE, AMOUNT_REV)               
SELECT               
  BALDATE = T_4_DATE,              
  CLTCODE,              
  LONG_NAME,              
  DPC_BALANCE = 0,              
  LEDGER_BALANCE = 0,              
  CASH_COLLATREAL = 0,              
  NONCASH_COLLATREAL = 0,              
  MARGIN_REQ = 0,              
  DPC_PERCENTE = DEBIT_INT,              
  BRANCH_CD,               
  SUB_BROKER,               
  TRADER,               
  REGION,               
  AREA,               
  CL_TYPE,        
  0              
 FROM              
  #DEBIT_DEPC_BILLS L, .DBO.GET_DPC_CLIENTS(@FROM_PARTY, @TO_PARTY, @FROM_DATE) C              
 WHERE              
  L.CLTCODE = PARTY_CODE              
  AND NOT EXISTS(SELECT DPC_DATE FROM #DPC_CHARGES C WHERE CONVERT(DATETIME, CONVERT(VARCHAR(11), DPC_DATE, 109)) = CONVERT(DATETIME, CONVERT(VARCHAR(11), T_4_DATE, 109))              
 AND L.CLTCODE = C.CLTCODE)*/        
             
         
              
              
--IF @FROM_DATE = @TO_DATE AND @SEGMENT = 'FUTURES'              
IF @SEGMENT = 'FUTURES'              
BEGIN              
 CREATE TABLE #GET_T_4_MIN_MARGIN      
 (      
  SNO INT IDENTITY(1, 1),      
  PARTY_CODE VARCHAR(10),      
  VDT DATETIME,      
  AMOUNT MONEY,      
  MIN_AMT MONEY      
 )      
      
 SET @@SQL = " INSERT INOT #GET_T_4_MIN_MARGIN(PARTY_CODE, VDT, AMOUNT) "      
 SET @@SQL = @@SQL + "SELECT "            
 SET @@SQL = @@SQL + "M.PARTY_CODE, "      
 SET @@SQL = @@SQL + "VDT = CONVERT(DATETIME, CONVERT(VARCHAR(11), MDATE, 109)), "      
 SET @@SQL = @@SQL + "AMOUNT = MTOM "      
 SET @@SQL = @@SQL + "FROM "            
 SET @@SQL = @@SQL + @SHAREDB + ".DBO.FOMARGINNEW M, "            
 SET @@SQL = @@SQL + "WHERE MDATE >= DATEADD(D, -10, '" + @FROM_DATE + "') AND MDATE <= '" + @TO_DATE + "'"      
 SET @@SQL = @@SQL + " AND M.PARTY_CODE >= '" + @FROM_PARTY + "' AND M.PARTY_CODE <= '" + @TO_PARTY + "'"            
 SET @@SQL = @@SQL + " ORDER BY M.PARTY_CODE, MDATE"      
      
 UPDATE G SET MIN_AMT = (SELECT MIN(AMOUNT) FROM #GET_T_4_MIN_MARGIN G1 WHERE  G1.SNO + 4 > G.SNO AND G1.SNO <= G.SNO)      
 FROM #GET_T_4_MIN_MARGIN G      
      
 INSERT INTO #DPC_CHARGES(DPC_DATE, CLTCODE, LONG_NAME, DPC_BALANCE, LEDGER_BALANCE, CASH_COLLATREAL, NONCASH_COLLATREAL, MARGIN_REQ, BRANCH_CD, SUB_BROKER, TRADER, REGION, AREA, CL_TYPE)       
 SELECT         
  BALDATE = VDT,       
  M.PARTY_CODE,       
  LONG_NAME,           
  DPC_BALANCE = 0,       
  LEDGER_BALANCE = 0,       
  CASH_COLLATREAL = 0,       
  NONCASH_COLLATREAL = 0,       
  MARGIN_REQ = MIN_AMT,         
  BRANCH_CD,       
  SUB_BROKER,       
  TRADER,          
  REGION,       
  AREA,            
  C.CL_TYPE       
 FROM       
 #GET_T_4_MIN_MARGIN M,       
 .DBO.GET_DPC_CLIENTS(@FROM_PARTY, @TO_PARTY, @FROM_DATE) C       
 WHERE M.PARTY_CODE = C.PARTY_CODE      
 AND VDT >= @FROM_DATE AND VDT <= @TO_DATE      
       
       
/* SET @@SQL = " INSERT INTO #DPC_CHARGES(DPC_DATE, CLTCODE, LONG_NAME, DPC_BALANCE, LEDGER_BALANCE, CASH_COLLATREAL, NONCASH_COLLATREAL, MARGIN_REQ, BRANCH_CD, SUB_BROKER, TRADER, REGION, AREA, CL_TYPE) "              
 SET @@SQL = @@SQL + "SELECT "              
 SET @@SQL = @@SQL + " BALDATE = CONVERT(DATETIME, CONVERT(VARCHAR(11), MDATE, 109)), "              
 SET @@SQL = @@SQL + " M.PARTY_CODE, "              
 SET @@SQL = @@SQL + " LONG_NAME, "              
 SET @@SQL = @@SQL + " DPC_BALANCE = 0, "              
 SET @@SQL = @@SQL + " LEDGER_BALANCE = 0, "              
 SET @@SQL = @@SQL + " CASH_COLLATREAL = 0, "              
 SET @@SQL = @@SQL + " NONCASH_COLLATREAL = 0, "              
 SET @@SQL = @@SQL + " MARGIN_REQ = MTOM, "              
 SET @@SQL = @@SQL + " BRANCH_CD, "              
 SET @@SQL = @@SQL + " SUB_BROKER, "              
 SET @@SQL = @@SQL + " TRADER, "              
 SET @@SQL = @@SQL + " REGION, "              
 SET @@SQL = @@SQL + " AREA, "              
 SET @@SQL = @@SQL + " M.CL_TYPE "              
 SET @@SQL = @@SQL + "FROM "              
 SET @@SQL = @@SQL + @SHAREDB + ".DBO.FOMARGINNEW M, "              
 SET @@SQL = @@SQL + ".DBO.GET_DPC_CLIENTS('" + @FROM_PARTY + "','" + @TO_PARTY + "','" +  @FROM_DATE + "') C "              
 SET @@SQL = @@SQL + "WHERE M.PARTY_CODE = C.PARTY_CODE AND MDATE >= '" + @FROM_DATE + "' AND MDATE <= '" + @TO_DATE + "'"              
 SET @@SQL = @@SQL + " AND M.PARTY_CODE >= '" + @FROM_PARTY + "' AND M.PARTY_CODE <= '" + @TO_PARTY + "'"        */      
               
 EXEC (@@SQL)              
               
 INSERT INTO #DPC_CHARGES(DPC_DATE, CLTCODE, LONG_NAME, DPC_BALANCE, LEDGER_BALANCE, CASH_COLLATREAL, NONCASH_COLLATREAL, MARGIN_REQ, BRANCH_CD, SUB_BROKER, TRADER, REGION, AREA, CL_TYPE)              
 SELECT              
  BALDATE = CONVERT(DATETIME, CONVERT(VARCHAR(11), TRANS_DATE, 109)),              
  CO.PARTY_CODE,              
  LONG_NAME,              
  DPC_BALANCE = 0,              
  LEDGER_BALANCE = 0,              
  CASH_COLLATREAL = CASH,              
  NONCASH_COLLATREAL = NONCASH,              
  MARGIN_REQ = 0,              
  BRANCH_CD,               
  SUB_BROKER,               
  TRADER,               
  REGION,               
  AREA,               
  CL_TYPE              
 FROM              
  MSAJAG.DBO.COLLATERAL CO, .DBO.GET_DPC_CLIENTS(@FROM_PARTY, @TO_PARTY, @FROM_DATE) C              
 WHERE               
  CO.PARTY_CODE = C.PARTY_CODE              
  AND TRANS_DATE >= @FROM_DATE AND TRANS_DATE <= @TO_DATE              
  AND EXCHANGE = @EXCHANGE              
  AND SEGMENT = @SEGMENT              
  AND CO.PARTY_CODE >= @FROM_PARTY AND CO.PARTY_CODE <= @TO_PARTY               
END              
/*              
DECLARE              
 @DAYS INT              
              
SELECT @DAYS = DATEDIFF(DD,@FROM_DATE,@TO_DATE) +1              
              
              
INSERT INTO #DPC_CHARGES(DPC_DATE, CLTCODE, LONG_NAME, DPC_BALANCE, LEDGER_BALANCE, CASH_COLLATREAL, NONCASH_COLLATREAL, MARGIN_REQ, BRANCH_CD, SUB_BROKER, TRADER, REGION, AREA, CL_TYPE)              
SELECT               
 DT.DPC_DATE, CLTCODE, LONG_NAME,               
 DPC_BALANCE = 0, LEDGER_BALANCE= 0, CASH_COLLATREAL = 0, NONCASH_COLLATREAL = 0, MARGIN_REQ = 0,               
 BRANCH_CD, SUB_BROKER, TRADER, REGION, AREA, CL_TYPE              
FROM              
 #DPC_CHARGES D,              
(              
 SELECT              
  DPC_DATE = DATEADD(DD,NUMBER-1,@FROM_DATE)              
 FROM              
  DBO.F_TABLE_NUMBER_RANGE( 1, @DAYS )              
) DT              
*/   
              
DECLARE              
      @DAYS INT              
      SELECT @DAYS = DATEDIFF(DD,@FROM_DATE,@TO_DATE) +1              
              
SELECT               
 DPC_DATE = DT.DPC_DATE, CLTCODE, LONG_NAME, BRANCH_CD, SUB_BROKER, TRADER, REGION, AREA, CL_TYPE, DPC_PERCENTE              
INTO #ALL_DATES               
FROM               
 #DPC_CHARGES D,               
 (SELECT              
           DPC_DATE = DATEADD(DD,NUMBER-1,@FROM_DATE)               
      FROM              
            DBO.F_TABLE_NUMBER_RANGE( 1, @DAYS )              
  ) DT              
                
INSERT INTO #DPC_CHARGES               
SELECT DISTINCT              
 DPC_DATE,              
 CLTCODE,              
 LONG_NAME,              
 BRANCH_CD,              
 SUB_BROKER,              
 TRADER,              
 REGION,              
 AREA,              
 CL_TYPE,              
 DPC_BALANCE = 0,              
 LEDGER_BALANCE = 0,              
 CASH_COLLATREAL = 0,              
 NONCASH_COLLATREAL = 0,              
 MARGIN_REQ = 0,              
 AMOUNT_REV = 0,              
 DPC_PERCENTE              
FROM #ALL_DATES A WHERE NOT EXISTS (SELECT DPC_DATE FROM #DPC_CHARGES TEMP WHERE A.CLTCODE = TEMP.CLTCODE AND A.DPC_DATE = TEMP.DPC_DATE)               
              
UPDATE D SET DPC_BALANCE = (SELECT SUM(DPC_BALANCE) FROM #DPC_CHARGES D1 WHERE D.CLTCODE = D1.CLTCODE AND D1.DPC_DATE <= D.DPC_DATE)              
FROM #DPC_CHARGES D        
        
UPDATE D SET VDT = CASE WHEN DPC_BALANCE + BILL_AMOUNT > 0 THEN T_2_DATE ELSE T_4_DATE END              
FROM              
 #DEBIT_DEPC_BILLS D, #DPC_CHARGES C              
WHERE               
 CONVERT(DATETIME, CONVERT(VARCHAR(11), DPC_DATE, 109)) = CONVERT(DATETIME, CONVERT(VARCHAR(11), T_4_DATE, 109))              
 AND D.CLTCODE = C.CLTCODE        
         
INSERT INTO #DEBIT_DEPC_BILLS(CLTCODE, BILL_AMOUNT, VDT)        
SELECT DISTINCT CLTCODE, 0, DPC_DATE        
FROM #ALL_DATES A WHERE NOT EXISTS (SELECT VDT FROM #DEBIT_DEPC_BILLS TEMP WHERE A.CLTCODE = TEMP.CLTCODE AND A.DPC_DATE = TEMP.VDT)        
        
UPDATE D SET BILL_AMOUNT = (SELECT SUM(BILL_AMOUNT) FROM #DEBIT_DEPC_BILLS D1 WHERE D.CLTCODE = D1.CLTCODE AND D1.VDT <= D.VDT AND D1.VDT >= @FROM_DATE)              
FROM #DEBIT_DEPC_BILLS D         
        
             
SELECT              
 C.DPC_DATE,              
 C.CLTCODE,              
 C.LONG_NAME,              
 C.BRANCH_CD,              
 C.SUB_BROKER,              
 C.TRADER,              
 C.REGION,              
 C.AREA,              
 C.CL_TYPE,              
 DPC_BALANCE = C.DPC_BALANCE + ISNULL(BILL_AMOUNT, 0) + CASE WHEN MARGIN_REQ - CASH_COLLATREAL - NONCASH_COLLATREAL > 0 THEN MARGIN_REQ - CASH_COLLATREAL - NONCASH_COLLATREAL ELSE 0 END,           
 C.LEDGER_BALANCE,              
 CASH_COLLATREAL,              
 NONCASH_COLLATREAL,              
 MARGIN_REQ,              
 DPC_CHARGE = ((CASE WHEN (C.DPC_BALANCE + ISNULL(BILL_AMOUNT, 0) + CASE WHEN MARGIN_REQ - CASH_COLLATREAL - NONCASH_COLLATREAL > 0 THEN MARGIN_REQ - CASH_COLLATREAL - NONCASH_COLLATREAL ELSE 0 END) > 0 THEN C.DPC_BALANCE + ISNULL(BILL_AMOUNT, 0) + CASE 
  
WHEN MARGIN_REQ - CASH_COLLATREAL - NONCASH_COLLATREAL > 0 THEN MARGIN_REQ - CASH_COLLATREAL - NONCASH_COLLATREAL ELSE 0 END ELSE 0 END) * DEBIT_INT)/ 100/ 365,              
 DPC_PERCENTE = DEBIT_INT,              
 AMOUNT_REV              
FROM              
 (SELECT               
  DPC_DATE, CLTCODE, LONG_NAME, BRANCH_CD, SUB_BROKER, TRADER, REGION, AREA, CL_TYPE,              
  DPC_BALANCE = SUM(DPC_BALANCE),              
  LEDGER_BALANCE = SUM(LEDGER_BALANCE),              
  CASH_COLLATREAL = SUM(CASH_COLLATREAL), NONCASH_COLLATREAL = SUM(CASH_COLLATREAL),              
  MARGIN_REQ = SUM(MARGIN_REQ), AMOUNT_REV = SUM(AMOUNT_REV)              
 FROM              
  #DPC_CHARGES               
 GROUP BY DPC_DATE, CLTCODE, LONG_NAME, BRANCH_CD, SUB_BROKER, TRADER, REGION, AREA, CL_TYPE              
 ) C LEFT OUTER JOIN (SELECT CLTCODE, VDT, BILL_AMOUNT = SUM(BILL_AMOUNT) FROM #DEBIT_DEPC_BILLS GROUP BY CLTCODE, VDT) D              
 ON              
  CONVERT(DATETIME, CONVERT(VARCHAR(11), DPC_DATE, 109)) = CONVERT(DATETIME, CONVERT(VARCHAR(11), VDT, 109))              
  AND D.CLTCODE = C.CLTCODE              
 , .DBO.GET_DPC_CLIENTS(@FROM_PARTY, @TO_PARTY, @FROM_DATE) C1              
WHERE               
 C.CLTCODE = C1.PARTY_CODE              
               
      /*SELECT              
            DPC_DATE = DATEADD(DD,NUMBER-1,'apr  1 2012') INTO #DATES               
      FROM              
            DBO.F_TABLE_NUMBER_RANGE( 1, @DAYS )              
      ORDER by DATEADD(DD,NUMBER-1,'apr  1 2012')*/              
              
/*              
INSERT INTO DPC_CHARGES (DPC_DATE,CLTCODE,LONG_NAME,BRANCH_CD,SUB_BROKER,TRADER,REGION,AREA,CL_TYPE,DPC_BALANCE,LEDGER_BALANCE,CASH_COLLATREAL,NONCASH_COLLATREAL,MARGIN_REQ,DPC_CHARGE,DPC_PERCENTE,AMOUNT_REV,EXCHANGE,SEGMENT,ENTITY,SEG_GROUP,NET_TYPE_BALA
  
    
      
        
          
            
NCE,NET_TYPE_INT,NET_BALANCE,NET_INT)              
SELECT               
 *,               
 EXCHANGE = @EXCHANGE,               
 SEGMENT = @SEGMENT,               
 ENTIRY = @EXCHANGE + ' - ' + @SEGMENT,              
 ENTITY_TYPE = @GROUPID,              
 DPC_BALANCE, DPC_CHARGE, DPC_BALANCE, DPC_CHARGE              
FROM #DPC_CHARGES_FINAL ORDER BY CLTCODE, DPC_DATE              
*/              
              
/*--INSERT INTO DPC_CHARGES (DPC_DATE, CLTCODE, LONG_NAME, BRANCH_CD, SUB_BROKER, TRADER, REGION, AREA, CL_TYPE, DPC_BALANCE, LEDGER_BALANCE, CASH_COLLATREAL, NONCASH_COLLATREAL, MARGIN_REQ, DPC_CHARGE, DPC_PERCENTE, AMOUNT_REV, EXCHANGE, SEGMENT, ENTITY 
 
,    
      
        
          
            
 SEG_GROUP)              
SELECT              
 CONVERT(DATETIME, CONVERT(VARCHAR(11), DPC_DATE, 109)),               
 CLTCODE, LONG_NAME, BRANCH_CD, SUB_BROKER, TRADER, REGION, AREA, CL_TYPE,              
 DPC_BALANCE = DPC_BALANCE + BILL_AMOUNT + CASE WHEN MARGIN_REQ - CASH_COLLATREAL - NONCASH_COLLATREAL > 0 THEN MARGIN_REQ - CASH_COLLATREAL - NONCASH_COLLATREAL ELSE 0 END,               
 LEDGER_BALANCE = DPC_BALANCE + BILL_AMOUNT,              
 CASH_COLLATREAL, NONCASH_COLLATREAL, MARGIN_REQ,              
 DPC_CHARGE = ((DPC_BALANCE + BILL_AMOUNT + CASE WHEN MARGIN_REQ - CASH_COLLATREAL - NONCASH_COLLATREAL > 0 THEN MARGIN_REQ - CASH_COLLATREAL - NONCASH_COLLATREAL ELSE 0 END) * DEBIT_INT)/ 100/ 365,              
 DPC_PERCENTE = DEBIT_INT,              
 AMOUNT_REV = SUM(AMOUNT_REV),               
 EXCHANGE = @EXCHANGE,               
 SEGMENT = @SEGMENT,              
 ENTITY = @EXCHANGE + ' - ' + @SEGMENT,              
 SEG_GROUP = @GROUPID              
FROM              
 #DEBIT_DEPC_BILLS D,               
 (SELECT               
  BALDATE,               
  CLTCODE, LONG_NAME, BRANCH_CD, SUB_BROKER, TRADER, REGION, AREA, CL_TYPE,              
  DPC_BALANCE = SUM(DPC_BALANCE),               
  CASH_COLLATREAL = SUM(CASH_COLLATREAL), NONCASH_COLLATREAL = SUM(CASH_COLLATREAL),              
  MARGIN_REQ = SUM(MARGIN_REQ)              
 FROM              
  #DPC_CHARGES               
 GROUP BY BALDATE,              
  CLTCODE, LONG_NAME, BRANCH_CD, SUB_BROKER, TRADER, REGION, AREA, CL_TYPE              
 ) C, GET_DPC_CLIENTS(@FROM_PARTY, @TO_PARTY, @FROM_DATE)              
WHERE               
 CONVERT(DATETIME, CONVERT(VARCHAR(11), DPC_DATE, 109)) = CONVERT(DATETIME, CONVERT(VARCHAR(11), VDT, 109))              
 AND D.CLTCODE = C.CLTCODE              
*/

GO
