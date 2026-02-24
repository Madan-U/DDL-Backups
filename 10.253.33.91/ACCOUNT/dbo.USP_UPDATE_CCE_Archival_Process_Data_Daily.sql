-- Object: PROCEDURE dbo.USP_UPDATE_CCE_Archival_Process_Data_Daily
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


-- =============================================
-- Author:      Ahsan Farooqui 
-- Create date: 13-Mar-2022
-- Description: This is Archival Daily Job for LED/CASH tables to FINYR TAbles.
-- DB Server -- 196 / DB name Msajag
-- Sp Name - USP_UPDATE_CCE_Archival_Job_Daily 
-- =============================================
CREATE PROCEDURE dbo.USP_UPDATE_CCE_Archival_Process_Data_Daily
(
 @ProcessDate DATE
)
AS

BEGIN

--- CCE KEEP the last 15 date data in main table beyond move to FinYR.
-------------- STEP 1 Store the data in temp Tables 
DECLARE @15DaysDate DATE 
SET @15DaysDate = CONVERT(DATE,GETDATE()-15)

--Select @15DaysDate

DECLARE @Id INT 
INSERT INTO INHOUSE.dbo.tbl_General_Process_Job_Running_Log
(
 OnDate,Process ,Task ,StartTime ,Remarks  
)
VALUES (CONVERT(DATE,GETDATE()) , 'CCE -ACCOUNT USP_UPDATE_CCE_Archival_Job_Daily' ,'Insert CASH IN TEMP TABLE #CLIENT_CASH_DETAILStmp', GETDATE(),'Step2' )
SET @Id =SCOPE_IDENTITY()

IF OBJECT_ID('tempdb..#CLIENT_CASH_DETAILStmp') IS NOT NULL
    DROP TABLE #CLIENT_CASH_DETAILStmp
    SELECT * INTO #CLIENT_CASH_DETAILStmp from ACCOUNT.DBO.CLIENT_CASH_DETAILS WITH(NOLOCK) WHERE REPORT_DATE <=@15DaysDate

UPDATE INHOUSE.dbo.tbl_General_Process_Job_Running_Log
SET EndTime = GETDATE()
WHERE Id = @Id

CREATE INDEX IX_#CLIENT_CASH_DETAILStmp_SNO ON #CLIENT_CASH_DETAILStmp(SNO) 

INSERT INTO INHOUSE.dbo.tbl_General_Process_Job_Running_Log
(
 OnDate,Process ,Task ,StartTime ,Remarks  
)
VALUES (CONVERT(DATE,GETDATE()) , 'CCE -ACCOUNT USP_UPDATE_CCE_Archival_Job_Daily' ,' Insert CASH IN TEMP TABLE #CLIENT_CASH_LED_BALANCEStmp', GETDATE(),'Step3' )
SET @Id =SCOPE_IDENTITY()

 IF OBJECT_ID('tempdb..#CLIENT_CASH_LED_BALANCEStmp') IS NOT NULL
    DROP TABLE #CLIENT_CASH_LED_BALANCEStmp
    SELECT A.* INTO #CLIENT_CASH_LED_BALANCEStmp  FROM ACCOUNT.DBO.CLIENT_CASH_LED_BALANCES A WITH(NOLOCK) 
    INNER JOIN #CLIENT_CASH_DETAILStmp B ON A.SNO=B.SNo

UPDATE INHOUSE.dbo.tbl_General_Process_Job_Running_Log
SET EndTime = GETDATE()
WHERE Id = @Id
 
 --ALTER TABLE CLIENT_CASH_LED_BALANCES_Curr_FINYR
 --ADD CASH_COLL_MTF_POSITIONS MONEY

