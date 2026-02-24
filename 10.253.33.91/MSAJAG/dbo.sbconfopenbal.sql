-- Object: PROCEDURE dbo.sbconfopenbal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbconfopenbal    Script Date: 3/17/01 9:56:06 PM ******/

/****** Object:  Stored Procedure dbo.sbconfopenbal    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sbconfopenbal    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbconfopenbal    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbconfopenbal    Script Date: 12/27/00 8:58:59 PM ******/

CREATE PROCEDURE sbconfopenbal
@clcode varchar(6)
AS
SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) from ledger, 
MSAJAG.DBO.client2 where cltcode in (SELECT DISTINCT PARTY_CODE 
FROM MSAJAG.DBO.CLIENT2 
WHERE CL_CODE=ltrim(@clcode))and cltcode=party_code group by drcr

GO
