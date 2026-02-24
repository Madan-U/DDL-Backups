-- Object: PROCEDURE dbo.rpt_bseclcodedetailledger
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bseclcodedetailledger    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bseclcodedetailledger    Script Date: 11/28/2001 12:23:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclcodedetailledger    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclcodedetailledger    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclcodedetailledger    Script Date: 8/7/01 6:03:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclcodedetailledger    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclcodedetailledger    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bseclcodedetailledger    Script Date: 20-Mar-01 11:43:34 PM ******/

/* report :allpartyledger report
   file : cumledger.asp 
*/
/*displays detail ledger of all parties of a client code*/
CREATE PROCEDURE rpt_bseclcodedetailledger
@clcode varchar(7),
@vdt varchar(10)
AS
SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
from ledger, bsedb.DBO.client2 
where cltcode in (SELECT DISTINCT PARTY_CODE FROM bsedb.DBO.CLIENT2 
WHERE CL_CODE=@clcode)and cltcode=party_code and vdt<=@vdt + ' 11:59pm' /* put blank before 11:59 */
group by drcr

GO
