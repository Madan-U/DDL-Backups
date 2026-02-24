-- Object: PROCEDURE citrus_usr.Pr_Rpt_03Summary
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--[Pr_Rpt_03Summary] 'nsdl',4,'Y','','','','','Y',1,'HO|*~|',''  
--select * from dp_mstr  
  
CREATE Proc [citrus_usr].[Pr_Rpt_03Summary]  
@pa_dptype varchar(4),                    
@pa_excsmid int,                    
@pa_asondate char(1),                    
@pa_fordate datetime,                    
@pa_fromaccid varchar(16),                    
@pa_toaccid varchar(16),                    
@pa_isincd varchar(12),              
@pa_withvalue char(1), --Y/N                    
@pa_login_pr_entm_id numeric,                      
@pa_login_entm_cd_chain  varchar(8000),                      
@pa_output varchar(8000) output                      
as                          
begin                          
         
  
  
create table #temp(DPAM_ID numeric,AcctName varchar(1000),AcctNo varchar(20),Valuation numeric(18,3))     
                 
declare @@dpmid int,                          
@@tmpholding_dt datetime  
select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                          
declare @@l_child_entm_id      numeric                      
select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                      
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)  
                    
                    
if @pa_fromaccid = ''                    
begin                    
 set @pa_fromaccid = '0'                    
 set @pa_toaccid = '99999999999999999'                    
end                      
if @pa_toaccid = ''                    
begin                    
 set @pa_toaccid = @pa_fromaccid                    
end                    
                        
                       
                        
IF @pa_toaccid =''                          
BEGIN                          
SET @pa_toaccid= @pa_fromaccid               
END                          
              
           
 IF @pa_withvalue ='Y'              
 BEGIN              
 if @pa_dptype = 'NSDL'                          
 BEGIN              
   IF @pa_asondate = 'Y'                          
   BEGIN              
  select top 1 @pa_fordate = DPDHM_HOLDING_DT from DP_HLDG_MSTR_NSDL where dpdhm_deleted_ind =1              
  
  INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)    
    
        insert into #temp     
  select  DPAM_ID=DPDHM_DPAM_ID,DPAM_SBA_NAME AcctName,DPAM_sba_NO AcctNo  
  ,Valuation= convert(numeric(18,3),DPDHM_QTY*isnull(clopm_nsdl_rt,0))     
  from DP_HLDG_MSTR_NSDL                
  LEFT OUTER JOIN ISIN_MSTR ON DPDHM_ISIN = ISIN_CD              
  LEFT OUTER JOIN CLOSING_LAST_NSDL on DPDHM_ISIN = CLOPM_ISIN_CD ,                    
  #ACLIST account,    
  citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') BEN                                
  where DPDHM_HOLDING_DT = @pa_fordate and DPDHM_DPM_ID = @@dpmid                          
  and DPDHM_dpam_id = account.dpam_id      
         and isnumeric(dpam_sba_no ) = 1                  
  and (DPDHM_HOLDING_DT between eff_from and eff_to)                    
  AND (convert(numeric,DPAM_sba_NO) between convert(numeric,@pa_fromaccid) AND  convert(numeric,@pa_toaccid))                          
  AND DPDHM_ISIN LIKE @pa_isincd + '%'    
  AND DPDHM_BENF_ACCT_TYP = BEN.CD      
  AND DPDHM_QTY <> 0       
          
  order by DPAM_sba_NO,ISIN_NAME,DPDHM_ISIN,DPDHM_BENF_ACCT_TYP                          
   END                          
   ELSE                          
   BEGIN       
  select top 1 @@tmpholding_dt = case when DPDHM_HOLDING_DT > @pa_fordate then @pa_fordate else DPDHM_HOLDING_DT end from DP_HLDG_MSTR_NSDL where dpdhm_deleted_ind =1   
            
        insert into #temp              
  select  DPAM_ID=dpdhmd_dpam_id,dpam_sba_name AcctName,dpam_sba_no AcctNo  
  ,Valuation= convert(numeric(18,3),dpdhmd_qty*isnull(clopm_nsdl_rt,0))     
        from fn_dailyholding(@@dpmid,@pa_fordate,@pa_fromaccid,@pa_toaccid,@pa_isincd,'',@pa_login_pr_entm_id,@@l_child_entm_id)   
  LEFT OUTER JOIN ISIN_MSTR ON DPDHMD_ISIN = ISIN_CD              
  LEFT OUTER JOIN CLOSING_LAST_NSDL on DPDHMD_ISIN = CLOPM_ISIN_CD,                    
  citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') BEN                                 
  where DPDHMD_BENF_ACCT_TYP = BEN.CD     
  order by DPAM_sba_NO,ISIN_NAME,DPDHMD_ISIN,DPDHMD_BENF_ACCT_TYP                          
   END                          
                          
                              
 END                          
        
              
              
END              
   
select a.dpam_id  
,acctname  
,acctno  
,sum(valuation) valuation   
,citrus_usr.fn_splitval(citrus_usr.[fn_addr_value](dpam_crn_no,'COR_ADR1'),1) adr1   
, citrus_usr.fn_splitval(citrus_usr.[fn_addr_value](dpam_crn_no,'COR_ADR1'),2) adr2   
, citrus_usr.fn_splitval(citrus_usr.[fn_addr_value](dpam_crn_no,'COR_ADR1'),3) adr3   
, citrus_usr.fn_splitval(citrus_usr.[fn_addr_value](dpam_crn_no,'COR_ADR1'),4) city   
, citrus_usr.fn_splitval(citrus_usr.[fn_addr_value](dpam_crn_no,'COR_ADR1'),5) state   
, citrus_usr.fn_splitval(citrus_usr.[fn_addr_value](dpam_crn_no,'COR_ADR1'),6) country  
, citrus_usr.fn_splitval(citrus_usr.[fn_addr_value](dpam_crn_no,'COR_ADR1'),7) zip  
, isnull(citrus_usr.fn_conc_value(dpam_crn_no ,'OFF_PH1'),'') phone1   
from #temp a, dp_acct_mstr   
where a.acctno = dpam_sba_no and dpam_stam_Cd = '03'  
group by a.dpam_id, acctname,acctno,dpam_crn_no  
  
  
  
  
      TRUNCATE TABLE #ACLIST  
   DROP TABLE #ACLIST             
                          
END

GO
