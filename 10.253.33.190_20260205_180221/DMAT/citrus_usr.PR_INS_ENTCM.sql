-- Object: PROCEDURE citrus_usr.PR_INS_ENTCM
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--EXEC PR_INS_ENTCM ''
CREATE PROCEDURE [citrus_usr].[PR_INS_ENTCM](@PA_TYPE   VARCHAR(20))
AS
BEGIN
--
  DECLARE @@C_ENTTM   CURSOR
        , @@C_CLICM    CURSOR
        , @@C_CLICM_ID  NUMERIC
        , @@L_CLICM_ID  NUMERIC
        , @@C_ENTTM_ID  NUMERIC
        , @@C_ENTTM_CD  VARCHAR(25)
        , @@C_CLICM_CD  VARCHAR(25)
  --
  SET @@C_ENTTM =  CURSOR FAST_FORWARD FOR
  SELECT ENTTM_ID
       , ENTTM_CD
  FROM   ENTITY_TYPE_MSTR
  WHERE  ENTTM_DELETED_IND = 1
  --
  SET @@L_CLICM_ID = 0
  --
  OPEN @@C_ENTTM
  FETCH NEXT FROM @@C_ENTTM INTO @@C_ENTTM_ID, @@C_ENTTM_CD
  --
  WHILE @@FETCH_STATUS = 0
  BEGIN--#C1
  --
   -- IF @@C_ENTTM_CD = 'CL'
   -- BEGIN --11
    --
      SET @@C_CLICM =  CURSOR FAST_FORWARD FOR
      SELECT CLICM_ID
           , CLICM_CD
      FROM   CLIENT_CTGRY_MSTR WITH(NOLOCK)
      WHERE  CLICM_DELETED_IND = 1
      --
      OPEN @@C_CLICM
      FETCH NEXT FROM @@C_CLICM INTO @@C_CLICM_ID, @@C_CLICM_CD
      WHILE @@FETCH_STATUS = 0
      BEGIN--#C2
      --
        INSERT INTO ENTTM_CLICM_MAPPING
        ( ENTCM_ENTTM_ID
        , ENTCM_CLICM_ID
        , ENTCM_CREATED_BY
        , ENTCM_CREATED_DT
        , ENTCM_LST_UPD_BY
        , ENTCM_LST_UPD_DT
        , ENTCM_DELETED_IND
        )
        VALUES
        ( @@C_ENTTM_ID
        , @@C_CLICM_ID
        , USER, GETDATE(), USER, GETDATE(), 1
        )
        --PRINT CONVERT(VARCHAR, @@C_ENTTM_ID) + '---' + CONVERT(VARCHAR,@@C_CLICM_ID)
        --
        FETCH NEXT FROM @@C_CLICM INTO @@C_CLICM_ID, @@C_CLICM_CD
      --
      END --#C2
      CLOSE @@C_CLICM
      DEALLOCATE @@C_CLICM
    --
    /*END --11
    ELSE
    BEGIN --22
    --
      SELECT @@L_CLICM_ID      = CLICM_ID
      FROM   CLIENT_CTGRY_MSTR   WITH(NOLOCK)
      WHERE  CLICM_CD          = 'NOR'
      AND    CLICM_DELETED_IND = 1
      --
      INSERT INTO ENTTM_CLICM_MAPPING
      ( ENTCM_ENTTM_ID
      , ENTCM_CLICM_ID
      , ENTCM_CREATED_BY
      , ENTCM_CREATED_DT
      , ENTCM_LST_UPD_BY
      , ENTCM_LST_UPD_DT
      , ENTCM_DELETED_IND
      )
      VALUES
      ( @@C_ENTTM_ID
      , @@L_CLICM_ID
      , USER, GETDATE(), USER, GETDATE(), 1
      )
    --
    END  --22*/
    --
    SET @@L_CLICM_ID = 0
    --
    FETCH NEXT FROM @@C_ENTTM INTO @@C_ENTTM_ID, @@C_ENTTM_CD
  --
  END  --#C1
  CLOSE @@C_ENTTM
  DEALLOCATE @@C_ENTTM
--
END

GO
