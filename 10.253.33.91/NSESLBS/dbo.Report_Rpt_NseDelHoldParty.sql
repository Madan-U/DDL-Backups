-- Object: PROCEDURE dbo.Report_Rpt_NseDelHoldParty
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------






CREATE Proc Report_Rpt_NseDelHoldParty (
@StatusId Varchar(15),@StatusName Varchar(25),@FromParty varchar(10),
@ToParty varchar(10),@FromScrip Varchar(12),@ToScrip Varchar(12),@BDpID Varchar(8),@BCltDpID Varchar(16))
AS
if @BDpID = '' 
Select @BDpID = '%'
if @BCltDpID = '' 
Select @BCltDpID = '%'
Set Transaction Isolation level read uncommitted
select scrip_cd, series ,D.Party_Code,Sett_No, Sett_type, QTy=Sum(Qty),CertNo,BDpId,BCltDpId,
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), 
PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End),
Party_Name = C1.Long_Name , C1.Long_Name 
from Deltrans_Report D, Client1_Report C1, Client2_Report C2 
where BDpId Like @BDpId and BCltDpId Like @BCltDpId 
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1  And Delivered = '0'
And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not like 'Auction'
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code
And C1.Branch_Cd Like (Case When @StatusId = 'branch' then @Statusname else '%' End) 
And C1.Sub_broker Like (Case When @StatusId = 'subbroker' then @Statusname else '%' End)
And C1.Trader Like (Case When @StatusId = 'trader' then @Statusname else '%' End)
And C1.Family Like (Case When @StatusId = 'family' then @Statusname else '%' End)
And C1.Region Like (Case When @StatusId = 'region' then @Statusname else '%' End)
And C1.Area Like (Case When @StatusId = 'area' then @Statusname else '%' End)
And C2.Party_Code Like (Case When @StatusId = 'client' then @Statusname else '%' End)
group by scrip_cd,CertNo, series, D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0 
Order By D.Party_Code,Scrip_CD,Series,Sett_No, Sett_type

GO
