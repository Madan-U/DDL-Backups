-- Object: PROCEDURE dbo.Proc_Service_Tax_Update_04082020
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC [dbo].[Proc_Service_Tax_Update]                
(                    
 @SETT_TYPE VARCHAR(2),                     
 @SAUDA_DATE VARCHAR(11),                     
 @FROMPARTY VARCHAR(10),                     
 @TOPARTY VARCHAR(10)                    
)                     
AS                 
            
DECLARE @SETT_NO VARCHAR(7)            
            
SELECT @SETT_NO = SETT_NO            
FROM SETT_MST (NOLOCK)
WHERE START_DATE BETWEEN  @SAUDA_DATE AND @SAUDA_DATE + ' 23:59'  
AND SETT_TYPE = @SETT_TYPE            
            
UPDATE SETTLEMENT SET             
 --TURN_TAX = ((floor(( (TRADEQTY*MARKETRATE*C.TURNOVER_TAX/100) * power(10,Round_To)+ RoFig + ErrNum)/(RoFig + NoZero )) * (RoFig + NoZero))/power(10,Round_To)),                
 --OTHER_CHRG = ((floor(( (TRADEQTY*MARKETRATE*C.OTHER_CHRG/100) * power(10,Round_To)+ RoFig + ErrNum)/(RoFig + NoZero )) * (RoFig + NoZero))/power(10,Round_To)),                
 --SEBI_TAX = ((floor(( (TRADEQTY*MARKETRATE*C.SEBITURN_TAX/100) * power(10,Round_To)+ RoFig + ErrNum)/(RoFig + NoZero )) * (RoFig + NoZero))/power(10,Round_To))                
 TURN_TAX   = ROUND((TRADEQTY*MARKETRATE*C.TURNOVER_TAX/100),C.ROUND_TO),    
 OTHER_CHRG = ROUND((TRADEQTY*MARKETRATE*C.OTHER_CHRG/100),C.ROUND_TO),    
 SEBI_TAX   = ROUND((TRADEQTY*MARKETRATE*C.SEBITURN_TAX/100),C.ROUND_TO)    
    
FROM CLIENTTAXES_NEW C (NOLOCK)
WHERE SETT_NO = @SETT_NO            
AND SETT_TYPE = @SETT_TYPE              
AND SAUDA_DATE BETWEEN FROMDATE AND TODATE            
AND C.PARTY_CODE = SETTLEMENT.PARTY_CODE            
AND TRANS_CAT = (CASE WHEN BILLFLAG > 3 THEN 'DEL' ELSE 'TRD' END)            
AND TRADE_NO NOT LIKE '%C%'            
AND AUCTIONPART NOT LIKE 'A%'            
AND AUCTIONPART NOT LIKE 'F%'            
AND SETTLEMENT.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY             
 AND SAUDA_DATE between C.fromdate and C.todate      
            
UPDATE ISETTLEMENT SET             
 --TURN_TAX = ((floor(( (TRADEQTY*MARKETRATE*C.TURNOVER_TAX/100) * power(10,Round_To)+ RoFig + ErrNum)/(RoFig + NoZero )) * (RoFig + NoZero))/power(10,Round_To)),                
 --OTHER_CHRG = ((floor(( (TRADEQTY*MARKETRATE*C.OTHER_CHRG/100) * power(10,Round_To)+ RoFig + ErrNum)/(RoFig + NoZero )) * (RoFig + NoZero))/power(10,Round_To)),                
 --SEBI_TAX = ((floor(( (TRADEQTY*MARKETRATE*C.SEBITURN_TAX/100) * power(10,Round_To)+ RoFig + ErrNum)/(RoFig + NoZero )) * (RoFig + NoZero))/power(10,Round_To))              
 TURN_TAX   = ROUND((TRADEQTY*MARKETRATE*C.TURNOVER_TAX/100),C.ROUND_TO),    
 OTHER_CHRG = ROUND((TRADEQTY*MARKETRATE*C.OTHER_CHRG/100),C.ROUND_TO),    
 SEBI_TAX   = ROUND((TRADEQTY*MARKETRATE*C.SEBITURN_TAX/100),C.ROUND_TO)    
