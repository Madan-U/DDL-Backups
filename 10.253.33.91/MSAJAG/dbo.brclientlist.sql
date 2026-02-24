-- Object: PROCEDURE dbo.brclientlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brclientlist    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brclientlist    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brclientlist    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brclientlist    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.brclientlist    Script Date: 12/27/00 8:58:44 PM ******/

/*Report  : Bill
   FILE Billmain.asp
  Displays list of all clients of a branch
*/
CREATE PROCEDURE brclientlist 
@br varchar(3)
as
SELECT C2.PARTY_CODE FROM CLIENT1 C1, CLIENT2 C2, BRANCHES B
WHERE B.SHORT_NAME=C1.TRADER AND C1.CL_CODE=C2.CL_CODE AND
B.BRANCH_CD=@br 
order by c2.party_code

GO
