-- Object: PROCEDURE citrus_usr.POPULATE_ENTPM_TABLE
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--select * from property_bak
--select * from ac_property_bak
--delete from entity_property_mstr
--delete from account_property_mstr
--exec POPULATE_ENTPM_TABLE ''  
CREATE PROCEDURE [citrus_usr].[POPULATE_ENTPM_TABLE](@PA_TYPE   VARCHAR(20))      
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
  SET @@USER             = 'HO'      
  SET @@DATE             = GETDATE()      
  SET @@L_ENTPM_ID       = 0      
  SET @@L_PROP_ID        = 0      
  SET @@L_ENTPM_CLI_YN   = 1      
  SET @@L_TYPE           = 0      
  --      
  /*IF @PA_TYPE = 'CL'      
  BEGIN      
  --      
    SET @@L_TYPE         = 0      
    SET @@L_ENTPM_CLI_YN = 1      
  --      
  END      
  ELSE      
  BEGIN      
  --      
    SET @@L_TYPE         = 1      
    SET @@L_ENTPM_CLI_YN = 0      
  --      
  END  */    
  --      
  SET @@C_EXCPM =  CURSOR FAST_FORWARD FOR      
  SELECT EXCPM.EXCPM_ID EXCPM_ID      
  FROM EXCSM_PROD_MSTR EXCPM , exch_seg_mstr excsm , product_mstr prom WITH (NOLOCK)      
  WHERE EXCPM.EXCPM_DELETED_IND = 1      
  and   excsm.excsm_id = excpm.excpm_excsm_id  
  and   prom.prom_id = excpm.excpm_prom_id  
  AND   excsm.excsm_exch_cd  not in ('CDSL','NSDL')
  AND   prom.prom_cd = '01'  
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
       AND    ENTTM.ENTTM_CLI_YN  & 2    = 2 -- if client    
       AND    enttm.enttm_cd in ('CL_BR','01_CDSL')
       AND    clicm.clicm_cd in ('IND','21')
       --      
       OPEN @@C_ENTTM_CLICM      
       FETCH NEXT FROM @@C_ENTTM_CLICM INTO @@C_CLICM_ID, @@C_ENTTM_ID      
       --      
       WHILE @@FETCH_STATUS = 0      
       BEGIN--#C2      
       --      
         SET @@I  = 1      
         --      
         WHILE @@I <= 65     
         BEGIN--I<=9      
         --      
           IF @@I = 1      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 1  
             SET @@L_PROP_CD   = 'VSATOFF'      
             SET @@L_PROP_DESC = 'VSAT OFFICE DETAILS'      
             SET @@DATA_TYPE   = 'B'       
           --      
           END      
           ELSE IF @@I = 2      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 2      
             SET @@L_PROP_CD   = 'QUAL'      
             SET @@L_PROP_DESC = 'QUALIFICATION'      
             SET @@DATA_TYPE   = 'L'       
           --      
           END      
           ELSE IF @@I = 3      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 3     
             SET @@L_PROP_CD   = 'DOBCP1'      
             SET @@L_PROP_DESC = 'DOB DIRECTOR/PARTNER1'      
             SET @@DATA_TYPE   = 'D'       
           --      
           END      
           ELSE IF @@I = 4      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 4   
             SET @@L_PROP_CD   = 'QCP1'      
             SET @@L_PROP_DESC = 'DIRECTOR/PARTNER QLF3'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 5      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 5      
             SET @@L_PROP_CD   = 'FTHNAME'      
             SET @@L_PROP_DESC = 'FATHER''S NAME'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 6      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 6      
             SET @@L_PROP_CD   = 'GUARD_IT'      
             SET @@L_PROP_DESC = 'GUARDIAN IT DETAILS'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
  
           ELSE IF @@I = 7      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 7    
             SET @@L_PROP_CD   = 'INTERACTMODE'      
             SET @@L_PROP_DESC = 'INTERACTMODE OF THE CLIENT'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
  
           ELSE IF @@I = 8      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 8      
             SET @@L_PROP_CD   = 'DOBDP3'      
             SET @@L_PROP_DESC = 'DOB DIRECTOR/PARTNER3'      
             SET @@DATA_TYPE   = 'D'       
           --      
           END      
  
           ELSE IF @@I = 9      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 9      
             SET @@L_PROP_CD   = 'QUALI'      
             SET @@L_PROP_DESC = 'QUALIFICATION'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
  
           ELSE IF @@I = 10      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 10      
             SET @@L_PROP_CD   = 'TERMINAL_ID'      
             SET @@L_PROP_DESC = 'TERMINAL ID'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 11      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 11      
             SET @@L_PROP_CD   = 'DIR2'      
             SET @@L_PROP_DESC = 'DIRECTOR/PARTNER2'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 12      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 12      
             SET @@L_PROP_CD   = 'GEOGRAPHICAL'      
             SET @@L_PROP_DESC = 'GEOGRAPHICAL DETAILS'      
             SET @@DATA_TYPE   = 'L'       
           --      
           END      
           ELSE IF @@I = 13      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 13      
             SET @@L_PROP_CD   = 'PAYLOCATION'      
             SET @@L_PROP_DESC = 'PAYLOCATION OF THE CLIENT'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      	
           ELSE IF @@I = 14      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 14      
             SET @@L_PROP_CD   = 'SEBI_REGN_NO'      
             SET @@L_PROP_DESC = 'SEBI REGISTRATION NUMBER'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 15      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 15      
             SET @@L_PROP_CD   = 'ANNUAL_INCOME'      
             SET @@L_PROP_DESC = 'ANNUAL INCOME'      
             SET @@DATA_TYPE   = 'L'       
           --      
           END      	
           ELSE IF @@I = 16      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 16      
             SET @@L_PROP_CD   = 'FORMNO'      
             SET @@L_PROP_DESC = 'APPL FORM NO'      
             SET @@DATA_TYPE   = 'N'       
           --      
           END      
           ELSE IF @@I = 17      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 17      
             SET @@L_PROP_CD   = 'NOM_GUARD_IT'      
             SET @@L_PROP_DESC = 'NOMINEE GUARDIAN IT DETAILS'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 18      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 18      
             SET @@L_PROP_CD   = 'THIRD PARTY'      
             SET @@L_PROP_DESC = 'THIRD PARTY VALIDATION'      
             SET @@DATA_TYPE   = 'B'       
           --      
           END      
           ELSE IF @@I = 19      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 19      
             SET @@L_PROP_CD   = 'PASSPORT_NO'      
             SET @@L_PROP_DESC = 'PASSPORT NUMBER OF THE CLIENT'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 20      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 20      
             SET @@L_PROP_CD   = 'APPROVER'      
             SET @@L_PROP_DESC = 'APPROVER OF THE CLIENT'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 21      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 21      
             SET @@L_PROP_CD   = 'FATHNAME'      
             SET @@L_PROP_DESC = 'FATHER / HUSBAND NAME'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 22      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 22      
             SET @@L_PROP_CD   = 'CONTACT_PERSON'      
             SET @@L_PROP_DESC = 'CONTACT PERSON'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 23      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 23      
             SET @@L_PROP_CD   = 'CHK_FLAG'      
             SET @@L_PROP_DESC = 'CHK FLAG'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 24      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 24      
             SET @@L_PROP_CD   = 'DRECTOR_NAME'      
             SET @@L_PROP_DESC = 'COMPANY DIRECTOR''S NAME'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 25      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 25      
             SET @@L_PROP_CD   = 'PCCNT'      
             SET @@L_PROP_DESC = 'NUMBER OF PC''S AVAILABLE'      
             SET @@DATA_TYPE   = 'N'       
           --      
           END      
           ELSE IF @@I = 26      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 26      
             SET @@L_PROP_CD   = 'QDP2'      
             SET @@L_PROP_DESC = 'DIRECTOR/PARTNER QLF2'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 27      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 27      
             SET @@L_PROP_CD   = 'OSITSBD'      
             SET @@L_PROP_DESC = 'SUBBROKER DEP'      
             SET @@DATA_TYPE   = 'N'       
           --      
           END      
           ELSE IF @@I = 28      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 28      
             SET @@L_PROP_CD   = 'NATIONALITY'      
             SET @@L_PROP_DESC = 'NATIONALITY'      
             SET @@DATA_TYPE   = 'L'       
           --      
           END      
           ELSE IF @@I = 29      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 29      
             SET @@L_PROP_CD   = 'NRI_IT'      
             SET @@L_PROP_DESC = 'NRI IT DETAILS'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 30      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 30      
             SET @@L_PROP_CD   = 'DDP2'      
             SET @@L_PROP_DESC = 'DOB DIRECTOR/PARTNER2'      
             SET @@DATA_TYPE   = 'D'       
           --      
           END      
           ELSE IF @@I = 31      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 31      
             SET @@L_PROP_CD   = 'GROUP_CD'      
             SET @@L_PROP_DESC = 'GROUP CD'      
             SET @@DATA_TYPE   = 'L'       
           --      
           END      
           ELSE IF @@I = 32      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 32      
             SET @@L_PROP_CD   = 'REGISTERED'      
             SET @@L_PROP_DESC = 'SUB BROKER REGISTERED'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 33      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 33     
             SET @@L_PROP_CD   = 'TH_POA_IT'      
             SET @@L_PROP_DESC = 'THIRD HOLDER IT DETAILS'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 34      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 34      
             SET @@L_PROP_CD   = 'RAT_CARD_NO'      
             SET @@L_PROP_DESC = 'RATION CARD NUMBER OF THE CLIENT'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 35      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 35      
             SET @@L_PROP_CD   = 'INTRODUCER'      
             SET @@L_PROP_DESC = 'INTRODUCER OF THE CLIENT'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 36      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 36      
             SET @@L_PROP_CD   = 'PAN_GIR_NO'      
             SET @@L_PROP_DESC = 'PAN NUMBER OF THE ENTITY'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 37      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 37      
             SET @@L_PROP_CD   = 'CLIENT_AGREMENT_ON'      
             SET @@L_PROP_DESC = 'CLIENT AGREEMENT SIGNED - DATE'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 38      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 38      
             SET @@L_PROP_CD   = 'TAX_DEDUCTION'      
             SET @@L_PROP_DESC = 'TAX DEDUCTION'      
             SET @@DATA_TYPE   = 'L'       
           --      
           END      
           ELSE IF @@I = 39      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 39     
             SET @@L_PROP_CD   = 'MAPIN_ID'      
             SET @@L_PROP_DESC = 'MAPIN ID OF THE CLIENT'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 40      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 40      
             SET @@L_PROP_CD   = 'LANGUAGE'      
             SET @@L_PROP_DESC = 'LANGUAGE'      
             SET @@DATA_TYPE   = 'L'       
           --      
           END      
           ELSE IF @@I = 41      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 41      
             SET @@L_PROP_CD   = 'DIR1'      
             SET @@L_PROP_DESC = 'DIRECTOR/PARTNER1'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 42     
           BEGIN      
           --      
             SET @@L_PROP_ID   = 42      
             SET @@L_PROP_CD   = 'EDUCATION'      
             SET @@L_PROP_DESC = 'EDUCATION'      
             SET @@DATA_TYPE   = 'L'       
           --      
           END  
           ELSE IF @@I = 43      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 43      
             SET @@L_PROP_CD   = 'TRDNAME'      
             SET @@L_PROP_DESC = 'TRADING NAME'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 44      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 44      
             SET @@L_PROP_CD   = 'REGR_NO'      
             SET @@L_PROP_DESC = 'REGISTRATION NUMBER OF THE COMPANY'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 45      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 45      
             SET @@L_PROP_CD   = 'SEQ_PARTYCODE'      
             SET @@L_PROP_DESC = 'SEQUENCE FOR PARTY CODE'      
             SET @@DATA_TYPE   = 'N'       
           --      
           END      
           ELSE IF @@I = 46      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 46      
             SET @@L_PROP_CD   = 'NOSEMP'      
             SET @@L_PROP_DESC = 'NUMBER OF EMPLOYEES'      
             SET @@DATA_TYPE   = 'N'       
           --      
           END      
           ELSE IF @@I = 47      
           BEGIN      
            --      
              SET @@L_PROP_ID   = 47      
              SET @@L_PROP_CD   = 'SMS_FLG'      
              SET @@L_PROP_DESC = 'SMS FLAG'      
              SET @@DATA_TYPE   = 'B'       
           --      
           END      
           ELSE IF @@I = 48      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 48      
             SET @@L_PROP_CD   = 'BBO_CODE'      
             SET @@L_PROP_DESC = 'BROKING BACK-OFFICE CODE'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 49      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 49      
             SET @@L_PROP_CD   = 'CLIENT_IT'      
             SET @@L_PROP_DESC = 'CLIENT IT DETAILS'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 50      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 50      
             SET @@L_PROP_CD   = 'SH_POA_IT'      
             SET @@L_PROP_DESC = 'SECOND HOLDER IT DETAILS'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 51      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 51      
             SET @@L_PROP_CD   = 'DP3'      
             SET @@L_PROP_DESC = 'DIRECTOR/PARTNER3'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 52      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 52      
             SET @@L_PROP_CD   = 'FM_CODE'      
             SET @@L_PROP_DESC = 'FUND MANAGER CODE'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 53      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 53      
             SET @@L_PROP_CD   = 'DIR3'      
             SET @@L_PROP_DESC = 'THIRD DIRECTOR/PARTNER'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 54      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 54      
             SET @@L_PROP_CD   = 'BOSETTLFLG'      
             SET @@L_PROP_DESC = 'BOSETTLEMENTPLANFLAG'      
             SET @@DATA_TYPE   = 'B'       
           --      
           END      
           ELSE IF @@I = 55      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 55      
             SET @@L_PROP_CD   = 'LICENCE_NO'      
             SET @@L_PROP_DESC = 'LICENCE NUMBER OF THE CLIENT'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 56      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 56      
             SET @@L_PROP_CD   = 'OCCUPATION'      
             SET @@L_PROP_DESC = 'OCCUPATION'      
             SET @@DATA_TYPE   = 'L'       
           --      
           END      
           ELSE IF @@I = 57      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 57      
             SET @@L_PROP_CD   = 'DOB'      
             SET @@L_PROP_DESC = 'DATE OF BIRTH'      
             SET @@DATA_TYPE   = 'D'       
           --      
           END      
           ELSE IF @@I = 58      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 58      
             SET @@L_PROP_CD   = 'ODIN'      
             SET @@L_PROP_DESC = 'ODIN TERMINAL'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 59      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 59      
             SET @@L_PROP_CD   = 'RBI_REF_NO'      
             SET @@L_PROP_DESC = 'BANK RBI REF NO.'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 60      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 60      
             SET @@L_PROP_CD   = 'INC_DOB'      
             SET @@L_PROP_DESC = 'DATE OF INCORPORATION'      
             SET @@DATA_TYPE   = 'D'       
           --      
           END      
           ELSE IF @@I = 61      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 61      
             SET @@L_PROP_CD   = 'VOTERSID_NO'      
             SET @@L_PROP_DESC = 'VOTER ID NUMBER OF THE CLIENT'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 62      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 62      
             SET @@L_PROP_CD   = 'LC'      
             SET @@L_PROP_DESC = 'LOCATION CODE'      
             SET @@DATA_TYPE   = 'N'       
           --      
           END      
           ELSE IF @@I = 63      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 63      
             SET @@L_PROP_CD   = 'UCC_CODE'      
             SET @@L_PROP_DESC = 'UCC CODE OF THE CUSTODIAN'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      
           ELSE IF @@I = 64      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 64      
             SET @@L_PROP_CD   = 'STAFF'      
             SET @@L_PROP_DESC = 'STAFF'      
             SET @@DATA_TYPE   = 'B'       
           --      
           END      
           ELSE IF @@I = 65      
           BEGIN      
           --      
             SET @@L_PROP_ID   = 65      
             SET @@L_PROP_CD   = 'ADP3'      
             SET @@L_PROP_DESC = 'DIRECTOR/PARTNER QLF1'      
             SET @@DATA_TYPE   = 'S'       
           --      
           END      

           SELECT @@SEQ = ISNULL(MAX(entpm_id),0)+ 1      
  
           FROM  entity_property_mstr WITH (NOLOCK)      
           --      
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
           , ENTPM_DATATYPE      
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
           ,@@DATA_TYPE      
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
  /*  ELSE IF @@L_TYPE = 1      
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
          --PRINT CONVERT(VARCHAR, @@l_prop_id) + '----' + CONVERT(VARCHAR,@@C_clicm_id) + '----' + CONVERT(VARCHAR,@@C_enttm_id)  + '----' + CONVERT(VARCHAR,@@C_excpm_id) + '----' + CONVERT(VARCHAR,@@l_prop_cd) + '----' + CONVERT(VARCHAR,@@l_prop_desc) +
  
 '----' + CONVERT(VARCHAR,@@l_entpm_cli_yn) + '----0----' +  @@l_prop_desc + '----' + USER + '---- GETDATE()----' + USER + '----GETDATE----1'      
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
    END--TYPE=1  */    
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
