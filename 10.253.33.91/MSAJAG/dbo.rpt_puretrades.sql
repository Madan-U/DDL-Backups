-- Object: PROCEDURE dbo.rpt_puretrades
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_puretrades    Script Date: 04/27/2001 4:32:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_puretrades    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_puretrades    Script Date: 20-Mar-01 11:39:02 PM ******/




/* report : partywise turnover 
   file : detailparty.asp
*/
/*displays partywise,scripwise position of  orders having order no like p% */

CREATE PROCEDURE rpt_puretrades

@partycode varchar(10)
AS


select Scrip_Cd,party_code, qty=sum(tradeqty), amount=sum(tradeqty*marketrate), Sell_buy, 
sett_no, series, sett_type  from settlement 
where party_code=@partycode and order_no like 'p%'
group by party_code,series,scrip_cd,sett_type,sett_no,sell_buy
order by party_code,series,scrip_cd,sett_type,sett_no,sell_buy

GO
