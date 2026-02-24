-- Object: PROCEDURE dbo.USP_Prepaid_SlabUpdation
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc [dbo].[USP_Prepaid_SlabUpdation](@success1 varchar(50) output)          
as          
          
Set nocount on          

SET XACT_ABORT ON
        
Declare @success varchar(30)          
Declare @error int         
         
BEGIN TRY          
 
 
          
 begin tran         
        
 select * into #file from intranet.risk.dbo.pp_temp2 with (nolock)/*Expiry*/        
          
 select * into #file1 from intranet.risk.dbo.pp_temp1 with (nolock)  /*Activation*/       
     
insert into client_brok_details_log    
select    
Cl_Code,Exchange,Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,
Credit_Limit,InActive_From,Print_Options,No_Of_Copies,Participant_Code,
Custodian_Code,Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,Market_Type,
Multiplier,Charged,Maintenance,Reqd_By_Exch,Reqd_By_Broker,Client_Rating,Debit_Balance,
Inter_Sett,TRD_STT,Trd_Tran_Chrgs,Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt,
Del_Stt,Del_Tran_Chrgs,Del_SEBI_Fees,Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt,Rounding_Method,
Round_To_Digit,Round_To_Paise,Fut_Brok,Fut_Opt_Brok,Fut_Fut_Fin_Brok,Fut_Opt_Exc,
Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,Fut_Sebi_Fees,Fut_Stamp_Duty,Fut_Other_Chrgs,
Status,Modifiedon,Modifiedby,Imp_Status,Pay_B3B_Payment,Pay_Bank_name,Pay_Branch_name,Pay_AC_No,
Pay_payment_Mode,Brok_Eff_Date,Inst_Trd_Brok,Inst_Del_Brok,    
Edit_By='PP.SYSTEM',Edit_on=getdate(),SYSTEMDATE,Active_Date,
CheckActiveClient,Deactive_Remarks,Deactive_value    
from  client_brok_details with(nolock)    
where cl_Code in    
(select distinct cl_Code from #file union select distinct cl_Code from #file1)     
        
    delete from client_brok_details where cl_Code in (select distinct cl_Code from #file)                                           
    insert into client_brok_details select * from #file          
      
          
    delete from client_brok_details where cl_Code in (select distinct Cl_Code from #file1)                          
    insert into client_brok_details select * from #file1            
          
 update client_details           
    set imp_status=0,status='U',modifidedOn=getdate()    
    where cl_Code in (select distinct cl_Code from #file union select distinct cl_Code from #file1)                                           
                  
          
 if @@error=0        
         
  begin        
             
     /* Temparary commented due to Distributed transaction Issue  */        
     exec angelfo.nsefo.dbo.USP_Prepaid_FoUpdation @success output          
   set @error=convert(int,@success)        
        
  end        
        
 else        
        
  begin        
          
   set @error=@@error          
        
  end        
        
END TRY          
          
BEGIN CATCH          
          
        SELECT          
        ERROR_NUMBER() AS ErrorNumber          
        ,ERROR_SEVERITY() AS ErrorSeverity          
        ,ERROR_STATE() AS ErrorState          
        ,ERROR_PROCEDURE() AS ErrorProcedure          
        ,ERROR_LINE() AS ErrorLine          
        ,ERROR_MESSAGE() AS ErrorMessage          
  ,getdate() as date;          
        
END CATCH          
          
  if(@error=0)          
        
   BEGIN          
    commit          
    set @success1='true'          
   END          
        
  Else          
        
   BEGIN          
    rollback           
    set @success1='false'          
   END          
          
SET XACT_ABORT OFF          
Set nocount off

GO
