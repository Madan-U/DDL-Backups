-- Object: PROCEDURE citrus_usr.pr_ins_upd_clim_bak_06102015
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create  PROCEDURE [citrus_usr].[pr_ins_upd_clim_bak_06102015](@pa_id          VARCHAR(8000)        
                               ,@pa_action      VARCHAR(20)        
                               ,@pa_login_name  VARCHAR(20)        
                               ,@pa_values      VARCHAR(8000)        
                               ,@pa_chk_yn      NUMERIC        
                               ,@rowdelimiter   CHAR(4) =  '*|~*'        
                               ,@coldelimiter   CHAR(4)  = '|*~|'        
                               ,@pa_output      VARCHAR(8000) OUTPUT        
                               ,@pa_msg         VARCHAR(8000) OUTPUT        
)        
AS        
/*        
*********************************************************************************        
 SYSTEM         : Citrus        
 MODULE NAME    : pr_ins_upd_clim        
 DESCRIPTION    : THIS PROCEDURE WILL ADD NEW CLIENT DETAILS VALUES TO  CLIENT_MSTR        
 COPYRIGHT(C)   : Marketplace technologies pvt.ltd.        
 VERSION HISTORY:        
 VERS.  AUTHOR            DATE        REASON        
 -----  -------------     ----------   -------------------------------------------------        
 1.0    HARI R            30-AUG-2006  INITIAL VERSION.        
 2.0    SUKHVINDER/TUSHAR 29-DEC-2006  INITIAL VERSION.        
 3.0    TUSHAR            01-APR-2007  ADD MAKER-CHECKER FUNCTIONALITY        
-----------------------------------------------------------------------------------*/        
BEGIN        
--   
if @pa_login_name =''
set @pa_login_name ='HO'     
  SET NOCOUNT ON        
  --        
  DECLARE @l_errorstr          VARCHAR(8000)        
         ,@l_cmconcm_id        BIGINT        
         ,@l_concm_id          BIGINT        
         ,@l_error             BIGINT        
         ,@delimeter           VARCHAR(10)        
         ,@delimeter_id        VARCHAR(10)         
         ,@remainingstring     VARCHAR(8000)        
         ,@remainingstring_id  VARCHAR(8000)        
         ,@currstring_id       VARCHAR(8000)        
         ,@currstring          VARCHAR(8000)        
         ,@remainingstring2    VARCHAR(8000)        
         ,@currstring2         VARCHAR(8000)        
         ,@foundat             INTEGER        
         ,@delimeterlength     INT        
         ,@delimeterlength_id  INT         
         ,@l_counter           INT        
         ,@l_clim_name1        VARCHAR(100)        
         ,@l_clim_name2        VARCHAR(50)        
         ,@l_clim_name3        VARCHAR(50)        
         ,@l_clim_short_name   VARCHAR(200)        
         ,@l_clim_gender       VARCHAR(20)        
         ,@l_clim_dob          DATETIME        
         ,@l_clim_enttm_cd     VARCHAR(20)        
         ,@l_clim_stam_cd      VARCHAR(20)        
         ,@l_clim_clicm_cd     VARCHAR(20)        
         ,@l_clim_crn_no       NUMERIC        
         ,@l_pa_output         VARCHAR(8000)        
         ,@l_clicm_id          NUMERIC         
         ,@l_enttm_id          NUMERIC        
         ,@l_deleted_ind       CHAR(1)        
         ,@l_clim_rmks         VARCHAR(1000)        
         ,@l_clim_id           NUMERIC        
         ,@l_action            CHAR(1)        
         ,@l_clim_sbum_id      NUMERIC        
         ,@l_id                NUMERIC        
         ,@l_rmks              varchar(8000)        
         ,@l_edt_del_id        NUMERIC        
         ,@l_clim_pangirno     VARCHAR(25)        
         ,@l_entpm_prop_id     NUMERIC        
         ,@l_values            VARCHAR(1000)        
         ,@l_entdm_id          NUMERIC         
         ,@l_dtls_values       VARCHAR(8000)        
  --          
  SET @l_counter   = 1        
  SET @l_error    = 0        
  SET @l_errorstr = ''        
  --        
  SET @delimeter_id      = '%'+ @rowdelimiter + '%'        
  SET @delimeter         = '%'+ @coldelimiter + '%'        
  SET @delimeterlength   = LEN(@coldelimiter)        
  --        
  SET @remainingstring_id = @pa_id        
  SET @remainingstring2   = @pa_values        
  --        
  WHILE @remainingstring2 <> ''        
