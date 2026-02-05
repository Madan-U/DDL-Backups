-- Object: PROCEDURE citrus_usr.Pr_rpt_consolidated_reports_bak27012012
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

/*
please pass @pa_report as 
1 for : Account Opened during period having same address 
2 for : Bad PAN :  done
3 for : Shares credited by Off-Market and went to payin : 
4 for : Off Market Credit value greater than :
5 for : ISIN from one account to different : done
6 for : ISIN from different account to one account : done  
7 for : High No of transactions between two accounts : done 
8 for : Duplicate PAN : done 
9 for : Missing PAN : done


*/

--select * from dp_mstr where default_dp = dpm_excsm_id 
--exec 	[Pr_rpt_consolidated_reports] 'CDSL','3',2,'jan 01 1900','jan 01 2012','','','','',0,0,1,'HO|*~|',''
--exec 	[Pr_rpt_consolidated_reports] 'CDSL','3',8,'jan 01 2001','jan 01 2012','','','','',0,0,1,'HO|*~|',''
--exec 	[Pr_rpt_consolidated_reports] 'CDSL','3',9,'jan 01 1900','jan 01 2012','','','','',0,0,1,'HO|*~|',''
--exec 	[Pr_rpt_consolidated_reports] 'CDSL','3',5,'jan 01 2011','jan 01 2012','','','','',0,0,1,'HO|*~|',''
--exec 	[Pr_rpt_consolidated_reports] 'CDSL','3',6,'jan 01 2011','jan 01 2012','','','','',0,0,1,'HO|*~|',''
--exec 	[Pr_rpt_consolidated_reports] 'CDSL','3',7,'jan 01 2011','jan 01 2012','','','','',0,0,1,'HO|*~|',''


create procedure  [citrus_usr].[Pr_rpt_consolidated_reports_bak27012012]              
@pa_dptype varchar(4),                      
@pa_excsmid int,    
@pa_report numeric,                  
@pa_fromdate datetime,                      
@pa_todate datetime,                      
@pa_fromaccid varchar(16),                      
@pa_toaccid varchar(16),  
@pa_pan varchar(20),
@pa_isin varchar(20),
@pa_noofdays numeric,
@pa_valus numeric(18,2),
@pa_login_pr_entm_id numeric,                        
@pa_login_entm_cd_chain  varchar(8000),                        
@pa_output varchar(8000) output
AS                      
BEGIN                      
              
              
set nocount on             
set transaction isolation level read uncommitted   
 declare @@dpmid int,  
 @@l_child_entm_id numeric

 select @@dpmid = dpm_id from dp_mstr with(nolock) where default_dp = @pa_excsmid and dpm_deleted_ind =1                      
 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)


 
                       
 IF @pa_fromaccid = ''                      
 BEGIN                      
  SET @pa_fromaccid = '0'                      
  SET @pa_toaccid = '99999999999999999'                      
 END                      
 IF @pa_toaccid = ''                      
 BEGIN                  
   SET @pa_toaccid = @pa_fromaccid                      
 END                      

select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id 
, accp_accpm_prop_cd into #account_properties 
from account_properties where accp_accpm_prop_cd = 'BILL_START_DT'
and accp_value not in ('  /  /    '
,'/  /'
,'//')
and left(accp_value ,2) <> '00' 