FROM CLIENTTAXES_NEW C (NOLOCK)
WHERE SETT_NO = @SETT_NO            
AND SETT_TYPE = @SETT_TYPE              
AND SAUDA_DATE BETWEEN FROMDATE AND TODATE            
AND C.PARTY_CODE = ISETTLEMENT.PARTY_CODE            
AND TRANS_CAT = 'DEL'            
AND TRADE_NO NOT LIKE '%C%'            
AND AUCTIONPART NOT LIKE 'A%'            
AND AUCTIONPART NOT LIKE 'F%'            
AND ISETTLEMENT.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY             
 AND SAUDA_DATE between C.fromdate and C.todate                  
      /*
UPDATE SETTLEMENT         
--SET TURN_TAX = (TRADEQTY*MARKETRATE*TAX_PERC/100)      
--SET TURN_TAX =((floor(( (TRADEQTY*MARKETRATE*TAX_PERC/100) * power(10,Round_To)+ RoFig + ErrNum)/(RoFig + NoZero )) * (RoFig + NoZero))/power(10,Round_To))      
SET TURN_TAX = ROUND((TRADEQTY*MARKETRATE*TAX_PERC/100),C.ROUND_TO)    
FROM TURNTAX_EXCEPTION (NOLOCK), CLIENTTAXES_NEW C (NOLOCK)      
WHERE SETT_NO = @SETT_NO            
AND SETT_TYPE = @SETT_TYPE              
AND SAUDA_DATE BETWEEN DATEFROM AND DATETO        
AND SETTLEMENT.SCRIP_CD = TURNTAX_EXCEPTION.SCRIP_CD        
AND TURN_TAX > 0        
            
UPDATE ISETTLEMENT        
--SET TURN_TAX = (TRADEQTY*MARKETRATE*TAX_PERC/100)      
--SET TURN_TAX =((floor(( (TRADEQTY*MARKETRATE*TAX_PERC/100) * power(10,Round_To)+ RoFig + ErrNum)/(RoFig + NoZero )) * (RoFig + NoZero))/power(10,Round_To))      
SET TURN_TAX = ROUND((TRADEQTY*MARKETRATE*TAX_PERC/100),C.ROUND_TO)    
FROM TURNTAX_EXCEPTION (NOLOCK), CLIENTTAXES_NEW C (NOLOCK)      
WHERE SETT_NO = @SETT_NO            
AND SETT_TYPE = @SETT_TYPE              
AND SAUDA_DATE BETWEEN DATEFROM AND DATETO        
AND ISETTLEMENT.SCRIP_CD = TURNTAX_EXCEPTION.SCRIP_CD        
AND TURN_TAX > 0      
            */
            
            
EXEC PROC_TURNTAX_EXCEPTION @SETT_TYPE, @SAUDA_DATE  
            
UPDATE SETTLEMENT SET                 
SERVICE_TAX = ((TRADEQTY*BROKAPPLIED)+                
       (CASE WHEN TURNOVER_AC = 1 AND TURNOVER_TAX = 1                 
      THEN TURN_TAX                
             ELSE 0                 
        END)+                
       (CASE WHEN SEBI_TURN_AC = 1 AND SEBI_TURN_TAX = 1                 
      THEN SEBI_TAX                
             ELSE 0                 
        END)+                
       (CASE WHEN BROKER_NOTE_AC = 1 AND BROKERNOTE = 1                 
      THEN BROKER_CHRG                
             ELSE 0                 
        END)+                
       (CASE WHEN OTHER_CHRG_AC = 1 AND C2.OTHER_CHRG = 1                
      THEN SETTLEMENT.OTHER_CHRG                
             ELSE 0                 
        END)+                
       (CASE WHEN STT_TAX_AC = 1 AND C2.INSURANCE_CHRG = 1                
      THEN SETTLEMENT.INS_CHRG                
             ELSE 0                 
        END)) * G.SERVICE_TAX/100,                
NSERTAX    = ((TRADEQTY*NBROKAPP)+                
       (CASE WHEN TURNOVER_AC = 1 AND TURNOVER_TAX = 1                 
      THEN TURN_TAX                
             ELSE 0                 
        END)+                
       (CASE WHEN SEBI_TURN_AC = 1 AND SEBI_TURN_TAX = 1                 
      THEN SEBI_TAX                
             ELSE 0                 
        END)+                
       (CASE WHEN BROKER_NOTE_AC = 1 AND BROKERNOTE = 1                 
      THEN BROKER_CHRG                
             ELSE 0                 
        END)+                
       (CASE WHEN OTHER_CHRG_AC = 1 AND C2.OTHER_CHRG = 1                
      THEN SETTLEMENT.OTHER_CHRG                
         ELSE 0                 
        END)+                
       (CASE WHEN STT_TAX_AC = 1 AND C2.INSURANCE_CHRG = 1                
      THEN SETTLEMENT.INS_CHRG                
             ELSE 0                 
        END)) * G.SERVICE_TAX/100                
