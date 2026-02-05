-- Object: PROCEDURE citrus_usr.Pr_Rpt_Holding_Bulk_bak_30032015
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------





--3	2012-06-01 00:00:00.000	2012-06-01 00:00:00.000	1201090000000101	1201090000000101
--exec  [pr_get_holding_fix]   3,'2012-06-01 00:00:00.000','2012-06-01 00:00:00.000','1201090000000101','1201090000000101',''


-- BEGIN TRAN
 /* 
ROLLBACK

COMMIT
EXEC PR_RPT_HOLDING 'CDSL',3,'Y','JUN 01 2012','1201090004071264','1201090004071264','','Y',1 ,'HO|*~|','','', '',''		

EXEC PR_RPT_HOLDING 'NSDL',4,'N','2009-05-22','1203270000187997','1203270000187997','','Y',83001,'HO|*~|','','','',''	

EXEC PR_RPT_HOLDING	'NSDL','4','Y','11/06/2009 12:00:00 AM','10000096','','','Y',1,'HO|*~|','','','',''	
*/
 
create PROC [citrus_usr].[Pr_Rpt_Holding_Bulk_bak_30032015]  
			@PA_DPTYPE VARCHAR(4),                    
			@PA_EXCSMID INT,                    
			@PA_ASONDATE CHAR(1),                    
			@PA_FORDATE DATETIME,                    
			@PA_FROMACCID VARCHAR(16),                    
			@PA_TOACCID VARCHAR(16),                    
			@PA_ISINCD VARCHAR(12),              
			@PA_WITHVALUE varCHAR(100), --Y/N                    
			@PA_LOGIN_PR_ENTM_ID NUMERIC,                      
			@PA_LOGIN_ENTM_CD_CHAIN  VARCHAR(8000),                      
            @PA_SETTM_TYPE VARCHAR(100),
            @PA_SETTM_NO_FR   VARCHAR(100),
            @PA_SETTM_NO_TO   VARCHAR(100),
			@PA_OUTPUT VARCHAR(8000) OUTPUT                      
AS                          
BEGIN                          
       
set dateformat DMY
--if @PA_ASONDATE <> 'Y'
--exec getdatelist
--
if @PA_SETTM_NO_TO = ''
set @PA_SETTM_NO_TO   = @PA_SETTM_NO_FR   
            
declare @l_bbo_code varchar(100), @ISINGRPVAL varchar(10)
set @l_bbo_code =''
set @l_bbo_code = ltrim(rtrim(citrus_usr.fn_splitval(@PA_WITHVALUE,2)))
SET @PA_WITHVALUE = citrus_usr.fn_splitval(@PA_WITHVALUE,1)

                   
DECLARE @@DPMID INT,                          
		@@TMPHOLDING_DT DATETIME

set @ISINGRPVAL ='N'

if @PA_SETTM_TYPE = 'ISINGRP'
begin
	set @ISINGRPVAL = 'Y'
	set @PA_SETTM_TYPE = ''
end

set @pa_settm_type  = case when @pa_settm_type ='0' then  '' else  @pa_settm_type  end 

 SELECT @pa_settm_type = SETTM_TYPE FROM SETTLEMENT_TYPE_MSTR WHERE convert(varchar,SETTM_ID) = @pa_settm_type             AND SETTM_DELETED_IND = 1

 set @pa_settm_type = case when @pa_settm_type ='0' then  '' else  @pa_settm_type  end 

  
SELECT @@DPMID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSMID AND DPM_DELETED_IND =1                          

DECLARE @@L_CHILD_ENTM_ID      NUMERIC                      

SELECT @@L_CHILD_ENTM_ID    =  CITRUS_USR.FN_GET_CHILD(@PA_LOGIN_PR_ENTM_ID , @PA_LOGIN_ENTM_CD_CHAIN)                      

CREATE TABLE 
#ACLIST
(
DPAM_ID BIGINT,
DPAM_SBA_NO VARCHAR(16),
DPAM_SBA_NAME VARCHAR(150),
EFF_FROM DATETIME,
EFF_TO DATETIME
)  

