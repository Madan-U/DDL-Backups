-- Object: PROCEDURE citrus_usr.pr_map_scancopy_reco_rpt
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*
--drop table maker_scancopy
create table maker_scancopy
(id numeric identity(1,1) 
,ref_no varchar(50)
,slip_no varchar(100)
,client_id varchar(16)
,entity varchar(100)
,entity_name varchar(250)
,scanimage image
,recon_flag char(1)
,recon_datetime datetime
,created_by varchar(50)
,created_dt datetime

,llst_upd_by varchar(50)
,lst_upd_dt datetime
,deleted_ind smallint
)

*/

CREATE proc [citrus_usr].[pr_map_scancopy_reco_rpt] (@pa_id numeric
,@pa_action varchar(25)
,@pa_ref_no varchar(50)
,@pa_slip_no varchar(100)
,@pa_client_id varchar(16)
,@pa_entity varchar(100)
,@pa_entity_name varchar(250)
,@pa_image varbinary(max)
,@pa_login_name varchar(150)
,@pa_remarks varchar(150)
,@pa_from_dt datetime
,@pa_to_dt datetime
,@pa_out varchar(8000) out)
as
begin 

select '40355' ref_no,
'103391406' slip_no,
'1201090002435340' client_id,
 '01/20/2012 12:11:02'  date_of_execution,
'RETAILCAL_BA' entity_name,
'' scanimage,
null recon_flag,
'CALCUTTA' created_by,
null remarks,
 '' recon_datetime,
'33425' highval,
'NO' highvalyn,
'APPROVED' makstatus,
'SIGNATURE MISMATCH' remarks1,
'' DPTDC_EXECUTION_DT,
'' code_1200,
'' name_1200,
'' contact_no_1200_code,
'' email_1200_code,
-- convert(datetime,'05/20/2014 12:11:02',105)- convert(datetime,'05/20/2012 12:11:02',105) num_days_date_execution
'05/20/2012 12:11:02' num_days_date_execution
from  temppr_map_scancopy_rec

 
--num_days_date_execution [varchar](8000) NULL
return
 declare @@l_child_entm_id numeric
 ,@l_entm_short_name varchar(250)
 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_entity , @pa_entity_name)
 if @@l_child_entm_id    <> 0 
 select @l_entm_short_name = entm_short_name from entity_mstr where entm_id = @@l_child_entm_id    

 if @@l_child_entm_id    = 0 
 select @l_entm_short_name = entm_short_name from entity_mstr where entm_id = 1


if @pa_action = 'SELECT_SEARCH'
begin 
		select Distinct DPTDC_DTLS_ID,DPTDC_SLIP_NO,dpam_sba_no,entm_enttm_cd   ,entm_short_name
		from dptdc_mak , dp_acct_mstr 
		, login_names
		, entity_mstr 
		where dptdc_deleted_ind in (0,6,-1)
		and DPTDC_DPAM_ID = dpam_id 
		and logn_ent_id = entm_id 
		and logn_name = dptdc_created_by
		and logn_deleted_ind = 1 
		and entm_deleted_ind = 1
		and DPTDC_DTLS_ID like  '%' +  @pa_ref_no  + '%'		
		--and DPTDC_SLIP_NO  = @pa_slip_no  
		and DPTDC_SLIP_NO  like  '%' + @pa_slip_no  + '%'	 
		and isnull(DPTDC_SLIP_NO,'') <> ''
		and DPTDC_SLIP_NO  not in (select slip_no from maker_scancopy where deleted_ind = 1)
end 
if @pa_action = 'INS'
begin 

	if exists(select * from maker_scancopy where ref_no = @pa_ref_no and slip_no = @pa_slip_no and deleted_ind = 1)
	begin 
	
	set @pa_out = 'Data already Exists ,Please check'
	
	return 
	
	end 
	
	insert into maker_scancopy(ref_no,slip_no,client_id,entity,entity_name,scanimage,created_by,created_dt,llst_upd_by,lst_upd_dt,deleted_ind)
	select @pa_ref_no,@pa_slip_no,@pa_client_id,@pa_entity,@pa_entity_name,@pa_image,@pa_login_name,getdate()
	,@pa_login_name , getdate(), 1 
	
	
