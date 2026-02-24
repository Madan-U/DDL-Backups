-- Object: PROCEDURE dbo.V2_FT_COMBINED_RMS
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROC [dbo].[V2_FT_COMBINED_RMS]    
 @START_DATE VARCHAR(11),              
 @END_DATE VARCHAR(11),              
 @VDT VARCHAR(11),              
 @CLIENT_FR VARCHAR(15),              
 @CLIENT_TO VARCHAR(15),              
 @BRANCH_CODE VARCHAR(15),              
 @DATE_TYPE CHAR(3),              
 @SR_NO VARCHAR(100),              
 @UNAME VARCHAR(100),              
 @COMPUTE_FLG BIT,              
 @MIN_AMOUNT MONEY = 0,              
 @COMP_FLAG CHAR(3) = 'FDT'              
              
AS              
/*BEGIN TRAN       
EXEC V2_FT_COMBINED_RMS 'APR  1 2008', 'MAR 31 2009', 'OCT 15 2008', '001A000001', '001A000001', '%', 'VDT', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30', 'NIKHIL', 0, 0      
SELECT * FROM V2_FT_COMPUTEBALANCES WHERE CLTCODE = '001A000001' ORDER BY ENTRY_TYPE      
SELECT * FROM V2_FT_PRIORITY WHERE SR_NO = 30      
SELECT * FROM V2_FT_COMPUTEBALANCES WHERE LEDGER_TYPE = 'BSE'      
SELECT * FROM LEDGER WHERE VNO = '200810170011' AND VTYP = 88      
SELECT * FROM MARGINLEDGER WHERE VNO = '200810170011' AND VTYP = 88      
SELECT * FROM V2_FT_PRIORITY WHERE SR_NO = 14    
ROLLBACK*/              
              
              
DECLARE              
 @SDTCUR VARCHAR(11),              
 @LDTCUR VARCHAR(11)              
              
SELECT              
 @SDTCUR = LEFT(CONVERT(VARCHAR,SDTCUR,109),11),              
 @LDTCUR = LEFT(CONVERT(VARCHAR,LDTCUR,109),11)              
FROM              
 ACCOUNT.DBO.PARAMETER              
WHERE              
 @VDT BETWEEN SDTCUR AND LDTCUR              
              
              
              
DECLARE              
 @@COMPUTE_CUR AS CURSOR,              
 @@FT_CUR AS CURSOR,              
 @@EXCH_FR VARCHAR(15),              
 @@DB_FR VARCHAR(15),              
 @@EXCH_TO VARCHAR(15),              
 @@EXCH_DEFAULT VARCHAR(15),              
 @@DB_TO VARCHAR(15),              
 @@SR_NO SMALLINT,              
 @@TRF_TYPE TINYINT,              
 @@VNO_FR VARCHAR(12),              
 @@VNO_TO VARCHAR(12),              
 @@VNO_COMMON VARCHAR(12),              
 @@VNO_COUNT INT,              
 @@SQL VARCHAR(8000),              
 @@ML_CODE_FR VARCHAR(15),              
 @@ML_NAME_FR VARCHAR(50),              
 @@ML_CODE_TO VARCHAR(15),              
 @@ML_NAME_TO VARCHAR(50),              
 @@JV_CODE_FR VARCHAR(10),              
 @@JV_NAME_FR VARCHAR(100),              
 @@JV_CODE_TO VARCHAR(10),              
 @@JV_NAME_TO VARCHAR(100)              
              
              
TRUNCATE TABLE V2_FT_COMPUTEBALANCES              
              
              
              
INSERT INTO               
 V2_FT_COMPUTEBALANCES               
SELECT               
 A.CLTCODE,               
 A.ACNAME,               
 LEDGER_TYPE = CASE WHEN EXCHANGE = 'NSE' THEN CASE WHEN SEGMENT = 'CAPITAL' THEN 'NSE' ELSE 'NFO' END ELSE 'BSE' END,               
 VTYPE = 0,               
 FINAL_LEDGER_AMOUNT = SUM(VDTLEDBAL),              
 FINAL_MARGIN_AMOUNT = 0,              
 LEDGER_AMOUNT = SUM(VDTLEDBAL) + SUM(OPENDEBITBILL),              
 MARGIN_AMOUNT = 0,              
 MARGIN_AVAILABLE = SUM(NONCASHCOLL),              
 MARGIN_USAGE_AMOUNT = SUM(BUYOPENPOS) - SUM(OPENDEBITBILL),              
 MARGIN_REQ = CASE WHEN EXCHANGE = 'NSE' AND SEGMENT = 'FUTURES' THEN -SUM(FOMARGIN) ELSE SUM(BUYOPENPOS + NDBUYPOS + UN_BUYOPENPOS) END,             
 ENTRY_TYPE = 0,               
 SOURCE_VO = '',              
 TARGET_VNO = '',              
 LNO = 0,              
 NARRATION = '',  
 BTOBPAYMENT = CASE WHEN BTOBPAYMENT <> 1 THEN 0 ELSE 1 END              
FROM               
 (SELECT * FROM MSAJAG.DBO.TBL_RMS_DATA WHERE RMS_DATE LIKE @VDT + '%') R,               
 ACMAST A              
WHERE               
 R.PARTY_CODE = A.CLTCODE              
 AND A.BRANCHCODE LIKE @BRANCH_CODE  
GROUP BY               
 A.CLTCODE,              
 A.ACNAME,              
 EXCHANGE,              
 SEGMENT,  
 BTOBPAYMENT        

UPDATE V2 
	SET MARGIN_REQ = MARGIN_REQ - AMOUNT
FROM
	V2_FT_COMPUTEBALANCES V2, 
	(SELECT EXCHANGE,PARTY_CODE,AMOUNT=SUM(AMOUNT) FROM  (SELECT EXCHANGE = (CASE WHEN D.BRANCH_CD = 'BSE' THEN 'BSE' ELSE 'NSE' END), D.PARTY_CODE, 
AMOUNT = SUM(CASE WHEN HOLDFLAG <> 'NDPOS' THEN FUTQTY*CL_RATE ELSE 0 END) + SUM(CASE WHEN HOLDFLAG = 'NDPOS' THEN FUTQTY*CL_RATE ELSE 0 END)
+ (CASE WHEN SUM(SHRTQTY) >= SUM(DEBITQTY) 
					THEN (SUM(SHRTQTY*CL_RATE) - SUM(DEBITQTY*CL_RATE))*(CASE WHEN CASHMARGINMARKUP > 0 
													 THEN (CASE WHEN (VARMARGIN * CASHMARGINMARKUP) > 100 
													 THEN 100
													 ELSE (VARMARGIN * CASHMARGINMARKUP)
												 END)
										   ELSE VARMARGIN
									  END)/100
				    ELSE 0
			   END)
+ SUM(SHRTQTY*CL_RATE) +SUM(CASE WHEN HOLDFLAG='PNL' THEN CL_RATE ELSE 0 END)
FROM MSAJAG.DBO.DELDEBITSUMMARYNEW D, MSAJAG.DBO.CLIENTTYPE C, MSAJAG.DBO.CLIENT_DETAILS C1
WHERE RUNDATE BETWEEN @VDT AND @VDT + ' 23:59:59' 
AND C1.PARTY_CODE = D.PARTY_CODE AND C.CL_TYPE = C1.CL_TYPE 
GROUP BY (CASE WHEN D.BRANCH_CD = 'BSE' THEN 'BSE' ELSE 'NSE' END), D.PARTY_CODE, VARMARGIN, CL_RATE, CASHMARGINMARKUP ) D
GROUP BY EXCHANGE,PARTY_CODE ) B

WHERE
	V2.CLTCODE = PARTY_CODE
	AND LEDGER_TYPE = EXCHANGE      
    

UPDATE V2 SET FINAL_MARGIN_AMOUNT = AMOUNT,  MARGIN_AMOUNT = AMOUNT FROM 
V2_FT_COMPUTEBALANCES V2, 
(SELECT 
	PARTY_CODE, EXCHANGE, SEGMENT, AMOUNT = SUM(AMOUNT) 
FROM 
	MSAJAG.DBO.COLLATERALDETAILS C
WHERE
	UPPER(COLL_TYPE) = 'MARGIN' AND EFFDATE LIKE @VDT + '%'
GROUP BY
	PARTY_CODE, EXCHANGE, SEGMENT) C
