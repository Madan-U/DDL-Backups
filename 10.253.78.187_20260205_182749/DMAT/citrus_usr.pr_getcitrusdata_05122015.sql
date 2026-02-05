-- Object: PROCEDURE citrus_usr.pr_getcitrusdata_05122015
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec [pr_getcitrusdata] '',''







--begin tran

--exec [pr_getcitrusdata] 'jul 18 2013','jul 25 2013'

--rollback

CREATE proc [citrus_usr].[pr_getcitrusdata_05122015]      

(@pa_from_dt datetime,@pa_to_dt datetime)      

as      

begin      

    

IF @pa_from_dt  = ''    

SET @pa_from_dt  = CONVERT(DATETIME,CONVERT(VARCHAR(11),GETDATE()-7,109),109)    

    

IF @pa_to_dt    = ''    

SET @pa_to_dt  = CONVERT(DATETIME,CONVERT(VARCHAR(11),GETDATE(),109),109)    

    

    

--insert into TMP_CLIENT_DTLS_MSTR_CDSL_CITRUS

exec [192.168.100.222].citrus.citrus_usr.getcitrusdatafordp @pa_from_dt  ,@pa_to_dt      

--alter table TMP_CLIENT_DTLS_MSTR_CDSL_CITRUS alter column TMPCLI_BANK_ADD_LN1 varchar(100)

    

SELECT * FROM TMP_CLIENT_DTLS_MSTR_CDSL_CITRUS WHERE TMPCLI_BOID NOT IN (SELECT DPAM_SBA_NO  FROM DP_ACCT_MSTR)    





exec [PR_IMPORT_CLIENT_CDSL_CITRUS] 'CDSL','HO','normal','','*|~*','|*~|',''  



--if exists(select sRefNo from tblerror_sql where  sModule = 'KYC DATA MIAGRATION' and sRefNo > @l_id)       

--begin  

--  

--select 1/0   

--   

--end   

      

end

GO
