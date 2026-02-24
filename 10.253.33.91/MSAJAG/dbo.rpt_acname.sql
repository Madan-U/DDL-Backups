-- Object: PROCEDURE dbo.rpt_acname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acname    Script Date: 01/19/2002 12:15:12 ******/

/****** Object:  Stored Procedure dbo.rpt_acname    Script Date: 01/04/1980 5:06:25 AM ******/






/****** Object:  Stored Procedure dbo.rpt_acname    Script Date: 09/07/2001 11:09:01 PM ******/

/****** Object:  Stored Procedure dbo.rpt_acname    Script Date: 3/23/01 7:59:30 PM ******/

/****** Object:  Stored Procedure dbo.rpt_acname    Script Date: 08/18/2001 8:24:01 PM ******/


/****** Object:  Stored Procedure dbo.rpt_acname    Script Date: 7/8/01 3:28:35 PM ******/

/****** Object:  Stored Procedure dbo.rpt_acname    Script Date: 2/17/01 5:19:37 PM ******/

/* report : allpartyledger
   file : singlparty.asp
   report : allpartyledger 
   file : cumledger.asp
*/
/* displays name of a client from ledger */

/*changed by mousami on 01/03/2001
 removed hardcoding  for sharedatabase and added hardcoding for account databse)*/
 
CREATE PROCEDURE rpt_acname 
@cltcode varchar(10)
as
/*
select acname from account.dbo.acmast where cltcode=@cltcode  and AcCat <> 4
*/
select acname from account.dbo.ledger where cltcode=@cltcode

GO