if @l_bbo_code <> ''
begin
select accp_value bbo , dpam_sba_no clientid 
into #bbocode from account_properties with (nolock) , dp_Acct_mstr  with (nolock)
where accp_accpm_prop_Cd='bbo_code'
and accp_clisba_id = dpam_id 
AND ACCP_VALUE = @l_bbo_code

create clustered index ix_1 on #bbocode(clientid,bbo)

end 

PRINT @l_bbo_code

                    
IF @PA_FROMACCID = ''                    

BEGIN                    

			 SET @PA_FROMACCID = '0'                    

			 SET @PA_TOACCID = '99999999999999999'                    

END                      

IF @PA_TOACCID = ''                    

			BEGIN                    

			 SET @PA_TOACCID = @PA_FROMACCID                    
END                    

                        
IF @PA_TOACCID =''                          
BEGIN                          

SET @PA_TOACCID= @PA_FROMACCID               

END           

--select top 20 ltrim(rtrim(DPAM_SBA_NAME)) DPAM_SBA_NAME,
--ltrim(rtrim(DPAM_SBA_NO)) DPAM_SBA_NO,
--ltrim(rtrim(DPHMCD_ISIN)) DPHMCD_ISIN,
--ltrim(rtrim(ISIN_NAME)) ISIN_NAME,
--ltrim(rtrim(a)) a,
--ltrim(rtrim(VALUATION)) VALUATION,
--ltrim(rtrim(x)) free_qty,
--ltrim(rtrim(b)) b,
--ltrim(rtrim(c)) c,
--ltrim(rtrim(d)) d,
--ltrim(rtrim(e)) e,
--ltrim(rtrim(f)) f,
--ltrim(rtrim(g)) g,
--ltrim(rtrim(h)) h,
--ltrim(rtrim(y)) y,
--ltrim(rtrim(i)) i,
--ltrim(rtrim(j)) j,
--ltrim(rtrim(k)) k,
--ltrim(rtrim(l)) l,
--ltrim(rtrim(DPAM_ID)) DPAM_ID,
--ltrim(rtrim(HOLDING_DT)) HOLDING_DT,
--ltrim(rtrim(CMP)) CMP,
--ltrim(rtrim(ratedate)) ratedate,
--ltrim(rtrim(tradingid)) tradingid from tmp_bulkholdingshilpa1 where isnull(tradingid,'')<>''
----return

create table #tmphldg 
(
	[DPHMCD_DPM_ID] [numeric](18, 0) NOT NULL,
	[DPHMCD_DPAM_ID] [numeric](10, 0) NOT NULL,
	[DPHMCD_ISIN] [varchar](20) NOT NULL,
	[DPHMCD_CURR_QTY] [numeric](18, 3) NULL,
	[DPHMCD_FREE_QTY] [numeric](18, 3) NULL,
	[DPHMCD_FREEZE_QTY] [numeric](18, 3) NULL,
	[DPHMCD_PLEDGE_QTY] [numeric](18, 3) NULL,
	[DPHMCD_DEMAT_PND_VER_QTY] [numeric](18, 3) NULL,
	[DPHMCD_REMAT_PND_CONF_QTY] [numeric](18, 3) NULL,
	[DPHMCD_DEMAT_PND_CONF_QTY] [numeric](18, 3) NULL,
	[DPHMCD_SAFE_KEEPING_QTY] [numeric](18, 3) NULL,
	[DPHMCD_LOCKIN_QTY] [numeric](18, 3) NULL,
	[DPHMCD_ELIMINATION_QTY] [numeric](18, 3) NULL,
	[DPHMCD_EARMARK_QTY] [numeric](18, 3) NULL,
	[DPHMCD_AVAIL_LEND_QTY] [numeric](18, 3) NULL,
	[DPHMCD_LEND_QTY] [numeric](18, 3) NULL,
	[DPHMCD_BORROW_QTY] [numeric](18, 3) NULL,
	[dphmcd_holding_dt] datetime
--, rate numeric(18,3),tradingid varchar(100)
	)  

