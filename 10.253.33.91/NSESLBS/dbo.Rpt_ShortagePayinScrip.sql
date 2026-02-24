-- Object: PROCEDURE dbo.Rpt_ShortagePayinScrip
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_ShortagePayinScrip (@StatusId Varchar(15), @StatusName Varchar(25),@FromSett_no Varchar(7),@ToSett_no Varchar(7), @sett_Type Varchar(2), @Flag Int) As           
Set Transaction Isolation level read uncommitted          
        
Declare @S_Sett_No Varchar(7),        
@SettCur Cursor        
        
Select Short_Name=c1.Short_Name + ' (' + C1.Branch_cd + ')' + ' (' + Sub_Broker + ')', C2.Party_Code        
Into #Client         
From Client2 C2,Client1 C1        
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
        
Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo,        
HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,        
ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5        
Into #DelTrans         
From DelTrans        
Where 1 = 2         

Select * into #Sett_Mst From Sett_Mst
Where Sett_No >= @FromSett_No        
And Sett_No <= @ToSett_No        
And Sett_type = @Sett_Type 

Set @SettCur = Cursor For        
Select Sett_No From #Sett_Mst        
Order By Sett_no
Open @SettCur        
Fetch Next From @SettCur into @S_Sett_No        
While @@fetch_status = 0         
Begin        
 Insert Into #DelTrans         
 Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,Qty,FromNo,ToNo,CertNo,FolioNo,        
 HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,        
 ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3,BDpType,BDpId,BCltDpId,Filler4,Filler5         
 From DelTrans With(Index(DelHold), NoLock)        
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
        
Select Sett_no,Sett_Type,scrip_cd,series,Party_code,          
BuyQty=Sum(Case When Inout = 'O' Then Qty Else 0 End),          
SellQty=Sum(Case When Inout = 'I' Then Qty Else 0 End)          
Into #DelClt         
from DeliveryClt        
Where Sett_No >= @FromSett_No        
and Sett_No <= @ToSett_no        
and Sett_type = @Sett_type        
And Party_code In (Select Party_Code From #Client)        
Group BY Sett_no,Sett_Type,scrip_cd,series,Party_code        
        
select d.sett_no,d.sett_type,d.Party_Code,C.Short_Name,d.Scrip_cd,d.Series,          
BuyTradeQty = BuyQty, BuyRecQty=Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) ,          
SellTradeQty = SellQty , SellRecQty=Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End),      
Flag = 0 , Isin=Convert(Varchar(12),'')                  
Into #DelAucNew from #Client C,         
#DelClt d Left Outer Join #DelTrans de           
On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd          
and de.series = d.series and de.party_code = d.party_code and filler2 = 1 And ShareType <> (Case When D.Sett_Type Not Like 'A%' Then 'AUCTION' Else '' End) )          
Where D.Party_Code = C.Party_Code        
And D.Sett_no >= @FromSett_No And D.Sett_no <= @ToSett_No            
And D.Sett_type = @Sett_Type          
Group By d.sett_no,d.sett_type,d.Party_Code,C.Short_Name,d.Scrip_cd,d.Series,BuyQty,SellQty      
Having ( BuyQty <> Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End)           
    Or SellQty <> Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End) )          
          
Insert Into #DelAucNew          
select d.sett_no,d.sett_type,d.Party_Code,C.Short_Name,d.Scrip_cd,d.Series,          
BuyTradeQty = 0, BuyRecQty=Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) ,          
SellTradeQty = 0, SellRecQty=Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End),      
Flag = 0 , Isin=Convert(Varchar(12),'')                  
from #Client C, #DelTrans d           
Where D.Party_Code = C.Party_Code        
And D.Sett_no >= @FromSett_No And D.Sett_no <= @ToSett_No            
And D.Sett_type = @Sett_Type          
and filler2 = 1 And ShareType <> (Case When D.Sett_Type Not Like 'A%' Then 'AUCTION' Else '' End)        
And D.Party_Code Not in ( Select Party_Code From #DelClt De          
     Where de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd          
     and de.series = d.series and de.party_code = d.party_code  )          
Group By d.sett_no,d.sett_type,d.Party_Code,C.Short_Name,d.Scrip_cd,d.Series      
Having Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) <> Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End)          
          
If @Sett_Type <> 'W'           
Begin           
          
 Select Sett_no,Sett_Type,Party_Code,Short_Name,Scrip_Cd,Series,BuyTradeQty,BuyRecQty,SellTradeQty,SellRecQty,          
 BuyShortage=(Case When ( BuyTradeQty - SellTradeQty - BuyRecQty + SellRecQty ) > 0           
            Then ( BuyTradeQty - SellTradeQty - BuyRecQty + SellRecQty )          
     Else 0 End ) ,          
 SellShortage=(Case When ( BuyTradeQty - SellTradeQty - BuyRecQty + SellRecQty ) < 0           
            Then Abs( BuyTradeQty - SellTradeQty - BuyRecQty + SellRecQty )          
     Else 0 End ), Cl_Rate = Convert(Numeric(18,4),0),      
