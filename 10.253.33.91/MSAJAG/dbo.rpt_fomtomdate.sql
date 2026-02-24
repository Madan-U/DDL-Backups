-- Object: PROCEDURE dbo.rpt_fomtomdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomtomdate    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomtomdate    Script Date: 5/7/2001 9:02:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomtomdate    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomtomdate    Script Date: 5/5/2001 1:24:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomtomdate    Script Date: 4/30/01 5:50:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomtomdate    Script Date: 10/26/00 6:04:43 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fomtomdate    Script Date: 12/27/00 8:59:10 PM ******/
CREATE PROCEDURE rpt_fomtomdate
AS
select party_code,inst_type, symbol, expirydate = convert(varchar,expirydate,106),
spread, nonspread, spmargin, nonspmargin 
from margin

GO
