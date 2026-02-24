-- Object: PROCEDURE dbo.rpt_fodetailtrade4432
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fodetailtrade4432    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodetailtrade4432    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodetailtrade4432    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodetailtrade4432    Script Date: 5/5/2001 1:24:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodetailtrade4432    Script Date: 4/30/01 5:50:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodetailtrade4432    Script Date: 10/26/00 6:04:42 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fodetailtrade4432    Script Date: 12/27/00 8:59:10 PM ******/
CREATE PROCEDURE rpt_fodetailtrade4432
@edate varchar(12)
AS
select inst_type, symbol, convert(varchar,expirydate,106)'expirydate', tradeqty ,amount,sell_buy 
from fotrade4432 s, client1 c1, client2 c2
where c1.cl_code = c2.cl_code
and c2.party_code = s.party_code
and convert(varchar,s.expirydate,103) = convert(varchar,@edate,103)
group by inst_type, symbol, expirydate, tradeqty ,amount,sell_buy 
order by inst_type, symbol, expirydate,sell_buy

GO