declare @exec varchar(2500)

if @PA_ASONDATE <>'Y'
begin 

	if @l_bbo_code <> ''
	begin 
		insert into  #tmphldg
		exec  [pr_get_holding_fix_latest_BBOCODE]   @@DPMID,@PA_FORDATE,@PA_FORDATE,@PA_FROMACCID,@PA_TOACCID,@l_bbo_code,''

	end 
	else 
	begin 
		if @pa_isincd =''
		begin 
			insert into  #tmphldg
			exec  [pr_get_holding_fix_latest]   @@DPMID,@PA_FORDATE,@PA_FORDATE,@PA_FROMACCID,@PA_TOACCID,''
		end 

		if @pa_isincd <>''
		begin 
			insert into  #tmphldg
			exec  [pr_get_holding_fix_latest_isinwise]   @@DPMID,@PA_FORDATE,@PA_FORDATE,@PA_FROMACCID,@PA_TOACCID,@pa_isincd,''
		end 

	end 


end 
else if @PA_ASONDATE ='Y'
begin 

alter table  #tmphldg add rate numeric(18,3)
alter table  #tmphldg add tradingid varchar(100)

	if @l_bbo_code = '' 
	begin

	insert into  #tmphldg
	select distinct a.* from holdingallforview a, DP_aCCT_MSTR WHERE DPAM_ID = DPHMCD_DPAM_ID
	AND (CONVERT(NUMERIC,DPAM_SBA_NO) BETWEEN CONVERT(NUMERIC,@PA_FROMACCID) AND  CONVERT(NUMERIC,@PA_TOACCID))  
	
	end 
	else 
	begin

	insert into  #tmphldg
	select distinct a.* from holdingallforview a, DP_aCCT_MSTR ,#bbocode WHERE DPAM_ID = DPHMCD_DPAM_ID and dpam_sba_no = clientid
	AND (CONVERT(NUMERIC,DPAM_SBA_NO) BETWEEN CONVERT(NUMERIC,@PA_FROMACCID) AND  CONVERT(NUMERIC,@PA_TOACCID)) 

	
	end 
	

end 

			if @l_bbo_code <> ''
			begin
			INSERT INTO #ACLIST 
