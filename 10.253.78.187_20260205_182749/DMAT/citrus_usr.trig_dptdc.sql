-- Object: TRIGGER citrus_usr.trig_dptdc
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

-------------trig_dptdc--------------  
CREATE TRIGGER [citrus_usr].[trig_dptdc]  
ON [citrus_usr].[dp_trx_dtls_cdsl]  
FOR INSERT,UPDATE  
AS  
DECLARE @l_action VARCHAR(20)  
--  
SET @l_action = 'E'  
--  
IF UPDATE(dptdc_deleted_ind)  
BEGIN  
--  
  IF EXISTS(SELECT inserted.dptdc_id    
            FROM   inserted   
            WHERE  inserted.dptdc_deleted_ind = 0  
           )  
  BEGIN  
  --  
    SET @l_action = 'D'  
  --    
  END    
--  
END  
--ELSE  
--BEGIN  
--  
--  SET @l_action = 'E'  
--  
--END  
--  
IF NOT EXISTS(SELECT deleted.dptdc_id FROM deleted)   
BEGIN--insert  
--  
  INSERT INTO DPTDC_HST  
  (DPTDC_ID  
,DPTDC_DPAM_ID  
,DPTDC_REQUEST_DT  
,DPTDC_SLIP_NO  
,DPTDC_ISIN  
,DPTDC_BATCH_NO  
,DPTDC_LINE_NO  
,DPTDC_QTY  
,DPTDC_INTERNAL_REF_NO  
,DPTDC_TRANS_NO  
,DPTDC_MKT_TYPE  
,DPTDC_SETTLEMENT_NO  
,DPTDC_EXECUTION_DT  
,DPTDC_OTHER_SETTLEMENT_TYPE  
,DPTDC_OTHER_SETTLEMENT_NO  
,DPTDC_COUNTER_DP_ID  
,DPTDC_COUNTER_CMBP_ID  
,DPTDC_COUNTER_DEMAT_ACCT_NO  
,dptdC_trastm_cd  
,DPTDC_DTLS_ID  
,DPTDC_BOOKING_NARRATION  
,DPTDC_BOOKING_TYPE  
,DPTDC_CONVERTED_QTY  
,DPTDC_REASON_CD  
,DPTDC_STATUS  
,DPTDC_INTERNAL_TRASTM  
,DPTDC_EXCM_ID  
,DPTDC_CASH_TRF  
,DPTDC_CM_ID  
,DPTDC_CREATED_BY  
,DPTDC_CREATED_DT  
,DPTDC_LST_UPD_BY  
,DPTDC_LST_UPD_DT  
,DPTDC_DELETED_IND  
,DPTDC_RMKS  
,DPTDC_ERRMSG  
,DPTDC_BROKERBATCH_NO  
,DPTDC_BROKER_INTERNAL_REF_NO  
,dptdc_others_cl_name  
,DPTDC_ACTION  
)  
  SELECT  inserted.DPTDC_ID  
,inserted.DPTDC_DPAM_ID  
,inserted.DPTDC_REQUEST_DT  
,inserted.DPTDC_SLIP_NO  
,inserted.DPTDC_ISIN  
,inserted.DPTDC_BATCH_NO  
,inserted.DPTDC_LINE_NO  
,inserted.DPTDC_QTY  
,inserted.DPTDC_INTERNAL_REF_NO  
,inserted.DPTDC_TRANS_NO  
,inserted.DPTDC_MKT_TYPE  
,inserted.DPTDC_SETTLEMENT_NO  
,inserted.DPTDC_EXECUTION_DT  
,inserted.DPTDC_OTHER_SETTLEMENT_TYPE  
,inserted.DPTDC_OTHER_SETTLEMENT_NO  
,inserted.DPTDC_COUNTER_DP_ID  
,inserted.DPTDC_COUNTER_CMBP_ID  
,inserted.DPTDC_COUNTER_DEMAT_ACCT_NO  
,inserted.dptdC_trastm_cd  
,inserted.DPTDC_DTLS_ID  
,inserted.DPTDC_BOOKING_NARRATION  
,inserted.DPTDC_BOOKING_TYPE  
,inserted.DPTDC_CONVERTED_QTY  
,inserted.DPTDC_REASON_CD  
,inserted.DPTDC_STATUS  
,inserted.DPTDC_INTERNAL_TRASTM  
,inserted.DPTDC_EXCM_ID  
,inserted.DPTDC_CASH_TRF  
,inserted.DPTDC_CM_ID  
,inserted.DPTDC_CREATED_BY  
,inserted.DPTDC_CREATED_DT  
,inserted.DPTDC_LST_UPD_BY  
,inserted.DPTDC_LST_UPD_DT  
,inserted.DPTDC_DELETED_IND  
,inserted.DPTDC_RMKS  
,inserted.DPTDC_ERRMSG  
,inserted.DPTDC_BROKERBATCH_NO  
,inserted.DPTDC_BROKER_INTERNAL_REF_NO  
,inserted.dptdc_others_cl_name  
      , 'I'  
  FROM   inserted  
