-- Object: PROCEDURE dbo.sbnamelist
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbnamelist    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.sbnamelist    Script Date: 11/28/2001 12:23:52 PM ******/

/****** Object:  Stored Procedure dbo.sbnamelist    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.sbnamelist    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.sbnamelist    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.sbnamelist    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.sbnamelist    Script Date: 2/17/01 3:34:18 PM ******/


/****** Object:  Stored Procedure dbo.sbnamelist    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE sbnamelist
@alpha varchar(21),
@subbroker varchar(15)
 AS
SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
FROM MSAJAG.DBO.CLIENT1 C1, MSAJAG.DBO.CLIENT2 C2, ledger l ,MSAJAG.DBO.subbrokers sb
WHERE c1.short_name like ltrim(@alpha)+'%' and C1.CL_CODE=C2.CL_CODE 
and c2.party_code=l.cltcode and sb.sub_broker=c1.sub_broker and sb.sub_broker=@subbroker
order by c1.short_name

GO
