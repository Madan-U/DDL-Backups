-- Object: PROCEDURE citrus_usr.pr_select_ucc_all_details
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


CREATE procedure [citrus_usr].[pr_select_ucc_all_details]
(
	@pa_account_id varchar(16),
	@pa_action varchar(25),
	@pa_value varchar(150),
	@pa_output varchar(8000) output
)
as begin
	if @pa_action = 'UCC_DTLS'
	begin
		select distinct CUDM_UCC,
		case when CUDM_EXID = '01' then 'NSE'
			 when CUDM_EXID = '02' then 'BSE'
			 when CUDM_EXID = '03' then 'MSE' else '' end CUDM_EXCD,
		CUDM_CMID,
		CUDM_TMCD,
		case when CUDM_SEGID = '01' then 'CAPITAL MARKET SEGMENT'
			 when CUDM_SEGID = '02' then 'FUTURES & OPTIONS SEGMENT'
			 when CUDM_SEGID = '03' then 'CURRENCY DERIVATIVES SEGMENT'
			 when CUDM_SEGID = '04' then 'SLB'
			 when CUDM_SEGID = '05' then 'COMMODITY DERIVATIVES SEGMENT'
			 when CUDM_SEGID = '06' then 'DEBT SEGMENT' else '' end CUDM_SEGCD
			 ,CUDM_EXID
			 ,CUDM_SEGID
		from cdsl_ucc_dtls_mstr 
		where CUDM_DELETED_IND =1
		and CUDM_BOID = @pa_account_id
	end
end

GO
