-- Object: PROCEDURE citrus_usr.populate_dp_property_mstr
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[populate_dp_property_mstr](@PA_TYPE   VARCHAR(20))
AS
BEGIN
--
  DECLARE @c_excpm          cursor
        , @c_enttm_clicm    cursor
        , @user             varchar(25)
        , @date             datetime
        , @l_entpm_id       numeric
        , @l_prop_id        numeric
        , @l_prop_cd        varchar(20)
        , @l_prop_desc      varchar(50)
        --, @l_entpm_cli_yn   smallint
        , @l_entdm_cd       varchar(25)
        , @l_entdm_desc     varchar(50)
        --, @l_type           numeric
        , @I                smallint
        , @c_excpm_id       numeric
        , @c_clicm_id       numeric
        , @c_enttm_id       numeric
        , @c_clicm_cd       varchar(25)
        , @seq              numeric
        , @data_type        char(1)
  --
  SET @user             = 'user'
  SET @date             = getdate()
  SET @l_entpm_id       = 0
  SET @l_prop_id        = 0
  --SET @l_entpm_cli_yn   = 0
  --SET @l_type           = 0
  --
  /*
  IF @pa_type = 'CL'
  BEGIN
  --
    SET @l_type         = 0
    SET @l_entpm_cli_yn = 1
  --
  END
  ELSE
  BEGIN
  --
    SET @l_type         = 1
    SET @l_entpm_cli_yn = 0
  --
  END
  */
  --
  SET @c_excpm =  CURSOR FAST_FORWARD FOR
  SELECT excpm.excpm_id excpm_id
  FROM   excsm_prod_mstr excpm     WITH (NOLOCK)
  WHERE  excpm.excpm_deleted_ind = 1
  --
  OPEN @c_excpm
  FETCH NEXT FROM @c_excpm INTO @c_excpm_id
  --
  WHILE @@FETCH_STATUS = 0
  BEGIN--#excpm_id
  --
       SET @c_enttm_clicm             = CURSOR FAST_FORWARD FOR
       SELECT clicm.clicm_id            clicm_id
            , enttm.enttm_id            enttm_id
            , clicm.clicm_cd            clicm_cd
       FROM   client_ctgry_mstr         clicm  WITH (NOLOCK)
            , entity_type_mstr          enttm  WITH (NOLOCK)
            , enttm_clicm_mapping       entcm  WITH (NOLOCK)
       WHERE  clicm.clicm_id          = entcm.entcm_clicm_id
       AND    enttm.enttm_id          = entcm.entcm_enttm_id
       AND    clicm.clicm_deleted_ind = 1
       AND    enttm.enttm_deleted_ind = 1
       AND    entcm.entcm_deleted_ind = 1
       AND    enttm.enttm_cli_yn      = 0
       --
       OPEN @c_enttm_clicm
       --
       FETCH NEXT FROM @c_enttm_clicm INTO @c_clicm_id, @c_enttm_id, @c_clicm_cd
       --
       WHILE @@FETCH_STATUS = 0
       BEGIN--#C2
       --
         SET @I  = 1
         --
         WHILE @I <= 79
         BEGIN--I<=79
         --
           --Client Type: FI, FII, Body Corporate, 'Mutual fund', 'Trust and Bank'         
           IF @c_clicm_cd IN ('FI', 'FII', 'BODY CORPORATE', 'MUTUAL FUND', 'TRUST AND BANK')
           BEGIN--##1
           --
             IF @I = 1
             BEGIN
             --
               SET @l_prop_id   = 1   
               SET @l_prop_cd   = 'ADR_FLG'  
               SET @L_PROP_DESC = 'ADDRESS PREFERENCE FLAG'  
               SET @DATA_TYPE   = 'S' 
             --
             END
             --
             IF @I = 2
             BEGIN
             --
               SET @l_prop_id   = 2   
               SET @l_prop_cd   = 'FT_HLDR_PAN'  
               SET @L_PROP_DESC = 'FIRST HOLDER PAN'  
               SET @DATA_TYPE   = 'S' 
             --
             END
             --
             IF @I = 3
             BEGIN
             --
               SET @l_prop_id   = 3   
               SET @l_prop_cd   = 'ST_INS_IND'  
               SET @L_PROP_DESC = 'STANDING INSTRUCTION INDICATOR'  
               SET @DATA_TYPE   = 'S' 
             --
             END
             --
             IF @I = 4
             BEGIN
             --
               SET @l_prop_id   = 4   
               SET @l_prop_cd   = 'BEN_RBI_REF_NO'  
               SET @l_prop_desc = 'BENEFICIARY RBI REFERENCE NO.'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 5
             BEGIN 
             --
               SET @l_prop_id   = 5   
               SET @l_prop_cd   = 'BEN_SEBI_REG_NO'  
               SET @l_prop_desc = 'BENEFICIARY SEBI REGISTRATION NO.'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 6
             BEGIN
             --
               SET @l_prop_id   = 6   
               SET @l_prop_cd   = 'BEN_TAX_DED_STATUS'  
               SET @l_prop_desc = 'BENEFICIARY TAX DEDUCTION STATUS'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 7
             BEGIN
             --
               SET @l_prop_id   = 7   
               SET @l_prop_cd   = 'FR_CORR_ADR_YN'  
               SET @l_prop_desc = 'FOREIGN/CORRESPONDENCE ADDRESS PRESEnt?'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 8
             BEGIN
             --
               SET @l_prop_id   = 8   
               SET @l_prop_cd   = 'NO_OF_AUTH_SIG'  
               SET @l_prop_desc = 'NO. OF FIRST HOLDER AUTHORIZED SIGNAtories'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 9
             BEGIN
             --
               SET @l_prop_id   = 9   
               SET @l_prop_cd   = 'SIZE_OF_SIGN'  
               SET @l_prop_desc = 'SIZE OF SIGNATURE'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 10
             BEGIN
             --
               SET @l_prop_id   = 10   
               SET @l_prop_cd   = 'MAPIN_FIRST_HLDR'  
               SET @l_prop_desc = 'MAP IN ID OF FIRST HOLDER'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 11
             BEGIN
             --
               SET @l_prop_id   = 11   
               SET @l_prop_cd   = 'SMS_FIRST_HLDR'  
               SET @l_prop_desc = 'SMS FACILITY FOR FIRST HOLDER (FOR Future reference)'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 12
             BEGIN
             --
               SET @l_prop_id   = 12   
               SET @l_prop_cd   = 'POA_FIRST_HLDR'  
               SET @l_prop_desc = 'POA FACILITY FOR FIRST HOLDER/ACCOUNt'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 13
             BEGIN
             --
               SET @l_prop_id   = 13   
               SET @l_prop_cd   = 'PAN_FIRST_HLDR'  
               SET @l_prop_desc = 'PAN FLAG FOR FIRST HOLDER'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 14
             BEGIN
             --
               SET @l_prop_id   = 14   
               SET @l_prop_cd   = 'MAPIN_SECOND_HLDR'  
               SET @l_prop_desc = 'MAP IN ID OF SECOND HOLDER'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 15
             BEGIN
             --
               SET @l_prop_id   = 15   
               SET @l_prop_cd   = 'SMS_SEC_HLDR'  
               SET @l_prop_desc = 'SMS FACILITY FOR SECOND HOLDER (FOR future reference)'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 16
             BEGIN
             --
               SET @l_prop_id   = 16   
               SET @l_prop_cd   = 'PAN_SEC_HLDR'  
               SET @l_prop_desc = 'PAN FLAG FOR SECOND HOLDER'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 17
             BEGIN
             --
               SET @l_prop_id   = 17   
               SET @l_prop_cd   = 'MAPIN_THIRD_HLDR'  
               SET @l_prop_desc = 'MAP IN ID OF THIRD HOLDER'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 18
             BEGIN
             --
               SET @l_prop_id   = 18   
               SET @l_prop_cd   = 'SMS_THIRD_HLDR'  
               SET @l_prop_desc = 'SMS FACILITY FOR THIRD HOLDER (FOR Future reference)'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 19
             BEGIN
             --
               SET @l_prop_id   = 19   
               SET @l_prop_cd   = 'PAN_THIRD_HLDR'  
               SET @l_prop_desc = 'PAN FLAG FOR THIRD HOLDER'  
               SET @data_type   = 'S'
             --
             END
           --  
           END--##1  
           --
           --Client type: resident, NRI & Foreign National      SET @L_PROP_DESC =  ''  SET @DATA_TYPE   = 'S' 
           IF @c_clicm_cd in ('RESIDENT','NRI & FOREIGN NATIONAL')
           BEGIN--##2
           --
             IF @I = 20
             BEGIN
             --
               SET @l_prop_id   = 20   
               SET @l_prop_cd   = 'FTH_NAME'  
               SET @l_prop_desc = 'FIRST HOLDER FATHER/HUSBAND NAME '  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 21
             BEGIN

               SET @l_prop_id   = 21   
               SET @l_prop_cd   = 'ADR_FLG'  
               SET @l_prop_desc = 'ADDRESS PREFERENCE FLAG'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 22
             BEGIN

               SET @l_prop_id   = 22   
               SET @l_prop_cd   = 'PAN_FIRST_HLDR'  
               SET @l_prop_desc = 'FIRST HOLDER I.T. P.A.N.'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 23
             BEGIN

               SET @l_prop_id   = 23   
               SET @l_prop_cd   = 'NOM_GUD_INDICATOR'  
               SET @l_prop_desc = 'NOMINEE/GUARDIAN INDICATOR'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 24
             BEGIN

               SET @l_prop_id   = 24   
               SET @l_prop_cd   = 'NOM_MIN_INDICATOR'  
               SET @l_prop_desc = 'NOMINEE MINOR INDICATOR'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 25
             BEGIN

               SET @l_prop_id   = 25   
               SET @l_prop_cd   = 'ST_INS_IND'  
               SET @l_prop_desc = 'STANDING INSTRUCTION INDICATOR'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 26
             BEGIN
             --
               SET @l_prop_id   = 26   
               SET @l_prop_cd   = 'BEN_RBI_REF_NO'  
               SET @l_prop_desc = 'BENEFICIARY RBI REFERENCE NO.'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 27
             BEGIN

               SET @l_prop_id   = 27   
               SET @l_prop_cd   = 'BEN_TAX_DED_STATUS'  
               SET @l_prop_desc = 'BENEFICIARY TAX DEDUCTION STATUS'  
               SET @data_type   = 'S'
             --  
             END  
             --
             IF @I = 28
             BEGIN

               SET @l_prop_id   = 28   
               SET @l_prop_cd   = 'NOM_ADR_YN'  
               SET @l_prop_desc = 'NOMINEE/GUARDIAN ADDRESS PRESENT?'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 29
             BEGIN

               SET @l_prop_id   = 29   
               SET @l_prop_cd   = 'MIN_ADR_YN'  
               SET @l_prop_desc = 'MINOR NOMINEES GUARDIAN ADDR PRESENT'  
               SET @data_type   = 'S' 
             --
             END

             IF @I = 30       
             BEGIN
             --
               SET @l_prop_id   = 30   
               SET @l_prop_cd   = 'FR_COR_YN'  
               SET @l_prop_desc = 'FOREIGN/CORRESPONDENCE ADDRESS PRESENT?'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 31
             BEGIN
             --
               SET @l_prop_id   = 31   
               SET @l_prop_cd   = 'NO_FH_SIGN'  
               SET @l_prop_desc = 'NO. OF FIRST HOLDER AUTHORIZED SIGNATORIES'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 32
             BEGIN
             --
               SET @l_prop_id   = 32   
               SET @l_prop_cd   = 'NO_SH_SIGN'  
               SET @l_prop_desc = 'NO. OF SEC HOLDER AUTHORIZED SIGNATORIES'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 33
             BEGIN

               SET @l_prop_id   = 33   
               SET @l_prop_cd   = 'NO_TH_SIGN'  
               SET @l_prop_desc = 'NO. OF THIRD HOLDER AUTHORIZED SIGNATORIES'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 34
             BEGIN

               SET @l_prop_id   = 34   
               SET @l_prop_cd   = 'SIZE_OF_SIGN'  
               SET @l_prop_desc = 'SIZE OF SIGNATURE'  
               SET @data_type   = 'S' 
             END
             --
             IF @I = 35
             BEGIN

               SET @l_prop_id   = 35   
               SET @l_prop_cd   = 'SENDER_REF_1'  
               SET @l_prop_desc = 'SENDER REFERENCE NUMBER 1'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 36
             BEGIN

               SET @l_prop_id   = 36   
               SET @l_prop_cd   = 'SENDER_REF_2'  
               SET @l_prop_desc = 'SENDER REFERENCE NUMBER 2'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 37
             BEGIN

               SET @l_prop_id   = 37   
               SET @l_prop_cd   = 'MAPIN_FIRST_HLDR'  
               SET @l_prop_desc = 'MAP IN ID OF FIRST HOLDER'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 38
             BEGIN

               SET @l_prop_id   = 38   
               SET @l_prop_cd   = 'SMS_FIRST_HLDR'  
               SET @l_prop_desc = 'SMS FACILITY FOR FIRST HOLDER (FOR FUTURE REFERENCE)'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 39
             BEGIN

               SET @l_prop_id   = 39   
               SET @l_prop_cd   = 'POA_FIRST_HLDR'  
               SET @l_prop_desc = 'POA FACILITY FOR FIRST HOLDER/ACCOUNT'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 40
             BEGIN

               SET @l_prop_id   = 40   
               SET @l_prop_cd   = 'PAN_FIRST_HLDR'  
               SET @l_prop_desc = 'PAN FLAG FOR FIRST HOLDER'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 41
             BEGIN

               SET @l_prop_id   = 41   
               SET @l_prop_cd   = 'MAPIN_SECOND_HLDR'  
               SET @l_prop_desc = 'MAP IN ID OF SECOND HOLDER'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 42
             BEGIN

               SET @l_prop_id   = 42   
               SET @l_prop_cd   = 'SMS_SEC_HLDR'  
               SET @l_prop_desc = 'SMS FACILITY FOR SECOND HOLDER (FOR FUTURE REFERENCE)'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 43
             BEGIN

               SET @l_prop_id   = 43   
               SET @l_prop_cd   = 'PAN_SEC_HLDR'  
               SET @l_prop_desc = 'PAN FLAG FOR SECOND HOLDER'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 44
             BEGIN

               SET @l_prop_id   = 44   
               SET @l_prop_cd   = 'MAPIN_THIRD_HLDR'  
               SET @l_prop_desc = 'MAP IN ID OF THIRD HOLDER'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 45
             BEGIN

               SET @l_prop_id   = 45   
               SET @l_prop_cd   = 'SMS_THIRD_HLDR'  
               SET @l_prop_desc = 'SMS FACILITY FOR THIRD HOLDER (FOR FUTURE REFERENCE)'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 46
             BEGIN

               SET @l_prop_id   = 46   
               SET @l_prop_cd   = 'PAN_THIRD_HLDR'  
               SET @l_prop_desc = 'PAN FLAG FOR THIRD HOLDER'  
               SET @data_type   = 'S'
             --
             END
           --
           END--##2
           
           --Client type: clearing Member      SET @L_PROP_DESC =  ''  SET @DATA_TYPE   = 'S' 
           IF @c_clicm_cd = 'CLEARING MEMBER'
           BEGIN--##3
           --
             IF @I = 47
             BEGIN
             --
               SET @l_prop_id   = 47   
               SET @l_prop_cd   = 'CMBPID'  
               SET @l_prop_desc = 'CORRESPONDING BP ID'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 48
             BEGIN

               SET @l_prop_id   = 48   
               SET @l_prop_cd   = 'ST_INS_IND'  
               SET @l_prop_desc = 'STANDING INSTRUCTION INDICATOR' 
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I  = 49
             BEGIN
             --
               SET @l_prop_id   = 49   
               SET @l_prop_cd   = 'NO_FH_SIGN'  
               SET @l_prop_desc = 'NO. OF FIRST HOLDER AUTHORIZED SIGNATORIES'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 50
             BEGIN
             --
               SET @l_prop_id   = 50   
               SET @l_prop_cd   = 'NO_SH_SIGN'  
               SET @l_prop_desc = 'NO. OF SEC HOLDER AUTHORIZED SIGNATORIES'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 1
             BEGIN

               SET @l_prop_id   = 51   
               SET @l_prop_cd   = 'NO_TH_SIGN'  
               SET @l_prop_desc = 'NO. OF THIRD HOLDER AUTHORIZED SIGNATORIES'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 52
             BEGIN

               SET @l_prop_id   = 52   
               SET @l_prop_cd   = 'SIZE_OF_SIGN'  
               SET @l_prop_desc = 'SIZE OF SIGNATURE'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 53
             BEGIN

               SET @l_prop_id   = 53   
               SET @l_prop_cd   = 'SENDER_REF_1'  
               SET @l_prop_desc = 'SENDER REFERENCE NUMBER 1'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 54
             BEGIN

               SET @l_prop_id   = 54   
               SET @l_prop_cd   = 'SENDER_REF_2'  
               SET @l_prop_desc = 'SENDER REFERENCE NUMBER 2' 
               SET @data_type   = 'S'
             --
             END
           --  
           END--##3  
           --
           ---Client type: fi, FII, Body Corporate, Mutual Fund, Trust & Bank 
           IF @c_clicm_cd IN ('FI','FII','BODY CORPORATE','MUTUAL FUND','TRUST & BANK')
           BEGIN--##4
           --
             IF @I = 55
             BEGIN

               SET @l_prop_id   = 55   
               SET @l_prop_cd   = 'ADR_FLG'  
               SET @l_prop_desc = 'ADDRESS PREFERENCE FLAG'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 56
             BEGIN

               SET @l_prop_id   = 56   
               SET @l_prop_cd   = 'FIRST_HLDR_PAN'  
               SET @l_prop_desc = 'FIRST HOLDER PAN'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 57
             BEGIN
             --
               SET @l_prop_id   = 57   
               SET @l_prop_cd   = 'ST_INS_IND'  
               SET @l_prop_desc = 'STANDING INSTRUCTION INDICATOR'  
               SET @data_type   = 'S' 
             --
             END

             IF @I = 58
             BEGIN
             --
               SET @l_prop_id   = 58   
               SET @l_prop_cd   = 'BEN_RBI_REF_NO'  
               SET @l_prop_desc = 'BENEFICIARY RBI REFERENCE NO.'  
               SET @data_type   = 'S'
             END
             --
             IF @I = 59
             BEGIN
             --
               SET @l_prop_id   = 59   
               SET @l_prop_cd   = 'BEN_SEBI_REG_NO'  
               SET @l_prop_desc = 'BENEFICIARY SEBI REGISTRATION NO.'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 60
             BEGIN
             --
               SET @l_prop_id   = 60   
               SET @l_prop_cd   = 'BEN_TAX_DED_STATUS'  
               SET @l_prop_desc = 'BENEFICIARY TAX DEDUCTION STATUS'  
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 61
             BEGIN

               SET @l_prop_id   = 61   
               SET @l_prop_cd   = 'FR_COR_YN'  
               SET @l_prop_desc = 'FOREIGN/CORRESPONDENCE ADDRESS PRESENT?'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 62
             BEGIN

               SET @l_prop_id   = 62   
               SET @l_prop_cd   = 'NO_FH_SIGN'  
               SET @l_prop_desc = 'NO. OF FIRST HOLDER AUTHORIZED SIGNATORIES'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 63
             BEGIN
             --
               SET @l_prop_id   = 63   
               SET @l_prop_cd   = 'NO_SH_SIGN'  
               SET @l_prop_desc = 'NO. OF SEC HOLDER AUTHORIZED SIGNATORIES'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 64
             BEGIN
             --
               SET @l_prop_id   = 64   
               SET @l_prop_cd   = 'NO_TH_SIGN'  
               SET @l_prop_desc = 'NO. OF THIRD HOLDER AUTHORIZED SIGNATORIES'  
               SET @data_type   = 'S'
             --
             END
             -- 
             IF @I = 65
             BEGIN
             --
               SET @l_prop_id   = 65   
               SET @l_prop_cd   = 'SIZE_OF_SIGN'  
               SET @l_prop_desc = 'SIZE OF SIGNATURE'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 66
             BEGIN
             --
               SET @l_prop_id   = 66   
               SET @l_prop_cd   = 'MAPIN_FIRST_HLDR'  
               SET @l_prop_desc = 'MAP IN ID OF FIRST HOLDER'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 67
             BEGIN
             --
               SET @l_prop_id   = 67   
               SET @l_prop_cd   = 'SMS_FIRST_HLDR'  
               SET @l_prop_desc = 'SMS FACILITY FOR FIRST HOLDER (FOR FUTURE REFERENCE)' 
               SET @data_type   = 'S'
             --
             END
             --
             IF @I = 68
             BEGIN
             --
               SET @l_prop_id   = 68   
               SET @l_prop_cd   = 'POA_FIRST_HLDR'  
               SET @l_prop_desc = 'POA FACILITY FOR FIRST HOLDER/ACCOUNT'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 69
             BEGIN
             --
               SET @l_prop_id   = 69   
               SET @l_prop_cd   = 'PAN_FIRST_HLDR'  
               SET @l_prop_desc = 'PAN FLAG FOR FIRST HOLDER'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 70
             BEGIN
             --
               SET @l_prop_id   = 70   
               SET @l_prop_cd   = 'MAPIN_SECOND_HLDR'  
               SET @l_prop_desc = 'MAP IN ID OF SECOND HOLDER'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 71
             BEGIN
             --
               SET @l_prop_id   = 71   
               SET @l_prop_cd   = 'MOBILE_SEC_HLDR'  
               SET @l_prop_desc = 'MOBILE NO OF SECOND HOLDER'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 72
             BEGIN
             --
                SEt @l_prop_id   =72   
                SEt @l_prop_cd   ='SMS_SEC_HLDR'  
                SEt @l_prop_desC ='SMS FACILITY FOR SECOND HOLDER (FOR FUTURE REFERENCE)'  
                SEt @data_type   ='S' 
             --
             END
             --
             IF @I = 73
             BEGIN
             --
               SET @l_prop_id   = 73   
               SET @l_prop_cd   = 'PAN_SEC_HLDR'  
               SET @l_prop_desc = 'PAN FLAG FOR SECOND HOLDER'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 74
             BEGIN
             --
               SET @l_prop_id   = 74   
               SET @l_prop_cd   = 'MAPIN_THIRD_HLDR'  
               SET @l_prop_desc = 'MAP IN ID OF THIRD HOLDER'  
               SET @data_type   = 'S' 
             --
             END
             --
             IF @I = 75
             BEGIN
             --
               SET @l_prop_id   = 75   
               SET @l_prop_cd   = 'SMS_THIRD_HLDR'  
               SET @l_prop_desc = 'SMS FACILITY FOR THIRD HOLDER (FOR FUTURE REFERENCE)'  
               SET @data_type   = 'S' 
             --  
             END  
             --
             IF @I = 76
             BEGIN
             --
               SET @l_prop_id   = 76   
               SET @l_prop_cd   = 'PAN_THIRD_HLDR'  
               SET @l_prop_desc = 'PAN FLAG FOR THIRD HOLDER'  
               SET @data_type   = 'S'
             --
             END
           --
           END--##4
           
           --Common properties in all Client_types    
           IF @I = 77
           BEGIN
           --           
             SET @l_prop_id   = 77   
             SET @l_prop_cd   = 'NO_FH_SIGN'  
             SET @l_prop_desc = 'NO. OF FIRST HOLDER AUTHORIZED SIGNATORIES'  
             SET @data_type   = 'S' 
           --
           END
           --
           IF @I = 78
           BEGIN
           --
             SET @l_prop_id   = 78   
             SET @l_prop_cd   = 'SIZE_OF_SIGN'  
             SET @l_prop_desc = 'SIZE OF SIGNATURE'  
             SET @data_type   = 'S' 
           --
           END
           --
           IF @I = 79
           BEGIN
           --
             SET @l_prop_id   = 79 
             SET @l_prop_cd   = 'ST_INS_IND'  
             SET @l_prop_desc = 'STANDING INSTRUCTION INDICATOR'  
             SET @data_type   = 'S' 
           --
           END
           --
           --PRINT  CONVERT(VARCHAR, @l_prop_id) + '-----' +  CONVERT(VARCHAR, @l_prop_cd) + '-----' + @l_prop_desc + '-----' +  CONVERT(VARCHAR, @c_clicm_id) + '-----' +  CONVERT(VARCHAR, @c_enttm_id) + '-----' +  CONVERT(VARCHAR, @c_excpm_id)
           SET @I           = @I + 1
           SET @l_prop_id   = null
           SET @l_prop_cd   = null
           SET @l_prop_desc = null
           SET @data_type   = null
         --
         END
         --
         FETCH NEXT FROM @c_enttm_clicm INTO @c_clicm_id, @c_enttm_id, @c_clicm_cd
       --
       END--#C2
       --
       CLOSE @c_enttm_clicm
       DEALLOCATE @c_enttm_clicm
    --
    --END--TYPE=0
    --
    FETCH NEXT FROM @c_excpm INTO @c_excpm_id
  --
  END--#excpm_id
  --
  CLOSE @c_excpm
  DEALLOCATE @c_excpm
--
END

GO
