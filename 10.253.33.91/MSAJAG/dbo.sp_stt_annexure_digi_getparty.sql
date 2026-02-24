-- Object: PROCEDURE dbo.sp_stt_annexure_digi_getparty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sp_stt_annexure_digi_getparty    Script Date: Oct 14 2004 20:19:56 ******/
CREATE proc

	sp_stt_annexure_digi_getparty
	(
		@datefrom varchar(11), 
		@dateto varchar(11), 

		@partyfrom varchar(10), 
		@partyto varchar(10), 

		@contnofrom varchar(12), 
		@contnoto varchar(12)
	)

as

set @datefrom = ltrim(rtrim(@datefrom)) + ' 00:00:00'
set @dateto = ltrim(rtrim(@dateto)) + ' 23:59:59'
set @partyfrom = ltrim(rtrim(@partyfrom))
set @partyto = ltrim(rtrim(@partyto))
set @contnofrom = ltrim(rtrim(@contnofrom))
set @contnoto = ltrim(rtrim(@contnoto))

if len(ltrim(rtrim(@partyfrom))) = 0 
begin
	set transaction isolation level read uncommitted 
	select 
		@partyfrom = min(party_code) 
	from 
		stt_clientdetail 
	where 
		sauda_date >= @datefrom and sauda_date <= @dateto
end

if len(ltrim(rtrim(@partyto))) = 0 
begin
	set transaction isolation level read uncommitted 
	select 
		@partyto = max(party_code) 
	from 
		stt_clientdetail 
	where 
		sauda_date >= @datefrom and sauda_date <= @dateto
end

if len(ltrim(rtrim(@contnofrom))) = 0 
begin
	set transaction isolation level read uncommitted 
	select 
		@contnofrom = min(contractno) 
	from 
		stt_clientdetail 
	where 
		party_code >= @partyfrom and party_code <= @partyto and
		sauda_date >= @datefrom and sauda_date <= @dateto and
		len(ltrim(rtrim(contractno))) > 0
end

if len(ltrim(rtrim(@contnoto))) = 0 
begin 
	set transaction isolation level read uncommitted 
	select 
		@contnoto = max(contractno) 
	from 
		stt_clientdetail 
	where 
		party_code >= @partyfrom and party_code <= @partyto and
		sauda_date >= @datefrom and sauda_date <= @dateto and
		len(ltrim(rtrim(contractno))) > 0
end

print '@partyfrom: ' + @partyfrom
print '@partyto: ' + @partyto
print '@contnofrom: ' + @contnofrom
print '@contnoto: ' + @contnoto

set transaction isolation level read uncommitted 

select	
	left(convert(varchar, min(sauda_date), 103), 10) as datefrom, 
	left(convert(varchar, max(sauda_date), 103), 10) as dateto, 
	ltrim(rtrim(party_code)) as party_code, 
	ltrim(rtrim(min(contractno))) as contractfrom, 
	ltrim(rtrim(max(contractno))) as contractto

from 
	stt_clientdetail

where
	party_code >= @partyfrom and party_code <= @partyto and
	contractno >= @contnofrom and contractno <= @contnoto 	and 
	sauda_date >= @datefrom and sauda_date <= @dateto and
	len(ltrim(rtrim(contractno))) > 0

group by
	ltrim(rtrim(party_code))

order by 
	ltrim(rtrim(party_code))

GO
