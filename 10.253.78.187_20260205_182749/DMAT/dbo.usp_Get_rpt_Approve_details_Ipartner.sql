-- Object: PROCEDURE dbo.usp_Get_rpt_Approve_details_Ipartner
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec [citrus_usr].rpt_Approve_details @pa_id='3',@pa_tab='ALL_RECORD_TYPE',@pa_type='CDSL',@pa_from_dt='',@pa_to_dt='23:55:55',@pa_trastm_cd='DMAT',@pa_login_pr_entm_id=1,@pa_login_entm_cd_chain='HO|*~|',@pa_slip_no='1262417',@pa_clientid='',@pa_drnno=''
--go

--Select Nise_party_code, client_code from TBL_CLIENT_MASTER where client_code='1203320019713373'

CREATE Procedure [dbo].[usp_Get_rpt_Approve_details_Ipartner]
(
@sub_broker varchar(100),
@pa_slip_no varchar(100)='1262417'
)
as
begin 
--EXEC usp_Get_rpt_Approve_details_Ipartner 'MMRW','1262417'


select * into #sb_client_details from dbo.sb_client_details with(nolock)
where sub_broker =@sub_broker 

Create Table #rpt_Approve_details
(
inst_id	varchar(200)
,REQUESTDATE 	varchar(200)	
,EXECUTIONDATE		varchar(200)
,trans_descp		varchar(200)
,SLIPNO		varchar(200)
,ACCOUNTNO		varchar(200)
,ACCOUNTNAME		varchar(200)
,QUANTITY	numeric(12,4)
,[DUAL CHECKER]	 	varchar(200)
,mkr		varchar(200)
,mkr_dt		varchar(200)
,ORDBY	INT
,ISIN_NAME		varchar(200)
,ISIN		varchar(200)
,dptdc_request_dt	Datetime
,Amt_charged	Numeric(12,2)
,outstand_amt	Numeric(12,2)
,mkt_type		varchar(200)
,other_mkt_type		varchar(200)
,settlementno		varchar(200)
,othersettmno		varchar(200)
,cmbp		varchar(200)
,counter_account		varchar(200)
,counter_dpid		varchar(200)
,Status1		varchar(200)
,auth_rmks		varchar(200)
,checker1		varchar(200)
,checker1_dt		varchar(200)
,checker2		varchar(200)
,checker2_dt		varchar(200)
,slip_reco		varchar(200)
,image_scan		varchar(200)
,scan_dt		varchar(200)
,dptdc_rmks		varchar(200)
,backoffice_code		varchar(200)
,reason		varchar(200)
,recon_datetime		varchar(200)
,batchno		varchar(200)
,recon_datetime1		varchar(200)
,batchno1		varchar(200)
,RejectionDate		varchar(200)
,courier		varchar(200)
,podno		varchar(200)
,dispdate		varchar(200)
,Rate		varchar(200)
,Valuation	varchar(200)
)



insert into #rpt_Approve_details
exec [citrus_usr].rpt_Approve_details @pa_id='3',@pa_tab='ALL_RECORD_TYPE',@pa_type='CDSL',@pa_from_dt='',@pa_to_dt='23:55:55',@pa_trastm_cd='DMAT',@pa_login_pr_entm_id=1,@pa_login_entm_cd_chain='HO|*~|',@pa_slip_no=@pa_slip_no,@pa_clientid='',@pa_drnno=''



select Nise_party_code,sub_broker,* from #rpt_Approve_details A with (nolock) 
inner join TBL_CLIENT_MASTER B with (nolock) on A.ACCOUNTNO=B.client_code 
inner join #sb_client_details SB with (nolock)  On Sb.party_code=B.Nise_party_code
where sub_broker =@sub_broker 

drop Table #rpt_Approve_details
drop table #sb_client_details 
END

GO
