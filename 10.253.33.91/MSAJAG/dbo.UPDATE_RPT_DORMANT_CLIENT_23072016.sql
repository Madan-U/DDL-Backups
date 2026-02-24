-- Object: PROCEDURE dbo.UPDATE_RPT_DORMANT_CLIENT_23072016
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 CREATE PROC [dbo].[UPDATE_RPT_DORMANT_CLIENT_23072016] 
 AS  
 
 SELECT * INTO #TBL_DORMANT_CLIENT FROM ANGELCOMMODITY.MCDX.DBO.TBL_DORMANT_CLIENT WITH(NOLOCK) WHERE DAY_DIFF =180 
 
  BEGIN                                                  
   UPDATE                                                  
    C                          
   SET                                                  
    DEACTIVE_REMARKS = DEACTIVE_REMARKS + '_DORMANT CLIENT',                                              
     DEACTIVE_VALUE  = 'D',  
     INACTIVE_FROM=  CREATED_ON ,              
    IMP_STATUS =  0 ,
    Modifiedby='DORMANT'               
   -- INACTIVE_FROM= ( CASE WHEN DAY_DIFF = 181 THEN DORMANT_DATE ELSE  INACTIVE_FROM END ),              
   -- IMP_STATUS = ( CASE WHEN DAY_DIFF = 181 THEN 0 ELSE  IMP_STATUS END )                                               
   FROM                                                  
    #TBL_DORMANT_CLIENT T (NOLOCK) ,MSAJAG.DBO.CLIENT_BROK_DETAILS  C                                                  
   WHERE                                                  
    C.CL_CODE = T.PARTY_CODE                                                  
    AND C.EXCHANGE IN ('MCX','NCX')                              
    --AND PARTY_CODE NOT IN (  SELECT DISTINCT CL_CODE FROM #REACTIVE WHERE DIFF <=180)             
    AND DAY_DIFF =180      
    AND C.INACTIVE_FROM > GETDATE()                       
  END

GO
