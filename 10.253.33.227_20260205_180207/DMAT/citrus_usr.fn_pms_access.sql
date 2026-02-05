-- Object: FUNCTION citrus_usr.fn_pms_access
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_pms_access](@pa_crn_no     numeric
                            ,@pa_clisba_no  varchar(25)
                            ,@pa_mode       char(3)
                            ,@pa_prom       varchar(25)
                            )
RETURNS int
AS
BEGIN--#1
--
  DECLARE @l_bit1    int
        , @l_bit2    int
        , @l_bit     int
  
  SET @l_bit = 0
  --
  IF @pa_mode = 'GET'
  BEGIN--get
  --
    SELECT @l_bit1         = bitrm_bit_location
    FROM   bitmap_ref_mstr   WITH (NOLOCK)
    WHERE  bitrm_child_cd  = @pa_prom
    AND    bitrm_parent_cd = 'MIGRATION' 
    --
    SELECT @l_bit2          = clim_status
    FROM   client_mig_status  WITH (NOLOCK)
    WHERE  clim_crn_no      = @pa_crn_no
    AND    clim_sub_acct    = @pa_clisba_no
    AND    clim_e_comltd    = 1
    --
    IF @l_bit2 & power(2, @l_bit1-1) > 0
    BEGIN
    --
      SET @l_bit = 1
    --
    END
    ELSE
    BEGIN
    --
      SET @l_bit = 0
    --
    END
  --
  END--get
  ELSE
  BEGIN--set
  --
    SELECT @l_bit1           = bitrm_bit_location 
    FROM   bitmap_ref_mstr     WITH (NOLOCK)
    WHERE  bitrm_child_cd    = @pa_prom
    AND    bitrm_parent_cd   = 'MIGRATION'
    AND    bitrm_deleted_ind = 1
    --
    SET  @l_bit = POWER(2, @l_bit1-1) | @l_bit
  --
  END--set
  --
  RETURN @l_bit
--
END--#1

GO
