-- Object: PROCEDURE citrus_usr.Sproc_MYB_DpTrans_sso
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

-- delete_suresh_Sproc_MYB_DpTrans_sso  '1201090000840524', '01/01/2012', '10/03/2012'  
  
CREATE procedure [citrus_usr].[Sproc_MYB_DpTrans_sso]        
(@dpid as nvarchar(20),@fromDate as nvarchar(20) , @todate as nvarchar(20))          
as          
SET NOCOUNT ON          
        
DECLARE @FRMDT VARCHAR(100)          
DECLARE @FTODT VARCHAR(100)        
set @FRMDT = CONVERT(VARCHAR(11),convert(datetime,@fromDate),109)        
set @FTODT = CONVERT(VARCHAR(11),convert(datetime,@todate),109)        
        
/*        
[Sproc_MYB_DpTrans_sso] '1201090000840524', '10/01/2012', '10/03/2012'        
*/        
declare @p19 varchar(100)        
set @p19 = ''        


declare @exscmId int

if substring(@dpid,1,8) = '12010900' 
	set @exscmId = 3
else if substring(@dpid,1,8) = '12010901' 
	set @exscmId = 19
else if substring(@dpid,1,8) = '12010902' 
	set @exscmId = 20
else if substring(@dpid,1,8) = '12010903' 
	set @exscmId = 21
else if substring(@dpid,1,8) = '12010904' 
	set @exscmId = 22
else if substring(@dpid,1,8) = '12010905'
	set @exscmId = 23
else if substring(@dpid,1,8) = '12010906'
	set @exscmId = 24
else if substring(@dpid,1,8) = '12010907'
	set @exscmId = 25
else if substring(@dpid,1,8) = '12010908'
	set @exscmId = 26
else if substring(@dpid,1,8) = '12010909'
	set @exscmId = 27
else if substring(@dpid,1,8) = '12010910'
	set @exscmId = 28
else if substring(@dpid,1,8) = '12010911'
	set @exscmId = 29
else if substring(@dpid,1,8) = '12010912'
	set @exscmId = 30
else if substring(@dpid,1,8) = '12010915'
	set @exscmId = 31
else if substring(@dpid,1,8) = '12010916'
	set @exscmId = 32
else if substring(@dpid,1,8) = '12010917'
	set @exscmId = 34
else if substring(@dpid,1,8) = '12010918'
	set @exscmId = 35
else if substring(@dpid,1,8) = '12010919'
	set @exscmId = 36
else if substring(@dpid,1,8) = '12010921'
	set @exscmId = 37
else if substring(@dpid,1,8) = '12010922'
	set @exscmId = 38
else if substring(@dpid,1,8) = '12010923'
	set @exscmId = 39
else if substring(@dpid,1,8) = '12010924'
	set @exscmId = 40
else if substring(@dpid,1,8) = '12010926'
	set @exscmId = 41
else if substring(@dpid,1,8) = '12010927'
	set @exscmId = 42
else if substring(@dpid,1,8) = '12010928'
	set @exscmId = 43


        
CREATE TABLE #tblDpPermRecords(    
 [order_by] [numeric](18, 0) NULL,    
 [dpam_id] [numeric](18, 0) NULL,    
 [dpam_sba_name] [varchar](100) NULL,    
 [dpam_acctno] [varchar](100) NULL,    
 [CDSHM_TRATM_DESC] [varchar](100) NULL,    
 [dpm_trans_no] [varchar](100) NULL,    
 [trans_date] [varchar](100) NULL,    
 [ISIN_CD] [varchar](100) NULL,    
 [sett_type] [varchar](100) NULL,    
 [sett_no] [varchar](100) NULL,    
 [isin_name] [varchar](100) NULL,    
 [opening_bal] [numeric](18, 0) NULL,    
 [DEBIT_QTY] [varchar](500) NULL,    
 [CREDIT_QTY] [varchar](500) NULL,    
 [closing_bal] [numeric](18, 0) NULL,    
 [cdshm_trg_settm_no] [varchar](100) NULL,    
 [VALUATION] [numeric](18, 2) NULL,    
 [rate] [numeric](18, 4) NULL,    
 [tratm_cd] [varchar](100) NULL,    
 [totalhldg] [numeric](18, 4) NULL    
)    
  
    
        
INSERT INTO #tblDpPermRecords (order_by,dpam_id,dpam_sba_name,dpam_acctno,CDSHM_TRATM_DESC,dpm_trans_no,trans_date,ISIN_CD,sett_type,sett_no,isin_name,opening_bal,DEBIT_QTY,CREDIT_QTY,closing_bal,cdshm_trg_settm_no,VALUATION,rate,tratm_cd,totalhldg)   
exec [192.168.100.30].DMAT.citrus_usr.Pr_rpt_statement @pa_dptype='CDSL',@pa_excsmid=@exscmId,@pa_fromdate=@FRMDT,        
@pa_todate=@FTODT,        
@pa_fromaccid=@dpid,        
@pa_toaccid='',@pa_bulk_printflag='N',        
@pa_stopbillclients_flag='N',        
@pa_isincd='',@pa_group_cd='|*~|N',        
@pa_transclientsonly='N',        
@pa_Hldg_Yn='N',        
@pa_login_pr_entm_id='1',        
@pa_login_entm_cd_chain='HO|*~|',        
@pa_settm_type='',        
@pa_settm_no_fr='',        
@pa_settm_no_to='',        
@PA_WITHVALUE='Y',        
@pa_output=@p19 out        
      
  
select     
cast(order_by as int)order_by,cast(dpam_id as bigint)dpam_id,dpam_sba_name,dpam_acctno,CDSHM_TRATM_DESC,dpm_trans_no,    
trans_date,ISIN_CD,sett_type,sett_no,isin_name,    
cast(opening_bal as varchar(100)) as opening_bal,    
cast(case when DEBIT_QTY = '' then '0' else DEBIT_QTY end as decimal(18,0))DEBIT_QTY,    
cast(case when CREDIT_QTY = '' then '0' else CREDIT_QTY end as decimal(18,0))CREDIT_QTY,    
cast(closing_bal as decimal(18,0))closing_bal,cdshm_trg_settm_no,VALUATION,rate,tratm_cd,totalhldg    
from #tblDpPermRecords     
where dpam_acctno = @dpid         
      
        
drop table #tblDpPermRecords

GO
