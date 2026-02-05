-- Object: PROCEDURE citrus_usr.pr_map_scancopy
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



CREATE proc [citrus_usr].[pr_map_scancopy](
 @pa_id numeric
,@pa_action varchar(25)
,@pa_ref_no varchar(50)
,@pa_slip_no varchar(100)
--,@pa_FrmDt datetime
--,@pa_ToDt datetime
,@pa_client_id varchar(16)
,@pa_entity varchar(100)
,@pa_entity_name varchar(250)
,@pa_image varbinary(max)
,@pa_login_name varchar(150)
,@pa_image_annx1 varbinary(max)
,@pa_image_annx2 varbinary(max)
,@pa_image_annx3 varbinary(max)
,@pa_image_annx4 varbinary(max)
,@pa_image_annx5 varbinary(max)
,@pa_out varchar(8000) out)
as
begin 

--select  * from  temppr_map_scancopy_rec
--return
declare @pa_FrmDt datetime
,@pa_ToDt datetime
select  @pa_FrmDt ='01/01/1900'
select  @pa_ToDt ='01/01/2100'
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
	and DPTDC_EXECUTION_DT between   @pa_FrmDt+' 00:00:00' and @pa_ToDt 
--
		and DPTDC_DTLS_ID like  '%' +  @pa_ref_no  + '%'		
		--and DPTDC_SLIP_NO  = @pa_slip_no  
		and DPTDC_SLIP_NO  like  '%' + @pa_slip_no  + '%'	 
		and left(DPAM_SBA_NO,8) = @pa_client_id
		and dptdc_created_by = @pa_login_name
		and isnull(DPTDC_SLIP_NO,'') <> ''
		and DPTDC_SLIP_NO  not in (select slip_no from maker_scancopy where deleted_ind = 1)
        and isnull(dptdc_res_desc,'')=''
end 
if @pa_action = 'INS'
begin 

	if exists(select * from maker_scancopy where ref_no = @pa_ref_no and slip_no = @pa_slip_no and deleted_ind = 1)
	begin 
	
	set @pa_out = 'Data already Exists ,Please check'
	
	return 
	
	end 
	
	insert into maker_scancopy(ref_no,slip_no,client_id,entity,entity_name,scanimage,created_by,created_dt,llst_upd_by,lst_upd_dt,deleted_ind
	,scanimage_Annx1
	,scanimage_Annx2
	,scanimage_Annx3
	,scanimage_Annx4
	,scanimage_Annx5
)
	select @pa_ref_no,@pa_slip_no,@pa_client_id,@pa_entity,@pa_entity_name,@pa_image,@pa_login_name,getdate()
	,@pa_login_name , getdate(), 1 ,@pa_image_annx1,@pa_image_annx2,@pa_image_annx3,@pa_image_annx4,@pa_image_annx5
	
	
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
	
	,scanimage_Annx1 = @pa_image_annx1
	,scanimage_Annx2 = @pa_image_annx2
	,scanimage_Annx3 = @pa_image_annx3
	,scanimage_Annx4 = @pa_image_annx4
	,scanimage_Annx5 = @pa_image_annx5
	
	,llst_upd_by = @pa_login_name
	,lst_upd_dt = getdate()
	where id = @pa_id 
	
	
end 
if @pa_action = 'DEL'
begin 
	
	update maker_scancopy
	set deleted_ind = 9--0 changed by shilpa for delete 
	,llst_upd_by = @pa_login_name
	,lst_upd_dt = getdate()
	where id = @pa_id 
	
	
end 
if @pa_action = 'SELECT_FOR_RECO'
begin 

	
	select * from maker_scancopy 
	where  ref_no like  '%' +  @pa_ref_no  + '%'
	and slip_no like  '%' +  @pa_slip_no  + '%'
	and deleted_ind = 1
	and isnull(recon_flag,'') = ''
	
	
end 
if @pa_action = 'SELECT'
begin 
	
select ref_no,slip_no,client_id,entity,entity_name,scanimage,recon_flag,recon_datetime,created_by,created_dt,llst_upd_by,lst_upd_dt,deleted_ind,id 
,scanimage_Annx1,scanimage_Annx2,scanimage_Annx3,scanimage_Annx4,scanimage_Annx5
from maker_scancopy , login_names
, entity_mstr
where  ref_no like  '%' +  @pa_ref_no  + '%'
and slip_no like  '%' +  @pa_slip_no  + '%'
and LOGN_ENT_ID=ENTM_ID
and LOGN_NAME=created_by
and created_by=@pa_login_name
and created_dt between   @pa_FrmDt +' 00:00:00' and @pa_ToDt
and left(client_id,8) = @pa_client_id
and deleted_ind = 1 	
	
end 

if @pa_action = 'RECO_UPD'
begin 

	
	update maker_scancopy  set recon_flag ='Y'
	,recon_datetime = getdate()
	where ref_no like  '%' +  @pa_ref_no  + '%'
	and slip_no like  '%' +  @pa_slip_no  + '%'
	and deleted_ind = 1 
	
	
end 






end

GO
