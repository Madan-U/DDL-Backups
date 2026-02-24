-- Object: PROCEDURE dbo.bank_reco
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


 CREATE procedure bank_reco (@cltcode as varchar(11),@fdate as varchar(11))
as
set nocount on
delete from bankreco where cltcode=@cltcode and referenceno='0' 
and valuedate=@fdate and description like '%cms-%'
-- order by amount
set nocount off

GO
