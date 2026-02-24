-- Object: PROCEDURE dbo.PR_CHARGES_DETAIL
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE PROC [dbo].[PR_CHARGES_DETAIL]   
(
	@F_Sett_No Varchar(7),  
	@F_Sett_Type Varchar(2),  
	@From_Party Varchar(10),  
	@To_Party Varchar(10)
)  
 AS  
Declare 
	@SettCur Cursor,
	@Party_Code varchar(10),        
	@Sett_No varchar(7),        
	@Sett_Type varchar(2),        
	@Sauda_Date varchar(11),        
	@ContractNo varchar(14),        
	@Trade_No varchar(20),        
	@Order_No varchar(16),        
	@SCRIP_CD varchar(12),        
	@Series Varchar(3),     
	@BuyRate money,        
	@SellRate money,        
	@TrdBuyQty int,        
	@TrdSellQty int,        
	@DelBuyQty int,        
	@DelSellQty int,  
	@TrdBuyQtyOrg int,        
	@TrdSellQtyOrg int,        
	@DelBuyQtyOrg int,        
	@DelSellQtyOrg int,  
	@TrdBuy_TurnOver money,        
	@TrdSell_TurnOver money,        
	@DelBuy_TurnOver money,        
	@DelSell_TurnOver money,        
	@Sp_ComputationLevel Char(1),        
	@Sp_ComputationOn char(1),        
	@Sp_ComputationType char(1),   
	@SchemeId Int,     
	@Min_BrokAmt Money,        
	@Max_BrokAmt Money,        
	@Min_ScripAmt Money,        
	@Max_ScripAmt Money,        
	@Sp_Trd_Type char(3)  
  
Declare 
	@SchemeCur Cursor,        
	@SP_Computation_Level char(1),        
	@SP_Multiplier money,        
	@SP_Buy_Brok_Type char(1),        
	@SP_Sell_Brok_Type char(1),        
	@SP_Buy_Brok numeric (18,4),        
	@SP_Sell_Brok numeric (18,4),        
	@SP_Value_From numeric (18,4),        
	@SP_Value_To numeric (18,4),        
	@BuyFlag int,        
	@SellFlag int,        
	@Sp_Scheme_Type int        
        
Declare         
	@Buy_TurnOver Money,        
	@NewBuyTurnOver Money,        
	@NewBuyTurnOver_1 Money,  
	@NewBuyTurnOverOrg Money,        
	@Sell_TurnOver Money,        
	@NewSellTurnOver Money,        
	@NewSellTurnOver_1 Money,        
	@NewSellTurnOverOrg Money,        
	@BuyBrokerage Money,        
	@SellBrokerage Money,  
	@BuyBrokerage_1 Money,        
	@SellBrokerage_1 Money    

TRUNCATE TABLE VBB_Charges_detail_Temp  
TRUNCATE TABLE VBB_Charges_detail_Temp_1  
TRUNCATE TABLE VBB_Charges_detail_Temp_2  
TRUNCATE TABLE VBB_Settlement  
TRUNCATE TABLE TRD_SCHEME_MAPPING
TRUNCATE TABLE TRD_CONTRACT_ROUNDING 

Set NoCount On  

Insert Into VBB_Settlement Select Sett_No,Sett_Type,Sauda_Date,
	Party_Code,Contractno,Trade_No,Order_No,Scrip_Cd,Series,
	Marketrate,Sell_Buy,Billflag,Tradeqty,NBrokapp,Auctionpart
From
	Settlement
Where
	Sett_No = @F_Sett_No And   
	Sett_Type = @F_Sett_Type And
	Party_Code between  @From_Party And @To_Party And
	TradeQty > 0

Declare @Sauda_Date_FROM varchar(11)

Select @Sauda_Date_FROM = Min(Sauda_Date) From VBB_Settlement

/* POPULATE TRD TABLES FOR BROKERAGE MAPPING AND ROUNDING */

  INSERT INTO TRD_SCHEME_MAPPING
  SELECT *
  FROM   SCHEME_MAPPING M
  WHERE  SP_DATE_TO > @Sauda_Date_FROM 
         AND EXISTS (SELECT DISTINCT PARTY_CODE
                     FROM   VBB_SETTLEMENT S
                     WHERE  M.SP_PARTY_CODE = S.PARTY_CODE)

  INSERT INTO TRD_CONTRACT_ROUNDING
  SELECT *
  FROM   CONTRACT_ROUNDING M
  WHERE  CR_DATE_TO > @Sauda_Date_FROM 
         AND EXISTS (SELECT DISTINCT PARTY_CODE
                     FROM   VBB_SETTLEMENT S
                     WHERE  M.CR_PARTY_CODE = S.PARTY_CODE)

/* DELETE RECORDS FROM TEMPORARY VBB SETTLEMENT TABLE FOR CLIENT WHERE VBB IS NOT DEFINED */

  DELETE FROM VBB_SETTLEMENT
  WHERE       NOT EXISTS (SELECT DISTINCT PARTY_CODE
                          FROM   (SELECT PARTY_CODE = SP_PARTY_CODE
                                  FROM   TRD_SCHEME_MAPPING
                                  WHERE  SAUDA_DATE BETWEEN SP_DATE_FROM AND SP_DATE_TO
                                  UNION 
                                  SELECT PARTY_CODE = CR_PARTY_CODE
                                  FROM   TRD_CONTRACT_ROUNDING
                                  WHERE  SAUDA_DATE BETWEEN CR_DATE_FROM AND CR_DATE_TO) A
                          WHERE  A.PARTY_CODE = VBB_SETTLEMENT.PARTY_CODE)

/*------------------------------------------------------------------------------------------*/
Insert Into VBB_Charges_detail_Temp_1   
Select 
	Party_Code,Sett_No,Sett_Type,Sauda_Date,ContractNo='0',
	Trade_No,Order_No,Scrip_Cd,Series,  
	BuyRate = (Case When Sum(TrdBuy_Qty+DelBuy_Qty) > 0   
	          Then Sum((TrdBuy_Qty+DelBuy_Qty)*BuyRate) / Sum(TrdBuy_Qty+DelBuy_Qty)   
	   Else 0  
	     End),  
	SellRate = (Case When Sum(TrdSell_Qty+DelSell_Qty) > 0   
	          Then Sum((TrdSell_Qty+DelSell_Qty)*SellRate) / Sum(TrdSell_Qty+DelSell_Qty)   
	   Else 0   
	     End),  
	TrdBuy_Qty=Sum(TrdBuy_Qty),  
	TrdSell_Qty=Sum(TrdSell_Qty),  
	DelBuy_Qty=Sum(DelBuy_Qty),  
	DelSell_Qty=Sum(DelSell_Qty),  
	TrdBuyBrokerage=(Case When Sum(RND_TrdBuy_TurnOver) > Sum(TrdBuy_TurnOver) And Sum(DelBuy_TurnOver) > 0   
	        Then Sum(TrdBuyBrokerage_2)   
	        Else Sum(TrdBuyBrokerage_1)  
	   End),  
	TrdSellBrokerage=(Case When Sum(RND_TrdSell_TurnOver) > Sum(TrdSell_TurnOver) And Sum(DelSell_TurnOver) > 0   
	        Then Sum(TrdSellBrokerage_2)   
	        Else Sum(TrdSellBrokerage_1)  
	   End),  
	DelBuyBrokerage=Sum(DelBuyBrokerage),  
	DelSellBrokerage=Sum(DelSellBrokerage),  
	TotalBrokerage = 0,  
	TrdBuy_TurnOver=Sum(TrdBuy_TurnOver),  
	TrdSell_TurnOver=Sum(TrdSell_TurnOver),  
	DelBuy_TurnOver=Sum(DelBuy_TurnOver),  
	DelSell_TurnOver=Sum(DelSell_TurnOver),  
	Sp_Computation_Level,  
	SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt  
