-- Object: PROCEDURE citrus_usr.Pr_Rpt_DPSummary
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--Pr_Rpt_DPSummary 'cdsl',3,'nov 15 2008','','','n',1,'HO*|~*',''      
CREATE Proc [citrus_usr].[Pr_Rpt_DPSummary]                  
@pa_dptype varchar(4),            
@pa_excsmid int,            
@pa_asondate char(1),            
@pa_fordate datetime,            
@pa_isincd varchar(12),      
@pa_withvalue char(1), --Y/N            
@pa_login_pr_entm_id numeric,              
@pa_login_entm_cd_chain  varchar(8000),              
@pa_output varchar(8000) output              
as                  
begin                  
                  
declare @@dpmid int,                  
@@l_child_entm_id int,
@@tmpholding_dt datetime
      
      
select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                  
select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)              
                
 CREATE TABLE #ACLIST(dpam_id BIGINT,EFF_FROM DATETIME,eff_to DATETIME)
 
      
 IF @pa_withvalue = 'N'      
 BEGIN      
   if @pa_dptype = 'NSDL'                  
   BEGIN      
    IF @pa_asondate = 'Y'                  
    BEGIN                  

		
		select top 1 @pa_fordate =dpdhm_holding_dt from DP_HLDG_MSTR_NSDL
		INSERT INTO #ACLIST SELECT DPAM_ID,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		
		select act_type=isnull(ben.descp,act_type),ISINCD,ISIN_NAME,Qty,holding_dt=convert(varchar(11),@pa_fordate,109)  from   
		(
		     select DPDHM_ISIN as ISINCD ,dpdhm_benf_acct_typ as act_type,convert(numeric(18,3),SUM(DPDHM_QTY)) as Qty       
		     from DP_HLDG_MSTR_NSDL,
		     #ACLIST account                        
		     where dpdhm_holding_dt = @pa_fordate and DPDHM_DPM_ID = @@dpmid                  
		     and DPDHM_dpam_id = account.dpam_id              
		     and (DPDHM_HOLDING_DT between eff_from and eff_to)            
		     AND DPDHM_ISIN LIKE @pa_isincd + '%'        
		     GROUP BY DPDHM_ISIN,dpdhm_benf_acct_typ  
		) tmpview  
		left outer join ISIN_MSTR ON ISINCD = ISIN_CD 
		,citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') BEN 
		where act_type = BEN.CD          
		order by ISIN_NAME,ISINCD,ben.descp                  
          
    END                  
    ELSE                  
    BEGIN                  
		 select top 1 @@tmpholding_dt = case when DPDHM_HOLDING_DT > @pa_fordate then @pa_fordate else DPDHM_HOLDING_DT end from DP_HLDG_MSTR_NSDL where dpdhm_deleted_ind =1 


	     select act_type=isnull(ben.descp,act_type),ISINCD,ISIN_NAME,Qty,holding_dt=convert(varchar(11),@@tmpholding_dt,109) from
	     (               
			 select DPDHMD_ISIN ISINCD,act_type=dpdhmd_benf_acct_typ,convert(numeric(18,3),SUM(DPDHMD_QTY)) Qty                
			 from fn_dailyholding(@@dpmid,@pa_fordate,'','',@pa_isincd,'',@pa_login_pr_entm_id,@@l_child_entm_id)
			 GROUP BY DPDHMD_ISIN,dpdhmd_benf_acct_typ  
	     ) tmpview LEFT OUTER JOIN ISIN_MSTR ON ISINCD = ISIN_CD 
	      ,citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') BEN 
	     where act_type = BEN.CD                    
	     order by ISIN_NAME,ISINCD,ben.descp                  
               
    END                  
         
   END                  
   ELSE                  
   BEGIN                  
              
    if @pa_asondate = 'Y'                  
    BEGIN    
		select top 1 @pa_fordate =DPHMC_HOLDING_DT from DP_HLDG_MSTR_CDSL 
		INSERT INTO #ACLIST SELECT DPAM_ID,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)
            select ISIN_NAME,tmpview.*,holding_dt=convert(varchar(11),@pa_fordate,109) from
	        (
				select DPHMC_ISIN,DPHMC_CURR_QTY=convert(numeric(18,3),SUM(DPHMC_CURR_QTY)),DPHMC_FREE_QTY=convert(numeric(18,3),SUM(DPHMC_FREE_QTY)),DPHMC_FREEZE_QTY=convert(numeric(18,3),SUM(DPHMC_FREEZE_QTY)),DPHMC_PLEDGE_QTY=convert(numeric(18,3),SUM(DPHMC_PLEDGE_QTY)),DPHMC_DEMAT_PND_VER_QTY=convert(numeric(18,3),SUM(DPHMC_DEMAT_PND_VER_QTY)),DPHMC_REMAT_PND_CONF_QTY=convert(numeric(18,3),SUM(DPHMC_REMAT_PND_CONF_QTY)),DPHMC_DEMAT_PND_CONF_QTY=convert(numeric(18,3),SUM(DPHMC_DEMAT_PND_CONF_QTY)),DPHMC_SAFE_KEEPING_QTY=convert(numeric(18,3),SUM(DPHMC_SAFE_KEEPING_QTY)),DPHMC_LOCKIN_QTY=convert(numeric(18,3),SUM(DPHMC_LOCKIN_QTY)),DPHMC_ELIMINATION_QTY=convert(numeric(18,3),SUM(DPHMC_ELIMINATION_QTY)),DPHMC_EARMARK_QTY=convert(numeric(18,3),SUM(DPHMC_EARMARK_QTY)),DPHMC_AVAIL_LEND_QTY=convert(numeric(18,3),SUM(DPHMC_AVAIL_LEND_QTY)),DPHMC_LEND_QTY=convert(numeric(18,3),SUM(DPHMC_LEND_QTY)),DPHMC_BORROW_QTY=convert(numeric(18,3),SUM(DPHMC_BORROW_QTY))                  
				from DP_HLDG_MSTR_CDSL ,            
				#ACLIST account                        
				where DPHMC_HOLDING_DT = @pa_fordate and DPHMC_DPM_ID = @@dpmid                  
				and DPHMC_dpam_id = account.dpam_id              
				and (DPHMC_HOLDING_DT between eff_from and eff_to)            
				and DPHMC_ISIN LIKE @pa_isincd + '%'       
				GROUP BY DPHMC_ISIN
				having SUM(DPHMC_CURR_QTY) <> 0  
			) tmpview LEFT OUTER JOIN ISIN_MSTR ON DPHMC_ISIN = ISIN_CD              
			order by ISIN_NAME,DPHMC_ISIN                  
                     
    END                  
    ELSE                  
    BEGIN  

			select top 1 @@tmpholding_dt = case when DPHMC_HOLDING_DT > @pa_fordate then @pa_fordate else DPHMC_HOLDING_DT end from DP_HLDG_MSTR_CDSL where dphmc_deleted_ind =1 

			INSERT INTO #ACLIST SELECT DPAM_ID,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)
            
			select ISIN_NAME,tmpview.*,holding_dt=convert(varchar(11),@@tmpholding_dt,109) from
	        (                
				select DPHMC_ISIN=DPHMCD_ISIN,DPHMCD_CURR_QTY=convert(numeric(18,3),SUM(DPHMCD_CURR_QTY)),DPHMCD_FREE_QTY=convert(numeric(18,3),SUM(DPHMCD_FREE_QTY)),DPHMCD_FREEZE_QTY=convert(numeric(18,3),SUM(DPHMCD_FREEZE_QTY)),DPHMCD_PLEDGE_QTY=convert(numeric(18,3),SUM(DPHMCD_PLEDGE_QTY)),DPHMCD_DEMAT_PND_VER_QTY=convert(numeric(18,3),SUM(DPHMCD_DEMAT_PND_VER_QTY)),DPHMCD_REMAT_PND_CONF_QTY=convert(numeric(18,3),SUM(DPHMCD_REMAT_PND_CONF_QTY)),DPHMCD_DEMAT_PND_CONF_QTY=convert(numeric(18,3),SUM(DPHMCD_DEMAT_PND_CONF_QTY)),DPHMCD_SAFE_KEEPING_QTY=convert(numeric(18,3),SUM(DPHMCD_SAFE_KEEPING_QTY)),DPHMCD_LOCKIN_QTY=convert(numeric(18,3),SUM(DPHMCD_LOCKIN_QTY)),DPHMCD_ELIMINATION_QTY=convert(numeric(18,3),SUM(DPHMCD_ELIMINATION_QTY)),DPHMCD_EARMARK_QTY=convert(numeric(18,3),SUM(DPHMCD_EARMARK_QTY)),DPHMCD_AVAIL_LEND_QTY=convert(numeric(18,3),SUM(DPHMCD_AVAIL_LEND_QTY)),DPHMCD_LEND_QTY=convert(numeric(18,3),SUM(DPHMCD_LEND_QTY)),DPHMCD_BORROW_QTY=convert(numeric(18,3),SUM(DPHMCD_BORROW_QTY))                  
				from DP_DAILY_HLDG_CDSL ,            
				#ACLIST account                              
				where DPHMCD_HOLDING_DT = @pa_fordate and DPHMCD_DPM_ID = @@dpmid                  
				and DPHMCD_dpam_id = account.dpam_id              
				and (DPHMCD_HOLDING_DT between eff_from and eff_to)            
				AND DPHMCD_ISIN LIKE @pa_isincd + '%'       
				GROUP BY DPHMCD_ISIN
				having SUM(DPHMCD_CURR_QTY) <> 0  
			) tmpview LEFT OUTER JOIN ISIN_MSTR ON DPHMC_ISIN = ISIN_CD                        
			order by ISIN_NAME,DPHMC_ISIN                  
               
    END                  
              
   END                  
 END      
 ELSE --@pa_withvalue ='Y'      
 BEGIN      
   if @pa_dptype = 'NSDL'                  
   BEGIN      
    IF @pa_asondate = 'Y'                  
    BEGIN      
	     select top 1 @pa_fordate = DPDHM_HOLDING_DT from DP_HLDG_MSTR_NSDL where dpdhm_deleted_ind =1
		 INSERT INTO #ACLIST SELECT DPAM_ID,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)      
	     select act_type=isnull(ben.descp,act_type),ISIN_NAME,tmpview.*
         ,Valuation=isnull(convert(numeric(18,4),QTY)*(select top 1 isnull(clopm_nsdl_rt,0) from CLOSING_LAST_NSDL where ISINCD = CLOPM_ISIN_CD  and CLOPM_DT < @pa_fordate order by CLOPM_DT desc) ,0)
         ,holding_dt=convert(varchar(11),@pa_fordate,109) from 
	     (     
		     select DPDHM_ISIN ISINCD,SUM(DPDHM_QTY)  Qty,act_type=dpdhm_benf_acct_typ                
		     from DP_HLDG_MSTR_NSDL,        
		     #ACLIST account                        
		     where DPDHM_HOLDING_DT = @pa_fordate and DPDHM_DPM_ID = @@dpmid                  
		     and DPDHM_dpam_id = account.dpam_id              
		     and (DPDHM_HOLDING_DT between eff_from and eff_to)            
		     AND DPDHM_ISIN LIKE @pa_isincd + '%'      
		     group by DPDHM_ISIN,dpdhm_benf_acct_typ
	     ) tmpview    
	     LEFT OUTER JOIN ISIN_MSTR ON ISINCD = ISIN_CD
	     ,citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') BEN 
	     where act_type = BEN.CD  
         order by ISIN_NAME,ISINCD,ben.descp                  
          
    END                  
    ELSE                  
    BEGIN
		select top 1 @@tmpholding_dt = case when DPDHM_HOLDING_DT > @pa_fordate then @pa_fordate else DPDHM_HOLDING_DT end from DP_HLDG_MSTR_NSDL where dpdhm_deleted_ind =1 

                  
     	select act_type=isnull(ben.descp,act_type),ISIN_NAME,tmpview.*
        ,Valuation=isnull(convert(numeric(18,4),QTY)*(select top 1 isnull(clopm_nsdl_rt,0) from CLOSING_LAST_NSDL where ISINCD = CLOPM_ISIN_CD  and CLOPM_DT < @pa_fordate order by CLOPM_DT desc) ,0)
        ,holding_dt=convert(varchar(11),@@tmpholding_dt,109) from 
        ( 
			select DPDHMD_ISIN ISINCD,SUM(DPDHMD_QTY) Qty,act_type=dpdhmd_benf_acct_typ               
			from fn_dailyholding(@@dpmid,@pa_fordate,'','',@pa_isincd,'',@pa_login_pr_entm_id,@@l_child_entm_id)
			group by DPDHMD_ISIN,dpdhmd_benf_acct_typ
		) tmpview
		LEFT OUTER JOIN ISIN_MSTR ON ISINCD = ISIN_CD 
		--LEFT OUTER JOIN CLOSING_LAST_NSDL on ISINCD = CLOPM_ISIN_CD  and CLOPM_DT = @pa_fordate        
		,citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') BEN
		where act_type = BEN.CD 
        
		order by ISIN_NAME,ISINCD,ben.descp                  
               
    END                  
                  
                      
   END                  
   ELSE                  
   BEGIN                  
              
    if @pa_asondate = 'Y'                  
    BEGIN              
		select top 1 @pa_fordate = DPHMC_HOLDING_DT from DP_HLDG_MSTR_CDSL where dphmc_deleted_ind =1      
		INSERT INTO #ACLIST SELECT DPAM_ID,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)
		select tmpview.*,ISIN_NAME
