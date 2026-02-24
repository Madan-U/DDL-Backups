-- Object: VIEW dbo.Vw_MFPoaIncrDataActive
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

CREATE View Vw_MFPoaIncrDataActive         
as        
select distinct c.nise_party_code,poa_date_from,c.client_code,poa_ver,c.status from        
(  select client_code,poa_date_from from tbl_client_poa with(nolock) ) p        
right join tbl_client_master c with(nolock)        
on p.client_code=c.client_code and isnull(nise_party_code,'')<>''

GO
