-- Object: PROCEDURE dbo.rpt_shortagepayout1Scrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure rpt_shortagepayout1Scrip
@StatusId Varchar(15),@StatusName Varchar(25),
@settno varchar(7),
@tosettno varchar(7),
@settype varchar(3)
as
If @statusid = 'broker'
Begin	
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,ToGive=(Case When Inout = 'O' Then D.Qty Else -D.Qty End )+Sum(Case When DrCr = 'C' Then isnull(De.qty,0)Else 0 End),
Given = Sum(Case When DrCr = 'D' Then isnull(De.qty,0)Else 0 End) 
 from Client2 C2,Client1 C1  ,deliveryClt d Left Outer Join DelTrans de
 On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd 
      and de.series = d.series and de.party_code = d.party_code and filler2 = 1  And ShareType <> 'AUCTION' )
 where d.qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
 and d.sett_no >= @Settno And D.Sett_No <= @toSettno and d.sett_type like @settype+'%'
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,d.qty,Inout
having (Case When Inout = 'O' Then D.Qty Else -D.Qty End )+Sum(Case When DrCr = 'C' Then isnull(De.qty,0)Else 0 End)
- Sum(Case When DrCr = 'D' Then isnull(De.qty,0)Else 0 End) > 0 
Union
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,
ToGive=(Case When D.Sett_Type <> 'C' Then Sum(Case When DrCr = 'C' Then isnull(D.qty,0)Else 0 End) Else 0 End),
Given = Sum(Case When DrCr = 'D' Then isnull(D.qty,0)Else 0 End)
from Client2 C2,Client1 C1,DelTrans d
where D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
and d.sett_no >= @settno and d.sett_no <= @tosettno and d.sett_type like @settype 
and Filler2 = 1 And D.Party_Code not in ( Select Party_Code From DeliveryClt Where 
sett_no = d.sett_no and sett_type = d.sett_type and scrip_cd = d.scrip_cd 
and series = d.series and party_code = d.party_code and inout = 'I') And ShareType <> 'AUCTION'
group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series
having (Case When D.Sett_Type <> 'C' Then Sum(Case When DrCr = 'C' Then isnull(D.qty,0)Else 0 End) Else 0 End)
- Sum(Case When DrCr = 'D' Then isnull(D.qty,0)Else 0 End) > 0 
order by d.sett_no,d.sett_type,d.scrip_cd,d.series,d.Party_Code,c1.Short_Name
End
If @statusid = 'branch'
Begin	
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,ToGive=(Case When Inout = 'O' Then D.Qty Else -D.Qty End )+Sum(Case When DrCr = 'C' Then isnull(De.qty,0)Else 0 End),
Given = Sum(Case When DrCr = 'D' Then isnull(De.qty,0)Else 0 End) 
 from Client2 C2,Client1 C1, branches br,deliveryClt d Left Outer Join DelTrans de
 On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd 
      and de.series = d.series and de.party_code = d.party_code and filler2 = 1 And ShareType <> 'AUCTION' )
 where d.qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
 and d.sett_no >= @Settno And D.Sett_No <= @toSettno and d.sett_type like @settype+'%'
