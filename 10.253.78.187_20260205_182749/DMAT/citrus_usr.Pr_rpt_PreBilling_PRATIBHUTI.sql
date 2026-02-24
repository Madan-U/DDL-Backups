-- Object: PROCEDURE citrus_usr.Pr_rpt_PreBilling_PRATIBHUTI
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--Pr_rpt_PreBilling 4,'OUTSTANDING','NSDL','jan 1 2009','sep 15 2009','','HO',1,'HO|*~|',''		
--Pr_rpt_PreBilling 4,'OUTSTANDING','NSDL','sep 1 2009','sep 15 2009','','HO',1,'HO|*~|',''	
--Pr_rpt_PreBilling 4,'UPFRONT COLLECTION_INWCLIENT','NSDL','apr 1 2001','apr 9 2009','123','HO',1,'',''  
--Pr_rpt_PreBilling 3,'CLIENTWITHEMAIL','CDSL','01/04/2009','09/04/2009','','CLIENT',1,'',''  
--Pr_rpt_PreBilling '3','TRXWISE','CDSL','01/01/2009','04/04/2010','DETAILS|1234567800000176','client',1,'',''	
--Pr_rpt_PreBilling '3','UPFRONT COLLECTION_INWCLIENT','CDSL','5/11/2006 12:00:00 AM','5/11/2009 11:59:59 PM','','HO',1,'',''	
--fn_createheirarchy_update  
CREATE proc [citrus_usr].[Pr_rpt_PreBilling_PRATIBHUTI]  
(@PA_EXCSMID   INT  
,@PA_TAB varchar(25)        
,@PA_DP_TYPE VARCHAR(10)        
,@PA_FROM_DT DATETIME  
,@PA_TO_DT DATETIME        
,@PA_ISIN VARCHAR(50)  
,@Pa_groupby varchar(20) -- entity_type code     
,@pa_login_pr_entm_id numeric                                        
,@pa_login_entm_cd_chain  varchar(8000)        
,@pa_output    varchar(20) OUT      
)        
as        
begin  

SET DATEFORMAT DMY 
declare @@dpmid int,  
@@finid int,  
@@ssql varchar(8000),  
@@l_child_entm_id BIGINT,  
@@chequeno varchar(30),  
@@acctno varchar(50),  
@@Bankname varchar(500),  
@@clientname varchar(250)  
  
 select convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd into #account_properties 
  from account_properties 
  where accp_accpm_prop_cd = 'BILL_START_DT' 
  and isnull(ltrim(rtrim(accp_value)) ,'') not in ( '','//','/  /','/  /')
  and substring(accp_value,1,2) <> '00' 

  
select @@dpmid= dpm_id from dp_mstr where default_dp = @PA_EXCSMID and dpm_deleted_ind =1                
set dateformat dmy                     
  
IF   @PA_TAB = 'MISSINGPROFILES'     
BEGIN    
  
 set dateformat dmy    
 select dpam_sba_no,dpam_sba_name,stam_desc,Activation_date= ISNULL(ACCP_VALUE ,'')  
 from dp_acct_mstr LEFT OUTER JOIN ACCOUNT_PROPERTIES ON DPAM_ID = ACCP_CLISBA_ID AND ACCP_ACCPM_PROP_CD = 'BILL_START_DT'    
   ,status_mstr   
 where dpam_stam_cd =stam_cd and not exists  
 (select clidb_dpam_id from client_dp_brkg where clidb_dpam_id = dpam_id and @pa_from_dt between clidb_eff_from_dt and isnull(clidb_eff_to_dt,'dec 31 2100') and clidb_deleted_ind = 1)  
    and dpam_dpm_id = @@dpmid  
 and isnull(@pa_from_dt,'jan  1 1900') >= case when isdate(citrus_usr.fn_ucc_accp(dpam_id ,'BILL_START_DT','')) = 1 then convert(datetime,citrus_usr.fn_ucc_accp(dpam_id ,'BILL_START_DT',''),103) else 'jan  1 1900' end  
 and dpam_deleted_ind = 1  
 and stam_deleted_ind = 1  
  
END  
  
  
select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                        
CREATE TABLE #ACLIST(dpam_crn_no BIGINT,dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME,group_cd bigint)  
INSERT INTO #ACLIST(dpam_crn_no,dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to)   
SELECT dpam_crn_no, DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO   
FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)    
  
    
 select @@ssql  = citrus_usr.fn_createheirarchy_update('#ACLIST',@Pa_groupby) 
print @@ssql 
 EXEC(@@ssql)  
  
  
IF   @PA_TAB = 'TRXWISE'     
   BEGIN    
   --    
     IF @PA_DP_TYPE ='NSDL'        
     BEGIN     
          
   create table #tmpnsdl(trans_type int,NSDHM_TRANSACTION_DT datetime,nsdhm_dpam_id bigint,nsdhm_qty numeric(18,3),NSDHM_ISIN varchar(12),NSDHM_BOOK_NAAR_CD varchar(3),nsdhm_dpm_trans_no varchar(12),Ben_acct_type varchar(3),nsdhm_charge numeric(18,2),BEN_ACCT_NO varchar(16))    
      
   insert into #tmpnsdl    
   select 0,nsdhm_transaction_dt,nsdhm_dpam_id,    
   nsdhm_qty,NSDHM_ISIN,NSDHM_BOOK_NAAR_CD,nsdhm_dpm_trans_no,NSDHM_BEN_ACCT_TYPE,nsdhm_charge,NSDHM_BEN_ACCT_NO     
   from nsdl_holding_dtls with(nolock)     
   where nsdhm_transaction_dt between  @pa_from_dt and  @pa_to_dt and nsdhm_dpm_id =  @@dpmid  
   and NSDHM_BEN_ACCT_TYPE not in(30,40,12,13)  
   --and   ((NSDHM_BEN_ACCT_TYPE in ('10','11','30')) or (NSDHM_BEN_ACCT_TYPE = '14' and nsdhm_book_naar_cd = '093'))  
  
  
   delete from #tmpnsdl where   
   not exists(select CODD_TRX_NO from cod_dtls c   
   where convert(varchar(11),nsdhm_transaction_dt,109)  = convert(varchar(11),CODD_STATUS_CHNG_DTTIME,109)  
   and nsdhm_dpm_trans_no = CODD_TRX_NO  
   and CODD_ORD_STATUS_TO = '31'  
   and BEN_ACCT_NO = codd_clt_id  
   )  
   and NSDHM_BOOK_NAAR_CD = '051'  
  
   -- condition for pledge account type = 14 as the records also come in individual account type  
   delete from #tmpnsdl where Ben_acct_type = '14' and nsdhm_book_naar_cd <> '093'  
   -- condition for pledge account type = 14 as the records also come in individual account type  
  
         
      
      IF @Pa_groupby <> 'CLIENT'  
      BEGIN  
     select NSDHM_BOOK_NAAR_CD CD,TRANS.DESCP Descp,trans_count=count(*),CONVERT(NUMERIC(18,2),isnull(sum(nsdhm_charge),0)) *-1 charges, entm_name1,group_cd from    
     (    
     select NSDHM_BOOK_NAAR_CD,nsdhm_charge,nsdhm_dpam_id  
     from #tmpnsdl --where trans_type = 1    
     ) tmp   
     ,citrus_usr.fn_getsubtransdtls('NARR_CODE') TRANS  
     ,#ACLIST cli_list  
     ,entity_mstr   
     WHERE TMP.NSDHM_BOOK_NAAR_CD = TRANS.CD  
     and   cli_list.dpam_id  = tmp.nsdhm_dpam_id  
     and   cli_list.group_cd = entm_id  
     group by entm_name1,group_cd,TRANS.DESCP,NSDHM_BOOK_NAAR_CD    
     Union  
     select CLIC_CHARGE_NAME,CLIC_CHARGE_NAME,count(*),CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1 charges,entm_name1,group_cd  
     from client_charges_nsdl tmp  
     ,#ACLIST cli_list  
     ,entity_mstr   
     where CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt   
     and   cli_list.dpam_id  = tmp.CLIC_DPAM_ID  
     and   cli_list.group_cd = entm_id  
     and clic_dpm_id =  @@dpmid    
     and CLIC_CHARGE_AMT <> 0 and CLIC_CHARGE_NAME <> 'TRANSACTION CHARGES'  
     AND CLIC_DELETED_IND = 1  
     group by entm_name1,group_cd,CLIC_CHARGE_NAME  
     order by entm_name1,group_cd  
   END  
   ELSE  
   BEGIN  
     select NSDHM_BOOK_NAAR_CD CD,TRANS.DESCP Descp,trans_count=count(*),CONVERT(NUMERIC(18,2),isnull(sum(nsdhm_charge),0)) *-1 charges, entm_name1=DPAM_SBA_NAME + ' - ' + DPAM_SBA_NO  from    
     (    
     select NSDHM_BOOK_NAAR_CD,nsdhm_charge,nsdhm_dpam_id  
     from #tmpnsdl --where trans_type = 1    
     ) tmp   
     ,citrus_usr.fn_getsubtransdtls('NARR_CODE') TRANS  
     ,#ACLIST cli_list  
     WHERE TMP.NSDHM_BOOK_NAAR_CD = TRANS.CD  
     and   cli_list.dpam_id  = tmp.nsdhm_dpam_id  
     group by DPAM_SBA_NAME,DPAM_SBA_NO,TRANS.DESCP,NSDHM_BOOK_NAAR_CD    
     Union  
     select CLIC_CHARGE_NAME,CLIC_CHARGE_NAME,count(*),CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1 charges,entm_name1=DPAM_SBA_NAME + ' - ' + DPAM_SBA_NO  
     from client_charges_nsdl tmp  
     ,#ACLIST cli_list  
     where CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt   
     and   cli_list.dpam_id  = tmp.CLIC_DPAM_ID  
     and clic_dpm_id =  @@dpmid    
     and CLIC_CHARGE_AMT <> 0 and CLIC_CHARGE_NAME <> 'TRANSACTION CHARGES'  
     AND CLIC_DELETED_IND = 1  
     group by DPAM_SBA_NAME,DPAM_SBA_NO,CLIC_CHARGE_NAME  
     order by entm_name1  
  
   END  
            
     truncate table #tmpnsdl    
     drop table #tmpnsdl    
          
    
     END    
     ELSE    
     BEGIN    
  
	declare @l_servicetax numeric(10,2)

    select top 1 @l_servicetax  = cham_charge_value from charge_mstr where cham_slab_name like '%service%' order by CHAM_SLAB_NO desc

      IF @Pa_groupby <> 'CLIENT'  
      BEGIN  

