-- Object: PROCEDURE dbo.VIRTUAL_MIS_LEDGER_CONVERTER_BKP_20220509
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/*        BEGIN TRAN                                        
    
    
    
EXEC VIRTUAL_MIS_LEDGER_CONVERTER 'D:\TEMP\20220114\141955278.CSV', 'SURESH'                                              
VIRTUAL_MIS_LEDGER_CONVERTER 'D:\BACKOFFICE\68118569.11122015.3A..CSV','SURESH'                                               
SELECT * FROM VIRTUAL_MIS_LEDGER_REPORT                 
    
ROLLBACK                                             
    
    
    
*/     
CREATE  PROCEDURE [dbo].[VIRTUAL_MIS_LEDGER_CONVERTER_BKP_20220509] @FILENAME VARCHAR(1000),     
                                                     @UNAME    VARCHAR(50)     
														WITH RECOMPILE
AS     

set xact_abort on 

    TRUNCATE TABLE VIRTUAL_MIS_LEDGER     
    
    CREATE TABLE #VIRTUAL_MIS_LEDGER     
      (     
         FILE_DATA VARCHAR(MAX),     
         SRNO      INT IDENTITY(1, 1)     
      )     
    
    --INSERT INTO #VIRTUAL_MIS_LEDGER  EXEC MASTER.DBO.XP_CMDSHELL 'TYPE D:\BACKOFFICE\VIRTUAL_BANK_FORMAT.CSV'                                              
DECLARE                                    
 @@SQL VARCHAR(MAX),  
  @@MYTEMPVNO AS VARCHAR(12)                                       
                                     
SET @@SQL = "INSERT INTO #VIRTUAL_MIS_LEDGER "                                    
SET @@SQL = @@SQL + " EXEC MASTER.DBO.XP_CMDSHELL 'TYPE " + @FILENAME + "'"                                    
                                    
