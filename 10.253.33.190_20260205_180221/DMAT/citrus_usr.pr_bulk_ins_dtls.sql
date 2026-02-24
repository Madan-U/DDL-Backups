-- Object: PROCEDURE citrus_usr.pr_bulk_ins_dtls
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[pr_bulk_ins_dtls]
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
	select  MEMBER_NO,
			MEMBER_NAME,
			TRADE_NAME,
			SEBI_REGISTRATION_NO,
			ADDRESS_1,
			ADDRESS_2,
			ADDRESS_3,
			CITY,
			PINCODE,
			STATE,
			E_MAIL,
			TELEPHONE,
			FAX,
			TELEPHONE1,
			E_MAIL1,
			FAX1 
	from bse_comp 
	where convert(varchar,member_no) not in(select entm_short_name from entity_mstr)

	open cur1
	fetch next from cur1 into 
	@l_member_no,@l_member_name,@l_trade_name,@l_sebi_registration_no,
	@l_address_1,@l_address_2,@l_address_3,@l_city,@l_pincode,@l_state,
	@l_e_mail,@l_telephone,@l_fax,@l_telephone1,@l_e_mail1,@l_fax1

	while @@fetch_status = 0 
	begin

	--	set @l_value = @l_value + @l_member_name + '' + '' + @l_member_no + 'BRK' + 'HO' + 'PARTNERSHIP' + @l_sebi_registration_no +  
	--	exec pr_ins_upd_entm '0','INS','MIG',@l_value,1,'*|~*','|*~|','',''

		BEGIN TRANSACTION

		SELECT @l_entm_id = MAX(ENTM_ID) + 1 FROM ENTITY_MSTR

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
			ENTM_DELETED_IND--,
			--entm_stam_cd
		)
		VALUES
		(
			@l_entm_id,
			@l_member_name,
			'',
			'',
			@l_member_no,
			'BRK',
			'PARTNERSHIP',
			'HO',
			@l_sebi_registration_no,
			'MIG',
			GETDATE(),
			'MIG',
			GETDATE(),
			1--,
			--'ACTIVE'
		)

		
		SET @l_adr_value = @l_adr_value + 'REG_ADDR' + '|*~|' + @l_address_1 + '|*~|' + @l_address_2 + '|*~|' + @l_address_3 + '|*~|' + @l_city + '|*~|' + @l_state + '|*~|' + 'INDIA' + '|*~|' + @l_pincode + '*|~*' 

		EXEC pr_ins_upd_addr @l_entm_id,'EDT','MIG',@l_entm_id,'',@l_adr_value,1,'*|~*','|*~|',''	
		--
	      
		select top 1 @l_conc_value1 = case when isnull(ltrim(rtrim(@l_e_mail)),'') <> '' 
											then convert(varchar,concm_cd)+'|*~|'+isnull(ltrim(rtrim(@l_e_mail)),'')+'|*~|*|~*' 
												else '' end from conc_code_mstr  
		where concm_cd= 'EMAIL' 
		exec pr_ins_upd_conc @l_entm_id,'EDT','MIG',@l_entm_id,'',@l_conc_value1,0,'*|~*','|*~|','' 
		--

		select top 1 @l_conc_value2 = case when isnull(ltrim(rtrim(@l_telephone)),'') <> '' 
											then convert(varchar,concm_cd)+'|*~|'+isnull(ltrim(rtrim(@l_telephone)),'')+'|*~|*|~*' 
												else '' end from conc_code_mstr  
		where concm_cd= 'PH_NO'     
		exec pr_ins_upd_conc @l_entm_id,'EDT','MIG',@l_entm_id,'',@l_conc_value2,0,'*|~*','|*~|',''
		--

		select top 1 @l_conc_value3 = case when isnull(ltrim(rtrim(@l_fax)),'') <> '' 
											then convert(varchar,concm_cd)+'|*~|'+isnull(ltrim(rtrim(@l_fax)),'')+'|*~|*|~*' 
												else '' end from conc_code_mstr  
		where concm_cd= 'FAX'     
		exec pr_ins_upd_conc @l_entm_id,'EDT','MIG',@l_entm_id,'',@l_conc_value3,0,'*|~*','|*~|',''
		--

		select top 1 @l_conc_value4 = case when isnull(ltrim(rtrim(@l_e_mail1)),'') <> '' 
											then convert(varchar,concm_cd)+'|*~|'+isnull(ltrim(rtrim(@l_e_mail1)),'')+'|*~|*|~*' 
												else '' end from conc_code_mstr  
		where concm_cd= 'COMP_OFF_EMAIL'    
		exec pr_ins_upd_conc @l_entm_id,'EDT','MIG',@l_entm_id,'',@l_conc_value4,0,'*|~*','|*~|',''
		--

		select top 1 @l_conc_value5 = case when isnull(ltrim(rtrim(@l_telephone1)),'') <> '' 
											then convert(varchar,concm_cd)+'|*~|'+isnull(ltrim(rtrim(@l_telephone1)),'')+'|*~|*|~*' 
												else '' end from conc_code_mstr  
		where concm_cd= 'COMP_OFF_MOB' 
		exec pr_ins_upd_conc @l_entm_id,'EDT','MIG',@l_entm_id,'',@l_conc_value5,0,'*|~*','|*~|',''
		--

		select top 1 @l_conc_value6 = case when isnull(ltrim(rtrim(@l_trade_name)),'') <> '' 
											then convert(varchar,concm_cd)+'|*~|'+isnull(ltrim(rtrim(@l_trade_name)),'')+'|*~|*|~*' 
												else '' end from conc_code_mstr  
		where concm_cd= 'COMP_OFFICER' 
		exec pr_ins_upd_conc @l_entm_id,'EDT','MIG',@l_entm_id,'',@l_conc_value6,0,'*|~*','|*~|',''


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
		@l_member_no,@l_member_name,@l_trade_name,@l_sebi_registration_no,
		@l_address_1,@l_address_2,@l_address_3,@l_city,@l_pincode,@l_state,
		@l_e_mail,@l_telephone,@l_fax,@l_telephone1,@l_e_mail1,@l_fax1

		end

		close cur1
		deallocate cur1

END

GO
