-- Object: PROCEDURE citrus_usr.pr_mak_banm
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--16b pr_mak_banm     add new two parameter  
  
CREATE PROCEDURE [citrus_usr].[pr_mak_banm]( @pa_id           VARCHAR(8000)  
                           , @pa_action       VARCHAR(20)  
                           , @pa_login_name   VARCHAR(20)  
                           , @pa_banm_name    VARCHAR(100) = ''  
                           , @pa_banm_branch  VARCHAR(100) = ''  
                           , @pa_banm_micr    VARCHAR(10)  
                           , @pa_rtgs_cd      VARCHAR(20)  
                           , @pa_pay_loc_cd   VARCHAR(20)  
                           , @pa_banm_rmks    VARCHAR(200)  
                           , @pa_chk_yn       INT  
                           , @pa_adr_flg      INT  
                           , @pa_adr_values   VARCHAR(8000)  
                           , @pa_conc_flg     INT  
                           , @pa_conc_values  VARCHAR(8000)  
                           , @rowdelimiter    CHAR(4)       = '*|~*'  
                           , @coldelimiter    CHAR(4)       = '|*~|'  
                           , @pa_errmsg       VARCHAR(8000) OUTPUT  
)  
AS  
/*  
*********************************************************************************  
 SYSTEM         : class  
 MODULE NAME    : pr_mak_banm  
 DESCRIPTION    : this procedure will contain the maker checker facility for bank master  
 COPYRIGHT(C)   : enc software solutions pvt. ltd.  
 VERSION HISTORY: 1.0  
 VERS.  AUTHOR            DATE         REASON  
 -----  -------------     ----------   -------------------------------------------------  
 1.0    HARI              18-11-2006   INITIAL VERSION.  
 2.0    SUKHVINDER/TUSHAR 15-12-2006   INITIAL VERSION.  
 3.0    TUSHAR            27-04-2007   INITIAL VERSION.  
-----------------------------------------------------------------------------------*/  
--  
BEGIN  
--  
  SET NOCOUNT ON  
  --  
  DECLARE @@t_errorstr       VARCHAR(8000)  
        , @l_bmbanm_id       BIGINT  
        , @l_banm_id         BIGINT  
        , @@l_error          BIGINT  
        , @delimeter         VARCHAR(10)  
        , @@remainingstring  VARCHAR(8000)  
        , @@currstring       VARCHAR(8000)  
        , @@foundat          INTEGER  
        , @@delimeterlength  INT  
        , @l_action          VARCHAR(10)  
  --  
  SET @@l_error         = 0  
  SET @@t_errorstr      = ''  
  --  
  SET @delimeter        = '%'+ @rowdelimiter + '%'  
  SET @@delimeterlength = len(@rowdelimiter)  
  --  
  SET @@remainingstring = @pa_id  
  --  
  WHILE @@remainingstring <> ''  
  BEGIN  
  --  
    SET @@foundat = 0  
    SET @@foundat =  patindex('%'+@delimeter+'%',@@remainingstring)  
    --  
    IF @@foundat > 0  
    BEGIN  
    --  
      SET @@currstring      = substring(@@remainingstring, 0,@@foundat)  
      SET @@remainingstring = substring(@@remainingstring, @@foundat+@@delimeterlength,len(@@remainingstring)- @@foundat+@@delimeterlength)  
    --  
    END  
    ELSE  
    BEGIN  
    --  
      SET @@currstring      = @@remainingstring  
      SET @@remainingstring = ''  
    --  
    END  
   --  
   IF @@currstring <> ''  
   BEGIN  
     --  
     IF @pa_action = 'INS'  
     BEGIN  
       --  
       IF @pa_chk_yn = 0 -- IF MAKER CHECKER FUNCTIONALITY IS NOT REQD  
       BEGIN  
         --  
         BEGIN TRANSACTION  
         --  
         SELECT @l_banm_id      = bitrm_bit_location  
         FROM   bitmap_ref_mstr WITH(NOLOCK)  
         WHERE  bitrm_parent_cd = 'ENTITY_ID'  
         AND    bitrm_child_cd  = 'ENTITY_ID'  
         --  
         UPDATE bitmap_ref_mstr    WITH(ROWLOCK)  
         SET    bitrm_bit_location = bitrm_bit_location+1  
         WHERE  bitrm_parent_cd    = 'ENTITY_ID'  
         AND    bitrm_child_cd     = 'ENTITY_ID'  
         --  
         INSERT INTO bank_mstr  
         (banm_id  
         ,banm_name  
         ,banm_branch  
         ,banm_micr  
         ,banm_rtgs_cd  
         ,banm_payloc_cd  
         ,banm_rmks  
         ,banm_created_by  
         ,banm_created_dt  
         ,banm_lst_upd_by  
         ,banm_lst_upd_dt  
         ,banm_deleted_ind  
        )  
         VALUES  
         (@l_banm_id  
         ,@pa_banm_name  
         ,@pa_banm_branch  
         ,@pa_banm_micr  
         ,@pa_rtgs_cd  
         ,@pa_pay_loc_cd  
         ,@pa_banm_rmks  
         ,@pa_login_name  
         ,getdate()  
         ,@pa_login_name  
         ,getdate()  
         ,1  
         )  
         --  
         SET @@l_error = @@error  
         --  
         IF @@l_error  > 0  
         BEGIN  
         --  
           SET @@t_errorstr=@@t_errorstr+convert(varchar, @@currstring)+@coldelimiter+@pa_banm_name+@coldelimiter+@pa_banm_branch+@coldelimiter+isnull(convert(varchar, @pa_banm_micr),'')+@coldelimiter+isnull(convert(varchar, @pa_rtgs_cd),'')+@coldelimiter
