-- Object: PROCEDURE dbo.rpt_fotopclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fotopclient    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopclient    Script Date: 5/7/2001 9:02:52 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopclient    Script Date: 5/5/2001 2:43:40 PM ******/
/****** Object:  Stored Procedure dbo.rpt_fotopclient    Script Date: 05/04/2001 8:26:28 PM ******/
CREATE PROCEDURE rpt_fotopclient
@topclient varchar(15)
AS
select short_name,party_code,netPamt = sum(NetPamt), netSamt = sum(NetSamt),
inst_type, symbol,expirydate
from rpt_fotopclientPos
group by short_name,party_code,inst_type, symbol,expirydate

having sum(NetPamt) >convert(money, @topclient) or sum(NetSamt) >convert(money, @topclient)

GO
