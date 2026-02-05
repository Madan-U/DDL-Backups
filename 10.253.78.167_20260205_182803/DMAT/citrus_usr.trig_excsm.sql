-- Object: TRIGGER citrus_usr.trig_excsm
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

-------------trig_excsm-------------  
CREATE TRIGGER trig_excsm  
ON exch_seg_mstr  
FOR INSERT,UPDATE  
AS  
DECLARE @l_action VARCHAR(20)  
--  
SET @l_action = 'E'  
--  
IF UPDATE(excsm_deleted_ind)  
BEGIN  
--  
  IF EXISTS(SELECT inserted.excsm_id   
            FROM   inserted   
            WHERE  inserted.excsm_deleted_ind  = 0  
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
IF NOT EXISTS(SELECT deleted.excsm_id FROM deleted)   
BEGIN--insert  
--  
  INSERT INTO excsm_hst  
  ( excsm_id  
  , excsm_compm_id  
  , excsm_exch_cd  
  , excsm_seg_cd  
  , excsm_sub_seg_cd  
  , excsm_desc  
  , excsm_parent_id  
  , excsm_rmks  
  , excsm_created_by  
  , excsm_created_dt  
  , excsm_lst_upd_by  
  , excsm_lst_upd_dt  
  , excsm_deleted_ind  
  , excsm_action  
  )  
  SELECT inserted.excsm_id  
       , inserted.excsm_compm_id  
       , inserted.excsm_exch_cd  
       , inserted.excsm_seg_cd  
       , inserted.excsm_sub_seg_cd  
       , inserted.excsm_desc  
       , inserted.excsm_parent_id  
       , inserted.excsm_rmks  
       , inserted.excsm_created_by  
       , inserted.excsm_created_dt  
       , inserted.excsm_lst_upd_by  
       , inserted.excsm_lst_upd_dt  
       , inserted.excsm_deleted_ind  
       , 'I'  
  FROM   inserted  
--    
END  
ELSE   
BEGIN--updated  
--  
  INSERT INTO excsm_hst  
  ( excsm_id  
  , excsm_compm_id  
  , excsm_exch_cd  
  , excsm_seg_cd  
  , excsm_sub_seg_cd  
  , excsm_desc  
  , excsm_parent_id  
  , excsm_rmks  
  , excsm_created_by  
  , excsm_created_dt  
  , excsm_lst_upd_by  
  , excsm_lst_upd_dt  
  , excsm_deleted_ind  
  , excsm_action  
  )  
  SELECT inserted.excsm_id  
       , inserted.excsm_compm_id  
       , inserted.excsm_exch_cd  
       , inserted.excsm_seg_cd  
       , inserted.excsm_sub_seg_cd  
       , inserted.excsm_desc  
       , inserted.excsm_parent_id  
       , inserted.excsm_rmks  
       , inserted.excsm_created_by  
       , inserted.excsm_created_dt  
       , inserted.excsm_lst_upd_by  
       , inserted.excsm_lst_upd_dt  
       , inserted.excsm_deleted_ind  
       , 'E'  
  FROM   inserted  
  --  
  IF @l_action = 'D'  
  BEGIN  
  --  
    DELETE exch_seg_mstr  
    FROM   exch_seg_mstr                excsm  
        ,  inserted                     inserted  
    WHERE  excsm.excsm_id             = inserted.excsm_id  
    AND    inserted.excsm_deleted_ind = 0  
  --  
  END  
--     
END  
-------------trig_excsm-------------

GO