BEGIN        
  --        
    SET @foundat = 0        
    SET @foundat =  PATINDEX('%'+@delimeter+'%',@remainingstring2)        
    --        
    IF @foundat > 0        
    BEGIN     
      --        
      SET @currstring2      = SUBSTRING(@remainingstring2, 0,@foundat)        
      SET @remainingstring2 = SUBSTRING(@remainingstring2, @foundat+@delimeterlength,LEN(@remainingstring2)- @foundat+@delimeterlength)        
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
    --IF @currstring2 <> ''        
    --BEGIN        
    --        
      IF @l_counter=1  BEGIN SET @l_clim_name1             = @currstring2 END        
      IF @l_counter=2  BEGIN SET @l_clim_name2             = @currstring2 END        
      IF @l_counter=3  BEGIN SET @l_clim_name3             = @currstring2 END        
      IF @l_counter=4  BEGIN SET @l_clim_short_name        = @currstring2 END        
      IF @l_counter=5  BEGIN SET @l_clim_gender            = @currstring2 END        
      IF @l_counter=6  BEGIN SET @l_clim_dob               = CASE WHEN @currstring2 = '' THEN CONVERT(DATETIME,'01/01/1900',104)  ELSE CONVERT(DATETIME,@currstring2,103) END END      
      IF @currstring2 <> ''      
      IF @l_counter=7  BEGIN SET @l_clim_enttm_cd          = ISNULL(LTRIM(RTRIM(@currstring2)),NULL) END        
      IF @l_counter=8  BEGIN SET @l_clim_stam_cd           = @currstring2 END        
      IF @currstring2 <> ''      
      IF @l_counter=9  BEGIN SET @l_clim_clicm_cd          = ISNULL(LTRIM(RTRIM(@currstring2)),NULL) END        
      IF @l_counter=10 BEGIN SET @l_clim_sbum_id           = convert(numeric,@currstring2) END        
      IF @l_counter=11 BEGIN SET @l_clim_pangirno          = @currstring2 END        
    --        
    --END  --END OF CURRSTRING2        
    --        
    SET @l_counter = @l_counter+1        
  --        
  END -- END OF WHILE FOR CURRSTRING2        
  --        
  --***CHANGES DONE ON N16/03/2006--        
  SET @l_clicm_id = NULL        
  SET @l_enttm_id = NULL        
  --        
  SELECT @l_clicm_id = clicm.clicm_id        
        ,@l_enttm_id = enttm.enttm_id        
  FROM   client_ctgry_mstr         clicm        
        ,entity_type_mstr          enttm        
        ,enttm_clicm_mapping       entcm        
  WHERE  clicm.clicm_id          = entcm.entcm_clicm_id        
  AND    enttm.enttm_id          = entcm.entcm_enttm_id        
  AND    clicm.clicm_deleted_ind = 1        
  AND    enttm.enttm_deleted_ind = 1        
  AND    entcm.entcm_deleted_ind = 1        
  AND    clicm.clicm_cd          = @l_clim_clicm_cd        
  AND    enttm.enttm_cd          = @l_clim_enttm_cd        
  ----------***-------------          
  SET @delimeter        = '%'+ @rowdelimiter + '%'        
  SET @delimeterlength  = LEN(@rowdelimiter)        
  SET @remainingstring  = @pa_id        
  --        
    WHILE @remainingstring <> ''        
    BEGIN        
      --        
      SET @foundat = 0        
      SET @foundat =  PATINDEX('%'+@delimeter+'%',@remainingstring)        
      --        
      IF @foundat > 0        
      BEGIN        
      --        
        SET @currstring      = SUBSTRING(@remainingstring, 0,@foundat)        
        SET @remainingstring = SUBSTRING(@remainingstring, @foundat+@delimeterlength,LEN(@remainingstring)- @foundat+@delimeterlength)        
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
      BEGIN        
      --        
        IF @pa_chk_yn = 0        
        BEGIN        
        --        
          IF @pa_action = 'INS'        
          BEGIN        
          --         
            BEGIN TRANSACTION        
            --        
            SELECT @l_clim_crn_no     = bitrm_bit_location        
            FROM   bitmap_ref_mstr    WITH (NOLOCK)        
            WHERE  bitrm_parent_cd    ='ENTITY_ID' AND bitrm_child_cd='ENTITY_ID'        
            --        
            UPDATE bitmap_ref_mstr    WITH (ROWLOCK)        
            SET    bitrm_bit_location = bitrm_bit_location+1        
            WHERE  bitrm_parent_cd    = 'ENTITY_ID' AND bitrm_child_cd='ENTITY_ID'        
            --        
            INSERT INTO client_mstr        
            ( clim_crn_no        
            , clim_name1        
            , clim_name2        
            , clim_name3        
            , clim_short_name        
            , clim_gender        
            , clim_dob        
            , clim_enttm_cd        
            , clim_stam_cd        
            , clim_clicm_cd        
            , clim_created_by        
            , clim_created_dt        
            , clim_lst_upd_by        
            , clim_lst_upd_dt        
            , clim_deleted_ind        
            , clim_sbum_id)        
            VALUES        
            ( @l_clim_crn_no        
            , @l_clim_name1        
            , @l_clim_name2        
            , @l_clim_name3        
            , @l_clim_short_name        
            , @l_clim_gender        
            , @l_clim_dob        
            , @l_clim_enttm_cd        
            , @l_clim_stam_cd        
            , @l_clim_clicm_cd        
            , @pa_login_name        
            , GETDATE()        
            , @pa_login_name        
            , GETDATE()        
            , 1        
            , @l_clim_sbum_id)        
            --        
            SET @l_error = @@error        
            --        
            IF @l_error > 0        
            BEGIN        
            --        
              SET @l_errorstr = '#'+@l_errorstr+CONVERT(VARCHAR,'0')+@coldelimiter+ISNULL(@l_clim_name1,'')+@coldelimiter+ISNULL(@l_clim_name2,'')+@coldelimiter+ISNULL(@l_clim_name3,'')+@coldelimiter+ISNULL(CONVERT(VARCHAR,@l_clicm_id),'')+@coldelimiter+ 
 
    
