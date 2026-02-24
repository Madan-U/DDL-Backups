-- Object: PROCEDURE dbo.CBO_INTER_SETTLEMENT_TRANSFER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



--exec CBO_INTER_SETTLEMENT_TRANSFER 'broker','broker'

CREATE    PROCEDURE CBO_INTER_SETTLEMENT_TRANSFER
(  
 @STATUSID VARCHAR(25),  
 @STATUSNAME VARCHAR(25)  
)  
AS  
DECLARE 
@@RefNo INT  ,
@Sett_no VARCHAR(7),
@Sett_Type VARCHAR(2)

IF @STATUSID <> 'BROKER'  
  BEGIN  
   RAISERROR ('This Procedure is accessible to Broker', 16, 1)  
   RETURN  
  END   

SELECT TOP 1 @@RefNo = RefNo FROM DelSegment

BEGIN  

Exec CBO_InterSettTrans  @Sett_no ,@Sett_Type ,@@RefNo
   
 
END

GO
