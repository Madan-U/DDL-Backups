-- Object: PROCEDURE citrus_usr.Pr_Rpt_Ledger_OLDONE
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/****** Object:  StoredProcedure [citrus_usr].[Pr_Rpt_Ledger]    Script Date: 10/22/2008 14:20:26 ******/
--SELECT * FROM DP_MSTR
--[Pr_Rpt_Ledger] 2,1,'apr  1 2008','mar 31 2009','p','','','y',1,'HO|~*|',''       
CREATE  Proc [citrus_usr].[Pr_Rpt_Ledger_OLDONE]        
@pa_dpmid int,        
@pa_finyearid int,        
@pa_fromdate datetime,        
@pa_todate datetime,        
@pa_ledgertype varchar(2),        
@pa_fromaccid varchar(16),        
@pa_toaccid varchar(16),        
@pa_withrunbal char(1),        
@pa_login_pr_entm_id numeric,          
@pa_login_entm_cd_chain  varchar(8000),          
@pa_output varchar(8000) output  As        
begin        
set nocount on        
declare @@ssql varchar(5000)        
--        
declare @@l_child_entm_id      numeric          
select @@l_child_entm_id    =  isnull(citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain),0)        

IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME = 'temptable')
DROP TABLE temptable      

if @pa_fromaccid = ''                  
begin                  
 set @pa_fromaccid = '0'                  
 set @pa_toaccid = '99999999999999999'                  
end                    
if @pa_toaccid = ''                  
begin                  
 set @pa_toaccid = @pa_fromaccid                  
end                  
        

CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME,acct_type varchar(2))
 if (@pa_ledgertype = 'G' or @pa_ledgertype = 'B')      
 begin           
	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO,acct_type FROM citrus_usr.fn_gl_acct_list(@pa_dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) 
   		
 end
 else
 begin
	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO,'P' FROM citrus_usr.fn_acct_list(@pa_dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) where convert(numeric,dpam_sba_no) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)    		
 end         
          
  
        
