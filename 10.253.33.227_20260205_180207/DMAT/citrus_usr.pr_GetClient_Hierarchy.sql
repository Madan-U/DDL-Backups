-- Object: PROCEDURE citrus_usr.pr_GetClient_Hierarchy
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


-- pr_GetClient_Hierarchy 'BAJAJ','1201090003806276',''
-- pr_GetClient_Hierarchy 'HO','1201090000004621',''
CREATE procedure [citrus_usr].[pr_GetClient_Hierarchy]
(@pa_login_name varchar(50),
 @pa_boid varchar(20),
 @pa_out varchar(500) output
)
as
Begin 
declare @ent_id numeric,@entr_col_name varchar(50)
,@stam_cd varchar(10)
,@fre_id int

select  @ent_id = LOGN_ENT_ID from login_names where LOGN_NAME = @pa_login_name

select @stam_cd = dpam_stam_cd from dp_acct_mstr where dpam_sba_no=@pa_boid
if(@stam_cd <> 'ACTIVE')
begin 
	set @pa_out = 'ERROR! Client is not Active, Please check!'
	select @pa_out
return
end
-- comment as per mail from irfan alam dated 15/10/2015---
--select top 1 @fre_id = isnull(fre_id,0) 
--from freeze_unfreeze_dtls,dp_acct_mstr
--where fre_dpam_id = dpam_id
--and dpam_deleted_ind =1
--and fre_deleted_ind=1
--and fre_action = 'F'
--and dpam_sba_no=@pa_boid
--order by fre_lst_upd_by desc

--if(@fre_id <> 0)
--begin
--	set @pa_out = 'ERROR! Client is Freezed, Please check!'
--	select @pa_out
--return
--end
-- comment as per mail from irfan alam dated 15/10/2015---

select  @ent_id = LOGN_ENT_ID from login_names where LOGN_NAME = @pa_login_name

SELECT   @entr_col_name = entem.entem_entr_col_name       
  FROM   login_names               logn      
       , enttm_entr_mapping        entem      
       , entity_type_mstr          enttm      
  WHERE  logn.logn_enttm_id      = enttm.enttm_id AND entem.entem_enttm_cd = enttm.enttm_cd      
  AND    logn.logn_ent_id        = @ent_id  AND logn.logn_deleted_ind  = 1  AND entem.entem_deleted_ind = 1      
  AND    enttm.enttm_deleted_ind = 1  

select @pa_out=  ENTR_CRN_NO from entity_relationship where entr_sba = @pa_boid 
and case when @entr_col_name='ENTR_BR' then ENTR_BR
	     when @entr_col_name='ENTR_HO' then ENTR_HO	 
when @entr_col_name='ENTR_RE' then ENTR_RE
when @entr_col_name='ENTR_AR' then ENTR_AR
when @entr_col_name='ENTR_SB' then ENTR_SB
when @entr_col_name='ENTR_DUMMY1' then ENTR_DUMMY1
when @entr_col_name='ENTR_DUMMY3' then ENTR_DUMMY3
when @entr_col_name='ENTR_DUMMY4' then ENTR_DUMMY4
when @entr_col_name='ENTR_DUMMY5' then ENTR_DUMMY5
when @entr_col_name='ENTR_DUMMY6' then ENTR_DUMMY6
when @entr_col_name='ENTR_DUMMY7' then ENTR_DUMMY7
when @entr_col_name='ENTR_DUMMY8' then ENTR_DUMMY8
when @entr_col_name='ENTR_DUMMY9' then ENTR_DUMMY9
when @entr_col_name='ENTR_DUMMY10' then ENTR_DUMMY10 END = convert(varchar,@ent_id)

select @pa_out
end

GO