WHERE V2.CLTCODE = PARTY_CODE AND (CASE WHEN EXCHANGE = 'NSE' THEN CASE WHEN SEGMENT = 'CAPITAL' THEN 'NSE' ELSE 'NFO' END ELSE 'BSE' END) = LEDGER_TYPE

              
CREATE TABLE #FUND_TRF              
(              
 CLTCODE VARCHAR(15),              
 ACNAME VARCHAR(100),              
 TRF_AMOUNT MONEY,    
 BTOBPAYMENT BIT,            
 SR_NO INT IDENTITY(1,1)              
)              
              
CREATE TABLE #VNO              
(              
 VNO VARCHAR(12)              
)              
              
SET @@FT_CUR = CURSOR FOR              
 SELECT SR_NO, EXCH_FR, EXCH_TO, EXCH_DEFAULT, DB_FR, DB_TO, TRF_TYPE, JV_CODE_FR, JV_NAME_FR, JV_CODE_TO, JV_NAME_TO, ML_CODE_FR, ML_NAME_FR, ML_CODE_TO, ML_NAME_TO FROM V2_FT_PRIORITY ORDER BY SR_NO              
              
OPEN @@FT_CUR              
 FETCH NEXT FROM @@FT_CUR INTO @@SR_NO, @@EXCH_FR, @@EXCH_TO, @@EXCH_DEFAULT, @@DB_FR, @@DB_TO, @@TRF_TYPE, @@JV_CODE_FR, @@JV_NAME_FR, @@JV_CODE_TO, @@JV_NAME_TO, @@ML_CODE_FR, @@ML_NAME_FR, @@ML_CODE_TO, @@ML_NAME_TO              
              
