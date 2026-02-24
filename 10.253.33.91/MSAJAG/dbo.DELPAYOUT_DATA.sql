-- Object: PROCEDURE dbo.DELPAYOUT_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [DBO].[DELPAYOUT_DATA]        
  
  
  
--(        
  
  
  
-- @STATUSID VARCHAR(25), @STATUSNAME VARCHAR(25),         
  
  
  
-- @FROMDATE VARCHAR(11), @TODATE VARCHAR(11),         
  
  
  
-- @FROMPARTY VARCHAR(10), @TOPARTY VARCHAR(10),         
  
  
  
-- @REPORTFOR VARCHAR(10)        
  
  
  
--)          
  
AS        
  
select* from [AngelDemat].msajag.dbo.delpayout with (nolock)

GO
