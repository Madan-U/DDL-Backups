-- Object: PROCEDURE dbo.CBO_DELETEBRANCHPAYMODE
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--select * from BRANCHPAYMODE  
  
--EXEC CBO_DELETEBRANCHPAYMODE 'IDBI BANK-ANI','IDBI001','ABC','NSE','CAPITAL'



CREATE PROCEDURE CBO_DELETEBRANCHPAYMODE  
@ACNAME VARCHAR(100),  
@CLTCODE VARCHAR(10),  
@BRANCH VARCHAR(10),  
@EXCHANGE VARCHAR(3),  
@SEGMENT VARCHAR(7),  
@STATUSID VARCHAR(25)='Broker',  
@STATUSNAME VARCHAR(25)='Broker'  
AS
Delete from BranchPayMode where AcName=@ACNAME  
and CltCode=@CLTCODE and Branch=@BRANCH and exchange = @EXCHANGE and segment = @SEGMENT
IF @@ROWCOUNT=0
		BEGIN  
		RAISERROR ('Few parties is messing...!', 16, 1)
		END

GO
