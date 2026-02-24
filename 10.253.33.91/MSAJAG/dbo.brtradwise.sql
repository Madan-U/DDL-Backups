-- Object: PROCEDURE dbo.brtradwise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brtradwise    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.brtradwise    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brtradwise    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brtradwise    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brtradwise    Script Date: 12/27/00 8:58:46 PM ******/

/* Report : Ledger Report
   File : traderwise
displays clients of particular trader
*/
CREATE PROCEDURE brtradwise
@br varchar(3),
@trader varchar(15)
AS
SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
FROM MSAJAG.DBO.CLIENT1 C1, MSAJAG.DBO.CLIENT2 C2,MSAJAG.DBO.branches b, ledger l 
WHERE C1.TRADER=@trader
AND C1.CL_CODE=C2.CL_CODE 
and b.short_name = c1.trader
and b.branch_cd = @br
and c2.party_code=l.cltcode 
ORDER BY C1.SHORT_NAME

GO
