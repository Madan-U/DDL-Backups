-- Object: PROCEDURE dbo.FASTTRADE_NetPosition_NCDX
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Procedure FASTTRADE_NetPosition_NCDX ( @TradeDate Varchar(11)) AS  

if @TradeDate <> ''  
begin  
Set Transaction Isolation Level Read Uncommitted  
  
Select   
 PositionDate    = Replace(Convert(Varchar(11),FoEa_Position_Date,106),' ', '-'),  
 SegmentInd   = FoEa_Segment_Ind,  
 SettType   = FoEa_Sett_Type,  
 CmCode    = FoEa_Cm_Code,  
 MemebrType   = FoEa_Mem_Type,  
 TMCode    = FoEa_Tm_Code,  
 AccountType   = FoEa_Acc_Type,  
 PartyCode   = FoEa_Party_Code,  
 InstType   = FoEa_Inst_Type,  
 Symbol    = FoEa_Symbol,  
 ExpiryDate   = Replace(Convert(Varchar(11),FoEa_ExpiryDate,106),' ', '-'),  
 StrikePrice   = Convert(Numeric(18,4),FoEa_Strike_Price),  
 OptionType   = (Case When Left(foEa_Inst_Type,3) ='OPT' Then FoEa_Option_Type Else '' End),  
 CorpActLevel   = FoEa_Cor_Act_Level,  
 BroughtFoRwardLongQuantity = FoEa_Brought_FoRward_Long_Quantity,  
 BroughtFoRwardLongValue  = FoEa_Brought_FoRward_Long_Value,  
 BroughtFoRwardShortQuantity = FoEa_Brought_FoRward_Short_Quantity,  
 BroughtFoRwardShortValue = FoEa_Brought_FoRward_Short_Value,  
 DayBuyOpenQuantity  = FoEa_Day_Buy_Open_Quantity,  
 DayBuyOpenValue   = FoEa_Day_Buy_Open_Value,  
 DaySellOpenQuantity  = FoEa_Day_Sell_Open_Quantity,  
 DaySellOpenValue  = FoEa_Day_Sell_Open_Value,  
 PreexallLongqty   = FoEa_Preexall_Longqty,  
 PreexallLongvalue  = FoEa_Preexall_Longvalue,  
 PreexallShortqty  = FoEa_Preexall_Shortqty,  
 PreexallShortvalue  = FoEa_Preexall_Shortvalue,  
 ExerciseQty   = FoEa_Exercise_Qty,  
 AllocQty   = FoEa_Alloc_Qty,  
 PostexallLongqty  = FoEa_Postexall_Longqty,  
 PostexallLongvalue  = FoEa_Postexall_Longvalue,  
 PostexallShortqty  = FoEa_Postexall_Shortqty,  
 PostexallShortvalue  = FoEa_Postexall_Shortvalue,  
 SettlementPrice   = (Case When left(FoEa_Inst_Type,3) ='FUT' Then FoEa_SettlementPrice Else 0 End),  
 NetPremium   = FoEa_NetPremium,  
 DailyMtmSettlementValue  = FoEa_Daily_Mtm_Settlement_Value,  
 FuturesFinalSettlementValue = FoEa_Futures_Final_Settlement_Value,  
 ExercisedAssignedValue  = FoEa_Exercised_Assigned_Value  
From  
 NCDX.dbo.FOExerciseAllocation (nolock)  
Where  
 Foea_Position_Date Like @TradeDate + '%'  
 and (FoEa_Postexall_Longqty > 0 or FoEa_Postexall_Shortqty > 0 )
Order By  
 PartyCode,  
 InstType,  
 Symbol,  
 ExpiryDate,  
 StrikePrice,  
 OptionType  
  
end

GO
