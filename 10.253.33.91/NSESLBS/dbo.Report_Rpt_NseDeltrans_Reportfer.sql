-- Object: PROCEDURE dbo.Report_Rpt_NseDeltrans_Reportfer
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------







Create Proc Report_Rpt_NseDeltrans_Reportfer 
(@StatusId Varchar(15),@StatusName Varchar(25),
 @FromParty Varchar(10),@ToParty Varchar(10),
 @FromScrip Varchar(12),@ToScrip Varchar(12)
)
As 
if @statusid = 'broker'
begin
Select Sett_no,Sett_Type,D.Party_Code,C1.Long_Name,Scrip_cd,Series,Qty=Sum(Qty),DpId,CltDpId,
TransDate=Left(Convert(Varchar,TransDate,109),11),BdpId,BCltDpId,TrType,ISett_No,ISett_Type 
From Deltrans_Report D, Client1_Report C1, Client2_Report C2 Where Delivered = 'D' And Filler2 = 1 And DrCr = 'D' 
And C2.Party_Code = D.Party_Code And C1.Cl_Code = C2.Cl_Code 
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty
And D.Scrip_CD >= @FromScrip And D.Scrip_Cd <= @ToScrip 
Group By D.Party_Code,C1.Long_Name,Scrip_cd,Series,Sett_no,Sett_Type,DpId,
CltDpId,Left(Convert(Varchar,TransDate,109),11),BdpId,BCltDpId,TrType,ISett_No,ISett_Type 
Order By D.Party_Code,C1.Long_Name,Scrip_cd,Series,Sett_no,Sett_Type 
End
if @statusid = 'branch'
begin
Select Sett_no,Sett_Type,D.Party_Code,C1.Long_Name,Scrip_cd,Series,Qty=Sum(Qty),DpId,CltDpId,
TransDate=Left(Convert(Varchar,TransDate,109),11),BdpId,BCltDpId,TrType,ISett_No,ISett_Type 
From Deltrans_Report D, Client1_Report C1, Client2_Report C2, branches br Where Delivered = 'D' And Filler2 = 1 And DrCr = 'D' 
And C2.Party_Code = D.Party_Code And C1.Cl_Code = C2.Cl_Code 
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty
And D.Scrip_CD >= @FromScrip And D.Scrip_Cd <= @ToScrip 
and br.short_name = c1.trader and br.branch_cd = @statusname
Group By D.Party_Code,C1.Long_Name,Scrip_cd,Series,Sett_no,Sett_Type,DpId,
CltDpId,Left(Convert(Varchar,TransDate,109),11),BdpId,BCltDpId,TrType,ISett_No,ISett_Type 
Order By D.Party_Code,C1.Long_Name,Scrip_cd,Series,Sett_no,Sett_Type 
End
if @statusid = 'subbroker'
begin
Select Sett_no,Sett_Type,D.Party_Code,C1.Long_Name,Scrip_cd,Series,Qty=Sum(Qty),DpId,CltDpId,
TransDate=Left(Convert(Varchar,TransDate,109),11),BdpId,BCltDpId,TrType,ISett_No,ISett_Type 
From Deltrans_Report D, Client1_Report C1, Client2_Report C2, subbrokers sb Where Delivered = 'D' And Filler2 = 1 And DrCr = 'D' 
And C2.Party_Code = D.Party_Code And C1.Cl_Code = C2.Cl_Code 
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty
And D.Scrip_CD >= @FromScrip And D.Scrip_Cd <= @ToScrip 
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
Group By D.Party_Code,C1.Long_Name,Scrip_cd,Series,Sett_no,Sett_Type,DpId,
CltDpId,Left(Convert(Varchar,TransDate,109),11),BdpId,BCltDpId,TrType,ISett_No,ISett_Type 
Order By D.Party_Code,C1.Long_Name,Scrip_cd,Series,Sett_no,Sett_Type 
End
if @statusid = 'trader'
begin
Select Sett_no,Sett_Type,D.Party_Code,C1.Long_Name,Scrip_cd,Series,Qty=Sum(Qty),DpId,CltDpId,
TransDate=Left(Convert(Varchar,TransDate,109),11),BdpId,BCltDpId,TrType,ISett_No,ISett_Type 
From Deltrans_Report D, Client1_Report C1, Client2_Report C2 Where Delivered = 'D' And Filler2 = 1 And DrCr = 'D' 
And C2.Party_Code = D.Party_Code And C1.Cl_Code = C2.Cl_Code 
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty
And D.Scrip_CD >= @FromScrip And D.Scrip_Cd <= @ToScrip 
and c1.trader = @statusname
Group By D.Party_Code,C1.Long_Name,Scrip_cd,Series,Sett_no,Sett_Type,DpId,
CltDpId,Left(Convert(Varchar,TransDate,109),11),BdpId,BCltDpId,TrType,ISett_No,ISett_Type 
Order By D.Party_Code,C1.Long_Name,Scrip_cd,Series,Sett_no,Sett_Type 
End
if @statusid = 'family'
begin
Select Sett_no,Sett_Type,D.Party_Code,C1.Long_Name,Scrip_cd,Series,Qty=Sum(Qty),DpId,CltDpId,
TransDate=Left(Convert(Varchar,TransDate,109),11),BdpId,BCltDpId,TrType,ISett_No,ISett_Type 
From Deltrans_Report D, Client1_Report C1, Client2_Report C2 Where Delivered = 'D' And Filler2 = 1 And DrCr = 'D' 
And C2.Party_Code = D.Party_Code And C1.Cl_Code = C2.Cl_Code 
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty
And D.Scrip_CD >= @FromScrip And D.Scrip_Cd <= @ToScrip 
and c1.family = @statusname
Group By D.Party_Code,C1.Long_Name,Scrip_cd,Series,Sett_no,Sett_Type,DpId,
CltDpId,Left(Convert(Varchar,TransDate,109),11),BdpId,BCltDpId,TrType,ISett_No,ISett_Type 
Order By D.Party_Code,C1.Long_Name,Scrip_cd,Series,Sett_no,Sett_Type 
End
if @statusid = 'client'
begin
Select Sett_no,Sett_Type,D.Party_Code,C1.Long_Name,Scrip_cd,Series,Qty=Sum(Qty),DpId,CltDpId,
TransDate=Left(Convert(Varchar,TransDate,109),11),BdpId,BCltDpId,TrType,ISett_No,ISett_Type 
From Deltrans_Report D, Client1_Report C1, Client2_Report C2 Where Delivered = 'D' And Filler2 = 1 And DrCr = 'D' 
And C2.Party_Code = D.Party_Code And C1.Cl_Code = C2.Cl_Code 
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty
And D.Scrip_CD >= @FromScrip And D.Scrip_Cd <= @ToScrip 
and c2.Party_Code = @statusname
Group By D.Party_Code,C1.Long_Name,Scrip_cd,Series,Sett_no,Sett_Type,DpId,
CltDpId,Left(Convert(Varchar,TransDate,109),11),BdpId,BCltDpId,TrType,ISett_No,ISett_Type 
Order By D.Party_Code,C1.Long_Name,Scrip_cd,Series,Sett_no,Sett_Type 
End

GO
