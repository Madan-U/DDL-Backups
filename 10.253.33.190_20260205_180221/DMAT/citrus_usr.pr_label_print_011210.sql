-- Object: PROCEDURE citrus_usr.pr_label_print_011210
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--exec pr_label_print 3,'jul 15 2009','sep 15 2009','','','1','ho|*~|',''

CREATE procedure [citrus_usr].[pr_label_print_011210]
( @pa_id numeric
, @pa_from_dt datetime
, @pa_to_dt datetime
, @pa_from_acct varchar(1000)
, @pa_to_acct varchar(1000)
, @pa_login_pr_entm_id numeric                        
, @pa_login_entm_cd_chain  varchar(8000) 
, @pa_out varchar(8000) out)
as
begin
  
  SET DATEFORMAT dmy

  declare @@l_child_entm_id numeric
  , @@dpmid NUMERIC
--  select convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd into #account_properties 
  select accp_value, accp_clisba_id , accp_accpm_prop_cd into #account_properties 
  from account_properties 
  where accp_accpm_prop_cd = 'BILL_START_DT' 
  and isnull(accp_value ,'') not in ('','//')
  and substring(accp_value,1,2) <> '00' 


  
IF @pa_from_acct = ''                      
 BEGIN                      
  SET @pa_from_acct = '0'                      
  SET @pa_to_acct = '99999999999999999'                      
 END                      
 IF @pa_to_acct = ''                      
 BEGIN                  
   SET @pa_to_acct = @pa_from_acct                      
 END       

select @@dpmid = dpm_id from dp_mstr with(nolock) where default_dp = @pa_ID and dpm_deleted_ind =1                      


select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)


CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)

INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		


select distinct '<td> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + DPAM.dpam_sba_no +'<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+ DPAM.dpam_sba_NAME + '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' 
+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),1) 
+ CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),1) <> '' THEN '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' ELSE '' END  
+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),2) 
+ CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),2) <> '' THEN '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' ELSE '' END  
+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),3) 
+ CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),3) <> '' THEN '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' ELSE '' END  
+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),4) 
+ CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),4) <> '' THEN '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' ELSE '' END  
+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),5) 
+ CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),5) <> '' THEN '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' ELSE '' END  
+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),6)  
+ CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),6) <> '' THEN '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' ELSE '' END  
+ citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),7)         
+ CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),7) <> '' THEN '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' ELSE '' END  
+ case when ISNULL(citrus_usr.fn_conc_value(dpam_crn_no,'MOBILE1'),'') <> '' then  ISNULL(citrus_usr.fn_conc_value(dpam_crn_no,'MOBILE1'),'') 
       when ISNULL(citrus_usr.fn_conc_value(dpam_crn_no,'RES_PH1'),'') <> '' then  ISNULL(citrus_usr.fn_conc_value(dpam_crn_no,'RES_PH1'),'') ELSE '' end 
+ ''



+ CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),1) = ''  THEN '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>' ELSE '' END  
+ CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),2) = '' THEN '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>' ELSE '' END  
+ CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),3) = '' THEN '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>' ELSE '' END  
+ CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),4) = '' THEN '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>' ELSE '' END  
+ CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),5) = '' THEN '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>' ELSE '' END  
+ CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),6) = '' THEN '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>' ELSE '' END  
+ CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),7) = '' THEN '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>' ELSE '' END  
+ case when ISNULL(citrus_usr.fn_conc_value(dpam_crn_no,'MOBILE1'),'') = '' and ISNULL(citrus_usr.fn_conc_value(dpam_crn_no,'RES_PH1'),'') = '' then  '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>' ELSE '' END  
       


--          +'<td>'  + DPAM.dpam_sba_no +'<br>'+ DPAM.dpam_sba_NAME + '<br>' + citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),1) 
--                                                        + CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),1) <> '' THEN '<br>' ELSE '' END  + citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),2) 
--																																																						+ CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),2) <> '' THEN '<br>' ELSE '' END  + citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),3) 
--																																																					 + CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),3) <> '' THEN '<br>' ELSE '' END  + citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),4) 
--																																																					 + CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),4) <> '' THEN '<br>' ELSE '' END  + citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),5) 
--																																																					 + CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),5) <> '' THEN '<br>' ELSE '' END  + citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),6)  
--																																																					 + CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),6) <> '' THEN '<br>' ELSE '' END  + citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),7)         
--                                                      + CASE WHEN citrus_usr.fn_splitval(citrus_usr.fn_addr_value(dpam_crn_no,'COR_ADR1'),7) <> '' THEN '<br>' ELSE '' END  + case when ISNULL(citrus_usr.fn_conc_value(dpam_crn_no,'MOBILE1'),'') <> '' then  ISNULL(citrus_usr.fn_conc_value(dpam_crn_no,'MOBILE1'),'') 
--                                                                              when ISNULL(citrus_usr.fn_conc_value(dpam_crn_no,'RES_PH1'),'') <> '' then  ISNULL(citrus_usr.fn_conc_value(dpam_crn_no,'RES_PH1'),'') ELSE '' end 
--          + '<br><br></td>'
           LABEL_DESC
  into #label_desc_main
  from dp_acct_mstr dpam
    ,  dp_mstr ,#account_properties , #ACLIST account
  where accp_clisba_id = dpam.dpam_id and account.dpam_id = dpam.dpam_id 
  and   dpam.dpam_dpm_id = dpm_id 
  and  default_dp = dpm_excsm_id 
  and  dpm_excsm_id = @pa_id
  and  isnumeric(DPAM.dpam_sba_no)=1
  and  convert(datetime,accp_value,103) between   @pa_from_dt and @pa_to_dt
  and  dpam.dpam_sba_no >= @pa_from_acct and dpam.dpam_sba_no <=  @pa_to_acct
  and  citrus_usr.fn_addr_value(dpam.dpam_crn_no,'COR_ADR1') <> '' 


  select identity(bigint,1,1) id , LABEL_DESC
           LABEL_DESC
  into #label_desc
  from #label_desc_main
  

  select  case when id % 2 <> 0 then '<tr>' + label_desc + '<br><br></td>' else    label_desc + '<br><br></td></tr>'  end  LABEL_DESC from #label_desc

end

GO
