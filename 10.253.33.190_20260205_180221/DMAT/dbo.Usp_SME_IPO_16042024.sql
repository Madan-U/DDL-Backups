-- Object: PROCEDURE dbo.Usp_SME_IPO_16042024
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------




 
      
--exec Usp_SME_IPO      
Create Proc [dbo].[Usp_SME_IPO_16042024]      
AS      
BEGIN  



  Truncate table SMEClientData
      
  select *  into #rcs from INTRANET.risk.dbo.Tbl_BSE_NSE_Scrip_Master      
        
  select distinct a.TD_CURDATE,a.TD_AC_CODE,a.TD_ISIN_CODE,a.TD_QTY,a.TD_DESCRIPTION,b.ISIN,b.Lotsize      
  into #esfg      
  from citrus_usr.SYNERGY_TRXN_DETAILS a Right join #rcs b       
  on a.TD_ISIN_CODE=b.ISIN      
  where a.TD_DESCRIPTION in ('INITIALPUBLIC OFFERING','TRANSMISSION')      
  and TD_TRXNO not in ('4456','2215')  
   
 --------OFF market share -----------------------   
  --select b.* into #notinholding from #esfg a Right join #rcs b   
  --on a.TD_ISIN_CODE =b.ISIN 
  --where a.TD_ISIN_CODE is null  
   
  --select a.*,b.Symbol,b.Series,b.ISIN as I_ISIN,b.Lotsize,b.ScripCode,b.Active_suspend   
  --into #offmarket  
  --from [CSOKYC-6].general.dbo.Tbl_DPDirectPush a inner join #notinholding b   
  --on  a.ISIN=b.isin  
        
  ---------------------------END-----------------------      
  select a.*,b.NISE_PARTY_CODE into #qwe from #esfg a inner join tbl_client_master b       
  on a.TD_AC_CODE=b.client_Code      
        
  select a.*,b.FREE_QTY,b.netqty into #holdingData  from #qwe a inner join citrus_usr.holding b       
  on a.NISE_PARTY_CODE=b.tradingid      
  and a.TD_ISIN_CODE=b.hld_isin_code      
     
     
  select * into #Tbl_CMBill_BSE_NSE from INTRANET.risk.dbo.Tbl_CMBill_BSE_NSE where  ( PQTYDEL + SQTYDEL) >0    
      
  select a.TD_CURDATE,a.TD_AC_CODE,a.TD_ISIN_CODE,a.TD_QTY,a.Lotsize,a.NISE_PARTY_CODE,a.FREE_QTY,a.netqty,a.TD_DESCRIPTION,b.*   
  into #final_data from #holdingData a   
  left join #Tbl_CMBill_BSE_NSE b    
  on a.NISE_PARTY_CODE=b.party_code    
  and a.TD_ISIN_CODE=b.isin    
    
  select * into #sett12 from [AngelNseCM].msajag.dbo.sett_mst where Start_date < Convert(varchar(11),GETDATE(),120) and  Sec_Payin>= Convert(varchar(11),GETDATE(),120)   
  and Sett_Type in ('W','N')   
        
 declare @maxDate datetime        
 Declare @Vardate datetime    
 Select @Vardate= max(Start_date)  from #sett12    
                
 select * into #VARDETAIL from AngelNseCM.msajag.dbo.VARDETAIL where DetailKey=replace(convert(varchar, @Vardate, 103),'/','')    
    
   
 select distinct SCRIP_CD,ISIN,CL_RATE into #tbl_closing_mtm from AngelNseCM.msajag.dbo.closing_mtm                 
 where cast(sysdate as date)= (select max(sysdate)  from AngelNseCM.msajag.dbo.closing_mtm)  
   
 select a.ISIN,a.SecVar,a.IndexVar,a.AppVar,a.SecSpecVar,a.VarMarginRate,b.CL_RATE   
 into #tbl_var_closing_mtm from  #VARDETAIL a inner join #tbl_closing_mtm b   
 on a.IsIN=b.ISIN  
   
 select a.*,b.AppVar,b.CL_RATE into #tbl_final_data from #final_data a left join #tbl_var_closing_mtm b   
 on a.TD_ISIN_CODE=b.ISIN  

 ------------------TD_QTY < lotsize logic changes for jira id ORE-3023------------------
     
    
select NISE_PARTY_CODE,TD_ISIN_CODE,qty,[IS_Collateral],[EVALUATIONMETHOD],[Collateral_QUANTITY],haircut,[Collateral update QUANTITY],[Holding update QUANTITY],[CL_RATE],[Withheld Holding Qty],[Withheld Collateral Qty],Type  
into #temp   
from(  
 select NISE_PARTY_CODE ,TD_ISIN_CODE,(case when TD_QTY > lotsize then lotsize
               when TD_QTY = lotsize then lotsize
               when TD_QTY < lotsize then TD_QTY    end )as qty,  
              '1' as 'IS_Collateral','0' as 'EVALUATIONMETHOD','0' as 'Collateral_QUANTITY',100 as haircut,'' as 'Collateral update QUANTITY',  
              '' as 'Holding update QUANTITY',Isnull(CL_RATE,0)CL_RATE,'' as 'Withheld Holding Qty', '' as 'Withheld Collateral Qty','CNC' as Type  
            from #tbl_final_data where  Party_code is null  and TD_DESCRIPTION  in ('INITIALPUBLIC OFFERING')
                                                                                        
 union all  
 select NISE_PARTY_CODE ,TD_ISIN_CODE,0 as qty,  
              '0' as 'IS_Collateral','0' as 'EVALUATIONMETHOD','0' as 'Collateral_QUANTITY',0 as haircut,'' as 'Collateral update QUANTITY',  
              '' as 'Holding update QUANTITY',0 as cl_rate,'' as 'Withheld Holding Qty', '' as 'Withheld Collateral Qty','CNC' as Type  
            from #tbl_final_data where  Party_code <>''  and TD_DESCRIPTION  in ('INITIALPUBLIC OFFERING') 
 union all  
 select NISE_PARTY_CODE ,TD_ISIN_CODE,0 as qty,  
              '0' as 'IS_Collateral','0' as 'EVALUATIONMETHOD','0' as 'Collateral_QUANTITY',0 as haircut,'' as 'Collateral update QUANTITY',  
              '' as 'Holding update QUANTITY',0 as cl_rate,'' as 'Withheld Holding Qty', '' as 'Withheld Collateral Qty','CNC' as Type  
            from #tbl_final_data  where  TD_DESCRIPTION not in ('INITIALPUBLIC OFFERING') 
 )A  
  
  Insert into SMEClientData
  select    
  Ltrim(Rtrim(NISE_PARTY_CODE)) +','+ TD_ISIN_CODE+','+convert(varchar(50),qty)+','+ [IS_Collateral]+','+[EVALUATIONMETHOD]+','+[Collateral_QUANTITY]+','+convert(varchar(50),haircut)+','+[Collateral update QUANTITY]+','+[Holding update QUANTITY]+','+convert(varchar(50),[CL_RATE])+','+[Withheld Holding Qty]+','+[Withheld Collateral Qty]+','+Type  
  as Output from #temp  
       
END

GO
