-- Object: PROCEDURE dbo.sbmngtodaysreport2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmngtodaysreport2    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbmngtodaysreport2    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbmngtodaysreport2    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmngtodaysreport2    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmngtodaysreport2    Script Date: 12/27/00 8:59:00 PM ******/

/*  file :todays reports .asp 
    report : management info
displays list of trades that are confirmed 
 **/
CREATE PROCEDURE sbmngtodaysreport2
@partyname varchar(21),
@scripcd varchar(10),
@partycode varchar(10),
@series varchar(3)
AS
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code 
from trade4432 t4,client1 c1,client2 c2 
where c2.party_code = t4.party_code and c1.cl_code = c2.cl_code 
and c1.short_name like ltrim(@partyname)+'%' and t4.Scrip_cd like ltrim(@scripcd)+'%' and 
t4.party_code like ltrim(@partycode)+'%' and t4.series like ltrim(series)+'%'
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date

GO
