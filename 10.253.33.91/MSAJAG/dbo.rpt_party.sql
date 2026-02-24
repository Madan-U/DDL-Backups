-- Object: PROCEDURE dbo.rpt_party
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE rpt_party
@statusid varchar(15),
@statusname varchar(25),
@settno varchar(7),
@settype varchar(3)
AS
if @statusid='broker'
begin
	select distinct party_code from albmpartypos 
	where sett_type = @settype and sett_no = @settno
	union
	select distinct party_code from albmpos  where sett_type = @settype
	and sett_no = @settno
	order by party_code
end

if @statusid='subbroker'
begin
	
	select distinct  a.party_code from albmpartypos a ,client1 c1 ,client2 c2 ,subbrokers sb
	where 
	c1.cl_code = c2.cl_code
	and a.party_code =c2.party_code
	and sett_type = @settype 
	and sett_no = @settno
	and c1.sub_broker = sb.sub_broker
	and sb.sub_broker = @statusname
	union
	select  distinct a.party_code from albmpos a ,client1 c1 ,client2 c2 ,subbrokers sb
	where 
	c1.cl_code = c2.cl_code
	and a.party_code =c2.party_code
	and sett_type = @settype 
	and sett_no = @settno
	and c1.sub_broker = sb.sub_broker
	and sb.sub_broker = @statusname
end

if @statusid='branch'
begin	
	select distinct a.party_code from albmpartypos a , client1 c1 , client2 c2 ,branches br
	where sett_type =@settype  and sett_no  =@settno
	and c1.cl_code = c2.cl_code
	and c2.party_code = a.party_code
	and br.short_name = c1.trader
	and br.branch_cd = @statusname
	union	
	select distinct a.party_code from albmpos a , client1 c1 , client2 c2 ,branches br
	where sett_type = @settype  and sett_no  =@settno
	and c1.cl_code = c2.cl_code
	and c2.party_code = a.party_code
	and br.short_name = c1.trader
	and br.branch_cd = @statusname
end

if @statusid='trader'
begin
	select distinct a.party_code from albmpartypos a , client1 c1 ,client2 c2
	where sett_type = @settype
	and sett_no = @settno
	and c1.cl_code =c2.cl_code
	and c2.party_code = a.party_code
	and c1.trader =@statusname
union all
	select distinct a.party_code from albmpos a , client1 c1 ,client2 c2
	where sett_type = @settype
	and sett_no = @settno
	and c1.cl_code =c2.cl_code
	and c2.party_code = a.party_code
	and c1.trader =@statusname
end


if @statusid='client'
begin
	select distinct a.party_code from albmpartypos a , client1 c1 ,client2 c2
	where sett_type = @settype
	and sett_no = @settno
	and c1.cl_code =c2.cl_code
	and c2.party_code = a.party_code
	and a.party_code =@statusname
union all
	select distinct a.party_code from albmpos a , client1 c1 ,client2 c2
	where sett_type = @settype
	and sett_no = @settno
	and c1.cl_code =c2.cl_code
	and c2.party_code = a.party_code
	and a.party_code =@statusname
end

if @statusid='family'
begin
	select distinct a.party_code from albmpartypos a , client1 c1 ,client2 c2
	where sett_type = @settype
	and sett_no = @settno
	and c1.cl_code =c2.cl_code
	and c2.party_code = a.party_code
	and c1.family =@statusname
	union all
	select distinct a.party_code from albmpos a , client1 c1 ,client2 c2
	where sett_type = @settype
	and sett_no = @settno
	and c1.cl_code =c2.cl_code
	and c2.party_code = a.party_code
	and c1.family =@statusname
end

GO
