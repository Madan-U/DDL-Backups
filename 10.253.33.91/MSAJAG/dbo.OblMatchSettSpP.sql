-- Object: PROCEDURE dbo.OblMatchSettSpP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.OblMatchSettSpP    Script Date: 3/17/01 9:55:54 PM ******/

/****** Object:  Stored Procedure dbo.OblMatchSettSpP    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.OblMatchSettSpP    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.OblMatchSettSpP    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.OblMatchSettSpP    Script Date: 12/27/00 8:58:52 PM ******/

CREATE PROCEDURE OblMatchSettSpP
 AS
 select Distinct Sett_no,sEtt_Type 
from settlement
 where tradeqty > 0 and BillNo > 0  
group by sett_no,Sett_Type 
 ORDER BY SETT_NO,Sett_type

GO
