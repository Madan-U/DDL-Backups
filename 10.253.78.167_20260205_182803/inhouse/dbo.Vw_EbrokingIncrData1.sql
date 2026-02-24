-- Object: VIEW dbo.Vw_EbrokingIncrData1
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

CREATE View Vw_EbrokingIncrData1    
as    
select c.nise_party_code,poa_date_from,c.client_code from    
(    
select client_code,convert(datetime,poa_date_from) as poa_date_from from DMAT.DBO.tbl_client_poa    
where poa_date_from>=(select max(convert(datetime,poa_date_from))-30 from DMAT.DBO.tbl_client_poa with (nolock) 
where  client_code not in('1203320003719477','1203320007427622','1203320007674164','1203320008555418','1203320008505651','1203320008433017','1203320007527127'))    
and poa_date_from<=(select MAX(convert(datetime,poa_date_from)) from DMAT.DBO.tbl_client_poa with (nolock) 
where  client_code not in('1203320003719477','1203320007427622','1203320007674164','1203320008555418','1203320008505651','1203320008433017','1203320007527127'))    
and  client_code not in('1203320003719477','1203320007427622','1203320007674164','1203320008555418','1203320008505651','1203320008433017','1203320007527127')  
) p    
inner join DMAT.DBO.tbl_client_master c with(nolock)    
on p.client_code=c.client_code and isnull(nise_party_code,'')<>''

GO
