-- Object: FUNCTION citrus_usr.fn_find_relations_Acctlvl
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_find_relations_Acctlvl](@pa_dpam_id     numeric  
                                 ,@pa_enttm_cd      varchar(25))  
RETURNS varchar (8000)  
AS  
BEGIN  
--  
/*family  
sub_broker  
trader  
region  
area*/  
  
  DECLARE @l_short_name VARCHAR(30)  
    
  SELECT @l_short_name  = entm_short_name  
  FROM   entity_mstr  
        ,entity_relationship  
,dp_acct_mstr  
  WHERE (entm_id = entr_ho   
         OR entm_id = entr_re   
         OR entm_id = entr_ar  
         OR entm_id = entr_br  
         OR entm_id = entr_sb  
         OR entm_id = entr_dl  
         OR entm_id = entr_rm  
         OR entm_id = entr_dummy1  
         OR entm_id = entr_dummy2  
         OR entm_id = entr_dummy3  
         OR entm_id = entr_dummy4  
         OR entm_id = entr_dummy5  
         OR entm_id = entr_dummy6  
         OR entm_id = entr_dummy7  
         OR entm_id = entr_dummy8  
         OR entm_id = entr_dummy9  
         OR entm_id = entr_dummy10)  
AND  
DPAM_SBA_NO=ENTR_SBA  
  AND DPAM_ID     = @pa_dpam_id  
  AND entm_enttm_cd = @pa_enttm_cd  
    
  RETURN @l_short_name  
  
--  
END

GO
