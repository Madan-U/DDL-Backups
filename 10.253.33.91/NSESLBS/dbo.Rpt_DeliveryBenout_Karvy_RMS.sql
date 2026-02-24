-- Object: PROCEDURE dbo.Rpt_DeliveryBenout_Karvy_RMS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.Rpt_DeliveryPayout_Karvy    Script Date: 01/17/2005 1:50:33 PM ******/  
CREATE Proc Rpt_DeliveryBenout_Karvy_RMS  
(@FromParty Varchar(10),  
 @ToParty Varchar(10),  
 @FromScrip Varchar(12),  
 @ToScrip Varchar(12),  
 @DpType Varchar(4),    
 @BDpType Varchar(4),  
 @BDpId Varchar(8),  
 @BCltDpId Varchar(16),  
 @BranchCd Varchar(10))  
AS  
  
Set NoCount On  
Select @BranchCd = (Case When @BranchCd = 'ALL' Then '%' Else @BranchCd End)  
Select @DpType   =  (Case When Upper(@DpType) = 'ALL' Then '%' Else @DpType End)  
  
Set Transaction Isolation Level Read Uncommitted  
  
select D.Scrip_cd,Series=D.Scrip_CD,D.Party_Code,C1.Long_Name,TrType,DpType,CltDpId,DpId,CertNo,Qty=sum(qty),bdptype,bdpid,bcltdpid,Amount=IsNull(LedBal,0),ISett_No,Isett_Type,  
Sett_no='',Sett_Type='',ActPayOut=IsNull(ActPayOut,0) from Client1 c1,client2 c2, DelTrans_View D Left Outer Join MSAJAG.DBO.DelPayoutView P
On ( P.Party_code = D.Party_Code And D.CertNo = P.CertNo And P.DebitQty > 0
And P.Exchange = 'NSE' And TrType = 904)
where TrType in (905,904)   
and D.Party_code = C2.Party_code and C1.Cl_Code = c2.Cl_Code   
And Delivered = '0'   
And BDpType = @BDpType And BDpId = @BDpId  
and BCltDpId = @BCltDpId And DrCr = 'D' And Filler2 = 1   
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty  
And D.Scrip_Cd >= @FromScrip And D.Scrip_Cd <= @ToScrip  
And DpType Like @DpType  
And C1.Branch_Cd Like Rtrim(LTrim(@BranchCd))  
Group by D.Scrip_cd,D.Series,D.Party_Code,C1.Long_Name,TrType,CltDpId,DpId,   
CertNo, bdptype,bdpid,bcltdpid,LedBal,ISett_No,Isett_Type,DpType, ActPayOut
order by D.Party_Code,D.Scrip_Cd,ISett_No,ISett_Type,DpType

GO