--			SELECT DPAM_ID,DPAM_SBA_NO,DPAM_SBA_NAME,EFF_FROM,isnull(EFF_TO,'dec 31 2900') 
--			FROM CITRUS_USR.[fn_acct_list_bytushar](@@DPMID ,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID,@PA_FROMACCID,@PA_TOACCID)    
--			where  exists(select clientid,bbo from #bbocode where clientid = dpam_sba_no and bbo = @l_bbo_code )
			SELECT DPAM_ID,DPAM_SBA_NO,DPAM_SBA_NAME,EFF_FROM,isnull(EFF_TO,'dec 31 2900') 
			FROM CITRUS_USR.fn_acct_list_bytushar_bybbo(@@DPMID ,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID,@PA_FROMACCID,@PA_TOACCID,@l_bbo_code)    
			
			end 
			else 
			begin
--print @@DPMID
--print @PA_LOGIN_PR_ENTM_ID
--print @@L_CHILD_ENTM_ID
--print @PA_FROMACCID
--print @PA_TOACCID
			INSERT INTO #ACLIST 
			SELECT DPAM_ID,DPAM_SBA_NO,DPAM_SBA_NAME,EFF_FROM,isnull(EFF_TO,'dec 31 2900') 
			FROM CITRUS_USR.[fn_acct_list_bytushar](@@DPMID ,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID,@PA_FROMACCID,@PA_TOACCID)    
			
			end 



              
 IF @PA_WITHVALUE = 'N'              
 BEGIN  
--	  IF @PA_ASONDATE = 'Y'                          
--	  BEGIN  
--			 SELECT TOP 1 @PA_FORDATE = convert(varchar(11),DPHMC_HOLDING_DT,109) from dp_hldg_mstr_cdsl with (nolock)
--			 where DPHMC_DPM_ID = @@DPMID order by DPHMC_HOLDING_DT desc --convert(varchar(11),getdate(),109)--DPHMC_HOLDING_DT FROM DP_HLDG_MSTR_CDSL WHERE DPHMC_DELETED_IND =1                           
--	  end 	


			
              

  IF @PA_ASONDATE = 'Y'                          
	  BEGIN 

SELECT TOP 1 @PA_FORDATE = convert(varchar(11),dphmcd_holding_dt,109) from  holdingallforview with (nolock)

 
			 SELECT 
						DPAM_SBA_NAME,
						DPAM_SBA_NO,DPHMCD_ISIN,
						ISIN_NAME,
						CONVERT(NUMERIC(18,3),sum(DPHMCD_CURR_QTY)),
						CONVERT(NUMERIC(18,3),sum(DPHMCD_FREE_QTY)),
						CONVERT(NUMERIC(18,3),sum(DPHMCD_FREEZE_QTY)),
						CONVERT(NUMERIC(18,3),sum(DPHMCD_PLEDGE_QTY)),
						CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)),
						CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)),
						CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_CONF_QTY)),
						CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)),
						--CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)),
						case when CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)) <> '0' then CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)) else CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)) end,
						CONVERT(NUMERIC(18,3),sum(DPHMCD_ELIMINATION_QTY)),
						CONVERT(NUMERIC(18,3),sum(DPHMCD_EARMARK_QTY)),
						CONVERT(NUMERIC(18,3),sum(DPHMCD_AVAIL_LEND_QTY)), 
						CONVERT(NUMERIC(18,3),sum(DPHMCD_LEND_QTY)),
						CONVERT(NUMERIC(18,3),sum(DPHMCD_BORROW_QTY)),
						DPAM_ID, 
						HOLDING_DT=CONVERT(VARCHAR(11),@PA_FORDATE,109)                           
			FROM 
						#tmphldg with (nolock) LEFT OUTER JOIN ISIN_MSTR with (nolock) ON DPHMCD_ISIN = ISIN_CD,                    
						#ACLIST ACCOUNT with (nolock)                                
			WHERE
						DPHMCd_HOLDING_DT = @PA_FORDATE AND DPHMCd_DPM_ID = @@DPMID                          
						AND DPHMCd_DPAM_ID = ACCOUNT.DPAM_ID                      
						AND (DPHMCd_HOLDING_DT BETWEEN EFF_FROM AND EFF_TO)                    
						AND (CONVERT(NUMERIC,DPAM_SBA_NO) BETWEEN CONVERT(NUMERIC,@PA_FROMACCID) AND  CONVERT(NUMERIC,@PA_TOACCID))  
					--	AND ISNULL(DPHMCD_CURR_QTY,0) <> 0                           
						AND DPHMCd_ISIN LIKE @PA_ISINCD + '%' 
			group BY 
						DPAM_SBA_NO,ISIN_NAME,DPHMCd_ISIN  ,DPAM_SBA_NAME ,DPAM_ID                       
			ORDER BY 
						DPAM_SBA_NO,ISIN_NAME,DPHMCd_ISIN  

print getdate()                  