create index ix_2 on #account_properties(accp_clisba_id,accp_value)

    CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)

	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		

           
    create index ix_1 on #ACLIST (dpam_sba_no)
    
     --select * into tusharACLIST from #ACLIST
     --return 
        
   if @pa_report = 2
   begin
   

				select a.dpam_sba_no [client Id]
				,'1st holder' [holder]
				,a.dpam_sba_name [name]
				,citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','') [pan no]
				,isnull(citrus_usr.fn_conc_value(dpam_crn_no,'OFF_Ph1'),'')  [Telephone No]
				,isnull(citrus_usr.fn_conc_value(dpam_crn_no,'RES_Ph1'),'')  [Telephone No 2]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](a.dpam_sba_no,'groupcd'),'') [Group Code]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](a.dpam_sba_no,'FAMILY'),'') [Family]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](a.dpam_sba_no,'BR'),'')  [branch]
				from dp_acct_mstr a,#ACLIST b, #account_properties
				where dpam_deleted_ind = 1 
				and a.dpam_sba_no = b.dpam_sba_no
				and a.dpam_id = accp_clisba_id 
				and isnumeric(a.dpam_sba_no )=1
				and a.dpam_sba_no between @pa_fromaccid and @pa_toaccid
				and accp_value between @pa_fromdate and @pa_todate
				and citrus_usr.fn_bad_pan(citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no',''))='Y'
				and citrus_usr.fn_ucc_entp(dpam_crn_no,'pan_gir_no','')<>''
				union
				select DPHD_DPAM_SBA_NO [client Id]
				,'2nd holder' [holder]
				,DPHD_SH_FNAME + ' ' + isnull(DPHD_SH_MNAME,'') + ' ' + isnull(DPHD_SH_LNAME,'') [name]
				,isnull(DPHD_SH_PAN_NO,'') [pan no]
				,''  [Telephone No]
				,''  [Telephone No 2]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](DPHD_DPAM_SBA_NO,'groupcd'),'') [Group Code]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](DPHD_DPAM_SBA_NO,'FAMILY'),'') [Family]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](DPHD_DPAM_SBA_NO,'BR'),'') [branch]
				from dp_holder_dtls a ,#ACLIST b, #account_properties
				where dpHD_deleted_ind = 1 
				and a.DPHD_DPAM_SBA_NO = b.dpam_sba_no 
				and a.DPHD_DPAM_ID = accp_clisba_id 
				and isnumeric(a.DPHD_DPAM_SBA_NO )=1
				and a.DPHD_DPAM_SBA_NO between @pa_fromaccid and @pa_toaccid
				and accp_value between @pa_fromdate and @pa_todate
				and citrus_usr.fn_bad_pan(DPHD_SH_PAN_NO)='Y'
				and isnull(DPHD_SH_PAN_NO,'') <>''
				union
				select DPHD_DPAM_SBA_NO [client Id]
				,'3rd holder' [holder]
				,DPHD_TH_FNAME + ' ' + isnull(DPHD_TH_MNAME,'') + ' ' + isnull(DPHD_TH_LNAME,'') [name]
				,isnull(DPHD_TH_PAN_NO,'') [pan no]
				,'' [Telephone No]
				,''  [Telephone No 2]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](DPHD_DPAM_SBA_NO,'groupcd'),'') [Group Code]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](DPHD_DPAM_SBA_NO,'FAMILY'),'')  [Family]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](DPHD_DPAM_SBA_NO,'BR'),'') [branch]
				from dp_holder_dtls a ,#ACLIST b, #account_properties
				where dpHD_deleted_ind = 1 
				and a.DPHD_DPAM_SBA_NO = b.dpam_sba_no 
				and a.DPHD_DPAM_ID = accp_clisba_id 
				and isnumeric(a.DPHD_DPAM_SBA_NO )=1
				and a.DPHD_DPAM_SBA_NO between @pa_fromaccid and @pa_toaccid
				and accp_value between @pa_fromdate and @pa_todate
				and citrus_usr.fn_bad_pan(DPHD_TH_PAN_NO)='Y'
				and isnull(DPHD_TH_PAN_NO,'') <>''


 
   end 
   if @pa_report = 8
   begin
   
			DECLARE  @L_DUP_PAN_NO TABLE([CLIENT ID] VARCHAR(20),[CLIENT NAME] VARCHAR(200),HOLDER VARCHAR(50))

			SELECT PAN,[CLIENT ID],[CLIENT NAME],[HOLDER]  INTO #TEMPDATA
			FROM (
			SELECT CITRUS_USR.FN_UCC_ENTP(DPAM_CRN_NO,'PAN_GIR_NO','') PAN
			,a.DPAM_SBA_NO [CLIENT ID]
			,a.DPAM_SBA_NAME  [CLIENT NAME]
			,'1ST HOLDER' [HOLDER]
			FROM DP_ACCT_MSTR a ,#ACLIST b, #account_properties
			WHERE DPAM_DELETED_IND = 1
			and a.dpam_sba_no = b.dpam_sba_no
			and isnumeric(a.dpam_sba_no )=1
			and a.dpam_sba_no between @pa_fromaccid and @pa_toaccid
			and accp_value between @pa_fromdate and @pa_todate
			and a.dpam_id = accp_clisba_id
			AND CITRUS_USR.FN_UCC_ENTP(DPAM_CRN_NO,'PAN_GIR_NO','') <> '' 
			UNION
			SELECT ISNULL(DPHD_SH_PAN_NO,'') PAN 
			,DPHD_DPAM_SBA_NO  [CLIENT ID]
			,DPHD_SH_FNAME + ' ' + ISNULL(DPHD_SH_MNAME,'') + ' ' + ISNULL(DPHD_SH_LNAME,'')    [CLIENT NAME]
			,'2ND HOLDER' [HOLDER]
			FROM DP_HOLDER_DTLS a,#ACLIST b, #account_properties
			WHERE DPHD_DELETED_IND = 1 
			and a.DPHD_DPAM_SBA_NO = b.dpam_sba_no 
				and a.DPHD_DPAM_ID = accp_clisba_id
				and isnumeric(a.DPHD_DPAM_SBA_NO )=1
				and a.DPHD_DPAM_SBA_NO between @pa_fromaccid and @pa_toaccid
				and accp_value between @pa_fromdate and @pa_todate
			AND ISNULL(DPHD_SH_PAN_NO,'') <>''
			UNION
			SELECT ISNULL(DPHD_TH_PAN_NO,'') PAN
			,DPHD_DPAM_SBA_NO  [CLIENT ID]
			,DPHD_TH_FNAME + ' ' + ISNULL(DPHD_TH_MNAME,'') + ' ' + ISNULL(DPHD_TH_LNAME,'')   [CLIENT NAME] 
			,'3RD HOLDER' [HOLDER]
			FROM DP_HOLDER_DTLS a,#ACLIST b, #account_properties
			WHERE DPHD_DELETED_IND = 1
			and a.DPHD_DPAM_SBA_NO = b.dpam_sba_no 
				and a.DPHD_DPAM_ID = accp_clisba_id
				and isnumeric(a.DPHD_DPAM_SBA_NO )=1
				and a.DPHD_DPAM_SBA_NO between @pa_fromaccid and @pa_toaccid
				and accp_value between @pa_fromdate and @pa_todate 
			AND ISNULL(DPHD_TH_PAN_NO,'') <>''
			) A 


			SELECT COUNT(1) ID , PAN INTO #MULTIPAN FROM #TEMPDATA
			GROUP BY PAN 
			HAVING COUNT(1) > 1


			SELECT A.* FROM #TEMPDATA A ,#MULTIPAN B
			WHERE A.PAN = B.PAN 

   end 
   if @pa_report = 9
   begin
   
			

			
			SELECT  a.dpam_sba_no [client Id]
				,'1st holder' [holder]
				,a.dpam_sba_name [name]
				,isnull(citrus_usr.fn_conc_value(dpam_crn_no,'OFF_Ph1'),'')  [Telephone No]
				,isnull(citrus_usr.fn_conc_value(dpam_crn_no,'RES_Ph1'),'')  [Telephone No 2]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](a.dpam_sba_no,'groupcd'),'') [Group Code]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](a.dpam_sba_no,'FAMILY'),'') [Family]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](a.dpam_sba_no,'BR'),'') [Branch]
			FROM DP_ACCT_MSTR a ,#ACLIST b, #account_properties
			WHERE DPAM_DELETED_IND = 1
			and a.dpam_sba_no = b.dpam_sba_no
			and a.dpam_id = accp_clisba_id 
			and isnumeric(a.dpam_sba_no )=1
			and a.dpam_sba_no between @pa_fromaccid and @pa_toaccid
			and accp_value between @pa_fromdate and @pa_todate
			and a.dpam_id = b.dpam_id   
			AND CITRUS_USR.FN_UCC_ENTP(DPAM_CRN_NO,'PAN_GIR_NO','') = '' 
			UNION
			select DPHD_DPAM_SBA_NO [client Id]
				,'2nd holder' [holder]
				,DPHD_SH_FNAME + ' ' + isnull(DPHD_SH_MNAME,'') + ' ' + isnull(DPHD_SH_LNAME,'') [name]
				,''  [Telephone No]
				,''  [Telephone No 2]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](DPHD_DPAM_SBA_NO,'groupcd'),'') [Group Code]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](DPHD_DPAM_SBA_NO,'FAMILY'),'') [Family]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](DPHD_DPAM_SBA_NO,'BR'),'') [Branch]
			FROM DP_HOLDER_DTLS a,#ACLIST b, #account_properties
			WHERE DPHD_DELETED_IND = 1 
			and a.DPHD_DPAM_SBA_NO = b.dpam_sba_no 
				and a.DPHD_DPAM_ID = accp_clisba_id
				and isnumeric(a.DPHD_DPAM_SBA_NO )=1
				and a.DPHD_DPAM_SBA_NO between @pa_fromaccid and @pa_toaccid
				and accp_value between @pa_fromdate and @pa_todate
				AND ISNULL(DPHD_SH_PAN_NO,'') = ''
			AND ISNULL(DPHD_SH_FNAME,'') <>''
			UNION
			select DPHD_DPAM_SBA_NO [client Id]
				,'3rd holder' [holder]
				,DPHD_TH_FNAME + ' ' + isnull(DPHD_TH_MNAME,'') + ' ' + isnull(DPHD_TH_LNAME,'') [name]
				,'' [Telephone No]
				,''  [Telephone No 2]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](DPHD_DPAM_SBA_NO,'groupcd'),'') [Group Code]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](DPHD_DPAM_SBA_NO,'FAMILY'),'') [Family]
				,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](DPHD_DPAM_SBA_NO,'BR'),'')[Branch]
			FROM DP_HOLDER_DTLS a,#ACLIST b, #account_properties
			WHERE DPHD_DELETED_IND = 1
			and a.DPHD_DPAM_SBA_NO = b.dpam_sba_no 
				and a.DPHD_DPAM_ID = accp_clisba_id
				and isnumeric(a.DPHD_DPAM_SBA_NO )=1
				and a.DPHD_DPAM_SBA_NO between @pa_fromaccid and @pa_toaccid
				and accp_value between @pa_fromdate and @pa_todate 
			AND ISNULL(DPHD_TH_PAN_NO,'') = ''
			AND ISNULL(DPHD_TH_FNAME,'') <>''
			


			

			
   end 
   if @pa_report = 5
   begin
   
		

		select count(1) noofcount, case when DPTDC_COUNTER_DP_ID not like '%IN%' and DPTDC_COUNTER_DP_ID<> ''then DPTDC_COUNTER_DP_ID + DPTDC_COUNTER_DEMAT_ACCT_NO  else DPTDC_COUNTER_DEMAT_ACCT_NO end counteracctno 
		into #counteracctno 
		from dp_trx_dtls_cdsl where DPTDC_EXECUTION_DT between @pa_fromdate and @pa_todate
		and isnull(DPTDC_COUNTER_DEMAT_ACCT_NO,'') <> ''
		group by case when DPTDC_COUNTER_DP_ID not like '%IN%' and DPTDC_COUNTER_DP_ID<> ''then DPTDC_COUNTER_DP_ID + DPTDC_COUNTER_DEMAT_ACCT_NO  else DPTDC_COUNTER_DEMAT_ACCT_NO end 
		having count(1)>1
		
		 

		
		select DPTDC_EXECUTION_DT TrxDate
		,a.dpam_sba_no  [Client Id]
		,a.dpam_sba_name [Client Name]
		,dptdc_isin [ISIN]
		,isnull(ISIN_NAME,'') [ISIN Name]
		,abs(dptdc_qty) qty 
		,counteracctno [Target Client]
		,isnull(b.dpam_sba_name,'')  [Target Name]
		,dptdc_slip_no [Slip No]
		,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](a.DPAM_SBA_NO,'BR'),'')[Branch]
		from #ACLIST acct,dp_acct_mstr a 
		, dp_trx_dtls_cdsl left outer join isin_mstr on isin_cd = dptdc_isin
		, #counteracctno left outer join dp_Acct_mstr b on b.dpam_sba_no  = counteracctno 
		where counteracctno = case when DPTDC_COUNTER_DP_ID not like '%IN%' and DPTDC_COUNTER_DP_ID<> ''then DPTDC_COUNTER_DP_ID + DPTDC_COUNTER_DEMAT_ACCT_NO  else DPTDC_COUNTER_DEMAT_ACCT_NO end 
		and DPTDC_EXECUTION_DT between @pa_fromdate and @pa_todate
		and isnumeric(a.dpam_sba_no )=1
		and acct.dpam_sba_no = a.dpam_sba_no 
		and a.dpam_sba_no between @pa_fromaccid and @pa_toaccid
		and dptdc_isin like '%' + @pa_isin 
		and a.dpam_id = dptdc_dpam_id 
		and dptdc_deleted_ind = 1
		
	end  
	
	if @pa_report = 6
    begin
   
	
		select count(1) noofcount, dpam_sba_no  sourceacctno
		into #sourceacctno 
		from dp_trx_dtls_cdsl,dp_acct_mstr where DPTDC_EXECUTION_DT between @pa_fromdate and @pa_todate
		and dpam_id = dptdc_dpam_id
		and DPTDC_COUNTER_DEMAT_ACCT_NO <>''
		group by dpam_sba_no
		having count(1)>1 

		 

		select DPTDC_EXECUTION_DT TrxDate
		,a.dpam_sba_no   [Client Id]
		,a.dpam_sba_name  [Client Name]
		,dptdc_isin [ISIN] 
		,isnull(ISIN_NAME,'') [ISIN Name]
		,abs(dptdc_qty) qty
		,case when DPTDC_COUNTER_DP_ID not like '%IN%' and DPTDC_COUNTER_DP_ID<> ''then DPTDC_COUNTER_DP_ID + DPTDC_COUNTER_DEMAT_ACCT_NO  else DPTDC_COUNTER_DEMAT_ACCT_NO end  [Target Client]
		,isnull(b.dpam_sba_name,'')  [Target Name]
		,dptdc_slip_no  [Slip No]
		,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](a.DPAM_SBA_NO,'BR'),'')[Branch]
		from #ACLIST acct,dp_acct_mstr a 
		, dp_trx_dtls_cdsl left outer join isin_mstr on isin_cd = dptdc_isin
		left outer join dp_acct_mstr b on case when DPTDC_COUNTER_DP_ID not like '%IN%' and DPTDC_COUNTER_DP_ID<> ''then DPTDC_COUNTER_DP_ID + DPTDC_COUNTER_DEMAT_ACCT_NO  else DPTDC_COUNTER_DEMAT_ACCT_NO end  = b.dpam_sba_no 
		, #sourceacctno 
		where sourceacctno = a.dpam_sba_no
		and a.dpam_id = dptdc_dpam_id 
		and DPTDC_EXECUTION_DT between @pa_fromdate and @pa_todate
		and isnumeric(a.dpam_sba_no )=1
		and acct.dpam_sba_no = a.dpam_sba_no 
		and a.dpam_sba_no between @pa_fromaccid and @pa_toaccid
		and dptdc_isin like '%' + @pa_isin 
		and dptdc_deleted_ind = 1 
		and DPTDC_COUNTER_DEMAT_ACCT_NO <>''
		
	end 
	
	if @pa_report = 7
    begin
   
	
		select count(1) noofcount, dpam_sba_no  sourceacctno 
		, case when DPTDC_COUNTER_DP_ID not like '%IN%' and DPTDC_COUNTER_DP_ID<> '' 
				then DPTDC_COUNTER_DP_ID + DPTDC_COUNTER_DEMAT_ACCT_NO  else DPTDC_COUNTER_DEMAT_ACCT_NO end   targetacctno
		into #highnooftrx 
		from dp_trx_dtls_cdsl,dp_acct_mstr where DPTDC_EXECUTION_DT between @pa_fromdate and @pa_todate
		and dpam_id = dptdc_dpam_id
		and DPTDC_COUNTER_DEMAT_ACCT_NO <>''
		group by dpam_sba_no
		,case when DPTDC_COUNTER_DP_ID not like '%IN%' and DPTDC_COUNTER_DP_ID<> ''
				then DPTDC_COUNTER_DP_ID + DPTDC_COUNTER_DEMAT_ACCT_NO  else DPTDC_COUNTER_DEMAT_ACCT_NO end  
		having count(1)>1 


		select '' TrxDate
		,acct.dpam_sba_no   [Client Id]
		,acct.dpam_sba_name  [Client Name]
		,'' [ISIN] 
		,noofcount [ISIN Name]
		,'' qty
		,targetacctno  [Target Client]
		,isnull(b.dpam_sba_name,'')  [Target Name]
		,'' [Slip No]
		,isnull(citrus_usr.[fn_find_relations_nm_by_dpamno](acct.DPAM_SBA_NO,'BR'),'')[Branch]
		from #ACLIST acct
		, #highnooftrx left outer join dp_acct_mstr b on targetacctno  = b.dpam_sba_no 
		where sourceacctno = acct.dpam_sba_no
		and isnumeric(acct.dpam_sba_no )=1
		and acct.dpam_sba_no between @pa_fromaccid and @pa_toaccid
		
	end 





                    
     
      TRUNCATE TABLE #ACLIST
	  DROP TABLE #ACLIST                  
END

GO
