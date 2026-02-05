-- Object: PROCEDURE citrus_usr.PR_INS_UPD_CLIBA_NEW
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_INS_UPD_CLIBA_NEW]( @PA_ID                VARCHAR(8000)
                                    , @PA_ACTION            VARCHAR(20)
                                    , @PA_LOGIN_NAME        VARCHAR(20)
                                    , @PA_ENT_ID            NUMERIC
                                    , @PA_VALUES            VARCHAR(8000)
                                    , @PA_CHK_YN            NUMERIC
                                    , @ROWDELIMITER         CHAR(4) =  '*|~*'
                                    , @COLDELIMITER         CHAR(4)  = '|*~|'
                                    , @PA_ERRMSG            VARCHAR(8000) OUTPUT
)
AS
/*
*********************************************************************************
 SYSTEM         : CLASS
 MODULE NAME    : PR_MAK_EXCSM
 DESCRIPTION    : THIS PROCEDURE WILL ADD NEW CLIENT DETAILS VALUES TO  CLIENT_BANK_ACCTS
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE         REASON
 -----  -------------     ----------   -------------------------------------------------
 2.0    SUKHVINDER/TUSHAR 04-OCT-2006  INITIAL VERSION.
-----------------------------------------------------------------------------------*/
--
-- VARIABLES TO BE DECLARED HERE
--
BEGIN
  --
  SET NOCOUNT ON
  DECLARE @@T_ERRORSTR       VARCHAR(8000),
          @L_CMCONCM_ID      BIGINT,
          @L_CONCM_ID        BIGINT,
          @@L_ERROR          BIGINT,
          @DELIMETER         VARCHAR(10),
          @@REMAININGSTRING  VARCHAR(8000),
          @@CURRSTRING       VARCHAR(8000),
          @@REMAININGSTRING2 VARCHAR(8000),
          @@CURRSTRING2      VARCHAR(8000),
          @@FOUNDAT          INTEGER,
          @@DELIMETERLENGTH  INT,
          @L_COUNTER         INT,
          @@L_CLISBA_ID      NUMERIC,
          @@L_CLISBA_ACCT_NO VARCHAR(20),
          @@L_COMPM_ID       INTEGER,
          @@L_EXCSM_ID       INTEGER,
          @@L_CLIBA_ACCT_NO  VARCHAR(20),
          @@L_CLIBA_AC_NAME  VARCHAR(20),
          @@L_CLIBA_BANM_ID  NUMERIC,
          @@L_CLIBA_AC_TYPE  VARCHAR(20),
          @@L_CLIBA_AC_NO    VARCHAR(20),
          @@L_CLIBA_FLG      INT,
          @@L_BITRM_BIT_LOCATION INT,
          @L_CLIBA_AC_TYPE   VARCHAR(20),
          @L_CLIBA_AC_NAME   VARCHAR(20),
          @L_CLIBA_FLG       INT,
          @L_FLG             INT
          --
SET @L_FLG = 0
--
DECLARE @L_RECORDSET TABLE (CLIBA_CLISBA_ID   NUMERIC
                           ,CLIBA_BANM_ID     NUMERIC
                           ,CLIBA_COMPM_ID    NUMERIC
                           ,CLIBA_AC_NO       VARCHAR(20)
                           ,CLIBA_AC_TYPE     VARCHAR(20)
                           ,CLIBA_AC_NAME     VARCHAR(20)
                           ,CLIBA_FLG         INTEGER
                           )
