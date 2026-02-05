-- Object: PROCEDURE citrus_usr.pr_cheque_cancel_reject_process
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--pr_dp_select_mstr '1099','P2P_DP_TRX_SELM_DTLS','','','','','','',0,'*|~*','|*~|',''    
--
--declare @p12 varchar(1)
--set @p12=NULL
--exec pr_dp_select_mstr 
--@pa_id='1|*~|3|*~|',@pa_action='VOUCHERPAY_SEL',@pa_login_name='',@pa_cd='',@pa_desc='28/09/2010',@pa_rmks='203412',@pa_values='',@pa_roles='1*|~*6*|~*8*|~*',@pa_scr_id='217',@RowDelimiter='*|~*',@ColDelimiter='|*~|',@pa_ref_cur=@p12 
--output
--select @p12
/*
select * from dp_mstr where default_dp=dpm_excsm_id
select * from LEDGER1 ORDER BY 1 DESC  
exec pr_dp_select_mstr '0','VOUCHERJV_DTLS_SEL','HO','','','','','',0,'*|~*','|*~|',''

pr_cheque_cancel_reject_process	'1|*~|3|*~|','VOUCHERPAY_SEL','HO','','sep  1 2010','203412','sep 30 2010','','0','','','*|~*','|*~|',''	
pr_cheque_cancel_reject_process	'1|*~|3|*~|','VOUCHERPAY_SEL','HO','','sep  1 2009','203412','sep 30 2010','','0','','','*|~*','|*~|',''	
 
*/
--LEDGER
 --pr_dp_select_mstr '90123456','GETDORMANTCLTMSG','','0','','','01/09/2009','',0,'*|~*','|*~|','' 
 CREATE PROCEDURE  [citrus_usr].[pr_cheque_cancel_reject_process]
	( 
	@pa_id  VARCHAR(20)                  
	,@pa_action         VARCHAR(100)                  
	,@pa_login_name     VARCHAR(20)                  
	,@pa_cd             VARCHAR(25)                  
	,@pa_desc           VARCHAR(250)                  
	,@pa_rmks           VARCHAR(250)                  
	,@pa_values         VARCHAR(8000)                 
	,@pa_roles          VARCHAR(8000)                
	,@pa_scr_id         NUMERIC 
	,@pa_bankid         VARCHAR(40)
	,@pa_chqno			VARCHAR(15)
	,@rowdelimiter      CHAR(10)                  
	,@coldelimiter      CHAR(4)                  
	,@pa_ref_cur        VARCHAR(8000) OUT                  
	)                  