+isnull(convert(varchar, @pa_pay_loc_cd),'')+@coldelimiter+isnull(@pa_banm_rmks,'')+@coldelimiter+@coldelimiter+@coldelimiter+convert(varchar,@@l_error)+@rowdelimiter  
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
       IF @pa_chk_yn = 1 -- IF MAKER IS INSERTING  
       BEGIN  
       --  
         BEGIN TRANSACTION  
         --  
         SELECT @l_banm_id       = bitrm_bit_location  
         FROM   bitmap_ref_mstr  with(nolock)  
         WHERE  bitrm_parent_cd  = 'entity_id'  
         AND    bitrm_child_cd   = 'entity_id'  
         --  
         UPDATE bitmap_ref_mstr    WITH(ROWLOCK)  
         SET    bitrm_bit_location = bitrm_bit_location+1  
         WHERE  bitrm_parent_cd    = 'entity_id'  
         AND    bitrm_child_cd     = 'entity_id'  
         --  
         INSERT INTO bank_mstr_mak  
         ( banm_id  
         , banm_name  
         , banm_branch  
         , banm_micr  
         , banm_rtgs_cd  
         , banm_payloc_cd  
         , banm_rmks  
         , banm_created_by  
         , banm_created_dt  
         , banm_lst_upd_by  
         , banm_lst_upd_dt  
         , banm_deleted_ind)  
         VALUES  
         ( @l_banm_id  
         , @pa_banm_name  
         , @pa_banm_branch  
         , @pa_banm_micr  
         , @pa_rtgs_cd  
         , @pa_pay_loc_cd  
         , @pa_banm_rmks  
         , @pa_login_name  
         , getdate()  
         , @pa_login_name  
         , getdate()  
         , 0  
         )  
         --  
         SET @@l_error = @@error  
         --  
         IF @@l_error  > 0  
         BEGIN  
         --  
           SET @@t_errorstr=@@t_errorstr+convert(varchar, @@currstring)+@coldelimiter+@pa_banm_name+@coldelimiter+@pa_banm_branch+@coldelimiter+isnull(convert(varchar, @pa_banm_micr),'')+@coldelimiter+isnull(convert(varchar, @pa_rtgs_cd),'')+@coldelimiter
