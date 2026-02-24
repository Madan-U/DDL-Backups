-- Object: PROCEDURE dbo.Rpt_DelAucListAsc
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc Rpt_DelAucListAsc (@StatusId Varchar(15),@StatusName Varchar(25)) As  
if @StatusId = 'broker'   
begin   
select distinct Party_Code from DeliveryClt Where Sett_Type Like 'A%' Order By Party_Code  
end  
if @StatusId = 'branch'   
begin   
select distinct D.Party_Code from DeliveryClt D, client1 c1,client2 c2,  branches br   
Where Sett_Type Like 'A%' And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code  
And Br.short_name = c1.trader and br.branch_cd = @statusname   
Order By D.Party_Code  
end  
if @StatusId = 'subbroker'   
begin   
select distinct D.Party_Code from DeliveryClt D, client1 c1,client2 c2,  subbrokers sb   
Where Sett_Type Like 'A%' And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code  
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname  
Order By D.Party_Code  
end  
if @StatusId = 'trader'   
begin   
select distinct D.Party_Code from DeliveryClt D, client1 c1,client2 c2  
Where Sett_Type Like 'A%' And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code  
And c1.trader = @statusname  
Order By D.Party_Code  
end  
if @StatusId = 'family'   
begin   
select distinct D.Party_Code from DeliveryClt D, client1 c1,client2 c2  
Where Sett_Type Like 'A%' And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code  
And c1.family = @statusname  
Order By D.Party_Code  
end  
if @StatusId = 'client'   
begin   
select distinct D.Party_Code from DeliveryClt D  
Where D.Party_Code = @Statusname  
Order By D.Party_Code  
end  
if @StatusId = 'area'   
begin   
select distinct D.Party_Code from DeliveryClt D, client1 c1,client2 c2  
Where Sett_Type Like 'A%' And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code  
And c1.area = @statusname  
Order By D.Party_Code  
end

GO
