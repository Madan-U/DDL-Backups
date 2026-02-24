-- Object: VIEW dbo.View_Dp_CLient
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE  View View_Dp_CLient  
as  
select client_Code,NISE_PARTY_CODE from TBL_CLIENT_MASTER (nolock)
where isnull(replace(NISE_PARTY_CODE,'	',''),'') not in ('','1')

GO
