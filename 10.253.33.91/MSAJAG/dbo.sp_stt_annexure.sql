-- Object: PROCEDURE dbo.sp_stt_annexure
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sp_STT_Annexure    Script Date: Oct 14 2004 20:20:12 ******/
CREATE proc

	sp_stt_annexure
	(
		@datefrom varchar(11), 
		@dateto varchar(11), 

		@partyfrom varchar(10), 
		@partyto varchar(10), 

		@contnofrom varchar(12), 
		@contnoto varchar(12), 

		@statusid varchar(15), 
		@statusname varchar(25)
	)

as

set @datefrom = ltrim(rtrim(@datefrom)) + ' 00:00:00'
set @dateto = ltrim(rtrim(@dateto)) + ' 23:59:59'
set @partyfrom = ltrim(rtrim(@partyfrom))
set @partyto = ltrim(rtrim(@partyto))
set @contnofrom = ltrim(rtrim(@contnofrom))
set @contnoto = ltrim(rtrim(@contnoto))
set @statusid = ltrim(rtrim(@statusid))
set @statusname = ltrim(rtrim(@statusname))

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
	company, addr1, addr2, city, zip, phone, isnull(exchangecode, 'NSE') exchangecode, membercode, 
	s.party_code, long_name, pan_gir_no, isnull(u.mapidid, '') mapidid, 
	contractno, scrip_cd, series, convert(varchar, sauda_date, 103) sauda_date, 
	pqtydel, pdelprice, pamtdel, psttdel, sqtydel, sdelprice, samtdel, ssttdel, 
	sqtytrd, strdprice, samttrd, sstttrd, totalstt

from
	owner, client1 c1, client2 c2, 
	stt_clientdetail s left outer join ucc_client u on (u.party_code = s.party_code)

where

	s.party_code = c2.party_code and c1.cl_code = c2.cl_code	and 
	s.party_code >= @partyfrom and s.party_code <= @partyto 	and 
	s.sauda_date >= @datefrom and s.sauda_date <= @dateto 	and 
	s.contractno >= @contnofrom and s.contractno <= @contnoto	and 
	c2.insurance_chrg = 1 and pqtydel+sqtydel+sqtytrd > 0 and
	len(ltrim(rtrim(contractno))) > 0 	and 

	branch_cd like (case when @statusid = 'branch' then @statusname else '%' end)	and 
	sub_broker like (case when @statusid = 'sub_broker' then @statusname else '%' end) and 
	trader like (case when @statusid = 'trader' then @statusname else '%' end) and 
	c1.family like (case when @statusid = 'family' then @statusname else '%' end) 	and 
	c1.cl_code like (case when @statusid = 'client' then @statusname else '%' end)

	order by
		sauda_date, s.party_code, contractno

GO