+isnull(convert(varchar, @pa_pay_loc_cd),'')+@coldelimiter+isnull(@pa_banm_rmks,'')+@coldelimiter+@coldelimiter+@coldelimiter+convert(varchar,@@l_error)+@rowdelimiter  
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
    END  --ACTION TYPE = INS ENDS HERE  
    --  
    IF @pa_action = 'APP'  
    BEGIN  
     --  
     IF EXISTS(SELECT banm_id  
               FROM   bank_mstr WITH (NOLOCK)  
               WHERE  banm_id   = CONVERT(INT, @@CURRSTRING))  
     BEGIN  
     --  
       BEGIN TRANSACTION  
       --  
       UPDATE banm WITH (ROWLOCK)  
       SET    banm.banm_name           = banmm.banm_name  
            , banm.banm_branch         = banmm.banm_branch  
            , banm.banm_micr           = banmm.banm_micr  
            , banm.banm_rtgs_cd        = banmm.banm_rtgs_cd  
            , banm.banm_payloc_cd      = banmm.banm_payloc_cd  
            , banm.banm_rmks           = banmm.banm_rmks  
            , banm.banm_lst_upd_by     = @pa_login_name  
            , banm.banm_lst_upd_dt     = getdate()  
            , banm.banm_deleted_ind    = 1  
       FROM   bank_mstr                  banm  
            , bank_mstr_mak              banmm  
       WHERE  banm.banm_id       = convert(int,@@currstring)  
       AND    banmm.banm_id            = banm.banm_id  
       AND    banm.banm_deleted_ind    = 1  
       AND    banmm.banm_deleted_ind   = 0  
       AND    banmm.banm_created_by   <> @pa_login_name  
       --  
       SET @@l_error = @@error  
       --  
       IF @@l_error  > 0  
       BEGIN  
       --  
         SELECT @@t_errorstr     = @@t_errorstr+CONVERT(VARCHAR, @@currstring)+@coldelimiter+banm_name+@coldelimiter+banm_branch+@coldelimiter+isnull(banm_micr,'')+@coldelimiter+isnull(banm_rtgs_cd,'')+@coldelimiter+isnull(banm_payloc_cd,'')+@coldelimiter+isnull(banm_rmks,'')+@coldelimiter+@coldelimiter+@coldelimiter+convert(varchar,@@l_error)+@rowdelimiter  
         FROM   bank_mstr_mak    WITH (NOLOCK)  
         WHERE  banm_id          = CONVERT(INT, @@currstring)  
         AND    banm_deleted_ind = 0  
         --  
         ROLLBACK TRANSACTION  
       --  
       END  
       --  
       ELSE  
       BEGIN  
       --  
         UPDATE bank_mstr_mak     WITH (ROWLOCK)  
         SET    banm_deleted_ind  = 1  
              , banm_lst_upd_by   = @pa_login_name  
              , banm_lst_upd_dt   = GETDATE()  
         WHERE  banm_id           = CONVERT(INT,@@currstring)  
         AND    banm_created_by  <> @pa_login_name  
         AND    banm_deleted_ind  = 0  
         --  
         SET @@l_error = @@error  
         --  
         IF @@l_error  > 0  
         BEGIN  
         --  
           SELECT @@t_errorstr     = @@t_errorstr+convert(varchar, @@currstring)+@coldelimiter+banm_name+@coldelimiter+banm_branch+@coldelimiter+isnull(banm_micr,'')+@coldelimiter+isnull(banm_rmks,'')+@coldelimiter+@coldelimiter+@coldelimiter+convert(varchar,@@l_error)+@rowdelimiter  
           FROM   bank_mstr_mak    WITH (NOLOCK)  
           WHERE  banm_id          = CONVERT(INT,@@currstring)  
           AND    banm_deleted_ind = 0  
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
        INSERT INTO bank_mstr  
        ( banm_id  
        , banm_name  
        , banm_branch  
        , banm_micr  
        , banm_rtgs_cd  
        , banm_payloc_cd  
        , banm_rmks  
        , banm_created_by  
        , banm_created_dt  
        , banm_lst_upd_by  
        , banm_lst_upd_dt  
        , banm_deleted_ind  
        )  
        SELECT banmm.banm_id  
             , banmm.banm_name  
             , banmm.banm_branch  
             , banmm.banm_micr  
             , banmm.banm_rtgs_cd  
             , banmm.banm_payloc_cd  
             , banmm.banm_rmks  
             , banmm.banm_created_by  
             , banmm.banm_created_dt  
             , @pa_login_name  
             , getdate()  
             , 1  
        FROM   bank_mstr_mak           banmm WITH (NOLOCK)  
        WHERE  banmm.banm_id           = CONVERT(INT,@@currstring)  
        AND    banmm.banm_created_by  <> @pa_login_name  
        AND    banmm.banm_deleted_ind  = 0  
        --  
        SET @@l_error = convert(int, @@error)  
        --  
        IF @@l_error  > 0  
        BEGIN  
          --  
          SELECT @@t_errorstr     = @@t_errorstr+convert(varchar, @@currstring)+@coldelimiter+banm_name+@coldelimiter+banm_branch+@coldelimiter+isnull(banm_micr,'')+@coldelimiter+isnull(banm_rtgs_cd,'')+@coldelimiter+isnull(banm_payloc_cd,'')+@coldelimiter+isnull(banm_rmks,'')+@coldelimiter+@coldelimiter+@coldelimiter+convert(varchar,@@l_error)+@rowdelimiter  
          FROM   bank_mstr_mak WITH (NOLOCK)  
          WHERE  banm_id          = convert(int,@@currstring)  
          AND    banm_deleted_ind = 0  
          --  
          ROLLBACK TRANSACTION  
          --  
        END  
        ELSE  
        BEGIN  
        --  
          UPDATE bank_mstr_mak WITH (ROWLOCK)  
          SET    banm_deleted_ind  = 1  
               , banm_lst_upd_by   = @pa_login_name  
          , banm_lst_upd_dt   = getdate()  
          WHERE  banm_id           = convert(int,@@currstring)  
          AND    banm_created_by  <> @pa_login_name  
          AND    banm_deleted_ind  = 0  
  
          SET @@l_error = @@error  
          --  
           IF  @@l_error > 0  
           BEGIN   
           --  
             SELECT @@t_errorstr    = @@t_errorstr+convert(varchar, @@currstring)+@coldelimiter+banm_name+@coldelimiter+banm_branch+@coldelimiter+isnull(banm_micr,'')+@coldelimiter+isnull(banm_rtgs_cd,'')+@coldelimiter+isnull(banm_payloc_cd,'')+@coldelimiter+isnull(banm_rmks,'')+@coldelimiter+@coldelimiter+@coldelimiter+convert(varchar,@@l_error)+@rowdelimiter  
             FROM   bank_mstr_mak   WITH (NOLOCK)  
             WHERE  banm_id          = convert(int,@@currstring)  
             AND    banm_deleted_ind = 0  
             --  
             ROLLBACK TRANSACTION  
           --  
           END  
           ELSE  
           BEGIN  
           --  
             
             COMMIT TRANSACTION   
               
             SELECT @@t_errorstr     = @@t_errorstr+convert(varchar, @@currstring)+@coldelimiter+banm_name+@coldelimiter+banm_branch+@coldelimiter+isnull(banm_micr,'0')+@coldelimiter+isnull(banm_rtgs_cd,'')+@coldelimiter+isnull(banm_payloc_cd,'')+@coldelimiter+isnull(banm_rmks,'')+@coldelimiter+@coldelimiter+@coldelimiter+convert(varchar,@@l_error)+@rowdelimiter  
             FROM   bank_mstr          WITH (NOLOCK)  
             WHERE  banm_id          = convert(int,@@currstring)  
             AND    banm_deleted_ind = 1   
               
           --  
           END  
        --  
        END  
       --  
       END  
      --  
      END  
     --  
     IF @pa_action ='rej'  
     BEGIN  
       --  
       IF @pa_chk_yn = 1 -- IF CHECKER IS REJECTING  
       BEGIN  
       --  
         BEGIN TRANSACTION  
         --  
         UPDATE bank_mstr_mak WITH (ROWLOCK)  
         SET    banm_deleted_ind = 3  
              , banm_lst_upd_by  = @pa_login_name  
              , banm_lst_upd_dt  = getdate()  
         WHERE  banm_id          = convert(int,@@currstring)  
         AND    banm_deleted_ind = 0  
         --  
         SET @@l_error = @@error  
         --  
         IF @@l_error > 0  
         BEGIN  
         --  
           SELECT @@t_errorstr = @@t_errorstr+convert(varchar, @@currstring)+@coldelimiter+banm_name+@coldelimiter+banm_branch+@coldelimiter+isnull(banm_micr,'')+@coldelimiter+isnull(banm_rtgs_cd,'')+@coldelimiter+isnull(banm_payloc_cd,'')+@coldelimiter+isnull(banm_rmks,'')+@coldelimiter+convert(varchar,@@l_error)+@rowdelimiter  
           FROM   bank_mstr_mak with (nolock)  
           WHERE  banm_id       =   convert(int,@@currstring)  
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
     IF @pa_action = 'DEL'  
     BEGIN  
       --  
       SET @l_banm_id=@@currstring  
       --  
       BEGIN TRANSACTION  
       --  
       UPDATE bank_mstr         WITH (ROWLOCK)  
       SET    banm_deleted_ind  = 0  
            , banm_lst_upd_by   = @pa_login_name  
            , banm_lst_upd_dt   = getdate()  
       WHERE  banm_id           = @l_banm_id  
       --  
       UPDATE entity_adr_conc with (rowlock)  
       SET    entac_deleted_ind = 0  
            , entac_lst_upd_by  = @pa_login_name  
            , entac_lst_upd_dt  = getdate()  
       WHERE  entac_ent_id      = @l_banm_id  
       --  
       UPDATE addresses with (rowlock)  
       SET    adr_deleted_ind   = 0  
            , adr_lst_upd_by    = @pa_login_name  
            , adr_lst_upd_dt    = getdate()  
       WHERE  adr_id IN(SELECT entac_adr_conc_id  
                        FROM   entity_adr_conc WITH (NOLOCK)  
                        WHERE  entac_ent_id    = @l_banm_id  
                        )  
       --  
       UPDATE contact_channels WITH (ROWLOCK)  
       SET    conc_deleted_ind = 0  
         ,conc_lst_upd_by  = @pa_login_name  
             ,conc_lst_upd_dt  = getdate()  
       WHERE  conc_id IN(SELECT entac_adr_conc_id  
                         FROM   entity_adr_conc  WITH (NOLOCK)  
                         WHERE  entac_ent_id    = @l_banm_id  
                         )  
       --  
       SET @@l_error = @@error  
       --  
       IF @@l_error > 0  
       BEGIN  
         --  
         SELECT @@t_errorstr     = @@t_errorstr+convert(varchar, @@currstring)+@coldelimiter+banm_name+@coldelimiter+banm_branch+@coldelimiter+isnull(banm_micr,'')+@coldelimiter+isnull(banm_rtgs_cd,'')+@coldelimiter+isnull(banm_payloc_cd,'')+@coldelimiter
