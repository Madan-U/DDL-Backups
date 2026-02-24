-- Object: PROCEDURE citrus_usr.Pr_rpt_printstatement
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*

EXEC  Pr_rpt_printstatement 'CDSL',3,'Apr 14 2009','Aug 14 2009','N','N','','','','','N','Y',1,10,1,'HO|*~|','zec5c0554wt10y45f0hdgf55','N','N','courier','HO','','','',''
 
*/

CREATE Proc [citrus_usr].[Pr_rpt_printstatement]              
@pa_dptype varchar(4),                      
@pa_excsmid int,                      
@pa_fromdate datetime,                      
@pa_todate datetime, 
@pa_bulk_printflag char(1), --Y/N
@pa_stopbillclients_flag char(1), --Y/N                          
@pa_fromaccid varchar(16),                      
@pa_toaccid varchar(16),                      
@pa_isincd varchar(12),
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
@pa_settm_type  varchar(80) ,    
@pa_settm_no_fr  varchar(80) ,                      
@pa_settm_no_to  varchar(80),   
@pa_output varchar(8000) output                        
AS                      
BEGIN                      
               
 set nocount on         
 set transaction isolation level read uncommitted             

if @PA_SETTM_NO_TO = ''
set @PA_SETTM_NO_TO   = @PA_SETTM_NO_FR   

 declare @@dpmid int,  
 @@l_child_entm_id numeric,  
 @@ssql varchar(8000),  
 @@temptable varchar(100),
 @@header_lines int,
 @@footer_lines int,
 @@prevfromdate datetime      

 set @pa_settm_type  = case when @pa_settm_type ='0' then  '' else  @pa_settm_type  end 

 SELECT @pa_settm_type = SETTM_TYPE FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) = @pa_settm_type             AND SETTM_DELETED_IND = 1

 set @pa_settm_type = case when @pa_settm_type ='0' then  '' else  @pa_settm_type  end 

            
            
 select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                      
                       
 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                        
                
 IF @pa_fromaccid = ''                      
 BEGIN                      
 SET @pa_fromaccid = '0'                      
 SET @pa_toaccid = '99999999999999999'                      
 END                      
 IF @pa_toaccid = ''                      
 BEGIN                  
 SET @pa_toaccid = @pa_fromaccid                      
 END                      
                    
              
 IF (@pa_dptype = 'CDSL')                      
 BEGIN                

	   set @@temptable = '##cdslstmt' + @pa_sessionid 	
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
				and blkcpd_rptname = 'TRANSACTION' 
		 end

	
		select @@prevfromdate = max(dphmcd_holding_dt) from DP_DAILY_HLDG_CDSL with(nolock) where dphmcd_holding_dt <= convert(varchar(11),@pa_todate,109)

	           
		   set @@ssql = 'create table ' + @@temptable + '
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
		   order_by int,
		   line_no bigint,