end 
if @pa_action = 'EDT'
begin 

	
	update maker_scancopy
	set ref_no = @pa_ref_no
	,slip_no = @pa_slip_no
	,client_id = @pa_client_id
	,entity = @pa_entity
	,entity_name = @pa_entity_name
	,scanimage = @pa_image
	,llst_upd_by = @pa_login_name
	,lst_upd_dt = getdate()
	where id = @pa_id 
	
	
end 
if @pa_action = 'DEL'
begin 
	
	update maker_scancopy
	set deleted_ind = 0 
	,llst_upd_by = @pa_login_name
	,lst_upd_dt = getdate()
	where id = @pa_id 	
end 

--if @pa_action = 'SELECT_FOR_RECO'
--begin 
--	
--if (@pa_from_dt<>'' and 	@pa_to_dt<>'' )
--begin 
--select ref_no,slip_no,client_id,entity_name,scanimage,recon_flag,created_by,remarks,recon_datetime
--	,highval = convert(numeric,isnull((Select sum(abs(clopm_Cdsl_rt*dptdc_qty))  
--                from dptdc_mak , closing_price_mstr_cdsl
--				Where CLOPM_ISIN_CD = dptdc_isin
--				And CLOPM_DT = dptdc_execution_dt
--				And dptdc_deleted_ind in (0,-1,1)
--				And dptdc_slip_no = slip_no),0))
--	,highvalyn = case when exists(select dptdc_mid_chk from dptdc_mak where dptdc_slip_no = slip_no and dptdc_deleted_ind =1 and isnull(dptdc_mid_chk,'')<>'' ) then 'Yes' else 'No' end
--     -- ,highvalyn = [citrus_usr].[fn_get_high_val](dptdc_isin_cd,dptdc_qty,'HIGH_VALUE','','')
--	 -- ,dormantyn = [citrus_usr].[fn_get_high_val](dptdc_isin_cd,dptdc_qty,'DORMANT','','')	
--    from maker_scancopy 
--	where  ref_no like  '%' +  isnull(@pa_ref_no,'')  + '%'
--	and slip_no like  '%' +  isnull(@pa_slip_no,'')  + '%'
--    and case when @pa_remarks ='R' then recon_datetime else created_dt end between  @pa_from_dt and @pa_to_dt + ' 23:59:59'
--	and deleted_ind = 1    
--	and isnull(recon_flag,'')  like  case when @pa_remarks = 'P' then '' 
--						 when @pa_remarks = 'R' then 'Y' 
--                         when @pa_remarks = 'A' then '%' end  
--    and entity_name like case when @l_entm_short_name = 'HO' then '%' else @l_entm_short_name end
----	and slip_no <> (select dptdc_slip_no from DP_TRX_DTLS_CDSL where dptdc_slip_no =  '%' +  isnull(@pa_ref_no,'')  + '%')
--end 
--else
--begin 
--select ref_no,slip_no,client_id,entity_name,scanimage,recon_flag,created_by,remarks,recon_datetime
--	,highval = convert(numeric,isnull((Select sum(abs(clopm_Cdsl_rt*dptdc_qty))  
--                from dptdc_mak , closing_price_mstr_cdsl
--				Where CLOPM_ISIN_CD = dptdc_isin
--				And CLOPM_DT = dptdc_execution_dt
--				And dptdc_deleted_ind in (0,-1,1)
--				And dptdc_slip_no = slip_no),0))
--	,highvalyn = case when exists(select dptdc_mid_chk from dptdc_mak where dptdc_slip_no = slip_no and dptdc_deleted_ind =1 and isnull(dptdc_mid_chk,'')<>'' ) then 'Yes' else 'No' end
--     -- ,highvalyn = [citrus_usr].[fn_get_high_val](dptdc_isin_cd,dptdc_qty,'HIGH_VALUE','','')
--	 -- ,dormantyn = [citrus_usr].[fn_get_high_val](dptdc_isin_cd,dptdc_qty,'DORMANT','','')	
--    from maker_scancopy 
--	where  ref_no like  '%' +  isnull(@pa_ref_no,'')  + '%'
--	and slip_no like  '%' +  isnull(@pa_slip_no,'')  + '%'
--   -- and created_dt between   @pa_from_dt and @pa_to_dt + ' 23:59:59'
--	and deleted_ind = 1    
--	and isnull(recon_flag,'')  like  case when @pa_remarks = 'P' then '' 
--						 when @pa_remarks = 'R' then 'Y' 
--                         when @pa_remarks = 'A' then '%' end  
--    and entity_name like case when @l_entm_short_name = 'HO' then '%' else @l_entm_short_name end
--end 
--    
--end 
if @pa_action = 'SELECT_FOR_RECO'
begin 