,Valuation=isnull(convert(numeric(18,4),DPHMC_CURR_QTY)*(select top 1 isnull(clopm_CDSL_rt,0) from CLOSING_LAST_CDSL where DPHMC_ISIN = CLOPM_ISIN_CD  and CLOPM_DT < @pa_fordate order by CLOPM_DT desc) ,0)
,holding_dt=convert(varchar(11),@pa_fordate,109) from
		(     
			select DPHMC_ISIN ,DPHMC_CURR_QTY=convert(numeric(18,3),SUM(DPHMC_CURR_QTY)), DPHMC_FREE_QTY=convert(numeric(18,3),SUM(DPHMC_FREE_QTY)),DPHMC_FREEZE_QTY=convert(numeric(18,3),SUM(DPHMC_FREEZE_QTY)),DPHMC_PLEDGE_QTY=convert(numeric(18,3),SUM(DPHMC_PLEDGE_QTY)),DPHMC_DEMAT_PND_VER_QTY=convert(numeric(18,3),SUM(DPHMC_DEMAT_PND_VER_QTY)),DPHMC_REMAT_PND_CONF_QTY=convert(numeric(18,3),SUM(DPHMC_REMAT_PND_CONF_QTY)),DPHMC_DEMAT_PND_CONF_QTY=convert(numeric(18,3),SUM(DPHMC_DEMAT_PND_CONF_QTY)),DPHMC_SAFE_KEEPING_QTY=convert(numeric(18,3),SUM(DPHMC_SAFE_KEEPING_QTY)),DPHMC_LOCKIN_QTY=convert(numeric(18,3),SUM(DPHMC_LOCKIN_QTY)),DPHMC_ELIMINATION_QTY =convert(numeric(18,3),SUM(DPHMC_ELIMINATION_QTY)),DPHMC_EARMARK_QTY=convert(numeric(18,3),SUM(DPHMC_EARMARK_QTY)),DPHMC_AVAIL_LEND_QTY=convert(numeric(18,3),SUM(DPHMC_AVAIL_LEND_QTY)),DPHMC_LEND_QTY=convert(numeric(18,3),SUM(DPHMC_LEND_QTY)),DPHMC_BORROW_QTY=convert(numeric(18,3),SUM(DPHMC_BORROW_QTY))                  
			from DP_HLDG_MSTR_CDSL,       
			#ACLIST account                        
			where DPHMC_HOLDING_DT = @pa_fordate and DPHMC_DPM_ID = @@dpmid                  
			and DPHMC_dpam_id = account.dpam_id              
			and (DPHMC_HOLDING_DT between eff_from and eff_to)            
			AND DPHMC_ISIN LIKE @pa_isincd + '%'       
			GROUP BY DPHMC_ISIN 
			having SUM(DPHMC_CURR_QTY) <> 0  
		) tmpview      
		LEFT OUTER JOIN ISIN_MSTR ON DPHMC_ISIN = ISIN_CD      
		order by ISIN_NAME,DPHMC_ISIN       
    END                  
    ELSE                  
    BEGIN 
		select top 1 @@tmpholding_dt = case when DPHMC_HOLDING_DT > @pa_fordate then @pa_fordate else DPHMC_HOLDING_DT end from DP_HLDG_MSTR_CDSL where dphmc_deleted_ind =1 

		INSERT INTO #ACLIST SELECT DPAM_ID,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)
		select tmpview.*,ISIN_NAME
