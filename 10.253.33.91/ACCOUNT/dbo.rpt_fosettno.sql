-- Object: PROCEDURE dbo.rpt_fosettno
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fosettno    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_fosettno    Script Date: 11/28/2001 12:23:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettno    Script Date: 29-Sep-01 8:12:07 PM ******/


/****** Object:  Stored Procedure dbo.rpt_fosettno    Script Date: 9/7/2001 6:05:58 PM ******/
CREATE PROCEDURE rpt_fosettno

/*@settno varchar(7),*/
@code varchar(10),
@sdate varchar(12),
@tdate varchar(12)
AS

/*select distinct left(convert(varchar,l.vdt,109),11) as vdt,l3.narr 
from ledger3 l3 ,ledger l
where l.vtyp = l3.vtyp
and l.vno = l3.vno
and narr like '%' + ltrim(@settno)+'%'
*/


/*select distinct left(convert(varchar,l.vdt,109),11) as vdt,l3.narr 
from ledger3 l3 ,ledger l
where l.vtyp = l3.vtyp
and l.vno = l3.vno
and narr like '%' + ltrim(@settno)+'%'
and cltcode = @code
and left(convert(varchar,vdt,109),11) = @sdate
*/

select distinct convert(varchar,l.vdt,106) as vdt,l3.narr 
from ledger3 l3 ,ledger l
where l.vtyp = l3.vtyp
and l.vno = l3.vno
and narr like '%NSEFO%'
and l3.vtyp = 15
and cltcode = @code
and convert(varchar,vdt,106) >= @sdate
and convert(varchar,vdt,106) <= @tdate

GO
