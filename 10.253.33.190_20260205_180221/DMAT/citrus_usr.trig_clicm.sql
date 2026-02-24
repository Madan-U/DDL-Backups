-- Object: TRIGGER citrus_usr.trig_clicm
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TRIGGER trig_clicm        
ON citrus_usr.CLIENT_CTGRY_MSTR        
FOR INSERT,UPDATE        
AS        
DECLARE @l_action VARCHAR(20)        
--        
IF UPDATE(clicm_deleted_ind)        
BEGIN        
--        
  IF EXISTS(SELECT inserted.clicm_id         
            FROM   inserted         
            WHERE  inserted.clicm_deleted_ind  = 0        
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
IF NOT EXISTS(SELECT deleted.clicm_id FROM deleted)         
BEGIN--insert        
--        
  INSERT INTO clicm_hst        
  ( clicm_id        
  , clicm_cd        
  , clicm_desc        
  , clicm_rmks        
  , clicm_created_by        
  , clicm_created_dt        
  , clicm_lst_upd_by        
  , clicm_lst_upd_dt        
  , clicm_deleted_ind        
  , clicm_action      
  , clicm_bit        
  )        
  SELECT inserted.clicm_id        
       , inserted.clicm_cd        
       , inserted.clicm_desc        
       , inserted.clicm_rmks        
       , inserted.clicm_created_by        
       , inserted.clicm_created_dt        
       , inserted.clicm_lst_upd_by        
       , inserted.clicm_lst_upd_dt        
       , inserted.clicm_deleted_ind        
       , 'I'      
       , inserted.clicm_bit        
  FROM   inserted        
--          
END        
ELSE         
BEGIN--updated        
--        
  INSERT INTO clicm_hst        
  ( clicm_id        
  , clicm_cd        
  , clicm_desc        
  , clicm_rmks        
  , clicm_created_by        
  , clicm_created_dt        
  , clicm_lst_upd_by        
  , clicm_lst_upd_dt        
  , clicm_deleted_ind        
  , clicm_action        
  , clicm_bit      
  )        
  SELECT inserted.clicm_id        
       , inserted.clicm_cd        
       , inserted.clicm_desc        
       , inserted.clicm_rmks        
       , inserted.clicm_created_by        
       , inserted.clicm_created_dt        
       , inserted.clicm_lst_upd_by        
       , inserted.clicm_lst_upd_dt        
       , inserted.clicm_deleted_ind        
       , 'E'      
       , inserted.clicm_bit        
  FROM   inserted        
  --        
  IF @l_action = 'D'        
  BEGIN        
  --        
    DELETE  client_ctgry_mstr        
    FROM    client_ctgry_mstr clicm        
          , inserted                     inserted        
    WHERE   clicm.clicm_id             = inserted.clicm_id        
    AND     inserted.clicm_deleted_ind = 0        
  --        
  END        
--           
END

GO