cdshm_trg_settm_no varchar(13),tratm_cd VARCHAR(20)    
	           )'              
	          
	          exec(@@ssql)


		    set @@ssql ='Create table '  + @@temptable + 'clients (
				id bigint identity(1,1),
				dpam_id bigint,
				dpam_acctno varchar(16),
				page_cnt int
				)'
				            
		    exec(@@ssql) 
	          

		   set @@ssql = 'insert into ' + @@temptable + '(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,cdshm_trg_settm_no,tratm_cd)           
		   select CDSHM_DPAM_ID,          
		   DPAM_SBA_NAME,          
		   CDSHM_BEN_ACCT_NO,                      
		   CDSHM_TRATM_DESC=replace(CDSHM_TRATM_DESC,''        '',''''),              
		   CDSHM_TRANS_NO,                      
		   CDSHM_TRAS_DT,                      
		   CDSHM_ISIN,
		   isnull(cdshm_opn_bal,0),            
		   CDSHM_QTY,          
		   0,
		   CDSHM_ID,
isnull(cdshm_trg_settm_no,''''),cdshm_tratm_cd 
		   FROM CDSL_HOLDING_DTLS ,          
		   #ACLIST_CDSL account                            
		   where   CDSHM_DPM_ID = ' + convert(varchar,@@dpmid) + '
		   AND CDSHM_TRAS_DT >= ''' + convert(varchar,@pa_fromdate,109) + ''' AND CDSHM_TRAS_DT <= ''' + convert(varchar,@pa_todate) + '''
		   and cdshm_tratm_cd in(''2246'',''2277'',''2280'',''2201'')                      
		   and convert(numeric,CDSHM_BEN_ACCT_NO) between convert(numeric,''' + @pa_fromaccid + ''') and convert(numeric,''' + @pa_toaccid + ''')                                               
		   AND cdshm_dpam_id = account.dpam_id              
		   and (CDSHM_TRAS_DT between eff_from and eff_to)          
		   and cdshm_isin like ''' + @pa_isincd + '%'''
		   if @pa_group_cd <> ''
		   begin
			set @@ssql = ' and exists(select g.dpam_id from account_group_mapping g where g.dpam_id = cdshm_dpam_id and group_cd = ''' + @pa_group_cd + ''')'
		   end   
        
	           exec(@@ssql)

set @@ssql ='delete from  ' + @@temptable 
set @@ssql = @@ssql  + ' where  tratm_cd not in (''2246'',''2277'',''2280'') 
and    trans_desc like ''%demat%''
and    exists 
(select CDSHM_BEN_ACCT_NO , CDSHM_TRANS_NO, CDSHM_ISIN, CDSHM_QTY 
from CDSL_HOLDING_DTLS where CDSHM_BEN_ACCT_NO = dpam_acctno
and CDSHM_TRANS_NO = dpm_trans_no and isin_cd =CDSHM_ISIN and qty =  CDSHM_QTY
and cdshm_tratm_cd in(''2246'',''2277'',''2280'') )'
PRINT @@ssql
exec(@@ssql)


	      if @pa_Hldg_Yn = 'Y'
          begin 
				   if @pa_transclientsonly <> 'Y'      
				   begin    

					set @@ssql = 'insert into ' + @@temptable + '(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,cdshm_trg_settm_no)   
					select DPHMCD_DPAM_ID,            
					DPAM_SBA_NAME,          
					DPAM_SBA_NO,                      
					trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),        
					TRANS_NO='''',                      
					trans_date=''Dec 31 2100'',                      
					DPHMCD_ISIN,
					0,            
					0,          
					1,
					0,
                   isnull(dphmcd_cntr_settm_id,'''')  
					FROM DP_DAILY_HLDG_CDSL,          
					#ACLIST_CDSL account                            
					WHERE           
					DPHMCD_HOLDING_DT = ''' + convert(varchar(11),@@prevfromdate,109) + '''         
					and DPHMCD_ISIN like ''' + @pa_isincd + '%''              
					and isnumeric(DPAM_SBA_NO) = 1                       
					and convert(numeric,DPAM_SBA_NO) between convert(numeric,'''+ @pa_fromaccid + ''') and convert(numeric,''' + @pa_toaccid + ''')                                               
					AND DPHMCD_dpam_id = account.dpam_id              
					and (DPHMCD_HOLDING_DT between eff_from and eff_to)
					and DPHMCD_dpm_id = ' + convert(varchar,@@dpmid) + ' 
					and isnull(DPHMCD_CURR_QTY,0) <> 0'
					if @pa_group_cd <> ''
					begin
					set @@ssql = ' and exists(select g.dpam_id from account_group_mapping g where g.dpam_id = DPHMCD_dpam_id and group_cd = ''' + @pa_group_cd + ''')'
					end             

					  END
				  ELSE
				  BEGIN
					set @@ssql = 'insert into ' + @@temptable + '(dpam_id,dpam_sba_name,dpam_acctno,trans_desc,dpm_trans_no,trans_date,isin_cd,opening_bal,qty,order_by,line_no,cdshm_trg_settm_no)   
					select DPHMCD_DPAM_ID,            
					DPAM_SBA_NAME,          
					DPAM_SBA_NO,                      
					trans_desc=Convert(varchar,ISNULL(DPHMCD_CURR_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_FREE_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_FREEZE_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_LOCKIN_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_AVAIL_LEND_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_PLEDGE_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_EARMARK_QTY,0.000)) + ''|'' + Convert(varchar,ISNULL(DPHMCD_BORROW_QTY,0.000)),        
					TRANS_NO='''',                      
					trans_date=''Dec 31 2100'',                      
					DPHMCD_ISIN,
					0,            
					0,          
					1,
					0        ,
isnull(dphmcd_cntr_settm_id,'''')             
					FROM DP_DAILY_HLDG_CDSL,          
					#ACLIST_CDSL account                            
					WHERE           
					DPHMCD_HOLDING_DT = ''' + convert(varchar(11),@@prevfromdate,109) + '''         
					and DPHMCD_ISIN like ''' + @pa_isincd + '%''              
					and EXISTS(SELECT DPAM_ID FROM ' + @@temptable + ' T WHERE T.DPAM_ID = DPHMCD_DPAM_ID)                      
					and isnumeric(DPAM_SBA_NO) = 1                       
					and convert(numeric,DPAM_SBA_NO) between convert(numeric,'''+ @pa_fromaccid + ''') and convert(numeric,''' + @pa_toaccid + ''')                                               
					AND DPHMCD_dpam_id = account.dpam_id              
					and (DPHMCD_HOLDING_DT between eff_from and eff_to)
					and DPHMCD_dpm_id = ' + convert(varchar,@@dpmid) + ' 
					and isnull(DPHMCD_CURR_QTY,0) <> 0'
		 
					if @pa_group_cd <> ''
					begin
					set @@ssql = ' and exists(select g.dpam_id from account_group_mapping g where g.dpam_id = DPHMCD_dpam_id and group_cd = ''' + @pa_group_cd + ''')'
					end             

				  END   
					exec(@@ssql)   
            end
   
		    set @@ssql ='insert into ' + @@temptable + 'clients select dpam_id,dpam_acctno, 0 from  ' + @@temptable + '  group by dpam_id,dpam_acctno order by dpam_acctno'   
		    exec(@@ssql)  
		   

		if @pa_pagenoreqd= 'Y'
		begin
		
		
			select @@header_lines =isnull(PAGE_HDR_MSG_SIZE,0)+ceiling(len(isnull(CITRUS_USR.FN_STRING_FOR_PRINT(page_footer_msg,75),''))/75.00)+ceiling(len(isnull(page_spl_msg,''))/75.00),@@footer_lines=isnull(PAGE_FTR_MSG_SIZE,0)
			from report_message where report_name = 'STMT_CDSL'
		
			
			/*
			insert into report_message(REPORT_NAME,PAGE_HDR_MSG_SIZE,PAGE_FTR_MSG_SIZE,PAGE_SPL_MSG,REPMSG_CREATED_BY,REPMSG_CREATED_DT,REPMSG_LST_UPD_BY,REPMSG_LST_UPD_DT,REPMSG_DELETED_IND)
			select REPORT_NAME='STMT_CDSL',PAGE_HDR_MSG_SIZE=15,PAGE_FTR_MSG_SIZE=1,PAGE_SPL_MSG='Depository accounts of those investors who have not provided their PAN details have been frozen (Suspended for Debit). The satus of your account is given above. I case the status is - Suspended for Debit, please provide your PAN details.',REPMSG_CREATED_BY='HO',REPMSG_CREATED_DT=getdate(),REPMSG_LST_UPD_BY='HO',REPMSG_LST_UPD_DT=getdate(),REPMSG_DELETED_IND=1
			--update tempclients set pagecnt = (headerlines + messagelines + count(isinwisebenctgrycnt) *2 +count(isin) + sum( getlines(transdesc,30)) + footerlines)/73
			*/
	
	
			set @@ssql='update c set page_cnt = ' + convert(varchar,@@header_lines) + ' + isnull((select sum(line_cnt) from (select dpam_id,line_cnt=4 from ' + @@temptable + ' d where d.dpam_id = c.dpam_id and order_by = 0 group by d.dpam_id,isin_cd) t where t.dpam_id = c.dpam_id),0)
			from ' + @@temptable + 'clients c'
			exec(@@ssql)

			set @@ssql='update c set page_cnt = isnull(page_cnt,0) + isnull((select sum(line_cnt) from (select dpam_id,line_cnt=4 from ' + @@temptable + ' d where d.dpam_id = c.dpam_id and order_by = 1 group by d.dpam_id,isin_cd) t where t.dpam_id = c.dpam_id),0)
			from ' + @@temptable + 'clients c'
			exec(@@ssql)

	
			set @@ssql='update c set page_cnt = isnull(page_cnt,0) + isnull((select sum(ceiling(len(trans_desc)/20.00)) from ' + @@temptable + ' d where d.dpam_id = c.dpam_id and order_by = 0 ),0)
			from ' + @@temptable + 'clients c'
			exec(@@ssql)	
	
	
			set @@ssql='update c set page_cnt = isnull(page_cnt,0) + 6
			from ' + @@temptable + 'clients c
			where exists( select t.dpam_id from ' + @@temptable + ' t where c.dpam_id = t.dpam_id  and order_by = 1)'
			exec(@@ssql)	


			set @@ssql='update ' + @@temptable + 'clients set page_cnt = ceiling((page_cnt/(64.00 - ' + convert(varchar,@@footer_lines) + ')))'
			exec(@@ssql)			

				
		end
		


		   set @@ssql ='select order_by,t.dpam_id,dpam_sba_name,t.dpam_acctno,                      
		   CDSHM_TRATM_DESC=replace(lower(ltrim(rtrim(ISNULL(trans_desc,'''')))),dpm_trans_no,''''),              
		   dpm_trans_no,                      
		   trans_date=convert(varchar(11),trans_date,109),                      
		   t.ISIN_CD,
		   isin_name=isnull(isin_name,''''),                      
		   opening_bal=replace(convert(varchar,isnull(opening_bal,0)),''.000'',''''),            
		   DEBIT_QTY= CASE WHEN  QTY <= 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,                      
		   CREDIT_QTY= CASE WHEN QTY > 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,          
		   closing_bal = replace(convert(varchar,(isnull(opening_bal,0) + isnull(QTY,0))),''.000'',''''),
		   tc.page_cnt,
           trans_date ,cdshm_trg_settm_no                    
		   FROM ' + @@temptable + 'clients tc,' + @@temptable + ' t LEFT OUTER JOIN  isin_mstr i on t.isin_cd = i.isin_cd 
		   where tc.dpam_id = t.dpam_id and tc.id > ' + convert(varchar,((@pa_currrecordctr-1) * @pa_reqdrecordcnt)) + ' and tc.id <=  ' + convert(varchar,(@pa_currrecordctr * @pa_reqdrecordcnt)) + '                      
		   order by t.dpam_acctno,dpam_sba_name,order_by,Isin_name,15,line_no'
	end
	else
	begin
		   set @@ssql ='select order_by,t.dpam_id,dpam_sba_name,t.dpam_acctno,                      
		   CDSHM_TRATM_DESC=replace(lower(ltrim(rtrim(ISNULL(trans_desc,'''')))),dpm_trans_no,''''),              
		   dpm_trans_no,                      
		   trans_date=convert(varchar(11),trans_date,109),                      
		   t.ISIN_CD,
		   isin_name=isnull(isin_name,''''),                      
		   opening_bal=replace(convert(varchar,isnull(opening_bal,0)),''.000'',''''),            
		   DEBIT_QTY= CASE WHEN  QTY <= 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,                      
		   CREDIT_QTY= CASE WHEN QTY > 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,          
		   closing_bal = replace(convert(varchar,(isnull(opening_bal,0) + isnull(QTY,0))),''.000'',''''),
		   tc.page_cnt,
		   trans_date                                 
		   FROM ' + @@temptable + 'clients tc,' + @@temptable + ' t LEFT OUTER JOIN  isin_mstr i on t.isin_cd = i.isin_cd 
		   where tc.dpam_id = t.dpam_id and tc.id > ' + convert(varchar,((@pa_currrecordctr-1) * @pa_reqdrecordcnt)) + ' and tc.id <=  ' + convert(varchar,(@pa_currrecordctr * @pa_reqdrecordcnt)) + '
		   order by t.dpam_acctno,dpam_sba_name,order_by,Isin_name,15,line_no'
	end  
print @@ssql
		Exec(@@ssql)


	   if @@rowcount = 0  
	   begin  
		if @pa_dispatch ='Y'
		begin
			set @@ssql ='insert into dispatch_report_cdsl(dpam_id,dispatch_mode,Report_name,Dispatch_dt,Cof_recv,Created_dt,created_by,lst_upd_dt,lst_upd_by,deleted_ind)
			select dpam_id,''' + @pa_dispatchmode + ''',''STMT_CDSL'',getdate(),0,getdate(),''' + @pa_loginname + ',getdate(),''' + @pa_loginname + ',1 from ' + @@temptable + 'clients'  
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
              
   set @@temptable = '##nsdlstmt' + @pa_sessionid     
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
				and blkcpd_rptname = 'TRANSACTION'
		 end

	select @@prevfromdate = max(dpdhmd_holding_dt) from DP_DAILY_HLDG_NSDL with(nolock) where dpdhmd_holding_dt < @pa_fromdate

    create table #tempmainnsdl              
    (              
    trans_date datetime,              
    dpam_id bigint,              
    dpam_acctno varchar(16),            
    dpam_sba_name varchar(200),            
    isin_cd varchar(12),
    sett_type varchar(3),
    sett_no varchar(10),              
    dpm_trans_no BIGINT,              
    Qty numeric(19,3),              
    Book_Narr_cd varchar(3),              
    Book_type varchar(3),         
    Ben_ctgry varchar(2),        
    Ben_acct_type varchar(2),             
    trans_desc varchar(200),              
    final_trans int,
    line_no bigint , CMBP_ID   varchar(100)
    )              
           
    

	if @pa_group_cd <> ''
	begin
	    insert into #tempmainnsdl             
	    select NSDHM_TRANSACTION_DT,NSDHM_dpam_id,NSDHM_BEN_ACCT_NO,dpam_sba_name,NSDHM_ISIN,nsdhm_sett_type,nsdhm_sett_no,nsdhm_dpm_trans_no,NSDHM_QTY,              
	    NSDHM_BOOK_NAAR_CD,NSDHM_BOOK_TYPE,NSDHM_BEN_CTGRY,NSDHM_BEN_ACCT_TYPE,          
	    TRANS_DESC=ltrim(rtrim(isnull(NSDHM_TRN_DESCP,'')))      
	    ,0,NSDHM_LN_NO   ,  NSDHM_COUNTER_CMBP_ID                      
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
        AND CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE ISNULL(nsdhm_sett_type,'') END = CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE @PA_SETTM_TYPE END
        AND CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE ISNULL(nsdhm_sett_no,'') END BETWEEN CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_FR END and CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_To END	
                  
	    and (NSDHM_TRANSACTION_DT between eff_from and eff_to)
	    and NSDHM_ISIN like @pa_isincd + '%'             
	end
	else
	begin
	    insert into #tempmainnsdl             
	    select NSDHM_TRANSACTION_DT,NSDHM_dpam_id,NSDHM_BEN_ACCT_NO,dpam_sba_name,NSDHM_ISIN,nsdhm_sett_type,nsdhm_sett_no,nsdhm_dpm_trans_no,NSDHM_QTY,              
	    NSDHM_BOOK_NAAR_CD,NSDHM_BOOK_TYPE,NSDHM_BEN_CTGRY,NSDHM_BEN_ACCT_TYPE,          
	    TRANS_DESC=ltrim(rtrim(isnull(NSDHM_TRN_DESCP,'')))      
	    ,0,NSDHM_LN_NO         ,  NSDHM_COUNTER_CMBP_ID                
	    from NSDL_HOLDING_DTLS ,
	    #ACLIST_NSDL account
	    where           
	    nsdhm_dpm_id = @@dpmid                      
	    and NSDHM_TRANSACTION_DT >=@pa_fromdate AND NSDHM_TRANSACTION_DT <=@pa_todate                       
	    and isnumeric(NSDHM_BEN_ACCT_NO) = 1                        
	    and convert(numeric,NSDHM_BEN_ACCT_NO) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)
	    and NSDHM_dpam_id = account.dpam_id       
		AND CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE ISNULL(nsdhm_sett_type,'') END = CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE @PA_SETTM_TYPE END
AND CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE ISNULL(nsdhm_sett_no,'') END BETWEEN CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_FR END and CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_To END	
                        
	    and (NSDHM_TRANSACTION_DT between eff_from and eff_to)
	    and NSDHM_ISIN like @pa_isincd + '%'             
	end	                
                 
                
                
    --for non pool accounts 

	    delete from #tempmainnsdl where Ben_acct_type not in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213','101')               
	    
        update m set final_trans = 1,sett_type='',sett_no=''              
	    from #tempmainnsdl m              
	    where Ben_acct_type not in('20','30','40') and convert(int,m.book_narr_cd) = isnull((select max(convert(int,book_narr_cd)) from #tempmainnsdl m1 where m.dpm_trans_no = m1.dpm_trans_no and m.isin_cd = m1.isin_cd and m.dpam_id = m1.dpam_id and m.Ben_acct_type = m1.Ben_acct_type),0)           

			--added for demat & remat pending transactions 
			update #tempmainnsdl set final_trans = 1,sett_type='',sett_no='' where Ben_acct_type in('12','13') 
			--added for demat & remat pending transactions


    --for non pool accounts            

     -- for pool accounts
	     delete from #tempmainnsdl where Ben_acct_type in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213')
	
	     update #tempmainnsdl set final_trans = 1 where  Ben_acct_type in('20','30','40') and  sett_type <> '00'
     -- for pool accounts


   
        
        
    if @pa_Hldg_Yn = 'Y'
    begin    

		if @pa_transclientsonly = 'Y'      
		BEGIN      
			insert into #tempmainnsdl              
			select @@prevfromdate,dpdhmd_dpam_id,dpam_sba_no,dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,null,sum(dpdhmd_qty),null,null,dpdhmd_benf_cat,dpdhmd_benf_acct_typ,'*',2,NULL             ,''
			from fn_dailyholding(@@dpmid,@@prevfromdate,@pa_fromaccid,@pa_toaccid,@pa_isincd,@pa_group_cd,@pa_login_pr_entm_id,@@l_child_entm_id) 
			where exists(select dpam_id from #tempmainnsdl where dpam_id = dpdhmd_dpam_id)             
            AND CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE ISNULL(dpdhmd_sett_type,'') END = CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE @PA_SETTM_TYPE END
            AND CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE ISNULL(dpdhmd_sett_no,'') END BETWEEN CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_FR END and CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_To END	
        
			group by dpdhmd_dpam_id,dpam_sba_no,dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,dpdhmd_benf_cat,dpdhmd_benf_acct_typ
		END      
		ELSE      
		BEGIN      
			insert into #tempmainnsdl              
			select @@prevfromdate,dpdhmd_dpam_id,h.dpam_sba_no,h.dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,null,sum(dpdhmd_qty),null,null,dpdhmd_benf_cat,dpdhmd_benf_acct_typ,'*',2,NULL,''
			from fn_dailyholding(@@dpmid,@@prevfromdate,@pa_fromaccid,@pa_toaccid,@pa_isincd,@pa_group_cd,@pa_login_pr_entm_id,@@l_child_entm_id) h , #ACLIST_NSDL a
			where h.dpdhmd_dpam_id = a.dpam_id
            AND     @@prevfromdate BETWEEN EFF_FROM AND EFF_TO                       
            AND CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE ISNULL(dpdhmd_sett_type,'') END = CASE WHEN ISNULL(@PA_SETTM_TYPE,'')='' THEN '0' ELSE @PA_SETTM_TYPE END
            AND CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE ISNULL(DPDHMD_SETT_NO,'') END BETWEEN CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_FR END and CASE WHEN ISNULL(@PA_SETTM_NO_FR,'')='' THEN '0' ELSE @PA_SETTM_NO_To END	
       
			group by dpdhmd_dpam_id,h.dpam_sba_no,h.dpam_sba_name,dpdhmd_isin,dpdhmd_sett_type,dpdhmd_sett_no,dpdhmd_benf_cat,dpdhmd_benf_acct_typ
		END  
     end       
            

     -- for pool accounts
	     delete from #tempmainnsdl where Ben_acct_type in('20','30','40') and sett_type = '00'
     -- for pool accounts
   --for non pool accounts 
       update #tempmainnsdl set sett_type='',sett_no='' where final_trans = 2 and Ben_acct_type not in('20','30','40')
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
		line_no bigint,   CMBP_ID   varchar(100)  ,
		closing_qty numeric(18,3)
		)
		CREATE INDEX IX_tmpstmt on '  + @@temptable + '(dpam_id,Ben_ctgry,Ben_acct_type,isin_cd)'
		            
    exec(@@ssql)      
   

    set @@ssql ='Create table '  + @@temptable + 'clients (
		id bigint identity(1,1),
		dpam_id bigint,
		dpam_acctno char(8),
		page_cnt bigint,
		PRIMARY KEY (dpam_id)
		)'
		            
    exec(@@ssql)            
         
           
    set @@ssql ='insert into ' + @@temptable + '  
    select m.*,closing_qty=0.000              
    from #tempmainnsdl m where final_trans > 0              
    order by dpam_id,isin_cd,Ben_ctgry,Ben_acct_type,sett_type,sett_no,trans_date,line_no,dpm_trans_no,Book_Narr_cd'              
    exec(@@ssql)  

    drop table #tempmainnsdl
           
    set @@ssql ='update t               
    set closing_qty = (select sum(isnull(qty,0)) from ' + @@temptable + ' t1 where t1.Runningid <= t.Runningid and t1.dpam_id =t.dpam_id and t1.Ben_ctgry = t.Ben_ctgry and t1.Ben_acct_type = t.Ben_acct_type and t1.isin_cd = t.isin_cd and t1.sett_type=t.sett_type and t1.sett_no = t.sett_no)          
    from ' + @@temptable + ' t'  
    exec(@@ssql)            
          
          
    set @@ssql ='delete t from ' + @@temptable + '  t           
    where exists(select dpam_id,isin_cd from ' + @@temptable + ' t1           
    where t.dpam_id = t1.dpam_id and t1.Ben_ctgry = t.Ben_ctgry and t1.Ben_acct_type = t.Ben_acct_type and t.isin_cd = t1.isin_cd and t1.trans_desc <> ''*'')           
    and t.trans_desc=''*'''  
    exec(@@ssql)          
           
  
  
    set @@ssql ='insert into ' + @@temptable + 'clients select dpam_id,dpam_acctno, 0 from  ' + @@temptable + '  group by dpam_id,dpam_acctno order by dpam_acctno'   
    exec(@@ssql)  


	if @pa_pagenoreqd= 'Y'
	begin
		--[fn_splitstrin_byspace_for_print]
		
		select @@header_lines =isnull(PAGE_HDR_MSG_SIZE,0)+ceiling(len(isnull(CITRUS_USR.FN_STRING_FOR_PRINT(page_footer_msg,75),''))/75.00)+ceiling(len(isnull(page_spl_msg,''))/75.00)
		,@@footer_lines=isnull(PAGE_FTR_MSG_SIZE,0) 
		from report_message where report_name = 'STMT_NSDL'
/*
		insert into report_message(REPORT_NAME,PAGE_HDR_MSG_SIZE,PAGE_FTR_MSG_SIZE,PAGE_SPL_MSG,REPMSG_CREATED_BY,REPMSG_CREATED_DT,REPMSG_LST_UPD_BY,REPMSG_LST_UPD_DT,REPMSG_DELETED_IND)
		select REPORT_NAME='STMT_CDSL',PAGE_HDR_MSG_SIZE=15,PAGE_FTR_MSG_SIZE=1,PAGE_SPL_MSG='Depository accounts of those investors who have not provided their PAN details have been frozen (Suspended for Debit). The satus of your account is given above. I case the status is - Suspended for Debit, please provide your PAN details.',REPMSG_CREATED_BY='HO',REPMSG_CREATED_DT=getdate(),REPMSG_LST_UPD_BY='HO',REPMSG_LST_UPD_DT=getdate(),REPMSG_DELETED_IND=1

		--select @@additional_lines = 15 + ceiling(len(isnull('',''))/70) + 1 

		--update tempclients set pagecnt = (headerlines + messagelines + count(isinwisebenctgrycnt) *2 +count(isin) + sum( getlines(transdesc,30)) + footerlines)/73
*/
		
		set @@ssql='update c set page_cnt = ' + convert(varchar,@@header_lines) + ' + isnull((select sum(line_cnt) from (select dpam_id,line_cnt=2 from ' + @@temptable + ' d where d.dpam_id = c.dpam_id group by d.dpam_id,Ben_ctgry,Ben_acct_type,isin_cd,sett_type,sett_no) t where t.dpam_id = c.dpam_id),0)
		from ' + @@temptable + 'clients c'
		exec(@@ssql)
		


		set @@ssql='update c set page_cnt = isnull(page_cnt,0) + isnull((select sum(line_cnt) from (select d.dpam_id,line_cnt=2 from ' + @@temptable + ' d where d.dpam_id = c.dpam_id and final_trans = 1 group by d.dpam_id,isin_cd) t where t.dpam_id = c.dpam_id),0)
		from ' + @@temptable + 'clients c'
		exec(@@ssql)				

		set @@ssql='update c set page_cnt = isnull(page_cnt,0) + isnull((select sum(line_cnt) from (select d.dpam_id,line_cnt=2 from ' + @@temptable + ' d where d.dpam_id = c.dpam_id and final_trans = 2 group by d.dpam_id,isin_cd) t where t.dpam_id = c.dpam_id),0)
		from ' + @@temptable + 'clients c'
		exec(@@ssql)				


		set @@ssql='update c set page_cnt = isnull(page_cnt,0) + isnull((select sum(ceiling((len(trans_desc)/20.00))) from ' + @@temptable + ' d where d.dpam_id = c.dpam_id and final_trans = 1),0)
		from ' + @@temptable + 'clients c'
		exec(@@ssql)	


		set @@ssql='update c set page_cnt = isnull(page_cnt,0) + 2
		from ' + @@temptable + 'clients c
		where exists( select t.dpam_id from ' + @@temptable + ' t where c.dpam_id = t.dpam_id and final_trans = 2)'
		exec(@@ssql)	



		set @@ssql='update ' + @@temptable + 'clients set page_cnt = ceiling((page_cnt/(64.00 - ' + convert(varchar,@@footer_lines) + ')))'
		exec(@@ssql)		
			
	


	end




  
    set @@ssql ='select final_trans,t.dpam_id,dpam_sba_name,NSDHM_BEN_ACCT_NO=t.dpam_acctno,ben_type=ltrim(rtrim(isnull(ben.descp,Ben_acct_type) + '' '' + case when sett_type <> '''' then isnull(s.settm_desc,sett_type) + ''/'' + sett_no else '''' end + case when isnull(CMBP_ID,'''') <> '''' then ''/''+ CMBP_ID else '''' end)) ,dpm_trans_no=ISNULL(dpm_trans_no,''''),                      
    TRANS_DESC=ltrim(rtrim(isnull(TRANS_DESC,''''))),              
    NSDHM_TRANSACTION_DT=convert(varchar(11),trans_date,109),                      
    NSDHM_ISIN=t.isin_cd,                      
    Isin_name=isnull(Isin_name,t.isin_cd),               
    open_qty = replace(convert(varchar,(CASE WHEN FINAL_TRANS = 2 THEN closing_qty ELSE closing_qty - qty END)),''.000'',''''),                    
    DEBIT_QTY= CASE WHEN QTY <= 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,                      
    CREDIT_QTY= CASE WHEN QTY > 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,                
    closing_qty=replace(convert(varchar,closing_qty),''.000'',''''),tc.page_cnt,trans_date              
    from 
    ' + @@temptable + 'clients tc,
    ' + @@temptable + ' t left outer join isin_mstr i on t.isin_cd = i.isin_cd
    left outer join settlement_type_mstr s on t.sett_type = s.settm_type and isnull(s.settm_type,'''') <> '''' and s.settm_deleted_ind = 1,         
    citrus_usr.FN_GETSUBTRANSDTLS(''BEN_ACCT_TYPE_NSDL'') ben                      
    WHERE  t.Ben_acct_type = ben.cd   
    and tc.dpam_id = t.dpam_id and tc.id > ' + convert(varchar,((@pa_currrecordctr-1) * @pa_reqdrecordcnt)) + ' and tc.id <=  ' + convert(varchar,(@pa_currrecordctr * @pa_reqdrecordcnt)) + '  
    order by t.dpam_acctno,final_trans,Isin_name,Runningid,16'  
  
   end  
   else  
   begin  
    set @@ssql ='select final_trans,t.dpam_id,dpam_sba_name,NSDHM_BEN_ACCT_NO=t.dpam_acctno,ben_type=ltrim(rtrim(isnull(ben.descp,Ben_acct_type) + '' '' + case when sett_type <> '''' then isnull(s.settm_desc,sett_type) + ''/'' + sett_no else '''' end)) ,dpm_trans_no=ISNULL(dpm_trans_no,''''),                      
    TRANS_DESC=ltrim(rtrim(isnull(TRANS_DESC,''''))),              
    NSDHM_TRANSACTION_DT=convert(varchar(11),trans_date,109),                      
    NSDHM_ISIN=t.isin_cd,                      
    Isin_name=isnull(Isin_name,t.isin_cd),               
    open_qty = replace(convert(varchar,(CASE WHEN FINAL_TRANS = 2 THEN closing_qty ELSE closing_qty - qty END)),''.000'',''''),                    
    DEBIT_QTY= CASE WHEN QTY <= 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,                      
    CREDIT_QTY= CASE WHEN QTY > 0 THEN replace(convert(varchar,ABS(QTY)),''.000'','''') ELSE '''' END,                
    closing_qty=replace(convert(varchar,closing_qty),''.000'',''''),tc.page_cnt,trans_date              
    from 
    ' + @@temptable + 'clients tc,
    ' + @@temptable + ' t left outer join isin_mstr i on t.isin_cd = i.isin_cd
    left outer join settlement_type_mstr s on t.sett_type = s.settm_type and isnull(s.settm_type,'''') <> '''' and s.settm_deleted_ind = 1 ,         
    citrus_usr.FN_GETSUBTRANSDTLS(''BEN_ACCT_TYPE_NSDL'') ben                      
    WHERE t.Ben_acct_type = ben.cd   
    and tc.dpam_id = t.dpam_id and tc.id > ' + convert(varchar,((@pa_currrecordctr-1) * @pa_reqdrecordcnt)) + ' and tc.id <=  ' + convert(varchar,(@pa_currrecordctr * @pa_reqdrecordcnt)) + '  
    order by t.dpam_acctno,final_trans,Isin_name,Runningid,16'  
   end  
  --PRINT (@@SSQL)  
   exec(@@ssql)  
     
   if @@rowcount = 0  
   begin  
	if @pa_dispatch ='Y'
	begin
		set @@ssql ='insert into dispatch_report_nsdl(dpam_id,dispatch_mode,Report_name,Dispatch_dt,Cof_recv,Created_dt,created_by,lst_upd_dt,lst_upd_by,deleted_ind)
		select dpam_id,''' + @pa_dispatchmode + ''',''STMT_NSDL'',getdate(),0,getdate(),''' + @pa_loginname + ',getdate(),''' + @pa_loginname + ',1 from ' + @@temptable + 'clients'  
		exec(@@ssql)
	end

	set @@ssql ='drop table ' + @@temptable  
	exec(@@ssql)  
	set @@ssql ='drop table ' + @@temptable + 'clients'  
	exec(@@ssql)  
   end  

                      
 END                      
                      
END                      
--transaction statement

GO
