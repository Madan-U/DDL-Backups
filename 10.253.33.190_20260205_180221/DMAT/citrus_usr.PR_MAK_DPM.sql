-- Object: PROCEDURE citrus_usr.PR_MAK_DPM
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE  PROCEDURE [citrus_usr].[PR_MAK_DPM]  ( @PA_ID               VARCHAR(8000)    
                              , @PA_ACTION           VARCHAR(20)    
                              , @PA_LOGIN_NAME       VARCHAR(20)    
                              , @PA_DPM_NAME         VARCHAR(100)    
                              , @PA_DPM_DPID         VARCHAR(20)    
                              , @PA_EXCSM_ID         NUMERIC  
                              , @PA_DPM_SHORT_NAME   VARCHAR(20)  
                              , @PA_DPM_RMKS         VARCHAR(200)    
                              , @PA_CHK_YN           INT    
                              , @PA_ADR_FLG          INT    
                              , @PA_ADR_VALUES       VARCHAR(8000)    
                              , @PA_CONC_FLG         INT    
                              , @PA_CONC_VALUES      VARCHAR(8000)    
                              , @ROWDELIMITER        CHAR(4)    
                              , @COLDELIMITER        CHAR(4)    
                              , @PA_ERRMSG           VARCHAR(8000) OUTPUT    
)    
AS    
/*    
*********************************************************************************    
 SYSTEM         : CLASS    
 MODULE NAME    : PR_MAK_DPM    
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR DP MASTER    
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.    
 VERSION HISTORY:    
 VERS.  AUTHOR           DATE        REASON    
 -----  -------------   ----------   -------------------------------------------------    
 1.0    TUSHAR          11-12-2006   INITIAL VERSION.    
 -----------------------------------------------------------------------------------*/    
