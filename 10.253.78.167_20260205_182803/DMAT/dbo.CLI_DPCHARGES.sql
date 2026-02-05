-- Object: VIEW dbo.CLI_DPCHARGES
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------



CREATE VIEW CLI_DPCHARGES
AS
select DPAM_BBO_CODE AS PARTY_CODE, DPAM_SBA_NO CLIENT_CODE, sum(clic_charge_amt)*-1 BROK_BA ,CLIC_TRANS_DT   from     
citrus_usr.dp_acct_mstr WITH(NOLOCK), citrus_usr.client_charges_cdsl WITH(NOLOCK) where clic_dpam_id = dpam_id  
AND CLIC_TRANS_DT>='2015-07-01' group by DPAM_SBA_NO,DPAM_BBO_CODE ,CLIC_TRANS_DT

GO
