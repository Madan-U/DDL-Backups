-- Object: PROCEDURE dbo.rpt_albmgrossexp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmgrossexp    Script Date: 04/27/2001 4:32:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmgrossexp    Script Date: 3/21/01 12:50:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmgrossexp    Script Date: 20-Mar-01 11:38:53 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmgrossexp    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmgrossexp    Script Date: 12/27/00 8:58:53 PM ******/

/* report: misnews
   file : topscrip_clients.asp
*/
/* selects grossexposure of current settlement's albm transactions */
CREATE PROCEDURE rpt_albmgrossexp
@statusid varchar(15),
@statusname varchar(25),
@settno varchar(7)
AS
if @statusid='broker'
begin
select  grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.sett_no=@settno and s.sett_type='l'
group by c1.cl_code,c1.short_name
union all
select  grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.sett_no=@settno and s.sett_type='l'
group by c1.cl_code,c1.short_name
end 
if @statusid='branch'
begin
select  grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.sett_no=@settno and s.sett_type='l'
group by c1.cl_code,c1.short_name
union all
select  grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.sett_no=@settno and s.sett_type='l'
group by c1.cl_code,c1.short_name
end 
if @statusid='trader'
begin
select  grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.sett_no=@settno and s.sett_type='l'
group by c1.cl_code,c1.short_name
union all
select  grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.sett_no=@settno and s.sett_type='l'
group by c1.cl_code,c1.short_name
end
if @statusid='subbroker'
begin
select  grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.sett_no=@settno and s.sett_type='l'
group by c1.cl_code,c1.short_name
union all
select  grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.sett_no=@settno and s.sett_type='l'
group by c1.cl_code,c1.short_name
end
if @statusid='client'
begin
select  grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.sett_no=@settno and s.sett_type='l'
group by c1.cl_code,c1.short_name
union all
select  grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name 
from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.sett_no=@settno and s.sett_type='l'
group by c1.cl_code,c1.short_name
end

GO
