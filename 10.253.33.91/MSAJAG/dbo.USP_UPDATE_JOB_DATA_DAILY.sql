-- Object: PROCEDURE dbo.USP_UPDATE_JOB_DATA_DAILY
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




CREATE PROCEDURE [dbo].[USP_UPDATE_JOB_DATA_DAILY]  
(  
  @OnDate DATETIME  =null  
)  
AS  
BEGIN  
------------------ Start Updation Job's    
  
  ------------ Step 1  
  EXEC [dbo].[USP_Update_Party_Bank_Details_NEW]   
  
  ---------------- Step 2 STAMP Duty   
  UPDATE A   
  SET FUT_BROKER_NOTE= (CASE WHEN FUT_BROKER_NOTE =0 then 1 ELSE  FUT_BROKER_NOTE END) ,   
      OPT_BROKER_NOTE =(CASE when OPT_BROKER_NOTE = 0 then 1 ELSE  OPT_BROKER_NOTE END)     
  from [AngelCommodity].MCDX.DBO.FOCLIENTTAXES A   
  WHERE (FUT_BROKER_NOTE = 0  OR OPT_BROKER_NOTE = 0)  
  and getdate() between Date_From AND Date_To  
  
   ----------------- END 2022 Apr 27 -------------------  
-- Step 3  
--TRUNCATE TABLE ACCOUNT.dbo.CLIENT_CASH_ACTIVE_LOG  
INSERT INTO ACCOUNT.dbo.CLIENT_CASH_ACTIVE_LOG   
(  
CLTCODE  
,STATUS_FROM_DATE  
,STATUS_TO_DATE  
,STATUS_FLAG  
,UPD_TIME  
,UNAME  
)  
select CLTCODE, Balance_date , '2049-12-31',0,getdate(),'BROKER'   
from MIS.SCCS.DBO.Unsettled_separatebank WITH(NOLOCK)  
--where Balance_date >=Getdate() -1
where Balance_date >(select max(STATUS_FROM_DATE) from ACCOUNT.dbo.CLIENT_CASH_ACTIVE_LOG)
  
  
--Declare @MXDT DATE  
--select @MXDT = MAX(balance_date) from MIS.SCCS.DBO.Unsettled_separatebank_hist WITH(NOLOCK) 
--Declare @MXISLogDT DATE 
--SELECT  @MXISLogDT= MAX(STATUS_FROM_DATE) from ACCOUNT.dbo.CLIENT_CASH_ACTIVE_LOG
 
--INSERT INTO ACCOUNT.dbo.CLIENT_CASH_ACTIVE_LOG   
--(  
--CLTCODE  
--,STATUS_FROM_DATE  
--,STATUS_TO_DATE  
--,STATUS_FLAG  
--,UPD_TIME  
--,UNAME  
--)  
-- SELECT 
-- CLTCODE, Balance_date , DATEADD(DD,-1,@MXISLogDT )  ,0,getdate(),'BROKER'   
-- FROm  MIS.SCCS.DBO.Unsettled_separatebank_hist WITH(NOLOCK)  where  balance_date =@MXDT  
  