From 
(  
	Select 
		Party_Code,Sett_No,Sett_Type,Sauda_Date,ContractNo='0',  
		Trade_No = (Case When Sp_Computation_Level = 'T' Then Trade_No Else '' End),        
		Order_No = (Case When Sp_Computation_Level In ('T', 'O') Then Order_No Else '' End),  
		Scrip_Cd = (Case When Sp_Computation_Level <> 'C' Then Scrip_Cd Else '' End),        
		Series = (Case When Sp_Computation_Level <> 'C' Then Series Else '' End),  
		BuyRate = (Case When Sum(TrdBuy_Qty+DelBuy_Qty) > 0   
		          Then Sum((TrdBuy_Qty+DelBuy_Qty)*MarketRate) / Sum(TrdBuy_Qty+DelBuy_Qty)   
		Else 0   
		     End),  
		SellRate = (Case When Sum(TrdSell_Qty+DelSell_Qty) > 0   
		          Then Sum((TrdSell_Qty+DelSell_Qty)*MarketRate) / Sum(TrdSell_Qty+DelSell_Qty)   
		Else 0   
		     End),    
		TrdBuy_Qty=Sum(TrdBuy_Qty),  
		TrdSell_Qty=Sum(TrdSell_Qty),  
		DelBuy_Qty=Sum(DelBuy_Qty),  
		DelSell_Qty=Sum(DelSell_Qty),  
		TrdBuy_TurnOver=Sum(TrdBuy_TurnOver),  
		TrdSell_TurnOver=Sum(TrdSell_TurnOver),  
		RND_TrdBuy_TurnOver = Pradnya.DBO.RoundedTurnover(Sum(TrdBuy_TurnOver),Sp_Multiplier),  
		RND_TrdSell_TurnOver = Pradnya.DBO.RoundedTurnover(Sum(TrdSell_TurnOver),Sp_Multiplier),  
		DelBuy_TurnOver=Sum(DelBuy_TurnOver),  
		DelSell_TurnOver=Sum(DelSell_TurnOver),  
		TrdBuyBrokerage_1 = (Case When Sp_Scheme_Type = 0         
		                   Then  (Pradnya.DBO.RoundedTurnover(Sum(TrdBuy_TurnOver),Sp_Multiplier)/Sp_Multiplier *         
		                          (Case When Sp_Buy_Brok_Type = 'P'         
		                         Then Sp_Buy_Brok/100         
		                         Else Sp_Buy_Brok         
		                         End))         
		           When (Sum(TrdBuy_TurnOver+DelBuy_TurnOver) >= Sum(TrdSell_TurnOver+DelSell_TurnOver) And Sp_Scheme_Type = 1)         
		      Or (Sum(TrdBuy_TurnOver+DelBuy_TurnOver) > Sum(TrdSell_TurnOver+DelSell_TurnOver) And Sp_Scheme_Type = 3)        
		           Then (Pradnya.DBO.RoundedTurnover(Sum(TrdBuy_TurnOver),Sp_Multiplier)/Sp_Multiplier *         
		         (Case When Sp_Buy_Brok_Type = 'P'         
		               Then Sp_Buy_Brok/100         
		        Else Sp_Buy_Brok         
		          End))        
		           Else (Pradnya.DBO.RoundedTurnover(Sum(TrdBuy_TurnOver),Sp_Multiplier)/Sp_Multiplier *         
		         (Case When Sp_Sell_Brok_Type = 'P'         
		        Then Sp_Sell_Brok/100         
		        Else Sp_Sell_Brok         
		          End))        
		       End),  
		  TrdSellBrokerage_1 = (Case When Sp_Scheme_Type = 0         
		           Then  (Pradnya.DBO.RoundedTurnover(Sum(TrdSell_TurnOver),Sp_Multiplier)/Sp_Multiplier *         
		                       (Case When Sp_Sell_Brok_Type = 'P'         
		               Then Sp_Sell_Brok/100         
		               Else Sp_Sell_Brok         
		                    End))        
		           When (Sum(TrdBuy_TurnOver+DelBuy_TurnOver) >= Sum(TrdSell_TurnOver+DelSell_TurnOver) And Sp_Scheme_Type = 1)         
		      Or (Sum(TrdBuy_TurnOver+DelBuy_TurnOver) > Sum(TrdSell_TurnOver+DelSell_TurnOver) And Sp_Scheme_Type = 3)        
		           Then (Pradnya.DBO.RoundedTurnover(Sum(TrdSell_TurnOver),Sp_Multiplier)/Sp_Multiplier *         
		         (Case When Sp_Sell_Brok_Type = 'P'         
		               Then Sp_Sell_Brok/100         
		        Else Sp_Sell_Brok         
		          End))        
		           Else (Pradnya.DBO.RoundedTurnover(Sum(TrdSell_TurnOver),Sp_Multiplier)/Sp_Multiplier *         
		         (Case When Sp_Buy_Brok_Type = 'P'         
		        Then Sp_Buy_Brok/100         
		        Else Sp_Buy_Brok         
		          End))        
		       End),  
		TrdBuyBrokerage_2 = (Case When Sum(TrdBuy_TurnOver) > 0 Then (Case When Sp_Scheme_Type = 0         
		                   Then  ((Pradnya.DBO.RoundedTurnover(Sum(TrdBuy_TurnOver),Sp_Multiplier)/Sp_Multiplier-1) *         
		                          (Case When Sp_Buy_Brok_Type = 'P'         
		                         Then Sp_Buy_Brok/100         
		                         Else Sp_Buy_Brok         
		                         End))         
		           When (Sum(TrdBuy_TurnOver+DelBuy_TurnOver) >= Sum(TrdSell_TurnOver+DelSell_TurnOver) And Sp_Scheme_Type = 1)         
		      Or (Sum(TrdBuy_TurnOver+DelBuy_TurnOver) > Sum(TrdSell_TurnOver+DelSell_TurnOver) And Sp_Scheme_Type = 3)        
		           Then ((Pradnya.DBO.RoundedTurnover(Sum(TrdBuy_TurnOver),Sp_Multiplier)/Sp_Multiplier-1) *         
		         (Case When Sp_Buy_Brok_Type = 'P'         
		               Then Sp_Buy_Brok/100         
		        Else Sp_Buy_Brok         
		          End))        
		           Else ((Pradnya.DBO.RoundedTurnover(Sum(TrdBuy_TurnOver),Sp_Multiplier)/Sp_Multiplier-1) *         
		         (Case When Sp_Sell_Brok_Type = 'P'         
		        Then Sp_Sell_Brok/100         
		        Else Sp_Sell_Brok         
		          End))        
		       End) Else 0 End),  
		  TrdSellBrokerage_2 = (Case When Sum(TrdSell_TurnOver) > 0 Then (Case When Sp_Scheme_Type = 0         
		           Then  ((Pradnya.DBO.RoundedTurnover(Sum(TrdSell_TurnOver),Sp_Multiplier)/Sp_Multiplier-1) *         
		                       (Case When Sp_Sell_Brok_Type = 'P'         
		               Then Sp_Sell_Brok/100         
		               Else Sp_Sell_Brok         
		                    End))        
		           When (Sum(TrdBuy_TurnOver+DelBuy_TurnOver) >= Sum(TrdSell_TurnOver+DelSell_TurnOver) And Sp_Scheme_Type = 1)         
		      Or (Sum(TrdBuy_TurnOver+DelBuy_TurnOver) > Sum(TrdSell_TurnOver+DelSell_TurnOver) And Sp_Scheme_Type = 3)        
		           Then ((Pradnya.DBO.RoundedTurnover(Sum(TrdSell_TurnOver),Sp_Multiplier)/Sp_Multiplier-1) *         
		         (Case When Sp_Sell_Brok_Type = 'P'         
		               Then Sp_Sell_Brok/100         
		        Else Sp_Sell_Brok         
		          End))        
		           Else ((Pradnya.DBO.RoundedTurnover(Sum(TrdSell_TurnOver),Sp_Multiplier)/Sp_Multiplier-1) *         
		         (Case When Sp_Buy_Brok_Type = 'P'         
		        Then Sp_Buy_Brok/100         
		        Else Sp_Buy_Brok         
		          End))        
		       End) Else 0 End),  
		DelBuyBrokerage=(Pradnya.DBO.RoundedTurnover(Sum(DelBuy_TurnOver),Sp_Multiplier)/Sp_Multiplier *         
		                (Case When Sp_Buy_Brok_Type = 'P'         
		                      Then Sp_Buy_Brok/100         
		                      Else Sp_Buy_Brok         
		                 End)),  
		DelSellBrokerage=(Pradnya.DBO.RoundedTurnover(Sum(DelSell_TurnOver),Sp_Multiplier)/Sp_Multiplier *         
		                (Case When Sp_Sell_Brok_Type = 'P'         
		                      Then Sp_Sell_Brok/100         
		                      Else Sp_Sell_Brok         
		           End)),  
		SP_Computation_Level,Sp_Brok_ComputeOn,Sp_Brok_ComputeType,Sp_Scheme_Type,SP_Scheme_Id,SP_Multiplier,  
		SP_Buy_Brok,SP_Sell_Brok,SP_Res_Multiplier,SP_Res_Buy_Brok,SP_Res_Sell_Brok,SP_Value_From,SP_Value_To,  
		SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,SP_Buy_Brok_Type,SP_Sell_Brok_Type  
	From (  
		Select     
			  S.Party_Code,S.Sett_No,S.Sett_Type,Sauda_Date=Left(Start_Date,11), ContractNo='0', 
			  Trade_No=Pradnya.dbo.ReplaceTradeNo(Trade_No),   
			  Order_No, S.Scrip_Cd, S.Series, MarketRate, Sell_Buy,  
			  TrdBuy_Qty = (Case When Sell_Buy = 1 And BillFlag = 2 Then TradeQty Else 0 End),        
			  TrdSell_Qty = (Case When Sell_Buy = 2 And BillFlag = 3 Then TradeQty Else 0 End),        
			  DelBuy_Qty = (Case When Sell_Buy = 1 And BillFlag = 4 Then TradeQty Else 0 End),        
			  DelSell_Qty = (Case When Sell_Buy = 2 And BillFlag = 5 Then TradeQty Else 0 End),  
			  TrdBuy_TurnOver = (Case When Sell_Buy = 1 And BillFlag = 2   
			     Then Case When Sp_Brok_ComputeOn = 'T'   
			        Then TradeQty*MarketRate   
			        Else TradeQty   
			          End   
			     Else 0  
			                     End),        
			  TrdSell_TurnOver = (Case When Sell_Buy = 2 And BillFlag = 3   
			     Then Case When Sp_Brok_ComputeOn = 'T'   
			        Then TradeQty*MarketRate   
			        Else TradeQty   
			          End   
			     Else 0  
			                     End),       
			  DelBuy_TurnOver = (Case When Sell_Buy = 1 And BillFlag = 4   
			     Then Case When Sp_Brok_ComputeOn = 'T'   
			        Then TradeQty*MarketRate   
			        Else TradeQty   
			          End   
			     Else 0  
			                     End),       
			  DelSell_TurnOver = (Case When Sell_Buy = 2 And BillFlag = 5   
			     Then Case When Sp_Brok_ComputeOn = 'T'   
			        Then TradeQty*MarketRate   
			        Else TradeQty   
			          End   
			     Else 0  
			                     End),    
			  SP_Computation_Level, Sp_Brok_ComputeOn, Sp_Brok_ComputeType, Sp_Scheme_Type, SP_Scheme_Id, SP_Multiplier,  
			  SP_Buy_Brok,SP_Sell_Brok,SP_Res_Multiplier, SP_Res_Buy_Brok,SP_Res_Sell_Brok,SP_Value_From,SP_Value_To,  
			  SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt, SP_Buy_Brok_Type,SP_Sell_Brok_Type,SP_Trd_Type    
			From VBB_Settlement S, TRD_SCHEME_MAPPING M, Sett_Mst SM, Client1 C1, Client2 C2  
			Where C1.Cl_Code = C2.Cl_Code  
			And C2.Party_Code = S.Party_Code  
			And C1.Cl_Type <> 'INS'  
			And Sauda_Date Between Sp_Date_From And Sp_Date_To        
			And S.Party_Code = Sp_Party_Code  
			And S.Sett_No = SM.Sett_No And S.Sett_Type = SM.Sett_Type  
			And Scrip_Cd Like (Case When Sp_Scrip = 'ALL' then '%' Else Sp_Scrip End)  
			And 1 = (Case When Sp_Scrip = 'ALL' And Scrip_Cd Not In         
			         (Select Sp_Scrip From TRD_SCHEME_MAPPING M  
			      Where Sauda_Date Between Sp_Date_From And Sp_Date_To        
			                    And S.Party_Code = Sp_Party_Code)  
			              Then 1           
			              Else (Case When Sp_Scrip = 'ALL' Then 0 Else 1 End)  
			  End)  
			         And SP_Trd_Type = (Case When BillFlag < 4   
			            Then 'TRD'   
			                                 Else 'DEL'   
			                            End)  
			And AuctionPart Not Like 'A%' And AuctionPart Not Like 'F%'  
			And Trade_No Not Like '%C%'  
			And MarketRate > 0 And TradeQty > 0  
			And Sp_Brok_ComputeType = 'V' 
		)  
		Sett_Mapping  
	Group By 
		Party_Code,Sett_No,Sett_Type,Sauda_Date,  
		(Case When Sp_Computation_Level = 'T' Then Trade_No Else '' End),        
		(Case When Sp_Computation_Level In ('T', 'O') Then Order_No Else '' End),  
		(Case When Sp_Computation_Level <> 'C' Then Scrip_Cd Else '' End),        
		(Case When Sp_Computation_Level <> 'C' Then Series Else '' End),  
		SP_Computation_Level,Sp_Brok_ComputeOn,Sp_Brok_ComputeType,Sp_Scheme_Type,SP_Scheme_Id,SP_Multiplier,  
		SP_Buy_Brok,SP_Sell_Brok,SP_Res_Multiplier,SP_Res_Buy_Brok,SP_Res_Sell_Brok,SP_Value_From,SP_Value_To,  
		SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,SP_Buy_Brok_Type,SP_Sell_Brok_Type, 
		SP_Trd_Type  
	Having (Case When SP_Trd_Type = 'TRD'   
	      Then Sum(TrdBuy_TurnOver+TrdSell_TurnOver)  
	      Else Sum(DelBuy_TurnOver+DelSell_TurnOver)  
	 End)  
	  > Sp_Value_From     
	    And     
	       (Case When SP_Trd_Type = 'TRD'   
	      Then Sum(TrdBuy_TurnOver+TrdSell_TurnOver)  
	      Else Sum(DelBuy_TurnOver+DelSell_TurnOver)  
	 End)  
	  <=   (Case When Sp_Value_To = -1         
	             Then (Case When SP_Trd_Type = 'TRD'   
	                 Then Sum(TrdBuy_TurnOver+TrdSell_TurnOver)  
	            Else Sum(DelBuy_TurnOver+DelSell_TurnOver)  
	            End)  
	             Else Sp_Value_To        
	        End)  
	) Sett_MappingFinal  
