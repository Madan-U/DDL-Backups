-- Object: PROCEDURE dbo.rpt_tradernamelist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_tradernamelist    Script Date: 01/19/2002 12:15:16 ******/

/****** Object:  Stored Procedure dbo.rpt_tradernamelist    Script Date: 01/04/1980 5:06:27 AM ******/




/****** Object:  Stored Procedure dbo.rpt_tradernamelist    Script Date: 2/17/01 5:19:55 PM ******/


/****** Object:  Stored Procedure dbo.rpt_tradernamelist    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_tradernamelist    Script Date: 20-Mar-01 11:39:04 PM ******/


/*Modified by amolika on 2nd march'2001 : removed msajag.dbo. & added account.dbo. to all account tables*/
/* report : allpartyledger
   file : namelist.asp
*/
/*shows list of names of clients from ledger corresponding to an alphabet*/
CREATE PROCEDURE rpt_tradernamelist
@statusid varchar(15),
@statusname varchar(25)
AS
SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
FROM  CLIENT1 C1,  CLIENT2 C2, account.dbo.ledger l
WHERE C1.CL_CODE=C2.CL_CODE
and c2.party_code=l.cltcode 
and c1.trader=@statusname
order by c1.short_name

GO
