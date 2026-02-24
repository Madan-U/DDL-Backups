-- Object: PROCEDURE dbo.NseAccValan
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc [dbo].[NseAccValan] (@Sett_No Varchar(7),@Sett_Type Varchar(2)) As           
          
Declare @Service_Tax Numeric(18,4)        
Declare @DelBuyTrans Numeric(18,4)        
Declare @OldSetting Int,    
@TurnOver_Ac Int,    
@Sebi_Turn_Ac Int,    
@Broker_Note_Ac Int,    
@Other_Chrg_Ac Int,    
@Stt_Tax_Ac Int    
        
Set @OldSetting = 0 --'Generate the valan based on the new STT And Service Tax Logic        
     
Select @OldSetting = IsNull(Count(1),0) From Sett_Mst        
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type           
And Start_Date >= 'Nov  1 2006'        
      
Select @Service_Tax= Service_Tax, @DelBuyTrans = DelBuyTrans,    
@TurnOver_Ac = TurnOver_Ac, @Sebi_Turn_Ac = Sebi_Turn_Ac,       
@Broker_Note_Ac = Broker_Note_Ac, @Other_Chrg_Ac = Other_Chrg_Ac,    
@Stt_Tax_Ac = STT_TAX_AC    
From Globals G, Sett_Mst S                
Where Sett_No = @Sett_no And Sett_Type = @Sett_Type                 
And Year_Start_Dt <= Start_Date And Year_End_Dt >= End_Date      
          
Truncate Table NseBillValan    
Insert Into NseBillValan           
select s.party_code,S.Scrip_Cd,sell_buy,pamt =             
isnull((case when sell_buy = 1 then             
 ( case when  Service_chrg = 2 then            
   sum(tradeqty * (N_NETRATE))             
 else              
   sum(tradeqty *  (N_NETRATE) +  NSertax)             
 end ) + ( CASE WHEN dispcharge = 1 THEN            
   ( CASE WHEN Turnover_tax = 1 THEN            
    SUM(turn_tax)             
     else 0 end )              
    else 0 end )            
         + (CASE WHEN dispcharge = 1 THEN            
   ( CASE WHEN Sebi_Turn_tax = 1 THEN            
    SUM(Sebi_Tax)             
     else 0 end )              
    else 0 end )            
         + ( CASE WHEN dispcharge = 1 THEN            
   ( CASE WHEN Insurance_Chrg = 1 THEN            
    SUM(Ins_chrg)             
     else 0 end )              
    else 0 end )            
  + ( CASE WHEN dispcharge = 1 THEN            
   ( CASE WHEN Brokernote = 1 THEN            
    SUM(Broker_chrg)             
     else 0 end )              
    else 0 end )            
  + ( CASE WHEN dispcharge = 1 THEN            
   ( CASE WHEN c2.Other_chrg = 1 OR AuctionPart Like 'F%' THEN            
    SUM(S.other_chrg)             
     else 0 end )              
    else 0 end )            
end),0),            
samt = isnull((case when sell_buy = 2 then             
 ( case when  Service_chrg = 2 then            
   sum(tradeqty *  (N_NETRATE) )             
 else              
   sum(tradeqty *  (N_NETRATE) - NSertax)             
 end ) - ( CASE WHEN dispcharge = 1 THEN            
   ( CASE WHEN Turnover_tax = 1 THEN            
    SUM(turn_tax)             
     else 0 end )              
    else 0 end )            
         - ( CASE WHEN dispcharge = 1 THEN            
   ( CASE WHEN Sebi_Turn_tax = 1 THEN            
    SUM(Sebi_Tax)             
     else 0 end )              
    else 0 end )            
         - ( CASE WHEN dispcharge = 1 THEN            
   ( CASE WHEN Insurance_Chrg = 1 THEN            
    SUM(Ins_chrg)             
     else 0 end )              
    else 0 end )            
  - ( CASE WHEN dispcharge = 1 THEN            
   ( CASE WHEN Brokernote = 1 THEN            
    SUM(Broker_chrg)             
     else 0 end )              
    else 0 end )            
  - ( CASE WHEN dispcharge = 1 THEN            
   ( CASE WHEN c2.Other_chrg = 1 OR AuctionPart Like 'F%' THEN            
    SUM(S.other_chrg)             
     else 0 end )              
    else 0 end )            
end),0),          
PRate = (Case When Sell_Buy = 1 
			  Then Sum(TradeQty*S.Dummy1)
				 Else 0 End),            