if (@pa_from_dt<>'' and @pa_to_dt<>'' )
begin 	
	if @pa_client_id = 'M'	
		begin		

		select ref_no,slip_no,client_id,entity_name,scanimage,recon_flag,created_by,remarks ,convert(varchar(11),convert(datetime,recon_datetime),103) recon_datetime
		,highval = convert(numeric(18,2),isnull((Select sum(abs(clopm_Cdsl_rt*dptdc_qty)) from dptdc_mak , CLOSING_LAST_CDSL--closing_price_mstr_cdsl
					Where CLOPM_ISIN_CD = dptdc_isin
					--And CLOPM_DT = dptdc_execution_dt
					And dptdc_deleted_ind in (0,-1,1)
					And dptdc_slip_no = slip_no),0))
		--,highvalyn = case when isnull(dptdc_mid_chk ,'') = '' then 'No' else 'Yes' end
,highvalyn = --Dormain + '/' + 
Highval
--exists(select distinct dptdc_mid_chk from dptdc_mak where dptdc_slip_no = slip_no and dptdc_deleted_ind =1 ) then 'Yes' else 'No' end
		,case when (dptdc_deleted_ind = 0 and dptdc_mid_chk <> '' and dptdc_res_desc ='') then 'First checker done'
			  when (dptdc_deleted_ind = 0  and dptdc_res_desc <>'') then 'Rejected'
			  when ((dptdc_deleted_ind = 0 or dptdc_deleted_ind = -1) and dptdc_mid_chk = '') then 'Pending for Verification'
			  --when (dptdc_deleted_ind = 0 and dptdc_res_desc <> '') then 'Rejected' 
			  when dptdc_deleted_ind = 1 then 'Approved' end makstatus
		    , case when (dptdc_deleted_ind = 0 and dptdc_res_desc <> '') then  dptdc_res_desc else dptdc_rmks end  remarks1
			,case when (dptdc_deleted_ind = 0  and dptdc_res_desc <>'') then convert(varchar(11),dptdc.dptdc_lst_upd_dt ,109) else convert(varchar(11),dptdc.dptdc_execution_dt ,109) end dptdc_execution_dt
			,DATEDIFF(day, dptdc.dptdc_lst_upd_dt, GETDATE()+ 1) Ageing
			,(select distinct top 1 rol_desc 
			from roles,entity_roles
			where rol_id = entro_rol_id
			and entro_deleted_ind=1
			and entro_logn_name = created_by) Role
	--case when [citrus_usr].[fn_get_high_val](dptdc_isin,dptdc_qty,'HIGH_VALUE',client_id,'')='Y' then 'Yes' else 'No' end
		from maker_scancopy,(select distinct dptdc_rmks,dptdc_deleted_ind ,dptdc_mid_chk,dptdc_res_desc,dptdc_slip_no
,convert(varchar(11),dptdc_created_dt ,109) dptdc_created_dt
,convert(varchar(11),dptdc_execution_dt ,109) dptdc_execution_dt
,dptdc_lst_upd_dt
--,DPTDC_ISIN
--,DPTDC_QTY
--,DPTDC_REQUEST_DT
--,case when [citrus_usr].[fn_get_high_val_new]('DORMANT',dptdc_slip_no) ='N' then 'NO' else 'YES' end Dormain
,case when [citrus_usr].[fn_get_high_val_new]('HIGH_VALUE',dptdc_slip_no)= 'N' then 'NO' else 'YES' end Highval
,dptdc_dpam_id  
from  dptdc_mak
where dptdc_lst_upd_dt between   @pa_from_dt and @pa_to_dt + ' 23:59:59'
and dptdc_slip_no like case when @pa_slip_no = '' then '%' else @pa_slip_no end ) dptdc
		where  ref_no like  '%' +  isnull(@pa_ref_no,'')  + '%'
		and slip_no like  '%' +  isnull(@pa_slip_no,'')  + '%'
		and  dptdc_created_dt between   @pa_from_dt and @pa_to_dt + ' 23:59:59'			 
		and deleted_ind = 1    
		and dptdc_slip_no = slip_no
		--and dptdc_deleted_ind =1
		and dptdc_deleted_ind in (0,1)
		and isnull(recon_flag,'')  like  case when @pa_remarks = 'P' then '' 
							 when @pa_remarks = 'R' then 'Y' 
							 when @pa_remarks = 'A' then '%' end  
		and entity_name like case when @l_entm_short_name = 'HO' then '%' else @l_entm_short_name end
		--	and slip_no <> (select dptdc_slip_no from DP_TRX_DTLS_CDSL where dptdc_slip_no =  '%' +  isnull(@pa_ref_no,'')  + '%')
		end