FROM GLOBALS G, CLIENT2 C2 (NOLOCK)
WHERE SETT_NO = @SETT_NO            
AND SETT_TYPE = @SETT_TYPE             
AND SETTLEMENT.PARTY_CODE = C2.PARTY_CODE                
AND C2.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                
AND AUCTIONPART NOT LIKE 'A%' --AND AUCTIONPART NOT LIKE 'F%'                
AND 1 <> (CASE WHEN SERVICE_CHRG = 1 AND SERTAXMETHOD = 1                 
        THEN 1 ELSE 0 END)                
AND SAUDA_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT                
                
UPDATE ISETTLEMENT SET                 
SERVICE_TAX = ((TRADEQTY*BROKAPPLIED)+                
       (CASE WHEN TURNOVER_AC = 1 AND TURNOVER_TAX = 1                 
      THEN TURN_TAX                
             ELSE 0                 
        END)+                
    (CASE WHEN SEBI_TURN_AC = 1 AND SEBI_TURN_TAX = 1                 
      THEN SEBI_TAX                
             ELSE 0                 
        END)+                
       (CASE WHEN BROKER_NOTE_AC = 1 AND BROKERNOTE = 1                 
      THEN BROKER_CHRG                
             ELSE 0                 
        END)+                
       (CASE WHEN OTHER_CHRG_AC = 1 AND C2.OTHER_CHRG = 1                
      THEN ISETTLEMENT.OTHER_CHRG                
             ELSE 0                 
        END)+                
       (CASE WHEN STT_TAX_AC = 1 AND C2.INSURANCE_CHRG = 1                
      THEN ISETTLEMENT.INS_CHRG                
             ELSE 0                 
        END)) * G.SERVICE_TAX/100,                
NSERTAX    = ((TRADEQTY*NBROKAPP)+                
       (CASE WHEN TURNOVER_AC = 1 AND TURNOVER_TAX = 1   
      THEN TURN_TAX                
             ELSE 0                 
        END)+                
       (CASE WHEN SEBI_TURN_AC = 1 AND SEBI_TURN_TAX = 1                 
      THEN SEBI_TAX                
             ELSE 0                 
        END)+                
       (CASE WHEN BROKER_NOTE_AC = 1 AND BROKERNOTE = 1                 
      THEN BROKER_CHRG                
             ELSE 0                 
        END)+                
       (CASE WHEN OTHER_CHRG_AC = 1 AND C2.OTHER_CHRG = 1                
      THEN ISETTLEMENT.OTHER_CHRG                
             ELSE 0                 
        END)+                
       (CASE WHEN STT_TAX_AC = 1 AND C2.INSURANCE_CHRG = 1                
      THEN ISETTLEMENT.INS_CHRG                
             ELSE 0                 
        END)) * G.SERVICE_TAX/100                
FROM GLOBALS G, CLIENT2 C2 (NOLOCK)
WHERE SETT_NO = @SETT_NO            
AND SETT_TYPE = @SETT_TYPE                
AND ISETTLEMENT.PARTY_CODE = C2.PARTY_CODE                
AND C2.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                
AND AUCTIONPART NOT LIKE 'A%' --AND AUCTIONPART NOT LIKE 'F%'                
AND 1 <> (CASE WHEN SERVICE_CHRG = 1 AND SERTAXMETHOD = 1                 
        THEN 1 ELSE 0 END)                
AND SAUDA_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT   
  
