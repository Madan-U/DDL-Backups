-- Object: PROCEDURE citrus_usr.SetBatchSettings
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[SetBatchSettings]
as
begin
declare @@dpm_dpid varchar(8),
	@@dpmid bigint,
	@@default_dp int,
	@@Parent_Cd varchar(500)

	declare rscursor  cursor for
	select dpm_id,dpm_dpid=ltrim(rtrim(dpm_dpid)),default_dp 
	from dp_mstr 
	where isnull(default_dp,0) <> 0
	order by dpm_dpid
	open rscursor
	fetch next from rscursor into @@dpmid,@@dpm_dpid, @@default_dp
	WHILE @@Fetch_Status = 0
	begin        
		if left(@@dpm_dpid,2) ='IN'
		begin
			set @@Parent_Cd = 'NSDL_BTCH_CLT_CURNO'
			if not exists(select bitrm_id from bitmap_ref_mstr where bitrm_Parent_cd = @@Parent_Cd and bitrm_child_cd = @@dpmid and bitrm_deleted_ind = 1)
			begin
				insert into bitmap_ref_mstr(BITRM_ID,BITRM_PARENT_CD,BITRM_CHILD_CD,BITRM_BIT_LOCATION,BITRM_VALUES,BITRM_TAB_TYPE,BITRM_CREATED_BY,BITRM_CREATED_DT,BITRM_LST_UPD_BY,BITRM_LST_UPD_DT,BITRM_DELETED_IND)
				select max(BITRM_ID)+1,@@Parent_Cd,@@dpmid,@@default_dp,1,'','HO',Getdate(),'HO',Getdate(),1
				from bitmap_ref_mstr
			end

			set @@Parent_Cd = 'NSDL_BTCH_TRX_CURNO'
			if not exists(select bitrm_id from bitmap_ref_mstr where bitrm_Parent_cd = @@Parent_Cd and bitrm_child_cd = @@dpmid and bitrm_deleted_ind = 1)
			begin
				insert into bitmap_ref_mstr(BITRM_ID,BITRM_PARENT_CD,BITRM_CHILD_CD,BITRM_BIT_LOCATION,BITRM_VALUES,BITRM_TAB_TYPE,BITRM_CREATED_BY,BITRM_CREATED_DT,BITRM_LST_UPD_BY,BITRM_LST_UPD_DT,BITRM_DELETED_IND)
				select max(BITRM_ID)+1,@@Parent_Cd,@@dpmid,@@default_dp,1,'','HO',Getdate(),'HO',Getdate(),1
				from bitmap_ref_mstr
			end
		
		end
		else
		begin
			set @@Parent_Cd = 'CDSL_BTCH_CLT_CURNO'
			if not exists(select bitrm_id from bitmap_ref_mstr where bitrm_Parent_cd = @@Parent_Cd and bitrm_child_cd = @@dpmid and bitrm_deleted_ind = 1)
			begin
				insert into bitmap_ref_mstr(BITRM_ID,BITRM_PARENT_CD,BITRM_CHILD_CD,BITRM_BIT_LOCATION,BITRM_VALUES,BITRM_TAB_TYPE,BITRM_CREATED_BY,BITRM_CREATED_DT,BITRM_LST_UPD_BY,BITRM_LST_UPD_DT,BITRM_DELETED_IND)
				select max(BITRM_ID)+1,@@Parent_Cd,@@dpmid,@@default_dp,1,'','HO',Getdate(),'HO',Getdate(),1
				from bitmap_ref_mstr
			end

			set @@Parent_Cd = 'CDSL_BTCH_DMAT_CURNO'
			if not exists(select bitrm_id from bitmap_ref_mstr where bitrm_Parent_cd = @@Parent_Cd and bitrm_child_cd = @@dpmid and bitrm_deleted_ind = 1)
			begin
				insert into bitmap_ref_mstr(BITRM_ID,BITRM_PARENT_CD,BITRM_CHILD_CD,BITRM_BIT_LOCATION,BITRM_VALUES,BITRM_TAB_TYPE,BITRM_CREATED_BY,BITRM_CREATED_DT,BITRM_LST_UPD_BY,BITRM_LST_UPD_DT,BITRM_DELETED_IND)
				select max(BITRM_ID)+1,@@Parent_Cd,@@dpmid,@@default_dp,1,'','HO',Getdate(),'HO',Getdate(),1
				from bitmap_ref_mstr
			end


			set @@Parent_Cd = 'CDSL_BTCH_EP_CURNO'
			if not exists(select bitrm_id from bitmap_ref_mstr where bitrm_Parent_cd = @@Parent_Cd and bitrm_child_cd = @@dpmid and bitrm_deleted_ind = 1)
			begin
				insert into bitmap_ref_mstr(BITRM_ID,BITRM_PARENT_CD,BITRM_CHILD_CD,BITRM_BIT_LOCATION,BITRM_VALUES,BITRM_TAB_TYPE,BITRM_CREATED_BY,BITRM_CREATED_DT,BITRM_LST_UPD_BY,BITRM_LST_UPD_DT,BITRM_DELETED_IND)
				select max(BITRM_ID)+1,@@Parent_Cd,@@dpmid,@@default_dp,1,'','HO',Getdate(),'HO',Getdate(),1
				from bitmap_ref_mstr
			end

			set @@Parent_Cd = 'CDSL_BTCH_ID_CURNO'
			if not exists(select bitrm_id from bitmap_ref_mstr where bitrm_Parent_cd = @@Parent_Cd and bitrm_child_cd = @@dpmid and bitrm_deleted_ind = 1)
			begin
				insert into bitmap_ref_mstr(BITRM_ID,BITRM_PARENT_CD,BITRM_CHILD_CD,BITRM_BIT_LOCATION,BITRM_VALUES,BITRM_TAB_TYPE,BITRM_CREATED_BY,BITRM_CREATED_DT,BITRM_LST_UPD_BY,BITRM_LST_UPD_DT,BITRM_DELETED_IND)
				select max(BITRM_ID)+1,@@Parent_Cd,@@dpmid,@@default_dp,1,'','HO',Getdate(),'HO',Getdate(),1
				from bitmap_ref_mstr
			end

			set @@Parent_Cd = 'CDSL_BTCH_NP_CURNO'
			if not exists(select bitrm_id from bitmap_ref_mstr where bitrm_Parent_cd = @@Parent_Cd and bitrm_child_cd = @@dpmid and bitrm_deleted_ind = 1)
			begin
				insert into bitmap_ref_mstr(BITRM_ID,BITRM_PARENT_CD,BITRM_CHILD_CD,BITRM_BIT_LOCATION,BITRM_VALUES,BITRM_TAB_TYPE,BITRM_CREATED_BY,BITRM_CREATED_DT,BITRM_LST_UPD_BY,BITRM_LST_UPD_DT,BITRM_DELETED_IND)
				select max(BITRM_ID)+1,@@Parent_Cd,@@dpmid,@@default_dp,1,'','HO',Getdate(),'HO',Getdate(),1
				from bitmap_ref_mstr
			end

			set @@Parent_Cd = 'CDSL_BTCH_OFFM_CURNO'
			if not exists(select bitrm_id from bitmap_ref_mstr where bitrm_Parent_cd = @@Parent_Cd and bitrm_child_cd = @@dpmid and bitrm_deleted_ind = 1)
			begin
				insert into bitmap_ref_mstr(BITRM_ID,BITRM_PARENT_CD,BITRM_CHILD_CD,BITRM_BIT_LOCATION,BITRM_VALUES,BITRM_TAB_TYPE,BITRM_CREATED_BY,BITRM_CREATED_DT,BITRM_LST_UPD_BY,BITRM_LST_UPD_DT,BITRM_DELETED_IND)
				select max(BITRM_ID)+1,@@Parent_Cd,@@dpmid,@@default_dp,1,'','HO',Getdate(),'HO',Getdate(),1
				from bitmap_ref_mstr
			end

			set @@Parent_Cd = 'CDSL_BTCH_RMAT_CURNO'
			if not exists(select bitrm_id from bitmap_ref_mstr where bitrm_Parent_cd = @@Parent_Cd and bitrm_child_cd = @@dpmid and bitrm_deleted_ind = 1)
			begin
				insert into bitmap_ref_mstr(BITRM_ID,BITRM_PARENT_CD,BITRM_CHILD_CD,BITRM_BIT_LOCATION,BITRM_VALUES,BITRM_TAB_TYPE,BITRM_CREATED_BY,BITRM_CREATED_DT,BITRM_LST_UPD_BY,BITRM_LST_UPD_DT,BITRM_DELETED_IND)
				select max(BITRM_ID)+1,@@Parent_Cd,@@dpmid,@@default_dp,1,'','HO',Getdate(),'HO',Getdate(),1
				from bitmap_ref_mstr
			end

		end
		fetch next from rscursor into @@dpmid,@@dpm_dpid, @@default_dp
	end
	close rscursor
	deallocate rscursor

end

GO
