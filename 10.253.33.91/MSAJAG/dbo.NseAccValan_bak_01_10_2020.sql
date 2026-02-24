-- Object: PROCEDURE dbo.NseAccValan_bak_01_10_2020
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



Create Proc [dbo].[NseAccValan_bak_01_10_2020] (@Sett_No Varchar(7),@Sett_Type Varchar(2)) As             
            
Declare @Service_Tax Numeric(18,6)              
DECLARE                 
@TRDTURNOVER_TAX NUMERIC(18,6),                
@DELTURNOVER_TAX NUMERIC(18,6),                
@TRDSEBI_TAX NUMERIC(18,6),                
@DELSEBI_TAX NUMERIC(18,6),                
@TRDBROKER_CHRG NUMERIC(18,6),                
@DELBROKER_CHRG NUMERIC(18,6),                
@Turnover_Ac Int,  
@start_date varchar(11)  
  
SELECT @TRDTURNOVER_TAX = Turnover_Tax, @TRDSEBI_TAX = Sebiturn_Tax, @TRDBROKER_CHRG = Broker_Note,  
@start_date = Start_date                 
FROM TAXES, SETT_MST S                 
WHERE TRANS_CAT = 'TRD'                
AND Sett_No = @Sett_no And Sett_Type = @Sett_Type                             
And Start_Date BETWEEN FROM_DATE AND TO_DATE               
              
SELECT @DELTURNOVER_TAX = Turnover_Tax, @DELSEBI_TAX = Sebiturn_Tax, @DELBROKER_CHRG = Broker_Note                
FROM TAXES, SETT_MST S                 
WHERE TRANS_CAT = 'DEL'                
AND Sett_No = @Sett_no And Sett_Type = @Sett_Type                             
And Start_Date BETWEEN FROM_DATE AND TO_DATE               
              
Select @Service_Tax= Service_Tax, @Turnover_Ac = Turnover_Ac From Globals G, Sett_Mst S                            
Where Sett_No = @Sett_no And Sett_Type = @Sett_Type                             
And Year_Start_Dt <= Start_Date And Year_End_Dt >= End_Date    
                     

--Select @Service_Tax            
            
--Delete From #NseBillValan Where Sett_No = @Sett_No and Sett_Type = @Sett_Type             
  
truncate table NseBillValan      
  
select *,                       
PTrdRate = pamt,                      
STrdRate = pamt,                
PDelRate = pamt,                      
SDelRate = pamt   
into #NseBillValan from NseBillValan  
where 1 = 2 
  
Insert Into #NseBillValan             
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
Brokerage = (Case when BillFlag in (2,3) Then Sum(TradeQty*NBrokapp) Else 0 End),            
DelBrokerage = (Case when BillFlag in (1,4,5) Then Sum(TradeQty*NBrokApp) Else 0 End),            
NSertax = Sum(NSertax),            
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
SQty = (Case When Sell_Buy = 2 Then Sum(TradeQty) Else 0 End ) ,0, series,                                        
PTrdRate = SUM(Case When Sell_Buy = 1 And BillFlag = 2 Then TradeQty*S.MarketRate Else 0 End),                      
STrdRate = SUM(Case When Sell_Buy = 2 And BillFlag = 3 Then TradeQty*S.MarketRate Else 0 End),                
PDelRate = SUM(Case When Sell_Buy = 1 And BillFlag <> 2 Then TradeQty*S.MarketRate Else 0 End),                      
SDelRate = SUM(Case When Sell_Buy = 2 And BillFlag <> 3 Then TradeQty*S.MarketRate Else 0 End)             
from SETTLEMENT_VALAN S, Client2 C2, OWNER,Client1              
where C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code              
and S.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type   
group by sett_no,sett_type,s.party_code,S.Scrip_Cd,series, sell_buy,service_chrg,billno,dispcharge,TurnOver_Tax,Sebi_Turn_Tax,            
Insurance_Chrg,Brokernote,c2.Other_chrg,Branch_cd,Cl_Type,BillFlag,C2.SerTaxMethod,AuctionPart              
  
  
Insert Into #NseBillValan    
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
Brokerage = 0,            
DelBrokerage = Sum(TradeQty*NBrokApp),            
NSertax = Sum(NSertax),            
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
SQty = (Case When Sell_Buy = 2 Then Sum(TradeQty) Else 0 End ),0, series,                            
PTrdRate = 0,                      
STrdRate = 0,                
PDelRate = SUM(Case When Sell_Buy = 1 Then TradeQty*S.MarketRate Else 0 End),                      
SDelRate = SUM(Case When Sell_Buy = 2 Then TradeQty*S.MarketRate Else 0 End)    
from ISETTLEMENT_VALAN S, Client2 C2 ,Client1, Owner              
where C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code             
and S.Sett_No = @Sett_No and S.Sett_Type = @Sett_Type             
group by sett_no,sett_type,s.party_code,S.Scrip_Cd,series,sell_buy,service_chrg,billno,Branch_cd,Cl_Type,BillFlag,SerTaxMethod            
  
