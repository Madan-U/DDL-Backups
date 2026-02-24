-- Object: PROCEDURE dbo.Rpt_DeliveryBenout_Karvy_ben
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.Rpt_DeliveryPayout_Karvy    Script Date: 01/17/2005 1:50:33 PM ******/  
CREATE Proc Rpt_DeliveryBenout_Karvy_ben  
(@FromParty Varchar(10),  
 @ToParty Varchar(10),  
 @FromScrip Varchar(12),  
 @ToScrip Varchar(12),  
 @DpType Varchar(4),    
 @BDpType Varchar(4),  
 @BDpId Varchar(8),  
 @BCltDpId Varchar(16),  
 @BranchCd Varchar(10),
 @acname varchar(100))  
AS  
  
Set NoCount On  
Select @BranchCd = (Case When @BranchCd = 'ALL' Then '%' Else @BranchCd End)  
Select @DpType   =  (Case When Upper(@DpType) = 'ALL' Then '%' Else @DpType End)  
  
Set Transaction Isolation Level Read Uncommitted  

select D.Scrip_cd,Series=D.Scrip_CD,D.Party_Code,Long_Name='',TrType,DT.DpType,CltDpId=DpCltNo,DT.DpId,
CertNo,Qty=sum(qty),bdptype,bdpid,bcltdpid,Amount=0,ISett_No,Isett_Type,  
Sett_no='',Sett_Type='' from Client1 c1,client2 c2, deliverydp dt,
DelTrans_View D
where TrType in (905,904)   
and D.Party_code = C2.Party_code and C1.Cl_Code = c2.Cl_Code   
And Delivered = '0'   
And BDpType = @BDpType And BDpId = @BDpId  
and BCltDpId = @BCltDpId And DrCr = 'D' And Filler2 = 1   
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty  
And D.Scrip_Cd >= @FromScrip And D.Scrip_Cd <= @ToScrip  
And C1.Branch_Cd Like Rtrim(LTrim(@BranchCd))
and dt.description = @acname  
Group by D.Scrip_cd,D.Series,D.Party_Code,C1.Long_Name,TrType,DT.DpType,DpCltNo,DT.DpId,   
CertNo, bdptype,bdpid,bcltdpid,ISett_No,Isett_Type
order by D.Party_Code,D.Scrip_Cd,ISett_No,ISett_Type

GO
