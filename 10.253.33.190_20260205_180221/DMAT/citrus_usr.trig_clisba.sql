-- Object: TRIGGER citrus_usr.trig_clisba
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

 CREATE TRIGGER trig_clisba  
ON client_sub_accts  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(clisba_deleted_ind) and EXISTS(SELECT inserted.clisba_id FROM inserted WHERE inserted.clisba_deleted_ind = 0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
  
IF NOT EXISTS(SELECT deleted.clisba_id FROM deleted)   
BEGIN  
--  
  INSERT INTO clisba_hst  
  (clisba_id  
  ,clisba_crn_no  
  ,clisba_acct_no  
  ,clisba_no  
  ,clisba_name  
  ,clisba_excpm_id  
  ,clisba_access2  
  ,clisba_created_by  
  ,clisba_created_dt  
  ,clisba_lst_upd_by  
  ,clisba_lst_upd_dt  
  ,clisba_deleted_ind  
  ,clisba_action  
  )  
  SELECT inserted.clisba_id  
        ,inserted.clisba_crn_no  
        ,inserted.clisba_acct_no  
        ,inserted.clisba_no  
        ,inserted.clisba_name  
        ,inserted.clisba_excpm_id  
        ,inserted.clisba_access2  
        ,inserted.clisba_created_by  
        ,inserted.clisba_created_dt  
        ,inserted.clisba_lst_upd_by  
        ,inserted.clisba_lst_upd_dt  
        ,inserted.clisba_deleted_ind    
        ,'I'  
  FROM  inserted  
    
--  
  
END  
ELSE   
BEGIN  
--  
  INSERT INTO clisba_hst  
  (clisba_id  
  ,clisba_crn_no  
  ,clisba_acct_no  
  ,clisba_no  
  ,clisba_name  
  ,clisba_excpm_id  
  ,clisba_access2  
  ,clisba_created_by  
  ,clisba_created_dt  
  ,clisba_lst_upd_by  
  ,clisba_lst_upd_dt  
  ,clisba_deleted_ind  
  ,clisba_action  
  )  
  SELECT inserted.clisba_id  
        ,inserted.clisba_crn_no  
        ,inserted.clisba_acct_no  
        ,inserted.clisba_no  
        ,inserted.clisba_name  
        ,inserted.clisba_excpm_id  
        ,inserted.clisba_access2  
        ,inserted.clisba_created_by  
        ,inserted.clisba_created_dt  
        ,inserted.clisba_lst_upd_by  
        ,inserted.clisba_lst_upd_dt  
        ,inserted.clisba_deleted_ind   
        ,@l_action  
  FROM  inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE client_sub_accts  
    FROM   client_sub_accts              clisba  
         , inserted                      inserted  
    WHERE  clisba.clisba_id            = inserted.clisba_id   
    AND    inserted.clisba_deleted_ind = 0  
  --  
  END  
  
--     
END  
  
  
--client_dp_accts

GO
