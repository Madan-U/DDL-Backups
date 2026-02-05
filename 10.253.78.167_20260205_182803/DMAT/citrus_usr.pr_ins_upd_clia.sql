-- Object: PROCEDURE citrus_usr.pr_ins_upd_clia
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE  PROCEDURE [citrus_usr].[pr_ins_upd_clia](@pa_id                VARCHAR(8000)            
                               ,@pa_action            VARCHAR(20)            
                               ,@pa_login_name        VARCHAR(20)            
                               ,@pa_ent_id            NUMERIC            
                               ,@pa_values            VARCHAR(8000)            
                               ,@pa_chk_yn            NUMERIC            
                               ,@rowdelimiter         CHAR(4) =  '*|~*'            
                               ,@coldelimiter         CHAR(4)  = '|*~|'            
                               ,@pa_msg               VARCHAR(8000) OUTPUT            
)            
AS            
/*            
*********************************************************************************            
 SYSTEM         : CLASS            
 MODULE NAME    : PR_INS_UPD_CLIA            
 DESCRIPTION    : THIS PROCEDURE WILL ADD NEW VALUES TO  CLIENT_ACCOUNTS            
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.            
 VERSION HISTORY:            
 VERS.  AUTHOR             DATE        REASON            
 -----  -------------      ----------  -------------------------------------------------            
 1.0    SUKHVINDER/TUSHAR  29-DEC-2006 INITIAL VERSION.            
--------------------------------------------------------------------------------------*/            
--            
BEGIN            
--            
DECLARE @@t_errorstr            VARCHAR(8000)            
      , @delimeter_id           VARCHAR(10)            
      , @@delimeterlength_id    INT            
      , @@remainingstring_id    VARCHAR(8000)            
      , @@currstring_id         VARCHAR(8000)            
      , @delimeter_value        VARCHAR(10)            
      , @@delimeterlength_value INT            
      , @@remainingstring_value VARCHAR(8000)            
      , @@currstring_value      VARCHAR(8000)            
      , @@currstring_value1     VARCHAR(8000)            
      , @@foundat               INTEGER            
      , @@l_clia_acctno         VARCHAR(20)            
      , @@l_bitrm_bit_location  NUMERIC            
      , @@l_access1             INTEGER            
      , @@c_access_cursor       CURSOR            
      , @@l_error               INTEGER            
      , @l_excsm_desc           VARCHAR(8000)            
      , @@l_compm_id            NUMERIC            
      , @l_acct_no              VARCHAR(25)            
      , @@l_msg                 VARCHAR(8000)            
      , @@l_excsm_id            NUMERIC            
      , @@chk_access            VARCHAR(10)            
      , @l_clia_id              numeric            
      , @l_excsm_id             numeric            
      , @l_clia_deleted_ind     numeric            
      , @@l_clia_ent_id         numeric            
      , @@l_action              varchar(10)        
      , @l_clisba_id            NUMERIC         
  --            
  SET @@t_errorstr         = @@error            
  SET nocount        ON            
  SET @delimeter_id        = '%'+ @rowdelimiter + '%'            
  SET @@delimeterlength_id = LEN(@rowdelimiter)            
  SET @@remainingstring_id = @pa_id            
  --            
  IF @pa_action = 'EDT' OR  @pa_action = 'INS' OR @pa_action = 'APP'            
  BEGIN            
  --            
     CREATE TABLE     #t_clia            
     (clia_acct_no    VARCHAR(25)            
     ,excsm_compm_id  NUMERIC            
     ,excsm_exch_cd   VARCHAR(25)            
     ,excsm_seg_cd    VARCHAR(25)            
     ,excsm_id        NUMERIC            
     ,excsm_desc      VARCHAR(50)            
     )            
                 
                 
     CREATE TABLE     #t_clia1            
     (clia_acct_no    VARCHAR(25)            
     ,excsm_compm_id  NUMERIC            
     ,excsm_exch_cd   VARCHAR(25)            
     ,excsm_seg_cd    VARCHAR(25)            
     ,excsm_id        NUMERIC            
     ,excsm_desc      VARCHAR(50)            
     )            
     --            
     INSERT INTO #t_clia            
     (clia_acct_no            
     ,excsm_compm_id            
     ,excsm_exch_cd            
     ,excsm_seg_cd            
     ,excsm_id            
     ,excsm_desc            
     )            
     SELECT clia.clia_acct_no         clia_acct_no            
       , excsm.excsm_compm_id      compm_id            
          , excsm.excsm_exch_cd       excsm_exch_cd            
          , excsm.excsm_seg_cd        excsm_seg_cd            
          , excsm.excsm_id  excsm_id            
          , excsm.excsm_desc          excsm_desc            
     FROM   client_accounts           clia    WITH (NOLOCK)            
          , exch_seg_mstr             excsm   WITH (NOLOCK)            
     WHERE  clia.clia_crn_no    = @pa_ent_id            
     AND    clia.clia_deleted_ind   = 1            
     AND    excsm.excsm_deleted_ind = 1            
     AND    citrus_usr.fn_get_single_access(clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc) > 0            
  --            
  END            
  --            
  IF (@pa_id <> '') AND (@pa_action <> '') AND (@pa_login_name <> '')            
  BEGIN            
  --            
    IF @pa_chk_yn = 0            
    BEGIN            
    --            
      IF @pa_action = 'INS'            
      BEGIN            
      --            
         WHILE @@remainingstring_id <> ''            
         BEGIN            
             --            
             SET @@foundat = 0            
             SET @@foundat = PATINDEX('%'+@delimeter_id+'%',@@remainingstring_id)            
             --            
             IF  @@foundat > 0            
             BEGIN            
               --            
               SET @@currstring_id      = SUBSTRING(@@remainingstring_id, 0,@@foundat)            
               SET @@remainingstring_id = SUBSTRING(@@remainingstring_id, @@foundat+@@delimeterlength_id,LEN(@@remainingstring_id)- @@foundat+@@delimeterlength_id)            
               --            
             END            
             ELSE            
             BEGIN            
               --            
               SET @@currstring_id      = @@remainingstring_id            
               SET @@remainingstring_id = ''            
             --            
             END            
             --            
             IF @@currstring_id <> ''            
             BEGIN            
             --            
               SET @delimeter_value        = '%'+ @rowdelimiter + '%'            
               SET @@delimeterlength_value = LEN(@rowdelimiter)            
               SET @@remainingstring_value = @pa_values            
             --            
               WHILE @@remainingstring_value <> ''            
               BEGIN            
               --            
                     SET @@foundat = 0            
                     SET @@foundat = PATINDEX('%'+@delimeter_value+'%',@@remainingstring_value)            
                     --            
                     IF @@foundat > 0            
                     BEGIN            
                       --            
                       SET @@currstring_value      = SUBSTRING(@@remainingstring_value, 0,@@foundat)            
                       SET @@remainingstring_value = SUBSTRING(@@remainingstring_value, @@foundat+@@delimeterlength_value,LEN(@@remainingstring_value)- @@foundat+@@delimeterlength_value)            
                       --            
                     END            
                     ELSE            
                     BEGIN            
                       --            
                       SET @@CURRSTRING_VALUE = @@REMAININGSTRING_VALUE            
                       SET @@REMAININGSTRING_VALUE = ''            
                     --            
                     END            
                     --            
                     IF @@currstring_value <> ''            
      BEGIN            
                     --            
                       SET @@l_clia_acctno = citrus_usr.FN_SPLITVAL(@@currstring_value,1)            
                       SET @@l_compm_id    = citrus_usr.FN_SPLITVAL(@@currstring_value,2)            
                       SET @@l_excsm_id    = citrus_usr.FN_SPLITVAL(@@currstring_value,3)            
                       SET @@l_action      = citrus_usr.FN_SPLITVAL(@@currstring_value,4)            
                       --            
                       SELECT @@l_access1      = clia_access1            
                       FROM   client_Accounts            
                       WHERE  clia_crn_no      = @pa_ent_id            
                       AND    clia_acct_no     = @@l_clia_acctno            
                       AND    clia_deleted_ind = 1            
                       --            
                       IF NOT EXISTS(SELECT *            
                                     FROM  client_Accounts    WITH (NOLOCK)            
                                     WHERE clia_crn_no    = @PA_ENT_ID            
                                     AND   clia_acct_no     = @@L_CLIA_ACCTNO            
                                     AND   clia_deleted_ind = 1            
                                     )            
                       BEGIN            
                       --            
                          BEGIN TRANSACTION            
                          --            
                          SELECT @l_excsm_desc = excsm_desc            
                          FROM   Exch_Seg_Mstr            
                          WHERE  excsm_id      = @@l_excsm_id            
                          --            
                          SELECT @@l_bitrm_bit_location = bitrm_bit_location            
                          FROM   bitmap_ref_mstr          WITH (NOLOCK)            
                               , exch_seg_mstr            WITH (NOLOCK)            
                          WHERE  bitrm_child_cd         = excsm_desc            
                          AND    excsm_id               = @@l_excsm_id            
                          --            
                          SET @@l_access1 = 0            
                          --            
                          SET @@l_access1 = POWER(2,@@l_bitrm_bit_location-1) | @@l_access1            
                          --            
                          INSERT INTO client_accounts            
                          (clia_crn_no            
                          ,clia_acct_no            
                          ,clia_access1            
                          ,clia_status1            
                          ,clia_access2            
                          ,clia_status2            
                          ,clia_created_by            
                          ,clia_created_dt            
                          ,clia_lst_upd_by            
                          ,clia_lst_upd_dt            
                          ,clia_deleted_ind)            
                           VALUES            
                          (@pa_ent_id            
                          ,@@l_clia_acctno            
                          ,@@l_access1            
                          ,0            
                          ,0            
                          ,0            
                          ,@pa_login_name            
                          ,getdate()            
                          ,@pa_login_name            
                          ,getdate()            
                          ,1)            
                          --            
                          SET @@l_error = @@error            
                          --            
                          IF @@l_error > 0            
                          BEGIN            
                          --            
                            SELECT @l_excsm_desc           = excsm.excsm_desc            
                       FROM   exch_seg_mstr excsm       WITH (NOLOCK)            
                            WHERE  excsm.excsm_id          = @@L_EXCSM_ID            
                            AND    excsm.excsm_deleted_ind = 1            
                            --            
                            SET @@t_errorstr = '#'+'Could Not Change Access For '+ ISNULL(CONVERT(VARCHAR,@@l_clia_acctno),'') + ' ON '+@l_excsm_desc+@rowdelimiter+@@t_errorstr            
                        --            
                            ROLLBACK TRANSACTION            
                          --            
                          END            
                          ELSE            
                          BEGIN            
                          --            
                            COMMIT TRANSACTION            
                          --            
                            SET @@t_errorstr = 'Client-Accounts Successfully Inserted/Edited'+ @rowdelimiter            
                          --            
                          END            
                       --            
                       END            
                       ELSE            
                       BEGIN            
                       --            
                         SELECT @l_excsm_desc           = excsm.excsm_desc            
                         FROM   exch_seg_mstr excsm       WITH (NOLOCK)            
                         WHERE  excsm.excsm_id          = @@l_excsm_id            
  AND    excsm.excsm_deleted_ind = 1            
                         --            
                         EXEC pr_set_access @pa_ent_id, @@l_clia_acctno, @l_excsm_desc, 'Y', @@l_msg            
                         --            
                         IF LTRIM(RTRIM(@@l_msg)) IS NOT NULL            
                         BEGIN            
                         --            
                           SET @@t_errorstr = @@l_msg            
                         --            
                         END            
                         ELSE            
                         BEGIN            
  --            
                           SET @@t_errorstr = 'Client-Accounts Successfully Inserted/Edited'+ @rowdelimiter            
                         --            
                         END            
                                     
                         --SET @@t_errorstr = 'Client-Accounts Successfully Inserted/Edited'+ @rowdelimiter            
                       --            
                       END            
                    --            
                    END --END OF IF @@CURRSTRING_VALUE <> ''            
                --            
                END --END OF WHILE @@REMAININGSTRING_VALUE <> ''                  --            
             END --END OF IF @@CURRSTRING_ID <> ''            
             --            
         END --END OF WHILE @@REMAININGSTRING_ID <> ''            
      --            
      END --END OF IF @PA_ACTION = 'INS'            
      ELSE IF @PA_ACTION = 'EDT'            
      BEGIN            
      --            
        WHILE @@remainingstring_id <> ''            
        BEGIN            
             --            
             SET @@foundat = 0            
             SET @@foundat =  PATINDEX('%'+@delimeter_id+'%',@@remainingstring_id)            
             --            
             IF  @@foundat > 0            
             BEGIN            
               --            
               SET @@currstring_id      = SUBSTRING(@@remainingstring_id, 0,@@foundat)            
               SET @@remainingstring_id = SUBSTRING(@@remainingstring_id, @@foundat+@@delimeterlength_id,LEN(@@remainingstring_id)- @@foundat+@@delimeterlength_id)            
               --            
             END            
             ELSE            
             BEGIN            
               --            
               SET @@currstring_id      = @@remainingstring_id            
