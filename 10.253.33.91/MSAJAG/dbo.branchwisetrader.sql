-- Object: PROCEDURE dbo.branchwisetrader
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.branchwisetrader    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.branchwisetrader    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.branchwisetrader    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.branchwisetrader    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.branchwisetrader    Script Date: 12/27/00 8:58:43 PM ******/

CREATE PROCEDURE branchwisetrader 
@settno varchar(7),
@settype varchar(3),
@trader varchar(15),
@branchcd varchar(3)
AS
select sett_no,sett_type,scrip_Cd,sell_buy,series,
qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from settlement s, client1 c1, client2 c2, branches b
where s.sett_no=@settno and s.sett_type=@settype and
s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.trader=@trader and c1.trader=b.short_name and b.branch_cd=@branchcd
group by sett_no,sett_type,scrip_Cd,series,sell_buy
union 
select sett_no,sett_type,scrip_Cd,sell_buy,series,
qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from history s, client1 c1, client2 c2, branches b
where s.sett_no=@settno and s.sett_type=@settype and
s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.trader=@trader and c1.trader=b.short_name and b.branch_cd=@branchcd
group by sett_no,sett_type,scrip_Cd,series,sell_buy
order by sett_no,sett_type,scrip_Cd,series,sell_buy

GO
