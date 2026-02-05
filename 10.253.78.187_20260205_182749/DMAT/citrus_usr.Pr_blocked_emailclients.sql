-- Object: PROCEDURE citrus_usr.Pr_blocked_emailclients
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[Pr_blocked_emailclients]
@PA_DP_ID varchar(8),
@PA_REPORT varchar(20),
@PA_BLKFOR varchar(20),
@pa_login_pr_entm_id numeric
as
begin
declare @@dpmid BIGINT,
@@ENTITY_ID varchar(20)
                      


select @@dpmid = dpm_id from dp_mstr where DPM_DPID = @PA_DP_ID and dpm_deleted_ind = 1       
IF @PA_BLKFOR = 'E'
BEGIN
	--
              
		delete from blk_client_email_dtls where blkced_dpmid = @@dpmid and blkced_rptname = @PA_REPORT

		DECLARE CUR CURSOR FOR
		SELECT BLKCE_ENTITY_ID FROM blk_client_email WHERE BLKCE_DPMDPID = @PA_DP_ID AND BLKCE_RPTNAME = @PA_REPORT AND BLKCE_ENTITY_TYPE <> 'C' and  BLKCE_deleted_ind = 1

		OPEN CUR
		FETCH NEXT FROM CUR INTO @@ENTITY_ID
		WHILE @@FETCH_STATUS = 0
		BEGIN

			INSERT INTO blk_client_email_dtls(blkced_dpmid,blkced_rptname,blcked_dpam_id)
			SELECT @@dpmid,@PA_REPORT,DPAM_ID 
			FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@ENTITY_ID)
			WHERE GETDATE() BETWEEN EFF_FROM AND EFF_TO

		FETCH NEXT FROM CUR INTO @@ENTITY_ID
		END
		CLOSE CUR
		DEALLOCATE CUR

		INSERT INTO blk_client_email_dtls(blkced_dpmid,blkced_rptname,blcked_dpam_id)
		SELECT @@dpmid,@PA_REPORT,DPAM_ID FROM DP_ACCT_MSTR,blk_client_email 
		WHERE  BLKCE_DPMDPID = @PA_DP_ID AND BLKCE_RPTNAME = @PA_REPORT 
	--	and DPAM_CRN_NO = convert(numeric,BLKCE_ENTITY_ID) 
        and DPAM_SBA_NO = BLKCE_ENTITY_ID
        AND BLKCE_ENTITY_TYPE = 'C' 
		and  BLKCE_deleted_ind = 1

	--
END
ELSE
BEGIN
	--
select *  from blk_client_print_dtls where blkcpd_dpmid = @@dpmid and blkcpd_rptname = @PA_REPORT
   
		delete from blk_client_print_dtls where blkcpd_dpmid = @@dpmid and blkcpd_rptname = @PA_REPORT

		DECLARE CUR CURSOR FOR
		SELECT BLKCp_ENTITY_ID FROM blk_client_print WHERE BLKCp_DPMDPID = @PA_DP_ID AND BLKCp_RPTNAME = @PA_REPORT AND BLKCp_ENTITY_TYPE <> 'C' and  BLKCp_deleted_ind = 1

		OPEN CUR
		FETCH NEXT FROM CUR INTO @@ENTITY_ID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO blk_client_print_dtls(blkcpd_dpmid,blkcpd_rptname,blckpd_dpam_id)
			SELECT @@dpmid,@PA_REPORT,DPAM_ID 
			FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@ENTITY_ID)
			WHERE GETDATE() BETWEEN EFF_FROM AND EFF_TO

		FETCH NEXT FROM CUR INTO @@ENTITY_ID
		END
		CLOSE CUR
		DEALLOCATE CUR

		INSERT INTO blk_client_print_dtls(blkcpd_dpmid,blkcpd_rptname,blckpd_dpam_id)
		SELECT @@dpmid,@PA_REPORT,DPAM_ID FROM DP_ACCT_MSTR,blk_client_print 
        WHERE  BLKCp_DPMDPID = @PA_DP_ID AND BLKCp_RPTNAME = @PA_REPORT 
      --  and DPAM_CRN_NO = convert(numeric,BLKCP_ENTITY_ID) 
        and DPAM_SBA_NO = BLKCP_ENTITY_ID 
        AND BLKCp_ENTITY_TYPE = 'C' and  BLKCp_deleted_ind = 1
	--
END
end

GO
