-- Object: PROCEDURE dbo.sbconfopenbal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbconfopenbal    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.sbconfopenbal    Script Date: 11/28/2001 12:23:51 PM ******/

/****** Object:  Stored Procedure dbo.sbconfopenbal    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.sbconfopenbal    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.sbconfopenbal    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.sbconfopenbal    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.sbconfopenbal    Script Date: 2/17/01 3:34:18 PM ******/


/****** Object:  Stored Procedure dbo.sbconfopenbal    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE sbconfopenbal
@clcode varchar(6)
AS
SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) from ledger, 
MSAJAG.DBO.client2 where cltcode in (SELECT DISTINCT PARTY_CODE 
FROM MSAJAG.DBO.CLIENT2 
WHERE CL_CODE=ltrim(@clcode))and cltcode=party_code group by drcr

GO