if @pa_client_id = 'C'
	begin
print 'C'
--	select ref_no,slip_no,client_id,entity_name,scanimage,recon_flag,created_by,remarks ,recon_datetime
--	,highval = convert(numeric(18,2),isnull((Select sum(abs(clopm_Cdsl_rt*dptdc_qty)) from dptdc_mak , closing_price_mstr_cdsl
--				Where CLOPM_ISIN_CD = dptdc_isin
--				And CLOPM_DT = dptdc_execution_dt
--				And dptdc_deleted_ind in (0,-1,1)
--				And dptdc_slip_no = slip_no),0))
--	,highvalyn = case when exists(select distinct dptdc_mid_chk from dptdc_mak where dptdc_slip_no =@pa_slip_no and dptdc_deleted_ind =1 ) then 'Yes' else 'No' end
----case when [citrus_usr].[fn_get_high_val](dptdc_isin,dptdc_qty,'HIGH_VALUE',client_id,'')='Y' then 'Yes' else 'No' end
--,case when (d1.dptdc_deleted_ind = 0 and d1.dptdc_mid_chk <> '') then 'First checker done'
--			  when ((d1.dptdc_deleted_ind = 0 or d1.dptdc_deleted_ind = -1) and d1.dptdc_mid_chk = '') then 'Pending for Verification'
--			  when (d1.dptdc_deleted_ind = 0 and d1.dptdc_res_desc <> '') then 'Rejected' 
--			  when d1.dptdc_deleted_ind = 1 then 'Approved' end makstatus
--		--,d.dptdc_rmks  remarks1
--,case when (d1.dptdc_deleted_ind = 0 and d1.dptdc_res_desc <> '') then  d1.dptdc_res_desc else d.dptdc_rmks end  remarks1
--    from maker_scancopy,dp_trx_dtls_cdsl d,dptdc_mak d1
--	where  ref_no like  '%' +  isnull(@pa_ref_no,'')  + '%'
--	and slip_no like  '%' +  isnull(@pa_slip_no,'')  + '%'
--    and  d1.dptdc_lst_upd_dt between   @pa_from_dt and @pa_to_dt + ' 23:59:59'			 
--	and deleted_ind =1
--	and d.dptdc_slip_no = slip_no
--	and d1.dptdc_slip_no = slip_no
--	and d1.dptdc_deleted_ind in(0,1)  
--	and isnull(recon_flag,'')  like  case when @pa_remarks = 'P' then '' 
--						 when @pa_remarks = 'R' then 'Y' 
--                         when @pa_remarks = 'A' then '%' end  
--    and entity_name like case when @l_entm_short_name = 'HO' then '%' else @l_entm_short_name end
--	--	and slip_no <> (select dptdc_slip_no from DP_TRX_DTLS_CDSL where dptdc_slip_no =  '%' +  isnull(@pa_ref_no,'')  + '%')

