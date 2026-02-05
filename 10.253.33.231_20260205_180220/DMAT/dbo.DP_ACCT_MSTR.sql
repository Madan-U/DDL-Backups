-- Object: VIEW dbo.DP_ACCT_MSTR
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------





CREATE view [dbo].[DP_ACCT_MSTR]
As


Select * from AGMUBODPL3.dMAT.CITRUS_USR.DP_ACCT_MSTR With(Nolock)
Union all
Select * from AngelDP5.dMAT.CITRUS_USR.DP_ACCT_MSTR With(Nolock)
Union all
Select * from Angeldp202.dMAT.CITRUS_USR.DP_ACCT_MSTR With(Nolock)

GO