AS                
BEGIN                
--                
  declare @l_temp_id table(id numeric)                
  declare @l_count numeric                
        , @l_tot_count numeric                
        , @L_ENTTM_CD VARCHAR(25)                
        , @l_dpm_dpid  int                
        , @l_entm_id numeric                
        , @l_stam_cd varchar(20)                
        , @@fin_id   numeric     
        , @l_sql     varchar(8000)
        , @dpm_dpid varchar(16)   
         
        set @l_stam_cd ='ACTIVE'                
                        
        declare @l_max_date datetime                
           ,@l_rate     int                 
                        
        SET @L_ENTTM_CD = 'CLI'                     
            
            
  if  isnull(@pa_id,'') <> ''  and isnumeric(@pa_id) = 1          
  begin            
		   
           if  len(@pa_id) < 5            
		   begin    
			select @l_dpm_dpid = dpm_id from dp_mstr where isnull(DEFAULT_DP,0) = @pa_id and dpm_deleted_ind = 1
            select @dpm_dpid = dpm_dpid from dp_mstr where isnull(DEFAULT_DP,0) = @pa_id and dpm_deleted_ind = 1                 
		   end    
  end   
  ELSE  
  BEGIN  

	   IF  CITRUS_USR.FN_SPLITVAL(@PA_ID,2) <> ''  
	   begin
	   select @l_dpm_dpid = dpm_id from dp_mstr where isnull(DEFAULT_DP,0) = CITRUS_USR.FN_SPLITVAL(@PA_ID,2) and dpm_deleted_ind = 1     
       select @dpm_dpid = dpm_dpid from dp_mstr where isnull(DEFAULT_DP,0) = CITRUS_USR.FN_SPLITVAL(@PA_ID,2) and dpm_deleted_ind = 1         
	   end

	   SET @PA_ID = CITRUS_USR.FN_SPLITVAL(@PA_ID,1)  

  END  

	  set dateformat dmy     
	  
      if @pa_action like '%voucher%'
      begin    
		  if (isdate(CONVERT(DATETIME,@pa_desc,103))=1 )
		  begin
			  SELECT @@fin_id = FIN_ID FROM FINANCIAL_YR_MSTR WHERE FIN_DPM_ID = @l_dpm_dpid AND (CONVERT(DATETIME,@pa_desc,103) BETWEEN FIN_START_DT AND FIN_END_DT)AND FIN_DELETED_IND =1    
		  end            
      end
   
   select @l_entm_id = logn_ent_id from login_names where logn_name = @pa_login_name and logn_deleted_ind =  1                   
   
 
                    
   IF @pa_action ='VOUCHERPAY_SEL'                  
   BEGIN                  
   --     

   set @l_sql =' SELECT DISTINCT a.ldg_voucher_no   VOUCHERNO                 
          --,ldg_voucher_type   VOUCHERTYPE                
          --,ldg_book_type_cd   BOOKTYPECODE                
          ,a.ldg_ref_no          REFERENCENO                  
          ,convert(varchar(11),a.ldg_voucher_dt,103) VOUCHERDATE                           
          ,dpam_sba_no        ACCOUNTCODE                  
          ,dpam_sba_name      ACCOUNTNAME                
          ,a.ldg_amount         AMOUNT                
          ,a.ldg_id             id                  
          ,a.ldg_dpm_id         DPMID                
          ,dpam_id            ACCOUNTID                     
          ,a.ldg_account_type
          ,isnull(a.LDG_NARRATION,'''')   LDG_NARRATION   
          ,isnull(a.LDG_INSTRUMENT_NO,'''') LDG_INSTRUMENT_NO   , b.ldg_account_id bank_id  ,isnull(a.LDG_ACCOUNT_NO,'''')  LDG_ACCOUNT_NO              
  FROM   (SELECT ldg_account_id , LDG_VOUCHER_TYPE , CONVERT(VARCHAR(11),LDG_VOUCHER_DT,103) LDG_VOUCHER_DT,LDG_VOUCHER_NO,CONVERT(VARCHAR(11),LDG_BANK_CL_DATE,103) LDG_BANK_CL_DATE
,LDG_NARRATION , LDG_INSTRUMENT_NO,FINA_ACC_NAME, LDG_AMOUNT , FINA_ACC_CODE ACCTNO , LDG_VOUCHER_DT ord  
FROM LEDGER' + convert(varchar(20),@@fin_id)     +   ' b ,FIN_ACCOUNT_MSTR,DP_MSTR where 
 ldg_voucher_dt between CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                   
  AND CASE WHEN isnull('''+@pa_values+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_values+''',103) END                   
AND LDG_ACCOUNT_ID=FINA_ACC_ID  
AND LDG_DPM_ID = DPM_ID  
AND DEFAULT_DP=DPM_EXCSM_ID 
and ldg_deleted_ind = 1 
AND FINA_ACC_TYPE=''B''
aND DPM_ID = ''' + convert(varchar,@pa_rmks  ) +'''
AND LDG_ACCOUNT_ID LIKE  CASE  WHEN LTRIM(RTRIM('''+@pa_bankid+''')) = '''' THEN ''%'' ELSE '''+ @pa_bankid + ''' END 
) b, ledger' + convert(varchar(20),@@fin_id)              + '                
    a ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks +','+ @pa_id+',0)                  
  WHERE a.ldg_voucher_type =1                
  AND dpam_id    = a.ldg_account_id  and b.ldg_voucher_no = a.ldg_voucher_no
and   b.LDG_VOUCHER_TYPE = a.LDG_VOUCHER_TYPE              
  AND a.ldg_account_type = acct_type and a.ldg_account_type =''P''
  and not exists(select ldg_account_id ,ldg_amount,ldg_instrument_no from ledger' + convert(varchar(20),@@fin_id)              + ' c   
                 where  c.ldg_account_id = a.ldg_account_id and abs(c.ldg_amount)=abs(a.ldg_amount) and c.ldg_instrument_no=a.ldg_instrument_no and c.ldg_deleted_ind =1 and c.ldg_voucher_type = ''8'') 
  AND a.LDG_INSTRUMENT_NO LIKE CASE  WHEN LTRIM(RTRIM('''+@pa_chqno+''')) = '''' THEN ''%'' ELSE '''+ @pa_chqno + ''' END                  
  AND a.ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+ @pa_cd + ''' END                  
  AND a.ldg_voucher_dt between CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN a.ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                   
  AND CASE WHEN isnull('''+@pa_values+''','''') = '''' THEN a.ldg_voucher_dt ELSE convert(datetime,'''+@pa_values+''',103) END                   
  AND a.ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+  @pa_rmks  + ''' END                 
  AND a.ldg_deleted_ind = 1   
  ORDER BY  a.ldg_id              '  

  exec(@l_sql)  
  
 --                  
 END                  
                 
                 
 IF @pa_action ='VOUCHERREC_SEL'                  
  BEGIN                  
   --    

    set @l_sql =' SELECT DISTINCT a.ldg_voucher_no   VOUCHERNO                 
           --,ldg_voucher_type   VOUCHERTYPE                
           --,ldg_book_type_cd   BOOKTYPECODE                
           ,a.ldg_ref_no          REFERENCENO                  
           ,convert(varchar(11),a.ldg_voucher_dt,103) VOUCHERDATE                           
           ,dpam_sba_no      ACCOUNTCODE                  
			 ,dpam_sba_name      ACCOUNTNAME                
			 ,-1*a.ldg_amount        AMOUNT                
			 ,a.ldg_account_no     ACCOUNTNO                
			 ,a.ldg_id             id                  
			 ,a.ldg_dpm_id         DPMID                
			 ,dpam_id     ACCOUNTID                   
			 ,a.ldg_account_type    
			 ,isnull(a.LDG_NARRATION,'''')   LDG_NARRATION 
			 ,isnull(a.LDG_INSTRUMENT_NO,'''') LDG_INSTRUMENT_NO   , b.ldg_account_id bank_id   ,isnull(a.LDG_ACCOUNT_NO,'''')  LDG_ACCOUNT_NO                               
		   FROM   (SELECT ldg_account_id , LDG_VOUCHER_TYPE , CONVERT(VARCHAR(11),LDG_VOUCHER_DT,103) LDG_VOUCHER_DT,LDG_VOUCHER_NO,CONVERT(VARCHAR(11),LDG_BANK_CL_DATE,103) LDG_BANK_CL_DATE
		,LDG_NARRATION , LDG_INSTRUMENT_NO,FINA_ACC_NAME, LDG_AMOUNT , FINA_ACC_CODE ACCTNO , LDG_VOUCHER_DT ord  
		FROM LEDGER' + convert(varchar(20),@@fin_id)     +   ' b ,FIN_ACCOUNT_MSTR,DP_MSTR where 
		ldg_voucher_dt between CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                   
		AND CASE WHEN isnull('''+@pa_values+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_values+''',103) END                   
		AND LDG_ACCOUNT_ID=FINA_ACC_ID  
		AND LDG_DPM_ID = DPM_ID  
		AND DEFAULT_DP=DPM_EXCSM_ID 
		and ldg_deleted_ind = 1 
		AND FINA_ACC_TYPE=''B''
		aND DPM_ID = ''' + convert(varchar,@pa_rmks  ) +'''
		AND LDG_ACCOUNT_ID LIKE  CASE  WHEN LTRIM(RTRIM('''+@pa_bankid+''')) = '''' THEN ''%'' ELSE '''+ @pa_bankid + ''' END 
		) b, ledger' + convert(varchar(20),@@fin_id) + '                 
			 a ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks+','+@pa_id+',0)                  
		   WHERE a.ldg_voucher_type =2       and b.ldg_voucher_no = a.ldg_voucher_no
		and   b.LDG_VOUCHER_TYPE = a.LDG_VOUCHER_TYPE          
		   AND dpam_id    = a.ldg_account_id                
		   AND a.ldg_account_type = acct_type 
		  and a.ldg_account_type =''P''		    
          and not exists(select ldg_account_id ,ldg_amount,ldg_instrument_no from ledger' + convert(varchar(20),@@fin_id)              + ' c  
                 where  c.ldg_account_id = a.ldg_account_id and abs(c.ldg_amount)=abs(a.ldg_amount) and c.ldg_instrument_no=a.ldg_instrument_no and c.ldg_deleted_ind =1 and c.ldg_voucher_type = ''9'') 
		  AND a.LDG_INSTRUMENT_NO LIKE CASE  WHEN LTRIM(RTRIM('''+@pa_chqno+''')) = '''' THEN ''%'' ELSE '''+ @pa_chqno + ''' END                    
		   AND a.ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+ @pa_cd +''' END                  
		   AND a.ldg_voucher_dt between CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN a.ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                   
		   AND CASE WHEN isnull('''+@pa_values+''','''') = '''' THEN a.ldg_voucher_dt ELSE convert(datetime,'''+@pa_values+''',103) END                   
		   AND a.ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+@pa_rmks+''' END                 
		   AND a.ldg_deleted_ind = 1                  
		   ORDER BY  a.ldg_id              '  


   exec(@l_sql)  
PRINT @l_sql
  --                  
 END      
  --  
IF @pa_action ='VOUCHERCHQ_RET'                  
   BEGIN                  
   --     

   set @l_sql =' SELECT DISTINCT a.ldg_voucher_no   VOUCHERNO                 
          --,ldg_voucher_type   VOUCHERTYPE                
          --,ldg_book_type_cd   BOOKTYPECODE                
          ,a.ldg_ref_no          REFERENCENO                  
          ,convert(varchar(11),a.ldg_voucher_dt,103) VOUCHERDATE                           
          ,dpam_sba_no        ACCOUNTCODE                  
          ,dpam_sba_name      ACCOUNTNAME                
          ,a.ldg_amount         AMOUNT                
          ,a.ldg_id             id                  
          ,a.ldg_dpm_id         DPMID                
          ,dpam_id            ACCOUNTID                     
          ,a.ldg_account_type
          ,isnull(a.LDG_NARRATION,'''')   LDG_NARRATION   
          ,isnull(a.LDG_INSTRUMENT_NO,'''') LDG_INSTRUMENT_NO   , b.ldg_account_id bank_id  ,isnull(a.LDG_ACCOUNT_NO,'''')  LDG_ACCOUNT_NO, case when isnull(a.LDG_BANK_CL_DATE,'''')=''1900-01-01 00:00:00.000'' then null else isnull(convert(varchar(11),a.LDG_BANK_CL_DATE,103),'''') end  LDG_BANK_CL_DATE          
  FROM   (SELECT ldg_account_id , LDG_VOUCHER_TYPE , CONVERT(VARCHAR(11),LDG_VOUCHER_DT,103) LDG_VOUCHER_DT,LDG_VOUCHER_NO,CONVERT(VARCHAR(11),LDG_BANK_CL_DATE,103) LDG_BANK_CL_DATE
,LDG_NARRATION , LDG_INSTRUMENT_NO,FINA_ACC_NAME, LDG_AMOUNT , FINA_ACC_CODE ACCTNO , LDG_VOUCHER_DT ord  
FROM LEDGER' + convert(varchar(20),@@fin_id)     +   ' b ,FIN_ACCOUNT_MSTR,DP_MSTR where 
 ldg_voucher_dt between CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                   
  AND CASE WHEN isnull('''+@pa_values+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_values+''',103) END                   
AND LDG_ACCOUNT_ID=FINA_ACC_ID  
AND LDG_DPM_ID = DPM_ID  
AND DEFAULT_DP=DPM_EXCSM_ID 
and ldg_deleted_ind = 1 
AND FINA_ACC_TYPE=''B''
aND DPM_ID = ''' + convert(varchar,@pa_rmks  ) +'''
AND LDG_ACCOUNT_ID LIKE  CASE  WHEN LTRIM(RTRIM('''+@pa_bankid+''')) = '''' THEN ''%'' ELSE '''+ @pa_bankid + ''' END 
) b, ledger' + convert(varchar(20),@@fin_id)              + '                
    a ,CITRUS_USR.FN_gl_ACCT_LIST('+@pa_rmks +','+ @pa_id+',0)                  
  WHERE a.ldg_voucher_type = 9                
  AND dpam_id    = a.ldg_account_id  and b.ldg_voucher_no = a.ldg_voucher_no
and   b.LDG_VOUCHER_TYPE = a.LDG_VOUCHER_TYPE              
  AND a.ldg_account_type = acct_type and a.ldg_account_type =''P''
  AND a.LDG_INSTRUMENT_NO LIKE CASE  WHEN LTRIM(RTRIM('''+@pa_chqno+''')) = '''' THEN ''%'' ELSE '''+ @pa_chqno + ''' END                  
  AND a.ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+ @pa_cd + ''' END                  
  AND a.ldg_voucher_dt between CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN a.ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                   
  AND CASE WHEN isnull('''+@pa_values+''','''') = '''' THEN a.ldg_voucher_dt ELSE convert(datetime,'''+@pa_values+''',103) END                   
  AND a.ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+  @pa_rmks  + ''' END                 
  AND a.ldg_deleted_ind = 1   
  ORDER BY  a.ldg_id              '  

  exec(@l_sql)  
  
 --                  
 END 

IF @pa_action ='VOUCHERCHQ_CAN'                  
   BEGIN                  
   --     

   set @l_sql =' SELECT DISTINCT a.ldg_voucher_no   VOUCHERNO                 
          --,ldg_voucher_type   VOUCHERTYPE                
          --,ldg_book_type_cd   BOOKTYPECODE                
          ,a.ldg_ref_no          REFERENCENO                  
          ,convert(varchar(11),a.ldg_voucher_dt,103) VOUCHERDATE                           
          ,dpam_sba_no        ACCOUNTCODE                  
          ,dpam_sba_name      ACCOUNTNAME                
          ,a.ldg_amount         AMOUNT                
          ,a.ldg_id             id                  
          ,a.ldg_dpm_id         DPMID                
          ,dpam_id            ACCOUNTID                     
          ,a.ldg_account_type
          ,isnull(a.LDG_NARRATION,'''')   LDG_NARRATION   
          ,isnull(a.LDG_INSTRUMENT_NO,'''') LDG_INSTRUMENT_NO   , b.ldg_account_id bank_id  ,isnull(a.LDG_ACCOUNT_NO,'''')  LDG_ACCOUNT_NO  , case when isnull(a.LDG_BANK_CL_DATE,'''')=''1900-01-01 00:00:00.000'' then null else isnull(convert(varchar(11),a.LDG_BANK_CL_DATE,103),'''') end  LDG_BANK_CL_DATE         
                      
  FROM   (SELECT ldg_account_id , LDG_VOUCHER_TYPE , CONVERT(VARCHAR(11),LDG_VOUCHER_DT,103) LDG_VOUCHER_DT,LDG_VOUCHER_NO,CONVERT(VARCHAR(11),LDG_BANK_CL_DATE,103) LDG_BANK_CL_DATE
  ,LDG_NARRATION , LDG_INSTRUMENT_NO,FINA_ACC_NAME, LDG_AMOUNT , FINA_ACC_CODE ACCTNO , LDG_VOUCHER_DT ord 
  FROM  LEDGER' + convert(varchar(20),@@fin_id)     +   ' b ,FIN_ACCOUNT_MSTR,DP_MSTR where    
  ldg_voucher_dt between CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                  
  AND CASE WHEN isnull('''+@pa_values+''','''') = '''' THEN ldg_voucher_dt ELSE convert(datetime,'''+@pa_values+''',103) END                   
AND LDG_ACCOUNT_ID=FINA_ACC_ID  
AND LDG_DPM_ID = DPM_ID  
AND DEFAULT_DP=DPM_EXCSM_ID 
and ldg_deleted_ind = 1 
AND FINA_ACC_TYPE=''B''
aND DPM_ID = ''' + convert(varchar,@pa_rmks  ) + '''
AND LDG_ACCOUNT_ID LIKE  CASE  WHEN LTRIM(RTRIM('''+@pa_bankid+''')) = '''' THEN ''%'' ELSE ''' + @pa_bankid + ''' END 
) b, ledger' + convert(varchar(20),@@fin_id)              + '                
    a ,CITRUS_USR.FN_gl_ACCT_LIST('''+@pa_rmks +''','''+ @pa_id+''',0)                  
  WHERE a.ldg_voucher_type = 8               
  AND dpam_id    = a.ldg_account_id  and b.ldg_voucher_no = a.ldg_voucher_no
and   b.LDG_VOUCHER_TYPE = a.LDG_VOUCHER_TYPE              
  AND a.ldg_account_type = acct_type and a.ldg_account_type =''P''
  AND a.LDG_INSTRUMENT_NO LIKE CASE  WHEN LTRIM(RTRIM('''+@pa_chqno+''')) = '''' THEN ''%'' ELSE '''+ @pa_chqno + ''' END                  
  AND a.ldg_ref_no LIKE CASE WHEN LTRIM(RTRIM('''+@pa_cd+''')) = '''' THEN ''%'' ELSE '''+ @pa_cd + ''' END                  
  AND a.ldg_voucher_dt between CASE WHEN isnull('''+@pa_desc+''','''') = '''' THEN a.ldg_voucher_dt ELSE convert(datetime,'''+@pa_desc+''',103) END                   
  AND CASE WHEN isnull('''+@pa_values+''','''') = '''' THEN a.ldg_voucher_dt ELSE convert(datetime,'''+@pa_values+''',103) END                   
  AND a.ldg_dpm_id LIKE CASE WHEN LTRIM(RTRIM('''+@pa_rmks+''')) = '''' THEN ''%'' ELSE '''+  @pa_rmks  + ''' END                 
  AND a.ldg_deleted_ind = 1   
  ORDER BY  a.ldg_id'  

  exec(@l_sql)  

 --                  
 END 
              
 END

GO
