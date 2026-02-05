-- Object: PROCEDURE citrus_usr.Pr_NsdlReconcile_pool
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--Pr_NsdlReconcile_pool 4,'Mar 31 2008'    
CREATE proc [citrus_usr].[Pr_NsdlReconcile_pool]    
@pa_excsmid int,                          
@pa_reconcile_dt datetime    
as    
begin    
 set nocount on             
    
declare @@dpmid int,    
@pa_prevfromdate datetime    
    
select @@dpmid = dpm_id from dp_mstr with(nolock) where default_dp = @pa_excsmid and dpm_deleted_ind =1                          
    
create table #nsdlreco                  
(                  
dpam_id bigint,                  
Ben_ctgry varchar(2),            
Ben_acct_type varchar(2),                 
isin_cd varchar(12),    
dpm_trans_no varchar(20),    
Qty numeric(19,3),                  
Book_Narr_cd varchar(3),
sett_type varchar(3),
sett_no varchar(10),                 
trans_type int    
)                  
    
/*    
 note : error in transaction staement & billing statement (4 procs)    
 add dpm_id condition in      
  select @pa_prevfromdate=isnull(max(dpdhmd_holding_dt),'jan  1 1900') from DP_DAILY_HLDG_NSDL where dpdhmd_holding_dt < @pa_fromdate                  
*/    
    
    
     insert into #nsdlreco(dpam_id,ben_ctgry,ben_acct_type,isin_cd,dpm_trans_no,Qty,Book_Narr_cd,sett_type,sett_no,trans_type)                 
     select NSDHM_dpam_id,NSDHM_BEN_CTGRY,NSDHM_BEN_ACCT_TYPE,NSDHM_ISIN,nsdhm_dpm_trans_no,NSDHM_QTY,NSDHM_BOOK_NAAR_CD,NSDHM_SETT_TYPE,NSDHM_SETT_NO,1    
     from NSDL_HOLDING_DTLS with(nolock)    
     where               
     nsdhm_dpm_id = @@dpmid                          
     and NSDHM_TRANSACTION_DT = @pa_reconcile_dt      
     and NSDHM_BEN_ACCT_TYPE in('20','30','40')  and nsdhm_sett_type <> '00'


     delete from #nsdlreco where book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213') 
     --delete from #nsdlreco where book_narr_cd in ('011','013','014','021','023','024','031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213') 
    
     select @pa_prevfromdate=isnull(max(dpdhmd_holding_dt),'jan  1 1900') from DP_DAILY_HLDG_NSDL with(nolock) where dpdhmd_dpm_id = @@dpmid and dpdhmd_holding_dt < @pa_reconcile_dt     
    
     insert into #nsdlreco(dpam_id,ben_ctgry,ben_acct_type,isin_cd,Qty,Book_Narr_cd,sett_type,sett_no,trans_type)                 
     select dpdhmd_dpam_id,dpdhmd_BENF_CAT,dpdhmd_BENF_ACCT_TYP,dpdhmd_ISIN,Qty=isnull(dpdhmd_qty,0)    
     ,null,dpdhmd_sett_type,dpdhmd_sett_no,1    
     from DP_DAILY_HLDG_NSDL with(nolock)    
     where               
     DPDHMD_DPM_ID = @@dpmid                          
     and DPDHMD_HOLDING_DT = @pa_prevfromdate  
     and dpdhmd_BENF_ACCT_TYP in('20','30','40')  and dpdhmd_sett_type <> '00' 

  
    
     insert into #nsdlreco(dpam_id,ben_ctgry,ben_acct_type,isin_cd,Qty,Book_Narr_cd,sett_type,sett_no,trans_type)                 
     select dpdhmd_dpam_id,dpdhmd_BENF_CAT,dpdhmd_BENF_ACCT_TYP,dpdhmd_ISIN,isnull(dpdhmd_qty,0),null,dpdhmd_sett_type,dpdhmd_sett_no,2    
     from DP_DAILY_HLDG_NSDL with(nolock)    
     where               
     DPDHMD_DPM_ID = @@dpmid                          
     and DPDHMD_HOLDING_DT = @pa_reconcile_dt    
     and dpdhmd_BENF_ACCT_TYP in('20','30','40')  and dpdhmd_sett_type <> '00' 


   
    select r.dpam_id,DPAM_SBA_NAME,DPAM_SBA_NO,ben_type=isnull(ben.descp,Ben_acct_type),Ben_acct_type,sett_type,sett_no,isin_cd,    
    Trans_Holding =sum(case when trans_type = 1 then Qty else 0 end),    
    SOH_Holding=sum(case when trans_type = 2 then Qty else 0 end)    
    from #nsdlreco r with(nolock), dp_acct_mstr d with(nolock),    
    citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') ben                          
       where r.dpam_id = d.dpam_id and r.Ben_acct_type = ben.cd    
    group by r.dpam_id,DPAM_SBA_NAME,DPAM_SBA_NO,isin_cd,Ben_ctgry,Ben_acct_type,ben.descp,sett_type,sett_no    
    having sum(case when trans_type = 1 then Qty else 0 end) <> sum(case when trans_type = 2 then Qty else 0 end)    
    order by DPAM_SBA_NO,isin_cd,Ben_acct_type     
    drop table #nsdlreco    
        
    --select * from #nsdlreco where isin_cd = 'INE001A01028' and dpam_id = 60017 order by sett_no



    

    
    
end

GO
