-- Object: PROCEDURE dbo.PROC_CLIENT_COLLATREAL_PROCESS
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

CREATE PROCEDURE [dbo].[PROC_CLIENT_COLLATREAL_PROCESS]      
@PROCESSTYPE VARCHAR(20)='' ,  
 @RUNDATE VARCHAR(11)     
    
AS    
  
select * from ALLOCATE_TEMP_NEW_HRISHI(nolock)

GO