SRate = (Case When Sell_Buy = 2 
				Then Sum(TradeQty*S.Dummy1) Else 0 End),          
Brokerage = (Case When @OldSetting = 0 Then        
  (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
     Then (CASE WHEN Sum(NSertax)  = 0 THEN Sum(TradeQty*BrokApplied)-Round(Sum(TradeQty*BrokApplied)*@Service_Tax/(100+@Service_Tax),2)          
    ELSE Sum(TradeQty*BrokApplied)  END )          
     Else Sum(TradeQty*BrokApplied) End)        
 Else        
  (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1        
        Then 0         
        Else Sum(TradeQty*BrokApplied)        
   End)        
 End),         
DelBrokerage = (Case When @OldSetting = 0 Then        
   (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
       Then  (CASE WHEN Sum(NSertax)  = 0 THEN Sum(TradeQty*NBrokApp)-Round(Sum(TradeQty*NBrokApp)*@Service_Tax/(100+@Service_Tax),2)          
      ELSE Sum(TradeQty*NBrokApp)  END )          
       Else Sum(TradeQty*NBrokApp) End)-          
     (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
       Then (CASE WHEN Sum(NSertax)  = 0 THEN Sum(TradeQty*BrokApplied)-Round(Sum(TradeQty*BrokApplied)*@Service_Tax/(100+@Service_Tax),2)          
       ELSE Sum(TradeQty*BrokApplied) END )          
       Else Sum(TradeQty*BrokApplied) End)        
       ELSE        
    (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1        
          Then Sum(TradeQty*NBrokapp)        
          Else Sum(TradeQty*NBrokapp) - Sum(TradeQty*BrokApplied)        
     End)         
  END),         
NSertax = (Case When @OldSetting = 0 Then        
  (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
      Then (CASE WHEN Sum(NSertax)  = 0 THEN Round(Sum(TradeQty*NBrokApp)*@Service_Tax/(100+@Service_Tax),2)           
       ELSE Sum(NSertax) END )          
        Else Sum(NSertax) End)        
  Else        
   (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
         Then 0         
         Else Sum(NSertax)        
    End)        
    End),          
ExNSertax = (Case When Service_chrg = 2           
        Then Sum(NSertax)          
        Else 0           
   End),          
Turn_Tax = (Case WHEN dispcharge = 1           
   THEN (Case WHEN Turnover_tax = 1           
              THEN SUM(turn_tax)             
                 Else 0           
         End)              
          else 0           
     End ),          
Sebi_Tax = (Case WHEN dispcharge = 1           
   THEN (CASE WHEN Sebi_Turn_tax = 1           
              THEN SUM(Sebi_Tax)             
       Else 0           
         End)              
   Else 0           
     End),            
Ins_Chrg = (Case WHEN dispcharge = 1           
   THEN (CASE WHEN Insurance_Chrg = 1           
       THEN SUM(Ins_chrg)             
         Else 0           
         End)              
   Else 0           
     End),          
Broker_Chrg = (CASE WHEN dispcharge = 1           
      THEN (CASE WHEN Brokernote = 1           
          THEN SUM(Broker_chrg)             
                 Else 0           
            End)              
      Else 0           
        End),          
Other_Chrg = (CASE WHEN dispcharge = 1           
     THEN (CASE WHEN c2.Other_chrg = 1 Or AuctionPart Like 'F%'          
                THEN SUM(S.other_chrg)             
                Else 0           
           End)              
     Else 0           
       End),            
TrdAmt = Sum(TradeQty*S.MarketRate),           
DelAmt = (Case When BillFlag in (1,4,5)          
         Then Sum(TradeQty*S.MarketRate)          
        Else 0           
   End),           
