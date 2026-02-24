-- Object: PROCEDURE dbo.RPT_CONTRACT_ANNEXTURE
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE   PROC RPT_CONTRACT_ANNEXTURE(        
 @STATUSID VARCHAR(15),        
 @STATUSNAME VARCHAR(25),         
 @FROMDATE VARCHAR(11),     
 @TODATE VARCHAR(11),    
 @FROMBRANCH VARCHAR(15),      
 @TOBRANCH VARCHAR(15),  
 @FROMSUB_BROKER VARCHAR(10),        
 @TOSUB_BROKER VARCHAR(10),
 @FROMPARTY VARCHAR(15),       
 @TOPARTY VARCHAR(15),             
 @SETT_TYPE VARCHAR(2),      
 @SELECTIONTYPE VARCHAR(1)       
 )        
         
 AS        
       
 SET NOCOUNT ON         
        
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED         
  
--EXEC RPT_CONTRACTSUMMARY 'BROKER','BROKER','JAN  1 2004','JAN  1 2007','0','ZZZZZZ','0','ZZZZZZZ','ALL'        
--EXEC RPT_CONTRACT_ANNEXTURE 'BROKER','BROKER','JAN  1 2004','JAN  1 2007','0','ZZZZZZ','0','ZZZZZZZ','0','ZZZZZZZ','N','N'        
--RPT_CONTRACT_ANNEXTURE 'broker','broker', 'Sep 20 2004' , 'Sep 20 2007' , '0','zzzzz' , '0' , 'zzzz', '000' , 'ZZZZ' , 'N' , 'N'   
BEGIN    
 SELECT         
  PARTY_CODE,        
  C1.BRANCH_CD,        
  CL_TYPE,        
  C1.LONG_NAME,        
  BRANCH = ISNULL(BRANCH,''),      
  SUB_BROKER = ISNULL(SUB_BROKER,'')         
 INTO  #CLIENTMASTER         
 FROM        
  CLIENT1 C1 WITH(NOLOCK)        
   LEFT OUTER JOIN         
   BRANCH ON (BRANCH_CODE = BRANCH_CD),        
  CLIENT2 C2 WITH(NOLOCK)        
 WHERE        
  C1.CL_CODE = C2.CL_CODE        
  AND C2.PARTY_CODE >= @FROMPARTY        
  AND C2.PARTY_CODE <= @TOPARTY        
  AND BRANCH_CD >= @FROMBRANCH        
  AND BRANCH_CD <= @TOBRANCH       
  AND SUB_BROKER >= @FROMSUB_BROKER        
  AND SUB_BROKER <= @TOSUB_BROKER       
  AND @STATUSNAME =         
  (CASE         
                        WHEN @STATUSID = 'BRANCH'         
                        THEN C1.BRANCH_CD         
                        WHEN @STATUSID = 'SUBBROKER'         
                        THEN C1.SUB_BROKER         
                        WHEN @STATUSID = 'TRADER'         
                        THEN C1.TRADER         
                        WHEN @STATUSID = 'FAMILY'         
                        THEN C1.FAMILY         
                        WHEN @STATUSID = 'AREA'         
                        THEN C1.AREA         
                        WHEN @STATUSID = 'REGION'         
                        THEN C1.REGION         
                        WHEN @STATUSID = 'CLIENT'         
                        THEN C2.PARTY_CODE         
                        ELSE 'BROKER' END)        
END        
    
    
    
