-- Object: PROCEDURE dbo.DIS_DATA_PRATHAM
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


  
--DIS_DATA_PRATHAM 'MAY  2 2016' , 'MAY  2 2016'  
  
CREATE PROC [dbo].[DIS_DATA_PRATHAM]    
(    
  @FROMDATE VARCHAR(11),    
  @TODATE VARCHAR(11)    
 )             
 AS    
 BEGIN  SELECT * INTO  #TEMP2 from (     
  
 SELECT     
 [client_code] = A.client_code,   
 [NISE_PARTY_CODE] = A.NISE_PARTY_CODE,      
 [ACTIVE_DATE] = A.ACTIVE_DATE    
 FROM    
 TBL_CLIENT_MASTER(NOLOCK) A 
  WHERE   A.ACTIVE_DATE >= @FROMDATE AND A.ACTIVE_DATE < =@TODATE + ' 23:59:59:999'          
 )  B
    
SELECT T.*,DIS_FLAG,APPLICATION_NO FROM #TEMP2 T
LEFT OUTER JOIN 
ABVSCITRUS.CRMDB_A.DBO.API_KYC C
ON NISE_PARTY_CODE =BOPARTYCODE  
 ORDER BY client_code  
     
END

GO