--- Step 4   
EXEC Msajag.dbo.USP_AUTO_ARCHIVAL_ORDER_TRANS_JV_CALC  
   
	--- STEP 5
	--DECLARE @MX_SCCS_SettDate_Last_SEBI DATETIME
	--Select @MX_SCCS_SettDate_Last_SEBI = Max(SCCS_SettDate_Last) 
	--FROM MSAJAG.dbo.SEBI_PAYOUT  with (Nolock)
	---- SELECT @MX_SCCS_SettDate_Last_SEBI

	--DECLARE @MXDT_SCCS_CLIENTMASTER_HIST DATETIME 
	----Select @MXDT_SCCS_CLIENTMASTER_HIST = Max(SCCS_SettDate_Last) from MIS.SCCS.DBO.SCCS_CLIENTMASTER_HIST with (Nolock)
	--Select @MXDT_SCCS_CLIENTMASTER_HIST = Max(SCCS_SettDate_Last) 
	--from sebipayout.SEBI.dbo.sccs_clientmaster_hist with (Nolock)
	  
 	IF OBJECT_ID('tempdb.dbo.#SCC_HISt', 'U') IS NOT NULL
		DROP TABLE #SCC_HISt
	Select Party_code , MAX(SCCS_SettDate_Last) SCCS_SettDate_Last
	INTO  #SCC_HISt 
	from sebipayout.SEBI.dbo.sccs_clientmaster_hist with (Nolock)
	where  Exclude='N'
	GROUP BY Party_code
	Create INDEX IX_#SCC_HISt On #SCC_HISt (Party_code) INCLUDE (SCCS_SettDate_Last)

	IF OBJECT_ID('tempdb.dbo.#SCCLIVE', 'U') IS NOT NULL
	DROP TABLE #SCCLIVE
	SELECT Party_code , MAX(SCCS_SettDate_Last)  SCCS_SettDate_Last INTO #SCCLIVE 
	FROM sebipayout.SEBI.dbo.sccs_clientmaster	WITH (NOLOCK) 
	where SCCS_SettDate_Last<=getdate() and Exclude='N'
	GROUP BY Party_code

	Create INDEX IX_#SCCLIVE On #SCCLIVE (Party_code) INCLUDE (SCCS_SettDate_Last)
	
	DELETE A FROM #SCC_HISt A
	INNER  JOIN #SCCLIVE B ON A.Party_code = B.Party_code

	TRUNCATE TABLE tbl_SEBI_PAYOUT_CCE_Reporting
	INSERT INTO tbl_SEBI_PAYOUT_CCE_Reporting
	(Party_code,SCCS_SettDate_Last)
	select Party_code,SCCS_SettDate_Last  from #SCC_HISt

	INSERT INTO tbl_SEBI_PAYOUT_CCE_Reporting
	  (Party_code,SCCS_SettDate_Last)
	select Party_code,SCCS_SettDate_Last from #SCCLIVE
	 	

	--SELECT  
	--    Party_code,SCCS_SettDate_Last,SCCS_SettDate_Next,RAA_Date,
	--    RAA_Expiry_Date,Exclude,Remark,dormant, updatedOn 
	--    --FROM MIS.SCCS.DBO.SCCS_CLIENTMASTER_HIST  WITH (NOLOCK)
	--	FROM sebipayout.SEBI.dbo.sccs_clientmaster WITH (NOLOCK)
	--    WHERE SCCS_SettDate_Last=@MX_SCCS_SettDate_Last and Exclude='N'

	--IF (@MX_SCCS_SettDate_Last_SEBI<@MX_SCCS_SettDate_Last )
	--BEGIN

	--	DELETE A FROM MSAJAG.dbo.SEBI_PAYOUT A WITH(NOLOCK) WHERE SCCS_SettDate_Last = @MX_SCCS_SettDate_Last

	--	INSERT INTO MSAJAG.dbo.SEBI_PAYOUT
	--	(
	--	 Party_code,SCCS_SettDate_Last,SCCS_SettDate_Next,RAA_Date
	--	,RAA_Expiry_Date,Exclude,Remark,dormant,updatedOn
	--	)
	--	SELECT  
	--	Party_code,SCCS_SettDate_Last,SCCS_SettDate_Next,RAA_Date,
	--	RAA_Expiry_Date,Exclude,Remark,dormant, updatedOn 
	--	--FROM MIS.SCCS.DBO.SCCS_CLIENTMASTER_HIST  WITH (NOLOCK)
	--	FROM sebipayout.SEBI.dbo.sccs_clientmaster WITH (NOLOCK)
	--	WHERE SCCS_SettDate_Last=@MX_SCCS_SettDate_Last and Exclude='N'
	
	--END

 -- IF (DATENAME (WEEKDAY,GETDATE()) ='MONDAY' AND @MXDT_SCCS_CLIENTMASTER_HIST >@MX_SCCS_SettDate_Last_SEBI )
 -- BEGIN
 --   INSERT INTO MSAJAG.dbo.SEBI_PAYOUT
 --   (
 --     Party_code,SCCS_SettDate_Last,SCCS_SettDate_Next,RAA_Date
 --   ,RAA_Expiry_Date,Exclude,Remark,dormant,updatedOn
 --   )
 --   SELECT  
 --   Party_code,SCCS_SettDate_Last,SCCS_SettDate_Next,RAA_Date,
 --   RAA_Expiry_Date,Exclude,Remark,dormant, updatedOn 
 --   --FROM MIS.SCCS.DBO.SCCS_CLIENTMASTER_HIST  WITH (NOLOCK)
	--FROM sebipayout.SEBI.dbo.sccs_clientmaster_hist WITH (NOLOCK)
 --   WHERE      PARTY_CODE >= 'A' 
 --           AND PARTY_CODE <='ZZZZZ999' 
 --           AND EXCLUDE ='N' 
 --           AND SCCS_SettDate_Last > @MX_SCCS_SettDate_Last_SEBI
 --END

------------------- Delete the records beyond the 15 minutes 
DELETE A 
from Account.dbo.OFFLINE_DATA_LOG A WITH(NOLOCK)
where DATEDIFF(MINUTE,APPROVALDATE ,getdate()) >15


END

GO
