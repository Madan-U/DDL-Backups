-- Object: PROCEDURE citrus_usr.POPULATE_ENTDM_TABLE
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[POPULATE_ENTDM_TABLE]
AS
BEGIN
--
  DECLARE @@L_COUNTER       NUMERIC
         ,@@L_DEBUG         VARCHAR(5)
         ,@@L_ENTDM_CD      VARCHAR(25)
         ,@@L_ENTDM_DESC    VARCHAR(50)
         ,@@L_ENTDM_RMKS    VARCHAR(250)
         ,@@C_ENTPM         CURSOR
         ,@@C_ENTPM_CD      VARCHAR(25)
         ,@@SEQ             NUMERIC
         ,@@C_ENTPM_PROP_ID NUMERIC
         ,@@I               NUMERIC
  --
  SET @@C_ENTPM =  CURSOR FAST_FORWARD FOR
  SELECT DISTINCT ENTPM.ENTPM_PROP_ID ENTPM_PROP_ID
       , ENTPM.ENTPM_CD            ENTPM_CD
  FROM   ENTITY_PROPERTY_MSTR      ENTPM WITH(NOLOCK)
  WHERE  ENTPM.ENTPM_DELETED_IND = 1
  --
  OPEN @@C_ENTPM
  FETCH NEXT FROM @@C_ENTPM INTO @@C_ENTPM_PROP_ID, @@C_ENTPM_CD
  --
  WHILE @@FETCH_STATUS = 0
  BEGIN--#C1
  --
    SET @@L_COUNTER = 1
    SET @@I          = 1
    --
    IF @@C_ENTPM_CD = 'PAN_GIR_NO'
    BEGIN
    --
      SET @@L_COUNTER = 1
    --
    END
    ELSE IF @@C_ENTPM_CD = 'SEBI_REGN_NO'
    BEGIN
    --
      SET @@L_COUNTER = 1
    --
    END
    ELSE IF @@C_ENTPM_CD = 'PASSPORT_NO'
    BEGIN
    --
      SET @@L_COUNTER = 3
    --
    END
    ELSE IF @@C_ENTPM_CD = 'LICENCE_NO'
    BEGIN
    --
      SET @@L_COUNTER = 3
    ---
    END
    ELSE IF @@C_ENTPM_CD = 'RAT_CARD_NO'
    BEGIN
    --
      SET @@L_COUNTER = 2
    --
    END
    ELSE IF @@C_ENTPM_CD = 'VOTERSID_NO'
    BEGIN
    --
       SET @@L_COUNTER = 2
    --
    END
    ELSE IF @@C_ENTPM_CD = 'REGR_NO'
    BEGIN
    --
       SET @@L_COUNTER = 3
    --
    END
    --
    WHILE @@I <= @@L_COUNTER
    BEGIN--@@L_COUNTER
    -----
      IF @@C_ENTPM_CD = 'VOTERSID_NO'
      BEGIN--VOTER
      --
        IF @@I = 1
        BEGIN
        --
          SET @@L_ENTDM_CD   = 'VOTERSID_ISSUED_AT'
          SET @@L_ENTDM_DESC = 'PLACE WHERE VOTERS ID CARD WAS ISSUED'
          SET @@L_ENTDM_RMKS = 'PLACE WHERE VOTERS ID CARD WAS ISSUED'
        --
        END
        ELSE IF @@I = 2
        BEGIN
        --
          SET @@L_ENTDM_CD   = 'VOTERSID_ISSUED_ON'
          SET @@L_ENTDM_DESC = 'DATE ON WHICH VOTERS ID CARD WAS ISSUED'
          SET @@L_ENTDM_RMKS = 'DATE ON WHICH VOTERS ID CARD WAS ISSUED'
        --
        END
      --
      END--VOTER
      ELSE IF @@C_ENTPM_CD = 'PAN_GIR_NO'
      BEGIN--PAN
      --
        SET @@L_ENTDM_CD   = 'WARD_NO'
        SET @@L_ENTDM_DESC = 'WARD NUMBER WHERE THE PAN CARD WAS ISSUED'
        SET @@L_ENTDM_RMKS = 'WARD NUMBER WHERE THE PAN CARD WAS ISSUED'
      --
      END--PAN
      ELSE IF @@C_ENTPM_CD = 'SEBI_REGN_NO'
      BEGIN--PAN
      --
        SET @@L_ENTDM_CD   = 'WARD_NO'
        SET @@L_ENTDM_DESC = 'WARD NUMBER WHERE THE SEBI NO WAS ISSUED'
        SET @@L_ENTDM_RMKS = 'WARD NUMBER WHERE THE SEBI NO WAS ISSUED'
      --
      END--PAN
      ELSE IF @@C_ENTPM_CD = 'PASSPORT_NO'
      BEGIN--PASSPORT
      --
        IF @@I = 1
        BEGIN
        --
          SET @@L_ENTDM_CD   = 'PASSPORT_ISSUED_AT'
          SET @@L_ENTDM_DESC = 'PLACE WHERE PASSPORT WAS ISSUED'
          SET @@L_ENTDM_RMKS = 'PLACE WHERE PASSPORT WAS ISSUED'
        --
        END
        ELSE IF @@I = 2
        BEGIN
        --
          SET @@L_ENTDM_CD   = 'PASSPORT_ISSUED_ON'
          SET @@L_ENTDM_DESC = 'DATE ON WHICH PASSPORT WAS ISSUED'
          SET @@L_ENTDM_RMKS = 'DATE ON WHICH PASSPORT WAS ISSUED'
        --
        END
        ELSE IF @@I = 3
        BEGIN
        --
          SET @@L_ENTDM_CD   = 'PASSPORT_EXPIRES_ON'
          SET @@L_ENTDM_DESC = 'DATE ON WHICH PASSPORT EXPIRES'
          SET @@L_ENTDM_RMKS = 'DATE ON WHICH PASSPORT EXPIRES'
        --
        END
      --
      END--PASSPORT
      ELSE IF @@C_ENTPM_CD = 'LICENCE_NO'
      BEGIN--LICENCE
      --
         IF @@I = 1
         BEGIN
         --
           SET @@L_ENTDM_CD   = 'LICENCE_ISSUED_AT'
           SET @@L_ENTDM_DESC = 'PLACE WHERE LICENCE WAS ISSUED'
           SET @@L_ENTDM_RMKS = 'PLACE WHERE LICENCE WAS ISSUED'
         --
         END
         ELSE IF @@I = 2
         BEGIN
         --
           SET @@L_ENTDM_CD   = 'LICENCE_ISSUED_ON'
           SET @@L_ENTDM_DESC = 'DATE ON WHICH LICENCE WAS ISSUED'
           SET @@L_ENTDM_RMKS = 'DATE ON WHICH LICENCE WAS ISSUED'
         --
         END
         ELSE IF @@I = 3
         BEGIN
         --
           SET @@L_ENTDM_CD   = 'LICENCE_EXPIRES_ON'
           SET @@L_ENTDM_DESC = 'DATE ON WHICH LICENCE EXPIRES'
           SET @@L_ENTDM_RMKS = 'DATE ON WHICH LICENCE EXPIRES'
         --
         END
      --
      END--LICENCE
      ELSE IF @@C_ENTPM_CD = 'RAT_CARD_NO'
      BEGIN--RAT
      --
        IF @@I = 1
        BEGIN
        --
          SET @@L_ENTDM_CD   = 'RAT_CARD_ISSUED_AT'
          SET @@L_ENTDM_DESC = 'PLACE WHERE RATION CARD WAS ISSUED'
          SET @@L_ENTDM_RMKS = 'PLACE WHERE RATION CARD WAS ISSUED'
        --
        END
        ELSE IF @@I = 2
        BEGIN
        --
          SET @@L_ENTDM_CD   = 'RAT_CARD_ISSUED_ON'
          SET @@L_ENTDM_DESC = 'DATE ON WHICH RATION CARD WAS ISSUED'
          SET @@L_ENTDM_RMKS = 'DATE ON WHICH RATION CARD WAS ISSUED'
        --
        END
      --
      END--RAT
      ELSE IF @@C_ENTPM_CD = 'REGR_NO'
      BEGIN--REGR
      --
        IF @@I = 1
        BEGIN
        --
          SET @@L_ENTDM_CD   = 'REGR_AT'
          SET @@L_ENTDM_DESC = 'PLACE OF REGISTRATION'
          SET @@L_ENTDM_RMKS = 'PLACE OF REGISTRATION'
        --
        END
        ELSE IF @@I = 2
        BEGIN
        --
          SET @@L_ENTDM_CD   = 'REGR_ON'
          SET @@L_ENTDM_DESC = 'DATE OF REGISTRATION'
          SET @@L_ENTDM_RMKS = 'DATE OF REGISTRATION'
        --
        END
        ELSE IF @@I = 3
        BEGIN
        --
          SET @@L_ENTDM_CD   = 'REGR_AUTHORITY'
          SET @@L_ENTDM_DESC = 'REGISTRATION AUTHORITY'
          SET @@L_ENTDM_RMKS = 'REGISTRATION AUTHORITY'
        --
        END
      --
      END--REGR
      --
      IF @@L_ENTDM_CD IS NOT NULL
      BEGIN
      --
         SELECT @@SEQ = ISNULL(MAX(ENTDM_ID),0)+ 1
         FROM  ENTPM_DTLS_MSTR WITH (NOLOCK)
         --
         INSERT INTO ENTPM_DTLS_MSTR
         ( ENTDM_ID
         , ENTDM_ENTPM_PROP_ID
         , ENTDM_CD
         , ENTDM_DESC
         , ENTDM_RMKS
         , ENTDM_CREATED_BY
         , ENTDM_CREATED_DT
         , ENTDM_LST_UPD_BY
         , ENTDM_LST_UPD_DT
         , ENTDM_DELETED_IND
         , ENTDM_DATATYPE
         )
         VALUES
         ( @@SEQ
         , @@C_ENTPM_PROP_ID
         , @@L_ENTDM_CD
         , @@L_ENTDM_DESC
         , @@L_ENTDM_RMKS
         , USER
         , GETDATE()
         , USER
         , GETDATE()
         , 1
         ,'S'
         )
         --PRINT CONVERT(VARCHAR, @@SEQ) + '--' + CONVERT(VARCHAR, @@C_ENTPM_PROP_ID) +'----'+ @@L_ENTDM_CD +'----'+ @@L_ENTDM_DESC  +'----'+ @@L_ENTDM_RMKS
     --
     END
    --
    SET @@I = @@I + 1
    --
    END--@@L_COUNTER
    --
    FETCH NEXT FROM @@C_ENTPM INTO @@C_ENTPM_PROP_ID, @@C_ENTPM_CD
  --
  END
  CLOSE @@C_ENTPM
  DEALLOCATE @@C_ENTPM
--
END

GO
