-- Object: PROCEDURE dbo.Report_Rpt_NSEDelAllScripList
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Report_Rpt_NSEDelAllScripList (  
@StatusId Varchar(15),@StatusName Varchar(25),@Party_Code Varchar(10))  
as   
Set Transaction Isolation level read uncommitted  
If @statusid = 'broker'  
Begin   
select distinct d.scrip_cd,d.series,Qty=0 from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1  
where D.Party_Code = @Party_Code  
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code   
Group by d.scrip_cd,d.series order by d.scrip_cd   
End  
If @statusid = 'branch'  
Begin   
select distinct d.scrip_cd,d.series,Qty=0 from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1, branches br    
where D.Party_Code = @Party_Code  
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code   
and br.short_name = c1.trader and br.branch_cd = @statusname  
Group by d.scrip_cd,d.series order by d.scrip_cd   
End  
If @statusid = 'subbroker'  
Begin   
select distinct d.scrip_cd,d.series,Qty=0 from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1, subbrokers sb  
where D.Party_Code = @Party_Code  
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code   
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname  
Group by d.scrip_cd,d.series order by d.scrip_cd   
End  
If @statusid = 'trader'  
Begin   
select distinct d.scrip_cd,d.series,Qty=0 from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1  
where D.Party_Code = @Party_Code  
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code and c1.trader = @statusname  
Group by d.scrip_cd,d.series order by d.scrip_cd   
End  
If @statusid = 'client'  
Begin   
select distinct d.scrip_cd,d.series,Qty=0 from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1  
where D.Party_Code = @Party_Code  
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code and c2.party_code = @statusname  
Group by d.scrip_cd,d.series order by d.scrip_cd   
End  
If @statusid = 'family'  
Begin   
select distinct d.scrip_cd,d.series,Qty=0 from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1  
where D.Party_Code = @Party_Code  
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code and c1.family = @statusname   
Group by d.scrip_cd,d.series order by d.scrip_cd   
End  
If @statusid = 'area'  
Begin   
select distinct d.scrip_cd,d.series,Qty=0 from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1  
where D.Party_Code = @Party_Code  
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code and c1.area = @statusname   
Group by d.scrip_cd,d.series order by d.scrip_cd   
End  
If @statusid = 'region'  
Begin   
select distinct d.scrip_cd,d.series,Qty=0 from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1  
where D.Party_Code = @Party_Code  
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code and c1.region = @statusname   
Group by d.scrip_cd,d.series order by d.scrip_cd   
End

GO
