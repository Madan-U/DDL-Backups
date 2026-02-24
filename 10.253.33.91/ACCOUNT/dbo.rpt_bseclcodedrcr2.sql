-- Object: PROCEDURE dbo.rpt_bseclcodedrcr2
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bseclcodedrcr2    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bseclcodedrcr2    Script Date: 11/28/2001 12:23:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclcodedrcr2    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclcodedrcr2    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclcodedrcr2    Script Date: 8/7/01 6:03:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclcodedrcr2    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclcodedrcr2    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bseclcodedrcr2    Script Date: 20-Mar-01 11:43:34 PM ******/

/* report :allpartyledger report
   file : allparty.asp 
*/
/*displays debit and credit of  totals of all accounts of a client code*/
CREATE PROCEDURE rpt_bseclcodedrcr2
@acname varchar(35),
@vdt varchar(10)
AS
select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
cramt=isnull((case drcr when 'c' then sum(vamt) end),0)
from ledger l, bsedb.dbo.client2 c2, bsedb.dbo.client1 c1 
where l.acname = c1.short_Name and c2.party_code=l.cltcode
and l.acname =@acname and vdt < @vdt
group by drcr

GO
