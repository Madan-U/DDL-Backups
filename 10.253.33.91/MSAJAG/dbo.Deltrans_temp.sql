-- Object: PROCEDURE dbo.Deltrans_temp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

Create Proc Deltrans_temp as 
CREATE  CLUSTERED  INDEX [delhold_tmp] ON [dbo].[DelTrans]([Sett_No], [Sett_type], [Party_Code], [scrip_cd], [series], [CertNo], [TrType], [DrCr], [BDpType], [BDpId], [BCltDpId]) ON [PRIMARY]

GO
