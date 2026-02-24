-- Object: PROCEDURE dbo.V2_OFFLINE_FILL_REC
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

            
            
CREATE PROC [dbo].[V2_OFFLINE_FILL_REC]              
(              
 @VTYP SMALLINT,              
 @EXCHANGE VARCHAR(3),               
 @SEGMENT VARCHAR(20),               
 @IP_VDATE  VARCHAR(11)               
)              
/*             
            
   EXEC   ACCOUNT_AB.DBO.V2_OFFLINE_FILL_REC 8,'BSE', 'CAPITAL', 'OCT 15 2010'              
V2_OFFLINE_FILL_REC 8, 'NSE','CAPITAL','SEP  1 2009'              
SELECT * FROM V2_OFFLINE_LEDGER_ENTRIES WHERE VOUCHERTYPE = 8 AND VDATE LIKE 'oct  8 2010%' AND  ROWSTATE = 0              
UPDATE V2_OFFLINE_LEDGER_ENTRIES SET ROWSTATE = 0, APPROVALFLAG = 1 WHERE VOUCHERTYPE = 8 AND ROWSTATE = 9              
SELECT * FROM BANK_VNO              
--TRUNCATE TABLE BANK_VNO              
SELECT * FROM V2_OFFLINE_LEDGER_ENTRIES WHERE VOUCHERTYPE = 8 AND VDATE LIKE 'oct  8 2010%'               
select * from ledger where vdt like 'oct  8 2010%'              
              
              
              
              
ROLLBACK              
*/              
AS              
 CREATE TABLE #TEMP              
 (              
  SNO INT,                    
  EDATE        VARCHAR(20),                      
  VDATE   VARCHAR(20),                      
  CLIENT_CODE  VARCHAR(50),                      
  AMOUNT       MONEY,                      
  DRCR         VARCHAR(1),                      
  NARRATION    VARCHAR(234),                      
  BANK_CODE    VARCHAR(10),                      
  BANK_NAME    VARCHAR(100),                      
  REF_NO       VARCHAR(15),                      
  BRANCHCODE   VARCHAR(20),                      
  BRANCH_NAME  VARCHAR(50),                      
  CHQ_MODE     VARCHAR(1),                      
  CHQ_DATE     VARCHAR(20),                      
  CHQ_NAME     VARCHAR(100),                      
  CL_MODE      VARCHAR(1),                      
  FLD_AUTO     BIGINT,                      
  ENTEREDBY    VARCHAR(25),                      
  VDT          DATETIME   NULL,                      
  EDT          DATETIME   NULL,                      
  DDDT         DATETIME   NULL,                      
  ACC_NO       VARCHAR(16),               
  VTYP         SMALLINT   NULL,                       
  VOUCHERNO    VARCHAR(12)   NULL,                    
  SRNO    INT              
 )  ON [PRIMARY]                      
              
 CREATE TABLE #BANK_VNO                        
 (                        
  VOUCHERNO VARCHAR(12),                    
  SNO INT,              
  EXCHANGE VARCHAR(3),              
  SEGMENT VARCHAR(20),              
  NEWSRNO INT IDENTITY(1,1)              
 )               
               
--BEGIN TRAN              
 INSERT INTO #TEMP              
 SELECT               
  SNO = O.SNO,              
  EDATE = CONVERT(VARCHAR,EDATE,103),               
  VDATE = CONVERT(VARCHAR,VDATE,103),                  
  CLTCODE = O.CLTCODE,                  
  AMOUNT = CONVERT(VARCHAR,CASE WHEN CC.CREDITAMT IS NULL THEN CASE WHEN O.CREDITAMT = '' THEN O.DEBITAMT ELSE O.CREDITAMT END ELSE CASE WHEN CC.CREDITAMT = '' THEN CC.DEBITAMT ELSE CC.CREDITAMT END END) ,                  
  DRCR = CONVERT(VARCHAR,CASE WHEN CC.CREDITAMT IS NULL THEN CASE WHEN O.CREDITAMT = '' THEN 'D' ELSE 'C' END ELSE CASE WHEN CC.CREDITAMT = '' THEN 'D' ELSE 'C' END END),                  
  NARRATION,                  
  OPPCODE,                  
  OPPCODENAME,                  
  DDNO,                  
  COSTCODE = CASE WHEN O.BRANCHCODE <> '' THEN O.BRANCHCODE ELSE CONVERT(VARCHAR,CASE WHEN CC.COSTCODE IS NOT NULL THEN CC.COSTCODE ELSE 'ALL' END) END,                  
  --  COSTCODE = O.BRANCHCODE,       
  'ALL',                  
  CHEQUEMODE,                  
  CHEQUEDATE = CONVERT(VARCHAR,CHEQUEDATE,103),                  
  CHEQUENAME,                  
  CLEAR_MODE,                  
  FLDAUTO = CONVERT(VARCHAR,O.FLDAUTO),                   
  ADDBY = O.ADDBY,                  
  VDATE = CONVERT(VARCHAR,VDATE),                  
  EDATE = CONVERT(VARCHAR,EDATE),                  
  CHEQUEDATE,                    TPACCOUNTNUMBER, CONVERT(VARCHAR,VOUCHERTYPE),VOUCHERNO,SRNO = 1                  
 FROM                
  V2_OFFLINE_LEDGER_ENTRIES O WITH(NOLOCK)                  
  LEFT OUTER JOIN V2_OFFLINE_CC_ENTRIES CC                  
  ON O.FLDAUTO = CC.VOLE_REFNO                  
 WHERE                
  CONVERT(VARCHAR,VOUCHERTYPE) = @VTYP              
  AND EXCHANGE = @EXCHANGE              
  AND SEGMENT = @SEGMENT              
  AND CONVERT(VARCHAR,ISNULL(ROWSTATE,0)) = '0'           
  AND CONVERT(VARCHAR,VDATE) LIKE @IP_VDATE + '%'                  
  AND CONVERT(VARCHAR,APPROVALFLAG) = '1'               
        
      
 UPDATE               
  O               
 SET               
  ROWSTATE = 9              
 FROM          
  V2_OFFLINE_LEDGER_ENTRIES O WITH(NOLOCK),                  
  #TEMP T              
 WHERE              
  O.FLDAUTO = T.FLD_AUTO              
               
 INSERT INTO               
  #BANK_VNO              
 SELECT               
  DISTINCT O.VOUCHERNO,O.SNO,@EXCHANGE, @SEGMENT              
 FROM                
  V2_OFFLINE_LEDGER_ENTRIES O WITH(NOLOCK),                  
  #TEMP T              
    WHERE               
  O.FLDAUTO = T.FLD_AUTO              
 ORDER BY               
  O.VOUCHERNO, O.SNO              
              
 INSERT INTO               
  BANK_VNO              
 SELECT               
  VOUCHERNO,SNO, @EXCHANGE, @SEGMENT, NEWSRNO              
 FROM               
  #BANK_VNO              
              
--COMMIT TRAN              
              
SELECT * FROM #TEMP              
DROP TABLE #TEMP              
DROP TABLE #BANK_VNO

GO
