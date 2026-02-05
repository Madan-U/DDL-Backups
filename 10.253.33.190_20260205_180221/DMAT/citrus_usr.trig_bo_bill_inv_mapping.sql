-- Object: TRIGGER citrus_usr.trig_bo_bill_inv_mapping
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------



create TRIGGER [citrus_usr].[trig_bo_bill_inv_mapping]
ON [citrus_usr].[bo_bill_inv_mapping]
FOR INSERT,UPDATE
AS 

DECLARE @l_action VARCHAR(20)
SET @l_action = 'E'
IF UPDATE(deleted_ind) and EXISTS(SELECT inv_no FROM inserted WHERE inserted.deleted_ind = 0)
BEGIN
--
  SET @l_action = 'D'
--
END
IF NOT EXISTS(SELECT deleted.inv_no FROM bo_bill_inv_mapping_log deleted) 
BEGIN
--
  INSERT INTO bo_bill_inv_mapping_log
  (billmonth
,billyear
,boid
,inv_no
,CN_FLG
,Return_flg
,Created_by
,created_dt
,lst_upd_by
,lst_upd_dt
,deleted_ind
,dpm_id
,inv_action
  )
  SELECT inserted.billmonth
        ,inserted.billyear
        ,inserted.boid
        ,inserted.inv_no
        ,inserted.CN_FLG
        ,inserted.Return_flg
        ,inserted.Created_by
        ,inserted.created_dt
        ,inserted.lst_upd_by
        ,inserted.lst_upd_dt
        ,inserted.deleted_ind
        ,inserted.dpm_id
        
        ,'I' from inserted
  
--

END
ELSE
BEGIN
--
  INSERT INTO bo_bill_inv_mapping_log
  (billmonth
,billyear
,boid
,inv_no
,CN_FLG
,Return_flg
,Created_by
,created_dt
,lst_upd_by
,lst_upd_dt
,deleted_ind
,dpm_id
,inv_action
  )
  SELECT inserted.billmonth
        ,inserted.billyear
        ,inserted.boid
        ,inserted.inv_no
        ,inserted.CN_FLG
        ,inserted.Return_flg
        ,inserted.Created_by
        ,inserted.created_dt
        ,inserted.lst_upd_by
        ,inserted.lst_upd_dt
        ,inserted.deleted_ind
        ,inserted.dpm_id
        
        ,@l_action
        
  FROM inserted
  
  IF @l_action='D'
  BEGIN
  --
    DELETE bo_bill_inv_mapping
    FROM   bo_bill_inv_mapping                 inv
         , inserted                    inserted
    WHERE  inv.billmonth          = inserted.billmonth and inv.billyear          = inserted.billyear  
	and inserted.boid=inv.boid
    
  --
  END
  
--   
END

--2.entity_mstr

GO
