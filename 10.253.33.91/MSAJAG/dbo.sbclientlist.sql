-- Object: PROCEDURE dbo.sbclientlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbclientlist    Script Date: 3/17/01 9:56:06 PM ******/

/****** Object:  Stored Procedure dbo.sbclientlist    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sbclientlist    Script Date: 20-Mar-01 11:39:04 PM ******/

/****** Object:  Stored Procedure dbo.sbclientlist    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbclientlist    Script Date: 12/27/00 8:58:59 PM ******/

/* Report : Confirmation
File : Confirmationmain.asp
displays list of all clients of a particular subbroker
*/
CREATE PROCEDURE sbclientlist 
@subbrok varchar(15)
AS
select c2.party_code,s.sub_broker from client1 c1, client2 c2, subbrokers s
where c2.cl_code=c1.cl_code and s.sub_broker=@subbrok and
c1.sub_broker=s.sub_broker
order by c2.party_code

GO
