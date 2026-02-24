-- Object: VIEW citrus_usr.Vw_Template_MASTER
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create view Vw_Template_MASTER
as 
select BROM_DESC AS TEMPLATE_CODE,BROM_DESC AS REMARKS,'' AS SERV_FLAG from brokerage_mstr

GO
