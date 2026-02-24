-- Object: PROCEDURE dbo.rpt_bseallpartyclbal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bseallpartyclbal    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bseallpartyclbal    Script Date: 11/28/2001 12:23:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseallpartyclbal    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseallpartyclbal    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseallpartyclbal    Script Date: 8/7/01 6:03:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseallpartyclbal    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseallpartyclbal    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bseallpartyclbal    Script Date: 20-Mar-01 11:43:34 PM ******/

/* report : allpartyledger
   file : allpartyclbal
*/
/* calculates debit  and credit  totals  of  all accounts of a client code*/
CREATE PROCEDURE rpt_bseallpartyclbal
@acname varchar(35),
@fromdt varchar(10),
@todt varchar(10)
AS
select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
cramt=isnull((case drcr when 'c' then sum(vamt) end),0) 
from ledger l , vmast, bsedb.dbo.client2 c2 , bsedb.dbo.client1 c1 
where l.acname = c1.short_Name and c1.cl_code = c2.cl_code 
and c2.party_code=l.cltcode and l.acname = @acname 
and vtyp=vtype and vdt >= @fromdt and vdt<=@todt + ' 11:59pm'  /* put space before 11:59 */
group by drcr

GO
