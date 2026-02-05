-- Object: VIEW citrus_usr.VW_NEWKYC_ACC_OPEN
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------





CREATE view [citrus_usr].[VW_NEWKYC_ACC_OPEN]
as
select pangir CB_PANNO 
, dpam_bbo_code  CM_BLSAVINGCD
, dpam_sba_no CLTDPID 
, CLIM_DOB CM_DATEOFBIRTH
, dpam_sba_name CM_NAME
--,case when exists(select 1 from dps8_pc16 where boid = dpam_sba_no and TypeOfTrans in ('2','1',''))  then 'Y' else 'N' end SMSFLAG
,ISNULL (smart_flag,'') SMSFLAG
,case when exists(select 1 from dps8_pc6 where boid = dpam_sba_no and TypeOfTrans in ('2','1',''))  then 'Y' else 'N' end nom_flg
,case when exists(select 1 from dps8_pc12 where boid = dpam_sba_no and TypeOfTrans in ('2','1',''))  then 'Y' else 'N' end Perm_add
,dpam_stam_cd 
from  dps8_pc1 WITH (NOLOCK)      
, dp_Acct_mstr WITH (NOLOCK)       
, client_mstr WITH (NOLOCK)       
where boid = dpam_sba_no
and dpam_crn_no = clim_crn_no

GO
