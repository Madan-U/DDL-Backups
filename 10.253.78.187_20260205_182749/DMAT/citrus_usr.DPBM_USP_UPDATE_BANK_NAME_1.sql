-- Object: PROCEDURE citrus_usr.DPBM_USP_UPDATE_BANK_NAME_1
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE  proc [citrus_usr].[DPBM_USP_UPDATE_BANK_NAME_1]            
           
AS
BEGIN              
DECLARE @intErrorCode INT          
          
--BEGIN TRAN          
    --update DPBM_DPBM_BANK_MASTER_UPLOAD 
	insert into  DPBM_TEMP_BANK_MASTER_UPLOAD_Arch select * from DPBM_TEMP_BANK_MASTER_UPLOAD         
    update DPBM_TEMP_BANK_MASTER_UPLOAD        
    set BRANCH_NAME = [citrus_usr].[DPBM_FN_GETBRANCHNAME](BANK_NAME)  
	     
 -- where UPLOADED_DATE = getdate()        
 --where CONVERT(DATETIME,CONVERT(VARCHAR,UPLOADED_DATE,106)) = CONVERT(DATETIME,CONVERT(VARCHAR,getdate(),106))        
          
    SELECT @intErrorCode = @@ERROR          
    IF (@intErrorCode <> 0) GOTO PROBLEM          
          
   -- update DPBM_DPBM_BANK_MASTER_UPLOAD            
    update DPBM_TEMP_BANK_MASTER_UPLOAD            
 set BANK_NAME = [citrus_usr].[DPBM_FN_GETBANKNAME](BANK_NAME) 
 -- where UPLOADED_DATE = getdate()        
 --where CONVERT(DATETIME,CONVERT(VARCHAR,UPLOADED_DATE,106)) = CONVERT(DATETIME,CONVERT(VARCHAR,getdate(),106))        
          
    SELECT @intErrorCode = @@ERROR          
    IF (@intErrorCode <> 0) GOTO PROBLEM          
  INSERT INTO DPBM_BANK_MASTER_UPLOAD (BANK_ID,MICR_CODE,IFSC_CODE,BANK_NAME,ADD1,ADD2,ADD3,CITY,STATE,  COUNTRY,PIN_CODE,COL1,COL2,COL3,COL4,COL5,BRANCH_MNGR,UPLOADED_DATE,BRANCH_NAME)         
  SELECT * FROM DPBM_TEMP_BANK_MASTER_UPLOAD    
  Delete from DPBM_BANK_MASTER_UPLOAD  
  where Row_Id in (Select max(Row_Id) as Row_Id from DPBM_BANK_MASTER_UPLOAD  
      group by BANK_ID,MICR_CODE,IFSC_CODE,BANK_NAME,ADD1,ADD2,ADD3,CITY,STATE,COUNTRY,PIN_CODE,COL1,COL2,COL3,COL4,COL5,BRANCH_MNGR,BRANCH_NAME  
      Having count(*)>1)  
  
 IF (@intErrorCode <> 0) GOTO PROBLEM         
        
 --COMMIT TRAN          
          
PROBLEM:          
IF (@intErrorCode <> 0) BEGIN          
PRINT 'Unexpected error occurred!'          
    --ROLLBACK TRAN          
END        
          
END

GO