Group by 
	Party_Code,Sett_No,Sett_Type,Sauda_Date,ContractNo,Trade_No,Order_No,Scrip_Cd,Series,  
	Sp_Computation_Level,SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt  
  
Set @SettCur = Cursor For  
Select Party_Code,Sett_No,Sett_Type,Sauda_Date,ContractNo,  
  Trade_No = (Case When Sp_Computation_Level = 'T' Then Trade_No Else '' End),        
  Order_No = (Case When Sp_Computation_Level In ('T', 'O') Then Order_No Else '' End),  
  Scrip_Cd = (Case When Sp_Computation_Level <> 'C' Then Scrip_Cd Else '' End),        
  Series = (Case When Sp_Computation_Level <> 'C' Then Series Else '' End),  
  BuyRate = (Case When Sum(TrdBuy_Qty+DelBuy_Qty) > 0   
                  Then Sum((TrdBuy_Qty+DelBuy_Qty)*MarketRate) / Sum(TrdBuy_Qty+DelBuy_Qty)   
    Else 0   
             End),  
  SellRate = (Case When Sum(TrdSell_Qty+DelSell_Qty) > 0   
                  Then Sum((TrdSell_Qty+DelSell_Qty)*MarketRate) / Sum(TrdSell_Qty+DelSell_Qty)   
    Else 0   
             End),    
TrdBuy_Qty=Sum(TrdBuy_Qty),  
TrdSell_Qty=Sum(TrdSell_Qty),  
DelBuy_Qty=Sum(DelBuy_Qty),  
DelSell_Qty=Sum(DelSell_Qty),  
TrdBuy_TurnOver=Sum(TrdBuy_TurnOver),  
TrdSell_TurnOver=Sum(TrdSell_TurnOver),  
DelBuy_TurnOver=Sum(DelBuy_TurnOver),  
DelSell_TurnOver=Sum(DelSell_TurnOver),  
SP_Computation_Level,Sp_Brok_ComputeOn,Sp_Brok_ComputeType,SP_Scheme_Id,  
SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,SP_Trd_Type  
From ( 
	Select     
		S.Party_Code,S.Sett_No,S.Sett_Type,Sauda_Date=Left(Start_Date,11), ContractNo='0', 
		Trade_No=Pradnya.dbo.ReplaceTradeNo(Trade_No),   
		Order_No, Scrip_Cd, S.Series, MarketRate, Sell_Buy,  
		TrdBuy_Qty = (Case When Sell_Buy = 1 And BillFlag = 2 Then TradeQty Else 0 End),        
		TrdSell_Qty = (Case When Sell_Buy = 2 And BillFlag = 3 Then TradeQty Else 0 End),        
		DelBuy_Qty = (Case When Sell_Buy = 1 And BillFlag = 4 Then TradeQty Else 0 End),        
		DelSell_Qty = (Case When Sell_Buy = 2 And BillFlag = 5 Then TradeQty Else 0 End),  
		TrdBuy_TurnOver = (Case When Sell_Buy = 1 And BillFlag = 2   
		Then Case When Sp_Brok_ComputeOn = 'T'   
		Then TradeQty*MarketRate   
		Else TradeQty   
		  End   
		Else 0  
		             End),        
		TrdSell_TurnOver = (Case When Sell_Buy = 2 And BillFlag = 3   
		Then Case When Sp_Brok_ComputeOn = 'T'   
		Then TradeQty*MarketRate   
		Else TradeQty   
		  End   
		Else 0  
		             End),       
		DelBuy_TurnOver = (Case When Sell_Buy = 1 And BillFlag = 4   
		Then Case When Sp_Brok_ComputeOn = 'T'   
		Then TradeQty*MarketRate   
		Else TradeQty   
		  End   
		Else 0  
		             End),       
		DelSell_TurnOver = (Case When Sell_Buy = 2 And BillFlag = 5   
		Then Case When Sp_Brok_ComputeOn = 'T'   
		Then TradeQty*MarketRate   
		Else TradeQty   
		  End   
		Else 0  
		             End),    
		SP_Computation_Level,Sp_Brok_ComputeOn,Sp_Brok_ComputeType,SP_Scheme_Id,  
		SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,SP_Trd_Type  
	From 
		VBB_Settlement S, TRD_SCHEME_MAPPING M, Sett_Mst SM, Client1 C1, Client2 C2  
	Where C1.Cl_Code = C2.Cl_Code  
	And C2.Party_Code = S.Party_Code  
	And C1.Cl_Type <> 'INS'  
	And Sauda_Date Between Sp_Date_From And Sp_Date_To        
	And S.Party_Code = Sp_Party_Code  
	And Scrip_Cd Like (Case When Sp_Scrip = 'ALL' then '%' Else Sp_Scrip End)  
	And 1 = (Case When Sp_Scrip = 'ALL' And Scrip_Cd Not In         
	         (Select Sp_Scrip From TRD_SCHEME_MAPPING M  
	      Where Sauda_Date Between Sp_Date_From And Sp_Date_To        
	                    And S.Party_Code = Sp_Party_Code)  
	              Then 1           
	              Else (Case When Sp_Scrip = 'ALL' Then 0 Else 1 End)  
	  End)  
	         And SP_Trd_Type = (Case When BillFlag < 4   
	            Then 'TRD'   
	                                 Else 'DEL'   
	                            End)  
	And AuctionPart Not Like 'A%' And AuctionPart Not Like 'F%'  
	And Trade_No Not Like '%C%'  
	And S.Sett_No = SM.Sett_No  
	And S.Sett_Type = SM.Sett_Type  
	And MarketRate > 0 And TradeQty > 0  
	And Sp_Brok_ComputeType = 'I'  
	   And Sp_Value_From = (Select Min(Sp_Value_From) From         
	       TRD_SCHEME_MAPPING  
	      Where SP_SCHEME_ID = M.SP_SCHEME_ID)  
)  
Sett_Mapping  
Group By Party_Code,Sett_No,Sett_Type,Sauda_Date,ContractNo,  
(Case When Sp_Computation_Level = 'T' Then Trade_No Else '' End),        
(Case When Sp_Computation_Level In ('T', 'O') Then Order_No Else '' End),  
(Case When Sp_Computation_Level <> 'C' Then Scrip_Cd Else '' End),        
(Case When Sp_Computation_Level <> 'C' Then Series Else '' End),  
SP_Computation_Level,Sp_Brok_ComputeOn,Sp_Brok_ComputeType,SP_Scheme_Id,  
SP_Min_BrokAmt,SP_Max_BrokAmt,SP_Min_ScripAmt,SP_Max_ScripAmt,SP_Trd_Type  
  
