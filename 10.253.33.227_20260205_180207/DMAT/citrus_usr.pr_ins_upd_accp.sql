-- Object: PROCEDURE citrus_usr.pr_ins_upd_accp
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--BEGIN TRANSACTION
--PR_INS_UPD_ACCP '1516*|~*1517*|~*1518*|~*1519*|~*1520*|~*1521*|~*1522*|~*1523*|~*1524*|~*1525*|~*1526*|~*1527*|~*1528*|~*1529*|~*1530*|~*1531*|~*1532*|~*1533*|~*1534*|~*1535*|~*1536*|~*1537*|~*','app','HO',60349,'','D','','',1,'*|~*','|*~|',''	
--select * from accp_mak where accpmak_id = 1522
--ROLLBACK TRANSACTION


CREATE PROCEDURE [citrus_usr].[pr_ins_upd_accp](@pa_id                VARCHAR(8000)    
                                ,@pa_action            VARCHAR(20)    
                                ,@pa_login_name        VARCHAR(25)    
                                ,@pa_clisba_id         NUMERIC    
                                ,@pa_acct_no           VARCHAR(20)
                                ,@pa_acct_type         VARCHAR(20)
                                ,@pa_values            VARCHAR(8000)    
                                ,@pa_dtls_values       VARCHAR(8000)    
                                ,@pa_chk_yn            NUMERIC    
                                ,@rowdelimiter         CHAR(4)  =  '*|~*'    
                                ,@coldelimiter         CHAR(4)  = '|*~|'    
                                ,@pa_msg               VARCHAR(8000) OUTPUT    
                                )    
                                
                                
AS
/*
**************************************************************************************
 SYSTEM         : CITRUS
 MODULE NAME    : pr_select_accts
 DESCRIPTION    : This procedure will select data related to client_account
 COPYRIGHT(C)   : Marketplace technologies pvt ltd
 VERSION HISTORY:
 VERS.  AUTHOR             DATE        REASON
 -----  -------------      ----------  ------------------------------------------------
 1.0    TUSHAR             04-MAY-2007 INITIAL VERSION.
--------------------------------------------------------------------------------------*/
BEGIN
--
  SET NOCOUNT ON
  --
  DECLARE @remainingstring_dtvalue_row    VARCHAR(8000)    
         ,@delimeterlength_dtvalue_row    INT    
         ,@currstring_dtvalue_row         VARCHAR(8000)    
         ,@delimeter_dtvalue_row          VARCHAR(10)  
          --@PA_ID--
         ,@currstring_id                  VARCHAR(8000)
         ,@delimeter_id                   VARCHAR(10)
         ,@delimeterlength_id             INT
         ,@remainingstring_id             VARCHAR(8000)
         ,@foundat                        INT
          --#t_dtls_values--
         ,@foundat_dtl_val                INT 
         ,@l_accpm_cd                     VARCHAR(50)          
         ,@l_accpd_cd                     VARCHAR(50) 
         ,@l_accpd_id                     NUMERIC
          --@pa_values
         ,@remainingstring_value          VARCHAR(8000)
         ,@currstring_value               VARCHAR(8000) 
         ,@delimeter_value                CHAR(4)
         ,@foundat_val                    INT 
         ,@delimeterlength_value          INT 

         ,@l_accpm_prop_id                NUMERIC
         ,@l_accdm_id                     NUMERIC
         ,@l_accpd_value                  VARCHAR(50)
         ,@l_accdm_cd                     VARCHAR(25)
         ,@l_accp_value                   VARCHAR(50) 
         ,@l_accpm_prop_cd                VARCHAR(25)
         ,@l_accp_id                      NUMERIC
         ,@l_error                        NUMERIC
         ,@l_accpm_prop_desc              VARCHAR(50) 
         ,@t_errorstr                     VARCHAR(200)
         ,@@c_access_cursor               CURSOR
         ,@accpm_prop_id                  NUMERIC 
         ,@accpd_value                    VARCHAR(50)
         ,@accdm_id                       NUMERIC
         ,@l_accdm_desc                   VARCHAR(50)

         ,@accdm_cd                       VARCHAR(25)
         ,@l_accpmak_id                   NUMERIC 
         ,@l_accpm_desc                   VARCHAR(50)
         ,@l_entpmak_id                   NUMERIC
         ,@l_clisba_crn_no                NUMERIC
         ,@l_accp_deleted_ind             CHAR(4)
         ,@l_clisba_id                    NUMERIC
         ,@l_accp_acct_no                 VARCHAR(25)
         ,@l_accp_accpm_prop_id           NUMERIC
         ,@l_accp_accpm_prop_cd           VARCHAR(25)
         ,@l_acct_type                    VARCHAR(10)
         ,@l_accpd_deleted_ind            CHAR(4)
         ,@l_accp_id1                     NUMERIC
         ,@l_accpd_accp_id                NUMERIC
         ,@l_accpd_accdm_id               NUMERIC
         ,@l_accpd_accdm_cd               VARCHAR(25)
         ,@@c_accpd                       cursor
         ,@l_accpd_created_by             varchar(10)
         ,@l_accpd_created_dt             DATETIME
