-- Object: PROCEDURE dbo.VIRTUAL_MIS_LEDGER_CONVERTER_BKP_20230325
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE  PROCEDURE [dbo].[VIRTUAL_MIS_LEDGER_CONVERTER_BKP_20230325] 
(
@FILENAME VARCHAR(1000),     
@UNAME    VARCHAR(50)
)

WITH RECOMPILE
AS     

--DECLARE
--@FILENAME VARCHAR(1000),     
--@UNAME    VARCHAR(50)
--SET @FILENAME ='J:\BackOffice\ANGLIN01RPT_154073611663577969517.csv'
--SET @UNAME ='e75427'
set xact_abort on 
    TRUNCATE TABLE VIRTUAL_MIS_LEDGER  
    truncate table tbl_VIRTUAL_MIS_LEDGER_bulk_upload  
  --IF OBJECT_ID('tempdb..#VIRTUAL_MIS_LEDGER') IS NOT NULL
  --  DROP TABLE #VIRTUAL_MIS_LEDGER
  --  CREATE TABLE #VIRTUAL_MIS_LEDGER     
  --    (     
  --       FILE_DATA VARCHAR(MAX),     
  --       SRNO      INT IDENTITY(1, 1)     
  --    )  
  
   --IF OBJECT_ID('tempdb..#VIRTUAL_MIS_LEDGER') IS NOT NULL
   -- DROP TABLE #VIRTUAL_MIS_LEDGER
 
    --CREATE TABLE tbl_VIRTUAL_MIS_LEDGER_bulk_upload     
    --  (     
    --     FILE_DATA VARCHAR(MAX),     
    --     SRNO      INT IDENTITY(1, 1)     
    --  )  
 
  DECLARE                                    
   @@SQL VARCHAR(MAX),  
    @@MYTEMPVNO AS VARCHAR(12)                                       
                                     
  SET @@SQL = "INSERT INTO tbl_VIRTUAL_MIS_LEDGER_bulk_upload "                                    
  SET @@SQL = @@SQL + " EXEC MASTER.DBO.XP_CMDSHELL 'TYPE " + @FILENAME + "'"                                    
  EXEC(@@SQL)  
	
  --DELETE FROM #VIRTUAL_MIS_LEDGER     
 -- WHERE  ISNULL(FILE_DATA, '') = '' 
	  
	
 -- DELETE FROM #VIRTUAL_MIS_LEDGER     
 -- WHERE  SRNO <= 2    ---- Replaced by 6 -- 20220624

 

	--UPDATE #VIRTUAL_MIS_LEDGER     
 --   SET    FILE_DATA = LEFT(FILE_DATA, CHARINDEX('"', FILE_DATA))     
 --                      + REPLACE(SUBSTRING(FILE_DATA, CHARINDEX('"', FILE_DATA),     
 --                      CHARINDEX(     
 --                             '"', FILE_DATA, CHARINDEX('"', FILE_DATA) + 1)     
 --                      - CHARINDEX(     
 --                             '"', FILE_DATA)), ',', '')     
 --                      + RIGHT(FILE_DATA, LEN(FILE_DATA) - CHARINDEX('"',     
 --                      FILE_DATA,     
 --                             CHARINDEX('"', FILE_DATA) + 1))     
    
 --   UPDATE #VIRTUAL_MIS_LEDGER     
 --   SET    FILE_DATA = REPLACE(FILE_DATA, '"', '')  
	 
    --INSERT INTO VIRTUAL_MIS_LEDGER     
    --SELECT CONVERT(DATETIME, .DBO.PIECE(FILE_DATA, ',', 1), 103),     
    --       .DBO.PIECE(FILE_DATA, ',', 2),     
    --       .DBO.PIECE(FILE_DATA, ',', 3),     
    --       .DBO.PIECE(FILE_DATA, ',', 4),     
    --       .DBO.PIECE(FILE_DATA, ',', 5),     
    --       .DBO.PIECE(FILE_DATA, ',', 6),     
    --       .DBO.PIECE(FILE_DATA, ',', 7),     
    --       .DBO.PIECE(FILE_DATA, ',', 8),     
    --       .DBO.PIECE(FILE_DATA, ',', 9),     
    --       .DBO.PIECE(FILE_DATA, ',', 10),     
    --       .DBO.PIECE(FILE_DATA, ',', 11),     
    --       .DBO.PIECE(FILE_DATA, ',', 12),     
    --       .DBO.PIECE(FILE_DATA, ',', 13),     
    --       .DBO.PIECE(FILE_DATA, ',', 14),     
    --       .DBO.PIECE(FILE_DATA, ',', 15),     
    --       .DBO.PIECE(FILE_DATA, ',', 16),     
    --       .DBO.PIECE(FILE_DATA, ',', 17),     
    --       .DBO.PIECE(FILE_DATA, ',', 18),     
    --       .DBO.PIECE(FILE_DATA, ',', 19),     
    --       .DBO.PIECE(FILE_DATA, ',', 20),     
    --       .DBO.PIECE(FILE_DATA, ',', 21)     
    --FROM   #VIRTUAL_MIS_LEDGER 
 
   
    DELETE FROM tbl_VIRTUAL_MIS_LEDGER_bulk_upload     
      WHERE  ISNULL(FILE_DATA, '') = '' 
		
  DELETE FROM tbl_VIRTUAL_MIS_LEDGER_bulk_upload     
  WHERE  SRNO <= 2

	UPDATE tbl_VIRTUAL_MIS_LEDGER_bulk_upload     
    SET    FILE_DATA = LEFT(FILE_DATA, CHARINDEX('"', FILE_DATA))     
                       + REPLACE(SUBSTRING(FILE_DATA, CHARINDEX('"', FILE_DATA),     
                       CHARINDEX(     
                              '"', FILE_DATA, CHARINDEX('"', FILE_DATA) + 1)     
                       - CHARINDEX(     
                              '"', FILE_DATA)), ',', '')     
                       + RIGHT(FILE_DATA, LEN(FILE_DATA) - CHARINDEX('"',     
                       FILE_DATA,     
                              CHARINDEX('"', FILE_DATA) + 1))     
    
    UPDATE tbl_VIRTUAL_MIS_LEDGER_bulk_upload     
    SET    FILE_DATA = REPLACE(FILE_DATA, '"', '')  

	    IF OBJECT_ID('tempdb..#VIRTUAL_MIS_LEDGER_tmp') IS NOT NULL
    DROP TABLE #VIRTUAL_MIS_LEDGER_tmp
    SELECT * INTO #VIRTUAL_MIS_LEDGER_tmp from VIRTUAL_MIS_LEDGER  WITH(NOLOCK)
    
    alter table #VIRTUAL_MIS_LEDGER_tmp
    alter column Business_Date VARCHAR(20)
  
  DELETE FROM   tbl_VIRTUAL_MIS_LEDGER_bulk_upload 
    where   (DBO.PIECE(FILE_DATA, ',', 4)='' OR  DBO.PIECE(FILE_DATA, ',', 4) IS NULL)
 
 INSERT INTO #VIRTUAL_MIS_LEDGER_tmp     
    SELECT .DBO.PIECE(FILE_DATA, ',', 1),     
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
    FROM   tbl_VIRTUAL_MIS_LEDGER_bulk_upload 
           WHERE ISNUMERIC(DBO.PIECE(FILE_DATA, ',', 4))=1

    DELETE from #VIRTUAL_MIS_LEDGER_tmp  where Business_Date =''
    DELETE from #VIRTUAL_MIS_LEDGER_tmp  WHERE VA_Number =''

    UPDATE  A
    SET Channel=''
    FROM #VIRTUAL_MIS_LEDGER_tmp A

    INSERT INTO VIRTUAL_MIS_LEDGER
    select 
    CONVERT(DATE,Business_Date,103),
    REPLACE(VA_Number,'á',''),Channel,Transaction_Amount,Transaction_Details1,Transaction_Details2,Transaction_Details3,Transaction_Details4,
    Transaction_Details5,Transaction_Details6,
	REPLACE(REPLACE(Transaction_Details7,'á','') ,',','')Transaction_Details7,
	REPLACE(REPLACE(REPLACE(REPLACE(Transaction_Details8,'á','') ,',',''),'-',''),'IN HSBC','') Transaction_Details8,Transaction_Details9,Transaction_Details10,
    Transaction_Details11,Transaction_Details12,Transaction_Details13,Transaction_Details14,Transaction_Details15,
    Transaction_Details16,Transaction_Details17
    from #VIRTUAL_MIS_LEDGER_tmp 
         WHERE Business_Date <>'00003'
   
