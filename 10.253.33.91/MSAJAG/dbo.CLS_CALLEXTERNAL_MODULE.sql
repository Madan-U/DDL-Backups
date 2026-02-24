-- Object: PROCEDURE dbo.CLS_CALLEXTERNAL_MODULE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC [dbo].[CLS_CALLEXTERNAL_MODULE]  
(  
 @RPTCODE VARCHAR(100)  
)  
  
AS   
--select * from CLS_CALLEXTERNAL  
  
select Report_Code,Exchange,Segment,URL,Req_MenuType from CLS_CALLEXTERNAL where Report_Code = @RPTCODE

GO
