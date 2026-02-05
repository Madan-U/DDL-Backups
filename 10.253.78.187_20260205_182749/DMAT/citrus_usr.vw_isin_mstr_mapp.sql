-- Object: VIEW citrus_usr.vw_isin_mstr_mapp
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create view [citrus_usr].[vw_isin_mstr_mapp]
as
(
select * from isin_mstr where isin_status = '01'  and isin_bit in (0,'2') 
)

GO
