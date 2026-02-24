-- Object: PROCEDURE dbo.rpt_confirmFamily
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_confirmFamily    Script Date: 05/20/2002 5:24:32 PM ******/
CREATE PROCEDURE rpt_confirmFamily

@statusid varchar(15),
@statusname varchar(25),
@settype varchar(3)

AS

if @statusid = 'broker'
begin	
	select distinct Family from settlement S, Client1 C1, Client2 C2
	where sett_type = @settype and C1.Cl_Code = C2.Cl_Code and C2.Party_Code = Family
	union 
	select distinct Family from history S, Client1 C1, Client2 C2		
	where sett_type = @settype and C1.Cl_Code = C2.Cl_Code and C2.Party_Code = Family
	order by Family
end 

if @statusid = 'branch'
begin	
	select distinct Family from settlement s, client1 c1 , client2 c2, branches br
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = Family and br.short_name = c1.trader and br.branch_cd = @statusname
	union
	select distinct Family from isettlement s, client1 c1 , client2 c2, branches br
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = Family and br.short_name = c1.trader and br.branch_cd = @statusname
	order by Family
end 

if @statusid = 'subbroker'
begin	
	select distinct Family from settlement s, client1 c1 , client2 c2, subbrokers sb
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = Family and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
	union 
	select distinct Family from isettlement s, client1 c1 , client2 c2, subbrokers sb
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = Family and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
	order by Family
end 

if @statusid = 'trader'
begin	
	select distinct Family from settlement s, client1 c1 , client2 c2
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = Family and c1.trader = @statusname
	union
	select distinct Family from isettlement s, client1 c1 , client2 c2
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = Family and c1.trader = @statusname
	order by Family
end 

if @statusid = 'client'
begin	
	select distinct Family from settlement s, client1 c1 , client2 c2
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = Family and c2.party_code = @statusname
	union
	select distinct Family from isettlement s, client1 c1 , client2 c2
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = Family and c2.party_code = @statusname
	order by Family
end 

if @statusid = 'family'
begin	
	select distinct Family from settlement s, client1 c1 , client2 c2
	where sett_type = @settype and c1.cl_code = c2.cl_code and 
	c2.party_code = Family and c1.family = @statusname
	order by Family
end

GO