SET @@remainingstring_id = ''            
             --            
             END            
             --            
             IF @@currstring_id <> ''            
             BEGIN            
             --            
               SET @delimeter_value        = '%'+ @rowdelimiter + '%'            
               SET @@delimeterlength_value = LEN(@rowdelimiter)            
               SET @@remainingstring_value = @pa_values            
             --            
               WHILE @@remainingstring_value <> ''            
               BEGIN            
               --            
                     SET @@foundat = 0            
                     SET @@foundat =  PATINDEX('%'+@delimeter_value+'%',@@remainingstring_value)            
                     --            
                     IF @@foundat > 0            
                     BEGIN            
                       --            
                       SET @@currstring_value      = SUBSTRING(@@remainingstring_value, 0,@@foundat)            
                       SET @@remainingstring_value = SUBSTRING(@@remainingstring_value, @@foundat+@@delimeterlength_value,LEN(@@remainingstring_value)- @@foundat+@@delimeterlength_value)            
                       --            
                     END            
            ELSE            
                     BEGIN            
                       --            
                       SET @@currstring_value = @@remainingstring_value            
                       SET @@remainingstring_value = ''            
                     --            
                     END            
                     --            
                     --            
                     IF @@currstring_value <> ''            
                     BEGIN            
                     --            
                       SET @@l_clia_acctno = CONVERT(VARCHAR,citrus_usr.FN_SPLITVAL(@@currstring_value,1))            
                       SET @@l_compm_id    = citrus_usr.FN_SPLITVAL(@@currstring_value,2)            
                       SET @@l_excsm_id    = citrus_usr.FN_SPLITVAL(@@currstring_value,3)            
                       SET @@l_action      = citrus_usr.FN_SPLITVAL(@@currstring_value,4)            
                       --            
                                   
                       /*IF EXISTS(SELECT excsm_desc            
                                 FROM   #t_clia            
                                 WHERE  clia_acct_no   = @@l_clia_acctno            
                                 AND    excsm_id       = @@l_excsm_id            
                                 )            
                       BEGIN            
                       --            
                          DELETE FROM #t_clia            
                          WHERE  clia_acct_no = @@l_clia_acctno            
                          AND    excsm_id     = @@l_excsm_id            
                          --            
                          SELECT @l_excsm_desc           = excsm.excsm_desc            
                          FROM   exch_seg_mstr             excsm  WITH (NOLOCK)            
                          WHERE  excsm.excsm_id          = @@l_excsm_id            
                          AND    excsm.excsm_deleted_ind = 1            
                          --            
                          EXEC PR_SET_ACCESS @pa_ent_id, @@l_clia_acctno, @l_excsm_desc, 'Y', @@l_msg            
                          --            
                          IF LTRIM(RTRIM(@@l_msg)) IS NOT NULL            
                          BEGIN            
                          --            
                           SET @@t_errorstr = @@l_msg            
                          --            
                          END            
                          ELSE            
                          BEGIN            
                          --            
                            SET @@t_errorstr = 'Client-Accounts Successfully Inserted/Edited'+ @rowdelimiter            
                          --            
                          END            
                       --            
                       END            
                       ELSE            
                       BEGIN            
                       --*/            
                       IF @@L_ACTION = 'A'            
                       BEGIN            
                       --            
                         IF EXISTS(SELECT clia_access1            
                                    FROM   client_accounts         clia            
                                    WHERE  clia.clia_crn_no      = @pa_ent_id            
                                    AND    clia.clia_acct_no     = @@l_clia_acctno            
                                    AND    clia.clia_deleted_ind = 1)            
                          BEGIN                      
                          --            
                            SELECT @l_excsm_desc           = excsm.excsm_desc            
                            FROM   exch_seg_mstr             excsm  WITH (NOLOCK)            
                            WHERE  excsm.excsm_id          = @@l_excsm_id            
                            AND    excsm.excsm_deleted_ind = 1            
                            --            
                                        
                            EXEC PR_SET_ACCESS @pa_ent_id, @@l_clia_acctno, @l_excsm_desc, 'Y', @@l_msg            
                          --            
                          END            
                 ELSE            
                          BEGIN            
                          --            
                            BEGIN TRANSACTION            
                            --            
                            SELECT @@l_bitrm_bit_location = bitrm_bit_location            
                            FROM   bitmap_ref_mstr          WITH (NOLOCK)            
                                 , exch_seg_mstr            WITH (NOLOCK)            
                            WHERE  bitrm_child_cd         = excsm_desc            
                            AND    excsm_id               = @@l_excsm_id            
                            --            
                            SET @@l_access1 = 0            
                            --            
                            SET @@l_access1 = POWER(2,@@l_bitrm_bit_location-1) | @@l_access1            
                            --            
                            INSERT INTO client_accounts            
                            (clia_crn_no            
                            ,clia_acct_no            
                            ,clia_access1            
                            ,clia_status1            
                            ,clia_access2            
                            ,clia_status2            
                            ,clia_created_by            
                            ,clia_created_dt            
                            ,clia_lst_upd_by            
                            ,clia_lst_upd_dt            
                            ,clia_deleted_ind)            
                             VALUES            
                            (@pa_ent_id            
                            ,@@l_clia_acctno            
                            ,@@l_access1            
                            ,0            
                  ,0            
                            ,0            
                            ,@pa_login_name            
                            ,getdate()            
                            ,@pa_login_name            
                            ,getdate()            
                            ,1)            
                            --            
                            SET @@l_error = @@error            
                            --            
                            IF @@l_error > 0            
                            BEGIN                                        --            
                              SELECT @l_excsm_desc           = excsm.excsm_desc            
                              FROM   exch_seg_mstr             excsm  WITH (NOLOCK)            
                              WHERE  excsm.excsm_id          = @@l_excsm_id            
                              AND    excsm.excsm_deleted_ind = 1            
                              --            
                              SET @@t_errorstr = '#'+'Could Not Change Access For '+ ISNULL(CONVERT(VARCHAR,@@l_clia_acctno),'')+' ON '+@l_excsm_desc+@rowdelimiter+@@t_errorstr            
                              --            
                              ROLLBACK TRANSACTION            
                            --            
                            END            
                            ELSE            
                            BEGIN            
                  --            
                              COMMIT TRANSACTION            
                            --            
                              SET @@t_errorstr = 'Client-Accounts Successfully Inserted/Edited'+ @rowdelimiter            
                            --            
                            END            
                          --            
                          END            
                        --            
                        END            
                        IF @@l_action = 'D'            
                        BEGIN            
                        --            
                                  
                          SELECT @l_excsm_desc           = excsm.excsm_desc            
                          FROM   exch_seg_mstr             excsm  WITH (NOLOCK)            
                          WHERE  excsm.excsm_id          = @@l_excsm_id            
                          AND    excsm.excsm_deleted_ind = 1            
        
                          SELECT @l_clisba_id               = clisba_id        
                          FROM   exch_seg_mstr             excsm  WITH (NOLOCK)            
                               , client_sub_accts          clisba WITH (NOLOCK)            
                               , excsm_prod_mstr           excpm  WITH (NOLOCK)            
                          WHERE  excsm.excsm_id          = @@l_excsm_id            
                          AND    excsm.excsm_id          = excpm.excpm_excsm_id        
                          AND    excpm.excpm_id            = clisba.clisba_excpm_id       
                          AND    clisba.clisba_crn_no      = @pa_ent_id    
                          AND    excsm.excsm_deleted_ind   = 1            
                          AND    excpm.excpm_deleted_ind   = 1            
                          AND    clisba.clisba_deleted_ind = 1            
        
                          IF ISNULL(@l_clisba_id,0)  <>  0        
                          BEGIN        
                          --        
                           update client_bank_accts         
                            set    cliba_deleted_ind  = 0         
                            where  cliba_clisba_id    = @l_clisba_id        
                            and    cliba_deleted_ind  = 1         
        
                            update client_dp_accts        
                            set    clidpa_deleted_ind  = 0         
                            where  clidpa_clisba_id    = @l_clisba_id        
                            and    clidpa_deleted_ind  = 1         
        
                            update entity_relationship        
                            set    entr_deleted_ind  = 0         
                            where  entr_excpm_id     = (select clisba_excpm_id from client_sub_accts where clisba_id = @l_clisba_id)        
                            and    entr_crn_no       = @pa_ent_id  
                            and    entr_deleted_ind  = 1         
        
                            update client_sub_accts        
                 set    clisba_deleted_ind  = 0         
                            where  clisba_id    = @l_clisba_id        
                            and    clisba_deleted_ind  = 1         
                          --        
                          END        
        
        
                         
            
                          EXEC pr_set_access @pa_ent_id, @l_acct_no, @l_excsm_desc, 'N', @@l_msg            
        
        
        
                                    
            
                          SET @@t_errorstr = 'Client-Accounts Successfully Inserted/Edited'+ @rowdelimiter            
                        --            
                        END            
                     --            
                     END --END OF IF @@CURRSTRING_VALUE <> ''            
                --            
                END --END OF WHILE @@REMAININGSTRING_VALUE <> ''            
                --            
             END --END OF IF @@CURRSTRING_ID <> ''            
             --            
        END --END OF WHILE @@REMAININGSTRING_ID <> ''            
        --            
        /*SET @@c_access_cursor =  CURSOR fast_forward FOR            
        SELECT clia_acct_no, excsm_desc FROM #t_clia            
        --            
        OPEN @@c_access_cursor            
        FETCH NEXT FROM @@c_access_cursor INTO @l_acct_no, @l_excsm_desc            
        --            
        WHILE @@fetch_status = 0            
        BEGIN            
        --            
          EXEC pr_set_access @pa_ent_id, @l_acct_no, @l_excsm_desc, 'N', @@l_msg            
          --            
          --SET @@T_ERRORSTR = @@L_MSG            
          --            
          FETCH NEXT FROM @@c_access_cursor INTO @l_acct_no, @l_excsm_desc            
        --            
        END            
        CLOSE      @@c_access_cursor            
        DEALLOCATE @@c_access_cursor*/            
                    
        SET @@t_errorstr = 'Client-Accounts Successfully Inserted/Edited'+ @rowdelimiter            
        --            
      END --END OF IF @PA_ACTION = 'EDT'            
    --            
    END            
  --            
  END            
  IF @pa_chk_yn = 1  OR @pa_chk_yn = 2                 
  BEGIN            
  --            
    IF @pa_action='INS'            
    BEGIN            
    --            
      WHILE @@remainingstring_id <> ''            
      BEGIN            
      --            
        SET @@foundat = 0            
        SET @@foundat = PATINDEX('%'+@delimeter_id+'%',@@remainingstring_id)            
        --            
        IF  @@foundat > 0            
     BEGIN            
          --            
          SET @@currstring_id      = SUBSTRING(@@remainingstring_id, 0,@@foundat)            
          SET @@remainingstring_id = SUBSTRING(@@remainingstring_id, @@foundat+@@delimeterlength_id,LEN(@@remainingstring_id)- @@foundat+@@delimeterlength_id)            
          --            
        END            
        ELSE            
        BEGIN            
          --            
          SET @@currstring_id      = @@remainingstring_id            
          SET @@remainingstring_id = ''            
        --            
        END            
        --            
        IF @@currstring_id <> ''            
        BEGIN            
        --            
          SET @delimeter_value        = '%'+ @rowdelimiter + '%'            
          SET @@delimeterlength_value = LEN(@rowdelimiter)            
          SET @@remainingstring_value = @pa_values            
          --            
          WHILE @@remainingstring_value <> ''            
          BEGIN            
          --            
            SET @@foundat = 0            
            SET @@foundat = PATINDEX('%'+@delimeter_value+'%',@@remainingstring_value)            
            --            
            IF @@foundat > 0            
            BEGIN            
              --            
              SET @@currstring_value      = SUBSTRING(@@remainingstring_value, 0,@@foundat)            
              SET @@remainingstring_value = SUBSTRING(@@remainingstring_value, @@foundat+@@delimeterlength_value,LEN(@@remainingstring_value)- @@foundat+@@delimeterlength_value)            
              --            
            END            
            ELSE            
            BEGIN            
              --            
              SET @@CURRSTRING_VALUE = @@REMAININGSTRING_VALUE            
              SET @@REMAININGSTRING_VALUE = ''            
            --            
            END            
            --            
            IF @@currstring_value <> ''            
            BEGIN            
            --            
              SET @@l_clia_acctno = citrus_usr.FN_SPLITVAL(@@currstring_value,1)            
              SET @@l_compm_id    = citrus_usr.FN_SPLITVAL(@@currstring_value,2)            
              SET @@l_excsm_id    = citrus_usr.FN_SPLITVAL(@@currstring_value,3)            
              SET @@l_action      = citrus_usr.FN_SPLITVAL(@@currstring_value,4)            
                          
                          
              IF EXISTS(SELECT cliam.clia_crn_no         clia_arn_no            
                        FROM   client_accounts_mak       cliam            
                        WHERE  cliam.clia_deleted_ind    IN (0,4,8)            
                        AND    cliam.clia_crn_no       = @pa_ent_id            
                        AND    cliam.clia_acct_no      = @@l_clia_acctno            
                        AND    cliam.clia_excsm_id     = @@l_excsm_id)            
              BEGIN            
              --            
                UPDATE client_accounts_mak                  
                SET    clia_deleted_ind              = 3            
                WHERE  clia_deleted_ind              IN (0,4,8)            
                AND    clia_crn_no                   = @pa_ent_id            
                AND    clia_acct_no                  = @@l_clia_acctno            
                AND    clia_excsm_id                 = @@l_excsm_id            
              --            
              END            
                          
              BEGIN TRANSACTION            
                          
              SELECT @l_clia_id = ISNULL(MAX(clia_id),0)+1 FROM client_accounts_mak             
                          
              INSERT INTO client_accounts_mak            
              (clia_id            
              ,clia_crn_no            
              ,clia_acct_no            
              ,clia_excsm_id            
              ,clia_created_by            
              ,clia_created_dt            
              ,clia_lst_upd_by            
              ,clia_lst_upd_dt            
              ,clia_deleted_ind)            
               VALUES            
              (@l_clia_id            
              ,@pa_ent_id            
              ,@@l_clia_acctno            
              ,@@l_excsm_id            
              ,@pa_login_name            
              ,getdate()            
              ,@pa_login_name            
              ,getdate()            
              ,0)            
              --            
              SET @@l_error = @@error            
              --            
              IF @@l_error > 0            
              BEGIN            
              --            
                SELECT @l_excsm_desc           = excsm.excsm_desc            
                FROM   exch_seg_mstr             excsm       WITH (NOLOCK)            
                WHERE  excsm.excsm_id          = @@L_EXCSM_ID            
                AND    excsm.excsm_deleted_ind = 1            
                --            
                SET @@t_errorstr = '#'+'Could Not Change Access For '+ ISNULL(CONVERT(VARCHAR,@@l_clia_acctno),'') + ' ON '+@l_excsm_desc+@rowdelimiter+@@t_errorstr            
                --            
                ROLLBACK TRANSACTION            
              --            
              END            
             ELSE            
              BEGIN            
              --            
                COMMIT TRANSACTION            
              --            
                SET @@t_errorstr = 'Client-Accounts Successfully Inserted/Edited'+ @rowdelimiter            
                            
                EXEC pr_ins_upd_list @pa_ent_id, 'I','CLIENT ACCOUNTS', @pa_login_name,'*|~*','|*~|',''            
              --            
              END            
                          
            --            
            END            
          --            
          END            
        --            
        END            
      --            
      END            
    --            
    END            
    ELSE IF @pa_action='EDT'            
    BEGIN            
    --            
      WHILE @@remainingstring_id <> ''            
      BEGIN            
      --            
        SET @@foundat = 0            
        SET @@foundat = PATINDEX('%'+@delimeter_id+'%',@@remainingstring_id)            
        --            
        IF  @@foundat > 0            
        BEGIN            
          --            
          SET @@currstring_id      = SUBSTRING(@@remainingstring_id, 0,@@foundat)            
          SET @@remainingstring_id = SUBSTRING(@@remainingstring_id, @@foundat+@@delimeterlength_id,LEN(@@remainingstring_id)- @@foundat+@@delimeterlength_id)            
          --            
        END            
        ELSE            
        BEGIN            
          --            
          SET @@currstring_id      = @@remainingstring_id            
          SET @@remainingstring_id = ''            
        --            
        END            
        --            
        IF @@currstring_id <> ''            
        BEGIN            
        --            
          SET @delimeter_value        = '%'+ @rowdelimiter + '%'            
          SET @@delimeterlength_value = LEN(@rowdelimiter)            
          SET @@remainingstring_value = @pa_values            
          --            
          WHILE @@remainingstring_value <> ''            
          BEGIN            
          --            
            SET @@foundat = 0            
            SET @@foundat = PATINDEX('%'+@delimeter_value+'%',@@remainingstring_value)            
            --            
            IF @@foundat > 0            
            BEGIN            
              --            
              SET @@currstring_value      = SUBSTRING(@@remainingstring_value, 0,@@foundat)            
              SET @@remainingstring_value = SUBSTRING(@@remainingstring_value, @@foundat+@@delimeterlength_value,LEN(@@remainingstring_value)- @@foundat+@@delimeterlength_value)            
              --            
            END            
            ELSE            
            BEGIN            
              --            
              SET @@CURRSTRING_VALUE = @@REMAININGSTRING_VALUE            
              SET @@REMAININGSTRING_VALUE = ''            
            --            
            END            
            --            
            IF @@currstring_value <> ''            
            BEGIN            
            --       
              SET @@l_clia_acctno = citrus_usr.FN_SPLITVAL(@@currstring_value,1)            
              SET @@l_compm_id    = citrus_usr.FN_SPLITVAL(@@currstring_value,2)            
              SET @@l_excsm_id    = citrus_usr.FN_SPLITVAL(@@currstring_value,3)            
              SET @@l_action      = citrus_usr.FN_SPLITVAL(@@currstring_value,4)            
                          
              IF EXISTS(SELECT cliam.clia_crn_no         clia_arn_no            
                        FROM   client_accounts_mak       cliam            
                        WHERE  cliam.clia_deleted_ind    IN (0,4,8)            
                        AND    cliam.clia_crn_no        =@pa_ent_id            
                        AND    cliam.clia_acct_no       =@@l_clia_acctno            
                        AND    cliam.clia_excsm_id      =@@l_excsm_id)      
             BEGIN            
             --            
               UPDATE client_accounts_mak                  
               SET    clia_deleted_ind        = 3            
               WHERE  clia_deleted_ind        IN (0,4,8)            
               AND    clia_crn_no             = @pa_ent_id            
               AND    clia_acct_no            = @@l_clia_acctno            
               AND    clia_excsm_id           = @@l_excsm_id            
              --            
              END            
                          
                          
                          
                          
              IF EXISTS(SELECT excsm_desc            
                        FROM   #t_clia            
                        WHERE  clia_acct_no   = @@l_clia_acctno            
                        AND    excsm_id       = @@l_excsm_id            
                       )            
              BEGIN            
              --            
                DELETE FROM #t_clia            
                WHERE  clia_acct_no = @@l_clia_acctno            
                AND    excsm_id     = @@l_excsm_id            
              --            
              END            
              ELSE              
              BEGIN            
              --            
                          
                BEGIN TRANSACTION            
                            
                SELECT @l_clia_id = ISNULL(MAX(clia_id),0)+1 FROM client_accounts_mak             
            
                INSERT INTO client_accounts_mak            
                (clia_id            
                ,clia_crn_no            
                ,clia_acct_no            
                ,clia_excsm_id            
                ,clia_created_by            
                ,clia_created_dt            
                ,clia_lst_upd_by            
                ,clia_lst_upd_dt            
                ,clia_deleted_ind)            
                 VALUES            
                (@l_clia_id            
                ,@pa_ent_id            
                ,@@l_clia_acctno            
                ,@@l_excsm_id            
                ,@pa_login_name            
                ,getdate()            
                ,@pa_login_name            
                ,getdate()            
                ,0)            
                            
                SET @@l_error = @@error            
                --            
                IF @@l_error > 0            
                BEGIN            
                --            
                  SELECT @l_excsm_desc           = excsm.excsm_desc            
                  FROM   exch_seg_mstr             excsm       WITH (NOLOCK)            
                  WHERE  excsm.excsm_id          = @@L_EXCSM_ID            
                  AND    excsm.excsm_deleted_ind = 1            
                  --            
                  SET @@t_errorstr = '#'+'Could Not Change Access For '+ ISNULL(CONVERT(VARCHAR,@@l_clia_acctno),'') + ' ON '+@l_excsm_desc+@rowdelimiter+@@t_errorstr            
                  --            
                  ROLLBACK TRANSACTION            
                --            
                END            
                ELSE            
                BEGIN            
                --            
                  COMMIT TRANSACTION            
                --            
                  SET @@t_errorstr = 'Client-Accounts Successfully Inserted/Edited'+ @rowdelimiter            
                              
                  EXEC pr_ins_upd_list @pa_ent_id, 'I','CLIENT ACCOUNTS', @pa_login_name,'*|~*','|*~|',''            
                --            
                END            
                            
                            
              --              
              END            
                          
                          
              IF EXISTS(SELECT excsm_desc            
                        FROM   #t_clia            
                        )         
              BEGIN            
              --            
                          
                BEGIN TRANSACTION            
                            
                SET @@c_access_cursor =  CURSOR fast_forward FOR            
                SELECT clia_acct_no, excsm_id FROM #t_clia            
                --            
                OPEN @@c_access_cursor            
                FETCH NEXT FROM @@c_access_cursor INTO @l_acct_no, @l_excsm_id            
                --            
                  WHILE @@fetch_status = 0            
                  BEGIN            
                  --            
                    SELECT @l_clia_id = ISNULL(MAX(clia_id),0)+1 FROM client_accounts_mak             
            
                    INSERT INTO client_accounts_mak            
                    (clia_id            
                    ,clia_crn_no            
                    ,clia_acct_no            
                    ,clia_excsm_id            
                    ,clia_created_by            
                    ,clia_created_dt            
                 ,clia_lst_upd_by            
                    ,clia_lst_upd_dt            
                    ,clia_deleted_ind)            
                     VALUES            
                    (@l_clia_id            
                    ,@pa_ent_id            
                    ,@l_acct_no            
    ,@l_excsm_id            
                    ,@pa_login_name            
                    ,getdate()            
                    ,@pa_login_name            
                    ,getdate()            
                    ,4)              
                                
                    EXEC pr_ins_upd_list @pa_ent_id, 'D','CLIENT ACCOUNTS', @pa_login_name,'*|~*','|*~|',''            
                                
                    FETCH NEXT FROM @@c_access_cursor INTO @l_acct_no, @l_excsm_desc            
                  --            
                  END            
                            
                  CLOSE      @@c_access_cursor            
                  DEALLOCATE @@c_access_cursor            
                              
                  SET @@l_error = @@error            
                  --            
                  IF @@l_error > 0            
                  BEGIN            
                  --            
                    SELECT @l_excsm_desc           = excsm.excsm_desc            
                    FROM   exch_seg_mstr             excsm       WITH (NOLOCK)            
                    WHERE  excsm.excsm_id          = @@L_EXCSM_ID            
                    AND    excsm.excsm_deleted_ind = 1            
                    --            
                    SET @@t_errorstr = '#'+'Could Not Change Access For '+ ISNULL(CONVERT(VARCHAR,@@l_clia_acctno),'') + ' ON '+@l_excsm_desc+@rowdelimiter+@@t_errorstr            
                    --            
                    ROLLBACK TRANSACTION            
                  --            
                  END            
                  ELSE            
                  BEGIN            
                  --            
                    COMMIT TRANSACTION            
