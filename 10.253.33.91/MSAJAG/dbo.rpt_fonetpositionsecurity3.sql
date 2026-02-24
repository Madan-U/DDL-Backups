-- Object: PROCEDURE dbo.rpt_fonetpositionsecurity3
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fonetpositionsecurity3    Script Date: 5/11/01 6:19:49 PM ******/
CREATE PROCEDURE rpt_fonetpositionsecurity3

AS

select distinct strike_price, option_type
from  foscrip2 s2
where maturitydate  >= (select LEFT(CONVERT(VARCHAR,getdate(),109),11)) +' 23:59:00'
order by  strike_price

GO
