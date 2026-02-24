-- Object: PROCEDURE dbo.Proc_Service_Tax_Update
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc Proc_Service_Tax_Update
(    
 @Sett_Type Varchar(2),     
 @Sauda_Date Varchar(11),     
 @FromParty Varchar(10),     
 @ToParty Varchar(10)    
)     
As 
Update Settlement Set 
Service_Tax = ((TradeQty*Brokapplied)+
	      (Case When TurnOver_Ac = 1 And Turnover_tax = 1 
		    Then Turn_Tax
	            Else 0 
	       End)+
	      (Case When Sebi_Turn_Ac = 1 And Sebi_Turn_tax = 1 
		    Then Sebi_Tax
	            Else 0 
	       End)+
	      (Case When Broker_Note_Ac = 1 And BrokerNote = 1 
		    Then Broker_Chrg
	            Else 0 
	       End)+
	      (Case When Other_Chrg_Ac = 1 And C2.Other_chrg = 1
		    Then Settlement.Other_Chrg
	            Else 0 
	       End)+
	      (Case When STT_TAX_AC = 1 And C2.INSURANCE_CHRG = 1
		    Then Settlement.Other_Chrg
	            Else 0 
	       End)) * G.Service_Tax/100,
NSerTax    = ((TradeQty*NBrokapp)+
	      (Case When TurnOver_Ac = 1 And Turnover_tax = 1 
		    Then Turn_Tax
	            Else 0 
	       End)+
	      (Case When Sebi_Turn_Ac = 1 And Sebi_Turn_tax = 1 
		    Then Sebi_Tax
	            Else 0 
	       End)+
	      (Case When Broker_Note_Ac = 1 And BrokerNote = 1 
		    Then Broker_Chrg
	            Else 0 
	       End)+
	      (Case When Other_Chrg_Ac = 1 And C2.Other_chrg = 1
		    Then Settlement.Other_Chrg
	            Else 0 
	       End)+
	      (Case When STT_TAX_AC = 1 And C2.INSURANCE_CHRG = 1
		    Then Settlement.Other_Chrg
	            Else 0 
	       End)) * G.Service_Tax/100
From Globals G, Client2 C2
Where Sett_Type = @Sett_Type
And Sauda_Date Like @Sauda_Date + '%'
And Settlement.Party_Code = C2.Party_Code
And C2.Party_Code BetWeen @FromParty And @ToParty
And AuctionPart Not Like 'A%' And AuctionPart Not Like 'F%'
And 1 <> (Case When Service_chrg = 1 And SerTaxMethod = 1 
	       Then 1 Else 0 End)
And Sauda_Date Between Year_Start_Dt And Year_End_Dt

GO