sett_no,sett_type,billno,Branch_cd,Cl_Type,TrdType='N',          
PQty = (Case When Sell_Buy = 1 Then Sum(TradeQty) Else 0 End ),           
SQty = (Case When Sell_Buy = 2 Then Sum(TradeQty) Else 0 End ) ,0,  
SERIES          
from settlement_valan S, Client2 C2, OWNER,Client1            
where C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code            
and S.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type           
group by sett_no,sett_type,s.party_code,S.Scrip_Cd,sell_buy,service_chrg,billno,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,Insurance_Chrg,Brokernote,c2.Other_chrg,Branch_cd,Cl_Type,BillFlag,C2.SerTaxMethod,AuctionPart,SERIES  
union all          
select s.party_code,S.Scrip_Cd,sell_buy,pamt =             
isnull((case when sell_buy = 1 then             
 ( case when Service_chrg = 2 then            
   sum(tradeqty *  (NBrokapp) )             
 else              
  sum(tradeqty *  (NBrokApp) +  NSertax ) end )           
 + Sum(Case WHEN dispcharge = 1           
   THEN (CASE WHEN Insurance_Chrg = 1           
       THEN (Ins_chrg)             
            Else 0           
         End)              
   Else 0           
     End)          
end),0),          
samt =        
isnull((case when sell_buy = 2 then             
 ( case when Service_chrg = 2 then            
   sum(tradeqty *  (NBrokapp) )             
 else              
  sum(tradeqty *  (NBrokApp) + NSertax  )  end )           
 + Sum(Case WHEN dispcharge = 1           
   THEN (CASE WHEN Insurance_Chrg = 1           
       THEN (Ins_chrg)             
            Else 0           
         End)              
   Else 0           
     End)          
end),0),          
PRate = (Case When Sum(Case When Sell_buy = 1         
                                           Then TradeQty*MarketRate -TradeQty*s.dummy1         
   Else -TradeQty*MarketRate +TradeQty*s.dummy1         
                                    End) < 0         
                    Then Abs(Sum(Case When Sell_buy = 1         
                                                Then TradeQty*MarketRate -TradeQty*s.dummy1         
                                                Else -TradeQty*MarketRate +TradeQty*s.dummy1         
                                         End))        
                    Else 0         
            End),        
SRate = (Case When Sum(Case When Sell_buy = 1         
                                           Then TradeQty*MarketRate -TradeQty*s.dummy1         
                                           Else -TradeQty*MarketRate +TradeQty*s.dummy1         
                                    End) > 0         
                    Then Sum(Case When Sell_buy = 1         
                                          Then TradeQty*MarketRate -TradeQty*s.dummy1         
                                          Else -TradeQty*MarketRate +TradeQty*s.dummy1         
                                   End)         
                    Else 0         
            End),        
Brokerage = (Case When @OldSetting = 0 Then        
  (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
     Then (CASE WHEN Sum(NSertax)  = 0 THEN Sum(TradeQty*BrokApplied)-Round(Sum(TradeQty*BrokApplied)*@Service_Tax/(100+@Service_Tax),2)          
    ELSE Sum(TradeQty*BrokApplied)  END )          
     Else Sum(TradeQty*BrokApplied) End)        
 Else        
  (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1        
        Then 0         
        Else Sum(TradeQty*BrokApplied)        
   End)        
 End),         
DelBrokerage = (Case When @OldSetting = 0 Then        
   (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
       Then  (CASE WHEN Sum(NSertax)  = 0 THEN Sum(TradeQty*NBrokApp)-Round(Sum(TradeQty*NBrokApp)*@Service_Tax/(100+@Service_Tax),2)          
      ELSE Sum(TradeQty*NBrokApp)  END )          
       Else Sum(TradeQty*NBrokApp) End)-          
     (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
       Then (CASE WHEN Sum(NSertax)  = 0 THEN Sum(TradeQty*BrokApplied)-Round(Sum(TradeQty*BrokApplied)*@Service_Tax/(100+@Service_Tax),2)          
       ELSE Sum(TradeQty*BrokApplied) END )          
       Else Sum(TradeQty*BrokApplied) End)        
       ELSE        
    (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1        
          Then Sum(TradeQty*NBrokapp)        
          Else Sum(TradeQty*NBrokapp) - Sum(TradeQty*BrokApplied)        
     End)         
  END),         
NSertax = (Case When @OldSetting = 0 Then        
  (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
      Then (CASE WHEN Sum(NSertax)  = 0 THEN Round(Sum(TradeQty*NBrokApp)*@Service_Tax/(100+@Service_Tax),2)           
       ELSE Sum(NSertax) END )          
        Else Sum(NSertax) End)        
  Else        
   (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
       Then 0         
         Else Sum(NSertax)        
    End)        
    End),          
