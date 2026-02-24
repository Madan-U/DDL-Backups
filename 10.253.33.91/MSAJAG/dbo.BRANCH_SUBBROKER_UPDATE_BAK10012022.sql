-- Object: PROCEDURE dbo.BRANCH_SUBBROKER_UPDATE_BAK10012022
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[BRANCH_SUBBROKER_UPDATE_BAK10012022]                                                
 @FILENAME VARCHAR(1000),                                                
 @UNAME VARCHAR(50)                                                
AS                  
                
                                       
BEGIN TRAN                 
    
TRUNCATE TABLE BRANCH_SUBBROKER                        
                                                
CREATE TABLE #BRANCH_SUBBROKER                  
(                                                
 FILE_DATA VARCHAR(MAX),                                                
 SRNO INT IDENTITY(1, 1)                                                
)                                                
                                                
                  
                                            
DECLARE                                                
 @@SQL VARCHAR(MAX) ,                
 @@ERROR_COUNT      AS BIGINT,                
 @ERRORCODE AS BIGINT                                                                                               
                                             
SET @@SQL = "INSERT INTO  #BRANCH_SUBBROKER "                  
SET @@SQL = @@SQL + " EXEC MASTER.DBO.XP_CMDSHELL 'TYPE " + @FILENAME + "'"                                                                              
--SET @@SQL = @@SQL + " EXEC MASTER.DBO.XP_CMDSHELL 'TYPE " + 'D:\BACKOFFICE\BRANCHCHANGE.CSV' + "'"                                                
            
PRINT @@SQL                                              
                                        
EXEC(@@SQL)              
        
        
            
            
DELETE FROM #BRANCH_SUBBROKER WHERE SRNO <= 1  
              
                
                                             
                                            
                                              
INSERT INTO BRANCH_SUBBROKER                                                 
SELECT                                                 
 .DBO.PIECE(FILE_DATA, ',', 1),                   
 .DBO.PIECE(FILE_DATA, ',', 2),                                                
 .DBO.PIECE(FILE_DATA, ',', 3),                                                
 .DBO.PIECE(FILE_DATA, ',', 4),                                                
 .DBO.PIECE(FILE_DATA, ',', 5),                                                                        
 .DBO.PIECE(FILE_DATA, ',', 6),                                                                       
 .DBO.PIECE(FILE_DATA, ',', 7),                                                                      
 .DBO.PIECE(FILE_DATA, ',', 8),                                                                     
 .DBO.PIECE(FILE_DATA, ',', 9),                                                                    
 .DBO.PIECE(FILE_DATA, ',', 10),                                                                    
 .DBO.PIECE(FILE_DATA, ',', 11),                                                                   
 .DBO.PIECE(FILE_DATA, ',', 12),                                                                  
 .DBO.PIECE(FILE_DATA, ',', 13),                                                                 
 .DBO.PIECE(FILE_DATA, ',', 14),                                                                
 .DBO.PIECE(FILE_DATA, ',', 15),                                                               
 .DBO.PIECE(FILE_DATA, ',', 16)                                                                        
FROM #BRANCH_SUBBROKER             
            
  
-------------VALIDATION FOR BRANCH  MAPPING--------------------      

                
                
SELECT @@ERROR_COUNT=COUNT(1)                 
FROM BRANCH_SUBBROKER WHERE BRANCH_CODE_NEW NOT IN (SELECT DISTINCT  BRANCH_CODE FROM MSAJAG..BRANCH)                
                
IF @@ERROR_COUNT > 0    
 BEGIN                
 SELECT  'BRANCH CODE DOSE NOT ESIXT IN MASTER'                
 UNION ALL                
 SELECT 'BRANCH_CODE'              
 UNION ALL            
 SELECT '------------------'                
 UNION ALL                
 SELECT BRANCH_CODE_NEW                 
 FROM BRANCH_SUBBROKER WHERE BRANCH_CODE_NEW NOT IN (SELECT DISTINCT  BRANCH_CODE FROM MSAJAG..BRANCH)                
                
 ROLLBACK TRAN                
 RETURN                                                                   
 END                                                                                
                                                                
  SET @@ERROR_COUNT = 0  
  
  -------------VALIDATION FOR BRANCH  MAPPING IN REGION MASTER--------------------      

                
                
