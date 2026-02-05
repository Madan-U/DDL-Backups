-- Object: TRIGGER citrus_usr.trig_clidpa
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_clidpa  
ON client_dp_accts  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(clidpa_deleted_ind) AND EXISTS(SELECT inserted.clidpa_deleted_ind FROM inserted WHERE inserted.clidpa_deleted_ind=0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
IF NOT EXISTS(SELECT deleted.clidpa_dpm_id FROM deleted)   
BEGIN  
--  
  INSERT INTO clidpa_hst  
  (clidpa_dpm_id  
  ,clidpa_clisba_id  
  ,clidpa_compm_id  
  ,clidpa_dp_id  
  ,clidpa_name  
  ,clidpa_flg  
  ,clidpa_poa_type  
  ,clidpa_created_by  
  ,clidpa_created_dt  
  ,clidpa_lst_upd_by  
  ,clidpa_lst_upd_dt  
  ,clidpa_deleted_ind  
  ,clidpa_action  
  )  
  SELECT inserted.clidpa_dpm_id  
        ,inserted.clidpa_clisba_id  
        ,inserted.clidpa_compm_id  
        ,inserted.clidpa_dp_id  
        ,inserted.clidpa_name  
        ,inserted.clidpa_flg  
        ,inserted.clidpa_poa_type  
        ,inserted.clidpa_created_by  
        ,inserted.clidpa_created_dt  
        ,inserted.clidpa_lst_upd_by  
        ,inserted.clidpa_lst_upd_dt  
        ,inserted.clidpa_deleted_ind  
        ,'I'  
  FROM  inserted  
    
--  
END  
BEGIN  
--  
  INSERT INTO clidpa_hst  
  (clidpa_dpm_id  
  ,clidpa_clisba_id  
  ,clidpa_compm_id  
  ,clidpa_dp_id  
  ,clidpa_name  
  ,clidpa_flg  
  ,clidpa_poa_type  
  ,clidpa_created_by  
  ,clidpa_created_dt  
  ,clidpa_lst_upd_by  
  ,clidpa_lst_upd_dt  
  ,clidpa_deleted_ind  
  ,clidpa_action  
  )  
  SELECT inserted.clidpa_dpm_id  
        ,inserted.clidpa_clisba_id  
        ,inserted.clidpa_compm_id  
        ,inserted.clidpa_dp_id  
        ,inserted.clidpa_name  
        ,inserted.clidpa_flg  
        ,inserted.clidpa_poa_type  
        ,inserted.clidpa_created_by  
        ,inserted.clidpa_created_dt  
        ,inserted.clidpa_lst_upd_by  
        ,inserted.clidpa_lst_upd_dt  
        ,inserted.clidpa_deleted_ind  
        ,@l_action  
  FROM  inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE client_dp_accts  
    FROM   client_dp_accts               clidpa  
         , inserted                      inserted  
    WHERE  clidpa.clidpa_dpm_id        = inserted.clidpa_dpm_id  
    AND    clidpa.clidpa_compm_id      = inserted.clidpa_compm_id  
    AND    clidpa.clidpa_dp_id         = inserted.clidpa_dp_id  
    AND    clidpa.clidpa_clisba_id     = inserted.clidpa_clisba_id  
    AND    inserted.clidpa_deleted_ind = 0  
  
  --  
  END  
  
--     
END

GO