+isnull(banm_rmks,'')+@coldelimiter+convert(varchar,@@l_error)+@rowdelimiter  
         FROM   bank_mstr        WITH (NOLOCK)  
         WHERE  banm_id          = convert(int,@@currstring)  
         AND    banm_deleted_ind = 1  
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
     END  --ACTION TYPE = DEL ENDS HERE  
     --  
     IF @pa_action = 'EDT'  
     BEGIN  
       --  
       SET @l_banm_id=@@currstring  
       --  
       IF @pa_chk_yn = 0 -- IF NO MAKER CHECKER  
       BEGIN  
         --  
         BEGIN TRANSACTION  
         --  
         UPDATE bank_mstr WITH (ROWLOCK)  
         SET    banm_name         = @pa_banm_name  
              , banm_branch       = @pa_banm_branch  
              , banm_micr         = @pa_banm_micr  
              , banm_rtgs_cd      = @pa_rtgs_cd  
              , banm_payloc_cd    = @pa_pay_loc_cd  
              , banm_rmks         = @pa_banm_rmks  
              , banm_lst_upd_by   = @pa_login_name  
              , banm_lst_upd_dt   = getdate()  
         WHERE  banm_id           = convert(int, @@currstring)  
         --  
         SET @@l_error = @@error  
         --  
         IF @@l_error > 0  
         BEGIN  
           --  
           SET @@t_errorstr = @@t_errorstr+convert(varchar, @@currstring)+@coldelimiter+@pa_banm_name+@coldelimiter+@pa_banm_branch+@coldelimiter+isnull(convert(varchar, @pa_banm_micr),'')+@coldelimiter+isnull(convert(varchar, @pa_rtgs_cd),'')+@coldelimiter+isnull(convert(varchar, @pa_pay_loc_cd),'')+@coldelimiter+isnull(@pa_banm_rmks,'')+@coldelimiter+@coldelimiter+@coldelimiter+convert(varchar,@@l_error)+@rowdelimiter  
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
       IF @pa_chk_yn = 1 -- IF MAKER OR CHEKER IS EDITING  
       BEGIN  
         --  
         BEGIN TRANSACTION  
         --  
         UPDATE bank_mstr_mak WITH (ROWLOCK)  
         SET    banm_deleted_ind = 2  
              , banm_lst_upd_by  = @pa_login_name  
              , banm_lst_upd_dt  = getdate()  
         WHERE  banm_id          = CONVERT(INT, @@CURRSTRING)  
         AND    banm_deleted_ind = 0  
         --  
         SET @@l_error = @@error  
         --  
         IF @@l_error > 0  
         BEGIN  
         --  
           SET @@t_errorstr = @@t_errorstr+convert(varchar, @@currstring)+@coldelimiter+@pa_banm_name+@coldelimiter+@pa_banm_branch+@coldelimiter+isnull(convert(varchar, @pa_banm_micr),'')+@coldelimiter+isnull(@pa_banm_rmks,'')+@coldelimiter+@coldelimiter
