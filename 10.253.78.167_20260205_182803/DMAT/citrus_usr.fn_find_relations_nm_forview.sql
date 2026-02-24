-- Object: FUNCTION citrus_usr.fn_find_relations_nm_forview
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create function [citrus_usr].[fn_find_relations_nm_forview](@pa_sba_no     varchar(100)
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
  
  SELECT @l_name  = entm_name1 + ' ' + isnull(entm_name2,'') + ' '  + isnull(entm_name3,'') 
  FROM   entity_mstr
        ,entity_relationship
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
  AND entr_sba   = @pa_sba_no
  AND entm_enttm_cd = @pa_enttm_cd 

  
  RETURN @l_name

--
END

GO
