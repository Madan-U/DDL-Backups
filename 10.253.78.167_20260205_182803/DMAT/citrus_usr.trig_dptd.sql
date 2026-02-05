-- Object: TRIGGER citrus_usr.trig_dptd
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

-------------trig_dptd--------------  
CREATE TRIGGER [citrus_usr].[trig_dptd]  
ON [citrus_usr].[dp_trx_dtls]  
FOR INSERT,UPDATE  
AS  
DECLARE @l_action VARCHAR(20)  
--  
SET @l_action = 'E'  
--  
IF UPDATE(dptd_deleted_ind)  
BEGIN  
--  
  IF EXISTS(SELECT inserted.dptd_id    
            FROM   inserted   
            WHERE  inserted.dptd_deleted_ind = 0  
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
IF NOT EXISTS(SELECT deleted.dptd_id FROM deleted)   
BEGIN--insert  
--  
  INSERT INTO DPTD_HST  
  (DPTD_ID  
,DPTD_DPAM_ID  
,DPTD_REQUEST_DT  
,DPTD_SLIP_NO  
,DPTD_ISIN  
,DPTD_BATCH_NO  
,DPTD_LINE_NO  
,DPTD_QTY  
,DPTD_INTERNAL_REF_NO  
,DPTD_TRANS_NO  
,DPTD_MKT_TYPE  
,DPTD_SETTLEMENT_NO  
,DPTD_EXECUTION_DT  
,DPTD_OTHER_SETTLEMENT_TYPE  
,DPTD_OTHER_SETTLEMENT_NO  
,DPTD_COUNTER_DP_ID  
,DPTD_COUNTER_CMBP_ID  
,DPTD_COUNTER_DEMAT_ACCT_NO  
,DPTD_CREATED_BY  
,DPTD_CREATED_DT  
,DPTD_LST_UPD_BY  
,DPTD_LST_UPD_DT  
,DPTD_DELETED_IND   
,dptd_trastm_cd  
,DPTD_DTLS_ID  
,DPTD_BOOKING_NARRATION  
,DPTD_BOOKING_TYPE  
,DPTD_CONVERTED_QTY  
,DPTD_REASON_CD  
,DPTD_STATUS  
,DPTD_INTERNAL_TRASTM  
,dptd_others_cl_name  
,DPTD_RMKS  
,DPTD_BROKERBATCH_NO  
,DPTD_BROKER_INTERNAL_REF_NO  
,DPTD_ACTION  
 )  
  SELECT  inserted.DPTD_ID  
,inserted.DPTD_DPAM_ID  
,inserted.DPTD_REQUEST_DT  
,inserted.DPTD_SLIP_NO  
,inserted.DPTD_ISIN  
,inserted.DPTD_BATCH_NO  
,inserted.DPTD_LINE_NO  
,inserted.DPTD_QTY  
,inserted.DPTD_INTERNAL_REF_NO  
,inserted.DPTD_TRANS_NO  
,inserted.DPTD_MKT_TYPE  
,inserted.DPTD_SETTLEMENT_NO  
,inserted.DPTD_EXECUTION_DT  
,inserted.DPTD_OTHER_SETTLEMENT_TYPE  
,inserted.DPTD_OTHER_SETTLEMENT_NO  
,inserted.DPTD_COUNTER_DP_ID  
,inserted.DPTD_COUNTER_CMBP_ID  
,inserted.DPTD_COUNTER_DEMAT_ACCT_NO  
,inserted.DPTD_CREATED_BY  
,inserted.DPTD_CREATED_DT  
,inserted.DPTD_LST_UPD_BY  
,inserted.DPTD_LST_UPD_DT  
,inserted.DPTD_DELETED_IND   
,inserted.dptd_trastm_cd  
,inserted.DPTD_DTLS_ID  
,inserted.DPTD_BOOKING_NARRATION  
,inserted.DPTD_BOOKING_TYPE  
,inserted.DPTD_CONVERTED_QTY  
,inserted.DPTD_REASON_CD  
,inserted.DPTD_STATUS  
,inserted.DPTD_INTERNAL_TRASTM  
,inserted.dptd_others_cl_name  
,inserted.DPTD_RMKS  
,inserted.DPTD_BROKERBATCH_NO  
,inserted.DPTD_BROKER_INTERNAL_REF_NO  
      , 'I'  
  FROM   inserted  
--    
END  
ELSE   
BEGIN--updated  
--  
  INSERT INTO DPTD_HST  
  (DPTD_ID  
,DPTD_DPAM_ID  
,DPTD_REQUEST_DT  
,DPTD_SLIP_NO  
,DPTD_ISIN  
,DPTD_BATCH_NO  
,DPTD_LINE_NO  
,DPTD_QTY  
,DPTD_INTERNAL_REF_NO  
,DPTD_TRANS_NO  
,DPTD_MKT_TYPE  
,DPTD_SETTLEMENT_NO  
,DPTD_EXECUTION_DT  
,DPTD_OTHER_SETTLEMENT_TYPE  
,DPTD_OTHER_SETTLEMENT_NO  
,DPTD_COUNTER_DP_ID  
,DPTD_COUNTER_CMBP_ID  
,DPTD_COUNTER_DEMAT_ACCT_NO  
,DPTD_CREATED_BY  
,DPTD_CREATED_DT  
,DPTD_LST_UPD_BY  
,DPTD_LST_UPD_DT  
,DPTD_DELETED_IND   
,dptd_trastm_cd  
,DPTD_DTLS_ID  
,DPTD_BOOKING_NARRATION  
,DPTD_BOOKING_TYPE  
,DPTD_CONVERTED_QTY  
,DPTD_REASON_CD  
,DPTD_STATUS  
,DPTD_INTERNAL_TRASTM  
,dptd_others_cl_name  
,DPTD_RMKS  
,DPTD_BROKERBATCH_NO  
,DPTD_BROKER_INTERNAL_REF_NO  
,DPTD_ACTION  
  )  
  SELECT  inserted.DPTD_ID  
,inserted.DPTD_DPAM_ID  
,inserted.DPTD_REQUEST_DT  
,inserted.DPTD_SLIP_NO  
,inserted.DPTD_ISIN  
,inserted.DPTD_BATCH_NO  
,inserted.DPTD_LINE_NO  
,inserted.DPTD_QTY  
,inserted.DPTD_INTERNAL_REF_NO  
,inserted.DPTD_TRANS_NO  
,inserted.DPTD_MKT_TYPE  
,inserted.DPTD_SETTLEMENT_NO  
,inserted.DPTD_EXECUTION_DT  
,inserted.DPTD_OTHER_SETTLEMENT_TYPE  
,inserted.DPTD_OTHER_SETTLEMENT_NO  
,inserted.DPTD_COUNTER_DP_ID  
,inserted.DPTD_COUNTER_CMBP_ID  
,inserted.DPTD_COUNTER_DEMAT_ACCT_NO  
,inserted.DPTD_CREATED_BY  
,inserted.DPTD_CREATED_DT  
,inserted.DPTD_LST_UPD_BY  
,inserted.DPTD_LST_UPD_DT  
,inserted.DPTD_DELETED_IND   
,inserted.dptd_trastm_cd  
,inserted.DPTD_DTLS_ID  
,inserted.DPTD_BOOKING_NARRATION  
,inserted.DPTD_BOOKING_TYPE  
,inserted.DPTD_CONVERTED_QTY  
,inserted.DPTD_REASON_CD  
,inserted.DPTD_STATUS  
,inserted.DPTD_INTERNAL_TRASTM  
,inserted.dptd_others_cl_name  
,inserted.DPTD_RMKS  
,inserted.DPTD_BROKERBATCH_NO  ,inserted.DPTD_BROKER_INTERNAL_REF_NO  
       , 'E'  
  FROM   inserted  
  --  
  IF @l_action = 'D'  
  BEGIN  
  --  
      DELETE dp_trx_dtls  
      FROM   dp_trx_dtls                  dptd  
           , inserted                    inserted  
      WHERE  dptd.dptd_id               = inserted.dptd_id  
      AND    inserted.dptd_deleted_ind = 0  
  --  
  END  
--     
END  
-------------trig_dptd---------------

GO
