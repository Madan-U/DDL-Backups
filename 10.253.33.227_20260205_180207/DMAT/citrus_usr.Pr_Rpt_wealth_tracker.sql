-- Object: PROCEDURE citrus_usr.Pr_Rpt_wealth_tracker
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--3	1203270000000990	1203270000000990	Jan 12 2010	
--Pr_Rpt_wealth_tracker 3,'1234567800000990','','Jan 12 2010',''
--Pr_Rpt_wealth_tracker 3,'','','Jan 19 2010',''
--SELECT * FROM dp_acct_mstr ORDER BY 1 DESC WHERE DPAM_SBA_NO BETWEEN '111111' AND '10000012'
CREATE procedure [citrus_usr].[Pr_Rpt_wealth_tracker]      
(
   @pa_excsmid  int      
  ,@pa_frmboid varchar(20)      
  ,@pa_toboid varchar(20)      
  ,@pa_ason_dt datetime     
  ,@pa_output varchar(8000) output      
) 
As
Begin     
declare @l_fin_yr numeric

select @l_fin_yr = FIN_ID from financial_yr_mstr where getdate() between FIN_START_DT and FIN_END_DT

declare @l_sql varchar(8000)
		--@l_sql1 varchar(8000),
		--@l_sql2 varchar(8000)

--IF @pa_frmboid = ''                      
-- BEGIN                      
--  SET @pa_frmboid = '0'                      
--  SET @pa_toboid = '99999999999999999'                      
-- END                      
 IF @pa_toboid = ''                      
 BEGIN                  
   SET @pa_toboid = @pa_frmboid                      
 END 
	
IF @pa_frmboid <> '' and @pa_toboid <> ''
BEGIN
	select @l_sql  = 'select dpam_sba_no [Demat Code]
					,dpam_sba_name [Party Name]
					,DPHMCD_ISIN [lists of shares ISIN WISE]
					,SUM(CONVERT(NUMERIC(18,2),DPHMCD_CURR_QTY*ISNULL(CLOPM_CDSL_RT,0))) [Valuation of shares as on date]
					,isnull(sum(ldg_amount),0) [Demat Ledger details.]
                    ,ISNULL(DPHMCD_CURR_QTY,0) DPHMCD_CURR_QTY
					from dp_acct_mstr 
					left outer join ledger'+convert(varchar,@l_fin_yr ) +' on ldg_account_id = DPAM_ID and ldg_deleted_ind =1 
					,DP_DAILY_HLDG_CDSL 
					 LEFT OUTER JOIN ISIN_MSTR ON DPHMCD_ISIN = ISIN_CD              
					 LEFT OUTER JOIN CLOSING_PRICE_MSTR_CDSL ON DPHMCD_ISIN = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,''01/01/1900'') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = DPHMCD_ISIN and CLOPM_DT <= getdate() and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)                     
					 where   DPHMCD_DPAM_ID = dpam_id      
					AND ISNULL(DPHMCD_CURR_QTY,0) <> 0
					AND dpam_sba_no between '''+@pa_frmboid+''' AND '''+@pa_toboid+'''
					group by dpam_id,dpam_sba_no,dpam_sba_name,DPHMCD_ISIN ,DPHMCD_CURR_QTY order by dpam_id'				
END

ELSE
BEGIN
	SET @l_sql = 'select dpam_sba_no [Demat Code]
					,dpam_sba_name [Party Name]
					,DPHMCD_ISIN [lists of shares ISIN WISE]
					,SUM(CONVERT(NUMERIC(18,2),DPHMCD_CURR_QTY*ISNULL(CLOPM_CDSL_RT,0))) [Valuation of shares as on date]
					,isnull(sum(ldg_amount),0) [Demat Ledger details.]
                    ,ISNULL(DPHMCD_CURR_QTY,0) DPHMCD_CURR_QTY
					from dp_acct_mstr 
					left outer join ledger'+convert(varchar,@l_fin_yr ) +' on ldg_account_id = DPAM_ID and ldg_deleted_ind =1 
					,DP_DAILY_HLDG_CDSL 
					 LEFT OUTER JOIN ISIN_MSTR ON DPHMCD_ISIN = ISIN_CD              
					 LEFT OUTER JOIN CLOSING_PRICE_MSTR_CDSL ON DPHMCD_ISIN = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,''01/01/1900'') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = DPHMCD_ISIN and CLOPM_DT <= getdate() and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)                     
					 where   DPHMCD_DPAM_ID = dpam_id      
					AND ISNULL(DPHMCD_CURR_QTY,0) <> 0
					group by dpam_id,dpam_sba_no,dpam_sba_name,DPHMCD_ISIN ,DPHMCD_CURR_QTY order by dpam_id'
END	

/*select @l_sql  = 'select dpam_sba_no [Demat Code	]
,dpam_sba_name [Party Name	]
,DPHMCD_ISIN [lists of shares ISIN WISE	]
,SUM(CONVERT(NUMERIC(18,2),DPHMCD_CURR_QTY*ISNULL(CLOPM_CDSL_RT,0))) [Valuation of shares as on date	]
,isnull(sum(ldg_amount),0) [Demat Ledger details.]
from dp_acct_mstr 
left outer join ledger'+convert(varchar,@l_fin_yr ) +' on ldg_account_id = DPAM_ID and ldg_deleted_ind =1 
,DP_DAILY_HLDG_CDSL 
 LEFT OUTER JOIN ISIN_MSTR ON DPHMCD_ISIN = ISIN_CD              
 LEFT OUTER JOIN CLOSING_PRICE_MSTR_CDSL ON DPHMCD_ISIN = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,''01/01/1900'') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = DPHMCD_ISIN and CLOPM_DT <= getdate() and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc)                     
 where   DPHMCD_DPAM_ID = dpam_id      
AND ISNULL(DPHMCD_CURR_QTY,0) <> 0'*/


--AND (convert(numeric,dpam_sba_no) between convert(numeric,'''+@pa_frmboid+''') AND  convert(numeric,'''+@pa_toboid+'''))

print (@l_sql)
exec(@l_sql)
end

GO
