-- Object: PROCEDURE dbo.rpt_NSEposition
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_NSEposition    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSEposition    Script Date: 3/21/01 12:50:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSEposition    Script Date: 20-Mar-01 11:39:02 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSEposition    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSEposition    Script Date: 12/27/00 8:58:57 PM ******/

/* report : NSEPosition
   file :  NSEPositiont.asp */
/* displays output to show the NET POSITION NSE reports*/
CREATE PROCEDURE rpt_NSEposition
@settno varchar(7),
@settype varchar(3)
AS
if ( select Count(*) from settlement where sett_no = @settno and sett_type = @settype ) > 0 
 begin
  select sett_no,sett_type,scrip_cd,series,Quantity=sum(tradeqty),Amount=sum(tradeqty*marketrate),sell_buy 
  from settlement where sett_no = @settno and sett_type = @settype
  group by sett_no,sett_type,scrip_cd,series,sell_buy 
  order by sett_no,sett_type,scrip_cd,series,sell_buy 
 end
else
 begin
  select sett_no,sett_type,scrip_cd,series,Quantity=sum(tradeqty),Amount=sum(tradeqty*marketrate),sell_buy 
  from history where sett_no = @settno and sett_type = @settype
  group by sett_no,sett_type,scrip_cd,series,sell_buy 
  order by sett_no,sett_type,scrip_cd,series,sell_buy 
 end

GO
