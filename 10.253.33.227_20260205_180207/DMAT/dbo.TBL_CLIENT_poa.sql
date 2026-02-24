-- Object: VIEW dbo.TBL_CLIENT_poa
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create view TBL_CLIENT_poa
as
select *  from citrus_usr.TBL_CLIENT_poa WITH(NOLOCK)

GO
