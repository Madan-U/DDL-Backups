-- Object: TRIGGER citrus_usr.trig_compm
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

-------------trig_compm--------------      
CREATE TRIGGER trig_compm      
ON company_mstr      
FOR INSERT,UPDATE      
AS      
DECLARE @l_action VARCHAR(20)      
--      
IF UPDATE(compm_deleted_ind)      
BEGIN      
--      
  IF EXISTS(SELECT inserted.compm_id       
            FROM   inserted       
            WHERE  inserted.compm_deleted_ind  = 0      
           )      
  BEGIN      
  --      
    SET @l_action = 'D'      
  --        
  END        
--      
END      
ELSE      
BEGIN      
      
  SET @l_action = 'E'      
      
END      
--      
IF NOT EXISTS(SELECT deleted.compm_id FROM deleted)       
BEGIN--insert      
--      
  INSERT INTO compm_hst       
  ( COMPM_ID     
,COMPM_NAME1     
,COMPM_SHORT_NAME     
,COMPM_TYPE     
,COMPM_NSECM_MEM_CD     
,COMPM_NSEFO_MEM_CD     
,COMPM_BSECM_MEM_CD     
,COMPM_BSEFO_MEM_CD     
,COMPM_Ncdex_MEM_CD     
,COMPM_mcx_MEM_CD     
,COMPM_dgcx_MEM_CD     
,COMPM_nmc_MEM_CD     
,COMPM_nsdl_dpid     
,COMPM_cdsl_dpid     
,COMPM_PAN_NO     
,COMPM_SERTAX_REGNO     
,COMPM_SEBI_REG_NO     
,COMPM_RMKS           
,COMPM_CREATED_BY     
,COMPM_CREATED_DT     
,COMPM_LST_UPD_BY     
,COMPM_LST_UPD_DT     
,COMPM_DELETED_IND    
  , compm_action      
  )      
  SELECT inserted.COMPM_ID     
,inserted.COMPM_NAME1     
,inserted.COMPM_SHORT_NAME     
,inserted.COMPM_TYPE     
,inserted.COMPM_NSECM_MEM_CD     
,inserted.COMPM_NSEFO_MEM_CD     
,inserted.COMPM_BSECM_MEM_CD     
,inserted.COMPM_BSEFO_MEM_CD     
,inserted.COMPM_Ncdex_MEM_CD     
,inserted.COMPM_mcx_MEM_CD     
,inserted.COMPM_dgcx_MEM_CD     
,inserted.COMPM_nmc_MEM_CD     
,inserted.COMPM_nsdl_dpid     
,inserted.COMPM_cdsl_dpid     
,inserted.COMPM_PAN_NO     
,inserted.COMPM_SERTAX_REGNO     
,inserted.COMPM_SEBI_REG_NO     
,inserted.COMPM_RMKS           
,inserted.COMPM_CREATED_BY     
,inserted.COMPM_CREATED_DT     
,inserted.COMPM_LST_UPD_BY     
,inserted.COMPM_LST_UPD_DT     
,inserted.COMPM_DELETED_IND     
       , 'I'      
  FROM   inserted      
--        
END      
ELSE       
BEGIN--updated      
--      
  INSERT INTO compm_hst       
  ( COMPM_ID     
,COMPM_NAME1     
,COMPM_SHORT_NAME     
,COMPM_TYPE     
,COMPM_NSECM_MEM_CD     
,COMPM_NSEFO_MEM_CD     
,COMPM_BSECM_MEM_CD     
,COMPM_BSEFO_MEM_CD     
,COMPM_Ncdex_MEM_CD     
,COMPM_mcx_MEM_CD     
,COMPM_dgcx_MEM_CD     
,COMPM_nmc_MEM_CD     
,COMPM_nsdl_dpid     
,COMPM_cdsl_dpid     
,COMPM_PAN_NO     
,COMPM_SERTAX_REGNO     
,COMPM_SEBI_REG_NO     
,COMPM_RMKS           
,COMPM_CREATED_BY     
,COMPM_CREATED_DT     
,COMPM_LST_UPD_BY     
,COMPM_LST_UPD_DT     
,COMPM_DELETED_IND    
  , compm_action      
  )      
  SELECT inserted.COMPM_ID     
,inserted.COMPM_NAME1     
,inserted.COMPM_SHORT_NAME     
,inserted.COMPM_TYPE     
,inserted.COMPM_NSECM_MEM_CD     
,inserted.COMPM_NSEFO_MEM_CD     
,inserted.COMPM_BSECM_MEM_CD     
,inserted.COMPM_BSEFO_MEM_CD     
,inserted.COMPM_Ncdex_MEM_CD     
,inserted.COMPM_mcx_MEM_CD     
,inserted.COMPM_dgcx_MEM_CD     
,inserted.COMPM_nmc_MEM_CD     
,inserted.COMPM_nsdl_dpid     
,inserted.COMPM_cdsl_dpid     
,inserted.COMPM_PAN_NO     
,inserted.COMPM_SERTAX_REGNO     
,inserted.COMPM_SEBI_REG_NO     
,inserted.COMPM_RMKS           
,inserted.COMPM_CREATED_BY     
,inserted.COMPM_CREATED_DT     
,inserted.COMPM_LST_UPD_BY     
,inserted.COMPM_LST_UPD_DT     
,inserted.COMPM_DELETED_IND     
       ,  @l_action      
  FROM   inserted      
  --      
  IF @l_action = 'D'      
  BEGIN      
  --      
    DELETE company_mstr      
    FROM   company_mstr                 compm      
         , inserted                     inserted      
    WHERE  compm.compm_id             = inserted.compm_id      
    AND    inserted.compm_deleted_ind = 0      
  --      
  END      
--         
END      
-----    
--------trig_compm-------------

GO
