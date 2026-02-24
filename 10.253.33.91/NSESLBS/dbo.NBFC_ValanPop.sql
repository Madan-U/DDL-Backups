-- Object: PROCEDURE dbo.NBFC_ValanPop
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc [dbo].[NBFC_ValanPop] (@MarginDate Varchar(11), @Party_Code Varchar(10)) As            
Declare @PrevDate Varchar(11),            
@CollCltCode Varchar(10),            
@FundCltCode Varchar(10)       

Select @CollCltCode = AcCode From ValanAccount where acname = 'COLLATERAL ACCOUNT'            
Select @FundCltCode = AcCode From ValanAccount where acname = 'FUNDING ACCOUNT'            
            
Select @PrevDate = Isnull(Left(Convert(Varchar,Max(MarginDate),109),11),'Jan  1 2000') 
From NBFCValan_Detail  (nolock)
Where MarginDate < @MarginDate     
            
Truncate Table NBFCValan_Detail_Up   
  
Insert into NBFCValan_Detail_Up            
Select sett_no='',sett_type='',s.party_code, S.Scrip_Cd, Series,           
PAmt =    IsNull(Sum(Case When TradeType = 'BT'             
                          Then Case When Sell_Buy = 1             
                      Then TradeQty*MarketRate            
                      Else 0             
                        End             
                        Else 0        
                          End),0),            
NetSell = IsNull(Sum(Case When TradeType = 'BT'             
                          Then Case When Sell_Buy = 2             
                      Then TradeQty*MarketRate            
                      Else 0             
                        End             
        Else 0          
                          End),0),            
POrL = IsNull(Sum(Case When Sell_Buy = 2 And BillFlag = 3             
           Then TradeQty*MarketRate            
                         Else 0             
             End),0) -             
       IsNull(Sum(Case When Sell_Buy = 1 And BillFlag = 2            
           Then TradeQty*MarketRate            
                         Else 0             
             End),0),            
GrossSell = IsNull(Sum(Case When TradeType = 'BT'             
                            Then Case When Sell_Buy = 2             
                        Then TradeQty*MarketRate            
                                      Else 0             
                            End             
                        Else 0        
                       End),0) - (            
         IsNull(Sum(Case When Sell_Buy = 2 And BillFlag = 3             
           Then TradeQty*MarketRate            
                         Else 0             
             End),0) -             
         IsNull(Sum(Case When Sell_Buy = 1 And BillFlag = 2            
           Then TradeQty*MarketRate            
                Else 0             
             End),0) ), MarginDate,             
NetBal = -IsNull(Sum(Case When Sell_Buy = 1             
                          Then TradeQty*MarketRate            
                          Else 0             
                     End),0),      
OpenPos = 0, FundingPer = 0,      
ReqFunding = 0, MarginLedgerBal = 0,       
Required = 0, MarginAmount = 0,       
@FundCltCode, @CollCltCode,      
ClosePos = IsNull( Sum(Case When AuctionPart = 'C'       
                            Then ( Case When Sell_Buy = 1       
                                        Then TradeQty * MarketRate       
                                        Else - TradeQty * MarketRate       
                                   End )      
                       Else 0      
                       End), 0)       
From NBFC_TRANS_PROCESS S (nolock), Client2 C2 (nolock), Owner (nolock), Client1 (nolock)             
Where left(convert(varchar,MarginDate,109),11) = @MarginDate           
And C2.Party_Code = S.Party_Code and client1.cl_code = c2.cl_code              
And C2.Party_Code Like @Party_Code    
group by s.party_code, MarginDate, S.Scrip_Cd, S.Series            
            
Update NBFCValan_Detail_Up Set NetBal = NetBal + GrossSell, OpenPos = -(NetBal + GrossSell), FundingPer = 100            
Where left(convert(varchar,MarginDate,109),11) = @MarginDate           
And Party_Code Like @Party_Code    
            
Update NBFCValan_Detail_Up Set FundingPer = Margin_Funding From TblClientMargin T  (nolock)          
Where left(convert(varchar,MarginDate,109),11) = @MarginDate And NBFCValan_Detail_Up.Party_Code = T.Party_Code            
And T.Scrip_Cd = 'ALL' And MarginDate Between From_Date And To_Date             
And T.Party_Code Like @Party_Code    
            
Update NBFCValan_Detail_Up Set ReqFunding = OpenPos * FundingPer / 100            
Where left(convert(varchar,MarginDate,109),11) = @MarginDate                 
And Party_Code Like @Party_Code    
    
Truncate Table NBFCValan_Up   
          
Insert into NBFCValan_Up           
Select sett_no, sett_type, party_code, sum(PAmt), sum(NetSell), sum(POrL), sum(GrossSell), MarginDate, sum(NetBal), sum(OpenPos),           
FundingPer, sum(ReqFunding), sum(MarginLedgerBal), sum(Required), sum(MarginAmount), FundingCode, CollateralCode, Sum(ClosePos)      
From NBFCValan_Detail_Up     (nolock)       
Where left(convert(varchar,MarginDate,109),11) = @MarginDate           
And Party_Code Like @Party_Code    
Group By sett_no, sett_type, party_code, MarginDate, FundingPer, FundingCode, CollateralCode          
          
Update NBFCValan_Up Set MarginLedgerBal = Amount From (            
 Select CltCode, Amount = Sum(Case When DrCr = 'C' Then Vamt Else -Vamt End)             
 From Account.DBO.Ledger M (nolock), Account.DBO.Parameter P   (nolock)         
 Where VDt BetWeen SDTCur And LDTCur And @MarginDate BetWeen SDTCur And LDTCur            
 And Vdt < @MarginDate          
 And CltCode Like @Party_Code    
 Group By CltCode ) A            