SELECT @@ERROR_COUNT=COUNT(1)                 
FROM BRANCH_SUBBROKER WHERE BRANCH_CODE_NEW NOT IN (SELECT DISTINCT  BRANCH_CODE FROM MSAJAG..REGION)                
                
IF @@ERROR_COUNT > 0    
 BEGIN                
 SELECT  'BRANCH CODE DOSE NOT MAPPED IN REGION MASTER'                
 UNION ALL                
 SELECT 'BRANCH_CODE'              
 UNION ALL            
 SELECT '------------------'                
 UNION ALL                
 SELECT BRANCH_CODE_NEW                 
 FROM BRANCH_SUBBROKER WHERE BRANCH_CODE_NEW NOT IN (SELECT DISTINCT  BRANCH_CODE FROM MSAJAG..REGION)                
                
 ROLLBACK TRAN                
 RETURN                                                                   
 END                                                                                
                                                                
  SET @@ERROR_COUNT = 0                
                
  -------------VALIDATION FOR SUB_BROKER  MAPPING--------------------                
                 
                  
 SELECT @@ERROR_COUNT=COUNT(1) FROM BRANCH_SUBBROKER WHERE SUB_BROKER_NEW                
 NOT IN (SELECT DISTINCT  SUB_BROKER FROM MSAJAG..SUBBROKERS)                
                
IF @@ERROR_COUNT > 0                                                                          
    BEGIN                                                                             
    SELECT 'SUB_BROKER CODE DOSE NOT ESIXT IN MASTER'                
    UNION ALL                
 SELECT 'SUB_BROKER'                
 UNION ALL                
 SELECT '------------------'                
 UNION ALL                
 SELECT SUB_BROKER_NEW                 
 FROM BRANCH_SUBBROKER WHERE SUB_BROKER_NEW NOT IN (SELECT DISTINCT  SUB_BROKER FROM MSAJAG..SUBBROKERS)                
                  
    DROP TABLE BRANCH_SUBBROKER                                
    ROLLBACK TRAN                 
    RETURN                                                                   
    END                                                                                                                                      
SET @@ERROR_COUNT = 0           
          
  -------------VALIDATION FOR TRADER  MAPPING--------------------                
                 
                  
 SELECT @@ERROR_COUNT=COUNT(1) FROM BRANCH_SUBBROKER WHERE TRADER_NEW                
 NOT IN (SELECT DISTINCT  SHORT_NAME FROM MSAJAG..BRANCHES)                
                
IF @@ERROR_COUNT > 0                                                                          
    BEGIN                                                                             
    SELECT 'TRADER CODE DOSE NOT ESIXT IN MASTER'                
    UNION ALL                
 SELECT 'BRANCH_CD'                
 UNION ALL                
 SELECT '------------------'                
 UNION ALL                
 SELECT TRADER_NEW                 
 FROM BRANCH_SUBBROKER WHERE TRADER_NEW NOT IN (SELECT DISTINCT SHORT_NAME FROM MSAJAG..BRANCHES)                
                  
    DROP TABLE BRANCH_SUBBROKER                                
    ROLLBACK TRAN                 
    RETURN                                                                   
    END                                                                                                                                      
SET @@ERROR_COUNT = 0                
            
 -------------VALIDATION FOR AREA  MAPPING--------------------                
                 
                  
 SELECT @@ERROR_COUNT=COUNT(1) FROM BRANCH_SUBBROKER WHERE AREA_NEW                
 NOT IN (SELECT DISTINCT  AREACODE FROM MSAJAG..AREA)                
                
