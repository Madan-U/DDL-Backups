-- Object: PROCEDURE dbo.Rpt_NseDelPartyListDesc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc Rpt_NseDelPartyListDesc (@StatusId Varchar(15),@StatusName Varchar(25))
As 
if @statusid = 'broker'
begin
select Distinct PARTY_CODE from DelTrans Where Filler2 = 1  order by PARTY_CODE Desc
End
if @statusid = 'branch'
begin
select Distinct D.PARTY_CODE from DelTrans D, Client1 C1, Client2 C2, branches br 
Where C1.Cl_Code = C2.Cl_Code and C2.Party_Code = D.Party_Code
and br.short_name = c1.trader and br.branch_cd = @statusname
And Filler2 = 1  
order by D.PARTY_CODE Desc
End
if @statusid = 'subbroker'
begin
select Distinct D.PARTY_CODE from DelTrans D, Client1 C1, Client2 C2, subbrokers sb 
Where C1.Cl_Code = C2.Cl_Code and C2.Party_Code = D.Party_Code
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
And Filler2 = 1  
order by D.PARTY_CODE Desc
End
if @statusid = 'trader'
begin
select Distinct D.PARTY_CODE from DelTrans D, Client1 C1, Client2 C2 
Where C1.Cl_Code = C2.Cl_Code and C2.Party_Code = D.Party_Code
and c1.trader = @statusname And Filler2 = 1  
order by D.PARTY_CODE Desc
End
if @statusid = 'client'
begin
select Distinct D.PARTY_CODE from DelTrans D, Client1 C1, Client2 C2 
Where C1.Cl_Code = C2.Cl_Code and C2.Party_Code = D.Party_Code
and c2.party_code = @statusname And Filler2 = 1  
order by D.PARTY_CODE Desc
End
if @statusid = 'family'
begin
select Distinct D.PARTY_CODE from DelTrans D, Client1 C1, Client2 C2 
Where C1.Cl_Code = C2.Cl_Code and C2.Party_Code = D.Party_Code
and c1.family = @statusname And Filler2 = 1  
order by D.PARTY_CODE Desc
End

GO