--            
                    SET @@t_errorstr = 'Client-Accounts Successfully Inserted/Edited'+ @rowdelimiter            
                  --            
                  END            
              --            
              END            
            --            
            END            
          --            
          END            
        --            
        END            
      --            
      END            
    --            
    END            
    ELSE IF @pa_action='APP'            
    BEGIN            
    --            
      print '1'            
      SET @@remainingstring_id  =@pa_id            
                  
      WHILE @@remainingstring_id <> ''            
  BEGIN            
      --            
        SET @@foundat = 0            
        SET @@foundat = PATINDEX('%'+@delimeter_id+'%',@@remainingstring_id)            
        --            
        IF  @@foundat > 0            
        BEGIN            
          --            
          SET @@currstring_id      = SUBSTRING(@@remainingstring_id, 0,@@foundat)            
          SET @@remainingstring_id = SUBSTRING(@@remainingstring_id, @@foundat+@@delimeterlength_id,LEN(@@remainingstring_id)- @@foundat+@@delimeterlength_id)            
          --            
        END            
        ELSE            
        BEGIN            
          --            
          SET @@currstring_id      = @@remainingstring_id            
          SET @@remainingstring_id = ''            
        --            
        END            
        --            
        IF @@currstring_id <> ''            
        BEGIN            
        --            
          SELECT @l_clia_deleted_ind = clia_deleted_ind             
                ,@@l_excsm_id        = clia_excsm_id            
                ,@@l_clia_ent_id     = clia_crn_no             
                ,@@l_clia_acctno     = clia_acct_no             
          FROM   client_accounts_mak             
          WHERE  clia_deleted_ind      IN (0,4,8)            
          AND    clia_id             = CONVERT(NUMERIC, @@currstring_id)            
          --            
          INSERT INTO #t_clia1            
          (clia_acct_no            
          ,excsm_compm_id            
          ,excsm_exch_cd            
          ,excsm_seg_cd            
          ,excsm_id            
          ,excsm_desc            
          )            
          SELECT clia.clia_acct_no         clia_acct_no            
               , excsm.excsm_compm_id      compm_id            
               , excsm.excsm_exch_cd       excsm_exch_cd            
               , excsm.excsm_seg_cd        excsm_seg_cd            
               , excsm.excsm_id            excsm_id            
               , excsm.excsm_desc          excsm_desc            
          FROM   client_accounts           clia   WITH (NOLOCK)            
     , exch_seg_mstr             excsm   WITH (NOLOCK)            
          WHERE  clia.clia_crn_no        = @@l_clia_ent_id            
          AND    clia.clia_deleted_ind   = 1            
          AND    excsm.excsm_deleted_ind = 1            
          AND    citrus_usr.fn_get_single_access(clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc) > 0            
             
          IF @l_clia_deleted_ind = 0            
          BEGIN            
          --            
            IF NOT EXISTS(SELECT *            
                          FROM  client_Accounts    WITH (NOLOCK)            
                          WHERE clia_crn_no      = @@l_clia_ent_id                 
                          AND   clia_acct_no     = @@l_clia_acctno            
                          AND   clia_deleted_ind = 1            
                          )            
            BEGIN            
            --            
                           
               --            
               SELECT @l_excsm_desc = excsm_desc            
               FROM   Exch_Seg_Mstr            
               WHERE  excsm_id      = @@l_excsm_id            
               --            
               SELECT @@l_bitrm_bit_location = bitrm_bit_location            
               FROM   bitmap_ref_mstr          WITH (NOLOCK)            
                    , exch_seg_mstr            WITH (NOLOCK)            
               WHERE  bitrm_child_cd         = excsm_desc            
               AND    excsm_id               = @@l_excsm_id            
               --            
               SET @@l_access1 = 0            
               --            
               SET @@l_access1 = POWER(2,@@l_bitrm_bit_location-1) | @@l_access1            
               --            
               INSERT INTO client_accounts            
               (clia_crn_no            
               ,clia_acct_no            
               ,clia_access1            
               ,clia_status1   
               ,clia_access2            
               ,clia_status2            
               ,clia_created_by            
               ,clia_created_dt            
               ,clia_lst_upd_by            
 ,clia_lst_upd_dt            
               ,clia_deleted_ind)            
        VALUES            
               (@@l_clia_ent_id             
               ,@@l_clia_acctno            
               ,@@l_access1            
               ,0            
               ,0            
               ,0            
               ,@pa_login_name            
               ,getdate()            
               ,@pa_login_name            
               ,getdate()            
               ,1            
               )              
               --             
               SET @@l_error = @@error            
               --            
               IF @@l_error > 0            
               BEGIN            
               --            
                 /*SELECT @l_excsm_desc           = excsm.excsm_desc            
                 FROM   exch_seg_mstr             excsm       WITH (NOLOCK)            
                 WHERE  excsm.excsm_id          = @@L_EXCSM_ID            
                 AND    excsm.excsm_deleted_ind = 1            
                 --            
                 SET @@t_errorstr = 'Could Not Change Access For '+ ISNULL(CONVERT(VARCHAR,@@l_clia_acctno),'') + ' ON '+@l_excsm_desc+@rowdelimiter+@@t_errorstr*/            
                 SET @@t_errorstr = convert(varchar,@@l_error)            
                 --            
                             
               --            
               END            
               ELSE            
               BEGIN            
               --            
                            
                --            
                SET @@t_errorstr = 'Client-Accounts Successfully Inserted/Edited'+ @rowdelimiter            
               --            
               END            
             --            
             END            
             ELSE            
             BEGIN            
             --            
               SELECT @l_excsm_desc           = excsm.excsm_desc            
               FROM   exch_seg_mstr excsm       WITH (NOLOCK)            
               WHERE  excsm.excsm_id          = @@l_excsm_id            
               AND    excsm.excsm_deleted_ind = 1            
                                        --            
               EXEC pr_set_access @@l_clia_ent_id, @@l_clia_acctno, @l_excsm_desc, 'Y', @@l_msg            
             --            
             END            
             --            
             UPDATE client_accounts_mak             
             SET    clia_deleted_ind = 1            
             WHERE  clia_deleted_ind = 0            
             AND    clia_id          = CONVERT(NUMERIC,@@currstring_id)            
             --            
             SET @@l_error = @@error            
             --            
             IF @@l_error > 0            
             BEGIN            
             --            
               SET @@t_errorstr = convert(varchar,@@l_error)            
               --            
                           
             --            
             END            
          --            
          END            
          ELSE IF @l_clia_deleted_ind = 4            
          BEGIN            
          --            
                        
                        
            SELECT @l_excsm_desc     = excsm_desc             
            FROM   exch_seg_mstr             
            WHERE  excsm_id          = (select clia_excsm_id from client_accounts_mak where clia_id = CONVERT(NUMERIC,@@currstring_id))            
            and    excsm_deleted_ind = 1            
                        
            EXEC pr_set_access @@l_clia_ent_id, @@l_clia_acctno, @l_excsm_desc, 'N', @@l_msg             
                        
            UPDATE client_accounts_mak             
            SET    clia_deleted_ind = 5            
            WHERE  clia_deleted_ind = 4            
            AND    clia_id          = CONVERT(NUMERIC,@@currstring_id)            
                        
            SET @@l_error = @@error            
            --            
            IF @@l_error > 0            
            BEGIN            
            --            
              SET @@t_errorstr = convert(varchar,@@l_error)            
              --            
                          
            --            
            END            
            ELSE            
            BEGIN            
            --            
         SET @@t_errorstr = 'Client-Accounts Successfully Inserted/Edited'+ @rowdelimiter            
            --            
            END            
          --            
          END            
          ELSE IF @l_clia_deleted_ind = 8            
          BEGIN            
          --            
                        
            IF EXISTS(SELECT excsm_desc            
                      FROM   #t_clia1            
                      WHERE  clia_acct_no   = @@l_clia_acctno            
                      AND    excsm_id       = @@l_excsm_id            
                      )            
            BEGIN            
            --            
               DELETE FROM #t_clia1            
               WHERE  clia_acct_no = @@l_clia_acctno            
               AND    excsm_id     = @@l_excsm_id            
 --            
               SELECT @l_excsm_desc           = excsm.excsm_desc            
               FROM   exch_seg_mstr             excsm  WITH (NOLOCK)            
               WHERE  excsm.excsm_id          = @@l_excsm_id            
               AND    excsm.excsm_deleted_ind = 1            
               --            
               EXEC PR_SET_ACCESS @pa_ent_id, @@l_clia_acctno, @l_excsm_desc, 'Y', @@l_msg            
               --            
               IF LTRIM(RTRIM(@@l_msg)) IS NOT NULL            
               BEGIN            
               --            
                 SET @@t_errorstr = @@l_msg            
               --            
               END            
               ELSE            
               BEGIN            
               --            
                 SET @@t_errorstr = 'Client-Accounts Successfully Inserted/Edited'+ @rowdelimiter            
               --            
