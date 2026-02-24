-- Object: PROCEDURE dbo.USP_GSTReversal_GetMonthData
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


  
-- USP_GSTReversal_GetMonthData '0','z','','Y'  
  
CREATE PROC [dbo].[USP_GSTReversal_GetMonthData]  
@FromClient VARCHAR(20),  
@ToClient VARCHAR(20),  
@Branch VARCHAR(20),  
@IsThirdParty CHAR  
  
AS  
  
BEGIN  
  
IF(@IsThirdParty= 'N')  
BEGIN  
   
 SELECT *  
 INTO #getMonthData  
 FROM (  
     
   SELECT DISTINCT 1 as Srno,'--SELECT--' AS INVOICE_DATE   
   UNION    
   SELECT DISTINCT 2 as Srno,DATENAME(M, INVOICE_DATE) + ' ' + DATENAME(YYYY, INVOICE_DATE) AS INVOICE_DATE   
   FROM TBL_GST_INVOICE-- _TMP   
   WHERE party_code BETWEEN @FromClient and @ToClient  
     OR BRANCH_CODE = CASE WHEN @Branch = '' THEN NULL ELSE @Branch END   
  )P  
 ORDER BY Srno ASC  
   
   
 SELECT INVOICE_DATE FROM #getMonthData  
   
   
 DROP TABLE #getMonthData  
END  
  
ELSE IF(@IsThirdParty= 'Y')  
BEGIN  
  
  SELECT *  
  FROM CLient_Details A  
    INNER JOIN Client5 B  
    ON A.cl_code = B.Cl_Code AND b.Inactivefrom >= GETDATE()  
  WHERE party_code BETWEEN @FromClient and @ToClient  
   OR branch_cd = CASE WHEN @Branch = '' THEN NULL ELSE @Branch END   
       
  
  
END  
  
END  
/*SELECT *  
FROM TBL_GST_INVOICE_TMP  
*/

GO