--   select count(1) , Business_Date from #VIRTUAL_MIS_LEDGER_tmp
--   group by Business_Date

--   IF OBJECT_ID('tempdb..##CLIENTS_KEYWORD', 'U') IS NOT NULL
--      DROP TABLE ##CLIENTS_KEYWORD
--select DISTINCT CASE 
--  WHEN ISDATE(Business_Date) = 1 THEN ''
--  ELSE Business_Date
--END AS Business_Date  INTO ##CLIENTS_KEYWORD from #VIRTUAL_MIS_LEDGER_tmp -- WHERE ISDATE(CAST(Business_Date AS DATE)) =1

    --  ISDATE(CONVERT(DATE,Business_Date,103))=1
      --TRUNCATE TABLE tbl_VIRTUAL_MIS_LEDGER_NEW
      --insert into tbl_VIRTUAL_MIS_LEDGER_NEW
      --select * from VIRTUAL_MIS_LEDGER

  IF OBJECT_ID('tempdb..#VIRTUAL_MIS') IS NOT NULL
    DROP TABLE #VIRTUAL_MIS
    CREATE TABLE #VIRTUAL_MIS     
      (     
         SRNO        INT IDENTITY(1, 1),     
         EDATE       datetime,     
         VDATE       datetime,     
         CLTCODE     VARCHAR(10),     
         AMOUNT      MONEY,     
         DRCR         CHAR(1),     
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
     
	DECLARE @MXDT  DATE
	SELECT @MXDT =MAX(CONVERT(datetime, BUSINESS_DATE)) FROm VIRTUAL_MIS_LEDGER WITH(NOLOCK)  
			IF OBJECT_ID('tempdb..#VIRTUAL_MIS_LEDGER_REPORT_11') IS NOT NULL
			DROP TABLE #VIRTUAL_MIS_LEDGER_REPORT_11
		SELECT * INTO #VIRTUAL_MIS_LEDGER_REPORT_11 from VIRTUAL_MIS_LEDGER_REPORT   WITH(NOLOCK) 
		WHERE TXN_DATE  = @MXDT
		 CREATE INDEX IX_#VIRTUAL_MIS_LEDGER_REPORT_11 On #VIRTUAL_MIS_LEDGER_REPORT_11 (TXN_REF_NO) INCLUDE(TXN_DATE)
	
 INSERT INTO #VIRTUAL_MIS     
SELECT  DISTINCT 
 CONVERT(datetime, BUSINESS_DATE),     
           CONVERT(datetime, BUSINESS_DATE),     
           RIGHT(VA_NUMBER, LEN(REPLACE(VA_NUMBER,'á','')) - 7),     
			TRANSACTION_AMOUNT,     
           'C',     
           'VIRTUAL ' + TRANSACTION_DETAILS1 +'|'+ TRANSACTION_DETAILS7+'|'+ TRANSACTION_DETAILS8,     
           '02093',     
           'SCB',     
      --CASE WHEN LEFT(TRANSACTION_DETAILS1,5)='IMPS/' THEN .DBO.PIECE(TRANSACTION_DETAILS1, '/', 3)  
      --     WHEN LEFT(TRANSACTION_DETAILS1,5)='IMPS|' THEN .DBO.PIECE(TRANSACTION_DETAILS1, '|', 3)
      --     WHEN LEFT(TRANSACTION_DETAILS1,4)='UPI/' THEN .DBO.PIECE(TRANSACTION_DETAILS1, '/', 2)  
      --ELSE .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1)END  ,   
      CASE WHEN LEFT(TRANSACTION_DETAILS1,5) ='RTGS|' THEN REPLACE (TRANSACTION_DETAILS1,'RTGS|','')
           WHEN LEFT(TRANSACTION_DETAILS1,5) ='NEFT|' THEN REPLACE (TRANSACTION_DETAILS1,'NEFT|','')
           WHEN LEFT(TRANSACTION_DETAILS1,5) ='IMPS|' THEN SUBSTRING(TRANSACTION_DETAILS1,6,12)
           WHEN LEFT(TRANSACTION_DETAILS1,4)='UPI/' THEN .DBO.PIECE(TRANSACTION_DETAILS1, '/', 2)  
           ELSE .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1)END,
           'HO',     
           'ALL',     
           'C',     
           CONVERT(datetime, BUSINESS_DATE, 103),     
           '',     
           'L', 
           ------------- Start By Ahsan Farooqui 20220623
           --CASE     
           --  WHEN PATINDEX('%[A-Z]%', REPLACE(TRANSACTION_DETAILS7, ' ', '')) =     
           --       0     
           --THEN     
           --  REPLACE(TRANSACTION_DETAILS7, ' ', '')     
           --  ELSE LEFT(REPLACE(TRANSACTION_DETAILS7, ' ', ''),     
           --              PATINDEX('%[A-Z]%', REPLACE(TRANSACTION_DETAILS7, ' ',     
           --                                  ''))     
           --              - 1)     
           --END,   

            --CASE WHEN Channel ='' THEN TRANSACTION_DETAILS8  ELSE 
            --(

            -- CASE     
            --             WHEN PATINDEX('%[A-Z]%', REPLACE(TRANSACTION_DETAILS7, ' ', '')) =     
            --                  0     
            --           THEN     
            --             REPLACE(TRANSACTION_DETAILS7, ' ', '')     
            --             ELSE LEFT(REPLACE(TRANSACTION_DETAILS7, ' ', ''),     
            --                         PATINDEX('%[A-Z]%', REPLACE(TRANSACTION_DETAILS7, ' ',     
            --                                             ''))     
            --                         - 1)     
            --           END
            --  ) END ,
          
          CASE WHEN CHARINDEX('|',TRANSACTION_DETAILS8) >0 then left (TRANSACTION_DETAILS8 ,CHARINDEX('|',TRANSACTION_DETAILS8) -1  )
          ELSE TRANSACTION_DETAILS8 end ,

              ------------- END By Ahsan Farooqui 20220623
           --LEFT(REPLACE(TRANSACTION_DETAILS7,' ' ,''), PATINDEX('%[A-Z]%',REPLACE(TRANSACTION_DETAILS7,' ' ,'')) - 1),                                               
           EXCHANGE='NSE',     
           SEGMENT='CAPITAL'     
    FROM   VIRTUAL_MIS_LEDGER VL WITH(NOLOCK),     
           VIRTUAL_MIS_SEGMENT_MAPPING SM   WITH(NOLOCK)  

    WHERE     LEFT(VL.VA_NUMBER, 7) = SEGCODE

         AND NOT EXISTS(SELECT TXN_REF_NO     
                 FROM   #VIRTUAL_MIS_LEDGER_REPORT_11  A WITH(NOLOCK)  
                 WHERE   A.TXN_REF_NO =
                 ( CASE WHEN LEFT(TRANSACTION_DETAILS1,5) ='RTGS|' THEN REPLACE (TRANSACTION_DETAILS1,'RTGS|','')
           WHEN LEFT(TRANSACTION_DETAILS1,5) ='NEFT|' THEN REPLACE (TRANSACTION_DETAILS1,'NEFT|','')
           WHEN LEFT(TRANSACTION_DETAILS1,5) ='IMPS|' THEN SUBSTRING(TRANSACTION_DETAILS1,6,12)
           WHEN LEFT(TRANSACTION_DETAILS1,4)='UPI/' THEN .DBO.PIECE(TRANSACTION_DETAILS1, '/', 2)  
           ELSE .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1)END)
           )

         --  (.DBO.PIECE(TRANSACTION_DETAILS1, '|' , 1) = TXN_REF_NO or .DBO.PIECE(TRANSACTION_DETAILS1, '/', 3) = TXN_REF_NO or .DBO.PIECE(TRANSACTION_DETAILS1, '|', 3) = TXN_REF_NO ) or .DBO.PIECE(TRANSACTION_DETAILS1, '/', 2) = TXN_REF_NO)     
        --  and  LEFT(VL.VA_NUMBER, 7) = SEGCODE

