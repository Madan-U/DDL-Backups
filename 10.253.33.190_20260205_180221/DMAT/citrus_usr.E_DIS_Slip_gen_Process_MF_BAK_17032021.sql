-- Object: PROCEDURE citrus_usr.E_DIS_Slip_gen_Process_MF_BAK_17032021
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE Procedure [citrus_usr].[E_DIS_Slip_gen_Process_MF_BAK_17032021]        
--(        
--@date datetime        
--)        
As        
---exec USP_DIY_POA_Process_Log_mf '09/14/2018'        
    
    
DECLARE @date datetime     
SELECT @date=CONVERT(VARCHAR(10),GETDATE(),101)    
  
Declare @sdate datetime  
  select @sdate=CONVERT(VARCHAR(10),GETDATE(),120)    
        
Begin        
        
declare @count int;        
Declare @counter int=1,@totalcount int,@p26 varchar(100), @pa_login_name varchar(50),@pa_slip_no varchar(50),@pa_excm_id varchar(10),        
@pa_values varchar(50),@pa_settlm_no varchar(50),@executionndate datetime,@pa_tr_setm_type varchar(10),@pa_tr_acct_no varchar(20);        
           
    
set @executionndate=  convert(varchar(11),getdate(),120)     
    
delete from DIY_POA_Process_Log_MF where CREATED_DATE= convert(varchar(11),getdate(),120)        
       
  --select * from DIY_POA_Process_Log_MF  
  select * into #DIY_POA_Process_Log_MF from DIY_POA_Process_Log_MF where 1=2  
  
INSERT INTO #DIY_POA_Process_Log_MF        
  SELECT         
  PARTYCODE ClientID,DPID ,SYMBOL,ISIN, Exchange=(CASE WHEN EXCHANGE ='1' THEN 'NSE'         
                      WHEN EXCHANGE ='3' THEN 'BSE'        
                      ELSE '' END ) , sum(convert(float, Quantity)) Quantity,POAStatus AS ONL,        
  CREATED_DATE =convert(varchar(11),date_time_stamp,120)  ,'','','','',convert(varchar(11),date_time_stamp,120),'',ROW_NUMBER() over(order by PARTYCODE),SETT_NO,''        
  FROM        
    [172.31.16.75].Angel_WMS.DBO.po_acceptance_status a        
    WHERE convert(varchar(11),DATE_TIME_STAMP,103) = CONVERT(VARCHAR(11),GETDATE(),103)      
    --AND CreationDate <=CONVERT(VARCHAR(11),@date,120) +' 23:59' AND         
   AND ACTION ='SELL'   and  isnull(convert(float, Quantity),0) <>0    AND PRODUCT_TYPE='MF'    
   and  ISNULL(SYMBOL,'') <> '' AND ISNULL( ISIN,'')  <>''  AND  SETT_NO <>'' --AND LEN(DPID)=16        
    GROUP BY  PARTYCODE,Exchange,POAStatus,SYMBOL,ISIN,DPID,convert(varchar(11),date_time_stamp,120),sett_no    
         
                
   UPDATE D SET DP_ID = Cltdpid FROM #DIY_POA_Process_Log_MF D,[196.1.115.200].BSEMFSS.DBO.MFSS_CLIENT C        
   WHERE D.Cl_code = C.PARTY_CODE   --AND Depository ='CDSL'          
   AND CONVERT(VARCHAR(11),CREATED_DATE,103) = CONVERT(VARCHAR(11),GETDATE(),103)      
    
   insert into DIY_Reprocess_log_e_dis_MF_hst  
   select * from DIY_Reprocess_log_e_dis_MF   
   truncate table DIY_Reprocess_log_e_dis_MF   
  
     
      
   INSERT INTO  DIY_Reprocess_log_e_dis_MF    
   SELECT sett_no,sett_type,Cl_code,SYMBOL,'',SELLtradeqty=0,sellRECQTY=0,  
   Sell_shortage =Qty  
   ,DP_ID,ISIN ,PROCESS_DATE=GETDATE(),0,'',0,'N',1,ADJ_QTY=Qty    
   FROM #DIY_POA_Process_Log_MF D   
   where  exists (select partycode from E_Dis_Trxn_Data t 
   where d.Cl_code =t.Partycode and d.ISIN=t.isin and getdate() between Request_date  
    and Request_date+ NO_of_days + ' 23:59' AND ISNULL(VALID,0)=0 and isnull(dummy3,'')='')  
  
    Exec Edis_trxn_process_MF  @sdate  
  
          
   
   --insert into E_DIS_Process_Data_hst  
   --select partycode,boid,isin,qty,ANGEL_TRXN_ID,CDSL_TRXN_Id,Request_date,sett_no,sett_type,  
   --process_status,process_date,slip_no  
   --from E_DIS_Process_Data  
     
  --- truncate table E_DIS_Process_Data  
  
   insert into E_DIS_Process_Data  
     select partycode,boid,n.isin,max(ADJ_QTY) as qty,max(ANGEL_TRXN_ID) ANGEL_TRXN_ID, max(CDSL_TRXN_Id) CDSL_TRXN_Id,   
   Request_date=convert(varchar(11),getdate(),120),t.sett_no,sett_type='' ,process_status=0,process_date=getdate(),0  
   from HOLD_REP_N_MF n, DIY_Reprocess_log_e_dis_MF t  
    where t.Party_code =n.Partycode and t.isin=n.isin  --and sett_no =@sett_no--and partycode='A133377'   
    group by partycode,boid,n.isin,t.sett_no  
        
  
    update t set Ex_qty =isnull(Ex_qty,0)+ALLOCATE_QTY  
   FROM E_Dis_Trxn_Data t ,HOLD_REP_N_MF n  
   where  t.Partycode =n.Partycode and t.isin=n.isin and t.CDSL_TRXN_Id=n.CDSL_TRXN_Id  
   and  t.ANGEL_TRXN_ID =n.ANGEL_TRXN_ID AND ISNULL(VALID,0)=0  
  
     
  
    update t set VALID =(case when t.qty <>ex_qty then '0' else '1' end),Pend_qty=T.qty-ex_qty  
   FROM E_Dis_Trxn_Data t ,HOLD_REP_N_MF n  
   where  t.Partycode =n.Partycode and t.isin=n.isin and t.CDSL_TRXN_Id=n.CDSL_TRXN_Id  
   and  t.ANGEL_TRXN_ID =n.ANGEL_TRXN_ID AND ISNULL(VALID,0)=0  
     
  
   ---select  * into E_DIS_Process_Data_mf from E_DIS_Process_Data where 1=2  
     
        
 Select BOID pa_login_name,(select srNo from tbl_ProcessSRNo) pa_slip_no,4 As pa_excm_id,        
 '52' AS pa_tr_setm_type,        
 'A|*~|'+ISIN+'|*~|'+convert(varchar(10),cast(QTY as decimal(18,4)))+'|*~|*|~*' pa_values,        
 SETT_NO pa_settlm_no,        
