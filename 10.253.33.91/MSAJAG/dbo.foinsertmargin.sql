-- Object: PROCEDURE dbo.foinsertmargin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foinsertmargin    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.foinsertmargin    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.foinsertmargin    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.foinsertmargin    Script Date: 20-Mar-01 11:38:50 PM ******/

/****** Object:  Stored Procedure dbo.foinsertmargin    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.foinsertmargin    Script Date: 12/27/00 8:58:50 PM ******/




create proc foinsertmargin
(@Account varchar(10),
@TradeDate smalldatetime,
@InstType varchar(6),
@Symbol         varchar(12),
@secname varchar(25),
@Expirydate smalldatetime,
@Strikeprice money,
@Optiontype varchar(2),
@finalim        money) as
insert into fomargin1 
values(@account,@tradedate,@insttype,@symbol,@secname,@Expirydate,@Strikeprice,@optiontype,@finalim)

GO
