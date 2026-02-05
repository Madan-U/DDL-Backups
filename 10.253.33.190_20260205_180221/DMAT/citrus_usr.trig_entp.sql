-- Object: TRIGGER citrus_usr.trig_entp
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER [citrus_usr].[trig_entp]  
ON [citrus_usr].[ENTITY_PROPERTIES]  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(entp_deleted_ind) AND EXISTS(SELECT inserted.entp_id FROM inserted WHERE inserted.entp_deleted_ind=0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
IF NOT EXISTS(SELECT deleted.entp_id FROM deleted)   
BEGIN  
--  
  INSERT INTO entp_hst  
  (entp_id  
  ,entp_ent_id  
  ,entp_acct_no  
  ,entp_entpm_prop_id  
  ,entp_entpm_cd  
  ,entp_value  
  ,entp_created_by  
  ,entp_created_dt  
  ,entp_lst_upd_by  
  ,entp_lst_upd_dt  
  ,entp_deleted_ind  
  ,entp_action  
  )  
  SELECT inserted.entp_id  
        ,inserted.entp_ent_id  
        ,inserted.entp_acct_no  
        ,inserted.entp_entpm_prop_id  
        ,inserted.entp_entpm_cd  
        ,inserted.entp_value  
        ,inserted.entp_created_by  
        ,inserted.entp_created_dt  
        ,inserted.entp_lst_upd_by  
        ,inserted.entp_lst_upd_dt  
        ,inserted.entp_deleted_ind  
        ,'I'  
  FROM  inserted  
    
--  
END  
ELSE  
BEGIN  
--  
  INSERT INTO entp_hst  
  (entp_id  
  ,entp_ent_id  
  ,entp_acct_no  
  ,entp_entpm_prop_id  
  ,entp_entpm_cd  
  ,entp_value  
  ,entp_created_by  
  ,entp_created_dt  
  ,entp_lst_upd_by  
  ,entp_lst_upd_dt  
  ,entp_deleted_ind  
  ,entp_action  
  )  
  SELECT inserted.entp_id  
        ,inserted.entp_ent_id  
        ,inserted.entp_acct_no  
        ,inserted.entp_entpm_prop_id  
        ,inserted.entp_entpm_cd  
        ,inserted.entp_value  
        ,inserted.entp_created_by  
        ,inserted.entp_created_dt  
        ,inserted.entp_lst_upd_by  
        ,inserted.entp_lst_upd_dt  
        ,inserted.entp_deleted_ind  
        ,@l_action  
  FROM  inserted  
    
  IF @l_action='D' AND NOT EXISTS(SELECT inserted.entp_id FROM inserted WHERE inserted.entp_entpm_cd =  'LC' OR RIGHT(inserted.entp_entpm_cd,7) =  'CUR_VAL')  
  BEGIN  
  --  
    DELETE entity_properties  
    FROM   entity_properties    entp  
         , inserted             inserted  
    WHERE  entp.entp_id       = inserted.entp_id  
    AND    inserted.entp_deleted_ind = 0  
  --  
  END  
  
--     
END  
  
  
--entity_property_dtls

GO
