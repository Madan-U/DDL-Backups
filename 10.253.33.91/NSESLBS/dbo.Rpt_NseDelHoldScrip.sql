-- Object: PROCEDURE dbo.Rpt_NseDelHoldScrip
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc Rpt_NseDelHoldScrip (      
@StatusId Varchar(15),@StatusName Varchar(25),@FromParty varchar(10),      
@ToParty varchar(10),@FromScrip Varchar(12),@ToScrip Varchar(12),    
@BDpID Varchar(8),@BCltDpID Varchar(16), @Branch Varchar(10))      
AS      
if @BDpID = ''       
Select @BDpID = '%'      
if @BCltDpID = ''       
Select @BCltDpID = '%'      
Set Transaction Isolation level read uncommitted      
select scrip_cd, series ,D.Party_Code,C1.Long_Name,Sett_No, Sett_type, QTy=Sum(Qty),CertNo,BDpId,BCltDpId,
HoldQty=(Case When @StatusId = 'broker' Then Sum(Case When TrType <> 909 Then Qty Else 0 End) Else Sum(Qty) End), 
PledgeQty=(Case When @StatusId = 'broker' Then Sum(Case When TrType = 909 Then Qty Else 0 End) Else 0 End)
from DELTRANS D, Client1 C1, Client2 C2      
where BDpId Like @BDpId+'%' and BCltDpId Like @BCltDpId+'%' And C1.Cl_Code = C2.Cl_Code and D.Party_Code = C2.Party_Code      
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY      
AND SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1  And Delivered = '0'  And TrType <> 907       
And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not Like 'AUCTION'      
And C1.Branch_Cd Like @Branch    
And C1.Branch_Cd Like (Case When @StatusId = 'branch' then @Statusname else '%' End)       
And C1.Sub_broker Like (Case When @StatusId = 'subbroker' then @Statusname else '%' End)      
And C1.Trader Like (Case When @StatusId = 'trader' then @Statusname else '%' End)      
And C1.Family Like (Case When @StatusId = 'family' then @Statusname else '%' End)      
And C1.Region Like (Case When @StatusId = 'region' then @Statusname else '%' End)      
And C1.Area Like (Case When @StatusId = 'area' then @Statusname else '%' End)      
And C2.Party_Code Like (Case When @StatusId = 'client' then @Statusname else '%' End)      
group by scrip_cd,CertNo, series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0       
Order By Scrip_CD,Series,D.Party_Code,Sett_No, Sett_type

GO
