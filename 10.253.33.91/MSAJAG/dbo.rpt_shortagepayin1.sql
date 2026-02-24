-- Object: PROCEDURE dbo.rpt_shortagepayin1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure rpt_shortagepayin1
@StatusId Varchar(15),@StatusName Varchar(25),
@settno varchar(7),
@tosettno varchar(7),
@settype varchar(3)
as
If @statusid = 'broker'
Begin	
select d.sett_no,d.sett_type,d.Party_Code,Short_Name=c1.Short_Name + ' (' + C1.Branch_Cd + ' )',d.Scrip_cd,d.Series,ToRecive=d.Qty,
 Recieved = isnull(Sum(Case when DrCr = 'C' Then IsNull(De.Qty,0) else -IsNull(De.Qty,0) End),0) 
 from Client2 C2,Client1 C1  ,deliveryClt d Left Outer Join DelTrans de
 On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd 
      and de.series = d.series and de.party_code = d.party_code and filler2 = 1 And ShareType <> 'AUCTION' )
 where d.inout = 'I' and d.qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
 and d.sett_no >= @settno And D.Sett_no <= @ToSettNo And d.sett_type like @settype+'%'
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,d.qty,C1.Branch_Cd
Having d.Qty > isnull(Sum(Case when DrCr = 'C' Then IsNull(De.Qty,0) else -IsNull(De.Qty,0) End),0) 
order by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series
End
If @statusid = 'branch'
Begin	
select d.sett_no,d.sett_type,d.Party_Code,Short_Name=c1.Short_Name + ' (' + C1.Branch_Cd + ' )',d.Scrip_cd,d.Series,ToRecive=d.Qty,
 Recieved = isnull(Sum(Case when DrCr = 'C' Then IsNull(De.Qty,0) else -IsNull(De.Qty,0) End),0) 
 from Client2 C2,Client1 C1, branches br,deliveryClt d Left Outer Join DelTrans de
 On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd 
      and de.series = d.series and de.party_code = d.party_code and filler2 = 1  And ShareType <> 'AUCTION' )
 where d.inout = 'I' and d.qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
 and d.sett_no >= @settno And D.Sett_no <= @ToSettNo And d.sett_type like @settype+'%'
and br.short_name = c1.trader and br.branch_cd = @statusname
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,d.qty,C1.Branch_Cd
Having d.Qty > isnull(Sum(De.qty),0) 
order by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series
End
If @statusid = 'subbroker'
Begin	
select d.sett_no,d.sett_type,d.Party_Code,Short_Name=c1.Short_Name + ' (' + C1.Branch_Cd + ' )',d.Scrip_cd,d.Series,ToRecive=d.Qty,
 Recieved =isnull(Sum(Case when DrCr = 'C' Then IsNull(De.Qty,0) else -IsNull(De.Qty,0) End),0) 
 from Client2 C2,Client1 C1, subbrokers sb,deliveryClt d Left Outer Join DelTrans de
 On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd 
      and de.series = d.series and de.party_code = d.party_code and filler2 = 1 And ShareType <> 'AUCTION' )
 where d.inout = 'I' and d.qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
 and d.sett_no >= @settno And D.Sett_no <= @ToSettNo And d.sett_type like @settype+'%'
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,d.qty,C1.Branch_Cd
Having d.Qty > isnull(Sum(De.qty),0) 
order by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series
End
If @statusid = 'trader'
Begin	
select d.sett_no,d.sett_type,d.Party_Code,Short_Name=c1.Short_Name + ' (' + C1.Branch_Cd + ' )',d.Scrip_cd,d.Series,ToRecive=d.Qty,
 Recieved = isnull(Sum(Case when DrCr = 'C' Then IsNull(De.Qty,0) else -IsNull(De.Qty,0) End),0) 
 from Client2 C2,Client1 C1,deliveryClt d Left Outer Join DelTrans de
 On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd 
      and de.series = d.series and de.party_code = d.party_code And filler2 = 1  And ShareType <> 'AUCTION')
 where d.inout = 'I' and d.qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
 and d.sett_no >= @settno And D.Sett_no <= @ToSettNo And d.sett_type like @settype+'%'
and c1.trader = @statusname
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,d.qty,C1.Branch_Cd
Having d.Qty > isnull(Sum(De.qty),0) 
order by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series
End
If @statusid = 'client'
Begin	
select d.sett_no,d.sett_type,d.Party_Code,Short_Name=c1.Short_Name + ' (' + C1.Branch_Cd + ' )',d.Scrip_cd,d.Series,ToRecive=d.Qty,
 Recieved = isnull(Sum(Case when DrCr = 'C' Then IsNull(De.Qty,0) else -IsNull(De.Qty,0) End),0) 
 from Client2 C2,Client1 C1,deliveryClt d Left Outer Join DelTrans de
 On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd 
      and de.series = d.series and de.party_code = d.party_code and filler2 = 1  And ShareType <> 'AUCTION')
 where d.inout = 'I' and d.qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
 and d.sett_no >= @settno And D.Sett_no <= @ToSettNo And d.sett_type like @settype+'%'
and c2.party_code = @statusname
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,d.qty,C1.Branch_Cd
Having d.Qty > isnull(Sum(De.qty),0) 
order by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series
End
If @statusid = 'family'
Begin	
select d.sett_no,d.sett_type,d.Party_Code,Short_Name=c1.Short_Name + ' (' + C1.Branch_Cd + ' )',d.Scrip_cd,d.Series,ToRecive=d.Qty,
 Recieved = isnull(Sum(Case when DrCr = 'C' Then IsNull(De.Qty,0) else -IsNull(De.Qty,0) End),0) 
 from Client2 C2,Client1 C1,deliveryClt d Left Outer Join DelTrans de
 On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd 
      and de.series = d.series and de.party_code = d.party_code and filler2 = 1 And ShareType <> 'AUCTION' )
 where d.inout = 'I' and d.qty > 0 
 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
 and d.sett_no >= @settno And D.Sett_no <= @ToSettNo And d.sett_type like @settype+'%'
and c1.family = @statusname
 group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,d.qty,C1.Branch_Cd
Having d.Qty > isnull(Sum(De.qty),0) 
order by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series
End

GO
