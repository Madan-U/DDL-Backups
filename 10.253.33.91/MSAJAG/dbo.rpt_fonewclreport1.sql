-- Object: PROCEDURE dbo.rpt_fonewclreport1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fonewclreport1    Script Date: 5/11/01 6:19:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonewclreport1    Script Date: 5/7/2001 9:02:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonewclreport1    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonewclreport1    Script Date: 5/5/2001 1:24:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonewclreport1    Script Date: 4/30/01 5:50:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonewclreport1    Script Date: 10/26/00 6:04:44 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fonewclreport1    Script Date: 12/27/00 8:59:10 PM ******/
CREATE PROCEDURE rpt_fonewclreport1
@code varchar(10)
AS
select party_code,inst_type, symbol,convert(varchar,expirydate,106)'expirydate', 
sell_buy,tradeqty,price, convert(varchar,tradedate,106)'tradedate' 
from fotrade4432 o 
where o.party_code = @code
order by inst_type, symbol,expirydate, sell_buy,price, tradedate

GO
