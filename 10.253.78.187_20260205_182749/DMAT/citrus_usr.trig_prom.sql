-- Object: TRIGGER citrus_usr.trig_prom
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

-------------trig_prom--------------  
CREATE TRIGGER trig_prom  
ON product_mstr  
FOR INSERT,UPDATE  
AS  
DECLARE @l_action VARCHAR(20)  
--  
SET @l_action = 'E'  
--  
IF UPDATE(prom_deleted_ind)  
BEGIN  
--  
  IF EXISTS(SELECT inserted.prom_id   
            FROM   inserted   
            WHERE  inserted.prom_deleted_ind  = 0  
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
IF NOT EXISTS(SELECT deleted.prom_id FROM deleted)   
BEGIN--insert  
--  
  INSERT INTO prom_hst  
  ( prom_id  
  , prom_cd  
  , prom_desc  
  , prom_rmks  
  , prom_created_by  
  , prom_created_dt  
  , prom_lst_upd_by  
  , prom_lst_upd_dt  
  , prom_deleted_ind  
  , prom_action  
  )  
  SELECT inserted.prom_id  
       , inserted.prom_cd  
       , inserted.prom_desc  
       , inserted.prom_rmks  
       , inserted.prom_created_by  
       , inserted.prom_created_dt  
       , inserted.prom_lst_upd_by  
       , inserted.prom_lst_upd_dt  
       , inserted.prom_deleted_ind  
       , 'I'  
  FROM   inserted  
--    
END  
ELSE   
BEGIN--updated  
--  
  INSERT INTO prom_hst  
  ( prom_id  
  , prom_cd  
  , prom_desc  
  , prom_rmks  
  , prom_created_by  
  , prom_created_dt  
  , prom_lst_upd_by  
  , prom_lst_upd_dt  
  , prom_deleted_ind  
  , prom_action  
  )   
  SELECT inserted.prom_id  
       , inserted.prom_cd  
       , inserted.prom_desc  
       , inserted.prom_rmks  
       , inserted.prom_created_by  
       , inserted.prom_created_dt  
       , inserted.prom_lst_upd_by  
       , inserted.prom_lst_upd_dt  
       , inserted.prom_deleted_ind  
       , 'E'  
  FROM   inserted  
  --  
  IF @l_action = 'D'  
  BEGIN  
  --  
    DELETE product_mstr  
    FROM   product_mstr                prom  
        ,  inserted                    inserted  
    WHERE  prom.prom_id              = inserted.prom_id  
    AND    inserted.prom_deleted_ind = 0  
  --  
  END  
--     
END  
-------------trig_prom-------------

GO
