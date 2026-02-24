-- Object: FUNCTION citrus_usr.ToGet_GSTFINCode
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


create function ToGet_GSTFINCode(@pa_entm_id numeric)
 returns varchar(100)
 as
begin 
declare @@l_entm_id varchar(200)
Select @@l_entm_id=entm_id + '_' + entm_short_name  +'_BL_'  from entity_mstr where entm_enttm_cd='Bl'
and entm_deleted_ind=1
and entm_id=@pa_entm_id
return @@l_entm_id
end

GO
