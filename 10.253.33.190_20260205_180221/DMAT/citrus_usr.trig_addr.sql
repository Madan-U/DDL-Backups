-- Object: TRIGGER citrus_usr.trig_addr
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

  
  
  
CREATE TRIGGER [trig_addr]  
ON [citrus_usr].[ADDRESSES]  
FOR INSERT,UPDATE  
AS   
  
DECLARE @l_action VARCHAR(20)  
SET @l_action = 'E'  
IF UPDATE(adr_deleted_ind) and EXISTS(SELECT adr_id FROM inserted WHERE inserted.adr_deleted_ind = 0)  
BEGIN  
--  
  SET @l_action = 'D'  
--  
END  
IF NOT EXISTS(SELECT deleted.adr_id FROM deleted)   
BEGIN  
--  
  INSERT INTO addr_hst  
  (ADR_ID  
 ,ADR_1  
 ,ADR_2  
 ,ADR_3  
 ,ADR_CITY  
 ,ADR_STATE  
 ,ADR_COUNTRY  
 ,ADR_ZIP  
 ,ADR_CREATED_BY  
 ,ADR_CREATED_DT  
 ,ADR_LST_UPD_BY  
 ,ADR_LST_UPD_DT  
 ,ADR_DELETED_IND  
 ,ADR_ACTION  
  )  
  SELECT inserted.ADR_ID  
,inserted.ADR_1  
,inserted.ADR_2  
,inserted.ADR_3  
,inserted.ADR_CITY  
,inserted.ADR_STATE  
,inserted.ADR_COUNTRY  
,inserted.ADR_ZIP  
,inserted.ADR_CREATED_BY  
,inserted.ADR_CREATED_DT  
,inserted.ADR_LST_UPD_BY  
,inserted.ADR_LST_UPD_DT  
,inserted.ADR_DELETED_IND  
,'I'  
  FROM  inserted  
    
--  
  
END  
ELSE  
BEGIN  
--  
  INSERT INTO addr_hst  
  (ADR_ID  
 ,ADR_1  
 ,ADR_2  
 ,ADR_3  
 ,ADR_CITY  
 ,ADR_STATE  
 ,ADR_COUNTRY  
 ,ADR_ZIP  
 ,ADR_CREATED_BY  
 ,ADR_CREATED_DT  
 ,ADR_LST_UPD_BY  
 ,ADR_LST_UPD_DT  
 ,ADR_DELETED_IND  
 ,ADR_ACTION  
  )  
  SELECT inserted.ADR_ID  
,inserted.ADR_1  
,inserted.ADR_2  
,inserted.ADR_3  
,inserted.ADR_CITY  
,inserted.ADR_STATE  
,inserted.ADR_COUNTRY  
,inserted.ADR_ZIP  
,inserted.ADR_CREATED_BY  
,inserted.ADR_CREATED_DT  
,inserted.ADR_LST_UPD_BY  
,inserted.ADR_LST_UPD_DT  
,inserted.ADR_DELETED_IND  
  
        ,@l_action  
  
  FROM inserted  
    
  IF @l_action='D'  
  BEGIN  
  --  
    DELETE addresses  
    FROM   addresses                 addr  
         , inserted                    inserted  
    WHERE  addr.adr_id          = inserted.adr_id  
    AND    inserted.adr_deleted_ind = 0  
  --  
  END  
    
--     
END  
  
--2.entity_mstr

GO
