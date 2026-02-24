-- Object: PROCEDURE dbo.FIND_Sett_no
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[FIND_Sett_no] (@date datetime,@PARTY_CODE VARCHAR(10),@AMT MONEY)  
AS  
SELECT PARTY_CODE,Start_Date,SETT_NO,SETT_TYPE,AMOUNT,'NSECM' AS EXCHANGE,PayIn_Date,PayOut_Date 
INTO #SETT FROM  AccBill (Nolock)  where start_date = @date AND PARTY_CODE= @PARTY_CODE  AND AMOUNT =AMOUNT  
UNION ALL  
SELECT PARTY_CODE,Start_Date,SETT_NO,SETT_TYPE,AMOUNT,'BSECM' AS EXCHANGE,PayIn_Date,PayOut_Date 
FROM AngelBSECM.BSEDB_AB.DBO.AccBill With(Nolock) where start_date = @date AND PARTY_CODE= @PARTY_CODE  AND AMOUNT =AMOUNT  
  
CREATE INDEX #S ON #SETT  
(PARTY_CODE )  
  
SELECT S.*,LONG_NAME,l_address1,l_address2,l_address3,l_city,l_state,l_zip,pan_gir_no 
FROM #SETT S (Nolock),CLIENT_DETAILS D WITH(NOLOCK)  
WHERE S.Party_Code =D.CL_CODE

GO
