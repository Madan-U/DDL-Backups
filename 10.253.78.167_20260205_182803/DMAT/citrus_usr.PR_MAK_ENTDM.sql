-- Object: PROCEDURE citrus_usr.PR_MAK_ENTDM
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_MAK_ENTDM](@PA_ID              VARCHAR(8000)
                            ,@PA_ACTION          VARCHAR(20)
                            ,@PA_LOGIN_NAME      VARCHAR(20)
                            ,@PA_ENTPM_PROP_ID   VARCHAR(20)
                            ,@PA_ENTDM_CD        VARCHAR(20)
                            ,@PA_ENTDM_RMKS      VARCHAR(200)
                            ,@PA_ENTDM_DESC      VARCHAR(100)
                            ,@PA_ENTDM_DATATYPE  VARCHAR(5)
                            ,@PA_ENTDM_MDTY      SMALLINT
                            ,@PA_CHK_YN          INT
                            ,@ROWDELIMITER       CHAR(4) =  '*|~*'
                            ,@COLDELIMITER       CHAR(4) = '|*~|'
                            ,@PA_ERRMSG          VARCHAR(8000) OUTPUT
                            )
AS
/*
*********************************************************************************
 SYSTEM         : CLASS
 MODULE NAME    : PR_MAK_ENTDM
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE MAKER CHECKER FACILITY FOR ENTITY_DOCUMENT_MSTR
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY: 3.0
 VERS.  AUTHOR            DATE        REASON
 -----  -------------     ----------   -------------------------------------------------
 1.0    HARI R            24-AUG-2006  INITIAL VERSION.
 2.0    SUKHVINDER/TUSHAR 06-SEP-2006  CHANGE LENGTH OF @PA_ENTDM_DESC FROM 20 TO 100
                                       PASSING OUTPUT PARAMETER FOR @PA_ERRMSG AT THE END
 3.0    SUKHVINDER/TUSHAR 08-SEP-2006  PUT PARAMETER @PA_ENTPM_ID IN INSERT VALUE OF CONDITION WITHOUT MAKER-CHECKER
 4.0    SUKHVINDER/TUSHAR 18-DEC-2006  REMARKS PARAMETER ADDED
 5.0    SUKHVINDER/TUSHAR 21-JAN-2007  CHANGES IN COLUMN NAME "ENTDM_ENTPM_PROP_ID"
-----------------------------------------------------------------------------------*/
--
BEGIN
--
SET NOCOUNT ON
--
DECLARE @@T_ERRORSTR        VARCHAR(8000)
      , @L_SENTDM_ID        BIGINT
      , @L_ENTDM_ID         BIGINT
      , @@L_ERROR           BIGINT
      , @DELIMETER          VARCHAR(10)
      , @@REMAININGSTRING   VARCHAR(8000)
      , @@CURRSTRING        VARCHAR(8000)
      , @@FOUNDAT           INTEGER
      , @@DELIMETERLENGTH   INT

