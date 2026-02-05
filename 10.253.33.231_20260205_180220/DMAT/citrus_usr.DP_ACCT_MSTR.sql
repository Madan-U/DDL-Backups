-- Object: VIEW citrus_usr.DP_ACCT_MSTR
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------



 --ALTER THIS VIEW UNDER SRE-34226



CREATE view [citrus_usr].[DP_ACCT_MSTR]
As


Select * from AGMUBODPL3.dMAT.CITRUS_USR.DP_ACCT_MSTR With(Nolock)
Union all
Select * from AngelDP5.dMAT.CITRUS_USR.DP_ACCT_MSTR With(Nolock)
Union all
Select * from Angeldp202.dMAT.CITRUS_USR.DP_ACCT_MSTR With(Nolock)
Union all
Select * from ABVSDP203.dMAT.CITRUS_USR.DP_ACCT_MSTR With(Nolock)
Union all
Select * from ABVSDP204.dMAT.CITRUS_USR.DP_ACCT_MSTR With(Nolock)

GO
