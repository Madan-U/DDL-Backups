-- Object: PROCEDURE dbo.StampDuty_Charges
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

Create Proc StampDuty_Charges 
(@Sauda_Date Varchar(11), @Sett_Type Varchar(2), @FromParty Varchar(10), @ToParty Varchar(10))
As

Update Settlement Set
Broker_Chrg = (Case When C.Broker_Note > 0 
                    Then (Case When C1.Cl_Type = 'PRO' 
		               Then TradeQty*MarketRate*ProStampDuty/100
		               Else 	
			           (Case When BillFlag not in (4,5) 
                                         Then TradeQty*MarketRate*TrdStampDuty/100
                                         Else TradeQty*MarketRate*DelStampDuty/100
                               	    End)
			  End)
		    Else 0	
               End)  
From State_Master S, Client1 C1, Client2 C2, ClientTaxes_New C, Sett_Mst SM
Where C1.Cl_Code = C2.Cl_Code
And C.Party_Code = C2.Party_Code
And Sauda_Date Between Fromdate And Todate
And S.State = C1.L_State
And C2.Party_Code = Settlement.Party_Code
And Trade_No Not Like '%C%'
And AuctionPart Not In ('AP', 'AR', 'FP', 'FC', 'FS', 'FL', 'FA')
And C.Broker_Note > 0 
And Trans_Cat = 'TRD'
And Settlement.Sett_No = SM.Sett_No
And Settlement.Sett_Type = SM.Sett_Type
And @Sauda_Date Between Start_Date And End_Date
And SM.Sett_Type = @Sett_Type

Update Settlement Set
Broker_Chrg = (Case When C.Broker_Note > 0 
                    Then (Case When C1.Cl_Type = 'PRO' 
		               Then TradeQty*MarketRate*ProStampDuty/100
		               Else 	
			           (Case When BillFlag not in (4,5) 
                                         Then TradeQty*MarketRate*TrdStampDuty/100
                                         Else TradeQty*MarketRate*DelStampDuty/100
                               	    End)
			  End)
		    Else 0	
               End)  
From State_Master S, Client1 C1, Client2 C2, ClientTaxes_New C, Owner O, Sett_Mst SM
Where C1.Cl_Code = C2.Cl_Code
And C.Party_Code = C2.Party_Code
And Sauda_Date Between Fromdate And Todate
And S.State = O.State
And C2.Party_Code = Settlement.Party_Code
And Trade_No Not Like '%C%'
And AuctionPart Not In ('AP', 'AR', 'FP', 'FC', 'FS', 'FL', 'FA')
And C.Broker_Note > 0 
And Trans_Cat = 'TRD'
And C1.L_State Not In ( Select State From State_Master )
And Settlement.Sett_No = SM.Sett_No
And Settlement.Sett_Type = SM.Sett_Type
And @Sauda_Date Between Start_Date And End_Date
And SM.Sett_Type = @Sett_Type

Update ISettlement Set
Broker_Chrg = (Case When C.Broker_Note > 0 
                    Then (Case When C1.Cl_Type = 'PRO' 
		               Then TradeQty*MarketRate*ProStampDuty/100
		               Else TradeQty*MarketRate*DelStampDuty/100
			  End)
		    Else 0	
               End)  
From State_Master S, Client1 C1, Client2 C2, ClientTaxes_New C, Sett_Mst SM
Where C1.Cl_Code = C2.Cl_Code
And C.Party_Code = C2.Party_Code
And Sauda_Date Between Fromdate And Todate
And S.State = C1.L_State
And C2.Party_Code = ISettlement.Party_Code
And Trade_No Not Like '%C%'
And AuctionPart Not In ('AP', 'AR', 'FP', 'FC', 'FS', 'FL', 'FA')
And C.Broker_Note > 0 
And Trans_Cat = 'TRD'
And ISettlement.Sett_No = SM.Sett_No
And ISettlement.Sett_Type = SM.Sett_Type
And @Sauda_Date Between Start_Date And End_Date
And SM.Sett_Type = @Sett_Type

Update ISettlement Set
Broker_Chrg = (Case When C.Broker_Note > 0 
                    Then (Case When C1.Cl_Type = 'PRO' 
		               Then TradeQty*MarketRate*ProStampDuty/100
		               Else TradeQty*MarketRate*DelStampDuty/100
			  End)
		    Else 0	
               End)  
From State_Master S, Client1 C1, Client2 C2, ClientTaxes_New C, Owner O, Sett_Mst SM
Where C1.Cl_Code = C2.Cl_Code
And C.Party_Code = C2.Party_Code
And Sauda_Date Between Fromdate And Todate
And S.State = O.State
And C2.Party_Code = ISettlement.Party_Code
And Trade_No Not Like '%C%'
And AuctionPart Not In ('AP', 'AR', 'FP', 'FC', 'FS', 'FL', 'FA')
And C.Broker_Note > 0 
And Trans_Cat = 'TRD'
And C1.L_State Not In ( Select State From State_Master )
And ISettlement.Sett_No = SM.Sett_No
And ISettlement.Sett_Type = SM.Sett_Type
And @Sauda_Date Between Start_Date And End_Date
And SM.Sett_Type = @Sett_Type

GO
