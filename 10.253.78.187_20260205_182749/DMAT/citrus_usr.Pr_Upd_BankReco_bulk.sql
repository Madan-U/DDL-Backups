-- Object: PROCEDURE citrus_usr.Pr_Upd_BankReco_bulk
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--[Pr_Upd_BankReco_bulk] 1,4,'Y','',''  
--ldg_id1 + coldel + bank_cl_dt1 + rowdel + ldg_id2 + coldel + bank_cl_dt2 + rowdel  
CREATE procedure [citrus_usr].[Pr_Upd_BankReco_bulk](@pa_finyearid numeric, @pa_excsm_id numeric,@pa_reco_yn varchar(25), @pa_values varchar(8000),@pa_ref_cur varchar(8000) output)  
as  
begin  
--  
  declare @l_sql varchar(8000)  
  declare @l_counter numeric  
   , @l_count numeric  
   , @L_VAL VARCHAR(8000)  
  
 
  set @l_sql = ''
  
  set @l_sql = 'update LDG'  
  set @l_sql = @l_sql  + case when @pa_reco_yn = 'Y' then ' set LDG_BANK_CL_DATE = convert(datetime,txndate,103)'  
                         else  ' set LDG_BANK_CL_DATE = null ' end 
  set @l_sql = @l_sql  + ' FROM ledger'+convert(varchar,@pa_finyearid) + ' LDG , DP_MSTR, tblbankupload'  
  set @l_sql = @l_sql  + ' where ldg_voucher_dt < convert(datetime,txndate,103)' 
  set @l_sql = @l_sql  + ' and LDG_AMOUNT = case when CrDr = ''CR'' then amount else amount*-1 end ' 
  set @l_sql = @l_sql  + ' and LDG_INSTRUMENT_NO =  CheckNo ' 
  set @l_sql = @l_sql  + ' AND DPM_EXCSM_ID = DEFAULT_DP AND DPM_ID = ' + CONVERT(VARCHAR,@pa_excsm_id)   
  
  

  PRINT @L_SQL  
  EXEC(@L_SQL)  
  
  
  SET @pa_ref_cur = 'Record Successfully Updated'  
--  
end

GO
