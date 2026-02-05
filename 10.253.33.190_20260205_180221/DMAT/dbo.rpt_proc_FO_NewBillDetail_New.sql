-- Object: PROCEDURE dbo.rpt_proc_FO_NewBillDetail_New
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


    CREATE       PROC          
[dbo].[rpt_proc_FO_NewBillDetail_New]          
          
 @StatusID VarChar(20),          
 @StatusName VarChar(50),          
          
 @FromDate VarChar(11),          
 @ToDate VarChar(11),          
          
 @FromPartyCode VarChar(20),          
 @ToPartyCode VarChar(20),          
          
 @ClientType VarChar (20),          
          
 @Dummy001 VarChar(50),          
 @Dummy002 VarChar(50),          
 @Dummy003 VarChar(50),          
 @Dummy004 VarChar(50),          
 @Dummy005 VarChar(50),          
 @Dummy006 VarChar(50),          
 @Dummy007 VarChar(50),          
 @Dummy008 VarChar(50),          
 @Dummy009 VarChar(50),          
 @Dummy010 VarChar(50)          
AS          
          
If @ClientType = '' Begin Set @ClientType = '%' End          
If @FromPartyCode = '' Begin Set @FromPartyCode = '%' End          
If @ToPartyCode = '' Begin Set @ToPartyCode = '%' End          
          
If (@FromDate = '' OR @ToDate = '')          
Begin           
 Select @FromDate = Left(Convert(Varchar,Min(Sauda_Date),109),11), @ToDate = Left(Convert(Varchar,Max(Sauda_Date),109),11) From FoBillValan_View           
End          
          
If (@FromPartyCode = '' OR @ToPartyCode = '' OR @FromPartyCode = '%' OR @ToPartyCode = '%')          
Begin           
 Select @FromPartyCode = Min(party_code), @ToPartyCode = Max(party_code) From FoBillValan_View           
End           
          
                                   
CREATE TABLE #FOBILL
	(
	PARTY_NAME	VARCHAR(100),
	PARTY_CODE	VARCHAR(20),
	CL_TYPE		VARCHAR(5),       
	L_ADDRESS1	VARCHAR(100),
	L_ADDRESS2	VARCHAR(100),
	L_ADDRESS3	VARCHAR(100),
	L_CITY		VARCHAR(100),
	L_STATE		VARCHAR(100),
	L_NATION	VARCHAR(50),
	L_ZIP		VARCHAR(50),
	RES_PHONE1	VARCHAR(100),
	EMAIL		VARCHAR(100),
	INST_TYPE	VARCHAR(6),
	SYMBOL		VARCHAR(30),
	EXPIRYDATE	VARCHAR(11),
	STRIKE_PRICE NUMERIC(18,4),
	OPTION_TYPE	VARCHAR(5),
	SAUDADATE	VARCHAR(11),
	CLOSINGRATE	NUMERIC(18,4),
	PRATE		NUMERIC(18,4),
	SRATE		NUMERIC(18,4),
	PQTY		INT,      
	SQTY		INT,
	SBILLAMT	NUMERIC(18,4),
	PBILLAMT	NUMERIC(18,4),
	DIFF		NUMERIC(18,4),
	CHRG_TOTAL	NUMERIC(18,4),
	FINALFIGURE	NUMERIC(18,4),
	CLCHRG		NUMERIC(18,4),
	SERVICE_TAX	NUMERIC(18,4),
	SEBI_TAX	NUMERIC(18,4),
	TURN_TAX	NUMERIC(18,4),
	STAMPDUTY	NUMERIC(18,4),
	INSURANCE_CHRG	NUMERIC(18,4),
	OTHER_CHRG	NUMERIC(18,4),
	--BROK		NUMERIC(18,4),
	TRADETYPE	VARCHAR(100),
	TRADETYPE1	VARCHAR(100)
	)
	
INSERT INTO #FOBILL
SELECT          
 Left(C1.Long_name, 25) AS party_name,          
 f.party_code,           
 C1.cl_type,           
 c1.l_address1,           
 c1.l_address2,          
 c1.l_address3,          
 c1.L_city,        
 c1.L_State,        
 c1.L_Nation,        
 c1.L_Zip,        
 c1.res_phone1,          
 Case When Len(c1.email) = 0 Then '_' Else c1.email End AS email,          
 f.inst_type,           
 f.symbol,          
 Convert(VarChar, f.expirydate, 103) AS expirydate,          
 f.strike_price,           
 Case When f.option_type = '' Then '' Else f.option_type End AS option_type,          
 Convert(VarChar, f.billdate, 103) AS saudadate,          
 f.Cl_Rate AS ClosingRate,          
 --((PRate*PQty) - (SRate*SQty)) as netrate,          
 Case When Sum(pqty)-Sum(Sqty) > 0 Then (Netwithbrok) Else 0 End AS prate,          
 Case When Sum(pqty)-Sum(Sqty) < 0 Then (Netwithbrok) Else 0 End AS srate,          
