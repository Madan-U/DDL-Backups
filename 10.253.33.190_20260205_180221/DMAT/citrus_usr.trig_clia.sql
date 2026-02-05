-- Object: TRIGGER citrus_usr.trig_clia
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_clia  
ON client_accounts  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(clia_deleted_ind) and EXISTS(SELECT inserted.clia_crn_no FROM inserted WHERE inserted.clia_deleted_ind = 0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
  
IF NOT EXISTS(SELECT deleted.clia_acct_no, deleted.clia_crn_no FROM deleted)   
BEGIN  
--  
  INSERT INTO clia_hst  
  (clia_crn_no  
  ,clia_acct_no  
  ,clia_access1  
  ,clia_status1  
  ,clia_access2  
  ,clia_status2  
  ,clia_created_by  
  ,clia_created_dt  
  ,clia_lst_upd_by  
  ,clia_lst_upd_dt  
  ,clia_deleted_ind  
  ,clia_action  
  )  
  SELECT inserted.clia_crn_no  
        ,inserted.clia_acct_no  
        ,inserted.clia_access1  
        ,inserted.clia_status1  
        ,inserted.clia_access2  
        ,inserted.clia_status2  
        ,inserted.clia_created_by  
        ,inserted.clia_created_dt  
        ,inserted.clia_lst_upd_by  
        ,inserted.clia_lst_upd_dt  
        ,inserted.clia_deleted_ind  
        ,'I'  
  FROM  inserted  
    
--  
END  
ELSE   
BEGIN  
--  
  INSERT INTO clia_hst  
  (clia_crn_no  
  ,clia_acct_no  
  ,clia_access1  
  ,clia_status1  
  ,clia_access2  
  ,clia_status2  
  ,clia_created_by  
  ,clia_created_dt  
  ,clia_lst_upd_by  
  ,clia_lst_upd_dt  
  ,clia_deleted_ind  
  ,clia_action  
  )  
  SELECT inserted.clia_crn_no  
        ,inserted.clia_acct_no  
        ,inserted.clia_access1  
        ,inserted.clia_status1  
        ,inserted.clia_access2  
        ,inserted.clia_status2  
        ,inserted.clia_created_by  
        ,inserted.clia_created_dt  
        ,inserted.clia_lst_upd_by  
        ,inserted.clia_lst_upd_dt  
        ,inserted.clia_deleted_ind  
        ,@l_action  
  FROM  inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE client_accounts  
    FROM   client_accounts             clia  
         , inserted                    inserted  
    WHERE  clia.clia_crn_no               = inserted.clia_crn_no  
    AND    clia.clia_acct_no              = inserted.clia_acct_no  
    AND    inserted.clia_deleted_ind = 0   
  
  --  
  END  
  
--     
END  
  
  
--client_sub_accts

GO