create Table #temptable        
(        
 trans_type char(10),        
 voucher_type int,        
 voucher_no bigint,        
 ref_no varchar(16),        
 account_id [numeric] (19,4),        
 account_cd varchar(16),        
 account_name varchar(200),        
 account_type varchar(2),        
 voucher_date datetime,        
 bank_cl_date datetime,        
 amount [numeric](19, 4),        
 narration varchar(250),        
 chq_no varchar(20),        
 bank_id int,        
 bank_acct_no varchar(16),
 sr_no int       
)        
        
        
 set @@ssql = 'Insert into #temptable'         
 set @@ssql = @@ssql + ' select ldg_trans_type,ldg_voucher_type,ldg_Voucher_no,ldg_ref_no,ldg_account_id,dpam_sba_no,dpam_sba_name,ldg_account_type,ldg_voucher_dt,ldg_bank_cl_date,ldg_amount,ldg_narration,ldg_instrument_no,ldg_bank_id,ldg_account_no,ldg_sr_no'     
 set @@ssql = @@ssql + ' from ledger' + convert(varchar,@pa_finyearid)  + ' , #ACLIST account '    
 set @@ssql = @@ssql + ' where ldg_dpm_id = ' + convert(varchar,@pa_dpmid) + '  and ldg_voucher_dt >= ''' + convert(varchar(11),@pa_fromdate,109) + ''' and ldg_voucher_dt <= ''' + convert(varchar(11),@pa_todate,109) + ' 23:59:59'''        
 set @@ssql = @@ssql + ' and ISNULL(ldg_trans_type,'''') <> ''O'''        
 set @@ssql = @@ssql + ' and ldg_account_id = account.dpam_id '            
 set @@ssql = @@ssql + ' and ldg_account_type = account.acct_type ' 
 set @@ssql = @@ssql + ' and ldg_deleted_ind  = 1 '            
         
 if @pa_ledgertype = 'G'        
 begin        
		if @pa_fromaccid <> ''
		begin
			set @@ssql = @@ssql + ' and dpam_sba_no = ''' + @pa_fromaccid + ''''          
		end
		set @@ssql = @@ssql + ' and ldg_account_type = ''G'' '        
 end 
 else if  @pa_ledgertype = 'B'        
 begin
		if @pa_fromaccid <> ''
		begin
			set @@ssql = @@ssql + ' and dpam_sba_no = ''' + @pa_fromaccid + ''''          
		end
		set @@ssql = @@ssql + ' and ldg_account_type in (''B'',''C'') '   
 end     
 else        
 begin        
        
		  set @@ssql = @@ssql + ' and isnumeric(dpam_sba_no) = 1 '        
		  set @@ssql = @@ssql + ' and (ldg_voucher_dt between eff_from and eff_to) '            
        
		  if @pa_fromaccid <> '' and @pa_toaccid <> ''         
		  begin        
			set @@ssql = @@ssql + ' and convert(bigint,dpam_sba_no) >= ' + @pa_fromaccid + ' and convert(bigint,dpam_sba_no) <= ' + @pa_toaccid         
		  end        
		  set @@ssql = @@ssql + ' and ldg_account_type = ''P'' '        
 end        
 set @@ssql = @@ssql + ' and ldg_deleted_ind = 1 '        
 set @@ssql = @@ssql + ' order by ldg_account_id,ldg_voucher_dt,ldg_Voucher_no'        
         
  
Exec(@@ssql)    

  
        
        
  --FOR OPENING RECORDS        
 -- voucher_type = 0 -- opening        
 set @@ssql = 'insert into #temptable '        
 set @@ssql = @@ssql + ' select trans_type='''',voucher_type=0,Voucher_no=0,refno='''',ldg_account_id,dpam_sba_no,dpam_sba_name,ldg_account_type,voucher_date= Dateadd(day,-1,cast(''' + convert(varchar(11),@pa_fromdate,109) + ''' as datetime)),bank_cl_date= '''','        
 set @@ssql = @@ssql + ' amount=Sum(ldg_amount),'        
 set @@ssql = @@ssql + ' narration='''',instrument_no='''',bank_id=0,acct_no = '''',sr_no=0'        
 set @@ssql = @@ssql + ' from ledger' + convert(varchar,@pa_finyearid) + ' , #ACLIST account '       
 set @@ssql = @@ssql + ' where ldg_dpm_id = ' + convert(varchar,@pa_dpmid) + '  and ldg_voucher_dt < ''' + convert(varchar(11),@pa_fromdate,109) + ' 00:00:00'''        
  set @@ssql = @@ssql + ' and ldg_account_id = account.dpam_id '            
  set @@ssql = @@ssql + ' and ldg_account_type = account.acct_type '      
  set @@ssql = @@ssql + ' and ldg_deleted_ind  = 1 '                  
          
 if @pa_ledgertype = 'G'        
 begin 
		if @pa_fromaccid <> ''
		begin       
			  set @@ssql = @@ssql + ' and dpam_sba_no = ''' + @pa_fromaccid + ''''  
		end
		set @@ssql = @@ssql + ' and ldg_account_type = ''G'' '        
 end        
 else if  @pa_ledgertype = 'B'        
 begin
		if @pa_fromaccid <> ''
		begin       
			  set @@ssql = @@ssql + ' and dpam_sba_no = ''' + @pa_fromaccid + ''''  
		end
		set @@ssql = @@ssql + ' and ldg_account_type in (''B'',''C'') '        
 end 
 else        
 begin        
		  set @@ssql = @@ssql + ' and (ldg_voucher_dt between eff_from and eff_to) '        
		  set @@ssql = @@ssql + ' and isnumeric(dpam_sba_no) = 1 '        
		  if @pa_fromaccid <> '' and @pa_toaccid <> ''        
		  begin        
			  set @@ssql = @@ssql + ' and convert(bigint,dpam_sba_no) >= ' + @pa_fromaccid + ' and convert(bigint,dpam_sba_no) <= ' + @pa_toaccid    
		  end        
		  set @@ssql = @@ssql + ' and ldg_account_type = ''P'' '        
  end         
  set @@ssql = @@ssql + ' and ldg_deleted_ind = 1 '             
  set @@ssql = @@ssql + ' group by ldg_account_id,ldg_account_type,dpam_sba_name,dpam_sba_no'        
   

 Exec(@@ssql)        
 --FOR OPENING RECORDS        



set @@ssql= 'update t set narration = isnull(narration,'''') + '' ('' + isnull(dpam_sba_name,'''') + '')''
,chq_no = CASE WHEN LTRIM(RTRIM(ISNULL(chq_no,''''))) = '''' THEN ISNULL(LDG_INSTRUMENT_NO,'''') ELSE chq_no END
from #temptable t,ledger' + convert(varchar,@pa_finyearid) + ',#ACLIST account
where t.voucher_date = ldg_voucher_dt 
and t.voucher_type = ldg_voucher_type
and t.voucher_no = ldg_voucher_no 
and t.account_type in (''B'',''C'')
and ldg_voucher_type in (1,2) 
and t.sr_no = 1
and ldg_sr_no = 2
and ldg_account_id = dpam_id
and ldg_deleted_ind = 1'
Exec(@@ssql)
--print(@@ssql)
     
 if (@pa_withrunbal = 'Y')        
 begin        
        
  select identity(int,1,1) as Runningid , * into #templedger from #temptable
  where  amount <> 0       
  order by account_id,Voucher_date,voucher_type,Voucher_no        
         
       

 
  select voucher_type= citrus_usr.GetVoucherDescp(voucher_type),Voucher_no=isnull(Voucher_no,0),account_id=account_id,account_cd,account_name,voucher_date= Convert(varchar(11),voucher_date,103),bank_cl_date= isnull(Convert(varchar(11),bank_cl_date,103),''),        
  debit = case when amount <=0 then Abs(amount) else 0 end,credit= case when amount >0 then Abs(amount) else 0 end,        
  citrus_usr.fn_splitstrin_byspace(narration + case when isnull( bank_acct_no,'')<>'' then 'A/c Nos.' + isnull( bank_acct_no,'') else '' END + '.',32,'',1) narration,isnull(chq_no,'') chq_no,        
  RunningAmt=(select sum(isnull(amount,0)) from #templedger t1 where t1.Runningid <= t.Runningid and t1.account_id=t.account_id),ord_dt=voucher_date   
,Runningid ,account_type
INTO temptable
from #templedger t

 SELECT DISTINCT * FROM temptable  
  order by Runningid,account_name,account_cd,account_type,narration,voucher_type,Voucher_no            
  --order by Runningid,account_name,account_cd,account_type,13,voucher_type,Voucher_no        
 end        
 else        
 begin  


      
  select voucher_type= citrus_usr.GetVoucherDescp(voucher_type),Voucher_no=isnull(Voucher_no,0),account_id=account_id,account_cd,account_name,voucher_date= Convert(varchar(11),voucher_date,103),bank_cl_date= isnull(Convert(varchar(11),bank_cl_date,103),''),        
  debit = case when amount <=0 then Abs(amount) else 0 end,credit= case when amount >0 then Abs(amount) else 0 end ,        
  citrus_usr.fn_splitstrin_byspace(narration + case when isnull( bank_acct_no,'')<>'' then 'A/c Nos.' + isnull( bank_acct_no,'') else '' END + '.',32,'',1) narration,isnull(chq_no,'') chq_no,ord_dt=voucher_date        
  ,account_type
  INTO temptable
  from #temptable t    
  where  amount <> 0  


  SELECT DISTINCT * FROM temptable  
  order by account_name,account_cd,account_type,narration,voucher_type,Voucher_no          
  --order by account_name,account_cd,account_type,12,voucher_type,Voucher_no        
        
        
 end        
        
 
    
end

GO
