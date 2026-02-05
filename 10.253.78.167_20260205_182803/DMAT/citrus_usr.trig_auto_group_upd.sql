-- Object: TRIGGER citrus_usr.trig_auto_group_upd
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_auto_group_upd  
ON account_properties    
FOR INSERT,UPDATE    
AS     
    
DECLARE @l_action VARCHAR(20)    
SET @l_action = 'E'    
IF UPDATE(accp_value) AND EXISTS(SELECT inserted.accp_id FROM inserted WHERE inserted.accp_deleted_ind =1 and inserted.accp_accpm_prop_cd = 'acc_group_code')    
BEGIN    
--    
    delete  accgm  
    from    account_group_mapping accgm  
           ,inserted  
    where   inserted.accp_clisba_id = accgm.dpam_id  
      
    insert account_group_mapping  
    (dpam_id  
    ,Group_cd  
    ,Created_dt  
    ,created_by  
    ,lst_upd_dt  
    ,lst_upd_by  
    ,deleted_ind  
    )     
    select inserted.accp_clisba_id  
    ,inserted.accp_value  
    ,inserted.accp_created_dt  
    ,inserted.accp_created_by  
    ,inserted.accp_lst_upd_dt  
    ,inserted.accp_lst_upd_by  
    ,1   
    from inserted  
       
--       
END    
    
    
--account_property_dtls

GO