--RETURN                                
--PRINT @@SQL   
    
    --RETURN                                           
    --PRINT @@SQL                                               
    EXEC(@@SQL)  
	

	DELETE FROM #VIRTUAL_MIS_LEDGER     
  WHERE  ISNULL(FILE_DATA, '') = '' 
	  
	
  DELETE FROM #VIRTUAL_MIS_LEDGER     
  WHERE  SRNO <= 6     
    
       

	UPDATE #VIRTUAL_MIS_LEDGER     
    SET    FILE_DATA = LEFT(FILE_DATA, CHARINDEX('"', FILE_DATA))     
                       + REPLACE(SUBSTRING(FILE_DATA, CHARINDEX('"', FILE_DATA),     
                       CHARINDEX(     
                              '"', FILE_DATA, CHARINDEX('"', FILE_DATA) + 1)     
                       - CHARINDEX(     
                              '"', FILE_DATA)), ',', '')     
                       + RIGHT(FILE_DATA, LEN(FILE_DATA) - CHARINDEX('"',     
                       FILE_DATA,     
                              CHARINDEX('"', FILE_DATA) + 1))     
    
    UPDATE #VIRTUAL_MIS_LEDGER     
    SET    FILE_DATA = REPLACE(FILE_DATA, '"', '')  
	  
    
    INSERT INTO VIRTUAL_MIS_LEDGER     
    SELECT CONVERT(DATETIME, .DBO.PIECE(FILE_DATA, ',', 1), 103),     
           .DBO.PIECE(FILE_DATA, ',', 2),     
           .DBO.PIECE(FILE_DATA, ',', 3),     
           .DBO.PIECE(FILE_DATA, ',', 4),     
           .DBO.PIECE(FILE_DATA, ',', 5),     
           .DBO.PIECE(FILE_DATA, ',', 6),     
           .DBO.PIECE(FILE_DATA, ',', 7),     
           .DBO.PIECE(FILE_DATA, ',', 8),     
           .DBO.PIECE(FILE_DATA, ',', 9),     
           .DBO.PIECE(FILE_DATA, ',', 10),     
           .DBO.PIECE(FILE_DATA, ',', 11),     
           .DBO.PIECE(FILE_DATA, ',', 12),     
           .DBO.PIECE(FILE_DATA, ',', 13),     
           .DBO.PIECE(FILE_DATA, ',', 14),     
           .DBO.PIECE(FILE_DATA, ',', 15),     
           .DBO.PIECE(FILE_DATA, ',', 16),     
           .DBO.PIECE(FILE_DATA, ',', 17),     
           .DBO.PIECE(FILE_DATA, ',', 18),     
           .DBO.PIECE(FILE_DATA, ',', 19),     
           .DBO.PIECE(FILE_DATA, ',', 20),     
           .DBO.PIECE(FILE_DATA, ',', 21)     
    FROM   #VIRTUAL_MIS_LEDGER 
     
    CREATE TABLE #VIRTUAL_MIS     
      (     
         SRNO        INT IDENTITY(1, 1),     
         EDATE       datetime,     
         VDATE       datetime,     
         CLTCODE     VARCHAR(10),     
         AMOUNT      MONEY,     
         DRCR        CHAR(1),     
         NARRATION   VARCHAR(500),     
         BANK_CODE   VARCHAR(10),     
         BANK_NAME   VARCHAR(100),     
         REF_NO      VARCHAR(100),     
         BRANCHCODE  VARCHAR(10),     
         BRANCH_NAME VARCHAR(100),     
         CHQ_MODE    VARCHAR(5),     
         CHQ_DATE     datetime,     
         CHQ_NAME    VARCHAR(100),     
         CL_MODE     CHAR(1),     
         ACCOUNTNO   VARCHAR(50),     
         EXCHANGE    VARCHAR(10),     
         SEGMENT     VARCHAR(10)     
      )     
    
    /*CREATE TABLE VIRTUAL_MIS_FILE                                     
        
    (                   
     SRNO INT IDENTITY(1, 1),                                      
     EDATE VARCHAR(10),                                               
     VDATE VARCHAR(10),                                               
     CLTCODE VARCHAR(10),                                               
     AMOUNT MONEY,                                               
     DRCR CHAR(1),                                               
     NARRATION VARCHAR(500),                                 
     BANK_CODE VARCHAR(10),                                               
     BANK_NAME VARCHAR(100),                                               
     REF_NO VARCHAR(20),                                               
     BRANCHCODE VARCHAR(10),                                               
     BRANCH_NAME VARCHAR(100),                                               
     CHQ_MODE VARCHAR(5),                                               
     CHQ_DATE VARCHAR(10),                                               
     CHQ_NAME VARCHAR(100),                                               
     CL_MODE CHAR(1),                                               
     ACCOUNTNO VARCHAR(20),                                               
     SEGMENT VARCHAR(10)                                               
    )                                            
         
         
    CREATE TABLE VIRTUAL_MIS_FILE_GEN                                     
    (                             
     SRNO VARCHAR(10),                                      
     EDATE VARCHAR(10),                                               
     VDATE VARCHAR(10),                                               
     CLTCODE VARCHAR(10),               
     AMOUNT VARCHAR(15),                                               
     DRCR VARCHAR(10),                                               
     NARRATION VARCHAR(500),                                               
     BANK_CODE VARCHAR(10),                                               
     BANK_NAME VARCHAR(100),                                               
     REF_NO VARCHAR(20),                                               
     BRANCHCODE VARCHAR(10),                                               
     BRANCH_NAME VARCHAR(100),              
     CHQ_MODE VARCHAR(5),                                               
     CHQ_DATE VARCHAR(10),                                               
     CHQ_NAME VARCHAR(100),                                               
     CL_MODE VARCHAR(10),                                               
     ACCOUNTNO VARCHAR(20),                                               
      EXCHANGE ,             
     SEGMENT                                                   
    )                  
         
         
    --SELECT  REPLACE(TRANSACTION_DETAILS7,' ' ,''),                  
         
         
         
    -- PATINDEX('%[A-Z]%',TRANSACTION_DETAILS7),                  
         
         
         
    -- CASE WHEN PATINDEX('%[A-Z]%',REPLACE(TRANSACTION_DETAILS7,' ' ,'')) =0 THEN                  
         
         
         
    -- REPLACE(TRANSACTION_DETAILS7,' ' ,'') ELSE                  
         
         
         
    -- LEFT(REPLACE(TRANSACTION_DETAILS7,' ' ,''), PATINDEX('%[A-Z]%',REPLACE(TRANSACTION_DETAILS7,' ' ,'')) - 1)                  
         
         
         
    --   END                                        
         
          ---*/    
		  

    
    
 INSERT INTO #VIRTUAL_MIS     
    SELECT   
   
 CONVERT(datetime, BUSINESS_DATE),     
           CONVERT(datetime, BUSINESS_DATE),     
           RIGHT(VA_NUMBER, LEN(VA_NUMBER) - 7),     
			TRANSACTION_AMOUNT,     
           'C',     
           'VIRTUAL ' + TRANSACTION_DETAILS1,     
           '02093',     
           'SCB',     
           --.DBO.PIECE(TRANSACTION_DETAILS1, '|', 1),                                     
         --  .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1),     
       CASE WHEN LEFT(TRANSACTION_DETAILS1,5)='IMPS/' THEN .DBO.PIECE(TRANSACTION_DETAILS1, '/', 3)  
        WHEN LEFT(TRANSACTION_DETAILS1,5)='IMPS|' THEN .DBO.PIECE(TRANSACTION_DETAILS1, '|', 3)
		WHEN LEFT(TRANSACTION_DETAILS1,4)='UPI/' THEN .DBO.PIECE(TRANSACTION_DETAILS1, '/', 2)  
     ELSE .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1)END  ,                                    
           'HO',     
           'ALL',     
           'C',     
           CONVERT(datetime, BUSINESS_DATE, 103),     
           '',     
           'L',     
           CASE     
             WHEN PATINDEX('%[A-Z]%', REPLACE(TRANSACTION_DETAILS7, ' ', '')) =     
                  0     
           THEN     
             REPLACE(TRANSACTION_DETAILS7, ' ', '')     
             ELSE LEFT(REPLACE(TRANSACTION_DETAILS7, ' ', ''),     
                         PATINDEX('%[A-Z]%', REPLACE(TRANSACTION_DETAILS7, ' ',     
                                             ''))     
                         - 1)     
           END,     
           --LEFT(REPLACE(TRANSACTION_DETAILS7,' ' ,''), PATINDEX('%[A-Z]%',REPLACE(TRANSACTION_DETAILS7,' ' ,'')) - 1),                                               
           EXCHANGE='NSE',     
           SEGMENT='CAPITAL'     
    FROM   VIRTUAL_MIS_LEDGER VL WITH(NOLOCK),     
           VIRTUAL_MIS_SEGMENT_MAPPING SM   WITH(NOLOCK)  
    WHERE     
      --NOT EXISTS(SELECT PARTY_CODE FROM VIRTUAL_MIS_LEDGER_REPORT VT WHERE BUSINESS_DATE = TXN_DATE AND RIGHT(VA_NUMBER, LEN(VA_NUMBER) - 7) = PARTY_CODE AND .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1) = BANK_REF_NO)                                        
 
      --AND EXISTS(SELECT PARTY_CODE FROM MSAJAG.DBO.CLIENT_DETAILS D WHERE D.PARTY_CODE = RIGHT(VA_NUMBER, LEN(VA_NUMBER) - 7))                                              
      -- NOT EXISTS(SELECT TXN_REF_NO FROM VIRTUAL_MIS_LEDGER_REPORT WHERE .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1)=TXN_REF_NO )                        
      NOT EXISTS(SELECT TXN_REF_NO     
                 FROM   VIRTUAL_MIS_LEDGER_REPORT   WITH(NOLOCK)  
                 WHERE   
    --.DBO.PIECE(TRANSACTION_DETAILS1, '|' , 1) = TXN_REF_NO)  
     --.DBO.PIECE(TRANSACTION_DETAILS1, '/', 3) = TXN_REF_NO )  
     (.DBO.PIECE(TRANSACTION_DETAILS1, '|' , 1) = TXN_REF_NO or .DBO.PIECE(TRANSACTION_DETAILS1, '/', 3) = TXN_REF_NO or .DBO.PIECE(TRANSACTION_DETAILS1, '|', 3) = TXN_REF_NO ) or .DBO.PIECE(TRANSACTION_DETAILS1, '/', 2) = TXN_REF_NO)     
      and  LEFT(VL.VA_NUMBER, 7) = SEGCODE   
  -- AND RIGHT(VA_NUMBER, LEN(VA_NUMBER) - 7)='k52350'  
  
   /*  ADDED FOR DUPLICATION  REMOVAL */ 
  DELETE FROM #VIRTUAL_MIS  WHERE EXISTS  (
  SELECT DDNO,CLTCODE FROM anand.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES V  WITH(NOLOCK) WHERE VDATE >=CONVERT(VARCHAR(11),GETDATE()-10,120)
  AND DDNO=REF_NO AND #VIRTUAL_MIS.CLTCODE= V.CLTCODE)
  
  --DELETE FROM VIRTUAL_MIS_LEDGER  WHERE EXISTS  (
  --SELECT DDNO,CLTCODE FROM anand.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES V WHERE VDATE >=CONVERT(VARCHAR(11),GETDATE()-10,120)
  --AND DDNO=REF_NO AND #VIRTUAL_MIS.CLTCODE= V.CLTCODE)
   
   /*  ADDED FOR DUPLICATION REMOVAL END */ 
    
    
    UPDATE #VIRTUAL_MIS     
    SET  ACCOUNTNO = case when ltrim(rtrim(substring(narration,8,5)))='IMPS' then .DBO.piece(ACCOUNTNO, '|', 1) else   RTRIM(LTRIM(REPLACE(ACCOUNTNO, '|', ''))) end   
   
    UPDATE #VIRTUAL_MIS     
    SET    ACCOUNTNO = RTRIM(LTRIM(REPLACE(ACCOUNTNO, '/', '')))   
      
    UPDATE #VIRTUAL_MIS  set ACCOUNTNO=substring(ACCOUNTNO , patindex('%[^0]%',ACCOUNTNO),20)     
    
    --UPDATE #VIRTUAL_MIS SET REF_NO=SUBSTRING(REF_NO,3,18)       
      
     --CHANGES BY SIVA  
     --- Below Code commented as on 24 Jan 2022
     --SELECT * INTO #BANKALLSEGMENT FROM BANKALLSEGMENT WHERE CLTCODE IN   
     --(SELECT CLTCODE FROM #VIRTUAL_MIS)  
     ----- 
     ---------- Added Below Code on 24 Jan 2022
   SELECT A.* INTO #BANKALLSEGMENT FROM Msajag.dbo.tbl_Party_Bank_Details_New A ---Msajag.dbo.Party_Bank_Details  A WITH(NOLOCK)   Replaced from New Bank Tables. 
                 INNER JOIN #VIRTUAL_MIS B ON A.Party_Code=B.CLTCODE
  ---------------- END 
         
          
    UPDATE #VIRTUAL_MIS     
    SET    BANK_NAME = ( CASE     
                           WHEN B.AcNum = '' THEN 'SCB'     
                           ELSE B.BankName     
                         END )     
    --CHQ_NAME = (CASE WHEN B.ACCNO= '' THEN 'SCB' ELSE B.BANK_NAME END)                                      
    FROM   #BANKALLSEGMENT B     
    WHERE  B.Party_Code = #VIRTUAL_MIS.CLTCODE     
           AND right(substring(B.AcNum, patindex('%[^0]%',B.AcNum),20) ,5)   =  Right(REPLACE(#VIRTUAL_MIS.ACCOUNTNO  ,'-','') ,5)  
         --  AND B.SEGMENT = #VIRTUAL_MIS.EXCHANGE     
    
    UPDATE #VIRTUAL_MIS    SET    CHQ_NAME = BANK_NAME     
      
      
    SET @@MYTEMPVNO = CONVERT(VARCHAR, GETDATE(), 12)     
                 + RIGHT(REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', '')     
                      , 6)     
    
    
    
    -- SELECT TOP 3 *FROM ANAND.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES             
    --WHERE VDATE LIKE '%DEC  7 2015%'             
    --AND VOUCHERTYPE=2             
    --AND EXCHANGE='BSE'        
    SELECT VoucherType,BookType,SNo,Vdate,EDate,CltCode,CreditAmt,DebitAmt,  
    Narration,OppCode,MarginCode,BankName,BranchName,BranchCode,DDNo,ChequeMode,  
    ChequeDate,ChequeName,Clear_Mode,TPAccountNumber,Exchange,Segment,TPFlag,AddDt,  
    AddBy,StatusID,StatusName,RowState,ApprovalFlag,ApprovalDate,ApprovedBy,VoucherNo,  
    UploadDt,LedgerVNO,ClientName,OppCodeName,MarginCodeName,Sett_No,Sett_Type,ProductType,  
    RevAmt,RevCode,MICR     
    INTO   #VIRTUAL_MIS1     
    FROM   ANAND.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES     
    WHERE  1 = 2     
        
    
   INSERT INTO #VIRTUAL_MIS1     
    SELECT VOUCHERTYPE=CONVERT(VARCHAR(2), '2'),     
           BOOKTYPE='01',     
           SRNO,     
          -- VDATE=CONVERT(DATETIME, VDATE),     
          -- EDATE=CONVERT(DATETIME, EDATE),     
      VDATE,     
           EDATE,     
           rtrim(ltrim(CLTCODE)) CLTCODE,     
           CREDITAMT=AMOUNT,     
           DEBITAMT= CONVERT(MONEY, '0'),     
           NARRATION=CONVERT(VARCHAR(255), NARRATION),     
           BANK_CODE,     
           MARGINCODE=CONVERT(VARCHAR(10), ''),     
           BANK_NAME,     
           BRANCHNAME=CONVERT(VARCHAR(100), 'ALL'),     
           BRANCHCODE,     
           REF_NO=CONVERT(VARCHAR(20), REF_NO),  /* Ref No increase from 15 to 20 as per confimration from Sanjeevan*/    
           CHEQUEMODE='C',     
        --   CHQ_DATE=CONVERT(DATETIME, CHQ_DATE),     
      CHQ_DATE,     
           CHQ_NAME,     
           CLEAR_CODE='O',     
           ACCOUNTNO=CONVERT(VARCHAR(20), ACCOUNTNO),     
           EXCHANGE=CONVERT(VARCHAR(3), EXCHANGE),     
           SEGMENT,     
           TPFLAG=CASE     
                    WHEN BANK_NAME = 'SCB' THEN 1     
                    ELSE 0     
                  END,     
           ADDDT=GETDATE(),     
           ADDBY='VIRTUAL',     
           STATUSID='BROKER',     
           STATUSNAME='BROKER',     
           ROWSTATE=0,     
    /** Changes done by Siva As per user request.**/  
           APPROVALFLAG=  CASE     
                           WHEN BANK_NAME = 'SCB' THEN 0     
                          ELSE 1     
                         END,     
   --  APPROVALFLAG =1,  
           APPROVALDATE=GETDATE(),     
           APPROVEDBY='VIRTUAL',     
           VOUCHERNO = @@MYTEMPVNO,     
           UPLOADDT=GETDATE(),     
           LEDGERVNO=CONVERT(VARCHAR(12), ''),     
           CLIENTNAME =CONVERT(VARCHAR(50), ''),     
           OPPCODENAME='',     
           MARGINCODENAME='',     
           SETT_NO='',     
           SETT_TYPE='',     
           PRODUCTTYPE='',     
           REVAMT='',     
           REVCODE='',     
           MICR=''     
    FROM   #VIRTUAL_MIS     
        
    UPDATE #VIRTUAL_MIS1 set CLTCODE='5100000018'
	where CLTCODE NOT IN 
	(SELECT CL_CODE FROM MSAJAG.DBO.CLIENT5)
   
    
    UPDATE #VIRTUAL_MIS1     
    SET    CLIENTNAME = ACMAST.LONGNAME     
    FROM   ACMAST     
    WHERE  #VIRTUAL_MIS1.CLTCODE = ACMAST.CLTCODE 

	
	
	
        
    --UPDATE #VIRTUAL_MIS1 SET CLTCODE='5100000018' WHERE TPFLAG=1    
  
  
   INSERT INTO anand.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES (  
    VoucherType,BookType,SNo,Vdate,EDate,CltCode,CreditAmt,DebitAmt,  
    Narration,OppCode,MarginCode,BankName,BranchName,BranchCode,DDNo,ChequeMode,  
    ChequeDate,ChequeName,Clear_Mode,TPAccountNumber,Exchange,Segment,TPFlag,AddDt,  
    AddBy,StatusID,StatusName,RowState,ApprovalFlag,ApprovalDate,ApprovedBy,VoucherNo,  
    UploadDt,LedgerVNO,ClientName,OppCodeName,MarginCodeName,Sett_No,Sett_Type,ProductType,  
    RevAmt,RevCode,MICR )   
    SELECT VOUCHERTYPE,     
           BOOKTYPE,     
           SNO,     
           VDATE,     
           EDATE,     
           CLTCODE = CASE  
                         WHEN  TPFLAG = 1 THEN '5100000018'   
                         ELSE CLTCODE  
                         END,     
           CREDITAMT,     
           DEBITAMT,     
           NARRATION,     
           OPPCODE,     
           MARGINCODE,     
           BANKNAME,     
           BRANCHNAME,     
           BRANCHCODE,     
           DDNO,     
           CHEQUEMODE,     
           CHEQUEDATE,     
           CHEQUENAME,     
           CLEAR_MODE,     
           TPACCOUNTNUMBER,     
           EXCHANGE,     
           SEGMENT,     
           TPFLAG,     
           ADDDT,     
           ADDBY,     
           STATUSID,     
           STATUSNAME,     
           ROWSTATE,     
           APPROVALFLAG,     
           APPROVALDATE,     
           APPROVEDBY,     
           VOUCHERNO,     
           UPLOADDT,     
           LEDGERVNO,     
           CLIENTNAME,     
           OPPCODENAME,     
           MARGINCODENAME,     
           SETT_NO,     
           SETT_TYPE,     
           PRODUCTTYPE,     
           REVAMT,     
           REVCODE,     
           MICR     
    FROM   #VIRTUAL_MIS1     
  
      
   
   
    
    /*** CHANGES DONE BY SURESH FOR DIRECT POSTING---------------------TO SAVE THE FILE DIRECTLY TO THE RESPECTIVE DATABASE SERVERS-----------                                     
         
              
    DECLARE @@MAINREC AS CURSOR                                     
    DECLARE                                     
     @@SEGMENT VARCHAR(20),                                     
     @@DATASERVER VARCHAR(50),                                     
     @@ACCOUNTDB VARCHAR(50),                                     
     @@SQLQRY VARCHAR(8000),                                     
     @@FNAME VARCHAR(500),                                     
     @@REC_COUNT INT,                                     
   @@FILE_SEGMENT VARCHAR(500)                                   
         
     SET @@FILE_SEGMENT = ''                                     
    SET @@MAINREC = CURSOR FOR                                             
      
         SELECT SEGMENT, ACCOUNTDB, DATASERVER FROM VIRTUAL_MIS_SEGMENT_MAPPING                                    
         
    OPEN @@MAINREC                                             
         
     FETCH NEXT FROM @@MAINREC INTO @@SEGMENT, @@ACCOUNTDB, @@DATASERVER                                    
      WHILE @@FETCH_STATUS = 0                                   
         
      BEGIN                                            
      TRUNCATE TABLE VIRTUAL_MIS_FILE                               
      TRUNCATE TABLE VIRTUAL_MIS_FILE_GEN                                
         
         
     INSERT INTO VIRTUAL_MIS_FILE                                      
     SELECT EDATE,VDATE,CLTCODE,AMOUNT,DRCR,NARRATION,BANK_CODE,BANK_NAME,REF_NO,BRANCHCODE,              
     BRANCH_NAME,CHQ_MODE,CHQ_DATE,CHQ_NAME,CL_MODE,ACCOUNTNO,SEGMENT FROM #VIRTUAL_MIS WHERE SEGMENT = @@SEGMENT                              
        
     SET  @@SQLQRY = " INSERT INTO VIRTUAL_MIS_FILE_GEN SELECT * FROM VIRTUAL_MIS_FILE "                              
     EXEC(@@SQLQRY)                     
         
     SELECT @@REC_COUNT = COUNT(1) FROM VIRTUAL_MIS_FILE_GEN                                    
         
     SET  @@SQLQRY = " SELECT CONVERT(VARCHAR, SRNO), EDATE, VDATE, CLTCODE, CONVERT(VARCHAR, AMOUNT), DRCR, NARRATION, BANK_CODE, BANK_NAME,REF_NO, BRANCHCODE, BRANCH_NAME, CHQ_MODE, CHQ_DATE, CHQ_NAME, CL_MODE, ACCOUNTNO FROM ANAND1.ACCOUNT.DBO.VIRTUAL_
  
  
MIS_FILE_GEN "                                     
         
      --  EXEC(@@SQLQRY)                                     
       
     SET @@FNAME = "D:\BACKOFFICE\RECPAYFILES\" + 'VIRTUAL_' + @@SEGMENT + '_' + CONVERT(VARCHAR(20),GETDATE(), 112) + REPLACE(CONVERT(VARCHAR(20),GETDATE(), 108), ':', '') +  ".CSV"                                    
       
      IF @@REC_COUNT > 0                                     
        BEGIN                                     
      SELECT @@FILE_SEGMENT = @@FILE_SEGMENT + @@SEGMENT + ","           
           
          PRINT @@FILE_SEGMENT                                            
         
      SELECT @@SQL = "EXEC " + @@DATASERVER + "." + @@ACCOUNTDB + ".DBO.VIRTUAL_MIS_FILEGEN '" + @@SQLQRY + "','" + @@DATASERVER + "','" + @@FNAME + "'"              
        --SELECT @@SQL = "DECLARE @@ERR AS INT EXEC @@ERR = MASTER.DBO.XP_CMDSHELL 'BCP " + CHAR(34) + @@SQLQRY + " " + CHAR(34) + " QUERYOUT " + CHAR(34) + @@FNAME + CHAR(34) + " -C -Q -T " + CHAR(34) + "," + CHAR(34) + " -T -S "+ CHAR(34) + CHAR(34) + 
  
@  
@DATASERVER + CHAR(34) + "'"                                     
         
      EXEC (@@SQL)                 
         
      PRINT @@SQL                                     
         
     END                                     
         
     FETCH NEXT FROM @@MAINREC INTO @@SEGMENT, @@ACCOUNTDB, @@DATASERVER               
      END                                     
         
    SELECT 'FILES GENERATED FOR ' + @@FILE_SEGMENT + 'SEGMENTS.'                      
         
    DROP TABLE VIRTUAL_MIS_FILE_GEN                
         
    DROP TABLE VIRTUAL_MIS_FILE                              
         
     ---CHANGES DONE BY SURESH FOR DIRECT POSTING-- --------------------------------------------------------------------------------------                                  */     
       
   INSERT INTO VIRTUAL_MIS_LEDGER_REPORT     
    SELECT BRANCH_CD,     
           SUB_BROKER,     
           PARTY_CODE,     
           LONG_NAME,     
           EXCHANGE,     
           TRANSACTION_AMOUNT,     
           BUSINESS_DATE,     
           '',     
           -- LEFT(TRANSACTION_DETAILS7, PATINDEX('%[A-Z]%',TRANSACTION_DETAILS7) - 1),     
                   
        CASE     
             WHEN PATINDEX('%[A-Z]%', REPLACE(TRANSACTION_DETAILS7, ' ', '')) =     
      0     
           THEN     
             REPLACE(TRANSACTION_DETAILS7, ' ', '')     
             ELSE LEFT(REPLACE(TRANSACTION_DETAILS7, ' ', ''),     
                         PATINDEX('%[A-Z]%', REPLACE(TRANSACTION_DETAILS7, ' ',     
                                             ''))     
                         - 1)     
           END,     
          --.DBO.PIECE(TRANSACTION_DETAILS1, '|', 1),     
    case when left(TRANSACTION_DETAILS1,5)='imps/' then .DBO.piece(TRANSACTION_DETAILS1, '/', 3)  
        when left(TRANSACTION_DETAILS1,5)='imps|' then .DBO.piece(TRANSACTION_DETAILS1, '|', 3)  
     else .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1)end  ,  
           'SCB -VIRTUAL',     
           TRANSACTION_DETAILS7,     
           @UNAME,     
           GETDATE()     
    FROM   VIRTUAL_MIS_LEDGER VL WITH(NOLOCK),     
           VIRTUAL_MIS_SEGMENT_MAPPING SM WITH(NOLOCK),     
           MSAJAG.DBO.CLIENT_DETAILS   WITH(NOLOCK)  
    WHERE     
      --.DBO.PIECE(TRANSACTION_DETAILS1, '|', 1) NOT IN (SELECT TXN_REF_NO FROM VIRTUAL_MIS_LEDGER_REPORT)                      
NOT EXISTS(SELECT TXN_REF_NO       
                 FROM   VIRTUAL_MIS_LEDGER_REPORT   WITH(NOLOCK)    
                 WHERE     
    --.DBO.PIECE(TRANSACTION_DETAILS1, '|' , 1) = TXN_REF_NO)    
     --.DBO.PIECE(TRANSACTION_DETAILS1, '/', 3) = TXN_REF_NO )    
     (.DBO.PIECE(TRANSACTION_DETAILS1, '|' , 1) = TXN_REF_NO     
     or .DBO.PIECE(TRANSACTION_DETAILS1, '/', 3) = TXN_REF_NO     
     or .DBO.PIECE(TRANSACTION_DETAILS1, '|', 3) = TXN_REF_NO )
	 or .DBO.PIECE(TRANSACTION_DETAILS1, '/', 2) = TXN_REF_NO)   
     -- .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1) NOT IN (SELECT   TXN_REF_NO     
                                                                           -- FROM     
    --  VIRTUAL_MIS_LEDGER_REPORT)     
      AND LEFT(VL.VA_NUMBER, 7) = SEGCODE     
      AND rtrim(ltrim(RIGHT(VA_NUMBER, LEN(VA_NUMBER) - 7))) = PARTY_CODE   
  
    
  
        
UPDATE M SET SOURCE_BANK_ACNO=1   
from  #VIRTUAL_MIS1 V ,VIRTUAL_MIS_LEDGER_REPORT M  
WHERE V.CLTCODE=M.PARTY_CODE  
AND V.TPFLAG = 1   
  
DROP TABLE #VIRTUAL_MIS  
 DROP TABLE #VIRTUAL_MIS1   
  DROP TABLE #BANKALLSEGMENT  
IF @UNAME <> 'AUTO'     
BEGIN    
 SELECT 'RECORDS UPDATED SUCCESSFULLY'        
END     
  
--set xact_abort off

GO
