-- Object: PROCEDURE dbo.Rpt_NseDelHoldScrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc Rpt_NseDelHoldScrip (
@StatusId Varchar(15),@StatusName Varchar(25),@FromParty varchar(10),
@ToParty varchar(10),@FromScrip Varchar(12),@ToScrip Varchar(12),@BDpID Varchar(8),@BCltDpID Varchar(16))
AS
if @BDpID = '' 
Select @BDpID = '%'
if @BCltDpID = '' 
Select @BCltDpID = '%'

if @statusid = 'broker'
begin
select scrip_cd, series ,D.Party_Code,C1.Long_Name,Sett_No, Sett_type, QTy=Sum(Qty),CertNo,BDpId,BCltDpId,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End)
from DELTRANS D, Client1 C1, Client2 C2
where BDpId Like @BDpId+'%' and BCltDpId Like @BCltDpId+'%' And C1.Cl_Code = C2.Cl_Code and D.Party_Code = C2.Party_Code
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1  And Delivered = '0'  And TrType <> 907 
And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not Like 'AUCTION'
group by scrip_cd,CertNo, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0 
Union All 
select scrip_cd, series ,D.Party_Code,C1.Long_Name,Sett_No, Sett_type, QTy=Sum(Qty),CertNo=IsIn ,BDpId,BCltAccNo,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End)
from DematTrans D, Client2 C2, Client1 C1
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And  
BDpId Like @BDpId and BCltAccNo = @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP 
And D.Party_Code <> 'BROKER' And TrType <> 906 
group by scrip_cd,isin, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type ,BDpId,BCltAccNo
Having Sum(Qty) > 0 
Order By Scrip_CD,Series,D.Party_Code,Sett_No, Sett_type

End
if @statusid = 'branch'
begin
select scrip_cd, series ,D.Party_Code,C1.Long_Name,Sett_No, Sett_type, QTy=Sum(Qty),CertNo,BDpId,BCltDpId ,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End)
from DELTRANS D, Client2 C2, Client1 C1, branches br  
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And
BDpId Like @BDpId and BCltDpId Like @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1  And Delivered = '0'
and br.short_name = c1.trader and br.branch_cd = @statusname And TrType <> 907 
And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not Like 'AUCTION'
group by scrip_cd,CertNo, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0 
Union All 
select scrip_cd, series ,D.Party_Code,C1.Long_Name,Sett_No, Sett_type, QTy=Sum(Qty),CertNo=IsIn,BDpId,BCltAccNo,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End) 
from DematTrans D, Client2 C2, Client1 C1, branches br  
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And  
BDpId Like @BDpId and BCltAccNo = @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP 
and br.short_name = c1.trader and br.branch_cd = @statusname 
And D.Party_Code <> 'BROKER' And TrType <> 906 
group by scrip_cd,isin, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type ,BDpId,BCltAccNo
Having Sum(Qty) > 0 
Order By Scrip_CD,Series,D.Party_Code,Sett_No, Sett_type
End
if @statusid = 'subbroker'
begin
select scrip_cd, series ,D.Party_Code,C1.Long_Name,Sett_No, Sett_type, QTy=Sum(Qty),CertNo ,BDpId,BCltDpId,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End)
from DELTRANS D, Client2 C2, Client1 C1, subbrokers sb 
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And
BDpId Like @BDpId and BCltDpId Like @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1  And Delivered = '0'
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname 
And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not Like 'AUCTION'
group by scrip_cd,CertNo, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0 
Union All 
select scrip_cd, series ,D.Party_Code,C1.Long_Name,Sett_No, Sett_type, QTy=Sum(Qty),CertNo=IsIn,BDpId,BCltAccNo ,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End)
from DematTrans D, Client2 C2, Client1 C1, subbrokers sb 
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And  
BDpId Like @BDpId and BCltAccNo = @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP 
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname 
And D.Party_Code <> 'BROKER' And TrType <> 906 
group by scrip_cd,isin, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type ,BDpId,BCltAccNo
Having Sum(Qty) > 0 
Order By Scrip_CD,Series,D.Party_Code,Sett_No, Sett_type
End
if @statusid = 'trader'
begin
select scrip_cd, series ,D.Party_Code,C1.Long_Name,Sett_No, Sett_type, QTy=Sum(Qty),CertNo,BDpId,BCltDpId,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End) 
from DELTRANS D, Client2 C2, Client1 C1
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And
BDpId Like @BDpId and BCltDpId Like @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1  And Delivered = '0'
and c1.trader = @statusname And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not Like 'AUCTION'
group by scrip_cd,CertNo, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0 
Union All 
select scrip_cd, series ,D.Party_Code,C1.Long_Name,Sett_No, Sett_type, QTy=Sum(Qty),CertNo=IsIn ,BDpId,BCltAccNo,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End)
from DematTrans D, Client2 C2, Client1 C1
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And  
BDpId Like @BDpId and BCltAccNo = @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP 
and c1.trader = @statusname And D.Party_Code <> 'BROKER' And TrType <> 906 
group by scrip_cd,isin, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type ,BDpId,BCltAccNo
Having Sum(Qty) > 0 
Order By Scrip_CD,Series,D.Party_Code,Sett_No, Sett_type
End
if @statusid = 'client'
begin
select scrip_cd, series ,D.Party_Code,C1.Long_Name,Sett_No, Sett_type, QTy=Sum(Qty),CertNo ,BDpId,BCltDpId,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End)
from DELTRANS D, Client2 C2, Client1 C1
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And
BDpId Like @BDpId and BCltDpId Like @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1 And Delivered = '0'
and c2.party_code = @statusname And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not Like 'AUCTION'
group by scrip_cd,CertNo, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0 
Union All 
select scrip_cd, series ,D.Party_Code,C1.Long_Name,Sett_No, Sett_type, QTy=Sum(Qty),CertNo=IsIn,BDpId,BCltAccNo ,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End)
from DematTrans D, Client2 C2, Client1 C1
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And  
BDpId Like @BDpId and BCltAccNo = @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP 
and c2.party_code = @statusname And D.Party_Code <> 'BROKER' And TrType <> 906 
group by scrip_cd,isin, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type ,BDpId,BCltAccNo
Having Sum(Qty) > 0 
Order By Scrip_CD,Series,D.Party_Code,Sett_No, Sett_type
End
if @statusid = 'family'
begin
select scrip_cd, series ,D.Party_Code,C1.Long_Name,Sett_No, Sett_type, QTy=Sum(Qty),CertNo,BDpId,BCltDpId ,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End)
from DELTRANS D, Client2 C2, Client1 C1
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And
BDpId Like @BDpId and BCltDpId Like @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1 And Delivered = '0'
and c1.family = @statusname And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not Like 'AUCTION'
group by scrip_cd,CertNo, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0 
Union All 
select scrip_cd, series ,D.Party_Code,C1.Long_Name,Sett_No, Sett_type, QTy=Sum(Qty),CertNo=IsIn ,BDpId,BCltAccNo,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End)
from DematTrans D, Client2 C2, Client1 C1
where C2.Cl_Code = C1.Cl_Code And C2.Party_Code = D.Party_Code And  
BDpId Like @BDpId and BCltAccNo = @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP 
and c1.family = @statusname And D.Party_Code <> 'BROKER' And TrType <> 906 
group by scrip_cd,isin, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type ,BDpId,BCltAccNo
Having Sum(Qty) > 0 
Order By Scrip_CD,Series,D.Party_Code,Sett_No, Sett_type
End

GO
