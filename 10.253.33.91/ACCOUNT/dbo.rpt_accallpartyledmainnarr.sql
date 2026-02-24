-- Object: PROCEDURE dbo.rpt_accallpartyledmainnarr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accallpartyledmainnarr    Script Date: 01/04/1980 1:40:38 AM ******/



/*report : Allpartyledger
   file : vourchardisp.asp
*/
/*
  shows main narration for a particular entry
*/


CREATE  PROCEDURE rpt_accallpartyledmainnarr

@vtyp smallint,
@vno varchar (12),
@vdt varchar(12),
@booktype varchar(2)
AS
select nar=isnull((select l3.narr from account.dbo.ledger3 l3 
 		where L.VTYP = L3.VTYP AND L.VNO = L3.VNO AND  l3.naratno=0),'')
from account.dbo.ledger l
where vtyp=@vtyp 
and vno=@vno
and vdt like ltrim(@vdt) + '%'
and l.BookType = @booktype

GO
