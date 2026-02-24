-- Object: PROCEDURE dbo.Rpt_DeliveryPayout_Karvy_RMS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_DeliveryPayout_Karvy_RMS
(@Sett_No Varchar(7),    
 @Sett_Type Varchar(2),    
 @FromParty Varchar(10),    
 @ToParty Varchar(10),    
 @FromScrip Varchar(12),    
 @ToScrip Varchar(12),    
 @DpType Varchar(4),    
 @DpId Varchar(8),    
 @CltDpId Varchar(16),    
 @Flag Int )    
AS    
    
Set Transaction Isolation Level Read Uncommitted    
  
select D.Scrip_cd,Series=D.Scrip_CD,D.Party_Code,Long_Name,TrType,D.DpType,CltDpId,    
D.DpId,CertNo,Qty=sum(qty),bdptype,bdpid,bcltdpid,    
ISett_No,Isett_Type,Flag=(Case When TrType = 907 Then 1 When TrType = 908 Then 2 Else 3 End),    
InExc=0 Into #Del from Client1 C1, Client2 C2, DelTrans D    
where Sett_no = @Sett_No and sett_type = @Sett_Type And TrType <> 906    
and D.Party_code = C2.Party_code and C1.Cl_Code = C2.Cl_Code     
And Delivered = '0' And D.Party_Code <> 'BROKER'     
And BDpType = @DpType And BDpId = @DpId and BCltDpId = @CltDpId And DrCr = 'D' And Filler2 = 1     
And D.Party_Code >= @FromParty And D.Party_Code <= @ToParty    
And D.Scrip_Cd >= @FromScrip And D.Scrip_Cd <= @ToScrip And TrType in (904,905)     
Group by D.Scrip_cd,D.Series,D.Party_Code,Long_Name,TrType,CltDpId,D.DpId,     
CertNo, bdptype,bdpid,bcltdpid,ISett_No,Isett_Type,D.DpType  
  
Select D.*, Amount=IsNull(LedBal,0), ActPayOut=IsNull(ActPayOut,0)
From #Del D Left Outer Join MSAJAG.DBO.DelPayOut P 
On ( P.Party_code = D.Party_Code And D.CertNo = P.CertNo And P.PoolQty > 0 
And D.Sett_No = P.Sett_No And D.Sett_Type = P.Sett_Type And P.Exchange = 'NSE' 
And TrType = 904  And D.bdptype = P.dptype)
order by Flag, ISett_No, ISett_Type, DpType, Party_Code, Scrip_Cd

GO
