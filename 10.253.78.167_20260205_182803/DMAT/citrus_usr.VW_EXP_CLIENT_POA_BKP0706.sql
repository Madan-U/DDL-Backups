-- Object: VIEW citrus_usr.VW_EXP_CLIENT_POA_BKP0706
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------





CREATE view VW_EXP_CLIENT_POA_BKP0706
as
select dpam_acct_no RECEIPT_CODE
,null       BENEF_ACCNO
,SetupDate        SLIP_DATE
,pc1.boid         CLIENT_CODE
,'05' PURPOSE_CODE
,[POARegNum]            POA_ID
,SetupDate SETUP_DATE
,'Y' OPERATE_AC
,[GPABPAFlg]            GPA_BPA_FLAG
,[EffFormDate]    FROM_DATE
,[EffToDate]      TO_DATE
,'' REMARKS
,'E'        STAGE
,'A'        STATUS
,''             TRXN_TYPE
from dp_Acct_mstr , dps8_pc1  pc1 
left outer join 
dps8_pc5 pc5 on pc1.boid = pc5.boid
,client_list_modified 
where pc1.boid = dpam_sba_no 
and clic_mod_action = 'POA ACTIVATION' 
and clic_mod_dpam_sba_no= dpam_sba_no and  convert(varchar(11),clic_mod_created_dt ,109) = convert(varchar(11),getdate(),109)

GO
