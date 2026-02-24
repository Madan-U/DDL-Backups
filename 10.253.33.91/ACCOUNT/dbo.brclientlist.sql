-- Object: PROCEDURE dbo.brclientlist
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brclientlist    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.brclientlist    Script Date: 11/28/2001 12:23:41 PM ******/

/****** Object:  Stored Procedure dbo.brclientlist    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.brclientlist    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.brclientlist    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.brclientlist    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.brclientlist    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.brclientlist    Script Date: 20-Mar-01 11:43:32 PM ******/

CREATE PROCEDURE brclientlist
@br varchar(3)
as
SELECT distinct l.cltcode FROM MSAJAG.DBO.CLIENT1 C1, MSAJAG.DBO.CLIENT2 C2, MSAJAG.DBO.BRANCHES B, ledger l
WHERE B.SHORT_NAME=C1.TRADER AND C1.CL_CODE=C2.CL_CODE AND
B.BRANCH_CD=@br and l.cltcode=c2.party_code
order by l.cltcode

GO