ISNULL(CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@coldelimiter+@rowdelimiter         
                                      
              --        
              ROLLBACK TRANSACTION        
              --        
            END        
            ELSE        
            BEGIN        
            --        
              COMMIT TRANSACTION        
              --        
              --pan_gir_no changed by Tushar on 18/07/2007        
                      
              /*        
                    ,client_ctgry_mstr         clicm        
                    ,entity_type_mstr          enttm          
              WHERE  entpm.entpm_cd          ='PAN_GIR_NO'         
              AND    entpm.entpm_clicm_id    = clicm.clicm_id        
              AND    entpm.entpm_enttm_id    = enttm.enttm_id        
              AND    enttm.enttm_cd          = @l_clim_enttm_cd        
              AND    clicm.clicm_cd          = @l_clim_clicm_cd        
              AND    entpm_deleted_ind       = 1*/        
                      
              SELECT @l_entpm_prop_id        = entpm_prop_id         
              FROM   entity_property_mstr      entpm         
              WHERE  entpm.entpm_cd          ='PAN_GIR_NO'         
              AND    entpm_deleted_ind       = 1        
        
              SELECT @l_entdm_id             = entdm_id        
              FROM   entpm_dtls_mstr           entdm        
              where  entdm.entdm_cd          = 'PAN_NAME'           
              AND    entdm_deleted_ind       = 1           
              --        
              IF ISNULL(@l_entpm_prop_id,0) <> 0 AND  ISNULL(@l_clim_pangirno,'') <> ''        
              BEGIN         
              --        
                SET @l_values       = CONVERT(VARCHAR,@l_entpm_prop_id)+@coldelimiter+ISNULL(@l_clim_pangirno,'')+@coldelimiter+@rowdelimiter         
                SET @l_dtls_values  = CONVERT(VARCHAR,@l_entpm_prop_id)+@coldelimiter+CONVERT(VARCHAR,@l_entdm_id)+@coldelimiter+@l_clim_name1+' '+ isnull(@l_clim_name2,'') + ' ' + isnull(@l_clim_name3,'') +@coldelimiter+@rowdelimiter         
                --            
                EXEC pr_ins_upd_entp '1', 'EDT', @pa_login_name, @l_clim_crn_no, '', @l_values, @l_dtls_values , @pa_chk_yn, '*|~*','|*~|',''         
                --        
              END        
              --pan_gir_no changed by Tushar on 18/07/2007        
              --         
              SET @l_pa_output = CONVERT(VARCHAR,ISNULL(@l_clim_crn_no,''))+@coldelimiter+ISNULL(@l_clim_name1,'')+@coldelimiter+ISNULL(@l_clim_name2,'')+@coldelimiter+ISNULL(@l_clim_name3,'')+@coldelimiter+ISNULL(CONVERT(VARCHAR,@l_clicm_id),'')+@coldelimiter+ISNULL(CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter+@rowdelimiter        
            --        
            END        
            --        
          END        
          --        
        IF @pa_action = 'EDT'        
        BEGIN        
         --        
           BEGIN TRANSACTION        
           --        
             /*UPDATE client_mstr     WITH (ROWLOCK)        
             SET    clim_name1       = (CASE WHEN @l_clim_name1             <> '' THEN @l_clim_name1      ELSE cm2.clim_name1      END)        
                   ,clim_name2       = (CASE WHEN @l_clim_name2             <> '' THEN @l_clim_name2      ELSE cm2.clim_name2      END)        
                   ,clim_name3       = (CASE WHEN @l_clim_name3             <> '' THEN @l_clim_name3      ELSE cm2.clim_name3      END)        
                   ,clim_short_name  = (CASE WHEN @l_clim_short_name        <> '' THEN @l_clim_short_name ELSE cm2.clim_short_name END)        
                   ,clim_gender      = (CASE WHEN @l_clim_gender            <> '' THEN @l_clim_gender     ELSE cm2.clim_gender     END)        
                   ,clim_dob         = (CASE WHEN @l_clim_dob               <> '' THEN @l_clim_dob        ELSE cm2.clim_dob        END)        
                   ,clim_enttm_cd    = (CASE WHEN @l_clim_enttm_cd          <> '' THEN @l_clim_enttm_cd   ELSE cm2.clim_enttm_cd   END)        
                   ,clim_stam_cd     = (CASE WHEN @l_clim_stam_cd           <> '' THEN @l_clim_stam_cd    ELSE cm2.clim_stam_cd    END)        
                   ,clim_clicm_cd    = (CASE WHEN @l_clim_clicm_cd          <> '' THEN @l_clim_clicm_cd   ELSE cm2.clim_clicm_cd   END)        
                   ,clim_sbum_id     = (CASE WHEN ISNULL(@l_clim_sbum_id,0) <> 0  THEN @l_clim_sbum_id    ELSE cm2.clim_sbum_id  END)        
                   ,clim_lst_upd_by  = @PA_LOGIN_NAME        
                   ,clim_lst_upd_dt  = GETDATE()        
             FROM   client_mstr cm2        
             WHERE  clim_crn_no      = @pa_id        
             AND    clim_deleted_ind = 1*/        
                     
             UPDATE client_mstr        WITH (ROWLOCK)        
             SET    clim_name1       = @l_clim_name1        
                   ,clim_name2       = @l_clim_name2        
                   ,clim_name3       = @l_clim_name3             
                   ,clim_short_name  = @l_clim_short_name        
                   ,clim_gender      = @l_clim_gender          
                   ,clim_dob         = @l_clim_dob             
                   ,clim_enttm_cd    = @l_clim_enttm_cd        
                   ,clim_stam_cd     = @l_clim_stam_cd         
                   ,clim_clicm_cd    = @l_clim_clicm_cd        
                   ,clim_sbum_id     = @l_clim_sbum_id        
                   ,clim_lst_upd_by  = @PA_LOGIN_NAME        
                   ,clim_lst_upd_dt  = GETDATE()        
             FROM   client_mstr cm2        
             WHERE  clim_crn_no      = @pa_id        
             AND    clim_deleted_ind = 1        
             --        
             SELECT @l_clim_name1    = clim.clim_name1        
                   ,@l_clim_name2    = clim.clim_name2        
                   ,@l_clim_name3   = clim.clim_name3        
             FROM   client_mstr clim   WITH(NOLOCK)        
             WHERE  clim_crn_no      = @pa_id        
             AND    clim_deleted_ind = 1        
             --        
             SET @l_error = @@error        
             --        
             IF @l_error > 0        
             BEGIN        
             --        
               SET @l_errorstr='#'+@l_errorstr+@currstring+@coldelimiter+CONVERT(VARCHAR,ISNULL(@pa_id,''))+@coldelimiter+ISNULL(@l_clim_name1,'')+@coldelimiter+ISNULL(@l_clim_name2,'')+@coldelimiter+ISNULL(@l_clim_name3,'')+@coldelimiter+ISNULL(@l_clim_short_name,'')+@coldelimiter+ISNULL(@l_clim_gender,'')+@coldelimiter+@l_clim_dob+@coldelimiter+ISNULL(@l_clim_enttm_cd,'')+@coldelimiter+ISNULL(@l_clim_stam_cd,'')+@coldelimiter+CONVERT(VARCHAR,@l_clim_clicm_cd)+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter        
               --        
               ROLLBACK TRANSACTION        
                --        
              END        
              ELSE        
              BEGIN        
              --        
                COMMIT TRANSACTION        
                --        
                SET @l_pa_output = CONVERT(VARCHAR,ISNULL(@pa_id,''))+@coldelimiter+ISNULL(@l_clim_name1,'')+@coldelimiter+ISNULL(@l_clim_name2,'')+@coldelimiter+ISNULL(@l_clim_name3,'')+@coldelimiter+ISNULL(CONVERT(VARCHAR,@l_clicm_id),'')+@coldelimiter+
ISNULL(CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter+@rowdelimiter        
              --        
              END        
          END--EDIT END        
          --        
          IF @pa_action = 'DEL'        
          BEGIN        
          --        
            BEGIN TRANSACTION        
            --        
            SELECT @l_clim_name1   = clim.clim_name1              
                 , @l_clim_name2   = clim.clim_name2              
                 , @l_clim_name3   = clim.clim_name3              
            FROM  client_mstr clim   WITH(NOLOCK)              
            WHERE clim_crn_no      = @PA_ID              
            AND   clim_deleted_ind = 1              
            --        
            UPDATE client_mstr WITH(ROWLOCK)        
            SET    clim_deleted_ind = 0        
                  ,clim_lst_upd_by  = @pa_login_name        
           ,clim_lst_upd_dt  = GETDATE()        
            WHERE  clim_crn_no      = @pa_id        
            AND    clim_deleted_ind = 1        
            --        
            SET @l_error = @@error        
            --        
            IF @l_error > 0        
            BEGIN        
            --        
             SET @l_errorstr='#'+@l_errorstr+@currstring+@coldelimiter+CONVERT(VARCHAR,ISNULL(@pa_id,''))+@coldelimiter+ISNULL(@l_clim_name1,'')+@coldelimiter+ISNULL(@l_clim_name2,'')+@coldelimiter+ISNULL(@l_clim_name3,'')+@coldelimiter+ISNULL(@l_clim_short_name,'')+@coldelimiter+ISNULL(@l_clim_gender,'')+@coldelimiter+@l_clim_dob+@coldelimiter+ISNULL(@l_clim_enttm_cd,'')+@coldelimiter+ISNULL(@l_clim_stam_cd,'')+@coldelimiter+CONVERT(VARCHAR,@l_clim_clicm_cd)+@coldelimiter+CONVERT(VARCHAR,@l_error)+@rowdelimiter        
             --        
             ROLLBACK TRANSACTION        
            --        
            END        
            ELSE        
            BEGIN        
            --        
             COMMIT TRANSACTION        
             --                       
             SET @l_pa_output = CONVERT(VARCHAR,ISNULL(@pa_id,''))+@coldelimiter+ISNULL(@l_clim_name1,'')+@coldelimiter+ISNULL(@l_clim_name2,'')+@coldelimiter+ISNULL(@l_clim_name3,'')+@coldelimiter+ISNULL(CONVERT(VARCHAR,@l_clicm_id),0)+@coldelimiter+ISNULL(CONVERT(VARCHAR,@l_enttm_id),0)+@coldelimiter+@rowdelimiter        
            --        
            END        
         --        
         END        
        --        
        END--@PA_CHK_YN END        
        IF @pa_chk_yn = 1  or @pa_chk_yn = 2        
        BEGIN        
        --        
          IF @pa_action = 'INS' or @pa_action='EDT' or @pa_action='DEL'    
          BEGIN        
          --        
            BEGIN TRANSACTION         
            --        
                    
            IF EXISTS(SELECT climm.clim_crn_no  clim_crn_no         
                      FROM   client_mstr_mak    climm        
                      WHERE  climm.clim_deleted_ind in (0,4,8)        
                      AND    climm.clim_crn_no = @pa_id)        
            BEGIN        
            --  
              IF ISNULL(@l_clim_clicm_cd,'') ='' AND ISNULL(@l_clim_enttm_cd,'') = ''        
              begin  
              --  
      if exists(SELECT CLIM_ID FROM   client_mstr_mak    climm        
       WHERE  climm.clim_deleted_ind in (0,4,8)        
       AND    climm.clim_crn_no = @pa_id       
       and    isnull(climm.clim_clicm_cd,'') <> ''                 
       and    isnull(climm.clim_enttm_cd,'') <> '')  
      begin    
       select @l_clim_clicm_cd = climm.clim_clicm_cd  
         , @l_clim_enttm_cd = climm.clim_enttm_cd  
       FROM   client_mstr_mak    climm        
       WHERE  climm.clim_deleted_ind in (0,4,8)        
       AND    climm.clim_crn_no = @pa_id       
       and    isnull(climm.clim_clicm_cd,'') <> ''                 
       and    isnull(climm.clim_enttm_cd,'') <> ''   
      end  
                  ELSE  
                  BEGIN  
                  --  
                      select @l_clim_clicm_cd = clim.clim_clicm_cd  
         , @l_clim_enttm_cd = clim.clim_enttm_cd  
       FROM   client_mstr    clim        
       WHERE  clim.clim_deleted_ind = 1  
       AND    clim.clim_crn_no = @pa_id       
       and    isnull(clim.clim_clicm_cd,'') <> ''                 
       and    isnull(clim.clim_enttm_cd,'') <> ''   
                  --     
                  END   
              --  
              end  
                
  
    
              UPDATE client_mstr_mak        
              SET    clim_deleted_ind =  3        
              WHERE  clim_deleted_ind IN (0,4,8)        
              AND    clim_crn_no      =  @pa_id        
            --        
            END        
            --                    
            IF @pa_action = 'INS'        
            BEGIN        
            --        
              SELECT @l_clim_crn_no     = bitrm_bit_location        
              FROM   bitmap_ref_mstr    WITH (NOLOCK)        
              WHERE  bitrm_parent_cd    ='ENTITY_ID' AND bitrm_child_cd='ENTITY_ID'        
              --        
              UPDATE bitmap_ref_mstr    WITH (ROWLOCK)        
              SET    bitrm_bit_location = bitrm_bit_location+1        
              WHERE  bitrm_parent_cd    = 'ENTITY_ID' AND bitrm_child_cd='ENTITY_ID'        
            --        
            END        
            --        
        
            IF @PA_ACTION='EDT' AND EXISTS(SELECT CLIM_CRN_NO FROM CLIENT_MSTR WHERE CLIM_CRN_NO = convert(numeric, @pa_id))         
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
        
            SELECT @l_clim_id = ISNULL(MAX(clim_id),0)+1 FROM client_mstr_mak         
            --        
  
  
  
  
            INSERT INTO client_mstr_mak        
            (clim_id         
            ,clim_crn_no        
            ,clim_name1        
            ,clim_name2        
            ,clim_name3        
            ,clim_short_name        
            ,clim_gender        
            ,clim_dob        
            ,clim_enttm_cd        
            ,clim_stam_cd        
            ,clim_clicm_cd        
            ,clim_created_by        
            ,clim_created_dt        
            ,clim_lst_upd_by        
            ,clim_lst_upd_dt        
            ,clim_deleted_ind        
            ,clim_sbum_id)        
            VALUES        
            (@l_clim_id        
            ,CASE @pa_action WHEN 'INS' THEN @l_clim_crn_no   
                             WHEN 'EDT' THEN convert(numeric, @pa_id)        
                             WHEN 'DEL' THEN convert(numeric, @pa_id)  END        
            ,@l_clim_name1        
            ,@l_clim_name2        
            ,@l_clim_name3        
            ,@l_clim_short_name        
            ,@l_clim_gender        
            ,@l_clim_dob        
            ,@l_clim_enttm_cd        
            ,@l_clim_stam_cd        
            ,@l_clim_clicm_cd        
            ,@pa_login_name        
            ,GETDATE()        
            ,@pa_login_name        
            ,GETDATE()        
            ,CASE @pa_action WHEN 'INS' THEN 0        
                             WHEN 'EDT' THEN @L_EDT_DEL_ID         
                             WHEN 'DEL' THEN 4 END        
            ,@l_clim_sbum_id                         
             )        
            --        
            SET @l_error = @@error        
            --        
            IF @l_error > 0        
            BEGIN        
            --        
              SET @l_errorstr = '#'+@l_errorstr+CONVERT(VARCHAR,'0')+@coldelimiter+ISNULL(@l_clim_name1,'')+@coldelimiter+ISNULL(@l_clim_name2,'')+@coldelimiter+ISNULL(@l_clim_name3,'')+@coldelimiter+ISNULL(CONVERT(VARCHAR,@l_clicm_id),'')+@coldelimiter+ISNULL(CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@coldelimiter+@rowdelimiter         
              --        
              ROLLBACK TRANSACTION         
             --        
            END        
            ELSE        
            BEGIN        
            --        
              COMMIT TRANSACTION        
              --        
              SELECT @l_action = CASE @pa_action WHEN 'INS' THEN 'I' WHEN 'EDT' THEN 'E' WHEN 'DEL' THEN 'D' END        
              --        
              IF @PA_ACTION = 'INS'   
              BEGIN        
              --        
                EXEC pr_ins_upd_list @l_clim_crn_no , @l_action,'CLIENT MSTR', @pa_login_name, '*|~*', '|*~|', ''         
                --                        
                --pan_gir_no changed by tushar on 18/07/2007        
                SELECT @l_entpm_prop_id        = entpm_prop_id     
                FROM   entity_property_mstr      entpm    
                WHERE  entpm.entpm_cd          ='PAN_GIR_NO'     
                AND    entpm_deleted_ind       = 1    
                
                SELECT @l_entdm_id             = entdm_id      
                FROM   entpm_dtls_mstr           entdm      
                where  entdm.entdm_cd          = 'PAN_NAME'         
                AND    entdm_deleted_ind       = 1      
                --    
                IF ISNULL(@l_entpm_prop_id,0) <> 0 AND  ISNULL(@l_clim_pangirno,'') <> ''    
                BEGIN     
                --    
                  if @pa_action = 'INS'
                  SET @l_values  = CONVERT(VARCHAR,@l_entpm_prop_id)+@coldelimiter+ISNULL(@l_clim_pangirno,'')+@coldelimiter+@rowdelimiter      

                  SET @l_dtls_values  = CONVERT(VARCHAR,@l_entpm_prop_id)+@coldelimiter+CONVERT(VARCHAR,@l_entdm_id)+@coldelimiter+@l_clim_name1+' '+ isnull(@l_clim_name2,'') + ' ' + isnull(@l_clim_name3,'') +@coldelimiter+@rowdelimiter       

                  --    
                  EXEC pr_ins_upd_entp '1', 'EDT', @pa_login_name, @l_clim_crn_no, '', @l_values, @l_dtls_values, 1, '*|~*','|*~|',''     
                --    
                END     
                --pan_gir_no changed by tushar on 18/07/2007        
              --        
              END         
              ELSE         
              BEGIN        
              --        
                EXEC pr_ins_upd_list @pa_id , @l_action,'CLIENT MSTR', @pa_login_name, '*|~*', '|*~|', ''         
              --         
              END         
              --        
              SET @l_pa_output = ISNULL(CONVERT(VARCHAR, @l_clim_crn_no),'')+@coldelimiter+ISNULL(@l_clim_name1,'')+@coldelimiter+ISNULL(@l_clim_name2,'')+@coldelimiter+ISNULL(@l_clim_name3,'')+@coldelimiter+ISNULL(CONVERT(VARCHAR,@l_clicm_id),'')+@coldelimiter+ISNULL(CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter+@rowdelimiter        
            --        
            END        
          --        
          END        
          /*ELSE IF @pa_action='EDT'        
          BEGIN        
          --        
            BEGIN TRANSACTION        
                    
            SELECT @l_clim_id = ISNULL(MAX(clim_id),0)+1 FROM client_mstr_mak         
            --        
                    
                    
            INSERT INTO client_mstr_mak        
            ( clim_id        
            , clim_crn_no        
            , clim_name1        
            , clim_name2        
            , clim_name3        
            , clim_short_name        
            , clim_gender        
            , clim_dob        
            , clim_enttm_cd        
            , clim_stam_cd        
            , clim_clicm_cd        
            , clim_created_by        
            , clim_created_dt        
            , clim_lst_upd_by        
            , clim_lst_upd_dt        
            , clim_deleted_ind)        
            VALUES        
            ( @l_clim_id         
            , convert(numeric,@pa_id)        
            , @l_clim_name1        
            , @l_clim_name2        
            , @l_clim_name3        
            , @l_clim_short_name        
            , @l_clim_gender        
            , @l_clim_dob        
            , @l_clim_enttm_cd        
            , @l_clim_stam_cd        
            , @l_clim_clicm_cd        
            , @pa_login_name        
            , GETDATE()        
            , @pa_login_name        
            , GETDATE()        
            , 8)        
            --        
            SET @l_error = @@error        
            --        
            IF @l_error > 0        
            BEGIN        
        
                      
              SET @l_errorstr = @l_errorstr+CONVERT(VARCHAR,0)+@coldelimiter+ISNULL(@l_clim_name1,'')+@coldelimiter+ISNULL(@l_clim_name2,'')+@coldelimiter+ISNULL(@l_clim_name3,'')+@coldelimiter+ISNULL(CONVERT(VARCHAR,@l_clicm_id),'')+@coldelimiter+ISNULL(
  
    
      
CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@coldelimiter+@rowdelimiter         
        
              --        
              ROLLBACK TRANSACTION        
              --        
            END        
            ELSE        
            BEGIN        
            --        
              COMMIT TRANSACTION        
              --        
              SET @l_pa_output = CONVERT(VARCHAR,ISNULL(@l_clim_crn_no,''))+@coldelimiter+ISNULL(@l_clim_name1,'')+@coldelimiter+ISNULL(@l_clim_name2,'')+@coldelimiter+ISNULL(@l_clim_name3,'')+@coldelimiter+ISNULL(CONVERT(VARCHAR,@l_clicm_id),'')+@coldeli
  
    
      
miter+ISNULL(CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter+@rowdelimiter        
            --        
            END        
          --        
          END        
          IF @pa_action='DEL'        
          BEGIN        
          --        
            BEGIN TRANSACTION        
            --        
                    
                    
              SELECT @l_clim_id = ISNULL(MAX(clim_id),0)+1 FROM client_mstr_mak         
                      
              INSERT INTO client_mstr_mak        
              ( clim_id         
              , clim_crn_no        
              , clim_name1        
              , clim_name2        
              , clim_name3        
              , clim_short_name        
              , clim_gender        
              , clim_dob        
              , clim_enttm_cd        
              , clim_stam_cd        
              , clim_clicm_cd        
              , clim_created_by        
              , clim_created_dt        
              , clim_lst_upd_by        
              , clim_lst_upd_dt        
              , clim_deleted_ind)        
              VALUES        
              ( @l_clim_id         
              , convert(numeric,@pa_id)        
              , @l_clim_name1        
              , @l_clim_name2        
              , @l_clim_name3        
              , @l_clim_short_name        
              , @l_clim_gender        
              , @l_clim_dob        
              , @l_clim_enttm_cd        
              , @l_clim_stam_cd        
              , @l_clim_clicm_cd        
              , @pa_login_name        
              , GETDATE()        
              , @pa_login_name        
              , GETDATE()        
              , 4)        
              --        
              IF @l_error > 0        
              BEGIN        
              --        
                SET @l_errorstr = @l_errorstr+CONVERT(VARCHAR,'0')+@coldelimiter+ISNULL(@l_clim_name1,'')+@coldelimiter+ISNULL(@l_clim_name2,'')+@coldelimiter+ISNULL(@l_clim_name3,'')+@coldelimiter+ISNULL(CONVERT(VARCHAR,@l_clicm_id),'')+@coldelimiter+ISN
  
    
      
ULL(CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter+CONVERT(VARCHAR,@l_error)+@coldelimiter+@rowdelimiter         
                --        
                ROLLBACK TRANSACTION        
              --        
              END        
              ELSE        
              BEGIN        
              --        
                COMMIT TRANSACTION        
                --        
                SET @l_pa_output = CONVERT(VARCHAR,ISNULL(@l_clim_crn_no,''))+@coldelimiter+ISNULL(@l_clim_name1,'')+@coldelimiter+ISNULL(@l_clim_name2,'')+@coldelimiter+ISNULL(@l_clim_name3,'')+@coldelimiter+ISNULL(CONVERT(VARCHAR,@l_clicm_id),'')+@colde
  
    
      
limiter+ISNULL(CONVERT(VARCHAR,@l_enttm_id),'')+@coldelimiter+@rowdelimiter        
              --        
              END        
          --        
          END*/        
                  
          WHILE @remainingstring_id <> ''        
          BEGIN--1        
          --        
            SET @foundat = 0        
            SET @foundat =  PATINDEX('%'+@delimeter_id+'%',@remainingstring_id)        
            --        
            IF  @foundat > 0        
            BEGIN        
            --        
         SET @currstring_id      = SUBSTRING(@remainingstring_id, 0,@foundat)        
              SET @remainingstring_id = SUBSTRING(@remainingstring_id, @FOUNDAT+@delimeterlength_id,LEN(@remainingstring_id)- @foundat+@delimeterlength_id)        
            --        
            END        
            ELSE        
            BEGIN        
            --        
              SET @currstring_id      = @remainingstring_id        
              SET @remainingstring_id = ''        
            --        
            END        
            --        
            IF @currstring_id <> ''        
            BEGIN--2        
            --        
              --        
              SET @l_id     = CONVERT(numeric, citrus_usr.fn_splitval(@currstring_id,1))        
           SET @l_rmks   = CONVERT(varchar, citrus_usr.fn_splitval(@currstring_id,2))        
              --        
              IF @pa_action = 'APP'        
              BEGIN        
              --        
                SELECT @l_deleted_ind  = clim_deleted_ind        
                      ,@l_clim_crn_no  = clim_crn_no         
                FROM   client_mstr_mak        
                WHERE  clim_id         = CONVERT(numeric, @l_id)        
                --                         
                IF @l_deleted_ind      = 4        
                BEGIN        
                --        
                          
                  UPDATE client_mstr          WITH (ROWLOCK)             
                  SET    clim_deleted_ind   = 0        
                       , clim_rmks          = CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE cm.clim_rmks END        
                       , clim_lst_upd_by    = @pa_login_name        
                       , clim_lst_upd_dt    = GETDATE()        
                  FROM   client_mstr          cm           
                  WHERE  clim_deleted_ind   = 1        
                  AND    clim_crn_no        = @l_clim_crn_no        
                  --        
SET @l_error = @@error        
                  --        
                  IF @l_error > 0        
                  BEGIN        
                    --        
                    SET @l_errorstr = CONVERT(VARCHAR,@l_error)        
                    --        
                          
                    --        
                  END        
                  ELSE        
                  BEGIN        
                  --        
                     UPDATE client_mstr_mak      WITH (ROWLOCK)               
                     SET    clim_deleted_ind   = 5        
                          , clim_rmks          = CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE cmm.clim_rmks END        
                          , clim_lst_upd_by    = @pa_login_name        
                          , clim_lst_upd_dt    = GETDATE()        
                     FROM   client_mstr_mak      cmm             
                     WHERE  clim_deleted_ind   = 4        
                     AND    clim_id            = CONVERT(numeric, @l_id)        
                     --        
                     SET @l_error = @@error        
                     --        
                     IF @l_error > 0        
                     BEGIN        
                     --        
                       SET @l_errorstr = CONVERT(VARCHAR,@l_error)        
                     --        
                     END        
                  --        
                  END        
                --        
                END        
                ELSE IF @l_deleted_ind = 8        
                BEGIN        
                --        
                  IF EXISTS(SELECT clim_crn_no         
                            FROM   client_mstr         
                            WHERE  clim_crn_no = (SELECT clim_crn_no         
                                                  FROM   client_mstr_mak         
                                                  WHERE  clim_id = CONVERT(numeric, @l_id) --CONVERT(numeric,@currstring_id)         
                                                  AND    clim_deleted_ind IN (0,4,8)        
                                                 )        
                           )        
                  BEGIN        
                  --        
                    UPDATE cm                      WITH (ROWLOCK)        
                    SET    cm.clim_name1         = cm2.clim_name1        
                         , cm.clim_name2         = cm2.clim_name2        
                         , cm.clim_name3         = cm2.clim_name3        
                         , cm.clim_short_name    = cm2.clim_short_name         
                         , cm.clim_gender        = cm2.clim_gender        
                         , cm.clim_dob           = cm2.clim_dob        
                         , cm.clim_enttm_cd      = cm2.clim_enttm_cd        
                         , cm.clim_stam_cd       = cm2.clim_stam_cd        
                         , cm.clim_clicm_cd      = cm2.clim_clicm_cd        
                         , cm.clim_rmks          = CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE cm2.clim_rmks END        
                         , cm.clim_lst_upd_by    = @pa_login_name        
                         , cm.clim_lst_upd_dt    = GETDATE()        
                         , cm.clim_sbum_id       = cm2.clim_sbum_id         
                    FROM   client_mstr_mak         cm2        
                         , client_mstr             cm        
                    WHERE  cm2.clim_deleted_ind  = 8        
                    AND    cm2.clim_crn_no       = @l_clim_crn_no        
                    AND    cm.clim_crn_no        = @l_clim_crn_no        
                    AND    cm2.clim_id           = CONVERT(numeric, @l_id) --CONVERT(numeric,@currstring_id)        
                    --        
                    SET @l_error = @@error        
                    --        
                    IF @l_error > 0        
                    BEGIN        
                    --        
                      SET @l_errorstr = CONVERT(VARCHAR,@l_error)        
                    --        
                    END        
                    ELSE        
                    BEGIN        
                    --        
                      UPDATE client_mstr_mak     WITH (ROWLOCK)              
                      SET    clim_deleted_ind  = 9        
                           , clim_rmks         = CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE cmm.clim_rmks END        
                           , clim_lst_upd_by   = @pa_login_name        
                           , clim_lst_upd_dt   = GETDATE()        
                      FROM   client_mstr_mak     cmm             
                      WHERE  clim_deleted_ind  = 8        
                      AND    clim_id           = CONVERT(numeric, @l_id) --CONVERT(numeric,@currstring_id)        
                      --        
                      SET @l_error = @@error        
                      --        
                      IF @l_error > 0        
                      BEGIN        
                      --        
                        SET @l_errorstr = convert(varchar,@l_error)        
                      --        
                      END        
                    --          
                    END        
                  --        
                  END        
                  ELSE        
                  BEGIN        
                  --        
                     INSERT INTO client_mstr        
                     ( clim_crn_no        
                     , clim_name1        
                     , clim_name2        
                     , clim_name3        
                     , clim_short_name        
                     , clim_gender        
                     , clim_dob        
                     , clim_enttm_cd        
                     , clim_stam_cd        
                     , clim_clicm_cd        
                     , clim_rmks        
                     , clim_created_by        
                     , clim_created_dt        
                     , clim_lst_upd_by        
                     , clim_lst_upd_dt        
                     , clim_deleted_ind        
                     , clim_sbum_id        
                     )        
                     SELECT climm.clim_crn_no        
                          , climm.clim_name1        
                          , climm.clim_name2        
                          , climm.clim_name3        
                          , climm.clim_short_name        
                          , climm.clim_gender        
                          , climm.clim_dob        
                          , climm.clim_enttm_cd        
                          , climm.clim_stam_cd        
                          , climm.clim_clicm_cd        
                          , CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE climm.clim_rmks END        
                          , climm.clim_created_by        
                          , climm.clim_created_dt        
   , @pa_login_name        
                          , convert(datetime,convert(varchar,getdate()),106)--GETDATE()        
                          , 1         
                          , climm.clim_sbum_id        
                      FROM  client_mstr_mak          climm        
                      WHERE climm.clim_crn_no      = @l_clim_crn_no        
                      AND   climm.clim_deleted_ind = 8                          
                      AND   climm.clim_id          = CONVERT(numeric, @l_id) --CONVERT(numeric,@currstring_id)        
                      --        
                      SET @l_error = @@error        
                      --        
                      IF @l_error > 0        
                      BEGIN        
                      --        
                        SET @l_errorstr = CONVERT(VARCHAR,@l_error)        
                      --        
                      END        
                      ELSE        
 BEGIN        
                      --        
                        UPDATE client_mstr_mak    WITH (ROWLOCK)               
                        SET    clim_deleted_ind = 1        
                             , clim_rmks        = CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE cmm.clim_rmks END        
                             , clim_lst_upd_by  = @pa_login_name        
                             , clim_lst_upd_dt  = GETDATE()        
                        FROM   client_mstr_mak    cmm               
                        WHERE  clim_deleted_ind = 8        
                        AND    clim_id          = CONVERT(numeric, @l_id) --CONVERT(numeric,@currstring_id)        
                        --        
                        SET @l_error = @@error        
                        --        
                        IF @l_error > 0        
                        BEGIN        
                          --        
                          SET @l_errorstr = CONVERT(VARCHAR,@l_error)        
                          --        
                                 
                          --        
                        END        
                      --        
                      END        
                  --        
                  END        
                --        
                END         
                ELSE IF @l_deleted_ind = 0        
                BEGIN        
                --        
                  INSERT INTO client_mstr        
                  ( clim_crn_no        
                  , clim_name1        
                  , clim_name2        
                  , clim_name3        
                  , clim_short_name        
                  , clim_gender        
                  , clim_dob        
                  , clim_enttm_cd        
                  , clim_stam_cd        
                  , clim_clicm_cd        
                  , clim_rmks        
                  , clim_created_by        
                  , clim_created_dt        
                  , clim_lst_upd_by        
                  , clim_lst_upd_dt        
                  , clim_deleted_ind        
                  , clim.clim_sbum_id        
                  )        
                  SELECT climm.clim_crn_no        
                       , climm.clim_name1        
                       , climm.clim_name2        
                       , climm.clim_name3        
                       , climm.clim_short_name        
                       , climm.clim_gender        
                       , climm.clim_dob        
                       , climm.clim_enttm_cd        
                       , climm.clim_stam_cd        
                       , climm.clim_clicm_cd        
                       , CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE climm.clim_rmks END        
                       , climm.clim_created_by        
                       , GETDATE()        
                       , @pa_login_name        
                       , GETDATE()        
                       , 1         
                       , climm.clim_sbum_id        
                   FROM  client_mstr_mak          climm        
                   WHERE climm.clim_crn_no      = @l_clim_crn_no        
                   AND   climm.clim_deleted_ind = 0                          
                   AND   climm.clim_id          = CONVERT(numeric, @l_id) --CONVERT(numeric,@currstring_id)        
                   --        
                   SET @l_error = @@error        
                   --        
                   IF @l_error > 0        
                   BEGIN        
                   --        
                     SET @l_errorstr = CONVERT(VARCHAR,@l_error)        
                   --        
                   END        
                   ELSE        
                   BEGIN        
                   --        
                     UPDATE client_mstr_mak     WITH (ROWLOCK)               
                     SET    clim_deleted_ind  = 1        
                          , clim_rmks         = CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE cmm.clim_rmks END        
                          , clim_lst_upd_by   = @pa_login_name        
                          , clim_lst_upd_dt   = GETDATE()        
                     FROM   client_mstr_mak     cmm              
                     WHERE  clim_deleted_ind  = 0        
                     AND    clim_id           = CONVERT(numeric, @l_id) --CONVERT(numeric,@currstring_id)        
                     --        
                     SET @l_error = @@error        
                     --        
                     IF @l_error > 0        
                     BEGIN        
                     --        
                       SET @l_errorstr = CONVERT(VARCHAR,@l_error)        
                     --        
                     END        
                   --        
                   END        
                --        
                END        
                --move to pr_app_client                        
                --EXEC pr_ins_upd_list @l_clim_crn_no,'A','CLIENT MSTR',@pa_login_name,'*|~*','|*~|',''         
              --        
              END        
              ELSE IF @pa_action = 'REJ'        
              BEGIN        
              --        
                UPDATE client_mstr_mak     WITH (ROWLOCK)                
                SET    clim_deleted_ind  = 3        
                     , clim_lst_upd_by   = @pa_login_name        
                     , clim_rmks         = CASE WHEN ISNULL(@l_rmks,'') <> '' THEN @l_rmks ELSE cmm.clim_rmks END        
                     , clim_lst_upd_dt   = GETDATE()        
                FROM   client_mstr_mak     cmm              
                WHERE  clim_deleted_ind    IN (0,4.8)        
                AND  clim_id           = @l_id --CONVERT(numeric,@currstring_id)        
                --        
                SET @l_error = @@error        
                --        
                IF @l_error > 0        
                BEGIN        
                --                           
                  SET @l_errorstr = CONVERT(VARCHAR,@l_error)        
                --        
                END        
                       
              --        
              END        
            --        
            END--2        
          --        
          END--1        
        --        
        END        
      --        
      END  --END OF CURRSTRING  */        
      --        
    END        
    --        
    IF @l_errorstr <> ''        
    BEGIN        
    --        
      SET @pa_msg    = @l_errorstr        
      SET @pa_output = @l_errorstr--@L_PA_OUTPUT        
    --        
    END        
    ELSE        
    BEGIN        
    --        
      SET @pa_msg    = @l_pa_output--@l_errorstr        
      SET @pa_output = @l_pa_output        
    --        
    END        
--        
END -- END OF THE MAIN BEGIN

GO
