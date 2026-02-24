-- Object: PROCEDURE dbo.rpt_branchwise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_branchwise    Script Date: 04/27/2001 4:32:33 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchwise    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchwise    Script Date: 20-Mar-01 11:38:54 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchwise    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchwise    Script Date: 12/27/00 8:58:53 PM ******/

/*
report : branch turnover 
file :trader.asp
displays settlementwise,scripwise cumulative report  including all traders of a particular branch  
*/
CREATE PROCEDURE rpt_branchwise
@settno varchar(7),
@settype varchar(3),
@statusid varchar(15),
@statusname varchar(25),
@branch varchar(10)
 AS
if @statusid='broker'
begin
select sett_no,sett_type,scrip_Cd,sell_buy,series,
qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from settlement s, client1 c1, client2 c2, branches b
where s.sett_no=@settno and s.sett_type=@settype and
s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.trader=b.short_name and b.branch_cd=@branch
group by sett_no,sett_type,scrip_Cd,series,sell_buy
union all
select sett_no,sett_type,scrip_Cd,sell_buy,series,
qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from history s, client1 c1, client2 c2, branches b
where s.sett_no=@settno and s.sett_type=@settype and
s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.trader=b.short_name and b.branch_cd=@branch
group by sett_no,sett_type,scrip_Cd,series,sell_buy
order by sett_no,sett_type,scrip_Cd,series,sell_buy
end
if @statusid='branch'
begin
select sett_no,sett_type,scrip_Cd,sell_buy,series,
qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from settlement s, client1 c1, client2 c2, branches b
where s.sett_no=@settno and s.sett_type=@settype and
s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.trader=b.short_name and b.branch_cd=@statusname
group by sett_no,sett_type,scrip_Cd,series,sell_buy
union all
select sett_no,sett_type,scrip_Cd,sell_buy,series,
qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from history s, client1 c1, client2 c2, branches b
where s.sett_no=@settno and s.sett_type=@settype and
s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.trader=b.short_name and b.branch_cd=@statusname
group by sett_no,sett_type,scrip_Cd,series,sell_buy
order by sett_no,sett_type,scrip_Cd,series,sell_buy
end

GO
