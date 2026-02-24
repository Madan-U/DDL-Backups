-- Object: PROCEDURE dbo.LedgerDetailFinalSpP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.LedgerDetailFinalSpP    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.LedgerDetailFinalSpP    Script Date: 11/28/2001 12:23:44 PM ******/

/****** Object:  Stored Procedure dbo.LedgerDetailFinalSpP    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.LedgerDetailFinalSpP    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.LedgerDetailFinalSpP    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.LedgerDetailFinalSpP    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.LedgerDetailFinalSpP    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.LedgerDetailFinalSpP    Script Date: 20-Mar-01 11:43:33 PM ******/

CREATE PROCEDURE LedgerDetailFinalSpP
@cltcode varchar(10),
@startdate varchar(12),
@enddate varchar(12)
 AS
select convert(varchar,l.vdt,103), vtyp, dramt=isnull((case drcr when 'd' then vamt end),0),  
cramt=isnull((case drcr when 'c' then vamt end),0), vno1, nar=isnull((select l3.narr from ledger3 l3 
where l3.refno=left(l.refno,7)), '') from ledger l,vmast where l.cltcode like @cltcode
And vtyp = vtype and l.vdt>=@startdate and  l.vdt<=@enddate
order by l.vdt

GO
