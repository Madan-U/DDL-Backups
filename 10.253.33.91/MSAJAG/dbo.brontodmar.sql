-- Object: PROCEDURE dbo.brontodmar
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brontodmar    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brontodmar    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brontodmar    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brontodmar    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brontodmar    Script Date: 12/27/00 8:58:45 PM ******/

/* Report : Online Trading 
   File : todaysreport.asp 
*/
CREATE PROCEDURE brontodmar
@br varchar(3),
@party varchar(10)
AS
select c1.short_name,t4.Order_no,t4.sell_buy,t4.Scrip_cd,t4.Series,t4.tradeqty, 
t4.marketrate,t4.user_id,t4.sauda_date,t4.party_code 
from trade4432 t4,client1 c1,client2 c2, branches b 
where c2.party_code = t4.party_code 
and c1.cl_code = c2.cl_code 
and b.short_name = c1.trader
and b.branch_cd = @br
and t4.party_code like ltrim(@party)
order by t4.party_code,c1.short_name,t4.scrip_cd,t4.sell_buy,t4.sauda_date

GO
