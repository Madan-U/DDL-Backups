-- Object: PROCEDURE dbo.UpdateTradeMatch_BSE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE Proc [dbo].[UpdateTradeMatch_BSE] as      

Declare @Trd_Date Varchar(11)      
Select Distinct @Trd_Date = Trd_Date From Trade_Match_Imp_BSE      
Select @Trd_Date = cast(@Trd_Date as datetime)      
      
Update Trade_Match_Imp_BSE Set Trd_Date = @Trd_Date + ' ' + Trd_Time      
      
SELECT ORDER_NO, TRADE_NO, SCRIP_CD
INTO #Trade_Match FROM Trade_Match_BSE
WHERE SAUDA_DATE LIKE @TRD_DATE + '%'
      
Insert Into Trade_Match_BSE      
Select Trade_No,Order_No,'11',Scrip_Cd,'BSE',Scrip_Name,Group_Code,      
'1',MarketType,User_Id=(Case when Len(Rtrim(Ltrim(Order_no))) > 3   
        then Convert(Varchar,Right(Rtrim(Ltrim(Order_no)),3))  
        else '1'  
   end),PartiCIpantCode,Party_Code,      
Sell_buy = (Case When Sell_Buy = 'B' Then 1 Else 2 End),TradeQty,      
MarketRate/100,    
Pro_Cli = PartiCIpantCode,    
Party_Code,'N','0','7',Trd_Date,Trd_Date,      
IsIn,1,Order_Time,'',MarketRate/100,'N',2 From Trade_Match_Imp_BSE I
WHERE ORDER_NO NOT IN (SELECT ORDER_NO FROM #Trade_Match T
					  WHERE T.ORDER_NO = I.ORDER_NO
					  AND T.TRADE_NO = I.TRADE_NO
					  AND T.SCRIP_CD = I.SCRIP_CD)

GO
