-- Object: PROCEDURE dbo.rpt_fonetpositionsecurity2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fonetpositionsecurity2    Script Date: 5/11/01 6:19:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonetpositionsecurity2    Script Date: 5/7/2001 9:02:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonetpositionsecurity2    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonetpositionsecurity2    Script Date: 5/5/2001 1:24:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonetpositionsecurity2    Script Date: 4/30/01 5:50:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonetpositionsecurity2    Script Date: 10/26/00 6:04:43 PM ******/


CREATE PROCEDURE rpt_fonetpositionsecurity2
 

AS

select distinct convert(varchar,expirydate,106) as expirydate, expirydate as expdate
from  foscrip2 s2
where maturitydate  >= (select LEFT(CONVERT(VARCHAR,getdate(),109),11)) +' 23:59:00'
order by  expdate

GO
