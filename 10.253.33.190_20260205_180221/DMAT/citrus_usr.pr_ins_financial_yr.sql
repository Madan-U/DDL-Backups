-- Object: PROCEDURE citrus_usr.pr_ins_financial_yr
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_ins_financial_yr]   
(@pa_id          VARCHAR(8000)     
,@pa_action      VARCHAR(20)     
,@pa_login_name  VARCHAR(20)    
,@pa_dpmdpid     VARCHAR(20)   
,@pa_start_dt    VARCHAR(11)   
,@pa_end_dt      VARCHAR(11)   
,@pa_chk_yn      INT        
,@rowdelimiter   CHAR(4)       = '*|~*'        
,@coldelimiter   CHAR(4)       = '|*~|'        
,@pa_errmsg      VARCHAR(8000)  OUTPUT   
)  
AS  
BEGIN  
--  
DECLARE @t_errorstr      VARCHAR(8000)      
, @l_error      BIGINT     
,@l_dpm_id int  
,@l_fin_id int   
,@@SSQL     VARCHAR(8000)  
,@l_end_dt VARCHAR(11)  
  
  
IF @pa_action ='SETFRMDT'  
BEGIN  
--  
 SELECT @l_dpm_id = dpm_id from dp_mstr where dpm_dpid =@pa_dpmdpid and dpm_deleted_ind = 1  
 IF EXISTS (SELECT FIN_END_DT FROM Financial_Yr_Mstr WHERE FIN_DPM_ID = CONVERT(INT,@l_dpm_id) and fin_deleted_ind = 1)  
 BEGIN  
 --  
  SELECT @l_end_dt = CONVERT(VARCHAR(11),MAX(FIN_END_DT)+1,103) FROM  Financial_Yr_Mstr WHERE FIN_DPM_ID = CONVERT(INT,@l_dpm_id) and fin_deleted_ind = 1     
  SET @pa_errmsg = @l_end_dt  
  return  
 --  
 END  
 ELSE  
 BEGIN  
 --  
  SET @pa_errmsg ='NA'  
  return  
 --  
 END  
--   
END       
  
IF @pa_action = 'GETFINYR'     
BEGIN  
--  
 SELECT @l_dpm_id = dpm_id from dp_mstr where default_dp = @pa_dpmdpid and dpm_deleted_ind = 1  
   
 SELECT CONVERT(VARCHAR,fin_id) + '-' + CONVERT(VARCHAR,fin_dpm_id) finid ,CONVERT(VARCHAR(11),fin_start_dt,103) +  '-' + CONVERT(VARCHAR(11),fin_end_dt,103) finyr  
 FROM    Financial_Yr_Mstr  
 WHERE   fin_deleted_ind = 1  
 AND  fin_dpm_id = @l_dpm_id  
--  
END  
  
