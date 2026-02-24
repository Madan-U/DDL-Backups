-- Object: PROCEDURE dbo.REMISSSOR_BILLPOSTING
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROC REMISSSOR_BILLPOSTING  
  
 @VTYPE SMALLINT,  
 @BOOKTYPE VARCHAR(2),  
 @VDT VARCHAR(11),  
 @EDTDR VARCHAR(11),  
 @EDTCR VARCHAR(11),  
 @CDT VARCHAR(11),      
 @PDT VARCHAR(11),      
 @ENTEREDBY VARCHAR(25),      
 @CHECKEDBY VARCHAR(25),      
 @SETT_NO VARCHAR(7),      
 @SETT_TYPE VARCHAR(3),      
 @UNAME VARCHAR(25),  
 @ACC_SERVER1 VARCHAR(15),  
 @ACC_DB1 VARCHAR(15),  
 @VNO1 VARCHAR(12),  
 @EXCHANGE1 VARCHAR(10),  
 @SEGMENT1 VARCHAR(10),
 @OVNO1 VARCHAR(12) = '',    
 @ACC_SERVER2 VARCHAR(15),  
 @ACC_DB2 VARCHAR(15),  
 @VNO2 VARCHAR(12),  
 @EXCHANGE2 VARCHAR(10),  
 @SEGMENT2 VARCHAR(10),
 @OVNO2 VARCHAR(12) = '',    
 @ACC_SERVER3 VARCHAR(15),  
 @ACC_DB3 VARCHAR(15),  
 @VNO3 VARCHAR(12),  
 @EXCHANGE3 VARCHAR(10),  
 @SEGMENT3 VARCHAR(10),
 @OVNO3 VARCHAR(12) = ''    
AS  
  
DECLARE   
 @@SQL VARCHAR(1000)  
  
BEGIN TRANSACTION  
  
  
 SET @@SQL = "EXEC " + @ACC_SERVER1 + "." + @ACC_DB1 + ".DBO.NEWPOSTBILL_REM " + CONVERT(VARCHAR, @VTYPE) + ",'" + @BOOKTYPE + "','" + @VNO1 + "','" + @VDT + "','" + @EDTDR + "','" + @EDTCR + "','" + @CDT + "','" + @PDT + "','" + @ENTEREDBY + "','" + @CHECKEDBY + "','" + @SETT_NO + "','" + @SETT_TYPE + "','" + @UNAME + "','" + @EXCHANGE1 + "','" + @SEGMENT1 + "','" + @OVNO1 + "'"  
  
  
 EXEC (@@SQL)  
  
 IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRAN  
 END  
  
 SET @@SQL = "EXEC " + @ACC_SERVER2 + "." + @ACC_DB2 + ".DBO.NEWPOSTBILL_REM " + CONVERT(VARCHAR, @VTYPE) + ",'" + @BOOKTYPE + "','" + @VNO2 + "','" + @VDT + "','" + @EDTDR + "','" + @EDTCR + "','" + @CDT + "','" + @PDT + "','" + @ENTEREDBY + "','" + @CHECKEDBY + "','" + @SETT_NO + "','" + @SETT_TYPE + "','" + @UNAME + "','" + @EXCHANGE2 + "','" + @SEGMENT2 + "','" + @OVNO2 + "'"  
  
 EXEC (@@SQL)  
  
 IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRAN  
 END  
  
 SET @@SQL = "EXEC " + @ACC_SERVER3 + "." + @ACC_DB3 + ".DBO.NEWPOSTBILL_REM " + CONVERT(VARCHAR, @VTYPE) + ",'" + @BOOKTYPE + "','" + @VNO3 + "','" + @VDT + "','" + @EDTDR + "','" + @EDTCR + "','" + @CDT + "','" + @PDT + "','" + @ENTEREDBY + "','" + @CHECKEDBY + "','" + @SETT_NO + "','" + @SETT_TYPE + "','" + @UNAME + "','" + @EXCHANGE3 + "','" + @SEGMENT3 + "','" + @OVNO3 + "'"  
  
 EXEC (@@SQL)  
  
 IF @@ERROR <> 0  
 BEGIN  
  ROLLBACK TRAN  
 END  
  
  
  
  
COMMIT TRANSACTION

GO