Where left(convert(varchar,MarginDate,109),11) = @MarginDate            
And NBFCValan_Up.Party_Code = A.CltCode            
And NBFCValan_Up.Party_Code Like @Party_Code    
   
Update NBFCValan_Up Set MarginLedgerBal = MarginLedgerBal + Amount From (            
 Select CltCode, Amount = Sum(Case When DrCr = 'C' Then Vamt Else -Vamt End)             
 From Account.DBO.Ledger M (nolock), Account.DBO.Parameter P   (nolock)         
 Where VDt BetWeen SDTCur And LDTCur And @MarginDate BetWeen SDTCur And LDTCur            
 And Vdt Like @MarginDate + '%'
 And CltCode Like @Party_Code    
 And Vtyp <> 15
 Group By CltCode ) A            
Where left(convert(varchar,MarginDate,109),11) = @MarginDate            
And NBFCValan_Up.Party_Code = A.CltCode            
And NBFCValan_Up.Party_Code Like @Party_Code    

Update NBFCValan_Up Set MarginLedgerBal = MarginLedgerBal + POrL             
Where left(convert(varchar,MarginDate,109),11) = @MarginDate            
And Party_Code Like @Party_Code    

Update NBFCValan_Up Set Required = (Case When (Case When ReqFunding > -(MarginLedgerBal + NetBal )             
                                              Then -(MarginLedgerBal + NetBal )             
                Else ReqFunding            
             End) > 0             
                                        Then (Case When ReqFunding > -(MarginLedgerBal + NetBal )             
                                  Then -(MarginLedgerBal + NetBal )             
                Else ReqFunding            
                                              End)            
                                        Else 0             
                                   End),            
MarginAmount = (Case When (Case When ReqFunding > -(MarginLedgerBal + NetBal )             
                            Then -(MarginLedgerBal + NetBal )             
              Else ReqFunding            
                       End) > 0             
                       Then (Case When ReqFunding > -(MarginLedgerBal + NetBal )             
                                  Then -(MarginLedgerBal + NetBal )             
                    Else ReqFunding            
                             End)            
                       Else 0             
                 End)            
Where left(convert(varchar,MarginDate,109),11) = @MarginDate           
And Party_Code Like @Party_Code    
            
Update NBFCValan_Up Set MarginAmount = MarginAmount - PrevReq From             
(Select Party_Code, PrevReq = Required From NBFCValan   (nolock)         
 Where left(convert(varchar,MarginDate,109),11) = @PrevDate     
 And Party_Code Like @Party_Code) M            
Where left(convert(varchar,MarginDate,109),11) = @MarginDate           
And NBFCValan_Up.Party_Code = M.Party_Code      
And NBFCValan_Up.Party_Code Like @Party_Code    
    
Delete NBFCValan_Detail Where left(convert(varchar,MarginDate,109),11) = @MarginDate           
And Party_Code Like @Party_Code    
  
Insert Into NBFCValan_Detail   
Select * From NBFCValan_Detail_Up (nolock) Where left(convert(varchar,MarginDate,109),11) = @MarginDate           
And Party_Code Like @Party_Code    
  
Delete NBFCValan Where left(convert(varchar,MarginDate,109),11) = @MarginDate           
And Party_Code Like @Party_Code    
  
Insert Into NBFCValan Select * From NBFCValan_Up (nolock) Where left(convert(varchar,MarginDate,109),11) = @MarginDate           
And Party_Code Like @Party_Code

Select Distinct Sett_No, Sett_Type into #Del From NBFC_TRANS_PROCESS
Where left(convert(varchar,Sauda_Date,109),11) = @MarginDate

Delete From DeliveryClt
Where Sett_No in (Select Sett_No From #Del 
	          Where DeliveryClt.Sett_No = #Del.Sett_No
		  And DeliveryClt.Sett_Type = #Del.Sett_Type)

Delete From BSEDB.DBO.DeliveryClt
Where Sett_No in (Select Sett_No From #Del 
	          Where BSEDB.DBO.DeliveryClt.Sett_No = #Del.Sett_No
		  And BSEDB.DBO.DeliveryClt.Sett_Type = #Del.Sett_Type)

Insert into DeliveryClt
Select Sett_No,Sett_Type,Scrip_Cd,Series,Party_Code,
Qty=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE -TRADEQTY END)),
Inout=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE -TRADEQTY END) > 0 
	    THEN 'O' ELSE 'I' END),
Branch_Cd='HO',Partipantcode
From NBFC_TRANS_PROCESS
Where left(convert(varchar,Sauda_Date,109),11) = @MarginDate
AND SETT_TYPE not in ('W', 'C')
GROUP BY Sett_No,Sett_Type,Scrip_Cd,Series,Party_Code,Partipantcode
HAVING ABS(SUM(CASE WHEN SELL_BUY = 1 THEN TRADEQTY ELSE -TRADEQTY END)) <> 0 

Insert into DeliveryClt
Select Sett_No,Sett_Type,Scrip_Cd,Series,Party_Code,
Qty=SUM(TRADEQTY),
Inout=(CASE WHEN SELL_BUY = 1 THEN 'O' ELSE 'I' END),
Branch_Cd='HO',Partipantcode
From NBFC_TRANS_PROCESS
Where left(convert(varchar,Sauda_Date,109),11) = @MarginDate
AND SETT_TYPE in ('W', 'C')
GROUP BY Sett_No,Sett_Type,Scrip_Cd,Series,Party_Code,Partipantcode, SELL_BUY

GO