select ref_no,slip_no,client_id,entity_name,scanimage,recon_flag,created_by,remarks ,convert(varchar(11),convert(datetime,recon_datetime),103) recon_datetime
		,highval = convert(numeric(18,2),isnull((Select sum(abs(clopm_Cdsl_rt*dptdc_qty)) from dptdc_mak , CLOSING_LAST_CDSL--closing_price_mstr_cdsl
					Where CLOPM_ISIN_CD = dptdc_isin
					--And CLOPM_DT = dptdc_execution_dt
					And dptdc_deleted_ind in (0,-1,1)
					And dptdc_slip_no = slip_no),0))
		--,highvalyn = case when isnull(dptdc_mid_chk ,'') = '' then 'No' else 'Yes' end
,highvalyn = --Dormain + '/' +
 Highval
--case when exists(select distinct dptdc_mid_chk from dptdc_mak where dptdc_slip_no =slip_no and dptdc_deleted_ind =1 ) then 'Yes' else 'No' end
		,case when (dptdc_deleted_ind = 0 and dptdc_mid_chk <> '' and dptdc_res_desc ='') then 'First checker done'
			  when (dptdc_deleted_ind = 0  and dptdc_res_desc <>'') then 'Rejected'
			  when ((dptdc_deleted_ind = 0 or dptdc_deleted_ind = -1) and dptdc_mid_chk = '') then 'Pending for Verification'
			  --when (dptdc_deleted_ind = 0 and dptdc_res_desc <> '') then 'Rejected' 
			  when dptdc_deleted_ind = 1 then 'Approved' end makstatus
		, case when (dptdc_deleted_ind = 0 and dptdc_res_desc <> '') then  dptdc_res_desc else dptdc_rmks end  remarks1
		,case when (dptdc_deleted_ind = 0  and dptdc_res_desc <>'') then convert(varchar(11),dptdc.dptdc_lst_upd_dt ,109) else convert(varchar(11),dptdc.dptdc_execution_dt ,109) end dptdc_execution_dt
		,DATEDIFF(day, dptdc.dptdc_lst_upd_dt, GETDATE()+ 1) Ageing
		,(select distinct top 1 rol_desc 
			from roles,entity_roles
			where rol_id = entro_rol_id
			and entro_deleted_ind=1
			and entro_logn_name = created_by) Role
	--case when [citrus_usr].[fn_get_high_val](dptdc_isin,dptdc_qty,'HIGH_VALUE',client_id,'')='Y' then 'Yes' else 'No' end
		from maker_scancopy,(select distinct dptdc_rmks,dptdc_deleted_ind ,dptdc_mid_chk,dptdc_res_desc
,dptdc_slip_no
,convert(varchar(11),dptdc_lst_upd_dt ,109) dptdc_lst_upd_dt
,convert(varchar(11),dptdc_execution_dt ,109) dptdc_execution_dt
--,DPTDC_ISIN
--,DPTDC_QTY
--,DPTDC_REQUEST_DT
--,case when [citrus_usr].[fn_get_high_val_new]('DORMANT',dptdc_slip_no) ='N' then 'NO' else 'YES' end Dormain
,case when [citrus_usr].[fn_get_high_val_new]('HIGH_VALUE',dptdc_slip_no)= 'N' then 'NO' else 'YES' end Highval

,dptdc_dpam_id from   dptdc_mak
where dptdc_lst_upd_dt between   @pa_from_dt and @pa_to_dt + ' 23:59:59'
and dptdc_slip_no like case when @pa_slip_no = '' then '%' else @pa_slip_no end 
) dptdc
		where  ref_no like  '%' +  isnull(@pa_ref_no,'')  + '%'
		and slip_no like  '%' +  isnull(@pa_slip_no,'')  + '%'
		--and  dptdc_created_dt between   @pa_from_dt and @pa_to_dt + ' 23:59:59'			 
		and  dptdc_lst_upd_dt between   @pa_from_dt and @pa_to_dt + ' 23:59:59'	
		and deleted_ind = 1    
		and dptdc_slip_no = slip_no
		--and dptdc_deleted_ind =1
		and dptdc_deleted_ind in (0,1)
		and isnull(recon_flag,'')  like  case when @pa_remarks = 'P' then '' 
							 when @pa_remarks = 'R' then 'Y' 
							 when @pa_remarks = 'A' then '%' end  
		and entity_name like case when @l_entm_short_name = 'HO' then '%' else @l_entm_short_name end
    end