IF @pa_action = 'INS'     
BEGIN  
--  
 SELECT @l_fin_id =ISNULL(MAX(fin_id),0) + 1 FROM  Financial_Yr_Mstr    
 --SELECT @l_dpm_id = dpm_id from dp_mstr where dpm_dpid =@pa_dpmdpid and dpm_deleted_ind = 1  
	IF @pa_dpmdpid = 'ALL'  
	BEGIN
		SET @l_dpm_id = 999
	END
	ELSE
	BEGIN
	 SELECT @l_dpm_id = dpm_id from dp_mstr where dpm_dpid =@pa_dpmdpid and dpm_deleted_ind = 1  
	END
  
 INSERT INTO Financial_Yr_Mstr  
 (FIN_ID  
 ,FIN_DPM_ID  
 ,FIN_START_DT  
 ,FIN_END_DT  
 ,FIN_CF_BALANCES  
 ,FIN_CREATED_BY  
 ,FIN_CREATED_DT  
 ,FIN_LST_UPD_BY  
 ,FIN_LST_UPD_DT  
 ,FIN_DELETED_IND  
 )  
 VALUES  
 (@l_fin_id  
 ,@l_dpm_id  
 ,convert(datetime,@pa_start_dt,103)  
 ,convert(datetime,@pa_end_dt,103)  
 ,'N'  
 ,@pa_login_name  
 ,getdate()  
 ,@pa_login_name  
 ,getdate()  
 ,1  
 )  
 SET @@SSQL = 'SELECT TOP 0 * INTO LEDGER'+convert(varchar,@l_fin_id)+'  FROM LEDGER '  
 exec(@@SSQL)  
    SET @@SSQL = 'SELECT TOP 0 * INTO LEDGER'+convert(varchar,@l_fin_id)+'_mak  FROM LEDGER '  
 exec(@@SSQL)  
 SET @@SSQL = 'SELECT TOP 0 * INTO ACCOUNTBAL'+convert(varchar,@l_fin_id)+'  FROM ACCOUNTBAL '  
 exec(@@SSQL)  
    SET @@SSQL = 'SELECT TOP 0 * INTO LEDGER_HST'+convert(varchar,@l_fin_id)+'  FROM LEDGER_HST '  
 exec(@@SSQL)  
  
  
 set @@SSQL='CREATE TRIGGER [citrus_usr].[trig_ledger' + convert(varchar,@l_fin_id) + ']   
 ON [citrus_usr].[LEDGER' + convert(varchar,@l_fin_id) + ']  
 FOR INSERT,UPDATE  
 AS  
 DECLARE @l_action VARCHAR(20)  
 SET @l_action = ''E''  
 IF UPDATE(LDG_DELETED_IND)  
 BEGIN  
   IF EXISTS(SELECT inserted.LDG_ID FROM inserted WHERE  inserted.LDG_DELETED_IND  = 0)  
   BEGIN  
     SET @l_action = ''D''  
   END    
   
 END  
 IF NOT EXISTS(SELECT deleted.LDG_ID FROM deleted)   
 BEGIN  
   INSERT INTO LEDGER_HST'+ convert(varchar,@l_fin_id)+'(LDG_ID,LDG_DPM_ID,LDG_VOUCHER_TYPE,LDG_BOOK_TYPE_CD,LDG_VOUCHER_NO,LDG_SR_NO,LDG_REF_NO,LDG_VOUCHER_DT,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,LDG_AMOUNT,LDG_NARRATION,LDG_BANK_ID,LDG_ACCOUNT_NO,LDG_INSTRUMENT_NO,LDG_BANK_CL_DATE,LDG_COST_CD_ID,LDG_BILL_BRKUP_ID,LDG_TRANS_TYPE,LDG_STATUS,LDG_CREATED_BY,LDG_CREATED_DT,LDG_LST_UPD_BY,LDG_LST_UPD_DT,LDG_DELETED_IND,LDG_BRANCH_ID,LDG_ACTION)     SELECT  inserted.LDG_ID,inserted.LDG_DPM_ID,inserted.LDG_VOUCHER_TYPE,inserted.LDG_BOOK_TYPE_CD,inserted.LDG_VOUCHER_NO,inserted.LDG_SR_NO,inserted.LDG_REF_NO,inserted.LDG_VOUCHER_DT,inserted.LDG_ACCOUNT_ID,inserted.LDG_ACCOUNT_TYPE,inserted.LDG_AMOUNT,inserted.LDG_NARRATION,inserted.LDG_BANK_ID,inserted.LDG_ACCOUNT_NO,inserted.LDG_INSTRUMENT_NO,inserted.LDG_BANK_CL_DATE,inserted.LDG_COST_CD_ID,inserted.LDG_BILL_BRKUP_ID,inserted.LDG_TRANS_TYPE,inserted.LDG_STATUS,inserted.LDG_CREATED_BY,inserted.LDG_CREATED_DT,inserted.LDG_LST_UPD_BY,inserted.LDG_LST_UPD_DT,inserted.LDG_DELETED_IND,inserted.LDG_BRANCH_ID,''I''     FROM   inserted  
 END  
 ELSE   
 BEGIN  
   INSERT INTO LEDGER_HST'+ convert(varchar,@l_fin_id)+'(LDG_ID,LDG_DPM_ID,LDG_VOUCHER_TYPE,LDG_BOOK_TYPE_CD,LDG_VOUCHER_NO,LDG_SR_NO,LDG_REF_NO,LDG_VOUCHER_DT,LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,LDG_AMOUNT,LDG_NARRATION,LDG_BANK_ID,LDG_ACCOUNT_NO,LDG_INSTRUMENT_NO,LDG_BANK_CL_DATE,LDG_COST_CD_ID,LDG_BILL_BRKUP_ID,LDG_TRANS_TYPE,LDG_STATUS,LDG_CREATED_BY,LDG_CREATED_DT,LDG_LST_UPD_BY,LDG_LST_UPD_DT,LDG_DELETED_IND,LDG_BRANCH_ID,LDG_ACTION)     SELECT inserted.LDG_ID,inserted.LDG_DPM_ID,inserted.LDG_VOUCHER_TYPE,inserted.LDG_BOOK_TYPE_CD,inserted.LDG_VOUCHER_NO,inserted.LDG_SR_NO,inserted.LDG_REF_NO,inserted.LDG_VOUCHER_DT,inserted.LDG_ACCOUNT_ID,inserted.LDG_ACCOUNT_TYPE,inserted.LDG_AMOUNT,inserted.LDG_NARRATION,inserted.LDG_BANK_ID,inserted.LDG_ACCOUNT_NO,inserted.LDG_INSTRUMENT_NO,inserted.LDG_BANK_CL_DATE,inserted.LDG_COST_CD_ID,inserted.LDG_BILL_BRKUP_ID,inserted.LDG_TRANS_TYPE,inserted.LDG_STATUS,inserted.LDG_CREATED_BY,inserted.LDG_CREATED_DT,inserted.LDG_LST_UPD_BY,inserted.LDG_LST_UPD_DT,inserted.LDG_DELETED_IND,inserted.LDG_BRANCH_ID,''E''  
   FROM   inserted  
   
   --IF @l_action = ''D''  
   --BEGIN  
   --    DELETE LEDGER' + convert(varchar,@l_fin_id) + '   
   --    FROM   LEDGER'+ convert(varchar,@l_fin_id) + ' LDG  
   --         , inserted                    inserted  
   --    WHERE  LDG.LDG_ID               = inserted.LDG_ID  
   --    AND    inserted.LDG_DELETED_IND = 0  
   --END  
 END'  
 exec(@@SSQL)  
