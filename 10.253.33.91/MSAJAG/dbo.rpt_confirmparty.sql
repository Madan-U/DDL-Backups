-- Object: PROCEDURE dbo.rpt_confirmparty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_confirmparty    Script Date: 05/20/2002 5:24:32 PM ******/
CREATE PROCEDURE rpt_confirmparty

@statusid varchar(15),
@statusname varchar(25),
@settype varchar(3)

AS

if @statusid = 'broker'
begin	
	select distinct party_code from settlement 
	where sett_type = @settype 
	union 
	select distinct party_code from isettlement 
	where sett_type = @settype order by party_code
end 

if @statusid = 'branch'
begin	
	select distinct s.party_code from settlement s, client1 c1 , client2 c2, branches br
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = s.party_code and br.short_name = c1.trader and br.branch_cd = @statusname
	union
	select distinct s.party_code from isettlement s, client1 c1 , client2 c2, branches br
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = s.party_code and br.short_name = c1.trader and br.branch_cd = @statusname
	order by s.party_code
end 

if @statusid = 'subbroker'
begin	
	select distinct s.party_code from settlement s, client1 c1 , client2 c2, subbrokers sb
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = s.party_code and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
	union 
	select distinct s.party_code from isettlement s, client1 c1 , client2 c2, subbrokers sb
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = s.party_code and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
	order by s.party_code
end 

if @statusid = 'trader'
begin	
	select distinct s.party_code from settlement s, client1 c1 , client2 c2
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = s.party_code and c1.trader = @statusname
	union
	select distinct s.party_code from isettlement s, client1 c1 , client2 c2
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = s.party_code and c1.trader = @statusname
	order by s.party_code
end 

if @statusid = 'client'
begin	
	select distinct s.party_code from settlement s, client1 c1 , client2 c2
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = s.party_code and c2.party_code = @statusname
	union
	select distinct s.party_code from isettlement s, client1 c1 , client2 c2
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = s.party_code and c2.party_code = @statusname
	order by s.party_code
end 

if @statusid = 'family'
begin	
	select distinct s.party_code from settlement s, client1 c1 , client2 c2
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = s.party_code and c1.family = @statusname
	order by s.party_code
end

GO
