-- Object: PROCEDURE dbo.DIS_DATA
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


--select * from AGMUBODPL3.DMAT.CITRUS_USR.TBL_CLIENT_MASTER  
--DIS_DATA 'MAY 30 2016' , 'MAY 30 2016'          
          
CREATE PROC [dbo].[DIS_DATA]            
(            
  @FROMDATE varchar(11),            
  @TODATE varchar(11)            
 )                     
 AS            
 BEGIN      
     
set @FROMDATE=convert(DATETIME,@FROMDATE,103)    
 set @TODATE=convert(DATETIME,@TODATE,103)    
       
          
 SELECT             
 [client_code] = A.client_code ,           
 [NISE_PARTY_CODE] = A.NISE_PARTY_CODE,FIRST_HOLD_NAME,
 SUB_TYPE ,              
 [ACTIVE_DATE] = convert(varchar,A.ACTIVE_DATE,103)  ,
 [EMAIL_ADD]=A.EMAIL_ADD  
  into #TEMP2         
 FROM            
 AGMUBODPL3.DMAT.CITRUS_USR.TBL_CLIENT_MASTER A         
  WHERE   A.ACTIVE_DATE >= @FROMDATE AND A.ACTIVE_DATE < =@TODATE + ' 23:59'                  
     
            
SELECT client_code,NISE_PARTY_CODE=isnull(NISE_PARTY_CODE,''),FIRST_HOLD_NAME,ACTIVE_DATE, SUB_TYPE,
 EMAIL_ADD,  
DIS_FLAG=isnull(dis_flag,''),APPLICATION_NO=isnull(APPLICATION_NO,'') FROM #TEMP2 T        
LEFT OUTER JOIN         
ABVSCITRUS.CRMDB_A.DBO.API_KYC C        
ON NISE_PARTY_CODE =BOPARTYCODE          
 ORDER BY client_code          
             
END

GO
