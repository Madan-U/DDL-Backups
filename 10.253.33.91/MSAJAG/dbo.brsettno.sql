-- Object: PROCEDURE dbo.brsettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brsettno    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brsettno    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brsettno    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brsettno    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brsettno    Script Date: 12/27/00 8:58:46 PM ******/

/* Report : Bill 
Report Name : Billmain.asp
Displays settlement no from settlement for a branch
*/   
CREATE PROCEDURE brsettno
@br varchar(3)
AS
select distinct sett_no from history  h,  CLIENT1 C1, CLIENT2 C2, BRANCHES B
WHERE B.SHORT_NAME=C1.TRADER AND h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE AND 
B.BRANCH_CD=@br
group by sett_no 
order by sett_no

GO
