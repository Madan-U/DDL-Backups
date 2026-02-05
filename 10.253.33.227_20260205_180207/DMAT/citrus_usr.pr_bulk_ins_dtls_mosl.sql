-- Object: PROCEDURE citrus_usr.pr_bulk_ins_dtls_mosl
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--begin tran
--pr_bulk_ins_dtls_mosl
--select * from entity_mstr order by entm_created_dt desc--957 --977
--select * from entity_adr_conc --5523  --5587
--select top 100 * from addresses order by adr_created_dt desc --1191 --3175288
--commit
--select top 100 * from contact_channels order by conc_created_dt desc --2533 --2596 
--rollback

CREATE PROC [citrus_usr].[pr_bulk_ins_dtls_mosl]
AS
BEGIN
--
Declare @l_member_no	varchar(50),
		@l_member_name	varchar(100),
		@l_trade_name	varchar(100),
		@l_sebi_registration_no		varchar(50),
		@l_address_1	varchar(50),
		@l_address_2	varchar(50),
		@l_address_3	varchar(50),
		@l_city			varchar(50),
		@l_pincode		varchar(50),
		@l_state		varchar(50),
		@l_e_mail		varchar(50),
		@l_telephone	varchar(100),
		@l_fax			varchar(100),
		@l_telephone1	varchar(100),
		@l_e_mail1		varchar(100),
		@l_fax1			varchar(100),
		@l_entm_id		int,
		@l_adr_value	varchar(8000),
		@l_conc_value1	varchar(8000),
		@l_conc_value2	varchar(8000),
		@l_conc_value3	varchar(8000),
		@l_conc_value4	varchar(8000),
		@l_conc_value5	varchar(8000),	
		@l_conc_value6	varchar(8000),
		@l_error		int
		

	set @l_adr_value = ''
	set @l_conc_value1 = '' 
	set @l_conc_value2 = ''
	set @l_conc_value3 = ''
	set @l_conc_value4 = ''
	set @l_conc_value5 = ''
	set @l_conc_value6 = ''
	

	declare cur1 cursor fast_forward for
	select  [branch],[Code Branch Name],isnull(Addr1,''),isnull(Addr2,''),isnull(Addr3,''),isnull(Addr4,'')
		,isnull(Pin,''),isnull(Fax,''),isnull(Phone,''),isnull(Email,'')
	from entity_br3 
	where branch not in(select entm_short_name from entity_mstr)

	open cur1
	fetch next from cur1 into 
	@l_member_no,@l_member_name,@l_address_1,@l_address_2,@l_city,@l_state,@l_pincode,@l_fax,@l_telephone,@l_e_mail

	while @@fetch_status = 0 
	begin

		set @l_adr_value = ''
	--	set @l_value = @l_value + @l_member_name + '' + '' + @l_member_no + 'BRK' + 'HO' + 'PARTNERSHIP' + @l_sebi_registration_no +  
	--	exec pr_ins_upd_entm '0','INS','MIG',@l_value,1,'*|~*','|*~|','',''

		BEGIN TRANSACTION

		SELECT @l_entm_id         = bitrm_bit_location    
      FROM   bitmap_ref_mstr    WITH(NOLOCK)    
      WHERE  bitrm_parent_cd    = 'ENTITY_ID'    
      AND    bitrm_child_cd     = 'ENTITY_ID'    
      --    
      UPDATE bitmap_ref_mstr    WITH(ROWLOCK)    
      SET    bitrm_bit_location = bitrm_bit_location+1    
      WHERE  bitrm_parent_cd    = 'ENTITY_ID'    
      AND    bitrm_child_cd     = 'ENTITY_ID'   

		INSERT INTO ENTITY_MSTR
		(
			ENTM_ID,
			ENTM_NAME1,
			ENTM_NAME2,
			ENTM_NAME3,
			ENTM_SHORT_NAME,
			ENTM_ENTTM_CD,
			ENTM_CLICM_CD,
			ENTM_PARENT_ID,
			ENTM_RMKS,
			ENTM_CREATED_BY,
			ENTM_CREATED_DT,
			ENTM_LST_UPD_BY,
			ENTM_LST_UPD_DT,
			ENTM_DELETED_IND
			--entm_stam_cd
		)
		VALUES
		(
			@l_entm_id,
			@l_member_name,
			'',
			'',
			@l_member_no,
			'RE',		--'BRK',
			'NRM', --'PARTNERSHIP', 
			1,
			'', --@l_sebi_registration_no,
			'MIG',
			GETDATE(),
			'MIG',
			GETDATE(),
			1
			--'ACTIVE' --case when isnull(@l_sebi_registration_no,'') <> '' then 'ACTIVE' else 'CI' end
		)
print 'ccccc'	
		if 	isnull(@l_address_1,'') <> ''
		SET @l_adr_value = 'COR_ADR1' + '|*~|' + @l_address_1 + '|*~|' + @l_address_2 + '|*~|' + ' ' + '|*~|' + @l_city + '|*~|' + @l_state + '|*~|' + 'INDIA' + '|*~|' + @l_pincode + '*|~*' 
print 'jitesh'
print @l_entm_id
print @l_adr_value

		EXEC pr_ins_upd_addr @l_entm_id,'EDT','MIG',@l_entm_id,'',@l_adr_value,0,'*|~*','|*~|',''	
		--
	      
		select top 1 @l_conc_value1 = case when isnull(ltrim(rtrim(@l_e_mail)),'') <> '' 
											then convert(varchar,concm_cd)+'|*~|'+isnull(ltrim(rtrim(@l_e_mail)),'')+'|*~|*|~*' 
												else '' end from conc_code_mstr  
		where concm_cd= 'EMAIL1' 
		exec pr_ins_upd_conc @l_entm_id,'EDT','MIG',@l_entm_id,'',@l_conc_value1,0,'*|~*','|*~|','' 
		--

		select top 1 @l_conc_value2 = case when isnull(ltrim(rtrim(@l_telephone)),'') <> '' 
											then convert(varchar,concm_cd)+'|*~|'+isnull(ltrim(rtrim(@l_telephone)),'')+'|*~|*|~*' 
												else '' end from conc_code_mstr  
		where concm_cd= 'OFF_PH1'     
		exec pr_ins_upd_conc @l_entm_id,'EDT','MIG',@l_entm_id,'',@l_conc_value2,0,'*|~*','|*~|',''
		--

		select top 1 @l_conc_value3 = case when isnull(ltrim(rtrim(@l_fax)),'') <> '' 
											then convert(varchar,concm_cd)+'|*~|'+isnull(ltrim(rtrim(@l_fax)),'')+'|*~|*|~*' 
												else '' end from conc_code_mstr  
		where concm_cd= 'FAX1'     
		exec pr_ins_upd_conc @l_entm_id,'EDT','MIG',@l_entm_id,'',@l_conc_value3,0,'*|~*','|*~|',''
		--

		set @l_error = @@error
		if @l_error <> 0
		begin 
			select 'Error : Can not Insert the Record'

			ROLLBACK TRANSACTION
		end

		else
		begin
			COMMIT TRANSACTION
		end
		
		fetch next from cur1 into 
			@l_member_no,@l_member_name,@l_address_1,@l_address_2,@l_city,@l_state,@l_pincode,@l_fax,@l_telephone,@l_e_mail

		 
		end

		close cur1
		deallocate cur1

END

GO
