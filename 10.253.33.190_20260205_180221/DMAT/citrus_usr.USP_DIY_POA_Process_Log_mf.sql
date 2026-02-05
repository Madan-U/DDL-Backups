-- Object: PROCEDURE citrus_usr.USP_DIY_POA_Process_Log_mf
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE Procedure [citrus_usr].[USP_DIY_POA_Process_Log_mf]      
--(      
--@date datetime      
--)      
As      
---exec USP_DIY_POA_Process_Log_mf '09/14/2018'      
  
  
DECLARE @date datetime   
SELECT @date=CONVERT(VARCHAR(10),GETDATE(),101)  
      
Begin      
      
declare @count int;      
Declare @counter int=1,@totalcount int,@p26 varchar(100), @pa_login_name varchar(50),@pa_slip_no varchar(50),@pa_excm_id varchar(10),      
@pa_values varchar(50),@pa_settlm_no varchar(50),@executionndate datetime,@pa_tr_setm_type varchar(10),@pa_tr_acct_no varchar(20);      
         
  
set @executionndate=  convert(varchar(11),getdate(),120)   
  
delete from DIY_POA_Process_Log_MF where CREATED_DATE= convert(varchar(11),getdate(),120)      
     
INSERT INTO DIY_POA_Process_Log_MF      
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
       
              
   UPDATE D SET DP_ID = Cltdpid FROM DIY_POA_Process_Log_MF D,[196.1.115.200].BSEMFSS.DBO.MFSS_CLIENT C      
   WHERE D.Cl_code = C.PARTY_CODE   --AND Depository ='CDSL'        
   AND CONVERT(VARCHAR(11),CREATED_DATE,103) = CONVERT(VARCHAR(11),GETDATE(),103)    
  
   
   
      
 Select DP_ID pa_login_name,(select srNo from tbl_ProcessSRNo) pa_slip_no,(Case when EXCHANGE='BSE' then 4 When EXCHANGE='NSE' then '3' End) As pa_excm_id,      
 '52' AS pa_tr_setm_type,      
 'A|*~|'+ISIN+'|*~|'+convert(varchar(10),QTY)+'|*~|*|~*' pa_values,      
 SETT_NO pa_settlm_no,      
'' As pa_tr_acct_no      
  Into #FinalTable       
 From DIY_POA_Process_Log_MF      
 where convert(varchar(11),CREATED_DATE,103) =CONVERT(VARCHAR(11),GETDATE(),103)   ---AND  POA_STATUS_BO =''  AND  BO_VALIDATION ='Y' AND DP_VALID <> ''      
---- AND SETT_TYPE ='W'    
    
        
 Alter table #FinalTable Add ID int Identity(1,1) primary key       
   
  
     
Declare @p33 varchar(100)   
  
   
      
 Select @totalcount= count(*) from #FinalTable      
      
 While(@counter<=@totalcount)      
      
 Begin      
 select  @pa_login_name= pa_login_name,@pa_slip_no='E'+convert(varchar(100),(pa_slip_no+@counter)),@pa_excm_id=pa_excm_id,@pa_values=pa_values,      
 @pa_settlm_no=pa_settlm_no,@pa_tr_setm_type=pa_tr_setm_type,@pa_tr_acct_no=pa_tr_acct_no from #FinalTable  where ID=@counter      
      
 set @p26=@pa_values    
 exec pr_ins_upd_trx_cdsl_sp @pa_id='0',@pa_tab='NP',@pa_action='INS',@pa_login_name=@pa_login_name,@pa_dpm_dpid='12033200',  
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
 update tbl_ProcessSRNo set SRNO = replace(@pa_slip_no,'E','')  
 
 END
 
      
End

GO