PRINT '111'

     select cdshm_tratm_cd cd,cdshm_tratm_type_desc + ' - ' + TRANS.DESCP descp,trans_count=count(*),CONVERT(NUMERIC(18,2),isnull(sum(cdshm_charge),0)) *-1 charges , entm_name1,group_cd , CONVERT(NUMERIC(18,2),isnull(sum(cdshm_charge),0))*-1*@l_servicetax*0.01  servicetax,CONVERT(NUMERIC(18,2),isnull(sum(cdshm_charge),0)) *-1*.20*0.01  edutax,CONVERT(NUMERIC(18,2),isnull(sum(cdshm_charge),0)) *-1*.10*0.01  hedutax from    
     (    
     select  cdshm_tratm_cd,cdshm_tratm_type_desc,cdshm_charge  ,CDSHM_DPAM_ID   
     from cdsl_holding_dtls  
     where cdshm_tras_dt between @pa_from_dt and @pa_to_dt   
     and cdshm_dpm_id =  @@dpmid   
     ) tmp   
     ,#ACLIST cli_list  
     ,entity_mstr   
     ,citrus_usr.fn_getsubtransdtls('TRANS_TYPE_CDSL') TRANS    
     WHERE TMP.cdshm_tratm_cd = TRANS.CD    
     and   cli_list.dpam_id  = tmp.CDSHM_DPAM_ID  
     and   cli_list.group_cd = entm_id  
     group by cdshm_tratm_cd,TRANS.DESCP,cdshm_tratm_type_desc  ,entm_name1,group_cd  
     Union  
     select CLIC_CHARGE_NAME,CLIC_CHARGE_NAME,count(*),CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1 charges, entm_name1,group_cd, CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1*@l_servicetax*0.01  servicetax   ,CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1*.20*0.01  edutax,CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1*.10*0.01  hedutax
     from client_charges_cdsl,#ACLIST cli_list, entity_mstr  
     where  cli_list.dpam_id  =CLIC_DPAM_ID  
     and   cli_list.group_cd = entm_id  
     and CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt   
     and clic_dpm_id =  @@dpmid 
	and CLIC_CHARGE_NAME not like '%service%' 
	and CLIC_CHARGE_NAME not like '%cess%' 
     and CLIC_CHARGE_AMT <> 0 and CLIC_CHARGE_NAME <> 'TRANSACTION CHARGES'  
	 and CLIC_CHARGE_NAME NOT LIKE  '%DOCUMENTATION CHARGE%'  
     AND CLIC_DELETED_IND = 1  
     group by entm_name1,group_cd,CLIC_CHARGE_NAME  
	Union  
     select CLIC_CHARGE_NAME,CLIC_CHARGE_NAME,count(*),CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1 charges, entm_name1,group_cd, 0 servicetax     ,0  edutax,0  hedutax
     from client_charges_cdsl,#ACLIST cli_list, entity_mstr  
     where  cli_list.dpam_id  =CLIC_DPAM_ID  
     and   cli_list.group_cd = entm_id  
     and CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt   
     and clic_dpm_id =  @@dpmid 
	and CLIC_CHARGE_NAME not like '%service%' 
	And CLIC_CHARGE_NAME not like '%cess%' 
     and CLIC_CHARGE_AMT <> 0 and CLIC_CHARGE_NAME <> 'TRANSACTION CHARGES'  
	 and CLIC_CHARGE_NAME LIKE  '%DOCUMENTATION CHARGE%'  
     AND CLIC_DELETED_IND = 1  
     group by entm_name1,group_cd,CLIC_CHARGE_NAME  
     order by entm_name1,group_cd  
   END  
   ELSE  
   BEGIN  

     if CITRUS_USR.FN_SPLITVAL_BY(@PA_ISIN,1,'|')  = 'DETAILS' or @pa_isin = ''
     begin 
			 select cdshm_tratm_cd cd,cdshm_tratm_type_desc + ' - ' + TRANS.DESCP descp,trans_count=count(*),CONVERT(NUMERIC(18,2),isnull(sum(cdshm_charge),0)) *-1 charges , entm_name1=DPAM_SBA_NAME + ' - ' + DPAM_SBA_NO,  CONVERT(NUMERIC(18,2),isnull(sum(cdshm_charge),0)) *-1*@l_servicetax*0.01  servicetax ,CONVERT(NUMERIC(18,2),isnull(sum(cdshm_charge),0)) *-1*.20*0.01  edutax,CONVERT(NUMERIC(18,2),isnull(sum(cdshm_charge),0)) *-1*.10*0.01  hedutax    from    
			 (    
			 select  cdshm_tratm_cd,cdshm_tratm_type_desc,cdshm_charge  ,CDSHM_DPAM_ID   
			 from cdsl_holding_dtls  
			 where cdshm_tras_dt between @pa_from_dt and @pa_to_dt   
			 and cdshm_dpm_id =  @@dpmid   
			 ) tmp   
			 ,#ACLIST cli_list  
			 ,citrus_usr.fn_getsubtransdtls('TRANS_TYPE_CDSL') TRANS    
			 WHERE TMP.cdshm_tratm_cd = TRANS.CD    and cdshm_charge <> 0
			 and   cli_list.dpam_id  = tmp.CDSHM_DPAM_ID  AND cli_list.dpam_SBA_NO = CITRUS_USR.FN_SPLITVAL_BY(@PA_ISIN,2,'|')
			 group by cdshm_tratm_cd,TRANS.DESCP,cdshm_tratm_type_desc  ,DPAM_SBA_NAME,DPAM_SBA_NO  
			 Union  
			 select CLIC_CHARGE_NAME,CLIC_CHARGE_NAME,count(*),CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1 charges, entm_name1=DPAM_SBA_NAME + ' - ' + DPAM_SBA_NO ,CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1*@l_servicetax*0.01  servicetax  ,CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1*.20*0.01  edutax,CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1*.10*0.01  hedutax       
			 from client_charges_cdsl,#ACLIST cli_list  
			 where  cli_list.dpam_id  =CLIC_DPAM_ID  
			 and CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt   
			 and clic_dpm_id =  @@dpmid  
			and CLIC_CHARGE_NAME not like '%service%' 
			and CLIC_CHARGE_NAME not like '%cess%'	
			 and CLIC_CHARGE_AMT <> 0 and CLIC_CHARGE_NAME <> 'TRANSACTION CHARGES'  
			and CLIC_CHARGE_NAME NOT LIKE  '%DOCUMENTATION CHARGE%'  
			 AND CLIC_DELETED_IND = 1  AND cli_list.dpam_SBA_NO = CITRUS_USR.FN_SPLITVAL_BY(@PA_ISIN,2,'|')
			 group by DPAM_SBA_NAME,DPAM_SBA_NO,CLIC_CHARGE_NAME  
				Union  
			 select CLIC_CHARGE_NAME,CLIC_CHARGE_NAME,count(*),CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1 charges, entm_name1=DPAM_SBA_NAME + ' - ' + DPAM_SBA_NO ,0 servicetax     ,0  edutax,0  hedutax
			 from client_charges_cdsl,#ACLIST cli_list  
			 where  cli_list.dpam_id  =CLIC_DPAM_ID  
			 and CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt   
			 and clic_dpm_id =  @@dpmid  
			and CLIC_CHARGE_NAME not like '%service%' 
			and CLIC_CHARGE_NAME not like '%cess%'	
			 and CLIC_CHARGE_AMT <> 0 and CLIC_CHARGE_NAME <> 'TRANSACTION CHARGES'  
			and CLIC_CHARGE_NAME LIKE  '%DOCUMENTATION CHARGE%'  
			 AND CLIC_DELETED_IND = 1  AND cli_list.dpam_SBA_NO = CITRUS_USR.FN_SPLITVAL_BY(@PA_ISIN,2,'|')
			 group by DPAM_SBA_NAME,DPAM_SBA_NO,CLIC_CHARGE_NAME  
			 order by entm_name1 
      END 
      ELSE 
      BEGIN