------ KFC CHANGES
	UPDATE CHARGES_DETAIL SET 
	CD_TrdBuySerTax = CD_TrdBuyBrokerage*(Service_Tax+CESSTAX)/100, 
	CD_TrdSellSerTax = CD_TrdSellBrokerage*(Service_Tax+CESSTAX)/100, 
	CD_DelBuySerTax = CD_DelBuyBrokerage*(Service_Tax+CESSTAX)/100, 
	CD_DelSellSerTax = CD_DelSellBrokerage*(Service_Tax+CESSTAX)/100, 
	CD_TotalSerTax = CD_TotalBrokerage*(Service_Tax+CESSTAX)/100
	FROM Globals, TBL_CLIENT_GST_DATA C, TBL_STATE_GST_DATA G, TBL_GST_LOCATION L
	WHERE CD_Sett_Type = @Sett_Type  
	And CD_Sauda_Date Like @Sauda_Date + '%'  
	AND CD_TotalSerTax > 0 
	AND CD_Party_Code = C.PARTY_CODE
	And C.Party_Code BetWeen @FromParty And @ToParty  
	AND CD_Sauda_Date BETWEEN C.EFF_FROM_DATE AND C.EFF_TO_DATE
	AND CD_Sauda_Date BETWEEN G.EFF_FROM_DATE AND G.EFF_TO_DATE
	AND CD_Sauda_Date BETWEEN Year_Start_Dt AND Year_End_Dt
	AND G.STATE_NAME = C.L_STATE
	AND C.GST_LOCATION = L.LOC_CODE
	AND L.STATE = G.STATE_NAME
	AND CESSTAX > 0 
	AND C.GST_NO = ''

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
	End)) * (Globals.Service_Tax+CESSTAX)/100,  
	NSerTax = ((TradeQty*NBrokapp)+  
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
	End)) * (Globals.Service_Tax+CESSTAX)/100    
	From Globals, TBL_CLIENT_GST_DATA C, TBL_STATE_GST_DATA G, TBL_GST_LOCATION L, CLIENT2 C2 
	Where Sett_Type = @Sett_Type  
	And Sauda_Date Like @Sauda_Date + '%'  
	And Settlement.Party_Code = C.Party_Code  
	And Settlement.Party_Code = C2.Party_Code  
	AND Sauda_Date BETWEEN C.EFF_FROM_DATE AND C.EFF_TO_DATE
	AND Sauda_Date BETWEEN G.EFF_FROM_DATE AND G.EFF_TO_DATE
	AND Sauda_Date BETWEEN Year_Start_Dt AND Year_End_Dt
	AND G.STATE_NAME = C.L_STATE
	AND C.GST_LOCATION = L.LOC_CODE
	AND L.STATE = G.STATE_NAME
	And C.Party_Code BetWeen @FromParty And @ToParty    
	AND Settlement.Service_Tax > 0 
	AND CESSTAX > 0 AND C.GST_NO = ''
	 
	Update ISettlement Set  
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
	Then ISettlement.Other_Chrg  
	Else 0  
	End)+  
	(Case When STT_TAX_AC = 1 And C2.INSURANCE_CHRG = 1  
	Then ISettlement.Other_Chrg  
	Else 0  
	End)) * (Globals.Service_Tax+CESSTAX)/100,  
	NSerTax = ((TradeQty*NBrokapp)+  
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
	Then ISettlement.Other_Chrg  
	Else 0  
	End)+  
	(Case When STT_TAX_AC = 1 And C2.INSURANCE_CHRG = 1  
	Then ISettlement.Other_Chrg  
	Else 0  
	End)) * (Globals.Service_Tax+CESSTAX)/100  
	From Globals, TBL_CLIENT_GST_DATA C, TBL_STATE_GST_DATA G, TBL_GST_LOCATION L, CLIENT2 C2 
	Where Sett_Type = @Sett_Type  
	And Sauda_Date Like @Sauda_Date + '%'  
	And ISettlement.Party_Code = C.Party_Code  
	And ISettlement.Party_Code = C2.Party_Code 
	AND Sauda_Date BETWEEN C.EFF_FROM_DATE AND C.EFF_TO_DATE
	AND Sauda_Date BETWEEN G.EFF_FROM_DATE AND G.EFF_TO_DATE
	AND Sauda_Date BETWEEN Year_Start_Dt AND Year_End_Dt
	AND G.STATE_NAME = C.L_STATE
	AND C.GST_LOCATION = L.LOC_CODE
	AND L.STATE = G.STATE_NAME
	And C.Party_Code BetWeen @FromParty And @ToParty    
	AND ISettlement.Service_Tax > 0 
	AND CESSTAX > 0 AND C.GST_NO = ''
------ KFC CHANGES

GO
