-- Object: PROCEDURE dbo.Report_rpt_NSEDelClientScrips
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------








CREATE Proc Report_rpt_NSEDelClientScrips
@StatusId Varchar(15),@StatusName Varchar(25),
@dematid varchar(2),
@settno varchar(7),
@settype varchar(3),
@partycode varchar(20)
AS
If @statusid = 'broker'
Begin	
Set Transaction Isolation level read uncommitted
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,d.Qty,
/*RecQty = Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)),
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End))*/
RecQty = (Case When D.Sett_Type ='W' Then 
	  (Case When InOut ='I' Then Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)) Else 0 End)
	  Else Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)) End),
GivenQty = (Case When D.Sett_Type ='W' Then 
	  (Case When InOut ='O' Then Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)) Else 0 End)
	  Else Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)) End)
from Client1_Report c1,Client2_Report c2, DeliveryClt_Report d Left Outer Join Deltrans_Report De
On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD
And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series ) 
 where  d.party_code = c2.party_code and c1.cl_code =c2.cl_code
 and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,d.inout,D.Qty
Union All
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,inout='I',Qty=0,
RecQty = Sum((Case When DrCr = 'C' Then IsNull(D.Qty,0) Else 0 End)),
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(D.Qty,0) Else 0 End))
from Client1_Report c1,Client2_Report c2,Deltrans_Report D
where  D.party_code = c2.party_code and c1.cl_code =c2.cl_code
and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode And Filler2 = 1
And d.Party_code Not In ( Select Party_Code From DeliveryClt_Report De Where De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD
And De.Party_Code = D.Party_Code And De.Series = D.Series ) 
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code
Order By d.sett_no,d.sett_type,d.scrip_cd,d.series

end
If @statusid = 'branch'
Begin	
Set Transaction Isolation level read uncommitted
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,d.Qty,
RecQty = Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)),
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End))
from Client1_Report c1,Client2_Report c2 , branches br , DeliveryClt_Report d Left Outer Join Deltrans_Report De
On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD
And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series ) 
 where  d.party_code = c2.party_code and c1.cl_code =c2.cl_code
 and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode
 and br.short_name = c1.trader and br.branch_cd = @statusname
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,d.inout,D.Qty
Union All
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,inout='I',Qty=0,
RecQty = Sum((Case When DrCr = 'C' Then IsNull(D.Qty,0) Else 0 End)),
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(D.Qty,0) Else 0 End))
from Client1_Report c1,Client2_Report c2, branches br ,Deltrans_Report D
where  D.party_code = c2.party_code and c1.cl_code =c2.cl_code
and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode And Filler2 = 1
and br.short_name = c1.trader and br.branch_cd = @statusname
And d.Party_code Not In ( Select Party_Code From DeliveryClt_Report De Where De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD
And De.Party_Code = D.Party_Code And De.Series = D.Series ) 
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code
Order By d.sett_no,d.sett_type,d.scrip_cd,d.series

end
If @statusid = 'subbroker'
Begin	
Set Transaction Isolation level read uncommitted
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,d.Qty,
RecQty = Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)),
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End))
from Client1_Report c1,Client2_Report c2 , subbrokers sb, DeliveryClt_Report d Left Outer Join Deltrans_Report De
On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD
And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series ) 
 where  d.party_code = c2.party_code and c1.cl_code =c2.cl_code
 and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode
 and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,d.inout,D.Qty
Union All
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,inout='I',Qty=0,
RecQty = Sum((Case When DrCr = 'C' Then IsNull(D.Qty,0) Else 0 End)),
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(D.Qty,0) Else 0 End))
from Client1_Report c1,Client2_Report c2, subbrokers sb, Deltrans_Report D
where  D.party_code = c2.party_code and c1.cl_code =c2.cl_code
and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode And Filler2 = 1
 and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
And d.Party_code Not In ( Select Party_Code From DeliveryClt_Report De Where De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD
And De.Party_Code = D.Party_Code And De.Series = D.Series ) 
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code
Order By d.sett_no,d.sett_type,d.scrip_cd,d.series

end
If @statusid = 'trader'
Begin	

Set Transaction Isolation level read uncommitted
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,d.Qty,
RecQty = Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)),
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End))
from Client1_Report c1,Client2_Report c2, DeliveryClt_Report d Left Outer Join Deltrans_Report De
On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD
And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series ) 
 where  d.party_code = c2.party_code and c1.cl_code =c2.cl_code
 and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode
 and c1.trader = @statusname
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,d.inout,D.Qty
Union All
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,inout='I',Qty=0,
RecQty = Sum((Case When DrCr = 'C' Then IsNull(D.Qty,0) Else 0 End)),
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(D.Qty,0) Else 0 End))
from Client1_Report c1,Client2_Report c2, Deltrans_Report D
where  D.party_code = c2.party_code and c1.cl_code =c2.cl_code
and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode And Filler2 = 1
 and c1.trader = @statusname
And d.Party_code Not In ( Select Party_Code From DeliveryClt_Report De Where De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD
And De.Party_Code = D.Party_Code And De.Series = D.Series ) 
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code
Order By d.sett_no,d.sett_type,d.scrip_cd,d.series
end
If @statusid = 'client'
Begin	
Set Transaction Isolation level read uncommitted
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,d.Qty,
RecQty = Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)),
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End))
from Client1_Report c1,Client2_Report c2, DeliveryClt_Report d Left Outer Join Deltrans_Report De
On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD
And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series ) 
 where  d.party_code = c2.party_code and c1.cl_code =c2.cl_code
 and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode
 and c2.party_code = @statusname
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,d.inout,D.Qty
Union All
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,inout='I',Qty=0,
RecQty = Sum((Case When DrCr = 'C' Then IsNull(D.Qty,0) Else 0 End)),
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(D.Qty,0) Else 0 End))
from Client1_Report c1,Client2_Report c2, Deltrans_Report D
where  D.party_code = c2.party_code and c1.cl_code =c2.cl_code
and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode And Filler2 = 1
 and c2.party_code = @statusname
And d.Party_code Not In ( Select Party_Code From DeliveryClt_Report De Where De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD
And De.Party_Code = D.Party_Code And De.Series = D.Series ) 
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code
Order By d.sett_no,d.sett_type,d.scrip_cd,d.series

end
If @statusid = 'family'
Begin	
Set Transaction Isolation level read uncommitted
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,d.Qty,
RecQty = Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)),
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End))
from Client1_Report c1,Client2_Report c2, DeliveryClt_Report d Left Outer Join Deltrans_Report De
On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD
And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series ) 
 where  d.party_code = c2.party_code and c1.cl_code =c2.cl_code
 and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode
 and c1.family = @statusname
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,d.inout,D.Qty
Union All
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,inout='I',Qty=0,
RecQty = Sum((Case When DrCr = 'C' Then IsNull(D.Qty,0) Else 0 End)),
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(D.Qty,0) Else 0 End))
from Client1_Report c1,Client2_Report c2, Deltrans_Report D
where  D.party_code = c2.party_code and c1.cl_code =c2.cl_code
and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode And Filler2 = 1
 and c1.family = @statusname
And d.Party_code Not In ( Select Party_Code From DeliveryClt_Report De Where De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD
And De.Party_Code = D.Party_Code And De.Series = D.Series ) 
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code
Order By d.sett_no,d.sett_type,d.scrip_cd,d.series


end

GO
