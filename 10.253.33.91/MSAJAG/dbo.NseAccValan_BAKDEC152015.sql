-- Object: PROCEDURE dbo.NseAccValan_BAKDEC152015
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc NseAccValan (@Sett_No Varchar(7),@Sett_Type Varchar(2)) As           
          
Declare @Service_Tax Numeric(18,4)          
          
Select @Service_Tax= Service_Tax From Globals G, Sett_Mst S          
Where Sett_No = @Sett_no And Sett_Type = @Sett_Type           
And Year_Start_Dt <= Start_Date And Year_End_Dt >= End_Date          
          
--Select @Service_Tax          
          
--Delete From NseBillValan Where Sett_No = @Sett_No and Sett_Type = @Sett_Type           
truncate table NseBillValan    
Insert Into NseBillValan           
select s.party_code,S.Scrip_Cd,sell_buy,pamt =             
isnull((case when sell_buy = 1 then             
 ( case when  Service_chrg = 2 then            
   sum(tradeqty * (N_NetRate))             
 else              
   sum(tradeqty *  (N_NetRate) +  NSertax)             
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
   sum(tradeqty *  (N_NetRate) )             
 else              
   sum(tradeqty *  (N_NetRate) - NSertax)             
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
PRate = (Case When Sell_Buy = 1 Then Sum(TradeQty*S.Dummy1) Else 0 End),            
SRate = (Case When Sell_Buy = 2 Then Sum(TradeQty*S.Dummy1) Else 0 End),          
Brokerage = (Case When BillFlag in (2,3) Then (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
                    Then (CASE WHEN Sum(NSertax)  = 0           
                               THEN Sum(TradeQty*NBrokapp)-Round(Sum(TradeQty*NBrokapp)*@Service_Tax/(100+@Service_Tax),2)          
                               ELSE Sum(TradeQty*NBrokapp)            
                         END )          
                   Else Sum(TradeQty*NBrokapp)           
              End) Else 0 End),          
          
DelBrokerage = (Case When BillFlag in (1,4,5) Then (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
                       Then  (CASE WHEN Sum(NSertax)  = 0           
                                   THEN Sum(TradeQty*NBrokApp)-Round(Sum(TradeQty*NBrokApp)*@Service_Tax/(100+@Service_Tax),2)          
                                   ELSE Sum(TradeQty*NBrokApp)            
                             END )          
                       Else Sum(TradeQty*NBrokApp)           
                 End) Else 0 End) ,          
          
NSertax = (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
    Then (CASE WHEN Sum(NSertax)  = 0 THEN Round(Sum(TradeQty*NBrokApp)*@Service_Tax/(100+@Service_Tax),2)           
   ELSE Sum(NSertax) END )          
    Else Sum(NSertax) End),          
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
SQty = (Case When Sell_Buy = 2 Then Sum(TradeQty) Else 0 End ) ,0          
from settlement S, Client2 C2, OWNER,Client1            
where C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code            
and S.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type           
group by sett_no,sett_type,s.party_code,S.Scrip_Cd,sell_buy,service_chrg,billno,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,          
Insurance_Chrg,Brokernote,c2.Other_chrg,Branch_cd,Cl_Type,BillFlag,C2.SerTaxMethod,AuctionPart            

IF (SELECT ISNULL(COUNT(1),0) FROM NSEBILLVALAN WHERE Sett_No = @Sett_No and Sett_Type = @Sett_Type) > 0 
BEGIN
	EXEC PROC_NSEVALAN_DETAIL @SETT_NO, @SETT_TYPE
END

  INSERT INTO NSEBILLVALAN        
  SELECT   S.CD_PARTY_CODE,        
           S.CD_SCRIP_CD,        
           SELL_BUY = 1,        
           PAMT = SUM(CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE + CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE) + (CASE         
                                                                                                                WHEN SERVICE_CHRG <> 2 THEN SUM(CD_TRDBUYSERTAX + CD_TRDSELLSERTAX + CD_DELBUYSERTAX + CD_DELSELLSERTAX)        
                                                                                                                ELSE 0        
                                                                                                              END),        
           SAMT = 0,        
           PRATE = 0,        
           SRATE = 0,        
           BROKERAGE = (CASE         
                          WHEN C2.SERVICE_CHRG = 1        
                               AND C2.SERTAXMETHOD = 1 THEN (CASE         
                                                               WHEN SUM(CD_TRDBUYSERTAX + CD_TRDSELLSERTAX) = 0 THEN SUM(CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE) - ROUND(SUM(CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE) * @SERVICE_TAX / (100 + @SERVICE_TAX),2)        
                                               ELSE SUM(CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE)        
                              END)        
                          ELSE SUM(CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE)        
                        END),        
           DELBROKERAGE = (CASE         
                             WHEN C2.SERVICE_CHRG = 1        
                                  AND C2.SERTAXMETHOD = 1 THEN (CASE         
                                                                  WHEN SUM(CD_DELBUYSERTAX + CD_DELSELLSERTAX) = 0 THEN SUM(CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE) - ROUND(SUM(CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE) * @SERVICE_TAX / (100 + @SERVICE_TAX),2)        
                                                                  ELSE SUM(CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE)        
                                                                END)        
                             ELSE SUM(CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE)        
                           END),        
           NSERTAX = (CASE         
                        WHEN C2.SERVICE_CHRG = 1        
                             AND C2.SERTAXMETHOD = 1 THEN (CASE         
                                                             WHEN SUM(CD_TRDBUYSERTAX + CD_TRDSELLSERTAX) = 0 THEN ROUND(SUM(CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE) * @SERVICE_TAX / (100 + @SERVICE_TAX),        
                                                                                                                         2)        
                                                             ELSE SUM(CD_TRDBUYSERTAX + CD_TRDSELLSERTAX)        
                                                           END)        
                        ELSE SUM(CD_TRDBUYSERTAX + CD_TRDSELLSERTAX)        
                      END) + (CASE         
                                WHEN C2.SERVICE_CHRG = 1        
                                     AND C2.SERTAXMETHOD = 1 THEN (CASE         
                                                                     WHEN SUM(CD_DELBUYSERTAX + CD_DELSELLSERTAX) = 0 THEN ROUND(SUM(CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE) * @SERVICE_TAX / (100 + @SERVICE_TAX),        
                                                                                                                                 2)        
                                                                     ELSE SUM(CD_DELBUYSERTAX + CD_DELSELLSERTAX)        
                                                                   END)        
                                ELSE SUM(CD_DELBUYSERTAX + CD_DELSELLSERTAX)        
                              END),        
           EXNSERTAX = (CASE         
                          WHEN SERVICE_CHRG = 2 THEN SUM(CD_TRDBUYSERTAX + CD_TRDSELLSERTAX + CD_DELBUYSERTAX + CD_DELSELLSERTAX)        
                          ELSE 0        
                        END),        
           TURN_TAX = 0,        
           SEBI_TAX = 0,        
           INS_CHRG = 0,        
           BROKER_CHRG = 0,        
           OTHER_CHRG = 0,        
           TRDAMT = 0,        
           DELAMT = 0,        
           CD_SETT_NO,        
           CD_SETT_TYPE,        
           BILLNO = 0,        
           BRANCH_CD,        
           CL_TYPE,        
           TRDTYPE = 'N',        
           PQTY = 0,        
           SQTY = 0,        
           0        
  FROM     CHARGES_DETAIL S,        
           CLIENT2 C2,        
           CLIENT1,        
           OWNER        
  WHERE    C2.PARTY_CODE = S.CD_PARTY_CODE        
           AND CLIENT1.CL_CODE = C2.CL_CODE        
           AND S.CD_SETT_NO = @SETT_NO        
           AND S.CD_SETT_TYPE = @SETT_TYPE        
  GROUP BY CD_SETT_NO,CD_SETT_TYPE,S.CD_PARTY_CODE,S.CD_SCRIP_CD,        
           SERVICE_CHRG,BRANCH_CD,CL_TYPE,SERTAXMETHOD,        
           CD_SERIES  
  
Insert Into NseBillValan  
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
PRate = 0,          
SRate = 0,          
Brokerage = (Case when BillFlag in (2,3) Then (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
    Then (CASE WHEN Sum(NSertax)  = 0 THEN Sum(TradeQty*NBrokapp)-Round(Sum(TradeQty*NBrokapp)*@Service_Tax/(100+@Service_Tax),2)          
   ELSE Sum(TradeQty*NBrokapp)  END )          
    Else Sum(TradeQty*NBrokapp) End) Else 0 End),          
DelBrokerage = (Case when BillFlag in (1,4,5) Then (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
    Then  (CASE WHEN Sum(NSertax)  = 0 THEN Sum(TradeQty*NBrokApp)-Round(Sum(TradeQty*NBrokApp)*@Service_Tax/(100+@Service_Tax),2)          
   ELSE Sum(TradeQty*NBrokApp)  END )          
    Else Sum(TradeQty*NBrokApp) End) Else 0 End),          
NSertax = (Case When C2.Service_Chrg = 1 And C2.SerTaxMethod = 1           
    Then (CASE WHEN Sum(NSertax)  = 0 THEN Round(Sum(TradeQty*NBrokApp)*@Service_Tax/(100+@Service_Tax),2)           
   ELSE Sum(NSertax) END )          
    Else Sum(NSertax) End),          
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
TrdAmt = 0 ,           
DelAmt = 0,            
sett_no,sett_type,billno,Branch_cd,Cl_Type,TrdType='I',          
PQty = (Case When Sell_Buy = 1 Then Sum(TradeQty) Else 0 End ),           
SQty = (Case When Sell_Buy = 2 Then Sum(TradeQty) Else 0 End ),0 from ISettlement S, Client2 C2 ,Client1, Owner            
where C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code           
and S.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type           
group by sett_no,sett_type,s.party_code,S.Scrip_Cd,sell_buy,service_chrg,billno,Branch_cd,Cl_Type,BillFlag,SerTaxMethod

GO
