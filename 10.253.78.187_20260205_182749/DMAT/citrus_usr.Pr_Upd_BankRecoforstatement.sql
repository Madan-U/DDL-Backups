-- Object: PROCEDURE citrus_usr.Pr_Upd_BankRecoforstatement
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--LEDGER1
--Pr_Upd_BankRecoforstatement 1,4,'Y','1|*~|638|*~|12/12/2009|*~|646|*~|12/12/2008|*~|*|~*',''  
--Pr_Upd_BankRecoforstatement 1,4,'Y','638|*~|12/12/2009|*~|*|~*646|*~|12/12/2008|*~|*|~*',''  
--ldg_id1 + coldel + bank_cl_dt1 + rowdel + ldg_id2 + coldel + bank_cl_dt2 + rowdel  
CREATE procedure [citrus_usr].[Pr_Upd_BankRecoforstatement](@pa_finyearid numeric, @pa_excsm_id numeric,@pa_reco_yn varchar(25), @pa_values varchar(8000),@pa_ref_cur varchar(8000) output)  
as  
begin  
--  


  declare @l_sql varchar(8000)
 ,@L_SQL1 VARCHAR(8000)  
  ,@l_counter numeric  
   , @l_count numeric  
   , @L_VAL VARCHAR(8000)  
 
  set @l_counter = 1   
  select @l_count = citrus_usr.ufn_countstring(@pa_values , '*|~*')  
set dateformat dmy
  SET @l_sql = ''
    
  while @l_counter <=@l_count   
  begin  
    
  set @l_val = citrus_usr.fn_splitval_row(@pA_VALUES,@L_COUNTER)  

--  if citrus_usr.fn_splitval(@l_val,2) <> ''
--  begin  

  --print citrus_usr.fn_splitval(@l_val,1) 

  

  set @l_sql = @l_sql + 'update LDG' 
 
  set @l_sql = @l_sql  + case when @pa_reco_yn = 'Y' then ' set LDG_BANK_CL_DATE = convert(datetime,''' + citrus_usr.fn_splitval(@l_val,3)+ ''',103)'  
                         else  ' set LDG_BANK_CL_DATE = null ' end 
  set @l_sql = @l_sql  + ', LDG_INSTRUMENT_NO = ''' + citrus_usr.fn_splitval(@l_val,4)+ ''' , LDG_NARRATION = ''' + citrus_usr.fn_splitval(@l_val,5)+ ''''
  set @l_sql = @l_sql  + ' FROM ledger'+convert(varchar,@pa_finyearid) + ' LDG , DP_MSTR'  
  set @l_sql = @l_sql  + ' where ldg_voucher_no = ' + citrus_usr.fn_splitval(@l_val,1)
 
  set @l_sql = @l_sql  + ' and  ldg_voucher_type = ' + case when citrus_usr.fn_splitval(@l_val,2)  = 'PAYMENT' then '1' 
															when citrus_usr.fn_splitval(@l_val,2)  = 'RECIEPT' then '2' 
															when citrus_usr.fn_splitval(@l_val,2)  = 'CONTRA' then '4' ELSE '' end 
  set @l_sql = @l_sql  + ' and ldg_voucher_type in (''1'',''2'',''4'') '
  set @l_sql = @l_sql  + ' AND DPM_EXCSM_ID = DEFAULT_DP AND DPM_ID = ' + CONVERT(VARCHAR,@pa_excsm_id)   


  SET @L_SQL1 = 'UPDATE TEMP'
  SET @L_SQL1 = @L_SQL1 + case when @pa_reco_yn = 'Y' then ' SET AUTOM_CHQNO = LDG_INSTRUMENT_NO , AUTOM_BANKRECO=''Y'' ' else ' SET  AUTOM_BANKRECO=''''' end
  set @L_SQL1 = @L_SQL1  + ' FROM ledger'+convert(varchar,@pa_finyearid) + ' LDG , DP_MSTR , AUTORECO_MSTR TEMP'  
  set @L_SQL1 = @L_SQL1  + ' where ldg_voucher_no = ' + citrus_usr.fn_splitval(@l_val,1)
 
  set @L_SQL1 = @L_SQL1  + ' and  ldg_voucher_type = ' + case when citrus_usr.fn_splitval(@l_val,2)  = 'PAYMENT' then '1' 
															when citrus_usr.fn_splitval(@l_val,2)  = 'RECIEPT' then '2' 
															when citrus_usr.fn_splitval(@l_val,2)  = 'CONTRA' then '4' ELSE '' end 
  set @L_SQL1 = @L_SQL1  + ' and ldg_voucher_type in (''1'',''2'',''4'') '
  set @L_SQL1 = @L_SQL1  + ' AND DPM_EXCSM_ID = DEFAULT_DP AND DPM_ID = ' + CONVERT(VARCHAR,@pa_excsm_id)   
  set @L_SQL1 = @L_SQL1  + ' AND (ABS(AUTOM_CREDIT) = ABS(ldg.LDG_AMOUNT) OR ABS(AUTOM_DEBIT) = ABS(ldg.LDG_AMOUNT)) '
  set @L_SQL1 = @L_SQL1  + ' and AUTOM_SNO = '+ citrus_usr.fn_splitval(@l_val,6) 
  
  set @l_counter = @l_counter + 1 
  

  EXEC(@L_SQL) 
  EXEC(@L_SQL1)

PRINT @L_SQL1 
 -- end 

  
  end   

  SET @pa_ref_cur = 'Record Successfully Updated'  
--  
end

GO
