-- Object: FUNCTION citrus_usr.to_get_freezestat
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



CREATE function [citrus_usr].[to_get_freezestat](@pa_sba_no varchar(50))
RETURNS varchar(8000) 
begin 
DECLARE @l_rate varchar(100)
select @l_rate='FREEZE (Reason Code):' +
CASE WHEN isnull(FreezeResCd,'')=1 THEN 'BENEFICIAL OWNER'
WHEN  isnull(FreezeResCd,'')=2 THEN 'ITO ATTACHMENT'
WHEN isnull(FreezeResCd,'')=3 THEN 'SEBI DIRECTIVE'

WHEN isnull(FreezeResCd,'')=4 THEN 'DISINVESTMENTS &  PRIVATE DEALS'
WHEN isnull(FreezeResCd,'')=5 THEN  'COURT ORDER'

WHEN isnull(FreezeResCd,'')=6 THEN 'VALID PAN NOT RECORDED'
WHEN isnull(FreezeResCd,'')=7  THEN 'SOLE/FIRST HOLDER DECEASED'
WHEN isnull(FreezeResCd,'')=8 THEN 'SECOND HOLDER DECEASED'
WHEN  isnull(FreezeResCd,'')=9 THEN'THIRD HOLDER DECEASED'
WHEN  isnull(FreezeResCd,'')=98 THEN  'PAN NOT RECORDED'

WHEN  isnull(FreezeResCd,'')='17'THEN'REQUESTED BY BO'
WHEN  isnull(FreezeResCd,'')='18'THEN'CORPORATE ACTIN FREEZE'
WHEN  isnull(FreezeResCd,'')='19'THEN'FATCA NONCOMPLIANT (UNDER ITRULE 114H(B))'
WHEN  isnull(FreezeResCd,'')='20'THEN'KYC DEFICIENCY REPORTED BY CDSL'
WHEN  isnull(FreezeResCd,'')='21'THEN'KYC PENDING'
WHEN  isnull(FreezeResCd,'')='22'THEN'KYC VERIFICATION NON COMPLIANT ACCOUNT'
WHEN  isnull(FreezeResCd,'')='94'THEN'NDU FREEZE SETUP'
WHEN  isnull(FreezeResCd,'')='14'THEN'ASSIGNMENT'
WHEN  isnull(FreezeResCd,'')='16'THEN'INITIATED BY BO'
WHEN  isnull(FreezeResCd,'')='10'THEN'ORDER FROM SECIAL RECOVERY OFFICER'
WHEN  isnull(FreezeResCd,'')='11'THEN'ORDER FROM CBI/POLICE'
WHEN  isnull(FreezeResCd,'')='12'THEN'FIU-IND REQUIREMENT'
WHEN  isnull(FreezeResCd,'')='13'THEN'IPV PENDING'
WHEN  isnull(FreezeResCd,'')='94'THEN'NDU FREEZE SETUP'
WHEN  isnull(FreezeResCd,'')='95'THEN'RGESS FREEZE'
WHEN  isnull(FreezeResCd,'')='96'THEN'RESTRAINED PAN'
WHEN  isnull(FreezeResCd,'')='97'THEN'MINOR ATTAINED MAJORITY'
WHEN  isnull(FreezeResCd,'')='98'THEN'PAN NOT RECORDED'
+ isnull(FreezeRmks  ,'')
 ELSE '' END from dps8_pc4  where boid = @pa_sba_no
and TypeOfTrans <> '3'

return @l_rate
end

GO
