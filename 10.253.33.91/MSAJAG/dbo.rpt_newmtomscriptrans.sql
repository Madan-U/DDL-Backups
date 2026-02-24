-- Object: PROCEDURE dbo.rpt_newmtomscriptrans
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_newmtomscriptrans    Script Date: 04/27/2001 4:32:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newmtomscriptrans    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newmtomscriptrans    Script Date: 20-Mar-01 11:39:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newmtomscriptrans    Script Date: 2/5/01 12:06:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_newmtomscriptrans    Script Date: 12/27/00 8:58:56 PM ******/

/* report : newmtom report
   file : scriptrans.asp
*/
/* displays details of a saudas of a particular party and scrip */
CREATE PROCEDURE rpt_newmtomscriptrans
@partycode varchar(10),
@scripcd varchar(12),
@series varchar(3)
AS
select sett_no,sett_type,party_code,Scrip_Cd,series,tradeqty,MarketRate,Sell_buy,Sauda_date,User_id 
from settlement 
where party_code = @partycode and sett_type = 'N' and billno =0 and Scrip_Cd = @scripcd and series = @series
order by sett_no,sett_type,party_code,Scrip_Cd,series,Sauda_date,Sell_buy,tradeqty,MarketRate,User_id

GO