ExNSertax = (Case When Service_chrg = 2           
        Then Sum(NSertax)          
        Else 0           
   End),          
Turn_Tax = 0,          
Sebi_Tax = 0,            
Ins_Chrg = Sum(Case WHEN dispcharge = 1           
   THEN (CASE WHEN Insurance_Chrg = 1           
       THEN (Ins_chrg)             
            Else 0           
         End)              
   Else 0           
     End),          
Broker_Chrg = 0,          
Other_Chrg = 0 ,          
TrdAmt = SUM(TradeQty*MarketRate),      
DelAmt = SUM(TradeQty*MarketRate),      
sett_no,sett_type,billno,Branch_cd,Cl_Type,TrdType='I',          
PQty = (Case When Sell_Buy = 1 Then Sum(TradeQty) Else 0 End ),           
SQty = (Case When Sell_Buy = 2 Then Sum(TradeQty) Else 0 End ),0,SERIES from Isettlement_valan S, Client2 C2 ,Client1, Owner            
where C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code           
and S.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type           
group by sett_no,sett_type,s.party_code,S.Scrip_Cd,sell_buy,service_chrg,billno,Branch_cd,Cl_Type,BillFlag,SerTaxMethod,SERIES  
      
if @OldSetting > 0        
Begin         
 Update NseBillValan Set             
 Service_Tax = Round(((DelBrokerage+    
        (Case When @TurnOver_Ac = 1    
       Then Turn_Tax    
              Else 0     
         End)+    
        (Case When @Sebi_Turn_Ac = 1    
       Then Sebi_Tax    
              Else 0     
         End)+    
        (Case When @Broker_Note_Ac = 1    
       Then Broker_Chrg    
              Else 0     
         End)+    
        (Case When @Other_Chrg_Ac = 1    
       Then NseBillValan.Other_Chrg    
              Else 0     
         End)+    
        (Case When @Stt_Tax_Ac = 1    
       Then NseBillValan.Other_Chrg    
              Else 0     
         End)) * @Service_Tax /(100 + @Service_Tax)),2),          
 DelBrokerage = DelBrokerage - Round(((DelBrokerage+    
         (Case When @TurnOver_Ac = 1    
        Then Turn_Tax    
               Else 0     
          End)+    
         (Case When @Sebi_Turn_Ac = 1    
        Then Sebi_Tax    
               Else 0     
          End)+    
         (Case When @Broker_Note_Ac = 1    
        Then Broker_Chrg    
               Else 0     
          End)+    
         (Case When @Other_Chrg_Ac = 1    
        Then NseBillValan.Other_Chrg    
               Else 0     
          End)+    
        (Case When @Stt_Tax_Ac = 1    
       Then NseBillValan.Other_Chrg    
              Else 0     
         End)) * @Service_Tax /(100 + @Service_Tax)),2)           
 Where Sett_No = @Sett_No and Sett_Type = @Sett_Type             
 And Service_Tax = 0 And DelBrokerage > 0    
 and Party_Code In (Select Party_Code From Client2 c2, Client1 c1     
 Where C1.Cl_Code = C2.Cl_Code And Service_chrg = 1 And SerTaxMethod = 1 )    
    
End    

Insert Into NseBillValan
Select S.CD_party_code,s.CD_scrip_cd,sell_buy=1,  
pamt=Sum(CD_TrdBuyBrokerage+CD_TrdSellBrokerage+CD_DelBuyBrokerage+CD_DelSellBrokerage)  
     +(case When Service_chrg <> 2           
           Then Sum(CD_TrdBuySerTax+CD_TrdSellSerTax+CD_DelBuySerTax+CD_DelSellSerTax)          
           Else 0           
         End) ,          
Samt=0,          
PRate=0,      
SRate=0,          
Brokerage=(case When C2.service_chrg = 1 And C2.sertaxmethod = 1           
                Then (case When Sum(CD_TrdBuySerTax+CD_TrdSellSerTax)=0   
             Then Sum(CD_TrdBuyBrokerage+CD_TrdSellBrokerage)  
                       -round(sum(CD_TrdBuyBrokerage+CD_TrdSellBrokerage)*@service_tax/(100+@service_tax),2)  
         Else Sum(CD_TrdBuyBrokerage+CD_TrdSellBrokerage)    
        End )          
                Else Sum(CD_TrdBuyBrokerage+CD_TrdSellBrokerage)   
    End),          