WHILE @@FETCH_STATUS = 0              
BEGIN              
              
 TRUNCATE TABLE #FUND_TRF              
              
 IF @@TRF_TYPE = 1 AND (@@EXCH_TO = 'NFO' OR @@DB_FR = @@DB_TO)              
 BEGIN              
  INSERT INTO               
   #FUND_TRF              
  SELECT              
   A.CLTCODE, A.ACNAME, CASE WHEN ABS(A.FINAL_AMOUNT) <= ABS(B.FINAL_AMOUNT) THEN ABS(A.FINAL_AMOUNT) ELSE ABS(B.FINAL_AMOUNT) END, A.BTOBPAYMENT  
  FROM              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = SUM(FINAL_LEDGER_AMOUNT + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END + MARGIN_REQ +  + MARGIN_AMOUNT), BTOBPAYMENT      
   FROM              
  V2_FT_COMPUTEBALANCES              
   WHERE              
    LEDGER_TYPE = @@EXCH_FR              
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT              
   HAVING              
    SUM(FINAL_LEDGER_AMOUNT + MARGIN_REQ + MARGIN_AMOUNT) > 0) A,              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = SUM(MARGIN_REQ + FINAL_MARGIN_AMOUNT + MARGIN_AVAILABLE), BTOBPAYMENT              
   FROM              
    V2_FT_COMPUTEBALANCES              
   WHERE              
   LEDGER_TYPE = @@EXCH_TO              
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT              
   HAVING              
    SUM(MARGIN_REQ + FINAL_MARGIN_AMOUNT + MARGIN_AVAILABLE) < 0) B              
  WHERE              
   A.CLTCODE = B.CLTCODE              
   AND A.CLTCODE BETWEEN @CLIENT_FR AND @CLIENT_TO              
               
  INSERT INTO               
   V2_FT_COMPUTEBALANCES              
  SELECT              
   CLTCODE, ACNAME, @@EXCH_FR, 88, -(TRF_AMOUNT), 0,0, 0, 0, 0, 0, @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT              
  FROM               
   #FUND_TRF              
          
             
  INSERT INTO               
     V2_FT_COMPUTEBALANCES              
  SELECT              
   CLTCODE, ACNAME, @@EXCH_TO, 88, 0, 0, 0, 0, 0, 0, (TRF_AMOUNT), @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT              
  FROM               
   #FUND_TRF              
 END              
 ELSE IF @@TRF_TYPE = 1              
 BEGIN              
  INSERT INTO #FUND_TRF              
  SELECT              
   A.CLTCODE, A.ACNAME, CASE WHEN ABS(A.FINAL_AMOUNT) <= ABS(B.FINAL_AMOUNT) THEN ABS(A.FINAL_AMOUNT) ELSE ABS(B.FINAL_AMOUNT) END, A.BTOBPAYMENT              
  FROM              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = SUM(FINAL_LEDGER_AMOUNT + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END + MARGIN_REQ + MARGIN_AMOUNT), BTOBPAYMENT     
   FROM              
    V2_FT_COMPUTEBALANCES              
   WHERE              
    LEDGER_TYPE = @@EXCH_FR              
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT              
   HAVING              
    SUM(FINAL_LEDGER_AMOUNT + MARGIN_AMOUNT + MARGIN_REQ) > 0) A,              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = SUM(MARGIN_REQ + FINAL_MARGIN_AMOUNT + MARGIN_AVAILABLE), BTOBPAYMENT              
   FROM              
    V2_FT_COMPUTEBALANCES              
   WHERE              
    LEDGER_TYPE = @@EXCH_TO              
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT              
   HAVING              
    SUM(MARGIN_REQ + FINAL_MARGIN_AMOUNT + MARGIN_AVAILABLE) < 0) B              
  WHERE              
   A.CLTCODE = B.CLTCODE              
   AND A.CLTCODE BETWEEN @CLIENT_FR AND @CLIENT_TO              
          
  INSERT INTO               
   V2_FT_COMPUTEBALANCES              
  SELECT              
   CLTCODE, ACNAME, @@EXCH_FR, 88, -(TRF_AMOUNT), 0,0, 0, 0, 0, 0, @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT  
  FROM               
   #FUND_TRF              
          
             
  INSERT INTO               
   V2_FT_COMPUTEBALANCES              
  SELECT              
   CLTCODE, ACNAME, @@EXCH_TO, 88, 0, 0, 0, 0, 0, 0, (TRF_AMOUNT), @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT  
  FROM               
   #FUND_TRF              
          
 END              
              
 IF @@TRF_TYPE = 0 AND @@EXCH_TO = 'NFO'              
 BEGIN              
  INSERT INTO               
   #FUND_TRF              
  SELECT              
   A.CLTCODE, A.ACNAME, CASE WHEN ABS(A.FINAL_AMOUNT) <= ABS(B.FINAL_AMOUNT) THEN ABS(A.FINAL_AMOUNT) ELSE ABS(B.FINAL_AMOUNT) END, A.BTOBPAYMENT  
  FROM              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = SUM(FINAL_LEDGER_AMOUNT + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END  + MARGIN_REQ + MARGIN_AMOUNT), BTOBPAYMENT              
   FROM              
    V2_FT_COMPUTEBALANCES              
   WHERE              
    LEDGER_TYPE = @@EXCH_FR  
 AND BTOBPAYMENT = 0              
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT              
   HAVING              
    SUM(FINAL_LEDGER_AMOUNT  + MARGIN_REQ + MARGIN_AMOUNT) > 0) A,              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = SUM(MARGIN_USAGE_AMOUNT), BTOBPAYMENT              
   FROM              
    V2_FT_COMPUTEBALANCES              
   WHERE              
    LEDGER_TYPE = @@EXCH_TO  
 AND BTOBPAYMENT = 0              
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT              
   HAVING              
    SUM(MARGIN_USAGE_AMOUNT) < 0) B              
  WHERE              
   A.CLTCODE = B.CLTCODE              
   AND A.CLTCODE BETWEEN @CLIENT_FR AND @CLIENT_TO              
             
  INSERT INTO               
   V2_FT_COMPUTEBALANCES              
  SELECT              
   CLTCODE, ACNAME, @@EXCH_FR, 88, -(TRF_AMOUNT), 0, 0, 0, 0, 0, 0, @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT  
  FROM               
   #FUND_TRF              
              
  INSERT INTO               
   V2_FT_COMPUTEBALANCES              
  SELECT              
   CLTCODE, ACNAME, @@EXCH_TO, 88, (TRF_AMOUNT), (TRF_AMOUNT), 0, 0, 0, (TRF_AMOUNT), 0, @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT  
  FROM               
   #FUND_TRF              
              
 END              
 ELSE IF @@TRF_TYPE = 0              
 BEGIN              
  INSERT INTO               
   #FUND_TRF              
  SELECT              
   A.CLTCODE, A.ACNAME, CASE WHEN ABS(A.FINAL_AMOUNT) <= ABS(B.FINAL_AMOUNT) THEN ABS(A.FINAL_AMOUNT) ELSE ABS(B.FINAL_AMOUNT) END, A.BTOBPAYMENT  
  FROM              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = SUM(FINAL_LEDGER_AMOUNT + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END  + MARGIN_REQ + MARGIN_AMOUNT), BTOBPAYMENT  
   FROM              
    V2_FT_COMPUTEBALANCES              
   WHERE              
    LEDGER_TYPE = @@EXCH_FR  
 AND BTOBPAYMENT = 0              
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT              
   HAVING              
    SUM(FINAL_LEDGER_AMOUNT + MARGIN_REQ + MARGIN_AMOUNT) > 0) A,              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = SUM(MARGIN_USAGE_AMOUNT), BTOBPAYMENT              
   FROM              
    V2_FT_COMPUTEBALANCES              
   WHERE              
    LEDGER_TYPE = @@EXCH_TO  
 AND BTOBPAYMENT = 0              
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT              
   HAVING              
    SUM(MARGIN_USAGE_AMOUNT) < 0) B              
  WHERE              
   A.CLTCODE = B.CLTCODE              
   AND A.CLTCODE BETWEEN @CLIENT_FR AND @CLIENT_TO              
              
  INSERT INTO               
   V2_FT_COMPUTEBALANCES              
  SELECT              
   CLTCODE, ACNAME, @@EXCH_FR, 88, -(TRF_AMOUNT), 0, 0, 0, 0, 0, 0, @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT  
  FROM               
   #FUND_TRF              
              
  INSERT INTO               
   V2_FT_COMPUTEBALANCES              
  SELECT              
   CLTCODE, ACNAME, @@EXCH_TO, 88, (TRF_AMOUNT), 0, 0, 0, 0, (TRF_AMOUNT), 0, @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT              
  FROM               
   #FUND_TRF              
 END              
              
 IF @@TRF_TYPE = 2 AND (@@EXCH_TO = 'NFO' OR @@DB_FR = @@DB_TO)              
 BEGIN              
  INSERT INTO               
   #FUND_TRF              
  SELECT              
   A.CLTCODE, A.ACNAME, CASE WHEN ABS(A.FINAL_AMOUNT) <= ABS(B.FINAL_AMOUNT) THEN ABS(A.FINAL_AMOUNT) ELSE ABS(B.FINAL_AMOUNT) END, A.BTOBPAYMENT  
  FROM              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = CASE WHEN SUM(MARGIN_AMOUNT + MARGIN_REQ  + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) > SUM(MARGIN_AMOUNT) THEN SUM(MARGIN_AMOUNT) ELSE SUM(MARGIN_AMOUNT + MARGIN_REQ + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) END, BTOBPAYMENT  
   FROM              
    V2_FT_COMPUTEBALANCES              
   WHERE              
    LEDGER_TYPE = @@EXCH_FR  
 AND BTOBPAYMENT = 0              
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT              
   HAVING              
    CASE WHEN SUM(MARGIN_AMOUNT + MARGIN_REQ + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) > SUM(MARGIN_AMOUNT) THEN SUM(MARGIN_AMOUNT) ELSE SUM(MARGIN_AMOUNT + MARGIN_REQ + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) END > 0) A,              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = SUM(MARGIN_USAGE_AMOUNT), BTOBPAYMENT              
   FROM              
    V2_FT_COMPUTEBALANCES              
   WHERE              
    LEDGER_TYPE = @@EXCH_TO  
 AND BTOBPAYMENT = 0              
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT              
   HAVING              
    SUM(MARGIN_USAGE_AMOUNT) < 0) B              
  WHERE              
   A.CLTCODE = B.CLTCODE              
   AND A.CLTCODE BETWEEN @CLIENT_FR AND @CLIENT_TO              
              
  INSERT INTO               
   V2_FT_COMPUTEBALANCES              
   SELECT              
   CLTCODE, ACNAME, @@EXCH_FR, 88, 0, -(TRF_AMOUNT), 0, -(TRF_AMOUNT), 0, 0, 0, @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT  
  FROM               
   #FUND_TRF              
          
  INSERT INTO               
   V2_FT_COMPUTEBALANCES              
  SELECT              
   CLTCODE, ACNAME, @@EXCH_TO, 88, (TRF_AMOUNT), 0, (TRF_AMOUNT), 0, 0, (TRF_AMOUNT), 0, @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT              
  FROM               
   #FUND_TRF              
 END              
 ELSE IF @@TRF_TYPE = 2         
 BEGIN              
  INSERT INTO               
   #FUND_TRF              
  SELECT              
   A.CLTCODE, A.ACNAME, CASE WHEN ABS(A.FINAL_AMOUNT) <= ABS(B.FINAL_AMOUNT) THEN ABS(A.FINAL_AMOUNT) ELSE ABS(B.FINAL_AMOUNT) END, A.BTOBPAYMENT  
  FROM              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = CASE WHEN SUM(MARGIN_AMOUNT + MARGIN_REQ + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) > SUM(MARGIN_AMOUNT) THEN SUM(MARGIN_AMOUNT) ELSE SUM(MARGIN_AMOUNT + MARGIN_REQ + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) END, BTOBPAYMENT  
   FROM              
    V2_FT_COMPUTEBALANCES  
   WHERE              
    LEDGER_TYPE = @@EXCH_FR              
	AND BTOBPAYMENT = 0  
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT              
   HAVING              
    CASE WHEN SUM(MARGIN_AMOUNT + MARGIN_REQ + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) > SUM(MARGIN_AMOUNT) THEN SUM(MARGIN_AMOUNT) ELSE SUM(MARGIN_AMOUNT + MARGIN_REQ + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) END > 0) A,              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = SUM(MARGIN_USAGE_AMOUNT), BTOBPAYMENT              
   FROM              
    V2_FT_COMPUTEBALANCES              
   WHERE              
    LEDGER_TYPE = @@EXCH_TO  
 AND BTOBPAYMENT = 0              
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT              
   HAVING              
    SUM(MARGIN_USAGE_AMOUNT) < 0) B              
  WHERE              
   A.CLTCODE = B.CLTCODE              
   AND A.CLTCODE BETWEEN @CLIENT_FR AND @CLIENT_TO              
             
  INSERT INTO               
   V2_FT_COMPUTEBALANCES              
   SELECT              
   CLTCODE, ACNAME, @@EXCH_FR, 88, 0, -(TRF_AMOUNT), 0, -(TRF_AMOUNT), 0, 0, 0, @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT  
  FROM               
   #FUND_TRF              
          
  INSERT INTO               
   V2_FT_COMPUTEBALANCES              
  SELECT              
 CLTCODE, ACNAME, @@EXCH_TO, 88, (TRF_AMOUNT), 0, (TRF_AMOUNT), 0, 0, (TRF_AMOUNT), 0, @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT              
  FROM               
   #FUND_TRF              
 END              
              
 IF @@TRF_TYPE = 3 AND @@EXCH_TO = 'NFO'              
 BEGIN              
  INSERT INTO               
   #FUND_TRF              
  SELECT              
   A.CLTCODE, A.ACNAME, CASE WHEN ABS(A.FINAL_AMOUNT) <= ABS(B.FINAL_AMOUNT) THEN ABS(A.FINAL_AMOUNT) ELSE ABS(B.FINAL_AMOUNT) END, A.BTOBPAYMENT  
  FROM              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = CASE WHEN SUM(MARGIN_AMOUNT + MARGIN_REQ + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) > SUM(MARGIN_AMOUNT) THEN SUM(MARGIN_AMOUNT) ELSE SUM(MARGIN_AMOUNT + MARGIN_REQ + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) END, BTOBPAYMENT              
   FROM              
    V2_FT_COMPUTEBALANCES              
   WHERE              
    LEDGER_TYPE = @@EXCH_FR              
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT              
   HAVING              
    CASE WHEN SUM(MARGIN_AMOUNT + MARGIN_REQ + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) > SUM(MARGIN_AMOUNT) THEN SUM(MARGIN_AMOUNT) ELSE SUM(MARGIN_AMOUNT + MARGIN_REQ + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) END > 0) A,              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = SUM(MARGIN_AMOUNT + MARGIN_REQ), BTOBPAYMENT              
   FROM              
    V2_FT_COMPUTEBALANCES              
   WHERE              
    LEDGER_TYPE = @@EXCH_TO              
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT             
   HAVING              
    SUM(MARGIN_AMOUNT + MARGIN_REQ) < 0) B              
  WHERE              
   A.CLTCODE = B.CLTCODE              
   AND A.CLTCODE BETWEEN @CLIENT_FR AND @CLIENT_TO              
              
  INSERT INTO               
   V2_FT_COMPUTEBALANCES              
  SELECT              
   CLTCODE, ACNAME, @@EXCH_FR, 88, 0, -(TRF_AMOUNT), 0, -(TRF_AMOUNT), 0, 0, 0, @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT  
  FROM               
   #FUND_TRF              
            
  INSERT INTO               
   V2_FT_COMPUTEBALANCES              
  SELECT              
   CLTCODE, ACNAME, @@EXCH_TO, 88, 0, (TRF_AMOUNT), 0, 0, 0, 0, (TRF_AMOUNT), @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT              
  FROM               
   #FUND_TRF              
 END              
 ELSE IF @@TRF_TYPE = 3              
 BEGIN              
  INSERT INTO               
   #FUND_TRF              
  SELECT              
   A.CLTCODE, A.ACNAME, CASE WHEN ABS(A.FINAL_AMOUNT) <= ABS(B.FINAL_AMOUNT) THEN ABS(A.FINAL_AMOUNT) ELSE ABS(B.FINAL_AMOUNT) END, A.BTOBPAYMENT  
  FROM              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = CASE WHEN SUM(MARGIN_AMOUNT + MARGIN_REQ + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) > SUM(MARGIN_AMOUNT) THEN SUM(MARGIN_AMOUNT) ELSE SUM(MARGIN_AMOUNT + MARGIN_REQ + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) END, BTOBPAYMENT              
   FROM              
    V2_FT_COMPUTEBALANCES              
   WHERE              
    LEDGER_TYPE = @@EXCH_FR              
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT              
   HAVING              
    CASE WHEN SUM(MARGIN_AMOUNT + MARGIN_REQ + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) > SUM(MARGIN_AMOUNT) THEN SUM(MARGIN_AMOUNT) ELSE SUM(MARGIN_AMOUNT + MARGIN_REQ + CASE WHEN MARGIN_USAGE_AMOUNT < 0 THEN MARGIN_USAGE_AMOUNT ELSE 0 END) END > 0) A,              
   (SELECT              
    CLTCODE, ACNAME, LEDGER_TYPE, FINAL_AMOUNT = SUM(MARGIN_AMOUNT + MARGIN_REQ), BTOBPAYMENT              
   FROM              
    V2_FT_COMPUTEBALANCES              
   WHERE              
    LEDGER_TYPE = @@EXCH_TO              
   GROUP BY              
    CLTCODE, LEDGER_TYPE, ACNAME, BTOBPAYMENT              
   HAVING              
    SUM(MARGIN_AMOUNT + MARGIN_REQ) < 0) B              
  WHERE              
   A.CLTCODE = B.CLTCODE              
   AND A.CLTCODE BETWEEN @CLIENT_FR AND @CLIENT_TO              
              
  INSERT INTO               
   V2_FT_COMPUTEBALANCES              
  SELECT              
   CLTCODE, ACNAME, @@EXCH_FR, 88, 0, -(TRF_AMOUNT), 0, -(TRF_AMOUNT), 0, 0, 0, @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT  
  FROM               
   #FUND_TRF              
              
  INSERT INTO               
   V2_FT_COMPUTEBALANCES              
  SELECT              
   CLTCODE, ACNAME, @@EXCH_TO, 88, 0, (TRF_AMOUNT), 0, 0, 0, 0, (TRF_AMOUNT), @@SR_NO, '', '', SR_NO, 'FUND TRANSFER FROM ' + @@EXCH_FR + ' TO ' + @@EXCH_TO, BTOBPAYMENT              
  FROM               
   #FUND_TRF              
 END          
      
