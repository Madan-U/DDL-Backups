-- Object: PROCEDURE citrus_usr.Pr_Rpt_Holding_changedbyTUSHAR280309
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--[Pr_Rpt_Holding_changedbyTUSHAR280309] 'nsdl',4,'Y','mar 28 2009','10000037','10000037','','N',1,'HO|*~|',''
--select * from dp_mstr
CREATE Proc [citrus_usr].[Pr_Rpt_Holding_changedbyTUSHAR280309]
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
                        
declare @@dpmid int,                        
@@tmpholding_dt datetime
select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                        
declare @@l_child_entm_id      numeric                    
select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                    
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
                  

IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME = 'TMPHLDGNSDL')
DROP TABLE TMPHLDGNSDL
                  
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
            
 IF @pa_withvalue = 'N'            
 BEGIN            
  IF @pa_dptype = 'NSDL'                        
  BEGIN            
      IF @pa_asondate = 'Y'                        
      BEGIN                        
        select top 1 @pa_fordate = DPDHM_HOLDING_DT from DP_HLDG_MSTR_NSDL where dpdhm_deleted_ind =1   
		INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		
                    
		select dpam_id,DPAM_SBA_NAME AcctName,DPAM_sba_NO AcctNo,BEN_TYPE=BEN.DESCP + CASE WHEN LTRIM(RTRIM(DPDHM_SETT_TYPE)) <> '00' AND ISNULL(LTRIM(RTRIM(DPDHM_SETT_TYPE)),'') <> '' THEN ' (' + settm_desc +'/' + DPDHM_SETT_NO + ')' ELSE '' END 
		,DPDHM_ISIN ISINCD,[citrus_usr].[fn_splitstrin_byspace](isin_name,'40','',1) isin_name ,convert(numeric(18,3),DPDHM_QTY)  Qty
		,CASE WHEN DPDHM_BLK_LOCK_FLG = 'F' THEN 'FREE' WHEN  DPDHM_BLK_LOCK_FLG = 'L' THEN 'LOCK' WHEN DPDHM_BLK_LOCK_FLG = 'B' THEN 'BLOCK' ELSE '' END LockFlg
		, holding_dt=convert(varchar(11),@pa_fordate,109),DPDHM_BENF_ACCT_TYP                        
        INTO TMPHLDGNSDL                  
		from DP_HLDG_MSTR_NSDL                  
		LEFT OUTER JOIN ISIN_MSTR ON DPDHM_ISIN = ISIN_CD,                  
		#ACLIST account,  
		citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') BEN  , settlement_type_mstr 
		where DPDHM_HOLDING_DT = @pa_fordate and DPDHM_DPM_ID = @@dpmid                        
		and DPDHM_dpam_id = account.dpam_id             
        and isnumeric(DPAM_sba_NO) =1        
        and  case when ltrim(rtrim(DPDHM_SETT_TYPE)) = '00' then '0' else settm_type end = case when ltrim(rtrim(DPDHM_SETT_TYPE)) = '00' then '0' else DPDHM_SETT_TYPE end 
		and (DPDHM_HOLDING_DT between eff_from and eff_to)                  
		AND (convert(numeric,DPAM_sba_NO) between convert(numeric,@pa_fromaccid) AND  convert(numeric,@pa_toaccid))                        
		AND DPDHM_ISIN LIKE @pa_isincd + '%'  
		AND DPDHM_BENF_ACCT_TYP = BEN.CD  
		AND DPDHM_QTY <> 0
		--order by DPAM_sba_NO,ISIN_NAME,DPDHM_ISIN,DPDHM_BENF_ACCT_TYP  


        SELECT DISTINCT  * FROM TMPHLDGNSDL
		order by AcctNo,isin_name,ISINCD,DPDHM_BENF_ACCT_TYP                       

                  
      END                        
      ELSE                        
      BEGIN

		select top 1 @@tmpholding_dt = case when DPDHM_HOLDING_DT > @pa_fordate then @pa_fordate else DPDHM_HOLDING_DT end from DP_HLDG_MSTR_NSDL where dpdhm_deleted_ind =1 

		select  dpam_id=DPDHMD_DPAM_ID,DPAM_SBA_NAME AcctName,DPAM_sba_NO AcctNo,BEN_TYPE=BEN.DESCP + CASE WHEN LTRIM(RTRIM(DPDHMD_SETT_TYPE)) <> '00' AND ISNULL(LTRIM(RTRIM(DPDHMD_SETT_TYPE)),'') <> '' THEN  ' (' + DPDHMD_SETT_TYPE +'/' + DPDHMD_SETT_NO + ')' ELSE '' END 
		,DPDHMD_ISIN ISINCD,[citrus_usr].[fn_splitstrin_byspace](isin_name,'40','',1) isin_name,convert(numeric(18,3),DPDHMD_QTY) Qty
		,CASE WHEN DPDHMD_BLK_LOCK_FLG = 'F' THEN 'FREE' WHEN  DPDHMD_BLK_LOCK_FLG = 'L' THEN 'LOCK' WHEN DPDHMD_BLK_LOCK_FLG = 'B' THEN 'BLOCK' ELSE '' END LockFlg
		,holding_dt=convert(varchar(11),@@tmpholding_dt,109) ,CD DPDHM_BENF_ACCT_TYP           
        INTO TMPHLDGNSDL      
		from fn_dailyholding(@@dpmid,@pa_fordate,@pa_fromaccid,@pa_toaccid,@pa_isincd,'',@pa_login_pr_entm_id,@@l_child_entm_id)  
		LEFT OUTER JOIN ISIN_MSTR ON DPDHMD_ISIN = ISIN_CD
		,citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') BEN    , settlement_type_mstr                 
		where DPDHMD_BENF_ACCT_TYP = BEN.CD           
        and  case when ltrim(rtrim(DPDHMD_SETT_TYPE)) = '00' then '0' else SETTM_TYPE end = case when ltrim(rtrim(DPDHMD_SETT_TYPE)) = '00' then '0' else DPDHMD_SETT_TYPE end 
 		
		


        SELECT DISTINCT  * FROM TMPHLDGNSDL
		order by AcctNo,isin_name,ISINCD,DPDHM_BENF_ACCT_TYP      
                      
      END                        
  END                        
 ELSE                        
 BEGIN                        
                    
  IF @pa_asondate = 'Y'                        
  BEGIN
	select top 1 @pa_fordate = DPHMC_HOLDING_DT from DP_HLDG_MSTR_CDSL where dphmc_deleted_ind =1                         
    
	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		
                    
	select  DPAM_SBA_NAME,DPAM_sba_NO,DPHMC_ISIN,[citrus_usr].[fn_splitstrin_byspace](isin_name,'40','',1) isin_name,convert(numeric(18,3),DPHMC_CURR_QTY),convert(numeric(18,3),DPHMC_FREE_QTY),convert(numeric(18,3),DPHMC_FREEZE_QTY),convert(numeric(18,3),DPHMC_PLEDGE_QTY),convert(numeric(18,3),DPHMC_DEMAT_PND_VER_QTY)    
	,convert(numeric(18,3),DPHMC_REMAT_PND_CONF_QTY),convert(numeric(18,3),DPHMC_DEMAT_PND_CONF_QTY),convert(numeric(18,3),DPHMC_SAFE_KEEPING_QTY),convert(numeric(18,3),DPHMC_LOCKIN_QTY)      
	,convert(numeric(18,3),DPHMC_ELIMINATION_QTY) ,convert(numeric(18,3),DPHMC_EARMARK_QTY),convert(numeric(18,3),DPHMC_AVAIL_LEND_QTY),convert(numeric(18,3),DPHMC_LEND_QTY),convert(numeric(18,3),DPHMC_BORROW_QTY),dpam_id, holding_dt=convert(varchar(11),@pa_fordate,109)                         
	from DP_HLDG_MSTR_CDSL LEFT OUTER JOIN ISIN_MSTR ON DPHMC_ISIN = ISIN_CD,                  
	#ACLIST account                              
	where DPHMC_HOLDING_DT = @pa_fordate and DPHMC_DPM_ID = @@dpmid                        
	and DPHMC_dpam_id = account.dpam_id                    
	and (DPHMC_HOLDING_DT between eff_from and eff_to)                  
	AND (convert(numeric,DPAM_sba_NO) between convert(numeric,@pa_fromaccid) AND  convert(numeric,@pa_toaccid))
	AND ISNULL(DPHMC_CURR_QTY,0) <> 0                         
	AND DPHMC_ISIN LIKE @pa_isincd + '%'                        
	order by DPAM_sba_NO,ISIN_NAME,DPHMC_ISIN                        
  END                        
  ELSE                        
  BEGIN                        
	select top 1 @@tmpholding_dt = case when DPHMC_HOLDING_DT > @pa_fordate then @pa_fordate else DPHMC_HOLDING_DT end from DP_HLDG_MSTR_CDSL where dphmc_deleted_ind =1 

	INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		

	select  DPAM_SBA_NAME,DPAM_sba_NO,DPHMCD_ISIN,[citrus_usr].[fn_splitstrin_byspace](isin_name,'40','',1) isin_name,convert(numeric(18,3),DPHMCD_CURR_QTY),convert(numeric(18,3),DPHMCD_FREE_QTY),convert(numeric(18,3),DPHMCD_FREEZE_QTY)    
	,convert(numeric(18,3),DPHMCD_PLEDGE_QTY),convert(numeric(18,3),DPHMCD_DEMAT_PND_VER_QTY),convert(numeric(18,3),DPHMCD_REMAT_PND_CONF_QTY),convert(numeric(18,3),DPHMCD_DEMAT_PND_CONF_QTY)    
	,convert(numeric(18,3),DPHMCD_SAFE_KEEPING_QTY),convert(numeric(18,3),DPHMCD_LOCKIN_QTY),convert(numeric(18,3),DPHMCD_ELIMINATION_QTY),convert(numeric(18,3),DPHMCD_EARMARK_QTY),convert(numeric(18,3),DPHMCD_AVAIL_LEND_QTY)    
	,convert(numeric(18,3),DPHMCD_LEND_QTY),convert(numeric(18,3),DPHMCD_BORROW_QTY),dpam_id,holding_dt=convert(varchar(11),@@tmpholding_dt,109)                                   
	from DP_DAILY_HLDG_CDSL LEFT OUTER JOIN ISIN_MSTR ON DPHMCD_ISIN = ISIN_CD,                  
	#ACLIST account                                    
	where DPHMCD_HOLDING_DT = @pa_fordate and DPHMCD_DPM_ID = @@dpmid                        
	and DPHMCD_dpam_id = account.dpam_id                    
	and (DPHMCD_HOLDING_DT between eff_from and eff_to)                  
	AND (convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) AND  convert(numeric,@pa_toaccid)) 
	AND ISNULL(DPHMCD_CURR_QTY,0) <> 0                         
	AND DPHMCD_ISIN LIKE @pa_isincd + '%'                        
	order by DPAM_sba_NO,ISIN_NAME,DPHMCD_ISIN                        
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

		INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		
		   
		select  DPAM_ID=DPDHM_DPAM_ID,DPAM_SBA_NAME AcctName,DPAM_sba_NO AcctNo
		,BEN_TYPE=BEN.DESCP + CASE WHEN LTRIM(RTRIM(DPDHM_SETT_TYPE)) <> '00' AND ISNULL(LTRIM(RTRIM(DPDHM_SETT_TYPE)),'') <> '' THEN  ' (' + DPDHM_SETT_TYPE +'/' + DPDHM_SETT_NO + ')' ELSE '' END 
		,DPDHM_ISIN ISINCD,[citrus_usr].[fn_splitstrin_byspace](isin_name,'40','',1) isin_name,convert(numeric(18,3),DPDHM_QTY)  Qty,Valuation= convert(numeric(18,3),DPDHM_QTY*isnull(clopm_nsdl_rt,0))   
		,CASE WHEN DPDHM_BLK_LOCK_FLG = 'F' THEN 'FREE' WHEN  DPDHM_BLK_LOCK_FLG = 'L' THEN 'LOCK' WHEN DPDHM_BLK_LOCK_FLG = 'B' THEN 'BLOCK' ELSE '' END LockFlg
		,holding_dt=convert(varchar(11),@pa_fordate,109),cmp=isnull(clopm_nsdl_rt,0.00),DPDHM_BENF_ACCT_TYP 
        INTO TMPHLDGNSDL      
		from DP_HLDG_MSTR_NSDL              
		LEFT OUTER JOIN ISIN_MSTR ON DPDHM_ISIN = ISIN_CD            
		LEFT OUTER JOIN CLOSING_LAST_NSDL on DPDHM_ISIN = CLOPM_ISIN_CD ,                  
		#ACLIST account,  
		citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') BEN        , settlement_type_mstr                                         
		where DPDHM_HOLDING_DT = @pa_fordate and DPDHM_DPM_ID = @@dpmid                        
		and DPDHM_dpam_id = account.dpam_id 
        and  case when ltrim(rtrim(DPDHM_SETT_TYPE)) = '00' then '0' else settm_type end = case when ltrim(rtrim(DPDHM_SETT_TYPE)) = '00' then '0' else DPDHM_SETT_TYPE end 
 		and isnumeric(dpam_sba_no ) = 1                
		and (DPDHM_HOLDING_DT between eff_from and eff_to)                  
		AND (convert(numeric,DPAM_sba_NO) between convert(numeric,@pa_fromaccid) AND  convert(numeric,@pa_toaccid))                        
		AND DPDHM_ISIN LIKE @pa_isincd + '%'  
		AND DPDHM_BENF_ACCT_TYP = BEN.CD    
		AND DPDHM_QTY <> 0     
        
		--order by DPAM_sba_NO,ISIN_NAME,DPDHM_ISIN,DPDHM_BENF_ACCT_TYP   

 
        SELECT DISTINCT  * FROM TMPHLDGNSDL
		order by AcctNo,isin_name,ISINCD,DPDHM_BENF_ACCT_TYP                         
                     
	  END                        
	  ELSE                        
	  BEGIN     
		select top 1 @@tmpholding_dt = case when DPDHM_HOLDING_DT > @pa_fordate then @pa_fordate else DPDHM_HOLDING_DT end from DP_HLDG_MSTR_NSDL where dpdhm_deleted_ind =1 
                   
		select  DPAM_ID=DPDHMD_DPAM_ID,DPAM_SBA_NAME AcctName,DPAM_sba_NO AcctNo
		,BEN_TYPE=BEN.DESCP + CASE WHEN LTRIM(RTRIM(DPDHMD_SETT_TYPE)) <> '00' AND ISNULL(LTRIM(RTRIM(DPDHMD_SETT_TYPE)),'') <> '' THEN  ' (' + DPDHMD_SETT_TYPE +'/' + DPDHMD_SETT_NO + ')' ELSE '' END 
		,DPDHMD_ISIN ISINCD,[citrus_usr].[fn_splitstrin_byspace](isin_name,'40','',1) isin_name,convert(numeric(18,3),DPDHMD_QTY) Qty,Valuation= convert(numeric(18,3),DPDHMD_QTY*isnull(clopm_nsdl_rt,0))                
		,CASE WHEN DPDHMD_BLK_LOCK_FLG = 'F' THEN 'FREE' WHEN  DPDHMD_BLK_LOCK_FLG = 'L' THEN 'LOCK' WHEN DPDHMD_BLK_LOCK_FLG = 'B' THEN 'BLOCK' ELSE '' END LockFlg
		,holding_dt=convert(varchar(11),@@tmpholding_dt,109),cmp=isnull(clopm_nsdl_rt,0.00)   , CD DPDHM_BENF_ACCT_TYP                     
        INTO TMPHLDGNSDL      
		from fn_dailyholding(@@dpmid,@pa_fordate,@pa_fromaccid,@pa_toaccid,@pa_isincd,'',@pa_login_pr_entm_id,@@l_child_entm_id) 
		LEFT OUTER JOIN ISIN_MSTR ON DPDHMD_ISIN = ISIN_CD            
		LEFT OUTER JOIN CLOSING_LAST_NSDL on DPDHMD_ISIN = CLOPM_ISIN_CD,                  
		citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') BEN     ,    settlement_type_mstr                                           
		where DPDHMD_BENF_ACCT_TYP = BEN.CD   
        and  case when ltrim(rtrim(DPDHMD_SETT_TYPE)) = '00' then '0' else settm_type end = case when ltrim(rtrim(DPDHMD_SETT_TYPE)) = '00' then '0' else DPDHMD_SETT_TYPE end 
 		order by DPAM_sba_NO,ISIN_NAME,DPDHMD_ISIN,DPDHMD_BENF_ACCT_TYP   

        SELECT DISTINCT * FROM TMPHLDGNSDL
		order by AcctNo,isin_name,ISINCD,DPDHM_BENF_ACCT_TYP                       
                     
	  END                        
                        
                            
 END                        
 ELSE                        
 BEGIN                        
                    
	  IF @pa_asondate = 'Y'                        
	  BEGIN                    
		   select top 1 @pa_fordate = DPHMC_HOLDING_DT from DP_HLDG_MSTR_CDSL where dphmc_deleted_ind =1            

		   INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		
		           
		   select  DPAM_SBA_NAME,DPAM_sba_NO,DPHMC_ISIN,[citrus_usr].[fn_splitstrin_byspace](isin_name,'40','',1) isin_name,convert(numeric(18,3),DPHMC_CURR_QTY),Valuation=convert(numeric(18,3),DPHMC_CURR_QTY*isnull(clopm_cdsl_rt,0)), convert(numeric(18,3),DPHMC_FREE_QTY),convert(numeric(18,3),DPHMC_FREEZE_QTY)    
		   ,convert(numeric(18,3),DPHMC_PLEDGE_QTY),convert(numeric(18,3),DPHMC_DEMAT_PND_VER_QTY),convert(numeric(18,3),DPHMC_REMAT_PND_CONF_QTY),convert(numeric(18,3),DPHMC_DEMAT_PND_CONF_QTY),convert(numeric(18,3),DPHMC_SAFE_KEEPING_QTY),convert(numeric(18,3),DPHMC_LOCKIN_QTY)    
		   ,convert(numeric(18,3),DPHMC_ELIMINATION_QTY),convert(numeric(18,3),DPHMC_EARMARK_QTY),convert(numeric(18,3),DPHMC_AVAIL_LEND_QTY),convert(numeric(18,3),DPHMC_LEND_QTY),convert(numeric(18,3),DPHMC_BORROW_QTY),dpam_id, holding_dt=convert(varchar(11),@pa_fordate,109),cmp=isnull(clopm_cdsl_rt,0.00)  
		   from DP_HLDG_MSTR_CDSL             
		   LEFT OUTER JOIN ISIN_MSTR ON DPHMC_ISIN = ISIN_CD            
		   LEFT OUTER JOIN CLOSING_LAST_CDSL ON DPHMC_ISIN = CLOPM_ISIN_CD,                  
		   #ACLIST account                              
		   where DPHMC_HOLDING_DT = @pa_fordate and DPHMC_DPM_ID = @@dpmid                        
		   and DPHMC_dpam_id = account.dpam_id   
           and isnumeric(dpam_sba_no ) = 1                     
		   and (DPHMC_HOLDING_DT between eff_from and eff_to)                  
		   AND (convert(numeric,DPAM_sba_NO) between convert(numeric,@pa_fromaccid) AND  convert(numeric,@pa_toaccid))                       
		   AND DPHMC_ISIN LIKE @pa_isincd + '%'
          
		   AND ISNULL(DPHMC_CURR_QTY,0) <> 0           
		   order by DPAM_sba_NO,ISIN_NAME,DPHMC_ISIN                        
                     
	  END                        
	  ELSE                        
	  BEGIN       

			select top 1 @@tmpholding_dt = case when DPHMC_HOLDING_DT > @pa_fordate then @pa_fordate else DPHMC_HOLDING_DT end from DP_HLDG_MSTR_CDSL where dphmc_deleted_ind =1 

			INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		
                 
		   select   DPAM_SBA_NAME,DPAM_sba_NO,DPHMCD_ISIN,[citrus_usr].[fn_splitstrin_byspace](isin_name,'40','',1) isin_name,convert(numeric(18,3),DPHMCD_CURR_QTY),Valuation=convert(numeric(18,3),DPHMCD_CURR_QTY*isnull(clopm_cdsl_rt,0)),convert(numeric(18,3),DPHMCD_FREE_QTY),convert(numeric(18,3),DPHMCD_FREEZE_QTY),convert(numeric(18,3),DPHMCD_PLEDGE_QTY)    
		   ,convert(numeric(18,3),DPHMCD_DEMAT_PND_VER_QTY),convert(numeric(18,3),DPHMCD_REMAT_PND_CONF_QTY),convert(numeric(18,3),DPHMCD_DEMAT_PND_CONF_QTY),convert(numeric(18,3),DPHMCD_SAFE_KEEPING_QTY),convert(numeric(18,3),DPHMCD_LOCKIN_QTY)                  
		   ,convert(numeric(18,3),DPHMCD_ELIMINATION_QTY),convert(numeric(18,3),DPHMCD_EARMARK_QTY),convert(numeric(18,3),DPHMCD_AVAIL_LEND_QTY),convert(numeric(18,3),DPHMCD_LEND_QTY),convert(numeric(18,3),DPHMCD_BORROW_QTY),dpam_id,holding_dt=convert(varchar(11),@@tmpholding_dt,109),cmp=isnull(clopm_cdsl_rt,0.00)                                   
		   from DP_DAILY_HLDG_CDSL             
		   LEFT OUTER JOIN ISIN_MSTR ON DPHMCD_ISIN = ISIN_CD            
		   LEFT OUTER JOIN CLOSING_LAST_CDSL ON DPHMCD_ISIN = CLOPM_ISIN_CD,                   
		   #ACLIST account                                    
		   where DPHMCD_HOLDING_DT = @pa_fordate and DPHMCD_DPM_ID = @@dpmid                        
		   and DPHMCD_dpam_id = account.dpam_id  
            and isnumeric(dpam_sba_no ) = 1                            
		   and (DPHMCD_HOLDING_DT between eff_from and eff_to)                  
		   AND (convert(numeric,DPAM_SBA_NO) between convert(numeric,@pa_fromaccid) AND  convert(numeric,@pa_toaccid))   
                    
		   AND DPHMCD_ISIN LIKE @pa_isincd + '%' 
		   AND ISNULL(DPHMCD_CURR_QTY,0) <> 0            
		   order by DPAM_sba_NO,ISIN_NAME,DPHMCD_ISIN                        
       
	  END                        
                          
    END           
            
            
END            
 

      TRUNCATE TABLE #ACLIST
	  DROP TABLE #ACLIST           
                        
END

GO
