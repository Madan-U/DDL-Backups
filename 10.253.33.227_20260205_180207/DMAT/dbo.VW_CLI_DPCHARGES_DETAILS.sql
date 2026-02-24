-- Object: VIEW dbo.VW_CLI_DPCHARGES_DETAILS
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

Create VIEW [dbo].[VW_CLI_DPCHARGES_DETAILS]
AS
select DPAM_BBO_CODE AS PARTY_CODE, DPAM_SBA_NO CLIENT_CODE, (clic_charge_amt)*-1 Charges ,CLIC_TRANS_DT as Bill_Date,CLIC_CHARGE_NAME from     
citrus_usr.dp_acct_mstr WITH(NOLOCK), citrus_usr.client_charges_cdsl WITH(NOLOCK) where clic_dpam_id = dpam_id  
AND CLIC_TRANS_DT>='2015-07-01' --group by DPAM_SBA_NO,DPAM_BBO_CODE ,CLIC_TRANS_DT

GO
