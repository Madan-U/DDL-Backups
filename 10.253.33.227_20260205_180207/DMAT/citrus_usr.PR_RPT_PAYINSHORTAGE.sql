-- Object: PROCEDURE citrus_usr.PR_RPT_PAYINSHORTAGE
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[PR_RPT_PAYINSHORTAGE](
@pa_excsmid int,
@pa_fromdt datetime,
@pa_todt datetime,
@excmid int,
@pa_setttype int,
@pa_settno varchar(7),
@pa_fromaccid varchar(16),                  
@pa_toaccid varchar(16),                  
@pa_isincd varchar(12), 
@pa_login_pr_entm_id numeric,                    
@pa_login_entm_cd_chain  varchar(8000),                    
@pa_output varchar(8000) output   
)
as 
begin

	set nocount on
	set transaction isolation level read uncommitted
	declare @@dpmid int                  
	               
	select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                  
	declare @@l_child_entm_id      numeric                    
	select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                    
	               
	if @pa_fromaccid = ''                  
	begin                  
	set @pa_fromaccid = '0'                  
	set @pa_toaccid = '99999999999999999'                  
	end                    
	               
	if @pa_toaccid = ''                  
	begin                  
	set @pa_toaccid = @pa_fromaccid                  
	end                 


	if @pa_settno <> ''
	begin
		select trans_date = case when Dp89_Txn_Type_Flag = 'E' then  convert(varchar(11),Dp89_Settl_DateTime,103) else convert(varchar(11),Dp89_Earmark_DateTime,103) end,trans_type = case when Dp89_Txn_Type_Flag = 'N' then 'NORMAL PAYIN' WHEN Dp89_Txn_Type_Flag = 'A' then 'AUTO PAYIN' WHEN Dp89_Txn_Type_Flag = 'E' then 'EARLY PAYIN' ELSE '' END,
		Exchange= isnull(Excm_desc,excm_id),sett_no = isnull(SETTM_DESC,'') + '/' + Dp89_Settl_Id,
		dpam_sba_no,dpam_sba_name,Cl_mem= [citrus_usr].[fn_splitstrin_byspace](isnull(Dp89_CM_Nm,'') + '/' + Dp89_CM_Id,'32','',1),Isin_cd =Dp89_ISIN,Isin_name,
		trx_qty=Dp89_Trx_Qty, Earmark_short_qty=Dp89_Earmark_Shrt_Qty,FREE_BAL=Dp89_Free_Balance,SHORTAGE_EXCESS=Dp89_Balance_Amt,
		PROBABLE_STATUS = CASE WHEN Dp89_Probable_Status = 'S' THEN 'SUCCESS' WHEN Dp89_Probable_Status = 'F' THEN 'FAILED' ELSE '' END,
		TRANS_NO =Dp89_Txn_Id ,INT_REF_NO=Dp89_Int_RefNo,TRANS_STATUS = ISNULL(stat.DESCP,Dp89_Trn_Status)
		from transaction_dp89 with(nolock)
		left outer join settlement_type_mstr on Dp89_Settl_type = settm_id,
		isin_mstr
		,citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) ACCOUNT   
		,citrus_usr.FN_GETSUBTRANSDTLS('DP89_STAT_CD_CDSL') stat  
		,exchange_mstr  
		where Dp89_Settl_type = @pa_setttype and Dp89_Settl_Id = @pa_settno
		AND Dp89_dpam_id = ACCOUNT.dpam_id
		AND (DPAM_SBA_NO BETWEEN CONVERT(NUMERIC,@pa_fromaccid) and CONVERT(NUMERIC,@pa_toaccid))
		AND (Dp89_Settl_DateTime between EFF_FROM and EFF_TO) 
		AND Dp89_ISIN like @pa_isincd + '%' 
		and dp89_ISIN = isin_cd
		AND Dp89_Trn_Status = stat.cd
		AND Dp89_Ex_Id = excm_id
		order by Dp89_Earmark_DateTime,dpam_sba_no,Dp89_Txn_Type_Flag,isnull(SETTM_DESC,'') + '/' + Dp89_Settl_Id,Dp89_ISIN



	end
	else
	begin

		select trans_date = case when Dp89_Txn_Type_Flag = 'E' then  convert(varchar(11),Dp89_Settl_DateTime,103) else convert(varchar(11),Dp89_Earmark_DateTime,103) end,trans_type = case when Dp89_Txn_Type_Flag = 'N' then 'NORMAL PAYIN' WHEN Dp89_Txn_Type_Flag = 'A' then 'AUTO PAYIN' WHEN Dp89_Txn_Type_Flag = 'E' then 'EARLY PAYIN' ELSE '' END,
		Exchange= isnull(Excm_desc,excm_id),sett_no = isnull(SETTM_DESC,'') + '/' + Dp89_Settl_Id,
		dpam_sba_no,dpam_sba_name,Cl_mem= [citrus_usr].[fn_splitstrin_byspace](isnull(Dp89_CM_Nm,'') + '/' + Dp89_CM_Id,'32','',1),Isin_cd =Dp89_ISIN,Isin_name,
		trx_qty=Dp89_Trx_Qty, Earmark_short_qty=Dp89_Earmark_Shrt_Qty,FREE_BAL=Dp89_Free_Balance,SHORTAGE_EXCESS=Dp89_Balance_Amt,
		PROBABLE_STATUS = CASE WHEN Dp89_Probable_Status = 'S' THEN 'SUCCESS' WHEN Dp89_Probable_Status = 'F' THEN 'FAILED' ELSE '' END,
		TRANS_NO =Dp89_Txn_Id ,INT_REF_NO=Dp89_Int_RefNo,TRANS_STATUS = ISNULL(stat.DESCP,Dp89_Trn_Status)
		from transaction_dp89 with(nolock)
		left outer join settlement_type_mstr on Dp89_Settl_type = settm_id,
		isin_mstr
		,citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) ACCOUNT   
		,citrus_usr.FN_GETSUBTRANSDTLS('DP89_STAT_CD_CDSL') stat  
		,exchange_mstr  
		where Dp89_Settl_DateTime between @pa_fromdt and @pa_todt
		AND Dp89_dpam_id = ACCOUNT.dpam_id
		AND (DPAM_SBA_NO BETWEEN CONVERT(NUMERIC,@pa_fromaccid) and CONVERT(NUMERIC,@pa_toaccid))
		AND (Dp89_Settl_DateTime between EFF_FROM and EFF_TO)                          
		AND Dp89_ISIN like @pa_isincd + '%' 
		and dp89_ISIN = isin_cd
		AND Dp89_Trn_Status = stat.cd
		AND Dp89_Ex_Id = excm_id
		order by Dp89_Earmark_DateTime,dpam_sba_no,Dp89_Txn_Type_Flag,isnull(SETTM_DESC,'') + '/' + Dp89_Settl_Id,Dp89_ISIN


	end



end

GO
