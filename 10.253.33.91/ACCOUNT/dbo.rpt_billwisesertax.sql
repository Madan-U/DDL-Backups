-- Object: PROCEDURE dbo.rpt_billwisesertax
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_billwisesertax    Script Date: 20-Mar-01 11:43:34 PM ******/

/* PRINTING CONTROL > BILL WISE SERVISE TAX */ 
CREATE PROCEDURE 
rpt_billwisesertax
@startdateday varchar(2),
@startdatemon varchar(2),
@enddateday varchar(2),
@enddatemon varchar(2),
@settype varchar(3)
AS
select settno=(substring(l3.narr,8,8)),l.vamt ,
tstart_date =(select start_date
from msajag.dbo.sett_mst
where Sett_No= (substring(l3.narr,8,7)) and sett_type=right(substring(narr,8,8),1)), 
 tend_date = l.VDT , L.CLTCODE 
 from ledger l, ledger3 l3
 where  substring(l.refno, 1, 7) = substring(l3.refno, 1, 7)  and
 cltcode in('99988' ,'99990','61310') and l.vtyp='15'  AND
DATEPART(day,VDT)>=@startdateday And 
 DATEPART(month,VDT) >=@startdatemon And 
DATEPART(day,VDT)<=@enddateday And 
 DATEPART(MONTH,VDT)<=@enddatemon and
(substring(l3.narr,15,1)) = @settype  
 order by tstart_date,VDT

GO