IF @@TRF_TYPE = 1      
BEGIN        
 SET @@SQL = "UPDATE V2_FT_COMPUTEBALANCES SET FINAL_LEDGER_AMOUNT = MARGIN_REQ WHERE LEDGER_TYPE = '" + @@EXCH_TO + "' AND FINAL_LEDGER_AMOUNT = 0 AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)      
 EXEC (@@SQL)      
END     
    
IF @@TRF_TYPE = 2      
BEGIN        
 SET @@SQL = "UPDATE V2_FT_COMPUTEBALANCES SET FINAL_LEDGER_AMOUNT = FINAL_MARGIN_AMOUNT WHERE LEDGER_TYPE = '" + @@EXCH_FR + "' AND FINAL_LEDGER_AMOUNT = 0 AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)      
 EXEC (@@SQL)      
END      
    
IF @@TRF_TYPE = 3      
BEGIN        
 SET @@SQL = "UPDATE V2_FT_COMPUTEBALANCES SET FINAL_LEDGER_AMOUNT = FINAL_MARGIN_AMOUNT WHERE ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)      
 EXEC (@@SQL)      
END        
      
       
      
      
DELETE FROM V2_FT_COMPUTEBALANCES WHERE VTYPE = 88 AND FINAL_LEDGER_AMOUNT = 0 AND FINAL_MARGIN_AMOUNT = 0 AND MARGIN_REQ = 0 AND MARGIN_USAGE_AMOUNT = 0             
              
 SELECT @@VNO_COUNT = COUNT(SR_NO) FROM #FUND_TRF              
              
 SET @@SQL = "INSERT INTO #VNO "              
 SET @@SQL = @@SQL + " EXEC " + @@DB_FR + ".DBO.ACC_GENVNO_NEW '" + @VDT + "', 88, '01', '" + @START_DATE + "', '" + @END_DATE + "'," + CONVERT(VARCHAR, @@VNO_COUNT)              
              
 EXEC (@@SQL)              
              
 SELECT @@VNO_FR = VNO FROM #VNO              
              
              
 TRUNCATE TABLE #VNO              
              
 SET @@SQL = "INSERT INTO #VNO "              
 SET @@SQL = @@SQL + " EXEC " + @@DB_TO + ".DBO.ACC_GENVNO_NEW '" + @VDT + "', 88, '01', '" + @START_DATE + "', '" + @END_DATE + "'," + CONVERT(VARCHAR, @@VNO_COUNT)              
              
 EXEC (@@SQL)              
              
 SELECT @@VNO_TO = VNO FROM #VNO              
              
 TRUNCATE TABLE #VNO              
              
 SELECT @@VNO_FR = VNO FROM #VNO              
 SELECT @@VNO_TO = VNO FROM #VNO              
              
              
 UPDATE V2_FT_COMPUTEBALANCES SET SOURCE_VNO = (CONVERT(NUMERIC, @@VNO_FR) - 1) + SR_NO FROM #FUND_TRF F WHERE F.CLTCODE = V2_FT_COMPUTEBALANCES.CLTCODE AND ENTRY_TYPE = @@SR_NO             
 UPDATE V2_FT_COMPUTEBALANCES SET TARGET_VNO = (CONVERT(NUMERIC, @@VNO_TO) - 1) + SR_NO FROM #FUND_TRF F WHERE F.CLTCODE = V2_FT_COMPUTEBALANCES.CLTCODE AND ENTRY_TYPE = @@SR_NO              
              
              
              
 IF @@TRF_TYPE = 0              
 BEGIN              
  SET @@SQL = "INSERT INTO " + @@DB_FR + ".DBO.LEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  SOURCE_VNO, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "              
  SET @@SQL = @@SQL + "  2, "              
  SET @@SQL = @@SQL + "  ACNAME, CASE WHEN FINAL_LEDGER_AMOUNT < 0 THEN 'D' ELSE 'C' END, "              
  SET @@SQL = @@SQL + "  ABS(FINAL_LEDGER_AMOUNT), "              
  SET @@SQL = @@SQL + "'" + @VDT + "',"              
  SET @@SQL = @@SQL + "  SOURCE_VNO, "              
  SET @@SQL = @@SQL + "  REFNO = '', "              
  SET @@SQL = @@SQL + "  BALAMT = 0, "              
  SET @@SQL = @@SQL + "  NODAYS = 0, "              
  SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
  SET @@SQL = @@SQL + "  CLTCODE, "              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
  SET @@SQL = @@SQL + " NARRATION "              
  SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_FR + "' AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
              
  SET @@SQL = @@SQL + " INSERT INTO " + @@DB_FR + ".DBO.LEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  SOURCE_VNO, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "              
  SET @@SQL = @@SQL + "  1, "              
              
  SET @@SQL = @@SQL + "  '" + @@JV_NAME_FR + "', "              
              
  SET @@SQL = @@SQL + " CASE WHEN SUM(FINAL_LEDGER_AMOUNT) < 0 THEN 'C' ELSE 'D' END, "              
  SET @@SQL = @@SQL + "  ABS(SUM(FINAL_LEDGER_AMOUNT)), "              
  SET @@SQL = @@SQL + "'" + @VDT + "',"              
  SET @@SQL = @@SQL + "  SOURCE_VNO, "              
  SET @@SQL = @@SQL + "  REFNO = '', "              
  SET @@SQL = @@SQL + "  BALAMT = 0, "              
  SET @@SQL = @@SQL + "  NODAYS = 0, "              
  SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
              
  SET @@SQL = @@SQL + "  '" + @@JV_CODE_FR + "', "              
              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
  SET @@SQL = @@SQL + " NARRATION "              
  SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_FR + "' AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
  SET @@SQL = @@SQL + " GROUP BY "              
  SET @@SQL = @@SQL + "  SOURCE_VNO, NARRATION "              
              
  EXEC (@@SQL)              
              
  SET @@SQL = "INSERT INTO " + @@DB_TO + ".DBO.LEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  TARGET_VNO, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "              
  SET @@SQL = @@SQL + "  2, "              
  SET @@SQL = @@SQL + "  ACNAME, CASE WHEN FINAL_LEDGER_AMOUNT < 0 THEN 'D' ELSE 'C' END, "              
  SET @@SQL = @@SQL + "  ABS(FINAL_LEDGER_AMOUNT), "              
  SET @@SQL = @@SQL + "'" + @VDT + "',"              
  SET @@SQL = @@SQL + "  SOURCE_VNO, "       
  SET @@SQL = @@SQL + "  REFNO = '', "              
  SET @@SQL = @@SQL + "  BALAMT = 0, "              
  SET @@SQL = @@SQL + "  NODAYS = 0, "              
  SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
  SET @@SQL = @@SQL + "  CLTCODE, "              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
  SET @@SQL = @@SQL + " NARRATION "              
  SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_TO + "' AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
              
  SET @@SQL = @@SQL + " INSERT INTO " + @@DB_TO + ".DBO.LEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  TARGET_VNO, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "              
  SET @@SQL = @@SQL + "  1, "              
              
  SET @@SQL = @@SQL + "  '" + @@JV_NAME_TO + "', "              
              
  SET @@SQL = @@SQL + "  CASE WHEN SUM(FINAL_LEDGER_AMOUNT) < 0 THEN 'C' ELSE 'D' END, "              
  SET @@SQL = @@SQL + "  ABS(SUM(FINAL_LEDGER_AMOUNT)), "              
  SET @@SQL = @@SQL + "'" + @VDT + "',"              
  SET @@SQL = @@SQL + "  TARGET_VNO, "              
  SET @@SQL = @@SQL + "  REFNO = '', "              
  SET @@SQL = @@SQL + "  BALAMT = 0, "              
  SET @@SQL = @@SQL + "  NODAYS = 0, "              
  SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
              
  SET @@SQL = @@SQL + "  '" + @@JV_CODE_TO + "', "              
              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
  SET @@SQL = @@SQL + " NARRATION "              
  SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_TO + "' AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
  SET @@SQL = @@SQL + " GROUP BY "              
  SET @@SQL = @@SQL + "  TARGET_VNO, NARRATION "              
              
  EXEC (@@SQL)              
              
 END              
              
 IF @@TRF_TYPE = 1              
 BEGIN              
              
  SET @@SQL = "INSERT INTO " + @@DB_TO + ".DBO.MARGINLEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  TARGET_VNO, "              
  SET @@SQL = @@SQL + "  1, "              
  SET @@SQL = @@SQL + "  CASE WHEN FINAL_LEDGER_AMOUNT < 0 THEN 'D' ELSE 'C' END, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "              
  SET @@SQL = @@SQL + "  ABS(FINAL_LEDGER_AMOUNT), "              
  SET @@SQL = @@SQL + "  CLTCODE, "              
  SET @@SQL = @@SQL + "'" + CASE WHEN LEFT(@@EXCH_TO, 3) = 'NFO' OR LEFT(@@EXCH_FR, 3) = 'NSE' THEN 'NSE' ELSE 'BSE' END + "', "              
  SET @@SQL = @@SQL + "'" + CASE WHEN LEFT(@@EXCH_TO, 3) = 'NFO' OR LEFT(@@EXCH_FR, 3) = 'BFO' THEN 'FUTURES' ELSE 'CAPITAL' END + "', "              
  SET @@SQL = @@SQL + "  0, '', "              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @@ML_CODE_to + "' "              
  SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_TO + "' AND FINAL_LEDGER_AMOUNT > 0 AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
              
  SET @@SQL = @@SQL + " INSERT INTO " + @@DB_TO + ".DBO.LEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  TARGET_VNO, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "              
  SET @@SQL = @@SQL + "  2, "              
  IF @@DB_FR <> @@DB_TO              
    SET @@SQL = @@SQL + "  '" + @@JV_NAME_TO + "', "              
  ELSE              
    SET @@SQL = @@SQL + " ACNAME, "              
              
  SET @@SQL = @@SQL + "  CASE WHEN SUM(FINAL_LEDGER_AMOUNT) < 0 THEN 'C' ELSE 'D' END, "              
  SET @@SQL = @@SQL + "  ABS(SUM(FINAL_LEDGER_AMOUNT)), "              
  SET @@SQL = @@SQL + "'" + @VDT + "',"              
  SET @@SQL = @@SQL + "  TARGET_VNO, "              
  SET @@SQL = @@SQL + "  REFNO = '', "              
  SET @@SQL = @@SQL + "  BALAMT = 0, "              
  SET @@SQL = @@SQL + "  NODAYS = 0, "              
  SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
              
  IF @@DB_FR <> @@DB_TO              
   SET @@SQL = @@SQL + "'" + @@JV_CODE_TO + "', "              
  ELSE              
   SET @@SQL = @@SQL + " CLTCODE, "              
              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
  SET @@SQL = @@SQL + " NARRATION "              
  SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_TO + "'  AND FINAL_LEDGER_AMOUNT>0 AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
  SET @@SQL = @@SQL + " GROUP BY "              
  SET @@SQL = @@SQL + "  TARGET_VNO, NARRATION "              
  IF @@DB_FR = @@DB_TO              
   SET @@SQL = @@SQL + ", ACNAME, CLTCODE "              
              
  SET @@SQL = @@SQL + " INSERT INTO " + @@DB_TO + ".DBO.LEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  TARGET_VNO, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "             
  SET @@SQL = @@SQL + "  1, "              
  SET @@SQL = @@SQL + "  '" + @@ML_NAME_TO + "', CASE WHEN SUM(FINAL_LEDGER_AMOUNT) < 0 THEN 'D' ELSE 'C' END, "              
              
  SET @@SQL = @@SQL + "  ABS(SUM(FINAL_LEDGER_AMOUNT)), "              
  SET @@SQL = @@SQL + "'" + @VDT + "',"              
  SET @@SQL = @@SQL + "  TARGET_VNO, "              
  SET @@SQL = @@SQL + "  REFNO = '', "              
  SET @@SQL = @@SQL + "  BALAMT = 0, "              
  SET @@SQL = @@SQL + "  NODAYS = 0, "              
  SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
              
  SET @@SQL = @@SQL + "'" + @@ML_CODE_TO + "', "              
              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
  SET @@SQL = @@SQL + " NARRATION "              
  SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_TO + "' AND FINAL_LEDGER_AMOUNT>0  AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
  SET @@SQL = @@SQL + " GROUP BY "              
  SET @@SQL = @@SQL + "  TARGET_VNO, LNO, NARRATION "              
              
  EXEC (@@SQL)              
              
  IF @@DB_FR <> @@DB_TO              
  BEGIN              
     SET @@SQL = "INSERT INTO " + @@DB_FR + ".DBO.LEDGER "              
     SET @@SQL = @@SQL + " SELECT "              
     SET @@SQL = @@SQL + "  88, "              
     SET @@SQL = @@SQL + "  SOURCE_VNO, "              
     SET @@SQL = @@SQL + "'" + @VDT + "', "              
     SET @@SQL = @@SQL + "  2, "              
              
     SET @@SQL = @@SQL + "  ACNAME, CASE WHEN FINAL_LEDGER_AMOUNT < 0 THEN 'D' ELSE 'C' END, "              
              
     SET @@SQL = @@SQL + "  ABS(FINAL_LEDGER_AMOUNT), "              
     SET @@SQL = @@SQL + "'" + @VDT + "',"              
     SET @@SQL = @@SQL + "  SOURCE_VNO, "              
     SET @@SQL = @@SQL + "  REFNO = '', "              
     SET @@SQL = @@SQL + "  BALAMT = 0, "              
     SET @@SQL = @@SQL + "  NODAYS = 0, "              
     SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
              
     SET @@SQL = @@SQL + "  CLTCODE, "              
              
     SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
     SET @@SQL = @@SQL + "'" + @UNAME + "', "              
     SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
     SET @@SQL = @@SQL + "'" + @UNAME + "', "              
     SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
     SET @@SQL = @@SQL + " NARRATION "              
     SET @@SQL = @@SQL + " FROM "              
     SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
     SET @@SQL = @@SQL + " WHERE "              
     SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_FR + "' AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
              
     SET @@SQL = @@SQL + " INSERT INTO " + @@DB_FR + ".DBO.LEDGER "              
     SET @@SQL = @@SQL + " SELECT "              
     SET @@SQL = @@SQL + "  88, "              
     SET @@SQL = @@SQL + "  SOURCE_VNO, "              
     SET @@SQL = @@SQL + "'" + @VDT + "', "              
     SET @@SQL = @@SQL + "  1, "              
              
     SET @@SQL = @@SQL + "  '" + @@JV_NAME_FR + "', CASE WHEN SUM(FINAL_LEDGER_AMOUNT) < 0 THEN 'C' ELSE 'D' END, "              
              
     SET @@SQL = @@SQL + "  ABS(SUM(FINAL_LEDGER_AMOUNT)), "              
     SET @@SQL = @@SQL + "'" + @VDT + "',"              
     SET @@SQL = @@SQL + "   SOURCE_VNO, "              
     SET @@SQL = @@SQL + "  REFNO = '', "              
     SET @@SQL = @@SQL + "  BALAMT = 0, "              
     SET @@SQL = @@SQL + "  NODAYS = 0, "              
     SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
              
     SET @@SQL = @@SQL + "'" + @@JV_CODE_FR + "', "              
              
     SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
     SET @@SQL = @@SQL + "'" + @UNAME + "', "              
     SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
     SET @@SQL = @@SQL + "'" + @UNAME + "', "              
     SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
     SET @@SQL = @@SQL + " NARRATION "              
     SET @@SQL = @@SQL + " FROM "              
 SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
     SET @@SQL = @@SQL + " WHERE "              
     SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_FR + "' AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
     SET @@SQL = @@SQL + " GROUP BY "              
     SET @@SQL = @@SQL + "  SOURCE_VNO, NARRATION "              
              
     EXEC (@@SQL)              
  END              
 END              
              
 IF @@TRF_TYPE = 2              
 BEGIN              
              
  SET @@SQL = "INSERT INTO " + @@DB_FR + ".DBO.MARGINLEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  SOURCE_VNO, "              
  SET @@SQL = @@SQL + "  1, "              
  SET @@SQL = @@SQL + "  CASE WHEN FINAL_LEDGER_AMOUNT < 0 THEN 'D' ELSE 'C' END, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "              
  SET @@SQL = @@SQL + "  ABS(FINAL_LEDGER_AMOUNT), "         
  SET @@SQL = @@SQL + "  CLTCODE, "              
  SET @@SQL = @@SQL + "'" + CASE WHEN LEFT(@@EXCH_FR, 3) = 'NFO' OR LEFT(@@EXCH_FR, 3) = 'NSE' THEN 'NSE' ELSE 'BSE' END + "', "              
  SET @@SQL = @@SQL + "'" + CASE WHEN LEFT(@@EXCH_FR, 3) = 'NFO' OR LEFT(@@EXCH_FR, 3) = 'BFO' THEN 'FUTURES' ELSE 'CAPITAL' END + "', "              
  SET @@SQL = @@SQL + "  0, '', "              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @@ML_CODE_FR + "' "              
  SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_FR + "' AND FINAL_LEDGER_AMOUNT < 0 AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
              
  SET @@SQL = @@SQL + " INSERT INTO " + @@DB_FR + ".DBO.LEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  SOURCE_VNO, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "              
  SET @@SQL = @@SQL + "  2, "              
  IF @@DB_FR <> @@DB_TO              
  BEGIN      
   SET @@SQL = @@SQL + "  '" + @@JV_NAME_FR + "', "              
  END      
  ELSE              
  BEGIN      
   SET @@SQL = @@SQL + " ACNAME, "              
  END      
      
  SET @@SQL = @@SQL + "  CASE WHEN SUM(FINAL_LEDGER_AMOUNT) < 0 THEN 'C' ELSE 'D' END, "              
              
        
  SET @@SQL = @@SQL + "  ABS(SUM(FINAL_LEDGER_AMOUNT)), "              
  SET @@SQL = @@SQL + "'" + @VDT + "',"              
  SET @@SQL = @@SQL + "  SOURCE_VNO, "              
  SET @@SQL = @@SQL + "  REFNO = '', "              
  SET @@SQL = @@SQL + "  BALAMT = 0, "              
  SET @@SQL = @@SQL + "  NODAYS = 0, "              
  SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
              
  IF @@DB_FR <> @@DB_TO              
   SET @@SQL = @@SQL + "'" + @@JV_CODE_FR + "', "              
  ELSE              
   SET @@SQL = @@SQL + " CLTCODE, "              
              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
  SET @@SQL = @@SQL + " NARRATION "              
  SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_FR + "' AND FINAL_LEDGER_AMOUNT < 0 AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
        
      
  SET @@SQL = @@SQL + " GROUP BY "              
  SET @@SQL = @@SQL + "  SOURCE_VNO, NARRATION "              
  IF @@DB_FR = @@DB_TO              
   SET @@SQL = @@SQL + ", ACNAME, CLTCODE "              
              
  SET @@SQL = @@SQL + " INSERT INTO " + @@DB_FR + ".DBO.LEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  SOURCE_VNO, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "              
  SET @@SQL = @@SQL + "  1, "              
  SET @@SQL = @@SQL + "  '" + @@ML_NAME_FR + "', CASE WHEN SUM(FINAL_LEDGER_AMOUNT) < 0 THEN 'D' ELSE 'C' END, "              
              
  SET @@SQL = @@SQL + "  ABS(SUM(FINAL_LEDGER_AMOUNT)), "              
  SET @@SQL = @@SQL + "'" + @VDT + "',"              
  SET @@SQL = @@SQL + "  SOURCE_VNO, "              
  SET @@SQL = @@SQL + "  REFNO = '', "              
  SET @@SQL = @@SQL + "  BALAMT = 0, "              
  SET @@SQL = @@SQL + "  NODAYS = 0, "              
  SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
              
  SET @@SQL = @@SQL + "'" + @@ML_CODE_FR + "', "              
              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
  SET @@SQL = @@SQL + " NARRATION "              
 SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_FR + "' AND FINAL_LEDGER_AMOUNT < 0 AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
        
  SET @@SQL = @@SQL + " GROUP BY "              
  SET @@SQL = @@SQL + "  SOURCE_VNO, LNO, NARRATION "              
              
  EXEC (@@SQL)              
              
  IF @@DB_FR <> @@DB_TO               
  BEGIN              
   SET @@SQL = "INSERT INTO " + @@DB_TO + ".DBO.LEDGER "              
   SET @@SQL = @@SQL + " SELECT "              
   SET @@SQL = @@SQL + "  88, "              
   SET @@SQL = @@SQL + "  TARGET_VNO, "              
   SET @@SQL = @@SQL + "'" + @VDT + "', "              
   SET @@SQL = @@SQL + "  2, "              
              
   SET @@SQL = @@SQL + "  ACNAME, CASE WHEN FINAL_LEDGER_AMOUNT < 0 THEN 'D' ELSE 'C' END, "              
   ----(change)            
   SET @@SQL = @@SQL + "  ABS(FINAL_LEDGER_AMOUNT), "              
   SET @@SQL = @@SQL + "'" + @VDT + "',"              
   SET @@SQL = @@SQL + "  TARGET_VNO, "              
   SET @@SQL = @@SQL + "  REFNO = '', "              
   SET @@SQL = @@SQL + "  BALAMT = 0, "              
   SET @@SQL = @@SQL + "  NODAYS = 0, "              
   SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
              
   SET @@SQL = @@SQL + "  CLTCODE, "              
              
   SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
   SET @@SQL = @@SQL + "'" + @UNAME + "', "              
   SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
   SET @@SQL = @@SQL + "'" + @UNAME + "', "              
   SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
   SET @@SQL = @@SQL + " NARRATION "              
   SET @@SQL = @@SQL + " FROM "              
   SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
   SET @@SQL = @@SQL + " WHERE "              
   SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_TO + "' AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
              
   SET @@SQL = @@SQL + " INSERT INTO " + @@DB_TO + ".DBO.LEDGER "              
   SET @@SQL = @@SQL + " SELECT "              
   SET @@SQL = @@SQL + "  88, "              
   SET @@SQL = @@SQL + "  TARGET_VNO, "              
   SET @@SQL = @@SQL + "'" + @VDT + "', "              
   SET @@SQL = @@SQL + "  1, "              
              
   SET @@SQL = @@SQL + "  '" + @@JV_NAME_FR + "', CASE WHEN SUM(FINAL_LEDGER_AMOUNT) < 0 THEN 'C' ELSE 'D' END, "              
   ---(change)            
              
   SET @@SQL = @@SQL + "  ABS(SUM(FINAL_LEDGER_AMOUNT)), "              
   SET @@SQL = @@SQL + "'" + @VDT + "',"              
   SET @@SQL = @@SQL + "   TARGET_VNO, "              
   SET @@SQL = @@SQL + "  REFNO = '', "          
   SET @@SQL = @@SQL + "  BALAMT = 0, "              
   SET @@SQL = @@SQL + "  NODAYS = 0, "              
   SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
              
   SET @@SQL = @@SQL + "'" + @@JV_CODE_TO + "', "              
              
   SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
   SET @@SQL = @@SQL + "'" + @UNAME + "', "              
   SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
   SET @@SQL = @@SQL + "'" + @UNAME + "', "              
   SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
   SET @@SQL = @@SQL + " NARRATION "              
   SET @@SQL = @@SQL + " FROM "              
   SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
   SET @@SQL = @@SQL + " WHERE "              
   SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_TO + "' AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
   SET @@SQL = @@SQL + " GROUP BY "              
   SET @@SQL = @@SQL + "  TARGET_VNO, NARRATION "              
              
   EXEC (@@SQL)              
  END              
 END              
              
 IF @@TRF_TYPE = 3              
 BEGIN              
              
  SET @@SQL = "INSERT INTO " + @@DB_TO + ".DBO.MARGINLEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  TARGET_VNO, "              
  SET @@SQL = @@SQL + "  1, "                                      
  SET @@SQL = @@SQL + "  CASE WHEN FINAL_LEDGER_AMOUNT < 0 THEN 'D' ELSE 'C' END, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "              
  SET @@SQL = @@SQL + "  ABS(FINAL_LEDGER_AMOUNT), "              
  SET @@SQL = @@SQL + "  CLTCODE, "              
  SET @@SQL = @@SQL + "'" + CASE WHEN LEFT(@@EXCH_TO, 3) = 'NFO' OR LEFT(@@EXCH_FR, 3) = 'NSE' THEN 'NSE' ELSE 'BSE' END + "', "              
  SET @@SQL = @@SQL + "'" + CASE WHEN LEFT(@@EXCH_TO, 3) = 'NFO' OR LEFT(@@EXCH_FR, 3) = 'BFO' THEN 'FUTURES' ELSE 'CAPITAL' END + "', "              
  SET @@SQL = @@SQL + "  0, '', "              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @@ML_CODE_TO + "' "              
  SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_TO + "' AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
              
  SET @@SQL = @@SQL + "INSERT INTO " + @@DB_FR + ".DBO.MARGINLEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  SOURCE_VNO, "              
  SET @@SQL = @@SQL + "  1, "              
  SET @@SQL = @@SQL + "  CASE WHEN FINAL_LEDGER_AMOUNT < 0 THEN 'D' ELSE 'C' END, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "              
  SET @@SQL = @@SQL + "  ABS(FINAL_LEDGER_AMOUNT), "              
  SET @@SQL = @@SQL + "  CLTCODE, "              
  SET @@SQL = @@SQL + "'" + CASE WHEN LEFT(@@EXCH_TO, 3) = 'NFO' OR LEFT(@@EXCH_FR, 3) = 'NSE' THEN 'NSE' ELSE 'BSE' END + "', "              
  SET @@SQL = @@SQL + "'" + CASE WHEN LEFT(@@EXCH_TO, 3) = 'NFO' OR LEFT(@@EXCH_FR, 3) = 'BFO' THEN 'FUTURES' ELSE 'CAPITAL' END + "', "              
  SET @@SQL = @@SQL + "  0, '', "              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @@ML_CODE_FR + "' "              
  SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_FR + "' AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
              
  SET @@SQL = @@SQL + " INSERT INTO " + @@DB_TO + ".DBO.LEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  TARGET_VNO, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "              
  SET @@SQL = @@SQL + "  2, "              
  IF @@DB_FR <> @@DB_TO              
    SET @@SQL = @@SQL + "  '" + @@JV_NAME_TO + "', "              
  ELSE              
    SET @@SQL = @@SQL + " ACNAME, "              
              
  SET @@SQL = @@SQL + "  CASE WHEN SUM(FINAL_LEDGER_AMOUNT) < 0 THEN 'C' ELSE 'D' END, "              
  SET @@SQL = @@SQL + "  ABS(SUM(FINAL_LEDGER_AMOUNT)), "              
  SET @@SQL = @@SQL + "'" + @VDT + "',"              
  SET @@SQL = @@SQL + "  TARGET_VNO, "              
  SET @@SQL = @@SQL + "  REFNO = '', "              
  SET @@SQL = @@SQL + "  BALAMT = 0, "              
  SET @@SQL = @@SQL + "  NODAYS = 0, "              
  SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
              
  IF @@DB_FR <> @@DB_TO              
   SET @@SQL = @@SQL + "'" + @@JV_CODE_TO + "', "              
  ELSE              
   SET @@SQL = @@SQL + " CLTCODE, "              
              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
  SET @@SQL = @@SQL + " NARRATION "              
  SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_TO + "' AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
  SET @@SQL = @@SQL + " GROUP BY "              
  SET @@SQL = @@SQL + "  TARGET_VNO, NARRATION "              
  IF @@DB_FR = @@DB_TO              
   SET @@SQL = @@SQL + ", ACNAME, CLTCODE "              
              
  SET @@SQL = @@SQL + " INSERT INTO " + @@DB_TO + ".DBO.LEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  TARGET_VNO, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "              
  SET @@SQL = @@SQL + "  1, "              
  SET @@SQL = @@SQL + "  '" + @@ML_NAME_TO + "', CASE WHEN SUM(FINAL_LEDGER_AMOUNT) < 0 THEN 'D' ELSE 'C' END, "              
              
  SET @@SQL = @@SQL + "  ABS(SUM(FINAL_LEDGER_AMOUNT)), "              
  SET @@SQL = @@SQL + "'" + @VDT + "',"              
  SET @@SQL = @@SQL + "  TARGET_VNO, "              
  SET @@SQL = @@SQL + "  REFNO = '', "              
  SET @@SQL = @@SQL + "  BALAMT = 0, "              
  SET @@SQL = @@SQL + "  NODAYS = 0, "              
  SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
              
  SET @@SQL = @@SQL + "'" + @@ML_CODE_TO + "', "              
              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
  SET @@SQL = @@SQL + " NARRATION "              
  SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_TO + "' AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
  SET @@SQL = @@SQL + " GROUP BY "              
  SET @@SQL = @@SQL + "  TARGET_VNO, LNO, NARRATION "              
                
  EXEC (@@SQL)              
              
  SET @@SQL = " INSERT INTO " + @@DB_FR + ".DBO.LEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  SOURCE_VNO, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "              
  SET @@SQL = @@SQL + "  2, "              
  IF @@DB_FR <> @@DB_TO              
    SET @@SQL = @@SQL + "  '" + @@JV_NAME_FR + "', "              
  ELSE              
    SET @@SQL = @@SQL + " ACNAME, "              
              
  SET @@SQL = @@SQL + "  CASE WHEN SUM(FINAL_LEDGER_AMOUNT) < 0 THEN 'C' ELSE 'D' END, "              
 SET @@SQL = @@SQL + "  ABS(SUM(FINAL_LEDGER_AMOUNT)), "              
  SET @@SQL = @@SQL + "'" + @VDT + "',"              
  SET @@SQL = @@SQL + "  SOURCE_VNO, "              
  SET @@SQL = @@SQL + "  REFNO = '', "              
  SET @@SQL = @@SQL + "  BALAMT = 0, "              
  SET @@SQL = @@SQL + "  NODAYS = 0, "              
  SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
              
  IF @@DB_FR <> @@DB_TO              
   SET @@SQL = @@SQL + "'" + @@JV_CODE_FR + "', "              
  ELSE              
   SET @@SQL = @@SQL + " CLTCODE, "              
              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
  SET @@SQL = @@SQL + " NARRATION "              
  SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_FR + "' AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)            
  SET @@SQL = @@SQL + " GROUP BY "              
  SET @@SQL = @@SQL + "  SOURCE_VNO, NARRATION "              
  IF @@DB_FR = @@DB_TO              
   SET @@SQL = @@SQL + ", ACNAME, CLTCODE "              
              
  SET @@SQL = @@SQL + " INSERT INTO " + @@DB_FR + ".DBO.LEDGER "              
  SET @@SQL = @@SQL + " SELECT "              
  SET @@SQL = @@SQL + "  88, "              
  SET @@SQL = @@SQL + "  SOURCE_VNO, "              
  SET @@SQL = @@SQL + "'" + @VDT + "', "              
  SET @@SQL = @@SQL + "  1, "              
  SET @@SQL = @@SQL + "  '" + @@ML_NAME_FR + "', CASE WHEN SUM(FINAL_LEDGER_AMOUNT) < 0 THEN 'D' ELSE 'C' END, "              
              
  SET @@SQL = @@SQL + "  ABS(SUM(FINAL_LEDGER_AMOUNT)), "              
  SET @@SQL = @@SQL + "'" + @VDT + "',"              
  SET @@SQL = @@SQL + "  SOURCE_VNO, "              
  SET @@SQL = @@SQL + "  REFNO = '', "              
  SET @@SQL = @@SQL + "  BALAMT = 0, "              
  SET @@SQL = @@SQL + "  NODAYS = 0, "              
  SET @@SQL = @@SQL + "  CDT = GETDATE(), "              
              
  SET @@SQL = @@SQL + "'" + @@ML_CODE_FR + "', "              
              
  SET @@SQL = @@SQL + "  BOOKTYPE = '01', "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + "  PDT = GETDATE(), "              
  SET @@SQL = @@SQL + "'" + @UNAME + "', "              
  SET @@SQL = @@SQL + " ACTNODAYS = 0, "              
  SET @@SQL = @@SQL + " NARRATION "              
  SET @@SQL = @@SQL + " FROM "              
  SET @@SQL = @@SQL + " V2_FT_COMPUTEBALANCES "              
  SET @@SQL = @@SQL + " WHERE "              
  SET @@SQL = @@SQL + "  LEDGER_TYPE = '" + @@EXCH_FR + "' AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)              
  SET @@SQL = @@SQL + " GROUP BY "              
  SET @@SQL = @@SQL + "  SOURCE_VNO, LNO, NARRATION "              
              
  EXEC (@@SQL)              
              
 END              
      
