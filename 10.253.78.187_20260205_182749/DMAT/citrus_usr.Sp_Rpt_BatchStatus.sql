-- Object: PROCEDURE citrus_usr.Sp_Rpt_BatchStatus
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[Sp_Rpt_BatchStatus]
@pa_dptype varchar(4),
@pa_excsmid int,
@pa_fromdate datetime,
@pa_todate datetime,
@pa_output varchar(8000) output 
as
begin
	declare @@dpmid int
	
	select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1


	IF @pa_dptype ='CDSL'
	BEGIN
		SELECT   batch_cr_dt=batchc_created_dt
			,batch_cr_user=batchc_created_by
			,batch_no = batchc_no,Tot_Records=batchc_records,For_trans=batchc_trans_type
		        ,batch_status=case when batchc_status = 'P' then 'Batch Request Generated' 
					 WHEN batchc_status = 'A' THEN 'Successful Verification Release'
					 when batchc_status = 'R' then 'Failure during Verification Release'
					 else '' end
		        ,batch_resp_dt=batchc_lst_upd_dt
		        ,batch_resp_user=batchc_lst_upd_by
		FROM    BATCHNO_CDSL_MSTR
		WHERE   batchc_dpm_id = @@dpmid
			and batchc_created_dt between @pa_fromdate and @pa_todate
			and batchc_deleted_ind =1
	END
	IF @pa_dptype ='NSDL'
	BEGIN
		SELECT   batch_cr_dt=batchn_created_dt
			,batch_cr_user=batchn_created_by
			,batch_no = batchn_no,Tot_Records=batchn_records,For_trans=batchn_trans_type
		        ,batch_status=case when batchn_status = 'P' then 'Batch Request Generated' 
					 WHEN batchn_status = 'A' THEN 'Normal - Successful Verification Release'
					 when batchn_status = 'R' then 'Normal - Failure during Verification Release'
					 WHEN batchn_status = 'VRA' THEN 'VR - Successful Verification Release'
					 when batchn_status = 'VRR' then 'VR - Failure during Verification Release'
					 else '' end
		        ,batch_resp_dt=batchn_lst_upd_dt
		        ,batch_resp_user=batchn_lst_upd_by
		FROM    BATCHNO_NSDL_MSTR
		WHERE   batchn_dpm_id = @@dpmid
			and batchn_created_dt between @pa_fromdate and @pa_todate
			and batchn_deleted_ind =1
	END



end

GO
