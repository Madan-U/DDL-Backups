-- Object: PROCEDURE dbo.rpt_foclosingdetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foclosingdetail    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosingdetail    Script Date: 5/7/2001 9:02:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosingdetail    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosingdetail    Script Date: 5/5/2001 1:24:10 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosingdetail    Script Date: 4/30/01 5:50:09 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foclosingdetail    Script Date: 10/26/00 6:04:41 PM ******/






/****** Object:  Stored Procedure dbo.rpt_foclosingdetail    Script Date: 12/27/00 8:59:09 PM ******/
/*
Used In      : NSE FO
Report Name  : Contract Wise Detail Report
File Name    : clientdetailclosingdetail
Tables Used  : fosettlement, foclosing
Function     : Returns sell_buy, tradeqty, closing rate of a particular contract descriptor
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_foclosingdetail
@inst varchar(6),
@symbol varchar(12),
@expdate varchar(12),
@code varchar(10),
@sdate varchar(12)
AS
/*select sell_buy, tradeqty, price , convert(varchar,sauda_date,106) as activitytime, c.cl_rate
from fosettlement t , foclosing c
where t.inst_type = @inst
and t.symbol = @symbol
and convert(varchar,t.expirydate,106) = @expdate
and party_Code = @code
and convert(varchar,t.expirydate,106) =  convert(varchar,c.expirydate,106)
and convert(varchar,trade_date,103) = convert(varchar,sauda_date,103)
and t.sauda_date <= @sdate + ' 23:29'
order by sell_buy*/


/*the above query was commented  by ranjeet and it was written by amolika */
/*it was modifed because it shows the details of the scrip even afer its maturity which should not happen */
/*The below query replaces it . written by ranjeet on 10 feb 2001*/

select sell_buy, tradeqty, price , 
      convert(varchar,sauda_date,106) as activitytime, c.cl_rate
from fosettlement t , foclosing c,FOSCRIP2
where 
     t.inst_type = FOSCRIP2.INST_TYPE and
     t.symbol = FOSCRIP2.SYMBOL and 
     convert(varchar,t.expirydate,106) = @expdate and 
     party_Code = @code and
     convert(varchar,t.expirydate,106) =  convert(varchar,c.expirydate,106) and 
     convert(varchar,trade_date,103) = convert(varchar,sauda_date,103) and 
     t.sauda_date <= @sdate + ' 23:59' AND
     
     FOSCRIP2.INST_TYPE=@inst AND 
     FOSCRIP2.SYMBOL=@symbol AND 
     convert(varchar,FOSCRIP2.expirydate,106)= @expdate AND
     FOSCRIP2.MATURITYDATE >= @sdate + ' 23:59'
order by sell_buy

GO
