-- Object: VIEW citrus_usr.CLIENTSUB_MASTER
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create view [citrus_usr].[CLIENTSUB_MASTER]
as
select distinct CLICM_CD, CLICM_DESC from CLIENT_CTGRY_MSTR

GO
