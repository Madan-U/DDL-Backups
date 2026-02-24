-- Object: PROCEDURE citrus_usr.pr_get_subctgry_count_yrwise
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec pr_get_subctgry_count_yrwise 3
CREATE proc pr_get_subctgry_count_yrwise(@pa_dpm_id numeric)
as
begin 

select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
into #account_properties from account_properties O
where accp_accpm_prop_cd = 'BILL_START_DT' 
and accp_value not in ('','//')




select distinct convert(datetime,accp_value,103) accp_value_cl
, accp_clisba_id accp_clisba_id_cl , accp_accpm_prop_cd accp_accpm_prop_cd_cl 
into #account_properties_close from account_properties 
where accp_accpm_prop_cd = 'ACC_CLOSE_DT' 
and accp_value not in ('','//') 


SELECT SUBCM_DESC,COUNT(1) NOOFACCOUNT,SUM(CASE WHEN DPAM_STAM_CD ='ACTIVE' THEN 1 ELSE 0 END ) ASONACTIVE 
,SUM(CASE WHEN accp_value between 'apr 01 2002' and 'mar 31 2003' then 1 ELSE 0 END ) [open during 2005-2006]
,SUM(CASE WHEN isnull(accp_value_cl,'') between 'apr 01 2002' and 'mar 31 2003' then 1 ELSE 0 END ) [close during 2005-2006]
,SUM(CASE WHEN isnull(accp_value_cl,'') not  between 'apr 01 2002' and 'mar 31 2003' and accp_value between 'apr 01 2002' and 'mar 31 2003'  then 1 ELSE 0 END ) [active during 2005-2006]

,SUM(CASE WHEN accp_value between 'apr 01 2003' and 'mar 31 2004' then 1 ELSE 0 END ) [open during 2005-2006]
,SUM(CASE WHEN isnull(accp_value_cl,'') between 'apr 01 2003' and 'mar 31 2004' then 1 ELSE 0 END ) [close during 2005-2006]
,SUM(CASE WHEN isnull(accp_value_cl,'') not  between 'apr 01 2002' and 'mar 31 2004' and accp_value between 'apr 01 2002' and 'mar 31 2004'  then 1 ELSE 0 END ) [active during 2005-2006]

,SUM(CASE WHEN accp_value between 'apr 01 2004' and 'mar 31 2005' then 1 ELSE 0 END ) [open during 2005-2006]
,SUM(CASE WHEN isnull(accp_value_cl,'') between 'apr 01 2004' and 'mar 31 2005' then 1 ELSE 0 END ) [close during 2005-2006]
,SUM(CASE WHEN isnull(accp_value_cl,'') not  between 'apr 01 2002' and 'mar 31 2005' and accp_value between 'apr 01 2002' and 'mar 31 2005'  then 1 ELSE 0 END ) [active during 2005-2006]


,SUM(CASE WHEN accp_value between 'apr 01 2005' and 'mar 31 2006' then 1 ELSE 0 END ) [open during 2005-2006]
,SUM(CASE WHEN isnull(accp_value_cl,'') between 'apr 01 2005' and 'mar 31 2006' then 1 ELSE 0 END ) [close during 2005-2006]
,SUM(CASE WHEN isnull(accp_value_cl,'') not  between 'apr 01 2002' and 'mar 31 2006' and accp_value between 'apr 01 2002' and 'mar 31 2006'  then 1 ELSE 0 END ) [active during 2005-2006]


,SUM(CASE WHEN accp_value between 'apr 01 2006' and 'mar 31 2007' then 1 ELSE 0 END ) [open during 2006-2007]
,SUM(CASE WHEN isnull(accp_value_cl,'') between 'apr 01 2006' and 'mar 31 2007' then 1 ELSE 0 END ) [close during 2006-2007]
,SUM(CASE WHEN isnull(accp_value_cl,'') not  between 'apr 01 2002' and 'mar 31 2007' and accp_value between 'apr 01 2002' and 'mar 31 2007' then 1 ELSE 0 END ) [active during 2006-2007]


,SUM(CASE WHEN accp_value between 'apr 01 2007' and 'mar 31 2008' then 1 ELSE 0 END ) [open during 2007-2008]
,SUM(CASE WHEN isnull(accp_value_cl,'') between 'apr 01 2007' and 'mar 31 2008' then 1 ELSE 0 END ) [close during 2007-2008]
,SUM(CASE WHEN isnull(accp_value_cl,'') not  between 'apr 01 2002' and 'mar 31 2008' and accp_value between 'apr 01 2002' and 'mar 31 2008' then 1 ELSE 0 END ) [active during 2007-2008]


,SUM(CASE WHEN accp_value between 'apr 01 2008' and 'mar 31 2009' then 1 ELSE 0 END ) [open during 2008-2009]
,SUM(CASE WHEN isnull(accp_value_cl,'') between 'apr 01 2008' and 'mar 31 2009' then 1 ELSE 0 END ) [close during 2008-2009]
,SUM(CASE WHEN isnull(accp_value_cl,'') not  between 'apr 01 2002' and 'mar 31 2009' and accp_value between 'apr 01 2002' and 'mar 31 2009' then 1 ELSE 0 END ) [active during 2008-2009]