IF @@TRF_TYPE = 1    
BEGIN        
 SET @@SQL = "UPDATE V2_FT_COMPUTEBALANCES SET FINAL_LEDGER_AMOUNT = 0 WHERE LEDGER_TYPE = '" + @@EXCH_TO + "' AND FINAL_LEDGER_AMOUNT > 0 AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)      
 EXEC (@@SQL)      
END           
      
IF @@TRF_TYPE = 2      
BEGIN        
 SET @@SQL = "UPDATE V2_FT_COMPUTEBALANCES SET FINAL_LEDGER_AMOUNT = 0 WHERE LEDGER_TYPE = '" + @@EXCH_FR + "' AND FINAL_LEDGER_AMOUNT < 0 AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)      
 EXEC (@@SQL)      
END           
    
IF @@TRF_TYPE = 3      
BEGIN        
 SET @@SQL = "UPDATE V2_FT_COMPUTEBALANCES SET FINAL_LEDGER_AMOUNT = 0 WHERE ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)      
SET @@SQL = @@SQL + " UPDATE V2_FT_COMPUTEBALANCES SET FINAL_MARGIN_AMOUNT = 0 WHERE FINAL_MARGIN_AMOUNT > 0 AND ENTRY_TYPE = " + CONVERT(VARCHAR, @@SR_NO)      
 EXEC (@@SQL)      
