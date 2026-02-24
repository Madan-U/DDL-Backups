-- Object: VIEW dbo.Synergy_CLIENT_MASTER_AUDIT
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



CREATE VIEW  [dbo].[Synergy_CLIENT_MASTER_AUDIT]
AS
SELECT clic_mod_dpam_sba_no as Client_code,0 as SEQ_NO,'' AS TBL_NAME,'C' AS COLUMN_TYPE,'' OLD_VALUE,''AS NEW_VALUE,
clic_mod_created_by AS USER_ID,'' AS TERMINAL,clic_mod_lst_upd_dt  AS DATE_TIME,CLIC_MOD_ACTION AS COLUMN_NAME 
FROM citrus_usr.client_list_modified with(nolock)

GO
