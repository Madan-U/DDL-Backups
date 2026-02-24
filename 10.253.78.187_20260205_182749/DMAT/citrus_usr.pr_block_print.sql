-- Object: PROCEDURE citrus_usr.pr_block_print
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--pr_block_print
CREATE Proc [citrus_usr].[pr_block_print]
as
begin

	Declare @l_dpam_id	int,
			@l_dpam_dpm_id int,
			@l_blkcp_id int,
			@l_error int

		declare cursor1 cursor fast_forward for
		select dpam_id,DPAM_DPM_ID from dp_acct_mstr ,email
		where dpam_sba_no = [account no#]

		open cursor1
		fetch next from cursor1 into @l_dpam_id, @l_dpam_dpm_id


		while @@fetch_status = 0
		begin

			begin transaction

			select @l_blkcp_id = max(blkcp_id) + 1 from blk_client_print

			insert into blk_client_print
			(	blkcp_id,
				blkcp_dpmdpid,
				blkcp_rptname,
				blkcp_entity_type,
				blkcp_entity_id,
				blkcp_created_by,
				blkcp_created_dt,
				blkcp_lst_upd_by,
				blkcp_lst_upd_dt,
				blkcp_deleted_ind
			)
			values
			(
				@l_blkcp_id,
				@l_dpam_dpm_id, 
				'BILL',
				'C',
				@l_dpam_id,
				'MIG',
				getdate(),
				'MIG',
				getdate(),
				1
			)


			insert into blk_client_print_dtls
			(
				blkcpd_dpmid,
				blkcpd_rptname,
				blckpd_dpam_id
			)
			values
			(
				@l_dpam_dpm_id,
				'BILL',
				@l_dpam_id
			)

			set @l_error = @@error
			if @l_error <> 0
			begin 
				select 'Error : Can not Insert the Record'

				rollback transaction
			end

			else
			begin
				commit transaction
			end

			fetch next from cursor1 into @l_dpam_id, @l_dpam_dpm_id

			end

		close cursor1
		deallocate cursor1

end

GO