SET @@L_ERROR         = 0
SET @@T_ERRORSTR      = ''
SET @DELIMETER        = '%'+ @ROWDELIMITER + '%'
SET @@DELIMETERLENGTH = LEN(@ROWDELIMITER)
SET @@REMAININGSTRING = @PA_ID
--
WHILE @@REMAININGSTRING <> ''
BEGIN
  --
  SET @@FOUNDAT = 0
  SET @@FOUNDAT = PATINDEX('%'+@DELIMETER+'%',@@REMAININGSTRING)
  --
  IF @@FOUNDAT > 0
  BEGIN
    --
    SET @@CURRSTRING      = SUBSTRING(@@REMAININGSTRING, 0,@@FOUNDAT)
    SET @@REMAININGSTRING = SUBSTRING(@@REMAININGSTRING, @@FOUNDAT+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING)- @@FOUNDAT+@@DELIMETERLENGTH)
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
    IF @PA_ACTION = 'INS'  --ACTION TYPE = INS BEGINS HERE
    BEGIN
      --
      IF @PA_CHK_YN = 0 -- IF MAKER CHECKER FUNCTIONALITY IS NOT REQD
      BEGIN
        --
        BEGIN TRANSACTION
        --
        SELECT @L_ENTDM_ID = ISNULL(MAX(ENTDM_ID),0)+1
        FROM  ENTPM_DTLS_MSTR WITH (NOLOCK)
        --
        INSERT INTO ENTPM_DTLS_MSTR
        (ENTDM_ID
        ,ENTDM_ENTPM_PROP_ID
        ,ENTDM_CD
        ,ENTDM_DESC
        ,ENTDM_RMKS
        ,ENTDM_CREATED_BY
        ,ENTDM_CREATED_DT
        ,ENTDM_LST_UPD_BY
        ,ENTDM_LST_UPD_DT
        ,ENTDM_DELETED_IND
        ,ENTDM_DATATYPE
        ,ENTDM_MDTY
        )
        VALUES
        (@L_ENTDM_ID
        ,@PA_ENTPM_PROP_ID
        ,@PA_ENTDM_CD
        ,@PA_ENTDM_DESC
        ,@PA_ENTDM_RMKS
        ,@PA_LOGIN_NAME
        ,GETDATE()
        ,@PA_LOGIN_NAME
        ,GETDATE()
        ,1
        ,@PA_ENTDM_DATATYPE
        ,@PA_ENTDM_MDTY
        )
        --
        SET @@L_ERROR = @@ERROR
        --
        IF @@L_ERROR > 0
        BEGIN
        --
          ROLLBACK TRANSACTION
          --
          SET @@T_ERRORSTR = ISNULL(@@T_ERRORSTR,'')+CONVERT(VARCHAR,@@CURRSTRING)+@COLDELIMITER+CONVERT(VARCHAR,@PA_ENTPM_PROP_ID)+@COLDELIMITER+@PA_ENTDM_CD+@COLDELIMITER+@PA_ENTDM_DESC+@COLDELIMITER+ISNULL(@PA_ENTDM_RMKS,'')+@COLDELIMITER+@PA_ENTDM_DATATYPE+@COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
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
        SELECT @L_SENTDM_ID = ISNULL(MAX(SM.ENTDM_ID),0) + 1
             , @L_ENTDM_ID  = ISNULL(MAX(S.ENTDM_ID),0) + 1
        FROM   ENTPM_DTLS_MSTR_MAK SM WITH (NOLOCK)
             , ENTPM_DTLS_MSTR S      WITH (NOLOCK)
        --
        IF @L_SENTDM_ID > @L_ENTDM_ID
        BEGIN
          --
          SET @L_ENTDM_ID = @L_SENTDM_ID
          --
        END
        --
        INSERT INTO ENTPM_DTLS_MSTR_MAK
        (ENTDM_ID
        ,ENTDM_ENTPM_PROP_ID
        ,ENTDM_CD
        ,ENTDM_DESC
        ,ENTDM_RMKS
        ,ENTDM_CREATED_BY
        ,ENTDM_CREATED_DT
        ,ENTDM_LST_UPD_BY
        ,ENTDM_LST_UPD_DT
        ,ENTDM_DELETED_IND
        ,ENTDM_DATATYPE
        ,ENTDM_MDTY
        )
        VALUES
        (@L_ENTDM_ID
        ,@PA_ENTPM_PROP_ID
        ,@PA_ENTDM_CD
        ,@PA_ENTDM_DESC
        ,@PA_ENTDM_RMKS
        ,@PA_LOGIN_NAME
        ,GETDATE()
        ,@PA_LOGIN_NAME
        ,GETDATE()
        ,0
        ,@PA_ENTDM_DATATYPE
        ,@PA_ENTDM_MDTY
        )
        --
        SET @@L_ERROR = @@ERROR
        --
        IF @@L_ERROR > 0
        BEGIN
        --
         SET @@T_ERRORSTR = ISNULL(@@T_ERRORSTR,'')+CONVERT(VARCHAR,@@CURRSTRING)+@COLDELIMITER+CONVERT(VARCHAR,@PA_ENTPM_PROP_ID)+@COLDELIMITER+@PA_ENTDM_CD+@COLDELIMITER+@PA_ENTDM_DESC+@COLDELIMITER+ISNULL(@PA_ENTDM_RMKS,'')+@COLDELIMITER+@PA_ENTDM_DATATYPE+@COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
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

    IF @PA_ACTION = 'APP'
    BEGIN
      --
      IF EXISTS(SELECT ENTDM_ID
                FROM   ENTPM_DTLS_MSTR  WITH (NOLOCK)
                WHERE  ENTDM_ID = CONVERT(INT,@@CURRSTRING))
      BEGIN
        --
        BEGIN TRANSACTION
        --
        UPDATE ENTDM                       WITH (ROWLOCK)
        SET    ENTDM.ENTDM_ENTPM_PROP_ID = ENTDMM.ENTDM_ENTPM_PROP_ID
             , ENTDM.ENTDM_CD            = ENTDMM.ENTDM_CD
             , ENTDM.ENTDM_DESC          = ENTDMM.ENTDM_DESC
             , ENTDM.ENTDM_RMKS          = ENTDMM.ENTDM_RMKS
             , ENTDM_DATATYPE            = ENTDMM.ENTDM_DATATYPE
             , ENTDM.ENTDM_MDTY          = ENTDMM.ENTDM_MDTY  
             , ENTDM.ENTDM_LST_UPD_BY    = @PA_LOGIN_NAME
             , ENTDM.ENTDM_LST_UPD_DT    = GETDATE()
        FROM   ENTPM_DTLS_MSTR ENTDM
             , ENTPM_DTLS_MSTR_MAK  ENTDMM
        WHERE  ENTDM.ENTDM_ID            = CONVERT(INT,@@CURRSTRING)
        AND    ENTDMM.ENTDM_DELETED_IND  = 0
        AND    ENTDMM.ENTDM_CREATED_BY  <> @PA_LOGIN_NAME
        --
        SET @@L_ERROR = @@ERROR
        --
        IF @@L_ERROR > 0
        BEGIN
        --
          SELECT @@T_ERRORSTR      = ISNULL(@@T_ERRORSTR,'')+CONVERT(VARCHAR,@@CURRSTRING)+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,ENTDM_ENTPM_PROP_ID),'')+@COLDELIMITER+isnull(ENTDM_CD,'')+@COLDELIMITER+isnull(ENTDM_DESC,'')+@COLDELIMITER+isnull(ENTDM_RMKS,'')+@COLDELIMITER+ENTDM_DATATYPE+@COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
          FROM   ENTPM_DTLS_MSTR_MAK WITH (NOLOCK)
          WHERE  ENTDM_ID          = @@CURRSTRING
          AND    ENTDM_DELETED_IND = 0
          --
          ROLLBACK TRANSACTION
        --
        END
        ELSE
        BEGIN
        --
          UPDATE ENTPM_DTLS_MSTR_MAK  WITH (ROWLOCK)
          SET    ENTDM_DELETED_IND = 1
                ,ENTDM_LST_UPD_BY  = @PA_LOGIN_NAME
                ,ENTDM_LST_UPD_DT  = GETDATE()
          WHERE  ENTDM_ID          = CONVERT(INT,@@CURRSTRING)
          AND    ENTDM_CREATED_BY <> @PA_LOGIN_NAME
          AND    ENTDM_DELETED_IND = 0
          --
          SET @@L_ERROR = @@ERROR
          --
          IF @@L_ERROR > 0
          BEGIN
          --
            SELECT @@T_ERRORSTR    = ISNULL(@@T_ERRORSTR,'')+CONVERT(VARCHAR,@@CURRSTRING)+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,ENTDM_ENTPM_PROP_ID),'')+@COLDELIMITER+isnull(ENTDM_CD,'')+@COLDELIMITER+isnull(ENTDM_DESC,'')+@COLDELIMITER+isnull(ENTDM_RMKS,'')+@COLDELIMITER+ENTDM_DATATYPE+@COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
            FROM  ENTPM_DTLS_MSTR_MAK  WITH (NOLOCK)
            WHERE ENTDM_ID         = CONVERT(INT,@@CURRSTRING)
            AND  ENTDM_DELETED_IND = 0
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
      END     --If record exist ends
      ELSE
      BEGIN
        --
        BEGIN TRANSACTION
        --
        INSERT INTO ENTPM_DTLS_MSTR
        (ENTDM_ID
        ,ENTDM_ENTPM_PROP_ID
        ,ENTDM_CD
        ,ENTDM_DESC
        ,ENTDM_RMKS
        ,ENTDM_CREATED_BY
        ,ENTDM_CREATED_DT
        ,ENTDM_LST_UPD_BY
        ,ENTDM_LST_UPD_DT
        ,ENTDM_DELETED_IND
        ,ENTDM_DATATYPE
        ,ENTDM_MDTY
        )
        SELECT ENTDMM.ENTDM_ID
             , ENTDMM.ENTDM_ENTPM_PROP_ID
             , ENTDMM.ENTDM_CD
             , ENTDMM.ENTDM_DESC
             , ENTDMM.ENTDM_RMKS
             , ENTDMM.ENTDM_CREATED_BY
             , ENTDMM.ENTDM_CREATED_DT
             , @PA_LOGIN_NAME
             , GETDATE()
             , 1
             , ENTDMM.ENTDM_DATATYPE
             , ENTDMM.ENTDM_MDTY
        FROM   ENTPM_DTLS_MSTR_MAK ENTDMM  WITH (NOLOCK)
        WHERE  ENTDMM.ENTDM_ID          = CONVERT(INT,@@CURRSTRING)
        AND    ENTDMM.ENTDM_CREATED_BY <> @PA_LOGIN_NAME
        AND    ENTDMM.ENTDM_DELETED_IND = 0
        --
        SET @@L_ERROR = @@ERROR
        --
        IF @@L_ERROR > 0
        BEGIN
          --
          SELECT @@T_ERRORSTR      = ISNULL(@@T_ERRORSTR,'')+CONVERT(VARCHAR,@@CURRSTRING)+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,ENTDM_ENTPM_PROP_ID),'')+@COLDELIMITER+isnull(ENTDM_CD,'')+@COLDELIMITER+isnull(ENTDM_DESC,'')+@COLDELIMITER+isnull(ENTDM_RMKS,'')+@COLDELIMITER+ENTDM_DATATYPE+@COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
          FROM   ENTPM_DTLS_MSTR_MAK  WITH (NOLOCK)
          WHERE  ENTDM_ID          = @@CURRSTRING
          AND    ENTDM_DELETED_IND = 0
          --
          ROLLBACK TRANSACTION
          --
        END
        ELSE
        BEGIN
          --
          UPDATE ENTPM_DTLS_MSTR_MAK  WITH (ROWLOCK)
          SET    ENTDM_DELETED_IND = 1
                ,ENTDM_LST_UPD_BY  = @PA_LOGIN_NAME
                ,ENTDM_LST_UPD_DT  = GETDATE()
          WHERE  ENTDM_ID          = CONVERT(INT,@@CURRSTRING)
          AND    ENTDM_CREATED_BY <> @PA_LOGIN_NAME
          AND    ENTDM_DELETED_IND = 0
          --
          SET @@L_ERROR = @@ERROR
          --
          IF @@L_ERROR > 0
          BEGIN
            --
            SELECT @@T_ERRORSTR    = ISNULL(@@T_ERRORSTR,'')+CONVERT(VARCHAR,@@CURRSTRING)+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,ENTDM_ENTPM_PROP_ID),'')+@COLDELIMITER+isnull(ENTDM_CD,'')+@COLDELIMITER+isnull(ENTDM_DESC,'')+@COLDELIMITER+isnull(ENTDM_RMKS,'')+@COLDELIMITER+ENTDM_DATATYPE+@COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
            FROM  ENTPM_DTLS_MSTR_MAK  WITH (NOLOCK)
            WHERE ENTDM_ID         = CONVERT(INT,@@CURRSTRING)
            AND  ENTDM_DELETED_IND = 0
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

    IF @PA_ACTION = 'REJ'  
    BEGIN
      --
      IF @PA_CHK_YN = 1 -- IF CHEKER IS REJECTING
      BEGIN
        --
        BEGIN TRANSACTION
        --
        UPDATE ENTPM_DTLS_MSTR_MAK  WITH (ROWLOCK)
        SET    ENTDM_DELETED_IND = 3
             , ENTDM_LST_UPD_BY  = @PA_LOGIN_NAME
             , ENTDM_LST_UPD_DT  = GETDATE()
        WHERE  ENTDM_ID          = CONVERT(INT,@@CURRSTRING)
        AND    ENTDM_DELETED_IND = 0
        --
        SET @@L_ERROR = @@ERROR
        --
        IF @@L_ERROR > 0
        BEGIN
          --
          SELECT @@T_ERRORSTR   = ISNULL(@@T_ERRORSTR,'')+CONVERT(VARCHAR,@@CURRSTRING)+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,ENTDM_ENTPM_PROP_ID),'')+@COLDELIMITER+isnull(ENTDM_CD,'')+@COLDELIMITER+isnull(ENTDM_DESC,'')+@COLDELIMITER+isnull(ENTDM_RMKS,'')+@COLDELIMITER+ENTDM_DATATYPE+@COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
          FROM  ENTPM_DTLS_MSTR_MAK  WITH (NOLOCK)
          WHERE ENTDM_ID        = CONVERT(INT,@@CURRSTRING)
          AND ENTDM_DELETED_IND = 0
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
    END          --ACTION TYPE = REJ ENDS HERE

    IF @PA_ACTION = 'DEL' 
    BEGIN
      --
      BEGIN TRANSACTION
      --
      UPDATE ENTPM_DTLS_MSTR WITH (ROWLOCK)
      SET    ENTDM_DELETED_IND = 0
            ,ENTDM_LST_UPD_BY  = @PA_LOGIN_NAME
            ,ENTDM_LST_UPD_DT  = GETDATE()
      WHERE  ENTDM_ID          = CONVERT(INT,@@CURRSTRING)
      --
      SET @@L_ERROR = @@ERROR
      --
      IF @@L_ERROR > 0     --IF ANY ERROR REPORTS THEN GENERATE THE ERROR STRING
      BEGIN
        --
        SELECT @@T_ERRORSTR    = ISNULL(@@T_ERRORSTR,'')+CONVERT(VARCHAR,@@CURRSTRING)+@COLDELIMITER+ISNULL(CONVERT(VARCHAR,ENTDM_ENTPM_PROP_ID),'')+@COLDELIMITER+isnull(ENTDM_CD,'')+@COLDELIMITER+isnull(ENTDM_DESC,'')+@COLDELIMITER+isnull(ENTDM_RMKS,'')+@COLDELIMITER+ENTDM_DATATYPE+@COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
        FROM  ENTPM_DTLS_MSTR_MAK WITH (NOLOCK)
        WHERE ENTDM_ID         = CONVERT(INT,@@CURRSTRING)
        AND  ENTDM_DELETED_IND = 1
        --
        ROLLBACK  TRANSACTION
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

    IF @PA_ACTION = 'EDT'  --ACTION TYPE = EDT BEGINS HERE
    BEGIN
      --
      IF @PA_CHK_YN = 0 -- IF NO MAKER CHECKER
      BEGIN
        --
        BEGIN TRANSACTION
        --
        UPDATE ENTPM_DTLS_MSTR  WITH (ROWLOCK)
        SET    ENTDM_ENTPM_PROP_ID = @PA_ENTPM_PROP_ID
             , ENTDM_CD            = @PA_ENTDM_CD
             , ENTDM_DESC          = @PA_ENTDM_DESC
             , ENTDM_RMKS          = @PA_ENTDM_RMKS
             , ENTDM_LST_UPD_BY    = @PA_LOGIN_NAME
             , ENTDM_LST_UPD_DT    = GETDATE()
             , ENTDM_DATATYPE      = @PA_ENTDM_DATATYPE 
             , ENTDM_MDTY          = @PA_ENTDM_MDTY
        WHERE  ENTDM_ID            = CONVERT(INT,@@CURRSTRING)
        AND    ENTDM_DELETED_IND   = 1
        --
        SET @@L_ERROR = @@ERROR
        --
        IF @@L_ERROR > 0
        BEGIN
          --
          SET @@T_ERRORSTR = ISNULL(@@T_ERRORSTR,'')+CONVERT(VARCHAR,@@CURRSTRING)+@COLDELIMITER+CONVERT(VARCHAR,@PA_ENTPM_PROP_ID)+@COLDELIMITER+@PA_ENTDM_CD+@COLDELIMITER+@PA_ENTDM_DESC+@COLDELIMITER+ISNULL(@PA_ENTDM_RMKS,'')+@COLDELIMITER+@PA_ENTDM_DATATYPE+@COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
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

      IF @PA_CHK_YN = 1 -- IF MAKER OR CHEKER IS EDITING
      BEGIN
        --
        BEGIN TRANSACTION
        --
        UPDATE ENTPM_DTLS_MSTR_MAK  WITH (ROWLOCK)
        SET    ENTDM_DELETED_IND = 2
             , ENTDM_LST_UPD_BY  = @PA_LOGIN_NAME
             , ENTDM_LST_UPD_DT  = GETDATE()
        WHERE  ENTDM_ID          = CONVERT(INT,@@CURRSTRING)
        AND    ENTDM_DELETED_IND = 0
        --
        SET @@L_ERROR = @@ERROR
        --
        IF @@L_ERROR > 0
        BEGIN
          --
          SET @@T_ERRORSTR = ISNULL(@@T_ERRORSTR,'')+CONVERT(VARCHAR,@@CURRSTRING)+@COLDELIMITER+CONVERT(VARCHAR,@PA_ENTPM_PROP_ID)+@COLDELIMITER+@PA_ENTDM_CD+@COLDELIMITER+@PA_ENTDM_DESC+@COLDELIMITER+ISNULL(@PA_ENTDM_RMKS,'')+@COLDELIMITER+@PA_ENTDM_DATATYPE+@COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
          --
          ROLLBACK TRANSACTION
          --
        END
        ELSE
        BEGIN
          --
          INSERT INTO ENTPM_DTLS_MSTR_MAK
          (ENTDM_ID
          ,ENTDM_ENTPM_PROP_ID
          ,ENTDM_CD
          ,ENTDM_DESC
          ,ENTDM_RMKS
          ,ENTDM_CREATED_BY
          ,ENTDM_CREATED_DT
          ,ENTDM_LST_UPD_BY
          ,ENTDM_LST_UPD_DT
          ,ENTDM_DELETED_IND
          ,ENTDM_DATATYPE
          ,ENTDM_MDTY
          )
          VALUES
          (CONVERT(INT, @@CURRSTRING)
          ,@PA_ENTPM_PROP_ID
          ,@PA_ENTDM_CD
          ,@PA_ENTDM_DESC
          ,@PA_ENTDM_RMKS
          ,@PA_LOGIN_NAME
          ,GETDATE()
          ,@PA_LOGIN_NAME
          ,GETDATE()
          ,0
          ,@PA_ENTDM_DATATYPE
          ,@PA_ENTDM_MDTY
          )
          --
          SET @@L_ERROR = @@ERROR
          --
          IF @@L_ERROR > 0
          BEGIN
          --
            SET @@T_ERRORSTR = ISNULL(@@T_ERRORSTR,'')+CONVERT(VARCHAR,@@CURRSTRING)+@COLDELIMITER+CONVERT(VARCHAR,@PA_ENTPM_PROP_ID)+@COLDELIMITER+@PA_ENTDM_CD+@COLDELIMITER+@PA_ENTDM_DESC+@COLDELIMITER+ISNULL(@PA_ENTDM_RMKS,'')+@COLDELIMITER+@PA_ENTDM_DATATYPE+@COLDELIMITER+CONVERT(VARCHAR, @@L_ERROR)+@ROWDELIMITER
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
  END  --ENDIMG OF THE CURRSTRING
--
END --END OF WHILE
--
SET @PA_ERRMSG = @@T_ERRORSTR
--
END

GO
