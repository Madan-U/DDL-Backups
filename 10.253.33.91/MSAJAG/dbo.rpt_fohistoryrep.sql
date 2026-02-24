-- Object: PROCEDURE dbo.rpt_fohistoryrep
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fohistoryrep    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fohistoryrep    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fohistoryrep    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fohistoryrep    Script Date: 5/5/2001 1:24:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fohistoryrep    Script Date: 4/30/01 5:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fohistoryrep    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fohistoryrep    Script Date: 12/27/00 8:59:10 PM ******/
/*** report : fo >misnews
    file ; historyreport.asp **/
CREATE procedure 
rpt_fohistoryrep
@partyname varchar(21),
@inst varchar(6),
@partycode varchar(10),
@sdate varchar(10)
as
select c1.short_name,t4.Order_no,t4.sell_buy,
t4.inst_type,t4.Symbol,t4.tradeqty, 
t4.price,t4.user_id,convert(varchar,t4.activitytime,106)'activitytime',t4.party_code ,
convert(varchar,t4.expirydate,106)'expirydate', t4.strike_price, t4.option_type
from fotrade t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@partyname)+'%'
and t4.inst_type like ltrim(@inst)+'%'
and t4.party_code like ltrim(@partycode)+'%'
and convert(varchar,t4.activitytime,103)=convert(varchar,@sdate,103)
union all
select c1.short_name,t4.Order_no,t4.sell_buy,
t4.inst_type,t4.Symbol,t4.tradeqty, 
t4.price,t4.user_id,convert(varchar,t4.sauda_date,106)'sauda_date',t4.party_code ,
convert(varchar,t4.expirydate,106)'expirydate', t4.strike_price, t4.option_type
from fosettlement t4,client1 c1,client2 c2
where c2.party_code = t4.party_code and 
c1.cl_code = c2.cl_code  and 
c1.short_name like ltrim(@partyname)+'%'
 and t4.inst_type like ltrim(@inst)+'%'
and t4.party_code like ltrim(@partycode)+'%'
and convert(varchar,t4.sauda_date,103)=convert(varchar,@sdate,103)

GO
