-- Object: TRIGGER citrus_usr.trig_accac
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_accac  
ON account_adr_conc  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(accac_deleted_ind) AND EXISTS(SELECT inserted.accac_clisba_id FROM inserted WHERE inserted.accac_deleted_ind=0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
  
IF NOT EXISTS(SELECT deleted.accac_clisba_id FROM deleted)   
BEGIN  
--  
  INSERT INTO accac_hst  
  (accac_clisba_id  
  ,accac_acct_no  
  ,accac_acct_type  
  ,accac_concm_id  
  ,accac_adr_conc_id  
  ,accac_created_by  
  ,accac_created_dt  
  ,accac_lst_upd_by  
  ,accac_lst_upd_dt  
  ,accac_deleted_ind  
  ,accac_action  
  )  
  SELECT inserted.accac_clisba_id  
        ,inserted.accac_acct_no  
        ,inserted.accac_acct_type  
        ,inserted.accac_concm_id  
        ,inserted.accac_adr_conc_id  
        ,inserted.accac_created_by  
        ,inserted.accac_created_dt  
        ,inserted.accac_lst_upd_by  
        ,inserted.accac_lst_upd_dt  
        ,inserted.accac_deleted_ind  
        ,'I'  
  FROM  inserted  
    
--  
END  
ELSE  
BEGIN  
--  
  INSERT INTO accac_hst  
  (accac_clisba_id  
  ,accac_acct_no  
  ,accac_acct_type  
  ,accac_concm_id  
  ,accac_adr_conc_id  
  ,accac_created_by  
  ,accac_created_dt  
  ,accac_lst_upd_by  
  ,accac_lst_upd_dt  
  ,accac_deleted_ind  
  ,accac_action  
  )  
  SELECT inserted.accac_clisba_id  
        ,inserted.accac_acct_no  
        ,inserted.accac_acct_type  
        ,inserted.accac_concm_id  
        ,inserted.accac_adr_conc_id  
        ,inserted.accac_created_by  
        ,inserted.accac_created_dt  
        ,inserted.accac_lst_upd_by  
        ,inserted.accac_lst_upd_dt  
        ,inserted.accac_deleted_ind  
        ,@l_action  
  FROM  inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE account_adr_conc  
    FROM   account_adr_conc                 accac  
         , inserted                         inserted  
    WHERE  accac.accac_clisba_id          = inserted.accac_clisba_id   
    AND    accac.accac_concm_id           = inserted.accac_concm_id  
    AND    accac.accac_acct_type          = inserted.accac_acct_type  
    AND    ISNULL(accac.accac_acct_no,'') = ISNULL(inserted.accac_acct_no,'')   
    AND    inserted.accac_deleted_ind     = 0   
  --  
  END  
  
--     
END  
  
  
/*ACTIONS  
ENTITY_ROLES  
LOGIN_NAMES  
ROLES  
ROLES_ACTIONS  
ROLES_COMPONENTS  
SCREENS  
*/  
  
--actions

GO