end 
else 
begin

			 SELECT 
						DPAM_SBA_NAME,
						DPAM_SBA_NO,DPHMCD_ISIN,
						ISIN_NAME,
						CONVERT(NUMERIC(18,3),DPHMCD_CURR_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_FREE_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_FREEZE_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_PLEDGE_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_DEMAT_PND_VER_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_REMAT_PND_CONF_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_DEMAT_PND_CONF_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_SAFE_KEEPING_QTY),
						--CONVERT(NUMERIC(18,3),DPHMCD_LOCKIN_QTY),
						case when CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)) <> '0' then CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)) else CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)) end,
						CONVERT(NUMERIC(18,3),DPHMCD_ELIMINATION_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_EARMARK_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_AVAIL_LEND_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_LEND_QTY),
						CONVERT(NUMERIC(18,3),DPHMCD_BORROW_QTY),
						DPAM_ID, 
						HOLDING_DT=CONVERT(VARCHAR(11),@PA_FORDATE,109)                           
			FROM 
						--vw_fetchclientholding LEFT OUTER JOIN ISIN_MSTR ON DPHMCD_ISIN = ISIN_CD,                    
						#tmphldg with (nolock) LEFT OUTER JOIN ISIN_MSTR with (nolock) ON DPHMCD_ISIN = ISIN_CD,                    
						#ACLIST ACCOUNT with (nolock)                                
			WHERE
						DPHMCD_HOLDING_DT = @PA_FORDATE AND DPHMCD_DPM_ID = @@DPMID                          
						AND DPHMCD_DPAM_ID = ACCOUNT.DPAM_ID                      
						AND (DPHMCD_HOLDING_DT BETWEEN EFF_FROM AND EFF_TO)                    
						AND (CONVERT(NUMERIC,DPAM_SBA_NO) BETWEEN CONVERT(NUMERIC,@PA_FROMACCID) AND  CONVERT(NUMERIC,@PA_TOACCID))  
					--	AND ISNULL(DPHMCD_CURR_QTY,0) <> 0                           
						AND DPHMCD_ISIN LIKE @PA_ISINCD + '%'                          
			ORDER BY 
						DPAM_SBA_NO,ISIN_NAME,DPHMCD_ISIN  
end 
                        

		        

		                      
	END
	ELSE --@PA_WITHVALUE ='Y'              
	BEGIN              
    
	
--	   IF @PA_ASONDATE = 'Y'                          
--	   BEGIN                      
--		  SELECT TOP 1 @PA_FORDATE = convert(varchar(11),DPHMC_HOLDING_DT,109) from dp_hldg_mstr_cdsl with (nolock) where DPHMC_DPM_ID = @@DPMID order by DPHMC_HOLDING_DT desc --convert(varchar(11),getdate(),109)--DPHMC_HOLDING_DT FROM DP_HLDG_MSTR_CDSL WHERE DPHMC_DELETED_IND =1                           
--	   END 
--		 
IF @PA_ASONDATE = 'Y'                          
BEGIN   

