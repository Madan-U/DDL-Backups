-- Object: PROCEDURE citrus_usr.Pr_Email_Shootout
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec Pr_Email_Shootout 'FREEZE','feb  1 2018','feb 19 2018','',''
CREATE procedure [citrus_usr].[Pr_Email_Shootout]
(
 @pa_type varchar(50)
,@pa_fromdt datetime
,@pa_todt datetime
,@filler1 varchar(50)
,@filler2 varchar(50)
)
as
begin
if @pa_type='FREEZE'
begin
select distinct pc4.boid,EMailId,'Account is Freezed' Subj ,FreezeRmks Bodymesg from dps8_pc4 pc4,dps8_pc1 pc1 where convert(datetime,substring(freezeactdt,1,2)+ '/' + substring(freezeactdt,3,2) + '/' + substring(freezeactdt,5,4) ,103)
between @pa_fromdt and @pa_todt
and freezestatus='A' and pc4.boid=pc1.boid and isnull(emailid,'')<>''
end

if @pa_type='UNFREEZE'
begin
select distinct pc4.boid,EMailId,'Account is UnFreezed' Subj ,FreezeRmks Bodymesg from dps8_pc4 pc4,dps8_pc1 pc1 where 
convert(datetime,substring(freezeactdt,1,2)+ '/' + substring(freezeactdt,3,2) + '/' + substring(freezeactdt,5,4) ,103)
between @pa_fromdt and @pa_todt
and freezestatus='U' and pc4.boid=pc1.boid and isnull(emailid,'')<>''
End 

if @pa_type='DISDRFREJ'
begin
select distinct cdshm_ben_acct_no,citrus_usr.fn_conc_value(dpam_crn_no,'EMAIL1'),case when CDSHM_CDAS_SUB_TRAS_TYPE='523'
then 'REJECTED BY OTHER DEPOSITORY' else '' end  from cdsl_holding_dtls
,dp_acct_mstr where CDSHM_CDAS_SUB_TRAS_TYPE='523' and dpam_id=cdshm_dpam_id and dpam_deleted_ind=1
and CDSHM_TRAS_DT between @pa_fromdt and @pa_todt
end
end

GO
