-- Object: PROCEDURE citrus_usr.PR_SELECT_TRXGEN_NSDL_SP_XML_REMEDYERROFFMKT
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[PR_SELECT_TRXGEN_NSDL_SP_XML_REMEDYERROFFMKT]  
(  
@PA_TRX_TAB VARCHAR(8000),  
@PA_FROM_DT VARCHAR(20),  
@PA_TO_DT VARCHAR(20),  
@PA_BATCH_NO VARCHAR(10),  
@PA_BATCH_TYPE VARCHAR(2),  
@PA_EXCSM_ID INT,  
@PA_LOGINNAME VARCHAR(20),  
@PA_POOL_ACCTNO VARCHAR(100),
@PA_BROKER_YN CHAR(1), 
@ROWDELIMITER VARCHAR(20),  
@COLDELIMITER VARCHAR(20),  
@PA_OUTPUT VARCHAR(20) OUTPUT  
)  
AS  
BEGIN 


declare @l_dpm_id numeric
select  @l_dpm_id  = dpm_id from dp_mstr where dpm_excsm_id = @PA_EXCSM_ID  and dpm_excsm_id = default_dp and dpm_deleted_ind = 1 

DECLARE  @SLIIM TABLE (PA_SLIIM_ID INT)




DECLARE @@RM_ID              VARCHAR(8000)                    
      , @@CUR_ID             VARCHAR(8000)                    
      , @@FOUNDAT            INT                    
      , @@DELIMETERLENGTH    INT                   
      , @@DELIMETER          CHAR(1)               
      , @C_CRN_NO            NUMERIC                     
      , @C_DPAM_ID           NUMERIC                                                                   
      , @C_ACCT_NO           VARCHAR(25)                                                                     
      , @C_SBA_NO            VARCHAR(20)          
      , @L_CRN_NO            NUMERIC                  
      , @L_ACCT_NO           VARCHAR(25)                    
      , @L_VALUE             VARCHAR(8000)                  
      , @L_CLIENT_TYPE       VARCHAR(100)                  
      , @L_CHK               NUMERIC                  
      , @L_CTGRY_CHK         NUMERIC  


	  
SELECT convert(varchar,EOFFM_SELLER_BOID) + '|' + EOFFM_BO_TYPE + '|' + convert(varchar,EOFFM_BOID) + '|' + EOFFM_EXEM_FLAG + '|' + convert(varchar,EOFFM_BUYER_PAN) as details FROM ERR_OFFMKT_MSTR WHERE EOFFM_CREATED_DT  BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' 
AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   AND EOFFM_DELETED_IND=1
and isnull(EOFFM_BATCH_NO,'')=''

UPDATE ERR_OFFMKT_MSTR SET EOFFM_BATCH_NO=@PA_BATCH_NO FROM ERR_OFFMKT_MSTR WHERE EOFFM_CREATED_DT  BETWEEN  CONVERT(VARCHAR,CONVERT(DATETIME, @PA_FROM_DT,103),106)+' 00:00:00' 
AND CONVERT(VARCHAR,CONVERT(DATETIME,@PA_TO_DT,103),106)+' 23:59:59'   AND EOFFM_DELETED_IND=1
and isnull(EOFFM_BATCH_NO,'')=''

--  
END 
 

--

GO