END           
      
      
      
 INSERT INTO               
  V2_LEDGERTRANSFER              
 SELECT              
  A.BRANCHCODE,              
  F.CLTCODE,              
  F.ACNAME,              
  FINAL_LEDGER_AMOUNT,              
  FINAL_MARGIN_AMOUNT,              
  LEDGER_AMOUNT,              
  MARGIN_AMOUNT,              
  MARGIN_AVAILABLE,              
  MARGIN_USAGE_AMOUNT,              
  MARGIN_REQ,              
  '',              
  @@EXCH_FR,              
  @@EXCH_TO,           
  @VDT,              
  'P',              
  @UNAME,              
  GETDATE(),              
  'FT',              
  NARRATION,              
  0              
 FROM              
  V2_FT_COMPUTEBALANCES F,              
  ACMAST A              
 WHERE              
  LEDGER_TYPE = @@EXCH_FR AND ENTRY_TYPE = CONVERT(VARCHAR, @@SR_NO)              
  AND A.CLTCODE = F.CLTCODE              
              
 FETCH NEXT FROM @@FT_CUR INTO @@SR_NO, @@EXCH_FR, @@EXCH_TO, @@EXCH_DEFAULT, @@DB_FR, @@DB_TO, @@TRF_TYPE, @@JV_CODE_FR, @@JV_NAME_FR, @@JV_CODE_TO, @@JV_NAME_TO, @@ML_CODE_FR, @@ML_NAME_FR, @@ML_CODE_TO, @@ML_NAME_TO              
END

GO
