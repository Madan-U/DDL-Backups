-- Object: PROCEDURE dbo.rpt_fonetpositionsecurity
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fonetpositionsecurity    Script Date: 5/11/01 6:19:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonetpositionsecurity    Script Date: 5/7/2001 9:02:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonetpositionsecurity    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonetpositionsecurity    Script Date: 5/5/2001 1:24:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonetpositionsecurity    Script Date: 4/30/01 5:50:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fonetpositionsecurity    Script Date: 10/26/00 6:04:43 PM ******/


CREATE PROCEDURE rpt_fonetpositionsecurity


AS


select distinct  inst_type
from foscrip2
where maturitydate > (select getdate()) +' 23:59:00'

GO