Delbrokerage=(case When C2.service_chrg = 1 And C2.sertaxmethod = 1           
                Then (case When Sum(CD_DelBuySerTax+CD_DelSellSerTax)=0   
             Then Sum(CD_DelBuyBrokerage+CD_DelSellBrokerage)  
                       -round(sum(CD_DelBuyBrokerage+CD_DelSellBrokerage)*@service_tax/(100+@service_tax),2)  
         Else Sum(CD_DelBuyBrokerage+CD_DelSellBrokerage)    
        End )          
                Else Sum(CD_DelBuyBrokerage+CD_DelSellBrokerage)   
    End),        
Nsertax = (case When C2.service_chrg = 1 And C2.sertaxmethod = 1           
      Then (Case When Sum(CD_TrdBuySerTax+CD_TrdSellSerTax) = 0   
      Then round(sum(CD_TrdBuyBrokerage+CD_TrdSellBrokerage)*@service_tax/(100+@service_tax),2)       
             Else Sum(CD_TrdBuySerTax+CD_TrdSellSerTax)   
        End)          
                Else Sum(CD_TrdBuySerTax+CD_TrdSellSerTax)   
    End) +  
   (case When C2.service_chrg = 1 And C2.sertaxmethod = 1           
      Then (Case When Sum(CD_DelBuySerTax+CD_DelSellSerTax) = 0   
      Then round(sum(CD_DelBuyBrokerage+CD_DelSellBrokerage)*@service_tax/(100+@service_tax),2)        
             Else Sum(CD_DelBuySerTax+CD_DelSellSerTax)   
        End)          
                Else Sum(CD_DelBuySerTax+CD_DelSellSerTax)   
   End),  
Exnsertax = (case When Service_chrg = 2           
           Then Sum(CD_TrdBuySerTax+CD_TrdSellSerTax+CD_DelBuySerTax+CD_DelSellSerTax)          
           Else 0           
         End),  
Turn_tax = 0,          
Sebi_tax = 0,            
Ins_chrg =0,          
Broker_chrg = 0,          
Other_chrg = 0 ,          
Trdamt = 0 ,           
Delamt = 0,            
cd_Sett_no,cd_sett_type,billno=0,branch_cd,cl_type,trdtype='N',          
Pqty = 0,           
Sqty = 0,0, cd_SERIES   
From Charges_Detail S, Client2 C2 ,client1, Owner            
Where C2.party_code = S.cd_party_code And Client1.cl_code = C2.cl_code            
And S.cd_sett_no = @sett_no And S.cd_sett_type = @sett_type           
Group By cd_Sett_no,cd_sett_type,s.cd_party_code,s.cd_scrip_cd,  
service_chrg,branch_cd,cl_type,sertaxmethod, cd_SERIES         
      
DELETE FROM TBL_NSEVALAN  
Where Sett_No = @Sett_No and Sett_Type = @Sett_Type  
  
INSERT INTO TBL_NSEVALAN   
SELECT SETT_NO, SETT_TYPE, PARTY_CODE, SCRIP_CD, SERIES, TOTAMOUNT = SUM(PAMT-SAMT), MKTAMOUNT = SUM(PRATE - SRATE),  
BROKERAGE = SUM(BROKERAGE), DELBROKERAGE = SUM(DELBROKERAGE), Service_Tax = SUM(Service_Tax),  
Exservice_Tax = SUM(Exservice_Tax), Turn_Tax = SUM(Turn_Tax), Sebi_Tax = SUM(Sebi_Tax),  
Ins_Chrg = SUM(Ins_Chrg), Broker_Chrg = SUM(Broker_Chrg), Other_Chrg = SUM(Other_Chrg),   
Trdamt = SUM(Trdamt), Delamt = SUM(Delamt), Pqty = SUM(Pqty), Sqty = SUM(Sqty)  
FROM NseBillValan  
Where Sett_No = @Sett_No and Sett_Type = @Sett_Type  
GROUP BY SETT_NO, SETT_TYPE, PARTY_CODE, SCRIP_CD, SERIES

GO
