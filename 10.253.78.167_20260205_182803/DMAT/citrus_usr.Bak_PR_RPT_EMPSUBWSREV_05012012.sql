-- Object: PROCEDURE citrus_usr.Bak_PR_RPT_EMPSUBWSREV_05012012
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec PR_RPT_EMPSUBWSREV '3','BR','R','APR 01 2010','30 apr 2010',''   

create PROCEDURE [citrus_usr].[Bak_PR_RPT_EMPSUBWSREV_05012012](@PA_EXCSM_ID NUMERIC 
,@PA_ENTTM_CD VARCHAR(20)
,@PA_ACTION VARCHAR(20)
,@PA_FROM_DT DATETIME
,@PA_TO_DT DATETIME 
,@PA_OUT VARCHAR(8000) OUT)
AS
BEGIN 


SET DATEFORMAT DMY 

DECLARE @L_DPM_ID NUMERIC 

SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DPM_EXCSM_ID = @PA_EXCSM_ID AND DEFAULT_DP = DPM_EXCSM_ID AND DPM_DELETED_IND = 1 



select distinct CONVERT(VARCHAR,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd into #account_properties from account_properties 
where accp_accpm_prop_cd = 'BILL_START_DT' 

--SELECT * FROM #account_properties
declare @l_commis_br_id varchar(8000)
, @l_commis_amt_type  varchar(10)
, @l_commis_amt numeric(18,2)

IF @PA_ACTION = 'A'
BEGIN 


select @l_commis_br_id = commis_br_id, @l_commis_amt_type= commis_amt_typ , @l_commis_amt = commis_amt 
from commission_dtls where commis_type = 'A' 
and convert(datetime,convert(varchar,@PA_FROM_DT,103),103) between commis_frm_dt and commis_to_dt
and convert(datetime,convert(varchar,@PA_TO_DT,103),103) between commis_frm_dt and commis_to_dt
and commis_DELETED_IND = 1 


	IF @PA_ENTTM_CD = 'BR' and @l_commis_amt_type = 'V'
	select COUNT(distinct ENTR_SBA)*case when @l_commis_br_id = 0 and  @l_commis_amt_type = 'V' then @l_commis_amt 
                                end   REV_VALUE, ENTM_SHORT_NAME  
	from DP_ACCT_MSTR , entity_relationship , ENTITY_MSTR , #account_properties
,(select sum(clic_charge_amt*-1 ) clic_charge_amt, clic_dpam_id
from client_charges_cdsl 
where clic_charge_name like '%AMC%' 
and  CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt group by clic_dpam_id) d
	WHERE DPAM_SBA_NO = ENTR_SBA and dpam_id= clic_Dpam_id  
	AND ACCP_CLISBA_ID = DPAM_ID 
	AND ENTR_AR = ENTM_ID 
	AND ENTM_ENTTM_CD = 'BR'
	--AND ENTR_TO_DT >= 'JAN 01 2009'
	AND isnull(ENTR_TO_DT,'') =  ''
	AND DPAM_DPM_ID = @L_DPM_ID 
	and dpam_stam_cd = 'ACTIVE'
	AND ACCP_VALUE BETWEEN @PA_FROM_DT AND @PA_TO_DT
	AND ENTR_DELETED_IND = 1
	AND ENTM_DELETED_IND = 1 
	GROUP BY ENTM_SHORT_NAME


 if @PA_ENTTM_CD = 'BR' and @l_commis_amt_type = 'P'
  select case  when @l_commis_br_id = 0 and  @l_commis_amt_type = 'P' then  sum(clic_charge_amt)*@l_commis_amt/100 
           end   REV_VALUE, ENTM_SHORT_NAME  
	from DP_ACCT_MSTR , entity_relationship , ENTITY_MSTR , #account_properties
,(select sum(clic_charge_amt *-1) clic_charge_amt, clic_dpam_id
from client_charges_cdsl 
where clic_charge_name like '%AMC%' 
and  CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt group by clic_dpam_id) d
	WHERE DPAM_SBA_NO = ENTR_SBA and clic_dpam_id = dpam_id 
	AND ACCP_CLISBA_ID = DPAM_ID 
	AND ENTR_AR = ENTM_ID and clic_charge_amt <> 0
	AND ENTM_ENTTM_CD = 'BR'
	--AND ENTR_TO_DT >= 'JAN 01 2009'
	AND isnull(ENTR_TO_DT,'') =  ''
	AND DPAM_DPM_ID = @L_DPM_ID 
	and dpam_stam_cd = 'ACTIVE'
	AND ACCP_VALUE BETWEEN @PA_FROM_DT AND @PA_TO_DT
	AND ENTR_DELETED_IND = 1
	AND ENTM_DELETED_IND = 1 
	GROUP BY ENTM_SHORT_NAME
	

	
END
else IF @PA_ACTION = 'R'
BEGIN 


select @l_commis_br_id = commis_br_id, @l_commis_amt_type= commis_amt_typ , @l_commis_amt = commis_amt 
from commission_dtls where commis_type = 'R' 
and convert(datetime,convert(varchar,@PA_FROM_DT,103),103) between commis_frm_dt and commis_to_dt
and convert(datetime,convert(varchar,@PA_TO_DT,103),103) between commis_frm_dt and commis_to_dt
and commis_DELETED_IND = 1 


	IF @PA_ENTTM_CD = 'BR' and @l_commis_amt_type = 'V'
	select COUNT(distinct ENTR_SBA)*
           case when @l_commis_br_id = 0 and  @l_commis_amt_type = 'V' then @l_commis_amt 
               end   REV_VALUE, ENTM_SHORT_NAME  
	from DP_ACCT_MSTR , entity_relationship , ENTITY_MSTR , #account_properties
,(select sum(clic_charge_amt*-1) clic_charge_amt, clic_dpam_id 
from client_charges_cdsl 
where clic_charge_name like '%AMC%' 
and  CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt group by clic_dpam_id) a
	WHERE DPAM_SBA_NO = ENTR_SBA  and dpam_id = clic_dpam_id 
	AND ACCP_CLISBA_ID = DPAM_ID 
	AND ENTR_AR = ENTM_ID 
	AND ENTM_ENTTM_CD = 'BR'
	--AND ENTR_TO_DT >= 'JAN 01 2009'
	AND isnull(ENTR_TO_DT,'') =  ''
	AND DPAM_DPM_ID = @L_DPM_ID 
	and dpam_stam_cd = 'ACTIVE'
	AND month(ACCP_VALUE) BETWEEN month(@PA_FROM_DT) AND month(@PA_TO_DT)
	AND day(ACCP_VALUE) BETWEEN day(@PA_FROM_DT) AND day(@PA_TO_DT)
	AND year(ACCP_VALUE) not between  year(@PA_FROM_DT) AND year(@PA_TO_DT)
	AND ENTR_DELETED_IND = 1
	AND ENTM_DELETED_IND = 1 
	GROUP BY ENTM_SHORT_NAME



if @PA_ENTTM_CD = 'BR' and @l_commis_amt_type = 'P'
	select case  when @l_commis_br_id = 0 and  @l_commis_amt_type = 'P' then  (sum(a.clic_charge_amt)*@l_commis_amt/100) 
           end   REV_VALUE, ENTM_SHORT_NAME  
	from DP_ACCT_MSTR , entity_relationship , ENTITY_MSTR , #account_properties
,(select sum(clic_charge_amt*-1) clic_charge_amt, clic_dpam_id 
from client_charges_cdsl 
where clic_charge_name like '%AMC%' 
and  CLIC_TRANS_DT between @pa_from_dt and @pa_to_dt group by clic_dpam_id) a
	WHERE DPAM_SBA_NO = ENTR_SBA and clic_dpam_id = dpam_id 
	AND ACCP_CLISBA_ID = DPAM_ID 
	AND ENTR_AR = ENTM_ID 
	AND ENTM_ENTTM_CD = 'BR'
	--AND ENTR_TO_DT >= 'JAN 01 2009'
	AND isnull(ENTR_TO_DT,'') =  ''
	AND DPAM_DPM_ID = @L_DPM_ID  and clic_charge_amt <> 0
	and dpam_stam_cd = 'ACTIVE'
	AND month(ACCP_VALUE) BETWEEN month(@PA_FROM_DT) AND month(@PA_TO_DT)
	AND day(ACCP_VALUE) BETWEEN day(@PA_FROM_DT) AND day(@PA_TO_DT)
	AND year(ACCP_VALUE) not between  year(@PA_FROM_DT) AND year(@PA_TO_DT)
	AND ENTR_DELETED_IND = 1
	AND ENTM_DELETED_IND = 1 
	GROUP BY ENTM_SHORT_NAME


	
END
ELSE
BEGIN
	select @l_commis_br_id = commis_br_id, @l_commis_amt_type= commis_amt_typ , @l_commis_amt = commis_amt 
    from commission_dtls where commis_type = 'T' 
and convert(datetime,convert(varchar,@PA_FROM_DT,103),103) between commis_frm_dt and commis_to_dt
and convert(datetime,convert(varchar,@PA_TO_DT,103),103) between commis_frm_dt and commis_to_dt
    and commis_DELETED_IND = 1 


	IF @PA_ENTTM_CD = 'BR' and @l_commis_br_id <> 0
	select abs(case when @l_commis_br_id = 0 and  @l_commis_amt_type = 'V' then @l_commis_amt 
                                when @l_commis_br_id = 0 and  @l_commis_amt_type = 'P' then  sum(clic_charge_amt*-1)*(@l_commis_amt/100)  end ) REV_VALUE, ENTM_SHORT_NAME  
	from DP_ACCT_MSTR , entity_relationship , ENTITY_MSTR , client_charges_cdsl
	WHERE DPAM_SBA_NO = ENTR_SBA 
	AND clic_dpam_ID = DPAM_ID 
	AND ENTR_AR = ENTM_ID 
	AND ENTM_ENTTM_CD = 'BR'
	--AND ENTR_TO_DT >= 'JAN 01 2009'
	AND isnull(ENTR_TO_DT,'') =  ''
	AND DPAM_DPM_ID = @L_DPM_ID 
	and dpam_stam_cd = 'ACTIVE' and clic_charge_name = 'TRANSACTION CHARGES'
    AND CLIC_TRANS_DT BETWEEN @PA_FROM_DT AND @PA_TO_DT
	AND ENTR_DELETED_IND = 1
	AND ENTM_DELETED_IND = 1 
	GROUP BY ENTM_SHORT_NAME
END





END

GO