SELECT TOP 1 @PA_FORDATE = convert(varchar(11),dphmcd_holding_dt,109) from  holdingallforview with (nolock)

      
--		 SELECT distinct DPAM_SBA_NAME,DPAM_SBA_NO,DPHMCD_ISIN,ISIN_NAME,CONVERT(NUMERIC(18,3),sum(DPHMCD_CURR_QTY)),
--  VALUATION=(CONVERT(NUMERIC(18,3),sum(DPHMCD_FREE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_FREEZE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_PLEDGE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)))*ISNULL(CLOPM_CDSL_RT,0) ---CONVERT(NUMERIC(18,2),sum(DPHMCD_CURR_QTY)*ISNULL(CLOPM_CDSL_RT,0)),
-- ,CONVERT(NUMERIC(18,3),sum(DPHMCD_FREE_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_FREEZE_QTY))      
--		 ,CONVERT(NUMERIC(18,3),sum(DPHMCD_PLEDGE_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_CONF_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY))       
--		 ,CONVERT(NUMERIC(18,3),sum(DPHMCD_ELIMINATION_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_EARMARK_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_AVAIL_LEND_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_LEND_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_BORROW_QTY)),DPAM_ID, HOLDING_DT=CONVERT(VARCHAR(11),@PA_FORDATE,109),CMP=ISNULL(convert(numeric(18,2),CLOPM_CDSL_RT),0.00)  
--		 ,CLOPM_DT ratedate
--  ,tradingid
print @ISINGRPVAL
if @ISINGRPVAL <> 'Y'
begin
 SELECT distinct DPAM_SBA_NAME,DPAM_SBA_NO,DPHMCD_ISIN,replace(ISIN_NAME,'*','') ISIN_NAME,CONVERT(NUMERIC(18,3),sum(DPHMCD_CURR_QTY)),
  VALUATION=isnull((CONVERT(NUMERIC(18,3),sum(DPHMCD_FREE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_FREEZE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_PLEDGE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_AVAIL_LEND_QTY)) )*ISNULL(CLOPM_CDSL_RT,0),0) ---CONVERT(NUMERIC(18,2),sum(DPHMCD_CURR_QTY)*ISNULL(CLOPM_CDSL_RT,0)),
 ,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_FREE_QTY)),0),isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_FREEZE_QTY)),0)      
 ,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_PLEDGE_QTY)),0)
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)),0)
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)),0)
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_CONF_QTY)),0)
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)),0)
--,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)),0)      
,case when CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)) <> '0' then CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)) else CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)) end
		 ,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_ELIMINATION_QTY)),0),isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_EARMARK_QTY)),0),isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_AVAIL_LEND_QTY)),0),isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_LEND_QTY)),0),isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_BORROW_QTY)),0),DPAM_ID, HOLDING_DT=CONVERT(VARCHAR(11),@PA_FORDATE,109),CMP=ISNULL(convert(numeric(18,2),CLOPM_CDSL_RT),0.00)  
		 ,CLOPM_DT ratedate
  ,tradingid

		 FROM #tmphldg    with (nolock)           
		 LEFT OUTER JOIN ISIN_MSTR with (nolock) ON DPHMCD_ISIN = ISIN_CD              
		 LEFT OUTER JOIN CLOSING_PRICE_MSTR_cDSL with (nolock) ON DPHMCD_ISIN = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = DPHMCD_ISIN and CLOPM_DT <= @PA_FORDATE and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)   ,                    
		 #ACLIST ACCOUNT  with (nolock)                              
		 WHERE DPHMCD_HOLDING_DT = @PA_FORDATE AND DPHMCD_DPM_ID = @@DPMID                          
		 AND DPHMCD_DPAM_ID = ACCOUNT.DPAM_ID                      
		 AND (DPHMCD_HOLDING_DT BETWEEN EFF_FROM AND EFF_TO)                    
		 AND (CONVERT(NUMERIC,DPAM_SBA_NO) BETWEEN CONVERT(NUMERIC,@PA_FROMACCID) AND  CONVERT(NUMERIC,@PA_TOACCID))                         
		 AND DPHMCD_ISIN LIKE @PA_ISINCD + '%'      
		-- AND ISNULL(DPHMCD_CURR_QTY,0) <> 0  
group BY DPAM_SBA_NO,ISIN_NAME,DPHMCD_ISIN ,DPAM_SBA_NAME  ,CLOPM_CDSL_RT,dpam_id,CLOPM_DT
,tradingid
having isnull((CONVERT(NUMERIC(18,3),sum(DPHMCD_curr_QTY))),0) <> 0
--or isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)),0) <> 0
--or  isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)),0) <> 0             

ORDER BY DPAM_SBA_NO,ISIN_NAME,DPHMCD_ISIN    
end
else
begin
SELECT distinct DPAM_SBA_NAME,DPAM_SBA_NO,DPHMCD_ISIN,replace(ISIN_NAME,'*','') ISIN_NAME,CONVERT(NUMERIC(18,3),sum(DPHMCD_CURR_QTY)),
  --VALUATION=isnull((CONVERT(NUMERIC(18,3),sum(DPHMCD_FREE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_FREEZE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_PLEDGE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_AVAIL_LEND_QTY)) )*ISNULL(CLOPM_CDSL_RT,0),0) ---CONVERT(NUMERIC(18,2),sum(DPHMCD_CURR_QTY)*ISNULL(CLOPM_CDSL_RT,0)),
 VALUATION=isnull((CONVERT(NUMERIC(18,3),sum(DPHMCD_FREE_QTY)))*ISNULL(CLOPM_CDSL_RT,0),0) ---CONVERT(NUMERIC(18,2),sum(DPHMCD_CURR_QTY)*ISNULL(CLOPM_CDSL_RT,0)),
 ,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_FREE_QTY)),0),isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_FREEZE_QTY)),0)      
		 ,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_PLEDGE_QTY)),0)
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)),0)
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)),0)
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_CONF_QTY)),0)
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)),0)
--,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)),0)      
,case when CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)) <> '0' then CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)) else CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)) end
		 ,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_ELIMINATION_QTY)),0),isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_EARMARK_QTY)),0),isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_AVAIL_LEND_QTY)),0),isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_LEND_QTY)),0),isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_BORROW_QTY)),0),DPAM_ID, HOLDING_DT=CONVERT(VARCHAR(11),@PA_FORDATE,109),CMP=ISNULL(convert(numeric(18,2),CLOPM_CDSL_RT),0.00)  
		 ,CLOPM_DT ratedate
  ,tradingid