and br.short_name = c1.trader and br.branch_cd = @statusname
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,d.qty,Inout
having (Case When Inout = 'O' Then D.Qty Else -D.Qty End )+Sum(Case When DrCr = 'C' Then isnull(De.qty,0)Else 0 End)
- Sum(Case When DrCr = 'D' Then isnull(De.qty,0)Else 0 End) > 0 
Union 
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,
ToGive=(Case When D.Sett_Type <> 'C' Then Sum(Case When DrCr = 'C' Then isnull(D.qty,0)Else 0 End) Else 0 End),
Given = Sum(Case When DrCr = 'D' Then isnull(D.qty,0)Else 0 End)
from Client2 C2,Client1 C1, Branches br,DelTrans d
where D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
and d.sett_no >= @settno and d.sett_no <= @tosettno and d.sett_type like @settype 
and Filler2 = 1 And D.Party_Code not in ( Select Party_Code From DeliveryClt Where 
sett_no = d.sett_no and sett_type = d.sett_type and scrip_cd = d.scrip_cd 
and series = d.series and party_code = d.party_code and inout = 'I')
and br.short_name = c1.trader and br.branch_cd = @statusname  And ShareType <> 'AUCTION'
group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series
having (Case When D.Sett_Type <> 'C' Then Sum(Case When DrCr = 'C' Then isnull(D.qty,0)Else 0 End) Else 0 End)
- Sum(Case When DrCr = 'D' Then isnull(D.qty,0)Else 0 End) > 0 
order by d.sett_no,d.sett_type,d.scrip_cd,d.series,d.Party_Code,c1.Short_Name
End
If @statusid = 'subbroker'
Begin	
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,ToGive=(Case When Inout = 'O' Then D.Qty Else -D.Qty End )+Sum(Case When DrCr = 'C' Then isnull(De.qty,0)Else 0 End),
Given = Sum(Case When DrCr = 'D' Then isnull(De.qty,0)Else 0 End) 
 from Client2 C2,Client1 C1, subbrokers sb,deliveryClt d Left Outer Join DelTrans de
 On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd 
      and de.series = d.series and de.party_code = d.party_code and filler2 = 1 And ShareType <> 'AUCTION' )
 where d.qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
 and d.sett_no >= @Settno And D.Sett_No <= @toSettno and d.sett_type like @settype+'%'
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname 
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,d.qty,Inout
having (Case When Inout = 'O' Then D.Qty Else -D.Qty End )+Sum(Case When DrCr = 'C' Then isnull(De.qty,0)Else 0 End)
- Sum(Case When DrCr = 'D' Then isnull(De.qty,0)Else 0 End) > 0 
Union 
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,
ToGive=(Case When D.Sett_Type <> 'C' Then Sum(Case When DrCr = 'C' Then isnull(D.qty,0)Else 0 End) Else 0 End),
Given = Sum(Case When DrCr = 'D' Then isnull(D.qty,0)Else 0 End)
from Client2 C2,Client1 C1, subbrokers sb,DelTrans d
where D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
and d.sett_no >= @settno and d.sett_no <= @tosettno and d.sett_type like @settype 
and Filler2 = 1 And D.Party_Code not in ( Select Party_Code From DeliveryClt Where 
sett_no = d.sett_no and sett_type = d.sett_type and scrip_cd = d.scrip_cd 
and series = d.series and party_code = d.party_code and inout = 'I')
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname And ShareType <> 'AUCTION'
group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series
having (Case When D.Sett_Type <> 'C' Then Sum(Case When DrCr = 'C' Then isnull(D.qty,0)Else 0 End) Else 0 End)
- Sum(Case When DrCr = 'D' Then isnull(D.qty,0)Else 0 End) > 0 
order by d.sett_no,d.sett_type,d.scrip_cd,d.series,d.Party_Code,c1.Short_Name
End
If @statusid = 'trader'
Begin	
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,ToGive=(Case When Inout = 'O' Then D.Qty Else -D.Qty End )+Sum(Case When DrCr = 'C' Then isnull(De.qty,0)Else 0 End),
Given = Sum(Case When DrCr = 'D' Then isnull(De.qty,0)Else 0 End) 
 from Client2 C2,Client1 C1,deliveryClt d Left Outer Join DelTrans de
 On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd 
      and de.series = d.series and de.party_code = d.party_code and filler2 = 1 And ShareType <> 'AUCTION' )
 where d.qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
 and d.sett_no >= @Settno And D.Sett_No <= @toSettno and d.sett_type like @settype+'%'
and c1.trader = @statusname
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,d.qty,Inout
having (Case When Inout = 'O' Then D.Qty Else -D.Qty End )+Sum(Case When DrCr = 'C' Then isnull(De.qty,0)Else 0 End)
- Sum(Case When DrCr = 'D' Then isnull(De.qty,0)Else 0 End) > 0 
Union 
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,
ToGive=(Case When D.Sett_Type <> 'C' Then Sum(Case When DrCr = 'C' Then isnull(D.qty,0)Else 0 End) Else 0 End),
Given = Sum(Case When DrCr = 'D' Then isnull(D.qty,0)Else 0 End)
from Client2 C2,Client1 C1,DelTrans d
where D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
and d.sett_no >= @settno and d.sett_no <= @tosettno and d.sett_type like @settype
and Filler2 = 1 And D.Party_Code not in ( Select Party_Code From DeliveryClt Where 
sett_no = d.sett_no and sett_type = d.sett_type and scrip_cd = d.scrip_cd 
and series = d.series and party_code = d.party_code and inout = 'I')
and c1.trader = @statusname And ShareType <> 'AUCTION'
group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series
having (Case When D.Sett_Type <> 'C' Then Sum(Case When DrCr = 'C' Then isnull(D.qty,0)Else 0 End) Else 0 End)
- Sum(Case When DrCr = 'D' Then isnull(D.qty,0)Else 0 End) > 0 
order by d.sett_no,d.sett_type,d.scrip_cd,d.series,d.Party_Code,c1.Short_Name
End
If @statusid = 'client'
Begin	
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,ToGive=(Case When Inout = 'O' Then D.Qty Else -D.Qty End )+Sum(Case When DrCr = 'C' Then isnull(De.qty,0)Else 0 End),
Given = Sum(Case When DrCr = 'D' Then isnull(De.qty,0)Else 0 End) 
 from Client2 C2,Client1 C1,deliveryClt d Left Outer Join DelTrans de
 On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd 
      and de.series = d.series and de.party_code = d.party_code and filler2 = 1  And ShareType <> 'AUCTION')
 where d.qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
 and d.sett_no >= @Settno And D.Sett_No <= @toSettno and d.sett_type like @settype+'%'
