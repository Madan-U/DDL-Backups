-- Object: FUNCTION citrus_usr.fn_ucc_dob
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_ucc_dob](@pa_crn_no numeric
                         ,@pa_exch  char(20)) 
RETURNS VARCHAR(12)
AS
BEGIN
--
  DECLARE @l_dob  VARCHAR(15)
  --DECLARE @l_Inc_dob   Varchar(25)
  --SELECT @l_Inc_dob =  entp_value FROM entity_properties WHERE  entp_ent_id = @pa_crn_no 
  --                    AND entp_entpm_cd ='INC_DOB' AND entp_deleted_ind= 1 
  --
  IF @pa_exch = 'NCDEX'
  BEGIN
  --
    SELECT @l_dob                 = CONVERT(varchar(11), clim_dob, 106)
    FROM   client_mstr              WITH (NOLOCK)
    WHERE  clim_crn_no            = @pa_crn_no
    AND    clim_deleted_ind       = 1 
  --
  END
  ELSE
  BEGIN 
  --
    SELECT @l_dob = CASE WHEN CLIM_clicm_CD not in  ('IND','NRI','SP') THEN '' ELSE Isnull(CONVERT(varchar(11), clim_dob, 103),'') END     
				FROM CLIENT_MSTR WHERE CLIM_CRN_NO = @pa_crn_no     
				AND    clim_deleted_ind       = 1     
		--
  END
  --
  RETURN @l_dob 
              
END

GO
