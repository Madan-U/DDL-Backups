-- Object: PROCEDURE dbo.disp_ledger
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

create proc disp_ledger
(
@cltcode varchar(25)
)
as
declare @acyearfrom as datetime,@acyearto as datetime
select @acyearfrom=sdtcur,@acyearto=ldtcur from parameter (nolock) 
where sdtcur <=getdate() and ldtcur >=getdate()

select * from ledger a (nolock) 
where vdt >=@acyearfrom and vdt<=getdate()
and a.cltcode = @cltcode

return

GO
