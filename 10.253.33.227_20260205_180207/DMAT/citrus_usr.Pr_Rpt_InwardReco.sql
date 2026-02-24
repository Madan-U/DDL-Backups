-- Object: PROCEDURE citrus_usr.Pr_Rpt_InwardReco
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--[Pr_Rpt_InwardReco] 'CDSL',3,'FEB 19 2009','FEB 19 2009','E','N',''
CREATE PROC [citrus_usr].[Pr_Rpt_InwardReco]                
@pa_dptype varchar(4),                
@pa_excsmid int,                
@pa_fromdate datetime,                
@pa_todate datetime,                
@pa_basedon char(1), -- 'E' for execution date and 'R' for Request date           
@pa_withexception char(1) ,              
@pa_output varchar(8000) output                 
as                
begin                
set nocount on                
 declare @@dpmid int                
                 
 select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                
                
                
create table #inwardreco                
(                
 dpam_id bigint,                
 recd_dt datetime,                
 exec_dt datetime,                
 slip_no varchar(20),                
 ttype_cd varchar (5),                
 recd_mode varchar(200),                
 in_rmks  varchar(250),                
 in_trans_cnt int,                
 reco_trans_cnt int,                
 trans_type char(1)                
)                
                
create table #actualtrans                
(                
 dpam_id bigint,                
 recd_dt datetime,                
 exec_dt datetime,                
 slip_no varchar(20),                
 ttype_cd varchar (5),                
 trans_cnt int,                
 trans_type char(1)                
)                
                 
                
                
 if @pa_basedon = 'E'                
 begin                
                
  if @pa_dptype ='NSDL'                
  begin                
   insert into #inwardreco(dpam_id,recd_dt,exec_dt,slip_no,ttype_cd,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type)                
   select INWSR_DPAM_ID,inwsr_recd_dt,inwsr_exec_dt execdt,inwsr_slip_no,left(inwsr_trastm_cd,3),inwsr_receIved_mode,inwsr_rmks,inwsr_no_of_trans,0,'I'                
   from INWARD_SLIP_REG where inwsr_dpm_id = @@dpmid                 
   and inwsr_exec_dt between @pa_fromdate and @pa_todate                
   and inwsr_deleted_ind = 1                
        
        
   insert into #inwardreco(dpam_id,recd_dt,exec_dt ,slip_no,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type)                
   select dptd_dpam_id,dptd_request_dt,DPTD_EXECUTION_DT,DPTD_SLIP_NO,'Received From Broker',left(DPTD_trastm_cd,3),count(dptd_id),0,'I'                
   from dp_trx_dtls,dp_acct_mstr                
   where dptd_dpam_id = dpam_id and dpam_dpm_id = @@dpmid                 
   and DPTD_EXECUTION_DT between @pa_fromdate and @pa_todate                
   and dptd_deleted_ind = 1         
   and dpam_deleted_ind = 1 
   and isnull(DPTD_BROKERBATCH_NO,'') <> ''         
   group by dptd_dpam_id,dptd_request_dt,DPTD_EXECUTION_DT,DPTD_SLIP_NO,dptd_trastm_cd         
                 
   insert into #actualtrans(dpam_id,recd_dt,exec_dt ,slip_no,ttype_cd,trans_cnt,trans_type)                
   select dptd_dpam_id,dptd_request_dt,DPTD_EXECUTION_DT,DPTD_SLIP_NO,dptd_trastm_cd,count(dptd_id),'A'                
   from dp_trx_dtls ,dp_acct_mstr                 
   where dptd_dpam_id = dpam_id         
   and dpam_dpm_id = @@dpmid                 
   and DPTD_EXECUTION_DT between @pa_fromdate and @pa_todate                
   and dptd_deleted_ind = 1                
   and dpam_deleted_ind = 1 
         
   group by dptd_dpam_id,dptd_request_dt,DPTD_EXECUTION_DT,DPTD_SLIP_NO,dptd_trastm_cd                
                 
                 
   update #inwardreco set reco_trans_cnt = trans_cnt                
   from #inwardreco i, #actualtrans a                
   where i.dpam_id = a.dpam_id and i.slip_no = a.slip_no and i.exec_dt = a.exec_dt and i.recd_dt = a.recd_dt                
                 
   insert into #inwardreco(dpam_id,recd_dt,exec_dt ,slip_no,ttype_cd,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type)                
   select dpam_id,recd_dt,exec_dt ,slip_no,ttype_cd,'Not Recd.','',0,trans_cnt,'A' from #actualtrans a                
   where not exists                
   (select dpam_id,slip_no,exec_dt,recd_dt from #inwardreco i where i.dpam_id = a.dpam_id and i.slip_no = a.slip_no and i.exec_dt = a.exec_dt and i.recd_dt = a.recd_dt and i.ttype_cd = a.ttype_cd)                
          
   if @pa_withexception = 'N'           
 begin          
  select INWSR_ID,DPAM_SBA_NO,dpam_sba_name,convert(varchar(11),recd_dt,109) recddt,convert(varchar(11),exec_dt,109) execdt,slip_no,tdesc=ISNULL(t.descp,'') + ' - ' + ISNULL(ttype_cd,''),recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type                
  from #inwardreco i left outer join citrus_usr.fn_getsubtransdtls('TRANS_TYPE_NSDL') t                
  on i.ttype_cd = t.cd                
  ,dp_acct_mstr d
  ,INWARD_SLIP_REG r               
  where i.dpam_id = d.dpam_id and i.dpam_id = r.inwsr_dpam_id               
  and d.dpam_deleted_ind = 1           
  and  in_trans_cnt = reco_trans_cnt               
  order by exec_dt,DPAM_SBA_NO,t.descp,slip_no                
 end          
    else          
 begin          
   select INWSR_ID,DPAM_SBA_NO,dpam_sba_name,convert(varchar(11),recd_dt,109) recddt,convert(varchar(11),exec_dt,109) execdt,slip_no,tdesc=ISNULL(t.descp,'') + ' - ' + ISNULL(ttype_cd,''),recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type                
  from #inwardreco i left outer join citrus_usr.fn_getsubtransdtls('TRANS_TYPE_NSDL') t                
  on i.ttype_cd = t.cd                
  ,dp_acct_mstr d 
  ,INWARD_SLIP_REG r               
  where i.dpam_id = d.dpam_id and i.dpam_id = r.inwsr_dpam_id               
  and d.dpam_deleted_ind = 1             
  and  in_trans_cnt <> reco_trans_cnt            
  order by exec_dt,DPAM_SBA_NO,t.descp,slip_no              
 end          
  end                
                 
  if @pa_dptype ='CDSL'                
  begin                
                 
   insert into #inwardreco(dpam_id,recd_dt,exec_dt,slip_no,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type)                
   select distinct INWSR_DPAM_ID,inwsr_recd_dt,inwsr_exec_dt,inwsr_slip_no,inwsr_receIved_mode,inwsr_rmks,inwsr_no_of_trans,0,'I'                
   from INWARD_SLIP_REG where inwsr_dpm_id = @@dpmid                 
   and inwsr_exec_dt between @pa_fromdate and @pa_todate                
   and inwsr_deleted_ind = 1                
         

  insert into #inwardreco(dpam_id,recd_dt,exec_dt,slip_no,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type)                
   select distinct dptdc_dpam_id,dptdc_request_dt,DPTDC_EXECUTION_DT,DPTDC_SLIP_NO,'Received From Broker','',count(dptdc_id),0,'I'                
   from dp_trx_dtls_cdsl,dp_acct_mstr                
   where dptdc_dpam_id = dpam_id and dpam_dpm_id = @@dpmid                 
   and DPTDC_EXECUTION_DT between @pa_fromdate and @pa_todate                
   and dptdc_deleted_ind = 1         
   and dpam_deleted_ind = 1 
   and isnull(DPTDC_BROKERBATCH_NO,'') <> ''         
   group by dptdc_dpam_id,dptdc_request_dt,DPTDC_EXECUTION_DT,DPTDC_SLIP_NO,dptdc_trastm_cd      
        
   insert into #actualtrans(dpam_id,recd_dt,exec_dt,slip_no,ttype_cd,trans_cnt,trans_type)                
   select distinct dptdc_dpam_id,dptdc_request_dt,DPTDc_EXECUTION_DT,DPTDc_SLIP_NO,dptdc_trastm_cd,count(dptdc_id),'A'                
   from dp_trx_dtls_cdsl,dp_acct_mstr                
   where dptdc_dpam_id = dpam_id and dpam_dpm_id = @@dpmid                 
   and DPTDC_EXECUTION_DT between @pa_fromdate and @pa_todate                
   and dptdc_deleted_ind = 1                
   and dpam_deleted_ind = 1     
             
   group by dptdc_dpam_id,dptdc_request_dt,DPTDc_EXECUTION_DT,DPTDc_SLIP_NO,dptdc_trastm_cd                
                 
                 
   update #inwardreco set reco_trans_cnt = trans_cnt,ttype_cd= a.ttype_cd                
   from #inwardreco i, #actualtrans a                
   where i.dpam_id = a.dpam_id and i.slip_no = a.slip_no and i.exec_dt = a.exec_dt and i.recd_dt = a.recd_dt                
                 
   insert into #inwardreco(dpam_id,recd_dt,exec_dt,slip_no,ttype_cd,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type)                
   select distinct dpam_id,recd_dt,exec_dt,SLIP_NO,ttype_cd,'Not Recd.','',0,trans_cnt,'A' from #actualtrans a                
   where not exists                
   (select dpam_id,slip_no,exec_dt from #inwardreco i where i.dpam_id = a.dpam_id and i.slip_no = a.slip_no and i.exec_dt = a.exec_dt and i.recd_dt = a.recd_dt)                
          
--    select * from #inwardreco            
                

             
   if @pa_withexception = 'N'           
begin              
 select isnull(INWSR_ID,0) INWSR_ID,DPAM_SBA_NO,dpam_sba_name,convert(varchar(11),recd_dt,109) recddt,convert(varchar(11),exec_dt,109) execdt,slip_no,                
 tdesc=case when ttype_cd = 'BOBO' then 'OFF MARKET - BO TO BO'                
 when ttype_cd = 'BOCM' then 'ON MARKET PAYIN - BO TO CM'                
 when ttype_cd = 'CMBO' then 'ON MARKET PAYOUT - CM TO BO'                
 when ttype_cd = 'CMCM' then 'ON MARKET PAYOUT - CM TO CM'                
 when ttype_cd = 'ID' then 'INTER DEPOSITORY - IDD'                
 when ttype_cd = 'EP' then 'EARLY PAYIN - EP'                
 when ttype_cd = 'NP' then 'NORMAL PAYIN - NP'                
 else 'COMMON SLIP' end,                
 ttype_cd,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type                
 from #inwardreco i                 
  left outer join INWARD_SLIP_REG r                on  i.dpam_id = r.inwsr_dpam_id   and   slip_no =  INWSR_SLIP_NO and inwsr_deleted_ind =1        
 ,dp_acct_mstr d
 
 where i.dpam_id = d.dpam_id  
 and d.dpam_deleted_ind = 1            
 and   in_trans_cnt = reco_trans_cnt            
 order by exec_dt,DPAM_SBA_NO,slip_no                
 end          
else          
begin          
 select isnull(INWSR_ID,0) INWSR_ID,DPAM_SBA_NO,dpam_sba_name,convert(varchar(11),recd_dt,109) recddt ,convert(varchar(11),exec_dt,109) execdt,slip_no,                
 tdesc=case when ttype_cd = 'BOBO' then 'OFF MARKET - BO TO BO'                
 when ttype_cd = 'BOCM' then 'ON MARKET PAYIN - BO TO CM'                
 when ttype_cd = 'CMBO' then 'ON MARKET PAYOUT - CM TO BO'                
 when ttype_cd = 'CMCM' then 'ON MARKET PAYOUT - CM TO CM'                
 when ttype_cd = 'ID' then 'INTER DEPOSITORY - IDD'                
 when ttype_cd = 'EP' then 'EARLY PAYIN - EP'        
 when ttype_cd = 'NP' then 'NORMAL PAYIN - NP'                
 else 'COMMON SLIP' end,                
 ttype_cd,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type                
 from #inwardreco i                 
 left outer join INWARD_SLIP_REG r                on  i.dpam_id = r.inwsr_dpam_id   and   slip_no =  INWSR_SLIP_NO and inwsr_deleted_ind =1        
 ,dp_acct_mstr d
 where i.dpam_id = d.dpam_id 
 and d.dpam_deleted_ind = 1               
 and   in_trans_cnt <> reco_trans_cnt           
 order by execdt,DPAM_SBA_NO,slip_no                
end          
                 
  end                
 end                
 else --@pa_basedon = 'R'                
 begin                
  if @pa_dptype ='NSDL'                
  begin                
   insert into #inwardreco(dpam_id,recd_dt,exec_dt,slip_no,ttype_cd,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type)                
   select INWSR_DPAM_ID,inwsr_recd_dt,inwsr_exec_dt,inwsr_slip_no,left(inwsr_trastm_cd,3),inwsr_receIved_mode,inwsr_rmks,inwsr_no_of_trans,0,'I'                
   from INWARD_SLIP_REG                 
   where inwsr_dpm_id = @@dpmid                 
   and inwsr_recd_dt between @pa_fromdate and @pa_todate                
   and inwsr_deleted_ind = 1            


   insert into #inwardreco(dpam_id,recd_dt,exec_dt,slip_no,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type)                
   select dptd_dpam_id,dptd_request_dt,DPTD_EXECUTION_DT,DPTD_SLIP_NO,'Received From Broker','',count(dptd_id),0,'I'                
   from dp_trx_dtls,dp_acct_mstr                
   where dptd_dpam_id = dpam_id and dpam_dpm_id = @@dpmid                 
   and dptd_request_dt between @pa_fromdate and @pa_todate                
   and dptd_deleted_ind = 1         
   and dpam_deleted_ind = 1 
   and isnull(DPTD_BROKERBATCH_NO,'') <> ''         
   group by dptd_dpam_id,dptd_request_dt,DPTD_EXECUTION_DT,DPTD_SLIP_NO,dptd_trastm_cd      
    
                 
   insert into #actualtrans(dpam_id,recd_dt,exec_dt,slip_no,ttype_cd,trans_cnt,trans_type)                
   select dptd_dpam_id,dptd_request_dt,DPTD_EXECUTION_DT,DPTD_SLIP_NO,dptd_trastm_cd,count(dptd_id),'A'                
   from dp_trx_dtls ,dp_acct_mstr                
   where dptd_dpam_id = dpam_id and dpam_dpm_id = @@dpmid                 
   and dptd_request_dt between @pa_fromdate and @pa_todate                
   and dptd_deleted_ind = 1                
   and dpam_deleted_ind = 1                

   group by dptd_dpam_id,dptd_request_dt,DPTD_EXECUTION_DT,DPTD_SLIP_NO,dptd_trastm_cd                
                 
                 
   update #inwardreco set reco_trans_cnt = trans_cnt                
   from #inwardreco i, #actualtrans a                
   where i.dpam_id = a.dpam_id and i.slip_no = a.slip_no and i.exec_dt = a.exec_dt and i.recd_dt = a.recd_dt                 
                 
   insert into #inwardreco(dpam_id,recd_dt,exec_dt,slip_no,ttype_cd,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type)                
   select dpam_id,recd_dt,exec_dt,slip_no,ttype_cd,'Not Recd.','',0,trans_cnt,'A' from #actualtrans a                
   where not exists                
   (select dpam_id,slip_no,exec_dt from #inwardreco i where i.dpam_id = a.dpam_id and i.slip_no = a.slip_no and i.exec_dt = a.exec_dt and i.recd_dt = a.recd_dt and i.ttype_cd = a.ttype_cd)                
          
  if @pa_withexception = 'N'          
begin          
 select INWSR_ID,DPAM_SBA_NO,dpam_sba_name,i.dpam_id,convert(varchar(11),recd_dt,109) recddt,convert(varchar(11),exec_dt,109) execdt,slip_no,tdesc=ISNULL(t.descp,'') + ' - ' + ISNULL(ttype_cd,''),recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type                
 from #inwardreco i left outer join citrus_usr.fn_getsubtransdtls('TRANS_TYPE_NSDL') t                
 on i.ttype_cd = t.cd                
 ,dp_acct_mstr d
 ,INWARD_SLIP_REG r               
 where i.dpam_id = d.dpam_id and i.dpam_id = r.inwsr_dpam_id                
 and d.dpam_deleted_ind = 1            
 and   in_trans_cnt = reco_trans_cnt            
 order by recd_dt,DPAM_SBA_NO,t.descp,slip_no                
end          
else          
begin          
 select INWSR_ID,DPAM_SBA_NO,dpam_sba_name,i.dpam_id,convert(varchar(11),recd_dt,109) recddt,convert(varchar(11),exec_dt,109) execdt,slip_no,tdesc=ISNULL(t.descp,'') + ' - ' + ISNULL(ttype_cd,''),recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type                
 from #inwardreco i left outer join citrus_usr.fn_getsubtransdtls('TRANS_TYPE_NSDL') t                
 on i.ttype_cd = t.cd                
 ,dp_acct_mstr d 
 ,INWARD_SLIP_REG r                
 where i.dpam_id = d.dpam_id and i.dpam_id = r.inwsr_dpam_id              
 and d.dpam_deleted_ind = 1             
 and   in_trans_cnt <> reco_trans_cnt              
 order by recd_dt,DPAM_SBA_NO,t.descp,slip_no             
end          
          
  end                
                 
  if @pa_dptype ='CDSL'                
  begin                
                 
   insert into #inwardreco(dpam_id,recd_dt,exec_dt,slip_no,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type)                
   select INWSR_DPAM_ID,inwsr_recd_dt,inwsr_exec_dt,inwsr_slip_no,inwsr_receIved_mode,inwsr_rmks,inwsr_no_of_trans,0,'I'                
   from INWARD_SLIP_REG where inwsr_dpm_id = @@dpmid                 
   and inwsr_recd_dt between @pa_fromdate and @pa_todate                
   and inwsr_deleted_ind = 1       


   insert into #inwardreco(dpam_id,recd_dt,exec_dt,slip_no,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type)                
   select dptdc_dpam_id,dptdc_request_dt,DPTDC_EXECUTION_DT,DPTDC_SLIP_NO,'Received From Broker','',count(dptdc_id),0,'I'                
   from dp_trx_dtls_cdsl,dp_acct_mstr                
   where dptdc_dpam_id = dpam_id and dpam_dpm_id = @@dpmid                 
   and dptdc_request_dt between @pa_fromdate and @pa_todate                
   and dptdc_deleted_ind = 1         
   and dpam_deleted_ind = 1 
   and isnull(DPTDC_BROKERBATCH_NO,'') <> ''         
   group by dptdc_dpam_id,dptdc_request_dt,DPTDC_EXECUTION_DT,DPTDC_SLIP_NO,dptdc_trastm_cd      
         



             
   insert into #actualtrans(dpam_id,recd_dt,exec_dt,slip_no,ttype_cd,trans_cnt,trans_type)                
   select dptdc_dpam_id,dptdc_request_dt,DPTDC_EXECUTION_DT,DPTDC_SLIP_NO,dptdc_trastm_cd,count(dptdc_id),'A'                
   from dp_trx_dtls_cdsl,dp_acct_mstr                
   where dptdc_dpam_id = dpam_id and dpam_dpm_id = @@dpmid                 
   and dptdc_request_dt between @pa_fromdate and @pa_todate                
   and dptdc_deleted_ind = 1         
   and dpam_deleted_ind = 1   
   --and isnull(DPTDC_BROKERBATCH_NO,'') = ''        
   group by dptdc_dpam_id,dptdc_request_dt,DPTDC_EXECUTION_DT,DPTDC_SLIP_NO,dptdc_trastm_cd                
                 
                 
   update #inwardreco set reco_trans_cnt = trans_cnt,ttype_cd= a.ttype_cd                
   from #inwardreco i, #actualtrans a                
   where i.dpam_id = a.dpam_id and i.slip_no = a.slip_no and i.exec_dt = a.exec_dt and i.recd_dt = a.recd_dt                 
                 
   insert into #inwardreco(dpam_id,recd_dt,exec_dt,slip_no,ttype_cd,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type)                
   select dpam_id,recd_dt,exec_dt,slip_no,ttype_cd,'Not Recd.','',0,trans_cnt,'A' from #actualtrans a                
   where not exists                
   (select dpam_id,slip_no,exec_dt from #inwardreco i where i.dpam_id = a.dpam_id and i.slip_no = a.slip_no and i.exec_dt = a.exec_dt and i.recd_dt = a.recd_dt)                
          
    if @pa_withexception = 'N'          
begin               
   select ISNULL(INWSR_ID,0) INWSR_ID ,DPAM_SBA_NO,dpam_sba_name,convert(varchar(11),recd_dt,109) recddt,convert(varchar(11),exec_dt,109) execdt ,slip_no,                
   tdesc=case when ttype_cd = 'BOBO' then 'OFF MARKET - BO TO BO'                
       when ttype_cd = 'BOCM' then 'ON MARKET PAYIN - BO TO CM'                
       when ttype_cd = 'CMBO' then 'ON MARKET PAYOUT - CM TO BO'                
       when ttype_cd = 'CMCM' then 'ON MARKET PAYOUT - CM TO CM'                
       when ttype_cd = 'ID' then 'INTER DEPOSITORY - IDD'                
       when ttype_cd = 'EP' then 'EARLY PAYIN - EP'                
       when ttype_cd = 'NP' then 'NORMAL PAYIN - NP'                
              else 'COMMON SLIP' end,                
   ttype_cd,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type                
   from #inwardreco i                 
   left outer join INWARD_SLIP_REG r                on  i.dpam_id = r.inwsr_dpam_id   and   slip_no =  INWSR_SLIP_NO and inwsr_deleted_ind =1        
   ,dp_acct_mstr d
   --,INWARD_SLIP_REG r               
   where i.dpam_id = d.dpam_id 
   and d.dpam_deleted_ind = 1              
and in_trans_cnt = reco_trans_cnt            
   order by recd_dt,DPAM_SBA_NO,slip_no                
     end          
else          
begin          
 select ISNULL(INWSR_ID,0) INWSR_ID  ,DPAM_SBA_NO,dpam_sba_name,convert(varchar(11),recd_dt,109) recddt,convert(varchar(11),exec_dt,109) execdt,slip_no,                
   tdesc=case when ttype_cd = 'BOBO' then 'OFF MARKET - BO TO BO'                
       when ttype_cd = 'BOCM' then 'ON MARKET PAYIN - BO TO CM'                
       when ttype_cd = 'CMBO' then 'ON MARKET PAYOUT - CM TO BO'                
       when ttype_cd = 'CMCM' then 'ON MARKET PAYOUT - CM TO CM'                
       when ttype_cd = 'ID' then 'INTER DEPOSITORY - IDD'                
       when ttype_cd = 'EP' then 'EARLY PAYIN - EP'                
       when ttype_cd = 'NP' then 'NORMAL PAYIN - NP'                
              else 'COMMON SLIP' end,                
   ttype_cd,recd_mode,in_rmks,in_trans_cnt,reco_trans_cnt,trans_type                
   from #inwardreco i                 
   left outer join INWARD_SLIP_REG r                on  i.dpam_id = r.inwsr_dpam_id   and   slip_no =  INWSR_SLIP_NO and inwsr_deleted_ind =1        
   ,dp_acct_mstr d 
   --,INWARD_SLIP_REG r               
   where i.dpam_id = d.dpam_id and i.dpam_id = r.inwsr_dpam_id              
   and d.dpam_deleted_ind = 1            
and in_trans_cnt <> reco_trans_cnt               
   order by recd_dt,DPAM_SBA_NO,slip_no                
end            
                 
  end                
                
        
                
 end                
                
                
end

GO
