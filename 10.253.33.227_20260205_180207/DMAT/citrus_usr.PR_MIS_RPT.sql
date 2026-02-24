-- Object: PROCEDURE citrus_usr.PR_MIS_RPT
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--
--TRXWISE	CDSL	19/11/2008	19/11/2008	1		HO|*~|	3	
--
--PR_MIS_RPT 'TRXWISE','CDSL','19/10/2008','19/11/2008',1,'','HO|*~|',3,''  
CREATE procedure [citrus_usr].[PR_MIS_RPT]      
(@PA_TAB varchar(25)      
,@PA_DP_TYPE VARCHAR(10)      
,@PA_FROM_DT VARCHAR(11)      
,@PA_TO_DT VARCHAR(11)      
,@pa_login_pr_entm_id numeric      
,@PA_FROM_ACCT  VARCHAR(16)      
,@pa_login_entm_cd_chain  varchar(8000)      
,@pa_excsmid   INT      
,@pa_output    varchar(20) OUT    
)      
as      
begin      
--      
set transaction isolation level read uncommitted
--
create TABLE  #temp(VALUE numeric,NAME varchar(25),ord int)  
declare @@dpmid int                                
DECLARE @L_CUR_DATE DATETIME      
SET @L_CUR_DATE  = GETDATE()       
select @@dpmid= dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                                
declare @@l_child_entm_id      numeric                            
select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                            
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)        
CREATE INDEX IX_2 on #ACLIST (DPAM_ID)    
INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)          
    
   
   
 IF   @PA_TAB = 'TRXWISE'   
   BEGIN  
   --  
     IF @PA_DP_TYPE ='NSDL'      
     BEGIN   
        
    create table #tmpnsdl(trans_type int,NSDHM_TRANSACTION_DT datetime,nsdhm_dpam_id bigint,nsdhm_qty numeric(18,3),NSDHM_ISIN varchar(12),NSDHM_BOOK_NAAR_CD varchar(3),nsdhm_dpm_trans_no varchar(12),Ben_acct_type varchar(3))  
  
    insert into #tmpnsdl  
    select DISTINCT 0,nsdhm_transaction_dt,nsdhm_dpam_id,  
    nsdhm_qty,NSDHM_ISIN,NSDHM_BOOK_NAAR_CD,nsdhm_dpm_trans_no,nsdhm_transaction_dt   
    from nsdl_holding_dtls with(nolock),cod_dtls with(nolock)      
    where nsdhm_dpm_trans_no = codd_trx_no   
    and CODD_ORD_STATUS_TO = '51'  
    and nsdhm_transaction_dt between  convert(datetime,@pa_from_dt,103) and  convert(datetime,@pa_to_dt,103)  
      
    delete from #tmpnsdl where Ben_acct_type not in('20','30','40') and NSDHM_BOOK_NAAR_CD in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213','101')                   
    delete from #tmpnsdl where Ben_acct_type in('20','30','40') and NSDHM_BOOK_NAAR_CD in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213')    
  
  
    update m set trans_type = 1                 
    from #tmpnsdl m                  
    where Ben_acct_type not in('20','30','40') and   
    convert(int,m.NSDHM_BOOK_NAAR_CD) = isnull((select max(convert(int,NSDHM_BOOK_NAAR_CD)) from #tmpnsdl m1 where m.nsdhm_dpm_trans_no = m1.nsdhm_dpm_trans_no and m.NSDHM_ISIN = m1.NSDHM_ISIN and m.nsdhm_dpam_id = m1.nsdhm_dpam_id and m.Ben_acct_type = m1.Ben_acct_type),0)               
  
  
    select TRANS.DESCP,trans_count=count(nsdhm_dpm_trans_no),dr_val= convert(numeric(18,2),sum(dr_qty*isnull(CLOPM_NSDL_RT,0))),Cr_val=convert(numeric(18,2),sum(cr_qty*isnull(CLOPM_NSDL_RT,0))),count(distinct dpam_id) CLIENT_COUNT from  
    (  
    select DISTINCT exec_dt=CONVERT(DATETIME,CONVERT(VARCHAR(11),NSDHM_TRANSACTION_DT,109)),nsdhm_dpam_id,  
    dr_qty= case when nsdhm_qty < 0 then Abs(nsdhm_qty) else 0 end,  
       cr_qty= case when nsdhm_qty >= 0 then Abs(nsdhm_qty) else 0 end,  
    NSDHM_ISIN,NSDHM_BOOK_NAAR_CD,nsdhm_dpm_trans_no,nsdhm_transaction_dt   
    from #tmpnsdl where trans_type = 1  
    ) tmp left outer join closing_price_mstr_nsdl on tmp.exec_dt = clopm_dt and tmp.nsdhm_isin = clopm_isin_cd,  
    citrus_usr.fn_getsubtransdtls('NARR_CODE') TRANS,  
    #ACLIST account  
    WHERE tmp.nsdhm_dpam_id = account.dpam_id  
    and exec_dt between eff_from and eff_to  
    and TMP.NSDHM_BOOK_NAAR_CD = left(TRANS.CD,3)  
    group by TRANS.DESCP  
      
    truncate table #tmpnsdl  
    drop table #tmpnsdl  
      
  
     END  
     ELSE  
     BEGIN  
    select TRANS.DESCP,trans_count=count(cdshm_trans_no),dr_val= sum(dr_qty*isnull(CLOPM_CDSL_RT,0)),Cr_val=sum(cr_qty*isnull(CLOPM_CDSL_RT,0)),count(distinct dpam_id) CLIENT_COUNT from  
     (  
     select DISTINCT exec_dt=CONVERT(DATETIME,CONVERT(VARCHAR(11),cdshm_tras_dt,109)),cdshm_dpam_id,  
     dr_qty= case when cdshm_qty < 0 then cdshm_qty else 0 end,  
     cr_qty= case when cdshm_qty >= 0 then cdshm_qty else 0 end,  
     CDSHM_ISIN,cdshm_tratm_cd,cdshm_trans_no,cdshm_tras_dt   
     from cdsl_holding_dtls  
     where cdshm_tras_dt between convert(datetime,@pa_from_dt,103) and  convert(datetime,@pa_to_dt,103) 
     ) tmp left outer join closing_price_mstr_cdsl on tmp.exec_dt = clopm_dt and tmp.cdshm_isin = clopm_isin_cd,  
     citrus_usr.fn_getsubtransdtls('TRANS_TYPE_CDSL') TRANS,  
     #ACLIST account  
     WHERE tmp.cdshm_dpam_id = account.dpam_id  
     and exec_dt between eff_from and eff_to  
     and TMP.cdshm_tratm_cd = TRANS.CD  
     group by TRANS.DESCP  
     END  
   --   
   END  
     
  
  IF   @PA_TAB = 'CLI_MAK'   
  BEGIN      
  --        
  
    insert into #temp  
    select count(distinct dpam_sba_no) VALUE, 'MAKER ENTERED' NAME, 1 ORD from DP_ACCT_MSTR_MAK 
	where dpam_dpm_id = @@dpmid and 
    dpam_lst_upd_dt between CONVERT(DATETIME,@PA_FROM_DT,103) and CONVERT(DATETIME,@PA_to_DT+' 23:59:59',103)  
    and dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_FROM_ACCT))     = '' THEN '%' ELSE @PA_FROM_ACCT  END  
	and dpam_deleted_ind in (0,4,6,1,5,7)
    union  
    select count(distinct dpam_sba_no) VALUE , 'CHECKER APPROVED' NAME, 2 ORD from DP_ACCT_MSTR 
	where dpam_dpm_id = @@dpmid and 
    dpam_lst_upd_dt between CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59:59',103)  
    and dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_FROM_ACCT))     = '' THEN '%' ELSE @PA_FROM_ACCT  END  
	and dpam_deleted_ind = 1 
    UNION  
    select count(distinct dpam_sba_no) VALUE , 'BATCH GENERATED' NAME, 3 ORD from DP_ACCT_MSTR 
	where dpam_dpm_id = @@dpmid and 
    dpam_lst_upd_dt between CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59:59',103)   
    AND ISNULL(DPAM_BATCH_NO,'0') <> '0' -- and isnull(dpam_stam_cd,'')='ACTIVE'  
    and dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_FROM_ACCT))     = '' THEN '%' ELSE @PA_FROM_ACCT  END  
	and dpam_deleted_ind = 1 
    UNION  
    select count(distinct dpam_sba_no) VALUE , 'ACCOUNT CLOSED' NAME, 3 ORD from DP_ACCT_MSTR 
	where dpam_dpm_id = @@dpmid and 
    dpam_lst_upd_dt between CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59:59',103)   
    AND ISNULL(DPAM_BATCH_NO,'0') <> '0' and isnull(dpam_stam_cd,'')='05'  
    and dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_FROM_ACCT))     = '' THEN '%' ELSE @PA_FROM_ACCT  END 
	and dpam_deleted_ind = 1
  
   SELECT  NAME,VALUE FROM #temp ORDER BY ORD DESC  
  --      
  END     
  
  --  
  IF   @PA_TAB = 'CLI_ADR'   
  BEGIN   
  
   create table #Climaddrdates (adr_id bigint,cl_code bigint,lst_dt datetime,concm_DESC varchar(50),lst_dt_actual datetime)

   create table #Climaddrdates_main (cl_code bigint,lst_dt datetime,concm_DESC varchar(50))

		create table #tempadr (dpam_sba_no varchar(16),dpam_sba_name varchar(100), concm_desc varchar(50),new_adr varchar(8000),old_adr varchar(8000),lst_upd_by varchar(50),lst_upd_dt datetime)
		create table #tempadr1 (adr_id numeric,dpam_sba_no varchar(16), concm_desc varchar(50),adr_1 varchar(50), adr_2 varchar(50), adr_3 varchar(50), adr_city varchar(50), adr_state varchar(50), adr_country varchar(50), adr_zip varchar(50),dt datetime)

    INSERT INTO #Climaddrdates(adr_id,cl_code  ,lst_dt ,concm_DESC)
    SELECT b.adr_id,e.dpam_sba_no,adr_lst_upd_dt,d.concm_DESC
    FROM  addr_hst b,ACCAC_HST c,conc_code_mstr  d,DP_ACCT_MSTR e,client_mstr clim
    WHERE  concm_id = accac_concm_id
    and   clim.clim_crn_no = e.dpam_Crn_no 
	and   e.dpam_id = c.ACCAC_CLISBA_ID
	AND   c.ACCAC_CONCM_ID = d.CONCM_ID
	and   c.accac_adr_conc_id = b.adr_id
    AND clim_lst_upd_dt BETWEEN CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103)



