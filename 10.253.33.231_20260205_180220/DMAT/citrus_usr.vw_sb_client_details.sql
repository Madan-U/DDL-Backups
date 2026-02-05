-- Object: VIEW citrus_usr.vw_sb_client_details
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------


CREATE VIEW [citrus_usr].[vw_sb_client_details]
AS


select * from AGMUBODPL3.dmat.dbo.sb_client_details with(nolock)

GO