--SELECT @pa_from_dt ,@pa_to_dt   

            select DPAM_SBA_NO ,DPAM_SBA_NAME ,  CONVERT(NUMERIC(18,2),isnull(sum(cdshm_charge),0)) *-1 charges ,isnull(sum(cdshm_charge),0) *-1*@l_servicetax*0.01  servicetax,CONVERT(NUMERIC(18,2),isnull(sum(cdshm_charge),0)) *-1*.20*0.01  edutax,CONVERT(NUMERIC(18,2),isnull(sum(cdshm_charge),0)) *-1*.10*0.01  hedutax    from    
			 (    
			 select  cdshm_tratm_cd,cdshm_tratm_type_desc,cdshm_charge  ,CDSHM_DPAM_ID   
			 from cdsl_holding_dtls  
			 where cdshm_tras_dt between @pa_from_dt and @pa_to_dt   
			 and cdshm_dpm_id =  @@dpmid   
			 ) tmp   
			 ,#ACLIST cli_list  
			 ,citrus_usr.fn_getsubtransdtls('TRANS_TYPE_CDSL') TRANS    
			 WHERE TMP.cdshm_tratm_cd = TRANS.CD    and cdshm_charge <> 0 
			 and   cli_list.dpam_id  = tmp.CDSHM_DPAM_ID  
			 group by DPAM_SBA_NAME,DPAM_SBA_NO  
			 Union  
			 select DPAM_SBA_NO , DPAM_SBA_NAME ,CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1 charges,CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1*@l_servicetax*0.01  servicetax     ,CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1*.20*0.01  edutax,CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1*.10*0.01  hedutax
			 from client_charges_cdsl,#ACLIST cli_list  
			 where  cli_list.dpam_id  =CLIC_DPAM_ID  
			 and CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt   
			 and clic_dpm_id =  @@dpmid  
			and CLIC_CHARGE_NAME not like '%service%' 
			and CLIC_CHARGE_NAME not like '%cess%' 
			 and CLIC_CHARGE_AMT <> 0 and CLIC_CHARGE_NAME <> 'TRANSACTION CHARGES'  
			and CLIC_CHARGE_NAME NOT LIKE  '%DOCUMENTATION CHARGE%'  
			 AND CLIC_DELETED_IND = 1  
			 group by DPAM_SBA_NAME,DPAM_SBA_NO
				Union  
			 select DPAM_SBA_NO , DPAM_SBA_NAME ,CONVERT(NUMERIC(18,2),isnull(sum(CLIC_CHARGE_AMT),0)) *-1 charges,0 servicetax     ,0  edutax,0  hedutax
			 from client_charges_cdsl,#ACLIST cli_list  
			 where  cli_list.dpam_id  =CLIC_DPAM_ID  
			 and CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt   
			 and clic_dpm_id =  @@dpmid  
			and CLIC_CHARGE_NAME not like '%service%' 
			and CLIC_CHARGE_NAME not like '%cess%' 
			 and CLIC_CHARGE_AMT <> 0 and CLIC_CHARGE_NAME <> 'TRANSACTION CHARGES'  
			and CLIC_CHARGE_NAME LIKE  '%DOCUMENTATION CHARGE%'  
			 AND CLIC_DELETED_IND = 1  
			 group by DPAM_SBA_NAME,DPAM_SBA_NO

			 
	  END 
 
  
   END  
  
  
  
  
     END    
   --     
   END  
  
   IF   @PA_TAB = 'CLIENTMKRCHKR'     
   BEGIN    
   --    
  IF @Pa_groupby <> 'CLIENT'  
   BEGIN  
    Select dpam.dpam_sba_no,dpam.dpam_sba_name,Convert(varchar(20),dpam_created_dt,109) dpam_created_dt,dpam_created_by,Convert(varchar(20),dpam_lst_upd_dt,109) dpam_lst_upd_dt,dpam_lst_upd_by,entm_name1,group_cd  
                ,citrus_usr.fn_conc_value(dpam.DPAM_CRN_NO,'MOBILE1') mobile  
                ,citrus_usr.fn_conc_value(dpam.DPAM_CRN_NO,'email1') email  
                ,isnull(citrus_usr.fn_find_relations_nm(dpam.dpam_crn_no,'BR'),'') branch  
    from dp_acct_mstr dpam,#ACLIST cli_list, entity_mstr, #account_properties accp 
    where dpam.dpam_id = accp.accp_clisba_id and accp_value between @pa_from_dt and @pa_to_dt   
    and dpam.dpam_id = cli_list.dpam_id    
    and   cli_list.group_cd = entm_id  
    and accp_value between eff_from and eff_to  
    and dpam_deleted_ind = 1  
                and dpam.dpam_dpm_id =  @@dpmid  
    order by group_cd,entm_name1,dpam_created_dt,dpam.dpam_sba_no,dpam.dpam_sba_name  
   end  
   else  
   begin  
    Select dpam_sba_no,dpam_sba_name,dpam_created_dt,Convert(varchar(20),dpam_created_by,109) dpam_created_by,Convert(varchar(20),dpam_lst_upd_dt,109) dpam_lst_upd_dt,dpam_lst_upd_by,entm_name1='',group_cd=''  
                ,citrus_usr.fn_conc_value(dpam_crn_no,'MOBILE1') mobile  
                ,citrus_usr.fn_conc_value(dpam_crn_no,'email1') email  
                ,isnull(citrus_usr.fn_find_relations_nm(dpam.dpam_crn_no,'BR'),'') branch  
    from dp_acct_mstr dpam  , #account_properties accp 
    where dpam.dpam_id = accp.accp_clisba_id and accp_value between @pa_from_dt and @pa_to_dt 
    and dpam_deleted_ind = 1  
                and dpam_dpm_id =  @@dpmid  
    order by accp_value,dpam_sba_no,dpam_sba_name  
   end  
   --  
   END  
   IF   @PA_TAB = 'CHKWTHOUTMBL'     
   BEGIN    
   --  
	  select dpam_sba_no, dpam_sba_name, citrus_usr.[fn_find_relations_nm](DPAM_CRN_NO,'BR')  entm_name1
	  from dp_acct_mstr 
	  where dpam_created_dt between @pa_from_dt and @pa_to_dt   
      and  isnull(citrus_usr.fn_conc_value(dpam_crn_no,'mobile1'),'')=''
      and dpam_deleted_ind = 1  
      and dpam_dpm_id =  @@dpmid  
   --
   END
   IF   @PA_TAB = 'CREDITS'     
   BEGIN    
   --    
  
   select @@finId = isnull(fin_id,0) from financial_yr_mstr where FIN_DPM_ID = @@dpmid AND @PA_TO_DT between fin_start_dt and fin_end_dt and fin_deleted_ind = 1  
  
  
      IF @Pa_groupby <> 'CLIENT'  
   BEGIN  
     set @@ssql = 'select Credit_cnt=count(*),Cr_amt=sum(abs(ldg_amount)),entm_name1 from ledger' + convert(varchar,@@finId) + ' ,#ACLIST cli_list  
     ,entity_mstr    
     where ldg_Voucher_dt between ''' + convert(varchar(11),@pa_from_dt,109) + ''' and ''' + convert(varchar(11),@pa_to_dt,109) + ' 23:59:59''  
     and ldg_dpm_id = ' + convert(varchar,@@dpmid) + '  
     and ldg_voucher_type = 2  
     and LDG_ACCOUNT_ID = dpam_id  
     and ldg_voucher_dt between eff_from and eff_to  
     and group_cd = entm_id  
     and LDG_ACCOUNT_TYPE = ''P''  
     and ldg_deleted_ind = 1  
     and ldg_amount > 0   
     group by group_cd,entm_name1  
     order by entm_name1,group_cd'  
  
   END  
   ELSE  
   BEGIN  
     set @@ssql = 'select Credit_cnt=count(*),Cr_amt=sum(abs(ldg_amount)),entm_name1=DPAM_SBA_NAME + '' - '' + DPAM_SBA_NO from ledger' + convert(varchar,@@finId) + ' ,#ACLIST cli_list  
     where ldg_Voucher_dt between ''' + convert(varchar(11),@pa_from_dt,109) + ''' and ''' + convert(varchar(11),@pa_to_dt,109) + ' 23:59:59''  
     and ldg_dpm_id = ' + convert(varchar,@@dpmid) + '  
     and ldg_voucher_type = 2  
     and LDG_ACCOUNT_ID = dpam_id  
     and ldg_voucher_dt between eff_from and eff_to  
     and LDG_ACCOUNT_TYPE = ''P''  
     and ldg_deleted_ind = 1  
     and ldg_amount > 0 group by DPAM_SBA_NAME,DPAM_SBA_NO'  
  
   END  
     Exec(@@ssql)  
   --     
   END  
  
   IF   @PA_TAB = 'CREDITDETAILS'     
   BEGIN    
   --    
  
   IF @Pa_groupby <> 'CLIENT'
			BEGIN



                select Cr_amt=sum(Cr_amt),client_name+'('+acctno+')' client_name,chequeno,Bankname,entm_name1='',group_cd='', created_dt , created_by
                from (  
				Select dpam.dpam_sba_name client_name,dpam.dpam_sba_no acctno,case when isnull(inwsr_cheque_no,'') = '' then 'CASH' else inwsr_cheque_no end chequeno, isnull(inwsr_clibank_name,'') Bankname ,Convert(varchar(20),INWSR_CREATED_DT,109) created_dt,INWSR_CREATED_BY created_by,entm_name1,group_cd,inwsr_ufcharge_collected Cr_amt
              	from dp_acct_mstr dpam,#ACLIST cli_list, entity_mstr , INWARD_SLIP_REG
				where INWSR_CREATED_DT between @pa_from_dt and @pa_to_dt 
				and dpam.dpam_id = cli_list.dpam_id  and INWSR_DPAM_ID = dpam.dpam_id 
				and   cli_list.group_cd = entm_id
				and INWSR_CREATED_DT between eff_from and eff_to
				and dpam_deleted_ind = 1
                and dpam.dpam_dpm_id =  @@dpmid
                union
                Select dpam.dpam_sba_name client_name,dpam.dpam_sba_no acctno,case when isnull(INWCR_cheque_no,'') = '' then 'CASH' else INWCR_cheque_no end chequeno, isnull(inwcr_clibank_name,'') Bankname ,Convert(varchar(20),inwcr_created_dt,109) created_dt,inwcr_created_by created_by,entm_name1,group_cd,inwcr_charge_collected Cr_amt
              	from dp_acct_mstr dpam,#ACLIST cli_list, entity_mstr , inw_client_reg
				where inwcr_created_dt between @pa_from_dt and @pa_to_dt 
				and dpam.dpam_id = cli_list.dpam_id  and inwcr_frmno = dpam.dpam_sba_no 
    and  inwcr_deleted_ind = 1
				and   cli_list.group_cd = entm_id
				and inwcr_created_dt between eff_from and eff_to
				and dpam_deleted_ind = 1
                and dpam.dpam_dpm_id =  @@dpmid ) a 
                group by client_name,acctno,entm_name1,chequeno,Bankname,group_cd, created_dt , created_by
				order by group_cd,entm_name1,created_dt,a.client_name

				
			end
			else
			begin
                select Cr_amt=sum(Cr_amt),client_name+'('+acctno+')' client_name,chequeno,Bankname,entm_name1='',group_cd='', created_dt , created_by
                from (  
				Select dpam_sba_name client_name,dpam.dpam_sba_no acctno,case when isnull(inwsr_cheque_no,'') = '' then 'CASH' else inwsr_cheque_no end chequeno, isnull(inwsr_clibank_name,'') Bankname,Convert(varchar(20),INWSR_CREATED_DT,109) created_dt,INWSR_CREATED_BY created_by,entm_name1='',group_cd='',inwsr_ufcharge_collected Cr_amt
                from dp_acct_mstr dpam , INWARD_SLIP_REG
				where INWSR_DPAM_ID = dpam_id   and  INWSR_DELETED_IND = 1 and INWSR_CREATED_DT between @pa_from_dt and @pa_to_dt 
				and dpam_deleted_ind = 1
                and dpam_dpm_id =  @@dpmid
				union
				Select dpam_sba_name client_name,dpam.dpam_sba_no acctno,case when isnull(INWCR_cheque_no,'') = '' then 'CASH' else INWCR_cheque_no end chequeno, isnull(inwcr_clibank_name,'') Bankname,Convert(varchar(20),inwcr_created_dt,109) created_dt,inwcr_created_by created_by,entm_name1='',group_cd='',inwcr_charge_collected Cr_amt
                from dp_acct_mstr dpam , inw_client_reg
				where inwcr_frmno = dpam.dpam_sba_no    and  inwcr_deleted_ind = 1 and inwcr_created_dt between @pa_from_dt and @pa_to_dt 
				and dpam_deleted_ind = 1
                and dpam_dpm_id =  @@dpmid
				) a 
                group by client_name,acctno,entm_name1,chequeno,Bankname,group_cd, created_dt , created_by
				order by group_cd,entm_name1,created_dt,a.client_name
			end
