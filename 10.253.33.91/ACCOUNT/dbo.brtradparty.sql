-- Object: PROCEDURE dbo.brtradparty
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brtradparty    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.brtradparty    Script Date: 11/28/2001 12:23:41 PM ******/

/****** Object:  Stored Procedure dbo.brtradparty    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.brtradparty    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.brtradparty    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.brtradparty    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.brtradparty    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.brtradparty    Script Date: 20-Mar-01 11:43:32 PM ******/

CREATE PROCEDURE brtradparty
@br varchar(3),
@trader varchar(15)
AS
SELECT DISTINCT C1.CL_CODE, C2.PARTY_CODE 
FROM MSAJAG.DBO.CLIENT1 C1, MSAJAG.DBO.CLIENT2 C2, MSAJAG.DBO.branches b, ledger l 
WHERE C1.TRADER=@trader
AND C1.CL_CODE=C2.CL_CODE 
and b.short_name = c1.trader
and b.branch_cd = @br
and c2.party_code=l.cltcode 
ORDER BY C2.party_code

GO