select sett_no, sett_Type, party_code, scrip_Cd, series, TOTALSTT = sum(TOTALSTT), SSTTTRD = sum(SSTTTRD)   
into #stt from (  
select sett_no, sett_Type, party_code, scrip_Cd, series, contractno, TOTALSTT = ROUND(TOTALSTT,0), SSTTTRD from stt_clientdetail  
where sauda_date = @start_date and sett_Type = @sett_Type ) a  
group by sett_no, sett_Type, party_code, scrip_Cd, series  
  
create clustered index idx_stt on #stt (sett_no,sett_Type, party_code, scrip_Cd, series)  
create clustered index idx_stt on #nseBillValan (sett_no,sett_Type, party_code, scrip_Cd, series)  
   
UPDATE #nseBillValan                
SET INS_CHRG = ROUND(TOTALSTT,0),                
brokerage = brokerage - SSTTTRD,                
delbrokerage = delbrokerage - (ROUND(TOTALSTT,0) - SSTTTRD)                
FROM #stt STT_CLIENTDETAIL           
WHERE #nseBillValan.SETT_NO = @Sett_No                
AND #nseBillValan.SETT_TYPE = @Sett_Type                
AND #nseBillValan.SETT_NO = STT_CLIENTDETAIL.SETT_NO                
AND #nseBillValan.SETT_TYPE = STT_CLIENTDETAIL.SETT_TYPE                
AND #nseBillValan.PARTY_CODE = STT_CLIENTDETAIL.PARTY_CODE                
AND #nseBillValan.SCRIP_CD = STT_CLIENTDETAIL.SCRIP_CD                
AND #nseBillValan.SERIES = STT_CLIENTDETAIL.SERIES                
AND TRDTYPE IN ('I', 'N')                
AND Cl_Type = 'INS'                
AND INS_CHRG = 0                 
AND Service_Tax = 0 and (BROKERAGE+DELBROKERAGE) > 0                
 
 ----19 july 2020 changes 
 

IF CONVERT(DATETIME,@START_DATE) >= CONVERT(DATETIME,'JUL  1 2020')

