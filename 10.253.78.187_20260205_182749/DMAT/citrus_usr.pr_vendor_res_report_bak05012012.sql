-- Object: PROCEDURE citrus_usr.pr_vendor_res_report_bak05012012
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create  procedure [citrus_usr].[pr_vendor_res_report_bak05012012]  (@pa_from_no varchar(50)
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
	 INSERT INTO #ACLIST SELECT DPAM_ID,DPAM_SBA_NO,DPAM_SBA_NAME,EFF_FROM,EFF_TO FROM CITRUS_USR.FN_ACCT_LIST(@@DPMID ,@PA_LOGIN_PR_ENTM_ID,@@L_CHILD_ENTM_ID)    
	
		select VR_id as "VR ID" ,
		--VR_DPID as "DPID",
		VR_boid as "BOID",
		VR_hldnm as "FIRST HOLDER",
		VR_sechldnm as "SECOND HOLDER",
		VR_thhldnm as  "THIRD HOLDER",
		VR_reqslip_fr as  "REQ SLIP FROM",
		VR_reqslip_to as "REQ SLIP FROM",
		VR_old_bookno as "OLD BOOK NO",
		VR_courier_name AS "COURIER NAME",
		VR_pod_no as "POD NO",
		VR_disp_date AS "DISPATCH DATE",
        remarks  "REMARKS",
        "STATUS" = case when deleted_ind = 1 then 'SUCCESS'  
			            when deleted_ind = 3 then 'REJECTED' end
		from vendor_response ,#ACLIST ACCOUNT,dis_req_dtls_MAK
		where VR_boid = ACCOUNT.DPAM_SBA_NO  
        and boid = VR_boid                   
		and VR_boid between  @pa_from_no and  @pa_to_no
		and convert(datetime,VR_disp_date,103) between @pa_from_dt AND @pa_to_dt
--select VR_id as "VR ID" ,
		--VR_DPID as "DPID",
--		VR_boid as "BOID",
--		VR_hldnm as "FIRST HOLDER",
--		VR_sechldnm as "SECOND HOLDER",
--		VR_thhldnm as  "THIRD HOLDER",
--		VR_reqslip_fr as  "REQ SLIP FROM",
--		VR_reqslip_to as "REQ SLIP FROM",
--		VR_old_bookno as "OLD BOOK NO",
--		VR_courier_name AS "COURIER NAME",
--		VR_pod_no as "POD NO",
--		VR_disp_date AS "DISPATCH DATE",
--        remarks  "REMARKS",
--        "STATUS" = case when deleted_ind = 1 then 'SUCCESS'  
--			            when deleted_ind = 3 then 'REJECTED' end
--SELECT
--Boid,Boname
--		from dis_req_dtls_MAK LEFT OUTER JOIN #ACLIST ACCOUNT ON boid = ACCOUNT.DPAM_SBA_NO   LEFT OUTER JOIN vendor_response  ON  	boid = VR_boid           
--		WHERE boid between  @pa_from_no and  @pa_to_no
--		and convert(datetime,lst_upd_dt,103) between @pa_from_dt AND @pa_to_dt
	--
	end
end

GO
