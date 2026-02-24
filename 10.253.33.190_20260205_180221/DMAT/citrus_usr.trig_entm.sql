-- Object: TRIGGER citrus_usr.trig_entm
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_entm  
ON entity_mstr  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(entm_deleted_ind) and EXISTS(SELECT inserted.entm_id FROM inserted WHERE inserted.entm_deleted_ind = 0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
  
IF NOT EXISTS(SELECT deleted.entm_id FROM deleted)   
BEGIN  
--  
  INSERT INTO entm_hst  
  (entm_id  
  ,entm_name1  
  ,entm_name2  
  ,entm_name3  
  ,entm_short_name  
  ,entm_enttm_cd  
  ,entm_clicm_cd  
  ,entm_parent_id  
  ,entm_rmks  
  ,entm_created_by  
  ,entm_created_dt  
  ,entm_lst_upd_by  
  ,entm_lst_upd_dt  
  ,entm_deleted_ind  
  ,entm_action  
  )  
  SELECT inserted.entm_id  
        ,inserted.entm_name1  
        ,inserted.entm_name2  
        ,inserted.entm_name3  
        ,inserted.entm_short_name  
        ,inserted.entm_enttm_cd  
        ,inserted.entm_clicm_cd  
        ,inserted.entm_parent_id  
        ,inserted.entm_rmks  
        ,inserted.entm_created_by  
        ,inserted.entm_created_dt  
        ,inserted.entm_lst_upd_by  
        ,inserted.entm_lst_upd_dt  
        ,inserted.entm_deleted_ind  
        ,'I'  
  FROM  inserted  
    
--  
END  
ELSE   
BEGIN  
--  
  INSERT INTO entm_hst  
  (entm_id  
  ,entm_name1  
  ,entm_name2  
  ,entm_name3  
  ,entm_short_name  
  ,entm_enttm_cd  
  ,entm_clicm_cd  
  ,entm_parent_id  
  ,entm_rmks  
  ,entm_created_by  
  ,entm_created_dt  
  ,entm_lst_upd_by  
  ,entm_lst_upd_dt  
  ,entm_deleted_ind  
  ,entm_action  
  )  
  SELECT inserted.entm_id  
        ,inserted.entm_name1  
        ,inserted.entm_name2  
        ,inserted.entm_name3  
        ,inserted.entm_short_name  
        ,inserted.entm_enttm_cd  
        ,inserted.entm_clicm_cd  
        ,inserted.entm_parent_id  
        ,inserted.entm_rmks  
        ,inserted.entm_created_by  
        ,inserted.entm_created_dt  
        ,inserted.entm_lst_upd_by  
        ,inserted.entm_lst_upd_dt  
        ,inserted.entm_deleted_ind  
        ,@l_action  
  FROM  inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE entity_mstr  
    FROM   entity_mstr                 entm  
         , inserted                    inserted  
    WHERE  entm.entm_id              = inserted.entm_id  
    AND    inserted.entm_deleted_ind = 0  
  --  
  END  
    
--     
END  
  
  
--3.client_accounts

GO