Open @SettCur  
Fetch Next From @SettCur Into   
 @Party_Code, @Sett_No, @Sett_Type, @Sauda_Date, @ContractNo, @Trade_No, @Order_No, @SCRIP_CD, @Series, @BuyRate,   
 @SellRate, @TrdBuyQty, @TrdSellQty, @DelBuyQty, @DelSellQty, @TrdBuy_TurnOver, @TrdSell_TurnOver, @DelBuy_TurnOver,   
 @DelSell_TurnOver, @Sp_ComputationLevel, @Sp_ComputationOn, @Sp_ComputationType,   
 @SchemeId, @Min_BrokAmt, @Max_BrokAmt, @Min_ScripAmt, @Max_ScripAmt, @Sp_Trd_Type  
While @@Fetch_Status = 0   
Begin   
  
  Set @SchemeCur = Cursor For        
  Select        
   SP_Computation_Level,        
   SP_Multiplier,        
   SP_Buy_Brok_Type,        
   SP_Sell_Brok_Type,        
   SP_Buy_Brok,        
   SP_Sell_Brok,        
   SP_Value_From,        
   SP_Value_To,        
   SP_Scheme_Type        
  From TRD_SCHEME_MAPPING        
  Where        
   @Sauda_Date Between Sp_Date_From And Sp_Date_To        
   And Sp_Party_Code = @Party_Code    
   And Sp_Trd_Type = @Sp_Trd_Type   
          And Sp_Scheme_Id = @SchemeId  
  Order By SP_Value_From  
  
  Open @SchemeCur        
  Fetch Next From         
  @SchemeCur into @SP_Computation_Level,@SP_Multiplier,@SP_Buy_Brok_Type,@SP_Sell_Brok_Type,        
  @SP_Buy_Brok,@SP_Sell_Brok,@SP_Value_From,@SP_Value_To,@Sp_Scheme_Type        
   
 if @Sp_Trd_Type = 'TRD'  
 Begin   
	SET @NewBuyTurnOver     = @TrdBuy_TurnOver     
	SET @NewSellTurnOver    = @TrdSell_TurnOver   
	SET @Buy_TurnOver = @TrdBuy_TurnOver     
	SET @Sell_TurnOver = @TrdSell_TurnOver  
	SET @NewBuyTurnOver_1   = 0  
	SET @NewSellTurnOver_1   = 0  
 End  
 Else  
 Begin  
	SET @NewBuyTurnOver     = @DelBuy_TurnOver     
	SET @NewSellTurnOver    = @DelSell_TurnOver      
	SET @Buy_TurnOver = @DelBuy_TurnOver     
	SET @Sell_TurnOver = @DelSell_TurnOver       
	SET @NewBuyTurnOver_1   = 0  
	SET @NewSellTurnOver_1   = 0  
 End  
        SET @NewBuyTurnOverOrg  = 0     
        SET @NewSellTurnOverOrg = 0     
        SET @BuyBrokerage       = 0     
        SET @SellBrokerage      = 0        
        SET @BuyBrokerage_1    = 0     
        SET @SellBrokerage_1      = 0        
  
 While @@Fetch_Status = 0 AND (@NewBuyTurnOver > 0 OR @NewSellTurnOver > 0)     
 Begin       
        /*--------------------------------------------------------------------*/     
        SET @BuyBrokerage      = 0     
        SET @SellBrokerage     = 0     
        SET @BuyBrokerage_1       = 0     
        SET @SellBrokerage_1      = 0        
 SET @TrdBuyQtyOrg = 0  
 SET @DelBuyQtyOrg = 0  
 SET @TrdSellQtyOrg = 0  
 SET @DelSellQtyOrg = 0  
 if @NewBuyTurnOver > 0     
 Begin     
 if @Buy_TurnOver >= @SP_Value_To AND @SP_Value_To > -1     
 Begin     
         SET @NewBuyTurnOver    = (@SP_Value_To - @SP_Value_From)/@SP_Multiplier     
         SET @NewBuyTurnOverOrg = @NewBuyTurnOver * @SP_Multiplier  
  SET @TrdBuyQtyOrg = 0  
  SET @DelBuyQtyOrg = 0  
  SET @NewBuyTurnOver_1 = @NewBuyTurnOver  
 END     
 ELSE     
 Begin     
  SET @NewBuyTurnOver     = @Buy_TurnOver - @SP_Value_From     
  if @NewBuyTurnOver < 0      
   SET @NewBuyTurnOver     = 0     
  SET @NewBuyTurnOverOrg  = @NewBuyTurnOver     
  SELECT  @NewBuyTurnOver = Pradnya.DBO.RoundedTurnover(@NewBuyTurnOver,@SP_Multiplier)     
  SELECT  @NewBuyTurnOver = @NewBuyTurnOver / @SP_Multiplier     
  
  If @sp_trd_type = 'TRD'   
   SET @NewBuyTurnOver_1 = @NewBuyTurnOver - 1    
  Else  
   SET @NewBuyTurnOver_1 = @NewBuyTurnOver  
  
  SELECT  @BuyFlag        = 1  
  SET @TrdBuyQtyOrg = @TrdBuyQty  
  SET @DelBuyQtyOrg = @DelBuyQty   
 END     
 if @NewBuyTurnOver    > 0     
 Begin     
  SELECT  @BuyBrokerage = CASE WHEN @Sp_Scheme_Type = 0   
          THEN CASE WHEN @Sp_Buy_Brok_Type ='P'     
                                  THEN @NewBuyTurnOver * @SP_Buy_Brok /100     
                                         ELSE @NewBuyTurnOver * @SP_Buy_Brok   
                                    END     
                               ELSE     
                                    CASE WHEN (@NewBuyTurnOver >= @NewSellTurnOver AND @Sp_Scheme_Type = 1) OR (@NewBuyTurnOver   >= @NewSellTurnOver AND @Sp_Scheme_Type =3)     
                                  THEN CASE WHEN @Sp_Buy_Brok_Type ='P'   
                                     THEN @NewBuyTurnOver * @SP_Buy_Brok /100   
                                                   ELSE @NewBuyTurnOver * @SP_Buy_Brok   
                                END     
                                  ELSE     
                                CASE WHEN @Sp_Sell_Brok_Type ='P'     
                                                   THEN @NewBuyTurnOver * @SP_Sell_Brok /100     
                                                          ELSE @NewBuyTurnOver * @SP_Sell_Brok   
                                                     END     
                                           END     
                          END  
  SELECT  @BuyBrokerage_1 = CASE WHEN @Sp_Scheme_Type = 0   
          THEN CASE WHEN @Sp_Buy_Brok_Type ='P'     
                                  THEN @NewBuyTurnOver_1 * @SP_Buy_Brok /100     
                                         ELSE @NewBuyTurnOver_1 * @SP_Buy_Brok   
                                    END     
                               ELSE     
                                    CASE WHEN (@NewBuyTurnOver >= @NewSellTurnOver AND @Sp_Scheme_Type = 1) OR (@NewBuyTurnOver   >= @NewSellTurnOver AND @Sp_Scheme_Type =3)     
                                  THEN CASE WHEN @Sp_Buy_Brok_Type ='P'   
                                     THEN @NewBuyTurnOver_1 * @SP_Buy_Brok /100   
                                                   ELSE @NewBuyTurnOver_1 * @SP_Buy_Brok   
                                END     
                                  ELSE     
                                CASE WHEN @Sp_Sell_Brok_Type ='P'     
                                                   THEN @NewBuyTurnOver_1 * @SP_Sell_Brok /100     
           ELSE @NewBuyTurnOver_1 * @SP_Sell_Brok   
                                                     END     
                                           END     
                          END    
END     
ELSE  
Begin      
 SELECT  @BuyBrokerage = 0    --Select @NewBuyTurnOver = 0      
 SELECT  @BuyBrokerage_1 = 0  
End  
END       
if @NewSellTurnOver     > 0     
Begin     
 if @Sell_TurnOver >= @SP_Value_To AND @SP_Value_To        > -1     
 Begin     
  SET @NewSellTurnOver    = (@SP_Value_To - @SP_Value_From)/@SP_Multiplier     
  SET @NewSellTurnOverOrg = @NewSellTurnOver * @SP_Multiplier   
  SET @TrdSellQtyOrg = 0  
  SET @DelSellQtyOrg = 0  
  SET @NewSellTurnOver = @NewSellTurnOver  
 END     
 ELSE     
 Begin     
  SET @NewSellTurnOver     = @Sell_TurnOver - @SP_Value_From     
  if @NewSellTurnOver < 0      
   SET @NewSellTurnOver     = 0     
  SET @NewSellTurnOverOrg  = @NewSellTurnOver     
  SELECT  @NewSellTurnOver = Pradnya.DBO.RoundedTurnover(@NewSellTurnOver,@SP_Multiplier)     
  SELECT  @NewSellTurnOver = @NewSellTurnOver / @SP_Multiplier     
  SELECT  @SellFlag        = 1  
  SET @TrdSellQtyOrg = @TrdSellQty  
  SET @DelSellQtyOrg = @DelSellQty      
  If @sp_trd_type = 'TRD'   
   SET @NewSellTurnOver_1 = @NewSellTurnOver - 1    
  Else  
   SET @NewSellTurnOver = @NewSellTurnOver  
   
 END     
  if @NewSellTurnOver    > 0     
  Begin      
   SELECT  @SellBrokerage =     
          CASE   
                  WHEN @Sp_Scheme_Type = 0   
                  THEN     
                  CASE   
                          WHEN @Sp_Sell_Brok_Type ='P'     
                          THEN @NewSellTurnOver * @SP_Sell_Brok /100     
                          ELSE @NewSellTurnOver * @SP_Sell_Brok   
                  END     
                  ELSE     
                  CASE   
                          WHEN (@NewBuyTurnOver >= @NewSellTurnOver   
                          AND @Sp_Scheme_Type    =1)     
                          OR (@NewBuyTurnOver   >= @NewSellTurnOver   
                          AND @Sp_Scheme_Type    =3)     
                          THEN     
                          CASE   
                                  WHEN @Sp_Sell_Brok_Type ='P'     
                                  THEN @NewSellTurnOver * @SP_Sell_Brok /100     
                                  ELSE @NewSellTurnOver * @SP_Sell_Brok   
                          END     
                          ELSE     
                          CASE   
                                  WHEN @Sp_Buy_Brok_Type ='P'     
                                  THEN @NewSellTurnOver * @SP_Buy_Brok /100     
                                  ELSE @NewSellTurnOver * @SP_Buy_Brok   
                          END     
                  END     
          END    
  
   SELECT  @SellBrokerage_1 =     
          CASE   
                  WHEN @Sp_Scheme_Type = 0   
                  THEN     
                  CASE   
                          WHEN @Sp_Sell_Brok_Type ='P'     
                          THEN @NewSellTurnOver_1 * @SP_Sell_Brok /100     
                          ELSE @NewSellTurnOver_1 * @SP_Sell_Brok   
                  END     
                  ELSE     
                  CASE   
                          WHEN (@NewBuyTurnOver >= @NewSellTurnOver   
                          AND @Sp_Scheme_Type    =1)     
                          OR (@NewBuyTurnOver   >= @NewSellTurnOver   
                          AND @Sp_Scheme_Type    =3)     
                          THEN     
                          CASE   
                                  WHEN @Sp_Sell_Brok_Type ='P'     
                                  THEN @NewSellTurnOver_1 * @SP_Sell_Brok /100     
                                  ELSE @NewSellTurnOver_1 * @SP_Sell_Brok   
                          END     
                          ELSE     
                          CASE   
                         WHEN @Sp_Buy_Brok_Type ='P'     
                                  THEN @NewSellTurnOver_1 * @SP_Buy_Brok /100     
                                  ELSE @NewSellTurnOver_1 * @SP_Buy_Brok   
                          END     
                  END     
          END   
  END     
 ELSE     
 Begin  
  SELECT  @SellBrokerage = 0  
  SELECT  @SellBrokerage_1 = 0  
 End   
 END       
