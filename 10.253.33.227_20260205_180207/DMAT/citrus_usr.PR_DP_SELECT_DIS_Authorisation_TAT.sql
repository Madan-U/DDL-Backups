-- Object: PROCEDURE citrus_usr.PR_DP_SELECT_DIS_Authorisation_TAT
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------





CREATE PROCEDURE [citrus_usr].[PR_DP_SELECT_DIS_Authorisation_TAT]
(
	@PA_EXCSM_ID INT,
	@PA_DATE DATETIME
)
AS 
BEGIN
declare @pa_dpm_id int
select @pa_dpm_id = dpm_id from dp_mstr where default_dp = dpm_excsm_id and dpm_excsm_id = @PA_EXCSM_ID


	SELECT  distinct DPAM_SBA_NO [DMAT A/C NUMBER],MM.DPTDC_SLIP_NO [SLIP NO]
--, convert(varchar(25),convert(datetime,m.dptdc_created_dt) )  [REQUEST DATE]
	, convert(varchar(25),convert(datetime,m.dptdc_created_dt) )  [REQUEST DATE]
	, convert(varchar(25),convert(datetime,lst_upd_dt) )   [SCAN TIME]
	,  case when isnull(dptdc_mid_chk ,'') <> '' then convert(varchar(25),convert(datetime,mm.dptdc_lst_upd_dt) ) else  convert(varchar(25),convert(datetime,m.dptdc_lst_upd_dt) ) end  [FIRST APPROVAL TIME] 
	, case when isnull(dptdc_mid_chk ,'') <> '' then convert(varchar(25),convert(datetime,m.dptdc_lst_upd_dt) )   else '' end [SECOND APPROVAL TIME] 

	--,case when isnull(dptdc_mid_chk ,'') <> '' then convert(datetime,convert(varchar(19),mm.dptdc_lst_upd_dt ,121) ,121) else  convert(datetime,convert(varchar(19),m.dptdc_lst_upd_dt ,121) ,121) end
	--, case when convert(datetime,convert(varchar(19),lst_upd_dt ,121) ,121)<convert(datetime,convert(varchar(19),m.dptdc_created_dt ,121) ,121)then convert(datetime,convert(varchar(19),m.dptdc_created_dt ,121) ,121) else 
	--convert(datetime,convert(varchar(19),lst_upd_dt ,121) ,121) end

	,abs((DATEDIFF(MINUTE,case when isnull(dptdc_mid_chk ,'') <> '' then convert(datetime,convert(varchar(19),mm.dptdc_lst_upd_dt ,121) ,121) else 
	 convert(datetime,convert(varchar(19),m.dptdc_lst_upd_dt ,121) ,121) end

	,case when convert(datetime,convert(varchar(19),lst_upd_dt ,121) ,121)<convert(datetime,convert(varchar(19),m.dptdc_created_dt ,121) ,121) then
	 convert(datetime,convert(varchar(19),m.dptdc_created_dt ,121) ,121) else 
	convert(datetime,convert(varchar(19),lst_upd_dt ,121) ,121) end ))) AS [TAT FROM IST APPROVAL]

	,case when isnull(dptdc_mid_chk ,'') <> '' then  convert(varchar,abs((DATEDIFF(MINUTE,convert(datetime,convert(varchar(19),m.dptdc_lst_upd_dt ,121) ,121)
	,convert(datetime,convert(varchar(19),mm.dptdc_lst_upd_dt ,121) ,121))))) else 'NA' end AS [TAT FROM IIND APPROVAL]
	FROM DP_TRX_DTLS_CDSL MM,MAKER_SCANCOPY,DP_ACCT_MSTR,DPTDC_MAK M 
	WHERE MM.DPTDC_SLIP_NO=SLIP_NO AND MM.DPTDC_DELETED_IND=1
	AND DELETED_IND=1 AND DPAM_ID=MM.DPTDC_DPAM_ID AND M.DPTDC_SLIP_NO=MM.DPTDC_SLIP_NO AND M.DPTDC_DELETED_InD=1
	AND M.DPTDC_DPAM_ID=MM.DPTDC_DPAM_ID
	--AND convert(varchar(11),M.DPTDC_CREATED_DT,109)=@PA_DATE 
	AND convert(varchar(11),M.DPTDC_EXECUTION_DT,109)=@PA_DATE 
	order BY abs((DATEDIFF(MINUTE,case when isnull(dptdc_mid_chk ,'') <> '' then convert(datetime,convert(varchar(19),mm.dptdc_lst_upd_dt ,121) ,121) else  convert(datetime,convert(varchar(19),m.dptdc_lst_upd_dt ,121) ,121) end
	,case when convert(datetime,convert(varchar(19),lst_upd_dt ,121) ,121)<convert(datetime,convert(varchar(19),m.dptdc_created_dt ,121) ,121)then convert(datetime,convert(varchar(19),m.dptdc_created_dt ,121) ,121) else 
	convert(datetime,convert(varchar(19),lst_upd_dt ,121) ,121) end ))) desc,DPAM_SBA_NO,MM.DPTDC_SLIP_NO
	, convert(varchar(25),convert(datetime,m.dptdc_created_dt) )     
	, convert(varchar(25),convert(datetime,lst_upd_dt) )
	,  case when isnull(dptdc_mid_chk ,'') <> '' then convert(varchar(25),convert(datetime,mm.dptdc_lst_upd_dt) ) else  convert(varchar(25),convert(datetime,m.dptdc_lst_upd_dt) ) end  
	, case when isnull(dptdc_mid_chk ,'') <> '' then convert(varchar(25),convert(datetime,m.dptdc_lst_upd_dt) )   else '' end 
	--,case when isnull(dptdc_mid_chk ,'') <> '' then convert(datetime,convert(varchar(19),mm.dptdc_lst_upd_dt ,121) ,121) else  convert(datetime,convert(varchar(19),m.dptdc_lst_upd_dt ,121) ,121) end
	--, case when convert(datetime,convert(varchar(19),lst_upd_dt ,121) ,121)<convert(datetime,convert(varchar(19),m.dptdc_created_dt ,121) ,121)then convert(datetime,convert(varchar(19),m.dptdc_created_dt ,121) ,121) else 
	--convert(datetime,convert(varchar(19),lst_upd_dt ,121) ,121) end
--SELECT 'pankaj', 'pankaj'
END

GO
