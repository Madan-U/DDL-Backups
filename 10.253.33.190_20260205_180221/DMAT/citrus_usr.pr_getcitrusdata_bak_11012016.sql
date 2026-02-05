-- Object: PROCEDURE citrus_usr.pr_getcitrusdata_bak_11012016
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


--exec [pr_getcitrusdata] '',''



--begin tran
--exec [pr_getcitrusdata] 'apr 21 2014','apr 21 2014'
--commit
--EXEC [192.168.100.222].CRMDB.DBO.GETDP_DATA_FORDP  'apr 01 2014'  ,'apr 21 2014'      

create proc [citrus_usr].[pr_getcitrusdata_bak_11012016]      
(@pa_from_dt datetime,@pa_to_dt datetime)      
as      
begin      
    
IF @pa_from_dt  = ''    
SET @pa_from_dt  = CONVERT(DATETIME,CONVERT(VARCHAR(11),GETDATE()-7,109),109)    
    
IF @pa_to_dt    = ''    
SET @pa_to_dt  = CONVERT(DATETIME,CONVERT(VARCHAR(11),GETDATE(),109),109)    
    
    
--insert into TMP_CLIENT_DTLS_MSTR_CDSL_CITRUS
EXEC [172.31.16.57].CRMDB_A.DBO.GETDP_DATA_FORDP  @pa_from_dt  ,@pa_to_dt      
--alter table TMP_CLIENT_DTLS_MSTR_CDSL_CITRUS alter column TMPCLI_BANK_ADD_LN1 varchar(100)

insert into TMP_CLIENT_DTLS_MSTR_CDSL_CITRUS_log 
SELECT * FROM TMP_CLIENT_DTLS_MSTR_CDSL_CITRUS WHERE TMPCLI_BOID NOT IN (SELECT DPAM_SBA_NO  FROM DP_ACCT_MSTR)
  
    

if exists(SELECT * FROM TMP_CLIENT_DTLS_MSTR_CDSL_CITRUS WHERE TMPCLI_BOID NOT IN (SELECT DPAM_SBA_NO  FROM DP_ACCT_MSTR)    )
begin 
exec citrus_usr.[PR_IMPORT_CLIENT_CDSL_CITRUS] 'CDSL','HO','normal','','*|~*','|*~|',''  
end 

--if exists(select sRefNo from tblerror_sql where  sModule = 'KYC DATA MIAGRATION' and sRefNo > @l_id)       
--begin  
--  
--select 1/0   
--   
--end   
      
end

GO