IF @@ERROR_COUNT > 0                                                                          
    BEGIN                                                                             
    SELECT 'AREA CODE DOSE NOT ESIXT IN MASTER'                
    UNION ALL                
 SELECT 'AREACODE'                
 UNION ALL                
 SELECT '------------------'    
 UNION ALL        
 SELECT AREA_NEW                 
 FROM BRANCH_SUBBROKER WHERE AREA_NEW NOT IN (SELECT DISTINCT  AREACODE FROM MSAJAG..AREA)                
                  
    DROP TABLE BRANCH_SUBBROKER                                
    ROLLBACK TRAN             
    RETURN                                        
    END                              
SET @@ERROR_COUNT = 0                
            
 -------------VALIDATION FOR AREA  MAPPING--------------------       
       
       
                
                  
 SELECT @@ERROR_COUNT=COUNT(1) FROM BRANCH_SUBBROKER WHERE REGION_NEW                
 NOT IN (SELECT DISTINCT  REGIONCODE FROM MSAJAG..REGION)                
                
IF @@ERROR_COUNT > 0                                                                          
    BEGIN                   
    SELECT 'REGION CODE DOSE NOT ESIXT IN MASTER'                
    UNION ALL                
 SELECT 'REGIONCODE'                
 UNION ALL                
 SELECT '------------------'                
 UNION ALL                
 SELECT REGION_NEW                 
 FROM BRANCH_SUBBROKER WHERE REGION_NEW NOT IN (SELECT DISTINCT  REGIONCODE FROM MSAJAG..REGION)                
                  
    DROP TABLE BRANCH_SUBBROKER                                
    ROLLBACK TRAN                 
    RETURN                                                                   
    END                                                                                                                                      
SET @@ERROR_COUNT = 0           
          
            
 -------------VALIDATION FOR SBU  MAPPING--------------------  
 
    
                            
                 
                  
 SELECT @@ERROR_COUNT=COUNT(1) FROM BRANCH_SUBBROKER WHERE SBU_NEW                
 NOT IN (SELECT DISTINCT  SBU_CODE FROM MSAJAG..SBU_MASTER)                
                
IF @@ERROR_COUNT > 0                                                                          
    BEGIN                                                                             
    SELECT 'SBU_CODE CODE DOSE NOT ESIXT IN MASTER'                
    UNION ALL                
 SELECT 'SBU_CODE'                
 UNION ALL                
 SELECT '------------------'                
 UNION ALL                
 SELECT SBU_NEW                 
 FROM BRANCH_SUBBROKER WHERE SBU_NEW NOT IN (SELECT DISTINCT  SBU_CODE FROM MSAJAG..SBU_MASTER)                
                  
    DROP TABLE BRANCH_SUBBROKER                                
    ROLLBACK TRAN                 
    RETURN                                                                   
    END                                                                                                                                      
SET @@ERROR_COUNT = 0     

                 
                