END            
            --               
            END            
            ELSE            
            BEGIN            
            --            
              IF EXISTS(SELECT clia_access1            
                        FROM   client_accounts         clia            
                        WHERE  clia.clia_crn_no      = @@l_clia_ent_id            
                        AND    clia.clia_acct_no     = @@l_clia_acctno            
                        AND    clia.clia_deleted_ind = 1)            
              BEGIN                      
              --            
                SELECT @l_excsm_desc           = excsm.excsm_desc            
                FROM   exch_seg_mstr             excsm  WITH (NOLOCK)            
                WHERE  excsm.excsm_id          = @@l_excsm_id            
                AND    excsm.excsm_deleted_ind = 1            
                --            
                EXEC PR_SET_ACCESS @@l_clia_ent_id, @@l_clia_acctno, @l_excsm_desc, 'Y', @@l_msg            
              --            
              END            
              ELSE            
              BEGIN            
              --            
SELECT @@l_bitrm_bit_location = bitrm_bit_location            
                FROM   bitmap_ref_mstr          WITH (NOLOCK)            
                     , exch_seg_mstr            WITH (NOLOCK)            
                WHERE  bitrm_child_cd         = excsm_desc            
                AND    excsm_id               = @@l_excsm_id            
            
                SET @@l_access1 = 0            
                --            
                SET @@l_access1 = POWER(2,@@l_bitrm_bit_location-1) | @@l_access1            
                --             
                INSERT INTO client_accounts            
                (clia_crn_no            
                ,clia_acct_no            
                ,clia_access1            
                ,clia_status1            
                ,clia_access2            
                ,clia_status2            
                ,clia_created_by            
                ,clia_created_dt            
                ,clia_lst_upd_by            
                ,clia_lst_upd_dt            
                ,clia_deleted_ind            
                )            
                VALUES            
                (@@l_clia_ent_id             
                ,@@l_clia_acctno            
                ,@@l_access1            
                ,0            
                ,0            
                ,0            
                ,@pa_login_name            
                ,getdate()            
                ,@pa_login_name            
                ,getdate()            
                ,1            
                )            
                --            
                SET @@l_error = @@error            
                --            
                IF @@l_error > 0            
                BEGIN            
                --            
                  SET @@t_errorstr = convert(varchar,@@l_error)            
                  --            
                              
                --            
                END            
                ELSE            
                BEGIN            
                --            
                  SET @@t_errorstr = 'Client-Accounts Successfully Inserted/Edited'+ @rowdelimiter            
                --            
                END            
              --            
              END            
            --            
            END            
            --                         
            UPDATE client_accounts_mak             
            SET    clia_deleted_ind = 9            
            WHERE  clia_deleted_ind = 8            
            AND    clia_id          = CONVERT(NUMERIC,@@currstring_id)            
            --                        
            SET @@l_error = @@error            
            --            
            IF @@l_error > 0            
            BEGIN            
            --            
              SET @@t_errorstr = convert(varchar,@@l_error)            
              --            
                          
            --            
            END     
           ELSE            
            BEGIN            
            --            
              SET @@t_errorstr = 'Client-Accounts Successfully Inserted/Edited'+ @rowdelimiter            
            --            
            END            
          --            
          END            
                    
        --            
        END            
      --            
      END            
      --move to pr_app_client            
      --EXEC pr_ins_upd_list @pa_ent_id, 'A','CLIENT ACCOUNTS', @pa_login_name,'*|~*','|*~|',''            
    --            
    END            
    ELSE IF @pa_action='REJ'            
    BEGIN            
    --            
      WHILE @@remainingstring_id <> ''            
      BEGIN            
      --            
        SET @@foundat = 0            
        SET @@foundat = PATINDEX('%'+@delimeter_id+'%',@@remainingstring_id)            
        --            
        IF  @@foundat > 0            
        BEGIN            
          --            
          SET @@currstring_id      = SUBSTRING(@@remainingstring_id, 0,@@foundat)            
          SET @@remainingstring_id = SUBSTRING(@@remainingstring_id, @@foundat+@@delimeterlength_id,LEN(@@remainingstring_id)- @@foundat+@@delimeterlength_id)            
     --            
        END            
        ELSE            
        BEGIN            
          --            
          SET @@currstring_id      = @@remainingstring_id            
          SET @@remainingstring_id = ''            
        --            
        END            
        --            
        IF @@currstring_id <> ''            
        BEGIN            
        --            
          UPDATE client_accounts_mak             
          SET    clia_deleted_ind    = 3            
          WHERE  clia_deleted_ind      IN (0,4,8)            
          AND    clia_id             = CONVERT(NUMERIC , @@currstring_id)            
          --            
          SET @@l_error = @@error            
          --            
          IF @@l_error > 0            
          BEGIN            
          --            
            SET @@t_errorstr = convert(varchar,@@l_error)            
            --            
                        
          --            
          END            
        --            
        END            
      --            
      END            
    --            
    END            
  --            
  END            
--            
SET @pa_msg = @@t_errorstr            
--            
END

GO
