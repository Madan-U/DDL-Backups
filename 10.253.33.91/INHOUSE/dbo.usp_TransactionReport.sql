-- Object: PROCEDURE dbo.usp_TransactionReport
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE proc usp_TransactionReport --'P','01/06/2010','N'  
@ReportType char(1),         
@TradeDate varchar(21),      
@SettType varchar(2)      
as            
/*----Sell-----*/            
IF @ReportType = 'S'    
begin    
  select top 5 a.Sauda_Date, Segment='NSE', a.Sett_Type, PayinDate = c.Funds_Payin,        
  SecSettDt = c.sec_payout, FundsCrDt = a.sauda_date+3,        
  a.Party_Name, b.Party_Code, SCrip = SCrip_CD +' '+ Scrip_Name,            
  ISIN, a.Sett_NO, BillNO,  Cl_Type, CltDpId1,QtyDel= SQtyDel, AmtDel=SAmtDel,        
  Price = (SAmtDel/SQtyDel),  
--CASE WHEN SQtyDel<>0 THEN (SAmtDel/SQtyDel) ELSE SQtyDel END,   
Val = SAmtDel, CASA = (SAmtDel + SBrokDel),        
  NetAmt =  (SAmtDel - SBrokDel)           
  from       
  msajag.dbo.cmbillvalan a with (nolock)            
  inner join            
  intranet.risk.dbo.client_details b with (nolock)            
  on            
  a.party_code = b.cl_code           
  inner join          
  msajag.dbo.sett_mst c          
  on          
  a.sett_type = c.sett_type and convert(varchar,a.sauda_date,103) = convert(varchar,c.start_date,103)          
  where       
  a.sett_type = @SettType      
  and         
  b.branch_cd = 'CHEN'            
  and            
  cl_type = 'CLI'            
  and              
  convert(varchar(11),a.sauda_date,103) = @TradeDate  
  --and a.sauda_date < convert(datetime,@TradeDate,103)+ ' 23:59:59.999'
  and a.SQtyDel > 0    
  and c.Exchange = 'NSE'         
  order by       
  b.Party_Code, SCrip      
End     
  
  
          
            
/*----Purchase-----*/            
    
IF @ReportType = 'P'    
Begin    
  select top 5 a.Sauda_Date, Segment='NSE', a.Sett_Type, PayinDate = c.Funds_Payout,        
  SecSettDt = c.sec_payin, SecDelDt = a.sauda_date+3,        
  a.Party_Name, b.Party_Code, SCrip = SCrip_CD +' '+ Scrip_Name,            
  ISIN, a.Sett_NO, BillNO,  Cl_Type, CltDpId1, QtyDel=PQtyDel, AmtDel=PAmtDel,        
  Price = (PAmtDel/PQtyDel), Val = PAmtDel, CASA = (PAmtDel + PBrokDel),        
  NetAmt =  (PAmtDel + PBrokDel)           
              
  from       
  msajag.dbo.cmbillvalan a with (nolock)            
  inner join            
  intranet.risk.dbo.client_details b with (nolock)            
  on            
  a.party_code = b.cl_code           
  inner join          
  msajag.dbo.sett_mst c          
  on          
  a.sett_type = c.sett_type and convert(varchar,a.sauda_date,103) = convert(varchar,c.start_date,103)          
  where    
  a.sett_type = @SettType      
  and                  
  b.branch_cd = 'CHEN'            
  and            
  cl_type = 'CLI'            
  and              
  convert(varchar(11),a.sauda_date,103) = @TradeDate  
  --and a.sauda_date < convert(datetime,@TradeDate,103)+ ' 23:59:59.999'     
  and PQTYDel > 0  
  and c.Exchange = 'NSE'       
End

GO
