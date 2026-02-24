-- Object: TRIGGER citrus_usr.trig_conc
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

  
  
  
CREATE TRIGGER [trig_conc]  
ON [citrus_usr].[CONTACT_CHANNELS]  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(conc_deleted_ind) and EXISTS(SELECT conc_id FROM inserted WHERE inserted.conc_deleted_ind = 0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
IF NOT EXISTS(SELECT deleted.conc_id FROM deleted)   
BEGIN  
--  
  INSERT INTO conc_hst  
  (CONC_ID  
,CONC_VALUE  
,CONC_CREATED_BY  
,CONC_CREATED_DT  
,CONC_LST_UPD_BY  
,CONC_LST_UPD_DT  
,CONC_DELETED_IND  
,CONC_ACTION  
  )  
  SELECT inserted.CONC_ID  
,inserted.CONC_VALUE  
,inserted.CONC_CREATED_BY  
,inserted.CONC_CREATED_DT  
,inserted.CONC_LST_UPD_BY  
,inserted.CONC_LST_UPD_DT  
,inserted.CONC_DELETED_IND  
,'I'  
  FROM  inserted  
    
--  
  
END  
ELSE  
BEGIN  
--  
   INSERT INTO conc_hst  
  (CONC_ID  
,CONC_VALUE  
,CONC_CREATED_BY  
,CONC_CREATED_DT  
,CONC_LST_UPD_BY  
,CONC_LST_UPD_DT  
,CONC_DELETED_IND  
,CONC_ACTION  
  )  
   SELECT inserted.CONC_ID  
,inserted.CONC_VALUE  
,inserted.CONC_CREATED_BY  
,inserted.CONC_CREATED_DT  
,inserted.CONC_LST_UPD_BY  
,inserted.CONC_LST_UPD_DT  
,inserted.CONC_DELETED_IND  
,@l_action  
  FROM  inserted  
    
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE conc  
    FROM   contact_channles                 conc  
         , inserted                    inserted  
    WHERE  conc.conc_id          = inserted.conc_id  
    AND    inserted.conc_deleted_ind = 0  
  --  
  END  
    
--     
END  
  
--2.entity_mstr

GO