+@coldelimiter+convert(varchar,@@l_error)+@rowdelimiter  
           --  
           ROLLBACK TRANSACTION  
         --  
         END  
         ELSE  
         BEGIN  
         --  
           INSERT INTO bank_mstr_mak  
           (banm_id  
           ,banm_name  
           ,banm_branch  
           ,banm_micr  
           ,banm_rtgs_cd  
           ,banm_payloc_cd  
           ,banm_rmks  
           ,banm_created_by  
           ,banm_created_dt  
           ,banm_lst_upd_by  
           ,banm_lst_upd_dt  
           ,banm_deleted_ind  
           )  
           VALUES  
           (convert(int,@@currstring)  
           ,@pa_banm_name  
           ,@pa_banm_branch  
           ,@pa_banm_micr  
           ,@pa_rtgs_cd  
           ,@pa_pay_loc_cd  
           ,@pa_banm_rmks  
           ,@pa_login_name  
           ,getdate()  
           ,@pa_login_name  
           ,getdate()  
           ,0  
           )  
           --  
           SET @@l_error = @@error  
           --  
           IF @@l_error > 0  
           BEGIN  
           --  
             SET @@t_errorstr = @@t_errorstr+convert(varchar, @@currstring)+@coldelimiter+@pa_banm_name+@coldelimiter+@pa_banm_branch+@coldelimiter+isnull(convert(varchar, @pa_banm_micr),'')+@coldelimiter+isnull(convert(varchar, @pa_rtgs_cd),'')+@coldelimiter+isnull(convert(varchar, @pa_pay_loc_cd),'')+@coldelimiter+isnull(@pa_banm_rmks,'')+@coldelimiter++convert(varchar,@@l_error)+@rowdelimiter  
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
     END  --ACTION TYPE = EDT ENDS HERE  
    --  
   END  
   --  
 END  
  
 IF @pa_action = 'EDT' OR @pa_action = 'APP' OR @pa_action = 'DEL'  
 BEGIN  
 --  
   SET @l_action = 'EDT'  
 --  
 END  
 ELSE  
 BEGIN  
 --  
   SET @l_action = 'INS'  
 --  
 END  
 --  
 IF @pa_action <> 'APP' AND @pa_adr_flg = 1  
 BEGIN  
 --  
   BEGIN TRANSACTION  
   --  
   EXEC pr_ins_upd_addr @l_banm_id, @l_action, @pa_login_name, @l_banm_id, '', @pa_adr_values, 0, @rowdelimiter, @coldelimiter ,''  
   --  
   SET @@l_error = @@error  
   --  
   IF @@l_error > 0  
   BEGIN  
   --  
     set @@t_errorstr = @@t_errorstr+convert(varchar, @@currstring)+@coldelimiter+@pa_banm_name+@coldelimiter+@pa_banm_branch+@coldelimiter+isnull(convert(varchar, @pa_banm_micr),'')+@coldelimiter+isnull(convert(varchar, @pa_rtgs_cd),'')+@coldelimiter+isnull(convert(varchar, @pa_pay_loc_cd),'')+@coldelimiter+isnull(@pa_banm_rmks,'')+@coldelimiter+convert(varchar,@@l_error)+@rowdelimiter  
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
  
 IF @pa_action <> 'APP' AND @pa_conc_flg = 1  
 BEGIN  
 --  
   BEGIN TRANSACTION  
   --  
   exec pr_ins_upd_conc @l_banm_id, @l_action, @pa_login_name, @l_banm_id, '', @pa_conc_values, 0, @rowdelimiter, @coldelimiter ,''  
   --  
   SET @@l_error = @@error  
   --  
   IF @@l_error > 0  
   BEGIN  
   --  
     SET @@t_errorstr = @@t_errorstr+convert(varchar, @@currstring)+@coldelimiter+@pa_banm_name+@coldelimiter+@pa_banm_branch+@coldelimiter+isnull(convert(varchar, @pa_banm_micr),'')+@coldelimiter+isnull(convert(varchar, @pa_rtgs_cd),'')+@coldelimiter+isnull(convert(varchar, @pa_pay_loc_cd),'')+@coldelimiter+isnull(@pa_banm_rmks,'')+@coldelimiter+convert(varchar,@@l_error)+@rowdelimiter  
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
 SET @pa_errmsg = @@t_errorstr  
 --  
END

GO
