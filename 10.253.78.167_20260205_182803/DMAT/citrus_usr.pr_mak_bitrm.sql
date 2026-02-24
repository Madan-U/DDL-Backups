-- Object: PROCEDURE citrus_usr.pr_mak_bitrm
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_mak_bitrm]  (@pa_id                   varchar(8000)    
                              ,@pa_action               varchar(20)    
                              ,@pa_login_name           varchar(20)
                              ,@pa_type                varchar(10) 
                              ,@pa_bitrm_parent_cd      varchar(20)     
                              ,@pa_bitrm_child_cd       varchar(50)    
                              ,@pa_bitrm_values         varchar(100)    
                              ,@pa_chk_yn               int    
                              ,@rowdelimiter            char(4)  = '*|~*'    
                              ,@coldelimiter            char(4)  = '|*~|'    
                              ,@pa_errmsg               varchar(8000) OUTPUT    
 )    
AS    
/*    
*********************************************************************************    
 SYSTEM         : CLASS    
 MODULE NAME    : PR_MAK_PRODM    
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR BITMAP_REF_MSTR    
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.    
 VERSION HISTORY:    
 VERS.  AUTHOR            DATE         REASON    
 -----  -------------     ----------   -------------------------------------------------    
 1.0    sukhi             23-APR-2007  INITIAL    
-----------------------------------------------------------------------------------*/    
--    
BEGIN    
--    
  SET nocount ON    
  --    
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  --    
  DECLARE @@remainingstring_id   varchar(8000)    
        , @@currstring_id        varchar(8000)    
        , @@foundat_id           int    
        --    
        , @@delimeterlength      int    
        , @@l_errorstr           varchar(8000)    
        , @@l_error              int      
        --    
        , @@l_bitrm_id           numeric    
        , @@l_delimeter          char(4)    
  --          
  SET @@l_error             = 0    
  SET @@l_errorstr          = ''      
  SET @@l_delimeter     =  @rowdelimiter    
  SET @@remainingstring_id  = @pa_id    
  --    
  WHILE @@remainingstring_id <> ''    
  BEGIN--#01    
  --    
    SET @@foundat_id  = 0    
    SET @@foundat_id  =  PATINDEX('%'+@@l_delimeter+'%', @@remainingstring_id)    
    --    
    IF @@foundat_id > 0    
    BEGIN    
    --    
      SET @@currstring_id      = substring(@@remainingstring_id, 0, @@foundat_id)    
      SET @@remainingstring_id = substring(@@remainingstring_id, @@foundat_id+@@delimeterlength, len(@@remainingstring_id)- @@foundat_id+@@delimeterlength)    
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
    BEGIN--cid    
    --    
      IF @pa_chk_yn = 0    
      BEGIN--chk_yn=0    
      --    
        IF @pa_action = 'INS'    
        BEGIN--ins_0    
        --    
          SELECT @@l_bitrm_id  = ISNULL(MAX(bitrm_id),0) + 1    
          FROM   bitmap_ref_mstr  WITH (NOLOCK)    
          --    
          IF @pa_bitrm_child_cd = ''    
          BEGIN    
          --   
            BEGIN TRANSACTION    
            --    
            IF NOT EXISTS(SELECT bitrm_id FROM bitmap_ref_mstr 
                      WHERE bitrm_tab_type = case @pa_type when 'CL' then 'ENTPM' when 'AL' then 'ACCPM' END 
                      AND   bitrm_parent_cd = @pa_bitrm_parent_cd
                      AND   bitrm_child_cd = @pa_bitrm_parent_cd
                      AND   bitrm_values  = upper(@pa_bitrm_values)  
                      AND   bitrm_deleted_ind = 1 
            )
            BEGIN
            	
           
            INSERT INTO bitmap_ref_mstr    
            (bitrm_id    
            ,bitrm_parent_cd    
            ,bitrm_child_cd    
            ,bitrm_bit_location    
            ,bitrm_values    
            ,bitrm_created_by    
            ,bitrm_created_dt    
            ,bitrm_lst_upd_by    
            ,bitrm_lst_upd_dt    
            ,bitrm_deleted_ind
            ,bitrm_tab_type
            )    
            VALUES    
            (@@l_bitrm_id    
            ,@pa_bitrm_parent_cd    
            ,@pa_bitrm_parent_cd    
            ,NULL    
            ,upper(@pa_bitrm_values)     
            ,@PA_LOGIN_NAME    
            ,GETDATE()    
            ,@pa_login_name    
            ,GETDATE()    
            ,1
            ,case @pa_type when 'CL' then 'ENTPM' when 'AL' then 'ACCPM' end
            )    
            --  
            END  
            ELSE 
            BEGIN
            	SET @@l_error = 'Duplicate Data Not Allowed'    
            END 
             
            SET @@l_error = @@error    
          --      
          END    
          ELSE    
          BEGIN    
          --    
            BEGIN TRANSACTION    
            --   
            IF NOT EXISTS(SELECT bitrm_id FROM bitmap_ref_mstr 
                      WHERE bitrm_tab_type = case @pa_type when 'CL' then 'ENTPM' when 'AL' then 'ACCPM' END 
                      AND   bitrm_parent_cd = @pa_bitrm_parent_cd
                      AND   bitrm_child_cd = @pa_bitrm_child_cd
                      AND   bitrm_values  = upper(@pa_bitrm_values)  
                      AND   bitrm_deleted_ind = 1 
            )
            BEGIN
            	
            INSERT INTO bitmap_ref_mstr    
            (bitrm_id    
            ,bitrm_parent_cd    
            ,bitrm_child_cd    
            ,bitrm_bit_location    
            ,bitrm_values    
            ,bitrm_created_by    
            ,bitrm_created_dt    
            ,bitrm_lst_upd_by    
            ,bitrm_lst_upd_dt    
            ,bitrm_deleted_ind  
            ,bitrm_tab_type  
            )    
            VALUES    
            (@@l_bitrm_id    
            ,@pa_bitrm_parent_cd  
            ,@pa_bitrm_child_cd    
            ,NULL    
            ,upper(@pa_bitrm_values)     
            ,@PA_LOGIN_NAME    
            ,GETDATE()    
            ,@pa_login_name    
            ,GETDATE()    
            ,1
            ,case @pa_type when 'CL' then 'ENTDM' when 'AL' then 'ACCDM'end
            )    
            --  
            end 
            ELSE 
            BEGIN
            	SET @@l_error = 'Duplicate Data Not Allowed'    
            END    
            SET @@l_error = @@error    
          --    
          END    
          --    
          IF @@l_error  > 0    
          BEGIN    
          --    
            ROLLBACK TRANSACTION     
            --    
            SET @@l_errorstr = @coldelimiter+CONVERT(varchar, @@l_error)+@rowdelimiter    
          --    
          END    
          ELSE    
          BEGIN    
          --    
            COMMIT TRANSACTION    
          --    
          END    
        --    
        END--ins_0    
        --    
        IF @PA_ACTION = 'EDT'    
        BEGIN--edt_0    
        --    
          IF @pa_bitrm_child_cd = ''    
          BEGIN    
          --    
            BEGIN TRANSACTION    
            --    
            UPDATE bitmap_ref_mstr WITH (ROWLOCK)      
            SET    bitrm_parent_cd    = @pa_bitrm_parent_cd    
                 , bitrm_child_cd     = @pa_bitrm_parent_cd
                 , bitrm_tab_type     = case @pa_type when 'CL' then 'ENTPM' when 'AL' then 'ACCPM' end
                 , bitrm_lst_upd_by   = @pa_login_name    
                 , bitrm_lst_upd_dt   = getdate()    
                 , bitrm_values       = upper(@pa_bitrm_values)    
            WHERE  bitrm_id           = convert(numeric, @@currstring_id)    
            AND    bitrm_deleted_ind  = 1     
            --    
            SET @@l_error = @@error    
          --    
          END    
          ELSE    
          BEGIN    
          --    
            BEGIN TRANSACTION    
            --    
            UPDATE bitmap_ref_mstr WITH (ROWLOCK)      
            SET    bitrm_parent_cd    = @pa_bitrm_parent_cd    
                 , bitrm_child_cd     = @pa_bitrm_child_cd  
                 , bitrm_tab_type     = case @pa_type when 'CL' then 'ENTDM' when 'AL' then 'ACCDM' end
                 , bitrm_lst_upd_by   = @pa_login_name    
                 , bitrm_lst_upd_dt   = getdate()    
                 , bitrm_values       = upper(@pa_bitrm_values)    
            WHERE  bitrm_id           = convert(numeric, @@currstring_id)     
            AND    bitrm_deleted_ind  = 1    
            --    
            SET @@l_error = @@error    
          --    
          END    
          --    
          IF @@l_error  > 0    
          BEGIN    
          --    
            ROLLBACK TRANSACTION     
            --    
            SET @@l_errorstr = @coldelimiter+CONVERT(varchar, @@l_error)+@rowdelimiter    
          --    
          END    
          ELSE    
          BEGIN    
          --    
            COMMIT TRANSACTION    
          --    
          END    
        --    
        END  --edt_0    
        --    
        IF @PA_ACTION = 'DEL'    
        BEGIN--del_0    
        --    
          BEGIN TRANSACTION    
          --    
          UPDATE bitmap_ref_mstr WITH (ROWLOCK)      
          SET    bitrm_deleted_ind  = 0    
               , bitrm_lst_upd_by   = @pa_login_name    
               , bitrm_lst_upd_dt   = getdate()    
          WHERE  bitrm_id           = convert(numeric, @@currstring_id)     
          AND    bitrm_deleted_ind  = 1      
          --    
          SET @@l_error = @@error     
          --    
          IF @@l_error  > 0    
          BEGIN    
          --    
            ROLLBACK TRANSACTION     
            --    
            SET @@l_errorstr = @coldelimiter+CONVERT(varchar, @@l_error)+@rowdelimiter    
          --    
          END    
          ELSE    
          BEGIN    
          --    
            COMMIT TRANSACTION    
          --    
          END    
     --    
     END  --del_0    
        --    
      END --chk_yn=0    
    --    
    END  --cid    
  --      
  END--#01      
  --    
  IF ISNULL(RTRIM(LTRIM(@@l_errorstr)),'') = ''    
  BEGIN    
  --    
     SET @@l_errorstr = 'Bitmap successfully inserted\edited '+ @rowdelimiter    
  --    
  END    
  ELSE    
  BEGIN    
  --    
    SET @pa_errmsg = @@l_errorstr     
  --    
  END    
--    
END

GO