update k
set lst_dt_actual = isnull((SELECT  max(adr_lst_upd_dt)
    FROM  addr_hst b,ACCAC_HST c,conc_code_mstr  d,DP_ACCT_MSTR e,client_mstr clim
    WHERE  concm_id = accac_concm_id
    and   clim.clim_crn_no = e.dpam_Crn_no 
	and   e.dpam_id = c.ACCAC_CLISBA_ID
	AND   c.ACCAC_CONCM_ID = d.CONCM_ID
    and   c.accac_adr_conc_id = b.adr_id
    AND clim_lst_upd_dt BETWEEN CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103)
	and adr_lst_upd_dt < lst_dt
	and k.adr_id = b.adr_id
	and k.cl_code = e.dpam_sba_no
	and k.concm_desc = d.concm_desc
	group by e.dpam_sba_no,d.concm_desc
),lst_dt)
from #Climaddrdates k 



select distinct cl_code  ,lst_dt ,concm_DESC into #Climaddrdates1 from #Climaddrdates where lst_dt <>  lst_dt_actual





    
	/*   
    INSERT INTO #Climaddrdates_main(cl_code  ,lst_dt ,concm_DESC)
    SELECT e.dpam_sba_no, max(lst_dt),d.concm_DESC
    FROM  addr_hst b,ACCAC_HST c,conc_code_mstr  d,DP_ACCT_MSTR e,client_mstr clim,#Climaddrdates f
    WHERE  concm_id = accac_concm_id
    and   clim.clim_crn_no = e.dpam_Crn_no 
	and   e.dpam_id = c.ACCAC_CLISBA_ID
	AND   c.ACCAC_CONCM_ID = d.CONCM_ID
    and   f.cl_Code = e.dpam_sba_no
    and   f.concm_desc = d.concm_desc
	and   f.adr_id = b.adr_id
    and   b.adr_lst_upd_Dt < f.lst_dt
    AND clim_lst_upd_dt BETWEEN CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103)
    GROUP BY e.dpam_sba_no,d.concm_desc
*/

		insert into #tempadr1
		select distinct adr_id ,dpam_sba_no, concm.concm_DESC,adr_1, adr_2, adr_3 , adr_city, adr_state, adr_country, adr_zip , clim_lst_upd_dt
		from addr_hst , conc_code_mstr concm, dp_Acct_mstr , ACCAC_HST,client_mstr,#Climaddrdates1 a
		where concm_id = accac_concm_id
		and   accac_clisba_id = dpam_id
		and   accac_adr_conc_id = adr_id
        and   clim_crn_no = dpam_crn_no 
		and   isnull(adr_1,'') <> ''
		AND   a.cl_code = dp_Acct_mstr.DPAM_SBA_NO
		AND   a.lst_dt = adr_LST_UPD_DT
		AND   a.concm_DESC = concm.CONCM_desc 
        --and clim_lst_upd_dt between  CONVERT(DATETIME,@pa_from_dt,103)  and  CONVERT(DATETIME,@pa_to_dt,103) 
        AND clim_lst_upd_dt BETWEEN CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103)
    
    
  
    
		
        DELETE A FROM  #tempadr1 A, ADDRESSES B, conc_code_mstr CONCM, dp_Acct_mstr DPAM, ACCOUNT_ADR_CONC,client_mstr
		where CONCM.concm_id = accac_concm_id
		and   accac_clisba_id = dpam_id
		and   accac_adr_conc_id = B.adr_id 
        and   clim_crn_no = dpam_crn_no 
		and   isnull(B.adr_1,'') <> ''
        AND   A.DPAM_SBA_NO = DPAM.DPAM_SBA_NO
        AND   A.CONCM_desc = CONCM.CONCM_desc
        AND   ltrim(rtrim(A.ADR_1))= ltrim(rtrim(B.ADR_1))
        AND   ltrim(rtrim(A.ADR_2))= ltrim(rtrim(B.ADR_2))
		AND   ltrim(rtrim(A.ADR_3))= ltrim(rtrim(B.ADR_3))
		AND   ltrim(rtrim(A.ADR_CITY))= ltrim(rtrim(B.ADR_CITY))
		AND   ltrim(rtrim(A.ADR_COUNTRY))= ltrim(rtrim(B.ADR_COUNTRY))
		AND   ltrim(rtrim(A.ADR_STATE))= ltrim(rtrim(B.ADR_STATE))
		AND   ltrim(rtrim(A.ADR_ZIP))= ltrim(rtrim(B.ADR_ZIP))
        --and CONVERT(VARCHAR(11),clim_lst_upd_dt,103) between  @pa_from_dt and  @pa_to_dt
        AND clim_lst_upd_dt BETWEEN CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103)


        insert into #tempadr
        select distinct dpam_sba_no, dpam_sba_name,concm_desc, ltrim(rtrim(isnull(adr_1,'')+' '+isnull(adr_2,'')+' '+ isnull(adr_3,'')+' '+ isnull(adr_city,'')+' ' + isnull(adr_state,'') +' '+isnull(adr_country,'') +' ' +  isnull(adr_zip,''))),'',adr_lst_upd_by,adr_lst_upd_dt
		from addresses, conc_code_mstr , dp_Acct_mstr , account_adr_conc,client_mstr
		where concm_id = accac_concm_id
		and   accac_clisba_id = dpam_id
		and   accac_adr_conc_id = adr_id 
        and   clim_crn_no = dpam_crn_no 
		and   isnull(adr_1,'') <> ''
        --and clim_lst_upd_dt between  CONVERT(DATETIME,@pa_from_dt,103)  and  CONVERT(DATETIME,@pa_to_dt,103) 
        AND clim_lst_upd_dt BETWEEN CONVERT(DATETIME,@PA_FROM_DT,103) and  CONVERT(DATETIME,@PA_to_DT+' 23:59 ',103)
        and dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_FROM_ACCT))     = '' THEN '%' ELSE @PA_FROM_ACCT  END
  
        update main
        set  old_adr = isnull((select top 1  isnull(adr_1,'')+' '+isnull(adr_2,'')+' '+ isnull(adr_3,'')+' '+ isnull(adr_city,'')+' ' + isnull(adr_state,'') +' '+isnull(adr_country,'') +' ' +  isnull(adr_zip,'') 
              from #tempadr1 a
              where main.concm_desc = a.concm_desc 
			  and   main.dpam_sba_no = a.dpam_sba_no
              order by dt desc),'') 
        from #tempadr main 

        
        SELECT distinct a.dpam_sba_no,a.dpam_sba_name,a.concm_desc,a.new_adr,a.old_adr,a.lst_upd_by,a.lst_upd_dt
        FROM #tempadr a,#Climaddrdates1 b 
        WHERE a.dpam_sba_no=b.cl_code AND a.concm_desc = b.concm_DESC AND a.lst_upd_dt = b.lst_dt
        and a.old_adr <> '' and a.old_adr <> a.new_adr
  
  
  
   end  
  --   
    IF  @PA_TAB = 'ALL'   
     BEGIN  
      SELECT Distinct DPAM_SBA_NO,DPAM_SBA_NAME FROM DP_ACCT_MSTR WHERE dpam_lst_upd_dt  
      BETWEEN CONVERT(DATETIME,@pa_from_dt,103)  and  CONVERT(DATETIME,@pa_to_dt,103)   
      and dpam_sba_no LIKE CASE WHEN LTRIM(RTRIM(@PA_FROM_ACCT))     = '' THEN '%' ELSE @PA_FROM_ACCT  END  
     and DPAM_DPM_ID = @@dpmid
      AND dpam_deleted_ind=1  
     END   
--      
TRUNCATE TABLE #ACLIST      
DROP TABLE #ACLIST      
end

GO
