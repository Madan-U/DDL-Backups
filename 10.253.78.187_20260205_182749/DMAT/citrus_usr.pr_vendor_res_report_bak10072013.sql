-- Object: PROCEDURE citrus_usr.pr_vendor_res_report_bak10072013
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create  procedure [citrus_usr].[pr_vendor_res_report_bak10072013]  (@pa_from_no varchar(50)
,@pa_to_no  varchar(50)
,@pa_from_dt datetime
,@pa_to_dt datetime
,@PA_LOGIN_PR_ENTM_ID NUMERIC
,@PA_LOGIN_ENTM_CD_CHAIN  VARCHAR(8000)
,@PA_EXCSMID int
,@PA_OUTPUT VARCHAR(8000) OUTPUT   
)  
as  
begin  
--exec pr_venor_res_report '','','',''
if @pa_from_no = '' and @pa_to_no = ''   
begin  
set @pa_from_no = '0'  
set @pa_to_no = '999999999999999'  
end   

if @pa_from_dt = '' and @pa_to_dt = ''   
begin  
set @pa_from_dt = '01/01/1900'
set @pa_to_dt = '12/31/2099'  
end   

DECLARE @@DPMID INT                          
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

if @pa_from_no <> '' and @pa_to_no = ''   
set @pa_to_no = @pa_from_no   

if @pa_from_dt <> '' and @pa_to_dt = ''   
set @pa_to_dt = @pa_from_dt   

	begin 
	--
--print @@DPMID
--print @PA_LOGIN_PR_ENTM_ID
--print @@L_CHILD_ENTM_ID
--3
--616621
--0
	 INSERT INTO #ACLIST SELECT DPAM_ID,DPAM_SBA_NO,DPAM_SBA_NAME,EFF_FROM,EFF_TO FROM CITRUS_USR.FN_ACCT_LIST(@@DPMID ,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID)    

		select  distinct --id as "VR ID" ,
		--VR_DPID as "DPID",
		d1.Boid as "BOID",
		d1.Boname as "FIRST HOLDER",
		isnull(d1.sholder,'') as "SECOND HOLDER",
		isnull(d1.tholder,'') as  "THIRD HOLDER",
		isnull(VR_reqslip_fr,'') as  "ISSUED SLIP FROM",
		isnull(VR_reqslip_to,'') as "ISSUED SLIP TO",
		isnull(VR_old_bookno,'') as "NEW BOOK NO",
		isnull(VR_courier_name,'') AS "COURIER NAME",
		isnull(VR_pod_no,'') as "POD NO",
		isnull(VR_disp_date,'') AS "DISPATCH DATE",
        case when d1.deleted_ind = 1 then isnull(d1.remarks,'') else isnull(d1.remarks,'') + isnull(d1.chk_remarks,'') end  "REMARKS",
        "STATUS" = case when d1.deleted_ind = 1 then 'SUCCESS'  
		            when d1.deleted_ind = 3 then 'REJECTED' end 
		, case when convert(varchar(11),isnull(d.reco_datetime,''),103) = '01/01/1900' then '' else convert(varchar(19),d.reco_datetime,120) end AS "RECO DTTIME"
		--,convert(varchar(11),isnull(d.reco_datetime,''),103),isnull(reco_yn,'')
		from #ACLIST ACCOUNT,dis_req_dtls_MAK d1 left outer join vendor_response on boid = VR_boid left outer join dis_req_dtls d
		on d.req_slip_no = d1.req_slip_no
		and d.boid = d1.boid
		where d1.created_dt between convert(datetime,@pa_from_dt,109)  AND convert(datetime,@pa_to_dt+ ' 23:59:59' ,109) 
		and d1.boid = ACCOUNT.DPAM_SBA_NO  
--        and d.req_slip_no = d1.req_slip_no
--		and d.boid = d1.boid
		and d.req_date = d1.req_date
        and dpam_sba_no between  @pa_from_no and  @pa_to_no
		
		and d1.slip_yn in ('S','L')

	--
	end
end

GO
