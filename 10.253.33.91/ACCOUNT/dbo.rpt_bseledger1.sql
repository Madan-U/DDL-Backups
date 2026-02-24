-- Object: PROCEDURE dbo.rpt_bseledger1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bseledger1    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bseledger1    Script Date: 11/28/2001 12:23:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger1    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger1    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger1    Script Date: 8/7/01 6:03:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger1    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger1    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bseledger1    Script Date: 20-Mar-01 11:43:34 PM ******/

/* Report : Confirmation Report
   File : Tconfirmationreport.asp
   Displays the dramt, cramt for a particular client
*/
CREATE PROCEDURE rpt_bseledger1
@clcode varchar(6)
AS
SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0),
cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) from ledger,
MSAJAG.DBO.client2 where cltcode in (SELECT DISTINCT PARTY_CODE 
FROM MSAJAG.DBO.CLIENT2 
WHERE CL_CODE=@clcode)and cltcode=party_code group by drcr

GO
