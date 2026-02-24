-- Object: PROCEDURE citrus_usr.pr_ins_upd_uccdtls_dpb9
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



CREATE  proc [citrus_usr].[pr_ins_upd_uccdtls_dpb9]
as
begin  

update a set 
CUDM_UCC =UCC
--,CUDM_EXID=EXCHANGE_ID
,CUDM_EXID=case when EXCHANGE_ID='11' then '02' when EXCHANGE_ID='12' then '01' when EXCHANGE_ID='29' then '03' else EXCHANGE_ID end
,CUDM_CMID=CM_ID
,CUDM_TMCD=TM_CODE
,CUDM_SEGID=SEGMENT_CODE
,CUDM_LINKSTATUS =  case when pc22.LINK_STATUS = 'V' then 'VERIFIED' when pc22.LINK_STATUS = 'D' then 'DELINKED'  when pc22.LINK_STATUS = 'P' then 'PENDING'  ELSE  pc22.LINK_STATUS END 
--,CUDM_LINKSTATUS
--,CUDM_CONSENTFLG 
,CUDM_DPAM_ID= dpam_id 
,CUDM_LST_UPD_BY='DPB9'
,CUDM_LST_UPD_DT= getdate()
from CDSL_UCC_DTLS_MSTR a, dpb9_pc22 pc22, dp_acct_mstr 
where pc22.boid = cudm_boid and dpam_sba_no = cudm_boid 
and  CUDM_EXID = case when EXCHANGE_ID='11' then '02' when EXCHANGE_ID='12' then '01' when EXCHANGE_ID='29' then '03' else EXCHANGE_ID end
and CUDM_SEGID = SEGMENT_CODE
and CM_ID = CUDM_CMID
and UCC = CUDM_UCC
and TM_CODE = CUDM_TMCD

select identity(numeric,1,1) id , PURPOSECODE22
,FILLER1
,case when pc22.LINK_STATUS = 'V' then 'VERIFIED' when pc22.LINK_STATUS = 'D' then 'DELINKED'  when pc22.LINK_STATUS = 'P' then 'PENDING'  ELSE  pc22.LINK_STATUS END  LINK_STATUS
,FILLER2
,case when EXCHANGE_ID='11' then '02' when EXCHANGE_ID='12' then '01' when EXCHANGE_ID='29' then '03' else EXCHANGE_ID end EXCHANGE_ID
,UCC
,SEGMENT_CODE
,CM_ID
,TM_CODE
,BOId
,TransSystemDate
 into #missingpc22 from (select distinct PURPOSECODE22
,FILLER1
,LINK_STATUS
,FILLER2
,EXCHANGE_ID
,UCC
,SEGMENT_CODE
,CM_ID
,TM_CODE
,BOId
,TransSystemDate 
from dpb9_pc22 ) pc22 where not exists (select 1 from CDSL_UCC_DTLS_MSTR 
where  pc22.boid = cudm_boid
and  CUDM_EXID = case when EXCHANGE_ID='11' then '02' when EXCHANGE_ID='12' then '01' when EXCHANGE_ID='29' then '03' else EXCHANGE_ID end
and CUDM_SEGID = SEGMENT_CODE
and CM_ID = CUDM_CMID
and UCC = CUDM_UCC
and TM_CODE = CUDM_TMCD
)

declare @l_max_id numeric 
set @l_max_id = 1 

--select @l_max_id  = max(isnull(CUDM_ID,0)) from CDSL_UCC_DTLS_MSTR
select @l_max_id  = ISNULL (max(cudm_id),0) from CDSL_UCC_DTLS_MSTR

insert into CDSL_UCC_DTLS_MSTR
select id+@l_max_id , boid,UCC,EXCHANGE_ID,CM_ID,TM_CODE,SEGMENT_CODE,LINK_STATUS,'',dpam_id , 'MIG',getdate(),'MIG',getdate(),1
from dp_acct_mstr , #missingpc22 where boid  = dpam_sba_no 


end

GO