/* Case When (f.pqty) > (f.sqty) Then (f.pqty) - (f.sqty) Else 0 End AS pqty,          
 Case When (f.pqty) < (f.sqty) Then (f.sqty) - (f.pqty) Else 0 End AS sqty,*/          
 (Case When Sum(pqty)-Sum(Sqty) > 0 Then Sum(pqty)-Sum(Sqty) Else 0 End) AS pqty,          
 (Case When Sum(pqty)-Sum(Sqty) < 0 Then Abs(Sum(pqty)-Sum(Sqty)) Else 0 End) AS sqty,          
        
 Case When Sum((SQty-PQty)*(NetRate-f.Cl_Rate)-(Brok)) > 0         
      Then Sum((SQty-PQty)*(NetRate-f.Cl_Rate)-(Brok))        
      Else 0         
 End          
 AS sbillamt,          
 Case When Sum((SQty-PQty)*(NetRate-f.Cl_Rate)-(Brok)) < 0         
      Then Abs(Sum((SQty-PQty)*(NetRate-f.Cl_Rate)-(Brok)))        
      Else 0         
 End          
 AS pbillamt ,        
 Sum((SQty-PQty)*(NetRate-f.Cl_Rate)-(Brok)) AS diff,          
        
        
   Sum((Service_Tax+f.sebi_tax+f.turn_tax+f.stampduty+f.insurance_chrg+f.Other_Chrg)) AS chrg_total,          
   Sum((Service_Tax+f.sebi_tax+f.turn_tax+f.stampduty+f.insurance_chrg+f.Other_Chrg)) - Sum((SQty-PQty)*(NetRate-f.Cl_Rate)-(Brok)) AS finalfigure,            
   0 clchrg, /* CLEARING CHARGES */          
   Sum(Service_Tax), /* SERVICE TAX */          
   Sum(f.sebi_tax), /* SEBI TAX */          
   Sum(f.turn_tax), /* TURNOVER TAX */          
   Sum(f.stampduty), /* STAMP DUTY */          
   Sum(f.insurance_chrg), /* INS CHARGES */          
   Sum(f.other_chrg), /* OTHERCHARGES */          
          
 Case When f.bfdayflag = 'B-F' Then '<FONT Style="COLOR: #ff0000;">' + f.bfdayflag + '</FONT>'           
               Else Case When AuctionPart = 'EA' And f.Inst_Type Like 'FUT%'           
                                  Then '<FONT Style="COLOR:BLUE;">' + 'FF'  + '</FONT>'           
        Else Case When AuctionPart = 'EA' And f.Inst_Type Like 'OPT%'           
                                         Then '<FONT Style="COLOR:GREEN;">' + 'EA'  + '</FONT>'          
                           Else f.bfdayflag           
                End           
                                  End           
               End AS tradetype,          
 Case When f.bfdayflag = 'B-F' Then  f.bfdayflag     
               Else Case When AuctionPart = 'EA' And f.Inst_Type Like 'FUT%'           
                                  Then  'FF'     
        Else Case When AuctionPart = 'EA' And f.Inst_Type Like 'OPT%'           
                                         Then  'EA'    
                           Else f.bfdayflag           
                End           
                                  End           
               End AS tradetypeprint         
 FROM          
 tbl_mtompremiumbill F (nolock),           
 client1 c1 (nolock),           
 client2 c2 (nolock)       
        
          
WHERE          
 c1.cl_code = c2.cl_code AND          
 c2.party_code = f.party_code AND           
 f.party_code >= @FromPartyCode AND          
 f.party_code <= @ToPartyCode AND          
 f.billdate >= @FromDate + ' 00:00:00' AND          
 f.billdate <= @ToDate + ' 23:59:59' AND        
 @statusName = (case  when @Statusid = 'branch' then isnull(c1.branch_cd,'')    
    when @Statusid = 'subbroker' then isnull(c1.sub_broker,'')    
    when @Statusid = 'trader' then isnull(c1.trader,'')    
    when @Statusid = 'family' then isnull(c1.Family,'')    
    when @Statusid = 'area' then isnull(c1.area,'')    
    when @Statusid = 'region' then isnull(c1.region,'')    
    when @Statusid = 'client' then isnull(c2.party_code,'')    
    when @Statusid = 'broker' then @statusname    
   end)    
        
Group By          
 f.party_code,           
 c1.long_name,           
 c1.cl_type,           
 f.symbol,           
 f.inst_type,           
 f.expirydate,           
 f.strike_price,           
 f.option_type,           
 f.bfdayflag,           
 f.billdate,        
 C1.Email,        
 F.AuctionPart,        
 C1.L_Address1,        
 C1.L_Address2,        
 C1.L_Address3,        
 c1.L_city,        
 c1.L_State,        
 c1.L_Nation,        
 c1.L_Zip,        
 C1.Res_Phone1,        
 Cl_Rate,        
 Netwithbrok        
        
Having Case When bfdayflag = 'B-F' Then Sum((SQty-PQty)*(NetRate-f.Cl_Rate)-(Brok)) Else 1 End <> 0    
    
--Having Sum(Case When bfdayflag = 'B-F' Then PQty Else 0 End) - Sum(Case When bfdayflag = 'B-F' Then SQty Else 0 End) <> 0         
  --      OR         