'' As pa_tr_acct_no  ,ANGEL_TRXN_ID, CDSL_TRXN_Id,isin  
 Into #FinalTable         
 From E_DIS_Process_Data       
 where convert(varchar(11),process_date,103) =CONVERT(VARCHAR(11),GETDATE(),103)    
 And Isin Like 'INF%' and process_status='0' ---AND  POA_STATUS_BO =''  AND  BO_VALIDATION ='Y' AND DP_VALID <> ''        
---- AND SETT_TYPE ='W'      
      
          
 Alter table #FinalTable Add ID int Identity(1,1) primary key         
     
    
       
Declare @p33 varchar(100)     
    
 Select @totalcount= count(*) from #FinalTable        
        
 While(@counter<=@totalcount)        
        
 Begin        
 select  @pa_login_name= pa_login_name,@pa_slip_no='E'+convert(varchar(100),(pa_slip_no+@counter)),@pa_excm_id=pa_excm_id,@pa_values=pa_values,        
 @pa_settlm_no=pa_settlm_no,@pa_tr_setm_type=pa_tr_setm_type,@pa_tr_acct_no=pa_tr_acct_no from #FinalTable  where ID=@counter        
        
 set @p26=@pa_values      
 exec pr_ins_upd_trx_cdsl_sp_PreEDIS @pa_id='0',@pa_tab='NP',@pa_action='INS',@pa_login_name=@pa_login_name,@pa_dpm_dpid='12033200',    
 @pa_dpam_acct_no=@pa_login_name,@pa_slip_no=@pa_slip_no,@pa_mkt_type='',@pa_settlm_no=@pa_settlm_no,    
 @pa_req_dt=@executionndate,@pa_cm_id='612',@pa_excm_id='4',@pa_cash_trf='NA',@pa_exe_dt=@executionndate,@pa_tr_cmbpid='',    
 @pa_tr_dp_id='',@pa_tr_setm_type='52',@pa_tr_setm_no='',@pa_tr_acct_no='',@pa_values=@pa_values,    
 @pa_rmks='',@pa_trdReasoncd='0',@pa_Paymode='',@pa_Bankacno='',@pa_Bankacname='',@pa_BankBrname='',@pa_TransfereeName='',    
 @pa_DOI='',@pa_ChqRefno='',@pa_chk_yn=1,@RowDelimiter='*|~*',@ColDelimiter='|*~|',@PA_ERRMSG=@p33 output    
 select @p33    
    
    
        
--update DIY_POA_Process_Log_MF set DP_PROCESS_DT=@date where SRNO=(select srno from #FinalTable where ID=@counter)        
set @counter=@counter+1        
        
End     
  
 IF ( @pa_slip_no IS NOT NULL OR @pa_slip_no <> '')  
     BEGIN   
    update tbl_ProcessSRNo set SRNO = SRNO+@totalcount  
   
 END  
   
        
End     
  
     update d set slip_no='E'+convert(varchar(100),(pa_slip_no+ID)),process_status =1 from #FinalTable (nolock) f, E_DIS_Process_Data (nolock) d where boid= pa_login_name    
   AND F.ISIN=D.ISIN  
   AND SETT_NO= pa_settlm_no AND process_status=0  and f.ANGEL_TRXN_ID =d.ANGEL_TRXN_ID and d.CDSL_TRXN_Id=f.CDSL_TRXN_Id   
  
  EXEC PR_CDSL_PRETRADE_EDIS_RESPONSE_ANGEL '',''

GO