--    
BEGIN    
  --    
  SET NOCOUNT ON    
  --    
  DECLARE @@T_ERRORSTR      VARCHAR(8000)    
        , @L_DMDPM_ID       BIGINT    
        , @L_DPM_ID         BIGINT    
        , @@L_ERROR         BIGINT    
        , @DELIMETER        VARCHAR(10)    
        , @@REMAININGSTRING VARCHAR(8000)    
        , @@CURRSTRING      VARCHAR(8000)    
        , @@FOUNDAT         INTEGER    
        , @@DELIMETERLENGTH INT    
        , @L_ACTION         VARCHAR(10)    
  --    
  SET @@L_ERROR = 0    
  SET @@T_ERRORSTR = ''    
  --    
  SET @DELIMETER = '%'+ @ROWDELIMITER + '%'    
  SET @@DELIMETERLENGTH = LEN(@ROWDELIMITER)    
  --    
  SET @@REMAININGSTRING = @PA_ID    
  WHILE @@REMAININGSTRING <> ''    
  BEGIN    
   --    
   SET @@FOUNDAT = 0    
   SET @@FOUNDAT =  PATINDEX('%'+@DELIMETER+'%',@@REMAININGSTRING)    
   --    
   IF @@FOUNDAT > 0    
   BEGIN    
     --    
     SET @@CURRSTRING      = SUBSTRING(@@REMAININGSTRING, 0,@@FOUNDAT)    
     SET @@REMAININGSTRING = SUBSTRING(@@REMAININGSTRING, @@FOUNDAT+@@DELIMETERLENGTH,LEN(@@REMAININGSTRING)- @@FOUNDAT+@@DELIMETERLENGTH)    
     --    
   END    
   ELSE    
   BEGIN    
     --    
     SET @@CURRSTRING      = @@REMAININGSTRING    
     SET @@REMAININGSTRING = ''    
     --    
   END    
   --    
   IF @@CURRSTRING <> ''    
   BEGIN    
     --    
     IF @PA_ACTION = 'INS' --ACTION TYPE = INS BEGINS HERE    
     BEGIN    
       --    
       IF @PA_CHK_YN = 0 -- IF MAKER CHECKER FUNCTIONALITY IS NOT REQD    
       BEGIN    
         --    
         BEGIN TRANSACTION    
         --    
         SELECT @L_DPM_ID=BITRM_BIT_LOCATION    
         FROM BITMAP_REF_MSTR WITH(NOLOCK)    
         WHERE BITRM_PARENT_CD='ENTITY_ID'    
         AND BITRM_CHILD_CD='ENTITY_ID'    
    
         UPDATE BITMAP_REF_MSTR WITH(ROWLOCK)    
         SET BITRM_BIT_LOCATION=BITRM_BIT_LOCATION+1    
         WHERE BITRM_PARENT_CD='ENTITY_ID'    
         AND BITRM_CHILD_CD='ENTITY_ID'    
         --    
         INSERT INTO DP_MSTR    
         ( DPM_ID    
         , DPM_NAME    
         , DPM_DPID    
         , DPM_EXCSM_ID  
         , DPM_SHORT_NAME  
         , DPM_RMKS    
         , DPM_CREATED_BY    
         , DPM_CREATED_DT    
         , DPM_LST_UPD_BY    
         , DPM_LST_UPD_DT    
         , DPM_DELETED_IND    
         )    
         VALUES    
         ( @L_DPM_ID    
         , @PA_DPM_NAME    
         , @PA_DPM_DPID    
         , @PA_EXCSM_ID  
         , @PA_DPM_SHORT_NAME  
         , @PA_DPM_RMKS    
         , @PA_LOGIN_NAME    
         , GETDATE()    
         , @PA_LOGIN_NAME    
         , GETDATE()    
         , 1    
         )    
         --    
         SET @@L_ERROR = @@ERROR    
         --    
         IF @@L_ERROR  > 0    
         BEGIN    
           --    
           ROLLBACK TRANSACTION    
           --    
           SET @@T_ERRORSTR=@@T_ERRORSTR+ISNULL(@@CURRSTRING,'')+@COLDELIMITER+ISNULL(@PA_DPM_NAME,'')+@COLDELIMITER+ISNULL(@PA_DPM_DPID,'')+@COLDELIMITER+ISNULL(convert(varchar(10),@PA_EXCSM_ID),'')+@COLDELIMITER+ISNULL(@PA_DPM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(@PA_DPM_RMKS,'')+@COLDELIMITER+@COLDELIMITER+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER    
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
       IF @PA_CHK_YN = 1 -- IF MAKER IS INSERTING    
       BEGIN    
         --    
         BEGIN TRANSACTION    
         --    
         SELECT @L_DPM_ID=BITRM_BIT_LOCATION    
         FROM BITMAP_REF_MSTR WITH(NOLOCK)    
         WHERE BITRM_PARENT_CD='ENTITY_ID'    
         AND BITRM_CHILD_CD='ENTITY_ID'    
    
         UPDATE BITMAP_REF_MSTR WITH(ROWLOCK)    
         SET BITRM_BIT_LOCATION=BITRM_BIT_LOCATION+1    
         WHERE BITRM_PARENT_CD='ENTITY_ID'    
         AND BITRM_CHILD_CD='ENTITY_ID'    
         --    
         INSERT INTO DP_MSTR_MAK    
         ( DPM_ID    
         , DPM_NAME    
         , DPM_DPID    
         , DPM_EXCSM_ID  
         , DPM_SHORT_NAME  
         , DPM_RMKS    
         , DPM_CREATED_BY    
         , DPM_CREATED_DT    
         , DPM_LST_UPD_BY    
         , DPM_LST_UPD_DT    
         , DPM_DELETED_IND)    
         VALUES    
         ( @L_DPM_ID    
         , @PA_DPM_NAME    
         , @PA_DPM_DPID    
         , @PA_EXCSM_ID   
         , @PA_DPM_SHORT_NAME  
         , @PA_DPM_RMKS    
         , @PA_LOGIN_NAME    
         , GETDATE()    
         , @PA_LOGIN_NAME    
         , GETDATE()    
         , 0    
         )    
         --    
         SET @@L_ERROR = @@ERROR    
         --    
         IF @@L_ERROR  > 0    
         BEGIN    
           --    
           ROLLBACK TRANSACTION    
           --    
           --SET @@T_ERRORSTR=@@T_ERRORSTR+ISNULL(@@CURRSTRING,'')+@COLDELIMITER+ISNULL(@PA_DPM_NAME,'')+@COLDELIMITER+ISNULL(@PA_DPM_DPID,'')+@COLDELIMITER+ISNULL(@PA_DPM_TYPE,'')+@COLDELIMITER+ISNULL(@PA_DPM_RMKS,'')+@COLDELIMITER+@COLDELIMITER+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER    
           SET @@T_ERRORSTR=@@T_ERRORSTR+ISNULL(@@CURRSTRING,'')+@COLDELIMITER+ISNULL(@PA_DPM_NAME,'')+@COLDELIMITER+ISNULL(@PA_DPM_DPID,'')+@COLDELIMITER+ISNULL(convert(varchar(10),@PA_EXCSM_ID),'')+@COLDELIMITER+ISNULL(@PA_DPM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(@PA_DPM_RMKS,'')+@COLDELIMITER+@COLDELIMITER+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER    
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
        
         
     IF @PA_ACTION = 'APP'    --ACTION TYPE = APP STARTS HERE    
     BEGIN    
       --    
       IF EXISTS(SELECT DPM_ID    
                 FROM   DP_MSTR    
                 WHERE  DPM_ID = CONVERT(INT, @@CURRSTRING))    
       BEGIN    
         --    
         BEGIN TRANSACTION    
         --    
         UPDATE DPM WITH(ROWLOCK)    
         SET    DPM.DPM_NAME        = DPMM.DPM_NAME    
              , DPM.DPM_DPID        = DPMM.DPM_DPID    
              , DPM.DPM_EXCSM_ID     = DPMM.DPM_EXCSM_ID   
              , DPM.DPM_SHORT_NAME  = DPMM.DPM_SHORT_NAME  
              , DPM.DPM_RMKS        = DPMM.DPM_RMKS    
              , DPM.DPM_LST_UPD_BY  = @PA_LOGIN_NAME    
, DPM.DPM_LST_UPD_DT  = GETDATE()    
              , DPM.DPM_DELETED_IND = 1    
         FROM DP_MSTR     DPM    
             ,DP_MSTR_MAK DPMM    
         WHERE DPM.DPM_ID         = CONVERT(INT,@@CURRSTRING)    
         AND DPMM.DPM_ID          = DPM.DPM_ID    
         AND DPM.DPM_DELETED_IND  = 1    
         AND DPMM.DPM_DELETED_IND = 0    
         AND DPMM.DPM_CREATED_BY <> @PA_LOGIN_NAME    
         --    
         SET @@L_ERROR = @@ERROR    
         --    
         IF @@L_ERROR  > 0    
         BEGIN    
           --    
           SELECT @@T_ERRORSTR=@@T_ERRORSTR+ISNULL(@@CURRSTRING,'')+@COLDELIMITER+ISNULL(DPM_NAME,'')+@COLDELIMITER+ISNULL(DPM_DPID,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR(10),DPM_EXCSM_ID),'')+@COLDELIMITER+ISNULL(DPM_SHORT_NAME,'')+@COLDELIMITER+ISNULL
(DPM_RMKS,'')+@COLDELIMITER+@COLDELIMITER+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER    
           FROM  DP_MSTR_MAK WITH(NOLOCK)             WHERE DPM_ID = CONVERT(INT, @@CURRSTRING)    
           AND   DPM_DELETED_IND =0    
           --    
           ROLLBACK TRANSACTION    
           --    
         END    
         ELSE    
         BEGIN    
           --    
           UPDATE DP_MSTR_MAK WITH(ROWLOCK)    
           SET    DPM_DELETED_IND  = 1    
                , DPM_LST_UPD_BY   = @PA_LOGIN_NAME    
                , DPM_LST_UPD_DT   = GETDATE()    
           WHERE  DPM_ID           = CONVERT(INT,@@CURRSTRING)    
           AND    DPM_CREATED_BY  <> @PA_LOGIN_NAME    
           AND    DPM_DELETED_IND  = 0    
           --    
           SET @@L_ERROR = @@ERROR    
           --    
           IF @@L_ERROR  > 0    
           BEGIN    
             --    
             SELECT @@T_ERRORSTR=@@T_ERRORSTR+ISNULL(@@CURRSTRING,'')+@COLDELIMITER+ISNULL(DPM_NAME,'')+@COLDELIMITER+ISNULL(DPM_DPID,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR(10),DPM_EXCSM_ID),'')+@COLDELIMITER+ISNULL(DPM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(DPM_RMKS,'')+@COLDELIMITER+@COLDELIMITER+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER    
             FROM  DP_MSTR_MAK WITH(NOLOCK)    
             WHERE DPM_ID          = CONVERT(INT,@@CURRSTRING)    
             AND   DPM_DELETED_IND = 0    
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
         INSERT INTO DP_MSTR    
         ( DPM_ID    
         , DPM_NAME    
         , DPM_DPID    
         , DPM_EXCSM_ID    
         , DPM_SHORT_NAME  
         , DPM_RMKS    
         , DPM_CREATED_BY    
         , DPM_CREATED_DT    
         , DPM_LST_UPD_BY    
         , DPM_LST_UPD_DT    
         , DPM_DELETED_IND    
         )    
         SELECT DPMM.DPM_ID    
              , DPMM.DPM_NAME    
              , DPMM.DPM_DPID    
              , DPMM.DPM_EXCSM_ID    
              , DPMM.DPM_SHORT_NAME  
              , DPMM.DPM_RMKS    
              , DPMM.DPM_CREATED_BY    
              , DPMM.DPM_CREATED_DT    
              , @PA_LOGIN_NAME    
              , GETDATE()    
              , 1    
         FROM   DP_MSTR_MAK DPMM    
         WHERE  DPMM.DPM_ID = CONVERT(INT,@@CURRSTRING)    
         AND    DPMM.DPM_CREATED_BY  <> @PA_LOGIN_NAME    
         AND    DPMM.DPM_DELETED_IND  = 0    
         --    
         SET @@L_ERROR = CONVERT(INT, @@ERROR)    
         --    
         IF @@L_ERROR  > 0    
         BEGIN    
           --    
           SELECT @@T_ERRORSTR=@@T_ERRORSTR+ISNULL(@@CURRSTRING,'')+@COLDELIMITER+ISNULL(DPM_NAME,'')+@COLDELIMITER+ISNULL(DPM_DPID,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR(10),DPM_EXCSM_ID),'')+@COLDELIMITER+ISNULL(DPM_SHORT_NAME,'')+@COLDELIMITER+ISNULL
