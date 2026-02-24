-- Object: PROCEDURE dbo.RecOsettED
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.RecOsettED    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.RecOsettED    Script Date: 11/28/2001 12:23:45 PM ******/

/****** Object:  Stored Procedure dbo.RecOsettED    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.RecOsettED    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.RecOsettED    Script Date: 8/7/01 6:03:50 PM ******/

/****** Object:  Stored Procedure dbo.RecOsettED    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.RecOsettED    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.RecOsettED    Script Date: 20-Mar-01 11:43:34 PM ******/

CREATE PROCEDURE RecOsettED
@stdate varchar(12),
@eddate varchar(12)
AS
SELECT DISTINCT convert(varchar,s.sauda_date,103), 
BOKERAGE = isnull(SUM(s.TRADEQTY*s.BROKAPPLIED),0), 
DELCHRG =  isnull(SUM(s.TRADEQTY*(s.NBROKAPP - s.BROKAPPLIED)),0), 
SERVICE_TAX = isnull(SUM(s.NSERTAX),0)  
FROM MSAJAG.DBO.SETTLEMENT s, MSAJAG.DBO.client1 c1,MSAJAG.DBO.client2 c2 Where  c2.Party_Code = s.Party_Code And 
c1.cl_code = c2.cl_code and  s. Sauda_date  >=@stdate  and s.sauda_date <= @eddate    and s.sett_type ='M'
group by convert(varchar,s.sauda_date,103) 
Union  
SELECT DISTINCT convert(varchar,h.sauda_date,103),  
BOKERAGE = isnull(SUM(TRADEQTY*BROKAPPLIED),0),  
DELCHRG =  isnull(SUM(TRADEQTY*(NBROKAPP - BROKAPPLIED)),0),  
SERVICE_TAX = isnull(SUM(NSERTAX),0)  FROM MSAJAG.DBO.history h, MSAJAG.DBO.client1 c1,MSAJAG.DBO.client2 c2 
Where  c2.Party_Code = h.Party_Code And c1.cl_code = c2.cl_code and  h. Sauda_date  >= @stdate
and h.sauda_date <= @eddate    and h.sett_type ='M'
group by convert(varchar,h.sauda_date,103)  
order by convert(varchar,sauda_date,103)

GO
