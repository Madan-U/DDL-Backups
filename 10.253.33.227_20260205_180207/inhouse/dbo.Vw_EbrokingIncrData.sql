-- Object: VIEW dbo.Vw_EbrokingIncrData
-- Server: 10.253.33.227 | DB: inhouse
--------------------------------------------------

  CREATE View Vw_EbrokingIncrData   
as  
select c.nise_party_code,poa_date_from,c.client_code from  
(  
select client_code,poa_date_from from tbl_client_poa  
where poa_date_from>=(select MAX((convert(datetime, poa_date_from)))-30 from tbl_client_poa with (nolock))  
and poa_date_from<=(select MAX((convert(date, poa_date_from))) from tbl_client_poa with (nolock))  
) p  
inner join tbl_client_master c with(nolock)  
on p.client_code=c.client_code and isnull(nise_party_code,'')<>''

GO
