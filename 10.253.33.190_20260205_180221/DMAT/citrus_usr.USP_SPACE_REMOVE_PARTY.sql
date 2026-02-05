-- Object: PROCEDURE citrus_usr.USP_SPACE_REMOVE_PARTY
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------



---|| CREATED DATE:- 21 OCT 2024  
---|| CREATED BY:- GANESH J  
---|| DESCRIPTION:- REMOVE SPACE IN PARTY CODE 
---|| CHANGEUNDER BELOW SRE--30734 
CREATE PROC USP_SPACE_REMOVE_PARTY   
----DECLARE @PARTY_CODE VARCHAR (20)=''  
AS  
BEGIN  
select Client_Code, NISE_PARTY_CODE into #clt  from  tbl_client_master where NISE_PARTY_CODE like '%	%'

begin tran  
Update a set  accp_value=TRIM(CONCAT(CHAR(9), CHAR(32)) FROM accp_value) from account_properties a  
where    ACCP_ACCPM_PROP_CD = 'bbo_code'  and accp_value like '%	%' 
Commit  

 begin tran  
update a set dpam_bbo_code=accp_value  from dp_acct_mstr  a (Nolock)  
,account_properties (Nolock)  
where isnull(dpam_bbo_code,'')<>accp_value  
--and accp_lst_upd_dt >='sep  1 2012'  
and accp_clisba_id = dpam_id  
and ACCP_ACCPM_PROP_CD = 'bbo_code' And DPAM_SBA_NO in (select client_code from #clt)  
--and isnull(dpam_bbo_code,'')<>accp_value  
COMMIT  

Update T Set NISE_PARTY_CODE =DPAM_BBO_CODE  from TBL_CLIENT_MASTER T (Nolock) ,DP_ACCT_MSTR D  (Nolock)  where client_code in (select client_code from #clt)  
and DPAM_SBA_NO =Client_Code  
UPDATE S Set CM_BLSAVINGCD= DPAM_BBO_CODE from Synergy_Client_Master S (Nolock) ,DP_ACCT_MSTR D (Nolock)  where  
 DPAM_SBA_NO =CM_CD  and CM_CD in (select client_code from #clt)  

 END

GO
