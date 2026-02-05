-- Object: PROCEDURE citrus_usr.pr_bulk_ins_dtls_adrconc
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--begin tran
--pr_bulk_ins_dtls_adrconc
--select * from entity_mstr --984 --989
--select * from entity_adr_conc --8959  --9926 
--select * from addresses --1554 --1598 --1612
--select * from contact_channels --3627 
--select * from entity_adr_conc where entac_ent_id = 141573 
--SELECT * FROM CONC_CODE_MSTR
--rollback
--COMMIT

CREATE PROC [citrus_usr].[pr_bulk_ins_dtls_adrconc]
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
		@l_e_mail		varchar(100),
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
	select  entm_id,		
			[bm_branchname],
			ISNULL([Contact Person],''),
			ISNULL(Addr1,''),
			ISNULL(Addr2,''),
			ISNULL(Addr3,''),
			ISNULL(Addr4,''),
			ISNULL(Pin,''),
			ISNULL(Email,''),
			ISNULL(Phone,''),
			ISNULL(Fax,'')
	from Branch_Master_new_pending ,entity_mstr, Branch_Master_new
	where bm_branchcd = entm_short_name and [Branch Code ]= bm_branchcd

 
	open cur1
	fetch next from cur1 into 
	@l_member_no,@l_member_name,@l_trade_name,
	@l_address_1,@l_address_2,@l_address_3,@l_city,@l_pincode,
	@l_e_mail,@l_telephone,@l_fax

	while @@fetch_status = 0 
	begin

		BEGIN TRANSACTION

		--ADDRESS
		SET @l_adr_value = 'OFF_ADR1' + '|*~|' + @l_address_1 + '|*~|' + @l_address_2 + '|*~|' + @l_address_3 + '|*~|' + @l_city + '|*~|' + @l_state + '|*~|' + 'INDIA' + '|*~|' + @l_pincode + '*|~*' 
		EXEC pr_ins_upd_addr @l_member_no,'EDT','MIG',@l_member_no,'',@l_adr_value,0,'*|~*','|*~|',''	
		
     
		--CONTACT CHANNELS
		select top 1 @l_conc_value1 = case when isnull(ltrim(rtrim(@l_e_mail)),'') <> '' 
											then convert(varchar,concm_cd)+'|*~|'+isnull(ltrim(rtrim(@l_e_mail)),'')+'|*~|*|~*' 
												else '' end from conc_code_mstr  
		where concm_cd= 'EMAIL1' 
		exec pr_ins_upd_conc @l_member_no,'EDT','MIG',@l_member_no,'',@l_conc_value1,0,'*|~*','|*~|','' 
		--

		select top 1 @l_conc_value2 = case when isnull(ltrim(rtrim(@l_telephone)),'') <> '' 
											then convert(varchar,concm_cd)+'|*~|'+isnull(ltrim(rtrim(@l_telephone)),'')+'|*~|*|~*' 
												else '' end from conc_code_mstr  
		where concm_cd= 'OFF_PH1'     
		exec pr_ins_upd_conc @l_member_no,'EDT','MIG',@l_member_no,'',@l_conc_value2,0,'*|~*','|*~|',''
		--

		select top 1 @l_conc_value3 = case when isnull(ltrim(rtrim(@l_fax)),'') <> '' 
											then convert(varchar,concm_cd)+'|*~|'+isnull(ltrim(rtrim(@l_fax)),'')+'|*~|*|~*' 
												else '' end from conc_code_mstr  
		where concm_cd= 'FAX1'     
		exec pr_ins_upd_conc @l_member_no,'EDT','MIG',@l_member_no,'',@l_conc_value3,0,'*|~*','|*~|',''

		

		--

		exec pr_ins_upd_conc @l_member_no,'EDT','MIG',@l_member_no,'',@l_conc_value6,0,'*|~*','|*~|',''


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
	@l_member_no,@l_member_name,@l_trade_name,
	@l_address_1,@l_address_2,@l_address_3,@l_city,@l_pincode,
	@l_e_mail,@l_telephone,@l_fax

		end

		close cur1
		deallocate cur1

END

GO
