-- Object: PROCEDURE dbo.brsettno
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brsettno    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.brsettno    Script Date: 11/28/2001 12:23:41 PM ******/

/****** Object:  Stored Procedure dbo.brsettno    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.brsettno    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.brsettno    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.brsettno    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.brsettno    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.brsettno    Script Date: 20-Mar-01 11:43:32 PM ******/

CREATE PROCEDURE brsettno
@br varchar(3)
AS
select distinct sett_no from history  h,  CLIENT1 C1, CLIENT2 C2, BRANCHES B
WHERE B.SHORT_NAME=C1.TRADER AND h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE AND 
B.BRANCH_CD=@br
group by sett_no 
order by sett_no

GO
