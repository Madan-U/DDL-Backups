-- Object: TRIGGER citrus_usr.trig_dppd
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

  
--  
  
--  
CREATE TRIGGER [trig_dppd]    
ON [citrus_usr].[DP_POA_DTLS]    
FOR INSERT,UPDATE    
AS    
DECLARE @l_action VARCHAR(20)    
--    
IF UPDATE(dppd_deleted_ind)    
BEGIN    
--    
  IF EXISTS(SELECT inserted.dppd_dpam_id     
            FROM   inserted     
            WHERE  inserted.dppd_deleted_ind  = 0    
           )    
  BEGIN    
  --    
    SET @l_action = 'D'    
  --      
  END      
--    
END    
--    
IF NOT EXISTS(SELECT deleted.dppd_dpam_id FROM deleted)     
BEGIN--insert    
--    
  INSERT INTO dppd_hst    
  (DPPD_ID  
,DPPD_DPAM_ID  
,DPPD_HLD  
,DPPD_POA_TYPE  
,DPPD_FNAME  
,DPPD_MNAME  
,DPPD_LNAME  
,DPPD_FTHNAME  
,DPPD_DOB  
,DPPD_PAN_NO  
,DPPD_GENDER  
,DPPD_CREATED_BY  
,DPPD_CREATED_DT  
,DPPD_LST_UPD_BY  
,DPPD_LST_UPD_DT  
,DPPD_DELETED_IND  
,dppd_action  
  )    
  SELECT inserted.DPPD_ID  
,inserted.DPPD_DPAM_ID  
,inserted.DPPD_HLD  
,inserted.DPPD_POA_TYPE  
,inserted.DPPD_FNAME  
,inserted.DPPD_MNAME  
,inserted.DPPD_LNAME  
,inserted.DPPD_FTHNAME  
,inserted.DPPD_DOB  
,inserted.DPPD_PAN_NO  
,inserted.DPPD_GENDER  
,inserted.DPPD_CREATED_BY  
,inserted.DPPD_CREATED_DT  
,inserted.DPPD_LST_UPD_BY  
,inserted.DPPD_LST_UPD_DT  
,inserted.DPPD_DELETED_IND  
,'I'  
  FROM inserted    
--      
END    
ELSE     
BEGIN--updated    
--    
  INSERT INTO dppd_hst    
  (DPPD_ID  
,DPPD_DPAM_ID  
,DPPD_HLD  
,DPPD_POA_TYPE  
,DPPD_FNAME  
,DPPD_MNAME  
,DPPD_LNAME  
,DPPD_FTHNAME  
,DPPD_DOB  
,DPPD_PAN_NO  
,DPPD_GENDER  
,DPPD_CREATED_BY  
,DPPD_CREATED_DT  
,DPPD_LST_UPD_BY  
,DPPD_LST_UPD_DT  
,DPPD_DELETED_IND  
,dppd_action  
  )    
     SELECT inserted.DPPD_ID  
,inserted.DPPD_DPAM_ID  
,inserted.DPPD_HLD  
,inserted.DPPD_POA_TYPE  
,inserted.DPPD_FNAME  
,inserted.DPPD_MNAME  
,inserted.DPPD_LNAME  
,inserted.DPPD_FTHNAME  
,inserted.DPPD_DOB  
,inserted.DPPD_PAN_NO  
,inserted.DPPD_GENDER  
,inserted.DPPD_CREATED_BY  
,inserted.DPPD_CREATED_DT  
,inserted.DPPD_LST_UPD_BY  
,inserted.DPPD_LST_UPD_DT  
,inserted.DPPD_DELETED_IND  
,'E'  
  FROM inserted    
  --    
  IF @l_action = 'D'    
  BEGIN    
  --    
    DELETE dppd    
    FROM   dp_poa_dtls             dppd     
        ,  inserted                    inserted    
    WHERE  dppd.dppd_dpam_id         = inserted.dppd_dpam_id   
    and     dppd.dppd_id         = inserted.dppd_id    
    AND    inserted.dppd_deleted_ind = 0    
  --    
  END    
--       
END

GO
