-- Object: TRIGGER citrus_usr.trig_entac
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_entac  
ON entity_adr_conc  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(entac_deleted_ind) AND EXISTS(SELECT inserted.entac_ent_id FROM inserted WHERE inserted.entac_deleted_ind=0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
IF NOT EXISTS(SELECT deleted.entac_ent_id FROM deleted)   
BEGIN  
--  
  INSERT INTO entac_hst  
  (entac_ent_id  
  ,entac_acct_no  
  ,entac_concm_id  
  ,entac_concm_cd  
  ,entac_adr_conc_id  
  ,entac_created_by  
  ,entac_created_dt  
  ,entac_lst_upd_by  
  ,entac_lst_upd_dt  
  ,entac_deleted_ind  
  ,entac_action  
  )  
  SELECT inserted.entac_ent_id  
        ,inserted.entac_acct_no  
        ,inserted.entac_concm_id  
        ,inserted.entac_concm_cd  
        ,inserted.entac_adr_conc_id  
        ,inserted.entac_created_by  
        ,inserted.entac_created_dt  
        ,inserted.entac_lst_upd_by  
        ,inserted.entac_lst_upd_dt  
        ,inserted.entac_deleted_ind  
        ,'I'  
  FROM  inserted  
    
--  
END  
ELSE   
BEGIN  
--  
  INSERT INTO entac_hst  
  (entac_ent_id  
  ,entac_acct_no  
  ,entac_concm_id  
  ,entac_concm_cd  
  ,entac_adr_conc_id  
  ,entac_created_by  
  ,entac_created_dt  
  ,entac_lst_upd_by  
  ,entac_lst_upd_dt  
  ,entac_deleted_ind  
  ,entac_action  
  )  
  SELECT inserted.entac_ent_id  
        ,inserted.entac_acct_no  
        ,inserted.entac_concm_id  
        ,inserted.entac_concm_cd  
        ,inserted.entac_adr_conc_id  
        ,inserted.entac_created_by  
        ,inserted.entac_created_dt  
        ,inserted.entac_lst_upd_by  
        ,inserted.entac_lst_upd_dt  
        ,inserted.entac_deleted_ind  
        ,@l_action  
  FROM  inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE entity_adr_conc  
    FROM   entity_adr_conc        entac  
         , inserted               inserted  
    WHERE  entac.entac_ent_id   = inserted.entac_ent_id   
    AND    entac.entac_concm_id = inserted.entac_concm_id  
    AND    inserted.entac_deleted_ind = 0  
  
  --  
  END  
  
--     
END  
  
  
--account_adr_conc

GO