,SUM(CASE WHEN accp_value between 'apr 01 2009' and 'mar 31 2010' then 1 ELSE 0 END ) [open during 2009-2010]
,SUM(CASE WHEN isnull(accp_value_cl,'') between 'apr 01 2009' and 'mar 31 2010' then 1 ELSE 0 END ) [close during 2009-2010]
,SUM(CASE WHEN isnull(accp_value_cl,'') not  between 'apr 01 2002' and 'mar 31 2010' and accp_value between 'apr 01 2002' and 'mar 31 2010'  then 1 ELSE 0 END ) [active during 2009-2010]


,SUM(CASE WHEN accp_value between 'apr 01 2010' and 'mar 31 2011' then 1 ELSE 0 END ) [open during 2010-2011]
,SUM(CASE WHEN isnull(accp_value_cl,'') between 'apr 01 2010' and 'mar 31 2011' then 1 ELSE 0 END ) [close during 2010-2011]
,SUM(CASE WHEN isnull(accp_value_cl,'') not  between 'apr 01 2002' and 'mar 31 2011' and accp_value between 'apr 01 2002' and 'mar 31 2011' then 1 ELSE 0 END ) [active during 2010-2011]


,SUM(CASE WHEN accp_value between 'apr 01 2011' and 'mar 31 2012' then 1 ELSE 0 END ) [open during 2011-2012]
,SUM(CASE WHEN isnull(accp_value_cl,'') between 'apr 01 2011' and 'mar 31 2012' then 1 ELSE 0 END ) [close during 2011-2012]
,SUM(CASE WHEN isnull(accp_value_cl,'') not  between 'apr 01 2002' and 'mar 31 2012' and accp_value between 'apr 01 2002' and 'mar 31 2012' then 1 ELSE 0 END ) [active during 2011-2012]


,SUM(CASE WHEN accp_value between 'apr 01 2012' and 'mar 31 2013' then 1 ELSE 0 END ) [open during 2012-2013]
,SUM(CASE WHEN isnull(accp_value_cl,'') between 'apr 01 2012' and 'mar 31 2013' then 1 ELSE 0 END ) [close during 2012-2013]
,SUM(CASE WHEN isnull(accp_value_cl,'') not  between 'apr 01 2002' and 'mar 31 2013' and accp_value between 'apr 01 2002' and 'mar 31 2013' then 1 ELSE 0 END ) [active during 2012-2013]


,SUM(CASE WHEN accp_value between 'apr 01 2013' and 'mar 31 2014' then 1 ELSE 0 END ) [open during 2013-2014]
,SUM(CASE WHEN isnull(accp_value_cl,'') between 'apr 01 2013' and 'mar 31 2014' then 1 ELSE 0 END ) [close during 2013-2014]
,SUM(CASE WHEN isnull(accp_value_cl,'') not  between 'apr 01 2002' and 'mar 31 2014' and accp_value between 'apr 01 2002' and 'mar 31 2014' then 1 ELSE 0 END ) [active during 2013-2014]


,SUM(CASE WHEN accp_value between 'apr 01 2014' and 'mar 31 2015' then 1 ELSE 0 END ) [open during 2014-2015]
,SUM(CASE WHEN isnull(accp_value_cl,'') between 'apr 01 2014' and 'mar 31 2015' then 1 ELSE 0 END ) [close during 2014-2015]
,SUM(CASE WHEN isnull(accp_value_cl,'') not  between 'apr 01 2002' and 'mar 31 2015' and accp_value between 'apr 01 2002' and 'mar 31 2015' then 1 ELSE 0 END ) [active during 2014-2015]


,SUM(CASE WHEN accp_value between 'apr 01 2015' and 'mar 31 2016' then 1 ELSE 0 END ) [open during 2015-2016]
,SUM(CASE WHEN isnull(accp_value_cl,'') between 'apr 01 2015' and 'mar 31 2016' then 1 ELSE 0 END ) [close during 2015-2016]
,SUM(CASE WHEN isnull(accp_value_cl,'') not  between 'apr 01 2002' and 'mar 31 2016' and accp_value between 'apr 01 2002' and 'mar 31 2016' then 1 ELSE 0 END ) [active during 2015-2016]

FROM citrus_usr.DP_ACCT_MSTR WITH(NOLOCK)
left outer join #account_properties on ACCP_CLISBA_ID = dpam_id 
left outer join #account_properties_close on accp_clisba_id_cl = dpam_id 
,citrus_usr.SUB_CTGRY_MSTR WITH(NOLOCK)
WHERE DPAM_SUBCM_CD = SUBCM_CD
AND DPAM_DELETED_IND = 1  and DPAM_DPM_ID = @pa_dpm_id
AND SUBCM_DELETED_IND = 1
GROUP BY SUBCM_DESC

end

GO
