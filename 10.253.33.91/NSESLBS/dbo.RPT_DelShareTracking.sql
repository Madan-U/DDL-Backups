-- Object: PROCEDURE dbo.RPT_DelShareTracking
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE  Proc RPT_DelShareTracking  
(  
   
   
 /*Declare*/  
 @StatusId Varchar(15),  
 @StatusName Varchar(25),  
 @FromSettNo Varchar(7),   
 @ToSettNo Varchar(7),  
 @FromParty Varchar(10),  
 @ToParty Varchar(10),  
 @FromScrip Varchar(12),  
 @ToScrip Varchar(12),  
 @Branch Varchar(10)  
  
)  
  
AS  
  
/*  
drop table #tmpShareRec  
Set @StatusId = 'broker'  
Set @StatusName = 'broker'  
Set @FromSettNo = '2004090'  
Set @ToSettNo = '2004300'  
Set @FromParty = ''  
Set @ToParty = ''  
Set @FromScrip = ''  
Set @ToScrip = ''  
Set @Branch = 'ALL'  
*/  
if len(@FromParty) = 0   
Begin  
 Select @FromParty=Min(Party_Code), @ToParty = Max(Party_Code) From Client2   
End   
if len(@FromScrip) = 0   
Begin  
 Select @FromScrip=Min(Scrip_Cd), @ToScrip = Max(Scrip_Cd) From Scrip2  
End   
  
select dl.sett_type,dl.sett_no,dl.party_code,dl.scrip_cd,dl.series,inout,  
c1.long_name,BuyQty=IsNull((Case When InOut = 'O' Then Dc.Qty Else 0 End),0),   
SellQty=IsNull((Case When InOut = 'I' Then Dc.Qty Else 0 End),0),   
Delivered=sum(Case When DrCr = 'D' Then dl.qty Else 0 End),   
Received=Sum(Case When DrCr = 'C' Then dl.qty Else 0 End),   
DelToParty=sum(Case When DrCr = 'D' And TrType in (904,905) And Delivered = 'D'  
And ShareType = 'DEMAT' Then dl.qty Else 0 End),   
DelInterSett=sum(Case When DrCr = 'D' And TrType in (907,908,1000)   
And ShareType = 'DEMAT' Then dl.qty Else 0 End),   
DelHoDebit=sum(Case When DrCr = 'D' And TrType in (904,909,905) And   
Delivered = '0' And ShareType = 'DEMAT' Then dl.qty Else 0 End),   
DelCloseOut=sum(Case When DrCr = 'D' And TrType = 904 And   
ShareType = 'AUCTION' Then dl.qty Else 0 End),   
RecFromParty=sum(Case When DrCr = 'C' And TrType = 904   
And ShareType = 'DEMAT' Then dl.qty Else 0 End),   
RecInterSett=sum(Case When DrCr = 'C' And TrType = 907   
And ShareType = 'DEMAT' Then dl.qty Else 0 End),   
DelHoCredit=0, RecCloseOut=sum(Case When DrCr = 'C' And TrType = 904   
And ShareType = 'AUCTION' Then dl.qty Else 0 End),Dl.DpId, Dl.CltDpId  
into #tmpShareRec from client1 c1, Client2 C2, deltrans dl WITH(INDEX(DELHOLD)) Left Outer Join deliveryclt dc   
On ( dc.sett_type=dl.sett_type and dc.sett_no=dl.sett_no and dc.scrip_cd = dl.scrip_cd   
and dc.series = dl.series and dc.party_code = dl.party_code )   
where dl.sett_no >=@FromSettNo and dl.sett_no <= @ToSettNo  
and dl.party_code >= @FromParty and dl.party_code <= @ToParty  
and c2.party_code = dl.party_code   
and dl.scrip_cd >= @FromScrip and dl.scrip_cd <= @ToScrip  
and dl.filler2 = 1   
and c1.cl_code = c2.cl_code  
and c1.cl_code = dc.party_code   
And C1.Branch_Cd Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End)  
And C1.sub_broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End)  
And C1.trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End)  
And C1.family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End)  
And area Like (Case When @Statusid = 'area' Then @statusname else '%' End)  
And region Like (Case When @Statusid = 'region' Then @statusname else '%' End)  
And C2.Party_Code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End)  
And C1.Branch_Cd Like (Case When @Branch = 'ALL' Then '%' Else @Branch End)  
group by dl.sett_type,dl.sett_no,dl.party_code,dl.scrip_cd,dl.series,Dc.Qty,  
InOut,c1.long_name,Dl.DpId, Dl.CltDpId   
  
Update #tmpShareRec Set RecFromParty = 0,  RecInterSett = RecFromParty, DpId = '', CltDpId = ''   
From BSEDB.DBO.DeliveryDp D Where D.DpId = #tmpShareRec.DpId   
And D.DpCltNo = #tmpShareRec.CltDpId  
  
Update #tmpShareRec Set RecFromParty = 0, DelHoCredit = RecFromParty   
From MSAJAG.DBO.DeliveryDp D Where D.DpId = #tmpShareRec.DpId   
And D.DpCltNo = #tmpShareRec.CltDpId  
  
Select sett_type,sett_no,party_code,scrip_cd,series,inout,long_name,  
BuyQty=BuyQty,SellQty=SellQty,  
Delivered=Sum(Delivered),Received=Sum(Received),  
DelToParty=Sum(DelToParty),DelInterSett=Sum(DelInterSett),  
DelHoDebit=Sum(DelHoDebit),DelCloseOut=Sum(DelCloseOut),  
RecFromParty=Sum(RecFromParty),RecInterSett=Sum(RecInterSett),  
DelHoCredit=Sum(DelHoCredit),RecCloseOut=Sum(RecCloseOut)  
From #tmpShareRec   
Group By sett_type,sett_no,party_code,scrip_cd,series,inout,long_name,SellQty,BuyQty  
Order By long_name,party_code,scrip_cd,series,sett_type,sett_no

GO
