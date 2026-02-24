-- Object: PROCEDURE dbo.Usp_Amd_sb_client_details
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


CREATE  procedure Usp_Amd_sb_client_details
as
begin

TRUNCATE TABLE [sb_client_details]

INSERT INTO [sb_client_details] (
party_code,sub_broker)
SELECT party_code,sub_broker FROM [172.31.16.95].NXT.dbo.sb_client_details with(nolock)

END

GO