INSERT INTO MSAJAG..CLIENT_DETAILS_LOG                  
SELECT CL_CODE,BRANCH_CD,PARTY_CODE,SUB_BROKER,TRADER,LONG_NAME,SHORT_NAME,L_ADDRESS1,L_CITY,                  
L_ADDRESS2,L_STATE,L_ADDRESS3,L_NATION,L_ZIP,PAN_GIR_NO,WARD_NO,SEBI_REGN_NO,RES_PHONE1,                  
RES_PHONE2,OFF_PHONE1,OFF_PHONE2,MOBILE_PAGER,FAX,EMAIL,CL_TYPE,CL_STATUS,FAMILY,REGION,AREA,                  
P_ADDRESS1,P_CITY,P_ADDRESS2,P_STATE,P_ADDRESS3,P_NATION,P_ZIP,P_PHONE,ADDEMAILID,SEX,DOB,                  
INTRODUCER,APPROVER,INTERACTMODE,PASSPORT_NO,PASSPORT_ISSUED_AT,PASSPORT_ISSUED_ON,                  
PASSPORT_EXPIRES_ON,LICENCE_NO,LICENCE_ISSUED_AT,LICENCE_ISSUED_ON,LICENCE_EXPIRES_ON,                  
RAT_CARD_NO,RAT_CARD_ISSUED_AT,RAT_CARD_ISSUED_ON,VOTERSID_NO,VOTERSID_ISSUED_AT,                  
VOTERSID_ISSUED_ON,IT_RETURN_YR,IT_RETURN_FILED_ON,REGR_NO,REGR_AT,REGR_ON,REGR_AUTHORITY,                  
CLIENT_AGREEMENT_ON,SETT_MODE,DEALING_WITH_OTHER_TM,OTHER_AC_NO,INTRODUCER_ID,INTRODUCER_RELATION,            
REPATRIAT_BANK,REPATRIAT_BANK_AC_NO,CHK_KYC_FORM,CHK_CORPORATE_DEED,CHK_BANK_CERTIFICATE,CHK_ANNUAL_REPORT,                  
CHK_NETWORTH_CERT,CHK_CORP_DTLS_RECD,BANK_NAME,BRANCH_NAME,AC_TYPE,AC_NUM,DEPOSITORY1,DPID1,CLTDPID1,                 
POA1,DEPOSITORY2,DPID2,CLTDPID2,POA2,DEPOSITORY3,DPID3,CLTDPID3,POA3,REL_MGR,C_GROUP,SBU,STATUS,                  
IMP_STATUS,MODIFIDEDBY,MODIFIDEDON ,BANK_ID,MAPIN_ID,UCC_CODE,MICR_NO,                  
EDIT_BY='BRANCHCHANGE',EDIT_ON=GETDATE(),DIRECTOR_NAME,PAYLOCATION,FMCODE,INCOME_SLAB,NETWORTH_SLAB,PARENTCODE,PRODUCTCODE,RES_PHONE1_STD,                  
RES_PHONE2_STD,OFF_PHONE1_STD,OFF_PHONE2_STD,P_PHONE_STD,GST_NO,GST_LOCATION                  
FROM MSAJAG..CLIENT_DETAILS                   
WHERE CL_CODE IN (SELECT PARTY_CODE FROM BRANCH_SUBBROKER)                  
                 
				--- SELECT TOP 1 * FROM MSAJAG..CLIENT_DETAILS 
UPDATE C  SET BRANCH_CD=UPPER(BRANCH_CODE_NEW) ,                
SUB_BROKER=UPPER(SUB_BROKER_NEW),TRADER= UPPER(TRADER_NEW), AREA=UPPER(AREA_NEW),REGION=UPPER(REGION_NEW),SBU= UPPER(SBU_NEW),          
IMP_STATUS=0 ,                
MODIFIDEDBY=UPDATE_BY,MODIFIDEDON = GETDATE()
FROM BRANCH_SUBBROKER B  ,MSAJAG..CLIENT_DETAILS C                  
WHERE C.CL_CODE =B.PARTY_CODE           
          
INSERT INTO BRANCH_SHIFTING_LOG          
SELECT PARTY_CODE,BRANCH_CODE_OLD,SUB_BROKER_OLD,TRADER_OLD,AREA_OLD,REGION_OLD,SBU_OLD,BRANCH_CODE_NEW,
SUB_BROKER_NEW,TRADER_NEW,AREA_NEW,REGION_NEW,SBU_NEW,UPDATE_MODE,UPDATE_BY,GETDATE()--convert(datetime,UPDATE_ON,103)
 FROM BRANCH_SUBBROKER 

                
SELECT 'RECORDS UPDATED SUCCESSFULLY'                  
                
COMMIT TRAN                
                
             
--SELECT *FROM BRANCH_SUBBROKER                  
                
                
--SELECT BRANCH_CD,SUB_BROKER,* FROM MSAJAG..CLIENT_DETAILS  WHERE CL_CODE='S39059'                  
--SELECT BRANCH_CD,SUB_BROKER,* FROM MSAJAG..CLIENT_DETAILS_LOG WHERE CL_CODE='S39059'

GO
