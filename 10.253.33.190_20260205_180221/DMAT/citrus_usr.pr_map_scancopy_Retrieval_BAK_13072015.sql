-- Object: PROCEDURE citrus_usr.pr_map_scancopy_Retrieval_BAK_13072015
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

CREATE  proc [citrus_usr].[pr_map_scancopy_Retrieval_BAK_13072015](
 @pa_id numeric
,@pa_action varchar(25)
,@pa_ref_no varchar(50)
,@pa_slip_no varchar(100)
,@pa_client_id varchar(16)
,@pa_entity varchar(100)
,@pa_entity_name varchar(250)
,@pa_image varbinary(max)
,@pa_login_name varchar(150)
,@pa_out varchar(8000) out)
as
begin 

--select  * from  temppr_map_scancopy_rec
----return
--if @pa_action = 'SELECT_SEARCH'
--begin 

--		select Distinct DPTDC_DTLS_ID,DPTDC_SLIP_NO,dpam_sba_no,entm_enttm_cd   ,entm_short_name
--		from dptdc_mak , dp_acct_mstr 
--		, login_names
--		, entity_mstr 
--		where dptdc_deleted_ind in (0,6,-1)
--		and DPTDC_DPAM_ID = dpam_id 
--		and logn_ent_id = entm_id 
--		and logn_name = dptdc_created_by
--		and logn_deleted_ind = 1 
--		and entm_deleted_ind = 1
--		and DPTDC_DTLS_ID like  '%' +  @pa_ref_no  + '%'		
--		--and DPTDC_SLIP_NO  = @pa_slip_no  
--		and DPTDC_SLIP_NO  like  '%' + @pa_slip_no  + '%'	 
--		and left(DPAM_SBA_NO,8) = @pa_client_id
--		and isnull(DPTDC_SLIP_NO,'') <> ''
--		and DPTDC_SLIP_NO  not in (select slip_no from maker_scancopy where deleted_ind = 1)
--        and isnull(dptdc_res_desc,'')=''
--end 
--if @pa_action = 'INS'
--begin 

--	if exists(select * from maker_scancopy where ref_no = @pa_ref_no and slip_no = @pa_slip_no and deleted_ind = 1)
--	begin 
	
--	set @pa_out = 'Data already Exists ,Please check'
	
--	return 
	
--	end 
	
--	insert into maker_scancopy(ref_no,slip_no,client_id,entity,entity_name,scanimage,created_by,created_dt,llst_upd_by,lst_upd_dt,deleted_ind)
--	select @pa_ref_no,@pa_slip_no,@pa_client_id,@pa_entity,@pa_entity_name,@pa_image,@pa_login_name,getdate()
--	,@pa_login_name , getdate(), 1 
	
	
--end 
--if @pa_action = 'EDT'
--begin 

	
--	update maker_scancopy
--	set ref_no = @pa_ref_no
--	,slip_no = @pa_slip_no
--	,client_id = @pa_client_id
--	,entity = @pa_entity
--	,entity_name = @pa_entity_name
--	,scanimage = @pa_image
--	,llst_upd_by = @pa_login_name
--	,lst_upd_dt = getdate()
--	where id = @pa_id 
	
	
--end 
--if @pa_action = 'DEL'
--begin 
	
--	update maker_scancopy
--	set deleted_ind = 9--0 changed by shilpa for delete 
--	,llst_upd_by = @pa_login_name
--	,lst_upd_dt = getdate()
--	where id = @pa_id 
	
	
--end 
--if @pa_action = 'SELECT_FOR_RECO'
--begin 

	
--	select * from maker_scancopy 
--	where  ref_no like  '%' +  @pa_ref_no  + '%'
--	and slip_no like  '%' +  @pa_slip_no  + '%'
--	and deleted_ind = 1
--	and isnull(recon_flag,'') = ''
	
	
--end 
if @pa_action = 'SELECT'
begin 
	--set @pa_slip_no = SUBSTRING(@pa_slip_no, PATINDEX('%[^0 ]%', @pa_slip_no + ' '), LEN(@pa_slip_no))

	select ref_no,--slip_no
	ISNULL(citrus_usr.FN_FORMATSTR(convert(varchar(12),slip_no),12,0,'L','0'),space(16))     slip_no
	,client_id,entity,entity_name,
	scanimage
	,recon_flag,recon_datetime,created_by,created_dt,llst_upd_by,lst_upd_dt,deleted_ind,id 
	,case when convert(varbinary,scanimage_Annx1)=0x00000000 then null else scanimage_Annx1 end scanimage_Annx1
	,case when convert(varbinary,scanimage_Annx2)=0x00000000 then null else scanimage_Annx2 end scanimage_Annx2 
	,case when convert(varbinary,scanimage_Annx3)=0x00000000 then null else scanimage_Annx3 end scanimage_Annx3 
	from maker_scancopy 
	where  ref_no like  '%' +  @pa_ref_no  + '%'
	and slip_no like  '%' +  @pa_slip_no  + '%'
	and deleted_ind = 1 		


--select '' ref_no, INWSR_SLIP_NO slip_no,dpam_sba_no client_id,'' entity,'' entity_name,inwsr_doc_path scanimage,'' recon_flag,'' recon_datetime,INWSR_CREATED_by created_by,
--	INWSR_CREATED_DT created_dt,INWSR_LST_UPD_by llst_upd_by, INWSR_LST_UPD_DT lst_upd_dt,INWSR_DELETED_IND deleted_ind,inwsr_id id  
--	from inward_slip_reg,dp_acct_mstr
--	where INWSR_slip_no like  '%' +  @pa_slip_no  + '%' 
--	and  inwsr_doc_path like '%' + @pa_ref_no + '%' and dpam_id=inwsr_dpam_id
--	and inwsr_deleted_ind=1
	
--	--order by 1 desc

--	union all
	
--	select '' ref_no, INWSR_SLIP_NO slip_no,dpam_sba_no client_id,'' entity,'' entity_name,indpo_urls scanimage,'' recon_flag,'' recon_datetime,INWSR_CREATED_by created_by,
--	INWSR_CREATED_DT created_dt,INWSR_LST_UPD_by llst_upd_by, INWSR_LST_UPD_DT lst_upd_dt,INWSR_DELETED_IND deleted_ind,inwsr_id id  
--	from inward_slip_reg,inward_doc_path_others ,dp_acct_mstr
--	where INWSR_slip_no like  '%' +  @pa_slip_no  + '%' 
--	and inwsr_deleted_ind=1 and dpam_id=inwsr_dpam_id
--	and INWSR_ID = indpo_inward_id
--	and  indpo_urls like '%' + @pa_ref_no + '%'
--	order by 1 desc
	
end 

--if @pa_action = 'RECO_UPD'
--begin 

	
--	update maker_scancopy  set recon_flag ='Y'
--	,recon_datetime = getdate()
--	where ref_no like  '%' +  @pa_ref_no  + '%'
--	and slip_no like  '%' +  @pa_slip_no  + '%'
--	and deleted_ind = 1 
	
	
--end 






end

GO
