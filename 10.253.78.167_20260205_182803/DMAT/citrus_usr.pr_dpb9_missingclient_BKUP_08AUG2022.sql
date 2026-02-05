-- Object: PROCEDURE citrus_usr.pr_dpb9_missingclient_BKUP_08AUG2022
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------



CREATE    procedure [citrus_usr].[pr_dpb9_missingclient_BKUP_08AUG2022]
(
-- exec pr_dpb9_missingclient 'Apr 15 2020' , 'Apr 15 2020' , 'Ho'
@pa_from_dt datetime
,@pa_to_dt datetime
,@pa_login_name varchar(100)
)
AS
BEGIN

select  ''''+ boid MISSINGBOID,'main table missing' descr
   from    dps8_pc1 where boid not in (select  dpam_sba_no from dp_acct_mstr) 
   and boid like '12033201%'
   union all

   
select ''''+ boid  ,'account opening date missing'  from dps8_pc1 where boid  in (
select DPAM_SBA_NO  from dp_acct_mstr where DPAM_ID not  in (select accp_clisba_id from account_properties
where ACCP_ACCPM_PROP_CD = 'bill_start_Dt')
and DPAM_SBA_NO <> DPAM_ACCT_NO 
and DPAM_STAM_CD = 'ACTIVE'
)
 
 and boid like '12033201%'
   order by 1 


end

GO
