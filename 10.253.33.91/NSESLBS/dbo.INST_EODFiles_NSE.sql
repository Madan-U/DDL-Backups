-- Object: PROCEDURE dbo.INST_EODFiles_NSE
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Procedure INST_EODFiles_NSE                    
@fdate varchar(11),                    
@ffamily varchar(10),                    
@tfamily varchar(10),                    
@fparty varchar(10),                    
@tparty varchar(10),                    
@fcontno varchar(7),                    
@tcontno varchar(7),                    
@sellbuy varchar(2)                    
----------------------Total Charges Computation---------------------------                    
--TotalBrokerage + ServiceTax + STT                    
----------------------Total Charges Computation---------------------------                    
----------------------Settlement Amount Computation---------------------------                    
--BUY Trades                    
--MarketValue + (TotalBrokerage + ServiceTax + STT)                    
--SELL Trades                    
--MarketValue - (TotalBrokerage + ServiceTax + STT)                    
----------------------Settlement Amount Computation---------------------------                    
As                    
Select             
 TradeDate = Left(Convert(Varchar,S.Sauda_Date,101),10),                
 TradeDate1 = Left(Convert(Varchar,S.Sauda_Date,103),10),                          
 S.Contractno as contractno,                     
 S.Party_Code as partycode,                     
 S.Scrip_Cd as scripcd,                
 ScripName = S1.short_name,                     
 Sell_buy,                     
 TradeQty = Sum(S.TradeQty),                      
 MarketValue = Sum(S.MarketRate * S.TradeQty),                    
 s.marketrate as marketrate,                      
/*PerShareBrokerage = Sum(S.BrokApplied * S.TradeQty) / Sum(TradeQty)*/
 PerShareBrokerage = Sum(S.BrokApplied * S.TradeQty) / Sum(case  TradeQty when 0 then 1 else tradeqty end),                         
 TotalBrokerage = Sum(S.BrokApplied * S.TradeQty),                    
 s.netrate as netrate,                    
 NetValue = Sum(S.NetRate * S.TradeQty),                      
 ServiceTax = Sum(Service_Tax),                     
 STT = Sum(Ins_Chrg),                     
 C.Long_Name as longname,      
 c.Short_Name as ShortName,             
 C.CPCode as cpcode ,                     
 C.Custodian as custodian,                     
 C.MapinId as mapinid,                     
 C.FmCode fmcode,                     
 C.Ucc_Code as ucc,                     
 C.Family family,                     
 ISIN = isnull(M.ISIN,''),                     
 SM.Sett_no as settno,                     
 S.Sett_Type as setttype,                     
 SettlementDate = Left(Convert(Varchar,SM.Funds_Payin,103),10),              
 SettlementDate1 = convert(varchar,SM.Funds_Payin,101),        
 Exchange = 'NSE',                     
 Segment = 'NORMAL'  ,                  
 S.series as series,          
 TradeType = 'CH'          
From                   
 ISettlement S,                     
 Scrip1 S1,                     
 Scrip2 S2 Left Outer Join MultiIsin M On (M.Scrip_Cd = S2.Scrip_Cd And M.Series = S2.Series And M.Valid = 1),                     
 (                  
 Select *                   
 From Sett_Mst                   
 Where @fdate Between Start_Date And End_Date                  
 ) SM,                     
 (                  
 Select                     
 C1.Cl_Code,                     
 C2.Party_Code,                     
 C1.Long_Name,                     
 C1.Short_Name,                     
 CPCode = C2.BankId,                     
 Custodian = C2.CltDpNo,                     
 MapinId = Isnull(U.MapidId,''),                     
 FmCode = Isnull(U.FmCode,''),                     
 Ucc_Code = Isnull(U.Ucc_Code,''),                     
 C1.Family                    
 From                   
  Client1 C1,                   
  Client2 C2                   
   Left Outer Join UCC_Client U                   
   On (C2.Party_Code = U.Party_Code)                    
 Where C1.Cl_Code = C2.Cl_Code                     
 And C2.Party_Code Between @fparty And @tparty             
 And C1.Family Between @ffamily And @tfamily                    
 And C1.Cl_Type = 'INS'                  
 ) C                     
Where C.Party_Code = S.Party_Code                  
And S.Scrip_Cd = S2.Scrip_Cd                    
And S.Series = S2.Series                     
And S2.Co_Code = S1.Co_Code                    
And S2.Series = S1.Series                    
--And S.Sett_No = SM.Sett_No                    
And S.Sett_Type = SM.Sett_Type                 
And Left(Convert(Varchar,S.Sauda_Date,109),11) = @fdate                    
And S.ContractNo Between @fcontno And @tcontno                    
And S.Sell_Buy Between left(@sellbuy,1) And right(@sellbuy,1) 
Group By                     
 S.Contractno,                     
 S.Party_Code,           
 S.Scrip_Cd,                     
 S1.short_name,                     
 S.Sell_buy,                    
 s.series,                  
 Left(Convert(Varchar,S.Sauda_Date,101),10),                
 Left(Convert(Varchar,S.Sauda_Date,103),10),               
 C.Long_Name,      
 c.Short_Name,      
 C.CPCode ,                     
 C.Custodian,                     
 C.MapinId,                     
 C.FmCode,                     
 C.Ucc_Code,                     
 C.Family,                     
 M.ISIN,                     
 SM.Sett_no,                     
 S.Sett_Type,                    
 s.netrate,                     
 s.marketrate,                    
 Left(Convert(Varchar,SM.Funds_Payin,103),10),        
 Convert(Varchar,SM.Funds_Payin,101)        
