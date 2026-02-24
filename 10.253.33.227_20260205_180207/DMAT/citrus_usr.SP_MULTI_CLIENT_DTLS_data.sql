-- Object: PROCEDURE citrus_usr.SP_MULTI_CLIENT_DTLS_data
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



--exec Sp_Multi_Client_Dtls @PA_FROM_ACCTNO='1201090000004621',@PA_TO_ACCTNO='|*~|',@PA_EXCSMID=3,@pa_login_pr_entm_id=1,@pa_login_entm_cd_chain='HO|*~|'





--select * from dp_acct_mstr

--select * from client_mstr 







--sELECT * FROM ACCOUNT_PROPERTIES WHERE ACCP_ACCPM_PROP_CD LIKE  '%SMS%'



--exec SP_MULTI_CLIENT_DTLS @PA_FROM_ACCTNO='',@PA_TO_ACCTNO='|*~|T06621',@PA_EXCSMID=3,@pa_login_pr_entm_id=1,@pa_login_entm_cd_chain='HO|*~|'



--SP_MULTI_CLIENT_DTLS '10000037','10000037',4,1,0

--SP_MULTI_CLIENT_DTLS '1234567890123456','1234567890123456',3,1,0

CREATE  PROCEDURE [citrus_usr].[SP_MULTI_CLIENT_DTLS_data]

( 

@PA_FROM_ACCTNO VARCHAR(16),

@PA_TO_ACCTNO VARCHAR(30),

@PA_EXCSMID INT,

@pa_login_pr_entm_id numeric,              

@pa_login_entm_cd_chain  varchar(8000)   

) with recompile

AS

BEGIN -- MAIN







declare @l_bbo_code varchar(100)  

set @l_bbo_code =''  

set @l_bbo_code = citrus_usr.fn_splitval(@PA_TO_ACCTNO,2)  

SET @PA_TO_ACCTNO = citrus_usr.fn_splitval(@PA_TO_ACCTNO,1)  





 IF @PA_FROM_ACCTNO = ''  and    @l_bbo_code<>''     

 BEGIN            

  SET @PA_FROM_ACCTNO = '0'            

  SET @PA_TO_ACCTNO = '99999999999999999'            

 END            

 

--IF @PA_TO_ACCTNO = '' or @PA_TO_ACCTNO <> ''           

-- BEGIN        

--   SET @PA_TO_ACCTNO = @PA_FROM_ACCTNO            

-- END    



--print @PA_FROM_ACCTNO

--print @PA_TO_ACCTNO

--print @l_bbo_code



--

--

--select accp_value bbo ,dpam_sba_no clientid   

--into #bbocode  from account_properties , dp_Acct_mstr 

--where accp_accpm_prop_Cd='bbo_code'  

--and accp_clisba_id = dpam_id   

  

 --create clustered index ix_1 on #bbocode(clientid,bbo)  



DECLARE @@DPMID INT                     

SELECT @@DPMID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSMID AND DPM_DELETED_IND =1    

DECLARE @@L_CHILD_ENTM_ID      NUMERIC              

SELECT @@L_CHILD_ENTM_ID    =  CITRUS_USR.FN_GET_CHILD(@PA_LOGIN_PR_ENTM_ID , @PA_LOGIN_ENTM_CD_CHAIN)  



print @PA_FROM_ACCTNO

print @PA_to_ACCTNO



print '222'

print @@DPMID 

print @PA_LOGIN_PR_ENTM_ID

print @@L_CHILD_ENTM_ID

		SELECT distinct case when fre_action = 'F' then 'FREEZED' else STAM_DESC end [STATUS]

--DISTINCT top 1 case when fre_action = 'F' then 'FREEZED' else STAM_DESC end [STATUS]

		,CLICM_DESC  [CATEGORY]

		,SUBCM_DESC  [SUBCATEGORY]

		,ENTTM_DESC  [TYPE]

		

FROM DP_ACCT_MSTR DPAM

		LEFT OUTER JOIN 

        client_dp_brkg     on dpam_id = clidb_dpam_id  and getdate() between clidb_eff_from_dt and clidb_eff_to_dt

        LEFT OUTER JOIN 

      	brokerage_mstr on brom_id = clidb_brom_id  

        LEFT OUTER JOIN 

		DP_HOLDER_DTLS ON  DPAM_ID = DPHD_DPAM_ID AND DPHD_DELETED_IND =1

		LEFT OUTER JOIN 

		DP_POA_DTLS    ON   DPAM_ID = DPPD_DPAM_ID  AND DPPD_DELETED_IND =1

		left outer join

		CLIENT_BANK_ACCTS on DPAM_ID = CLIBA_CLISBA_ID and CLIBA_DELETED_IND = 1

		left outer join

		BANK_MSTR    on   CLIBA_BANM_ID      = BANM_ID and  BANM_DELETED_IND = 1

        left outer join

        bank_addresses_dtls on TMPBA_DP_BANK = banm_micr and TMPBA_DP_BR = banm_rtgs_cd

        left outer join 

        account_documents on accd_clisba_id = DPAM_ID and accd_deleted_ind = 1 and accd_accdocm_doc_id = 12

		,CLIENT_CTGRY_MSTR

		,ENTITY_TYPE_MSTR

		,STATUS_MSTR

		,SUB_CTGRY_MSTR 

		,CLIENT_MSTR

		--,CLIENT_BANK_ACCTS

		--,BANK_MSTR  

		,CITRUS_USR.FN_ACCT_LIST(@@DPMID ,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID) ACCOUNT 		       

		left outer join freeze_unfreeze_dtls on fre_Dpam_id = ACCOUNT.dpam_id and fre_deleted_ind = 1

	   

		WHERE isNumeric(dpam.DPAM_SBA_NO)=1 

        --and right(dpam.DPAM_SBA_NO,8)  BETWEEN @PA_FROM_ACCTNO AND @PA_TO_ACCTNO

        and dpam.DPAM_SBA_NO  BETWEEN @PA_FROM_ACCTNO AND @PA_TO_ACCTNO

		AND   DPAM.DPAM_CLICM_CD = CLICM_CD 

		AND   DPAM.DPAM_ENTTM_CD = ENTTM_CD

		AND   DPAM.DPAM_STAM_CD  = STAM_CD

		AND   DPAM.DPAM_SUBCM_CD = SUBCM_CD

		AND   CLICM_ID           = SUBCM_CLICM_ID

		AND   CLIM_CRN_NO        = DPAM.DPAM_CRN_NO 

		--AND   CLIBA_CLISBA_ID    = DPAM.DPAM_ID

		--AND   CLIBA_BANM_ID      = BANM_ID     

		AND   DPAM.DPAM_ID       = ACCOUNT.DPAM_ID

       -- and ISNULL(CITRUS_USR.FN_UCC_ACCP(dpam.DPAM_id,'BBO_CODE',''),'') like case when isnull(@l_bbo_code,'') ='' then '%' else @l_bbo_code end  --+ '%'

		and isnull(dpam_bbo_code ,'') like case when isnull(@l_bbo_code,'') ='' then '%' else @l_bbo_code end 

		

		--and exists(select clientid,bbo from #bbocode where clientid = dpam.dpam_sba_no and bbo = case when @l_bbo_code <> '' then @l_bbo_code else bbo end ) 

--

--truncate table #bbocode

--drop table #bbocode



END -- MAIN

GO
