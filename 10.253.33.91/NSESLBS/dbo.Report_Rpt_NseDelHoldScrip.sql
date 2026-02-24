-- Object: PROCEDURE dbo.Report_Rpt_NseDelHoldScrip
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE Proc Report_Rpt_NseDelHoldScrip (  
@StatusId Varchar(15),@StatusName Varchar(25),@FromParty varchar(10),  
@ToParty varchar(10),@FromScrip Varchar(12),@ToScrip Varchar(12),@BDpID Varchar(8),@BCltDpID Varchar(16))  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  
if @BDpID = ''   
Select @BDpID = '%'  
if @BCltDpID = ''   
Select @BCltDpID = '%'  
  
select D.Scrip_Cd, D.Series, D.Party_Code,C1.Long_Name,Sett_No, Sett_type, QTy=Sum(Qty),CertNo,BDpId,BCltDpId,  
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End), PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End)  
from Deltrans_report D, client1_report C1, client2_report C2  
where BDpId = @BDpId and BCltDpId = @BCltDpId And C1.Cl_Code = C2.Cl_Code and D.Party_Code = C2.Party_Code  
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY  
AND D.Scrip_Cd BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1  And Delivered = '0'  And TrType <> 907   
And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not Like 'AUCTION'  
AND CERTNO LIKE 'IN%'  
And C1.Branch_Cd Like (Case When @StatusId = 'branch' then @StatusName Else '%' End)  
And C1.Sub_Broker Like (Case When @StatusId = 'subbroker' then @StatusName Else '%' End)  
And C1.Trader Like (Case When @StatusId = 'trader' then @StatusName Else '%' End)  
And C1.Family Like (Case When @StatusId = 'family' then @StatusName Else '%' End)  
And C2.Party_Code Like (Case When @StatusId = 'client' then @StatusName Else '%' End)  
group by D.Scrip_Cd,CertNo,D.Series ,D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0   
Order By D.Scrip_Cd, D.Series, D.Party_Code,Sett_No, Sett_type

GO
