-- Object: PROCEDURE citrus_usr.pr_upd_consign_remat
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--[pr_upd_consign_remat] '','SELECT','N', '','APR 26 2010','APR 26 2010'
CREATE Procedure [citrus_usr].[pr_upd_consign_remat]

(@pa_id           varchar(8000)
,@pa_tab          varchar(20)
,@pa_flg          varchar(20) 
,@pa_consignno    varchar(250) 
,@pa_from_dt     datetime
,@pa_to_dt      datetime)
As
Begin
if @pa_tab = 'UPDATE'
update dmat_dispatch_remat set dispr_cons_no = @pa_consignno where DISPR_DOC_ID = @pa_id

if @pa_tab = 'SELECT'
Select CONVERT(VARCHAR ,DISPR_DT,103) as DISP_DT,
DISPR_NAME as DISP_NAME,
isnull(DISPR_DOC_ID,0) as DISP_DOC_ID ,
DISPR_TO as DISP_TO, 
dispr_cons_no as disp_cons_no
from dp_acct_mstr,dmat_dispatch_remat,remat_request_mstr
where(dpam_id = remrm_dpam_id)
and remrm_id = dispr_remrm_id
and dispr_dt between  @pa_from_dt  and @pa_to_dt 
and dispr_conf_recd = 'D' 
and dispr_cons_no = case when @pa_flg = 'N' then   '0'    else dispr_cons_no end 

End

GO