--   Sum(Case When bfdayflag = 'B-F' Then 0 Else PQty End) - Sum(Case When bfdayflag = 'B-F' Then 0 Else SQty End) <> 0         
        
ORDER BY           
 f.party_code,           
 c1.long_name,  
f.billdate,             
 c1.cl_type,           
 f.symbol,           
 f.inst_type,           
 f.expirydate,           
 f.strike_price,           
 f.option_type,           
 f.bfdayflag DESC           
 --f.billdate           

/*        
COMPUTE          
 Sum(Case When Sum((SQty-PQty)*(NetRate-f.Cl_Rate)-(Brok)) > 0         
      Then Sum((SQty-PQty)*(NetRate-f.Cl_Rate)-(Brok))        
      Else 0         
 End), /* SAMT */           
 Sum(Case When Sum((SQty-PQty)*(NetRate-f.Cl_Rate)-(Brok)) < 0         
      Then Abs(Sum((SQty-PQty)*(NetRate-f.Cl_Rate)-(Brok)))        
      Else 0         
 End), /* PAMT */          
    
 Sum(Sum((SQty-PQty)*(NetRate-f.Cl_Rate)-(Brok))),  /*DIFF = PAMT-SAMT*/          
        
 Sum(Sum(Service_Tax+ f.sebi_tax+f.turn_tax+f.stampduty+f.insurance_chrg+f.Other_Chrg)), /* TOTAL OF CHARGES */          
 Sum(Sum(Service_Tax+f.sebi_tax+f.turn_tax+f.stampduty+f.insurance_chrg+f.Other_Chrg) - Sum((SQty-PQty)*(NetRate-f.Cl_Rate)-(Brok))), /* DIFF - TOTAL OF CHARGES */          
 Sum(0), /* TOTAL OF CLEARING CHARGES */          
 Sum(Sum(Service_Tax)), /* TOTAL OF SERVICE TAX */          
 Sum(Sum(f.sebi_tax)), /* TOTAL OF SEBI TAX */          
 Sum(Sum(f.turn_tax)), /* TOTAL OF TURNOVER TAX */     
 Sum(Sum(f.stampduty)), /* TOTAL OF STAMP DUTY */          
 Sum(Sum(f.insurance_chrg)),/* TOTAL OF INS CHARGES */          
 Sum(Sum(f.Other_Chrg)) /* TOTAL OF OTHERCHARGES */           
        
 BY f.party_code         
    
*/    

	DECLARE @PARTYCODE 		VARCHAR(20)
	DECLARE @SAUDADATE		VARCHAR(11)
	DECLARE @PARTYWISE_CURSOR CURSOR

	SET @PARTYWISE_CURSOR = CURSOR FOR
	SELECT DISTINCT PARTY_CODE, SAUDADATE=(CASE WHEN @DUMMY001 = 1 THEN SAUDADATE ELSE '' END) FROM #FOBILL ORDER BY PARTY_CODE
	OPEN @PARTYWISE_CURSOR 
	FETCH NEXT FROM @PARTYWISE_CURSOR INTO @PARTYCODE, @SAUDADATE

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT * FROM #FOBILL
		WHERE PARTY_CODE = @PARTYCODE AND SAUDADATE = (CASE WHEN @DUMMY001 = 1 THEN @SAUDADATE ELSE SAUDADATE END) 	
		ORDER BY 
			CASE WHEN @DUMMY001 = 1 THEN SAUDADATE ELSE '' END,
			PARTY_CODE

		SELECT 
			SUM=SUM(PBILLAMT),
			SUM=SUM(SBILLAMT),
			SUM=SUM(DIFF),
			SUM=SUM(CHRG_TOTAL),
			SUM=SUM(FINALFIGURE),
			SUM=SUM(CLCHRG),
			SUM=SUM(SERVICE_TAX),
			SUM=SUM(SEBI_TAX),
			SUM=SUM(TURN_TAX),
			SUM=SUM(STAMPDUTY),
			SUM=SUM(INSURANCE_CHRG),
			SUM=SUM(OTHER_CHRG),
			--SUM=SUM(BROK),
			PARTY_CODE,
			SAUDADATE=CASE WHEN @DUMMY001 = 1 THEN SAUDADATE ELSE '' END
		FROM 
			#FOBILL	
		WHERE 
			PARTY_CODE = @PARTYCODE
			AND SAUDADATE = (CASE WHEN @DUMMY001 = 1 THEN @SAUDADATE ELSE SAUDADATE END)	
		GROUP BY
			PARTY_CODE,
			CASE WHEN @DUMMY001 = 1 THEN SAUDADATE ELSE '' END
		ORDER BY
			CASE WHEN @DUMMY001 = 1 THEN SAUDADATE ELSE '' END,
			PARTY_CODE
				 
		FETCH NEXT FROM @PARTYWISE_CURSOR INTO @PARTYCODE, @SAUDADATE
	END

	CLOSE @PARTYWISE_CURSOR
	DEALLOCATE @PARTYWISE_CURSOR

GO
