-- Object: PROCEDURE dbo.Usp_buyback_dp_holding_eliQty
-- Server: 10.253.33.231 | DB: Scratchpad
--------------------------------------------------


    
--exec Usp_buy_back_dp_holding 'INE285J01028'    
CREATE proc [dbo].[Usp_buyback_dp_holding_eliQty]     
(    
@ISIN VARCHAR(20) = ''   
)    
AS    
BEGIN    
    
 select ISIN,Rate,    
 SUBSTRING(Retail_AllotmentValue, 1, CHARINDEX(':', Retail_AllotmentValue) - 1) as Retail_AllotmentValue_qty ,     
 SUBSTRING(Retail_AllotmentValue, CHARINDEX(':', Retail_AllotmentValue) + 1, LEN(Retail_AllotmentValue)) as Retail_AllotmentValue_eli_qty ,    
 SUBSTRING(HNI_AllotmentValue, 1, CHARINDEX(':', HNI_AllotmentValue) - 1) as HNI_AllotmentValue_qty ,     
 SUBSTRING(HNI_AllotmentValue, CHARINDEX(':', HNI_AllotmentValue) + 1, LEN(HNI_AllotmentValue)) as HNI_AllotmentValue_eli_qty,
 SettlementID,ScripName,Retail_AllotmentValue,HNI_AllotmentValue,
 case when ExchangeId = 4 then 'BSE'
 when ExchangeId = 5 then 'NSE'
 when ExchangeId = 6 then 'BSE/NSE' end as Exchange
 into  #tbl_buyback_scripmaster    
 from KYC1DB.[AngelBrokingWebDB].dbo.tbl_buyback_ScripMaster_new  with (nolock) where convert(date,getdate()) =  convert(date,RecordDate)
 --between convert(date,fromdate) and convert(date,Todate)




select  tradingid,hld_isin_code,CONVERT(DECIMAL(18,2) ,netqty) as netqty,CONVERT(DECIMAL(18,2),FREE_QTY) as FREE_QTY,CONVERT(DECIMAL(18,2),PLEDGE_QTY) as PLEDGE_QTY,
CONVERT(DECIMAL(18,2),A.Rate) as Rate,
CONVERT(DECIMAL(18,2),Valuation) as Valuation,HOLDINGDT
into #buy_back_ISIN 
from [DMAT].citrus_usr.[HOLDING] A with (nolock)  
inner join  #tbl_buyback_scripmaster B on A.hld_isin_code = B.isin  

select a.*,b.ISIN,
 (CONVERT(DECIMAL(18,2),(a.netqty*a.Rate))) as holding_value ,    
 case when ((a.netqty*a.Rate) > 200000) then (a. netqty*HNI_AllotmentValue_eli_qty/HNI_AllotmentValue_qty)    
      when ((a.netqty*a.Rate) < 200000) then (a. netqty*Retail_AllotmentValue_eli_qty/Retail_AllotmentValue_qty) end eligiable_QTY,
	  case when ((a.netqty*a.Rate) > 200000) then 'HNI'    
      when ((a.netqty*a.Rate) < 200000) then 'Retail' end category,  
	  b.SettlementID,b.ScripName,b.Retail_AllotmentValue,b.HNI_AllotmentValue,b.Exchange
 into #final_Eligible_hold_QTY   
 from #buy_back_ISIN  a left join #tbl_buyback_scripmaster b    
 on a.hld_isin_code=b.ISIN    
     

 
 select tradingid as ClientCode,hld_isin_code as ISIN,netqty as Total_Qty,FREE_QTY,PLEDGE_QTY,FLOOR(eligiable_QTY) as Eligiable_QTY,Rate,Valuation,convert(date,HOLDINGDT)HOLDINGDT,category,
 SettlementID,ScripName,Retail_AllotmentValue,HNI_AllotmentValue,Exchange,CONVERT(DECIMAL(18,2),holding_value) as holding_value, 'DP' as account
 into #temp --[INTRANET].[Dustbin].dbo.Tbl_Buyback_ClientDetails
 from #final_Eligible_hold_QTY 

 


--insert into KYC1DB.[AngelBrokingWebDB].dbo.Tbl_Buyback_ClientDetails(
--ClientCode,ISIN,Total_Qty,FREE_QTY,PLEDGE_QTY,Eligiable_QTY,Rate,Valuation,HOLDINGDT,Category,SettlementID,ScripName,Retail_AllotmentValue,HNI_AllotmentValue,Exchange,holding_value,account)    
--select * from #temp order by ISIN
 
  
END

GO
