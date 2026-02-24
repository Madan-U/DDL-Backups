-- Object: PROCEDURE dbo.misgrossexp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.misgrossexp    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.misgrossexp    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.misgrossexp    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.misgrossexp    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.misgrossexp    Script Date: 12/27/00 8:58:51 PM ******/

/* calculates gross exposure of all clients till todays including settlement */
create procedure misgrossexp as
select grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name from settlement s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.billno = '0' and s.sett_type='N'
group by c1.cl_code,c1.short_name
union
select grossexp=sum(s.tradeqty*s.marketrate),c1.cl_code,c1.short_name from trade4432 s,client1 c1,client2 c2 
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
group by c1.cl_code,c1.short_name
order by c1.cl_code,c1.short_name

GO
