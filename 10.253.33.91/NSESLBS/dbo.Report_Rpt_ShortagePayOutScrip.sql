-- Object: PROCEDURE dbo.Report_Rpt_ShortagePayOutScrip
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Report_Rpt_ShortagePayOutScrip (@StatusId Varchar(15), @StatusName Varchar(25),@FromSett_no Varchar(7),@ToSett_no Varchar(7), @sett_Type Varchar(2), @Flag Int) As         
    
Declare @S_Sett_No Varchar(7),    
@SettCur Cursor    
    
Select Short_Name=c1.Short_Name + ' (' + C1.Branch_cd + ')' + ' (' + Sub_Broker + ')', C2.Party_Code    
Into #Client     
From Client2_Report C2,Client1_Report C1    
Where C1.Cl_Code = C2.Cl_Code    
And @StatusName =     
                  (case     
                        when @StatusId = 'BRANCH' then c1.branch_cd    
                        when @StatusId = 'SUBBROKER' then c1.sub_broker    
                        when @StatusId = 'Trader' then c1.Trader    
                        when @StatusId = 'Family' then c1.Family    
                        when @StatusId = 'Area' then c1.Area    
                        when @StatusId = 'Region' then c1.Region    
                        when @StatusId = 'Client' then c2.party_code    
                  else     
                        'BROKER'    
                  End)    
    
Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,  
FolioNo,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,  
SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,  
BDpType,BDpId,BCltDpId,Filler4,Filler5    
Into #DelTrans     
From DelTrans_Report    
Where 1 = 2     
    
Set @SettCur = Cursor For    
Select Sett_No From Sett_Mst    
Where Sett_No >= @FromSett_No    
And Sett_No <= @ToSett_No    
And Sett_type = @Sett_Type    
Open @SettCur    
Fetch Next From @SettCur into @S_Sett_No    
While @@fetch_status = 0     
Begin    
 Insert Into #DelTrans     
 Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,  
 FolioNo,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,  
 BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,  
 BDpType,BDpId,BCltDpId,Filler4,Filler5     
 From DelTrans_Report With(Index(DelHold), NoLock)    
 Where Sett_No = @S_Sett_No    
 And Sett_type = @Sett_Type    
 And Filler2 = 1     
 And TrType <> 906     
 And Party_Code <> 'BROKER'    
 And Party_code In (Select Party_Code From #Client)    
 Fetch Next From @SettCur into @S_Sett_No    
End    
Close @SettCur    
DeAllocate @SettCur    
    
Select * Into #DeliveryClt    
From DeliveryClt_Report    
Where Sett_No >= @FromSett_No    
And Sett_No <= @ToSett_No    
And Sett_type = @Sett_Type    
And Party_code In (Select Party_Code From #Client)    
    
set transaction isolation level read uncommitted      
If LTrim(RTrim(@Sett_Type)) <> 'W'         
Begin        
select d.sett_no,d.sett_type,d.Party_Code,C.Short_Name,d.Scrip_cd,d.Series,  
BuyTradeQty = BuyQty, BuyRecQty=Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) ,        
SellTradeQty = SellQty , SellRecQty=Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End) ,        
BuyShortage = (Case When BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) > 0         
          Then BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End)        
          Else 0 End )         
 + (Case When (SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) < 0 Then         
  Abs(SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) Else 0 End),        
SellShortage = (Case When (SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) > 0 Then         
  Abs(SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) Else 0 End) +        
  (Case When BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) < 0         
           Then Abs(BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End))        
          Else 0 End ),    
Flag = 0    
into #delaucshort    
from #Client C,   
(    
 Select Sett_No, Sett_Type, Scrip_Cd, Series, Party_Code,       
 Buyqty= Sum(Case When Inout = 'O' Then Qty Else 0 End),       
 Sellqty= Sum(Case When Inout = 'I' Then Qty Else 0 End)      
 From #DeliveryClt    
 where Sett_no >= @fromsett_no    
 and sett_no <= @toSett_no    
 and sett_type = @sett_type    
 Group By Sett_No, Sett_Type, Scrip_Cd, Series, Party_Code      
)    
 d Left Outer Join #DelTrans de         
On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd        
and de.series = d.series and de.party_code = d.party_code and filler2 = 1 And ShareType <> (Case When D.Sett_Type Not Like 'A%' Then 'AUCTION' Else '' End) )        
Where D.Party_Code = C.Party_Code And D.Sett_no >= @FromSett_No And D.Sett_no <= @ToSett_No And D.Sett_type = @Sett_Type        
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,d.Party_Code,C.Short_Name,d.BuyQty,SellQty        
Having  ((Case When BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) > 0         
          Then BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End)        
          Else 0 End )         
 + (Case When (SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) < 0 Then         
  Abs(SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) Else 0 End))        
 -         
  ((Case When (SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) > 0 Then         
  Abs(SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) Else 0 End) +        
  (Case When BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) < 0         
           Then Abs(BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End))        
          Else 0 End )) > 0         
Or ( (Case When BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) > 0         
          Then BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End)        
          Else 0 End )         
 + (Case When (SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) < 0 Then         
  Abs(SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) Else 0 End) > 0         
And  (Case When (SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) > 0 Then         
  Abs(SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) Else 0 End) +        
  (Case When BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) < 0         
           Then Abs(BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End))        
          Else 0 End )  = 0 )           
