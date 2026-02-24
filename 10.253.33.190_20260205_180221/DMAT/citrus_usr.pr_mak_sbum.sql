-- Object: PROCEDURE citrus_usr.pr_mak_sbum
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_mak_sbum](@pa_id             varchar(8000)
                            ,@pa_action         varchar(20)
                            ,@pa_login_name     varchar(20)
                            ,@pa_sbum_cd        varchar(20)   = ''
                            ,@pa_sbum_desc      varchar(20)   = ''
                            ,@pa_sbum_rmks      varchar(200)
                            ,@pa_sbum_start_no  varchar(20)
                            ,@pa_sbum_end_no    varchar(20)
                            ,@pa_sbum_cur_no    varchar(20)
                            ,@pa_chk_yn         int
                            ,@rowdelimiter      char(4)       = '*|~*'
                            ,@coldelimiter      char(4)       = '|*~|'
                            ,@pa_errmsg         varchar(8000) output
)
AS
/*
*********************************************************************************
 SYSTEM         : CITRUS
 MODULE NAME    : PR_MAK_SBUM
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR SBU MASTER
 COPYRIGHT(C)   : MARKETPLACE TECHNOLOGIOS PVT LTD
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  -----------------------------------------
 1.0    SUKHVINDER        17-09-2007    INITIAL.
 --------------------------------------------------------------------------------
*********************************************************************************
*/
--
BEGIN
--
  SET NOCOUNT ON
  --
  DECLARE @l_errorstr       varchar(8000)
        , @l_smsbum_id      bigint
        , @l_sbum_id        bigint
        , @l_error          bigint
        , @delimeter        varchar(10)
        , @remainingstring  varchar(8000)
        , @currstring       varchar(8000)
        , @foundat          integer
        , @delimeterlength  int
  --
  SET @l_error          = 0
  SET @l_errorstr       = ''
  SET @delimeter        = '%'+ @rowdelimiter + '%'
  SET @delimeterlength  = len(@rowdelimiter)
  SET @remainingstring  = @pa_id
  --
  WHILE @remainingstring <> ''
  BEGIN--while
  --
   SET @foundat = 0
   SET @foundat =  patindex('%'+@delimeter+'%',@remainingstring)
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
   IF isnull(@currstring,'') <> ''
   BEGIN--curr
   --
     IF @pa_action = 'INS'
     BEGIN--ins
       --
       IF @pa_chk_yn = 0 
       BEGIN--chk_0
       --
         SELECT @l_sbum_id = isnull(max(sbum_id),0)+ 1
         FROM   sbu_mstr WITH (NOLOCK)
         --
         BEGIN TRANSACTION
         --
         INSERT INTO sbu_mstr
         ( sbum_id
         , sbum_cd
         , sbum_desc
         , sbum_rmks
         , sbum_start_no
         , sbum_end_no  
         , sbum_cur_no  
         , sbum_created_by
         , sbum_created_dt
         , sbum_lst_upd_by
         , sbum_lst_upd_dt
         , sbum_deleted_ind
         )
         VALUES
         ( @l_sbum_id
         , @pa_sbum_cd
         , @pa_sbum_desc
         , @pa_sbum_rmks
         , CASE WHEN datalength(@pa_sbum_start_no) = 1 THEN '0000'+@pa_sbum_start_no 
                WHEN datalength(@pa_sbum_start_no) = 2 THEN '000'+@pa_sbum_start_no 
                WHEN datalength(@pa_sbum_start_no) = 3 THEN '00'+@pa_sbum_start_no
                WHEN datalength(@pa_sbum_start_no) = 4 THEN '0'+@pa_sbum_start_no
                ELSE @pa_sbum_start_no END
         , CASE WHEN datalength(@pa_sbum_end_no) = 1 THEN '0000'+@pa_sbum_end_no
                WHEN datalength(@pa_sbum_end_no) = 2 THEN '000'+@pa_sbum_end_no
                WHEN datalength(@pa_sbum_end_no) = 3 THEN '00'+@pa_sbum_end_no
                WHEN datalength(@pa_sbum_end_no) = 4 THEN '0'+@pa_sbum_end_no
                ELSE @pa_sbum_end_no END
         , CASE WHEN datalength(@pa_sbum_cur_no) = 1 THEN '0000'+@pa_sbum_cur_no
                WHEN datalength(@pa_sbum_cur_no) = 2 THEN '000'+@pa_sbum_cur_no
                WHEN datalength(@pa_sbum_cur_no) = 3 THEN '00'+@pa_sbum_cur_no
                WHEN datalength(@pa_sbum_cur_no) = 4 THEN '0'+@pa_sbum_cur_no
                ELSE @pa_sbum_cur_no END                
         --, @pa_sbum_start_no
         --, @pa_sbum_end_no  
         -- , @pa_sbum_cur_no  
         , @pa_login_name
         , getdate()
         , @pa_login_name
         , getdate()
         , 1
         )
         --
         SET @l_error = @@ERROR
         --
         IF @l_error  > 0
         BEGIN
         --
           ROLLBACK TRANSACTION
           --
           SET @l_errorstr = isnull(@l_errorstr,'')+@currstring+@coldelimiter+@pa_sbum_cd+@coldelimiter+@pa_sbum_desc+@coldelimiter+isnull(@pa_sbum_rmks,'')+@coldelimiter+isnull(convert(varchar, @pa_sbum_start_no),'')+@coldelimiter+isnull(convert(varchar, @pa_sbum_end_no),'')+@coldelimiter+isnull(convert(varchar, @pa_sbum_cur_no),'')+@coldelimiter+convert(varchar,@l_error)+@rowdelimiter
         --
         END
         ELSE
         BEGIN
         --
           declare @l_clicm_id int
                 , @l_enttm_id int
                 , @l_excpm_id int
                 
                 
           select top 1 @l_clicm_id = clicm_id from client_ctgry_mstr
           select top 1 @l_enttm_id = enttm_id from entity_type_mstr
           select top 1 @l_excpm_id = excpm_id from excsm_prod_mstr
         
           INSERT INTO ENTITY_PROPERTY_MSTR
           (ENTPM_ID
											,ENTPM_PROP_ID
											,ENTPM_CLICM_ID
											,ENTPM_ENTTM_ID
											,ENTPM_EXCPM_ID
											,ENTPM_CD
											,ENTPM_DESC
											,ENTPM_CLI_YN
											,ENTPM_MDTY
											,ENTPM_RMKS
											,ENTPM_DATATYPE
											,ENTPM_CREATED_BY
											,ENTPM_CREATED_DT
											,ENTPM_LST_UPD_BY
											,ENTPM_LST_UPD_DT
											,ENTPM_DELETED_IND)
										select max(ENTPM_ID) + 1
										     , max(ENTPM_PROP_ID) + 1 
										     , @l_clicm_id
										     , @l_enttm_id
										     , @l_excpm_id
										     , convert(varchar,@l_sbum_id) + '_CUR_VAL'
										     , convert(varchar,@l_sbum_id) + '_CUR_VAL'
										     , 1
               , 1
               , 'D'
               ,''
               , @pa_login_name
               , getdate()
               , @pa_login_name
               , getdate()
               , 1
           from entity_property_mstr     
               
           COMMIT TRANSACTION
         --
         END
       --
       END--chk_1  
       --
       IF @pa_chk_yn = 1
       BEGIN--chk_1
         --
         SELECT @l_smsbum_id = isnull(max(sm.sbum_id),0)+1
         FROM   sbu_mstr_mak sm WITH (NOLOCK)
         --
         SELECT @l_sbum_id   = isnull(max(s.sbum_id),0)+1
         FROM   sbu_mstr s     WITH (NOLOCK)
         --
         BEGIN TRANSACTION
         --
         IF @l_smsbum_id > @l_sbum_id
         BEGIN
           --
           SET  @l_sbum_id = @l_smsbum_id
           --
         END
         --
         INSERT INTO sbu_mstr_mak
         ( sbum_id
         , sbum_cd
         , sbum_desc
         , sbum_rmks
         , sbum_start_no
         , sbum_end_no  
         , sbum_cur_no  
         , sbum_created_by
         , sbum_created_dt
         , sbum_lst_upd_by
         , sbum_lst_upd_dt
         , sbum_deleted_ind
         )
         VALUES
         ( @l_sbum_id
         , @pa_sbum_cd
         , @pa_sbum_desc
         , @pa_sbum_rmks
         , CASE WHEN datalength(@pa_sbum_start_no) = 1 THEN '0000'+@pa_sbum_start_no 
                WHEN datalength(@pa_sbum_start_no) = 2 THEN '000'+@pa_sbum_start_no 
                WHEN datalength(@pa_sbum_start_no) = 3 THEN '00'+@pa_sbum_start_no
                WHEN datalength(@pa_sbum_start_no) = 4 THEN '0'+@pa_sbum_start_no
                ELSE @pa_sbum_start_no END
         , CASE WHEN datalength(@pa_sbum_end_no) = 1 THEN '0000'+@pa_sbum_end_no
                WHEN datalength(@pa_sbum_end_no) = 2 THEN '000'+@pa_sbum_end_no
                WHEN datalength(@pa_sbum_end_no) = 3 THEN '00'+@pa_sbum_end_no
                WHEN datalength(@pa_sbum_end_no) = 4 THEN '0'+@pa_sbum_end_no
                ELSE @pa_sbum_end_no END
         , CASE WHEN datalength(@pa_sbum_cur_no) = 1 THEN '0000'+@pa_sbum_cur_no
                WHEN datalength(@pa_sbum_cur_no) = 2 THEN '000'+@pa_sbum_cur_no
                WHEN datalength(@pa_sbum_cur_no) = 3 THEN '00'+@pa_sbum_cur_no
                WHEN datalength(@pa_sbum_cur_no) = 4 THEN '0'+@pa_sbum_cur_no
                ELSE @pa_sbum_cur_no END      
         --, @pa_sbum_start_no
         --, @pa_sbum_end_no  
         --, @pa_sbum_cur_no  
         , @pa_login_name
         , getdate()
         , @pa_login_name
         , getdate()
         , 0
         )
         --
         SET @l_error = @@ERROR
         --
         IF @l_error  > 0
         BEGIN
         --
           ROLLBACK TRANSACTION
           --
           SET @l_errorstr = isnull(@l_errorstr,'')+@currstring+@coldelimiter+@pa_sbum_cd+@coldelimiter+@pa_sbum_desc+@coldelimiter+isnull(@pa_sbum_rmks,'')+@coldelimiter+isnull(convert(varchar, @pa_sbum_start_no),'')+@coldelimiter+isnull(convert(varchar, @pa_sbum_end_no),'')+@coldelimiter+isnull(convert(varchar, @pa_sbum_cur_no),'')+@coldelimiter+convert(varchar,@l_error)+@rowdelimiter
         --
         END
         ELSE
         BEGIN
         --
           COMMIT TRANSACTION
         --
         END
       --
       END--chk_1
     --
     END--ins
     --
     IF @pa_action = 'APP'
     BEGIN--app
     --
       IF EXISTS(SELECT sbum_id
                 FROM   sbu_mstr   WITH(NOLOCK)
                 WHERE  sbum_id  = convert(int, @currstring))
       BEGIN
       --
         BEGIN TRANSACTION
         --
         UPDATE sbum                       WITH (ROWLOCK)
         SET    sbum.sbum_cd             = sbummak.sbum_cd
              , sbum.sbum_desc           = sbummak.sbum_desc
              , sbum.sbum_rmks           = sbummak.sbum_rmks
              , sbum.sbum_start_no       = sbummak.sbum_start_no
              , sbum.sbum_end_no         = sbummak.sbum_end_no  
              , sbum.sbum_cur_no         = sbummak.sbum_cur_no
              , sbum.sbum_lst_upd_by     = @pa_login_name
              , sbum.sbum_lst_upd_dt     = getdate()
              , sbum.sbum_deleted_ind    = 1
         FROM   sbu_mstr                   sbum
              , sbu_mstr_mak               sbummak
         WHERE  sbum.sbum_id             = convert(int,@currstring)
         AND    sbummak.sbum_id          = sbum.sbum_id
         AND    sbum.sbum_deleted_ind    = 1
         AND    sbummak.sbum_deleted_ind = 0
         AND    sbummak.sbum_created_by <> @pa_login_name
         --
         SET @l_error = @@ERROR
         --
         IF @l_error  > 0
         BEGIN    
         --
           SELECT @l_errorstr      = @l_errorstr+@currstring+@coldelimiter+sbum_cd+@coldelimiter+sbum_desc+@coldelimiter+isnull(sbum_rmks,'')+@coldelimiter+isnull(convert(varchar, sbum_start_no),'')+@coldelimiter+isnull(convert(varchar, sbum_end_no),'')+@coldelimiter+isnull(convert(varchar, sbum_cur_no),'')+@coldelimiter+convert(varchar,@l_error)+@rowdelimiter
           FROM   sbu_mstr_mak       WITH (NOLOCK)
           WHERE  sbum_id          = convert(int, @currstring)
           AND    sbum_deleted_ind = 0
           --
           ROLLBACK TRANSACTION
         --
         END
         ELSE
         BEGIN
         --
           UPDATE sbu_mstr_mak        WITH (ROWLOCK)
           SET    sbum_deleted_ind  = 1
                , sbum_lst_upd_by   = @pa_login_name
                , sbum_lst_upd_dt   = getdate()
           WHERE  sbum_id           = convert(int,@currstring)
           AND    sbum_created_by  <> @pa_login_name
           AND    sbum_deleted_ind  = 0
           --
           SET @l_error = @@ERROR
           --
           IF @l_error  > 0
           BEGIN             
           --
             SELECT @l_errorstr      = @l_errorstr+@currstring+@coldelimiter+sbum_cd+@coldelimiter+sbum_desc+@coldelimiter+isnull(sbum_rmks,'')+@coldelimiter+isnull(convert(varchar, sbum_start_no),'')+@coldelimiter+isnull(convert(varchar, sbum_end_no),'')+@coldelimiter+isnull(convert(varchar, sbum_cur_no),'')+@coldelimiter+convert(varchar,@l_error)+@rowdelimiter
             FROM   sbu_mstr_mak       WITH (NOLOCK)
             WHERE  sbum_id          = convert(int,@currstring)
             AND    sbum_deleted_ind = 0
             --
             ROLLBACK TRANSACTION
           --
           END
           ELSE
           BEGIN
           --
             COMMIT TRANSACTION
           --
           END
         --
         END
       --
       END
       ELSE
       BEGIN
       --
         BEGIN TRANSACTION
         --
         INSERT INTO sbu_mstr
         ( sbum_id
         , sbum_cd
         , sbum_desc
         , sbum_rmks
         , sbum_start_no
         , sbum_end_no  
         , sbum_cur_no  
         , sbum_created_by
         , sbum_created_dt
         , sbum_lst_upd_by
         , sbum_lst_upd_dt
         , sbum_deleted_ind
         )
         SELECT sbumm.sbum_id
              , sbumm.sbum_cd
              , sbumm.sbum_desc
              , sbumm.sbum_rmks
              , sbumm.sbum_start_no
              , sbumm.sbum_end_no  
              , sbumm.sbum_cur_no
              , sbumm.sbum_created_by
              , sbumm.sbum_created_dt
              , @pa_login_name
              , getdate()
              , 1
         FROM   sbu_mstr_mak              sbumm WITH (NOLOCK)
         WHERE  sbumm.sbum_id           = convert(int,@currstring)
         AND    sbumm.sbum_created_by  <> @pa_login_name
         AND    sbumm.sbum_deleted_ind  = 0
         --
         SET @l_error = CONVERT(INT, @@ERROR)
         --
         IF @l_error  > 0
         BEGIN
         --
           SELECT @l_errorstr      = @l_errorstr+@currstring+@coldelimiter+sbum_cd+@coldelimiter+sbum_desc+@coldelimiter+isnull(sbum_rmks,'')+@coldelimiter+isnull(convert(varchar, sbum_start_no),'')+@coldelimiter+isnull(convert(varchar, sbum_end_no),'')+@coldelimiter+isnull(convert(varchar, sbum_cur_no),'')+@coldelimiter+convert(varchar,@l_error)+@rowdelimiter
           FROM   sbu_mstr_mak       WITH (NOLOCK)
           WHERE  sbum_id          = convert(int,@currstring)
           AND    sbum_deleted_ind = 0
           --
           ROLLBACK TRANSACTION
         --
         END
         ELSE
         BEGIN
         --
           UPDATE sbu_mstr_mak        WITH (ROWLOCK)
           SET    sbum_deleted_ind  = 1
                , sbum_lst_upd_by   = @pa_login_name
                , sbum_lst_upd_dt   = getdate()
           WHERE  sbum_id           = convert(int,@currstring)
           AND    sbum_created_by  <> @pa_login_name
           AND    sbum_deleted_ind  = 0

           SET @l_error = @@ERROR
           --
           IF @l_error > 0
           BEGIN
           --
             SELECT @l_errorstr      = @l_errorstr+@currstring+@coldelimiter+sbum_cd+@coldelimiter+sbum_desc+@coldelimiter+isnull(sbum_rmks,'')+@coldelimiter+isnull(convert(varchar, sbum_start_no),'')+@coldelimiter+isnull(convert(varchar, sbum_end_no),'')+@coldelimiter+isnull(convert(varchar, sbum_cur_no),'')+@coldelimiter+convert(varchar,@l_error)+@rowdelimiter
             FROM   sbu_mstr_mak       WITH (NOLOCK)
             WHERE  sbum_id          = convert(int, @currstring)
             AND    sbum_deleted_ind = 0
             --
             ROLLBACK TRANSACTION
           --
           END
           ELSE
           BEGIN
           --
             COMMIT TRANSACTION
           --
           END
         --
         END
       --
       END
     --
     END--app
     ------------------- 
     IF @pa_action = 'REJ' 
     BEGIN--rej
     --
       BEGIN TRANSACTION
       --
       UPDATE sbu_mstr_mak       WITH (ROWLOCK)
       SET    sbum_deleted_ind = 3
            , sbum_lst_upd_by  = @pa_login_name
            , sbum_lst_upd_dt  = getdate()
       WHERE  sbum_id          = convert(int,@currstring)
       AND    sbum_deleted_ind = 0
       --
       SET @l_error = @@ERROR
       --
       IF @l_error > 0
       BEGIN
       --
         SELECT @l_errorstr    = @l_errorstr+@currstring+@coldelimiter+sbum_cd+@coldelimiter+sbum_desc+@coldelimiter+isnull(sbum_rmks,'')+@coldelimiter+isnull(convert(varchar, sbum_start_no),'')+@coldelimiter+isnull(convert(varchar, sbum_end_no),'')+@coldelimiter+isnull(convert(varchar, sbum_cur_no),'')+@coldelimiter+convert(varchar,@l_error)+@rowdelimiter
         FROM   sbu_mstr_mak     WITH (NOLOCK)
         WHERE  sbum_id        = convert(int,@currstring)
         --
         ROLLBACK TRANSACTION
       --
       END
       ELSE
       BEGIN
       --
         COMMIT TRANSACTION
       --
       END
     --
     END--rej
     -------------------
     IF @pa_action = 'DEL'
     BEGIN--del
     --
       BEGIN TRANSACTION
       --
       UPDATE sbu_mstr           WITH (ROWLOCK)
       SET    sbum_deleted_ind = 0
            , sbum_lst_upd_by  = @pa_login_name
            , sbum_lst_upd_dt  = getdate()
       WHERE  sbum_id          = convert(int,@currstring)
       AND    sbum_deleted_ind = 1 
       --
       SET @l_error = @@ERROR
       --
       IF @l_error > 0
       BEGIN
       --
         SELECT @l_errorstr      = @l_errorstr+@currstring+@coldelimiter+sbum_cd+@coldelimiter+sbum_desc+@coldelimiter+isnull(sbum_rmks,'')+@coldelimiter+isnull(convert(varchar, sbum_start_no),'')+@coldelimiter+isnull(convert(varchar, sbum_end_no),'')+@coldelimiter+isnull(convert(varchar, sbum_cur_no),'')+@coldelimiter+convert(varchar,@l_error)+@rowdelimiter
         FROM   sbu_mstr           WITH (NOLOCK)
         WHERE  sbum_id          = convert(int,@currstring)
         AND    sbum_deleted_ind = 1
         --
         ROLLBACK TRANSACTION
       --
       END
       ELSE
       BEGIN
       --
         COMMIT TRANSACTION
       --
       END
     --
     END--del
     -------------------
     IF @pa_action = 'EDT'
     BEGIN--edt
     --
       IF @pa_chk_yn = 0
       BEGIN--chk_0
       --
         BEGIN TRANSACTION
         --
         UPDATE sbu_mstr             WITH (ROWLOCK)
         SET    sbum_cd            = @pa_sbum_cd
              , sbum_desc          = @pa_sbum_desc
              , sbum_rmks          = @pa_sbum_rmks
              , sbum_start_no      = CASE WHEN datalength(@pa_sbum_start_no) = 1 THEN '0000'+@pa_sbum_start_no 
                                          WHEN datalength(sbum_start_no) = 2 THEN '000'+@pa_sbum_start_no
                                          WHEN datalength(sbum_start_no) = 3 THEN '00'+@pa_sbum_start_no
                                          WHEN datalength(sbum_start_no) = 4 THEN '0'+@pa_sbum_start_no
                                          ELSE @pa_sbum_start_no END
              , sbum_end_no        = CASE WHEN datalength(@pa_sbum_end_no) = 1 THEN '0000'+@pa_sbum_end_no 
                                          WHEN datalength(sbum_end_no) = 2 THEN '000'+@pa_sbum_end_no
                                          WHEN datalength(sbum_end_no) = 3 THEN '00'+@pa_sbum_end_no
                                          WHEN datalength(sbum_end_no) = 4 THEN '0'+@pa_sbum_end_no
                                          ELSE @pa_sbum_end_no END
              , sbum_cur_no        = CASE WHEN datalength(@pa_sbum_cur_no) = 1 THEN '0000'+@pa_sbum_cur_no 
                                          WHEN datalength(@pa_sbum_cur_no) = 2 THEN '000'+@pa_sbum_cur_no
                                          WHEN datalength(@pa_sbum_cur_no) = 3 THEN '00'+@pa_sbum_cur_no
                                          WHEN datalength(@pa_sbum_cur_no) = 4 THEN '0'+@pa_sbum_cur_no
                                          ELSE @pa_sbum_cur_no END
              , sbum_lst_upd_by    = @pa_login_name
              , sbum_lst_upd_dt    = getdate()
         WHERE  sbum_id            = convert(int, @currstring)
         AND    sbum_deleted_ind   = 1
         --
         SET @l_error = @@ERROR
         --
         IF @l_error > 0
         BEGIN
         --
           SET @l_errorstr = isnull(@l_errorstr,'')+@currstring+@coldelimiter+@pa_sbum_cd+@coldelimiter+@pa_sbum_desc+@coldelimiter+isnull(@pa_sbum_rmks,'')+@coldelimiter+isnull(convert(varchar, @pa_sbum_start_no),'')+@coldelimiter+isnull(convert(varchar, @pa_sbum_end_no),'')+@coldelimiter+isnull(convert(varchar, @pa_sbum_cur_no),'')+@coldelimiter+convert(varchar,@l_error)+@rowdelimiter
           --
           ROLLBACK TRANSACTION
         --
         END
         ELSE
         BEGIN
         --
           COMMIT TRANSACTION
         --
         END
       --
       END--chk_0
       --
       IF @pa_chk_yn = 1 -- IF MAKER OR CHEKER IS EDITING
       BEGIN--chk_1
       --
         BEGIN TRANSACTION
         --
         UPDATE sbu_mstr_mak       WITH (ROWLOCK)
         SET    sbum_deleted_ind = 2
              , sbum_lst_upd_by  = @pa_login_name
              , sbum_lst_upd_dt  = getdate()
         WHERE  sbum_id          = convert(int, @currstring)
         AND    sbum_deleted_ind = 0
         --
         SET @l_error = @@ERROR
         --
         IF @l_error > 0
         BEGIN
         --
           SET @l_errorstr = isnull(@l_errorstr,'')+@currstring+@coldelimiter+@pa_sbum_cd+@coldelimiter+@pa_sbum_desc+@coldelimiter+isnull(@pa_sbum_rmks,'')+@coldelimiter+isnull(convert(varchar, @pa_sbum_start_no),'')+@coldelimiter+isnull(convert(varchar, @pa_sbum_end_no),'')+@coldelimiter+isnull(convert(varchar, @pa_sbum_cur_no),'')+@coldelimiter+convert(varchar,@l_error)+@rowdelimiter
           --
           ROLLBACK TRANSACTION
         --
         END
         ELSE
         BEGIN
         --
           INSERT INTO sbu_mstr_mak
           (sbum_id
           ,sbum_cd
           ,sbum_desc
           ,sbum_rmks
           ,sbum_start_no
           ,sbum_end_no  
           ,sbum_cur_no  
           ,sbum_created_by
           ,sbum_created_dt
           ,sbum_lst_upd_by
           ,sbum_lst_upd_dt
           ,sbum_deleted_ind
           )
           VALUES
           (convert(int,@currstring)
           ,@pa_sbum_cd
           ,@pa_sbum_desc
           ,@pa_sbum_rmks
           , CASE WHEN datalength(@pa_sbum_start_no) = 1 THEN '0000'+@pa_sbum_start_no 
                  WHEN datalength(@pa_sbum_start_no) = 2 THEN '000'+@pa_sbum_start_no 
                  WHEN datalength(@pa_sbum_start_no) = 3 THEN '00'+@pa_sbum_start_no
                  WHEN datalength(@pa_sbum_start_no) = 4 THEN '0'+@pa_sbum_start_no
                  ELSE @pa_sbum_start_no END
           , CASE WHEN datalength(@pa_sbum_end_no) = 1 THEN '0000'+@pa_sbum_end_no
                  WHEN datalength(@pa_sbum_end_no) = 2 THEN '000'+@pa_sbum_end_no
                  WHEN datalength(@pa_sbum_end_no) = 3 THEN '00'+@pa_sbum_end_no
                  WHEN datalength(@pa_sbum_end_no) = 4 THEN '0'+@pa_sbum_end_no
                  ELSE @pa_sbum_end_no END
           , CASE WHEN datalength(@pa_sbum_cur_no) = 1 THEN '0000'+@pa_sbum_cur_no
                  WHEN datalength(@pa_sbum_cur_no) = 2 THEN '000'+@pa_sbum_cur_no
                  WHEN datalength(@pa_sbum_cur_no) = 3 THEN '00'+@pa_sbum_cur_no
                  WHEN datalength(@pa_sbum_cur_no) = 4 THEN '0'+@pa_sbum_cur_no
                  ELSE @pa_sbum_cur_no END      
           ,@pa_login_name
           ,getdate()
           ,@pa_login_name
           ,getdate()
           ,0
           )
           --
           SET @l_error = @@ERROR
           --
           IF @l_error > 0
           BEGIN
           --
             SET @l_errorstr = isnull(@l_errorstr,'')+@currstring+@coldelimiter+@pa_sbum_cd+@coldelimiter+@pa_sbum_desc+@coldelimiter+isnull(@pa_sbum_rmks,'')+@coldelimiter+isnull(convert(varchar, @pa_sbum_start_no),'')+@coldelimiter+isnull(convert(varchar, @pa_sbum_end_no),'')+@coldelimiter+isnull(convert(varchar, @pa_sbum_cur_no),'')+@coldelimiter+convert(varchar,@l_error)+@rowdelimiter
             --
             ROLLBACK TRANSACTION
           --
           END
           ELSE
           BEGIN
           --
             COMMIT TRANSACTION
           --
           END
         --
         END
       --
       END--chk_1
     --
     END--edt
   --
   END--curr
   --
   SET @pa_errmsg = @l_errorstr
  --
  END--while
--
END

GO