IF  (@SELECTIONTYPE = 'N')     
BEGIN     
 SELECT
  Convert(Varchar,Sauda_Date,112),
  S.Party_code,         
  S.ContractNo,       
  Sett_no = S.Sett_no,         
  branch_cd=C.branch_cd,        
  cl_type= cl_type,        
  sett_type= S.sett_type,        
  MRATE = MARKETRATE,        
  AMOUNT = TRADEQTY*MARKETRATE,        
  Partyname = C.Long_name,        
  Partipantcode = S.Partipantcode,      
  Order_No= S.Order_No,      
  Trade_No=S.Trade_No,    
  Scrip_Cd = S.scrip_cd,    
  Series=S.Series,      
  Tradeqty = S.Tradeqty,      
  --Tradedate = left(convert(varchar,sauda_date,109),11),
  TradeDate = Convert(Varchar,Sauda_Date,103) +' '+ Convert(Varchar,Sauda_Date,108), 
  BranchName = ISNULL(Branch,''),        
  Sell_Buy = (Case When S.Sell_Buy = 1 Then 'B' Else 'S' ENd)       
  FROM         
  SETTLEMENT S WITH(NOLOCK),        
  SETT_MST M WITH(NOLOCK),         
  #CLIENTMASTER C WITH(NOLOCK)        
        
 WHERE         
  S.Sett_No = M.Sett_No         
  And S.Sett_Type = M.Sett_Type         
  And S.party_code = C.party_code        
  And S.tradeqty > 0        
  And Sauda_date >= @FROMDATE        
  And Sauda_date <= @TODATE + ' 23:59'         
  And AuctionPart Not in ('AP','AR','FA','FC','FS','FL','FP')        
  --ORDER BY S.Party_code, S.ContractNo,     
  --S.Sett_no, C.branch_cd, S.sett_type      
        
     /*-------*/        
 UNION        
     /*-------*/ 
        
 SELECT         
  Convert(Varchar,Sauda_Date,112),
  S.Party_code,         
  S.ContractNo,       
  Sett_no = S.Sett_no,         
  branch_cd = C.branch_cd,        
  cl_type= cl_type,        
  sett_type= S.sett_type,        
  MRATE = MARKETRATE,        
  AMOUNT = TRADEQTY*MARKETRATE,        
  Partyname = C.Long_name,        
  Partipantcode = S.Partipantcode,      
  Order_No= S.Order_No,      
  Trade_No=S.Trade_No,    
  Scrip_Cd = S.scrip_cd,    
  Series=S.Series,      
  Tradeqty = S.Tradeqty,      
  --Tradedate = left(convert(varchar,sauda_date,109),11),        
  TradeDate = Convert(Varchar,Sauda_Date,103) +' '+ Convert(Varchar,Sauda_Date,108), 
  BranchName = ISNULL(Branch,''),        
  Sell_Buy = (Case When S.Sell_Buy = 1 Then 'B' Else 'S' ENd)       
      
 FROM         
  HISTORY S WITH(NOLOCK),        
  SETT_MST M WITH(NOLOCK),         
  #CLIENTMASTER C WITH(NOLOCK)        
        
 WHERE         
  S.Sett_No = M.Sett_No         
  And S.Sett_Type = M.Sett_Type         
  And S.party_code = C.party_code        
  And S.tradeqty > 0        
  And Sauda_date >= @FROMDATE        
  And Sauda_date <= @TODATE + ' 23:59'         
  And AuctionPart Not in ('AP','AR','FA','FC','FS','FL','FP')        
      
ORDER BY 
  	Convert(Varchar,Sauda_Date,112),
	S.Party_code, 
	S.Tradedate,
	S.Sett_no,
	S.sett_type,
	S.ContractNo,
	S.Scrip_Cd,
	S.Sell_Buy
END    
    
        
IF  (@SELECTIONTYPE = 'I')     
BEGIN     
 SELECT         
  Convert(Varchar,Sauda_Date,112),
  S.Party_code,         
  S.ContractNo,       
  Sett_no = S.Sett_no,         
  branch_cd=C.branch_cd,        
  cl_type= cl_type,        
  sett_type= S.sett_type,        
  MRATE = MARKETRATE,        
  AMOUNT = TRADEQTY*MARKETRATE,        
  Partyname = C.Long_name,        
  Partipantcode = S.Partipantcode,      
  Order_No= S.Order_No,      
  Trade_No=S.Trade_No,    
  Scrip_Cd = S.scrip_cd,    
  Series=S.Series,      
  Tradeqty = S.Tradeqty,      
  --Tradedate = left(convert(varchar,sauda_date,109),11),        
  TradeDate = Convert(Varchar,Sauda_Date,103) +' '+ Convert(Varchar,Sauda_Date,108), 
  BranchName = ISNULL(Branch,''),        
  Sell_Buy = (Case When S.Sell_Buy = 1 Then 'B' Else 'S' ENd)       
        
 FROM         
  ISETTLEMENT S WITH(NOLOCK),        
  SETT_MST M WITH(NOLOCK),         
  #CLIENTMASTER C WITH(NOLOCK)        
        
 WHERE         
  S.Sett_No = M.Sett_No         
  And S.Sett_Type = M.Sett_Type         
  And S.party_code = C.party_code        
  And S.tradeqty > 0        
  And Sauda_date >= @FROMDATE        
  And Sauda_date <= @TODATE + ' 23:59'         
  And AuctionPart Not in ('AP','AR','FA','FC','FS','FL','FP')        
  --ORDER BY S.Party_code, S.ContractNo,     
  --S.Sett_no, C.branch_cd, S.sett_type      
        
     /*-------*/        
 UNION        
     /*-------*/     
       
        
        
 SELECT         
  Convert(Varchar,Sauda_Date,112),
  S.Party_code,         
  S.ContractNo,       
  Sett_no = S.Sett_no,         
  branch_cd=C.branch_cd,        
  cl_type= cl_type,        
  sett_type= S.sett_type,        
  MRATE = MARKETRATE,        
  AMOUNT = TRADEQTY*MARKETRATE,        
  Partyname = C.Long_name,        
  Partipantcode = S.Partipantcode,      
  Order_No= S.Order_No,      
  Trade_No=S.Trade_No,    
  Scrip_Cd = S.scrip_cd,    
  Series=S.Series,      
  Tradeqty = S.Tradeqty,      
  --Tradedate = left(convert(varchar,sauda_date,109),11),        
  TradeDate = Convert(Varchar,Sauda_Date,103) +' '+ Convert(Varchar,Sauda_Date,108), 
  BranchName = ISNULL(Branch,''),        
  Sell_Buy = (Case When S.Sell_Buy = 1 Then 'B' Else 'S' ENd)       
        
 FROM         
  IHISTORY S WITH(NOLOCK),        
  SETT_MST M WITH(NOLOCK),         
  #CLIENTMASTER C WITH(NOLOCK)        
        
 WHERE         
  S.Sett_No = M.Sett_No         
  And S.Sett_Type = M.Sett_Type         
  And S.party_code = C.party_code        
  And S.tradeqty > 0        
  And Sauda_date >= @FROMDATE        
  And Sauda_date <= @TODATE + ' 23:59'         
  And AuctionPart Not in ('AP','AR','FA','FC','FS','FL','FP')        
      
