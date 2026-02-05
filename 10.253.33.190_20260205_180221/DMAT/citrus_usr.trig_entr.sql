-- Object: TRIGGER citrus_usr.trig_entr
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_entr  
ON citrus_usr.ENTITY_RELATIONSHIP   
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(entr_deleted_ind) AND EXISTS(SELECT inserted.entr_crn_no FROM inserted WHERE inserted.entr_deleted_ind=0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
  
IF NOT EXISTS(SELECT deleted.entr_crn_no FROM deleted)   
BEGIN  
--  
  INSERT INTO entr_hst  
  (entr_crn_no  
  ,entr_acct_no  
  ,entr_sba  
  ,entr_ho  
  ,entr_re  
  ,entr_ar  
  ,entr_br  
  ,entr_sb  
  ,entr_dl  
  ,entr_rm  
  ,entr_dummy1  
  ,entr_dummy2  
  ,entr_dummy3  
  ,entr_dummy4  
  ,entr_dummy5  
  ,entr_dummy6  
  ,entr_dummy7  
  ,entr_dummy8  
  ,entr_dummy9  
  ,entr_dummy10  
  ,entr_from_dt  
  ,entr_to_dt  
  ,entr_created_by  
  ,entr_created_dt  
  ,entr_lst_upd_by  
  ,entr_lst_upd_dt  
  ,entr_deleted_ind  
  ,entr_action  
  )  
  SELECT inserted.entr_crn_no  
        ,inserted.entr_acct_no  
        ,inserted.entr_sba  
        ,inserted.entr_ho  
        ,inserted.entr_re  
        ,inserted.entr_ar  
        ,inserted.entr_br  
        ,inserted.entr_sb  
        ,inserted.entr_dl  
        ,inserted.entr_rm  
        ,inserted.entr_dummy1  
        ,inserted.entr_dummy2  
        ,inserted.entr_dummy3  
        ,inserted.entr_dummy4  
        ,inserted.entr_dummy5  
        ,inserted.entr_dummy6  
        ,inserted.entr_dummy7  
        ,inserted.entr_dummy8  
        ,inserted.entr_dummy9  
        ,inserted.entr_dummy10  
        ,inserted.entr_from_dt  
        ,inserted.entr_to_dt  
        ,inserted.entr_created_by  
        ,inserted.entr_created_dt  
        ,inserted.entr_lst_upd_by  
        ,inserted.entr_lst_upd_dt  
        ,inserted.entr_deleted_ind  
        ,'I'  
  FROM  inserted  
    
--  
END  
ELSE   
BEGIN  
--  
  INSERT INTO entr_hst  
  (entr_crn_no  
  ,entr_acct_no  
  ,entr_sba  
  ,entr_ho  
  ,entr_re  
  ,entr_ar  
  ,entr_br  
  ,entr_sb  
  ,entr_dl  
  ,entr_rm  
  ,entr_dummy1  
  ,entr_dummy2  
  ,entr_dummy3  
  ,entr_dummy4  
  ,entr_dummy5  
  ,entr_dummy6  
  ,entr_dummy7  
  ,entr_dummy8  
  ,entr_dummy9  
  ,entr_dummy10  
  ,entr_from_dt  
  ,entr_to_dt  
  ,entr_created_by  
  ,entr_created_dt  
  ,entr_lst_upd_by  
  ,entr_lst_upd_dt  
  ,entr_deleted_ind  
  ,entr_action  
  )  
  SELECT inserted.entr_crn_no  
        ,inserted.entr_acct_no  
        ,inserted.entr_sba  
        ,inserted.entr_ho  
        ,inserted.entr_re  
        ,inserted.entr_ar  
        ,inserted.entr_br  
        ,inserted.entr_sb  
        ,inserted.entr_dl  
        ,inserted.entr_rm  
        ,inserted.entr_dummy1  
        ,inserted.entr_dummy2  
        ,inserted.entr_dummy3  
        ,inserted.entr_dummy4  
        ,inserted.entr_dummy5  
        ,inserted.entr_dummy6  
        ,inserted.entr_dummy7  
        ,inserted.entr_dummy8  
        ,inserted.entr_dummy9  
        ,inserted.entr_dummy10  
        ,inserted.entr_from_dt  
        ,inserted.entr_to_dt  
        ,inserted.entr_created_by  
        ,inserted.entr_created_dt  
        ,inserted.entr_lst_upd_by  
        ,inserted.entr_lst_upd_dt  
        ,inserted.entr_deleted_ind  
        ,@l_action  
  FROM  inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE entity_relationship  
    FROM   entity_relationship   entr  
         , inserted              inserted    
    WHERE  entr.entr_crn_no    = inserted.entr_crn_no    
    AND    entr.entr_sba       = inserted.entr_sba    
    AND    entr.entr_acct_no   = inserted.entr_acct_no    
    AND    entr.entr_from_dt   = inserted.entr_from_dt  
    AND    inserted.entr_deleted_ind = 0  
        
  --  
  END  
  
--     
END  
  
--entity_properties

GO
