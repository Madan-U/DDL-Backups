-- Object: TRIGGER citrus_usr.trig_cliba
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_cliba  
ON citrus_usr.CLIENT_BANK_ACCTS  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(cliba_deleted_ind) AND EXISTS(SELECT inserted.cliba_banm_id FROM inserted WHERE inserted.cliba_deleted_ind=0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
IF NOT EXISTS(SELECT deleted.cliba_banm_id FROM deleted)   
BEGIN  
--  
  INSERT INTO cliba_hst  
  (cliba_banm_id  
  ,cliba_clisba_id  
  ,cliba_compm_id  
  ,cliba_ac_no  
  ,cliba_ac_type  
  ,cliba_ac_name  
  ,cliba_flg  
  ,cliba_created_by  
  ,cliba_created_dt  
  ,cliba_lst_upd_by  
  ,cliba_lst_upd_dt  
  ,cliba_deleted_ind  
  ,cliba_action  
  )  
  SELECT inserted.cliba_banm_id  
        ,inserted.cliba_clisba_id  
        ,inserted.cliba_compm_id  
        ,inserted.cliba_ac_no  
        ,inserted.cliba_ac_type  
        ,inserted.cliba_ac_name  
        ,inserted.cliba_flg  
        ,inserted.cliba_created_by  
        ,inserted.cliba_created_dt  
        ,inserted.cliba_lst_upd_by  
        ,inserted.cliba_lst_upd_dt  
        ,inserted.cliba_deleted_ind  
        ,'I'  
  FROM  inserted  
    
--  
END  
ELSE   
BEGIN  
--  
  INSERT INTO cliba_hst  
  (cliba_banm_id  
  ,cliba_clisba_id  
  ,cliba_compm_id  
  ,cliba_ac_no  
  ,cliba_ac_type  
  ,cliba_ac_name  
  ,cliba_flg  
  ,cliba_created_by  
  ,cliba_created_dt  
  ,cliba_lst_upd_by  
  ,cliba_lst_upd_dt  
  ,cliba_deleted_ind  
  ,cliba_action  
  )  
  SELECT inserted.cliba_banm_id  
        ,inserted.cliba_clisba_id  
        ,inserted.cliba_compm_id  
        ,inserted.cliba_ac_no  
        ,inserted.cliba_ac_type  
        ,inserted.cliba_ac_name  
        ,inserted.cliba_flg  
        ,inserted.cliba_created_by  
        ,inserted.cliba_created_dt  
        ,inserted.cliba_lst_upd_by  
        ,inserted.cliba_lst_upd_dt  
        ,inserted.cliba_deleted_ind  
        ,@l_action  
  FROM  inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE client_bank_accts  
    FROM   client_bank_accts         cliba  
         , inserted                  inserted  
    WHERE  cliba.cliba_banm_id     = inserted.cliba_banm_id  
    AND    cliba.cliba_compm_id    = inserted.cliba_compm_id  
    AND    cliba.cliba_ac_no       = inserted.cliba_ac_no  
    AND    cliba.cliba_clisba_id   = inserted.cliba_clisba_id  
    AND    inserted.cliba_deleted_ind = 0  
  --  
  END  
  
--     
END

GO
