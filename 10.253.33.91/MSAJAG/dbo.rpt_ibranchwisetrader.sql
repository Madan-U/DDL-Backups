-- Object: PROCEDURE dbo.rpt_ibranchwisetrader
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_ibranchwisetrader    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibranchwisetrader    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibranchwisetrader    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibranchwisetrader    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibranchwisetrader    Script Date: 12/27/00 8:59:12 PM ******/

/* institutional trading */
/*
report : branch turnover 
file : trader.asp
displays traderwise,settlementwise report of a particular branch  for institutional trading
*/
CREATE PROCEDURE rpt_ibranchwisetrader 
@settno varchar(7),
@settype varchar(3),
@trader varchar(15),
@statusname varchar(25),
@statusid varchar(15),
@branch varchar(10),
@pcode varchar(15)
AS
if @statusid='broker'
begin
select sett_no,sett_type,scrip_Cd,sell_buy,series,
qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from isettlement s, client1 c1, client2 c2, branches b
where s.sett_no=@settno and s.sett_type=@settype and
s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.trader=@trader and c1.trader=b.short_name and b.branch_cd=@branch
and s.partipantcode like ltrim(@pcode)+ '%'
group by sett_no,sett_type,scrip_Cd,series,sell_buy
union all
select sett_no,sett_type,scrip_Cd,sell_buy,series,
qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from ihistory s, client1 c1, client2 c2, branches b
where s.sett_no=@settno and s.sett_type=@settype and
s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.trader=@trader and c1.trader=b.short_name and b.branch_cd=@branch
and s.partipantcode like ltrim(@pcode) + '%'
group by sett_no,sett_type,scrip_Cd,series,sell_buy
order by sett_no,sett_type,scrip_Cd,series,sell_buy
end 
if @statusid='branch'
begin
select sett_no,sett_type,scrip_Cd,sell_buy,series,
qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from isettlement s, client1 c1, client2 c2, branches b
where s.sett_no=@settno and s.sett_type=@settype and
s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.trader=@trader and c1.trader=b.short_name and b.branch_cd=@statusname
and s.partipantcode like ltrim(@pcode)+'%'
group by sett_no,sett_type,scrip_Cd,series,sell_buy
union all
select sett_no,sett_type,scrip_Cd,sell_buy,series,
qty=sum(tradeqty),amt=sum(marketrate*tradeqty) from ihistory s, client1 c1, client2 c2, branches b
where s.sett_no=@settno and s.sett_type=@settype and
s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.trader=@trader and c1.trader=b.short_name and b.branch_cd=@statusname
and s.partipantcode like ltrim(@pcode)+'%'
group by sett_no,sett_type,scrip_Cd,series,sell_buy
order by sett_no,sett_type,scrip_Cd,series,sell_buy
end

GO