--  
END  
  
  
ELSE IF @PA_ACTION ='DEL'  
BEGIN  
--  
 SET @@SSQL = 'SELECT  top 1 ldg_id FROM LEDGER'+CONVERT(VARCHAR,@pa_id)  
 exec(@@SSQL)  
  
 IF @@rowcount = 1   
 BEGIN  
 --  
  SET  @pa_errmsg ='ERROR:-Data is  available for this financial year'  
  return   
 --  
 END  
 ELSE  
 BEGIN  
 --  
  
  
  SET @@SSQL = 'DROP TRIGGER trig_ledger'+CONVERT(VARCHAR,@pa_id) + '   
         DROP TABLE  LEDGER'+CONVERT(VARCHAR,@pa_id) +'    
         DROP TABLE ACCOUNTBAL'+CONVERT(VARCHAR,@pa_id)   
  exec(@@SSQL)  
    
  UPDATE Financial_Yr_Mstr  
  SET  fin_deleted_ind = 0  
  ,fin_lst_upd_by =@PA_LOGIN_NAME  
  ,fin_lst_upd_dt = getdate()  
  WHERE fin_id =CONVERT(INT,@pa_id)       
  AND   fin_deleted_ind = 1  
 --  
 END  
  
END  /*del action */  
  
END

GO
