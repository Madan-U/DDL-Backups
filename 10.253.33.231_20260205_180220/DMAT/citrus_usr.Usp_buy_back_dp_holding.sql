-- Object: PROCEDURE citrus_usr.Usp_buy_back_dp_holding
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

    
--exec Usp_buy_back_dp_holding 'INE285J01028'    
CREATE proc [citrus_usr].[Usp_buy_back_dp_holding]     
(    
@ISIN VARCHAR(20)    
)    
AS    
BEGIN    
    
 select  tradingid,hld_isin_code,CONVERT(DECIMAL(18,2) ,netqty) as netqty,CONVERT(DECIMAL(18,2),FREE_QTY) as FREE_QTY,CONVERT(DECIMAL(18,2),PLEDGE_QTY) as PLEDGE_QTY,
 CONVERT(DECIMAL(18,2),Rate) as Rate,
 CONVERT(DECIMAL(18,2),Valuation) as Valuation,HOLDINGDT into  #buy_back_ISIN from  [HOLDING] with (nolock)  where hld_isin_code = 'INE285J01028' --@ISIN    
     
 select ISIN,Rate,    
    SUBSTRING(Retail_AllotmentValue, 1, CHARINDEX(':', Retail_AllotmentValue) - 1) as Retail_AllotmentValue_qty ,     
    SUBSTRING(Retail_AllotmentValue, CHARINDEX(':', Retail_AllotmentValue) + 1, LEN(Retail_AllotmentValue)) as Retail_AllotmentValue_eli_qty ,    
    SUBSTRING(HNI_AllotmentValue, 1, CHARINDEX(':', HNI_AllotmentValue) - 1) as HNI_AllotmentValue_qty ,     
    SUBSTRING(HNI_AllotmentValue, CHARINDEX(':', HNI_AllotmentValue) + 1, LEN(HNI_AllotmentValue)) as HNI_AllotmentValue_eli_qty     
 into  #tbl_buyback_scripmaster    
 from KYC1DB.[AngelBrokingWebDB].dbo.tbl_buyback_scripmaster  where ISIN = 'INE285J01028'    
     
 select a.*,b.ISIN,b.Retail_AllotmentValue_qty,b.Retail_AllotmentValue_eli_qty,b.HNI_AllotmentValue_qty,b.HNI_AllotmentValue_eli_qty,
 (CONVERT(DECIMAL(18,2),(a.netqty*a.Rate))) as holding_value ,    
 case when ((a.netqty*a.Rate) > 200000) then (a. netqty*HNI_AllotmentValue_eli_qty/HNI_AllotmentValue_qty)    
      when ((a.netqty*a.Rate) < 200000) then (a. netqty*Retail_AllotmentValue_eli_qty/Retail_AllotmentValue_qty) end eligiable_QTY    
 into #final_Eligible_hold_QTY   
 from #buy_back_ISIN  a left join #tbl_buyback_scripmaster b    
 on a.hld_isin_code=b.ISIN    
 
-- select *,FLOOR(eligiable_QTY)AS absolute_values from #final_Eligible_hold_QTY 
 
 select tradingid,hld_isin_code,netqty,FREE_QTY,PLEDGE_QTY,Rate,Valuation,HOLDINGDT,ISIN,
 Retail_AllotmentValue_qty,Retail_AllotmentValue_eli_qty,HNI_AllotmentValue_qty,
 HNI_AllotmentValue_eli_qty,CONVERT(DECIMAL(18,2),holding_value) as holding_value,FLOOR(eligiable_QTY) as eligiable_QTY, 'DP' as account
 into #temp1 from #final_Eligible_hold_QTY 
 
 
 
  CREATE TABLE #temp(        
    [ClCode] varchar(20) null,     
    [Qty] varchar(20) null,     
    [eligible] varchar(20) null,            
    [enCCode] varchar(max) null,        
    [enCQty] varchar(max) null,  
    [EncAccount] varchar(max) null  
  )        
  
  INSERT INTO #temp ([ClCode], [Qty],[eligible], enCCode, enCQty, EncAccount)        
  SELECT        
   tradingid,netqty, eligiable_QTY
    , CAST(N'' AS XML).value(        
      'xs:base64Binary(xs:hexBinary(sql:column("encCode")))'        
    , 'VARCHAR(MAX)'        
   )   encCode,        
    CAST(N'' AS XML).value(        
      'xs:base64Binary(xs:hexBinary(sql:column("encQty")))'        
    , 'VARCHAR(MAX)'        
   )   encQty     
   ,        
    CAST(N'' AS XML).value(        
      'xs:base64Binary(xs:hexBinary(sql:column("encAccount")))'        
    , 'VARCHAR(MAX)'        
   )   EncAccount 
     FROM (        
   SELECT CAST(tradingid AS VARBINARY(MAX)) AS encCode  
   --, CAST(CAST(Dmat_Qty as varchar) AS VARBINARY(MAX)) AS encQty  
   , CAST(CAST(netqty as varchar) AS VARBINARY(MAX)) AS encQty  --changed by kaustubh on 2018-08-30 as requested by Anil  
   , tradingid  ,netqty, eligiable_QTY
  -- , CAST(netqty as varchar) 'uploadedqty'   
   --, CAST(eligiable_QTY as varchar) 'eligible'      
   ,account as 'account'  
   ,CAST(account AS VARBINARY(MAX)) as 'encAccount'  
   FROM #temp1   
  ) AS bin_sql_server_temp; 
   
   --FROM #temp1 
   --AS bin_sql_server_temp;  
   
   --alter table  #temp1
   --add  account varchar (200)
   
   --update #temp1
   --set account = 'DP'
   --where account IS null

    
 DECLARE @SettlementID varchar(20) = '', @Bid_End_Date varchar(20) = '', @EncScripName varchar(500) = '';; 
 declare @UploadedFileId VARCHAR (200) =''  
   
 SELECT @EncScripName =   CAST(N'' AS XML).value(  
     'xs:base64Binary(xs:hexBinary(sql:column("bin")))'  
   , 'VARCHAR(MAX)'  
  ) ,  
  @SettlementID=SettlementID,@Bid_End_Date=Todate     
  FROM (  
   SELECT a.*,b.ISIN as ISIN,B.SettlementID as SettlementID ,B.Todate as Todate, CAST(a.ScripName AS VARBINARY(MAX)) AS bin     
   FROM KYC1DB.[AngelBrokingWebDB].[dbo].[tbl_buyback_Source] a WITH (NOLOCK)  
   LEFT JOIN KYC1DB.[AngelBrokingWebDB].dbo.tbl_buyback_ScripMaster B  WITH (NOLOCK)  
   ON A.ScripName=B.ScripName WHERE a.UploadedFileId = @UploadedFileId     
  )  as bin_sql_server_temp  
  
  --select @EncScripName
 
       
  select ClCode 'partycode', cd.long_name 'name',cd.email 'email',cd.mobile_pager 'mobile'  
   , Qty 'quantity', eligible 'UploadedQty', eligible  
   , 'https://mf.angelmf.com/User/BuyBack?ClientCode='+enCCode + '&Quantity=' + enCQty + '&scrip='+ @EncScripName +'&account='+EncAccount as 'link'      
  from #temp a WITH(NOLOCK)  
  inner join AngelNseCM.Msajag.dbo.client_details cd with(Nolock) on a.ClCode=cd.cl_code 
      
END

GO