(DPM_RMKS,'')+@COLDELIMITER+@COLDELIMITER+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER    
           FROM   DP_MSTR_MAK WITH(NOLOCK)    
           WHERE  DPM_ID          = CONVERT(INT,@@CURRSTRING)    
           AND    DPM_DELETED_IND = 0    
           --    
           ROLLBACK TRANSACTION    
           --    
           END    
         ELSE    
         BEGIN    
           --    
           UPDATE DP_MSTR_MAK WITH(ROWLOCK)    
           SET    DPM_DELETED_IND  = 1    
                , DPM_LST_UPD_BY   = @PA_LOGIN_NAME    
                , DPM_LST_UPD_DT   = GETDATE()    
           WHERE  DPM_ID           = CONVERT(INT,@@CURRSTRING)    
           AND    DPM_CREATED_BY  <> @PA_LOGIN_NAME    
           AND    DPM_DELETED_IND  = 0    
    
           SET @@L_ERROR = @@ERROR    
           IF  @@L_ERROR > 0    
           BEGIN                     --IF ANY ERROR REPORTED THE GENERATE THE ERROR MESSAGE STRING    
             --    
             SELECT @@T_ERRORSTR=@@T_ERRORSTR+ISNULL(@@CURRSTRING,'')+@COLDELIMITER+ISNULL(DPM_NAME,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR(20),DPM_EXCSM_ID),'')+@COLDELIMITER+ISNULL(DPM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(DPM_RMKS,'')+@COLDELIMITER+@COLDELIMITER+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER    
             FROM  DP_MSTR_MAK WITH(NOLOCK)    
             WHERE DPM_ID          = CONVERT(INT,@@CURRSTRING)    
             AND   DPM_DELETED_IND = 0    
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
     END    
    
     IF @PA_ACTION = 'REJ'    --ACTION TYPE = REJ BEGINS HERE    
     BEGIN    
       --    
       IF @PA_CHK_YN = 1    
       BEGIN    
         --    
         BEGIN TRANSACTION    
         --    
         UPDATE DP_MSTR_MAK WITH(ROWLOCK)    
         SET    DPM_DELETED_IND = 3    
              , DPM_LST_UPD_BY  = @PA_LOGIN_NAME    
              , DPM_LST_UPD_DT  = GETDATE()    
         WHERE  DPM_ID          = CONVERT(INT,@@CURRSTRING)    
         AND    DPM_DELETED_IND = 0    
         --    
         SET @@L_ERROR = @@ERROR    
         --    
         IF @@L_ERROR > 0    
         BEGIN    
           --    
           SELECT @@T_ERRORSTR=@@T_ERRORSTR+ISNULL(@@CURRSTRING,'')+@COLDELIMITER+ISNULL(DPM_NAME,'')+@COLDELIMITER+ISNULL(DPM_DPID,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR(20),DPM_EXCSM_ID),'')+@COLDELIMITER+ISNULL(DPM_SHORT_NAME,'')+@COLDELIMITER+ISNULL