--Insert into TEMP Table  
if (@NewBuyTurnOver > 0 OR @NewSellTurnOver > 0)  
Insert Into VBB_Charges_detail_Temp  
SELECT @Party_Code, @Sett_No, @Sett_Type, @Sauda_Date, @ContractNo, @Trade_No, @Order_No, @SCRIP_CD, @Series, @BuyRate,   
 @SellRate, @TrdBuyQtyOrg, @TrdSellQtyOrg, @DelBuyQtyOrg, @DelSellQtyOrg,   
 (Case When @Sp_Trd_Type = 'TRD' Then @BuyBrokerage Else 0 End),   
 (Case When @Sp_Trd_Type = 'TRD' Then @SellBrokerage Else 0 End),   
 (Case When @Sp_Trd_Type = 'DEL' Then @BuyBrokerage Else 0 End),   
 (Case When @Sp_Trd_Type = 'DEL' Then @SellBrokerage Else 0 End),  
 (Case When @Sp_Trd_Type = 'TRD' Then @BuyBrokerage_1 Else 0 End),   
 (Case When @Sp_Trd_Type = 'TRD' Then @SellBrokerage_1 Else 0 End),   
 (Case When @Sp_Trd_Type = 'DEL' Then @BuyBrokerage_1 Else 0 End),   
 (Case When @Sp_Trd_Type = 'DEL' Then @SellBrokerage_1 Else 0 End),  
  CD_TotalBrokerage = 0,  
 (Case When @Sp_Trd_Type = 'TRD' Then @NewBuyTurnOverOrg Else 0 End),   
 (Case When @Sp_Trd_Type = 'TRD' Then @NewSellTurnOverOrg Else 0 End),   
 (Case When @Sp_Trd_Type = 'DEL' Then @NewBuyTurnOverOrg Else 0 End),   
 (Case When @Sp_Trd_Type = 'DEL' Then @NewSellTurnOverOrg Else 0 End),  
 (Case When @Sp_Trd_Type = 'TRD' Then @NewBuyTurnOver*@SP_Multiplier Else 0 End),   
 (Case When @Sp_Trd_Type = 'TRD' Then @NewSellTurnOver*@SP_Multiplier Else 0 End),   
 @Sp_ComputationLevel, @Min_BrokAmt, @Max_BrokAmt, @Min_ScripAmt, @Max_ScripAmt  
  
if @SP_Value_To  = -1     
Begin     
 SELECT  @NewBuyTurnOver  = 0     
 SELECT  @NewSellTurnOver = 0     
END     
/*--------------------------------------------------------------------*/     
FETCH Next   
FROM      @SchemeCur   
INTO    @SP_Computation_Level,  
        @SP_Multiplier,  
        @SP_Buy_Brok_Type,  
        @SP_Sell_Brok_Type,     
        @SP_Buy_Brok,  
        @SP_Sell_Brok,  
        @SP_Value_From,  
        @SP_Value_To,  
        @Sp_Scheme_Type     
END     
Close @SchemeCur     
DeAllocate @SchemeCur     
        
 Fetch Next From @SettCur Into   
  @Party_Code, @Sett_No, @Sett_Type, @Sauda_Date, @ContractNo, @Trade_No, @Order_No, @SCRIP_CD, @Series, @BuyRate,   
  @SellRate, @TrdBuyQty, @TrdSellQty, @DelBuyQty, @DelSellQty, @TrdBuy_TurnOver, @TrdSell_TurnOver, @DelBuy_TurnOver,   
  @DelSell_TurnOver, @Sp_ComputationLevel, @Sp_ComputationOn, @Sp_ComputationType,  
  @SchemeId, @Min_BrokAmt, @Max_BrokAmt, @Min_ScripAmt, @Max_ScripAmt, @Sp_Trd_Type  
End  
  
Insert into VBB_Charges_detail_Temp_1  
Select CD_Party_Code,CD_Sett_No,CD_Sett_Type,CD_Sauda_Date,CD_ContractNo,CD_Trade_No,CD_Order_No,CD_Scrip_Cd,CD_Series,  
BuyRate = (Case When Sum(CD_TrdBuy_Qty+CD_DelBuy_Qty) > 0   
          Then Sum((CD_TrdBuy_Qty+CD_DelBuy_Qty)*CD_BuyRate) / Sum(CD_TrdBuy_Qty+CD_DelBuy_Qty)   
   Else 0  
     End),  
SellRate = (Case When Sum(CD_TrdSell_Qty+CD_DelSell_Qty) > 0   
          Then Sum((CD_TrdSell_Qty+CD_DelSell_Qty)*CD_SellRate) / Sum(CD_TrdSell_Qty+CD_DelSell_Qty)   
   Else 0   
     End),  
TrdBuy_Qty=Sum(CD_TrdBuy_Qty),  
TrdSell_Qty=Sum(CD_TrdSell_Qty),  
DelBuy_Qty=Sum(CD_DelBuy_Qty),  
DelSell_Qty=Sum(CD_DelSell_Qty),  
TrdBuyBrokerage=(Case When Sum(CD_RND_TrdBuy_TurnOver) > Sum(CD_TrdBuy_TurnOver) And Sum(CD_DelBuy_TurnOver) > 0   
        Then Sum(CD_TrdBuyBrokerage_1)   
        Else Sum(CD_TrdBuyBrokerage)  
   End),  
TrdSellBrokerage=(Case When Sum(CD_RND_TrdSell_TurnOver) > Sum(CD_TrdSell_TurnOver) And Sum(CD_DelSell_TurnOver) > 0   
        Then Sum(CD_TrdSellBrokerage_1)   
        Else Sum(CD_TrdSellBrokerage)  
   End),  
DelBuyBrokerage=Sum(CD_DelBuyBrokerage),  
DelSellBrokerage=Sum(CD_DelSellBrokerage),  
CD_TotalBrokerage = 0,  
TrdBuy_TurnOver=Sum(CD_TrdBuy_TurnOver),  
TrdSell_TurnOver=Sum(CD_TrdSell_TurnOver),  
DelBuy_TurnOver=Sum(CD_DelBuy_TurnOver),  
DelSell_TurnOver=Sum(CD_DelSell_TurnOver),  
CD_Computation_Level,  
CD_Min_BrokAmt,CD_Max_BrokAmt,CD_Min_ScripAmt,CD_Max_ScripAmt  
From VBB_Charges_detail_Temp  
Group By CD_Party_Code,CD_Sett_No,CD_Sett_Type,CD_Sauda_Date,  
CD_ContractNo,CD_Trade_No,CD_Order_No,CD_Scrip_Cd,CD_Series,  
CD_Computation_Level,CD_Min_BrokAmt,CD_Max_BrokAmt,CD_Min_ScripAmt,CD_Max_ScripAmt  
  
Update VBB_Charges_detail_Temp_1 Set CD_TotalBrokerage = CD_TrdBuyBrokerage + CD_TrdSellBrokerage + CD_DelBuyBrokerage + CD_DelSellBrokerage  
  
Insert Into VBB_Charges_detail_Temp_2  
Select CD_Party_Code,CD_Sett_No,CD_Sett_Type,CD_Sauda_Date,CD_ContractNo,CD_Trade_No,CD_Order_No,CD_Scrip_Cd,  
CD_Series,CD_BuyRate,CD_SellRate,CD_TrdBuy_Qty,CD_TrdSell_Qty,CD_DelBuy_Qty,CD_DelSell_Qty,  
CD_TrdBuyBrokerage,CD_TrdSellBrokerage,CD_DelBuyBrokerage,CD_DelSellBrokerage,  
CD_TotalBrokerage = (CASE WHEN (CD_TotalBrokerage) > 0   
                   THEN (CASE WHEN CD_Max_BrokAmt = - 1   
                              THEN (CASE WHEN CD_Min_BrokAmt <> 0  
                                  THEN Pradnya.Dbo.fnMax(CD_Min_BrokAmt,(CD_TotalBrokerage))  
                                  ELSE (CD_TotalBrokerage)     
                      END)     
                                 ELSE Pradnya.Dbo.fnMin(CD_Max_BrokAmt,  
                     (CASE WHEN CD_Min_BrokAmt <> 0  
                                                THEN Pradnya.Dbo.fnMax(CD_Min_BrokAmt,(CD_TotalBrokerage))     
                                                ELSE (CD_TotalBrokerage)     
                                           END))  
                  END)  
                           ELSE 0  
              END),  
