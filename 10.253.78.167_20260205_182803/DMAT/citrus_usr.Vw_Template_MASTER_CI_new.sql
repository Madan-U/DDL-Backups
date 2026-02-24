-- Object: VIEW citrus_usr.Vw_Template_MASTER_CI_new
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create view Vw_Template_MASTER_CI_new  
as   
select BROM_DESC AS TEMPLATE_CODE,BROM_DESC AS REMARKS,'' AS SERV_FLAG from brokerage_mstr
where BROM_ID NOT IN ('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','20',
'21','22','23','24','25','26','27','28','29','30','31','32','33','34','38','39','40','41','42','43','44',
'45','46','47','48','49','50','51','52','53','54','55','56','57','58','59','60','61','62','63','64','65','66',
'67','74')

GO
