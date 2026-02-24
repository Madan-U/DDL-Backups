-- Object: PROCEDURE dbo.rpt_fosettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fosettno    Script Date: 5/11/01 6:19:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettno    Script Date: 5/7/2001 9:02:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettno    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettno    Script Date: 5/5/2001 1:24:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettno    Script Date: 4/30/01 5:50:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fosettno    Script Date: 10/26/00 6:04:44 PM ******/




/*Modified by Amolika on 7th feb'2001: Added condition for partycode & sdate*/
CREATE PROCEDURE rpt_fosettno

@settno varchar(7),
@code varchar(10),
@sdate varchar(12)

AS

/*select distinct left(convert(varchar,l.vdt,109),11) as vdt,l3.narr 
from ledger3 l3 ,ledger l
where l.vtyp = l3.vtyp
and l.vno = l3.vno
and narr like '%' + ltrim(@settno)+'%'
*/


select distinct left(convert(varchar,l.vdt,109),11) as vdt,l3.narr 
from ledger3 l3 ,ledger l
where l.vtyp = l3.vtyp
and l.vno = l3.vno
and narr like '%' + ltrim(@settno)+'%'
and cltcode = @code
and left(convert(varchar,vdt,109),11) = @sdate

GO