BEGIN
	UPDATE #NSEBILLVALAN SET BROKER_CHRG = TOTALSTAMP
	--BROKERAGE = 0,          
	--DELBROKERAGE = BROKERAGE + DELBROKERAGE - TOTALSTAMP          
	FROM (SELECT PARTY_CODE, SCRIP_CD, SERIES, TRADE_TYPE,
		  TOTALSTAMP = CONVERT(NUMERIC(18,0),SUM(BUYSQSTAMP+BUYDELSTAMP)) 
		  FROM MSAJAG.DBO.TBL_STAMP_DATA 
		  WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE 
		  GROUP BY PARTY_CODE, SCRIP_CD, SERIES, TRADE_TYPE) A
	WHERE A.PARTY_CODE = #NSEBILLVALAN.PARTY_CODE
	AND A.SCRIP_CD = #NSEBILLVALAN.SCRIP_CD 
	AND A.SERIES = #NSEBILLVALAN.SERIES 
	AND #NSEBILLVALAN.SELL_BUY = 1 
	AND #NSEBILLVALAN.TRDTYPE = (CASE WHEN TRADE_TYPE = 'N' THEN 'S' ELSE TRADE_TYPE END)
	AND #NSEBILLVALAN.BROKER_CHRG = 0 
	
	UPDATE #NSEBILLVALAN SET BROKER_CHRG = TOTALSTAMP
	--BROKERAGE = 0,          
	--DELBROKERAGE = BROKERAGE + DELBROKERAGE - TOTALSTAMP          
	FROM (SELECT PARTY_CODE, SCRIP_CD, SERIES, TRADE_TYPE,
		  TOTALSTAMP = CONVERT(NUMERIC(18,0),SUM(BUYSQSTAMP+BUYDELSTAMP)) 
		  FROM ANAND.BSEDB_AB.DBO.TBL_STAMP_DATA 
		  WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE 
		  GROUP BY PARTY_CODE, SCRIP_CD, SERIES, TRADE_TYPE) A
	WHERE A.PARTY_CODE = #NSEBILLVALAN.PARTY_CODE
	AND A.SCRIP_CD = #NSEBILLVALAN.SCRIP_CD 
	AND A.SERIES = #NSEBILLVALAN.SERIES 
	AND #NSEBILLVALAN.SELL_BUY = 1 
	AND #NSEBILLVALAN.TRDTYPE = (CASE WHEN TRADE_TYPE = 'N' THEN 'S' ELSE TRADE_TYPE END)
	AND #NSEBILLVALAN.BROKER_CHRG = 0 

	UPDATE #NSEBILLVALAN SET BROKER_CHRG = TOTALSTAMP
	--BROKERAGE = 0,          
	--DELBROKERAGE = BROKERAGE + DELBROKERAGE - TOTALSTAMP    
	FROM (SELECT PARTY_CODE, SCRIP_CD, SERIES, TRADE_TYPE,
		  TOTALSTAMP = CONVERT(NUMERIC(18,0),SUM(SELLSQSTAMP+SELLDELSTAMP)) 
		  FROM MSAJAG.DBO.TBL_STAMP_DATA 
		  WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE 
		  GROUP BY PARTY_CODE, SCRIP_CD, SERIES, TRADE_TYPE) A
	WHERE A.PARTY_CODE = #NSEBILLVALAN.PARTY_CODE
	AND A.SCRIP_CD = #NSEBILLVALAN.SCRIP_CD 
	AND A.SERIES = #NSEBILLVALAN.SERIES 
	AND #NSEBILLVALAN.SELL_BUY = 2 
	AND #NSEBILLVALAN.TRDTYPE = (CASE WHEN TRADE_TYPE = 'N' THEN 'S' ELSE TRADE_TYPE END)
	AND #NSEBILLVALAN.BROKER_CHRG = 0  
	
	UPDATE #NSEBILLVALAN SET BROKER_CHRG = TOTALSTAMP
	--BROKERAGE = 0,          
	--DELBROKERAGE = BROKERAGE + DELBROKERAGE - TOTALSTAMP    
	FROM (SELECT PARTY_CODE, SCRIP_CD, SERIES, TRADE_TYPE,
		  TOTALSTAMP = CONVERT(NUMERIC(18,0),SUM(SELLSQSTAMP+SELLDELSTAMP)) 
		  FROM ANAND.BSEDB_AB.DBO.TBL_STAMP_DATA 
		  WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE 
		  GROUP BY PARTY_CODE, SCRIP_CD, SERIES, TRADE_TYPE) A
	WHERE A.PARTY_CODE = #NSEBILLVALAN.PARTY_CODE
	AND A.SCRIP_CD = #NSEBILLVALAN.SCRIP_CD 
	AND A.SERIES = #NSEBILLVALAN.SERIES 
	AND #NSEBILLVALAN.SELL_BUY = 2 
	AND #NSEBILLVALAN.TRDTYPE = (CASE WHEN TRADE_TYPE = 'N' THEN 'S' ELSE TRADE_TYPE END)
	AND #NSEBILLVALAN.BROKER_CHRG = 0 
END

----------changes end
                
UPDATE #nseBillValan                
SET Broker_Chrg = PTrdRate*@TRDBROKER_CHRG/100                
    + STrdRate*@TRDBROKER_CHRG/100                
    + PDELRate*@DELBROKER_CHRG/100                
    + SDELRate*@DELBROKER_CHRG/100,           
BROKERAGE = BROKERAGE - (PTrdRate*@TRDBROKER_CHRG/100                
       +  STrdRate*@TRDBROKER_CHRG/100),                
DELBROKERAGE = DELBROKERAGE - (PDELRate*@DELBROKER_CHRG/100                
       +  SDELRate*@DELBROKER_CHRG/100)                