--left(convert(varchar,SM.Funds_Payin,101),6) + right(convert(varchar,SM.Funds_Payin,101),2)               
Union All          
          
Select             
 TradeDate = Left(Convert(Varchar,S.Sauda_Date,101),10),                
 TradeDate1 = Left(Convert(Varchar,S.Sauda_Date,103),10),                          
 S.Contractno as contractno,                     
 S.Party_Code as partycode,                     
 S.Scrip_Cd as scripcd,                
 ScripName = S1.short_name,                     
 Sell_buy,                     
 TradeQty = Sum(S.TradeQty),                      
 MarketValue = Sum(S.MarketRate * S.TradeQty),                    
 s.marketrate as marketrate,                      
 PerShareBrokerage = Sum(S.BrokApplied * S.TradeQty) / Sum(TradeQty),                     
 TotalBrokerage = Sum(S.BrokApplied * S.TradeQty),                    
 s.netrate as netrate,                    
 NetValue = Sum(S.NetRate * S.TradeQty),                      
 ServiceTax = Sum(Service_Tax),                     
 STT = Sum(Ins_Chrg),                     
 C.Long_Name as longname,                     
 C.Short_Name as shortName,             
 C.CPCode as cpcode ,                     
 C.Custodian as custodian,                     
 C.MapinId as mapinid,                     
 C.FmCode fmcode,                     
 C.Ucc_Code as ucc,                     
 C.Family family,                     
 ISIN = isnull(M.ISIN,''),                     
 SM.Sett_no as settno,                     
 S.Sett_Type as setttype,                     
 SettlementDate = Left(Convert(Varchar,SM.Funds_Payin,103),10),              
 SettlementDate1 = Convert(Varchar,SM.Funds_Payin,101),        
 Exchange = 'NSE',                     
 Segment = 'NORMAL'  ,                  
 S.series as series,          
 TradeType = 'DVP'          
From                   
 Settlement S,                     
 Scrip1 S1,                     
 Scrip2 S2 Left Outer Join MultiIsin M On (M.Scrip_Cd = S2.Scrip_Cd And M.Series = S2.Series And M.Valid = 1),                     
 (                  
 Select *                   
 From Sett_Mst                   
 Where @fdate Between Start_Date And End_Date                  
 ) SM,                     
 (                  
 Select                     
 C1.Cl_Code,                     
 C2.Party_Code,                     
 C1.Long_Name,                     
 C1.Short_Name,                     
 CPCode = C2.BankId,                     
 Custodian = C2.CltDpNo,                     
 MapinId = Isnull(U.MapidId,''),                     
 FmCode = Isnull(U.FmCode,''),                     
 Ucc_Code = Isnull(U.Ucc_Code,''),                     
 C1.Family               
 From                   
  Client1 C1,                   
  Client2 C2                   
   Left Outer Join UCC_Client U                   
   On (C2.Party_Code = U.Party_Code)                    
 Where C1.Cl_Code = C2.Cl_Code                     
 And C2.Party_Code Between @fparty And @tparty                    
 And C1.Family Between @ffamily And @tfamily                  
 And C1.Cl_Type = 'INS'                  
 ) C                     
Where C.Party_Code = S.Party_Code                  
And S.Scrip_Cd = S2.Scrip_Cd                    
And S.Series = S2.Series                     
And S2.Co_Code = S1.Co_Code                    
And S2.Series = S1.Series                    
--And S.Sett_No = SM.Sett_No                    
And S.Sett_Type = SM.Sett_Type                    
And Left(Convert(Varchar,S.Sauda_Date,109),11) = @fdate                    
And S.ContractNo Between @fcontno And @tcontno                    
And S.Sell_Buy Between left(@sellbuy,1) And right(@sellbuy,1)                    
Group By                     
 S.Contractno,                     
 S.Party_Code,                
 S.Scrip_Cd,                     
 S1.short_name,                     
 S.Sell_buy,                    
 s.series,                  
 Left(Convert(Varchar,S.Sauda_Date,101),10),                
 Left(Convert(Varchar,S.Sauda_Date,103),10),               
 C.Long_Name,      
 c.Short_Name,      
 C.CPCode ,                     
 C.Custodian,                     
 C.MapinId,                     
 C.FmCode,                     
 C.Ucc_Code,                     
 C.Family,                     
 M.ISIN,                     
 SM.Sett_no,                     
 S.Sett_Type,                    
 s.netrate,                     
 s.marketrate,                    
 Left(Convert(Varchar,SM.Funds_Payin,103),10),        
 Convert(Varchar,SM.Funds_Payin,101)               
 order by S.Scrip_Cd,c.Short_Name

GO
