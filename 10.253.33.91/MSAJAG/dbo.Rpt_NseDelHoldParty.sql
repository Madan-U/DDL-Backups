-- Object: PROCEDURE dbo.Rpt_NseDelHoldParty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc Rpt_NseDelHoldParty (
@StatusId Varchar(15),@StatusName Varchar(25),@FromParty varchar(10),
@ToParty varchar(10),@FromScrip Varchar(12),@ToScrip Varchar(12),@BDpID Varchar(8),@BCltDpID Varchar(16))
AS
if @BDpID = '' 
Select @BDpID = '%'
if @BCltDpID = '' 
Select @BCltDpID = '%'
if @statusid = 'broker'
begin
select scrip_cd, series ,D.Party_Code,Sett_No, Sett_type, QTy=Sum(Qty),CertNo,BDpId,BCltDpId,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End),
Party_Name = C1.Long_Name 
from DELTRANS D, Client1 C1, Client2 C2 
where BDpId Like @BDpId and BCltDpId Like @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1  And Delivered = '0'
And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not like 'Auction'
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code
group by scrip_cd,CertNo, series, D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0 
Order By D.Party_Code,Scrip_CD,Series,Sett_No, Sett_type
End
if @statusid = 'branch'
begin
select scrip_cd, series ,D.Party_Code,Sett_No, Sett_type, QTy=Sum(Qty),CertNo ,BDpId,BCltDpId,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End),
Party_Name = C1.Long_Name 
from DELTRANS D, Client2 C2, Client1 C1, branches br  
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And
BDpId Like @BDpId and BCltDpId Like @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1 And Delivered = '0'
and br.short_name = c1.trader and br.branch_cd = @statusname
And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not like 'Auction'
group by scrip_cd,CertNo, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0 
Order By D.Party_Code,Scrip_CD,Series,Sett_No, Sett_type
End
if @statusid = 'subbroker'
begin
select scrip_cd, series ,D.Party_Code,Sett_No, Sett_type, QTy=Sum(Qty),CertNo ,BDpId,BCltDpId,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End),
Party_Name = C1.Long_Name 
from DELTRANS D, Client2 C2, Client1 C1, subbrokers sb 
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And
BDpId Like @BDpId and BCltDpId Like @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1 And Delivered = '0'
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not like 'Auction'
group by scrip_cd,CertNo, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0 
Order By D.Party_Code,Scrip_CD,Series,Sett_No, Sett_type
End
if @statusid = 'trader'
begin
select scrip_cd, series ,D.Party_Code,Sett_No, Sett_type, QTy=Sum(Qty),CertNo ,BDpId,BCltDpId,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End),
Party_Name = C1.Long_Name 
from DELTRANS D, Client2 C2, Client1 C1
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And
BDpId Like @BDpId and BCltDpId Like @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1 And Delivered = '0'
and c1.trader = @statusname
And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not like 'Auction'
group by scrip_cd,CertNo, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0 
Order By D.Party_Code,Scrip_CD,Series,Sett_No, Sett_type
End
if @statusid = 'client'
begin
select scrip_cd, series ,D.Party_Code,Sett_No, Sett_type, QTy=Sum(Qty),CertNo ,BDpId,BCltDpId,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End),
Party_Name = C1.Long_Name 
from DELTRANS D, Client2 C2, Client1 C1
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And
BDpId Like @BDpId and BCltDpId Like @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1  And Delivered = '0'
and c2.party_code = @statusname
And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not like 'Auction'
group by scrip_cd,CertNo, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0 
Order By D.Party_Code,Scrip_CD,Series,Sett_No, Sett_type
End
if @statusid = 'family'
begin
select scrip_cd, series ,D.Party_Code,Sett_No, Sett_type, QTy=Sum(Qty),CertNo ,BDpId,BCltDpId,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End),
Party_Name = C1.Long_Name 
from DELTRANS D, Client2 C2, Client1 C1
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And
BDpId Like @BDpId and BCltDpId Like @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1  And Delivered = '0' 
and c1.family = @statusname
And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not like 'Auction'
group by scrip_cd,CertNo, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0 
Order By D.Party_Code,Scrip_CD,Series,Sett_No, Sett_type
End

GO