--    
END  
ELSE   
BEGIN--updated  
--  
  INSERT INTO DPTDC_HST  
  (DPTDC_ID  
,DPTDC_DPAM_ID  
,DPTDC_REQUEST_DT  
,DPTDC_SLIP_NO  
,DPTDC_ISIN  
,DPTDC_BATCH_NO  
,DPTDC_LINE_NO  
,DPTDC_QTY  
,DPTDC_INTERNAL_REF_NO  
,DPTDC_TRANS_NO  
,DPTDC_MKT_TYPE  
,DPTDC_SETTLEMENT_NO  
,DPTDC_EXECUTION_DT  
,DPTDC_OTHER_SETTLEMENT_TYPE  
,DPTDC_OTHER_SETTLEMENT_NO  
,DPTDC_COUNTER_DP_ID  
,DPTDC_COUNTER_CMBP_ID  
,DPTDC_COUNTER_DEMAT_ACCT_NO  
,dptdC_trastm_cd  
,DPTDC_DTLS_ID  
,DPTDC_BOOKING_NARRATION  
,DPTDC_BOOKING_TYPE  
,DPTDC_CONVERTED_QTY  
,DPTDC_REASON_CD  
,DPTDC_STATUS  
,DPTDC_INTERNAL_TRASTM  
,DPTDC_EXCM_ID  
,DPTDC_CASH_TRF  
,DPTDC_CM_ID  
,DPTDC_CREATED_BY  
,DPTDC_CREATED_DT  
,DPTDC_LST_UPD_BY  
,DPTDC_LST_UPD_DT  
,DPTDC_DELETED_IND  
,DPTDC_RMKS  
,DPTDC_ERRMSG  
,DPTDC_BROKERBATCH_NO  
,DPTDC_BROKER_INTERNAL_REF_NO  
,dptdc_others_cl_name  
,DPTDC_ACTION  
  )  
  SELECT  inserted.DPTDC_ID  
,inserted.DPTDC_DPAM_ID  
,inserted.DPTDC_REQUEST_DT  
,inserted.DPTDC_SLIP_NO  
,inserted.DPTDC_ISIN  
,inserted.DPTDC_BATCH_NO  
,inserted.DPTDC_LINE_NO  
,inserted.DPTDC_QTY  
,inserted.DPTDC_INTERNAL_REF_NO  
,inserted.DPTDC_TRANS_NO  
,inserted.DPTDC_MKT_TYPE  
,inserted.DPTDC_SETTLEMENT_NO  
,inserted.DPTDC_EXECUTION_DT  
,inserted.DPTDC_OTHER_SETTLEMENT_TYPE  
,inserted.DPTDC_OTHER_SETTLEMENT_NO  
,inserted.DPTDC_COUNTER_DP_ID  
,inserted.DPTDC_COUNTER_CMBP_ID  
,inserted.DPTDC_COUNTER_DEMAT_ACCT_NO  
,inserted.dptdC_trastm_cd  
,inserted.DPTDC_DTLS_ID  
,inserted.DPTDC_BOOKING_NARRATION  
,inserted.DPTDC_BOOKING_TYPE  
,inserted.DPTDC_CONVERTED_QTY  
,inserted.DPTDC_REASON_CD  
,inserted.DPTDC_STATUS  
,inserted.DPTDC_INTERNAL_TRASTM  
,inserted.DPTDC_EXCM_ID  
,inserted.DPTDC_CASH_TRF  
,inserted.DPTDC_CM_ID  
,inserted.DPTDC_CREATED_BY  
,inserted.DPTDC_CREATED_DT  
,inserted.DPTDC_LST_UPD_BY  
,inserted.DPTDC_LST_UPD_DT  
,inserted.DPTDC_DELETED_IND  
,inserted.DPTDC_RMKS  
,inserted.DPTDC_ERRMSG  
,inserted.DPTDC_BROKERBATCH_NO  
,inserted.DPTDC_BROKER_INTERNAL_REF_NO  
,inserted.dptdc_others_cl_name  
       , 'E'  
  FROM   inserted  
  --  
  IF @l_action = 'D'  
  BEGIN  
  --  
      DELETE dp_trx_dtls_cdsl  
      FROM   dp_trx_dtls_cdsl             dptdc  
           , inserted                    inserted  
      WHERE  dptdc.dptdc_id               = inserted.dptdc_id  
      AND    inserted.dptdc_deleted_ind = 0  
  --  
  END  
--     
END  
-------------trig_dptdc---------------

GO
