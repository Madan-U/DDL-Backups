-- Object: PROCEDURE citrus_usr.pr_bulk_ins_dtls_fr
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--begin tran
--pr_bulk_ins_dtls_fr
--select * from entity_mstr --select 9318 + 1011 --10329
--select * from entity_adr_conc --8959  --9926 
--select * from addresses --1554 --1598 --1612
--select * from contact_channels --3627 
--select * from entity_adr_conc where entac_ent_id = 141573 
--SELECT * FROM CONC_CODE_MSTR
--select * from entity_type_mstr where enttm_cli_yn = 1
--select * from enttm_entr_mapping 
--rollback
--COMMIT

CREATE PROC [citrus_usr].[pr_bulk_ins_dtls_fr]
AS
BEGIN
--
Declare @l_member_no	varchar(50),
		@l_member_name	varchar(100),
		@l_sebi_registration_no	varchar(50),
		@l_entm_id		int,
		@l_error		int
		

	declare cur1 cursor fast_forward for
	select distinct MEMBER_NO,
			MEMBER_NAME--,
			--SEBI_REGISTRATION_NO
	from entity_fr1 --,entity_mstr
	where member_no not in(select entm_short_name from entity_mstr)
 
	open cur1
	fetch next from cur1 into 
	@l_member_no,@l_member_name --,@l_sebi_registration_no

	while @@fetch_status = 0 
	begin

		BEGIN TRANSACTION

		/*SELECT @l_entm_id = MAX(ENTM_ID) + 1 FROM ENTITY_MSTR*/
print @l_member_no

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
			'BR',		--'BRK',
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


		SET @L_ERROR = @@ERROR
		IF @L_ERROR <> 0
		BEGIN 
			SELECT 'Error : Can not Insert the Record'

			ROLLBACK TRANSACTION
		END

		ELSE
		BEGIN
			COMMIT TRANSACTION
		END


		fetch next from cur1 into 
		@l_member_no,@l_member_name --,@l_sebi_registration_no

		end

		close cur1
		deallocate cur1

END

GO