,Valuation=isnull(convert(numeric(18,4),DPHMC_CURR_QTY)*(select top 1 isnull(clopm_CDSL_rt,0) from CLOSING_LAST_CDSL where DPHMC_ISIN = CLOPM_ISIN_CD  and CLOPM_DT < @pa_fordate order by CLOPM_DT desc) ,0)
,holding_dt=convert(varchar(11),@@tmpholding_dt,109) from
		(
			select DPHMCD_ISIN DPHMC_ISIN,DPHMC_CURR_QTY=SUM(DPHMCD_CURR_QTY),DPHMC_FREE_QTY=SUM(DPHMCD_FREE_QTY),DPHMC_FREEZE_QTY=SUM(DPHMCD_FREEZE_QTY),DPHMC_PLEDGE_QTY=SUM(DPHMCD_PLEDGE_QTY),DPHMC_DEMAT_PND_VER_QTY=SUM(DPHMCD_DEMAT_PND_VER_QTY),DPHMC_REMAT_PND_CONF_QTY=SUM(DPHMCD_REMAT_PND_CONF_QTY),DPHMC_DEMAT_PND_CONF_QTY=SUM(DPHMCD_DEMAT_PND_CONF_QTY),DPHMC_SAFE_KEEPING_QTY=SUM(DPHMCD_SAFE_KEEPING_QTY),DPHMC_LOCKIN_QTY=SUM(DPHMCD_LOCKIN_QTY),DPHMC_ELIMINATION_QTY=SUM(DPHMCD_ELIMINATION_QTY),DPHMC_EARMARK_QTY=SUM(DPHMCD_EARMARK_QTY),DPHMC_AVAIL_LEND_QTY=SUM(DPHMCD_AVAIL_LEND_QTY),DPHMC_LEND_QTY=SUM(DPHMCD_LEND_QTY),DPHMC_BORROW_QTY=SUM(DPHMCD_BORROW_QTY) 
			from DP_DAILY_HLDG_CDSL,       
			#ACLIST account                              
			where DPHMCD_HOLDING_DT = @pa_fordate and DPHMCD_DPM_ID = @@dpmid                  
			and DPHMCD_dpam_id = account.dpam_id              
			and (DPHMCD_HOLDING_DT between eff_from and eff_to)            
			AND DPHMCD_ISIN LIKE @pa_isincd + '%'     
			GROUP BY DPHMCD_ISIN
			having SUM(DPHMCD_CURR_QTY) <> 0  
		) tmpview
		LEFT OUTER JOIN ISIN_MSTR ON DPHMC_ISIN = ISIN_CD      
		order by ISIN_NAME,DPHMC_ISIN                  
               
    END                  
                    
   END                  
      
      
 END      
      TRUNCATE TABLE #ACLIST
	  DROP TABLE #ACLIST
                  
END

GO
