-- Object: PROCEDURE dbo.Trade_online
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create proc Trade_online (

@DATE VARCHAR (11),

@PARTYCODE VARCHAR (10)
)as 
select * from TBL_TRADE_ONLINE where SAUDA_DATE>=@DATE
and PARTY_CODE =@PARTYCODE order by PARTY_CODE

GO
