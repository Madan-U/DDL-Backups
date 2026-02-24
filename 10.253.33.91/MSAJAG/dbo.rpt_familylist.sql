-- Object: PROCEDURE dbo.rpt_familylist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_familylist    Script Date: 01/19/2002 12:15:14 ******/

/****** Object:  Stored Procedure dbo.rpt_familylist    Script Date: 01/04/1980 5:06:27 AM ******/




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
