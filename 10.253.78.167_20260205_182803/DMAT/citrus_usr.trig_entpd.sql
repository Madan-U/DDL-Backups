-- Object: TRIGGER citrus_usr.trig_entpd
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_entpd  
ON entity_property_dtls  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(entpd_deleted_ind) AND EXISTS(SELECT inserted.entpd_entp_id FROM inserted WHERE inserted.entpd_deleted_ind=0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
  
IF NOT EXISTS(SELECT deleted.entpd_entp_id FROM deleted)   
BEGIN  
--  
  INSERT INTO entpd_hst  
  (entpd_entp_id  
  ,entpd_entdm_id  
  ,entpd_entdm_cd  
  ,entpd_value  
  ,entpd_created_by  
  ,entpd_created_dt  
  ,entpd_lst_upd_by  
  ,entpd_lst_upd_dt  
  ,entpd_deleted_ind  
  ,entpd_action  
  )  
  SELECT inserted.entpd_entp_id  
        ,inserted.entpd_entdm_id  
        ,inserted.entpd_entdm_cd  
        ,inserted.entpd_value  
        ,inserted.entpd_created_by  
        ,inserted.entpd_created_dt  
        ,inserted.entpd_lst_upd_by  
        ,inserted.entpd_lst_upd_dt  
        ,inserted.entpd_deleted_ind  
        ,'I'  
  FROM  inserted  
    
--  
END  
ELSE   
BEGIN  
--  
  INSERT INTO entpd_hst  
  (entpd_entp_id  
  ,entpd_entdm_id  
  ,entpd_entdm_cd  
  ,entpd_value  
  ,entpd_created_by  
  ,entpd_created_dt  
  ,entpd_lst_upd_by  
  ,entpd_lst_upd_dt  
  ,entpd_deleted_ind  
  ,entpd_action  
  )  
  SELECT inserted.entpd_entp_id  
        ,inserted.entpd_entdm_id  
        ,inserted.entpd_entdm_cd  
        ,inserted.entpd_value  
        ,inserted.entpd_created_by  
        ,inserted.entpd_created_dt  
        ,inserted.entpd_lst_upd_by  
        ,inserted.entpd_lst_upd_dt  
        ,inserted.entpd_deleted_ind  
        ,@l_action  
  FROM  inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE entity_property_dtls  
      
    FROM   entity_property_dtls    entpd   
         , inserted                inserted    
    WHERE  entpd.entpd_entdm_id  = inserted.entpd_entdm_id     
    AND    entpd.entpd_entp_id   = inserted.entpd_entp_id     
    AND    inserted.entpd_deleted_ind = 0  
  --  
  END  
  
--     
END  
  
  
--account_properties

GO
