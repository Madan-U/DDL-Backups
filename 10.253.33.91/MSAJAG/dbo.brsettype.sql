-- Object: PROCEDURE dbo.brsettype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brsettype    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brsettype    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brsettype    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brsettype    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brsettype    Script Date: 12/27/00 8:58:46 PM ******/

CREATE PROCEDURE brsettype
@br varchar(15)
AS
select distinct sett_type from history h, CLIENT1 C1, CLIENT2 C2, BRANCHES B
WHERE B.SHORT_NAME=C1.TRADER AND C1.CL_CODE=C2.CL_CODE AND
h.party_code=c2.party_code and B.BRANCH_CD=@br

GO