end
else
begin 
--	select ref_no,slip_no,client_id,entity_name,scanimage,recon_flag,created_by,remarks,recon_datetime
--	,highval = convert(numeric,isnull((Select sum(abs(clopm_Cdsl_rt*dptdc_qty))  
--                from dptdc_mak , closing_price_mstr_cdsl
--				Where CLOPM_ISIN_CD = dptdc_isin
--				And CLOPM_DT = dptdc_execution_dt
--				And dptdc_deleted_ind in (0,-1,1)
--				And dptdc_slip_no = slip_no),0))
--	,highvalyn = case when exists(select dptdc_mid_chk from dptdc_mak where dptdc_slip_no = slip_no and dptdc_deleted_ind =1 and isnull(dptdc_mid_chk,'')<>'' ) then 'Yes' else 'No' end
--     -- ,highvalyn = [citrus_usr].[fn_get_high_val](dptdc_isin_cd,dptdc_qty,'HIGH_VALUE','','')
--	 -- ,dormantyn = [citrus_usr].[fn_get_high_val](dptdc_isin_cd,dptdc_qty,'DORMANT','','')	
--    from maker_scancopy 
--	where  ref_no like  '%' +  isnull(@pa_ref_no,'')  + '%'
--	and slip_no like  '%' +  isnull(@pa_slip_no,'')  + '%'
--   -- and created_dt between   @pa_from_dt and @pa_to_dt + ' 23:59:59'
--	and deleted_ind = 1    
--	and isnull(recon_flag,'')  like  case when @pa_remarks = 'P' then '' 
--						 when @pa_remarks = 'R' then 'Y' 
--                         when @pa_remarks = 'A' then '%' end  
--    and entity_name like case when @l_entm_short_name = 'HO' then '%' else @l_entm_short_name end
select ref_no,slip_no,client_id,entity_name,scanimage,recon_flag,created_by,remarks , convert(varchar(11),convert(datetime,recon_datetime),103) recon_datetime
		,highval = convert(numeric(18,2),isnull((Select sum(abs(clopm_Cdsl_rt*dptdc_qty)) from dptdc_mak ,CLOSING_LAST_CDSL-- closing_price_mstr_cdsl
					Where CLOPM_ISIN_CD = dptdc_isin
					--And CLOPM_DT = dptdc_execution_dt
					And dptdc_deleted_ind in (0,-1,1)
					And dptdc_slip_no = slip_no),0))
		--,highvalyn = case when isnull(dptdc_mid_chk ,'') = '' then 'No' else 'Yes' end
