-- Object: PROCEDURE dbo.CBO_ADDBRANCHBROKTABLE
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--EXEC CBO_ADDBRANCHBROKTABLE 124,'TEST Rnd','1324','S','Ashoks','12-1-2008','Test','NSE','CAPITAL'  
CREATE PROCEDURE CBO_ADDBRANCHBROKTABLE  
@TABLE_NO INT,  
@TABLE_NAME VARCHAR(30),  
@BRANCH_CODE VARCHAR(10),  
@TABLE_TYPE CHAR(1),  
@CREATED_BY VARCHAR(25),  
@CREATED_ON varchar(10),  
@REMARKS VARCHAR(50),  
@EXCHANGE VARCHAR(3),  
@SEGMENT VARCHAR(7),  
@STATUSID VARCHAR(25)='Broker',  
@STATUSNAME VARCHAR(25)='Broker'  
AS  
INSERT INTO BRANCHBROKTABLE  
(        
Table_No,  
Table_Name,  
Branch_Code,  
Table_Type,  
Created_By,  
Created_On,
Remarks,  
Exchange,  
Segment  
)        
VALUES  
(        
@TABLE_NO,  
@TABLE_NAME,  
@BRANCH_CODE,  
@TABLE_TYPE,  
@CREATED_BY,  
 
Convert(Varchar(11), Convert(Datetime,@CREATED_ON, 103), 109), 
--@SR_NO,  
@REMARKS,  
@EXCHANGE,  
@SEGMENT  
)      
IF @@ROWCOUNT=0      
  BEGIN        
  RAISERROR ('Few parties is messing...!', 16, 1)      
  END

GO
