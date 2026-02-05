-- Object: VIEW citrus_usr.Vw_Template_MASTER_CI
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE view Vw_Template_MASTER_CI



as 



select convert(varchar(10),brom_desc)  AS TEMPLATE_CODE,
(CASE WHEN BROM_DESC='1' THEN 'INVESTOR' ELSE BROM_DESC END) AS REMARKS,'' AS SERV_FLAG from brokerage_mstr

GO
