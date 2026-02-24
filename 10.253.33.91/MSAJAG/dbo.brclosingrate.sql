-- Object: PROCEDURE dbo.brclosingrate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brclosingrate    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brclosingrate    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brclosingrate    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brclosingrate    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.brclosingrate    Script Date: 12/27/00 8:58:44 PM ******/

/* Report : mtom
    File : mtomrepot */
CREATE PROCEDURE brclosingrate
@scripcd varchar(10),
@series varchar(2)
AS
select distinct Cl_Rate 
from closing 
where scrip_cd =@scripcd 
and series =@series 
and MARKET='NORMAL'

GO