WHERE #nseBillValan.SETT_NO = @Sett_No                
AND #nseBillValan.SETT_TYPE = @Sett_Type                
AND TRDTYPE IN ('I', 'N')                
AND Cl_Type = 'INS'                
AND Broker_Chrg = 0                 
AND Service_Tax = 0 and (BROKERAGE+DELBROKERAGE) > 0                
AND NOT EXISTS (SELECT n.party_code FROM #nseBillValan n where n.SETT_NO = @Sett_No                
AND n.SETT_TYPE = @Sett_Type                
AND n.TRDTYPE IN ('I', 'N') and n.party_code = #nseBillValan.party_code AND Broker_Chrg > 0)
                
UPDATE #nseBillValan                
SET TURN_TAX = PTrdRate*@TRDTURNOVER_TAX/100                
   + STrdRate*@TRDTURNOVER_TAX/100                
   + PDELRate*@DELTURNOVER_TAX/100                
   + SDELRate*@DELTURNOVER_TAX/100,                
BROKERAGE = (Case When @Turnover_Ac = 0                 
    Then BROKERAGE                 
    Else BROKERAGE * 100 / (100+@SERVICE_TAX)                
      End)                 
      - (PTrdRate*@TRDTURNOVER_TAX/100                
      +  STrdRate*@TRDTURNOVER_TAX/100),                
DELBROKERAGE = (Case When @Turnover_Ac = 0                 
    Then DELBROKERAGE                
    Else DELBROKERAGE * 100 / (100+@SERVICE_TAX)                
      End) - (PDELRate*@DELTURNOVER_TAX/100                
      +  SDELRate*@DELTURNOVER_TAX/100),            
      Service_Tax = (CASE WHEN @Turnover_Ac = 0                 
  THEN Service_Tax                
  ELSE BROKERAGE - BROKERAGE * 100 / (100+@SERVICE_TAX)                
     + DELBROKERAGE - DELBROKERAGE * 100 / (100+@SERVICE_TAX)                
    END)        WHERE #nseBillValan.SETT_NO = @Sett_No                
AND #nseBillValan.SETT_TYPE = @Sett_Type                
AND TRDTYPE IN ('I', 'N')                
AND Cl_Type = 'INS'                
AND TURN_TAX = 0                 
AND Service_Tax = 0 and (BROKERAGE+DELBROKERAGE) > 0                
                
if @Turnover_Ac = 0                 
Begin                
 UPDATE #nseBillValan                
 SET Service_Tax = BROKERAGE - BROKERAGE * 100 / (100+@SERVICE_TAX)                
     + DELBROKERAGE - DELBROKERAGE * 100 / (100+@SERVICE_TAX),                
 BROKERAGE = BROKERAGE * 100 / (100+@SERVICE_TAX),                
 DELBROKERAGE = DELBROKERAGE * 100 / (100+@SERVICE_TAX)                
 WHERE #nseBillValan.SETT_NO = @Sett_No                
 AND #nseBillValan.SETT_TYPE = @Sett_Type                
 AND TRDTYPE IN ('I', 'N')                
 AND Cl_Type = 'INS'                
 AND Service_Tax = 0 and (BROKERAGE+DELBROKERAGE) > 0                
End  
  
                
UPDATE #nseBillValan                
SET Sebi_Tax = PTrdRate*@TRDSEBI_TAX/100                
    + STrdRate*@TRDSEBI_TAX/100                
    + PDELRate*@DELSEBI_TAX/100    
    + SDELRate*@DELSEBI_TAX/100,                
BROKERAGE = BROKERAGE - (PTrdRate*@TRDSEBI_TAX/100                
       +  STrdRate*@TRDSEBI_TAX/100),                
DELBROKERAGE = DELBROKERAGE - (PDELRate*@DELSEBI_TAX/100                
       +  SDELRate*@DELSEBI_TAX/100)                
WHERE #nseBillValan.SETT_NO = @Sett_No                
AND #nseBillValan.SETT_TYPE = @Sett_Type                
AND TRDTYPE IN ('I', 'N')                
AND Cl_Type = 'INS'                
AND Sebi_Tax = 0                 
and (BROKERAGE+DELBROKERAGE) > 0     
  
INSERT INTO NseBillValan          
select party_code,Scrip_Cd,sell_buy,pamt,samt,PRate,SRate,Brokerage,DelBrokerage,Service_Tax,ExService_Tax,Turn_Tax,Sebi_Tax,Ins_Chrg,Broker_Chrg,Other_Chrg,TrdAmt,DelAmt,sett_no,sett_type,billno,Branch_cd,Cl_Type,TrdType,PQty,SQty,Stampflag,series   
from #NseBillValan  
  
  INSERT INTO NseBillValan          
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
                                                               WHEN SUM(CD_TRDBUYSERTAX + CD_TRDSELLSERTAX) = 0 THEN SUM(CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE) - ROUND(SUM(CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE) * @SERVICE_TAX / (100 + @SERVICE_TAX)
,2)          
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
           0, CD_Series           
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
               
IF (SELECT ISNULL(COUNT(1),0) FROM NseBillValan WHERE Sett_No = @Sett_No and Sett_Type = @Sett_Type) > 0   
BEGIN  
 EXEC PROC_NSEVALAN_DETAIL @SETT_NO, @SETT_TYPE  
END  

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
