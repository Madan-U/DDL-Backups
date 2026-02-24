-- Object: VIEW dbo.Vw_Template_Master
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

CREATE View Vw_Template_Master  
as  
select Template_Code,Remarks,Serv_Flag ='Y' from dmat.citrus_usr.VW_TEMPLATE_MASTER

GO
