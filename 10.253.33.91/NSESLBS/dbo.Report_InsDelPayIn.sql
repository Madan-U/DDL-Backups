-- Object: PROCEDURE dbo.Report_InsDelPayIn
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Report_InsDelPayIn(@StatusId Varchar(25),@StatusName Varchar(25),@Sett_no Varchar(11),@Sett_Type Varchar(11),@FParty_Cd Varchar(10),@TParty_Cd Varchar(10)) As
Select D.Sett_no,D.Sett_Type,D.Party_Code,Long_Name,IsIn=CertNo,Scrip_Cd,Qty=Sum(Qty),
CltDpId = CltDpID,DpId = D.DpID,Isett_No,Isett_Type,
TransDate=Left(Convert(Varchar,TransDate,109),11),Exchg='NSE',
Remark=(Case When TrType = 907 Then 'Inter Settlement From ' + CltDpId
	Else 'RECEIVED' End)
From DelTrans_Report D,
Client2_Report C2 , Client1_Report C1
Where D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type And DrCr = 'C' And Filler2 = 1
And D.Party_Code >= @FParty_Cd And D.Party_Code <= @TParty_Cd AND SHARETYPE <> 'AUCTION'
And C1.Cl_Code = C2.Cl_Code and C2.Party_code = D.Party_Code And 
C1.Branch_Cd  Like (Case When @StatusId = 'branch'    Then @StatusName Else '%' End) And
C1.sub_broker  Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End) And
C1.trader     Like (Case When @StatusId = 'trader'    Then @StatusName Else '%' End) And 
C1.family     Like (Case When @StatusId = 'family'    Then @StatusName Else '%' End) And
C2.Party_Code Like (Case When @StatusId = 'client'    Then @StatusName Else '%' End) 
Group By D.Sett_no,D.Sett_Type,D.Party_Code,Long_Name,CertNo,Scrip_Cd,CltDpId,D.DpID,Isett_No,Isett_Type,
D.Sett_No,TransDate,Delivered,TrType
Union All
select d.sett_no,d.sett_type,d.Party_Code,c1.Long_Name,IsIn=' ',D.Scrip_cd,Qty=D.Qty-Sum((Case When DrCr = 'C' Then isnull(De.qty,0) Else -isnull(De.qty,0) End)),
CltDpId=' ', DpId = ' ', Isett_No=' ',ISett_Type=' ',TransDate=Left(Convert(Varchar,Sec_PayIn,109),11),Exchg='NSE',
Remark='PAYIN SHORTAGE'
from Sett_Mst s,Client2_Report C2,Client1_Report C1,deliveryClt_Report d Left Outer Join DelTrans_Report de 
On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd 
     and de.series = d.series and de.party_code = d.party_code and filler2 = 1 AND SHARETYPE <> 'AUCTION')
where d.inout = 'I' and D.qty > 0 and D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code
and d.sett_no = S.Sett_no and d.sett_type = S.Sett_Type 
And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type 
And D.Party_Code >= @FParty_Cd And D.Party_Code <= @TParty_Cd And
C1.Branch_Cd  Like (Case When @StatusId = 'branch'    Then @StatusName Else '%' End) And
C1.sub_broker  Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End) And
C1.trader     Like (Case When @StatusId = 'trader'    Then @StatusName Else '%' End) And 
C1.family     Like (Case When @StatusId = 'family'    Then @StatusName Else '%' End) And
C2.Party_Code Like (Case When @StatusId = 'client'    Then @StatusName Else '%' End) 
group by d.sett_no,d.sett_type,d.Party_Code,c1.Long_Name,d.scrip_cd,d.series,D.qty,Sec_PayIn
having D.Qty <> Sum((Case When DrCr = 'C' Then isnull(De.qty,0) Else -isnull(De.qty,0) End))
Order By D.Party_Code,Exchg,CertNo,D.Sett_no,D.Sett_Type,Left(Convert(Varchar,TransDate,109),11)

GO
