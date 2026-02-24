-- Object: PROCEDURE citrus_usr.Pr_Upd_BankReco
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--Pr_Upd_BankReco 1,4,'Y','638|*~|12/12/2009|*~|*|~*646|*~|12/12/2008|*~|*|~*',''  
--ldg_id1 + coldel + bank_cl_dt1 + rowdel + ldg_id2 + coldel + bank_cl_dt2 + rowdel  
CREATE procedure [citrus_usr].[Pr_Upd_BankReco](@pa_finyearid numeric, @pa_excsm_id numeric,@pa_reco_yn varchar(25), @pa_values varchar(8000),@pa_ref_cur varchar(8000) output)  
as  
begin  
--  


  declare @l_sql varchar(8000)  
  declare @l_counter numeric  
   , @l_count numeric  
   , @L_VAL VARCHAR(8000)  
  set @l_counter = 1   
  select @l_count = citrus_usr.ufn_countstring(@pa_values , '*|~*')  
    
  while @l_counter <=@l_count   
  begin  
    
  set @l_val = citrus_usr.fn_splitval_row(@pA_VALUES,@L_COUNTER)  

--  if citrus_usr.fn_splitval(@l_val,2) <> ''
--  begin  

  print citrus_usr.fn_splitval(@l_val,1) 

  set @l_sql = 'update LDG'  
  set @l_sql = @l_sql  + case when @pa_reco_yn = 'Y' then ' set LDG_BANK_CL_DATE = convert(datetime,''' + citrus_usr.fn_splitval(@l_val,3)+ ''',103)'  
                         else  ' set LDG_BANK_CL_DATE = null ' end 
  set @l_sql = @l_sql  + ' FROM ledger'+convert(varchar,@pa_finyearid) + ' LDG , DP_MSTR'  
  set @l_sql = @l_sql  + ' where ldg_voucher_no = ' + citrus_usr.fn_splitval(@l_val,1) 
  set @l_sql = @l_sql  + ' and  ldg_voucher_type = ' + case when citrus_usr.fn_splitval(@l_val,2)  = 'PAYMENT' then '1' when citrus_usr.fn_splitval(@l_val,2)  = 'RECIEPT' then '2' when citrus_usr.fn_splitval(@l_val,2)  = 'CONTRA' then '4' end 
  set @l_sql = @l_sql  + ' and ldg_voucher_type in (''1'',''2'',''4'') '
 
  set @l_sql = @l_sql  + ' AND DPM_EXCSM_ID = DEFAULT_DP AND DPM_ID = ' + CONVERT(VARCHAR,@pa_excsm_id)   
  
  set @l_counter = @l_counter + 1 
  

  EXEC(@L_SQL)  
 -- end 
  
  end   

  SET @pa_ref_cur = 'Record Successfully Updated'  
--  
end

GO
