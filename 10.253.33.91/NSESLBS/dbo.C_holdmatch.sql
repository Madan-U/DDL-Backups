-- Object: PROCEDURE dbo.C_holdmatch
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc C_holdmatch 
( @cltdpid Varchar(16),
  @dpid Varchar(8) )
As
Select D.isin,d.scrip_cd,qty=sum(case When Drcr = 'c' Then Qty Else -qty End),
Freeqty=sum(case When Drcr = 'c' Then Qty Else -qty End),
Pledgeqty=0,holdqty=isnull(currbal,0),
Holdfreeqty=isnull(freebal,0),holdpledgeqty=isnull(pledgebal,0),
Todayqty=0
From C_securitiesmst D Left Outer Join Delcdslbalance A 
On ( A.isin = D.isin And B_dp_acc_code = A.cltdpid And B_bankdpid = A.dpid) 
Where D.party_code <> 'broker' And Active = 1 
And B_dp_acc_code = @cltdpid And B_bankdpid = @dpid
Group By D.isin, D.scrip_cd, B_bankdpid, B_dp_acc_code, Currbal, Freebal, Pledgebal
Having Sum(case When Drcr = 'c' Then Qty Else -qty End) <> 0 
Union All
Select Isin=a.isin,scrip_cd,qty=0,freeqty=0,pledgeqty=0,holdqty=isnull(currbal,0),
Holdfreeqty=isnull(freebal,0),holdpledgeqty=isnull(pledgebal,0),todayqty=0 
From Delcdslbalance A Where Cltdpid = @cltdpid
And Dpid = @dpid And 
A.isin Not In ( Select Distinct Isin From C_securitiesmst D Where B_dp_acc_code = A.cltdpid And 
B_bankdpid = A.dpid And A.isin = D.isin 
And D.party_code <> 'broker' And Active = 1 
Group By Isin, Scrip_cd, Currbal, Freebal, Pledgebal
Having Sum(case When Drcr = 'c' Then Qty Else -qty End) <> 0) 
Order By 2

GO
