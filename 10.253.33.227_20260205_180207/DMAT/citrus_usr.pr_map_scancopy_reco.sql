-- Object: PROCEDURE citrus_usr.pr_map_scancopy_reco
-- Server: 10.253.33.227 | DB: DMAT
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

CREATE proc [citrus_usr].[pr_map_scancopy_reco] (@pa_id numeric
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

--select top 1 ref_no,
--slip_no,
--client_id,
--client_id date_of_execution,
--entity_name,
--scanimage,
--recon_flag,
--created_by,
--remarks,
--recon_datetime,
--highval,
--highvalyn,
--makstatus,
--remarks1,
--DPTDC_EXECUTION_DT,
--code_1200,
--name_1200,
--contact_no_1200_code,
--email_1200_code,
--num_days_date_execution
--from  temppr_map_scancopy_rec

 
--num_days_date_execution [varchar](8000) NULL
--return
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
		,case --when (dptdc_deleted_ind = 0 and dptdc_mid_chk <> '' and dptdc_res_desc ='') then 'First checker done'
			  --when (dptdc_deleted_ind = 0  and dptdc_res_desc <>'') then 'Rejected'
			  --when ((dptdc_deleted_ind = 0 or dptdc_deleted_ind = -1) and dptdc_mid_chk = '') then 'Pending for Verification'
			  ----when (dptdc_deleted_ind = 0 and dptdc_res_desc <> '') then 'Rejected' 
			  when (dptdc_deleted_ind = 0 and isnull(replace(dptdc_execution_dt,'Jan  1 1900',''),'') = '')  then 'PreApproved' 
			  when (dptdc_deleted_ind = 1 and isnull(replace(dptdc_execution_dt,'Jan  1 1900',''),'') <> '') then 'Approved'  end makstatus
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
,convert(varchar(11),dptdc_lst_upd_dt,109) dptdc_lst_upd_dt
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
							 when @pa_remarks = 'A' then '%' else '' end  
		and isnull(preappflg,'') like case when @pa_remarks = 'D' then 'Y' else '%' end
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
			  when (dptdc_deleted_ind = 0 and isnull(replace(dptdc_execution_dt,'Jan  1 1900',''),'') = '')  then 'PreApproved' 
			  when (dptdc_deleted_ind = 1 and isnull(replace(dptdc_execution_dt,'Jan  1 1900',''),'') <> '') then 'Approved'  end makstatus

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
		--and isnull(recon_flag,'')  like  case when @pa_remarks = 'P' then '' 
		--					 when @pa_remarks = 'R' then 'Y' 
		--					 when @pa_remarks = 'A' then '%' end  
		and isnull(recon_flag,'')  like  case when @pa_remarks = 'P' then '' 
							 when @pa_remarks = 'R' then 'Y' 
							 when @pa_remarks = 'A' then '%' else '' end  
		and isnull(preappflg,'') like case when @pa_remarks = 'D' then 'Y' else '%' end
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
			  when (dptdc_deleted_ind = 0 and isnull(replace(dptdc_execution_dt,'Jan  1 1900',''),'') = '')  then 'PreApproved' 
  	 	     when (dptdc_deleted_ind = 1 and isnull(replace(dptdc_execution_dt,'Jan  1 1900',''),'') <> '') then 'Approved'  end makstatus

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
		--and isnull(recon_flag,'')  like  case when @pa_remarks = 'P' then '' 
		--					 when @pa_remarks = 'R' then 'Y' 
		--					 when @pa_remarks = 'A' then '%' end  
		and isnull(recon_flag,'')  like  case when @pa_remarks = 'P' then '' 
							 when @pa_remarks = 'R' then 'Y' 
							 when @pa_remarks = 'A' then '%' else '' end  
		and isnull(preappflg,'') like case when @pa_remarks = 'D' then 'Y' else '%' end
		and entity_name like case when @l_entm_short_name = 'HO' then '%' else @l_entm_short_name end
end
end 
if @pa_action = 'SELECT'
begin 

	
	select top 1  ref_no,slip_no,client_id,entity,entity_name,scanimage,recon_flag,recon_datetime,created_by,created_dt,llst_upd_by,lst_upd_dt,deleted_ind,id from maker_scancopy 
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


/* without scan records
SELECT 0 REF_NO,dptdc_slip_no SLIP_NO,dpam_sba_no CLIENT_ID,'' ENTITY_NAME,0 SCANIMAGE,'N' RECON_FLAG,dptdc_created_by
 CREATED_BY
,'' REMARKS , '' RECON_DATETIME
,HIGHVAL = CONVERT(NUMERIC(18,2),ISNULL((SELECT SUM(ABS(CLOPM_CDSL_RT*DPTDC_QTY)) FROM DPTDC_MAK ,CLOSING_LAST_CDSL-- CLOSING_PRICE_MSTR_CDSL
WHERE CLOPM_ISIN_CD = DPTDC_ISIN
AND DPTDC_DELETED_IND IN (0,-1,1)
AND DPTDC_SLIP_NO = SLIP_NO),0))
,HIGHVALYN = --DORMAIN + '/' + 
HIGHVAL
,CASE WHEN (DPTDC_DELETED_IND = 0 AND DPTDC_MID_CHK <> '' AND DPTDC_RES_DESC ='') THEN 'FIRST CHECKER DONE'
WHEN (DPTDC_DELETED_IND = 0  AND DPTDC_RES_DESC <>'') THEN 'REJECTED'
WHEN ((DPTDC_DELETED_IND = 0 OR DPTDC_DELETED_IND = -1) AND DPTDC_MID_CHK = '') THEN 'PENDING FOR VERIFICATION'

WHEN (DPTDC_DELETED_IND = 0 AND ISNULL(REPLACE(DPTDC_EXECUTION_DT,'JAN  1 1900',''),'') = '')  THEN 'PREAPPROVED' 
WHEN (DPTDC_DELETED_IND = 1 AND ISNULL(REPLACE(DPTDC_EXECUTION_DT,'JAN  1 1900',''),'') <> '') THEN 'APPROVED'  END MAKSTATUS

, CASE WHEN (DPTDC_DELETED_IND = 0 AND DPTDC_RES_DESC <> '') THEN  DPTDC_RES_DESC ELSE DPTDC_RMKS END  REMARKS1
,CASE WHEN (DPTDC_DELETED_IND = 0  AND DPTDC_RES_DESC <>'') THEN CONVERT(VARCHAR(11),DPTDC.DPTDC_LST_UPD_DT ,109) ELSE CONVERT(VARCHAR(11),DPTDC.DPTDC_EXECUTION_DT ,109) END DPTDC_EXECUTION_DT
,DATEDIFF(DAY, DPTDC.DPTDC_LST_UPD_DT, GETDATE()+ 1) AGEING
,(SELECT DISTINCT TOP 1 ROL_DESC 
FROM ROLES,ENTITY_ROLES
WHERE ROL_ID = ENTRO_ROL_ID
AND ENTRO_DELETED_IND=1
AND ENTRO_LOGN_NAME = CREATED_BY) ROLE

FROM dp_acct_mstr, (SELECT DISTINCT DPTDC_RMKS,DPTDC_DELETED_IND ,DPTDC_MID_CHK,DPTDC_RES_DESC
,DPTDC_SLIP_NO
,CONVERT(VARCHAR(11),DPTDC_LST_UPD_DT ,109) DPTDC_LST_UPD_DT 
,CONVERT(VARCHAR(11),DPTDC_EXECUTION_DT ,109) DPTDC_EXECUTION_DT
,CASE WHEN [CITRUS_USR].[FN_GET_HIGH_VAL_NEW]('HIGH_VALUE',DPTDC_SLIP_NO)= 'N' THEN 'NO' ELSE 'YES' END HIGHVAL
,DPTDC_DPAM_ID,DPTDC_CREATED_BY FROM   DPTDC_MAK WHERE DPTDC_SLIP_NO LIKE CASE WHEN '502137240' ='' THEN '%' ELSE '502137240' END 
) DPTDC
left outer join
MAKER_SCANCOPY 
on REF_NO LIKE  '%' +  ISNULL('','')  + '%'
AND SLIP_NO LIKE  '%' +  ISNULL('502137240','')  + '%'
AND DPTDC_SLIP_NO = SLIP_NO
AND ISNULL(RECON_FLAG,'')  LIKE  CASE WHEN 'A' = 'P' THEN '' 
WHEN 'A' = 'R' THEN 'Y' 
WHEN 'A' = 'A' THEN '%' ELSE '' END  
AND ISNULL(PREAPPFLG,'') LIKE CASE WHEN 'A' = 'D' THEN 'Y' ELSE '%' END
and DELETED_IND = 1    
WHERE  
 
 DPTDC_DELETED_IND IN (0,1) 
and DPAM_DELETED_IND=1
and DPAM_ID=DPTDC_DPAM_ID
--AND ENTITY_NAME LIKE CASE WHEN @L_ENTM_SHORT_NAME = 'HO' THEN '%' ELSE @L_ENTM_SHORT_NAME END
*/

GO
