-- Object: PROCEDURE dbo.brallname
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brallname    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.brallname    Script Date: 11/28/2001 12:23:41 PM ******/

/****** Object:  Stored Procedure dbo.brallname    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.brallname    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.brallname    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.brallname    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.brallname    Script Date: 2/17/01 3:34:13 PM ******/


/****** Object:  Stored Procedure dbo.brallname    Script Date: 20-Mar-01 11:43:32 PM ******/

CREATE PROCEDURE brallname
@br varchar(3),
@short_name varchar(21)
AS
SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
FROM MSAJAG.DBO.CLIENT1 C1, MSAJAG.DBO.CLIENT2 C2,MSAJAG.DBO.branches b, ledger l 
WHERE c1.short_name like @short_name+'%' 
and C1.CL_CODE=C2.CL_CODE 
and c2.party_code=l.cltcode 
and b.short_name = c1.trader
and b.branch_cd = @br
order by c1.short_name

GO