,highvalyn = --Dormain + '/' + 
Highval
--case when exists(select distinct dptdc_mid_chk from dptdc_mak where dptdc_slip_no =slip_no and dptdc_deleted_ind =1 ) then 'Yes' else 'No' end
		,case when (dptdc_deleted_ind = 0 and dptdc_mid_chk <> '' and dptdc_res_desc ='') then 'First checker done'
			  when (dptdc_deleted_ind = 0  and dptdc_res_desc <>'') then 'Rejected'
			  when ((dptdc_deleted_ind = 0 or dptdc_deleted_ind = -1) and dptdc_mid_chk = '') then 'Pending for Verification'
			  --when (dptdc_deleted_ind = 0 and dptdc_res_desc <> '') then 'Rejected' 
			  when dptdc_deleted_ind = 1 then 'Approved' end makstatus
		, case when (dptdc_deleted_ind = 0 and dptdc_res_desc <> '') then  dptdc_res_desc else dptdc_rmks end  remarks1
		,case when (dptdc_deleted_ind = 0  and dptdc_res_desc <>'') then convert(varchar(11),dptdc.dptdc_lst_upd_dt ,109) else convert(varchar(11),dptdc.dptdc_execution_dt ,109) end dptdc_execution_dt
		,DATEDIFF(day, dptdc.dptdc_lst_upd_dt, GETDATE()+ 1) Ageing
		,(select distinct top 1 rol_desc 
			from roles,entity_roles
			where rol_id = entro_rol_id
			and entro_deleted_ind=1
			and entro_logn_name = created_by) Role
	--case when [citrus_usr].[fn_get_high_val](dptdc_isin,dptdc_qty,'HIGH_VALUE',client_id,'')='Y' then 'Yes' else 'No' end
		from maker_scancopy,(select distinct dptdc_rmks,dptdc_deleted_ind ,dptdc_mid_chk,dptdc_res_desc
,dptdc_slip_no
,convert(varchar(11),dptdc_lst_upd_dt ,109) dptdc_lst_upd_dt 
,convert(varchar(11),dptdc_execution_dt ,109) dptdc_execution_dt

--,convert(varchar(11),dptdc_request_dt ,109) dptdc_request_dt
--,DPTDC_ISIN
--,DPTDC_QTY
--,case when [citrus_usr].[fn_get_high_val_new]('DORMANT',dptdc_slip_no) ='N' then 'NO' else 'YES' end Dormain
,case when [citrus_usr].[fn_get_high_val_new]('HIGH_VALUE',dptdc_slip_no)= 'N' then 'NO' else 'YES' end Highval
,dptdc_dpam_id from   dptdc_mak where dptdc_slip_no like case when @pa_slip_no ='' then '%' else @pa_slip_no end 
										) dptdc
		where  ref_no like  '%' +  isnull(@pa_ref_no,'')  + '%'
		and slip_no like  '%' +  isnull(@pa_slip_no,'')  + '%'
		--and  dptdc_request_dt between   @pa_from_dt and @pa_to_dt + ' 23:59:59'			 
		and deleted_ind = 1    
		and dptdc_slip_no = slip_no
		--and dptdc_deleted_ind =1
	and dptdc_deleted_ind in (0,1)
		and isnull(recon_flag,'')  like  case when @pa_remarks = 'P' then '' 
							 when @pa_remarks = 'R' then 'Y' 
							 when @pa_remarks = 'A' then '%' end  
		and entity_name like case when @l_entm_short_name = 'HO' then '%' else @l_entm_short_name end
end
end 
if @pa_action = 'SELECT'
begin 

	
	select ref_no,slip_no,client_id,entity,entity_name,scanimage,recon_flag,recon_datetime,created_by,created_dt,llst_upd_by,lst_upd_dt,deleted_ind,id from maker_scancopy 
	where  ref_no like  '%' +  @pa_ref_no  + '%'
	and slip_no like  '%' +  @pa_slip_no  + '%'
	and deleted_ind = 1 
	
	
end 

if @pa_action = 'RECO_UPD'
begin 
	print @pa_remarks
	update maker_scancopy  set recon_flag ='Y',remarks = @pa_remarks
	,recon_datetime = @pa_client_id -- getdate()
	where ref_no like  '%' +  @pa_ref_no  + '%'  
	and slip_no like  '%' +  @pa_slip_no  + '%'
    and deleted_ind = 1 
    
end 

end

GO
