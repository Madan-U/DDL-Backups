-- Object: PROCEDURE citrus_usr.pr_ins_upd_cliba
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE  PROCEDURE [citrus_usr].[pr_ins_upd_cliba](@pa_id                varchar(8000)      
                                 ,@pa_action            varchar(20)      
                                 ,@pa_login_name        varchar(20)      
                                 ,@pa_ent_id            numeric      
                                 ,@pa_values            varchar(8000)      
                                 ,@pa_chk_yn            numeric      
                                 ,@rowdelimiter         char(4)  = '*|~*'      
                                 ,@coldelimiter         char(4)  = '|*~|'      
                                 ,@pa_msg               varchar(8000) output      
)      
as      
/*      
*********************************************************************************      
 system         : Citrus      
 module name    : pr_ins_upd_cliba      
 description    : this procedure will add new client details VALUES to  client_bank_accts      
 copyright(c)   : marketplace technologies pvt. Ltd.      
 version history: 1.0      
 vers.  author            date         reason      
 -----  -------------     ----------   ------------------------------------------      
 1.0    sukhvinder/tushar 04-oct-2006  initial version.      
 --------------------------------------------------------------------------------      
*********************************************************************************      
*/      
BEGIN--#1      
--      
  SET NOCOUNT ON      
  --      
  DECLARE @t_errorstr            varchar(8000)      
        , @l_error               bigint      
        , @delimeter             varchar(5)      
        , @remainingstring       varchar(8000)      
        , @currstring            varchar(8000)      
        , @remainingstring2      varchar(8000)      
        , @currstring2           varchar(8000)      
        , @foundat               integer      
        , @delimeterlength       int      
        , @l_counter             int      
        , @l_flg                 int      
        ---      
        , @@l_compm_id           numeric      
        , @@l_excsm_id           numeric      
        , @@l_cliba_acct_no      varchar(20)      
        , @@l_clisba_acct_no     varchar(20)      
        , @@l_cliba_ac_name      varchar(100)       
        , @@l_cliba_banm_id      numeric      
        , @@l_cliba_ac_type      varchar(20)      
        , @@l_cliba_ac_no        varchar(20)       
        , @@l_cliba_flg          int      
        , @@l_action_type        varchar(10)      
        ---      
        , @l_cliba_id            numeric      
        , @l_cliba_banm_id       numeric      
        , @l_cliba_clisba_id     numeric      
        , @l_cliba_compm_id      numeric      
        , @l_cliba_ac_no         varchar(20)      
        , @l_cliba_ac_type       varchar(20)      
        , @l_cliba_ac_name       varchar(100)      
        , @l_cliba_flg           int      
        , @l_cliba_deleted_ind   int      
        , @@l_bitrm_bit_location int      
        , @@l_cliba_def_flg      int      
        , @@l_cliba_poa_flg      int      
        , @l_cliba_poa_flg       int      
        , @l_cliba_def_flg       int      
        , @@l_deleted_ind        int      
        , @@l_clisba_id          numeric      
        , @l_action              char(1)      
        , @l_crn_no              varchar(10)           
        , @L_EDT_DEL_ID           NUMERIC      
        --      
      /* , @l_clisba_acct_no  VARCHAR(25)       
       , @l_clisba_no          VARCHAR(25)       
       , @l_clisba_id           NUMERIC      
       , @l_clisba_crn_no    numeric  */      
        --      
  --       
  SET @l_crn_no     = @pa_ent_id      
  SET @l_flg        = 0      
  set @@l_cliba_flg = 0      
  SET @t_errorstr  = ''            
  --      
  IF @pa_action     = 'APP' or @pa_action = 'REJ'      
  BEGIN--a      
  --        
    CREATE TABLE #t_mak      
    (cliba_id            numeric      
    ,cliba_banm_id       numeric      
    ,cliba_clisba_id     numeric      
    ,cliba_compm_id      numeric      
    ,cliba_ac_no         varchar(20)      
    ,cliba_ac_type       varchar(20)      
    ,cliba_ac_name       varchar(150)      
    ,cliba_flg           int      
    ,cliba_deleted_ind   int      
    )      
    INSERT INTO #t_mak(cliba_id      
                      ,cliba_banm_id      
                      ,cliba_clisba_id      
                      ,cliba_compm_id      
       ,cliba_ac_no      
                      ,cliba_ac_type      
                      ,cliba_ac_name      
                      ,cliba_flg      
                      ,cliba_deleted_ind      
                      )      
    --                        
    SELECT cliba_id      
         , cliba_banm_id      
         , cliba_clisba_id      
         , cliba_compm_id      
         , cliba_ac_no      
         , cliba_ac_type      
         , cliba_ac_name      
         , cliba_flg      
         , cliba_deleted_ind      
    FROM   client_bank_accts_mak WITH (NOLOCK)      
    WHERE  cliba_deleted_ind IN (0,4,8)      
    --AND    cliba_created_by      <> @pa_login_name      
  --        
  END--a      
  ELSE      
  BEGIN--b      
  --      
    CREATE TABLE #t_mstr      
    (cliba_banm_id       numeric      
    ,cliba_clisba_id     numeric      
    ,cliba_compm_id      numeric      
    ,cliba_ac_no         varchar(20)      
    ,cliba_ac_type       varchar(20)      
    ,cliba_ac_name       varchar(50)      
    ,cliba_flg           int      
    ,cliba_deleted_ind   int      
    )      
    --      
    INSERT INTO #t_mstr(cliba_banm_id          
                       ,cliba_clisba_id        
                       ,cliba_compm_id         
                       ,cliba_ac_no            
                       ,cliba_ac_type          
                       ,cliba_ac_name          
                       ,cliba_flg              
                       ,cliba_deleted_ind      
                       )      
    --                        
    SELECT cliba_banm_id          
         , cliba_clisba_id        
         , cliba_compm_id         
         , cliba_ac_no            
         , cliba_ac_type          
         , cliba_ac_name          
         , cliba_flg              
         , cliba_deleted_ind      
    FROM   client_bank_accts WITH (NOLOCK)      
    WHERE  cliba_deleted_ind = 1      
  --                                
  END--b      
  --      
  IF ISNULL(@pa_id,'') <> '' AND ISNULL(@pa_action,'') <> '' AND ISNULL(@pa_login_name,'') <> ''      
  BEGIN--<>''      
  --      
    SET @l_error           = 0      
    SET @t_errorstr        = ''      
    SET @delimeter          = '%'+ @rowdelimiter + '%'      
    SET @delimeterlength   = len(@rowdelimiter)      
    SET @remainingstring2  = @pa_id      
    --      
    WHILE @remainingstring2 <> ''      
    BEGIN      
    --      
      SET @foundat        = 0      
      SET @foundat        =  patindex('%'+@delimeter+'%',@remainingstring2)      
      --      
      IF @foundat > 0      
      BEGIN      
      --      
        SET @currstring2      = substring(@remainingstring2, 0,@foundat)      
        SET @remainingstring2 = substring(@remainingstring2, @foundat+@delimeterlength,len(@remainingstring2)- @foundat+@delimeterlength)      
      --      
      END      
      ELSE      
      BEGIN      
      --      
        SET @currstring2      = @remainingstring2      
        SET @remainingstring2 = ''      
      --      
      END      
      --      
      IF @currstring2 <> ''      
      BEGIN--curr_id      
      --pa_id--      
        SET @delimeter        = '%'+ @rowdelimiter + '%'      
        SET @delimeterlength = len(@rowdelimiter)      
        SET @remainingstring = @pa_values      
        --      
        WHILE @remainingstring <> ''      
        BEGIN--VAL      
        --      
          SET @foundat       = 0      
          SET @foundat       =  patindex('%'+@delimeter+'%',@remainingstring)      
          --      
          IF @foundat > 0      
          BEGIN      
          --      
            SET @currstring      = substring(@remainingstring, 0,@foundat)      
            SET @remainingstring = substring(@remainingstring, @foundat+@delimeterlength,len(@remainingstring)- @foundat+@delimeterlength)      
          --      
          END      
          ELSE      
          BEGIN      
          --      
            SET @currstring      = @remainingstring      
            SET @remainingstring = ''      
          --      
          END      
   --      
          IF @currstring <> ''      
          BEGIN--curr_val      
          --      
            SET @@l_compm_id       = citrus_usr.fn_splitval(@currstring,1)      
            SET @@l_excsm_id       = citrus_usr.fn_splitval(@currstring,2)      
            SET @@l_cliba_acct_no  = citrus_usr.fn_splitval(@currstring,3)      
            SET @@l_clisba_acct_no = citrus_usr.fn_splitval(@currstring,4)      
            SET @@l_cliba_ac_name  = citrus_usr.fn_splitval(@currstring,5)      
            SET @@l_cliba_banm_id  = citrus_usr.fn_splitval(@currstring,6)      
            SET @@l_cliba_ac_type  = citrus_usr.fn_splitval(@currstring,7)      
            SET @@l_cliba_ac_no    = citrus_usr.fn_splitval(@currstring,8)      
            SET @@l_cliba_def_flg  = CONVERT(int,citrus_usr.fn_splitval(@currstring,9))      
            SET @@l_cliba_poa_flg  = CONVERT(int,citrus_usr.fn_splitval(@currstring, 10))      
            SET @@l_action_type    = citrus_usr.fn_splitval(@currstring,11)      
            --      
                  
            SET  @@l_clisba_id = NULL      
                  
            /*SELECT @@l_clisba_id      = clisba_id      
            FROM   client_sub_accts   WITH (NOLOCK)      
            WHERE  clisba_crn_no      = @pa_ent_id      
            AND    clisba_acct_no     = @@l_cliba_acct_no      
            AND    clisba_no          = @@l_clisba_acct_no      
            AND    clisba_deleted_ind = 1  */    
                
                
  SELECT @@l_clisba_id      = clisba_id        
  FROM   client_sub_accts   WITH (NOLOCK)        
       , exch_seg_mstr      WITH (NOLOCK)        
       , excsm_prod_mstr    WITH (NOLOCK)        
       , product_mstr       WITH (NOLOCK)        
  WHERE  clisba_crn_no      = @pa_ent_id        
  AND    clisba_acct_no     = @@l_cliba_acct_no        
  AND    clisba_no          = @@l_clisba_acct_no        
  AND    excpm_excsm_id     = excsm_id        
  AND    excpm_prom_id      = prom_id        
  AND    excsm_id           = @@l_excsm_id        
  AND    excpm_id           = clisba_excpm_id        
  AND    prom_cd            = right(@@l_clisba_acct_no,2)        
  AND    clisba_deleted_ind = 1        
    
            --      
            IF @PA_CHK_YN = 0      
            BEGIN--CHK_YN=0      
            --      
              IF @@l_action_type = 'A'      
              BEGIN--A_0      
              --      
                BEGIN TRANSACTION      
                --      
                /*IF @@l_cliba_flg = 1      
                BEGIN--FLG=1      
                --      
                  SELECT @@l_bitrm_bit_location = bitrm_bit_location      
                  FROM   bitmap_ref_mstr  WITH (NOLOCK)      
                  WHERE  bitrm_parent_cd        = 'BANK'      
                  AND    bitrm_child_cd         = 'DEF_FLG'      
                  --      
                  SET  @@l_cliba_flg            = power(2,@@l_bitrm_bit_location-1) | @@l_cliba_flg      
                --      
                END  --FLG=1*/      
                --      
                IF @@l_cliba_poa_flg = 1      
                BEGIN      
                --      
                  SELECT @@l_bitrm_bit_location = bitrm_bit_location      
                  FROM   bitmap_ref_mstr        WITH (NOLOCK)      
                  WHERE  bitrm_parent_cd        = 'BANK'      
                  AND    bitrm_child_cd         = 'POA_FLG'      
                  --      
                  SET @@l_cliba_flg = power(2,@@l_bitrm_bit_location-1) | @@l_cliba_flg      
                --      
                END      
 --      
                IF @@l_cliba_def_flg = 1      
                BEGIN      
                --      
                  SELECT @@l_bitrm_bit_location = bitrm_bit_location      
                  FROM   bitmap_ref_mstr        WITH (NOLOCK)      
                  WHERE  bitrm_parent_cd        = 'BANK'      
                  AND    bitrm_child_cd         = 'DEF_FLG'      
                  --      
                  SET @@l_cliba_flg = power(2, @@l_bitrm_bit_location-1) | @@l_cliba_flg      
                --      
                END      
                --      
   INSERT into client_bank_accts      
                (cliba_banm_id      
                ,cliba_clisba_id      
                ,cliba_compm_id      
                ,cliba_ac_no      
                ,cliba_ac_type      
                ,cliba_ac_name      
                ,cliba_flg      
                ,cliba_created_by      
                ,cliba_created_dt      
                ,cliba_lst_upd_by      
                ,cliba_lst_upd_dt      
                ,cliba_deleted_ind      
                )      
                VALUES      
                (@@l_cliba_banm_id      
                ,@@l_clisba_id      
                ,@@l_compm_id      
                ,@@l_cliba_ac_no      
                ,@@l_cliba_ac_type      
                ,@@l_cliba_ac_name      
                --,@@l_cliba_def_flg       
                ,@@l_cliba_flg      
                ,@pa_login_name      
                ,GETDATE()      
                ,@pa_login_name      
                ,GETDATE()      
                ,1      
                )      
                --      
                SET @l_error = @@error      
                --      
                IF @l_error > 0      
                BEGIN      
                --      
                  SET @t_errorstr = '#'+'could not change access for ' + convert(varchar, @@l_cliba_ac_name) + ISNULL(@t_errorstr,'')      
                  --      
                  ROLLBACK TRANSACTION      
                --      
      END      
                ELSE      
                BEGIN      
                --      
                  SET @t_errorstr = 'client bank account successfully inserted\edited '+ @rowdelimiter      
                  --      
                  COMMIT TRANSACTION      
                --      
                END      
              --      
              END--A_0      
              --      
              IF @@l_action_type = 'E'      
              BEGIN--e_0      
              --      
                SELECT @l_cliba_ac_type = cliba_ac_type      
                      ,@l_cliba_ac_name = cliba_ac_name      
                      --,@l_cliba_flg     = cliba_flg      
                      ,@l_cliba_poa_flg = cliba_flg & 1      
                      ,@l_cliba_def_flg = cliba_flg & 2      
                FROM   #t_mstr      
                WHERE  cliba_banm_id    = @@l_cliba_banm_id      
                AND    cliba_compm_id   = @@l_compm_id      
                AND    cliba_clisba_id  = @@l_clisba_id      
                AND    cliba_ac_no      = @@l_cliba_ac_no      
                --      
                IF (@@l_cliba_ac_type     = @l_cliba_ac_type)       
                   AND (@@l_cliba_ac_name = @l_cliba_ac_name)       
                   AND (@@l_cliba_def_flg = @l_cliba_def_flg)      
                   AND (@@l_cliba_poa_flg = @l_cliba_poa_flg)      
                BEGIN--NOT_EXITS      
                --      
                  BEGIN TRANSACTION      
                  --      
                  IF @@l_cliba_poa_flg = 1      
                  BEGIN      
                  --      
                    SELECT @@l_bitrm_bit_location = bitrm_bit_location      
                    FROM   bitmap_ref_mstr WITH (NOLOCK)      
                    WHERE  bitrm_parent_cd        = 'BANK'      
                    AND    bitrm_child_cd         = 'POA_FLG'      
                    --      
                    SET @@l_cliba_flg            = power(2, @@l_bitrm_bit_location-1) | @@l_cliba_flg      
                  --      
                  END      
                  --      
                  IF @@l_cliba_def_flg = 1      
                  BEGIN      
                  --      
                    SELECT @@l_bitrm_bit_location = bitrm_bit_location      
                    FROM   bitmap_ref_mstr WITH (NOLOCK)      
                    WHERE  bitrm_parent_cd        = 'BANK'      
                    AND    bitrm_child_cd         = 'DEF_FLG'      
                    --      
                    SET @@l_cliba_flg            = power(2, @@l_bitrm_bit_location - 1) | @@l_cliba_flg      
                  --      
                  END      
                  --      
                  INSERT into client_bank_accts      
                  (cliba_banm_id      
                  ,cliba_clisba_id      
                  ,cliba_compm_id      
                  ,cliba_ac_no      
                  ,cliba_ac_type      
                  ,cliba_ac_name      
                  ,cliba_flg      
                  ,cliba_created_by      
                  ,cliba_created_dt      
                  ,cliba_lst_upd_by      
                  ,cliba_lst_upd_dt      
                  ,cliba_deleted_ind      
                  )      
                  VALUES      
                  (@@l_cliba_banm_id      
                  ,@@l_clisba_id      
                  ,@@l_compm_id      
                  ,@@l_cliba_ac_no      
                  ,@@l_cliba_ac_type      
                  ,@@l_cliba_ac_name      
                  ,@@l_cliba_flg      
                  ,@pa_login_name      
                  ,GETDATE()      
                  ,@pa_login_name      
                  ,GETDATE()      
                  ,1      
                  )      
                  --      
                  SET @l_error = @@error      
                  --      
                  IF @l_error > 0      
                  BEGIN      
                  --      
                    SET @t_errorstr = '#'+'could not change access for ' + convert(varchar, @@l_cliba_ac_name) + ISNULL(@t_errorstr,'')      
                    --      
                    ROLLBACK TRANSACTION      
                  --      
                  END      
                  ELSE      
                  BEGIN      
                  --      
                   SET @t_errorstr = 'client bank account successfully inserted\edited '+ @rowdelimiter      
                   --      
             COMMIT TRANSACTION      
                  --      
                  END      
                --      
                END--NOT_EXITS      
                ELSE      
                BEGIN--EXIST      
                --      
                  BEGIN TRANSACTION      
                  --      
                  IF @@l_cliba_poa_flg = 1      
                  BEGIN      
                  --      
                    SELECT @@l_bitrm_bit_location = bitrm_bit_location      
                    FROM   bitmap_ref_mstr WITH (NOLOCK)      
                    WHERE  bitrm_parent_cd        = 'BANK'      
                    AND    bitrm_child_cd         = 'POA_FLG'      
                    --      
                    SET @@l_cliba_flg             = power(2, @@l_bitrm_bit_location-1) | @@l_cliba_flg      
                  --      
                  END      
                  --      
                  IF @@l_cliba_def_flg = 1      
                  BEGIN      
                  --      
                    SELECT @@l_bitrm_bit_location = bitrm_bit_location      
                    FROM   bitmap_ref_mstr WITH (NOLOCK)      
                    WHERE  bitrm_parent_cd        = 'BANK'      
                    AND    bitrm_child_cd         = 'DEF_FLG'      
                    --      
                    SET @@l_cliba_flg             = power(2, @@l_bitrm_bit_location - 1) | @@l_cliba_flg      
                  --      
                  END      
                  --      
                  DELETE FROM #t_mstr      
                  WHERE  cliba_ac_no = @@l_cliba_ac_no      
       --      
                  UPDATE client_bank_accts   WITH(ROWLOCK)      
                  SET    cliba_ac_type     = @@l_cliba_ac_type      
                        ,cliba_ac_name     = @@l_cliba_ac_name      
                        ,cliba_flg         = @@l_cliba_flg      
                        ,cliba_lst_upd_by  = @pa_login_name      
                        ,cliba_lst_upd_dt  = GETDATE()      
                  WHERE  cliba_banm_id     = @@l_cliba_banm_id      
                  AND    cliba_clisba_id   = @@l_clisba_id      
                  AND    cliba_compm_id    = @@l_compm_id      
                  AND    cliba_ac_no       = @@l_cliba_ac_no      
                  AND    cliba_deleted_ind = 1      
                  --      
                  SET @l_error = @@error      
                  --      
                  IF @l_error > 0      
                  BEGIN      
                  --      
                   SET @t_errorstr = '#'+'could not change access for ' + convert(varchar, @@l_cliba_ac_name) + ISNULL(@t_errorstr,'')      
                   --      
                   ROLLBACK TRANSACTION      
                  --      
                  END      
                  ELSE      
                  BEGIN      
                  --      
                    SET @t_errorstr = 'client bank account successfully inserted\edited '+ @rowdelimiter      
                    --      
                    COMMIT TRANSACTION      
                  --      
                  END      
                --      
                END  --EXIST      
              --      
              END  --e_0      
              --      
              IF @@l_action_type = 'D'      
              BEGIN--d_0      
              --      
                BEGIN TRANSACTION      
                --      
                UPDATE client_bank_accts  WITH (ROWLOCK)      
                SET    cliba_deleted_ind  = 0       
                      ,cliba_lst_upd_by   = @pa_login_name      
                      ,cliba_lst_upd_dt   = GETDATE()      
                WHERE  cliba_banm_id      = @@l_cliba_banm_id      
                AND    cliba_clisba_id    = @@l_clisba_id      
                AND    cliba_compm_id     = @@l_compm_id      
                AND    cliba_ac_no        = @@l_cliba_ac_no      
                AND    cliba_deleted_ind  = 1      
                --      
                SET @l_error = @@error      
                --      
                IF @l_error > 0      
                BEGIN      
                --      
                  SET @t_errorstr = '#'+'could not change access for ' + convert(varchar, @@l_cliba_ac_name) + ISNULL(@t_errorstr,'')      
                  --      
                  ROLLBACK TRANSACTION      
                --      
                END      
                ELSE      
       BEGIN      
                --      
                  SET @t_errorstr = 'client bank account successfully inserted\edited '+ @rowdelimiter      
                  --      
                  COMMIT TRANSACTION      
                --      
                END      
              --      
              END  --d_0      
            --      
            END--chk_yn=0      
            --      
            IF @PA_CHK_YN = 1 OR @PA_CHK_YN = 2      
            BEGIN--CHK_YN_1      
            --      
              IF ISNULL(@@l_clisba_id, 0) = 0      
              BEGIN      
              --      
                 SELECT @@l_clisba_id      = clisba_id  
                 FROM   client_sub_accts_mak   WITH (NOLOCK)  
                      , exch_seg_mstr      WITH (NOLOCK)  
                      , excsm_prod_mstr    WITH (NOLOCK)  
                      , product_mstr       WITH (NOLOCK)  
                 WHERE  clisba_crn_no      = @pa_ent_id  
                 AND    clisba_acct_no     = @@l_cliba_acct_no  
                 AND    clisba_no          = @@l_clisba_acct_no  
                 AND    excpm_excsm_id     = excsm_id  
                 AND    excpm_prom_id      = prom_id  
                 AND    excsm_id           = @@l_excsm_id  
                 AND    excpm_id           = clisba_excpm_id  
                 AND    prom_cd            = right(@@l_clisba_acct_no,2)  
                 AND    clisba_deleted_ind in (0,4,8)  
              --        
              END      
              /*Changed at JMM on 28 may 2007*/      
              IF ISNULL(@@l_clisba_id, 0) = 0      
              BEGIN      
              --      
                /*SELECT @@l_clisba_id      = clisba_id      
                FROM   client_sub_accts   WITH (NOLOCK)      
                WHERE  clisba_crn_no      = @pa_ent_id      
                AND    clisba_acct_no     = @@l_cliba_acct_no      
                AND    clisba_no          = @@l_clisba_acct_no      
                AND    clisba_deleted_ind = 1     */  
                SELECT @@l_clisba_id      = clisba_id        
                  FROM   client_sub_accts   WITH (NOLOCK)        
                       , exch_seg_mstr      WITH (NOLOCK)        
                       , excsm_prod_mstr    WITH (NOLOCK)        
                       , product_mstr       WITH (NOLOCK)        
                  WHERE  clisba_crn_no      = @pa_ent_id        
                  AND    clisba_acct_no     = @@l_cliba_acct_no        
                  AND    clisba_no          = @@l_clisba_acct_no        
                  AND    excpm_excsm_id     = excsm_id        
                  AND    excpm_prom_id      = prom_id        
                  AND    excsm_id           = @@l_excsm_id        
                  AND    excpm_id           = clisba_excpm_id        
                  AND    prom_cd            = right(@@l_clisba_acct_no,2)        
                  AND    clisba_deleted_ind = 1   
              --      
              END      
              /*Changed at JMM on 28 may 2007*/         
              --      
              IF @@l_action_type IN ('A','D','E')      
              BEGIN--**      
              --      
                IF EXISTS(SELECT cliba_id      
                          FROM   client_bank_accts_mak WITH (NOLOCK)      
                          WHERE  cliba_banm_id      = @@l_cliba_banm_id      
                          AND    cliba_compm_id     = @@l_compm_id      
                          AND    cliba_clisba_id    = @@l_clisba_id      
                          AND    cliba_ac_no        = @@l_cliba_ac_no      
                          AND    cliba_deleted_ind IN (0,4,8)      
                          )      
                BEGIN--#exist      
                --      
                  BEGIN TRANSACTION      
                  --      
                  UPDATE client_bank_accts_mak WITH (ROWLOCK)      
                  SET    cliba_deleted_ind          = 3      
                        ,cliba_lst_upd_by           = @pa_login_name      
                        ,cliba_lst_upd_dt           = GETDATE()      
                  WHERE  cliba_banm_id              = @@l_cliba_banm_id      
                  AND    cliba_compm_id             = @@l_compm_id      
                  AND    cliba_clisba_id            = @@l_clisba_id      
                  AND    cliba_ac_no                = @@l_cliba_ac_no      
                  AND    cliba_deleted_ind         IN (0,4,8)      
                  --      
                  SET @l_error = @@error      
                  --      
                  IF @l_error > 0      
                  BEGIN      
                  --      
                    SET @t_errorstr = '#'+'could not change access for ' + convert(varchar, @@l_cliba_ac_name) + ISNULL(@t_errorstr,'')      
                    --      
                    ROLLBACK TRANSACTION      
                  --      
                  END      
                  ELSE      
                  BEGIN      
                  --      
                    SET @t_errorstr = 'client bank account successfully inserted\edited '+ @rowdelimiter      
                    --      
                    COMMIT TRANSACTION      
                  --      
                  END      
          --      
                END  --#exist      
                --      
                IF @@l_action_type IN ('A','E')      
                BEGIN--***      
                --      
                  /*IF @@l_cliba_flg = 1      
                  BEGIN--FLG=1      
                  --      
                    SELECT @@l_bitrm_bit_location = bitrm_bit_location      
                    FROM   bitmap_ref_mstr WITH (NOLOCK)      
                    WHERE  bitrm_parent_cd        = 'BANK'      
                    AND    bitrm_child_cd         = 'DEF_FLG'      
                    --      
                    SET  @@l_cliba_flg            = POWER(2,@@l_bitrm_bit_location-1) | @@l_cliba_flg      
                  --      
                  END  --FLG=1*/      
                  --      
                  IF @@l_cliba_poa_flg = 1      
                  BEGIN      
                  --      
                    SELECT @@l_bitrm_bit_location = bitrm_bit_location      
                    FROM   bitmap_ref_mstr WITH (NOLOCK)      
                    WHERE  bitrm_parent_cd        = 'BANK'      
                    AND    bitrm_child_cd         = 'POA_FLG'      
                    --      
                    SET @@l_cliba_flg             = power(2, @@l_bitrm_bit_location-1) | @@l_cliba_flg      
                  --      
                  END      
                  --      
                  IF @@l_cliba_def_flg = 1      
                  BEGIN      
                  --      
                    SELECT @@l_bitrm_bit_location = bitrm_bit_location      
                    FROM   bitmap_ref_mstr WITH (NOLOCK)      
                    WHERE  bitrm_parent_cd        = 'BANK'      
                    AND    bitrm_child_cd         = 'DEF_FLG'      
                    --      
                    SET @@l_cliba_flg             = power(2, @@l_bitrm_bit_location - 1) | @@l_cliba_flg      
                  --      
                  END      
                --       
                END--***       
                --      
                     
                IF EXISTS(SELECT CLIBA_CLISBA_ID FROM CLIENT_BANK_ACCTS WHERE CLIBA_CLISBA_ID = @@l_clisba_id AND cliba_banm_id = @@l_cliba_banm_id)      
                BEGIN      
                --      
                  SET @L_EDT_DEL_ID = 8      
                --      
                END      
                ELSE      
                BEGIN      
                --      
                  SET @L_EDT_DEL_ID = 0      
                --      
                END       
       
                SELECT @l_cliba_id = ISNULL(MAX(cliba_id),0) + 1      
                FROM   client_bank_accts_mak WITH (NOLOCK)      
                --      
                BEGIN TRANSACTION      
        --      
                INSERT into client_bank_accts_mak      
                (cliba_id      
                ,cliba_banm_id      
                ,cliba_clisba_id      
                ,cliba_compm_id      
                ,cliba_ac_no      
                ,cliba_ac_type      
                ,cliba_ac_name      
                ,cliba_flg      
                ,cliba_created_by      
                ,cliba_created_dt      
                ,cliba_lst_upd_by      
                ,cliba_lst_upd_dt      
                ,cliba_deleted_ind      
                )      
                VALUES      
                (@L_cliba_id      
                ,@@l_cliba_banm_id      
                ,@@l_clisba_id      
                ,@@l_compm_id      
                ,@@l_cliba_ac_no      
                ,@@l_cliba_ac_type      
                ,@@l_cliba_ac_name      
                ,@@l_cliba_flg      
                ,@pa_login_name      
                ,GETDATE()      
                ,@pa_login_name      
                ,GETDATE()      
                ,CASE @@l_action_type WHEN 'A' then 0      
                                      WHEN 'E' then @L_EDT_DEL_ID                           
                                      WHEN 'D' then 4      
                                      END      
                )      
                --      
                --      
                SET @l_error = @@error      
                --      
                IF @l_error > 0      
                BEGIN      
                --      
                  SET @t_errorstr = '#'+'could not change access for ' + convert(varchar, @@l_cliba_ac_name) + ISNULL(@t_errorstr,'')      
                  --      
                  ROLLBACK TRANSACTION      
                --      
                END      
                ELSE      
                BEGIN      
                --      
                  SET @t_errorstr = 'client bank account successfully inserted\edited '+ @rowdelimiter      
                  --      
                  SELECT @l_action = CASE @@l_action_type WHEN 'A' THEN 'I' WHEN 'E' THEN 'E' WHEN 'D' THEN 'D' END      
                  --      
                  EXEC pr_ins_upd_list @l_crn_no, @l_action, 'Client Bank Accts',@pa_login_name,'*|~*','|*~|',''                     --      
                  COMMIT TRANSACTION      
                --      
                END      
              --      
              END--**      
            --      
            END--CHK_YN_1      
          --      
          END  --curr_val      
        --        
        END --val        
        --pa_id--      
        IF ISNULL(@@l_action_type,'') = ''       
        BEGIN--action_type=''        
        --                   
          IF @pa_action = 'REJ'      
          BEGIN--rej      
          --      
            --BEGIN TRANSACTION      
            --      
            UPDATE client_bank_accts_mak  with (rowlock)      
            SET    cliba_deleted_ind = 3       
                  ,cliba_lst_upd_by  = @pa_login_name      
                  ,cliba_lst_upd_dt  = GETDATE()      
            WHERE  cliba_id          = convert(numeric, @currstring2)      
            AND    cliba_deleted_ind in (0,4,8)        
            --      
            SET @l_error = @@error      
            --      
            IF @l_error > 0      
            BEGIN      
            --      
              --SET @t_errorstr = 'could not change access for ' + convert(varchar, @@l_cliba_ac_name) + ISNULL(@t_errorstr,'')      
              --      
              --ROLLBACK TRANSACTION      
              SET @t_errorstr  = CONVERT(varchar(10), @l_error)       
            --      
            END      
            --ELSE      
            --BEGIN      
            --      
            --  SET @t_errorstr = 'client bank account successfully inserted\edited '+ @rowdelimiter      
              --      
            --  COMMIT TRANSACTION      
            --      
            --END      
          --      
          END--rej      
          --      
          IF @pa_action = 'APP'      
          BEGIN--app      
          --      
            SELECT @l_cliba_banm_id     = cliba_banm_id          
                 , @l_cliba_clisba_id   = cliba_clisba_id        
   , @l_cliba_compm_id    = cliba_compm_id         
                 , @l_cliba_ac_no       = cliba_ac_no            
                 , @l_cliba_ac_type     = cliba_ac_type          
                 , @l_cliba_ac_name     = cliba_ac_name          
                 , @l_cliba_flg         = cliba_flg              
                 , @l_cliba_deleted_ind = cliba_deleted_ind      
            FROM   #t_mak      
            WHERE  cliba_id             = convert(numeric, @currstring2)      
            --      
            IF @l_cliba_deleted_ind = 4      
            BEGIN --4      
            --      
                  
              --      
              UPDATE client_bank_accts_mak  WITH(ROWLOCK)      
              SET    cliba_deleted_ind = 5      
                    ,cliba_lst_upd_by  = @pa_login_name      
                    ,cliba_lst_upd_dt  = GETDATE()      
              WHERE  cliba_id          = convert(numeric, @currstring2)      
              AND    cliba_deleted_ind = 4      
              --      
              SET @l_error = @@ERROR       
              --      
       IF @l_error > 0      
              BEGIN      
              --      
                --SET @t_errorstr = 'could not change access for ' + convert(varchar, @@l_cliba_ac_name) + ISNULL(@t_errorstr,'')      
                SET @t_errorstr = CONVERT(VARCHAR(10), @l_error)      
                --      
                     
              --      
              END      
                   
              UPDATE client_bank_accts   WITH(ROWLOCK)      
              SET    cliba_deleted_ind = 0      
                    ,cliba_lst_upd_by  = @pa_login_name      
                    ,cliba_lst_upd_dt  = GETDATE()      
              WHERE  cliba_banm_id     = @l_cliba_banm_id      
              AND    cliba_clisba_id   = @l_cliba_clisba_id      
              AND    cliba_compm_id    = @l_cliba_compm_id      
              AND    cliba_ac_no       = @l_cliba_ac_no      
              AND    cliba_deleted_ind = 1         
              --      
              SET @l_error = @@ERROR       
              --      
              IF @l_error > 0      
              BEGIN      
              --      
                --SET @t_errorstr = 'could not change access for ' + convert(varchar, @@l_cliba_ac_name) + ISNULL(@t_errorstr,'')      
                SET @t_errorstr = CONVERT(VARCHAR(10), @l_error)      
                --      
                     
              --      
              END      
                
            END --4      
            ELSE IF @l_cliba_deleted_ind    = 8      
            BEGIN --8      
            --      
                   
              --      
              UPDATE client_bank_accts_mak  WITH(ROWLOCK)      
              SET    cliba_deleted_ind = 9      
                    ,cliba_lst_upd_by  = @pa_login_name      
                    ,cliba_lst_upd_dt  = GETDATE()      
              WHERE  cliba_id          = convert(numeric, @currstring2)      
              AND    cliba_deleted_ind = 8      
              --      
              SET @l_error = @@ERROR       
              --      
              IF @l_error > 0      
              BEGIN      
              --      
                --SET @t_errorstr = 'could not change access for ' + convert(varchar, @@l_cliba_ac_name) + ISNULL(@t_errorstr,'')      
                SET @t_errorstr = CONVERT(VARCHAR(10), @l_error)      
                --      
                     
              --      
              END      
                   
              UPDATE client_bank_accts  WITH(ROWLOCK)      
              SET    cliba_ac_type     = @l_cliba_ac_type      
                    ,cliba_ac_name     = @l_cliba_ac_name      
                    ,cliba_flg         = @l_cliba_flg      
                    ,cliba_lst_upd_by  = @pa_login_name      
                    ,cliba_lst_upd_dt  = GETDATE()      
              WHERE  cliba_banm_id     = @l_cliba_banm_id      
              AND    cliba_clisba_id   = @l_cliba_clisba_id      
              AND    cliba_compm_id    = @l_cliba_compm_id      
              AND    cliba_ac_no       = cliba_ac_no      
              AND    cliba_deleted_ind = 1      
              --      
              SET @l_error = @@ERROR       
              --      
              IF @l_error > 0      
              BEGIN      
              --      
                --SET @t_errorstr = 'could not change access for ' + convert(varchar, @@l_cliba_ac_name) + ISNULL(@t_errorstr,'')      
                SET @t_errorstr = CONVERT(VARCHAR(10), @l_error)      
                --      
                      
              --      
              END      
                   
            --      
            END --8      
            ELSE IF @l_cliba_deleted_ind    = 0      
            BEGIN --0      
            --      
                   
              --      
              UPDATE client_bank_accts_mak  WITH(ROWLOCK)      
              SET    cliba_deleted_ind = 1      
                    ,cliba_lst_upd_by  = @pa_login_name      
                    ,cliba_lst_upd_dt  = GETDATE()      
              WHERE  cliba_id          = convert(numeric, @currstring2)      
              AND    cliba_deleted_ind = 0        
              --      
              SET @l_error = @@ERROR       
              --      
              IF @l_error > 0      
              BEGIN      
              --      
                --SET @t_errorstr = 'could not change access for ' + convert(varchar, @@l_cliba_ac_name) + ISNULL(@t_errorstr,'')      
                SET @t_errorstr = CONVERT(varchar(10), @l_error)      
                --      
                     
              --      
              END      
                    
              /*SELECT @l_clisba_acct_no = clisba_acct_no      
                       , @l_clisba_no         = clisba_no      
                       , @l_clisba_crn_no   = clisba_crn_no      
              FROM    client_sub_accts_mak      
              WHERE  clisbamak_id        = (SELECT cliba_clisba_id FROM  client_bank_accts_mak WHERE cliba_id = CONVERT(numeric, @currstring2))      
                      
       
              SELECT @l_clisba_id = clisba_id       
              FROM   client_sub_accts       
              WHERE clisba_acct_no     =  @l_clisba_acct_no      
              and     clisba_no             =  @l_clisba_no       
              and     clisba_crn_no       =  @l_clisba_crn_no           
              and     clisba_deleted_ind = 1*/      
      
       
              INSERT into client_bank_accts      
              (cliba_banm_id      
              ,cliba_clisba_id      
              ,cliba_compm_id      
              ,cliba_ac_no      
              ,cliba_ac_type      
              ,cliba_ac_name      
              ,cliba_flg      
              ,cliba_created_by      
              ,cliba_created_dt      
              ,cliba_lst_upd_by      
              ,cliba_lst_upd_dt      
 ,cliba_deleted_ind      
              )      
      
              SELECT cliba_banm_id      
                   , cliba_clisba_id      
                   , cliba_compm_id      
                   , cliba_ac_no      
                   , cliba_ac_type      
                   , cliba_ac_name      
                   , cliba_flg      
                   , @pa_login_name      
                   , GETDATE()      
                   , @pa_login_name      
                   , GETDATE()      
                   , 1      
              FROM   #t_mak      
              WHERE  cliba_id  = CONVERT(numeric, @currstring2)      
              --      
              SET @l_error = @@ERROR       
              --      
              IF @l_error > 0      
              BEGIN      
              --      
                --SET @t_errorstr = 'could not change access for ' + convert(varchar, @@l_cliba_ac_name) + ISNULL(@t_errorstr,'')      
                --      
                SET @t_errorstr = CONVERT(VARCHAR(10), @l_error)      
                --      
                    
              --      
              END      
                   
            --      
            END--0      
            --move to pr_app_client      
            --EXEC pr_ins_upd_list @l_crn_no,'A','Client Bank Accts',@pa_login_name,'*|~*','|*~|',''       
          --      
          END--app      
        --        
        END--action_type=''        
      --        
      END  --curr_id      
    --        
    END--WHILE id        
  --      
  END  --<>''      
  --      
  SET @pa_msg = @t_errorstr      
--        
END  --#1

GO