/*This Code is commented By Ahsan Farooqui 2022-07-23*/
 -- SELECT   
 --CONVERT(datetime, BUSINESS_DATE),     
 --          CONVERT(datetime, BUSINESS_DATE),     
 --          RIGHT(VA_NUMBER, LEN(VA_NUMBER) - 7),     
	--		TRANSACTION_AMOUNT,     
 --          'C',     
 --          'VIRTUAL ' + TRANSACTION_DETAILS1,     
 --          '02093',     
 --          'SCB',     
 --    CASE WHEN LEFT(TRANSACTION_DETAILS1,5)='IMPS/' THEN .DBO.PIECE(TRANSACTION_DETAILS1, '/', 3)  
 --       WHEN LEFT(TRANSACTION_DETAILS1,5)='IMPS|' THEN .DBO.PIECE(TRANSACTION_DETAILS1, '|', 3)
	--	WHEN LEFT(TRANSACTION_DETAILS1,4)='UPI/' THEN .DBO.PIECE(TRANSACTION_DETAILS1, '/', 2)  
 --    ELSE .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1)END  ,                                    
 --          'HO',     
 --          'ALL',     
 --          'C',     
 --          CONVERT(datetime, BUSINESS_DATE, 103),     
 --          '',     
 --          'L', 
 --          ------------- Start By Ahsan Farooqui 20220623
 --          --CASE     
 --          --  WHEN PATINDEX('%[A-Z]%', REPLACE(TRANSACTION_DETAILS7, ' ', '')) =     
 --          --       0     
 --          --THEN     
 --          --  REPLACE(TRANSACTION_DETAILS7, ' ', '')     
 --          --  ELSE LEFT(REPLACE(TRANSACTION_DETAILS7, ' ', ''),     
 --          --              PATINDEX('%[A-Z]%', REPLACE(TRANSACTION_DETAILS7, ' ',     
 --          --                                  ''))     
 --          --              - 1)     
 --          --END,   
 --           CASE WHEN Channel ='' THEN TRANSACTION_DETAILS8  ELSE 
 --           (

 --            CASE     
 --                        WHEN PATINDEX('%[A-Z]%', REPLACE(TRANSACTION_DETAILS7, ' ', '')) =     
 --                             0     
 --                      THEN     
 --                        REPLACE(TRANSACTION_DETAILS7, ' ', '')     
 --                        ELSE LEFT(REPLACE(TRANSACTION_DETAILS7, ' ', ''),     
 --                                    PATINDEX('%[A-Z]%', REPLACE(TRANSACTION_DETAILS7, ' ',     
 --                                                        ''))     
 --                                    - 1)     
 --                      END
 --             ) END ,
 --             ------------- END By Ahsan Farooqui 20220623
 --          --LEFT(REPLACE(TRANSACTION_DETAILS7,' ' ,''), PATINDEX('%[A-Z]%',REPLACE(TRANSACTION_DETAILS7,' ' ,'')) - 1),                                               
 --          EXCHANGE='NSE',     
 --          SEGMENT='CAPITAL'     
 --   FROM   tbl_VIRTUAL_MIS_LEDGER_NEW VL WITH(NOLOCK),     
 --          VIRTUAL_MIS_SEGMENT_MAPPING SM   WITH(NOLOCK)  
 --   WHERE     
 --     NOT EXISTS(SELECT TXN_REF_NO     
 --                FROM   VIRTUAL_MIS_LEDGER_REPORT   WITH(NOLOCK)  
 --                WHERE   
 --    (.DBO.PIECE(TRANSACTION_DETAILS1, '|' , 1) = TXN_REF_NO or .DBO.PIECE(TRANSACTION_DETAILS1, '/', 3) = TXN_REF_NO or .DBO.PIECE(TRANSACTION_DETAILS1, '|', 3) = TXN_REF_NO ) or .DBO.PIECE(TRANSACTION_DETAILS1, '/', 2) = TXN_REF_NO)     
 --     and  LEFT(VL.VA_NUMBER, 7) = SEGCODE
 /*End 2022-07-23*/
      
   /*  ADDED FOR DUPLICATION  REMOVAL */ 

   CREATE INDEX IX_#VIRTUAL_MIS On #VIRTUAL_MIS (REF_NO ,CLTCODE) --INCLUDE()

      DELETE FROM #VIRTUAL_MIS  WHERE EXISTS  (
      SELECT DDNO,CLTCODE FROM AngelBSECM.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES V WITH(NOLOCK) WHERE VDATE >=CONVERT(VARCHAR(11),GETDATE()-10,120)
                                  AND DDNO=REF_NO AND #VIRTUAL_MIS.CLTCODE= V.CLTCODE
                                )
    
   /*  ADDED FOR DUPLICATION REMOVAL END */ 
    
	CREATE INDEX IX_#VIRTUAL_MIS_ACCOUNTNO On #VIRTUAL_MIS (ACCOUNTNO)
	UPDATE #VIRTUAL_MIS     
	SET  ACCOUNTNO = case when ltrim(rtrim(substring(narration,8,5)))='IMPS' then .DBO.piece(ACCOUNTNO, '|', 1) else   RTRIM(LTRIM(REPLACE(ACCOUNTNO, '|', ''))) end   
   
	UPDATE #VIRTUAL_MIS     
	SET    ACCOUNTNO = RTRIM(LTRIM(REPLACE(ACCOUNTNO, '/', '')))   
      
	UPDATE #VIRTUAL_MIS  set ACCOUNTNO=substring(ACCOUNTNO , patindex('%[^0]%',ACCOUNTNO),20)     
	---------- Added Below Code on 24 Jan 2022
	IF OBJECT_ID('tempdb..#BANKALLSEGMENT') IS NOT NULL
	drop table #BANKALLSEGMENT
	SELECT A.* INTO #BANKALLSEGMENT FROM Msajag.dbo.tbl_Party_Bank_Details_New A WITH(NOLOCK) ---Msajag.dbo.Party_Bank_Details  A WITH(NOLOCK)   Replaced from New Bank Tables. 
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
    
    UPDATE #VIRTUAL_MIS    
     SET    CHQ_NAME = BANK_NAME  
   
   --   SET @@MYTEMPVNO = CONVERT(VARCHAR, GETDATE(), 12)     
    --             + RIGHT(REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', '')     
    --                  , 6)  
    IF OBJECT_ID('tempdb..#VIRTUAL_MIS1') IS NOT NULL
    DROP TABLE #VIRTUAL_MIS1  
    SELECT 
    VoucherType,BookType,SNo,Vdate,EDate,CltCode,CreditAmt,DebitAmt,  
    Narration,OppCode,MarginCode,BankName,BranchName,BranchCode,DDNo,ChequeMode,  
    ChequeDate,ChequeName,Clear_Mode,TPAccountNumber,Exchange,Segment,TPFlag,AddDt,  
    AddBy,StatusID,StatusName,RowState,ApprovalFlag,ApprovalDate,ApprovedBy,VoucherNo,  
    UploadDt,LedgerVNO,ClientName,OppCodeName,MarginCodeName,Sett_No,Sett_Type,ProductType,  
    RevAmt,RevCode,MICR     
    INTO   #VIRTUAL_MIS1     
    FROM   AngelBSECM.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES  WITH(NOLOCK) 
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
           REF_NO=CONVERT(VARCHAR(30), REF_NO),  /* Ref No increase from 15 to 20 as per confimration from Sanjeevan*/    
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
           VOUCHERNO = CONVERT(VARCHAR, GETDATE(), 12)     
                 + RIGHT(REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', '')     
                      , 6)  ,--@@MYTEMPVNO,     
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
      
    CREATE INDEX IX_#VIRTUAL_MIS1 ON #VIRTUAL_MIS1(CLTCODE)  INCLUDE (TPFLAG) 
   
   --select * from MSAJAG.DBO.CLIENT5 B  where CL_CODE ='N70096'
   --select * from #VIRTUAL_MIS1

   UPDATE A 
    set CLTCODE='5100000018'
    FROM #VIRTUAL_MIS1 A 
    where 
    NOT EXISTS
    (SELECT CL_CODE FROM MSAJAG.DBO.CLIENT5 B WITH(NOLOCK) WHERE  B.CL_CODE= A.CLTCODE)
   
    UPDATE #VIRTUAL_MIS1     
    SET    CLIENTNAME = ACMAST.LONGNAME     
    FROM   ACMAST   WITH(NOLOCK)  
    WHERE  #VIRTUAL_MIS1.CLTCODE = ACMAST.CLTCODE 
   
   INSERT INTO AngelBSECM.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES (  
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
      
    /*New Code  Added By Ahsan 9th May 2022 */
  
  IF OBJECT_ID('tempdb..#tbl_VIRTUAL_MIS_LEDGER_REPORT_TEMP') IS NOT NULL
    DROP TABLE #tbl_VIRTUAL_MIS_LEDGER_REPORT_TEMP
 CREATE TABLE [dbo].[#tbl_VIRTUAL_MIS_LEDGER_REPORT_TEMP](
	[BR_CODE] [varchar](10) NULL,
	[SB_CODE] [varchar](30) NULL,
	[PARTY_CODE] [varchar](10) NULL,
	[PARTY_NAME] [varchar](100) NULL,
	[SEGMENT] [varchar](10) NULL,
	[AMOUNT] [money] NULL,
	[TXN_DATE] [datetime] NULL,
	[SOURCE_BANK_ACNO] [varchar](50) NULL,
	[BANK_REF_NO] [varchar](50) NULL,
	[TXN_REF_NO] [varchar](50) NULL,
	[PRODUCT] [varchar](50) NULL,
	[REMARKS] [varchar](100) NULL,
	[UPLOAD_BY] [varchar](100) NULL,
	[UPLOAD_DT] [datetime] NULL
) 

INSERT INTO #tbl_VIRTUAL_MIS_LEDGER_REPORT_TEMP
(
 BR_CODE,SB_CODE,PARTY_CODE,PARTY_NAME
,SEGMENT,AMOUNT,TXN_DATE,SOURCE_BANK_ACNO
,BANK_REF_NO,TXN_REF_NO
,PRODUCT,REMARKS
,UPLOAD_BY,UPLOAD_DT
)
 SELECT    
    BRANCH_CD, SUB_BROKER,PARTY_CODE,LONG_NAME,     
    EXCHANGE, TRANSACTION_AMOUNT,BUSINESS_DATE, '' SOURCE_BANK_ACNO,     
  CASE     
    WHEN PATINDEX('%[A-Z]%', REPLACE(TRANSACTION_DETAILS7, ' ', '')) =     
    0     
  THEN     
    REPLACE(TRANSACTION_DETAILS7, ' ', '')     
  ELSE LEFT(REPLACE(TRANSACTION_DETAILS7, ' ', ''), 
       PATINDEX('%[A-Z]%', REPLACE(TRANSACTION_DETAILS7, ' ',''))     
      - 1)     
  END,     
          --.DBO.PIECE(TRANSACTION_DETAILS1, '|', 1),     
      CASE WHEN LEFT(TRANSACTION_DETAILS1,5) ='RTGS|' THEN REPLACE (TRANSACTION_DETAILS1,'RTGS|','')
           WHEN LEFT(TRANSACTION_DETAILS1,5) ='NEFT|' THEN REPLACE (TRANSACTION_DETAILS1,'NEFT|','')
           WHEN LEFT(TRANSACTION_DETAILS1,5) ='IMPS|' THEN SUBSTRING(TRANSACTION_DETAILS1,6,12)
           WHEN LEFT(TRANSACTION_DETAILS1,4)='UPI/' THEN .DBO.PIECE(TRANSACTION_DETAILS1, '/', 2)  
           ELSE .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1)END  ,  

           'SCB -VIRTUAL',     
           TRANSACTION_DETAILS7+'|'+ TRANSACTION_DETAILS8,     
           'SURESH',     
           GETDATE()  DT     
    FROM   VIRTUAL_MIS_LEDGER VL WITH(NOLOCK),     
           VIRTUAL_MIS_SEGMENT_MAPPING SM WITH(NOLOCK),     
           MSAJAG.DBO.CLIENT_DETAILS   WITH(NOLOCK)  
    WHERE     
  --NOT EXISTS(SELECT TXN_REF_NO       
  --               FROM   VIRTUAL_MIS_LEDGER_REPORT   WITH(NOLOCK)    
  --               WHERE     
          --(.DBO.PIECE(TRANSACTION_DETAILS1, '|' , 1) = TXN_REF_NO     
          --or .DBO.PIECE(TRANSACTION_DETAILS1, '/', 3) = TXN_REF_NO     
          --or .DBO.PIECE(TRANSACTION_DETAILS1, '|', 3) = TXN_REF_NO )
          --or .DBO.PIECE(TRANSACTION_DETAILS1, '/', 2) = TXN_REF_NO)   
                 NOT EXISTS(SELECT TXN_REF_NO     
                 FROM   #VIRTUAL_MIS_LEDGER_REPORT_11  A WITH(NOLOCK)  
                 WHERE   A.TXN_REF_NO =
                 ( CASE WHEN LEFT(TRANSACTION_DETAILS1,5) ='RTGS|' THEN REPLACE (TRANSACTION_DETAILS1,'RTGS|','')
           WHEN LEFT(TRANSACTION_DETAILS1,5) ='NEFT|' THEN REPLACE (TRANSACTION_DETAILS1,'NEFT|','')
           WHEN LEFT(TRANSACTION_DETAILS1,5) ='IMPS|' THEN SUBSTRING(TRANSACTION_DETAILS1,6,12)
           WHEN LEFT(TRANSACTION_DETAILS1,4)='UPI/' THEN .DBO.PIECE(TRANSACTION_DETAILS1, '/', 2)  
           ELSE .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1)END)
           )
      AND LEFT(VL.VA_NUMBER, 7) = SEGCODE     
      AND rtrim(ltrim(RIGHT(VA_NUMBER, LEN(VA_NUMBER) - 7))) = PARTY_CODE   

      INSERT INTO VIRTUAL_MIS_LEDGER_REPORT 
      (
      BR_CODE,SB_CODE,PARTY_CODE,PARTY_NAME
      ,SEGMENT,AMOUNT,TXN_DATE,SOURCE_BANK_ACNO
      ,BANK_REF_NO,TXN_REF_NO ,PRODUCT,REMARKS
      ,UPLOAD_BY,UPLOAD_DT
      )
      Select BR_CODE,SB_CODE,PARTY_CODE,PARTY_NAME
      ,SEGMENT,AMOUNT,TXN_DATE,SOURCE_BANK_ACNO
      ,BANK_REF_NO,TXN_REF_NO ,PRODUCT,REMARKS
      ,UPLOAD_BY,UPLOAD_DT from #tbl_VIRTUAL_MIS_LEDGER_REPORT_TEMP

        
UPDATE M SET SOURCE_BANK_ACNO=1   
from  #VIRTUAL_MIS1 V 
INNER JOIN VIRTUAL_MIS_LEDGER_REPORT M  ON  V.CLTCODE=M.PARTY_CODE  
WHERE V.TPFLAG = 1   

 IF OBJECT_ID('tempdb..#VIRTUAL_MIS') IS NOT NULL  
    DROP TABLE #VIRTUAL_MIS  
     IF OBJECT_ID('tempdb..#VIRTUAL_MIS1') IS NOT NULL
    DROP TABLE #VIRTUAL_MIS1   
     IF OBJECT_ID('tempdb..#BANKALLSEGMENT') IS NOT NULL
    DROP TABLE #BANKALLSEGMENT  

IF @UNAME <> 'AUTO'     
BEGIN    
 SELECT 'RECORDS UPDATED SUCCESSFULLY'        
END     
  
--set xact_abort off

GO
