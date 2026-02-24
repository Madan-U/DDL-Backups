-- Object: FUNCTION citrus_usr.fn_get_concm_bit
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--select concm_id, citrus_usr.fn_get_concm_bit(concm_id,1,0),citrus_usr.fn_get_concm_bit(concm_id,2,0) gg from conc_code_mstr_mak
-- where concm_id = @pa_concm_id
--select citrus_usr.fn_get_concm_bit(8,1)
CREATE function [citrus_usr].[fn_get_concm_bit](@pa_concm_id  numeric
                               ,@pa_check     numeric
                               ,@pa_chk_yn    numeric
                               )
RETURNS VARCHAR(8000)
AS
BEGIN
--
  DECLARE @l_concm_bit         INTEGER
         ,@l_bitrm_bit_locaton NUMERIC 
         ,@l_bitrm_parent_cd   VARCHAR(25) 
         ,@l_busm_id           NUMERIC
         ,@l_string1           VARCHAR(1000)
         ,@l_string2           VARCHAR(1000) 
         ,@l_busm_desc         VARCHAR(50)
         --,@l_string            VARCHAR(1000)   
  --
  If @pa_chk_yn = 0 
  BEGIN
  --
    SELECT @l_concm_bit      = concm_cli_yn 
    FROM   conc_code_mstr      WITH (NOLOCK)
    WHERE  concm_id          = @pa_concm_id
    AND    concm_deleted_ind = 1
  --  
  END  
  ELSE
  BEGIN
  --
    SELECT @l_concm_bit      = concm_cli_yn 
    FROM   conc_code_mstr_mak  WITH (NOLOCK) 
    WHERE  concm_id          = @pa_concm_id
    AND    concm_deleted_ind = 0
  --
  END
  --
  SET @l_string1       = ''
  SET @l_string2       = ''  
  DECLARE @c_cursor CURSOR
  --
  SET @c_cursor = CURSOR fast_forward FOR 
  SELECT DISTINCT bitrm_parent_cd 
  FROM   bitmap_ref_mstr 
  WHERE  bitrm_parent_cd LIKE 'bus_%'
  --
  OPEN @c_cursor 
  FETCH NEXT FROM @c_cursor INTO @l_bitrm_parent_cd 
  --
  WHILE (@@FETCH_STATUS = 0)
  BEGIN--cur
  --
    SELECT top 1 @l_bitrm_bit_locaton = bitrm_bit_location 
    FROM   bitmap_ref_mstr 
    WHERE  bitrm_parent_cd            = @l_bitrm_parent_cd 
    --
    IF @l_concm_bit & power(2,@l_bitrm_bit_locaton-1) > 0 
    BEGIN--#1
    --
      SELECT @l_busm_id       = busm_id
           , @l_busm_desc     = busm_desc 
      FROM   business_mstr 
      WHERE  busm_cd          = right(@l_bitrm_parent_cd,len(@l_bitrm_parent_cd)-4)
      AND    busm_deleted_ind = 1
      --
      IF @pa_check = 1
      BEGIN
      --
        SET @l_string1 = isnull(@l_string1,'') + convert(VARCHAR,@l_busm_id) + ',' 
        --SET @l_string1 = isnull(@l_string1,'') + convert(VARCHAR(5),@l_busm_id) + ',' 
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
    END--#1
    --  
    FETCH NEXT FROM @c_cursor INTO @l_bitrm_parent_cd 
 --
 END--cur
 --
 CLOSE      @c_cursor 
 DEALLOCATE @c_cursor 
 --
 RETURN CASE WHEN @pa_check = 1 THEN CASE WHEN ISNULL(@l_string1,'') = '' THEN NULL ELSE LEFT(@l_string1,LEN(@l_string1)-1) end 
             ELSE CASE WHEN ISNULL(@l_string2,'') = '' THEN NULL ELSE LEFT(@l_string2,LEN(@l_string2)-1) END   --LEFT(@l_string2,LEN(@l_string2)-1)
             END
--
END

GO
