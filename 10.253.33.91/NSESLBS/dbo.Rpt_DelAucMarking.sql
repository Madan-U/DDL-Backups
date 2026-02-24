-- Object: PROCEDURE dbo.Rpt_DelAucMarking
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE  Proc Rpt_DelAucMarking (@Sett_No Varchar(7), @Sett_Type Varchar(2)) As   
Truncate table DelAucNew  
Insert Into DelAucNew  
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,  
BuyTradeQty = BuyQty, BuyRecQty=Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) ,  
SellTradeQty = SellQty , SellRecQty=Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)   
from Client2 C2,Client1 C1, DelCltView d Left Outer Join DelTrans de   
On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd  
and de.series = d.series and de.party_code = d.party_code and filler2 = 1 And ShareType <> 'AUCTION' )  
Where D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code And D.Sett_no = @Sett_No And D.Sett_type = @Sett_Type  
Group By d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,BuyQty,SellQty  
Having ( BuyQty <> Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End)   
    Or SellQty <> Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End) )  
  
Insert Into DelAucNew  
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,  
BuyTradeQty = 0, BuyRecQty=Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) ,  
SellTradeQty = 0, SellRecQty=Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End)  
from Client2 C2,Client1 C1 , DelTrans d   
Where D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code   
And D.Sett_no = @Sett_No And D.Sett_type = @Sett_Type  
and filler2 = 1 And ShareType <> 'AUCTION'  
And D.Party_Code Not in ( Select Party_Code From DeliveryClt De  
     Where de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd  
     and de.series = d.series and de.party_code = d.party_code  )  
Group By d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series  
Having Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) <>   
Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End)  
  
If @Sett_Type <> 'W'   
Begin   
 Truncate table DelAucShort  
 Insert Into DelAucShort  
 Select Sett_no,Sett_Type,Party_Code,Short_Name,Scrip_Cd,Series,BuyTradeQty,BuyRecQty,SellTradeQty,SellRecQty,  
 BuyShortage=(Case When ( BuyTradeQty - SellTradeQty - BuyRecQty + SellRecQty ) > 0   
            Then ( BuyTradeQty - SellTradeQty - BuyRecQty + SellRecQty )  
     Else 0 End ) ,  
 SellShortage=(Case When ( BuyTradeQty - SellTradeQty - BuyRecQty + SellRecQty ) < 0   
            Then Abs( BuyTradeQty - SellTradeQty - BuyRecQty + SellRecQty )  
     Else 0 End )   
 From DelAucNew  
 Where ( BuyTradeQty - SellTradeQty - BuyRecQty + SellRecQty ) <> 0   
End  
Else  
Begin  
 Truncate table DelAucShort  
 Insert Into DelAucShort  
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
     End )   
 From DelAucNew  
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
End

GO
