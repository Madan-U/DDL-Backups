-- Object: TRIGGER citrus_usr.trig_bitrm
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

-------------trig_bitrm--------------  
CREATE TRIGGER trig_bitrm  
ON bitmap_ref_mstr  
FOR INSERT,UPDATE  
AS  
DECLARE @l_action VARCHAR(20)  
--  
SET @l_action = 'E'  
--  
IF UPDATE(bitrm_deleted_ind)  
BEGIN  
--  
  IF EXISTS(SELECT inserted.bitrm_id   
            FROM   inserted   
            WHERE  inserted.bitrm_deleted_ind  = 0  
           )  
  BEGIN  
  --  
    SET @l_action = 'D'  
  --    
  END    
--  
END  
--ELSE  
--BEGIN  
--  
--  SET @l_action = 'E'  
--  
--END  
--  
IF NOT EXISTS(SELECT deleted.bitrm_id FROM deleted)   
BEGIN--insert  
--  
  INSERT INTO bitrm_hst  
  ( bitrm_id  
  , bitrm_parent_cd  
  , bitrm_child_cd  
  , bitrm_bit_location  
  , bitrm_values  
  , bitrm_tab_type  
  , bitrm_created_by  
  , bitrm_created_dt  
  , bitrm_lst_upd_by  
  , bitrm_lst_upd_dt  
  , bitrm_deleted_ind  
  , bitrm_action  
  )  
  SELECT inserted.bitrm_id  
       , inserted.bitrm_parent_cd  
       , inserted.bitrm_child_cd  
       , inserted.bitrm_bit_location  
       , inserted.bitrm_values  
       , inserted.bitrm_tab_type  
       , inserted.bitrm_created_by  
       , inserted.bitrm_created_dt  
       , inserted.bitrm_lst_upd_by  
       , inserted.bitrm_lst_upd_dt  
       , inserted.bitrm_deleted_ind  
       , 'I'  
  FROM   inserted  
--    
END  
ELSE   
BEGIN--updated  
--  
  INSERT INTO bitrm_hst  
  ( bitrm_id  
  , bitrm_parent_cd  
  , bitrm_child_cd  
  , bitrm_bit_location  
  , bitrm_values  
  , bitrm_tab_type  
  , bitrm_created_by  
  , bitrm_created_dt  
  , bitrm_lst_upd_by  
  , bitrm_lst_upd_dt  
  , bitrm_deleted_ind  
  , bitrm_action  
  )  
  SELECT inserted.bitrm_id  
       , inserted.bitrm_parent_cd  
       , inserted.bitrm_child_cd  
       , inserted.bitrm_bit_location  
       , inserted.bitrm_values  
       , inserted.bitrm_tab_type  
       , inserted.bitrm_created_by  
       , inserted.bitrm_created_dt  
       , inserted.bitrm_lst_upd_by  
       , inserted.bitrm_lst_upd_dt  
       , inserted.bitrm_deleted_ind  
       , 'E'  
  FROM   inserted  
  --  
  IF @l_action = 'D'  
  BEGIN  
  --  
    DELETE bitmap_ref_mstr   
    FROM   bitmap_ref_mstr              bitrm  
          ,inserted                     inserted  
    WHERE  bitrm.bitrm_id             = inserted.bitrm_id  
    AND    inserted.bitrm_deleted_ind = 0  
  --  
  END  
--     
END  
-------------trig_bitrm-------------

GO
