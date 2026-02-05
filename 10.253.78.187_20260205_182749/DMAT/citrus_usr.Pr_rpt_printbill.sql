-- Object: PROCEDURE citrus_usr.Pr_rpt_printbill
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

---CDSL	3	Mar  1 2009	Mar 31 2009 23:59:59	N	N				N	Y	1	20	1	HO|*~|	rm413v3ekwm2ok55mfnab455	N	N	courier	HO	

--PR_RPT_PRINTBILL 'NSDL',4,'MAY 02 2008','AUG 31 2008 23:59:59','n','n','','','','N','y',1,20,1,'HO|*~|','u5bvdx45q5bavgrrz4m5uyyf','Y','Y','courier','HO',''	
--PR_RPT_PRINTBILL 'CDSL',3,'JAN 01 2009','JUN 26 2009 23:59:59','N','N','1234567890123456','1234567890123456','','N','Y',1,20,1,'HO|*~|','jqq5fw554brejy551z44pm45','N','N','','HO',''	

CREATE Proc [citrus_usr].[Pr_rpt_printbill]            
@pa_dptype varchar(4),                    
@pa_excsmid int,                    
@pa_fromdate datetime,                    
@pa_todate datetime,      
@pa_bulk_printflag char(1), --Y/N
@pa_stopbillclients_flag char(1), --Y/N               
@pa_fromaccid varchar(16),                    
@pa_toaccid varchar(16),
@pa_group_cd varchar(10),        
@pa_transclientsonly char(1),  
@pa_Hldg_Yn char(1),                  
@pa_currrecordctr int,
@pa_reqdrecordcnt int,                      
@pa_login_pr_entm_id numeric,                      
@pa_login_entm_cd_chain  varchar(8000),                      
@pa_sessionid varchar(50),
@pa_pagenoreqd char(1),
@pa_dispatch char(1),
@pa_dispatchmode varchar(10),
@pa_loginname varchar(50),                           
@pa_output varchar(8000) output                      
AS                    
BEGIN                    
            
-- set nocount on    
 set transaction isolation level read uncommitted         

