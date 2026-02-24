-- Object: PROCEDURE dbo.DvpContCumBill_Section_BSECM_History
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc DvpContCumBill_Section_BSECM_History 
(  
@Statusid Varchar(15),   
@Statusname Varchar(25),      
@Sdate Varchar(12),    
@Sett_No Varchar(10),    
@Sett_Type Varchar(3),     
@Fromparty_Code Varchar(10),   
@Toparty_Code Varchar(10),     
@FromContractno Varchar(12),
@ToContractno Varchar(12),
@Branch Varchar(10),   
@Sub_Broker Varchar(10)
)

As    
  
    
Set  Transaction Isolation Level Read Uncommitted  
  
Select S.Party_Code, S.Billno, S.Contractno, 
 Order_No = Min(S.Order_No), Tm = Convert(Char,Min(S.Sauda_Date), 8),    
 Trade_No = Min(S.Trade_No), 
 Sauda_Date = Left(Convert(Varchar,Sauda_Date,109),11), S.Scrip_Cd, S.Series,    
 Scripname = S1.Long_Name, Sdt = Substring(Convert(Varchar,Min(Sauda_Date), 109), 1, 11),    
 S.Sell_Buy, S.Markettype,    
 Service_Tax = Sum(Isnull(S.Service_Tax, 0)),    
 Nsertax = Sum((Case When Service_Chrg = 0 Then Nsertax Else 0 End)), 
 N_Netrate = Sum(N_Netrate*TradeQty)/sum(TradeQty), Cl_Rate = 0,     
 Pqty = Sum(Isnull((Case Sell_Buy    
  When 1 Then S.Tradeqty End), 0)),    
 Sqty = Sum(Isnull((Case Sell_Buy    
  When 2 Then S.Tradeqty End), 0)),    
 Prate = Isnull((Case Sell_Buy    
  When 1 Then Sum(S.Marketrate*TradeQty)/sum(TradeQty) End), 0),    
 Srate = Isnull((Case Sell_Buy    
  When 2 Then Sum(S.Marketrate*TradeQty)/sum(TradeQty) End), 0),    
 Pbrok = Isnull((Case Sell_Buy  When 1 Then Sum(S.Nbrokapp*TradeQty)/sum(TradeQty) + (Case When Service_Chrg = 1   
               Then Sum(Nsertax)/Sum(Tradeqty)   
               Else 0   
    End) End), 0),    
 Sbrok = Isnull((Case Sell_Buy When 2 Then Sum(S.Nbrokapp*TradeQty)/sum(TradeQty) + (Case When Service_Chrg = 1   
               Then Sum(Nsertax)/Sum(Tradeqty)
               Else 0   
    End)end), 0),    
 Pnetrate = Isnull((Case Sell_Buy When 1 Then Sum(S.N_Netrate*TradeQty)/sum(TradeQty) + (Case When Service_Chrg = 1   
               Then Sum(Nsertax)/Sum(Tradeqty)
               Else 0   
    End) End), 0),    
 Snetrate = Isnull((Case Sell_Buy When 2 Then Sum(S.N_Netrate*TradeQty)/sum(TradeQty) - (Case When Service_Chrg = 1   
               Then Sum(Nsertax)/Sum(Tradeqty)
               Else 0   
    End)  End), 0),    
 Pamt = Isnull(Sum(Case Sell_Buy When 1 Then ((S.N_Netrate)* S.Tradeqty)+ (Case When Service_Chrg = 1   
               Then Nsertax  
               Else 0   
    End) End), 0),    
 Samt = Isnull(Sum(Case Sell_Buy When 2 Then ((S.N_Netrate)* S.Tradeqty)- (Case When Service_Chrg = 1   
               Then Nsertax  
               Else 0   
    End)  End), 0),    
 Brokerage = Isnull(Sum(Tradeqty*Convert(Numeric(9, 2), Brokapplied)+ (Case When Service_Chrg = 1 Then Nsertax   
               Else 0   
    End)), 0) ,    
 Newbrokerage = Isnull(Sum(Tradeqty*Convert(Numeric(9, 2), Nbrokapp)), 0) ,    
 --Tmark 		= (Case When Billflag = 4 Or Billflag = 5 Or Billflag = 1 Then 'D' Else '' End) ,    
 Tmark		= '',
 Turn_Tax 	= Sum(Case When Turnover_Tax = 1 Then Turn_Tax Else 0 End),    
 Sebi_Tax 	= Sum(Case When Sebi_Turn_Tax = 1 Then Sebi_Tax Else 0 End),    
 Ins_Chrg 	= Sum(Case When Insurance_Chrg = 1 Then Ins_Chrg Else 0 End),    
 Other_Chrg 	= Sum(Case When C2.Other_Chrg = 1 Then S.Other_Chrg Else 0 End),    
 Broker_Chrg 	= Sum(Case When Brokernote = 1 Then Broker_Chrg Else 0 End),   
 Partyname 	= C1.Long_Name,   
 C1.L_Address1, C1.L_Address2, C1.L_Address3,   
 C1.L_City, C1.L_Zip, C2.Service_Chrg, C1.Branch_Cd , C1.Sub_Broker, C1.Pan_Gir_No,   
 C1.Off_Phone1, C1.Off_Phone2, Printf, C1.Fd_Code,   
 Branch_CD, S.Sett_No, Mapidid  

From History S
left outer join ucc_client uc on (s.party_code = uc.party_code), 
Scrip2 S2 , Scrip1 S1, Client1 C1, Client2 C2    

Where S.Scrip_Cd = S2.Bsecode    
And S1.Co_Code = S2.Co_Code    
And S1.Series = S2.Series    
And C1.Cl_Code = C2.Cl_Code     
And S.Party_Code = C2.Party_Code    
And S.Sett_No = @Sett_No    
And S.Sett_Type = @Sett_Type    
And S.Sauda_date Like @Sdate + '%'
And Cl_Type = 'INS'
And S.Party_Code Between @Fromparty_Code And  @Toparty_Code   
And S.Contractno between @FromContractno And  @ToContractno 
And S.Tradeqty > 0    

And Branch_Cd Like (Case When @Statusid = 'Branch' Then @Statusname Else '%' End)  
And Sub_Broker Like (Case When @Statusid = 'Subbroker' Then @Statusname Else '%' End)  
And Trader Like (Case When @Statusid = 'Trader' Then @Statusname Else '%' End)  
And Family Like (Case When @Statusid = 'Family' Then @Statusname Else '%' End)  
And C2.Party_Code Like (Case When @Statusid = 'Client' Then @Statusname Else '%' End)  
And Region Like (Case When @Statusid = 'Region' Then @Statusname Else '%' End)  

And Branch_Cd Like @Branch  
And Sub_Broker Like @Sub_Broker  

Group By ContractNo,s.Party_code,Left(Convert(Varchar,Sauda_Date,109),11),S.Scrip_Cd,S.Series,S1.Long_Name,    
Sell_Buy,MarketType,/*Billflag,*/ billno,
C1.Long_Name, C1.L_Address1, C1.L_Address2, C1.L_Address3,   
C1.L_City, C1.L_Zip, C2.Service_Chrg, C1.Branch_Cd , C1.Sub_Broker, C1.Pan_Gir_No,   
C1.Off_Phone1, C1.Off_Phone2, Printf, C1.Fd_Code, Branch_CD, S.Sett_No, Mapidid

Order By Branch_CD, C1.Sub_Broker, S.Party_Code, S1.Long_Name, ContractNo, Order_No, Trade_No

GO