(DPM_RMKS,'')+@COLDELIMITER+@COLDELIMITER+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER    
           FROM  DP_MSTR_MAK WITH(NOLOCK)    
           WHERE DPM_ID = CONVERT(INT,@@CURRSTRING)    
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
     END    --ACTION TYPE = REJ ENDS HERE    
     --    
     IF @PA_ACTION = 'DEL'    
     BEGIN    
       --    
       BEGIN TRANSACTION    
       --    
       SET @L_DPM_ID = @@CURRSTRING     
       --    
       UPDATE DP_MSTR WITH(ROWLOCK)    
       SET    DPM_DELETED_IND = 0    
            , DPM_LST_UPD_BY  = @PA_LOGIN_NAME    
            , DPM_LST_UPD_DT  = GETDATE()    
       WHERE  DPM_ID          = CONVERT(INT,@@CURRSTRING)    
       --    
       UPDATE ENTITY_ADR_CONC WITH (ROWLOCK)    
       SET    ENTAC_DELETED_IND = 0    
            , ENTAC_LST_UPD_BY  = @PA_LOGIN_NAME    
            , ENTAC_LST_UPD_DT  = GETDATE()    
       WHERE  ENTAC_ENT_ID      = @L_DPM_ID    
    --    
      UPDATE ADDRESSES WITH (ROWLOCK)    
      SET    ADR_DELETED_IND = 0    
           , ADR_LST_UPD_BY   = @PA_LOGIN_NAME    
           , ADR_LST_UPD_DT   = GETDATE()    
      WHERE  ADR_ID IN( SELECT ENTAC_ADR_CONC_ID FROM ENTITY_ADR_CONC WHERE ENTAC_ENT_ID = @L_DPM_ID)    
    --    
      UPDATE CONTACT_CHANNELS WITH (ROWLOCK)    
      SET    CONC_DELETED_IND = 0    
           , CONC_LST_UPD_BY  = @PA_LOGIN_NAME    
           , CONC_LST_UPD_DT  = GETDATE()    
      WHERE  CONC_ID IN( SELECT ENTAC_ADR_CONC_ID FROM ENTITY_ADR_CONC WHERE ENTAC_ENT_ID = @L_DPM_ID)    
   --    
       SET @@L_ERROR = @@ERROR    
       --    
       IF @@L_ERROR > 0    
       BEGIN    
         --    
         SELECT @@T_ERRORSTR=@@T_ERRORSTR+ISNULL(@@CURRSTRING,'')+@COLDELIMITER+ISNULL(DPM_NAME,'')+@COLDELIMITER+ISNULL(DPM_DPID,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR(20),DPM_EXCSM_ID),'')+@COLDELIMITER+ISNULL(DPM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(DPM_RMKS,'')+@COLDELIMITER+@COLDELIMITER+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER    
         FROM   DP_MSTR WITH(NOLOCK)    
         WHERE  DPM_ID  = CONVERT(INT,@@CURRSTRING)    
         AND    DPM_DELETED_IND = 1    
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
     IF @PA_ACTION = 'EDT'    
     BEGIN    
       --    
       SET @L_DPM_ID=@@CURRSTRING     
       --    
       IF @PA_CHK_YN = 0 -- IF NO MAKER CHECKER    
       BEGIN    
         --    
             
         BEGIN TRANSACTION    
         --    
         UPDATE DP_MSTR WITH(ROWLOCK)    
         SET    DPM_NAME        = @PA_DPM_NAME    
              , DPM_DPID        = @PA_DPM_DPID    
              --, DPM_EXCSM_ID    = @PA_EXCSM_ID   
              , DPM_SHORT_NAME  = @PA_DPM_SHORT_NAME  
              , DPM_RMKS        = @PA_DPM_RMKS    
              , DPM_LST_UPD_BY  = @PA_LOGIN_NAME    
              , DPM_LST_UPD_DT  = GETDATE()    
         WHERE  DPM_ID          = CONVERT(INT, @@CURRSTRING)    
         --    
         SET @@L_ERROR = @@ERROR    
         --    
         IF @@L_ERROR > 0    
         BEGIN    
           --    
            SET @@T_ERRORSTR=@@T_ERRORSTR+ISNULL(@@CURRSTRING,'')+@COLDELIMITER+ISNULL(@PA_DPM_NAME,'')+@COLDELIMITER+ISNULL(@PA_DPM_DPID,'')+@COLDELIMITER+ISNULL(CONVERT(VARCHAR(20),@PA_EXCSM_ID),'')+@COLDELIMITER+ISNULL(@PA_DPM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(@PA_DPM_RMKS,'')+@COLDELIMITER+@COLDELIMITER+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER    
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
       IF @PA_CHK_YN = 1 -- IF MAKER OR CHEKER IS EDITING    
       BEGIN    
         --    
         BEGIN TRANSACTION    
         --    
         UPDATE DP_MSTR_MAK  WITH(ROWLOCK)    
         SET    DPM_DELETED_IND = 2    
              , DPM_LST_UPD_BY  = @PA_LOGIN_NAME    
              , DPM_LST_UPD_DT  = GETDATE()    
         WHERE  DPM_ID          = CONVERT(INT, @@CURRSTRING)    
         AND    DPM_DELETED_IND = 0    
         --    
         SET @@L_ERROR = @@ERROR    
         --    
         IF @@L_ERROR > 0    
         BEGIN    
           --    
           SET @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_DPM_NAME+@COLDELIMITER+@PA_DPM_DPID+@COLDELIMITER+CONVERT(VARCHAR(20),@PA_EXCSM_ID)+@COLDELIMITER+ISNULL(@PA_DPM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(@PA_DPM_RMKS,'')+@COLDELIMITER+@COLDELIMITER+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER  
    
           --    
           ROLLBACK TRANSACTION    
           --    
         END    
         ELSE    
         BEGIN    
           --    
           INSERT INTO DP_MSTR_MAK    
           ( DPM_ID    
           , DPM_NAME    
           , DPM_DPID    
           , DPM_EXCSM_ID    
           , DPM_SHORT_NAME  
           , DPM_RMKS    
           , DPM_CREATED_BY    
           , DPM_CREATED_DT    
           , DPM_LST_UPD_BY    
           , DPM_LST_UPD_DT    
           , DPM_DELETED_IND    
           )    
           VALUES    
           ( CONVERT(INT,@@CURRSTRING)    
           , @PA_DPM_NAME    
           , @PA_DPM_DPID    
           , @PA_EXCSM_ID  
           , @PA_DPM_SHORT_NAME  
           , @PA_DPM_RMKS    
         , @PA_LOGIN_NAME    
           , GETDATE()    
           , @PA_LOGIN_NAME    
           , GETDATE()    
           , 0    
           )    
           --    
           SET @@L_ERROR = @@ERROR    
           --    
           IF @@L_ERROR > 0    
           BEGIN    
             --    
             SET @@T_ERRORSTR=@@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_DPM_NAME+@COLDELIMITER+@PA_DPM_DPID+@COLDELIMITER+CONVERT(VARCHAR(20),@PA_EXCSM_ID)+@COLDELIMITER+ISNULL(@PA_DPM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(@PA_DPM_RMKS,'')+@COLDELIMITER+@COLDELIMITER+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER               --    
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
    
  IF @PA_ACTION = 'EDT' OR @PA_ACTION ='APP' OR @PA_ACTION ='REJ'    
  BEGIN    
    --    
    SET @L_ACTION = 'EDT'    
    --    
  END    
  ELSE    
  BEGIN    
    --    
    SET @L_ACTION ='INS'    
    --    
  END    
    
  IF @PA_ACTION <> 'APP' AND @PA_ADR_FLG = 1    
  BEGIN    
    --    
    BEGIN TRANSACTION    
    --    
    EXEC PR_INS_UPD_ADDR @L_DPM_ID, @L_ACTION, @PA_LOGIN_NAME, @L_DPM_ID, '', @PA_ADR_VALUES, 0, @ROWDELIMITER, @COLDELIMITER ,''    
    --    
    SET @@L_ERROR = @@ERROR    
    --    
    IF @@L_ERROR > 0    
    BEGIN    
    --    
      SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_DPM_NAME+@COLDELIMITER+@PA_DPM_DPID+@COLDELIMITER+CONVERT(VARCHAR(10),@PA_EXCSM_ID)+@COLDELIMITER+ISNULL(@PA_DPM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(@PA_DPM_RMKS,'')+@COLDELIMITER+@COLDELIMITER+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER    
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
    
  IF @PA_ACTION <> 'APP' AND @PA_CONC_FLG = 1    
  BEGIN    
  --    
   BEGIN TRANSACTION    
   --    
   EXEC PR_INS_UPD_CONC @L_DPM_ID, @L_ACTION, @PA_LOGIN_NAME, @L_DPM_ID, '', @PA_CONC_VALUES, 0, @ROWDELIMITER, @COLDELIMITER ,''    
   --    
   IF @@L_ERROR > 0    
   BEGIN    
   --    
     SET @@T_ERRORSTR = @@T_ERRORSTR+@@CURRSTRING+@COLDELIMITER+@PA_DPM_NAME+@COLDELIMITER+@PA_DPM_DPID+@COLDELIMITER+CONVERT(VARCHAR(10),@PA_EXCSM_ID)+@COLDELIMITER+ISNULL(@PA_DPM_SHORT_NAME,'')+@COLDELIMITER+ISNULL(@PA_DPM_RMKS,'')+@COLDELIMITER+@COLDELIMITER+@COLDELIMITER+CONVERT(VARCHAR,@@L_ERROR)+@ROWDELIMITER    
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
  SET @PA_ERRMSG = @@T_ERRORSTR    
  --    
 --    
 END

GO
