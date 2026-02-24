-- Object: PROCEDURE dbo.UPDATE_RPT_DORMANT_CLIENT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE  PROC [dbo].[UPDATE_RPT_DORMANT_CLIENT] 
 AS  
 
 SELECT * INTO #TBL_DORMANT_CLIENT FROM ANGELCOMMODITY.MCDX.DBO.TBL_DORMANT_CLIENT WITH(NOLOCK) WHERE DAY_DIFF >=365
 
    
   INSERT INTO TBL_DORMANT_CLIENT_COMM(SRNO,PARTY_CODE,LAST_SAUDA_DATE,DAY_DIFF,CREATED_BY,CREATED_ON,FLAG,EXCHANGE,REACTIVATION_FLAG,REACTIVATION_dATE)
   SELECT T.* ,'',''  
   FROM                                                  
    #TBL_DORMANT_CLIENT T (NOLOCK) ,MSAJAG.DBO.CLIENT_BROK_DETAILS  C (NOLOCK)                                                  
   WHERE                                                  
    C.CL_CODE = T.PARTY_CODE                                                  
    AND C.EXCHANGE IN ('MCX','NCX')                              
    --AND PARTY_CODE NOT IN (  SELECT DISTINCT CL_CODE FROM #REACTIVE WHERE DIFF <=180)             
    AND DAY_DIFF >=365    
    AND InActive_From >GETDATE()  AND T.EXCHANGE=C.EXCHANGE AND ISNULL(DEACTIVE_VALUE,'') <> 'D'

	--SELECT * FROM CLIENT_BROK_DETAILS WHERE CL_CODE ='SRHS003'
 

  BEGIN    TRAN                                    
   UPDATE                                                  
    C                          
   SET                                                  
    DEACTIVE_REMARKS = LEFT(DEACTIVE_REMARKS + '_DORMANT CLIENT',100)  ,                      
     DEACTIVE_VALUE  = 'D',  
   --  INACTIVE_FROM=  CREATED_ON ,              
  ---  IMP_STATUS =  0 ,
    Modifiedby='DORMANT'               
   -- INACTIVE_FROM= ( CASE WHEN DAY_DIFF = 181 THEN DORMANT_DATE ELSE  INACTIVE_FROM END ),              
   -- IMP_STATUS = ( CASE WHEN DAY_DIFF = 181 THEN 0 ELSE  IMP_STATUS END )                                               
   FROM                                                  
    #TBL_DORMANT_CLIENT T (NOLOCK) ,MSAJAG.DBO.CLIENT_BROK_DETAILS  C                                                  
   WHERE                                                  
    C.CL_CODE = T.PARTY_CODE                                                  
    AND C.EXCHANGE IN ('MCX','NCX')                              
    --AND PARTY_CODE NOT IN (  SELECT DISTINCT CL_CODE FROM #REACTIVE WHERE DIFF <=180)             
    AND DAY_DIFF >=365     AND T.EXCHANGE=C.EXCHANGE   
    AND C.INACTIVE_FROM > GETDATE()  AND  ISNULL(DEACTIVE_VALUE,'') <> 'D'
	                     

UPDATE T SET REACTIVATION_dATE=Modifiedon,REACTIVATION_FLAG =Deactive_value
 from 
TBL_DORMANT_CLIENT_COMM T,CLIENT_BROK_DETAILS C
WHERE T.PARTY_CODE =C.CL_CODE AND T.EXCHANGE=C.EXCHANGE 
AND INACTIVE_FROM >GETDATE() AND ISNULL(REACTIVATION_dATE ,'')='' and ISNULL(DEACTIVE_VALUE,'')='R'

 
 
 
 COMMIT

GO
