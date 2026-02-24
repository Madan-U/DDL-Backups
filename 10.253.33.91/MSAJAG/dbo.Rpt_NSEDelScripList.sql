-- Object: PROCEDURE dbo.Rpt_NSEDelScripList
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc Rpt_NSEDelScripList (
@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@Scrip_Cd Varchar(12),@Series Varchar(3))
as 
If @statusid = 'broker'
Begin	
select distinct d.scrip_cd,d.series,Qty=Sum(Case When Inout = 'I' Then d.qty Else -D.Qty End) from DeliveryClt D, Client2 C2, Client1 C1
where d.sett_no like @settno and d.sett_type like @Sett_Type and d.scrip_cd like @Scrip_Cd and d.series like @Series
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code 
Group by d.scrip_cd,d.series order by d.scrip_cd 
End
If @statusid = 'branch'
Begin	
select distinct d.scrip_cd,d.series,Qty=Sum(Case When Inout = 'I' Then d.qty Else -D.Qty End) from DeliveryClt D, Client2 C2, Client1 C1, branches br  
where d.sett_no like @settno and d.sett_type like @Sett_Type and d.scrip_cd like @Scrip_Cd and d.series like @Series
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code 
and br.short_name = c1.trader and br.branch_cd = @statusname
Group by d.scrip_cd,d.series order by d.scrip_cd 
End
If @statusid = 'subbroker'
Begin	
select distinct d.scrip_cd,d.series,Qty=Sum(Case When Inout = 'I' Then d.qty Else -D.Qty End) from DeliveryClt D, Client2 C2, Client1 C1, subbrokers sb
where d.sett_no like @settno and d.sett_type like @Sett_Type and d.scrip_cd like @Scrip_Cd and d.series like @Series
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code 
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
Group by d.scrip_cd,d.series order by d.scrip_cd 
End
If @statusid = 'trader'
Begin	
select distinct d.scrip_cd,d.series,Qty=Sum(Case When Inout = 'I' Then d.qty Else -D.Qty End) from DeliveryClt D, Client2 C2, Client1 C1
where d.sett_no = @settno and d.sett_type= @Sett_Type and d.scrip_cd like @Scrip_Cd and d.series like @Series
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code and c1.trader = @statusname
Group by d.scrip_cd,d.series order by d.scrip_cd 
End
If @statusid = 'client'
Begin	
select distinct d.scrip_cd,d.series,Qty=Sum(Case When Inout = 'I' Then d.qty Else -D.Qty End) from DeliveryClt D, Client2 C2, Client1 C1
where d.sett_no = @settno and d.sett_type= @Sett_Type and d.scrip_cd like @Scrip_Cd and d.series like @Series
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code and c2.party_code = @statusname
Group by d.scrip_cd,d.series order by d.scrip_cd 
End
If @statusid = 'family'
Begin	
select distinct d.scrip_cd,d.series,Qty=Sum(Case When Inout = 'I' Then d.qty Else -D.Qty End) from DeliveryClt D, Client2 C2, Client1 C1
where d.sett_no = @settno and d.sett_type= @Sett_Type and d.scrip_cd like @Scrip_Cd and d.series like @Series
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code and c1.family = @statusname 
Group by d.scrip_cd,d.series order by d.scrip_cd 
End

GO
