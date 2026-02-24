-- Object: PROCEDURE dbo.rpt_fotodaysrep
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fotodaysrep    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysrep    Script Date: 5/7/2001 9:02:52 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysrep    Script Date: 5/5/2001 2:43:40 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysrep    Script Date: 5/5/2001 1:24:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysrep    Script Date: 05/04/2001 8:26:28 PM ******/
/****** Object:  Stored Procedure dbo.rpt_fotodaysrep    Script Date: 5/4/2001 2:40:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysrep    Script Date: 4/30/01 5:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysrep    Script Date: 10/26/00 6:04:45 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fotodaysrep    Script Date: 12/27/00 8:59:11 PM ******/
/** report : fo_reports
file : misnews **/
CREATE PROCEDURE rpt_fotodaysrep
@partyname varchar(21),
@partycode varchar(10),
@symbol varchar(12),
@tdate varchar(10),
@inst varchar(6)
 AS
select  distinct c1.short_name,
o.party_code ,o.inst_type,o.symbol,convert(varchar,o.expirydate,106)'expirydate',o.sell_buy,
o.tradeqty,convert(varchar,o.OrderTime,106)'ordertime',o.price
 from foorders o,client1 c1,client2 c2
where c2.party_code = o.party_code and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%'  and o.inst_type like ltrim(@inst)+'%' 
and o.party_code like ltrim(@partycode)+'%'
and o.symbol like  ltrim(@symbol)+'%'
and  convert(varchar,ordertime,103) like @tdate
order by c1.short_name,o.inst_type,o.symbol,o.expirydate,o.sell_buy,OrderTime

GO
