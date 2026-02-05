-- Object: PROCEDURE citrus_usr.pr_getcitrusdata
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


--exec [pr_getcitrusdata] '',''

 
--begin tran
--exec [pr_getcitrusdata] 'jul 01 2017','jul 01 2017'
--commit
--EXEC [192.168.100.222].CRMDB.DBO.GETDP_DATA_FORDP  'apr 01 2014'  ,'apr 21 2014'      

CREATE proc [citrus_usr].[pr_getcitrusdata]      
(@pa_from_dt datetime,@pa_to_dt datetime)      
as      
begin      
    
IF @pa_from_dt  = ''    
SET @pa_from_dt  = CONVERT(DATETIME,CONVERT(VARCHAR(11),GETDATE()-7,109),109)    
    
IF @pa_to_dt    = ''    
SET @pa_to_dt  = CONVERT(DATETIME,CONVERT(VARCHAR(11),GETDATE(),109),109)    
    
    
--insert into TMP_CLIENT_DTLS_MSTR_CDSL_CITRUS
EXEC ABVSCITRUS.CRMDB_A.DBO.GETDP_DATA_FORDP_NEWDP  @pa_from_dt  ,@pa_to_dt      
--alter table TMP_CLIENT_DTLS_MSTR_CDSL_CITRUS alter column TMPCLI_BANK_ADD_LN1 varchar(100)

insert into TMP_CLIENT_DTLS_MSTR_CDSL_CITRUS_log 
SELECT * FROM TMP_CLIENT_DTLS_MSTR_CDSL_CITRUS WHERE TMPCLI_BOID NOT IN (SELECT DPAM_SBA_NO  FROM DP_ACCT_MSTR)
 AND  TMPCLI_BOID >'1203320100000000'
  
    

if exists(SELECT * FROM TMP_CLIENT_DTLS_MSTR_CDSL_CITRUS WHERE TMPCLI_BOID NOT IN (SELECT DPAM_SBA_NO  FROM DP_ACCT_MSTR)    )
begin 
exec citrus_usr.[PR_IMPORT_CLIENT_CDSL_CITRUS] 'CDSL','HO','normal','','*|~*','|*~|',''  

-- put condition on Feb 3 2016

Exec ABVSCITRUS.crmdb_a.dbo.Dp_Flag_update --''
/*
Update  CLEA
		Set CLEA_MIGRATE_STAT =1
	FROM  
		ABVSCITRUS.CRMDB_A.DBO.CLIENT_EXCHANGE CLEA,
			DP_ACCT_MSTR
	WHERE 
		CLEA.CLEA_DP_ACCTNO = DPAM_SBA_NO AND isnull(CLEA_MIGRATE_STAT,0) =0

-- put condition on Feb 3 2016  */

end 

--if exists(select sRefNo from tblerror_sql where  sModule = 'KYC DATA MIAGRATION' and sRefNo > @l_id)       
--begin  
--  
--select 1/0   
--   
--end   
      
end

GO
