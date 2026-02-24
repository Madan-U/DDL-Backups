-- Object: PROCEDURE citrus_usr.Pr_NsdlReconcile
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--Pr_NsdlReconcile 4,'jun  3 2008','Y',''          
CREATE proc [citrus_usr].[Pr_NsdlReconcile]            
@pa_excsmid int,                                  
@pa_reconcile_dt datetime,  
@pa_mismatchonly char(1),  
@pa_account varchar(8)           
as            
begin            
 set nocount on                     
 set transaction isolation level read uncommitted             
declare @@dpmid int,            
@pa_prevfromdate datetime            
            
select @@dpmid = dpm_id from dp_mstr with(nolock) where default_dp = @pa_excsmid and dpm_deleted_ind =1                                  
            
create table #nsdlreco                          
(                          
dpam_id bigint,                          
Ben_ctgry varchar(2),                    
Ben_acct_type varchar(2),                         
isin_cd varchar(12),  
sett_type varchar(3),    
sett_no varchar(10),             
dpm_trans_no varchar(20),            
Qty numeric(19,3),                          
Book_Narr_cd varchar(3),                          
trans_type int,            
)                          
            
     if @pa_account <> ''  
     begin  
      insert into #nsdlreco(dpam_id,ben_ctgry,ben_acct_type,isin_cd,sett_type,sett_no,dpm_trans_no,Qty,Book_Narr_cd,trans_type)                         
      select NSDHM_dpam_id,NSDHM_BEN_CTGRY,NSDHM_BEN_ACCT_TYPE,NSDHM_ISIN,nsdhm_sett_type,nsdhm_sett_no,nsdhm_dpm_trans_no,NSDHM_QTY,NSDHM_BOOK_NAAR_CD,0            
      from NSDL_HOLDING_DTLS with(nolock)            
      where                     
      nsdhm_dpm_id = @@dpmid                                  
      and NSDHM_TRANSACTION_DT = @pa_reconcile_dt  and nsdhm_ben_acct_no = @pa_account  
     end  
     else  
     begin  
      insert into #nsdlreco(dpam_id,ben_ctgry,ben_acct_type,isin_cd,sett_type,sett_no,dpm_trans_no,Qty,Book_Narr_cd,trans_type)                         
      select NSDHM_dpam_id,NSDHM_BEN_CTGRY,NSDHM_BEN_ACCT_TYPE,NSDHM_ISIN,nsdhm_sett_type,nsdhm_sett_no,nsdhm_dpm_trans_no,NSDHM_QTY,NSDHM_BOOK_NAAR_CD,0            
      from NSDL_HOLDING_DTLS with(nolock)            
      where                       
      NSDHM_TRANSACTION_DT = @pa_reconcile_dt     
      AND nsdhm_dpm_id = @@dpmid                                  
     end  
  
  
  
  
     --for non pool accounts   
     delete from #nsdlreco where Ben_acct_type not in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213','101')                 
       
     update m set trans_type = 1               
     from #nsdlreco m                
     where Ben_acct_type not in('20','30','40') and convert(int,m.book_narr_cd) = isnull((select max(convert(int,book_narr_cd)) from #nsdlreco m1 where m.dpm_trans_no = m1.dpm_trans_no and m.isin_cd = m1.isin_cd and m.dpam_id = m1.dpam_id and m.Ben_acct_type = m1.Ben_acct_type),0)             


	--added for demat & remat pending transactions 
	update #nsdlreco set trans_type = 1,sett_type='',sett_no='' where Ben_acct_type in('12','13') 
	--added for demat & remat pending transactions

     --for non pool accounts              
  
     -- for pool accounts  
      delete from #nsdlreco where Ben_acct_type in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213')  
   
      update #nsdlreco set trans_type = 1 where  Ben_acct_type in('20','30','40') and  sett_type <> '00'  
     -- for pool accounts          
   
            
	  select @pa_prevfromdate= max(dpdhmd_holding_dt) from DP_DAILY_HLDG_NSDL where dpdhmd_holding_dt < @pa_reconcile_dt
      
     if @pa_account <> ''  
     begin  
      insert into #nsdlreco(dpam_id,ben_ctgry,ben_acct_type,isin_cd,sett_type,sett_no,Qty,Book_Narr_cd,trans_type)                         
      select dpdhmd_dpam_id,dpdhmd_BENF_CAT,dpdhmd_BENF_ACCT_TYP,dpdhmd_ISIN,dpdhmd_sett_type,dpdhmd_sett_no,Qty=isnull(dpdhmd_qty,0),null,1            
      from fn_dailyholding_HO(@@dpmid,@pa_prevfromdate,@pa_account,@pa_account,'','')
  
         
      insert into #nsdlreco(dpam_id,ben_ctgry,ben_acct_type,isin_cd,sett_type,sett_no,Qty,Book_Narr_cd,trans_type)                         
      select dpdhmd_dpam_id,dpdhmd_BENF_CAT,dpdhmd_BENF_ACCT_TYP,dpdhmd_ISIN,dpdhmd_sett_type,dpdhmd_sett_no,isnull(dpdhmd_qty,0),null,2            
      from fn_dailyholding_HO(@@dpmid,@pa_reconcile_dt,@pa_account,@pa_account,'','')
   
     end  
     else  
     begin  
      insert into #nsdlreco(dpam_id,ben_ctgry,ben_acct_type,isin_cd,sett_type,sett_no,Qty,Book_Narr_cd,trans_type)                         
      select dpdhmd_dpam_id,dpdhmd_BENF_CAT,dpdhmd_BENF_ACCT_TYP,dpdhmd_ISIN,dpdhmd_sett_type,dpdhmd_sett_no,Qty=isnull(dpdhmd_qty,0),null,1            
      from fn_dailyholding_HO(@@dpmid,@pa_prevfromdate,'','','','')
 
 
      insert into #nsdlreco(dpam_id,ben_ctgry,ben_acct_type,isin_cd,sett_type,sett_no,Qty,Book_Narr_cd,trans_type)                         
      select dpdhmd_dpam_id,dpdhmd_BENF_CAT,dpdhmd_BENF_ACCT_TYP,dpdhmd_ISIN,dpdhmd_sett_type,dpdhmd_sett_no,isnull(dpdhmd_qty,0),null,2            
      from fn_dailyholding_HO(@@dpmid,@pa_reconcile_dt,'','','','')
 
     end  
           
  
     -- for pool accounts  
      delete from #nsdlreco where Ben_acct_type in('20','30','40') and sett_type = '00'  
     -- for pool accounts  
     --for non pool accounts   
       update #nsdlreco set sett_type='',sett_no='' where Ben_acct_type not in('20','30','40')  
     --for non pool accounts   
  
  
  
  
    if @pa_mismatchonly = 'Y'  
    begin    
	/*    
     select r.dpam_id,DPAM_SBA_NAME,DPAM_SBA_NO,ben_type=ltrim(rtrim(isnull(ben.descp,Ben_acct_type) + ' ' + case when sett_type <> '' then isnull(s.settm_desc,sett_type) + '/' + sett_no else '' end)),Ben_acct_type,isin_cd,            
     Trans_Holding =sum(case when trans_type = 1 then Qty else 0 end),            
     SOH_Holding=sum(case when trans_type = 2 then Qty else 0 end)           
     from #nsdlreco r with(nolock)  
     left outer join settlement_type_mstr s with(nolock) on r.sett_type = s.settm_type and isnull(s.settm_type,'') <> '',  
     dp_acct_mstr d with(nolock),            
     citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') ben         
     where trans_type > 0 and r.dpam_id = d.dpam_id and r.Ben_acct_type = ben.cd            
     group by r.dpam_id,DPAM_SBA_NAME,DPAM_SBA_NO,isin_cd,Ben_ctgry,Ben_acct_type,ben.descp,sett_type,s.settm_desc,sett_no            
     having sum(case when trans_type = 1 then Qty else 0 end) <> sum(case when trans_type = 2 then Qty else 0 end)            
     order by DPAM_SBA_NO,Ben_acct_type,sett_type,sett_no,isin_cd  
	*/
	 select r.dpam_id,DPAM_SBA_NAME,DPAM_SBA_NO,ben_type=case when sett_type <> '' then isnull(s.settm_desc,sett_type) + '/' + sett_no else '' end,isin_cd,            
     Trans_Holding =sum(case when trans_type = 1 then Qty else 0 end),            
     SOH_Holding=sum(case when trans_type = 2 then Qty else 0 end)           
     from #nsdlreco r with(nolock)  
     left outer join settlement_type_mstr s with(nolock) on r.sett_type = s.settm_type and isnull(s.settm_type,'') <> '',  
     dp_acct_mstr d with(nolock)         
     where trans_type > 0 and r.dpam_id = d.dpam_id            
     group by r.dpam_id,DPAM_SBA_NAME,DPAM_SBA_NO,isin_cd,sett_type,s.settm_desc,sett_no            
     having sum(case when trans_type = 1 then Qty else 0 end) <> sum(case when trans_type = 2 then Qty else 0 end)            
     order by DPAM_SBA_NO,sett_type,sett_no,isin_cd  
          
    end  
    else  
    begin  
     select r.dpam_id,DPAM_SBA_NAME,DPAM_SBA_NO,ben_type= case when sett_type <> '' then isnull(s.settm_desc,sett_type) + '/' + sett_no else '' end,isin_cd,            
     Trans_Holding =sum(case when trans_type = 1 then Qty else 0 end),            
     SOH_Holding=sum(case when trans_type = 2 then Qty else 0 end)           
     from #nsdlreco r with(nolock)  
     left outer join settlement_type_mstr s with(nolock)  on r.sett_type = s.settm_type and isnull(s.settm_type,'') <> '' ,  
     dp_acct_mstr d with(nolock)       
     where trans_type > 0 and r.dpam_id = d.dpam_id 
     group by r.dpam_id,DPAM_SBA_NAME,DPAM_SBA_NO,isin_cd,sett_type,s.settm_desc,sett_no            
     order by DPAM_SBA_NO,sett_type,sett_no,isin_cd           
    end  


	--select * from #nsdlreco where dpam_id = 20292 and isin_cd  = 'INE450G01024' order by Ben_acct_type,sett_type,sett_no
          
   
		truncate table #nsdlreco
    	drop table #nsdlreco          
         
            
end

GO
