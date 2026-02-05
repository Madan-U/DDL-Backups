-- Object: PROCEDURE citrus_usr.Pr_Rpt_Acct_Intimation_bak_08122015
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


--exec Pr_Rpt_Acct_Intimation 3,'','','Sep  3 2008','Sep  3 2009 23:59:59',1,'HO|*~|',''	



--select * from dp_mstr
--Pr_Rpt_Acct_Intimation 4,'','','may 11 2008','may 18 2009',1,'HO*|~*',''
--select distinct sliim_dpam_acct_no from slip_issue_mstr
create procedure [citrus_usr].[Pr_Rpt_Acct_Intimation_bak_08122015]      
(      
  @pa_excsmid  int      
  ,@pa_frmboid varchar(20)      
  ,@pa_toboid varchar(20)      
  ,@pa_frmactivation_dt datetime     
  ,@pa_toactivation_dt datetime    
  ,@pa_login_pr_entm_id numeric      
  ,@pa_login_entm_cd_chain  varchar(8000)      
  ,@pa_output varchar(8000) output      
)      
AS      
BEGIN      
--      
 DECLARE @l_dpm_id  int      
  ,@@l_child_entm_id numeric  

	if @pa_frmboid =''
	begin
		set @pa_frmboid ='0'	
		set @pa_toboid='99999999999999999'
	end   
	if @pa_toboid =''
	begin
		set @pa_toboid = @pa_frmboid
	end
       
 SELECT @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                
     
          
 select @l_dpm_id = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1              


  CREATE TABLE #ACLIST(dpam_crn_no BIGINT,dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)

  INSERT INTO #ACLIST 
  SELECT dpam_crn_no,DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO 
  FROM citrus_usr.[fn_acct_list_bytushar](@l_dpm_id ,@pa_login_pr_entm_id,@@l_child_entm_id,@pa_frmboid,@pa_toboid)		
  where eff_from between @pa_frmactivation_dt and @pa_toactivation_dt
  
  select convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd into #account_properties 
  from account_properties ,dp_acct_mstr  dpam
  where accp_accpm_prop_cd = 'BILL_START_DT'  and DPAM_ID = ACCP_CLISBA_ID  and ISNUMERIC(DPAM_SBA_NO )= 1
  and convert(numeric,dpam.DPAM_SBA_NO     ) between convert(numeric,@pa_frmboid) AND  convert(numeric,@pa_toboid)       
  and isnull(accp_value ,'') not in ( '','//')
  and substring(accp_value,1,2) <> '00' 
  

 SELECT distinct  account.dpam_sba_name    ACCTNAME      
        ,account.dpam_sba_no     ACCNO      
        ,enttm.enttm_desc        CATEGORY       
        ,clicm.clicm_desc        TYPE      
        ,subcm_desc              SUBTYPE      
        ,trastm_desc             TTYPE      
        ,sliim_series_type       SERIESTYPE      
        ,sliim_slip_no_fr        SLIPNOFROM      
        ,sliim_slip_no_to        SLIPNOTO      
        ,(CONVERT(NUMERIC,sliim_slip_no_to) - CONVERT(NUMERIC,sliim_slip_no_fr))+ 1      NOOFSLIPS      
        --, case when citrus_usr.[fn_acct_addr_value](account.dpam_id,'ACC_COR_ADR1') <> '' then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(ACCOUNT.DPAM_id,'ACC_COR_ADR1'),''),1) + ' ' + citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(ACCOUNT.DPAM_id,'ACC_COR_ADR1'),''),2) else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(ACCOUNT.DPAM_CRN_NO,'COR_ADR1'),''),1) + ' ' + citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(ACCOUNT.DPAM_CRN_NO,'COR_ADR1'),''),2) end    address      
        --, case when citrus_usr.[fn_acct_addr_value](account.dpam_id,'ACC_COR_ADR1') <> '' then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(ACCOUNT.DPAM_id,'ACC_COR_ADR1'),''),3)  else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(ACCOUNT.DPAM_CRN_NO,'COR_ADR1'),''),3)  end    adr3  
        --, case when citrus_usr.[fn_acct_addr_value](account.dpam_id,'ACC_COR_ADR1') <> '' then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(ACCOUNT.DPAM_id,'ACC_COR_ADR1'),''),4) + ' - ' + citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(ACCOUNT.DPAM_id,'ACC_COR_ADR1'),''),7) else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(ACCOUNT.DPAM_CRN_NO,'COR_ADR1'),''),4) + ' - ' + citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(ACCOUNT.DPAM_CRN_NO,'COR_ADR1'),''),7) end    city      
        --, case when citrus_usr.[fn_acct_addr_value](account.dpam_id,'ACC_COR_ADR1') <> '' then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(ACCOUNT.DPAM_id,'ACC_COR_ADR1'),''),5)  else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(ACCOUNT.DPAM_CRN_NO,'COR_ADR1'),''),5)  end    state          
        --, case when citrus_usr.[fn_acct_addr_value](account.dpam_id,'ACC_COR_ADR1') <> '' then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(ACCOUNT.DPAM_id,'ACC_COR_ADR1'),''),6)  else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(ACCOUNT.DPAM_CRN_NO,'COR_ADR1'),''),6)  end    country          
        ,pc1.Addr1 + ' ' + pc1.addr2 address      
        ,pc1.addr3 adr3  
        ,pc1.city city
        ,pc1.state state
        ,pc1.country + ' - ' +  pc1.PinCode country 
        ,pc1.PinCode pin 
        ,pc1.PriPhNum  phone
        ,pc1.pangir PAN
        ,STAM.STAM_DESC STAM_DESC
        ,pc2.pangir DPHD_SH_PAN_NO
        ,pc1.EMailId  email
        ,BROM_DESC = (select TOP 1 BROM_DESC from brokerage_mstr , client_dp_brkg 
        where clidb_brom_id = brom_id and clidb_dpam_id = DPAM.dpam_id and clidb_deleted_ind = 1)
        ,clientgroup  = citrus_usr.[fn_find_relations_nm](ACCOUNT.DPAM_CRN_NO,'GROUP') 
        ,clientfamily = citrus_usr.[fn_find_relations_nm](ACCOUNT.DPAM_CRN_NO,'FM') 
        ,clientbranch = citrus_usr.[fn_find_relations_nm](ACCOUNT.DPAM_CRN_NO,'BR') 
        ,Nominee = pc6.Name + ' ' + pc6.MiddleName  + ' ' + pc6.SearchName   
        ,sh_hld = pc2.Name + ' ' + pc2.MiddleName  + ' ' + pc2.SearchName 
        ,th_hld= pc3.Name + ' ' + pc3.MiddleName  + ' ' + pc3.SearchName 
        ,account_act_dt = left (pc1.AcctCreatDt,2)+'/'+substring (pc1.AcctCreatDt,3,2)+'/'+right(pc1.AcctCreatDt,4) 
        ,backofficecode = DPAM_BBO_CODE 
        ,bank_name = BANM_NAME 
        ,micr = banm_micr 
        ,account_no = CLIBA_AC_NO
        , footer = (select l_values from acct_inti_footer)
        ,''  slibm_book_name, convert(varchar(11),sliim_lst_upd_dt,103) date
        
        
 FROM   #ACLIST ACCOUNT ,dps8_pc1 pc1 left outer join dps8_pc2 pc2 on pc1.BOId = pc2.BOId 
 left outer join dps8_pc3 pc3 on pc1.BOId = pc3.BOId 
 left outer join dps8_pc6 pc6 on pc1.BOId = pc6.BOId 
        --, slip_book_mstr          
       ,slip_issue_mstr   
       left outer join transaction_sub_type_mstr on trastm_id       = sliim_tratm_id       
       ,dp_acct_mstr      DPAM
      --  LEFT OUTER JOIN dp_holder_dtls DPHD ON DPAM.DPAM_ID=DPHD.DPHD_DPAM_ID AND DPHD_DELETED_IND=1      
        left outer join client_bank_accts on cliba_clisba_id = dpam.dpam_id  and cliba_deleted_ind = 1
        left outer join bank_mstr on banm_id = cliba_banm_id and banm_deleted_ind = 1
       ,entity_type_mstr  ENTTM      
       ,client_ctgry_mstr CLICM      
       ,sub_ctgry_mstr    SUBCM
       ,status_mstr       stam    , #account_properties  
 WHERE pc1.boid = ACCOUNT.dpam_sba_no and isnumeric(dpam.dpam_sba_no ) =1 and isnumeric(account.dpam_sba_no) = 1 
 and DPAM.dpam_sba_no   = ACCOUNT.DPAM_sba_no AND DPAM.DPAM_ID = ACCP_CLISBA_ID 
 AND (convert(numeric,ACCOUNT.DPAM_sba_NO) between convert(numeric,@pa_frmboid) AND  convert(numeric,@pa_toboid))       
  AND (convert(datetime,ISNULL(accp_value,'01/01/1990'),103) BETWEEN convert(datetime,@pa_frmactivation_dt,103) and convert(datetime,@pa_toactivation_dt,103))    

 --and  SLIBM_FROM_NO = SLIIM_SLIP_NO_FR
 --and  SLIBM_TO_NO = SLIIM_SLIP_NO_TO
 --and  SLIBM_SERIES_TYPE = SLIIM_SERIES_TYPE
 AND  DPAM.dpam_enttm_cd = ENTTM.ENTTM_CD      
 AND  DPAM.dpam_clicm_cd = CLICM.CLICM_CD      
 AND  DPAM.dpam_subcm_cd = SUBCM.SUBCM_CD  
 AND  DPAM.DPAM_STAM_CD  = STAM.STAM_CD     
 and  SLIIM_DPAM_ACCT_NO = ACCOUNT.dpam_sba_no  AND  sliim_dpm_id = @l_dpm_id        
 --AND (convert(datetime,ISNULL(citrus_usr.fn_ucc_accp(ACCOUNT.dpam_id,'BILL_START_DT',''),'01/01/1900'),103) BETWEEN convert(datetime,@pa_frmactivation_dt,103) and convert(datetime,@pa_toactivation_dt,103))    
 AND  isnull(sliim_deleted_ind,1) =1      
 AND  isnull(trastm_deleted_ind,1) =1      
 AND  DPAM.dpam_deleted_ind = 1      
 AND  ENTTM.enttm_deleted_ind = 1      
 AND  CLICM.clicm_deleted_ind = 1      
 AND  SUBCM.subcm_deleted_ind = 1 
 and  not exists ( SELECT USES_SLIP_NO  FROM USED_SLIP_BLOCK where SLIIM_SLIP_NO_FR = USES_SLIP_NO   and USES_DELETED_IND =1)
 and DPAM_STAM_CD = 'Active'    
 ORDER BY ACCOUNT.dpam_sba_no

      TRUNCATE TABLE #ACLIST
	  DROP TABLE #ACLIST 
--      
END

GO
