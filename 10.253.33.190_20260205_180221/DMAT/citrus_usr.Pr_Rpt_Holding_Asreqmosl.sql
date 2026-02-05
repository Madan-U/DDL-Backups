-- Object: PROCEDURE citrus_usr.Pr_Rpt_Holding_Asreqmosl
-- Server: 10.253.33.190 | DB: DMAT
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
 
CREATE  PROC [citrus_usr].[Pr_Rpt_Holding_Asreqmosl](
--			@PA_DPTYPE VARCHAR(4),                    
--			@PA_EXCSMID INT,                    
--			@PA_ASONDATE CHAR(1),                    
			@PA_FORDATE DATETIME,                    
			@PA_FROMACCID VARCHAR(16)                    
			--@PA_TOACCID VARCHAR(16),                    
			--@PA_ISINCD VARCHAR(12),              
			--@PA_WITHVALUE varCHAR(100), --Y/N                    
			--@PA_LOGIN_PR_ENTM_ID NUMERIC,                      
			--@PA_LOGIN_ENTM_CD_CHAIN  VARCHAR(8000),                      
            --@PA_SETTM_TYPE VARCHAR(100),
            --@PA_SETTM_NO_FR   VARCHAR(100),
            --@PA_SETTM_NO_TO   VARCHAR(100),
			--@PA_OUTPUT VARCHAR(8000) OUTPUT  
)                    
AS                          
BEGIN                          
       
set dateformat DMY
--if @PA_ASONDATE <> 'Y'
--exec getdatelist
--

declare @PA_EXCSMID numeric
set @PA_EXCSMID = 0 

if (@PA_FROMACCID = '') or not exists(select dpam_sba_no from dp_acct_mstr where dpam_sba_no =@PA_FROMACCID )
begin


SELECT distinct 0 DPHMCD_DPM_ID,'' DPAM_SBA_NAME
,'' DPAM_SBA_NO

,'' DPHMCD_ISIN
,'' ISIN_NAME
,0 DPHMCD_CURR_QTY
,VALUATION=0
,0 DPHMCD_FREE_QTY 
,0 DPHMCD_FREEZE_QTY      
,0 DPHMCD_PLEDGE_QTY
,0 DPHMCD_DEMAT_PND_VER_QTY
,0 DPHMCD_REMAT_PND_CONF_QTY
,0 DPHMCD_DEMAT_PND_CONF_QTY
,0 DPHMCD_SAFE_KEEPING_QTY
,0 DPHMCD_LOCKING_QTY    
,0 DPHMCD_ELIMINATION_QTY
,0 DPHMCD_EARMARK_QTY
,0 DPHMCD_AVAIL_LEND_QTY
,0 DPHMCD_LEND_QTY
,0 DPHMCD_BORROW_QTY
,0 DPHMCD_DPAM_ID
,DPHMCD_HOLDING_DT=''
,DP_ID=''
,'' ratedate,'' dpam_bbo_code
,Rate=''
--,tradingid 
where 1=0

return 

end 
else 
begin

select @PA_EXCSMID = dpam_excsm_id from dp_acct_mstr where dpam_sba_no = @PA_FROMACCID and dpam_deleted_ind = 1

end  

--
--if @PA_SETTM_NO_TO = ''
--set @PA_SETTM_NO_TO   = @PA_SETTM_NO_FR   
--            
--declare @l_bbo_code varchar(100)
--set @l_bbo_code =''
--set @l_bbo_code = ltrim(rtrim(citrus_usr.fn_splitval(@PA_WITHVALUE,2)))
--SET @PA_WITHVALUE = citrus_usr.fn_splitval(@PA_WITHVALUE,1)
--
--                   
DECLARE @@DPMID INT,                          
		@@TMPHOLDING_DT DATETIME


  
SELECT @@DPMID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSMID AND DPM_DELETED_IND =1                          



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




insert into  #tmphldg
exec  [pr_get_holding_fix_latest]   @@DPMID,@PA_FORDATE,@PA_FORDATE,@PA_FROMACCID,@PA_FROMACCID,''


SELECT distinct dpam_dpm_id dphmcd_dpm_id , DPAM_SBA_NAME
,DPAM_SBA_NO
,DPHMCD_ISIN
,ISIN_NAME
,CONVERT(NUMERIC(18,3),sum(DPHMCD_CURR_QTY)) DPHMCD_CURR_QTY,
VALUATION=isnull((CONVERT(NUMERIC(18,3),sum(DPHMCD_FREE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_FREEZE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_PLEDGE_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)) + CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)))*ISNULL(CLOPM_CDSL_RT,0),0)
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_FREE_QTY)),0) DPHMCD_FREE_QTY 
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_FREEZE_QTY)),0) DPHMCD_FREEZE_QTY      
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_PLEDGE_QTY)),0) DPHMCD_PLEDGE_QTY
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_VER_QTY)),0) DPHMCD_DEMAT_PND_VER_QTY
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_REMAT_PND_CONF_QTY)),0) DPHMCD_REMAT_PND_CONF_QTY
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_DEMAT_PND_CONF_QTY)),0) DPHMCD_DEMAT_PND_CONF_QTY
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_SAFE_KEEPING_QTY)),0) DPHMCD_SAFE_KEEPING_QTY
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_LOCKIN_QTY)),0)  DPHMCD_LOCKING_QTY    
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_ELIMINATION_QTY)),0) DPHMCD_ELIMINATION_QTY
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_EARMARK_QTY)),0) DPHMCD_EARMARK_QTY
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_AVAIL_LEND_QTY)),0) DPHMCD_AVAIL_LEND_QTY
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_LEND_QTY)),0) DPHMCD_LEND_QTY
,isnull(CONVERT(NUMERIC(18,3),sum(DPHMCD_BORROW_QTY)),0) DPHMCD_BORROW_QTY
,dpam_id dphmcd_dpam_id
,DPHMCD_HOLDING_DT=CONVERT(VARCHAR(11),@PA_FORDATE,109),rate=ISNULL(convert(numeric(18,2),CLOPM_CDSL_RT),0.00)    
,CLOPM_DT ratedate
,dpam_bbo_code
,left(DPAM_SBA_NO,8) DP_ID

FROM #tmphldg with (nolock)               
LEFT OUTER JOIN ISIN_MSTR with (nolock) ON DPHMCD_ISIN = ISIN_CD              
LEFT OUTER JOIN CLOSING_PRICE_MSTR_cDSL with (nolock) ON DPHMCD_ISIN = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = DPHMCD_ISIN and CLOPM_DT <= @PA_FORDATE and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)   ,                    
dp_acct_mstr ACCOUNT with (nolock)                                
WHERE DPHMCD_HOLDING_DT = @PA_FORDATE AND DPHMCD_DPM_ID = @@DPMID                          
AND DPHMCD_DPAM_ID = ACCOUNT.DPAM_ID                      
AND CONVERT(NUMERIC,DPAM_SBA_NO) = CONVERT(NUMERIC,@PA_FROMACCID) 
group BY dpam_dpm_id,DPAM_SBA_NO,ISIN_NAME,DPHMCD_ISIN ,DPAM_SBA_NAME  ,CLOPM_CDSL_RT,dpam_id,CLOPM_DT ,dpam_bbo_code
--,tradingid         
ORDER BY DPAM_SBA_NO,ISIN_NAME,DPHMCD_ISIN 

                       
                   
              
              
              
   
          
                          
END

GO
