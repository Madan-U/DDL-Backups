-- Object: PROCEDURE dbo.rpt_newclrep2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_newclrep2    Script Date: 04/27/2001 4:32:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newclrep2    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newclrep2    Script Date: 20-Mar-01 11:39:01 PM ******/





/****** Object:  Stored Procedure dbo.rpt_newclrep2    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newclrep2    Script Date: 12/27/00 8:58:56 PM ******/

/*** file :newclientreport.asp
 report :management info  
displays orders confirmed for new client
***/
CREATE PROCEDURE rpt_newclrep2
@partycode varchar(10)
AS
select Order_no,sell_buy,Scrip_cd,Series,tradeqty, marketrate, 
user_id,sauda_date,t.party_code , markettype
from trade4432 t 
where t.party_code = @partycode
order by t.party_code,scrip_cd,sell_buy,sauda_date

GO
