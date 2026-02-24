-- Object: PROCEDURE dbo.CALCULATE_STAMP_DUTY
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  PROC CALCULATE_STAMP_DUTY            
(                  
 @Sett_Type Varchar(2),            
 @Sauda_Date Varchar(11),            
 @FromParty Varchar(10),                   
 @ToParty Varchar(10)                  
)            
AS            
            
Declare @Sett_No Varchar(7)            
            
Select @Sett_No = Sett_No From Sett_Mst Where Sett_Type = @Sett_Type            
And @Sauda_Date Between Start_Date And End_Date            
            
Begin Tran            

UPDATE SETTLEMENT SET Broker_Chrg = 0          
WHERE SETT_NO = @SETT_NO           
AND SETT_TYPE = @SETT_TYPE          
AND TRADE_NO NOT LIKE '%C%'          
AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')          
And Party_Code Between @FromParty And @ToParty          
And Exists (Select ClientTaxes_New.Party_Code From ClientTaxes_New            
Where SETTLEMENT.Party_Code = ClientTaxes_New.Party_Code            
And @Sauda_Date Between ClientTaxes_New.FromDate And ClientTaxes_New.ToDate            
And Broker_Note = 0 )
          
UPDATE SETTLEMENT SET Broker_Chrg = 
	(CASE WHEN CL_TYPE = 'PRO' THEN TRADEQTY*MARKETRATE*PROSTAMPDUTY/100
	ELSE 
        TRADEQTY*MARKETRATE*(CASE WHEN BILLFLAG IN (2,3)           
        THEN TRDSTAMPDUTY/100 ELSE DELSTAMPDUTY/100 END)          
	END)
FROM STATE_MASTER, CLIENT1 C1, CLIENT2 C2          
WHERE C1.CL_CODE = C2.CL_CODE          
AND C2.PARTY_CODE = SETTLEMENT.PARTY_CODE             
and l_state=state  
AND SETT_NO = @SETT_NO           
AND SETT_TYPE = @SETT_TYPE          
AND TRADE_NO NOT LIKE '%C%'          
AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')          
And C2.Party_Code Between @FromParty And @ToParty          
And Not Exists (Select ClientTaxes_New.Party_Code From ClientTaxes_New            
Where C2.Party_Code = ClientTaxes_New.Party_Code            
And @Sauda_Date Between ClientTaxes_New.FromDate And ClientTaxes_New.ToDate            
And Broker_Note = 0 ) 

Select Sett_no, Sett_Type, S.Party_Code, Broker_Note = Sum(Broker_Chrg),             
L_State, Turnover = Sum(TradeQty*MarketRate),            
RoundedTurnover = Sum(TradeQty*MarketRate),            
ToBeChrg_StampDuty = Sum(Broker_Chrg)            
into #stamp            
From Settlement S, Client1 C1, Client2 C2            
Where Sett_No = @Sett_No            
And Sett_Type = @Sett_Type            
And C1.Cl_Code = C2.Cl_Code            
And C2.Party_Code = S.Party_Code            
And Trade_No Not Like '%C%'            
And TradeQty > 0 And MarketRate > 0             
And AuctionPart Not In ('AP', 'AR', 'FP', 'FL', 'FC', 'FP', 'FA', 'FS')            
And L_State in (Select State From State_Master Where Min_Multiplier > 0 Or Maximum_Limit > 0)            
And C2.Party_Code Between @FromParty And @ToParty          
Group By Sett_no, Sett_Type, S.Party_Code, L_State            

            
Update #Stamp Set RoundedTurnover = Pradnya.DBO.RoundedTurnover(TurnOver, For_TurnOver)            
From State_master Where L_State = State            
And For_TurnOver > 0            
            
Update #Stamp Set             
ToBeChrg_StampDuty = (Case When RoundedTurnover/For_TurnOver * Min_Multiplier > Maximum_Limit And Maximum_Limit > 0             
      Then Maximum_Limit            
      When RoundedTurnover/For_TurnOver * Min_Multiplier > Broker_Note            
      Then RoundedTurnover/For_TurnOver * Min_Multiplier            
      When Broker_Note > Maximum_Limit And Maximum_Limit > 0              
      Then Maximum_Limit            
      Else Broker_Note             
        End)            
From State_master Where L_State = State            
And For_TurnOver > 0            
            
Update Settlement Set Broker_Chrg = 0             
Where Exists (Select Party_Code From #Stamp            
Where Settlement.Sett_No = @Sett_No            
And Settlement.Sett_Type = @Sett_Type            
And #Stamp.Sett_No = Settlement.Sett_No            
And #Stamp.Sett_Type = Settlement.Sett_Type            
And #Stamp.Party_Code = Settlement.Party_Code)            
            
Delete From #Stamp            
Where Exists (Select Party_Code From ClientTaxes_New            
Where #Stamp.Party_Code = ClientTaxes_New.Party_Code            
And @Sauda_Date Between ClientTaxes_New.FromDate And ClientTaxes_New.ToDate            
And Broker_Note = 0 )            
            
Select Sett_No, Sett_Type, Party_Code,             
TradeScripSell = Min(RTrim(Trade_No)+RTrim(Scrip_CD)+Convert(Varchar,Sell_Buy))            
Into #SettStamp From Settlement            
Where Settlement.Sett_No = @Sett_No            
And Settlement.Sett_Type = @Sett_Type            
And Exists (Select Party_Code From #Stamp            
Where #Stamp.Sett_No = Settlement.Sett_No        
And #Stamp.Sett_Type = Settlement.Sett_Type            
And #Stamp.Party_Code = Settlement.Party_Code)            
Group By Sett_No, Sett_Type, Party_Code            
            
Update Settlement Set Broker_Chrg = ToBeChrg_StampDuty            
From #Stamp, #SettStamp            
Where Settlement.Sett_No = @Sett_No            
And Settlement.Sett_Type = @Sett_Type            
And #Stamp.Sett_No = Settlement.Sett_No            
And #Stamp.Sett_Type = Settlement.Sett_Type            
And #Stamp.Party_Code = Settlement.Party_Code            
And #SettStamp.Sett_No = Settlement.Sett_No            
And #SettStamp.Sett_Type = Settlement.Sett_Type            
And #SettStamp.Party_Code = Settlement.Party_Code            
And #SettStamp.TradeScripSell = RTrim(Trade_No)+RTrim(Scrip_CD)+Convert(Varchar,Sell_Buy)            
            
Commit

GO
