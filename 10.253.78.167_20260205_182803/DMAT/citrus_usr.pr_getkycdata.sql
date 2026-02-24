-- Object: PROCEDURE citrus_usr.pr_getkycdata
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_getkycdata]      
(@pa_from_dt datetime,@pa_to_dt datetime)      
as      
begin      
    
IF @pa_from_dt  = ''    
SET @pa_from_dt  = CONVERT(DATETIME,CONVERT(VARCHAR(11),GETDATE()-7,109),109)    
    
IF @pa_to_dt    = ''    
SET @pa_to_dt  = CONVERT(DATETIME,CONVERT(VARCHAR(11),GETDATE(),109),109)    
    
    
      
exec kyc.dbo.getsinglekycdatafordp @pa_from_dt  ,@pa_to_dt      
  
declare @l_id numeric   
select @l_id  = max(isnull(sRefNo,0)) from tblerror_sql where  sModule = 'KYC DATA MIAGRATION'  
    
--SELECT * FROM TMP_CLIENT_DTLS_MSTR_CDSL_KYC WHERE TMPCLI_BOID NOT IN (SELECT DPAM_SBA_NO  FROM DP_ACCT_MSTR)    

exec dmat.citrus_usr.[PR_IMPORT_CLIENT_CDSL_KYC] 'CDSL','HO','normal','','*|~*','|*~|',''  

--if exists(select sRefNo from tblerror_sql where  sModule = 'KYC DATA MIAGRATION' and sRefNo > @l_id)       
--begin  
--  
--select 1/0   
--   
--end   
      
end

GO
