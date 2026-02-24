-- Object: PROCEDURE dbo.sbgrossexp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbgrossexp    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbgrossexp    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sbgrossexp    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbgrossexp    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbgrossexp    Script Date: 12/27/00 8:59:00 PM ******/

CREATE PROCEDURE sbgrossexp
@broker varchar(15)
AS
select grossexp=sum(s.tradeqty*s.N_NetRate),c1.cl_code,c1.short_name from settlement s,client1 c1,client2 c2 , branches b,
subbrokers sb
where c1.cl_code=c2.cl_code
and s.party_code = c2.party_code 
and sb.sub_broker = c1.sub_broker
and sb.sub_broker=@broker
and  s.billno = '0' and s.sett_type='N'
and b.short_name=c1.trader
group by c1.cl_code,c1.short_name
order by c1.short_name

GO
