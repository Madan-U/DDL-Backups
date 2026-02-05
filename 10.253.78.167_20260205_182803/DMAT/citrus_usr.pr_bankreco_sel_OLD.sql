-- Object: PROCEDURE citrus_usr.pr_bankreco_sel_OLD
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--pr_bankreco_sel '4','N',2,'apr 22 2010','jun 28 2010','ALL','HDFCCLIENT',''

--pr_bankreco_sel '1','y',3,'feb 01 2010','feb 28 2010','1',''	
CREATE proc [citrus_usr].[pr_bankreco_sel_OLD](@pa_fin_id varchar(10), @pa_rec_flg char(1),@pa_dpm_id numeric
,@pa_from_dt varchar(20),@pa_to_dt varchar(20),@pa_voucher_type varchar(10),@pa_acct_cd varchar(20),@pa_out varchar(20) out)  
as  
begin 
 
declare @l_sql varchar(8000)
,@l_sql1 varchar(8000)

set @l_sql = 'select DISTINCT A.LDG_VOUCHER_TYPE
,A.LDG_VOUCHER_DT
,A.LDG_VOUCHER_NO 
,A.LDG_NARRATION
,b.LDG_INSTRUMENT_NO
,A.FINA_ACC_NAME + ''-'' + isnull(DPAM_SBA_NO ,'''') + ''-'' + isnull(DPAM_SBA_NAME ,'''') FINA_ACC_NAME
,A.LDG_AMOUNT
,A.ACCTNO
,A.ord
,A.LDG_BANK_CL_DATE

from (SELECT LDG_VOUCHER_TYPE , CONVERT(VARCHAR(11),LDG_VOUCHER_DT,103) LDG_VOUCHER_DT,LDG_VOUCHER_NO,CONVERT(VARCHAR(11),LDG_BANK_CL_DATE,103) LDG_BANK_CL_DATE
,LDG_NARRATION , LDG_INSTRUMENT_NO,FINA_ACC_NAME, LDG_AMOUNT , FINA_ACC_CODE ACCTNO , LDG_VOUCHER_DT ord  
FROM LEDGER' + @pa_fin_id +   ' b ,FIN_ACCOUNT_MSTR,DP_MSTR where '
IF @pa_rec_flg = 'Y'
SET @l_sql =  @l_sql  + ' ISNULL(LDG_BANK_CL_DATE,''1900-01-01 00:00:00.000'') = ''1900-01-01 00:00:00.000'' '   
ELSE 
SET @l_sql =  @l_sql  + ' ISNULL(LDG_BANK_CL_DATE,''1900-01-01 00:00:00.000'') <> ''1900-01-01 00:00:00.000'' '   

SET @l_sql  = @l_sql  + 'and LDG_VOUCHER_TYPE  in  '+ case when  @pa_voucher_type ='all' then '(''1'',''2'',''4'')' else  '(''' + @pa_voucher_type + ''')' end  +' 
AND LDG_VOUCHER_DT BETWEEN '''  + @pa_from_dt + ''' AND ''' +   @pa_to_dt  + '''
AND LDG_ACCOUNT_ID=FINA_ACC_ID  
AND LDG_DPM_ID = DPM_ID  
AND DEFAULT_DP=DPM_EXCSM_ID 
and ldg_deleted_ind = 1 
AND FINA_ACC_TYPE=''B''
aND DPM_ID = ''' + convert(varchar,@pa_dpm_id  ) +'''
and FINA_ACC_CODE = ''' + @pa_acct_cd + '''
) A , ledger' + @pa_fin_id   + ' b left outer join dp_acct_mstr  on ldg_account_id = dpam_id 
where b.ldg_voucher_no = a.ldg_voucher_no
and   b.LDG_VOUCHER_TYPE = a.LDG_VOUCHER_TYPE
and   b.ldg_account_type in (''P'',''C'',''G'') and ldg_deleted_ind = 1
and   b.LDG_VOUCHER_TYPE  in  (''1'',''2'',''4'') 
order by ord , a.LDG_VOUCHER_TYPE,  a.LDG_VOUCHER_NO 
'

--set @l_sql1 = ' UNION SELECT LDG_VOUCHER_TYPE , CONVERT(VARCHAR(11),LDG_VOUCHER_DT,103) LDG_VOUCHER_DT ,LDG_VOUCHER_NO ,LDG_NARRATION , LDG_INSTRUMENT_NO,BANM_NAME FINA_ACC_NAME, LDG_AMOUNT ,CLIBA_AC_NO ACCTNO , LDG_VOUCHER_DT ord FROM LEDGER'+@pa_fin_id + ',DP_ACCT_MSTR,CLIENT_BANK_ACCTS,DP_MSTR,BANK_MSTR   
--WHERE '
--IF @pa_rec_flg = 'Y'
--SET @l_sql1    = @l_sql1  + ' ISNULL(convert(varchar(11),LDG_BANK_CL_DATE,109),''jan 01 1900'') = ''jan 01 1900'' '   
--ELSE 
--SET @l_sql1   = @l_sql1  + ' ISNULL(convert(varchar(11),LDG_BANK_CL_DATE,109),''jan 01 1900'') <> ''jan 01 1900'' '   
--
--
--SET @l_sql1  = @l_sql1  + 'and LDG_VOUCHER_TYPE  in  '+ case when  @pa_voucher_type ='all' then '(''1'',''2'',''4'')' else  '(''' + @pa_voucher_type + ''')' end  +' 
--AND LDG_VOUCHER_DT BETWEEN '''  + @pa_from_dt + ''' AND ''' +   @pa_to_dt  + '''
--AND LDG_ACCOUNT_ID=DPAM_ID
--AND DPAM_ID = CLIBA_CLISBA_ID
--AND CLIBA_BANM_ID = BANM_ID
--AND LDG_DPM_ID = DPM_ID  
--AND DEFAULT_DP=DPM_EXCSM_ID  
--aND DPM_ID = ''' + convert(varchar,@pa_dpm_id  ) +'''
--AND CLIBA_DELETED_IND=1 and ldg_account_type=''P''
--AND DPAM_DELETED_IND=1
--AND BANM_DELETED_IND=1 


PRINT(@l_sql)
exec(@l_sql)
  
end

GO