and c2.party_code = @statusname
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,d.qty,Inout
having (Case When Inout = 'O' Then D.Qty Else -D.Qty End )+Sum(Case When DrCr = 'C' Then isnull(De.qty,0)Else 0 End)
- Sum(Case When DrCr = 'D' Then isnull(De.qty,0)Else 0 End) > 0 
Union 
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,
ToGive=(Case When D.Sett_Type <> 'C' Then Sum(Case When DrCr = 'C' Then isnull(D.qty,0)Else 0 End) Else 0 End),
Given = Sum(Case When DrCr = 'D' Then isnull(D.qty,0)Else 0 End)
from Client2 C2,Client1 C1,DelTrans d
where D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
and d.sett_no >= @settno and d.sett_no <= @tosettno and d.sett_type like @settype 
and Filler2 = 1 And D.Party_Code not in ( Select Party_Code From DeliveryClt Where 
sett_no = d.sett_no and sett_type = d.sett_type and scrip_cd = d.scrip_cd 
and series = d.series and party_code = d.party_code and inout = 'I')
and c2.party_code = @statusname And ShareType <> 'AUCTION'
group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series
having (Case When D.Sett_Type <> 'C' Then Sum(Case When DrCr = 'C' Then isnull(D.qty,0)Else 0 End) Else 0 End)
- Sum(Case When DrCr = 'D' Then isnull(D.qty,0)Else 0 End) > 0 
order by d.sett_no,d.sett_type,d.scrip_cd,d.series,d.Party_Code,c1.Short_Name
End
If @statusid = 'family'
Begin	
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,ToGive=(Case When Inout = 'O' Then D.Qty Else -D.Qty End )+Sum(Case When DrCr = 'C' Then isnull(De.qty,0)Else 0 End),
Given = Sum(Case When DrCr = 'D' Then isnull(De.qty,0)Else 0 End) 
 from Client2 C2,Client1 C1,deliveryClt d Left Outer Join DelTrans de
 On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd 
      and de.series = d.series and de.party_code = d.party_code and filler2 = 1 And ShareType <> 'AUCTION' )
 where d.qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
 and d.sett_no >= @Settno And D.Sett_No <= @toSettno and d.sett_type like @settype+'%'
and c1.family = @statusname
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,d.qty,Inout
having (Case When Inout = 'O' Then D.Qty Else -D.Qty End )+Sum(Case When DrCr = 'C' Then isnull(De.qty,0)Else 0 End)
- Sum(Case When DrCr = 'D' Then isnull(De.qty,0)Else 0 End) > 0 
Union 
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,
ToGive=(Case When D.Sett_Type <> 'C' Then Sum(Case When DrCr = 'C' Then isnull(D.qty,0)Else 0 End) Else 0 End),
Given = Sum(Case When DrCr = 'D' Then isnull(D.qty,0)Else 0 End)
from Client2 C2,Client1 C1,DelTrans d
where D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
and d.sett_no >= @settno and d.sett_no <= @tosettno and d.sett_type like @settype 
and Filler2 = 1 And D.Party_Code not in ( Select Party_Code From DeliveryClt Where 
sett_no = d.sett_no and sett_type = d.sett_type and scrip_cd = d.scrip_cd 
and series = d.series and party_code = d.party_code and inout = 'I')
and c1.family = @statusname And ShareType <> 'AUCTION'
group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series
having (Case When D.Sett_Type <> 'C' Then Sum(Case When DrCr = 'C' Then isnull(D.qty,0)Else 0 End) Else 0 End)
- Sum(Case When DrCr = 'D' Then isnull(D.qty,0)Else 0 End) > 0 
order by d.sett_no,d.sett_type,d.scrip_cd,d.series,d.Party_Code,c1.Short_Name
End

GO
