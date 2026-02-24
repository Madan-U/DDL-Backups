-- Object: PROCEDURE dbo.NSE_TAXESUPDATE
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC NSE_TAXESUPDATE (@SETT_NO VARCHAR(7), @SETT_TYPE VARCHAR(2)) AS 

Select Distinct Party_Code, Sauda_Date = Convert(DateTime,Left(Convert(Varchar,Sauda_Date,109),11))   
Into #sett  
From Settlement  
Where Sett_No = @SETT_NO And Sett_Type = @SETT_TYPE  
AND BILLFLAG < 4 AND BILLFLAG > 1
AND TRADE_NO NOT LIKE '%C%'   
AND AUCTIONPART NOT LIKE 'A%'  
AND AUCTIONPART NOT LIKE 'F%'   

Select C.* Into #ClientTaxes_New From ClientTaxes_New C, #Sett S  
Where C.Party_Code = S.Party_Code  
And Sauda_Date Between FromDate And ToDate  
And trans_cat = 'TRD'   
   
UPDATE SETTLEMENT SET     
SERVICE_TAX = (CASE WHEN SERVICE_CHRG = 1 AND SERTAXMETHOD = 1      
      THEN 0     
      ELSE TRADEQTY*BROKAPPLIED*Globals.service_tax/100    
        END),    
NSERTAX =     (CASE WHEN SERVICE_CHRG = 1 AND SERTAXMETHOD = 1      
      THEN 0     
      ELSE TRADEQTY*NBROKAPP*Globals.service_tax/100    
        END),    
turn_tax  = ((CT.turnover_tax * Settlement.marketrate * Settlement.Tradeqty)/100 ),    
other_chrg = ((CT.other_chrg * Settlement.marketrate * Settlement.Tradeqty)/100 ),    
sebi_tax = ((CT.sebiturn_tax * Settlement.marketrate * Settlement.Tradeqty)/100),    
Broker_chrg = ((CT.broker_note * Settlement.marketrate * Settlement.Tradeqty)/100)    
FROM #CLIENTTAXES_NEW CT, CLIENT2 C2, CLIENT1 C1, GLOBALS    
WHERE SETT_NO = @SETT_NO    
AND SETT_TYPE = @SETT_TYPE     
AND C1.CL_CODE = C2.CL_CODE    
AND CT.PARTY_CODE = C2.PARTY_CODE    
AND C2.PARTY_CODE = SETTLEMENT.PARTY_CODE    
AND CT.TRANS_CAT = 'TRD'    
AND SAUDA_DATE BETWEEN FROMDATE AND TODATE    
AND TRADE_NO NOT LIKE '%C%'   
AND AUCTIONPART NOT LIKE 'A%'  
AND AUCTIONPART NOT LIKE 'F%'   
AND BILLFLAG < 4 AND BILLFLAG > 1  
And Sauda_date > Globals.year_start_dt    
And Sauda_date < Globals.year_end_dt

GO
