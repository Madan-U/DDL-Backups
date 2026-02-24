-- Object: PROCEDURE dbo.cumbal1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.cumbal1    Script Date: 01/04/1980 1:40:36 AM ******/



/****** Object:  Stored Procedure dbo.cumbal1    Script Date: 11/28/2001 12:23:42 PM ******/

/****** Object:  Stored Procedure dbo.cumbal1    Script Date: 29-Sep-01 8:12:03 PM ******/

/****** Object:  Stored Procedure dbo.cumbal1    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.cumbal1    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.cumbal1    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.cumbal1    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.cumbal1    Script Date: 20-Mar-01 11:43:33 PM ******/

CREATE PROCEDURE cumbal1
@clcode varchar(6)
AS
SELECT  dramt=isnull((case drcr when 
'd' then SUM(vamt)end),0), cramt=isnull((case drcr when 
'c' then SUM(vamt)end),0) from ledger, MSAJAG.DBO.client2 
where cltcode in (SELECT DISTINCT PARTY_CODE FROM MSAJAG.DBO.CLIENT2 
WHERE CL_CODE=@clcode ) and cltcode=party_code 
group by drcr

GO