,isnull((CONVERT(NUMERIC(18,3),sum(DPHMCD_curr_QTY))),0) FREE_QTY

		 FROM #tmphldg    with (nolock)           
		 LEFT OUTER JOIN ISIN_MSTR with (nolock) ON DPHMCD_ISIN = ISIN_CD              
		 LEFT OUTER JOIN CLOSING_PRICE_MSTR_cDSL with (nolock) ON DPHMCD_ISIN = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = DPHMCD_ISIN and CLOPM_DT <= @PA_FORDATE and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)   ,                    
		 #ACLIST ACCOUNT  with (nolock)                              
		 WHERE DPHMCD_HOLDING_DT = @PA_FORDATE AND DPHMCD_DPM_ID = @@DPMID                          
		 AND DPHMCD_DPAM_ID = ACCOUNT.DPAM_ID                      
		 AND (DPHMCD_HOLDING_DT BETWEEN EFF_FROM AND EFF_TO)                    
		 AND (CONVERT(NUMERIC,DPAM_SBA_NO) BETWEEN CONVERT(NUMERIC,@PA_FROMACCID) AND  CONVERT(NUMERIC,@PA_TOACCID))                         
		 AND DPHMCD_ISIN LIKE @PA_ISINCD + '%'      
		-- AND ISNULL(DPHMCD_CURR_QTY,0) <> 0  
group BY DPHMCD_ISIN,ISIN_NAME,DPAM_SBA_NO,DPAM_SBA_NAME  ,CLOPM_CDSL_RT,dpam_id,CLOPM_DT
,tradingid
having isnull((CONVERT(NUMERIC(18,3),sum(DPHMCD_CURR_QTY))),0) <> 0
--or isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)),0) <> 0
--or  isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)),0) <> 0             

--DPAM_SBA_NO,ISIN_NAME,DPHMCD_ISIN ,DPAM_SBA_NAME  ,CLOPM_CDSL_RT,dpam_id,CLOPM_DT
--,tradingid
 ORDER BY DPHMCD_ISIN,ISIN_NAME,DPAM_SBA_NO  
end 
end
else 
begin

