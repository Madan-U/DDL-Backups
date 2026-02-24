-- Object: PROCEDURE dbo.USP_GET_HOLDDATE
-- Server: 10.253.33.231 | DB: inhouse
--------------------------------------------------

CREATE PROC [dbo].[USP_GET_HOLDDATE]            
@MODE CHAR(1), @HOLD_DATE VARCHAR(11), @HOLD_DATE_NEW VARCHAR(11) OUTPUT            
AS    
  
EXEC AGMUBODPL3.DMAT.CITRUS_USR.USP_GET_HOLDDATE @MODE,@HOLD_DATE,@HOLD_DATE_NEW

GO