CD_TrdBuy_TurnOver,CD_TrdSell_TurnOver,CD_DelBuy_TurnOver,CD_DelSell_TurnOver,  
CD_Computation_Level,CD_Min_BrokAmt,CD_Max_BrokAmt,CD_Min_ScripAmt,CD_Max_ScripAmt  
From VBB_Charges_detail_Temp_1  
  
--Truncate Table VBB_Charges_detail_Temp_1  
  
Insert into VBB_Charges_detail_Temp_1   
Select CD_Party_Code,CD_Sett_No,CD_Sett_Type,CD_Sauda_Date,CD_ContractNo,  
CD_Trade_No='',CD_Order_No='',CD_Scrip_Cd,CD_Series,  
BuyRate = (Case When Sum(CD_TrdBuy_Qty+CD_DelBuy_Qty) > 0   
          Then Sum((CD_TrdBuy_Qty+CD_DelBuy_Qty)*CD_BuyRate) / Sum(CD_TrdBuy_Qty+CD_DelBuy_Qty)   
   Else 0  
     End),  
SellRate = (Case When Sum(CD_TrdSell_Qty+CD_DelSell_Qty) > 0   
          Then Sum((CD_TrdSell_Qty+CD_DelSell_Qty)*CD_SellRate) / Sum(CD_TrdSell_Qty+CD_DelSell_Qty)   
   Else 0   
     End),  
TrdBuy_Qty=Sum(CD_TrdBuy_Qty),  
TrdSell_Qty=Sum(CD_TrdSell_Qty),  
DelBuy_Qty=Sum(CD_DelBuy_Qty),  
DelSell_Qty=Sum(CD_DelSell_Qty),  
CD_TrdBuyBrokerage=Sum(CD_TrdBuyBrokerage),  
CD_TrdSellBrokerage=Sum(CD_TrdSellBrokerage),  
CD_DelBuyBrokerage=Sum(CD_DelBuyBrokerage),  
CD_DelSellBrokerage=Sum(CD_DelSellBrokerage),  
CD_TotalBrokerage = (Case WHEN CD_Computation_Level In ('C', 'S')   
     THEN Sum(CD_TotalBrokerage)  
     ELSE (CASE WHEN Sum(CD_TotalBrokerage) > 0   
                       THEN (CASE WHEN CD_Max_ScripAmt = - 1   
                                  THEN (CASE WHEN CD_Min_ScripAmt <> 0  
                                         THEN Pradnya.Dbo.fnMax(CD_Min_ScripAmt,Sum(CD_TotalBrokerage))  
                                      ELSE Sum(CD_TotalBrokerage)     
                          END)     
                                         ELSE Pradnya.Dbo.fnMin(CD_Max_ScripAmt,  
                         (CASE WHEN CD_Min_BrokAmt <> 0  
                                                    THEN Pradnya.Dbo.fnMax(CD_Min_ScripAmt,Sum(CD_TotalBrokerage))     
                                                    ELSE Sum(CD_TotalBrokerage)     
                                   END))  
                      END)  
                              ELSE 0  
                  END)  
       End),  
CD_TrdBuy_TurnOver=Sum(CD_TrdBuy_TurnOver),  
CD_TrdSell_TurnOver=Sum(CD_TrdSell_TurnOver),  
CD_DelBuy_TurnOver=Sum(CD_DelBuy_TurnOver),  
CD_DelSell_TurnOver=Sum(CD_DelSell_TurnOver),  
CD_Computation_Level,CD_Min_BrokAmt,CD_Max_BrokAmt,CD_Min_ScripAmt,CD_Max_ScripAmt  
From VBB_Charges_detail_Temp_2 Where CD_Computation_Level Not In ('C', 'S')   
Group By CD_Party_Code,CD_Sett_No,CD_Sett_Type,CD_Sauda_Date,CD_ContractNo,CD_Scrip_Cd,CD_Series,  
CD_Computation_Level,CD_Min_BrokAmt,CD_Max_BrokAmt,CD_Min_ScripAmt,CD_Max_ScripAmt  
Having   
Sum(CD_TotalBrokerage) <> (Case WHEN CD_Computation_Level In ('C', 'S')   
     THEN Sum(CD_TotalBrokerage)  
     ELSE (CASE WHEN Sum(CD_TotalBrokerage) > 0   
                       THEN (CASE WHEN CD_Max_ScripAmt = - 1   
                                  THEN (CASE WHEN CD_Min_ScripAmt <> 0  
                                         THEN Pradnya.Dbo.fnMax(CD_Min_ScripAmt,Sum(CD_TotalBrokerage))  
                                      ELSE Sum(CD_TotalBrokerage)     
                          END)     
                                         ELSE Pradnya.Dbo.fnMin(CD_Max_ScripAmt,  
                         (CASE WHEN CD_Min_BrokAmt <> 0  
                                                    THEN Pradnya.Dbo.fnMax(CD_Min_ScripAmt,Sum(CD_TotalBrokerage))     
                                                    ELSE Sum(CD_TotalBrokerage)     
                                               END))  
                      END)  
                        ELSE 0  
                  END)  
       End)  
  
Insert Into VBB_Charges_detail_Temp_1  
Select * From VBB_Charges_detail_Temp_2 C2  
Where Not Exists (Select CD_Party_Code From VBB_Charges_detail_Temp_1 C1  
Where C1.CD_Party_Code = C2.CD_Party_Code  
And C1.CD_Sett_No = C2.CD_Sett_No  
And C1.CD_Sett_Type = C2.CD_Sett_Type  
And C1.CD_Scrip_Cd = C2.CD_Scrip_Cd  
And C1.CD_Series = C2.CD_Series )  
  
--Truncate Table VBB_Charges_detail_Temp_2  
  
Insert Into VBB_Charges_detail_Temp_2  
Select S.Party_Code,S.Sett_No,S.Sett_Type,Sauda_Date=Left(Start_Date,11),   
  ContractNo='0', Trade_No='',   
  Order_No='', Scrip_Cd = 'BROKERAGE',   
  Series=(Case When S.Sett_Type = 'W' Then 'BE' Else 'EQ' End),   
  BuyRate = (Case When Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End) > 0   
    Then Sum(Case When Sell_Buy = 1 Then TradeQty*MarketRate Else 0 End)   
    / Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End)  
    Else 0   
      End),  
  SellRate = (Case When Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) > 0   
    Then Sum(Case When Sell_Buy = 2 Then TradeQty*MarketRate Else 0 End)   
    / Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End)  
    Else 0   
      End),  
  TrdBuy_Qty = Sum(Case When Sell_Buy = 1 And BillFlag = 2 Then TradeQty Else 0 End),        
  TrdSell_Qty = Sum(Case When Sell_Buy = 2 And BillFlag = 3 Then TradeQty Else 0 End),        
  DelBuy_Qty = Sum(Case When Sell_Buy = 1 And BillFlag = 4 Then TradeQty Else 0 End),        
  DelSell_Qty = Sum(Case When Sell_Buy = 2 And BillFlag = 5 Then TradeQty Else 0 End),  
  TrdBuy_Brokerage = Sum(Case When Sell_Buy = 1 And BillFlag = 2 Then TradeQty*NBrokapp Else 0 End),        
  TrdSell_Brokerage = Sum(Case When Sell_Buy = 2 And BillFlag = 3 Then TradeQty*NBrokapp Else 0 End),        
  DelBuy_Brokerage = Sum(Case When Sell_Buy = 1 And BillFlag = 4 Then TradeQty*NBrokapp Else 0 End),        
  DelSell_Brokerage = Sum(Case When Sell_Buy = 2 And BillFlag = 5 Then TradeQty*NBrokapp Else 0 End),  
  Total_Brokerage = (CASE WHEN Sum(TradeQty*NBrokapp) > 0   
                   THEN (CASE WHEN CR_Max_ContractAmt = - 1   
                         THEN (CASE WHEN CR_Min_ContractAmt <> 0  
                                  THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(TradeQty*NBrokapp))  
                           ELSE Sum(TradeQty*NBrokapp)     
                             END)     
                              ELSE Pradnya.Dbo.fnMin(CR_Max_ContractAmt,  
              (CASE WHEN CR_Min_ContractAmt <> 0  
                                         THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(TradeQty*NBrokapp))     
                                         ELSE Sum(TradeQty*NBrokapp)    
                                    END))  
                         END)  
                   ELSE 0  
              END),  
  TrdBuy_TurnOver = Sum(Case When Sell_Buy = 1 And BillFlag = 2   
     Then TradeQty*MarketRate   
     Else 0  
                     End),        
  TrdSell_TurnOver = Sum(Case When Sell_Buy = 2 And BillFlag = 3   
     Then TradeQty*MarketRate   
     Else 0  
                     End),       
  DelBuy_TurnOver = Sum(Case When Sell_Buy = 1 And BillFlag = 4   
     Then TradeQty*MarketRate   
     Else 0  
                     End),       
  DelSell_TurnOver = Sum(Case When Sell_Buy = 2 And BillFlag = 5   
     Then TradeQty*MarketRate   
     Else 0  
                     End),  
