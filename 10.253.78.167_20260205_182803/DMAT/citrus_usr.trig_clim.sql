-- Object: TRIGGER citrus_usr.trig_clim
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--1.client_mstr  
--2.entity_mstr  
--3.client_accounts  
--client_sub_accts  
--client_dp_accts  
--client_bank_accts  
--entity_relationship  
--entity_properties  
--entity_property_dtls  
--account_properties  
--account_property_dtls  
--account_documents  
--client_documents  
--entity_adr_conc  
--account_adr_conc  
--actions  
--entity_roles  
--login_names  
--roles  
--roles_actions  
--roles_components  
--screens  
  
--1.client_mstr  
  
CREATE TRIGGER trig_clim  
ON client_mstr  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(clim_deleted_ind) and EXISTS(SELECT clim_crn_no FROM inserted WHERE inserted.clim_deleted_ind = 0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
IF NOT EXISTS(SELECT deleted.clim_crn_no FROM deleted)   
BEGIN  
--  
  INSERT INTO clim_hst  
  (clim_crn_no  
  ,clim_name1  
  ,clim_name2  
  ,clim_name3  
  ,clim_short_name  
  ,clim_gender  
  ,clim_dob  
  ,clim_enttm_cd  
  ,clim_stam_cd  
  ,clim_clicm_cd  
  ,clim_rmks  
  ,clim_created_by  
  ,clim_created_dt  
  ,clim_lst_upd_by  
  ,clim_lst_upd_dt  
  ,clim_deleted_ind  
  ,clim_action  
  ,clim_sbum_id  
  )  
  SELECT inserted.clim_crn_no  
        ,inserted.clim_name1  
        ,inserted.clim_name2  
        ,inserted.clim_name3  
        ,inserted.clim_short_name  
        ,inserted.clim_gender  
        ,inserted.clim_dob  
        ,inserted.clim_enttm_cd  
        ,inserted.clim_stam_cd  
        ,inserted.clim_clicm_cd  
        ,inserted.clim_rmks  
        ,inserted.clim_created_by  
        ,inserted.clim_created_dt  
        ,inserted.clim_lst_upd_by  
        ,inserted.clim_lst_upd_dt  
        ,inserted.clim_deleted_ind  
        ,'I'  
        ,inserted.clim_sbum_id  
  FROM  inserted  
    
--  
  
END  
ELSE  
BEGIN  
--  
  INSERT INTO clim_hst  
  (clim_crn_no  
  ,clim_name1  
  ,clim_name2  
  ,clim_name3  
  ,clim_short_name  
  ,clim_gender  
  ,clim_dob  
  ,clim_enttm_cd  
  ,clim_stam_cd  
  ,clim_clicm_cd  
  ,clim_rmks  
  ,clim_created_by  
  ,clim_created_dt  
  ,clim_lst_upd_by  
  ,clim_lst_upd_dt  
  ,clim_deleted_ind  
  ,clim_action  
  ,clim_sbum_id  
  )  
  SELECT inserted.clim_crn_no  
        ,inserted.clim_name1  
        ,inserted.clim_name2  
        ,inserted.clim_name3  
        ,inserted.clim_short_name  
        ,inserted.clim_gender  
        ,inserted.clim_dob  
        ,inserted.clim_enttm_cd  
        ,inserted.clim_stam_cd  
        ,inserted.clim_clicm_cd  
        ,inserted.clim_rmks  
        ,inserted.clim_created_by  
        ,inserted.clim_created_dt  
        ,inserted.clim_lst_upd_by  
        ,inserted.clim_lst_upd_dt  
        ,inserted.clim_deleted_ind  
        ,@l_action  
        ,inserted.clim_sbum_id  
  FROM inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE client_mstr  
    FROM   client_mstr                 clim  
         , inserted                    inserted  
    WHERE  clim.clim_crn_no          = inserted.clim_crn_no  
    AND    inserted.clim_deleted_ind = 0  
  --  
  END  
    
--     
END  
  
--2.entity_mstr

GO