--------------------Step 2 Store the Current Finacial Details in CLIENT_CASH_LED_BALANCESFInYrs 
INSERT INTO INHOUSE.dbo.tbl_General_Process_Job_Running_Log
(
 OnDate,Process ,Task ,StartTime ,Remarks  
)
VALUES (CONVERT(DATE,GETDATE()) , 'CCE -ACCOUNT USP_UPDATE_CCE_Archival_Job_Daily ' ,'Insert LED CASH IN FI YR TABLE ACCOUNT.DBO.CLIENT_CASH_LED_BALANCES_Curr_FINYR', GETDATE(),'Step4' )
SET @Id =SCOPE_IDENTITY()
    INSERT INTO ACCOUNT.DBO.CLIENT_CASH_LED_BALANCES_Curr_FINYR
    (
    SNO,PARTY_CODE,EXCHANGE,SEGMENT
    ,VDT_BAL,EDT_BAL,OPEN_BILL1,OPEN_BILL2
    ,CHQ_DEPOSITS,CHQ_ISSUE,MARGIN_REQ,PEAK_FINANCIAL_LEDGER
    ,BG,FDR,GOV_IND_SEC,Gilt_funds
    ,EPI_LEDGER,POOL_ACCOUNT,LEDACCOUNT,COMM_VALUE ,CASH_COLL_MTF_POSITIONS
    )
    SELECT 
    SNO,PARTY_CODE,EXCHANGE,SEGMENT
    ,VDT_BAL,EDT_BAL,OPEN_BILL1,OPEN_BILL2
    ,CHQ_DEPOSITS,CHQ_ISSUE,MARGIN_REQ,PEAK_FINANCIAL_LEDGER
    ,BG,FDR,GOV_IND_SEC,Gilt_funds
    ,EPI_LEDGER,POOL_ACCOUNT,LEDACCOUNT,COMM_VALUE ,CASH_COLL_MTF_POSITIONS
    FROM #CLIENT_CASH_LED_BALANCEStmp

  UPDATE INHOUSE.dbo.tbl_General_Process_Job_Running_Log
  SET EndTime = GETDATE()
  WHERE Id = @Id
 
--------------------- Step 3 Store the Current Finacial Details in CLIENT_CASH_DETAILS_Curr_FINYR 
INSERT INTO INHOUSE.dbo.tbl_General_Process_Job_Running_Log
(
 OnDate,Process ,Task ,StartTime ,Remarks  
)
VALUES (CONVERT(DATE,GETDATE()) , 'CCE -ACCOUNT USP_UPDATE_CCE_Archival_Job_Daily' ,'Insert Current Finacial CASH IN FI YR TABLE CLIENT_CASH_DETAILS_Curr_FINYR', GETDATE(),'Step5' )
SET @Id =SCOPE_IDENTITY()

    SET IDENTITY_INSERT ACCOUNT.DBO.CLIENT_CASH_DETAILS_Curr_FINYR ON
      INSERT INTO ACCOUNT.DBO.CLIENT_CASH_DETAILS_Curr_FINYR
      (
        SNO,TRADING_PAN,UCC,PARENTCODE
      ,CLIENT_PAN,CLIENT_NAME,CL_TYPE,REPORT_DATE
      ,LAST_SETT_DATE,RUNDATE
      )
      SELECT  
        SNO,TRADING_PAN,UCC,PARENTCODE
      ,CLIENT_PAN,CLIENT_NAME,CL_TYPE,REPORT_DATE
      ,LAST_SETT_DATE,RUNDATE
      FROM #CLIENT_CASH_DETAILStmp
    SET IDENTITY_INSERT ACCOUNT.DBO.CLIENT_CASH_DETAILS_Curr_FINYR OFF 

UPDATE INHOUSE.dbo.tbl_General_Process_Job_Running_Log
SET EndTime = GETDATE()
WHERE Id = @Id
 
------------- STEP 4 Delete the Records from Backup Tables. 
 
	DECLARE @ONDATE DATE 
	DECLARE @ToDate DATE
	   -- SET @ONDATE = '2022-01-28 00:00:00.000'
		  --SET @ToDate =  '2022-01-24 00:00:00.000'
 Select @ToDate=MAX(REPORT_DATE) ,@ONDATE =MIN(REPORT_DATE)  FROm #CLIENT_CASH_DETAILStmp
 
