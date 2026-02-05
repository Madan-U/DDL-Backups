-- Object: PROCEDURE citrus_usr.Pr_Rpt_Slip_Intimation
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec Pr_Rpt_Slip_Intimation 4,'','','Sep  3 2009','jan 29 2010',1,'HO|*~|',''	
--select * from dp_mstr
--Pr_Rpt_Slip_Intimation 3,'','','jan 30 2010','jan 30 2010',1,'HO|*~|',''
--select distinct sliim_dpam_acct_no from slip_issue_mstr
CREATE procedure [citrus_usr].[Pr_Rpt_Slip_Intimation]      
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
	if @pa_frmboid =''
	begin
		set @pa_frmboid ='0'	
		set @pa_toboid='99999999999999999'
	end   
	if @pa_toboid =''
	begin
		set @pa_toboid = @pa_frmboid
	end
    
 Select
		dpam.dpam_sba_name    ACCTNAME      
        ,dpam.dpam_sba_no     ACCNO      
        ,enttm.enttm_desc        CATEGORY       
        ,clicm.clicm_desc        TYPE      
        ,subcm_desc              SUBTYPE      
        ,trastm_desc             TTYPE      
        ,sliim_series_type       SERIESTYPE      
        ,sliim_slip_no_fr        SLIPNOFROM      
        ,sliim_slip_no_to        SLIPNOTO      
        ,(CONVERT(NUMERIC,sliim_slip_no_to) - CONVERT(NUMERIC,sliim_slip_no_fr))+ 1      NOOFSLIPS      
        , case when citrus_usr.[fn_acct_addr_value](dpam.dpam_id,'ACC_COR_ADR1') <> '' then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.DPAM_id,'ACC_COR_ADR1'),''),1) + ' ' + citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.DPAM_id,'ACC_COR_ADR1'),''),2) else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(dpam.DPAM_CRN_NO,'COR_ADR1'),''),1) + ' ' + citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(dpam.DPAM_CRN_NO,'COR_ADR1'),''),2) end    address      
        , case when citrus_usr.[fn_acct_addr_value](dpam.dpam_id,'ACC_COR_ADR1') <> '' then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.DPAM_id,'ACC_COR_ADR1'),''),3)  else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(dpam.DPAM_CRN_NO,'COR_ADR1'),''),3)  end    adr3  
        , case when citrus_usr.[fn_acct_addr_value](dpam.dpam_id,'ACC_COR_ADR1') <> '' then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.DPAM_id,'ACC_COR_ADR1'),''),4) + ' - ' + citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.DPAM_id,'ACC_COR_ADR1'),''),7) else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(dpam.DPAM_CRN_NO,'COR_ADR1'),''),4) + ' - ' + citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(dpam.DPAM_CRN_NO,'COR_ADR1'),''),7) end    city      
        , case when citrus_usr.[fn_acct_addr_value](dpam.dpam_id,'ACC_COR_ADR1') <> '' then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.DPAM_id,'ACC_COR_ADR1'),''),5)  else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(dpam.DPAM_CRN_NO,'COR_ADR1'),''),5)  end    state          
        , case when citrus_usr.[fn_acct_addr_value](dpam.dpam_id,'ACC_COR_ADR1') <> '' then citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_acct_addr_value(dpam.DPAM_id,'ACC_COR_ADR1'),''),6)  else citrus_usr.fn_splitval(ISNULL(citrus_usr.fn_addr_value(dpam.DPAM_CRN_NO,'COR_ADR1'),''),6)  end    country           
		, citrus_usr.fn_conc_value(dpam.DPAM_CRN_NO,'MOBILE1') phone
        , citrus_usr.fn_ucc_entp(dpam.DPAM_CRN_NO,'PAN_GIR_NO','') PAN
        , STAM.STAM_DESC STAM_DESC
		, citrus_usr.fn_conc_value(dpam.DPAM_CRN_NO,'Email1') email
		, footer = (select l_values from acct_inti_footer) 
		, convert(varchar(11),sliim_lst_upd_dt,103) date
 from	 dp_acct_mstr dpam 
		,slip_book_mstr 
		,slip_issue_mstr left outer join transaction_sub_type_mstr on trastm_id = sliim_tratm_id 
		,entity_type_mstr  ENTTM      
		,client_ctgry_mstr CLICM      
		,sub_ctgry_mstr    SUBCM
		,status_mstr       stam  
where SLIIM_DPAM_ACCT_NO = dpam.dpam_sba_no  
AND  sliim_dpm_id = 203412  
 and  SLIBM_FROM_NO = SLIIM_SLIP_NO_FR
 and  SLIBM_TO_NO = SLIIM_SLIP_NO_TO
 and  SLIBM_SERIES_TYPE = SLIIM_SERIES_TYPE
 AND  DPAM.dpam_enttm_cd = ENTTM.ENTTM_CD      
 AND  DPAM.dpam_clicm_cd = CLICM.CLICM_CD      
 AND  DPAM.dpam_subcm_cd = SUBCM.SUBCM_CD  
 AND  DPAM.DPAM_STAM_CD  = STAM.STAM_CD 
AND (convert(numeric,dpam.DPAM_sba_NO) between convert(numeric,@pa_frmboid) AND  convert(numeric,@pa_toboid))
AND (convert(datetime,sliim_lst_upd_dt,103) BETWEEN convert(datetime,@pa_frmactivation_dt,103) and convert(datetime,@pa_toactivation_dt,103)   )
 AND  isnull(sliim_deleted_ind,1) =1      
 --AND  isnull(trastm_deleted_ind,1) =1      
 AND  DPAM.dpam_deleted_ind = 1      
 AND  ENTTM.enttm_deleted_ind = 1      
 AND  CLICM.clicm_deleted_ind = 1      
 AND  SUBCM.subcm_deleted_ind = 1  
 and DPAM_STAM_CD = 'Active'       
--      
END

GO