Flag = 0 , Isin=Convert(Varchar(12),'')                      
 Into #DelAucShort From #DelAucNew          
 Where ( BuyTradeQty - SellTradeQty - BuyRecQty + SellRecQty ) <> 0           

 Update #DelAucShort Set Cl_Rate = C.Cl_Rate                     
 From Closing C, #Sett_Mst S                     
 Where S.Sett_No = #DelAucShort.Sett_No                    
 And S.Sett_Type = #DelAucShort.Sett_Type                    
 And C.Scrip_Cd = #DelAucShort.Scrip_CD                    
 And C.Series = #DelAucShort.Series                    
 And SysDate = ( Select Max(SysDate) From Closing C1                     
       Where C.Scrip_Cd = C1.Scrip_CD                    
                           And C.Series = C1.Series And SysDate > Start_Date And SysDate < Sec_PayIn)                    
                    
 Update #delaucshort Set Flag = 1 From MultiCltId M                    
 Where M.Party_Code = #delaucshort.Party_Code                    
        And Def = 1                 
 Update #delaucshort Set Isin=multiisin.Isin From Multiisin                
 Where Multiisin.scrip_cd = #delaucshort.scrip_cd And MultiIsIn.Series = #delaucshort.Series                    
        And valid = 1      
          
 Select * From #DelAucShort          
 Where SellShortage > 0 And Flag Like (Case When @Flag = 0 Then '0' When @Flag = 1 Then '1' Else '%' End)         
 Order BY sett_no,sett_type,scrip_cd,series,Party_Code,Short_Name          
          
End          
Else          
Begin          
 Select Sett_no,Sett_Type,Party_Code,Short_Name,Scrip_Cd,Series,BuyTradeQty,BuyRecQty,SellTradeQty,SellRecQty,          
 BuyShortage=(Case When ( BuyTradeQty > BuyRecQty )          
            Then BuyTradeQty - BuyRecQty           
     Else           
      Case When ( BuyTradeQty < BuyRecQty )          
      Then (Case When ( SellTradeQty < SellRecQty And (BuyRecQty - BuyTradeQty - SellRecQty + SellTradeQty) < 0 )               
        Then Abs(BuyRecQty - BuyTradeQty - SellRecQty + SellTradeQty)          
             Else 0           
          End )            
           Else (CASE WHEN SellTradeQty < SellRecQty           
      THEN SellRecQty - SellTradeQty             
      ELSE 0 End ) END          
     End ),          
 SellShortage=(Case When ( SellTradeQty > SellRecQty )          
            Then SellTradeQty - SellRecQty           
 Else           
      Case When ( SellTradeQty < SellRecQty )          
      Then (Case When ( BuyTradeQty < BuyRecQty And (SellRecQty - SellTradeQty - BuyRecQty + BuyTradeQty ) < 0 )               
        Then Abs(SellRecQty - SellTradeQty - BuyRecQty + BuyTradeQty )          
     Else 0           
          End )            
           Else (CASE WHEN BuyTradeQty < BuyRecQty           
      THEN BuyRecQty - BuyTradeQty             
      ELSE 0 End ) END          
     End ), Cl_Rate = Convert(Numeric(18,4),0),      
 Flag = 0 , Isin=Convert(Varchar(12),'')                      
 Into #DelAucShort1 From #DelAucNew          
 Where ( (Case When ( SellTradeQty > SellRecQty )          
            Then SellTradeQty - SellRecQty           
     Else           
      Case When ( SellTradeQty < SellRecQty )          
      Then (Case When ( BuyTradeQty < BuyRecQty And (SellRecQty - SellTradeQty - BuyRecQty + BuyTradeQty ) < 0 )               
        Then Abs(SellRecQty - SellTradeQty - BuyRecQty + BuyTradeQty )          
             Else 0           
          End )            
           Else (CASE WHEN BuyTradeQty < BuyRecQty           
      THEN BuyRecQty - BuyTradeQty             
      ELSE 0 End ) END          
     End )  <> 0           
   Or            
  (Case When ( BuyTradeQty > BuyRecQty )          
            Then BuyTradeQty - BuyRecQty           
     Else           
      Case When ( BuyTradeQty < BuyRecQty )          
      Then (Case When ( SellTradeQty < SellRecQty And (BuyRecQty - BuyTradeQty - SellRecQty + SellTradeQty) < 0 )               
        Then Abs(BuyRecQty - BuyTradeQty - SellRecQty + SellTradeQty)          
             Else 0           
          End )            
           Else (CASE WHEN SellTradeQty < SellRecQty           
      THEN SellRecQty - SellTradeQty             
      ELSE 0 End ) END          
     End ) <> 0 )          
      
 Update #DelAucShort1 Set Cl_Rate = C.Cl_Rate                     
 From Closing C, #Sett_Mst S                     
 Where S.Sett_No = #DelAucShort1.Sett_No                    
 And S.Sett_Type = #DelAucShort1.Sett_Type                    
 And C.Scrip_Cd = #DelAucShort1.Scrip_CD                    
 And C.Series = #DelAucShort1.Series                    
 And SysDate Like ( Select Max(SysDate) From Closing C1                     
       Where C.Scrip_Cd = C1.Scrip_CD                    
                           And C.Series = C1.Series And SysDate > Start_Date And SysDate < Sec_PayIn)                    
                    
 Update #delaucshort1 Set Flag = 1 From MultiCltId M                    
 Where M.Party_Code = #delaucshort1.Party_Code                    
        And Def = 1                     
 Update #delaucshort1 Set Isin=multiisin.Isin From Multiisin                
 Where Multiisin.scrip_cd = #delaucshort1.scrip_cd And MultiIsIn.Series = #delaucshort1.Series      
        And valid = 1       
          
 Select * From #DelAucShort1           
 Where SellShortage > 0 And Flag Like (Case When @Flag = 0 Then '0' When @Flag = 1 Then '1' Else '%' End)       
 Order BY sett_no,sett_type,scrip_cd,series,Party_Code,Short_Name          
          
End

GO
