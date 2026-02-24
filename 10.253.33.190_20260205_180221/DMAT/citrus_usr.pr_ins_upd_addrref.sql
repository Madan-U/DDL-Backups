-- Object: PROCEDURE citrus_usr.pr_ins_upd_addrref
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_ins_upd_addrref](@pa_id             VARCHAR(8000)
                                  ,@pa_action         VARCHAR(20)
                                  ,@pa_country        VARCHAR(100)
                                  ,@pa_state          VARCHAR(100)
                                  ,@pa_city           VARCHAR(100)
                                  ,@pa_area           VARCHAR(100) 
                                  ,@pa_zip            VARCHAR(100)  
                                  ,@pa_chk_yn         NUMERIC
                                  ,@rowdelimiter      CHAR(4) =  '*|~*'
                                  ,@coldelimiter      CHAR(4)  = '|*~|'
                                  ,@pa_msg            VARCHAR(8000) OUTPUT
                                  )
AS
BEGIN
--
  DECLARE @l_coum_id        NUMERIC
        , @l_statem_id      NUMERIC 
        , @l_citm_id        NUMERIC 
        , @l_zipm_id        NUMERIC 
        , @l_statem_coum_id NUMERIC
        , @l_citm_statem_id NUMERIC
        , @l_zipm_citm_id   NUMERIC
  --
  IF @pa_action = 'INS'
  BEGIN--ins
  --
    IF isnull(@pa_country,'') <> '' and isnull(@pa_state,'') = '' and isnull(@pa_city,'')  = '' and isnull(@pa_area,'') = '' and isnull(@pa_zip,'')=  ''
    BEGIN
    --
      IF NOT EXISTS(SELECT coum_id FROM country_mstr WHERE coum_name = @pa_country)     
      BEGIN
      --
        SELECT @l_coum_id = ISNULL(MAX(coum_id),0)+1 FROM country_mstr
        --
        INSERT INTO country_mstr
        (coum_id
        ,coum_name
        )
        VALUES
        (@l_coum_id
        ,@pa_country 
        )
        --
        SET @pa_msg = '0'
      --  
      END  
      ELSE
      BEGIN
      --
        SET @pa_msg = '1'
      --
      END
    --
    END
    --
    IF isnull(@pa_country,'') <> '' and isnull(@pa_state,'') <> '' and isnull(@pa_city,'')  = '' and isnull(@pa_area,'') = '' and isnull(@pa_zip,'') =  ''
    BEGIN
    --
      IF NOT EXISTS(SELECT statem_id 
                    FROM   state_mstr    WITH (NOLOCK)
                    WHERE  statem_name = @pa_state and statem_coum_id IN (SELECT coum_id FROM country_mstr WHERE coum_name = @pa_country))     
      BEGIN
      --
        SELECT @l_statem_id = ISNULL(MAX(statem_id),0)+1 FROM state_mstr
        --
        SELECT @l_statem_coum_id = coum_id FROM country_mstr WHERE coum_name = @pa_country

        INSERT INTO state_mstr
        (statem_id
        ,statem_name
        ,statem_coum_id
        )
        VALUES
        (@l_statem_id
        ,@pa_state
        ,@l_statem_coum_id
        )
        --
        set @pa_msg  = '0'
      --    
      END
      ELSE
      BEGIN
      --
        SET @pa_msg = '1'
      --
      END    
    --
    END
    --
    IF isnull(@pa_country,'') <> '' and isnull(@pa_state,'') <> '' and isnull(@pa_city,'')  <> '' and isnull(@pa_area,'') = '' and isnull(@pa_zip,'') =  ''
    BEGIN
    --
      IF NOT EXISTS(SELECT citm_id 
                    FROM   city_mstr       WITH (NOLOCK)   
                    WHERE  citm_name     = @pa_city
                    AND    citm_statem  IN (SELECT statem_id 
                                            FROM   state_mstr    WITH(NOLOCK)
                                                 , country_mstr  WITH(NOLOCK)
                                            WHERE  statem_name = @pa_state
                                            AND    coum_name   = @pa_country 
                                            AND    statem_coum_id = coum_id
                                            )
                   )
      BEGIN
      --
        SELECT @l_citm_id = ISNULL(MAX(citm_id),0)+1 FROM city_mstr
        --
        SELECT @l_citm_statem_id = statem_id 
        FROM   state_mstr          WITH(NOLOCK)
             , country_mstr        WITH(NOLOCK) 
        WHERE  statem_name       = @pa_state
        AND    coum_name         = @pa_country 
        AND    statem_coum_id    = coum_id
        --
        INSERT INTO city_mstr
        (citm_id
        ,citm_name
        ,citm_statem
        )
        VALUES
        (@l_citm_id
        ,@pa_city
        ,@l_citm_statem_id 
        )
        --
        SET @pa_msg = '0'
      --    
      END
      ELSE
      BEGIN
      --
        SET @pa_msg = '1'
      --
      END    
    --  
    END
    --
    IF isnull(@pa_country,'') <> '' and isnull(@pa_state,'') <> '' and isnull(@pa_city,'')  <> '' and isnull(@pa_area,'') = '' and isnull(@pa_zip,'') <>  ''
    BEGIN
    -- 
      IF NOT EXISTS(SELECT zipm_id FROM zip_mstr WHERE zipm_cd = @pa_zip)     
      BEGIN
      --
        SELECT @l_zipm_id = ISNULL(MAX(zipm_id),0)+1 FROM zip_mstr
        --
        SELECT @l_zipm_citm_id = citm_id FROM city_mstr WHERE citm_name = LTRIM(RTRIM(@pa_city))
        -- 
        INSERT INTO zip_mstr
        (zipm_id
        ,zipm_area_name
        ,zipm_cd
        ,zipm_citm_id
        )
        VALUES
        (@l_zipm_id
        ,@pa_area
        ,@pa_zip
        ,@l_zipm_citm_id 
        )
        --
        SET @pa_msg = '0'
      --
      END
      ELSE
      BEGIN
      --
        SET @pa_msg = '1'
      --
      END
    --  
    END  
    --
    --END
  --
  END--ins
  --
  ELSE IF @pa_action = 'EDT'
  BEGIN--edt
  --
    DECLARE @l_old_country   varchar(100)
          , @l_new_country   varchar(100)
          , @l_old_state     varchar(100)
          , @l_new_state     varchar(100)
          , @l_old_city      varchar(100)
          , @l_new_city      varchar(100)
          , @l_old_pin       varchar(100)
          , @l_new_pin       varchar(100)
          , @l_country       varchar(100)  
    --
    IF ISNULL(@pa_country,'') <> '' --AND ISNULL(@pa_state,'') = ''
    BEGIN
    --
      SET @l_old_country = LTRIM(RTRIM(citrus_usr.FN_SPLITVAL(@pa_country,1)))
      SET @l_new_country = LTRIM(RTRIM(citrus_usr.FN_SPLITVAL(@pa_country,2)))
      --
      IF NOT EXISTS(SELECT coum_id FROM country_mstr WITH (NOLOCK) WHERE coum_name = @l_new_country)
      BEGIN
      --
        UPDATE country_mstr  WITH (ROWLOCK)
        SET    coum_name   = @l_new_country
        WHERE  coum_id     = @pa_id
        --
        SET @pa_msg        = '0'
      --  
      END
      ELSE
      BEGIN
      --
        SET @pa_msg        = '1'
      --
      END
    --
    END
    ELSE IF ISNULL(@pa_state,'') <> ''
    BEGIN
    --
      SET @l_old_state   = LTRIM(RTRIM(citrus_usr.FN_SPLITVAL(@pa_state,1)))
      SET @l_new_state   = LTRIM(RTRIM(citrus_usr.FN_SPLITVAL(@pa_state,2)))
      SET @l_country     = LTRIM(RTRIM(citrus_usr.FN_SPLITVAL(@pa_state,3)))
      --
      IF NOT EXISTS(SELECT statem_id 
                    FROM   state_mstr    WITH (NOLOCK)
                    WHERE  statem_name = @l_new_state and statem_coum_id IN (SELECT coum_id FROM country_mstr WHERE coum_name = @l_country))     
                    
      --IF NOT EXISTS(SELECT statem_id FROM state_mstr WITH (NOLOCK) WHERE statem_name = @l_new_state)
      BEGIN
      --
        UPDATE state_mstr         WITH (ROWLOCK)
        SET    statem_name      = @l_new_state --@pa_state
        WHERE  statem_id        = @pa_id
        --
        SET @pa_msg = '0'
      --
      END  
      ELSE
      BEGIN
      --
        SET @pa_msg = '1'
      --
      END
    --
    END
    ELSE IF isnull(@pa_city,'') <> ''
    BEGIN
    --
      DECLARE @l_state varchar(50)
      
      SET @l_old_city  = LTRIM(RTRIM(citrus_usr.FN_SPLITVAL(@pa_city,1)))
      SET @l_new_city  = LTRIM(RTRIM(citrus_usr.FN_SPLITVAL(@pa_city,2)))
      SET @l_state     = citrus_usr.FN_SPLITVAL(@pa_city,3)
      SET @l_country   = citrus_usr.FN_SPLITVAL(@pa_city,4)
      --
      IF NOT EXISTS(SELECT citm_id 
                    FROM   city_mstr       WITH (NOLOCK)   
                    WHERE  citm_name     = @l_new_city
                    AND    citm_statem  IN (SELECT statem_id 
                                            FROM   state_mstr       WITH(NOLOCK)
                                                 , country_mstr     WITH(NOLOCK)
                                            WHERE  statem_name    = @l_state
                                            AND    coum_name      = @l_country 
                                            AND    statem_coum_id = coum_id
                                            )
                   )
      --IF NOT EXISTS(SELECT citm_id 
      --              FROM   city_mstr       WITH (NOLOCK)   
      --              WHERE  citm_name     = @l_new_city
      --              AND    citm_statem   IN (select statem_id from state_mstr where statem_name =  @l_state)
      --             )
      BEGIN             
      -- 
        UPDATE city_mstr     WITH (ROWLOCK)
        SET    citm_name   = @l_new_city  --@pa_city
        WHERE  citm_id     = @pa_id
        --
        SET @pa_msg = '0' 
      --
      END
      ELSE
      BEGIN
      --
        SET @pa_msg = '1'
      --
      END
    --
    END
    ELSE IF isnull(@pa_zip,'') <> '' 
    BEGIN
    --
      SET @l_old_pin   = CONVERT(varchar(10),LTRIM(RTRIM(citrus_usr.FN_SPLITVAL(@pa_zip,1))))
      SET @l_new_pin   = CONVERT(varchar(10),LTRIM(RTRIM(citrus_usr.FN_SPLITVAL(@pa_zip,2))))
      --
      IF NOT EXISTS(SELECT zipm_id FROM zip_mstr WHERE zipm_cd = @l_new_pin)     
      BEGIN
      --
        UPDATE zip_mstr       WITH (ROWLOCK)
        SET    zipm_cd      = @l_new_pin   --@pa_zip
        WHERE  zipm_id      = @pa_id
        -- 
        SET @pa_msg = '0'
      -- 
      END
      ELSE
      BEGIN
      --
        SET @pa_msg = '1'
      --
      END
    --
    END
  --
  END--edt
  ELSE IF @pa_action = 'DEL'
  BEGIN
  --
    IF isnull(@pa_zip,'') <> '' AND  isnull(@pa_city,'') = '' AND isnull(@pa_state,'') = '' AND isnull(@pa_country,'') = ''
    BEGIN
    --
      DELETE FROM zip_mstr WHERE zipm_id = convert(numeric, @pa_id)
    --  
    END  
    
    IF isnull(@pa_zip,'') = '' AND  isnull(@pa_city,'') <> '' AND isnull(@pa_state,'') = '' AND isnull(@pa_country,'') = ''
    BEGIN
    --
      DELETE FROM zip_mstr WHERE zipm_citm_id = convert(numeric, @pa_id)
      --
      DELETE FROM city_mstr WHERE citm_id   = convert(numeric, @pa_id)
    --  
    END  
    --
    IF isnull(@pa_zip,'') = '' AND  isnull(@pa_city,'') = '' AND isnull(@pa_state,'') <> '' AND isnull(@pa_country,'') = ''
    BEGIN
    --
      DELETE FROM zip_mstr WHERE  zipm_citm_id in (SELECT citm_id FROM city_mstr WHERE citm_statem = convert(numeric,@pa_id))
      --
      DELETE FROM city_mstr WHERE citm_statem = convert(numeric,@pa_id) 
      --
      DELETE FROM state_mstr WHERE statem_id = convert(numeric,@pa_id) 
    --  
    END  
    --
    IF isnull(@pa_zip,'') = '' AND  isnull(@pa_city,'') = '' AND isnull(@pa_state,'') = '' AND isnull(@pa_country,'') <> ''
    BEGIN
    --
      DELETE FROM zip_mstr WHERE zipm_citm_id in (SELECT a.citm_id FROM city_mstr a, state_mstr b WHERE b.statem_id = a.citm_statem and b.statem_coum_id = convert(numeric,@pa_id)) 
      --
      DELETE FROM city_mstr WHERE citm_statem in (SELECT statem_id FROM state_mstr WHERE statem_coum_id = convert(numeric,@pa_id))
      --
      DELETE FROM state_mstr WHERE statem_coum_id = convert(numeric,@pa_id)
      --
      DELETE FROM country_mstr WHERE coum_id = convert(numeric,@pa_id)
    --
    END
  --
  END
--
END
---

GO
