-- Object: VIEW dbo.Vw_SYNERGY_HOLDING
-- Server: 10.253.78.187 | DB: inhouse
--------------------------------------------------

Create View Vw_SYNERGY_HOLDING
as
select * from Inhouse.DBO.SYNERGY_HOLDING with (nolock)
union all
select * from synergy.DBO.SYNERGY_HOLDING with (nolock)

GO