ORDER BY 
  Convert(Varchar,Sauda_Date,112),
  S.Party_code, 
  S.Tradedate,
  S.Sett_no,
  S.sett_type,
  S.ContractNo,
  S.Scrip_Cd,
  S.Sell_Buy

END     
    
ELSE    
    
BEGIN     
 SELECT         
  Convert(Varchar,Sauda_Date,112),
  S.Party_code,         
  S.ContractNo,       
  Sett_no = S.Sett_no,         
  branch_cd=C.branch_cd,        
  cl_type= cl_type,        
  sett_type= S.sett_type,        
  MRATE = MARKETRATE,        
  AMOUNT = TRADEQTY*MARKETRATE,        
  Partyname = C.Long_name,        
  Partipantcode = S.Partipantcode,      
  Order_No= S.Order_No,      
  Trade_No=S.Trade_No,    
  Scrip_Cd = S.scrip_cd,    
  Series=S.Series,      
  Tradeqty = S.Tradeqty,      
  --Tradedate = left(convert(varchar,sauda_date,109),11),        
  TradeDate = Convert(Varchar,Sauda_Date,103) +' '+ Convert(Varchar,Sauda_Date,108), 
  BranchName = ISNULL(Branch,''),        
  Sell_Buy = (Case When S.Sell_Buy = 1 Then 'B' Else 'S' ENd)       
        
 FROM         
  SETTLEMENT S WITH(NOLOCK),        
  SETT_MST M WITH(NOLOCK),         
  #CLIENTMASTER C WITH(NOLOCK)        
        
 WHERE         
  S.Sett_No = M.Sett_No         
  And S.Sett_Type = M.Sett_Type         
  And S.party_code = C.party_code        
  And S.tradeqty > 0        
  And Sauda_date >= @FROMDATE        
  And Sauda_date <= @TODATE + ' 23:59'         
  And AuctionPart Not in ('AP','AR','FA','FC','FS','FL','FP')        
  And Cl_type = 'INS'     
  --ORDER BY S.Party_code, S.ContractNo,     
  --S.Sett_no, C.branch_cd, S.sett_type      
    
     /*-------*/        
 UNION        
     /*-------*/     
       
        
        
 SELECT         
  Convert(Varchar,Sauda_Date,112),
  S.Party_code,         
  S.ContractNo,       
  Sett_no = S.Sett_no,         
  branch_cd=C.branch_cd,        
  cl_type= cl_type,        
  sett_type= S.sett_type,        
  MRATE = MARKETRATE,        
  AMOUNT = TRADEQTY*MARKETRATE,        
  Partyname = C.Long_name,        
  Partipantcode = S.Partipantcode,      
  Order_No= S.Order_No,      
  Trade_No=S.Trade_No,    
  Scrip_Cd = S.scrip_cd,    
  Series=S.Series,      
  Tradeqty = S.Tradeqty,      
  --Tradedate = left(convert(varchar,sauda_date,109),11),        
  TradeDate = Convert(Varchar,Sauda_Date,103) +' '+ Convert(Varchar,Sauda_Date,108), 
  BranchName = ISNULL(Branch,''),        
  Sell_Buy = (Case When S.Sell_Buy = 1 Then 'B' Else 'S' ENd)       
        
 FROM         
  HISTORY S WITH(NOLOCK),        
  SETT_MST M WITH(NOLOCK),         
  #CLIENTMASTER C WITH(NOLOCK)        
        
 WHERE         
  S.Sett_No = M.Sett_No         
  And S.Sett_Type = M.Sett_Type         
  And S.party_code = C.party_code        
  And S.tradeqty > 0        
  And Sauda_date >= @FROMDATE        
  And Sauda_date <= @TODATE + ' 23:59'         
  And AuctionPart Not in ('AP','AR','FA','FC','FS','FL','FP')        
  And Cl_type = 'INS'     
      
ORDER BY 
  Convert(Varchar,Sauda_Date,112),
	S.Party_code, 
	S.Tradedate,
	S.Sett_no,
	S.sett_type,
	S.ContractNo,
	S.Scrip_Cd,
	S.Sell_Buy

END

GO
