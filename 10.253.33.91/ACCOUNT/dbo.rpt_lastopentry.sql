-- Object: PROCEDURE dbo.rpt_lastopentry
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_lastopentry    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_lastopentry    Script Date: 11/28/2001 12:23:50 PM ******/



/*
This query is used if opening entry for current yr is not found
this query gives us the latest opeing entry date
*/
CREATE procedure rpt_lastopentry
@sdtcur datetime
as
select   isnull(left((convert(varchar,max(vdt),109)),11),'') from account.dbo.ledger where vtyp='18' and
vdt < @sdtcur

GO
