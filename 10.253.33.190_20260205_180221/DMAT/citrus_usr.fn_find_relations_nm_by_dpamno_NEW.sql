-- Object: FUNCTION citrus_usr.fn_find_relations_nm_by_dpamno_NEW
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_find_relations_nm_by_dpamno_NEW](@pa_dpam_sbano     numeric  
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
  
  DECLARE @l_name VARCHAR(30)  
    
  SELECT @l_name  = entm_name1  
	FROM (
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_ho
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_re
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_ar
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_br  
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_sb  
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_dl  
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_dl  
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_rm
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_dummy1
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_dummy2
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_dummy3
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_dummy4
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_dummy5
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_dummy6
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_dummy7
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_dummy8
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_dummy9
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
	UNION ALL
	SELECT ENTM_NAME1
		FROM   entity_mstr  
	    ,entity_relationship  
		WHERE entm_id = entr_dummy10
		and isnumeric(entr_sba) = 1 
		AND entr_sba   = @pa_dpam_sbano
		AND entm_enttm_cd = @pa_enttm_cd 
) A
  
  RETURN @l_name  
  
--  
END

GO