declare @@dpmid int,
@@ssql varchar(8000),
@@temptable varchar(100),
@@l_child_entm_id numeric,
@@header_lines int,
@@footer_lines int,
@@Ledgerid int,
@@Billduedate varchar(11)

                 
 select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                                          
 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                      
 select @@Ledgerid =fin_id from Financial_Yr_Mstr where fin_dpm_id = @@dpmid and  (@pa_fromdate between fin_start_dt and fin_end_dt) and fin_deleted_ind = 1
 select @@Billduedate = CONVERT(VARCHAR(11),billc_due_date,109) from bill_cycle where billc_dpm_id = @@dpmid and billc_from_dt = CONVERT(VARCHAR(11),@pa_fromdate,109) and billc_to_dt = CONVERT(VARCHAR(11),@pa_todate,109)  

 

 IF @pa_fromaccid = ''                    
 BEGIN                    
  SET @pa_fromaccid = '0'                    
  SET @pa_toaccid = '99999999999999999'                    
 END                    
 IF @pa_toaccid = ''                    
 BEGIN                
   SET @pa_toaccid = @pa_fromaccid                    
 END                    
                  
 declare @@prevfromdate datetime             
 IF (@pa_dptype = 'CDSL')                    
 BEGIN              

  	  set @@temptable = '##cdslbill' + @pa_sessionid        
	  if @pa_currrecordctr = 1
	  begin     
     		if exists (select name from tempdb.dbo.sysobjects where name  =  @@temptable and type = 'u' )  
            	BEGIN  
			set @@ssql ='drop table ' + @@temptable
		  	exec(@@ssql)
			set @@ssql ='drop table ' + @@temptable + 'clients'
		  	exec(@@ssql)
			END


		  CREATE TABLE #ACLIST_CDSL(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
		  if @pa_stopbillclients_flag = 'Y'
		  begin
			INSERT INTO #ACLIST_CDSL SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) where dpam_stam_cd <> '02_BILLSTOP'		
		  end 
		  else
		  begin
			INSERT INTO #ACLIST_CDSL SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		
		  end 

		 if @pa_bulk_printflag = 'Y'
		 begin
				delete A from #ACLIST_CDSL A,blk_client_print_dtls 
				where dpam_id = blckpd_dpam_id and blkcpd_dpmid = @@dpmid
				and blkcpd_rptname = 'BILL' 
		 end
        
			select @@prevfromdate = max(dphmcd_holding_dt) from DP_DAILY_HLDG_CDSL with(nolock) where dphmcd_holding_dt <= convert(varchar(11),@pa_todate,109)
           
     

		
			set @@ssql='create table ' + @@temptable + '
			(        
			dpam_id bigint,          
			dpam_sba_name varchar(200),        
			dpam_acctno varchar(16),          
			trans_desc varchar(200),            
			dpm_trans_no varchar(10),            
			trans_date datetime,            
			isin_cd varchar(12),
			opening_bal numeric(19,3),        
			qty numeric(19,3),        
			order_by integer,
			line_no bigint,        
			charge_val numeric(19,2) , settm_id varchar(25),tr_settm_id varchar(25)       
			)'            
			exec(@@ssql)


		    	set @@ssql ='Create table '  + @@temptable + 'clients (
				id bigint identity(1,1),
				dpam_id bigint,
				dpam_acctno varchar(16),
				prev_bill_bal numeric(18,2),
				page_cnt int
				)'
				            
		    	exec(@@ssql)
		        
		        
			set @@ssql='insert into ' + @@temptable + '(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val,settm_id, tr_settm_id)         
			select distinct CDSHM_DPAM_ID,        
			DPAM_SBA_NAME,        
			CDSHM_BEN_ACCT_NO,                    
			CDSHM_TRATM_DESC=replace(CDSHM_TRATM_DESC,''        '',''''),
			CDSHM_TRANS_NO,                    
			CDSHM_TRAS_DT,                    
			CDSHM_ISIN,
			isnull(cdshm_opn_bal,0),          
			CDSHM_QTY,        
			1,
			CDSHM_ID,                  
			cdshm_charge , isnull(CDSHM_SETT_NO,''''), isnull(CDSHM_TRG_SETTM_NO ,'''')                  
			FROM CDSL_HOLDING_DTLS ,        
			#ACLIST_CDSL account                          
			where   CDSHM_DPM_ID = ' +  convert(varchar,@@dpmid) + '
			AND CDSHM_TRAS_DT >= ''' +  convert(varchar,@pa_fromdate,109) + ''' AND CDSHM_TRAS_DT <= ''' +  convert(varchar,@pa_todate,109) + '''
			and (cdshm_tratm_cd in(''2246'',''2277'') or isnull(cdshm_charge,0) <> 0)        
			and convert(numeric,CDSHM_BEN_ACCT_NO) between convert(numeric,''' + @pa_fromaccid + ''') and convert(numeric,''' + @pa_toaccid + ''')
			AND CDSHM_DPAM_ID = account.dpam_id            
			and (CDSHM_TRAS_DT between eff_from and eff_to)' 
			if @pa_group_cd <> ''
			begin
				set @@ssql = @@ssql + ' and exists(select g.dpam_id from account_group_mapping g where g.dpam_id = cdshm_dpam_id and group_cd = ''' + @pa_group_cd + ''')'
			end   
			exec(@@ssql)        

            if @pa_Hldg_Yn = 'Y'
            begin
			 if @pa_transclientsonly <> 'Y'  
			 begin        
				   set @@ssql='insert into ' + @@temptable + '(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val,settm_id , tr_settm_id )         
				   select DPHMCD_DPAM_ID,          
				   DPAM_SBA_NAME,        
				   DPAM_SBA_NO,                    
				   trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),        
				   TRANS_NO='''',
				   trans_date=''Dec 31 2100'',                    
				   DPHMCD_ISIN,                    
				   0, 
				   0,        
				   3,
				   0,      
				   0   , '''', right(isnull(dphmcd_cntr_settm_id ,''''),7)                    
				   FROM DP_DAILY_HLDG_CDSL,        
				   #ACLIST_CDSL account 
				   WHERE         
				   DPHMCD_HOLDING_DT = ''' +  convert(varchar(11),@@prevfromdate,109) + '''
				   and isnumeric(DPAM_SBA_NO) = 1                     
				   and convert(numeric,DPAM_SBA_NO) between convert(numeric,''' + @pa_fromaccid + ''') and convert(numeric,''' + @pa_toaccid + ''')
				   AND DPHMCD_dpam_id = account.dpam_id            
				   and (DPHMCD_HOLDING_DT between eff_from and eff_to)
				   and DPHMCD_dpm_id = ' +  convert(varchar,@@dpmid) + ' 
				   and isnull(DPHMCD_CURR_QTY,0) <> 0'
				   if @pa_group_cd <> ''
				   begin
				   set @@ssql = @@ssql + ' and exists(select g.dpam_id from account_group_mapping g where g.dpam_id = DPHMCD_dpam_id and group_cd = ''' + @pa_group_cd + ''')'
				   end             
			 end
			 else
			 begin
				   set @@ssql='insert into ' + @@temptable + '(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val,settm_id,tr_settm_id)         
				   select distinct DPHMCD_DPAM_ID,          
				   DPAM_SBA_NAME,        
				   DPAM_SBA_NO,                    
				   trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),        
				   TRANS_NO='''',
				   trans_date=''Dec 31 2100'',                    
				   DPHMCD_ISIN,                    
				   0,          
				   0,        
				   3,
				   0,      
				   0     , '''', right(isnull(dphmcd_cntr_settm_id ,''''),7)                     
				   FROM DP_DAILY_HLDG_CDSL,        
				   #ACLIST_CDSL account 
				   WHERE         
				   DPHMCD_HOLDING_DT = ''' +  convert(varchar(11),@@prevfromdate,109) + '''
		   	       and EXISTS(SELECT DPAM_ID FROM ' + @@temptable + ' T1 with(nolock) WHERE T1.DPAM_ID = DPHMCD_DPAM_ID)                          
				   and isnumeric(DPAM_SBA_NO) = 1                     
				   and convert(numeric,DPAM_SBA_NO) between convert(numeric,''' + @pa_fromaccid + ''') and convert(numeric,''' + @pa_toaccid + ''')
				   and DPHMCD_dpam_id = account.dpam_id            
				   and (DPHMCD_HOLDING_DT between eff_from and eff_to)
				   and DPHMCD_dpm_id = ' +  convert(varchar,@@dpmid) + ' 
				   and isnull(DPHMCD_CURR_QTY,0) <> 0'
				   if @pa_group_cd <> ''
				   begin
				   set @@ssql = @@ssql + ' and exists(select g.dpam_id from account_group_mapping g where g.dpam_id = DPHMCD_dpam_id and group_cd = ''' + @pa_group_cd + ''')'
				   end 
			 end

  	         exec(@@ssql)
          end 

		        
		  set @@ssql='insert into ' + @@temptable + '(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val)         
		  select clic_dpam_id,dpam_sba_name,dpam_sba_no,clic_charge_name,null,clic_trans_dt=''' +  convert(varchar,@pa_todate,109) + ''',null,null,null,2,null,sum(clic_charge_amt)         
		  from client_charges_cdsl,        
		  #ACLIST_CDSL account 
		  where         
		  clic_dpm_id = ' + convert(varchar,@@dpmid) + '
		  and clic_charge_name <> ''TRANSACTION CHARGES''
		  and clic_TRANS_DT >= ''' + convert(varchar,@pa_fromdate,109) + ''' AND clic_TRANS_DT <= ''' +  convert(varchar,@pa_todate,109) + '''
		  and isnumeric(dpam_sba_no) = 1                      
		  and convert(numeric,dpam_sba_no) between convert(numeric,''' + @pa_fromaccid + ''') and convert(numeric,''' + @pa_toaccid + ''')
		  and clic_dpam_id = account.dpam_id   
          and clic_deleted_ind=1                   
		  and (clic_TRANS_DT between eff_from and eff_to)'
		  if @pa_group_cd <> ''
		  begin
		  set @@ssql = @@ssql + ' and exists(select g.dpam_id from account_group_mapping g where g.dpam_id = clic_dpam_id and group_cd = ''' + @pa_group_cd + ''')'
		  end 
		  set @@ssql = @@ssql + ' group by clic_dpam_id,dpam_sba_name,dpam_sba_no,clic_charge_name'


		  exec(@@ssql)     

         IF @pa_transclientsonly <> 'Y'    
	     BEGIN

	     set @@ssql = 'insert into ' + @@temptable + '(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,charge_val) 
	     SELECT dpam_id , dpam_sba_name, dpam_sba_no , '''','''','''','''',0,0,4,0,0 FROM #ACLIST_CDSL a
	     WHERE NOT EXISTS(SELECT dpam_id FROM ' + @@temptable + ' b WHERE a.dpam_id = b.dpam_id)
         AND  eff_from BETWEEN CONVERT(datetime,''' +  CONVERT(varchar,@pa_fromdate,103)  + ''',103) AND  CONVERT(datetime,''' +  CONVERT(varchar,@pa_todate,103) + ''',103)
         and isnumeric(dpam_sba_no)  = 1 and convert(numeric,dpam_sba_no) between convert(numeric,''' + @pa_fromaccid + ''') and convert(numeric,''' + @pa_toaccid + ''')' 

         exec(@@ssql)

	     END 	


		set @@ssql ='insert into ' + @@temptable + 'clients
		select dpam_id,dpam_acctno,sum(case when ldg_voucher_type = 5 and ldg_voucher_dt >= ''' + convert(varchar(11),@pa_fromdate,109) + ''' then 0 else isnull(ldg_amount,0) * -1 end ) ,0
		from (
		select distinct dpam_id,dpam_acctno from ' + @@temptable + ' 
		) tmp left outer join Ledger' + convert(varchar,@@Ledgerid) + ' on dpam_id = ldg_account_id and ldg_account_type = ''P'' and ldg_voucher_dt <= ''' + convert(varchar(11),@pa_todate,109) + ''' and ldg_deleted_ind = 1 
		group by dpam_id,dpam_acctno order by dpam_acctno'
		exec(@@ssql)



		if @pa_pagenoreqd= 'Y'
		begin
		
		
			select @@header_lines =isnull(PAGE_HDR_MSG_SIZE,0)+ceiling(len(isnull(CITRUS_USR.FN_STRING_FOR_PRINT(page_footer_msg,75),''))/75.00)+ceiling(len(isnull(page_spl_msg,''))/75.00),@@footer_lines=isnull(PAGE_FTR_MSG_SIZE,0)
		    from report_message where report_name = 'BILL_CDSL'
			/*
			SELECT * FROM report_message
			insert into report_message(REPORT_NAME,PAGE_HDR_MSG_SIZE,PAGE_FTR_MSG_SIZE,PAGE_SPL_MSG,REPMSG_CREATED_BY,REPMSG_CREATED_DT,REPMSG_LST_UPD_BY,REPMSG_LST_UPD_DT,REPMSG_DELETED_IND)
			select REPORT_NAME='BILL_CDSL',PAGE_HDR_MSG_SIZE=17,PAGE_FTR_MSG_SIZE=3,PAGE_SPL_MSG='Depository accounts of those investors who have not provided their PAN details have been frozen (Suspended for Debit). The satus of your account is given above. I case the status is - Suspended for Debit, please provide your PAN details.',REPMSG_CREATED_BY='HO',REPMSG_CREATED_DT=getdate(),REPMSG_LST_UPD_BY='HO',REPMSG_LST_UPD_DT=getdate(),REPMSG_DELETED_IND=1
			--update tempclients set pagecnt = (headerlines + messagelines + count(isinwisebenctgrycnt) *2 +count(isin) + sum( getlines(transdesc,30)) + footerlines)/73
			*/
			set @@ssql='update c set page_cnt = ' + convert(varchar,@@header_lines) + ' + 5 + isnull((select sum(line_cnt) from (select dpam_id,line_cnt=4 from ' + @@temptable + ' d where d.dpam_id = c.dpam_id and order_by = 1 group by d.dpam_id,isin_cd) t where t.dpam_id = c.dpam_id),0)
			from ' + @@temptable + 'clients c'
			exec(@@ssql)

			set @@ssql='update c set page_cnt = isnull(page_cnt,0) + isnull((select sum(line_cnt) from (select dpam_id,line_cnt=4 from ' + @@temptable + ' d where d.dpam_id = c.dpam_id and order_by = 3 group by d.dpam_id,isin_cd) t where t.dpam_id = c.dpam_id),0)
			from ' + @@temptable + 'clients c'
			exec(@@ssql)

	
			set @@ssql='update c set page_cnt = isnull(page_cnt,0) + isnull((select sum(ceiling(len(trans_desc)/20.00)) from ' + @@temptable + ' d where d.dpam_id = c.dpam_id and order_by =1),0)
			from ' + @@temptable + 'clients c'
			exec(@@ssql)	

			set @@ssql='update c set page_cnt = isnull(page_cnt,0) + isnull((select count(order_by) from ' + @@temptable + ' d where d.dpam_id = c.dpam_id and order_by =2),0)
			from ' + @@temptable + 'clients c'
			exec(@@ssql)
	


			set @@ssql='update c set page_cnt = isnull(page_cnt,0) + 1
			from ' + @@temptable + 'clients c
			where exists( select t.dpam_id from ' + @@temptable + ' t where c.dpam_id = t.dpam_id  and order_by = 1)'
			exec(@@ssql)	


			set @@ssql='update c set page_cnt = isnull(page_cnt,0) + 1
			from ' + @@temptable + 'clients c
			where exists( select t.dpam_id from ' + @@temptable + ' t where c.dpam_id = t.dpam_id  and order_by = 2)'
			exec(@@ssql)	


			set @@ssql='update c set page_cnt = isnull(page_cnt,0) + 6
			from ' + @@temptable + 'clients c
			where exists( select t.dpam_id from ' + @@temptable + ' t where c.dpam_id = t.dpam_id  and order_by = 3)'
			exec(@@ssql)	

	
			set @@ssql='update ' + @@temptable + 'clients set page_cnt = ceiling((page_cnt/(64.00 - ' + convert(varchar,@@footer_lines) + ')))'
			exec(@@ssql)			
		end




		  set @@ssql='select order_by,t.dpam_id,dpam_sba_name,t.dpam_acctno,                    
		  CDSHM_TRATM_DESC=replace(isnull(ltrim(rtrim(trans_desc)),''''),dpm_trans_no,''''),            
		  dpm_trans_no,                    
		  trans_date=convert(varchar(11),trans_date,109),                    
		  t.ISIN_CD,        
		  isin_name=isnull(isin_name,''''),
		  opening_bal= replace(convert(varchar,isnull(opening_bal,0)),''.000'',''''),          
		  DEBIT_QTY= CASE WHEN  QTY <= 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,                    
		  CREDIT_QTY= CASE WHEN QTY > 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,        
		  closing_bal = replace(convert(varchar,(isnull(opening_bal,0) + isnull(QTY,0))),''.000'',''''),        
		  closing_qty = replace(convert(varchar,(isnull(opening_bal,0) + isnull(QTY,0))),''.000'',''''),        
		  charge_val=isnull(charge_val,0)  * -1,
		  prev_bill_bal=isnull(prev_bill_bal,0.00),
		  page_cnt,
		  bill_due_dt = ''' + @@Billduedate + ''',
		  trans_date, isnull(settm_id ,'''') settm_id , isnull(tr_settm_id,'''')  tr_settm_id
		  FROM ' + @@temptable + 'clients tc,' + @@temptable + ' t LEFT OUTER JOIN  isin_mstr i on t.isin_cd = i.isin_cd                   
		  where tc.dpam_id = t.dpam_id and tc.id > ' + convert(varchar,((@pa_currrecordctr-1) * @pa_reqdrecordcnt)) + ' and tc.id <=  ' + convert(varchar,(@pa_currrecordctr * @pa_reqdrecordcnt)) + '
		  order by t.dpam_acctno,dpam_sba_name,order_by,trans_date,Isin_name,18,line_no'


	end
	else
	begin		         
		  set @@ssql='select order_by,t.dpam_id,dpam_sba_name,t.dpam_acctno,                    
		  CDSHM_TRATM_DESC=replace(isnull(ltrim(rtrim(trans_desc)),''''),dpm_trans_no,''''),            
		  dpm_trans_no,                    
		  trans_date=convert(varchar(11),trans_date,109),                    
		  t.ISIN_CD,        
		  isin_name=isnull(isin_name,''''), 
		  opening_bal=replace(convert(varchar,isnull(opening_bal,0)),''.000'',''''),          
		  DEBIT_QTY= CASE WHEN  QTY <= 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,                    
		  CREDIT_QTY= CASE WHEN QTY > 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,        
		  closing_bal = replace(convert(varchar,(isnull(opening_bal,0) + isnull(QTY,0))),''.000'',''''),  
		  closing_qty = replace(convert(varchar,(isnull(opening_bal,0) + isnull(QTY,0))),''.000'',''''),       
		  charge_val=isnull(charge_val,0)  * -1,
		  prev_bill_bal=isnull(prev_bill_bal,0.00),
		  page_cnt,
		  bill_due_dt = ''' + @@Billduedate + ''',
		  trans_date
		  FROM ' + @@temptable + 'clients tc,' + @@temptable + ' t LEFT OUTER JOIN  isin_mstr i on t.isin_cd = i.isin_cd 
		  where tc.dpam_id = t.dpam_id and tc.id > ' + convert(varchar,((@pa_currrecordctr-1) * @pa_reqdrecordcnt)) + ' and tc.id <=  ' + convert(varchar,(@pa_currrecordctr * @pa_reqdrecordcnt)) + ' 
		  order by t.dpam_acctno,dpam_sba_name,order_by,trans_date,Isin_name,18,line_no'

	end
	
	exec(@@ssql)
	if @@rowcount = 0
	  begin

		if @pa_dispatch ='Y'
		begin
			set @@ssql ='insert into dispatch_report_cdsl(dpam_id,dispatch_mode,Report_name,Dispatch_dt,Cof_recv,Created_dt,created_by,lst_upd_dt,lst_upd_by,deleted_ind)
			select dpam_id,''' + @pa_dispatchmode + ''',''BILL_CDSL'',getdate(),0,getdate(),''' + @pa_loginname + ''',getdate(),''' + @pa_loginname + ''',1 from ' + @@temptable + 'clients'  
			exec(@@ssql)
		end
		set @@ssql ='drop table ' + @@temptable
	  	exec(@@ssql)
		set @@ssql ='drop table ' + @@temptable + 'clients'
	  	exec(@@ssql)
	  end


 END                    
 ELSE                    
 BEGIN              
            
  	  set @@temptable = '##nsdlbill' + @pa_sessionid        
	  if @pa_currrecordctr = 1
	  begin     



		if exists (select name from tempdb.dbo.sysobjects where name  =  @@temptable and type = 'u' )    
		BEGIN    
			set @@ssql ='drop table ' + @@temptable  
			exec(@@ssql)  
			set @@ssql ='drop table ' + @@temptable + 'clients'  
			exec(@@ssql)  
		END              

		  CREATE TABLE #ACLIST_NSDL(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
		  if @pa_stopbillclients_flag = 'Y'
		  begin
			INSERT INTO #ACLIST_NSDL SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) where dpam_stam_cd <> '02_BILLSTOP'		
		  end 
		  else
		  begin
			INSERT INTO #ACLIST_NSDL SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		
		  end 

		 if @pa_bulk_printflag = 'Y'
		 begin
				delete A from #ACLIST_NSDL A,blk_client_print_dtls 
				where dpam_id = blckpd_dpam_id and blkcpd_dpmid = @@dpmid
				and blkcpd_rptname = 'BILL'
		 end

		  select @@prevfromdate = max(dpdhmd_holding_dt) from DP_DAILY_HLDG_NSDL with(nolock) where dpdhmd_holding_dt < @pa_fromdate
		      
		        
		  create table #tmpnsdlbill            
		  (            
		  trans_date datetime,            
		  dpam_id bigint,            
		  dpam_acctno char(8),          
		  dpam_sba_name varchar(200),          
		  isin_cd varchar(12),
		  sett_type varchar(3),
		  sett_no varchar(10),              
		  dpm_trans_no bigint,            
		  Qty numeric(19,3),            
		  Book_Narr_cd varchar(3),            
		  Book_type varchar(3),      
		  Ben_ctgry varchar(2),      
		  Ben_acct_type varchar(2),            
		  trans_desc varchar(200),            
		  final_trans int,        
		  charge_val numeric(19,2),
		  line_no bigint            
		  )            
		               
		              
		if @pa_group_cd <> ''
		begin
			insert into #tmpnsdlbill           
			select distinct NSDHM_TRANSACTION_DT,NSDHM_dpam_id,NSDHM_BEN_ACCT_NO,dpam_sba_name,NSDHM_ISIN,nsdhm_sett_type,nsdhm_sett_no,nsdhm_dpm_trans_no,NSDHM_QTY,            
			NSDHM_BOOK_NAAR_CD,NSDHM_BOOK_TYPE,NSDHM_BEN_CTGRY,NSDHM_BEN_ACCT_TYPE,            
			TRANS_DESC= isnull(NSDHM_TRN_DESCP,'')    
			,0        
			,nsdhm_charge,NSDHM_LN_NO            
			from NSDL_HOLDING_DTLS ,
			account_group_mapping g,
			#ACLIST_NSDL account                    
			where         
			nsdhm_dpm_id = @@dpmid                    
			and NSDHM_TRANSACTION_DT >=@pa_fromdate AND NSDHM_TRANSACTION_DT <=@pa_todate                     
			and isnumeric(NSDHM_BEN_ACCT_NO) = 1                      
			and convert(numeric,NSDHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)
			and g.dpam_id = NSDHM_dpam_id
			and group_cd =  @pa_group_cd
			and NSDHM_dpam_id = account.dpam_id                      
			and (NSDHM_TRANSACTION_DT between eff_from and eff_to) 
		end
		else
		begin
			insert into #tmpnsdlbill           
			select distinct NSDHM_TRANSACTION_DT,NSDHM_dpam_id,NSDHM_BEN_ACCT_NO,dpam_sba_name,NSDHM_ISIN,nsdhm_sett_type,nsdhm_sett_no,nsdhm_dpm_trans_no,NSDHM_QTY,            
			NSDHM_BOOK_NAAR_CD,NSDHM_BOOK_TYPE,NSDHM_BEN_CTGRY,NSDHM_BEN_ACCT_TYPE,            
			TRANS_DESC= isnull(NSDHM_TRN_DESCP,'')    
			,0        
			,nsdhm_charge,NSDHM_LN_NO            
			from NSDL_HOLDING_DTLS ,                    
			#ACLIST_NSDL account                    
			where         
			nsdhm_dpm_id = @@dpmid                    
			and NSDHM_TRANSACTION_DT >=@pa_fromdate AND NSDHM_TRANSACTION_DT <=@pa_todate                     
			and isnumeric(NSDHM_BEN_ACCT_NO) = 1                      
			and convert(numeric,NSDHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                     
			and NSDHM_dpam_id = account.dpam_id                      
			and (NSDHM_TRANSACTION_DT between eff_from and eff_to) 
		end
		      
		              



	    --for non pool accounts 
	
		  delete from #tmpnsdlbill where Ben_acct_type not in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213','101')               
		    
		  update m set final_trans = 1,sett_type='',sett_no=''             
		  from #tmpnsdlbill m            
		  where Ben_acct_type not in('20','30','40') and convert(int,m.book_narr_cd) = isnull((select max(convert(int,book_narr_cd)) from #tmpnsdlbill m1 where m.dpm_trans_no = m1.dpm_trans_no and m.isin_cd = m1.isin_cd and m.dpam_id = m1.dpam_id and m.Ben_acct_type = m1.Ben_acct_type),0)            

			--added for demat & remat pending transactions 
			update #tmpnsdlbill set final_trans = 1,sett_type='',sett_no='' where Ben_acct_type in('12','13') 
			--added for demat & remat pending transactions

	    --for non pool accounts            
	
	     -- for pool accounts
		     delete from #tmpnsdlbill where Ben_acct_type in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213')
		
		     update #tmpnsdlbill set final_trans = 1 where  Ben_acct_type in('20','30','40') and  sett_type <> '00'
	     -- for pool accounts

		  if @pa_Hldg_Yn    ='Y'
          begin 
		             
			  if @pa_transclientsonly = 'Y'  
			  begin               
				   insert into #tmpnsdlbill            
				   select @@prevfromdate,dpdhmd_dpam_id,dpam_sba_no,dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,null,sum(dpdhmd_qty),null,null,dpdhmd_benf_cat,dpdhmd_benf_acct_typ,'*',3,0,null            
				   from fn_dailyholding(@@dpmid,@@prevfromdate,@pa_fromaccid,@pa_toaccid,'',@pa_group_cd,@pa_login_pr_entm_id,@@l_child_entm_id)          
				   where exists(select dpam_id from #tmpnsdlbill where dpam_id = dpdhmd_dpam_id)         
                   and       @@prevfromdate between eff_from and eff_to
				   group by dpdhmd_dpam_id,dpam_sba_no,dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,dpdhmd_benf_cat,dpdhmd_benf_acct_typ             
			  end  
			  else  
			  begin
				   insert into #tmpnsdlbill            
				   select @@prevfromdate,dpdhmd_dpam_id,h.dpam_sba_no,h.dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,null,sum(dpdhmd_qty),null,null,dpdhmd_benf_cat,dpdhmd_benf_acct_typ,'*',3,0,null           
				   from fn_dailyholding(@@dpmid,@@prevfromdate,@pa_fromaccid,@pa_toaccid,'',@pa_group_cd,@pa_login_pr_entm_id,@@l_child_entm_id) h, #ACLIST_NSDL a
				   where h.dpdhmd_dpam_id = a.dpam_id 
                   and       @@prevfromdate between eff_from and eff_to
				   group by dpdhmd_dpam_id,h.dpam_sba_no,h.dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,dpdhmd_benf_cat,dpdhmd_benf_acct_typ  
			  end  
          end   

		if @pa_group_cd <> ''
		begin
			insert into #tmpnsdlbill        
			select clic_trans_dt=@pa_todate,clic_dpam_id,dpam_sba_no,dpam_sba_name,null,null,null,null,null,null,null,null,null,clic_charge_name,2,sum(clic_charge_amt),null         
			from client_charges_nsdl
			, account_group_mapping g   
			, #ACLIST_NSDL account           
			where         
			clic_dpm_id = @@dpmid                    
			and clic_TRANS_DT >=@pa_fromdate AND clic_TRANS_DT <=@pa_todate                     
			and clic_charge_name <> 'TRANSACTION CHARGES'         
			and isnumeric(dpam_sba_no) = 1                      
			and convert(numeric,dpam_sba_no) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                     
			and clic_dpam_id = account.dpam_id                      
			and (clic_TRANS_DT between eff_from and eff_to)
			and g.dpam_id = clic_dpam_id
			and group_cd =  @pa_group_cd 
			group by clic_dpam_id,dpam_sba_no,dpam_sba_name,clic_charge_name
		end
		else
		begin
			insert into #tmpnsdlbill        
			select clic_trans_dt=@pa_todate,clic_dpam_id,dpam_sba_no,dpam_sba_name,null,null,null,null,null,null,null,null,null,clic_charge_name,2,sum(clic_charge_amt),null         
			from client_charges_nsdl        
			, #ACLIST_NSDL account           
			where         
			clic_dpm_id = @@dpmid                    
			and clic_TRANS_DT >=@pa_fromdate AND clic_TRANS_DT <=@pa_todate                     
			and clic_charge_name <> 'TRANSACTION CHARGES'         
			and isnumeric(dpam_sba_no) = 1                      
			and convert(numeric,dpam_sba_no) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)                     
			and clic_dpam_id = account.dpam_id                      
			and (clic_TRANS_DT between eff_from and eff_to)      
			group by clic_dpam_id,dpam_sba_no,dpam_sba_name,clic_charge_name
		end		         

     -- for pool accounts
	     delete from #tmpnsdlbill where Ben_acct_type in('20','30','40') and sett_type = '00'
     -- for pool accounts
     --for non pool accounts 
       update #tmpnsdlbill set sett_type='',sett_no='' where final_trans = 3 and Ben_acct_type not in('20','30','40')
     --for non pool accounts 

		    set @@ssql ='Create table '  + @@temptable + '(
				Runningid bigint identity(1,1),
				trans_date datetime,              
				dpam_id bigint,              
				dpam_acctno varchar(16),            
				dpam_sba_name varchar(200),            
				isin_cd varchar(12),
				sett_type varchar(3),
				sett_no varchar(10),              
				dpm_trans_no varchar(10),              
				Qty numeric(19,3),              
				Book_Narr_cd varchar(3),              
				Book_type varchar(3),         
				Ben_ctgry varchar(2),        
				Ben_acct_type varchar(2),             
				trans_desc varchar(200),              
				final_trans int,
				charge_val numeric(19,2),
				line_no bigint,
				closing_qty numeric(18,3)
				)
				CREATE INDEX IX_tmpbill on '  + @@temptable + '(dpam_id,Ben_ctgry,Ben_acct_type,isin_cd)'
				            
		    exec(@@ssql)      
		
		
		    set @@ssql ='Create table '  + @@temptable + 'clients (
				id bigint identity(1,1),
				dpam_id bigint,
				dpam_acctno varchar(16),
				prev_bill_bal numeric(18,2),
				page_cnt bigint,
				PRIMARY KEY (dpam_id)
				)'
				            
		    exec(@@ssql) 
		         
		  set @@ssql ='insert into ' + @@temptable + '            
		  select m.*,closing_qty=0.000 
		  from #tmpnsdlbill m where final_trans > 0            
		  order by dpam_id,isin_cd,Ben_ctgry,Ben_acct_type,sett_type,sett_no,trans_date,line_no,dpm_trans_no,Book_Narr_cd'            
		  exec(@@ssql) 
		
		  drop table #tmpnsdlbill	              
		              
		  set @@ssql ='update t             
		  set closing_qty = (select sum(isnull(qty,0)) from ' + @@temptable + ' t1 where t1.Runningid <= t.Runningid and t1.dpam_id =t.dpam_id and t1.Ben_ctgry = t.Ben_ctgry and t1.Ben_acct_type = t.Ben_acct_type and t1.isin_cd = t.isin_cd and t1.sett_type=t.sett_type and t1.sett_no = t.sett_no)        
		  from ' + @@temptable + ' t'
		  exec(@@ssql) 		                          
		         
		         
		  set @@ssql ='delete t from ' + @@temptable + ' t         
		  where exists(select dpam_id,isin_cd from ' + @@temptable + ' t1         
		  where t.dpam_id = t1.dpam_id and t1.Ben_ctgry = t.Ben_ctgry and t1.Ben_acct_type = t.Ben_acct_type and t.isin_cd = t1.isin_cd and t1.trans_desc <> ''*'')         
		  and t.trans_desc=''*'''        
		  exec(@@ssql) 		        


		set @@ssql ='insert into ' + @@temptable + 'clients
		select dpam_id,dpam_acctno,sum(case when ldg_voucher_type = 5 and ldg_voucher_dt >= ''' + convert(varchar(11),@pa_fromdate,109) + ''' then 0 else isnull(ldg_amount,0) * -1 end) ,0
		from (
		select distinct dpam_id,dpam_acctno from ' + @@temptable + ' 
		) tmp left outer join Ledger' + convert(varchar,@@Ledgerid) + ' on dpam_id = ldg_account_id and ldg_account_type = ''P'' and ldg_voucher_dt <= ''' + convert(varchar(11),@pa_todate,109) + ''' and ldg_deleted_ind = 1 
		group by dpam_id,dpam_acctno order by dpam_acctno'
		exec(@@ssql)




	if @pa_pagenoreqd= 'Y'
	begin
		--[fn_splitstrin_byspace_for_print]
		
		select @@header_lines =isnull(PAGE_HDR_MSG_SIZE,0)+ceiling(len(isnull(CITRUS_USR.FN_STRING_FOR_PRINT(page_footer_msg,75),''))/75.00)+ceiling(len(isnull(page_spl_msg,''))/75.00)
		,@@footer_lines=isnull(PAGE_FTR_MSG_SIZE,0) 
		from report_message where report_name = 'BILL_NSDL'


/*
		insert into report_message(REPORT_NAME,PAGE_HDR_MSG_SIZE,PAGE_FTR_MSG_SIZE,PAGE_SPL_MSG,REPMSG_CREATED_BY,REPMSG_CREATED_DT,REPMSG_LST_UPD_BY,REPMSG_LST_UPD_DT,REPMSG_DELETED_IND)
		select REPORT_NAME='BILL_NSDL',PAGE_HDR_MSG_SIZE=15,PAGE_FTR_MSG_SIZE=1,PAGE_SPL_MSG='Depository accounts of those investors who have not provided their PAN details have been frozen (Suspended for Debit). The satus of your account is given above. I case the status is - Suspended for Debit, please provide your PAN details.',REPMSG_CREATED_BY='HO',REPMSG_CREATED_DT=getdate(),REPMSG_LST_UPD_BY='HO',REPMSG_LST_UPD_DT=getdate(),REPMSG_DELETED_IND=1

		--select @@additional_lines = 15 + ceiling(len(isnull('',''))/70) + 1 

		--update tempclients set pagecnt = (headerlines + messagelines + count(isinwisebenctgrycnt) *2 +count(isin) + sum( getlines(transdesc,30)) + footerlines)/73
*/

		-- for adding opening & closing balances for each category for each isin		
		set @@ssql='update c set page_cnt = ' + convert(varchar,@@header_lines) + ' + 5 + isnull((select sum(line_cnt) from (select d.dpam_id,line_cnt=2 from ' + @@temptable + ' d where final_trans <> 2 and d.dpam_id = c.dpam_id group by d.dpam_id,Ben_ctgry,Ben_acct_type,isin_cd,sett_type,sett_no) t where t.dpam_id = c.dpam_id),0)
		from ' + @@temptable + 'clients c'
		exec(@@ssql)
		-- for adding opening & closing balances for each category for each isin		

		-- for adding isin line for each isin
		set @@ssql='update c set page_cnt = isnull(page_cnt,0) + isnull((select sum(line_cnt) from (select d.dpam_id,line_cnt=2 from ' + @@temptable + ' d where d.dpam_id = c.dpam_id and final_trans = 1 group by d.dpam_id,isin_cd) t where t.dpam_id = c.dpam_id),0)
		from ' + @@temptable + 'clients c'
		exec(@@ssql)	

		set @@ssql='update c set page_cnt = isnull(page_cnt,0) + isnull((select sum(line_cnt) from (select d.dpam_id,line_cnt=2 from ' + @@temptable + ' d where d.dpam_id = c.dpam_id and final_trans = 3 group by d.dpam_id,isin_cd) t where t.dpam_id = c.dpam_id),0)
		from ' + @@temptable + 'clients c'
		exec(@@ssql)	
		-- for adding isin line for each isin

		-- for adding description division lines for actual trans & charge descp.
		set @@ssql='update c set page_cnt = isnull(page_cnt,0) + isnull((select sum(ceiling(len(trans_desc)/20.00)) from ' + @@temptable + ' d where d.dpam_id = c.dpam_id and final_trans =1),0)
		from ' + @@temptable + 'clients c'
		exec(@@ssql)	
		-- for adding description division lines for actual trans & charge descp.


		-- for adding transaction charges line if any charge other than transaction charges are applied
		set @@ssql='update c set page_cnt = isnull(page_cnt,0) + 1
		from ' + @@temptable + 'clients c
		where exists( select t.dpam_id from ' + @@temptable + ' t where c.dpam_id = t.dpam_id and final_trans = 1)'
		exec(@@ssql)	
		-- for adding transaction charges line if any charge other than transaction charges are applied

		-- for adding total charges line if any charge other than transaction charges are applied
		set @@ssql='update c set page_cnt = isnull(page_cnt,0) + isnull((select count(final_trans) from ' + @@temptable + ' d where d.dpam_id = c.dpam_id and final_trans =2),0)
		from ' + @@temptable + 'clients c'
		exec(@@ssql)	

		set @@ssql='update c set page_cnt = isnull(page_cnt,0) + 1
		from ' + @@temptable + 'clients c
		where exists( select t.dpam_id from ' + @@temptable + ' t where c.dpam_id = t.dpam_id and final_trans = 2)'
		exec(@@ssql)	
		-- for adding total charges line if any charge other than transaction charges are applied

		-- for adding no transaction happened for holdings line
		set @@ssql='update c set page_cnt = isnull(page_cnt,0) + 2
		from ' + @@temptable + 'clients c
		where exists( select t.dpam_id from ' + @@temptable + ' t where c.dpam_id = t.dpam_id and final_trans = 3)'
		exec(@@ssql)	
		-- for adding no transaction happened for holdings line

		set @@ssql='update ' + @@temptable + 'clients set page_cnt = ceiling((page_cnt/(64.00 - ' + convert(varchar,@@footer_lines) + ')))'
		exec(@@ssql)	
		
				
	end



		        
		  set @@ssql ='select final_trans,t.dpam_id,dpam_sba_name,NSDHM_BEN_ACCT_NO=t.dpam_acctno,ben_type=ltrim(rtrim(isnull(ben.descp,Ben_acct_type) + '' '' + case when sett_type <> '''' then isnull(s.settm_desc,sett_type) + ''/'' + sett_no else '''' end)),dpm_trans_no=ISNULL(dpm_trans_no,''''),                    
		  TRANS_DESC=ltrim(rtrim(isnull(TRANS_DESC,''''))),            
		  NSDHM_TRANSACTION_DT=convert(varchar(11),trans_date,109),                    
		  NSDHM_ISIN=t.isin_cd,                    
		  Isin_name=isnull(Isin_name,t.isin_cd),             
		  open_qty = replace(convert(varchar,(CASE WHEN final_trans = 3 THEN closing_qty ELSE closing_qty - qty END)),''.000'',''''),                  
		  DEBIT_QTY= CASE WHEN QTY <= 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,                    
		  CREDIT_QTY= CASE WHEN QTY > 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,              
		  closing_qty= replace(convert(varchar,closing_qty),''.000'',''''),        
		  charge_val= isnull(charge_val,0) * -1 ,
		  prev_bill_bal=isnull(prev_bill_bal,0.00),
		  page_cnt,
		  bill_due_dt = ''' + @@Billduedate + ''',
		  trans_date        
		  from ' + @@temptable + 'clients tc,' + @@temptable + ' t left outer join isin_mstr i on t.isin_cd = i.isin_cd 
		  left outer join settlement_type_mstr s on t.sett_type = s.settm_type  and isnull(s.settm_type,'''') <> '''' and s.settm_deleted_ind = 1        
		  left outer join citrus_usr.FN_GETSUBTRANSDTLS(''BEN_ACCT_TYPE_NSDL'') ben on t.Ben_acct_type = ben.cd                  
		  where tc.dpam_id = t.dpam_id and tc.id > ' + convert(varchar,((@pa_currrecordctr-1) * @pa_reqdrecordcnt)) + ' and tc.id <=  ' + convert(varchar,(@pa_currrecordctr * @pa_reqdrecordcnt)) + '  		
		  order by t.dpam_acctno,final_trans,Isin_name,Runningid,19'

        end
	else
	begin
		  set @@ssql ='select final_trans,t.dpam_id,dpam_sba_name,NSDHM_BEN_ACCT_NO=t.dpam_acctno,ben_type=ltrim(rtrim(isnull(ben.descp,Ben_acct_type) + '' '' + case when sett_type <> '''' then isnull(s.settm_desc,sett_type) + ''/'' + sett_no else '''' end)),dpm_trans_no=ISNULL(dpm_trans_no,''''),                    
		  TRANS_DESC=ltrim(rtrim(isnull(TRANS_DESC,''''))),            
		  NSDHM_TRANSACTION_DT=convert(varchar(11),trans_date,109),                    
		  NSDHM_ISIN=t.isin_cd,                    
		  Isin_name=isnull(Isin_name,t.isin_cd),    
		  open_qty = replace(convert(varchar,(CASE WHEN final_trans = 3 THEN closing_qty ELSE closing_qty - qty END)),''.000'',''''),                  
		  DEBIT_QTY= CASE WHEN QTY <= 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,                    
		  CREDIT_QTY= CASE WHEN QTY > 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,              
		  closing_qty= replace(convert(varchar,closing_qty),''.000'',''''),        
		  charge_val= isnull(charge_val,0) * -1,
		  prev_bill_bal=isnull(prev_bill_bal,0.00),
		  page_cnt,
		  bill_due_dt = ''' + @@Billduedate + ''',
		  trans_date         
		  from ' + @@temptable + 'clients tc,' + @@temptable + ' t left outer join isin_mstr i on t.isin_cd = i.isin_cd
		  left outer join settlement_type_mstr s on t.sett_type = s.settm_type and isnull(s.settm_type,'''') <> '''' and s.settm_deleted_ind = 1 
		  left outer join citrus_usr.FN_GETSUBTRANSDTLS(''BEN_ACCT_TYPE_NSDL'') ben on t.Ben_acct_type = ben.cd                  
		  where tc.dpam_id = t.dpam_id and tc.id > ' + convert(varchar,((@pa_currrecordctr-1) * @pa_reqdrecordcnt)) + ' and tc.id <=  ' + convert(varchar,(@pa_currrecordctr * @pa_reqdrecordcnt)) + '  		
		  order by t.dpam_acctno,final_trans,Isin_name,Runningid,19'
		  

	end  
	exec(@@ssql)


	   if @@rowcount = 0  
	   begin  
		if @pa_dispatch ='Y'
		begin
			set @@ssql ='insert into dispatch_report_nsdl(dpam_id,dispatch_mode,Report_name,Dispatch_dt,Cof_recv,Created_dt,created_by,lst_upd_dt,lst_upd_by,deleted_ind)
			select dpam_id,''' + @pa_dispatchmode + ''',''BILL_NSDL'',getdate(),0,getdate(),''' + @pa_loginname + ''',getdate(),''' + @pa_loginname + ''',1 from ' + @@temptable + 'clients'  
			exec(@@ssql)
		end

	
		set @@ssql ='drop table ' + @@temptable  
		exec(@@ssql)  
		set @@ssql ='drop table ' + @@temptable + 'clients'  
		exec(@@ssql)  
	   end 
	            
            
            
                      
 END                    
                    
END

GO