----------------			select @@finId = isnull(fin_id,0) from financial_yr_mstr where FIN_DPM_ID = @@dpmid AND @PA_TO_DT between fin_start_dt and fin_end_dt and fin_deleted_ind = 1
----------------
----------------		    IF @Pa_groupby <> 'CLIENT'
----------------			BEGIN
----------------
----------------					create table #creditdetails(dpam_id bigint,Cr_amt money,client_name varchar(250),entm_name1 varchar(200),chequeno varchar(20),acctno varchar(30),Bankname varchar(500),group_cd bigint)
----------------					set @@ssql = 'Insert into #creditdetails(dpam_id,Cr_amt,client_name,entm_name1,chequeno,acctno,Bankname,group_cd)
----------------					select cli_list.dpam_id,Cr_amt=abs(ldg_amount),ltrim(rtrim(cli_list.dpam_sba_name)) + '' ('' + ltrim(rtrim(cli_list.dpam_sba_no)) + '')'',entm_name1,chequeno=ldg_instrument_no,ltrim(rtrim(replace(dpam.dpam_acct_no,'' '',''''))),Narration=ltrim(rtrim(ldg_narration)),group_cd 
----------------					from ledger' + convert(varchar,@@finId) + ',#ACLIST cli_list
----------------					,entity_mstr , dp_acct_mstr  dpam
----------------					where ldg_account_id = dpam.dpam_id and ldg_Voucher_dt between ''' + convert(varchar(11),@pa_from_dt,109) + ''' and ''' + convert(varchar(11),@pa_to_dt,109) + ' 23:59:59''
----------------					and ldg_dpm_id = ' + convert(varchar,@@dpmid) + '
----------------					and ldg_voucher_type = 2
----------------					and LDG_ACCOUNT_ID = dpam.dpam_id
----------------                    and dpam.dpam_id = cli_list.dpam_id
----------------					and ldg_voucher_dt between eff_from and eff_to
----------------					and group_cd = entm_id
----------------					and LDG_ACCOUNT_TYPE = ''P''
----------------					and ldg_deleted_ind = 1
----------------					and ldg_amount > 0'
----------------		
----------------					Exec(@@ssql)
----------------
----------------                   
----------------
----------------					update #creditdetails
----------------					set bankname = LTRIM(RTRIM(banm_name)) + ' ' + LTRIM(RTRIM(REPLACE(REPLACE(BANM_BRANCH,'---','-'),'--','-')))
----------------					from #creditdetails,client_bank_accts,bank_mstr
----------------					where dpam_id = cliba_clisba_id
----------------					--and cliba_ac_no = acctno
----------------					and cliba_banm_id = banm_id
----------------					and ltrim(rtrim(acctno)) <> ''
----------------					and cliba_deleted_ind = 1
----------------					and banm_deleted_ind = 1
----------------
----------------
----------------					declare rscursor  cursor for
----------------					SELECT chequeno,acctno
----------------					FROM #creditdetails
----------------					where ltrim(rtrim(isnull(chequeno,''))) <> '' and ltrim(rtrim(isnull(acctno,''))) <> ''
----------------					GROUP BY chequeno,acctno
----------------					HAVING COUNT(*) > 1
----------------					open rscursor
----------------					fetch next from rscursor into @@chequeno,@@acctno
----------------					WHILE @@Fetch_Status = 0
----------------					Begin
----------------							Select top 1 @@clientname = client_name,@@bankname = bankname   from #creditdetails where chequeno = @@chequeno and acctno = @@acctno 
----------------							update #creditdetails set client_name = @@clientname,bankname=@@bankname where chequeno = @@chequeno and acctno = @@acctno 
----------------
----------------						fetch next from rscursor into  @@chequeno,@@acctno
----------------					End
----------------					Close rscursor
----------------					Deallocate rscursor
----------------
----------------					select Cr_amt=sum(Cr_amt),client_name,entm_name1,chequeno,acctno,Bankname,group_cd
----------------					from #creditdetails
----------------					group by client_name,entm_name1,chequeno,acctno,Bankname,group_cd
----------------					order by entm_name1,group_cd,chequeno,acctno,Bankname,client_name
----------------					truncate table #creditdetails
----------------					drop table #creditdetails
----------------
----------------			END
----------------			ELSE
----------------			BEGIN
----------------
----------------					create table #creditdetailscli(dpam_id bigint,Cr_amt money,client_name varchar(250),chequeno varchar(20),acctno varchar(30),Bankname varchar(500))
----------------					set @@ssql = 'Insert into #creditdetailscli(dpam_id,Cr_amt,client_name,chequeno,acctno,Bankname)
----------------					select cli_list.dpam_id,Cr_amt=abs(ldg_amount),ltrim(rtrim(cli_list.dpam_sba_name)) + '' ('' + ltrim(rtrim(cli_list.dpam_sba_no)) + '')'',chequeno=ldg_instrument_no,ltrim(rtrim(replace(dpam.dpam_acct_no,'' '',''''))),Narration=ltrim(rtrim(ldg_narration))
----------------					from ledger' + convert(varchar,@@finId) + ',#ACLIST cli_list , dp_Acct_mstr dpam
----------------					where ldg_account_id = dpam.dpam_id and ldg_Voucher_dt between ''' + convert(varchar(11),@pa_from_dt,109) + ''' and ''' + convert(varchar(11),@pa_to_dt,109) + ' 23:59:59''
----------------					and ldg_dpm_id = ' + convert(varchar,@@dpmid) + '
----------------					and ldg_voucher_type = 2
----------------					and LDG_ACCOUNT_ID = dpam.dpam_id
----------------                    and dpam.dpam_id = cli_list.dpam_id 
----------------					and ldg_voucher_dt between eff_from and eff_to
----------------					and LDG_ACCOUNT_TYPE = ''P''
----------------					and ldg_deleted_ind = 1
----------------					and ldg_amount > 0'
----------------					Exec(@@ssql)
----------------
----------------
----------------
----------------    				update #creditdetailscli
----------------					set bankname = LTRIM(RTRIM(banm_name)) + ' ' + LTRIM(RTRIM(REPLACE(REPLACE(BANM_BRANCH,'---','-'),'--','-')))
----------------					from #creditdetailscli,client_bank_accts,bank_mstr
----------------					where dpam_id = cliba_clisba_id
----------------					--and cliba_ac_no = acctno
----------------					and cliba_banm_id = banm_id
----------------					and ltrim(rtrim(acctno)) <> ''
----------------					and cliba_deleted_ind = 1
----------------					and banm_deleted_ind = 1
----------------
----------------
----------------					declare rscursor  cursor for
----------------					SELECT chequeno,acctno
----------------					FROM #creditdetailscli
----------------					GROUP BY chequeno,acctno
----------------					HAVING COUNT(*) > 1
----------------					open rscursor
----------------					fetch next from rscursor into @@chequeno,@@acctno
----------------					WHILE @@Fetch_Status = 0
----------------					Begin
----------------							Select top 1 @@clientname = client_name,@@bankname = bankname   from #creditdetailscli where chequeno = @@chequeno and acctno = @@acctno 
----------------							update #creditdetailscli set client_name = @@clientname,bankname=@@bankname where chequeno = @@chequeno and acctno = @@acctno 
----------------
----------------						fetch next from rscursor into  @@chequeno,@@acctno
----------------					End
----------------					Close rscursor
----------------					Deallocate rscursor
----------------
----------------
----------------
----------------
----------------					select Cr_amt=sum(Cr_amt),client_name,chequeno,acctno,Bankname,entm_name1='',group_cd=''
----------------					from #creditdetailscli
----------------					group by client_name,chequeno,acctno,Bankname
----------------					order by chequeno,acctno,Bankname,client_name
----------------
----------------
----------------					truncate table #creditdetailscli
----------------					drop table #creditdetailscli
----------------
----------------			END
  
   --     
   END  
  
    
   IF   @PA_TAB = 'OUTSTANDING'     
   BEGIN    
   --    
  select @@finId = isnull(fin_id,0) from financial_yr_mstr where FIN_DPM_ID = @@dpmid AND @PA_TO_DT between fin_start_dt and fin_end_dt and fin_deleted_ind = 1  
  
  

  
      IF @Pa_groupby <> 'CLIENT'  
   BEGIN    
     set @@ssql = 'select entm_name1,Client_cnt=count(Distinct LDG_ACCOUNT_ID),OUTSTANDINGAMT= isnull(sum(ldg_amount),0) from ledger' + convert(varchar,@@finId) + '  
      ,#ACLIST cli_list  
     ,entity_mstr   
     where ldg_Voucher_dt <= ''' + convert(varchar(11),@pa_to_dt,109) + ' 23:59:59''  
     and ldg_dpm_id = ' + convert(varchar,@@dpmid) + '  
     and ldg_deleted_ind = 1  
     and LDG_ACCOUNT_ID = dpam_id  
     and ldg_voucher_dt between eff_from and eff_to  
     and group_cd = entm_id  
     and ldg_account_type = ''P''   
     group by  entm_name1,group_cd'  
   END  
   ELSE  
   BEGIN  
     set @@ssql = 'select entm_name1=DPAM_SBA_NAME + '' - '' + DPAM_SBA_NO,Client_cnt=1,OUTSTANDINGAMT= isnull(sum(ldg_amount),0) from ledger' + convert(varchar,@@finId) + '  
      ,#ACLIST cli_list  
     where ldg_Voucher_dt <= ''' + convert(varchar(11),@pa_to_dt,109) + ' 23:59:59''  
     and ldg_dpm_id = ' + convert(varchar,@@dpmid) + '  
     and ldg_deleted_ind = 1  
     and LDG_ACCOUNT_ID = dpam_id  
     and ldg_voucher_dt between eff_from and eff_to  
     and ldg_account_type = ''P''   
     group by  DPAM_SBA_NAME,DPAM_SBA_NO'  
   END 

  Exec(@@ssql)  
   --     
   END   
  
  
  
   IF   @PA_TAB = 'COLLECTION_MIS'     
   BEGIN  
   --    
  
  SET @@finId = 0  
  SELECT @@finId = ISNULL(FIN_ID,0) FROM FINANCIAL_YR_MSTR WHERE FIN_DPM_ID = @@dpmid AND (@PA_FROM_DT BETWEEN FIN_START_DT AND FIN_END_DT) AND (@PA_TO_DT BETWEEN FIN_START_DT AND FIN_END_DT) AND FIN_DELETED_IND = 1   
  IF @@finId <> 0  
  BEGIN  
     CREATE TABLE #TMP(ACCT_ID BIGINT,ACCT_TYPE CHAR(1),V_DATE DATETIME,V_TYPE INT,V_NO BIGINT,SR_NO INT,AMT MONEY,CHEQUE_NO VARCHAR(20),CTR_ACC_TYPE CHAR(1),WAIVER_AMT MONEY,AUTOCR_AMT MONEY)  
     set @@ssql = 'INSERT INTO #TMP(ACCT_ID,ACCT_TYPE,V_DATE,V_TYPE,V_NO,SR_NO,AMT,CHEQUE_NO)  
     SELECT LDG_ACCOUNT_ID,LDG_ACCOUNT_TYPE,LDG_VOUCHER_DT,LDG_VOUCHER_TYPE,LDG_VOUCHER_NO,LDG_SR_NO,LDG_AMOUNT,LDG_INSTRUMENT_NO  
     FROM LEDGER' + CONVERT(VARCHAR,@@finId) + '  
     WHERE LDG_DPM_ID = ' + CONVERT(VARCHAR,@@dpmid) + '   
     AND LDG_VOUCHER_DT BETWEEN ''' + CONVERT(VARCHAR(11),@PA_FROM_DT,109) + ''' AND ''' + CONVERT(VARCHAR(11),@PA_TO_DT,109) + ' 23:59:59''  
     AND LDG_VOUCHER_TYPE = 2   
     AND LDG_TRANS_TYPE <> ''O''  
     AND LDG_DELETED_IND = 1'  
     EXEC(@@ssql)  
  
  
  
     UPDATE #TMP SET CTR_ACC_TYPE = ISNULL((SELECT ACCT_TYPE FROM #TMP T WHERE T.V_DATE = T1.V_DATE AND T.V_TYPE = T1.V_TYPE AND T.V_NO = T1.V_NO AND T.SR_NO = 1),0)  
     FROM #TMP T1  
  
  
  
     set @@ssql = 'INSERT INTO #TMP(ACCT_ID,ACCT_TYPE,AUTOCR_AMT,V_DATE)  
     SELECT LDG_ACCOUNT_ID,''P'',LDG_AMOUNT,LDG_VOUCHER_DT  
     FROM LEDGER' + CONVERT(VARCHAR,@@finId) + '  
     WHERE LDG_DPM_ID = ' + CONVERT(VARCHAR,@@dpmid) + '   
     AND LDG_VOUCHER_DT BETWEEN ''' + CONVERT(VARCHAR(11),@PA_FROM_DT,109) + ''' AND ''' + CONVERT(VARCHAR(11),@PA_TO_DT,109) + ' 23:59:59''  
     AND LDG_VOUCHER_TYPE = 3  
     and LDG_ACCOUNT_TYPE = ''P''   
     AND LDG_TRANS_TYPE = ''AC''  
     AND LDG_DELETED_IND = 1'  
     EXEC(@@ssql)  
  
  
     IF @PA_DP_TYPE = 'CDSL'  
     BEGIN  
      INSERT INTO #TMP(ACCT_ID,ACCT_TYPE,WAIVER_AMT,V_DATE)  
      SELECT CLIC_DPAM_ID ,'P',ABS(ISNULL(CLIC_CHARGE_AMT,0)),CLIC_TRANS_DT  
      FROM CLIENT_CHARGES_CDSL   
      WHERE CLIC_DPM_ID = @@dpmid   
      AND CLIC_TRANS_DT BETWEEN  @PA_FROM_DT AND @PA_TO_DT   
      AND CLIC_CHARGE_AMT > 0 AND CLIC_FLG <> 'S'  
      AND CLIC_DELETED_IND =1   
     END  
     ELSE  
     BEGIN  
      INSERT INTO #TMP(ACCT_ID,ACCT_TYPE,WAIVER_AMT,V_DATE)  
      SELECT CLIC_DPAM_ID ,'P',ABS(ISNULL(CLIC_CHARGE_AMT,0)),CLIC_TRANS_DT  
      FROM CLIENT_CHARGES_NSDL  
      WHERE CLIC_DPM_ID = @@dpmid   
      AND CLIC_TRANS_DT BETWEEN  @PA_FROM_DT AND @PA_TO_DT   
      AND CLIC_CHARGE_AMT > 0 AND CLIC_FLG <> 'S'  
      AND CLIC_DELETED_IND =1   
     END  
  
      IF @Pa_groupby <> 'CLIENT'  
   BEGIN  
  
     SELECT entm_name1,group_cd,CASH_AMT=SUM(ABS(CASE WHEN ISNULL(CTR_ACC_TYPE,'') = 'C' THEN ISNULL(AMT,0) ELSE 0 END))   
     + SUM(ABS(CASE WHEN ISNULL(CTR_ACC_TYPE,'') = 'B' AND LTRIM(RTRIM(ISNULL(CHEQUE_NO,''))) = '' THEN ISNULL(AMT,0) ELSE 0 END)),  
     CHEQUE_AMT= SUM(ABS(CASE WHEN ISNULL(CTR_ACC_TYPE,'') = 'B' AND LTRIM(RTRIM(ISNULL(CHEQUE_NO,''))) <> '' THEN ISNULL(AMT,0) ELSE 0 END)),  
     WAIVER = SUM(ISNULL(WAIVER_AMT,0)),AUTOCREDIT=SUM(ISNULL(AUTOCR_AMT,0)),ret_val = ''  
     FROM #TMP,#ACLIST,entity_mstr  
     WHERE ACCT_ID = DPAM_ID   
     and V_DATE between eff_from and eff_to  
     and group_cd = entm_id  
     and entm_deleted_ind = 1  
     AND SR_NO <> 1  
     GROUP BY group_cd,entm_name1  
   END  
   ELSE  
   BEGIN  
     SELECT entm_name1=DPAM_SBA_NAME + ' - ' + DPAM_SBA_NO,CASH_AMT=SUM(ABS(CASE WHEN ISNULL(CTR_ACC_TYPE,'') = 'C' THEN ISNULL(AMT,0) ELSE 0 END))   
     + SUM(ABS(CASE WHEN ISNULL(CTR_ACC_TYPE,'') = 'B' AND LTRIM(RTRIM(ISNULL(CHEQUE_NO,''))) = '' THEN ISNULL(AMT,0) ELSE 0 END)),  
     CHEQUE_AMT= SUM(ABS(CASE WHEN ISNULL(CTR_ACC_TYPE,'') = 'B' AND LTRIM(RTRIM(ISNULL(CHEQUE_NO,''))) <> '' THEN ISNULL(AMT,0) ELSE 0 END)),  
     WAIVER = SUM(ISNULL(WAIVER_AMT,0)),AUTOCREDIT=SUM(ISNULL(AUTOCR_AMT,0)),ret_val = ''  
     FROM #TMP,#ACLIST  
     WHERE ACCT_ID = DPAM_ID   
     and V_DATE between eff_from and eff_to  
     AND SR_NO <> 1  
     GROUP BY DPAM_SBA_NAME,DPAM_SBA_NO  
   END  
  END  
  ELSE  
  BEGIN  
    
    SELECT RET_VAL ='FINYEARPROBLEM'  
  END  
  
     
  
   --  
   END  
  
   IF   @PA_TAB = 'UPFRONT COLLECTION_INWSLIP'     
   BEGIN  
   --    
    CREATE TABLE #TMPCOLL(DPAM_ID BIGINT,CHARGE_COLLECTED NUMERIC(18,2),COLLECTION_TYPE VARCHAR(10),MODULE CHAR(1),recd_dt datetime,created_by varchar(30),cheque_no varchar(50), bank_name varchar(1000))  
      
    INSERT INTO #TMPCOLL(DPAM_ID,CHARGE_COLLECTED,COLLECTION_TYPE,MODULE,recd_dt,created_by,cheque_no,bank_name)  
    SELECT DPAM_ID=INWSR_DPAM_ID,CHARGE_COLLECTED=ISNULL(inwsr_ufcharge_collected,0),COLLECTION_TYPE=ISNULL(inwsr_PAY_MODE,''),'T',INWSR_RECD_DT,inwsr_lst_upd_by,isnull(inwsr_cheque_no,'') , isnull(inwsr_clibank_name,'')FINA_ACC_NAME 
    FROM INWARD_SLIP_REG left outer join FIN_ACCOUNT_MSTR on FINA_ACC_ID = isnull(inwsr_bankid,0)  
    WHERE ISNULL(inwsr_ufcharge_collected,0) <> 0  
    AND INWSR_RECD_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT   
    AND INWSR_DPM_ID= @@dpmid   
    AND INWSR_DELETED_IND = 1   
  
--    INSERT INTO #TMPCOLL(DPAM_ID,CHARGE_COLLECTED,COLLECTION_TYPE,MODULE,recd_dt,created_by,cheque_no,bank_name)  
--    SELECT DPAM_ID,CHARGE_COLLECTED=ISNULL(inwcr_charge_collected,0),COLLECTION_TYPE=ISNULL(INWCR_PAY_MODE,''),'A',INWCR_RECVD_DT,inwcr_lst_upd_by,isnull(INWCR_cheque_no,'') , isnull(FINA_ACC_NAME,'')   
--    FROM inw_client_reg left outer join FIN_ACCOUNT_MSTR on FINA_ACC_ID = isnull(INWCR_BANK_ID,0)   
--                , DP_ACCT_MSTR  
--    WHERE inwcr_frmno =  DPAM_ACCT_NO  
--    AND INWCR_RECVD_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT   
--    AND ISNULL(inwcr_charge_collected,0) <> 0  
--    AND inwcr_dmpdpid= @@dpmid   
--    AND inwcr_deleted_ind = 1   
--    AND DPAM_DELETED_IND =1  
  
/*  
    IF @Pa_groupby <> 'CLIENT'  
    BEGIN  
     SELECT entm_name1,group_cd,MODULE= CASE WHEN MODULE = 'A' THEN 'ACCOUNT REG COLLECTION' ELSE 'TRANSACTION COLLECTION' END ,COLLECTION_TYPE,CHARGE_COLLECTED=SUM(CHARGE_COLLECTED)  
     FROM #TMPCOLL T,#ACLIST A,entity_mstr  
     WHERE T.DPAM_ID = A.DPAM_ID   
     and recd_dt between eff_from and eff_to  
     and a.group_cd = entm_id  
     and entm_deleted_ind = 1  
     GROUP BY entm_name1,group_cd,MODULE,COLLECTION_TYPE  
     ORDER BY 3,1  
    END  
    ELSE  
    BEGIN  
     SELECT * FROM (  
     SELECT entm_name1=ltrim(rtrim(DPAM_SBA_NAME)) + ' - ' + ltrim(rtrim(DPAM_SBA_NO)),MODULE=CASE WHEN MODULE = 'A' THEN 'ACCOUNT REG COLLECTION' ELSE 'TRANSACTION COLLECTION' END ,COLLECTION_TYPE,CHARGE_COLLECTED=SUM(CHARGE_COLLECTED)  
     FROM #TMPCOLL T,#ACLIST A  
     WHERE T.DPAM_ID = A.DPAM_ID   
     and recd_dt between eff_from and eff_to  
     and MODULE <> 'A'  
     GROUP BY DPAM_SBA_NAME,DPAM_SBA_NO,MODULE,COLLECTION_TYPE  
     UNION  
     select ltrim(rtrim(inwcr_name)) + ' - ' + ltrim(rtrim(inwcr_frmno)),'ACCOUNT REG COLLECTION',ISNULL(INWCR_PAY_MODE,''),ISNULL(inwcr_charge_collected,0)  
     FROM inw_client_reg WHERE INWCR_RECVD_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT and inwcr_dmpdpid= @@dpmid and inwcr_deleted_ind = 1   
     ) TMPVIEW  
     ORDER BY 2,1  
       
    END  
*/  
  
  IF @Pa_groupby = 'CLIENT'  
  BEGIN  
  
   SELECT * ,cheque_no,bank_name FROM (  
   SELECT entm_name1=ltrim(rtrim(DPAM_SBA_NAME)) + ' - ' + ltrim(rtrim(DPAM_SBA_NO))  
     ,MODULE=CASE WHEN MODULE = 'A' THEN 'ACCOUNT REG COLLECTION' ELSE 'TRANSACTION COLLECTION' END   
     ,COLLECTION_TYPE  
     ,CHARGE_COLLECTED=SUM(CHARGE_COLLECTED)  
     ,created_by  
     ,  recd_dt ,cheque_no,bank_name  
   FROM #TMPCOLL T,#ACLIST A  
   WHERE T.DPAM_ID = A.DPAM_ID   
   and recd_dt between eff_from and eff_to  
   and MODULE <> 'A'  
   GROUP BY DPAM_SBA_NAME,DPAM_SBA_NO,MODULE,COLLECTION_TYPE,created_by,recd_dt,cheque_no,bank_name  
   UNION  
   select ltrim(rtrim(inwcr_name)) + ' - ' + ltrim(rtrim(inwcr_frmno)),'ACCOUNT REG COLLECTION',ISNULL(INWCR_PAY_MODE,''),ISNULL(inwcr_charge_collected,0),created_by =inwcr_lst_upd_by, INWCR_RECVD_DT,INWCR_cheque_no,inwcr_clibank_name as FINA_ACC_NAME  
   FROM inw_client_reg left outer join FIN_ACCOUNT_MSTR on FINA_ACC_ID = INWCR_BANK_ID   
            WHERE INWCR_RECVD_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT and inwcr_dmpdpid= @@dpmid and inwcr_deleted_ind = 1   
   ) TMPVIEW  
   ORDER BY recd_dt,created_by,2,1  
  end   
  else    
  begin  
      SELECT *  FROM (  
   SELECT entm_name1=ltrim(rtrim(DPAM_SBA_NAME)) + ' - ' + ltrim(rtrim(DPAM_SBA_NO))  
     ,MODULE=CASE WHEN MODULE = 'A' THEN 'ACCOUNT REG COLLECTION' ELSE 'TRANSACTION COLLECTION' END   
     ,COLLECTION_TYPE  
     ,CHARGE_COLLECTED=SUM(CHARGE_COLLECTED)  
     ,created_by  
     ,recd_dt,cheque_no,bank_name  
   FROM #TMPCOLL T,#ACLIST A  
   WHERE T.DPAM_ID = A.DPAM_ID   
   and recd_dt between eff_from and eff_to  
   and MODULE <> 'A'  
   GROUP BY DPAM_SBA_NAME,DPAM_SBA_NO,MODULE,COLLECTION_TYPE,created_by,recd_dt,cheque_no,bank_name  
   UNION  
   select ltrim(rtrim(inwcr_name)) + ' - ' + ltrim(rtrim(inwcr_frmno)),'ACCOUNT REG COLLECTION',ISNULL(INWCR_PAY_MODE,''),ISNULL(inwcr_charge_collected,0),created_by =inwcr_lst_upd_by, INWCR_RECVD_DT,INWCR_cheque_no,inwcr_clibank_name as FINA_ACC_NAME  
   FROM inw_client_reg left outer join FIN_ACCOUNT_MSTR on FINA_ACC_ID = INWCR_BANK_ID   
            WHERE INWCR_RECVD_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT and inwcr_dmpdpid= @@dpmid and inwcr_deleted_ind = 1   
   ) TMPVIEW  
   ORDER BY entm_name1,created_by,2  
  end          
      
  
   --  
   END  

IF   @PA_TAB = 'UPFRONT COLLECTION_INWCLIENT'     
   BEGIN  
   --    
    CREATE TABLE #TMPCOLL1(DPAM_ID BIGINT
							,CHARGE_COLLECTED NUMERIC(18,2)
							,COLLECTION_TYPE VARCHAR(10)
							,MODULE CHAR(1)
							,recd_dt datetime
							,created_by varchar(30)
							,cheque_no varchar(50)
							,bank_name varchar(1000)
                            ,inward_dt datetime
                            ,inward_no varchar(100)
                            ,cheque_dt datetime
                            ,micr_no varchar(100)
                            ,remarks varchar(1000)
							)  
      
--    INSERT INTO #TMPCOLL(DPAM_ID,CHARGE_COLLECTED,COLLECTION_TYPE,MODULE,recd_dt,created_by,cheque_no,bank_name)  
--    SELECT DPAM_ID=INWSR_DPAM_ID,CHARGE_COLLECTED=ISNULL(inwsr_ufcharge_collected,0),COLLECTION_TYPE=ISNULL(inwsr_PAY_MODE,''),'T',INWSR_RECD_DT,inwsr_lst_upd_by,isnull(inwsr_cheque_no,'') , isnull(FINA_ACC_NAME,'')   
--    FROM INWARD_SLIP_REG left outer join FIN_ACCOUNT_MSTR on FINA_ACC_ID = isnull(inwsr_bankid,0)  
--    WHERE ISNULL(inwsr_ufcharge_collected,0) <> 0  
--    AND INWSR_RECD_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT   
--    AND INWSR_DPM_ID= @@dpmid   
--    AND INWSR_DELETED_IND = 1   

    INSERT INTO #TMPCOLL1(DPAM_ID,CHARGE_COLLECTED,COLLECTION_TYPE,MODULE,recd_dt,created_by,cheque_no,bank_name,inward_dt ,inward_no ,cheque_dt ,micr_no ,remarks )  
    SELECT DPAM_ID,CHARGE_COLLECTED=ISNULL(inwcr_charge_collected,0),COLLECTION_TYPE=ISNULL(INWCR_PAY_MODE,''),'A',INWCR_RECVD_DT,inwcr_lst_upd_by,isnull(INWCR_cheque_no,'') , isnull(FINA_ACC_NAME,'')   
    , inwcr_created_dt , inwcr_id , inwcr_cheque_dt , inwcr_bank_branch ,inwcr_rmks
    FROM inw_client_reg left outer join FIN_ACCOUNT_MSTR on FINA_ACC_ID = isnull(INWCR_BANK_ID,0)   
                , DP_ACCT_MSTR  
    WHERE inwcr_frmno =  DPAM_ACCT_NO  
    AND INWCR_RECVD_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT   
    AND ISNULL(inwcr_charge_collected,0) <> 0  
    AND inwcr_dmpdpid= @@dpmid   
    AND inwcr_deleted_ind = 1   
    AND DPAM_DELETED_IND =1  
  
/*  
    IF @Pa_groupby <> 'CLIENT'  
    BEGIN  
     SELECT entm_name1,group_cd,MODULE= CASE WHEN MODULE = 'A' THEN 'ACCOUNT REG COLLECTION' ELSE 'TRANSACTION COLLECTION' END ,COLLECTION_TYPE,CHARGE_COLLECTED=SUM(CHARGE_COLLECTED)  
     FROM #TMPCOLL T,#ACLIST A,entity_mstr  
     WHERE T.DPAM_ID = A.DPAM_ID   
     and recd_dt between eff_from and eff_to  
     and a.group_cd = entm_id  
     and entm_deleted_ind = 1  
     GROUP BY entm_name1,group_cd,MODULE,COLLECTION_TYPE  
     ORDER BY 3,1  
    END  
    ELSE  
    BEGIN  
     SELECT * FROM (  
     SELECT entm_name1=ltrim(rtrim(DPAM_SBA_NAME)) + ' - ' + ltrim(rtrim(DPAM_SBA_NO)),MODULE=CASE WHEN MODULE = 'A' THEN 'ACCOUNT REG COLLECTION' ELSE 'TRANSACTION COLLECTION' END ,COLLECTION_TYPE,CHARGE_COLLECTED=SUM(CHARGE_COLLECTED)  
     FROM #TMPCOLL T,#ACLIST A  
     WHERE T.DPAM_ID = A.DPAM_ID   
     and recd_dt between eff_from and eff_to  
     and MODULE <> 'A'  
     GROUP BY DPAM_SBA_NAME,DPAM_SBA_NO,MODULE,COLLECTION_TYPE  
     UNION  
     select ltrim(rtrim(inwcr_name)) + ' - ' + ltrim(rtrim(inwcr_frmno)),'ACCOUNT REG COLLECTION',ISNULL(INWCR_PAY_MODE,''),ISNULL(inwcr_charge_collected,0)  
     FROM inw_client_reg WHERE INWCR_RECVD_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT and inwcr_dmpdpid= @@dpmid and inwcr_deleted_ind = 1   
     ) TMPVIEW  
     ORDER BY 2,1  
       
    END  
*/  


  
  IF @Pa_groupby = 'CLIENT'  
  BEGIN  
  
   SELECT * ,cheque_no,bank_name FROM (  
   SELECT entm_name1=ltrim(rtrim(DPAM_SBA_NAME)) + ' - ' + ltrim(rtrim(DPAM_SBA_NO))  
     ,MODULE=CASE WHEN MODULE = 'A' THEN 'ACCOUNT REG COLLECTION' ELSE 'TRANSACTION COLLECTION' END   
     ,COLLECTION_TYPE  
     ,CHARGE_COLLECTED=SUM(CHARGE_COLLECTED)  
     ,created_by  
     ,recd_dt ,cheque_no,bank_name  , inward_dt ,inward_no ,cheque_dt ,micr_no ,remarks 
   FROM #TMPCOLL1 T,#ACLIST A  
   WHERE T.DPAM_ID = A.DPAM_ID   
   and recd_dt between eff_from and eff_to  
   and MODULE <> 'A'  
   GROUP BY DPAM_SBA_NAME,DPAM_SBA_NO,MODULE,COLLECTION_TYPE,created_by,recd_dt,cheque_no,bank_name   , inward_dt ,inward_no ,cheque_dt ,micr_no ,remarks 
   UNION  
   select ltrim(rtrim(inwcr_name)) + ' - ' + ltrim(rtrim(inwcr_frmno)),'ACCOUNT REG COLLECTION',ISNULL(INWCR_PAY_MODE,''),ISNULL(inwcr_charge_collected,0),created_by =inwcr_lst_upd_by, INWCR_RECVD_DT,INWCR_cheque_no,inwcr_clibank_name as FINA_ACC_NAME  
   , inwcr_created_dt , inwcr_id , inwcr_cheque_dt , inwcr_bank_branch ,inwcr_rmks
   FROM inw_client_reg left outer join FIN_ACCOUNT_MSTR on FINA_ACC_ID = INWCR_BANK_ID   
            WHERE INWCR_RECVD_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT and inwcr_dmpdpid= @@dpmid and inwcr_deleted_ind = 1   
   ) TMPVIEW  
   ORDER BY recd_dt,created_by,2,1  
  end   
  else    
  begin  
      SELECT *  FROM (  
   SELECT entm_name1=ltrim(rtrim(DPAM_SBA_NAME)) + ' - ' + ltrim(rtrim(DPAM_SBA_NO))  
     ,MODULE=CASE WHEN MODULE = 'A' THEN 'ACCOUNT REG COLLECTION' ELSE 'TRANSACTION COLLECTION' END   
     ,COLLECTION_TYPE  
     ,CHARGE_COLLECTED=SUM(CHARGE_COLLECTED)  
     ,created_by  
     ,recd_dt,cheque_no,bank_name  , inward_dt ,inward_no ,cheque_dt ,micr_no ,remarks 
   FROM #TMPCOLL1 T,#ACLIST A  
   WHERE T.DPAM_ID = A.DPAM_ID   
   and recd_dt between eff_from and eff_to  
   and MODULE <> 'A'  
   GROUP BY DPAM_SBA_NAME,DPAM_SBA_NO,MODULE,COLLECTION_TYPE,created_by,recd_dt,cheque_no,bank_name  , inward_dt ,inward_no ,cheque_dt ,micr_no ,remarks  
   UNION  
   select ltrim(rtrim(inwcr_name)) + ' - ' + ltrim(rtrim(inwcr_frmno)),'ACCOUNT REG COLLECTION',ISNULL(INWCR_PAY_MODE,''),ISNULL(inwcr_charge_collected,0),created_by =inwcr_lst_upd_by, INWCR_RECVD_DT,INWCR_cheque_no,inwcr_clibank_name as FINA_ACC_NAME  
   , inwcr_created_dt , inwcr_id , inwcr_cheque_dt , inwcr_bank_branch ,inwcr_rmks
   FROM inw_client_reg left outer join FIN_ACCOUNT_MSTR on FINA_ACC_ID = INWCR_BANK_ID   
            WHERE INWCR_RECVD_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT and inwcr_dmpdpid= @@dpmid and inwcr_deleted_ind = 1   
   ) TMPVIEW  
   ORDER BY entm_name1,created_by,2  
  end          
      
  
   --  
   END  
  
   IF   @PA_TAB = 'ISINRATES'     
   BEGIN    
   --    
   IF @PA_DP_TYPE ='NSDL'        
   BEGIN    
   select closing_dt = convert(varchar(11),CLOPM_DT,103),ISIN_CD= CLOPM_ISIN_CD,ISIN_NAME=ISNULL(ISIN_NAME,''),CL_RATE=ISNULL(CLOPM_NSDL_RT,0)   
   from closing_price_mstr_NSDL   
   LEFT OUTER JOIN ISIN_MSTR ON CLOPM_ISIN_CD = ISIN_CD  
   where CLOPM_DT >=@PA_FROM_DT and  CLOPM_DT <= @PA_TO_DT  
   AND CLOPM_ISIN_CD LIKE @PA_ISIN + '%'  
   ORDER BY CLOPM_DT,ISIN_NAME  
   END  
   ELSE  
   BEGIN  
   select closing_dt = convert(varchar(11),CLOPM_DT,103),ISIN_CD= CLOPM_ISIN_CD,ISIN_NAME=ISNULL(ISIN_NAME,''),CL_RATE=ISNULL(CLOPM_CDSL_RT,0)   
   from closing_price_mstr_cdsl  
   LEFT OUTER JOIN ISIN_MSTR ON CLOPM_ISIN_CD = ISIN_CD  
   where CLOPM_DT >=@PA_FROM_DT and  CLOPM_DT <= @PA_TO_DT  
   AND CLOPM_ISIN_CD LIKE @PA_ISIN + '%'  
   ORDER BY CLOPM_DT,ISIN_NAME  
   END  
   --     
   END   
   IF   @PA_TAB = 'PENDINGACCOUNT'     
   BEGIN    
   --    
    select CONVERT(VARCHAR(11),INWCR_RECVD_DT,109) INWCR_RECVD_DT,inwcr_frmno,INWCR_NAME,inwcr_rmks,FINA_ACC_NAME,INWCR_PAY_MODE,INWCR_cheque_no   from inw_client_reg , FIN_ACCOUNT_MSTR  
            where INWCR_BANK_ID = FINA_ACC_ID   
--            and   not exists (select CLIC_DPAM_ID   
--                              from client_charges_nsdl , dp_acct_mstr   
--                              where CLIC_DPAM_ID = dpam_id and dpam_acct_no = inwcr_frmno and dpam_deleted_ind = 1)  
            and   not exists (select DPAM_ID  
                              from  dp_acct_mstr   
                              where dpam_acct_no = inwcr_frmno and dpam_deleted_ind = 1)  
  
            and  inwcr_dmpdpid =  @@dpmid  
            and  inwcr_deleted_ind = 1 
            and  INWCR_RECVD_DT >= @PA_FROM_DT and  INWCR_RECVD_DT <= @PA_TO_DT  
            order by    INWCR_RECVD_DT    
             
     
   --     
   END   
   IF   @PA_TAB = 'ISINRATES_CNT'     
   BEGIN    
   IF @PA_DP_TYPE ='NSDL'        
   BEGIN   
   select Closing_dt = convert(varchar(11),CLOPM_DT,103),Rec_cnt=count(CLOPM_ISIN_CD) from closing_price_mstr_NSDL  
   where CLOPM_DT >=@PA_FROM_DT and  CLOPM_DT <= @PA_TO_DT  
   group by CLOPM_DT  
   END  
   ELSE  
   BEGIN  
   select Closing_dt = convert(varchar(11),CLOPM_DT,103),Rec_cnt=count(CLOPM_ISIN_CD) from closing_price_mstr_CDSL  
   where CLOPM_DT >=@PA_FROM_DT and  CLOPM_DT <= @PA_TO_DT  
   group by CLOPM_DT  
   END  
   
 END  
  
  
   IF   @PA_TAB = 'HOLDING_CNT'     
   BEGIN    
   --    
   IF @PA_DP_TYPE ='NSDL'        
   BEGIN    
   CREATE TABLE #TMPHLDG(HLDG_DT DATETIME,CNT BIGINT,ENTM_NAME1 VARCHAR(250))  
   declare @c_cursor cursor,  
   @@TMPDATE datetime  
  
   SET @c_cursor =  CURSOR fast_forward FOR   
       select distinct DPDHMD_HOLDING_DT  
       from  DP_DAILY_HLDG_NSDL  
       WHERE DPDHMD_HOLDING_DT >=@PA_FROM_DT AND DPDHMD_HOLDING_DT <= @PA_TO_DT  
       AND DPDHMD_DPM_ID = @@dpmid  
  
   OPEN @c_cursor              
   FETCH NEXT FROM @c_cursor   INTO @@TMPDATE   
        
   IF @Pa_groupby <> 'CLIENT'  
   BEGIN  
     WHILE @@fetch_status = 0              
     BEGIN     
      INSERT INTO #TMPHLDG(HLDG_DT,CNT,ENTM_NAME1)   
      SELECT @@TMPDATE,COUNT(*),entm_name1   
      FROM CITRUS_USR.fn_dailyholding_HO(@@dpmid,@@TMPDATE,'','','','') H  
      ,#ACLIST A,entity_mstr    
      WHERE dpdhmd_qty <> 0  
      AND H.dpdhmd_DPAM_ID = A.dpam_id AND GROUP_cd = entm_id  
      group by entm_name1  
      FETCH NEXT FROM @c_cursor   INTO @@TMPDATE   
     END  
   END  
   ELSE  
   BEGIN  
     WHILE @@fetch_status = 0              
     BEGIN     
      INSERT INTO #TMPHLDG(HLDG_DT,CNT,ENTM_NAME1)   
      SELECT @@TMPDATE,COUNT(*),h.DPAM_SBA_NAME + ' - ' + h.DPAM_SBA_NO   
      FROM CITRUS_USR.fn_dailyholding_HO(@@dpmid,@@TMPDATE,'','','','') H  
      ,#ACLIST A  
      WHERE dpdhmd_qty <> 0  
      AND H.dpdhmd_DPAM_ID = A.dpam_id   
      group by h.DPAM_SBA_NAME,h.DPAM_SBA_NO  
      FETCH NEXT FROM @c_cursor   INTO @@TMPDATE   
     END  
   END  
  
   CLOSE @c_cursor  
   DEALLOCATE @c_cursor  
     
   SELECT * FROM #TMPHLDG  
   TRUNCATE TABLE #TMPHLDG  
   DROP TABLE #TMPHLDG  
  
  
   END  
   ELSE  
   BEGIN  
   IF @Pa_groupby <> 'CLIENT'  
   BEGIN  
     select holding_dt = DPHMCD_HOLDING_DT,Rec_cnt=count(*),entm_name1   
     from DP_DAILY_HLDG_CDSL,#ACLIST,entity_mstr   
     where DPHMCD_HOLDING_DT >=@PA_FROM_DT and  DPHMCD_HOLDING_DT <= @PA_TO_DT  
     AND DPHMCD_DPAM_ID = dpam_id AND GROUP_cd = entm_id  
     and dphmcd_curr_qty <> 0  
     AND DPHMCD_DPM_ID = @@dpmid  
     group by DPHMCD_HOLDING_DT,entm_name1  
   END  
   ELSE  
   BEGIN  
     select holding_dt = DPHMCD_HOLDING_DT,Rec_cnt=count(*),entm_name1=DPAM_SBA_NAME + ' - ' + DPAM_SBA_NO    
     from DP_DAILY_HLDG_CDSL,#ACLIST  
     where DPHMCD_HOLDING_DT >=@PA_FROM_DT and  DPHMCD_HOLDING_DT <= @PA_TO_DT  
     AND DPHMCD_DPAM_ID = dpam_id   
     and dphmcd_curr_qty <> 0  
     AND DPHMCD_DPM_ID = @@dpmid  
     group by DPHMCD_HOLDING_DT,DPAM_SBA_NAME,DPAM_SBA_NO   
   END  
  
  
   END  
   --     
   END   
  
   IF   @PA_TAB = 'DPMTRN_CNT'     
   BEGIN    
   --    
   IF @PA_DP_TYPE ='NSDL'        
   BEGIN    
   IF @Pa_groupby <> 'CLIENT'  
   BEGIN  
    select Trn_dt = NSDHM_TRANSACTION_DT,Rec_cnt=count(*),entm_name1 from NSDL_HOLDING_DTLS,#ACLIST cli_list  
    ,entity_mstr   
    where NSDHM_TRANSACTION_DT >=@PA_FROM_DT and  NSDHM_TRANSACTION_DT <= @PA_TO_DT AND dpam_id = NSDHM_DPAM_ID AND GROUP_cd = entm_id  
    and NSDHM_TRANSACTION_DT between eff_from and eff_to     
    group by GROUP_cd,entm_name1,NSDHM_TRANSACTION_DT  
   END  
   ELSE  
   BEGIN  
    select Trn_dt = NSDHM_TRANSACTION_DT,Rec_cnt=count(*),entm_name1=DPAM_SBA_NAME + ' - ' + DPAM_SBA_NO  from NSDL_HOLDING_DTLS,#ACLIST cli_list  
    where NSDHM_TRANSACTION_DT >=@PA_FROM_DT and  NSDHM_TRANSACTION_DT <= @PA_TO_DT AND dpam_id = NSDHM_DPAM_ID   
    and NSDHM_TRANSACTION_DT between eff_from and eff_to     
    group by NSDHM_TRANSACTION_DT,DPAM_SBA_NAME ,DPAM_SBA_NO   
  
   END  
   END  
   ELSE  
   BEGIN  
   IF @Pa_groupby <> 'CLIENT'  
   BEGIN  
     select Trn_dt = CDSHM_TRAS_DT,Rec_cnt=count(*),entm_name1 from CDSL_HOLDING_DTLS,#ACLIST cli_list  
      ,entity_mstr   
     where CDSHM_TRAS_DT >=@PA_FROM_DT and  CDSHM_TRAS_DT <= @PA_TO_DT  AND dpam_id = cdshm_dpam_id AND GROUP_cd = entm_id  
     and CDSHM_TRAS_DT between eff_from and eff_to     
     group by GROUP_cd,entm_name1,CDSHM_TRAS_DT  
   END  
   ELSE  
   BEGIN  
     select Trn_dt = CDSHM_TRAS_DT,Rec_cnt=count(*),entm_name1=DPAM_SBA_NAME + ' - ' + DPAM_SBA_NO from CDSL_HOLDING_DTLS,#ACLIST cli_list  
     where CDSHM_TRAS_DT >=@PA_FROM_DT and  CDSHM_TRAS_DT <= @PA_TO_DT  AND dpam_id = cdshm_dpam_id   
     and CDSHM_TRAS_DT between eff_from and eff_to     
     group by DPAM_SBA_NAME ,DPAM_SBA_NO,CDSHM_TRAS_DT  
   END  
   END  
   --     
   END   
   IF   @PA_TAB = 'CLI_STATUS_DTWISE'     
   BEGIN    
   --    
     CREATE TABLE #TEMP_CLI_STATUS_DTWISE(DATE VARCHAR(11),STATUS VARCHAR(50),[NO OF CLIENT] NUMERIC)  
       
        
         INSERT INTO #TEMP_CLI_STATUS_DTWISE  
  
   SELECT dt [DATE], 'ACTIVE' STATUS, COUNT(id) [NO OF CLIENT]  FROM (  
   SELECT citrus_usr.fn_ucc_accp(dpam_id ,'BILL_START_DT','') dt   
  ,COUNT(DISTINCT dpam_sba_no) id  
   FROM citrus_usr.DP_ACCT_MSTR , citrus_usr.EXCH_SEG_MSTR  
   WHERE DPAM_EXCSM_ID = EXCSM_ID  
   --AND   DPAM_ACTION ='E'  
   AND   dpam_stam_cd ='ACTIVE'  
   AND   EXCSM_EXCH_CD =@PA_DP_TYPE  
   AND  citrus_usr.fn_ucc_accp(dpam_id ,'BILL_START_DT','') <> ''  
   AND  ISDATE(citrus_usr.fn_ucc_accp(dpam_id ,'BILL_START_DT','')) =1   
   AND CONVERT(DATETIME,citrus_usr.fn_ucc_accp(dpam_id ,'BILL_START_DT',''),103) BETWEEN CONVERT(DATETIME,@PA_FROM_DT,103) AND CONVERT(DATETIME,@PA_TO_DT,103)   
  GROUP BY citrus_usr.fn_ucc_accp(dpam_id ,'BILL_START_DT',''),dpam_id) a  
  GROUP BY dt  
  
  
  UNION  
  
  SELECT dt [DATE], 'REGISTERED' STATUS, COUNT(id) [NO OF CLIENT]  FROM (  
  SeLECT CONVERT(VARCHAR,dpam_lst_upd_dt,103) dt ,COUNT(DISTINCT dpam_sba_no) id  
  FROM citrus_usr.DP_ACCT_MSTR , citrus_usr.EXCH_SEG_MSTR  
  WHERE DPAM_EXCSM_ID = EXCSM_ID --AND DPAM_ACTION ='E'  
  AND   dpam_stam_cd ='06'  
  AND   EXCSM_EXCH_CD =@PA_DP_TYPE  
  AND dpam_lst_upd_dt BETWEEN CONVERT(DATETIME,@PA_FROM_DT,103) AND CONVERT(DATETIME,@PA_TO_DT,103)  
  --AND   citrus_usr.fn_ucc_accp(dpam_id ,'BILL_START_DT','') = '05/12/2002'  
  GROUP BY dpam_lst_upd_dt,dpam_id) a  
  GROUP BY dt  
  
  UNION  
  
  SELECT dt [DATE], 'INACTIVE' STATUS, COUNT(id) [NO OF CLIENT]  FROM (  
  SeLECT CONVERT(VARCHAR,dpam_lst_upd_dt,103) dt ,COUNT(DISTINCT dpam_sba_no) id  
  FROM citrus_usr.DP_ACCT_MSTR , citrus_usr.EXCH_SEG_MSTR  
  WHERE DPAM_EXCSM_ID = EXCSM_ID --AND DPAM_ACTION ='E'  
  AND   dpam_stam_cd ='CI'  
  AND   EXCSM_EXCH_CD =@PA_DP_TYPE  
  AND dpam_lst_upd_dt BETWEEN CONVERT(DATETIME,@PA_FROM_DT,103) AND CONVERT(DATETIME,@PA_TO_DT,103)  
  --AND   citrus_usr.fn_ucc_accp(dpam_id ,'BILL_START_DT','') = '05/12/2002'  
  GROUP BY dpam_lst_upd_dt,dpam_id) a  
  GROUP BY dt  
  
  UNION  
  
  SELECT dt [DATE], 'CLOSED' STATUS, COUNT(id) [NO OF CLIENT]  FROM (  
  SeLECT CONVERT(VARCHAR,dpam_lst_upd_dt,103) dt ,COUNT(DISTINCT dpam_sba_no) id  
  FROM citrus_usr.DP_ACCT_MSTR, citrus_usr.EXCH_SEG_MSTR  
  WHERE DPAM_EXCSM_ID = EXCSM_ID --AND  DPAM_ACTION ='E'  
  AND dpam_stam_cd ='05'  
  AND EXCSM_EXCH_CD = @PA_DP_TYPE  
  AND CONVERT(DATETIME,citrus_usr.fn_ucc_accp(dpam_id ,'ACC_CLOSE_DT',''),103) BETWEEN CONVERT(DATETIME,@PA_FROM_DT,103) AND CONVERT(DATETIME,@PA_TO_DT,103)   
  GROUP BY dpam_lst_upd_dt,dpam_id) a  
  GROUP BY dt  
  
  UNION  
  
  SELECT CONVERT(VARCHAR,dt,103) [DATE], 'SUSPENDED FOR DEBIT' STATUS, COUNT(id) [NO OF CLIENT]  FROM (  
  SeLECT MIN(dpam_lst_upd_dt) dt ,COUNT(DISTINCT dpam_sba_no) id  
  FROM citrus_usr.DP_ACCT_MSTR_HST , citrus_usr.EXCH_SEG_MSTR  
  WHERE DPAM_EXCSM_ID = EXCSM_ID --AND DPAM_ACTION ='E'  
  AND   dpam_stam_cd ='03'  
  AND   EXCSM_EXCH_CD =@PA_DP_TYPE  
    
  GROUP BY dpam_id) a  
        WHERE  DT BETWEEN @PA_FROM_DT AND @PA_TO_DT  
  GROUP BY dt  
  ORDER BY dt  
   
       
        SELECT DATE ,STATUS ,[NO OF CLIENT] FROM #TEMP_CLI_STATUS_DTWISE  
  
  
   --     
   END   
   IF   @PA_TAB = 'CLI_DTLSSTATUS_DTWISE'     
   BEGIN    
   --    
  SET @@finId =0  
  SELECT @@finId = ISNULL(FIN_ID,0) FROM FINANCIAL_YR_MSTR WHERE FIN_DPM_ID = @@dpmid AND (@PA_FROM_DT BETWEEN convert(varchar(11),FIN_START_DT,109) AND convert(varchar(11),FIN_END_DT,109)) AND (@PA_TO_DT BETWEEN convert(varchar(11),FIN_START_DT,109) AND 
convert(varchar(11),FIN_END_DT,109) ) AND FIN_DELETED_IND = 1   
        PRINT @@finId  
  IF @@finId <> 0  
  BEGIN  
  
    CREATE TABLE #TEMP_CLI_DTLSSTATUS_DTWISE(DATE VARCHAR(11),[CLIENT NAME] VARCHAR(1000),[CLIENT ID] VARCHAR(16),STATUS VARCHAR(50))  
         
          
     INSERT INTO #TEMP_CLI_DTLSSTATUS_DTWISE  
     SELECT dt [DATE], DPAM_SBA_NAME,DPAM_SBA_NO,'ACTIVE' STATUS  FROM (  
     SELECT DISTINCT citrus_usr.fn_ucc_accp(dpam_id ,'BILL_START_DT','') DT ,DPAM_SBA_NAME ,DPAM_SBA_NO   
     FROM citrus_usr.DP_ACCT_MSTR , citrus_usr.EXCH_SEG_MSTR  
     WHERE DPAM_EXCSM_ID = EXCSM_ID  
     --AND   DPAM_ACTION ='E'  
     AND   dpam_stam_cd ='ACTIVE'  
     AND   EXCSM_EXCH_CD =@PA_DP_TYPE  
     AND  citrus_usr.fn_ucc_accp(dpam_id ,'BILL_START_DT','') <> ''  
     AND  ISDATE(citrus_usr.fn_ucc_accp(dpam_id ,'BILL_START_DT','')) = 1   
     AND CONVERT(DATETIME,citrus_usr.fn_ucc_accp(dpam_id ,'BILL_START_DT',''),103) BETWEEN CONVERT(DATETIME,@PA_FROM_DT,103) AND CONVERT(DATETIME,@PA_TO_DT,103)   
    ) a  
      
  
    UNION  
  
    SELECT dt [DATE], DPAM_SBA_NAME,DPAM_SBA_NO, 'REGISTERED' STATUS FROM (  
    SeLECT DISTINCT CONVERT(VARCHAR,dpam_lst_upd_dt,103) dt ,DPAM_SBA_NAME,DPAM_SBA_NO   
    FROM citrus_usr.DP_ACCT_MSTR , citrus_usr.EXCH_SEG_MSTR  
    WHERE DPAM_EXCSM_ID = EXCSM_ID --AND DPAM_ACTION ='E'  
    AND   dpam_stam_cd ='06'  
    AND   EXCSM_EXCH_CD =@PA_DP_TYPE  
    AND dpam_lst_upd_dt BETWEEN CONVERT(DATETIME,@PA_FROM_DT,103) AND CONVERT(DATETIME,@PA_TO_DT,103)  
    --AND   citrus_usr.fn_ucc_accp(dpam_id ,'BILL_START_DT','') = '05/12/2002'  
    ) a  
      
    UNION  
  
    SELECT dt [DATE], DPAM_SBA_NAME,DPAM_SBA_NO, 'INACTIVE' STATUS FROM (  
    SeLECT DISTINCT CONVERT(VARCHAR,dpam_lst_upd_dt,103) dt ,DPAM_SBA_NAME,DPAM_SBA_NO   
    FROM citrus_usr.DP_ACCT_MSTR , citrus_usr.EXCH_SEG_MSTR  
    WHERE DPAM_EXCSM_ID = EXCSM_ID --AND DPAM_ACTION ='E'  
    AND   dpam_stam_cd ='CI'  
    AND   EXCSM_EXCH_CD =@PA_DP_TYPE  
    AND dpam_lst_upd_dt BETWEEN CONVERT(DATETIME,@PA_FROM_DT,103) AND CONVERT(DATETIME,@PA_TO_DT,103)  
    --AND   citrus_usr.fn_ucc_accp(dpam_id ,'BILL_START_DT','') = '05/12/2002'  
    ) a  
  
    UNION  
  
    SELECT dt [DATE], DPAM_SBA_NAME,DPAM_SBA_NO, 'CLOSED' STATUS FROM (  
    SeLECT DISTINCT CONVERT(VARCHAR,dpam_lst_upd_dt,103) dt ,DPAM_SBA_NAME,DPAM_SBA_NO   
    FROM citrus_usr.DP_ACCT_MSTR, citrus_usr.EXCH_SEG_MSTR  
    WHERE DPAM_EXCSM_ID = EXCSM_ID --AND  DPAM_ACTION ='E'  
    AND   dpam_stam_cd ='05'  
    AND   EXCSM_EXCH_CD =@PA_DP_TYPE  
    AND CONVERT(DATETIME,citrus_usr.fn_ucc_accp(dpam_id ,'ACC_CLOSE_DT',''),103) BETWEEN CONVERT(DATETIME,@PA_FROM_DT,103) AND CONVERT(DATETIME,@PA_TO_DT,103)   
    ) a  
      
  
    UNION  
  
    SELECT CONVERT(VARCHAR,dt,103) [DATE], DPAM_SBA_NAME,DPAM_SBA_NO, 'SUSPENDED FOR DEBIT' STATUS  FROM (  
    SeLECT DISTINCT MIN(dpam_lst_upd_dt) dt ,DPAM_SBA_NAME,DPAM_SBA_NO   
    FROM citrus_usr.DP_ACCT_MSTR_HST , citrus_usr.EXCH_SEG_MSTR  
    WHERE DPAM_EXCSM_ID = EXCSM_ID --AND DPAM_ACTION ='E'  
    AND   dpam_stam_cd = '03'  
    AND   EXCSM_EXCH_CD =@PA_DP_TYPE  
                GROUP BY DPAM_SBA_NAME, DPAM_SBA_NO   
    ) a  
                WHERE DT BETWEEN CONVERT(DATETIME,@PA_FROM_DT,103) AND CONVERT(DATETIME,@PA_TO_DT,103)   
                  
    ORDER BY dt   
         
  
    SET @@SSQL='SELECT DATE ,[CLIENT NAME] ,[CLIENT ID] ,STATUS,OUTSTND_AMT = CASE WHEN ISNULL(ACCBAL_AMOUNT,0) < 0 THEN ISNULL(ACCBAL_AMOUNT,0) ELSE 0 END,RET_VAL=''''    
    FROM #TEMP_CLI_DTLSSTATUS_DTWISE,#ACLIST LEFT OUTER JOIN ACCOUNTBAL' + CONVERT(VARCHAR,@@finId) + ' ON ACCBAL_ACCT_ID = DPAM_ID AND ACCBAL_ACCT_TYPE = ''P'' AND ACCBAL_DPM_ID = ' + CONVERT(VARCHAR, @@dpmid) + '   
    WHERE  [CLIENT ID] = DPAM_SBA_NO ORDER BY DATE , [CLIENT ID]'  
  
    EXEC(@@SSQL)  
  END  
  ELSE  
  BEGIN  
   
    SELECT RET_VAL ='FINYEARPROBLEM'  
  END  
  
  
  
   --     
   END  
  
 IF   @PA_TAB = 'CLI_TRX_DTLS'   
BEGIN  
--  
 IF @PA_DP_TYPE = 'NSDL'  
 BEGIN  
 --  
  SELECT DISTINCT DPAM_SBA_NO  
  ,DPAM_SBA_NAME   
        ,ISNULL(ADR_CITY,'') CITY  
        ,ISNULL(ADR_STATE,'') STATE  
        ,trxdt =''  
  FROM NSDL_HOLDING_DTLS  
   ,#ACLIST ,ACCOUNT_ADR_CONC,CONC_CODE_MSTR,ADDRESSES  
  WHERE NSDHM_DPAM_ID =DPAM_ID    
  AND NSDHM_TRANSACTION_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT  
  and NSDHM_TRANSACTION_DT between eff_from and eff_to  
  AND NSDHM_DELETED_IND =1  
        AND ACCAC_CLISBA_ID = DPAM_ID  
        AND ACCAC_CONCM_ID=CONCM_ID  
        AND ACCAC_ADR_CONC_ID=ADR_ID  
        AND CONCM_CD ='AC_COR_ADR1'  
  ORDER BY 1  
  
    --  
 END  
 ELSE  
 BEGIN  
 --  
  SELECT DISTINCT DPAM_SBA_NO  
  ,DPAM_SBA_NAME   
        ,ISNULL(ADR_CITY,'') CITY  
        ,ISNULL(ADR_STATE,'') STATE  
        ,trxdt =''  
  FROM CDSL_HOLDING_DTLS  
   ,#ACLIST ,ACCOUNT_ADR_CONC,CONC_CODE_MSTR,ADDRESSES  
  WHERE CDSHM_DPAM_ID =DPAM_ID    
  AND CDSHM_TRAS_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT  
  and CDSHM_TRAS_DT between eff_from and eff_to  
  AND CDSHM_DELETED_IND =1  
        AND ACCAC_CLISBA_ID = DPAM_ID  
        AND ACCAC_CONCM_ID=CONCM_ID  
        AND ACCAC_ADR_CONC_ID=ADR_ID  
        AND CONCM_CD ='AC_COR_ADR1'  
  ORDER BY 1  
 --  
 END  
--  
END  


IF  @PA_TAB = 'CHKWTHMAIL'       
  BEGIN  
 SELECT DISTINCT
 ISNULL(CLIM_NAME1,'') + ' ' + ISNULL(CLIM_NAME2,'') + ' ' + ISNULL(CLIM_NAME3,'')  AS CLIENTMSTR,CONC_VALUE,DPAM_SBA_NO 
FROM 
CLIENT_MSTR,DP_ACCT_MSTR,ENTITY_ADR_CONC,CONTACT_CHANNELS 

WHERE ENTAC_CONCM_CD='EMAIL1' AND ENTAC_ADR_CONC_ID=CONC_ID  
AND CONC_VALUE<>'' AND CLIM_CRN_NO=ENTAC_ENT_ID AND CLIM_CRN_NO = DPAM_CRN_NO  
AND DPAM_STAM_CD='ACTIVE' AND  CLIM_CREATED_DT between @pa_from_dt and @pa_to_dt  
ORDER BY  ISNULL(CLIM_NAME1,'') + ' ' + ISNULL(CLIM_NAME2,'') + ' ' + ISNULL(CLIM_NAME3,'') ASC  
  END
  
  
/*  
SP_HELP CLIENT_MSTR
SELECT * FROM CLIENT_MSTR
exception check - dont delete  
  
select * from cdsl_holding_dtls where cdshm_tratm_type_desc like '%-DR%' and cdshm_tratm_cd = '2246'  
  
select * from cdsl_holding_dtls where cdshm_tratm_type_desc like '%-CR%' and cdshm_tratm_cd = '2277'  
  
exception check  
*/  
  
end

GO
