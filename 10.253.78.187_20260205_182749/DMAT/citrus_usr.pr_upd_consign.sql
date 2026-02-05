-- Object: PROCEDURE citrus_usr.pr_upd_consign
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--pr_upd_consign '','SELECT','E', '','May 27 2008','May 27 2009',
CREATE Procedure [citrus_usr].[pr_upd_consign]

(@pa_id           varchar(8000)
,@pa_tab          varchar(20)
,@pa_flg          varchar(20) 
,@pa_consignno    varchar(20) 
,@pa_from_dt     datetime
,@pa_to_dt      datetime)
As
Begin
if @pa_tab = 'UPDATE'
update dmat_dispatch set disp_cons_no = @pa_consignno where DISP_DOC_ID = @pa_id

if @pa_tab = 'SELECT'
Select CONVERT(VARCHAR ,DISP_DT,103)DISP_DT, DEMRM_SLIP_SERIAL_NO  DISP_NAME ,isnull(DISP_DOC_ID,0)DISP_DOC_ID ,DISP_TO,disp_cons_no from dp_acct_mstr,dmat_dispatch,demat_request_mstr
where(dpam_id = demrm_dpam_id)
and demrm_id=disp_demrm_id
and disp_dt between  @pa_from_dt  and @pa_to_dt 
and disp_conf_recd is null 
and disp_cons_no = case when @pa_flg = 'N' then   '0'    else disp_cons_no end 

End

GO
