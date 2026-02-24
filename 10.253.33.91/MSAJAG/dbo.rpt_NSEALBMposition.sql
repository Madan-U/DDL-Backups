-- Object: PROCEDURE dbo.rpt_NSEALBMposition
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_NSEALBMposition    Script Date: 04/27/2001 4:32:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSEALBMposition    Script Date: 3/21/01 12:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSEALBMposition    Script Date: 20-Mar-01 11:39:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSEALBMposition    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_NSEALBMposition    Script Date: 12/27/00 8:58:56 PM ******/

/* report : NSEPosition
   file :  NSEPositiont.asp */
/* displays output to show the NET POSITION NSE reports*/
CREATE PROCEDURE rpt_NSEALBMposition
@settno varchar(7),
@settype varchar(3),
@scripcd varchar(10),
@series varchar(3)
AS
if ( select Count(*) from settlement where sett_no = @settno and sett_type = @settype ) > 0 
 begin
  select s.sett_no,s.sett_type,s.scrip_cd,s.series,Quantity=sum(s.tradeqty),Amount=sum(s.tradeqty * a.rate),s.sell_buy
  from settlement s, albmrate a
  where a.sett_no = s.sett_no and a.sett_type = s.sett_type
  and a.scrip_cd = s.scrip_cd and a.series = s.series
  and s.sett_no = @settno and s.sett_type = @settype
  and s.scrip_cd = @scripcd and s.series = @series
  group by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy
  order by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy
 end
else
 begin
  select s.sett_no,s.sett_type,s.scrip_cd,s.series,Quantity=sum(s.tradeqty),Amount=sum(s.tradeqty * a.rate),s.sell_buy
  from history s, albmrate a
  where a.sett_no = s.sett_no and a.sett_type = s.sett_type
  and a.scrip_cd = s.scrip_cd and a.series = s.series
  and s.sett_no = @settno and s.sett_type = @settype
  and s.scrip_cd = @scripcd and s.series = @series
  group by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy
  order by s.sett_no,s.sett_type,s.scrip_cd,s.series,s.sell_buy
 end

GO
