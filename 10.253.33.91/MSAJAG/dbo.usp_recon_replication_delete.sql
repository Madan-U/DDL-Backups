-- Object: PROCEDURE dbo.usp_recon_replication_delete
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc [dbo].[usp_recon_replication]  
as begin  
--truncate table tbl_nsecash_replication  
--select *,'MSAJAG' AS 'DB' into #source_nsecash from (  
--select 'Client1' as TableName, count(1) as cnt from msajag.dbo.Client1 with(nolock) union  
--select 'Client2' as TableName, count(1) as cnt from msajag.dbo.Client2 with(nolock) union  
--select 'client3' as TableName, count(1) as cnt from msajag.dbo.client3 with(nolock) union  
--select 'client4' as TableName, count(1) as cnt from msajag.dbo.client4 with(nolock) union  
--select 'client5' as TableName, count(1) as cnt from msajag.dbo.client5 with(nolock) union  
--select 'clienttaxes_new' as TableName, count(1) as cnt from msajag.dbo.clienttaxes_new with(nolock) union  
--select 'clientbrok_scheme' as TableName, count(1) as cnt from msajag.dbo.clientbrok_scheme with(nolock) union  
--select 'settlement' as TableName, count(1) as cnt from msajag.dbo.settlement with(nolock) union  
--select 'broktable' as TableName, count(1) as cnt from msajag.dbo.broktable with(nolock) union  
--select 'scheme_mapping' as TableName, count(1) as cnt from msajag.dbo.scheme_mapping with(nolock) union  
--select 'charges_detail' as TableName, count(1) as cnt from msajag.dbo.charges_detail with(nolock) union  
--select 'history' as TableName, count(1) as cnt from msajag.dbo.history with(nolock) union  
--select 'isettlement' as TableName, count(1) as cnt from msajag.dbo.isettlement with(nolock) union  
----select 'Contract_data' as TableName, count(1) as cnt from msajag.dbo.Contract_data with(nolock) union  
--select 'common_contract_data' as TableName, count(1) as cnt from msajag.dbo.common_contract_data with(nolock) union  
--select 'owner' as TableName, count(1) as cnt from msajag.dbo.owner with(nolock) union  
--select 'taxes' as TableName, count(1) as cnt from msajag.dbo.taxes with(nolock) union  
--select 'Client_details' as TableName, count(1) as cnt from msajag.dbo.Client_details with(nolock) union  
--select 'client_brok_details' as TableName, count(1) as cnt from msajag.dbo.client_brok_details with(nolock) union  
--select 'CLIENT_MASTER_UCC_DATA' as TableName, count(1) as cnt from msajag.dbo.CLIENT_MASTER_UCC_DATA with(nolock) union  
--select 'Multicltid' as TableName, count(1) as cnt from msajag.dbo.Multicltid with(nolock) union  
--select 'Pobank' as TableName, count(1) as cnt from msajag.dbo.Pobank with(nolock) union  
--select 'Bank' as TableName, count(1) as cnt from msajag.dbo.Bank with(nolock) union  
--select 'Branch' as TableName, count(1) as cnt from msajag.dbo.Branch with(nolock) union  
--select 'Subbrokers' as TableName, count(1) as cnt from msajag.dbo.Subbrokers with(nolock) union  
--select 'branches' as TableName, count(1) as cnt from msajag.dbo.branches with(nolock) union  
--select 'Region' as TableName, count(1) as cnt from msajag.dbo.Region with(nolock) union  
--select 'TBL_Combine_Reporting' as TableName, count(1) as cnt from msajag.dbo.TBL_Combine_Reporting with(nolock) union  
--select 'TBL_Combine_Reporting_Detail' as TableName, count(1) as cnt from msajag.dbo.TBL_Combine_Reporting_Detail with(nolock) union  
--select 'TBL_Combine_Reporting_Peak' as TableName, count(1) as cnt from msajag.dbo.TBL_Combine_Reporting_Peak with(nolock) union  
--select 'TBL_Combine_Reporting_peak_detail' as TableName, count(1) as cnt from msajag.dbo.TBL_Combine_Reporting_peak_detail with(nolock) union  
--select 'V2_TBL_COLLATERAL_MARGIN_COMBINE' as TableName, count(1) as cnt from msajag.dbo.V2_TBL_COLLATERAL_MARGIN_COMBINE with(nolock) union  
--select 'TBL_Combine_Reporting_hist' as TableName, count(1) as cnt from msajag.dbo.TBL_Combine_Reporting_hist with(nolock) union  
--select 'TBL_COMBINE_REPORTING_DETAIL_HIST' as TableName, count(1) as cnt from msajag.dbo.TBL_COMBINE_REPORTING_DETAIL_HIST with(nolock) union  
--select 'TBL_COMBINE_REPORTING_PEAK_HIST' as TableName, count(1) as cnt from msajag.dbo.TBL_COMBINE_REPORTING_PEAK_HIST with(nolock) union  
--select 'TBL_COMBINE_REPORTING_PEAK_DETAIL_HIST' as TableName, count(1) as cnt from msajag.dbo.TBL_COMBINE_REPORTING_PEAK_DETAIL_HIST with(nolock) union  
--select 'V2_TBL_COLLATERAL_MARGIN_COMBINE_hist' as TableName, count(1) as cnt from msajag.dbo.V2_TBL_COLLATERAL_MARGIN_COMBINE_history with(nolock) union  
--select 'Cmbillvalan' as TableName, count(1) as cnt from msajag.dbo.Cmbillvalan with(nolock) union  
--select 'TBL_COMBINE_REPORTING_PEAK' as TableName, count(1) as cnt from msajag.dbo.TBL_COMBINE_REPORTING_PEAK with(nolock) )source  
  
  
--select *,'ACCOUNT' AS 'DB' into #source_account from(  
--select 'acmast' as TableName, count(1) as cnt from account.dbo.acmast with(nolock) union  
--select 'ledger1' as TableName, count(1) as cnt from account.dbo.ledger1 with(nolock) union  
--select 'parameter' as TableName, count(1) as cnt from account.dbo.parameter with(nolock) union  
--select 'ledger2' as TableName, count(1) as cnt from account.dbo.ledger2 with(nolock) union  
--select 'costmast' as TableName, count(1) as cnt from account.dbo.costmast with(nolock) union  
--select 'vmast' as TableName, count(1) as cnt from account.dbo.vmast with(nolock) union  
--select 'Multibankid' as TableName, count(1) as cnt from account.dbo.Multibankid with(nolock)   
--) source_acc  
  
--insert into tbl_nsecash_replication  
--select * from #source_nsecash  
  
--insert into tbl_nsecash_replication  
--select * from #source_account  
  
  CREATE TABLE #SpaceUsed (
	 TableName sysname
	,NumRows BIGINT
	,ReservedSpace VARCHAR(50)
	,DataSpace VARCHAR(50)
	,IndexSize VARCHAR(50)
	,UnusedSpace VARCHAR(50)
	) 

DECLARE @str VARCHAR(500)
SET @str =  'exec sp_spaceused ''?'''

INSERT INTO #SpaceUsed 
EXEC sp_msforeachtable @command1=@str

SELECT replace( replace( replace(TableName,'[dbo].',''),'[',''),']','') as tablename ,NumRows into #TempUsed FROM #SpaceUsed ORDER BY TableName


update r
set r.cnt=u.NumRows
from tbl_nsecash_replication r
join #TempUsed u
on r.TableName=u.tablename
and r.DB='MSAJAG'



end

GO
