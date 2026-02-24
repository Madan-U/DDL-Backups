-- Object: PROCEDURE dbo.brmisgrossexp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brmisgrossexp    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brmisgrossexp    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brmisgrossexp    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brmisgrossexp    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brmisgrossexp    Script Date: 12/27/00 8:58:44 PM ******/

/* displays list of  grossexp of clients for current settlement including no del scrips for a 
particular branch
*/
CREATE PROCEDURE brmisgrossexp
@br varchar(3)
AS
select grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name from settlement s,client1 c1,client2 c2 , branches b
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and  s.billno = '0' and s.sett_type='N'
and b.short_name=c1.trader
and b.branch_cd=@br
group by c1.cl_code,c1.short_name
union
select grossexp=sum(s.tradeqty*s.marketrate),c1.cl_code,c1.short_name from trade4432 s,client1 c1,client2 c2 , branches b
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and b.short_name=c1.trader
and b.branch_cd=@br
group by c1.cl_code,c1.short_name
order by c1.cl_code,c1.short_name

GO
