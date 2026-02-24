-- Object: PROCEDURE dbo.USP_DormantClientUpdate_05022016
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

    
Create Proc [dbo].[USP_DormantClientUpdate_05022016]                
as                
--As Per System Date                
--Client Entered into System Before Apr 08 2011                
--Client Active as on date                
                
 select cl_code,Exchange,Segment,Active_date,Inactive_from,SystemDate,Deactive_Remarks,Deactive_value,LastABLBillDate=convert(Datetime,'Jan 01 1900')                 
 into #abl_cli                
 from msajag.dbo.client_brok_details     
 where --Active_date<convert(varchar(11),Getdate()-180)     
 Cl_code in     
 (Select distinct Cl_code from msajag.dbo.client_brok_details     
 Group by Cl_code having (min(Active_date))<convert(varchar(11),Getdate()-180))       
 -- Active_date<convert(varchar(11),Getdate())     
 and Inactive_from>getdate() and cl_code not like '98%'                
 and exchange not in ('MCX','NCX') and isnull(Deactive_value,'') not in ('D','C','I','B','T')                
      
 /*                
 C-->Close                
 D-->Dormant                
 I-->Inactive(Sebi or legal close)                
 B-->Close(Inactive Risk)                
 T-->Close(Old Code)                
 */                
      
 select cltcode,vdt=max(vdt)                 
 into #bse                 
 from anand.account_ab.dbo.ledger a, #abl_cli b                
 where a.cltcode=b.cl_code and                
 vdt>=convert(varchar(11),Getdate()-200)                
 and vtyp=15                
 group by cltcode                
                
                
 select cltcode,vdt=max(vdt)                 
 into #nse                 
 from anand1.account.dbo.ledger a, #abl_cli b                
 where a.cltcode=b.cl_code and vdt>=convert(varchar(11),Getdate()-200)                
 and vtyp=15                
 group by cltcode                
                
 select cltcode,vdt=max(vdt)                 
 into #fo                
 from angelfo.accountfo.dbo.ledger a, #abl_cli b                
 where a.cltcode=b.cl_code and vdt>=convert(varchar(11),Getdate()-200)                
 and vtyp=15                
 group by cltcode                
                
                
 select cltcode,vdt=max(vdt)                 
 into #nsx                
 from angelfo.accountcurfo.dbo.ledger a, #abl_cli b                
 where a.cltcode=b.cl_code and vdt>=convert(varchar(11),Getdate()-200)                
 and vtyp=15                
 group by cltcode                
                
 select cltcode,vdt=max(vdt)                 
 into #mcd                
 from angelcommodity.accountmcdxcds.dbo.ledger a, #abl_cli b                
 where a.cltcode=b.cl_code and vdt>=convert(varchar(11),Getdate()-200)                
 and vtyp=15                
 group by cltcode                
                
                
 /* Modified by Manesh on 08/08/2012 08:01 PM based on the request from Rahul Shah/Dharmesh Mistry to consider dormant segmentwise      
 instead of Entitywise */      
       
 --- Entitywise              
 update #abl_cli set LastABLBillDate=b.vdt from #bse b  where #abl_cli.cl_code=b.cltcode                 
                
 update #abl_cli set LastABLBillDate=b.vdt from #nse b  where #abl_cli.cl_code=b.cltcode                 
 and isnull(LastABLBillDate,'Jan 01 1900')<b.vdt                
                
 update #abl_cli set LastABLBillDate=b.vdt from #fo b  where #abl_cli.cl_code=b.cltcode                 
 and isnull(LastABLBillDate,'Jan 01 1900')<b.vdt                
                
 update #abl_cli set LastABLBillDate=b.vdt from #mcd b  where #abl_cli.cl_code=b.cltcode                 
 and isnull(LastABLBillDate,'Jan 01 1900')<b.vdt                
                
 update #abl_cli set LastABLBillDate=b.vdt from #nsx b  where #abl_cli.cl_code=b.cltcode                 
 and isnull(LastABLBillDate,'Jan 01 1900')<b.vdt                
       
       
 /* --- Segmentwise : START */      
 /*       
 update #abl_cli set LastABLBillDate=b.vdt from #bse b  where #abl_cli.cl_code=b.cltcode                 
 and #abl_cli.exchange='BSE' and segment='CAPITAL'      
       
 update #abl_cli set LastABLBillDate=b.vdt from #nse b  where #abl_cli.cl_code=b.cltcode                 
 and isnull(LastABLBillDate,'Jan 01 1900')<b.vdt                
 and #abl_cli.exchange='NSE' and segment='CAPITAL'      
                
 update #abl_cli set LastABLBillDate=b.vdt from #fo b  where #abl_cli.cl_code=b.cltcode                 
 and isnull(LastABLBillDate,'Jan 01 1900')<b.vdt                
 and #abl_cli.exchange='NSE' and segment='FUTURES'      
       
 update #abl_cli set LastABLBillDate=b.vdt from #mcd b  where #abl_cli.cl_code=b.cltcode                 
and isnull(LastABLBillDate,'Jan 01 1900')<b.vdt        
 and #abl_cli.exchange='MCD' and segment='FUTURES'              
       
 update #abl_cli set LastABLBillDate=b.vdt from #nsx b  where #abl_cli.cl_code=b.cltcode                 
 and isnull(LastABLBillDate,'Jan 01 1900')<b.vdt                
 and #abl_cli.exchange='NSX' and segment='FUTURES'      
 */      
 /* --- Segmentwise : END */                
      
 insert into tbl_Angel_DormantClientABL                
 select *,Getdate()                
 from #abl_cli a where isnull(LastABLBillDate,'Jan 01 1900')<convert(varchar(11),getdate()-180)   
  and exists  
 (select * from (select cl_code,Active_Date=MIN(Active_Date) from #abl_cli group by cl_code)b where a.Cl_Code=b.Cl_Code  
 and a.Active_Date<convert(varchar(11),getdate()-180))               
     
     
              
                
 begin tran                
  /*Added On Nov 17 2011*/          
  insert into msajag.dbo.client_brok_details_log            
    
  select a.Cl_Code,a.Exchange,a.Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,Credit_Limit,a.InActive_From,Print_Options,No_Of_Copies,Participant_Code,Custodian_Code,Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,Market_Type,Multiplier
  
    
      
        
,Charged,Maintenance,Reqd_By_Exch,Reqd_By_Broker,Client_Rating,Debit_Balance,Inter_Sett,TRD_STT,Trd_Tran_Chrgs,Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt,Del_Stt,Del_Tran_Chrgs,Del_SEBI_Fees,Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt,        
Rounding_Method,Round_To_Digit,Round_To_Paise,Fut_Brok,Fut_Opt_Brok,Fut_Fut_Fin_Brok,Fut_Opt_Exc,Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,Fut_Sebi_Fees,Fut_Stamp_Duty,Fut_Other_Chrgs,Status,a.Modifiedon,a.Modifiedby,Imp_Status,Pay_B3B_Payment,      
Pay_Bank_name,Pay_Branch_name,Pay_AC_No,Pay_payment_Mode,Brok_Eff_Date,Inst_Trd_Brok,Inst_Del_Brok,Edit_By='DormantPro',Edit_on=getdate(),a.SYSTEMDATE,a.Active_Date,CheckActiveClient,a.Deactive_Remarks,a.Deactive_value          
  from msajag.dbo.client_brok_details a, #abl_cli b          
  where a.cl_code=b.cl_code and a.exchange=b.exchange                 
  and a.segment=b.segment                
  and isnull(LastABLBillDate,'Jan 01 1900')<convert(varchar(11),getdate()-180)    
   and exists  
 (select * from (select cl_code,Active_Date=MIN(Active_Date) from #abl_cli group by cl_code) c where b.Cl_Code=c.Cl_Code  
 and b.Active_Date<convert(varchar(11),getdate()-180))              
                
  update msajag.dbo.client_brok_details set Deactive_value='D',Deactive_Remarks='Dormant client',
  -- As requested by siva to comment imp status as this is not required 12/112014
  --imp_status=0,
  Modifiedon=getdate()   
  from  #abl_cli b                
  where msajag.dbo.client_brok_details.cl_code=b.cl_code and msajag.dbo.client_brok_details.exchange=b.exchange                 
  and msajag.dbo.client_brok_details.segment=b.segment                
  and isnull(LastABLBillDate,'Jan 01 1900')<convert(varchar(11),getdate()-180)  
   and exists  
 (select * from (select cl_code,Active_Date=MIN(Active_Date) from #abl_cli group by cl_code) c where b.Cl_Code=c.Cl_Code  
 and b.Active_Date<convert(varchar(11),getdate()-180))                
                
 commit

GO
