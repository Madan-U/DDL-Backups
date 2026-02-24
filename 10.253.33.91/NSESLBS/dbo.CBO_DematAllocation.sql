-- Object: PROCEDURE dbo.CBO_DematAllocation
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


-- CBO_DematAllocation 'BROKER','BROKER'
CREATE  PROCEDURE CBO_DematAllocation  
(  
 @STATUSID VARCHAR(25),  
 @STATUSNAME VARCHAR(25)  
)  
AS  
DECLARE @@RefNo INT  

IF @STATUSID <> 'BROKER'  
  BEGIN  
   RAISERROR ('This Procedure is accessible to Broker', 16, 1)  
   RETURN  
  END   

SELECT TOP 1 @@RefNo = RefNo FROM DelSegment

BEGIN  

 Exec InsDelCheckPos @@RefNo  
   
 Execute InsDematAllocateCursor @@RefNo  
   
 Execute InsDematNseCursor @@RefNo  
END

GO
