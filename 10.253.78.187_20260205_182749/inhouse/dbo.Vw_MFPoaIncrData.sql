-- Object: VIEW dbo.Vw_MFPoaIncrData
-- Server: 10.253.78.187 | DB: inhouse
--------------------------------------------------

CREATE View Vw_MFPoaIncrData       
as      
select c.nise_party_code,poa_date_from,c.client_code,poa_ver from      
(  select client_code,poa_date_from from tbl_client_poa with(nolock) ) p      
inner join tbl_client_master c with(nolock)      
on p.client_code=c.client_code and isnull(nise_party_code,'')<>''

GO