Or   BuyQty > Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End)         
    
    
Insert into #delaucshort    
select d.sett_no,d.sett_type,d.Party_Code,c.Short_Name,d.Scrip_cd,d.Series,  
BuyTradeQty = 0, BuyRecQty=Sum(Case When DrCr = 'D' Then isnull(d.qty,0) Else 0 End) ,        
SellTradeQty = 0, SellRecQty=Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End) ,        
BuyShortage = (Case When Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End) - Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) > 0 Then        
  Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End) - Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) Else 0 End),        
SellShortage = (Case When Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) - Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End) > 0 Then        
  Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) - Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End) Else 0 End),    
Flag = 0    
from #Client C, #DelTrans d         
Where D.Party_Code = C.Party_Code And D.Sett_no >= @FromSett_No And         
D.Sett_no <= @ToSett_No And D.Sett_type = @Sett_Type        
And Filler2 = 1 And TrType <> 906 And D.Party_Code Not in ( Select Party_Code From #DeliveryClt DE         
Where de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd        
and de.series = d.series and de.party_code = d.party_code )        
And ShareType <> (Case When D.Sett_Type Not Like 'A%' Then 'AUCTION' Else '' End)        
group by d.sett_no,d.sett_type,d.Party_Code,C.Short_Name,d.scrip_cd,d.series  
having Sum(Case When DrCr = 'D' Then isnull(d.qty,0) Else 0 End) < Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End)         
    
Update #delaucshort Set Flag = 1 From MultiCltId M          
Where M.Party_Code = #delaucshort.Party_Code          
And Def = 1           
          
Select * From #DelAucShort          
Where Flag Like (Case When @Flag = 0 Then '0' When @Flag = 1 Then '1' Else '%' End)          
Order BY sett_no, sett_type, scrip_cd, series, Party_Code, Short_Name        
    
End        
Else        
Begin        
select d.sett_no,d.sett_type,d.Party_Code,C.Short_Name,d.Scrip_cd,d.Series,  
BuyTradeQty = BuyQty, BuyRecQty=Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) ,        
SellTradeQty = SellQty , SellRecQty=Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End) ,        
BuyShortage = (Case When Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End) > SellQty Then
	   BuyQty + Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End) - SellQty
	   - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End)
      Else BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End)
 End),        
SellShortage = 0,    
Flag = 0    
into #delaucshort1    
from #Client C,     
(    
Select Sett_No, Sett_Type, Scrip_Cd, Series, Party_Code,       
Buyqty= Sum(Case When Inout = 'O' Then Qty Else 0 End),       
Sellqty= Sum(Case When Inout = 'I' Then Qty Else 0 End)      
From #DeliveryClt      
where Sett_no >= @fromsett_no    
and sett_no <= @tosett_no    
and sett_type = @sett_type    
Group By Sett_No, Sett_Type, Scrip_Cd, Series, Party_Code      
)    
 d Left Outer Join #DelTrans de         
On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd        
and de.series = d.series and de.party_code = d.party_code and filler2 = 1 And ShareType <> (Case When D.Sett_Type Not Like 'A%' Then 'AUCTION' Else '' End))        
Where D.Party_Code = C.Party_Code And D.Sett_no >= @FromSett_No And D.Sett_no <= @ToSett_No And D.Sett_type = @Sett_Type        
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,d.Party_Code,C.Short_Name,d.BuyQty,SellQty        
Having  (Case When BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) > 0         
          Then BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End)        
          Else 0 End )         
 + (Case When (SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) < 0 Then         
  Abs(SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) Else 0 End) > 0          
AND (CASE WHEN Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End) > SellQty         
   THEN (Case When BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) > 0         
          Then BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End)        
          Else 0 End )         
 + (Case When (SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) < 0 Then         
  Abs(SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) Else 0 End) - (        
  (Case When (SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) > 0 Then         
  Abs(SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) Else 0 End) +        
  (Case When BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) < 0         
           Then Abs(BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End))        
          Else 0 End )) ELSE 1 END) <> 0         
       
Insert into #delaucshort1        
select d.sett_no,d.sett_type,d.Party_Code,C.Short_Name,d.Scrip_cd,d.Series,  
BuyTradeQty = 0, BuyRecQty=Sum(Case When DrCr = 'D' Then isnull(d.qty,0) Else 0 End) ,        
SellTradeQty = 0, SellRecQty=Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End) ,        
BuyShortage = (Case When Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End) - Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) > 0 Then        
  Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End) - Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) Else 0 End),        
SellShortage = (Case When Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) - Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End) > 0 Then        
  Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) - Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End) Else 0 End),    
Flag = 0        
from #Client C, #DelTrans d         
Where D.Party_Code = C.Party_Code and D.Sett_no >= @FromSett_No And         
D.Sett_no <= @ToSett_No And D.Sett_type = @Sett_Type        
And Filler2 = 1 And TrType <> 906 And D.Party_Code Not in ( Select Party_Code From #DeliveryClt DE         
Where de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd        
and de.series = d.series and de.party_code = d.party_code )        
And ShareType <> (Case When D.Sett_Type Not Like 'A%' Then 'AUCTION' Else '' End)        
group by d.sett_no,d.sett_type,d.Party_Code,C.Short_Name,d.scrip_cd,d.series        
having Sum(Case When DrCr = 'D' Then isnull(d.qty,0) Else 0 End) < Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End)         
    
Update #delaucshort1 Set Flag = 1 From MultiCltId M          
Where M.Party_Code = #delaucshort1.Party_Code          
And Def = 1           
          
Select * From #DelAucShort1          
Where Flag Like (Case When @Flag = 0 Then '0' When @Flag = 1 Then '1' Else '%' End)          
Order BY sett_no, sett_type, scrip_cd, series, Party_Code, Short_Name         
       
End

GO
