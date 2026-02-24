-- Object: PROCEDURE dbo.brnewmar
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brnewmar    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brnewmar    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brnewmar    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brnewmar    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brnewmar    Script Date: 12/27/00 8:58:45 PM ******/

/* Report : Management info
    File : newclientreport.asp
displays list of trades confirmed for a client
*/
CREATE PROCEDURE brnewmar
@partycode varchar(10)
AS
select distinct Order_no,sell_buy,Scrip_cd,Series,tradeqty, 
marketrate,user_id,sauda_date,t.party_code
from trade4432 t,client1 c1, client2 c2
where t.party_code = @partycode 
and c1.cl_code = c2.cl_code
order by t.party_code,scrip_cd,sell_buy,sauda_date

GO
