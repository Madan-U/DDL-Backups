-- Object: PROCEDURE dbo.rpt_familylist
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_familylist    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_familylist    Script Date: 11/28/2001 12:23:50 PM ******/




/****** Object:  Stored Procedure dbo.rpt_familylist    Script Date: 2/17/01 5:19:45 PM ******/


/****** Object:  Stored Procedure dbo.rpt_familylist    Script Date: 3/21/01 12:50:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_familylist    Script Date: 20-Mar-01 11:38:55 PM ******/

/* report : traderledger
    file : clienttraderwise.asp
    displays list of party codes of a family */


CREATE PROCEDURE rpt_familylist

@statusname varchar(25)
as


select distinct party_code, c2.cl_code  from account.dbo.ledger , client1 c1, client2 c2
where c1.cl_code=c2.cl_code
and c1.family=@statusname

GO
