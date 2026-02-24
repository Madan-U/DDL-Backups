-- Object: PROCEDURE dbo.rpt_fotodaysrep1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fotodaysrep1    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysrep1    Script Date: 5/7/2001 9:02:52 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysrep1    Script Date: 5/5/2001 2:43:40 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysrep1    Script Date: 5/5/2001 1:24:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysrep1    Script Date: 4/30/01 5:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotodaysrep1    Script Date: 10/26/00 6:04:45 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fotodaysrep1    Script Date: 12/27/00 8:59:11 PM ******/
/** foreport > todaysreport.asp ***/
CREATE PROCEDURE 
rpt_fotodaysrep1
@partyname varchar(21),
@partycode varchar(10),
@inst varchar(6),
@symbol varchar(12),
@tdate varchar(10)
AS
select c1.short_name,t4.sell_buy,t4.inst_type,t4.symbol,t4.tradeqty,
convert(varchar,t4.expirydate,106)'expirydate' ,convert(varchar,t4.tradedate,106)'tradedate',
t4.price,t4.party_code 
from fotrade4432 t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%' and t4.inst_type like ltrim(@inst)+'%' 
and t4.party_code like ltrim(@partycode)+'%' 
and t4.symbol like  ltrim(@symbol)+'%'
and convert(varchar,t4.tradedate,103) like convert(varchar,ltrim(@tdate),103)+'%'
order by t4.party_code,c1.short_name,t4.inst_type,t4.sell_buy , t4.expirydate,t4.tradedate

GO