set @l_clisba_crn_no  = 0
    --     
    CREATE TABLE #t_dtls_values    
    (accpm_prop_id    varchar(50)    
    ,accdm_id         varchar(50)    
    ,accpd_value      varchar(50)
    ,accdm_cd         varchar(20)
    )



 IF @pa_action = 'APP' or @pa_action = 'REJ'
    BEGIN--Temp
    --
      CREATE TABLE #accp_mak
      ( accpmak_id          numeric --#change
      , accp_id             numeric
      , accp_clisba_id      numeric
      , accp_acct_no        varchar(25)
      , accp_accpm_prop_id  numeric
      , accp_accpm_prop_cd  varchar(20)
      , accp_value          varchar(50)
      , accp_deleted_ind    smallint
      , acct_type           varchar(10) 
      )
      
      --
      INSERT INTO #accp_mak
      ( accpmak_id
      , accp_id
      , accp_clisba_id
      , accp_acct_no
      , accp_accpm_prop_id
      , accp_accpm_prop_cd
      , accp_value        
      , accp_deleted_ind
      , acct_type
      )  
      SELECT accpmak_id
           , accp_id        
           , accp_clisba_id       
           , accp_acct_no 
           , accp_accpm_prop_id
           , accp_accpm_prop_cd     
           , accp_value   
           , accp_deleted_ind
           , accp_acct_type
      FROM   accp_mak
           , dp_acct_mstr dpam
      WHERE  accp_deleted_ind IN (0,4,8)
      and    dpam_id = accp_clisba_id
      and    dpam_crn_no = @pa_clisba_id --crn_no send by approve procedure pr_app_client
      
      union

      SELECT accp_id
           , accp_id        
           , accp_clisba_id       
           , accp_acct_no 
           , accp_accpm_prop_id
           , accp_accpm_prop_cd     
           , accp_value   
           , accp_deleted_ind
           , accp_acct_type
      FROM   account_properties 
           , dp_acct_mstr dpam
           , accpd_mak    accpd 
      WHERE  accp_deleted_ind = 1 
      and    dpam_id = accp_clisba_id
      and    accpd_accp_id = accp_id 
      and    dpam_crn_no = @pa_clisba_id
      and    accpd_deleted_ind in (0,4,8) 
      --AND    accp_created_by <> @pa_login_name
      --
      CREATE TABLE #accp_dtls_mak
      (accpd_id          numeric
      ,accpd_accp_id     numeric
      ,accpd_accdm_id    numeric
      ,accpd_accdm_cd    varchar(20)
      ,accpd_value       varchar(50)
      ,accpd_created_by  varchar(25)
      ,accpd_created_dt  DATETIME 
      ,accpd_deleted_ind smallint
      )
      --
      
      INSERT INTO #accp_dtls_mak
      (accpd_id
      ,accpd_accp_id
      ,accpd_accdm_id
      ,accpd_accdm_cd
      ,accpd_value
      ,accpd_created_by
      ,accpd_created_dt
      ,accpd_deleted_ind
      )
      SELECT accpd_id
           , accpd_accp_id
           , accpd_accdm_id
           , accpd_accdm_cd
           , accpd_value
           , accpd_created_by
           , accpd_created_dt
           , accpd_deleted_ind
      FROM   accpd_mak
      WHERE  accpd_created_by  <> @pa_login_name
      AND    accpd_deleted_ind IN(0,4,8) 
      and ACCPD_ACCP_ID in (select accp_id from #accp_mak)


   --   
   END--Temp 



    IF ISNULL(@PA_ID,'') = '' 
    BEGIN 
    --
      SET @remainingstring_id = '0'
    --
    END
    ELSE
    BEGIN
    --
      SET @remainingstring_id = @pa_id
    --
    END
    
    SET @delimeter_id             = '%'+@rowdelimiter+ '%'
   SET @delimeterlength_id        =  LEN(@rowdelimiter)      
    
    --*********************************************MAK-CHK*****************************************************
   
   
   --*********************************************MAK-CHK*****************************************************
         
    WHILE @remainingstring_id <> ''
    BEGIN
    --
      
      SET @foundat = 0
      
      SET @foundat =  patindex('%'+@delimeter_id+'%',@remainingstring_id)
      --
      IF  @foundat > 0
      BEGIN
      --
        SET @currstring_id      = substring(@remainingstring_id, 0,@Foundat)
        SET @remainingstring_id = substring(@remainingstring_id, @foundat+@delimeterlength_id,len(@remainingstring_id)- @foundat+@delimeterlength_id)
      --
      END
      ELSE
      BEGIN
      --
        SET @currstring_id = @remainingstring_id
        SET @remainingstring_id = ''
      --
      END
      --
      IF @currstring_id <> ''
      BEGIN
      --
        

        
        SET @delimeter_value             = '%'+@rowdelimiter+ '%'
        SET @delimeterlength_value       = len(@rowdelimiter)
        SET @remainingstring_dtvalue_row = @pa_dtls_valueS
        SET @remainingstring_value       = @pa_values
        --
        WHILE @remainingstring_dtvalue_row <> ''
        BEGIN
        --
          SET @foundat = 0
          SET @foundat =  patindex('%'+@delimeter_value+'%',@remainingstring_dtvalue_row)
          --
          IF @foundat > 0
          BEGIN
          --
            SET @currstring_dtvalue_row            = substring(@remainingstring_dtvalue_row, 0,@foundat)
            SET @remainingstring_dtvalue_row       = substring(@remainingstring_dtvalue_row, @foundat+@delimeterlength_value,len(@remainingstring_dtvalue_row)- @foundat+@delimeterlength_value)
          --
          END
          ELSE
          BEGIN
          --
            SET @currstring_dtvalue_row            = @remainingstring_dtvalue_row
            SET @remainingstring_dtvalue_row       = ''
          --
          END
          --
          IF @currstring_dtvalue_row <> ''
          BEGIN
          --
             SET @l_accpm_prop_id = CONVERT(numeric, citrus_usr.fn_splitval(@currstring_dtvalue_row,1))    
             SET @l_accdm_id      = CONVERT(numeric, citrus_usr.fn_splitval(@currstring_dtvalue_row,2))    
             SET @l_accpd_value   = citrus_usr.fn_splitval(@currstring_dtvalue_row,3)    
             --
             SELECT @l_accdm_cd       = accdm_cd    
             FROM   accpm_dtls_mstr     WITH (NOLOCK)    
             WHERE  accdm_id          = @l_accdm_id
             AND    accdm_deleted_ind = 1
             --
             INSERT INTO #t_dtls_values     
             VALUES (@l_accpm_prop_id   
                    ,@l_accdm_id   
                    ,@l_accpd_value
                    ,@l_accdm_cd
                    )
             SET @l_accdm_cd = NULL   
             
             
          --
          END
        --
        END
        --
        WHILE @remainingstring_value <> ''
        BEGIN
        --
          SET @foundat = 0
          SET @foundat =  patindex('%'+@delimeter_value+'%',@remainingstring_value)
          --
          IF @foundat > 0
          BEGIN
          --
            SET @currstring_value      = substring(@remainingstring_value, 0,@foundat)
            SET @remainingstring_value = substring(@remainingstring_value, @foundat+@delimeterlength_value,len(@remainingstring_value)- @foundat+@delimeterlength_value)
          --
          END
          ELSE
          BEGIN
          --
            SET @currstring_value      = @remainingstring_value
            SET @remainingstring_value = ''
          --
          END
          --
          IF @currstring_value <> ''
          BEGIN
          --
            SET @l_accpm_prop_id      = CONVERT(numeric, citrus_usr.fn_splitval(@currstring_value, 1))    
            SET @l_accp_value         = RTRIM(LTRIM(citrus_usr.fn_splitval(@currstring_value, 2)))  
            
            SELECT DISTINCT @l_accpm_prop_cd = accpm_prop_cd
            FROM   account_property_mstr
            WHERE  accpm_prop_id        = @l_accpm_prop_id 
            AND    accpm_deleted_ind    = 1  
            
            IF @pa_chk_yn = 0
            BEGIN--chk_yn=0
            --
              IF ISNULL(@l_accp_value,'') = ''
              BEGIN
              --
                BEGIN TRANSACTION
                
                SELECT @l_accp_id         = accp_id    
                FROM   account_properties   WITH(NOLOCK)    
                WHERE  accp_clisba_id     = @pa_clisba_id    
                AND    accp_accpm_prop_id = @l_accpm_prop_id
                AND    accp_acct_no       = @pa_acct_no
                AND    accp_deleted_ind   = 1 
                                  -- 
                UPDATE account_property_dtls  WITH(ROWLOCK)   
                SET    accpd_deleted_ind  = 0
                     , accpd_lst_upd_by   = @pa_login_name
                     , accpd_lst_upd_dt   = GETDATE()
                WHERE  accpd_accp_id      = @l_accp_id
                AND    accpd_deleted_ind  = 1 
                
                SET @l_error = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN--roll    
                --    
                  SELECT TOP 1 @l_accpm_prop_desc = accpm_prop_desc    
                  FROM   account_property_mstr         WITH(NOLOCK)    
                  WHERE  accpm_prop_id               = @l_accpm_prop_id    
                  AND    accpm_deleted_ind           = 1    
                  --    
                  SET @t_errorstr = '#'+@l_accpm_prop_desc + ' could not be inserted/edited'+@rowdelimiter    
                  --    
                  ROLLBACK TRANSACTION    
                --    
                END--roll    
                ELSE
                BEGIN--com
                --
                  UPDATE account_properties   WITH(ROWLOCK)   
                  SET    accp_deleted_ind  = 0
                       , accp_lst_upd_by   = @pa_login_name
                       , accp_lst_upd_dt   = GETDATE()
                  WHERE  accp_id           = @l_accp_id
                  AND    accp_deleted_ind  = 1 
                  --
                  SET @l_error   = @@ERROR    
                  --    
                  IF @l_error > 0    
                  BEGIN --#1    
                  --    
                    SELECT TOP 1 @l_accpm_prop_desc    = accpm_prop_desc    
                    FROM   account_property_mstr       WITH(NOLOCK)    
                    WHERE  accpm_prop_id               = @l_accpm_prop_id    
                    AND    accpm_deleted_ind           = 1    
                    --    
                    SET @t_errorstr = '#'+@l_accpm_prop_desc+' could not be inserted/edited'+@rowdelimiter    
                    --    
                    ROLLBACK TRANSACTION    
                  --    
                  END  --#1    
                  ELSE    
                  BEGIN--#2    
                  --    
                    SET @t_errorstr = 'Account properties successfuly inserted/edited'+@rowdelimiter    
                    --    
                    COMMIT TRANSACTION    
                  --    
                  END  --#2
                  --
                  SET @l_accp_id = null    
                --  
                END--com  
              --
              END
              ELSE
              BEGIN
              --
                IF EXISTS(SELECT accp_id    
                          FROM   account_properties  WITH(NOLOCK)    
                          WHERE  accp_clisba_id     = @pa_clisba_id
                          AND    accp_accpm_prop_id = @l_accpm_prop_id
                          AND    accp_acct_no       = @pa_acct_no
                          AND    accp_deleted_ind   = 1)
                BEGIN
                --
                  BEGIN TRANSACTION 
                  --
                  SELECT @l_accp_id          =  accp_id    
                  FROM   account_properties  WITH(NOLOCK)    
                  WHERE  accp_clisba_id      = @pa_clisba_id
                  AND    accp_accpm_prop_id  = @l_accpm_prop_id  
                  AND    accp_acct_no        = @pa_acct_no
                  AND    accp_deleted_ind    = 1 
                  --    
                  UPDATE account_properties WITH(ROWLOCK)    
                  SET    accp_value          = @l_accp_value    
                       , accp_lst_upd_by     = @pa_login_name    
                       , accp_lst_upd_dt     = GETDATE()    
                  WHERE  accp_clisba_id      = @pa_clisba_id    
                  AND    accp_accpm_prop_id  = @l_accpm_prop_id    
                  AND    accp_deleted_ind    = 1      
                  
                  SET @l_error               = @@ERROR    
                  --    
                  IF @l_error > 0    
                  BEGIN --#1    
                  --    
                    SELECT TOP 1 @l_accpm_prop_desc  = accpm_prop_desc    
                    FROM   account_property_mstr   WITH(NOLOCK)    
                    WHERE  accpm_prop_id           = @l_accpm_prop_id  
                    AND    accpm_deleted_ind       = 1    
                    --    
                    SET @t_errorstr = '#'+@l_accpm_prop_desc+' could not be inserted/edited'+@rowdelimiter    
                    --    
                    ROLLBACK TRANSACTION    
                  --    
                  END--#1    
                  ELSE    
                  BEGIN--#2    
                  --    
                    SET @t_errorstr = 'Account properties successfuly inserted/edited'+@rowdelimiter    
                    --    
                    COMMIT TRANSACTION    
                  --    
                  END--#2    
                  --
                  SET @l_accp_id     = NULL    
                  --    
                --
                END
                ELSE
                BEGIN
                --
                  BEGIN TRANSACTION    
                  --    
                 SELECT @l_accp_id1  = ISNULL(MAX(accp_id),0)+1 FROM  accp_mak 
                  SELECT @l_accp_id  = ISNULL(MAX(accp_id),0)+1 FROM   account_properties
                                                      
                  IF @l_accp_id1 > @l_accp_id
                  BEGIN
                  --
                    SET @l_accp_id = @l_accp_id1
                  --
                  END
                  --
                  INSERT INTO account_properties    
                  (accp_id    
                  ,accp_clisba_id    
                  ,accp_acct_no    
                  ,accp_acct_type
                  ,accp_accpm_prop_id    
                  ,accp_accpm_prop_cd    
                  ,accp_value    
                  ,accp_created_by    
                  ,accp_created_dt    
                  ,accp_lst_upd_by    
                  ,accp_lst_upd_dt    
                  ,accp_deleted_ind    
                  )    
                  VALUES    
                  (@l_accp_id    
                  ,@pa_clisba_id    
                  ,@pa_acct_no  
                  ,@PA_ACCT_TYPE  
                  ,@l_accpm_prop_id    
                  ,@l_accpm_prop_cd    
                  ,@l_accp_value   
                  ,@pa_login_name    
                  ,GETDATE()    
                  ,@pa_login_name    
                  ,GETDATE()    
                  ,1
                  )    
                  --    
                  SET @l_accp_id = NULL    
                  --    
                  SET @l_error  = @@ERROR    
                  --    
                  IF @l_error > 0    
                  BEGIN --#1    
                  --    
                    SELECT TOP 1 @l_accpm_prop_desc  = accpm_prop_desc    
                    FROM   account_property_mstr    WITH(NOLOCK)    
                    WHERE  accpm_prop_id           = @l_accpm_prop_id   
                    AND    accpm_deleted_ind       = 1    
                    --    
                    SET @t_errorstr = '#'+@l_accpm_prop_desc +' Could Not Be Inserted/Edited'+@rowdelimiter    
                    --    
                    ROLLBACK TRANSACTION    
                  --    
                  END--#1    
                  ELSE    
                  BEGIN--#2    
                  --    
                    SET @t_errorstr = 'Account Properties Successfuly Inserted/Edited'+@ROWDELIMITER    
                    --    
                    COMMIT TRANSACTION    
                  --    
                  END--#2    
                --
                END
              --
              END
              
            --
            END
            --******************************************MAK-CHK*****************************************************
            IF @PA_CHK_YN = 1 OR  @PA_CHK_YN = 2
            BEGIN--chk_yn=1_2
            --
              SELECT DISTINCT @l_accpm_prop_cd = accpm_prop_cd
              FROM   account_property_mstr
              WHERE  accpm_prop_id        = @l_accpm_prop_id 
              AND    accpm_deleted_ind    = 1  
              --                
              IF @pa_clisba_id <> 0 and @pa_acct_type <> 'D'
              BEGIN--1
              --
                IF EXISTS(SELECT clisba_crn_no
                          FROM   client_sub_accts_mak
                          WHERE  clisba_id          = @pa_clisba_id
                          AND    clisba_deleted_ind IN(0,4,8))
                BEGIN
                --
                  SELECT @l_clisba_crn_no   = clisba_crn_no
                  FROM   client_sub_accts_mak
                  WHERE  clisba_id          = @pa_clisba_id
                  AND    clisba_deleted_ind IN(0,4,8)
                --
                END
                ELSE
                BEGIN
                --
                  SELECT @l_clisba_crn_no   = clisba_crn_no
                  FROM   client_sub_accts
                  WHERE  clisba_id          = @pa_clisba_id
                  AND    clisba_deleted_ind = 1
                --
                END

              --
              END--1
              --
              IF @pa_clisba_id<>0 and @pa_acct_type = 'D'
              BEGIN--11
              --
                IF EXISTS(SELECT dpam_crn_no
                          FROM   dp_acct_mstr_mak
                          WHERE  dpam_id          = @pa_clisba_id
                          AND    dpam_deleted_ind IN(0,4,8))
                BEGIN
                --
                  SELECT @l_clisba_crn_no   = dpam_crn_no
                  FROM   dp_acct_mstr_mak
                  WHERE  dpam_id          = @pa_clisba_id
                  AND    dpam_deleted_ind IN(0,4,8)
                --
                END
                ELSE
                BEGIN
                --
                  SELECT @l_clisba_crn_no   = dpam_crn_no
                  FROM   dp_acct_mstr
                  WHERE  dpam_id            = @pa_clisba_id
                  AND    dpam_deleted_ind = 1
                --
                END
              --
              END--11
            
              --EXEC pr_ins_upd_list @l_clim_crn_no, @l_action,'CLIENT MSTR', @pa_login_name, '*|~*', '|*~|', '' 
              IF EXISTS(SELECT accpmak_id 
                        FROM   accp_mak
                        WHERE  accp_clisba_id     = @pa_clisba_id 
                        AND    accp_accpm_prop_id = @l_accpm_prop_id 
                        AND    accp_deleted_ind   IN (0,4,8))  
              BEGIN
              --
                UPDATE accp_mak
                SET    accp_deleted_ind   = 3
                      ,accp_lst_upd_by    = @pa_login_name  
                      ,accp_lst_upd_dt    = GETDATE()
                WHERE  accp_clisba_id     = @pa_clisba_id 
                AND    accp_accpm_prop_id = @l_accpm_prop_id 
                AND    accp_deleted_ind   IN (0,4,8)
              --
              END
              
              
              IF ISNULL(@l_accp_value,'') = ''
              BEGIN--accp_value=''
              --
                BEGIN TRANSACTION    
                --    
                SELECT @l_accpmak_id    = ISNULL(MAX(accpmak_id),0)+1    
                FROM   accp_mak WITH(NOLOCK)  
                
                SELECT @l_accp_id1  = ISNULL(MAX(accp_id),0)+ 1 FROM  accp_mak 
                SELECT @l_accp_id  = ISNULL(MAX(accp_id),0)+ 1 FROM   account_properties
                
                IF @l_accp_id1 > @l_accp_id
                BEGIN
                --
                  SET @l_accp_id = @l_accp_id1
                --
                END
                --    
                INSERT INTO accp_mak
                (accpmak_id
                ,accp_id
                ,accp_clisba_id
                ,accp_acct_no
                ,accp_acct_type
                ,accp_accpm_prop_id
                ,accp_accpm_prop_cd
                ,accp_value
                ,accp_created_by
                ,accp_created_dt
                ,accp_lst_upd_by
                ,accp_lst_upd_dt
                ,accp_deleted_ind
                )
                VALUES
                (@l_accpmak_id 
                ,@l_accp_id    
                ,@pa_clisba_id    
                ,@pa_acct_no    
                ,@pa_acct_type
                ,@l_accpm_prop_id    
                ,@l_accpm_prop_cd      
                ,@l_accp_value    
                ,@pa_login_name    
                ,GETDATE()    
                ,@pa_login_name    
                ,GETDATE()    
                ,4
                )    
                --
                SET @l_accp_id = null    
                --    
                SET @l_error  = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN --#1    
                --    
                  SELECT TOP 1 @l_accpm_desc     = accpm_prop_desc    
                  FROM   account_property_mstr  with(nolock)    
                  WHERE  accpm_prop_id     = @l_accpm_prop_id    
                  AND    accpm_deleted_ind = 1    
                  --    
                  SET @t_errorstr = @l_accpm_desc+' could not be inserted/edited'+@rowdelimiter
                  --    
                  ROLLBACK TRANSACTION    
                --    
                END--#1    
                ELSE    
                BEGIN--#2    
                --    
                  SET @t_errorstr = 'Account properties successfuly inserted/edited'+@rowdelimiter    
                  --    
                  COMMIT TRANSACTION 
                  UPDATE client_mstr set clim_lst_upd_by = @pa_login_name WHERE clim_crn_no =@l_clisba_crn_no AND clim_deleted_ind = 1
                  EXEC pr_ins_upd_list @l_clisba_crn_no, 'D','ACCOUNT PROPERTIES', @pa_login_name, '*|~*', '|*~|', '' 
                --    
                END--#2    
              --
              END--accpm_value=''
              IF ISNULL(@l_accp_value,'') <> ''
              BEGIN--accpm_value<>''
              --
                IF EXISTS(SELECT accp_id    
                          FROM   ACCOUNT_PROPERTIES with(nolock)    
                          WHERE  accp_clisba_id     = @pa_clisba_id    
                          AND    accp_accpm_prop_id = @l_accpm_prop_id
                          AND    accp_deleted_ind   = 1
                          )    
                BEGIN--exist    
                --    
                  BEGIN TRANSACTION    
                  --
                    SELECT @l_accpmak_id    = ISNULL(MAX(accpmak_id),0)+1    
                    FROM   accp_mak WITH(NOLOCK)
                    
                    /*SELECT @l_accp_id1  = MAX(ISNULL(accp_id,0))+1 FROM  accp_mak 
                    SELECT @l_accp_id  = MAX(ISNULL(accp_id,0))+1 FROM   account_properties
                                    
                    IF @l_accp_id1 > @l_accp_id
                    BEGIN
                    --
                      SET @l_accp_id = @l_accp_id1
                    --
                    END*/
                    SELECT @l_accp_id         = accp_id    
                    FROM   account_properties   WITH(NOLOCK)    
                    WHERE  accp_clisba_id     = @pa_clisba_id    
                    AND    accp_accpm_prop_id = @l_accpm_prop_id
                    AND    accp_deleted_ind   = 1
    
                    if isnull(@l_accp_id,0) = 0
                    begin
                    --
                      SELECT @l_accp_id         = accp_id    
                      FROM   accp_mak   WITH(NOLOCK)    
                      WHERE  accp_clisba_id     = @pa_clisba_id    
                      AND    accp_accpm_prop_id = @l_accpm_prop_id
                      AND    accp_deleted_ind   in (0,8)
                    --
                    end             
                    
                    --    
                    INSERT INTO accp_mak
                    (accpmak_id
                    ,accp_id
                    ,accp_clisba_id
                    ,accp_acct_no
                    ,accp_acct_type
                    ,accp_accpm_prop_id
                    ,accp_accpm_prop_cd
                    ,accp_value
                    ,accp_created_by
                    ,accp_created_dt
                    ,accp_lst_upd_by
                    ,accp_lst_upd_dt
                    ,accp_deleted_ind
                    )
                    VALUES
                    (@l_accpmak_id 
                    ,@l_accp_id    
                    ,@pa_clisba_id    
                    ,@pa_acct_no    
                    ,@pa_acct_type
                    ,@l_accpm_prop_id    
                    ,@l_accpm_prop_cd    
                    ,@l_accp_value    
                    ,@pa_login_name    
                    ,GETDATE()    
                    ,@pa_login_name    
                    ,GETDATE()    
                    ,8
                    )    
                  --
                  
                  SET @l_accp_id              = NULL    
                  SET @l_error                = @@ERROR    
                  --    
                  IF @l_error > 0    
                  BEGIN --#1    
                  --    
                    SELECT TOP 1 @l_accpm_desc           = accpm_prop_desc    
                    FROM   account_property_mstr   WITH(NOLOCK)    
                    WHERE  accpm_prop_id           = @l_accpm_prop_id    
                    AND    accpm_deleted_ind = 1    
                    --    
                    SET @t_errorstr = @l_accpm_desc+' could not be inserted/edited'+@rowdelimiter 
                    --    
                    ROLLBACK TRANSACTION    
                  --    
                  END--#1    
                  ELSE    
                  BEGIN--#2    
                  --    
                    SET @t_errorstr = 'Account properties successfuly inserted/edited'+@rowdelimiter    
                    --    
                    COMMIT TRANSACTION   
                     UPDATE client_mstr set clim_lst_upd_by = @pa_login_name WHERE clim_crn_no =@l_clisba_crn_no AND clim_deleted_ind = 1
                    EXEC pr_ins_upd_list @l_clisba_crn_no, 'E','ACCOUNT PROPERTIES', @pa_login_name, '*|~*', '|*~|', '' 
                  --    
                  END--#2    
                  
                --
                END
                ELSE
                BEGIN
                --
                  BEGIN TRANSACTION    
                  --
                  SELECT @l_accpmak_id = ISNULL(MAX(accpmak_id),0) + 1    
                  FROM accp_mak WITH(NOLOCK)
                  
                  SELECT @l_accp_id1  = ISNULL(MAX(accp_id),0)+1 FROM  accp_mak 
                  SELECT @l_accp_id  = ISNULL(MAX(accp_id),0)+1 FROM   account_properties
                                                      
                  IF @l_accp_id1 > @l_accp_id
                  BEGIN
                  --
                    SET @l_accp_id = @l_accp_id1
                  --
                  END
                  
                  --    
                  INSERT INTO accp_mak    
                  (accpmak_id
                  ,accp_id    
                  ,accp_clisba_id    
                  ,accp_acct_no   
                  ,accp_acct_type
                  ,accp_accpm_prop_id    
                  ,accp_accpm_prop_cd    
                  ,accp_value    
                  ,accp_created_by    
                  ,accp_created_dt    
                  ,accp_lst_upd_by    
                  ,accp_lst_upd_dt    
                  ,accp_deleted_ind    
                  )    
                  VALUES    
                  (@l_accpmak_id
                  ,@l_accp_id    
                  ,@pa_clisba_id    
                  ,@pa_acct_no    
                  ,@pa_acct_type
                  ,@l_accpm_prop_id    
                  ,@l_accpm_prop_cd    
                  ,@l_accp_value   
                  ,@pa_login_name    
                  ,GETDATE()    
                  ,@pa_login_name    
                  ,GETDATE()    
                  ,0
                  )    
                  --    
                  SET @l_error  = @@ERROR    
                  --    
                  IF @l_error > 0    
                  BEGIN --#1    
                  --    
                    SELECT TOP 1 @l_accpm_desc           = accpm_prop_desc    
                    FROM   account_property_mstr   WITH(NOLOCK)    
                    WHERE  accpm_prop_id           = @l_accpm_prop_id    
                    AND    accpm_deleted_ind = 1    
                    --    
                    SET @t_errorstr = @l_accpm_desc+' Could Not Be Inserted/Edited'+@rowdelimiter 
                    --    
                    ROLLBACK TRANSACTION    
                  --    
                  END--#1    
                  ELSE    
                  BEGIN--#2    
                  --    
                    SET @t_errorstr = 'Account Properties Successfuly Inserted/Edited'+@ROWDELIMITER    
                    --    
                    COMMIT TRANSACTION    
                     UPDATE client_mstr set clim_lst_upd_by = @pa_login_name WHERE clim_crn_no =@l_clisba_crn_no AND clim_deleted_ind = 1
                    EXEC pr_ins_upd_list @l_clisba_crn_no, 'I','ACCOUNT PROPERTIES', @pa_login_name, '*|~*', '|*~|', '' 
                  --    
                  END--#2
                  --
                  SET @l_entpmak_id = NULL    
                --
                END
              --
              END--accpm_value<>''
              
            --
            END--chk_yn=1_2
            --******************************************MAK-CHK****************************************************
          --
          END
        --
        END
        IF RTRIM(LTRIM(@pa_dtls_values)) <> ''
        BEGIN
        --
          IF @pa_chk_yn = 0
          BEGIN
          --
            SET @@c_access_cursor =  CURSOR fast_forward FOR    
            SELECT accpm_prop_id    
                 , accdm_id    
                 , accpd_value
                 , accdm_cd
            FROM   #t_dtls_values     
            --    
            
            
            OPEN @@c_access_cursor    
            FETCH next FROM @@c_access_cursor INTO @accpm_prop_id, @accdm_id, @accpd_value, @accdm_cd    
            
            WHILE @@fetch_status = 0    
            BEGIN--cur    
            --
              SELECT @l_accp_id         = accp_id    
              FROM   account_properties  WITH(NOLOCK)    
              WHERE  accp_clisba_id     = @pa_clisba_id    
              AND    accp_accpm_prop_id = @accpm_prop_id
              AND    accp_deleted_ind   = 1 
              --              
              IF rtrim(ltrim(@accpd_value)) = ''    
              BEGIN--entpd_value=''    
              --    
                BEGIN TRANSACTION    
                --
                UPDATE account_property_dtls WITH (ROWLOCK)
                SET    accpd_deleted_ind = 0
                     , accpd_lst_upd_by  = @pa_login_name
                     , accpd_lst_upd_dt  = GETDATE()
                WHERE  accpd_accp_id     = @l_accp_id    
                AND    accpd_accdm_id    = @accdm_id 
                AND    accpd_deleted_ind = 1
                --    
                SET @l_error    = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                -- 
                  SELECT @l_accdm_desc     = accdm_desc    
                  FROM   accpm_dtls_mstr   WITH(NOLOCK)    
                  WHERE  accdm_id          = @accdm_id    
                  AND    accdm_deleted_ind = 1  
                  --
                  SET @t_errorstr = '#'+@l_accdm_desc+' could not be inserted/edited'+@rowdelimiter    
                  --
                  ROLLBACK TRANSACTION    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  SET @t_errorstr = 'Account properties successfully inserted/edited'+@rowdelimiter    
                  --
                  COMMIT TRANSACTION    
                --    
                END    
                --
                SET @l_accp_id  = null    
              --    
              END--entpd_value=''
              ELSE
              BEGIN
              --
                IF EXISTS(SELECT *    
                          FROM   account_property_dtls with(nolock)    
                          WHERE  accpd_accp_id       = @l_accp_id    
                          AND    accpd_accdm_id      = @accdm_id   
                          and    accpd_deleted_ind   = 1
                          )    
                BEGIN
                --
                  BEGIN TRANSACTION    
                  --    
                  UPDATE account_property_dtls WITH(ROWLOCK)    
                  SET    accpd_value       = @accpd_value
                        ,accpd_lst_upd_by  = @pa_login_name
                        ,accpd_lst_upd_dt  = GETDATE() 
                  WHERE  accpd_accp_id     = @l_accp_id    
                  AND    accpd_accdm_id    = @accdm_id
                  and    accpd_deleted_ind = 1    
                  --    
                  SET @l_error = @@ERROR    
                  --    
                  IF @l_error > 0    
                  BEGIN    
                  --    
                    SELECT @l_accdm_desc     = accdm_desc    
                    FROM   accpm_dtls_mstr   WITH(NOLOCK)    
                    WHERE  accdm_id          = @accdm_id    
                    AND    accdm_deleted_ind = 1  
                    --
                    SET @t_errorstr = '#'+@l_accdm_desc+' could not be inserted/edited'+@rowdelimiter    
                    --
                    ROLLBACK TRANSACTION    
                  --    
                  END    
                  ELSE    
                  BEGIN    
                  --    
                    COMMIT TRANSACTION    
                    --    
                    SET @t_errorstr = 'Account properties successfully inserted/edited'+@rowdelimiter    
                  --    
                  END
                --
                END
                ELSE
                BEGIN
                  --
                    BEGIN TRANSACTION    
                    --
                    INSERT INTO account_property_dtls    
                    (accpd_accp_id    
                    ,accpd_accdm_id    
                    ,accpd_accdm_cd    
                    ,accpd_value    
                    ,accpd_created_by    
                    ,accpd_created_dt    
                    ,accpd_lst_upd_by    
                    ,accpd_lst_upd_dt    
                    ,accpd_deleted_ind)    
                    VALUES    
                    (@l_accp_id    
                    ,@accdm_id    
                    ,@accdm_cd    
                    ,@accpd_value    
                    ,@pa_login_name    
                    ,GETDATE()    
                    ,@pa_login_name    
                    ,GETDATE()    
                    ,1)    
                    --    
                    SET @l_error = @@ERROR    
                    --    
                    IF @l_error > 0    
                    BEGIN    
                    --
                      SELECT @l_accdm_desc     = accdm_desc    
                      FROM   accpm_dtls_mstr   WITH(NOLOCK)    
                      WHERE  accdm_id          = @accdm_id    
                      AND    accdm_deleted_ind = 1  
                      --
                      SET @t_errorstr = '#'+@l_accdm_desc+' could not be inserted/edited'+@rowdelimiter    
                      --
                      ROLLBACK TRANSACTION   
                    --  
                    END    
                    ELSE    
                    BEGIN    
                    --    
                       
                      COMMIT TRANSACTION    
                      --    
                      SET @t_errorstr = 'Account properties successfully inserted/edited'+@rowdelimiter    
                    --    
                    END    
                --
                END
                --
              END
              --
              FETCH next FROM @@c_access_cursor INTO @accpm_prop_id, @accdm_id, @accpd_value, @accdm_cd      
            --
            END
            --
            CLOSE @@c_access_cursor    
            DEALLOCATE @@c_access_cursor
          --  
          END
          --*********************************mak-chk-dtls*****************************************************
          IF @pa_chk_yn = 1 or @pa_chk_yn = 2
          BEGIN
          --

            IF @pa_clisba_id <> 0 and @pa_acct_type <> 'D'
              BEGIN--1
              --
                IF EXISTS(SELECT clisba_crn_no
                          FROM   client_sub_accts_mak
                          WHERE  clisba_id          = @pa_clisba_id
                          AND    clisba_deleted_ind IN(0,4,8))
                BEGIN
                --
                  SELECT @l_clisba_crn_no   = clisba_crn_no
                  FROM   client_sub_accts_mak
                  WHERE  clisba_id          = @pa_clisba_id
                  AND    clisba_deleted_ind IN(0,4,8)
                --
                END
                ELSE
                BEGIN
                --
                  SELECT @l_clisba_crn_no   = clisba_crn_no
                  FROM   client_sub_accts
                  WHERE  clisba_id          = @pa_clisba_id
                  AND    clisba_deleted_ind = 1
                --
                END

              --
              END--1
              --
              IF @pa_clisba_id<>0 and @pa_acct_type = 'D'
              BEGIN--11
              --
                IF EXISTS(SELECT dpam_crn_no
                          FROM   dp_acct_mstr_mak
                          WHERE  dpam_id          = @pa_clisba_id
                          AND    dpam_deleted_ind IN(0,4,8))
                BEGIN
                --
                  SELECT @l_clisba_crn_no   = dpam_crn_no
                  FROM   dp_acct_mstr_mak
                  WHERE  dpam_id          = @pa_clisba_id
                  AND    dpam_deleted_ind IN(0,4,8)
                --
                END
                ELSE
                BEGIN
                --
                  SELECT @l_clisba_crn_no   = dpam_crn_no
                  FROM   dp_acct_mstr
                  WHERE  dpam_id            = @pa_clisba_id
                  AND    dpam_deleted_ind = 1
                --
                END
              --
              END--11

            SET @@c_access_cursor =  CURSOR fast_forward FOR    
            SELECT accpm_prop_id    
                 , accdm_id    
                 , accpd_value
                 , accdm_cd
            FROM   #t_dtls_values     
            --    

            
            OPEN @@c_access_cursor    
            FETCH next FROM @@c_access_cursor INTO @accpm_prop_id, @accdm_id, @accpd_value, @accdm_cd    

            WHILE @@fetch_status = 0    
            BEGIN--cur    
            --
              
            
              SELECT @l_accp_id         = accp_id    
              FROM   accp_mak             WITH(NOLOCK)    
              WHERE  accp_clisba_id     = @pa_clisba_id    
              AND    accp_accpm_prop_id = @accpm_prop_id
              AND    accp_deleted_ind   IN(0,8) 

              IF ISNULL(@l_accp_id,0)=0 
              BEGIN
              --
                SELECT @l_accp_id         = accp_id    
                FROM   account_properties   WITH(NOLOCK)    
                WHERE  accp_clisba_id     = @pa_clisba_id    
                AND    accp_accpm_prop_id = @accpm_prop_id
                AND    accp_deleted_ind   = 1 
              --
              END
              
              IF EXISTS(SELECT accpd_id FROM accpd_mak WHERE accpd_accp_id = @l_accp_id and accpd_accdm_id = @accdm_id)
              BEGIN
              --
                UPDATE accpd_mak
                SET    accpd_deleted_ind = 3
                WHERE  accpd_accp_id     = @l_accp_id 
                AND    accpd_accdm_id    = @accdm_id
                AND    accpd_deleted_ind IN(0,4,8)
                
              --
              END

              IF rtrim(ltrim(@accpd_value)) = ''    
              BEGIN--entpd_value=''    
              --    
                BEGIN TRANSACTION    
                --
                --print 'insert into dtls_mak with deleted index 4'
                
                select @l_accpd_id = ISNULL(MAX(accpd_id),0)+1 FROM accpd_mak
                
                INSERT INTO accpd_mak
                (accpd_id
                ,accpd_accp_id
                ,accpd_accdm_id
                ,accpd_accdm_cd
                ,accpd_value
                ,accpd_created_by
                ,accpd_created_dt
                ,accpd_lst_upd_by
                ,accpd_lst_upd_dt
                ,accpd_deleted_ind
                )
                VALUES
                (@l_accpd_id
                ,@l_accp_id
                ,@accdm_id
                ,@accdm_cd
                ,@accpd_value
                ,@pa_login_name
                ,GETDATE()
                ,@pa_login_name
                ,GETDATE()
                ,4
                )
                
                
                --    
                SET @l_error    = @@ERROR    
                --    
                IF @l_error > 0    
                BEGIN    
                -- 
                  SELECT @l_accdm_desc     = accdm_desc    
                  FROM   accpm_dtls_mstr   WITH(NOLOCK)    
                  WHERE  accdm_id          = @accdm_id    
                  AND    accdm_deleted_ind = 1  
                  --
                  SET @t_errorstr = '#'+@l_accdm_desc+' could not be inserted/edited'+@rowdelimiter    
                  --
                  ROLLBACK TRANSACTION    
                --    
                END    
                ELSE    
                BEGIN    
                --    
                  SET @t_errorstr = 'Account properties successfully inserted/edited'+@rowdelimiter    
                   UPDATE client_mstr set clim_lst_upd_by = @pa_login_name WHERE clim_crn_no =@l_clisba_crn_no AND clim_deleted_ind = 1
                  EXEC pr_ins_upd_list @l_clisba_crn_no, 'D','ACCOUNT PROPERTIES', @pa_login_name, '*|~*', '|*~|', '' 
                  --
                  COMMIT TRANSACTION    
                --    
                END    
                --
                SET @l_accp_id  = null    
              --    
              END--entpd_value=''
              ELSE
              BEGIN
              --
                IF EXISTS(SELECT *    
                          FROM   account_property_dtls with(nolock)    
                          WHERE  accpd_accp_id       = @l_accp_id    
                          AND    accpd_accdm_id      = @accdm_id   
                          and    accpd_deleted_ind   = 1
                          )    or 
                   EXISTS(SELECT *    
                          FROM   accpd_mak             with(nolock)    
                          WHERE  accpd_accp_id       = @l_accp_id    
                          AND    accpd_accdm_id      = @accdm_id   
                          and    accpd_deleted_ind   IN(0,8)
                          )
                BEGIN
                --
                  BEGIN TRANSACTION    
                  --    
                    

                     
                    SELECT @l_accpd_id = ISNULL(MAX(accpd_id),0)+1 FROM accpd_mak

                    INSERT INTO accpd_mak
                    (accpd_id
                    ,accpd_accp_id
                    ,accpd_accdm_id
                    ,accpd_accdm_cd
                    ,accpd_value
                    ,accpd_created_by
                    ,accpd_created_dt
                    ,accpd_lst_upd_by
                    ,accpd_lst_upd_dt
                    ,accpd_deleted_ind
                    )
                    VALUES
                    (@l_accpd_id
                    ,@l_accp_id
                    ,@accdm_id
                    ,@accdm_cd
                    ,@accpd_value
                    ,@pa_login_name
                    ,GETDATE()
                    ,@pa_login_name
                    ,GETDATE()
                    ,8
                    )
                  --    
                  SET @l_error = @@ERROR    
                  --    
                  IF @l_error > 0    
                  BEGIN    
                  --    
                    SELECT @l_accdm_desc     = accdm_desc    
                    FROM   accpm_dtls_mstr   WITH(NOLOCK)    
                    WHERE  accdm_id          = @accdm_id    
                    AND    accdm_deleted_ind = 1  
                    --
                    SET @t_errorstr = '#'+@l_accdm_desc+' could not be inserted/edited'+@rowdelimiter    
                    --
                    ROLLBACK TRANSACTION    
                  --    
                  END    
                  ELSE    
                  BEGIN    
                  --    
                    COMMIT TRANSACTION    
                    --    
                    SET @t_errorstr = 'Account properties successfully inserted/edited'+@rowdelimiter    
                    
                     UPDATE client_mstr set clim_lst_upd_by = @pa_login_name WHERE clim_crn_no =@l_clisba_crn_no AND clim_deleted_ind = 1
                    EXEC pr_ins_upd_list @l_clisba_crn_no, 'E','ACCOUNT PROPERTIES', @pa_login_name, '*|~*', '|*~|', '' 
                  --    
                  END

                --
                END
                ELSE
                BEGIN
                --
                  BEGIN TRANSACTION    
                  --

                  select @l_accpd_id = ISNULL(MAX(accpd_id),0)+1 FROM accpd_mak

                  INSERT INTO accpd_mak
                  (accpd_id
                  ,accpd_accp_id
                  ,accpd_accdm_id
                  ,accpd_accdm_cd
                  ,accpd_value
                  ,accpd_created_by
                  ,accpd_created_dt
                  ,accpd_lst_upd_by
                  ,accpd_lst_upd_dt
                  ,accpd_deleted_ind
                  )
                  VALUES
                  (@l_accpd_id
                  ,@l_accp_id
                  ,@accdm_id
                  ,@accdm_cd
                  ,@accpd_value
                  ,@pa_login_name
                  ,GETDATE()
                  ,@pa_login_name
                  ,GETDATE()
                  ,0
                  )


                  SET @l_error = @@ERROR    
                  --    
                  IF @l_error > 0    
                  BEGIN    
                  --
                    SELECT @l_accdm_desc     = accdm_desc    
                    FROM   accpm_dtls_mstr   WITH(NOLOCK)    
                    WHERE  accdm_id          = @accdm_id    
                    AND    accdm_deleted_ind = 1  
                    --
                    SET @t_errorstr = '#'+@l_accdm_desc+' could not be inserted/edited'+@rowdelimiter    
                    --
                    ROLLBACK TRANSACTION   
                  --  
                  END    
                  ELSE    
                  BEGIN    
                  --    
                    COMMIT TRANSACTION    
                    --    
                    SET @t_errorstr = 'Account properties successfully inserted/edited'+@rowdelimiter    
                     UPDATE client_mstr set clim_lst_upd_by = @pa_login_name WHERE clim_crn_no =@l_clisba_crn_no AND clim_deleted_ind = 1
                    EXEC pr_ins_upd_list @l_clisba_crn_no, 'I','ACCOUNT PROPERTIES', @pa_login_name, '*|~*', '|*~|', '' 
                  --    
                  END    
                --
                END
                --
              END
              --
              FETCH next FROM @@c_access_cursor INTO @accpm_prop_id, @accdm_id, @accpd_value, @accdm_cd      
            --
            END
            --
            CLOSE @@c_access_cursor    
            DEALLOCATE @@c_access_cursor
          --  
          END
          --****************************************8mak-chk-dtls*******************************************
          
        --  
        END
        
        --***********************************MAK-CHK-APP*****************************************************
        IF @pa_action = 'APP'
        BEGIN--app
        --
          SELECT @l_accp_deleted_ind   = accp_deleted_ind
                ,@l_accp_id            = accp_id  
                ,@l_clisba_id          = accp_clisba_id 
                ,@l_accp_acct_no       = accp_acct_no
                ,@l_accp_accpm_prop_id = accp_accpm_prop_id
                ,@l_accp_accpm_prop_cd = accp_accpm_prop_cd
                ,@l_accp_value         = accp_value
                ,@l_acct_type          = acct_type 
          FROM   #accp_mak
          WHERE  accpmak_id          = CONVERT(numeric, @currstring_id)
          --
          
           
          
          IF @l_accp_deleted_ind     = 4 
          BEGIN--4
          --
            IF EXISTS(SELECT * FROM account_property_dtls WHERE accpd_accp_id IN (select @l_accp_id) AND accpd_deleted_ind = 1)                
            BEGIN
            --
              UPDATE account_property_dtls
              SET    accpd_deleted_ind = 0
              WHERE  accpd_accp_id     IN (select @l_accp_id)
              AND    accpd_deleted_ind = 1
            --
            END
            
            UPDATE account_properties
            SET    accp_deleted_ind = 0
            WHERE  accp_accpm_prop_id  = @l_accp_accpm_prop_id
            AND    accp_clisba_id      = @l_clisba_id
            AND    accp_deleted_ind   = 1

            UPDATE accp_mak
            set    accp_deleted_ind = 5
            WHERE  accpmak_id       = CONVERT(numeric, @currstring_id)
            AND    accp_deleted_ind = 4

            SET @l_error = @@ERROR
            --
            IF @l_error > 0
            BEGIN
            --
              SET @t_errorstr = CONVERT(varchar(10), @l_error)
            --
            END
          --
          END  --4
          IF @l_accp_deleted_ind     = 8 
          BEGIN--8
          --
            UPDATE accp 
            SET    accp.accp_value          = accpmak.accp_value    
                 , accp.accp_lst_upd_by     = @pa_login_name    
                 , accp.accp_lst_upd_dt     = GETDATE()    
            FROM   account_properties accp
                 , #accp_mak          accpmak  
            WHERE  accp.accp_clisba_id      = @l_clisba_id    
            AND    accp.accp_accpm_prop_id  = @l_accp_accpm_prop_id    
            AND    accp.accp_deleted_ind    = 1
            AND    accp.accp_id             = @l_accp_id
            AND    accpmak.accpmak_id          = CONVERT(numeric, @currstring_id)
                      
            UPDATE accp_mak
            set    accp_deleted_ind = 9
            WHERE  accpmak_id       = CONVERT(numeric, @currstring_id)
            AND    accp_deleted_ind = 8

          SET @@c_accpd =  CURSOR FAST_FORWARD FOR    
          SELECT accpd_id
               , accpd_accp_id
               , accpd_accdm_id
               , accpd_accdm_cd
               , accpd_value
               , accpd_created_by
               , accpd_created_dt
               , accpd_deleted_ind 
          FROM   #accp_dtls_mak
          WHERE accpd_accp_id = @l_accp_id       --CHANGED BY TUSHAR JMM
          --
          OPEN @@c_accpd    
          --
          FETCH NEXT FROM @@c_accpd INTO @l_accpd_id, @l_accpd_accp_id, @l_accpd_accdm_id, @l_accpd_accdm_cd, @l_accpd_value, @l_accpd_created_by, @l_accpd_created_dt,@l_accpd_deleted_ind    
          --
          WHILE @@fetch_status = 0    
          BEGIN--cur    
          --
            IF @l_accpd_deleted_ind = 0 
            BEGIN
            --
              UPDATE accpd_mak   WITH (ROWLOCK)  
              SET    accpd_deleted_ind        = 1
                   , accpd_lst_upd_by         = @pa_login_name
                   , accpd_lst_upd_dt         = GETDATE()
              WHERE  accpd_deleted_ind        = 0
              AND    accpd_id                 = @l_accpd_id
              --
              SET @l_error = @@ERROR
              --
              IF @l_error > 0
              BEGIN
              --
                SET @t_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
                --
                INSERT INTO account_property_dtls
                ( accpd_accp_id
                , accpd_accdm_id
                , accpd_accdm_cd
                , accpd_value
                , accpd_created_by
                , accpd_created_dt
                , accpd_lst_upd_by
                , accpd_lst_upd_dt
                , accpd_deleted_ind
                )
                VALUES
                ( @l_accpd_accp_id
                , @l_accpd_accdm_id
                , @l_accpd_accdm_cd
                , @l_accpd_value
                , @l_accpd_created_by
                , @l_accpd_created_dt
                , @pa_login_name
                , GETDATE()
                , 1
                )
                --
                SET @l_error = @@ERROR
                --
                IF @l_error > 0
                BEGIN
                --
                  SET @t_errorstr = CONVERT(varchar(10), @l_error)
                  --
                  --ROLLBACK TRANSACTION
                --
                END

            --
            END
            IF @l_accpd_deleted_ind = 4 --@l_entp_id = @l_entpd_entp_id 
            BEGIN
            --
              UPDATE accpd_mak   WITH (ROWLOCK)  
              SET    accpd_deleted_ind        = 5
                   , accpd_lst_upd_by         = @pa_login_name
                   , accpd_lst_upd_dt         = GETDATE()
              WHERE  accpd_deleted_ind        = 4
              AND    accpd_id                 = @l_accpd_id
              --
              SET @l_error = @@ERROR
              --
              IF @l_error > 0
              BEGIN
              --
                SET @t_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
              --
                UPDATE account_property_dtls
                SET    accpd_deleted_ind = 0
                WHERE  accpd_accp_id     = @l_accpd_accp_id
                AND    accpd_deleted_ind = 1
                AND    accpd_accdm_id    = @l_accpd_accdm_id                  
              --
              SET @l_error = @@ERROR
              --
              IF @l_error > 0
              BEGIN
              --
                SET @t_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
            --
            END
            IF @l_accpd_deleted_ind = 8 --@l_entp_id = @l_entpd_entp_id 
            BEGIN
            --
              UPDATE accpd_mak   WITH (ROWLOCK)  
              SET    accpd_deleted_ind        = 9
                   , accpd_lst_upd_by         = @pa_login_name
                   , accpd_lst_upd_dt         = GETDATE()
              WHERE  accpd_deleted_ind        = 8
              AND    accpd_id                 = @l_accpd_id
              --
              SET @l_error = @@ERROR
              --
              IF @l_error > 0
              BEGIN
              --
                SET @t_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
              --
                UPDATE account_property_dtls
                SET    accpd_value       = @l_accpd_value
                      ,accpd_lst_upd_by  = @pa_login_name
                      ,accpd_lst_upd_dt  = GETDATE()
                WHERE  accpd_accp_id     = @l_accpd_accp_id
                AND    accpd_deleted_ind = 1
                AND    accpd_accdm_id    = @l_accpd_accdm_id                  
              --
              SET @l_error = @@ERROR
              --
              IF @l_error > 0
              BEGIN
              --
                SET @t_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
            --
            END
        
            FETCH NEXT FROM @@c_accpd INTO @l_accpd_id, @l_accpd_accp_id, @l_accpd_accdm_id, @l_accpd_accdm_cd, @l_accpd_value, @l_accpd_created_by, @l_accpd_created_dt,@l_accpd_deleted_ind    
                 
          --
          END  
          CLOSE @@c_accpd    
          DEALLOCATE @@c_accpd



            SET @l_error = @@ERROR
            --
            IF @l_error > 0
            BEGIN
            --
              SET @t_errorstr = CONVERT(varchar(10), @l_error)
            --
            END
          --
          END  --8
          IF @l_accp_deleted_ind     = 1
          BEGIN--1
          --

          SELECT accpd_id
               , accpd_accp_id
               , accpd_accdm_id
               , accpd_accdm_cd
               , accpd_value
               , accpd_created_by
               , accpd_created_dt
               , accpd_deleted_ind 
          FROM   #accp_dtls_mak
          WHERE accpd_accp_id = @l_accp_id       --CHANGED BY TUSHAR JMM


          SET @@c_accpd =  CURSOR FAST_FORWARD FOR    
          SELECT accpd_id
               , accpd_accp_id
               , accpd_accdm_id
               , accpd_accdm_cd
               , accpd_value
               , accpd_created_by
               , accpd_created_dt
               , accpd_deleted_ind 
          FROM   #accp_dtls_mak
          WHERE accpd_accp_id = @l_accp_id       --CHANGED BY TUSHAR JMM

          --
          OPEN @@c_accpd    
          --
          FETCH NEXT FROM @@c_accpd INTO @l_accpd_id, @l_accpd_accp_id, @l_accpd_accdm_id, @l_accpd_accdm_cd, @l_accpd_value, @l_accpd_created_by, @l_accpd_created_dt,@l_accpd_deleted_ind    
          --
          WHILE @@fetch_status = 0    
          BEGIN--cur    
          --
            IF @l_accpd_deleted_ind = 0 
            BEGIN
            --
              UPDATE accpd_mak   WITH (ROWLOCK)  
              SET    accpd_deleted_ind        = 1
                   , accpd_lst_upd_by         = @pa_login_name
                   , accpd_lst_upd_dt         = GETDATE()
              WHERE  accpd_deleted_ind        = 0
              AND    accpd_id                 = @l_accpd_id
              --
              SET @l_error = @@ERROR
              --
              IF @l_error > 0
              BEGIN
              --
                SET @t_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
                --
                INSERT INTO account_property_dtls
                ( accpd_accp_id
                , accpd_accdm_id
                , accpd_accdm_cd
                , accpd_value
                , accpd_created_by
                , accpd_created_dt
                , accpd_lst_upd_by
                , accpd_lst_upd_dt
                , accpd_deleted_ind
                )
                VALUES
                ( @l_accpd_accp_id
                , @l_accpd_accdm_id
                , @l_accpd_accdm_cd
                , @l_accpd_value
                , @l_accpd_created_by
                , @l_accpd_created_dt
                , @pa_login_name
                , GETDATE()
                , 1
                )
                --
                SET @l_error = @@ERROR
                --
                IF @l_error > 0
                BEGIN
                --
                  SET @t_errorstr = CONVERT(varchar(10), @l_error)
                  --
                  --ROLLBACK TRANSACTION
                --
                END

            --
            END
            IF @l_accpd_deleted_ind = 4 --@l_entp_id = @l_entpd_entp_id 
            BEGIN
            --
              UPDATE accpd_mak   WITH (ROWLOCK)  
              SET    accpd_deleted_ind        = 5
                   , accpd_lst_upd_by         = @pa_login_name
                   , accpd_lst_upd_dt         = GETDATE()
              WHERE  accpd_deleted_ind        = 4
              AND    accpd_id                 = @l_accpd_id
              --
              SET @l_error = @@ERROR
              --
              IF @l_error > 0
              BEGIN
              --
                SET @t_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
              --
                UPDATE account_property_dtls
                SET    accpd_deleted_ind = 0
                WHERE  accpd_accp_id     = @l_accpd_accp_id
                AND    accpd_deleted_ind = 1
                AND    accpd_accdm_id    = @l_accpd_accdm_id                  
              --
              SET @l_error = @@ERROR
              --
              IF @l_error > 0
              BEGIN
              --
                SET @t_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
            --
            END
            IF @l_accpd_deleted_ind = 8 --@l_entp_id = @l_entpd_entp_id 
            BEGIN
            --
              UPDATE accpd_mak   WITH (ROWLOCK)  
              SET    accpd_deleted_ind        = 9
                   , accpd_lst_upd_by         = @pa_login_name
                   , accpd_lst_upd_dt         = GETDATE()
              WHERE  accpd_deleted_ind        = 8
              AND    accpd_id                 = @l_accpd_id
              --
              SET @l_error = @@ERROR
              --
              IF @l_error > 0
              BEGIN
              --
                SET @t_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
              --
                UPDATE account_property_dtls
                SET    accpd_value       = @l_accpd_value
                      ,accpd_lst_upd_by  = @pa_login_name
                      ,accpd_lst_upd_dt  = GETDATE()
                WHERE  accpd_accp_id     = @l_accpd_accp_id
                AND    accpd_deleted_ind = 1
                AND    accpd_accdm_id    = @l_accpd_accdm_id                  
              --
              SET @l_error = @@ERROR
              --
              IF @l_error > 0
              BEGIN
              --
                SET @t_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
            --
            END
        
            FETCH NEXT FROM @@c_accpd INTO @l_accpd_id, @l_accpd_accp_id, @l_accpd_accdm_id, @l_accpd_accdm_cd, @l_accpd_value, @l_accpd_created_by, @l_accpd_created_dt,@l_accpd_deleted_ind    
                 
          --
          END  
          CLOSE @@c_accpd    
          DEALLOCATE @@c_accpd



            SET @l_error = @@ERROR
            --
            IF @l_error > 0
            BEGIN
            --
              SET @t_errorstr = CONVERT(varchar(10), @l_error)
            --
            END
          --
          END  --1

          IF @l_accp_deleted_ind     = 0 
          BEGIN--0
          --
            
           INSERT INTO account_properties    
            (accp_id    
            ,accp_clisba_id    
            ,accp_acct_no    
            ,accp_acct_type
            ,accp_accpm_prop_id    
            ,accp_accpm_prop_cd    
            ,accp_value    
            ,accp_created_by    
            ,accp_created_dt    
            ,accp_lst_upd_by    
            ,accp_lst_upd_dt    
            ,accp_deleted_ind    
            )    
            select accp_id
			  , accp_clisba_id
			  , accp_acct_no
              , acct_type 
			  , accp_accpm_prop_id
			  , accp_accpm_prop_cd
			  , accp_value        
			  ,@PA_LOGIN_NAME
              ,GETDATE() 
              ,@PA_LOGIN_NAME
              ,GETDATE() 
              , 1
            FROM   #accp_mak
            WHERE  accpmak_id          = CONVERT(numeric, @currstring_id)
                
            -- 
            UPDATE accp_mak
            set    accp_deleted_ind = 1
            WHERE  accpmak_id       = CONVERT(numeric, @currstring_id)
            AND    accp_deleted_ind = 0
            
            SET @l_error = @@ERROR
            --
            IF @l_error > 0
            BEGIN
            --
              SET @t_errorstr = CONVERT(varchar(10), @l_error)
            --
            END

          --
          END  --0
          

          SET @@c_accpd =  CURSOR FAST_FORWARD FOR    
          SELECT accpd_id
               , accpd_accp_id
               , accpd_accdm_id
               , accpd_accdm_cd
               , accpd_value
               , accpd_created_by
               , accpd_created_dt
               , accpd_deleted_ind 
          FROM   #accp_dtls_mak
          WHERE accpd_accp_id = @l_accp_id       --CHANGED BY TUSHAR JMM
          --
          OPEN @@c_accpd    
          --
          FETCH NEXT FROM @@c_accpd INTO @l_accpd_id, @l_accpd_accp_id, @l_accpd_accdm_id, @l_accpd_accdm_cd, @l_accpd_value, @l_accpd_created_by, @l_accpd_created_dt,@l_accpd_deleted_ind    
          --
          WHILE @@fetch_status = 0    
          BEGIN--cur    
          --
            IF @l_accpd_deleted_ind = 0 
            BEGIN
            --
              UPDATE accpd_mak   WITH (ROWLOCK)  
              SET    accpd_deleted_ind        = 1
                   , accpd_lst_upd_by         = @pa_login_name
                   , accpd_lst_upd_dt         = GETDATE()
              WHERE  accpd_deleted_ind        = 0
              AND    accpd_id                 = @l_accpd_id
              --
              SET @l_error = @@ERROR
              --
              IF @l_error > 0
              BEGIN
              --
                SET @t_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
                --
                INSERT INTO account_property_dtls
                ( accpd_accp_id
                , accpd_accdm_id
                , accpd_accdm_cd
                , accpd_value
                , accpd_created_by
                , accpd_created_dt
                , accpd_lst_upd_by
                , accpd_lst_upd_dt
                , accpd_deleted_ind
                )
                VALUES
                ( @l_accpd_accp_id
                , @l_accpd_accdm_id
                , @l_accpd_accdm_cd
                , @l_accpd_value
                , @l_accpd_created_by
                , @l_accpd_created_dt
                , @pa_login_name
                , GETDATE()
                , 1
                )
                --
                SET @l_error = @@ERROR
                --
                IF @l_error > 0
                BEGIN
                --
                  SET @t_errorstr = CONVERT(varchar(10), @l_error)
                  --
                  --ROLLBACK TRANSACTION
                --
                END

            --
            END
            IF @l_accpd_deleted_ind = 4 --@l_entp_id = @l_entpd_entp_id 
            BEGIN
            --
              UPDATE accpd_mak   WITH (ROWLOCK)  
              SET    accpd_deleted_ind        = 5
                   , accpd_lst_upd_by         = @pa_login_name
                   , accpd_lst_upd_dt         = GETDATE()
              WHERE  accpd_deleted_ind        = 4
              AND    accpd_id                 = @l_accpd_id
              --
              SET @l_error = @@ERROR
              --
              IF @l_error > 0
              BEGIN
              --
                SET @t_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
              --
               

                UPDATE account_property_dtls
                SET    accpd_deleted_ind = 0
                WHERE  accpd_accp_id     = @l_accpd_accp_id
                AND    accpd_deleted_ind = 1
                AND    accpd_accdm_id    = @l_accpd_accdm_id                  
              --
              SET @l_error = @@ERROR
              --
              IF @l_error > 0
              BEGIN
              --
                SET @t_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
            --
            END
            IF @l_accpd_deleted_ind = 8 --@l_entp_id = @l_entpd_entp_id 
            BEGIN
            --
              UPDATE accpd_mak   WITH (ROWLOCK)  
              SET    accpd_deleted_ind        = 9
                   , accpd_lst_upd_by         = @pa_login_name
                   , accpd_lst_upd_dt         = GETDATE()
              WHERE  accpd_deleted_ind        = 8
              AND    accpd_id                 = @l_accpd_id
              --
              SET @l_error = @@ERROR
              --
              IF @l_error > 0
              BEGIN
              --
                SET @t_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
              --
                UPDATE account_property_dtls
                SET    accpd_value       = @l_accpd_value
                      ,accpd_lst_upd_by  = @pa_login_name
                      ,accpd_lst_upd_dt  = GETDATE()
                WHERE  accpd_accp_id     = @l_accpd_accp_id
                AND    accpd_deleted_ind = 1
                AND    accpd_accdm_id    = @l_accpd_accdm_id                  
              --
              SET @l_error = @@ERROR
              --
              IF @l_error > 0
              BEGIN
              --
                SET @t_errorstr = CONVERT(varchar(10), @l_error)
              --
              END
            --
            END
        
            FETCH NEXT FROM @@c_accpd INTO @l_accpd_id, @l_accpd_accp_id, @l_accpd_accdm_id, @l_accpd_accdm_cd, @l_accpd_value, @l_accpd_created_by, @l_accpd_created_dt,@l_accpd_deleted_ind    
                 
          --
          END  
          CLOSE @@c_accpd    
          DEALLOCATE @@c_accpd
        --
        END
        --************************************MAK-CHK-APP*****************************************************/
        --
        --
        END
      --
      END
      --
      SET @pa_msg = @t_errorstr 
    --
    END

GO
