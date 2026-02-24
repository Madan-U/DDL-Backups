-- Object: FUNCTION citrus_usr.fn_get_enttm_bit
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_get_enttm_bit](@pa_enttm_id   numeric
                               ,@pa_check      numeric
                               ,@pa_chk_yn     numeric
                                )
RETURNS VARCHAR(8000)
AS
BEGIN
--
  DECLARE @l_enttm_bit           INTEGER
        , @l_bitrm_bit_locaton   NUMERIC 
        , @l_bitrm_parent_cd     VARCHAR(25) 
        , @l_busm_id             NUMERIC
        , @l_string1             VARCHAR(1000)
        , @l_string2             VARCHAR(1000)
        , @l_busm_desc           VARCHAR(50) 
  --
  If @pa_chk_yn = 0 
  BEGIN
  --
    SELECT @l_enttm_bit      = enttm_bit 
    FROM   entity_type_mstr    WITH (NOLOCK)
    WHERE  enttm_id          = @pa_enttm_id
    AND    enttm_deleted_ind = 1
  --  
  END
  ELSE
  BEGIN
  --
    SELECT @l_enttm_bit      =  enttm_bit 
    FROM   entity_type_mstr_mak WITH (NOLOCK)
    WHERE  enttm_id          =  @pa_enttm_id
    AND    enttm_deleted_ind =  0
  --
  END
  --
  DECLARE @c_cursor CURSOR
  --
  SET @c_cursor = CURSOR FAST_FORWARD FOR 
  SELECT DISTINCT bitrm_parent_cd 
  FROM   bitmap_ref_mstr  WITH (NOLOCK)
  WHERE  bitrm_parent_cd like 'bus_%'
  --
  OPEN @c_cursor 
  FETCH NEXT FROM @c_cursor INTO @l_bitrm_parent_cd 
  --
  WHILE (@@FETCH_STATUS=0)
  BEGIN
  --
    SELECT TOP 1 @l_bitrm_bit_locaton = bitrm_bit_location 
    FROM   bitmap_ref_mstr   WITH (NOLOCK)
    WHERE  bitrm_parent_cd = @l_bitrm_parent_cd 
    --
    IF @l_enttm_bit & power(2,@l_bitrm_bit_locaton-1) > 0 
    BEGIN
    --
      SELECT @l_busm_id   = busm_id 
           , @l_busm_desc = busm_desc
      FROM   business_mstr  WITH (NOLOCK)
      WHERE  busm_cd      = RIGHT(@l_bitrm_parent_cd,LEN(@l_bitrm_parent_cd)-4)
      --
      IF @pa_check = 1
      BEGIN
      --
        SET @l_string1 = isnull(@l_string1,'') + convert(VARCHAR,@l_busm_id) + ',' 
        --SET @l_string2 = isnull(@l_string2,'') + convert(VARCHAR(25),@l_busm_desc) + ',' 
      --
      END
      ELSE
      BEGIN
      --
        SET @l_string2 = isnull(@l_string2,'') + convert(VARCHAR(25),@l_busm_desc) + ',' 
      --
      END
    --
    END
    --
    FETCH NEXT FROM @c_cursor INTO @l_bitrm_parent_cd 
  --  
  END
  --
  CLOSE      @c_cursor 
  DEALLOCATE @c_cursor 
  --
  --RETURN left(@l_string,len(@l_string)-1)
  RETURN CASE WHEN @pa_check = 1 THEN CASE WHEN ISNULL(@l_string1,'') = '' THEN NULL ELSE LEFT(@l_string1,LEN(@l_string1)-1) end 
              ELSE CASE WHEN ISNULL(@l_string2,'') = '' THEN NULL ELSE LEFT(@l_string2,LEN(@l_string2)-1) END   --LEFT(@l_string2,LEN(@l_string2)-1)
              END
--  
END

GO
