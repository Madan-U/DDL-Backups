-- Object: PROCEDURE dbo.sbmngtodaysreport1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmngtodaysreport1    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbmngtodaysreport1    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbmngtodaysreport1    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmngtodaysreport1    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmngtodaysreport1    Script Date: 12/27/00 8:59:00 PM ******/

/*  file :todays reports .asp 
    report : management info
displays list of trades that are not confirmed 
 **/
CREATE PROCEDURE sbmngtodaysreport1
@partyname varchar(21),
@scripcd varchar(10),
@partycode varchar(10),
@series varchar(3)
 AS
select  distinct c1.short_name,o.order_no,o.party_code ,o.scrip_cd,o.series,o.sell_buy,(o.qty-o.tradeqty),o.user_id,
o.EffRate,o.OrderRate,o.qty,o.tradeqty,o.OrderTime
 from orders o,client1 c1,client2 c2
where c2.party_code = o.party_code and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%'  and o.scrip_cd like ltrim(@scripcd)+'%' and o.party_code like ltrim(@partycode)+'%'
and o.series like ltrim(series)+'%'
order by c1.short_name,o.scrip_cd,o.sell_buy,OrderTime

GO
