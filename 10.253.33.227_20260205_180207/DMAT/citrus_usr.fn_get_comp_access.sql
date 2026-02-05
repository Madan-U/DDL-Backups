-- Object: FUNCTION citrus_usr.fn_get_comp_access
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_get_comp_access](@pa_rol_id    numeric
                                  ,@pa_scr_id   numeric
                                  ,@pa_comp_id  numeric
                                  ,@pa_mdtry    int
                                  ,@pa_enable   int
                                  ,@pa_exch_seg varchar(20)
                                  )
RETURNS VARCHAR(20)
AS
/*******************************************************************************
 System         : CLASS
 Module Name    : FN_GET_COMP_ACCESS
 Description    : Script to fetch the boolean value from the columns rolc_mdtry in the table roles_components
 Copyright(c)   : ENC Software Solutions Pvt. Ltd.
 Version History:
 Vers.  Author             Date         Reason
 -----  -------------      ----------   ------------------------------------------------
 1.0    SUKHVINDER/TUSHAR  09-JAN-2007  Initial Version.
**********************************************************************************/
BEGIN
--
  DECLARE @@l_parent_cd     VARCHAR(20)
         ,@@l_bit_locn      NUMERIC
         ,@@l_access        VARCHAR(20)
  --
  SELECT @@l_parent_cd = bitrm_parent_cd
       , @@l_bit_locn  = bitrm_bit_location
  FROM   bitmap_ref_mstr
  WHERE  bitrm_parent_cd  IN ('ACCESS1', 'ACCESS2')
  AND    bitrm_child_cd    = @pa_exch_seg
  AND    bitrm_deleted_ind = 1
  --

  IF @pa_comp_id = 0
  BEGIN
  --
    IF @@l_parent_cd = 'ACCESS1'
    BEGIN
    --
      SET @@l_access =  POWER(2, @@L_BIT_LOCN-1) & @pa_mdtry
    --
    END
    IF @@l_parent_cd = 'ACCESS2'
    BEGIN
    --
      SET @@l_access = ''
    --
    END
  --
  END
  ELSE
  BEGIN
  --
    IF @@l_parent_cd = 'ACCESS1'
    BEGIN
    --
      SET @@l_access =  POWER(2, @@L_BIT_LOCN-1) & @pa_mdtry
    --
    END
    IF @@l_parent_cd = 'ACCESS2'
    BEGIN
    --
      SET @@l_access =  ''
    --
    END
  --
  END
  --
  RETURN @@l_access
--
END

GO
