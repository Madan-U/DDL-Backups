-- Object: PROCEDURE citrus_usr.usp_get_dis_requests_new
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[usp_get_dis_requests_new]  
  
as begin  
  
declare @sql as varchar(max)='exec dmat.citrus_usr.rpt_Approve_details @pa_id=''3'',@pa_tab=''ALL_RECORD_TYPE'',@pa_type=''CDSL'',@pa_from_dt='''+ convert(varchar(25), CONVERT(DATE, GETDATE())) +''',@pa_to_dt='''+convert(varchar(25), CONVERT(DATE, GETDATE()+1))  +''',@pa_trastm_cd='''',@pa_login_pr_entm_id=1,@pa_login_entm_cd_chain=''HO|*~|'',@pa_slip_no='''',@pa_clientid='''',@pa_drnno='''''  
  
  
  
declare @disRequest as  TABLE(  
 [inst_id] [varchar](200) NOT NULL,  
 [REQUESTDATE] [varchar](200) NOT NULL,  
 [EXECUTIONDATE] [varchar](200) NOT NULL,  
 [trans_descp] [varchar](200) NOT NULL,  
 [SLIPNO] [varchar](200) NOT NULL,  
 [ACCOUNTNO] [varchar](200) NOT NULL,  
 [ACCOUNTNAME] [varchar](200) NOT NULL,  
 [QUANTITY] [varchar](200) NOT NULL,  
 [DUAL_CHECKER] [varchar](200) NULL,  
 [mkr] [varchar](200) NOT NULL,  
 [mkr_dt] [varchar](200) NOT NULL,  
 [ORDBY] [varchar](200) NOT NULL,  
 [ISIN_NAME] [varchar](200) NOT NULL,  
 [ISIN] [varchar](200) NOT NULL,  
 [dptdc_request_dt] [varchar](200) NOT NULL,  
 [Amt_charged] [varchar](200) NOT NULL,  
 [outstand_amt] [float] NOT NULL,  
 [mkt_type] [varchar](200) NULL,  
 [other_mkt_type] [varchar](200) NULL,  
 [settlementno] [varchar](200) NULL,  
 [othersettmno] [varchar](200) NULL,  
 [cmbp] [varchar](200) NULL,  
 [counter_account] [varchar](200) NULL,  
 [counter_dpid] [varchar](200) NULL,  
 [Status1] [varchar](200) NOT NULL,  
 [auth_rmks] [varchar](200) NULL,  
 [checker1] [varchar](200) NOT NULL,  
 [checker1_dt] [varchar](200) NOT NULL,  
 [checker2] [varchar](200) NULL,  
 [checker2_dt] [varchar](200) NULL,  
 [slip_reco] [varchar](200) NULL,  
 [image_scan] [varchar](200) NULL,  
 [scan_dt] [varchar](200) NULL,  
 [dptdc_rmks] [varchar](200) NULL,  
 [backoffice_code] [varchar](200) NULL,  
 [reason] [varchar](200) NULL,  
 [recon_datetime] [varchar](200) NULL,  
 [batchno] [varchar](200) NULL,  
 [RejectionDate] [varchar](200) NULL,  
 [courier] [varchar](200) NULL,  
 [podno] [varchar](200) NULL,  
 [dispdate] [varchar](200) NULL,  
 [Rate] [varchar](200) NULL,  
 [Valuation] [varchar](200) NOT NULL  
)   
  
declare @bo_dp as table(party_code varchar(100),acc varchar(200))  
declare @Tbl_rms_collection_cli as table(party_code varchar(100),acc varchar(200),Net_Available  decimal(18,5))  
  
insert into @disRequest  
exec( @sql)  
  
  
  
  
  
insert into @bo_dp  
select party_code,cltdpid from [CSOKYC-6].general.dbo.bo_dppoa   
where cltdpid in (select accountno from @disRequest)  
  
  
insert into @Tbl_rms_collection_cli(party_code,acc,Net_Available)  
select c.Party_Code,d.acc,c.Net_Available from [CSOKYC-6].general.dbo.Tbl_rms_collection_cli c  
join @bo_dp d  
on d.party_code=c.Party_Code  
--where Party_code in (select party_code from @bo_dp)  
  
delete from tbl_DIS_Request_Status   
where   CONVERT(DATE, entryon)  = CONVERT(DATE, GETDATE())    
  
  
insert into tbl_DIS_Request_Status  
select distinct r.*,isnull(c.Net_Available,0.00),case when (isnull(c.Net_Available,0.00)>-1.00) then 'Release' else 'Hold' end as 'Status',getdate() as entryon   from @disRequest r left join   
@Tbl_rms_collection_cli c  
on r.ACCOUNTNO=c.acc 



exec usp_authorized_dis
  
end  
--select * from @disRequest

GO
