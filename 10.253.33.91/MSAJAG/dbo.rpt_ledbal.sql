-- Object: PROCEDURE dbo.rpt_ledbal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_ledbal    Script Date: 01/19/2002 12:15:15 ******/

/****** Object:  Stored Procedure dbo.rpt_ledbal    Script Date: 01/04/1980 5:06:27 AM ******/






/****** Object:  Stored Procedure dbo.rpt_ledbal    Script Date: 09/07/2001 11:09:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ledbal    Script Date: 3/23/01 7:59:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ledbal    Script Date: 08/18/2001 8:24:20 PM ******/


/****** Object:  Stored Procedure dbo.rpt_ledbal    Script Date: 7/8/01 3:28:44 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ledbal    Script Date: 2/17/01 5:19:50 PM ******/


/****** Object:  Stored Procedure dbo.rpt_ledbal    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ledbal    Script Date: 20-Mar-01 11:38:59 PM ******/

/*
Modified by neelambari on 1 mar 2001
removed hardcoding for share database and added hardcoding for account database for all the queries below
*/

/* report : cheques
    file: todayscheques.asp
*/
/* displays ledger balance of a client till a particular date */
CREATE PROCEDURE rpt_ledbal
@vdt smalldatetime,
@partycode varchar(10)
 AS
select l.cltcode,amount=isnull(((select sum(l1.vamt) from account.dbo.ledger l1 where l1.drcr='d' and l.cltcode=l1.cltcode 
and l1.vdt <= @vdt + ' 23:59:59' 
group by l1.cltcode ,l1.drcr ) -
(select sum(l1.vamt) from account.dbo.ledger l1 where l1.drcr='c' and l.cltcode=l1.cltcode and l1.vdt <= @vdt + ' 23:59:59'
 group by l1.cltcode, l1.drcr)),0) from account.dbo.ledger l where l.vdt <= @vdt + ' 23:59:59'  /* put spaces before 23:59:59 */
and l.cltcode=@partycode
group by l.cltcode

GO
