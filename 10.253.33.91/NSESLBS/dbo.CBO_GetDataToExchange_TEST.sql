-- Object: PROCEDURE dbo.CBO_GetDataToExchange_TEST
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC CBO_GetDataToExchange_TEST @SaudaDate  VARCHAR(10)

 as


 

select ToExchange.Rec_Type, ToExchange.Sell_BuyFlag, ToExchange.Sett_Type, ToExchange.Sett_No,ToExchange.Sec_Symbol, ToExchange.Security_Series,  

ToExchange.CP_Code,ToExchange.Allocated_Qty,ToExchange.Allocated_Value,ToExchange.CP_Code1,ToExchange.Cont_NoteNo,ToExchange.Otr_no, 

netrate = (allocated_value/Allocated_qty),Diffqty,Diffamt from ToExchange , (Select F.Rec_Type, F.Sell_BuyFlag, F.Sett_Type, F.Sett_No,F.Sec_Symbol,  

F.Security_Series, F.CP_Code, DiffQty = F.Oblig_Qty  - Sum(Allocated_Qty),Diffamt = F.Oblig_Value - Sum(Allocated_Value) From FromExchange F,ToExchange T where  
T.Rec_type = 10 and F.Rec_Type = T.Rec_Type and F.Sell_BuyFlag = T.Sell_BuyFlag And F.Sett_Type = T.Sett_Type And F.Sett_No = T.Sett_No  
And F.Sec_Symbol = T.Sec_Symbol And F.Security_Series = T.Security_Series And F.CP_Code = T.CP_Code And sauda_date like ''+@saudadate+'%' 

Group by 
F.Rec_Type, F.Sell_BuyFlag, F.Sett_Type, F.Sett_No,F.Sec_Symbol, F.Security_Series, F.CP_Code,F.Oblig_Qty ,F.Oblig_Value 
)  S where sauda_date like ''+ @saudadate +'%' and ToExchange.cp_code = 'inst' and S.Rec_type = 10 
and S.Sett_type = ToExchange.Sett_Type and S.Sett_no = ToExchange.Sett_no and S.Sec_symbol = ToExchange.Sec_Symbol 
and S.Security_Series = ToExchange.Security_series and S.Sell_buyFlag = Toexchange.sell_buyFlag 
Order By ToExchange.Sett_Type, ToExchange.Sett_No,ToExchange.Sec_Symbol

GO
