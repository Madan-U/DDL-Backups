-- Object: PROCEDURE citrus_usr.POPULATE_ACCTDM_TABLE
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--EXEC POPULATE_ENTDM_TABLE
CREATE PROCEDURE [citrus_usr].[POPULATE_ACCTDM_TABLE]
AS
BEGIN
--
  DECLARE @@L_COUNTER        NUMERIC
         ,@@L_DEBUG          VARCHAR(5)
         ,@@L_ENTDM_CD     VARCHAR(25)
         ,@@L_ENTDM_DESC     VARCHAR(50)
         ,@@L_ENTDM_RMKS     VARCHAR(250)
         ,@@C_ENTPM          CURSOR
         ,@@C_ENTPM_CD       VARCHAR(25)
         ,@@SEQ              NUMERIC
         ,@@C_ENTPM_PROP_ID  NUMERIC
         ,@@I                NUMERIC
         ,@@l_accdm_datatype CHAR(2)
  --
  SET @@C_ENTPM =  CURSOR FAST_FORWARD FOR
  /*SELECT DISTINCT ENTPM.ENTPM_PROP_ID ENTPM_PROP_ID
       , ENTPM.ENTPM_CD            ENTPM_CD
  FROM   ENTITY_PROPERTY_MSTR      ENTPM WITH(NOLOCK)
  WHERE  ENTPM.ENTPM_DELETED_IND = 1*/
  --
  SELECT DISTINCT accpm.accpm_prop_id   accpm_prop_id
       , accpm.accpm_prop_cd            accpm_prop_cd
  FROM   account_property_mstr          accpm
  WHERE  accpm.accpm_deleted_ind      = 1
  --
  OPEN @@C_ENTPM
  FETCH NEXT FROM @@C_ENTPM INTO @@C_ENTPM_PROP_ID, @@C_ENTPM_CD
  --
  WHILE @@FETCH_STATUS = 0
  BEGIN--#C1
  --
    SET @@L_COUNTER = 1
    SET @@I         = 1
    --
    IF @@C_ENTPM_CD = 'SH DTLS' 
    BEGIN
    --
      SET @@L_COUNTER = 5
    --  
    END
    ELSE IF @@C_ENTPM_CD = 'TH DTLS' 
    BEGIN
    --
      SET @@L_COUNTER = 5
    -- 
    END
    ELSE IF @@C_ENTPM_CD = 'NOMINATION DETAILS' 
    BEGIN
    --
      SET @@L_COUNTER = 6
    -- 
    END
    /*IF @@C_ENTPM_CD = 'PAN_GIR_NO'
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
    END*/
    --
    WHILE @@I <= @@L_COUNTER
    BEGIN--@@L_COUNTER
    -----
      IF @@C_ENTPM_CD = 'SH DTLS' 
      BEGIN
      --
        IF @@I = 1 
        BEGIN
        --
         SET  @@L_ENTDM_CD       = 'STATUS'
         SET  @@L_ENTDM_DESC     = 'STATUS OF THE ENTITY'
         SET  @@l_accdm_datatype = 'S'
        --
        END
        ELSE IF @@I = 2
        BEGIN
        --
          SET @@L_ENTDM_CD       = 'DATE OF BIRTH'
          SET @@L_ENTDM_DESC     = 'DATE OF BIRTH OF THE ENTITY'
          SET @@l_accdm_datatype = 'D'
        --
        END
        ELSE IF @@I = 3 
        BEGIN
        --
          SET @@L_ENTDM_CD       = 'MINOR_YN'
          SET @@L_ENTDM_DESC     = 'IS HE/SHE A MINOR'
          SET @@l_accdm_datatype = 'B'
        --
        END
        ELSE IF @@I = 4 
        BEGIN
        --
          SET @@L_ENTDM_CD       = 'GAURDIAN'
          SET @@L_ENTDM_DESC     = 'NAME OF GAURDIAN'
          SET @@l_accdm_datatype = 'S'
        --
        END
        ELSE IF @@I = 5 
        BEGIN
        --
          SET  @@L_ENTDM_CD       = 'PAN NUMBER'
          SET @@L_ENTDM_DESC     = 'PAN NUMBER OF THE ENTITY'
          SET  @@l_accdm_datatype = 'S'
        --
        END
      --
      END--
      --
      ELSE IF @@C_ENTPM_CD = 'TH DTLS' 
      BEGIN
      --
        IF @@I = 1 
        BEGIN
        --
          SET @@L_ENTDM_CD       = 'STATUS'
          SET @@L_ENTDM_DESC     = 'STATUS OF THE ENTITY'
          SET @@l_accdm_datatype = 'S'
        --
        END
        ELSE IF @@I = 2 
        BEGIN
        --
          SET @@L_ENTDM_CD       = 'DATE OF BIRTH'
          SET @@L_ENTDM_DESC     = 'DATE OF BIRTH OF THE ENTITY'
          SET @@l_accdm_datatype = 'D'
        --
        END
        ELSE IF @@I = 3 
        BEGIN
        --
          SET @@L_ENTDM_CD       = 'MINOR_YN'
          SET @@L_ENTDM_DESC     = 'IS HE/SHE A MINOR'
          SET @@l_accdm_datatype = 'S'
        --
        END
        ELSE IF @@I = 4 
        BEGIN
        --
          SET @@L_ENTDM_CD       = 'GAURDIAN'
          SET @@L_ENTDM_DESC     = 'NAME OF GAURDIAN'
          SET @@l_accdm_datatype = 'S'
        --
        END
        ELSE IF @@I = 5 
        BEGIN
        --
          SET @@L_ENTDM_CD       = 'PAN NUMBER'
          SET @@L_ENTDM_DESC     = 'PAN NUMBER OF THE ENTITY'
          SET @@l_accdm_datatype = 'S'
        --
        END
      --
      END
      --
      ELSE IF @@C_ENTPM_CD   = 'NOMINATION DETAILS' 
      BEGIN
      --
        IF @@I = 1 
        BEGIN
        --
          SET @@L_ENTDM_CD       = 'NAME OF NOMINEE'
          SET @@L_ENTDM_DESC     = 'NAME OF THE NOMINEE'
          SET @@l_accdm_datatype = 'S'
        --
        END
        ELSE IF @@I = 2 
        BEGIN
        --
          SET @@L_ENTDM_CD       = 'MINOR_YN'
          SET @@L_ENTDM_DESC     = 'IS NOMINEE A MINOR'
          SET @@l_accdm_datatype = 'B'
        --
        END
        ELSE IF @@I = 3 
        BEGIN
        --
          SET @@L_ENTDM_CD       = 'NAME OF GAURDIAN'
          SET @@L_ENTDM_DESC     = 'NAME OF GAURDIAN'
         SET  @@l_accdm_datatype = 'S'
        --
        END
        ELSE IF @@I = 4 
        BEGIN
        --
          SET @@L_ENTDM_CD       = 'RELATIONSHIP'
          SET @@L_ENTDM_DESC     = 'RELATIONSHIP WITH THE NOMINEE'
          SET @@l_accdm_datatype = 'S'
        --
        END
        ELSE IF @@I = 5 
        BEGIN
        --
          SET @@L_ENTDM_CD       = 'BROKING ACCT OPENED'
          SET @@L_ENTDM_DESC     = 'BROKING ACCOUNT OPENED?'
          SET @@l_accdm_datatype = 'B'
        --
        END
        ELSE IF @@I = 6 
        BEGIN
        --
          SET @@L_ENTDM_CD       = 'DEMAT ACCT OPENED'
          SET @@L_ENTDM_DESC     = 'DEMAT ACCOUNT OPENED?'
          SET @@l_accdm_datatype = 'B'
         --
        END
      --
      END
      
      /*IF @@C_ENTPM_CD = 'VOTERSID_NO'
      BEGIN--VOTER
      --
        IF @@I = 1
        BEGIN
        --
          SET @@@@L_ENTDM_CD   = 'VOTERSID_ISSUED_AT'
          SET @@L_ENTDM_DESC = 'PLACE WHERE VOTERS ID CARD WAS ISSUED'
          SET @@L_ENTDM_RMKS = 'PLACE WHERE VOTERS ID CARD WAS ISSUED'
        --
        END
        ELSE IF @@I = 2
        BEGIN
        --
          SET @@@@L_ENTDM_CD   = 'VOTERSID_ISSUED_ON'
          SET @@L_ENTDM_DESC = 'DATE ON WHICH VOTERS ID CARD WAS ISSUED'
          SET @@L_ENTDM_RMKS = 'DATE ON WHICH VOTERS ID CARD WAS ISSUED'
        --
        END
      --
      END--VOTER
      ELSE IF @@C_ENTPM_CD = 'PAN_GIR_NO'
      BEGIN--PAN
      --
        SET @@@@L_ENTDM_CD   = 'WARD_NO'
        SET @@L_ENTDM_DESC = 'WARD NUMBER WHERE THE PAN CARD WAS ISSUED'
        SET @@L_ENTDM_RMKS = 'WARD NUMBER WHERE THE PAN CARD WAS ISSUED'
      --
      END--PAN
      ELSE IF @@C_ENTPM_CD = 'SEBI_REGN_NO'
      BEGIN--PAN
      --
        SET @@@@L_ENTDM_CD   = 'WARD_NO'
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
          SET @@@@L_ENTDM_CD   = 'PASSPORT_ISSUED_AT'
          SET @@L_ENTDM_DESC = 'PLACE WHERE PASSPORT WAS ISSUED'
          SET @@L_ENTDM_RMKS = 'PLACE WHERE PASSPORT WAS ISSUED'
        --
        END
        ELSE IF @@I = 2
        BEGIN
        --
          SET @@@@L_ENTDM_CD   = 'PASSPORT_ISSUED_ON'
          SET @@L_ENTDM_DESC = 'DATE ON WHICH PASSPORT WAS ISSUED'
          SET @@L_ENTDM_RMKS = 'DATE ON WHICH PASSPORT WAS ISSUED'
        --
        END
        ELSE IF @@I = 3
        BEGIN
        --
          SET @@@@L_ENTDM_CD   = 'PASSPORT_EXPIRES_ON'
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
           SET @@@@L_ENTDM_CD   = 'LICENCE_ISSUED_AT'
           SET @@L_ENTDM_DESC = 'PLACE WHERE LICENCE WAS ISSUED'
           SET @@L_ENTDM_RMKS = 'PLACE WHERE LICENCE WAS ISSUED'
         --
         END
         ELSE IF @@I = 2
         BEGIN
         --
           SET @@@@L_ENTDM_CD   = 'LICENCE_ISSUED_ON'
           SET @@L_ENTDM_DESC = 'DATE ON WHICH LICENCE WAS ISSUED'
           SET @@L_ENTDM_RMKS = 'DATE ON WHICH LICENCE WAS ISSUED'
         --
         END
         ELSE IF @@I = 3
         BEGIN
         --
           SET @@@@L_ENTDM_CD   = 'LICENCE_EXPIRES_ON'
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
          SET @@@@L_ENTDM_CD   = 'RAT_CARD_ISSUED_AT'
          SET @@L_ENTDM_DESC = 'PLACE WHERE RATION CARD WAS ISSUED'
          SET @@L_ENTDM_RMKS = 'PLACE WHERE RATION CARD WAS ISSUED'
        --
        END
        ELSE IF @@I = 2
        BEGIN
        --
          SET @@@@L_ENTDM_CD   = 'RAT_CARD_ISSUED_ON'
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
          SET @@@@L_ENTDM_CD   = 'REGR_AT'
          SET @@L_ENTDM_DESC = 'PLACE OF REGISTRATION'
          SET @@L_ENTDM_RMKS = 'PLACE OF REGISTRATION'
        --
        END
        ELSE IF @@I = 2
        BEGIN
        --
          SET @@@@L_ENTDM_CD   = 'REGR_ON'
          SET @@L_ENTDM_DESC = 'DATE OF REGISTRATION'
          SET @@L_ENTDM_RMKS = 'DATE OF REGISTRATION'
        --
        END
        ELSE IF @@I = 3
        BEGIN
        --
          SET @@@@L_ENTDM_CD   = 'REGR_AUTHORITY'
          SET @@L_ENTDM_DESC = 'REGISTRATION AUTHORITY'
          SET @@L_ENTDM_RMKS = 'REGISTRATION AUTHORITY'
        --
        END
      --
      END--REGR
      */
      --
      IF @@L_ENTDM_CD IS NOT NULL
      BEGIN
      --
         SELECT @@SEQ = ISNULL(MAX(accdm_id),0)+ 1
         FROM  accpm_dtls_mstr WITH (NOLOCK)
         --
         INSERT INTO accpm_dtls_mstr
         ( accdm_id
         , accdm_accpm_prop_id
         , accdm_cd
         , accdm_desc
         , accdm_rmks
         , accdm_datatype
         , accdm_created_by
         , accdm_created_dt
         , accdm_lst_upd_by
         , accdm_lst_upd_dt
         , accdm_deleted_ind
        )
         VALUES
         ( @@SEQ
         , @@C_ENTPM_PROP_ID
         , @@L_ENTDM_CD
         , @@L_ENTDM_DESC
         , NULL
         , @@l_accdm_datatype
         , USER
         , GETDATE()
         , USER
         , GETDATE()
         , 1
         )
         --PRINT CONVERT(VARCHAR, @@SEQ) + '--' + CONVERT(VARCHAR, @@C_ENTPM_PROP_ID) +'----'+ @@@@L_ENTDM_CD +'----'+ @@L_ENTDM_DESC  +'----'+ @@L_ENTDM_RMKS
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
