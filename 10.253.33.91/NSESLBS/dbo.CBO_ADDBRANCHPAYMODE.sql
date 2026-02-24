-- Object: PROCEDURE dbo.CBO_ADDBRANCHPAYMODE
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--EXEC CBO_ADDBRANCHPAYMODE 'IDBIBANK-ANI','12345','IDBI01','ASHOKS','12-1-2008','NSE','CAPITAL','Broker','Broker'    
    
CREATE PROCEDURE CBO_ADDBRANCHPAYMODE    
    
 @ACNAME VARCHAR(100),    
 @BRANCH VARCHAR(10),    
 @CLTCODE VARCHAR(10),    
 @CREATEDBY VARCHAR(25),    
 @CREATEDON DATETIME,    
 @EXCHANGE VARCHAR(3),    
 @SEGMENT  VARCHAR(7),    
 @STATUSID VARCHAR(25),    
 @STATUSNAME VARCHAR(25)    
AS    
INSERT INTO BRANCHPAYMODE    
(    
 AcName,    
 Branch,    
 CltCode,    
 Created_By,    
 Created_On,    
 Exchange,    
 Segment    
)    
VALUES    
(    
 @ACNAME,    
 @BRANCH,    
 @CLTCODE,    
 @CREATEDBY,    
 @CREATEDON,    
 @EXCHANGE,    
 @SEGMENT    
)  
IF @@ROWCOUNT=0  
  BEGIN    
  RAISERROR ('Few parties is messing...!', 16, 1)  
  END

GO
