-- Object: PROCEDURE dbo.Report_rpt_NSEDelClientSettScrip
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE Proc Report_rpt_NSEDelClientSettScrip
@scripcd varchar(20),
@series varchar(3),
@partycode varchar(10)
AS
Set Transaction Isolation level read uncommitted
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,d.Qty,
RecQty = Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)),
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)),
Demat_Date = 'Jan 30 2079'
from Client1_Report c1,Client2_Report c2, DeliveryClt_Report d Left Outer Join Deltrans_Report De
On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD
And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series ) 
 where d.party_code = c2.party_code and c1.cl_code =c2.cl_code
 and d.party_code = @partycode And d.scrip_cd = @scripcd and d.series = @series
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,d.inout,D.Qty
 Order By d.sett_no,d.sett_type,d.scrip_cd,d.series

GO