--
IF @PA_ID <> '' AND @PA_ACTION <> '' AND @PA_LOGIN_NAME <> ''
--
BEGIN
--
  SET @L_COUNTER = 1
  SET @@L_ERROR = 0
  SET @@T_ERRORSTR=''
  SET @DELIMETER = '%'+ @ROWDELIMITER + '%'
  SET @@DELIMETERLENGTH = LEN(@ROWDELIMITER)
  SET @@REMAININGSTRING2 = @PA_ID
  --
  WHILE @@REMAININGSTRING2 <> ''
  BEGIN
  --
    SET @@FOUNDAT = 0
    SET @@FOUNDAT =  PATINDEX('%'+@DELIMETER+'%',@@REMAININGSTRING2)
  --
    IF @@FOUNDAT > 0
    BEGIN
    --
      SET @@CURRSTRING2      = SUBSTRING(@@REMAININGSTRING2, 0,@@FOUNDAT)
      SET @@REMAININGSTRING2 = SUBSTRING(@@REMAININGSTRING2, @@FOUNDAT+@@DELIMETERLENGTH,LEN(@@REMAININGSTRING2)- @@FOUNDAT+@@DELIMETERLENGTH)
    --
    END
    ELSE
    BEGIN
    --
      SET @@CURRSTRING2 = @@REMAININGSTRING2
      SET @@REMAININGSTRING2 = ''
    --
    END
    --
    IF @@CURRSTRING2 <> ''
    BEGIN
    --
      SET @DELIMETER = '%'+ @ROWDELIMITER + '%'
      SET @@DELIMETERLENGTH = LEN(@ROWDELIMITER)
    --
      SET @@REMAININGSTRING = @PA_VALUES
      --
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
          SET @@L_CLISBA_ACCT_NO = citrus_usr.FN_SPLITVAL(@@CURRSTRING,1)
          SET @@L_COMPM_ID       = citrus_usr.FN_SPLITVAL(@@CURRSTRING,2)
          SET @@L_EXCSM_ID       = citrus_usr.FN_SPLITVAL(@@CURRSTRING,3)
          SET @@L_CLIBA_ACCT_NO  = citrus_usr.FN_SPLITVAL(@@CURRSTRING,4)
          SET @@L_CLIBA_AC_NAME  = citrus_usr.FN_SPLITVAL(@@CURRSTRING,5)
          SET @@L_CLIBA_BANM_ID  = citrus_usr.FN_SPLITVAL(@@CURRSTRING,6)
          SET @@L_CLIBA_AC_TYPE  = citrus_usr.FN_SPLITVAL(@@CURRSTRING,7)
          SET @@L_CLIBA_AC_NO    = citrus_usr.FN_SPLITVAL(@@CURRSTRING,8)
          SET @@L_CLIBA_FLG      = citrus_usr.FN_SPLITVAL(@@CURRSTRING,9)
          --
          SELECT @@L_CLISBA_ID = CLISBA.CLISBA_ID
          FROM   CLIENT_SUB_ACCTS  CLISBA
          WHERE  CLISBA.CLISBA_CRN_NO      = @PA_ENT_ID
          AND    CLISBA.CLISBA_ACCT_NO     = @@L_CLIBA_ACCT_NO
          AND    CLISBA.CLISBA_NO          = @@L_CLISBA_ACCT_NO
          AND    CLISBA.CLISBA_DELETED_IND = 1
          --
          INSERT INTO @L_RECORDSET(CLIBA_CLISBA_ID
                                  ,CLIBA_BANM_ID
                                  ,CLIBA_COMPM_ID
                                  ,CLIBA_AC_NO
                                  ,CLIBA_AC_TYPE
                                  ,CLIBA_AC_NAME
                                  ,CLIBA_FLG
                                  )
          SELECT CLIBA_CLISBA_ID
                ,CLIBA_BANM_ID
                ,CLIBA_COMPM_ID
                ,CLIBA_AC_NO
                ,CLIBA_AC_TYPE
                ,CLIBA_AC_NAME
                ,CLIBA_FLG
          FROM  CLIENT_BANK_ACCTS
          WHERE CLIBA_CLISBA_ID = @@L_CLISBA_ID
          --
          IF @PA_ACTION = 'INS'
          BEGIN
          --
             IF @PA_CHK_YN = 0
             BEGIN
             --
                IF @@L_CLIBA_FLG = 1
                BEGIN --#01
                --
                  SELECT @@L_BITRM_BIT_LOCATION = BITRM_BIT_LOCATION
                  FROM BITMAP_REF_MSTR
                  WHERE BITRM_PARENT_CD = 'BANK'
                  AND BITRM_CHILD_CD = 'DEF_FLG'
                  --
                  SET  @@L_CLIBA_FLG= POWER(2,@@L_BITRM_BIT_LOCATION-1) | @@L_CLIBA_FLG
                  --
                  INSERT INTO CLIENT_BANK_ACCTS
                  (CLIBA_BANM_ID
                  ,CLIBA_CLISBA_ID
                  ,CLIBA_COMPM_ID
                  ,CLIBA_AC_NO
                  ,CLIBA_AC_TYPE
                  ,CLIBA_AC_NAME
                  ,CLIBA_FLG
                  ,CLIBA_CREATED_BY
                  ,CLIBA_CREATED_DT
                  ,CLIBA_LST_UPD_BY
                  ,CLIBA_LST_UPD_DT
                  ,CLIBA_DELETED_IND
                  )
                  VALUES
                  (@@L_CLIBA_BANM_ID
                  ,@@L_CLISBA_ID
                  ,@@L_COMPM_ID
                  ,@@L_CLIBA_AC_NO
                  ,@@L_CLIBA_AC_TYPE
                  ,@@L_CLIBA_AC_NAME
                  ,@@L_CLIBA_FLG
                  ,@PA_LOGIN_NAME
                  ,GETDATE()
                  ,@PA_LOGIN_NAME
                  ,GETDATE()
                  ,1
                  )
                --
                END --#01
             --
             END
            --
          END  --END OF INSERT

          IF @PA_ACTION = 'EDT'
          BEGIN
          --
            IF @PA_CHK_YN = 0
            BEGIN
            --
              IF EXISTS(SELECT CLIBA_AC_TYPE
                              , CLIBA_AC_NAME
                              , CLIBA_FLG
                        FROM   @L_RECORDSET
                        WHERE  CLIBA_BANM_ID   = @@L_CLIBA_BANM_ID
                        AND    CLIBA_COMPM_ID  = @@L_COMPM_ID
                        AND    CLIBA_CLISBA_ID = @@L_CLISBA_ID
                        AND    CLIBA_AC_NO     = @@L_CLIBA_AC_NO)
              BEGIN
              --
                 SELECT @L_CLIBA_AC_TYPE=CLIBA_AC_TYPE
                       ,@L_CLIBA_AC_NAME=CLIBA_AC_NAME
                       ,@L_CLIBA_FLG =CLIBA_FLG
                 FROM   @L_RECORDSET
                 WHERE  CLIBA_BANM_ID = @@L_CLIBA_BANM_ID
                 AND    CLIBA_COMPM_ID = @@L_COMPM_ID
                 AND    CLIBA_CLISBA_ID = @@L_CLISBA_ID
                 AND    CLIBA_AC_NO = @@L_CLIBA_AC_NO
                 --
                 IF (@@L_CLIBA_AC_TYPE = @L_CLIBA_AC_TYPE) AND (@@L_CLIBA_AC_NAME=@L_CLIBA_AC_NAME) AND (@@L_CLIBA_FLG=@L_CLIBA_FLG)
                 BEGIN --#02
                 --
                   DELETE FROM @L_RECORDSET
                   WHERE  CLIBA_AC_NO = @@L_CLIBA_AC_NO
                 --
                 END
                 ELSE
                 BEGIN
                 --
                   IF @@L_CLIBA_FLG=1 AND @L_CLIBA_FLG = 0
                   BEGIN
                   --
                     SET @L_FLG = 1 | @L_FLG
                   --
                   END
                   --
                   IF @@L_CLIBA_FLG = 0 AND @L_CLIBA_FLG = 1
                   BEGIN
                   --
                     SET @L_FLG = 1 | @L_FLG
                   --
                   END
                   --
                   UPDATE CLIENT_BANK_ACCTS
                   SET    CLIBA_AC_TYPE  = @@L_CLIBA_AC_TYPE
                          ,CLIBA_AC_NAME = @@L_CLIBA_AC_NAME
                          ,CLIBA_FLG     = @L_FLG
                          ,CLIBA_LST_UPD_BY  = @PA_LOGIN_NAME
                          ,CLIBA_LST_UPD_DT  = GETDATE()
                   WHERE  CLIBA_BANM_ID     = @@L_CLIBA_BANM_ID
                   AND    CLIBA_CLISBA_ID   = @@L_CLISBA_ID
                   AND    CLIBA_COMPM_ID    = @@L_COMPM_ID
                   AND    CLIBA_AC_NO       = @@L_CLIBA_AC_NO
                   AND    CLIBA_DELETED_IND = 1;
                   --
                   DELETE FROM @L_RECORDSET
                   WHERE  CLIBA_AC_NO = @@L_CLIBA_AC_NO
                 --
                 END --#02
              --
              END --END OF EXIST
              ELSE
              BEGIN
                IF @@L_CLIBA_FLG = 1
                BEGIN
                --
                   SELECT @@L_BITRM_BIT_LOCATION =BITRM_BIT_LOCATION
                   FROM BITMAP_REF_MSTR
                   WHERE BITRM_PARENT_CD = 'BANK'
                   AND BITRM_CHILD_CD = 'DEF_FLG'
                   --
                   SET  @@L_CLIBA_FLG= POWER(2,@@L_BITRM_BIT_LOCATION-1) | @@L_CLIBA_FLG
                   --
                   INSERT INTO CLIENT_BANK_ACCTS
                   (CLIBA_BANM_ID
                   ,CLIBA_CLISBA_ID
                   ,CLIBA_COMPM_ID
                   ,CLIBA_AC_NO
                   ,CLIBA_AC_TYPE
                   ,CLIBA_AC_NAME
                   ,CLIBA_FLG
                   ,CLIBA_CREATED_BY
                   ,CLIBA_CREATED_DT
                   ,CLIBA_LST_UPD_BY
                   ,CLIBA_LST_UPD_DT
                   ,CLIBA_DELETED_IND
                   )
                   VALUES
                   (@@L_CLIBA_BANM_ID
                   ,@@L_CLISBA_ID
                   ,@@L_COMPM_ID
                   ,@@L_CLIBA_AC_NO
                   ,@@L_CLIBA_AC_TYPE
                   ,@@L_CLIBA_AC_NAME
                   ,@@L_CLIBA_FLG
                   ,@PA_LOGIN_NAME
                   ,GETDATE()
                   ,@PA_LOGIN_NAME
                   ,GETDATE()
                   ,1
                   )
                --
                END --END OF FLG = 1
              --
            END --END OF NOT EXIST
            --
           END --END OF@PA_CHK_YN = 0
          --
          END  --END OF EDIT
        --
        END    --END OF CURRSTRING
        --
      END  --END OF WHILE

      IF @PA_ACTION='EDT'
      BEGIN
      --
         DELETE FROM CLIENT_BANK_ACCTS
         WHERE CLIBA_AC_NO  IN (SELECT CLIBA_AC_NO FROM @L_RECORDSET)
         AND CLIBA_DELETED_IND=1
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

GO