CD_Computation_Level='',CR_Min_ContractAmt,CR_Max_ContractAmt,CD_Min_ScripAmt=0,CD_Max_ScripAmt=-1  
FROM VBB_Settlement S, Sett_Mst SM, TRD_CONTRACT_ROUNDING C, Client1 C1, Client2 C2  
Where C1.Cl_Code = C2.Cl_Code  
And C2.Party_Code = S.Party_Code  
And C1.Cl_Type <> 'INS'  
And S.Sett_No = SM.Sett_No   
And S.Sett_Type = SM.Sett_Type  
And C.CR_Party_Code = S.Party_Code  
And AuctionPart Not Like 'A%' And AuctionPart Not Like 'F%'  
And Trade_No Not Like '%C%'  
And Sauda_Date BETWEEN CR_Date_From AND CR_Date_To  
And Not Exists (Select CD_Party_Code From VBB_Charges_detail_Temp_1 C1  
Where C1.CD_Party_Code = S.Party_Code  
And C1.CD_Sett_No = S.Sett_No  
And C1.CD_Sett_Type = S.Sett_Type)  
Group By S.Party_Code,S.Sett_No,S.Sett_Type, Left(Start_Date,11), CR_Min_ContractAmt,CR_Max_ContractAmt  
Having (CASE WHEN Sum(TradeQty*NBrokapp) > 0   
                   THEN (CASE WHEN CR_Max_ContractAmt = - 1   
                         THEN (CASE WHEN CR_Min_ContractAmt <> 0  
                                  THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(TradeQty*NBrokapp))  
                           ELSE Sum(TradeQty*NBrokapp)     
                             END)     
                              ELSE Pradnya.Dbo.fnMin(CR_Max_ContractAmt,  
              (CASE WHEN CR_Min_ContractAmt <> 0  
                                         THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(TradeQty*NBrokapp))     
                                         ELSE Sum(TradeQty*NBrokapp)    
                                    END))  
                         END)  
                   ELSE 0  
              END) < Sum(TradeQty*NBrokapp)  
  
Update Settlement Set   
Brokapplied = 0, NetRate = MarketRate,   
NBrokapp = 0, N_NetRate = MarketRate,   
Service_Tax = 0, NSerTax = 0   
From VBB_Charges_detail_Temp_2   
Where VBB_Charges_detail_Temp_2.CD_Sett_No = Settlement.Sett_No  
And VBB_Charges_detail_Temp_2.CD_Sett_Type = Settlement.Sett_Type  
And VBB_Charges_detail_Temp_2.CD_Party_Code = Settlement.Party_Code   
  
Update Settlement Set   
Brokapplied = 0, NetRate = MarketRate,   
NBrokapp = 0, N_NetRate = MarketRate,   
Service_Tax = 0, NSerTax = 0   
From VBB_Charges_detail_Temp_1   
Where VBB_Charges_detail_Temp_1.CD_Sett_No = Settlement.Sett_No  
And VBB_Charges_detail_Temp_1.CD_Sett_Type = Settlement.Sett_Type  
And VBB_Charges_detail_Temp_1.CD_Party_Code = Settlement.Party_Code   
And VBB_Charges_detail_Temp_1.CD_Scrip_CD = Settlement.Scrip_CD  
And VBB_Charges_detail_Temp_1.CD_Series = Settlement.Series  
  
Insert Into VBB_Charges_detail_Temp_2  
Select S.Party_Code,S.Sett_No,S.Sett_Type,Sauda_Date=Left(Start_Date,11),   
  ContractNo='0', Trade_No='',   
  Order_No='', Scrip_Cd = 'BROKERAGE',   
  Series=(Case When S.Sett_Type = 'W' Then 'BE' Else 'EQ' End),   
  BuyRate = 0,  
  SellRate = 0,  
  TrdBuy_Qty = 0,        
  TrdSell_Qty = 0,        
  DelBuy_Qty = 0,        
  DelSell_Qty = 0,  
  TrdBuy_Brokerage = 0,        
  TrdSell_Brokerage = 0,        
  DelBuy_Brokerage = 0,        
  DelSell_Brokerage = 0,  
  Total_Brokerage = (CASE WHEN Sum(TradeQty*NBrokapp) > 0   
                   THEN (CASE WHEN CR_Max_ContractAmt = - 1   
                         THEN (CASE WHEN CR_Min_ContractAmt <> 0  
                                  THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(TradeQty*NBrokapp))  
                           ELSE Sum(TradeQty*NBrokapp)     
                             END)     
                              ELSE Pradnya.Dbo.fnMin(CR_Max_ContractAmt,  
              (CASE WHEN CR_Min_ContractAmt <> 0  
                                         THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(TradeQty*NBrokapp))     
                                         ELSE Sum(TradeQty*NBrokapp)    
                                    END))  
                         END)  
                   ELSE 0  
              END) - Sum(TradeQty*NBrokapp),  
  TrdBuy_TurnOver = 0,        
  TrdSell_TurnOver = 0,       
  DelBuy_TurnOver = 0,       
  DelSell_TurnOver = 0,  
CD_Computation_Level='',CR_Min_ContractAmt,CR_Max_ContractAmt,CD_Min_ScripAmt=0,CD_Max_ScripAmt=-1  
FROM VBB_Settlement S, Sett_Mst SM, TRD_CONTRACT_ROUNDING C, Client1 C1, Client2 C2  
Where C1.Cl_Code = C2.Cl_Code  
And C2.Party_Code = S.Party_Code  
And C1.Cl_Type <> 'INS'  
And S.Sett_No = SM.Sett_No   
And S.Sett_Type = SM.Sett_Type  
And C.CR_Party_Code = S.Party_Code  
And AuctionPart Not Like 'A%' And AuctionPart Not Like 'F%'  
And Trade_No Not Like '%C%'  
And Sauda_Date BETWEEN CR_Date_From AND CR_Date_To  
And Not Exists (Select CD_Party_Code From VBB_Charges_detail_Temp_1 C1  
Where C1.CD_Party_Code = S.Party_Code  
And C1.CD_Sett_No = S.Sett_No  
And C1.CD_Sett_Type = S.Sett_Type)  
Group By S.Party_Code,S.Sett_No,S.Sett_Type, Left(Start_Date,11), CR_Min_ContractAmt,CR_Max_ContractAmt  
Having (CASE WHEN Sum(TradeQty*NBrokapp) > 0   
                   THEN (CASE WHEN CR_Max_ContractAmt = - 1   
                         THEN (CASE WHEN CR_Min_ContractAmt <> 0  
                                  THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(TradeQty*NBrokapp))  
                           ELSE Sum(TradeQty*NBrokapp)     
                             END)     
                              ELSE Pradnya.Dbo.fnMin(CR_Max_ContractAmt,  
              (CASE WHEN CR_Min_ContractAmt <> 0  
                                         THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(TradeQty*NBrokapp))     
                                         ELSE Sum(TradeQty*NBrokapp)    
                                    END))  
                         END)  
                   ELSE 0  
              END) > Sum(TradeQty*NBrokapp)  
  
Insert into VBB_Charges_detail_Temp_2   
Select CD_Party_Code,CD_Sett_No,CD_Sett_Type,CD_Sauda_Date,CD_ContractNo,  
CD_Trade_No='',CD_Order_No='',CD_Scrip_Cd='BROKERAGE',CD_Series=(Case When CD_Sett_Type = 'W' Then 'BE' Else 'EQ' End),  
BuyRate = (Case When Sum(CD_TrdBuy_Qty+CD_DelBuy_Qty) > 0   
          Then Sum((CD_TrdBuy_Qty+CD_DelBuy_Qty)*CD_BuyRate) / Sum(CD_TrdBuy_Qty+CD_DelBuy_Qty)   
   Else 0  
     End),  
SellRate = (Case When Sum(CD_TrdSell_Qty+CD_DelSell_Qty) > 0   
          Then Sum((CD_TrdSell_Qty+CD_DelSell_Qty)*CD_SellRate) / Sum(CD_TrdSell_Qty+CD_DelSell_Qty)   
   Else 0   
     End),  
TrdBuy_Qty=Sum(CD_TrdBuy_Qty),  
TrdSell_Qty=Sum(CD_TrdSell_Qty),  
DelBuy_Qty=Sum(CD_DelBuy_Qty),  
DelSell_Qty=Sum(CD_DelSell_Qty),  
CD_TrdBuyBrokerage=Sum(CD_TrdBuyBrokerage),  
CD_TrdSellBrokerage=Sum(CD_TrdSellBrokerage),  
CD_DelBuyBrokerage=Sum(CD_DelBuyBrokerage),  
CD_DelSellBrokerage=Sum(CD_DelSellBrokerage),  
CD_TotalBrokerage = (CASE WHEN Sum(CD_TotalBrokerage) > 0   
                   THEN (CASE WHEN CR_Max_ContractAmt = - 1   
                         THEN (CASE WHEN CR_Min_ContractAmt <> 0  
                                  THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(CD_TotalBrokerage))  
                           ELSE Sum(CD_TotalBrokerage)     
                             END)     
                              ELSE Pradnya.Dbo.fnMin(CR_Max_ContractAmt,  
              (CASE WHEN CR_Min_ContractAmt <> 0  
                                         THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(CD_TotalBrokerage))     
                                         ELSE Sum(CD_TotalBrokerage)    
                                    END))  
                         END)  
                   ELSE 0  
              END),  
CD_TrdBuy_TurnOver=Sum(CD_TrdBuy_TurnOver),  
CD_TrdSell_TurnOver=Sum(CD_TrdSell_TurnOver),  
CD_DelBuy_TurnOver=Sum(CD_DelBuy_TurnOver),  
CD_DelSell_TurnOver=Sum(CD_DelSell_TurnOver),  
CD_Computation_Level,CD_Min_BrokAmt,CD_Max_BrokAmt,CD_Min_ScripAmt,CD_Max_ScripAmt  
From VBB_Charges_detail_Temp_1, TRD_CONTRACT_ROUNDING  
Where CD_Party_Code = CR_Party_Code  
And CD_Sauda_Date BETWEEN CR_Date_From AND CR_Date_To  
Group By CD_Party_Code,CD_Sett_No,CD_Sett_Type,CD_Sauda_Date,CD_ContractNo,  
CD_Computation_Level,CD_Min_BrokAmt,CD_Max_BrokAmt,CD_Min_ScripAmt,CD_Max_ScripAmt,CR_Min_ContractAmt, CR_Max_ContractAmt  
Having (CASE WHEN Sum(CD_TotalBrokerage) > 0   
                   THEN (CASE WHEN CR_Max_ContractAmt = - 1   
                         THEN (CASE WHEN CR_Min_ContractAmt <> 0  
                                  THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(CD_TotalBrokerage))  
                           ELSE Sum(CD_TotalBrokerage)     
                             END)     
                              ELSE Pradnya.Dbo.fnMin(CR_Max_ContractAmt,  
              (CASE WHEN CR_Min_ContractAmt <> 0  
         THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(CD_TotalBrokerage))     
                                         ELSE Sum(CD_TotalBrokerage)    
                                    END))  
                         END)  
                   ELSE 0  
              END) < Sum(CD_TotalBrokerage)  
  
