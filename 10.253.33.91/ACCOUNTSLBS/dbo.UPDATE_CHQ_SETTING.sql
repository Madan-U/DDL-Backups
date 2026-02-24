-- Object: PROCEDURE dbo.UPDATE_CHQ_SETTING
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

  
CREATE PROC [dbo].[UPDATE_CHQ_SETTING]  
(  
 @STRING VARCHAR(1000)  
)  
AS   
SELECT * INTO #CHQ FROM SPLIT(@STRING,'|')  
SELECT * FROM #CHQ  
DROP TABLE #CHQ

GO