--SELECT distinct DPAM_SBA_NAME,DPAM_SBA_NO,DPHMCD_ISIN,ISIN_NAME,CONVERT(NUMERIC(18,3),sum(DPHMCD_CURR_QTY)),
----VALUATION=CONVERT(NUMERIC(18,2),DPHMCD_CURR_QTY*ISNULL(CLOPM_CDSL_RT,0)), 
--VALUATION=(CONVERT(NUMERIC(18,3),sum(DPHMCD_FREE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_FREEZE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_PLEDGE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)))*ISNULL(CLOPM_CDSL_RT,0)
--,CONVERT(NUMERIC(18,3),sum(DPHMCD_FREE_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_FREEZE_QTY))      
--		 ,CONVERT(NUMERIC(18,3),sum(DPHMCD_PLEDGE_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_CONF_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY))      
--		 ,CONVERT(NUMERIC(18,3),sum(DPHMCD_ELIMINATION_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_EARMARK_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_AVAIL_LEND_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_LEND_QTY)),CONVERT(NUMERIC(18,3),sum(DPHMCD_BORROW_QTY)),DPAM_ID, HOLDING_DT=CONVERT(VARCHAR(11),@PA_FORDATE,109),CMP=ISNULL(convert(numeric(18,2),CLOPM_CDSL_RT),0.00)    
--		 ,CLOPM_DT ratedate
--		 --,tradingid
SELECT distinct DPAM_SBA_NAME,DPAM_SBA_NO,DPHMCD_ISIN,replace(ISIN_NAME,'*','') ISIN_NAME,CONVERT(NUMERIC(18,3),sum(DPHMCD_CURR_QTY)),
--VALUATION=CONVERT(NUMERIC(18,2),DPHMCD_CURR_QTY*ISNULL(CLOPM_CDSL_RT,0)), 
VALUATION=isnull((CONVERT(NUMERIC(18,3),sum(DPHMCD_FREE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_FREEZE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_PLEDGE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)) )*ISNULL(CLOPM_CDSL_RT,0),0)
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_FREE_QTY)),0),isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_FREEZE_QTY)),0)      
		 ,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_PLEDGE_QTY)),0)
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)),0)
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)),0)
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_CONF_QTY)),0)
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)),0)
--,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)),0)     
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)),0)     lockinqty
,case when CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)) <> '0' then CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)) else CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)) end
		 ,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_ELIMINATION_QTY)),0),isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_EARMARK_QTY)),0),isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_AVAIL_LEND_QTY)),0),isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_LEND_QTY)),0),isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_BORROW_QTY)),0),DPAM_ID, HOLDING_DT=CONVERT(VARCHAR(11),@PA_FORDATE,109),CMP=ISNULL(convert(numeric(18,2),CLOPM_CDSL_RT),0.00)    
		 ,CLOPM_DT ratedate
		 ,dpam_bbo_code  tradingid

		 FROM #tmphldg with (nolock)               
		 LEFT OUTER JOIN ISIN_MSTR with (nolock) ON DPHMCD_ISIN = ISIN_CD              
		 LEFT OUTER JOIN CLOSING_PRICE_MSTR_cDSL with (nolock) ON DPHMCD_ISIN = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = DPHMCD_ISIN and CLOPM_DT <= @PA_FORDATE and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)   ,                    
		 #ACLIST ACCOUNT with (nolock)  ,(select dpam_id dpamid , dpam_bbo_code from dp_acct_mstr                              ) dpam
		 WHERE DPHMCD_HOLDING_DT = @PA_FORDATE AND DPHMCD_DPM_ID = @@DPMID  and dpamid = dphmcd_dpam_id 
		 AND DPHMCD_DPAM_ID = ACCOUNT.DPAM_ID                      
		 AND (DPHMCD_HOLDING_DT BETWEEN EFF_FROM AND EFF_TO)                    
		 AND (CONVERT(NUMERIC,DPAM_SBA_NO) BETWEEN CONVERT(NUMERIC,@PA_FROMACCID) AND  CONVERT(NUMERIC,@PA_TOACCID))                         
		 AND DPHMCD_ISIN LIKE @PA_ISINCD + '%'      
		-- AND ISNULL(DPHMCD_CURR_QTY,0) <> 0 
group BY DPAM_SBA_NO,ISIN_NAME,DPHMCD_ISIN ,DPAM_SBA_NAME  ,CLOPM_CDSL_RT,dpam_id,CLOPM_DT 
,dpam_bbo_code
having isnull((CONVERT(NUMERIC(18,3),sum(DPHMCD_curr_QTY))),0) <> 0
--or isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)),0) <> 0
--or isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)),0) <> 0             
		 ORDER BY DPAM_SBA_NO,ISIN_NAME,DPHMCD_ISIN 

end                       
                       
                   
    END             
              
              
        truncate table #tmphldg
        drop table #tmphldg
   
  
      TRUNCATE TABLE #ACLIST  
   DROP TABLE #ACLIST             
                          
END

GO
