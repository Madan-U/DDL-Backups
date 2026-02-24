-- Object: PROCEDURE dbo.sbclose
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbclose    Script Date: 3/17/01 9:56:06 PM ******/

/****** Object:  Stored Procedure dbo.sbclose    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sbclose    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbclose    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbclose    Script Date: 12/27/00 8:58:59 PM ******/

CREATE PROCEDURE 
sbclose
@scrip varchar(10)
 AS
select distinct MARKET,SCRIP_CD,SERIES, Cl_Rate   from closing
where scrip_cd like ltrim( @scrip)+'%'
 order by scrip_cd

GO