WHILE (@ONDATE <= @ToDate)
 BEGIN

  INSERT INTO INHOUSE.dbo.tbl_General_Process_Job_Running_Log
  (
  OnDate,Process ,Task ,StartTime ,Remarks  
  )
  VALUES (CONVERT(DATE,GETDATE()) , 'CCE -ACCOUNT USP_UPDATE_CCE_Archival_Job_Daily ' ,'Delete the records from LED MAIn TBALEs CLIENT_CASH_LED_BALANCES for perticular days ' +CONVERT(VARCHAR(112),@ONDATE,12), GETDATE(),'Step5' )
  SET @Id =SCOPE_IDENTITY()

  IF OBJECT_ID('tempdb..#CLIENT_CASH_DETAILStmp_1') IS NOT NULL
    DROP TABLE #CLIENT_CASH_DETAILStmp_1
     SELECT * INTO #CLIENT_CASH_DETAILStmp_1 from CLIENT_CASH_DETAILS WITH(NOLOCK) WHERE REPORT_DATE= @ONDATE
     CREATE INDEX IX_#CLIENT_CASH_DETAILStmp_1_SNO ON #CLIENT_CASH_DETAILStmp_1(SNO) 

    DELETE A FROm CLIENT_CASH_LED_BALANCES A   
              WHERE A.SNO IN (Select SNO FROm #CLIENT_CASH_DETAILStmp_1)

    UPDATE INHOUSE.dbo.tbl_General_Process_Job_Running_Log
    SET EndTime = GETDATE()
    WHERE Id = @Id

    INSERT INTO INHOUSE.dbo.tbl_General_Process_Job_Running_Log
    (
    OnDate,Process ,Task ,StartTime ,Remarks  
    )
    VALUES (CONVERT(DATE,GETDATE()) , 'CCE -ACCOUNT USP_UPDATE_CCE_Archival_Job_Daily' ,'Delete the records from CLIENT_CASH_DETAILS for perticular days ' +CONVERT(VARCHAR(112),@ONDATE,12), GETDATE(),'Step7' )
    SET @Id =SCOPE_IDENTITY()

    DELETE A FROM CLIENT_CASH_DETAILS A WHERE REPORT_DATE= @ONDATE

    UPDATE INHOUSE.dbo.tbl_General_Process_Job_Running_Log
    SET EndTime = GETDATE()
    WHERE Id = @Id

  SET @ONDATE = DATEADD(DD,1,@ONDATE )
      PRINT @ONDATE
  END
  
  ------------------ DROP TEMP TABLEs 
    IF OBJECT_ID('tempdb..#CLIENT_CASH_DETAILStmp_1') IS NOT NULL
    DROP TABLE #CLIENT_CASH_DETAILStmp_1

  IF OBJECT_ID('tempdb..#CLIENT_CASH_DETAILStmp') IS NOT NULL
    DROP TABLE #CLIENT_CASH_DETAILStmp

    IF OBJECT_ID('tempdb..#CLIENT_CASH_LED_BALANCEStmp') IS NOT NULL
    DROP TABLE #CLIENT_CASH_LED_BALANCEStmp
---------------- Process Completed -------------------------------


      -- NOW Data Moved to History from Financial Yers Tables.
                 --This Task have to do Manually

    --INSERT INTO Account.dbo.CLIENT_CASH_DETAILS_HISTORY
    --(
    --   SNO,TRADING_PAN,UCC,PARENTCOD
    --  ,CLIENT_PA,CLIENT_NA,CL_TYPE,REPORT_DA
    --  ,LAST_SETT,RUNDATE
    --)
    --SELECT
    -- SNO,TRADING_PAN,UCC,PARENTCOD
    --,CLIENT_PA,CLIENT_NA,CL_TYPE,REPORT_DA
    --,LAST_SETT,RUNDATE
    --FROM Account.dbo.CLIENT_CASH_DETAILS_Curr_FINYR  WHERE RUNDATE <'2022-03-31' 

    --INSERT INTO Account.dbo.CLIENT_CASH_LED_BALANCES_HISTORY
    --(
    --   SNO,TRADING_PAN,UCC,PARENTCOD
    --  ,CLIENT_PA,CLIENT_NA,CL_TYPE,REPORT_DA
    --  ,LAST_SETT,RUNDATE
    --)
    --SELECT
    -- SNO,TRADING_PAN,UCC,PARENTCOD
    --,CLIENT_PA,CLIENT_NA,CL_TYPE,REPORT_DA
    --,LAST_SETT,RUNDATE
    --FROM Account.dbo.CLIENT_CASH_DETAILS_Curr_FINYR  WHERE RUNDATE <'2022-03-31' 

----------------------- END The Process CLIENT_CASH----------------------
 
END

GO