Delete From VBB_Charges_detail_Temp_1   
Where Exists (Select CD_Party_Code From VBB_Charges_detail_Temp_2  
Where VBB_Charges_detail_Temp_1.CD_Party_Code = VBB_Charges_detail_Temp_2.CD_Party_Code  
And VBB_Charges_detail_Temp_1.CD_Sett_No = VBB_Charges_detail_Temp_2.CD_Sett_No  
And VBB_Charges_detail_Temp_1.CD_Sett_Type = VBB_Charges_detail_Temp_2.CD_Sett_Type )  
  
Insert into VBB_Charges_detail_Temp_2   
Select CD_Party_Code,CD_Sett_No,CD_Sett_Type,CD_Sauda_Date,CD_ContractNo,  
CD_Trade_No='',CD_Order_No='',CD_Scrip_Cd='BROKERAGE',CD_Series=(Case When CD_Sett_Type = 'W' Then 'BE' Else 'EQ' End),  
BuyRate = 0,  
SellRate = 0,  
TrdBuy_Qty=Sum(CD_TrdBuy_Qty),  
TrdSell_Qty=Sum(CD_TrdSell_Qty),  
DelBuy_Qty=Sum(CD_DelBuy_Qty),  
DelSell_Qty=Sum(CD_DelSell_Qty),  
CD_TrdBuyBrokerage=Sum(CD_TrdBuyBrokerage),  
CD_TrdSellBrokerage=Sum(CD_TrdSellBrokerage),  
CD_DelBuyBrokerage=Sum(CD_DelBuyBrokerage),  
CD_DelSellBrokerage=Sum(CD_DelSellBrokerage),  
CD_TotalBrokerage = (CASE WHEN Sum(CD_TotalBrokerage) > 0   
                   THEN (CASE WHEN CR_Max_ContractAmt = - 1   
                         THEN (CASE WHEN CR_Min_ContractAmt <> 0  
                                  THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(CD_TotalBrokerage))  
                           ELSE Sum(CD_TotalBrokerage)     
                             END)     
                              ELSE Pradnya.Dbo.fnMin(CR_Max_ContractAmt,  
              (CASE WHEN CR_Min_ContractAmt <> 0  
                                         THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(CD_TotalBrokerage))     
                                         ELSE Sum(CD_TotalBrokerage)    
                                    END))  
                         END)  
                   ELSE 0  
              END) - Sum(CD_TotalBrokerage),  
CD_TrdBuy_TurnOver=0,  
CD_TrdSell_TurnOver=0,  
CD_DelBuy_TurnOver=0,  
CD_DelSell_TurnOver=0,  
CD_Computation_Level,CD_Min_BrokAmt,CD_Max_BrokAmt,CD_Min_ScripAmt,CD_Max_ScripAmt  
From VBB_Charges_detail_Temp_1, TRD_CONTRACT_ROUNDING  
Where CD_Party_Code = CR_Party_Code  
And CD_Sauda_Date BETWEEN CR_Date_From AND CR_Date_To  
Group By CD_Party_Code,CD_Sett_No,CD_Sett_Type,CD_Sauda_Date,CD_ContractNo,  
CD_Computation_Level,CD_Min_BrokAmt,CD_Max_BrokAmt,CD_Min_ScripAmt,CD_Max_ScripAmt, CR_Min_ContractAmt, CR_Max_ContractAmt  
Having (CASE WHEN Sum(CD_TotalBrokerage) > 0   
                   THEN (CASE WHEN CR_Max_ContractAmt = - 1   
                         THEN (CASE WHEN CR_Min_ContractAmt <> 0  
                                  THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(CD_TotalBrokerage))  
                           ELSE Sum(CD_TotalBrokerage)     
                             END)     
                              ELSE Pradnya.Dbo.fnMin(CR_Max_ContractAmt,  
              (CASE WHEN CR_Min_ContractAmt <> 0  
                                         THEN Pradnya.Dbo.fnMax(CR_Min_ContractAmt,Sum(CD_TotalBrokerage))     
                                         ELSE Sum(CD_TotalBrokerage)    
                                    END))  
                         END)  
                   ELSE 0  
              END) > Sum(CD_TotalBrokerage)  
  
Insert Into VBB_Charges_detail_Temp_2  
Select * From VBB_Charges_detail_Temp_1  
  
Update VBB_Charges_detail_Temp_2   
Set CD_TrdBuyBrokerage = 0, CD_TrdSellBrokerage = 0, CD_DelBuyBrokerage = 0, CD_DelSellBrokerage = 0  
Where CD_TrdBuyBrokerage + CD_TrdSellBrokerage + CD_DelBuyBrokerage + CD_DelSellBrokerage <> CD_TotalBrokerage  
  
Update VBB_Charges_detail_Temp_2   
Set CD_TrdBuyBrokerage = (Case When (CD_TrdBuy_Qty + CD_DelBuy_Qty) >= (CD_TrdSell_Qty + CD_DelSell_Qty)  
          Then (Case When CD_TrdBuy_Qty > CD_DelBuy_Qty   
       Then CD_TotalBrokerage  
       Else CD_TrdBuyBrokerage  
         End)  
  
          Else CD_TrdBuyBrokerage  
     End),  
   CD_TrdSellBrokerage = (Case When (CD_TrdBuy_Qty + CD_DelBuy_Qty) < (CD_TrdSell_Qty + CD_DelSell_Qty)  
          Then (Case When CD_TrdSell_Qty > CD_DelSell_Qty   
       Then CD_TotalBrokerage  
       Else CD_TrdSellBrokerage  
         End)  
          Else CD_TrdSellBrokerage  
     End),        
    CD_DelBuyBrokerage = (Case When (CD_TrdBuy_Qty + CD_DelBuy_Qty) >= (CD_TrdSell_Qty + CD_DelSell_Qty)  
          Then (Case When CD_TrdBuy_Qty > CD_DelBuy_Qty   
       Then CD_DelBuyBrokerage  
       Else CD_TotalBrokerage  
         End)  
          Else CD_TrdBuyBrokerage  
     End),  
   CD_DelSellBrokerage = (Case When (CD_TrdBuy_Qty + CD_DelBuy_Qty) < (CD_TrdSell_Qty + CD_DelSell_Qty)  
          Then (Case When CD_TrdSell_Qty > CD_DelSell_Qty   
       Then CD_DelSellBrokerage  
       Else CD_TotalBrokerage  
         End)  
          Else CD_TrdSellBrokerage  
     End),  
   CD_TrdBuy_Qty = (Case When CD_BuyRate = 0 Then 0 Else CD_TrdBuy_Qty End),    
   CD_TrdSell_Qty = (Case When CD_SellRate = 0 Then 0 Else CD_TrdSell_Qty End),    
   CD_DelBuy_Qty = (Case When CD_BuyRate = 0 Then 0 Else CD_DelBuy_Qty End),    
   CD_DelSell_Qty = (Case When CD_SellRate = 0 Then 0 Else CD_DelSell_Qty End)  
Where CD_TrdBuyBrokerage + CD_TrdSellBrokerage + CD_DelBuyBrokerage + CD_DelSellBrokerage <> CD_TotalBrokerage  
  
Delete From Charges_detail   
Where CD_Sett_No = @F_Sett_No  
And CD_Sett_Type = @F_Sett_Type  
And CD_Party_Code Between @From_Party And @To_Party  

UPDATE VBB_Charges_detail_Temp_2 SET 
CD_Scrip_Cd='BROKERAGE',
CD_Series=(Case When CD_Sett_Type = 'W' Then 'BE' Else 'EQ' End)
WHERE CD_Scrip_Cd = ''
  
Insert Into Charges_detail  
Select CD_Party_Code,CD_Sett_No,CD_Sett_Type,CD_Sauda_Date,CD_ContractNo,CD_Trade_No,CD_Order_No,  
CD_Scrip_Cd,CD_Series,CD_BuyRate,CD_SellRate,CD_TrdBuy_Qty,CD_TrdSell_Qty,CD_DelBuy_Qty,CD_DelSell_Qty,  
CD_TrdBuyBrokerage,CD_TrdSellBrokerage,CD_DelBuyBrokerage,CD_DelSellBrokerage,CD_TotalBrokerage,  
CD_TrdBuySerTax=CD_TrdBuyBrokerage*Service_Tax/100,  
CD_TrdSellSerTax=CD_TrdSellBrokerage*Service_Tax/100,  
CD_DelBuySerTax=CD_DelBuyBrokerage*Service_Tax/100,  
CD_DelSellSerTax=CD_DelSellBrokerage*Service_Tax/100,  
CD_TotalSerTax=CD_TotalBrokerage*Service_Tax/100,  
CD_TrdBuy_TurnOver,CD_TrdSell_TurnOver,CD_DelBuy_TurnOver,CD_DelSell_TurnOver,CD_Computation_Level,  
CD_Min_BrokAmt,CD_Max_BrokAmt,CD_Min_ScripAmt,CD_Max_ScripAmt,CD_TimeStamp=GetDate()  
From VBB_Charges_detail_Temp_2, Globals  
Where CD_Sauda_Date Between Year_Start_Dt And Year_End_Dt

GO
