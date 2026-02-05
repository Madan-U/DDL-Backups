-- Object: PROCEDURE citrus_usr.BRANCH_LOGIN_EXCEEDS
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[BRANCH_LOGIN_EXCEEDS](@PA_ENTTM_cd Varchar(25), @PA_OUT VARCHAR(20) OUT)   
AS  
BEGIN  
--  
 -- DECLARE @PA_ENTTM_CD VARCHAR(25)

 -- SELECT @PA_ENTTM_CD = ENTTM_CD FROM ENTITY_TYPE_MSTR WHERE ENTTM_ID = @PA_ENTTM_ID AND ENTTM_DELETED_IND = 1

  if exists(select DMAT_BR_NO_ALLOW from dmat_setting where DMAT_BR_NO_IND = 1)  
  begin  
  declare @l_max bigint  
        , @l_count bigint   
  select @l_max  = DMAT_BR_NO_ALLOW from dmat_setting where DMAT_BR_NO_IND = 1   
  select @l_count  = count(DISTINCT LOGN_ENT_ID) from login_names , entity_mstr where entm_id = LOGN_ENT_ID and entm_deleted_ind =1 and 
                     logn_deleted_ind = 1 and entm_enttm_cd <> 'HO'  
print @l_max
print @l_count

  if @l_max  > @l_count OR @PA_ENTTM_CD = 'HO'
  SET @PA_OUT = 'Y'  
  else   
  SET @PA_OUT = 'N'  
  end  
--  
END

GO
