-- Object: PROCEDURE citrus_usr.POPULATE_ACCTPM_TABLE
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec POPULATE_ACCTPM_TABLE 'CL'  
--select max(accpm_prop_id) from account_property_mstr
CREATE PROCEDURE [citrus_usr].[POPULATE_ACCTPM_TABLE](@PA_TYPE   VARCHAR(20))  
AS  
BEGIN  
--  
  DECLARE @@C_EXCPM          CURSOR  
        , @@C_ENTTM_CLICM    CURSOR  
        , @@USER             VARCHAR(25)  
        , @@DATE             DATETIME  
        , @@L_ENTPM_ID       NUMERIC  
        , @@L_PROP_ID        NUMERIC  
        , @@L_PROP_CD        VARCHAR(20)  
        , @@L_PROP_DESC      VARCHAR(50)  
        , @@L_ENTPM_CLI_YN   SMALLINT  
        , @@L_ENTDM_CD       VARCHAR(25)  
        , @@L_ENTDM_DESC     VARCHAR(50)  
        , @@L_TYPE           NUMERIC  
        , @@I                SMALLINT  
        , @@C_EXCPM_ID       NUMERIC  
        , @@C_CLICM_ID       NUMERIC  
        , @@C_ENTTM_ID       NUMERIC  
        , @@SEQ              NUMERIC  
        , @@DATA_TYPE  CHAR(1)  
  --  
  SET @@USER             = 'USER'  
  SET @@DATE             = GETDATE()  
  SET @@L_ENTPM_ID       = 0  
  SET @@L_PROP_ID        = 0  
  SET @@L_ENTPM_CLI_YN   = 0  
  SET @@L_TYPE           = 0  
  --  
  IF @PA_TYPE = 'CL'  
  BEGIN  
  --  
    SET @@L_TYPE         = 0  
    SET @@L_ENTPM_CLI_YN = 2
  --  
  END  
  ELSE  
  BEGIN  
  --  
    SET @@L_TYPE         = 1  
    SET @@L_ENTPM_CLI_YN = 0  
  --  
  END  
  --  
  SET @@C_EXCPM =  CURSOR FAST_FORWARD FOR  
  SELECT EXCPM.EXCPM_ID EXCPM_ID  
  FROM EXCSM_PROD_MSTR EXCPM WITH (NOLOCK)  
  WHERE EXCPM.EXCPM_DELETED_IND = 1  
  --  
  OPEN @@C_EXCPM  
  FETCH NEXT FROM @@C_EXCPM INTO @@C_EXCPM_ID  
  --  
  WHILE @@FETCH_STATUS = 0  
  BEGIN--#C1  
  --  
    IF @@L_TYPE = 0  
    BEGIN--TYPE=0  
    --  
       SET @@C_ENTTM_CLICM            = CURSOR FAST_FORWARD FOR  
       SELECT CLICM.CLICM_ID            CLICM_ID  
            , ENTTM.ENTTM_ID            ENTTM_ID  
       FROM   CLIENT_CTGRY_MSTR         CLICM  WITH (NOLOCK)  
            , ENTITY_TYPE_MSTR          ENTTM  WITH (NOLOCK)  
            , ENTTM_CLICM_MAPPING       ENTCM  WITH (NOLOCK)  
       WHERE  CLICM.CLICM_ID          = ENTCM.ENTCM_CLICM_ID  
       AND    ENTTM.ENTTM_ID          = ENTCM.ENTCM_ENTTM_ID  
       AND    CLICM.CLICM_DELETED_IND = 1  
       AND    ENTTM.ENTTM_DELETED_IND = 1  
       AND    ENTCM.ENTCM_DELETED_IND = 1  
       AND    ENTTM.ENTTM_CLI_YN      = 2
       --  
       OPEN @@C_ENTTM_CLICM  
       FETCH NEXT FROM @@C_ENTTM_CLICM INTO @@C_CLICM_ID, @@C_ENTTM_ID  
       --  
       WHILE @@FETCH_STATUS = 0  
       BEGIN--#C2  
       --  
         SET @@I  = 1  
         --  
         WHILE @@I <= 2  
         BEGIN--I<=9  
         --  
           IF @@I = 1  
           BEGIN  
           --  
             SET @@L_PROP_ID   = 31  
             SET @@L_PROP_CD   = 'CMBP_ID'  
             SET @@L_PROP_DESC = 'CMBPID'  
             SET @@DATA_TYPE   = 'S'   
           --  
           END  
           ELSE IF @@I = 2  
           BEGIN  
           --  
             SET @@L_PROP_ID   = 32 
             SET @@L_PROP_CD   = 'CMBPEXCH';  
             SET @@L_PROP_DESC = 'POOL A/C FOR EXCHANGE';  
             SET @@DATA_TYPE   = 'L'   
           --  
           END  
           
           --  
           SELECT @@SEQ = ISNULL(MAX(ACCPM_ID),0)+ 1  
           FROM  ACCOUNT_PROPERTY_MSTR WITH (NOLOCK)  
           --  
           INSERT INTO ACCOUNT_PROPERTY_MSTR  
           ( ACCPM_ID  
           , ACCPM_PROP_ID  
           , ACCPM_CLICM_ID  
           , ACCPM_ENTTM_ID  
           , ACCPM_EXCPM_ID  
           , ACCPM_PROP_CD  
           , ACCPM_PROP_DESC  
           , ACCPM_MDTY  
           , ACCPM_ACCT_TYPE  
           , ACCPM_DATATYPE  
           , ACCPM_CREATED_BY  
           , ACCPM_CREATED_DT  
           , ACCPM_LST_UPD_BY  
           , ACCPM_LST_UPD_DT  
           , ACCPM_DELETED_IND  
           )  
           VALUES  
           ( @@SEQ  
           , @@l_prop_id  
           , @@C_clicm_id  
           , @@C_enttm_id  
           , @@C_excpm_id  
           , @@l_prop_cd  
           , @@l_prop_desc  
           , 0  
           , 'DP'  
           , @@DATA_TYPE  
           , USER  
           , GETDATE()  
           , USER  
           , GETDATE()  
           , 1  
           )  
           --  
           --PRINT CONVERT(VARCHAR, @@l_prop_id) + '----' + CONVERT(VARCHAR,@@C_clicm_id) + '----' + CONVERT(VARCHAR,@@C_enttm_id)  + '----' + CONVERT(VARCHAR,@@C_excpm_id) + '----' + CONVERT(VARCHAR,@@l_prop_cd) + '----' + CONVERT(VARCHAR,@@l_prop_desc) + '----' + CONVERT(VARCHAR,@@l_entpm_cli_yn) + '----0----' +  @@l_prop_desc + '----' + USER + '---- GETDATE()----' + USER + '----GETDATE----1'  
           --  
           SET @@I           = @@I + 1  
           SET @@L_PROP_ID   = NULL  
           SET @@L_PROP_CD   = NULL  
           SET @@L_PROP_DESC = NULL  
           SET @@DATA_TYPE   = NULL  
         --  
         END--I<=9  
         --  
         FETCH NEXT FROM @@C_ENTTM_CLICM INTO @@C_CLICM_ID, @@C_ENTTM_ID  
       --  
       END--#C2  
       CLOSE @@C_ENTTM_CLICM  
       DEALLOCATE @@C_ENTTM_CLICM  
    --  
    END--TYPE=0  
    ELSE IF @@L_TYPE = 1  
    BEGIN--TYPE=1  
    --  
      SET @@C_ENTTM_CLICM =  CURSOR FAST_FORWARD FOR  
      SELECT CLICM.CLICM_ID            CLICM_ID  
           , ENTTM.ENTTM_ID            ENTTM_ID  
      FROM   CLIENT_CTGRY_MSTR         CLICM  WITH (NOLOCK)  
           , ENTITY_TYPE_MSTR          ENTTM  WITH (NOLOCK)  
           , ENTTM_CLICM_MAPPING       ENTCM  WITH (NOLOCK)  
      WHERE  CLICM.CLICM_ID          = ENTCM.ENTCM_CLICM_ID  
      AND    ENTTM.ENTTM_ID          = ENTCM.ENTCM_ENTTM_ID  
      AND    CLICM.CLICM_DELETED_IND = 1  
      AND    ENTTM.ENTTM_DELETED_IND = 1  
      AND    ENTCM.ENTCM_DELETED_IND = 1  
      AND    ENTTM.ENTTM_CLI_YN      = CONVERT(NUMERIC, @@L_TYPE)  
      --  
      OPEN @@C_ENTTM_CLICM  
      FETCH NEXT FROM @@C_ENTTM_CLICM INTO @@C_CLICM_ID, @@C_ENTTM_ID  
      --  
      WHILE @@FETCH_STATUS = 0  
      BEGIN--#C2  
      --  
        SET @@I  = 1  
        --  
        WHILE @@I <= 4  
        BEGIN--I<=4  
        --  
          IF @@I = 1  
          BEGIN  
          --  
            SET @@L_PROP_ID      = 10  
            SET @@L_PROP_CD      = 'MEMBER_CD'  
            SET @@L_PROP_DESC    = 'MEMBER CODE OF COMPANY'  
            SET @@L_ENTPM_CLI_YN = 0  
          --  
          END  
          ELSE IF @@I = 2  
          BEGIN  
          --  
            SET @@L_PROP_ID      = 11  
            SET @@L_PROP_CD      = 'MEMBER_TYPE'  
            SET @@L_PROP_DESC    = 'MEMBER TYPE OF COMPANY'  
            SET @@L_ENTPM_CLI_YN = 0  
          --  
          END  
          ELSE IF @@I = 3  
          BEGIN  
          --  
            SET @@L_PROP_ID   = 12  
            SET @@L_PROP_CD   = 'CL_MEMBER_NAME'  
            SET @@L_PROP_DESC = 'NAME OF THE COMPANY''S CLEARING MEMBER'  
          --  
          END  
          ELSE IF @@I = 4  
          BEGIN  
          --  
            SET @@L_PROP_ID   = 13  
            SET @@L_PROP_CD   = 'COMPANY_REGNO'  
            SET @@L_PROP_DESC = 'COMPANY''S REGISTRATION NUMBER'  
          --  
          END  
          --  
          --PRINT CONVERT(VARCHAR, @@l_prop_id) + '----' + CONVERT(VARCHAR,@@C_clicm_id) + '----' + CONVERT(VARCHAR,@@C_enttm_id)  + '----' + CONVERT(VARCHAR,@@C_excpm_id) + '----' + CONVERT(VARCHAR,@@l_prop_cd) + '----' + CONVERT(VARCHAR,@@l_prop_desc) + '----' + CONVERT(VARCHAR,@@l_entpm_cli_yn) + '----0----' +  @@l_prop_desc + '----' + USER + '---- GETDATE()----' + USER + '----GETDATE----1'  
          --  
          SELECT @@SEQ = ISNULL(MAX(entpm_id),0)+ 1  
          FROM  entity_property_mstr WITH (NOLOCK)  
  
          INSERT INTO entity_property_mstr  
          ( entpm_id  
          , entpm_prop_id  
          , entpm_clicm_id  
          , entpm_enttm_id  
          , entpm_excpm_id  
          , entpm_cd  
          , entpm_desc  
          , entpm_cli_yn  
          , entpm_mdty  
          , entpm_rmks  
          , entpm_created_by  
          , entpm_created_dt  
          , entpm_lst_upd_by  
          , entpm_lst_upd_dt  
          , entpm_deleted_ind  
          )  
          VALUES  
          (@@SEQ  
          ,@@l_prop_id  
          ,@@C_clicm_id  
          ,@@C_enttm_id  
          ,@@C_excpm_id  
          ,@@l_prop_cd  
          ,@@l_prop_desc  
          ,@@l_entpm_cli_yn  
          ,0  
          ,@@l_prop_desc  
          ,USER  
          ,GETDATE()  
          ,USER  
          ,GETDATE()  
          ,1  
          )  
          --  
          SET @@I           = @@I + 1  
          SET @@L_PROP_ID   = NULL  
          SET @@L_PROP_CD   = NULL  
          SET @@L_PROP_DESC = NULL  
        --  
        END--I<=4  
        --  
        FETCH NEXT FROM @@C_ENTTM_CLICM  INTO @@C_CLICM_ID, @@C_ENTTM_ID  
      --  
      END--#C2  
      --  
      CLOSE @@C_ENTTM_CLICM  
      DEALLOCATE @@C_ENTTM_CLICM  
    --  
    END--TYPE=1  
    --  
    FETCH NEXT FROM @@C_EXCPM INTO @@C_EXCPM_ID  
  --  
  END--#C1  
  --  
  CLOSE @@C_EXCPM  
  DEALLOCATE @@C_EXCPM  
--  
END

GO
