-- Object: PROCEDURE citrus_usr.PR_SELECT_MSTR
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE  [citrus_usr].[PR_SELECT_MSTR](@PA_ID            VARCHAR(20)
                               ,@PA_ACTION        VARCHAR(20)
                               ,@PA_LOGIN_NAME    VARCHAR(20)
                               ,@PA_CD            VARCHAR(25)
                               ,@PA_DESC          VARCHAR(250)
                               ,@PA_RMKS          VARCHAR(250)
                               ,@PA_VALUES        VARCHAR(8000)
                               ,@ROWDELIMITER     CHAR(4)
                               ,@COLDELIMITER     CHAR(4)
                               ,@PA_REF_CUR       VARCHAR(8000) OUT
                               )
AS
BEGIN
--
Declare @l int   
IF @PA_ACTION = 'DP_LISTING' 
  BEGIN
  --
    SELECT DISTINCT top 1  excsm.excsm_id        excsm_id
                   ,excm.excm_id          excm_id
                   ,excm.excm_cd          excm_cd
                   ,excm.excm_desc        excm_desc
    FROM   exchange_mstr                  excm  with(nolock)
          ,exch_seg_mstr                  excsm with(nolock)  
    WHERE  excm.excm_deleted_ind        = 1
    AND    excsm.excsm_deleted_ind      = 1
    AND    excm.excm_cd                 = excsm.excsm_exch_cd 
    AND    excsm_seg_cd                 = 'depository'
    AND    excsm_exch_cd                = 'CDSL'
     
    
    union
    
			    SELECT  DISTINCT  top 1 excsm.excsm_id        excsm_id
				,excm.excm_id          excm_id
				,excm.excm_cd          excm_cd
				,excm.excm_desc        excm_desc
				FROM   exchange_mstr                  excm  with(nolock)
				,exch_seg_mstr                  excsm with(nolock)  
				WHERE  excm.excm_deleted_ind        = 1
				AND    excsm.excsm_deleted_ind      = 1
				AND    excm.excm_cd                 = excsm.excsm_exch_cd 
				AND    excsm_seg_cd                 = 'depository'
				AND    excsm_exch_cd                = 'NSDL'
    ORDER  by excsm_id ,excm_cd     
  --
  END
  IF @PA_ACTION = 'HLD_LISTING' 
		BEGIN
		--
				SELECT BITRM_CHILD_CD
				      ,BITRM_BIT_LOCATION
				FROM   BITMAP_REF_MSTR 
				WHERE  BITRM_PARENT_CD = 'HOLDER'
				AND    BITRM_DELETED_IND = 1 
				ORDER BY BITRM_BIT_LOCATION
		--
  END
  IF @PA_ACTION = 'POATYPE_LISTING' 
		BEGIN
		--
				SELECT BITRM_CHILD_CD,BITRM_VALUES
				FROM   BITMAP_REF_MSTR 
				WHERE  BITRM_PARENT_CD = 'POA_TYPE'
				AND    BITRM_DELETED_IND = 1 
		--
  END
  IF @PA_ACTION = 'UCC_CHECK' 
		BEGIN
		--
				SELECT clia_acct_no 
				FROM   client_accounts
				WHERE  clia_acct_no     = @pa_cd
				AND    clia_deleted_ind = 1
		--
  END
  
  IF @PA_ACTION = 'SBU_LISTING' 
  BEGIN
		--
				declare @l_sbum numeric
				
				select @l_sbum = logn_sbum_id from login_names where logn_name = @pa_login_name and logn_deleted_ind = 1
				
				IF @l_sbum <> 0
				BEGIN
				--
				  SELECT sbum_id 
				       , sbum_desc
				  FROM   sbu_mstr
				       , login_names 
				  WHERE  logn_sbum_id = sbum_id
				  AND    sbum_deleted_ind  = 1
				  AND    logn_deleted_ind  = 1
				  AND    logn_name         = @pa_login_name
				--
				END
				ELSE
				BEGiN
				--
				  SELECT sbum_id 
											, sbum_desc
						FROM   sbu_mstr
						WHERE  sbum_deleted_ind  = 1
                        AND    sbum_id  <> 0      
				--
				END
				
		--
  END
  IF @PA_ACTION = 'STAM_SEARCH' 
  BEGIN
  --
    SELECT DISTINCT stam.stam_cd      stam_cd
                   ,stam.stam_desc    stam_desc
    FROM   status_mstr                stam with(nolock)
    WHERE  stam.stam_deleted_ind    = 1
  --
  END
  ELSE IF @PA_ACTION = 'STAM_SEARCHM'
  BEGIN
  --
    SELECT DISTINCT stamm.stam_cd    stam_cd
                   ,stamm.stam_desc  stam_desc
    FROM   status_mstr_mak           stamm  with(nolock)
    WHERE  stamm.stam_deleted_ind IN (0, 4, 6)
    AND    stamm.stam_created_by   = @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'STAM_SEARCHC'
  BEGIN
  --
    SELECT DISTINCT stamm.stam_cd    stam_cd
                   ,stamm.stam_desc  stam_desc
    FROM   status_mstr_mak           stamm  with(nolock)
    WHERE  stamm.stam_deleted_ind IN (0, 4, 6)
    AND    stamm.stam_created_by  <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'STAM_SEL'
  BEGIN
  --
    SELECT stam.stam_id               stam_id
         , stam.stam_cd               stam_cd
         , stam.stam_desc             stam_desc
         , stam.stam_rmks             stam_rmks
         , ''                         errmsg
    FROM   status_mstr                stam   with(nolock)
    WHERE  stam.stam_deleted_ind    = 1
    AND    stam.stam_cd          LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD  END
    AND    stam.stam_desc        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC +'%' END
  --
  END
  ELSE IF @PA_ACTION = 'STAM_SELM'
  BEGIN
  --
    SELECT stamm.stam_id               stam_id
         , stamm.stam_cd               stam_cd
         , stamm.stam_desc             stam_desc
         , stamm.stam_rmks             stam_rmks
         , ''                          errmsg
    FROM   status_mstr_mak             stamm  with(nolock)
    WHERE  stamm.stam_deleted_ind   IN (0, 4, 6)
    AND    stamm.stam_cd          LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD   END
    AND    stamm.stam_desc        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC +'%' END
    AND    stamm.stam_created_by     = @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'STAM_SELC'
  BEGIN
  --
    SELECT stamm.stam_id               stam_id
         , stamm.stam_cd               stam_cd
         , stamm.stam_desc             stam_desc
         , stamm.stam_rmks             stam_rmks
         , ''                          errmsg
    FROM   status_mstr_mak             stamm  with(nolock)
    WHERE  stamm.stam_deleted_ind   IN (0, 4, 6)
    AND    stamm.stam_cd          LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD   END
    AND    stamm.stam_desc        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC +'%'   END
    AND    stamm.stam_lst_upd_by    <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'ENTTM_SEARCH'
  BEGIN
  --
    SELECT DISTINCT enttm.enttm_cd      enttm_cd
          ,enttm.enttm_desc             enttm_desc
    FROM   entity_type_mstr             enttm  with(nolock)
    WHERE  enttm.enttm_deleted_ind    = 1
  --
  END
  ELSE IF @PA_ACTION = 'ENTTM_SEARCHM'
  BEGIN
  --
    SELECT DISTINCT enttmm.enttm_cd    enttm_cd
          ,enttmm.enttm_desc           enttm_desc
    FROM   entity_type_mstr_mak        enttmm   with(nolock)
    WHERE  enttmm.enttm_deleted_ind IN (0, 4, 6)
    AND    enttmm.enttm_created_by   = @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'ENTTM_SEARCHC'
  BEGIN 
  --
    SELECT DISTINCT enttmm.enttm_cd     enttm_cd
          ,enttmm.enttm_desc            enttm_desc
    FROM   entity_type_mstr_mak         enttmm   with(nolock)
    WHERE  enttmm.enttm_deleted_ind IN (0, 4, 6)
    AND    enttmm.enttm_created_by  <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'ENTTM_SEL' 
  BEGIN
  --
    SELECT enttm.enttm_id               enttm_id
         , enttm.enttm_cd               enttm_cd
         , enttm.enttm_prefix           enttm_prefix
         , enttm.enttm_desc             enttm_desc
         , enttm.enttm_rmks             enttm_rmks
         ,''                            errmsg
         
         , ISNULL(citrus_usr.fn_get_enttm_bit(enttm.enttm_id,1,0),'')  busm_dtlsid
         , ISNULL(citrus_usr.fn_get_enttm_bit(enttm.enttm_id,2,0),'')  busm_dtls 
         , CASE enttm.enttm_cli_yn&1 WHEN 0 THEN 0 ELSE 1 END          ent_yn
         , CASE enttm.enttm_cli_yn&2 WHEN 0 THEN 0 ELSE 1 END          cli_yn
         , CASE enttm.enttm_cli_yn&4 WHEN 0 THEN 0 ELSE 1 END          oth_yn
         , enttm.enttm_parent_cd        enttm_parent_cd
    FROM   entity_type_mstr             enttm   with(nolock)
    WHERE  enttm.enttm_deleted_ind    = 1
    AND    enttm.enttm_cd          LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD   END
    AND    enttm.enttm_desc        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC +'%' END
  --
  END
  ELSE IF @PA_ACTION = 'ENTTM_SELM' 
  BEGIN
  --
    SELECT enttmm.enttm_id               enttm_id
         , enttmm.enttm_cd               enttm_cd
         , enttmm.enttm_prefix           enttm_prefix
         , enttmm.enttm_desc             enttm_desc
         , enttmm.enttm_rmks             enttm_rmks
         ,''                             errmsg
         
         , ISNULL(citrus_usr.fn_get_enttm_bit(enttmm.enttm_id,1,1),'')  busm_dtlsid
         , ISNULL(citrus_usr.fn_get_enttm_bit(enttmm.enttm_id,2,1),'')  busm_dtls 
         , CASE enttmm.enttm_cli_yn&1 WHEN 0 THEN 0 ELSE 1 END          ent_yn
         , CASE enttmm.enttm_cli_yn&2 WHEN 0 THEN 0 ELSE 1 END          cli_yn
         , CASE enttmm.enttm_cli_yn&4 WHEN 0 THEN 0 ELSE 1 END          oth_yn
         
         , enttmm.enttm_parent_cd        enttm_parent_cd
    FROM   entity_type_mstr_mak          enttmm   with(nolock)
    WHERE  enttmm.enttm_cd          LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD   END
    AND    enttmm.enttm_desc        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC +'%' END
    AND    enttmm.enttm_deleted_ind   IN (0, 4, 6)
    AND    enttmm.enttm_created_by     = @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'ENTTM_SELC'
  BEGIN
  --
    SELECT enttmm.enttm_id               enttm_id
         , enttmm.enttm_cd               enttm_cd
         , enttmm.enttm_prefix           enttm_prefix
         , enttmm.enttm_desc             enttm_desc
         , enttmm.enttm_rmks             enttm_rmks
         ,''                             errmsg
         , ISNULL(citrus_usr.fn_get_enttm_bit(enttmm.enttm_id,1,1),'')  busm_dtlsid
         , ISNULL(citrus_usr.fn_get_enttm_bit(enttmm.enttm_id,2,1),'')  busm_dtls 
         , CASE enttmm.enttm_cli_yn&1 WHEN 0 THEN 0 ELSE 1 END          ent_yn
         , CASE enttmm.enttm_cli_yn&2 WHEN 0 THEN 0 ELSE 1 END          cli_yn
         , CASE enttmm.enttm_cli_yn&4 WHEN 0 THEN 0 ELSE 1 END          oth_yn
         , enttmm.enttm_parent_cd        enttm_parent_cd
    FROM   entity_type_mstr_mak          enttmm         WITH(NOLOCK)
    WHERE  enttmm.enttm_cd          LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD   END
    AND    enttmm.enttm_desc        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC +'%' END
    AND    enttmm.enttm_deleted_ind   IN (0, 4, 6)
    AND    enttmm.enttm_lst_upd_by    <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'CLICM_SEARCH'

  BEGIN
  --
    select @l = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd  = 'bus_' + isnull(@pa_cd,'')
    SELECT DISTINCT clicm.clicm_cd   clicm_cd
           ,clicm.clicm_desc         clicm_desc         
           ,clicm.clicm_id           clicm_id
    FROM   client_ctgry_mstr         clicm   with(nolock)
    WHERE  clicm.clicm_deleted_ind = 1
    AND clicm_bit & power(2,@l-1) > 0
  --
  END
  ELSE IF @PA_ACTION = 'CLICM_SEARCHM'
  BEGIN
  --
    select @l = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd  = 'bus_' + isnull(@pa_cd,'')
    SELECT DISTINCT clicmm.clicm_cd    clicm_cd
          ,clicmm.clicm_desc           clicm_desc         
          ,clicmm.clicm_id             clicm_id
    FROM   client_ctgry_mstr_mak       clicmm   with(nolock)
    WHERE  clicmm.clicm_deleted_ind IN (0, 4, 6)
    AND    clicmm.clicm_created_by   = @PA_LOGIN_NAME
    AND    clicm_bit & power(2,@l-1) > 0
  --
  END
  ELSE IF @PA_ACTION = 'CLICM_SEARCHC'
  BEGIN
  --
    SELECT DISTINCT clicmm.clicm_cd    clicm_cd
           ,clicmm.clicm_desc         clicm_desc         
           ,clicmm.clicm_id            clicm_id
           
    FROM   client_ctgry_mstr_mak       clicmm   with(nolock)
    WHERE  clicmm.clicm_deleted_ind IN (0, 4, 6)
    AND    clicmm.clicm_created_by  <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'CLICM_SEL'
  BEGIN
  --
    select @l = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd  = 'bus_' + isnull(@pa_id,'')
    SELECT ENTTM.ENTTM_ID            CLICM_ENTTM_ID
         , CLICM.CLICM_CD            CLICM_CD
         , CLICM.CLICM_DESC          CLICM_DESC
         , CLICM.CLICM_ID            CLICM_ID
         , ''                        ERRMSG
         , CLICM_DELETED_IND         CLICM_DELETED_IND
         , ISNULL(citrus_usr.fn_get_clicm_bit(clicm.clicm_id,1,0),'')  busm_dtlsid
         , ISNULL(citrus_usr.fn_get_clicm_bit(clicm.clicm_id,2,0),'')  busm_dtls 
         , CLICM_RMKS                CLICM_RMKS
         , ENTTM.ENTTM_DESC          CLICM_ENTTM_DESC
    FROM   CLIENT_CTGRY_MSTR         CLICM WITH(NOLOCK)
         , ENTITY_TYPE_MSTR          ENTTM WITH(NOLOCK)
         , ENTTM_CLICM_MAPPING       ENTCM WITH(NOLOCK)
    WHERE  CLICM.CLICM_ID          = ENTCM.ENTCM_CLICM_ID
    AND    ENTTM.ENTTM_ID          = ENTCM.ENTCM_ENTTM_ID
    AND    CLICM.CLICM_DELETED_IND = 1
    AND    ENTTM.ENTTM_DELETED_IND = 1
    AND    ENTCM.ENTCM_DELETED_IND = 1
    AND    CLICM.CLICM_CD   LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD   END
    AND    CLICM.CLICM_DESC LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
    AND clicm_bit & power(2,@l-1) > 0
  --
  END
  ELSE IF @PA_ACTION = 'CLICM_SELM'
  BEGIN
  --
    select @l = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd  = 'bus_' + isnull(@pa_id,'')
    SELECT CLICM_ID                  CLICM_ID
         , CLICM_CD                  CLICM_CD
         , CLICM_DESC                CLICM_DESC
         , CLICM_ENTTM_ID            CLICM_ENTTM_ID
         , ISNULL(citrus_usr.fn_get_clicm_bit(clicmm.clicm_id,1,1),'')  busm_dtlsid
         , ISNULL(citrus_usr.fn_get_clicm_bit(clicmm.clicm_id,2,1),'')  busm_dtls 
         , CLICM_RMKS                CLICM_RMKS
         , ''                        ERRMSG
         , ENTTM.ENTTM_DESC          CLICM_ENTTM_DESC
    FROM   CLIENT_CTGRY_MSTR_MAK     CLICMM WITH(NOLOCK)
         , ENTITY_TYPE_MSTR          ENTTM  WITH(NOLOCK)
    WHERE  CLICM_DELETED_IND      =  0
    AND    CLICMM.CLICM_ENTTM_ID  =  ENTTM.ENTTM_ID
    AND    CLICM_CREATED_BY       =  @PA_LOGIN_NAME
    AND    CLICMM.CLICM_CD   LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    CLICMM.CLICM_DESC LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
    AND clicm_bit & power(2,@l-1) > 0
  --
  END
  ELSE IF @PA_ACTION = 'CLICM_SELC'
  BEGIN
  --
    SELECT CLICM_ID           CLICM_ID
         , CLICM_CD           CLICM_CD
         , CLICM_DESC         CLICM_DESC
         , CLICM_ENTTM_ID     CLICM_ENTTM_ID
         , ISNULL(citrus_usr.fn_get_clicm_bit(clicmm.clicm_id,1,1),'')  busm_dtlsid
         , ISNULL(citrus_usr.fn_get_clicm_bit(clicmm.clicm_id,2,1),'')  busm_dtls 
         , CLICM_RMKS         CLICM_RMKS
         , '' AS              ERRMSG
         , CLICM_DELETED_IND  CLICM_DELETED_IND
         , ENTTM.ENTTM_DESC   CLICM_ENTTM_DESC
    FROM   CLIENT_CTGRY_MSTR_MAK  CLICMM WITH (NOLOCK)
         , ENTITY_TYPE_MSTR       ENTTM  WITH (NOLOCK)
    WHERE  CLICMM.CLICM_ENTTM_ID = ENTTM.ENTTM_ID
    AND    CLICM_DELETED_IND IN (0,4,6)
    AND    CLICM_lst_upd_by <> @PA_LOGIN_NAME
    AND    CLICMM.CLICM_CD   LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    CLICMM.CLICM_DESC LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
    order by clicm_cd 
  --
  END
  ELSE IF @PA_ACTION = 'SUBCLM_SEARCH'
  BEGIN
  --
    SELECT DISTINCT subcm.subcm_cd   subcm_cd
           ,subcm.subcm_desc         subcm_desc         
           ,subcm.subcm_id           subcm_id
    FROM   sub_ctgry_mstr            subcm   with(nolock)
    WHERE  subcm.subcm_deleted_ind = 1
  --
  END
  ELSE IF @PA_ACTION = 'SUBCLM_SEARCHM'
  BEGIN
  --
    SELECT DISTINCT subcmm.subcm_cd    subcm_cd
          ,subcmm.subcm_desc           subcm_desc         
          ,subcmm.subcm_id             subcm_id
    FROM   sub_ctgry_mstr_mak          subcmm   with(nolock)
    WHERE  subcmm.subcm_deleted_ind IN (0, 4, 6)
    AND    subcmm.subcm_created_by   = @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'SUBCLM_SEARCHC'
  BEGIN
  --
    SELECT DISTINCT subcmm.subcm_cd    subcm_cd
           ,subcmm.subcm_desc          subcm_desc         
           ,subcmm.subcm_id            subcm_id
    FROM   sub_ctgry_mstr_mak          subcmm   with(nolock)
    WHERE  subcmm.subcm_deleted_ind IN (0, 4, 6)
    AND    subcmm.subcm_created_by  <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'SUBCLM_SEL'
  BEGIN
  --
    SELECT SUBCM.SUBCM_CLICM_ID      CLICM_ID
         , CLICM.CLICM_DESC          CLICM_DESC
         , SUBCM.SUBCM_CD            SUBCM_CD
         , SUBCM.SUBCM_DESC          SUBCM_DESC
         , SUBCM.SUBCM_ID            SUBCM_ID
         , ''                        ERRMSG
         , SUBCM_DELETED_IND         SUBCM_DELETED_IND
         , SUBCM_RMKS                SUBCM_RMKS
    FROM   SUB_CTGRY_MSTR            SUBCM WITH(NOLOCK)
         , CLIENT_CTGRY_MSTR         CLICM WITH(NOLOCK)
    WHERE  SUBCM.SUBCM_DELETED_IND = 1
    AND    CLICM.CLICM_ID          = SUBCM.SUBCM_CLICM_ID
    AND    SUBCM.SUBCM_CD   LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD   END
    AND    SUBCM.SUBCM_DESC LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
  --
  END
  ELSE IF @PA_ACTION = 'SUBCLM_SELM'
  BEGIN
  --
    SELECT SUBCM.SUBCM_CLICM_ID          CLICM_ID
         , SUBCM.SUBCM_CD                SUBCM_CD
         , SUBCM.SUBCM_DESC              SUBCM_DESC
         , SUBCM.SUBCM_ID                SUBCM_ID
         , ''                            ERRMSG
         , SUBCM_DELETED_IND             SUBCM_DELETED_IND
         , SUBCM_RMKS                    SUBCM_RMKS
    FROM   SUB_CTGRY_MSTR_MAK            SUBCM WITH(NOLOCK)
         , CLIENT_CTGRY_MSTR             CLICM WITH(NOLOCK)
    WHERE  SUBCM.SUBCM_DELETED_IND       IN(0,4,6)
    AND    CLICM.CLICM_ID                = SUBCM.SUBCM_CLICM_ID
    AND    SUBCM.SUBCM_CD   LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD   END
    AND    SUBCM.SUBCM_DESC LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
  --
  END
  ELSE IF @PA_ACTION = 'SUBCLM_SELC'
  BEGIN
  --
    SELECT SUBCM.SUBCM_CLICM_ID          CLICM_ID
         , SUBCM.SUBCM_CD                SUBCM_CD
         , SUBCM.SUBCM_DESC              SUBCM_DESC
         , SUBCM.SUBCM_ID                SUBCM_ID
         , ''                            ERRMSG
         , SUBCM_DELETED_IND             SUBCM_DELETED_IND
         , SUBCM_RMKS                    SUBCM_RMKS
    FROM   SUB_CTGRY_MSTR_MAK            SUBCM WITH(NOLOCK)
         , CLIENT_CTGRY_MSTR             CLICM WITH(NOLOCK)
    WHERE  SUBCM.SUBCM_DELETED_IND       IN(0,4,6)
    AND    CLICM.CLICM_ID                = SUBCM.SUBCM_CLICM_ID
    AND    SUBCM.SUBCM_CD   LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD   END
    AND    SUBCM.SUBCM_DESC LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
    AND    SUBCM.SUBCM_LST_UPD_BY <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'BANM_SEARCH'
  BEGIN
  --
    SELECT DISTINCT banm.banm_name banm_name
    
    FROM   bank_mstr               banm   with(nolock)
    WHERE  banm.banm_deleted_ind = 1
    ORDER BY  banm.banm_name
  --
  END
  ELSE IF @PA_ACTION = 'BANM_SEARCHM' 
  BEGIN
  --
    SELECT DISTINCT banmm.banm_name   banm_name
    FROM   bank_mstr_mak              banmm   with(nolock)
    WHERE  banmm.banm_deleted_ind IN (0, 4, 6)
    AND    banmm.banm_created_by   = @PA_LOGIN_NAME
    ORDER BY  banmm.banm_name
  --
  END
  ELSE IF @PA_ACTION = 'BANM_SEARCHC'
  BEGIN
  --
    SELECT DISTINCT banmm.banm_name   banm_name
    FROM   bank_mstr_mak              banmm   with(nolock)
    WHERE  banmm.banm_deleted_ind IN (0, 4, 6)
    AND    banmm.banm_created_by  <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'BANM_SEL'
  BEGIN
  --
    SELECT banm.banm_id               banm_id
         , banm.banm_name             banm_name
         , banm.banm_branch           banm_branch
         , banm.banm_micr             banm_micr
         , banm.banm_rtgs_cd          banm_rtgs_cd
         , banm.banm_payloc_cd        banm_payloc_cd 
         , banm.banm_rmks             banm_rmks
         , ''                         address
         , ''                         contact
         , ''                         errmsg
         
    FROM   bank_mstr                  banm   with(nolock)
    WHERE  banm.banm_deleted_ind    = 1 
    AND    banm.banm_name        LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD + '%' END
    AND    banm.banm_branch      LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC + '%' END
    AND    convert(varchar,banm.banm_micr)      LIKE CASE WHEN LTRIM(RTRIM(@PA_rmks)) = '' THEN '%' ELSE @PA_rmks + '%' END
    ORDER BY  banm_name,banm_branch
  --
  END
  ELSE IF @PA_ACTION = 'BANM_SELM' 
  BEGIN
  --
    SELECT banmm.banm_id               banm_id
         , banmm.banm_name             banm_name
         , banmm.banm_branch           banm_branch
         , banmm.banm_micr             banm_micr
         , banmm.banm_rtgs_cd          banm_rtgs_cd
         , banmm.banm_payloc_cd        banm_payloc_cd
         , banmm.banm_rmks             banm_rmks
         , ''                          address
         , ''                          contact
         , ''                          errmsg
         
    FROM   bank_mstr_mak               banmm   with(nolock)
    WHERE  banmm.banm_deleted_ind   IN (0, 4, 6)
    AND    banmm.banm_branch      LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
    AND    banmm.banm_name        LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    convert(varchar,banmm.banm_micr)      LIKE CASE WHEN LTRIM(RTRIM(@PA_rmks)) = '' THEN '%' ELSE @PA_rmks + '%' END
    AND    banmm.banm_created_by     = @PA_LOGIN_NAME
    ORDER BY  banm_name,banm_branch

  --
  END
  ELSE IF @PA_ACTION = 'BANM_SELC'
  BEGIN
  --
    SELECT banmm.banm_id               banm_id
         , banmm.banm_name             banm_name
         , banmm.banm_branch           banm_branch
         , banmm.banm_micr             banm_micr
         , banmm.banm_rtgs_cd          banm_rtgs_cd
         , banmm.banm_payloc_cd        banm_payloc_cd
         , banmm.banm_rmks             banm_rmks
         , ''                          address
         , ''                          contact
         , ''                          errmsg
        
    FROM   bank_mstr_mak               banmm   with(nolock)
    WHERE  banmm.banm_deleted_ind   IN (0, 4, 6)
    AND    banmm.banm_branch      LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
    AND    banmm.banm_name        LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    banmm.banm_lst_upd_by    <> @PA_LOGIN_NAME
    ORDER BY  banm_name,banm_branch
  --
  END
  ELSE IF @PA_ACTION = 'DPM_SEARCH'
  BEGIN
  --
    SELECT DISTINCT dpm.dpm_name   dpm_name
         , dpm.dpm_dpid            dpm_dpid
    FROM   dp_mstr                 dpm   with(nolock)
         , exch_seg_mstr           excsm with(nolock)
    WHERE  dpm.dpm_deleted_ind   = 1
    AND    excsm.excsm_id        = dpm.dpm_excsm_id
  --
  END
  ELSE IF @PA_ACTION = 'DPM_SEARCHM' 
  BEGIN
  --
    SELECT DISTINCT dpmm.dpm_name    dpm_name
         , dpmm.dpm_dpid             dpm_dpid
    FROM   dp_mstr_mak               dpmm   with(nolock)
         , exch_seg_mstr             excsm   with(nolock)
    WHERE  dpmm.dpm_deleted_ind   IN (0, 4, 6)
    AND    dpmm.dpm_created_by     = @PA_LOGIN_NAME
    AND    excsm.excsm_id            = dpmm.dpm_excsm_id
  --
  END
  ELSE IF @PA_ACTION = 'DPM_SEARCHC'
  BEGIN
  --
    SELECT DISTINCT dpmm.dpm_name   dpm_name
         , dpmm.dpm_dpid            dpm_dpid
    FROM   dp_mstr_mak              dpmm   with(nolock)
         , exch_seg_mstr            excsm  with(nolock) 
    WHERE  dpmm.dpm_deleted_ind IN (0, 4, 6)
    AND    dpmm.dpm_created_by  <> @PA_LOGIN_NAME
    AND    excsm.excsm_id            = dpmm.dpm_excsm_id
  --
  END
  ELSE IF @PA_ACTION = 'DPM_SEL'
  BEGIN
  --
    SELECT dpm.dpm_id               dpm_id
         , dpm.dpm_name             dpm_name
         , dpm.dpm_dpid             dpm_dpid
         , excsm.excsm_id           excsm_id  
         , excsm.excsm_exch_cd      excsm_cd  
         , dpm.dpm_rmks             dpm_rmks
         , dpm.dpm_short_name       dpm_short_name
         , ''                       address
         , ''                       contact
         , ''                       errmsg
    FROM   dp_mstr                  dpm   with(nolock)
         , exch_seg_mstr            excsm with(nolock)
    WHERE  dpm.dpm_deleted_ind      = 1
    AND    excsm.excsm_deleted_ind   = 1
    AND    excsm.excsm_id           = dpm.dpm_excsm_id
    AND    dpm.dpm_dpid             LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD+'%' END
    AND    dpm.dpm_name             LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
  --
  END
  ELSE IF @PA_ACTION = 'DPM_SELM'
  BEGIN
  --
    SELECT dpmm.dpm_id               dpm_id
         , dpmm.dpm_name             dpm_name
         , dpmm.dpm_dpid             dpm_dpid
         , excsm.excsm_id           excsm_id  
         , excsm.excsm_exch_cd      excsm_cd  
         , dpmm.dpm_rmks             dpm_rmks
         , dpmm.dpm_short_name       dpm_short_name
         , ''                        address
         , ''                        contact
         , ''                        errmsg
    FROM   dp_mstr_mak               dpmm    with(nolock)
         , exch_seg_mstr             excsm   with(nolock)
    WHERE  dpmm.dpm_deleted_ind      IN (0, 4, 6)
    AND    excsm.excsm_deleted_ind   = 1
    AND    excsm.excsm_id          = dpmm.dpm_excsm_id
    AND    dpmm.dpm_name             LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
    AND    dpmm.dpm_dpid             LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    dpmm.dpm_created_by     = @pa_login_name
  --
  END
  ELSE IF @PA_ACTION = 'DPM_SELC'
  BEGIN
  --
    SELECT dpmm.dpm_id               dpm_id
         , dpmm.dpm_name             dpm_name
         , dpmm.dpm_dpid             dpm_dpid
         , excsm.excsm_id           excsm_id  
         , excsm.excsm_exch_cd      excsm_cd  
         , dpmm.dpm_rmks             dpm_rmks
         , dpmm.dpm_short_name        dpm_short_name
         , ''                        address
         , ''                        contact
         , ''                        errmsg
    FROM   dp_mstr_mak               dpmm    with(nolock)
         , exch_seg_mstr             excsm   with(nolock)
    WHERE  dpmm.dpm_deleted_ind      IN (0, 4, 6)
    AND    excsm.excsm_deleted_ind   = 1
    AND    excsm.excsm_id            = dpmm.dpm_excsm_id
    AND    dpmm.dpm_name             LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
    AND    dpmm.dpm_dpid             LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    dpmm.dpm_lst_upd_by    <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'COMPM_SEARCH'
  BEGIN
  --
    SELECT DISTINCT compm.compm_name1   compm_name1
         , compm.compm_id               compm_id
    FROM   company_mstr                 compm   with(nolock)
    WHERE  compm.compm_deleted_ind    = 1
  --
  END
  ELSE IF @PA_ACTION = 'COMPM_SEARCHM'
  BEGIN
  --
    SELECT DISTINCT compmm.compm_name1   compm_name1
         , compmm.compm_id               compm_id
    FROM   company_mstr_mak              compmm   with(nolock)
    WHERE  compmm.compm_deleted_ind   IN (0, 4, 6)
    AND    compmm.compm_created_by     = @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'COMPM_SEARCHC'
  BEGIN
  --
    SELECT DISTINCT compmm.compm_name1   compm_name1
         , compmm.compm_id               compm_id
    FROM   company_mstr_mak              compmm   with(nolock)
    WHERE  compmm.compm_deleted_ind   IN (0, 4, 6)
    AND    compmm.compm_created_by    <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'COMPM_SEL'
  BEGIN
  --
    SELECT compm.compm_name1                        compm_name1
         , ISNULL(compm.compm_short_name,'')        compm_short_name
         , ISNULL(compm.compm_type,'')              compm_type
         , ISNULL(compm_nsecm_mem_cd,'')            compm_nsecm_mem_cd
									, ISNULL(compm_nsefo_mem_cd,'')            compm_nsefo_mem_cd
									, ISNULL(compm_bsecm_mem_cd,'')            compm_bsecm_mem_cd
									, ISNULL(compm_bsefo_mem_cd,'')            compm_bsefo_mem_cd
									, ISNULL(compm_ncdex_mem_cd,'')            compm_ncdex_mem_cd
									, ISNULL(compm_mcx_mem_cd ,'')             compm_mcx_mem_cd  
									, ISNULL(compm_dgcx_mem_cd ,'')            compm_dgcx_mem_cd 
									, ISNULL(compm_nmc_mem_cd ,'')             compm_nmc_mem_cd 
									, ISNULL(compm_nsdl_dpid ,'')              compm_nsdl_dpid 
         , ISNULL(compm_cdsl_dpid ,'')              compm_cdsl_dpid 
         , ISNULL(compm.compm_sebi_reg_no,0)        compm_sebi_reg_no
         , ISNULL(compm.compm_sertax_regno,0)       compm_sertax_regno
         , ISNULL(compm.compm_pan_no,0)             compm_pan_no
         
         , ISNULL(compm.compm_rmks, '')             compm_rmks
    FROM   company_mstr                             compm   with(nolock)
    WHERE  compm.compm_deleted_ind                = 1
    AND    compm.compm_id                         LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
  --
  END
  ELSE IF @PA_ACTION = 'COMPM_SELM'
  BEGIN
  --
    SELECT compmm.compm_name1                        compm_name1
         , ISNULL(compmm.compm_short_name,'')        compm_short_name
         , ISNULL(compmm.compm_type,'')              compm_type
         , ISNULL(compm_nsecm_mem_cd,'')            compm_nsecm_mem_cd
									, ISNULL(compm_nsefo_mem_cd,'')            compm_nsefo_mem_cd
									, ISNULL(compm_bsecm_mem_cd,'')            compm_bsecm_mem_cd
									, ISNULL(compm_bsefo_mem_cd,'')            compm_bsefo_mem_cd
									, ISNULL(compm_ncdex_mem_cd,'')            compm_ncdex_mem_cd
									, ISNULL(compm_mcx_mem_cd ,'')             compm_mcx_mem_cd  
									, ISNULL(compm_dgcx_mem_cd ,'')            compm_dgcx_mem_cd 
									, ISNULL(compm_nmc_mem_cd ,'')             compm_nmc_mem_cd 
									, ISNULL(compm_nsdl_dpid ,'')              compm_nsdl_dpid 
         , ISNULL(compm_cdsl_dpid ,'')              compm_cdsl_dpid 
         , ISNULL(compmm.compm_sebi_reg_no,0)        compm_sebi_reg_no
         , ISNULL(compmm.compm_sertax_regno,0)       compm_sertax_regno
         , ISNULL(compmm.compm_pan_no,0)             compm_pan_no
         
         , ISNULL(compmm.compm_rmks, '')             compm_rmks
    FROM   company_mstr_mak                          compmm   with(nolock)
    WHERE  compmm.compm_deleted_ind               IN (0, 4, 6)
    AND    compmm.compm_id                        LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    compmm.compm_created_by                = @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'COMPM_SELC'
  BEGIN
  --
    SELECT compmm.compm_name1                        compm_name1
         , ISNULL(compmm.compm_short_name,'')        compm_short_name
         , ISNULL(compmm.compm_type,'')              compm_type
         , ISNULL(compm_nsecm_mem_cd,'')            compm_nsecm_mem_cd
									, ISNULL(compm_nsefo_mem_cd,'')            compm_nsefo_mem_cd
									, ISNULL(compm_bsecm_mem_cd,'')            compm_bsecm_mem_cd
									, ISNULL(compm_bsefo_mem_cd,'')            compm_bsefo_mem_cd
									, ISNULL(compm_ncdex_mem_cd,'')            compm_ncdex_mem_cd
									, ISNULL(compm_mcx_mem_cd ,'')             compm_mcx_mem_cd  
									, ISNULL(compm_dgcx_mem_cd ,'')            compm_dgcx_mem_cd 
									, ISNULL(compm_nmc_mem_cd ,'')             compm_nmc_mem_cd 
									, ISNULL(compm_nsdl_dpid ,'')              compm_nsdl_dpid 
         , ISNULL(compm_cdsl_dpid ,'')              compm_cdsl_dpid 
         , ISNULL(compmm.compm_sebi_reg_no,0)        compm_sebi_reg_no
         , ISNULL(compmm.compm_sertax_regno,0)       compm_sertax_regno
         , ISNULL(compmm.compm_pan_no,0)             compm_pan_no
         
         , ISNULL(compmm.compm_rmks, '')             compm_rmks
         , compmm.compm_id
    FROM   company_mstr_mak                          compmm   with(nolock)
    WHERE  compmm.compm_deleted_ind               IN (0, 4, 6)
    AND    compmm.compm_id                        LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    compmm.compm_lst_upd_by                <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'DPTM_SEARCH'
  BEGIN
  --
    SELECT DISTINCT dptm.dptm_cd   dptm_cd
          ,dptm.dptm_desc          dptm_desc
    FROM   dp_type_mstr            dptm   with(nolock)
    WHERE  dptm.dptm_deleted_ind = 1
  --
  END
  ELSE IF @PA_ACTION = 'DPTM_SEARCHM'
  BEGIN
  --
    SELECT DISTINCT dptmm.dptm_cd    dptm_cd
          ,dptmm.dptm_desc           dptm_desc
    FROM   dp_type_mstr_mak          dptmm   with(nolock)
    WHERE  dptmm.dptm_deleted_ind IN (0, 4, 6)
    AND    dptmm.dptm_created_by   = @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'DPTM_SEARCHC'
  BEGIN
  --
    SELECT DISTINCT dptmm.dptm_cd    dptm_cd
          ,dptmm.dptm_desc           dptm_desc
    FROM   dp_type_mstr_mak          dptmm   with(nolock)
    WHERE  dptmm.dptm_deleted_ind IN (0, 4, 6)
    AND    dptmm.dptm_created_by  <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'DPTM_SEL'
  BEGIN
  --
    SELECT dptm.dptm_id               dptm_id
         , dptm.dptm_cd               dptm_cd
         , dptm.dptm_desc             dptm_desc
         , dptm.dptm_rmks             dptm_rmks
         , ''                         errmsg
    FROM   dp_type_mstr               dptm   with(nolock)
    WHERE  dptm.dptm_deleted_ind    = 1
    AND    dptm.dptm_cd           LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    dptm.dptm_desc         LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
  --
  END
  ELSE IF @PA_ACTION = 'DPTM_SELM' 
  BEGIN
  --
    SELECT dptmm.dptm_id               dptm_id
         , dptmm.dptm_cd               dptm_cd
         , dptmm.dptm_desc             dptm_desc
         , dptmm.dptm_rmks             dptm_rmks
         , ''                          errmsg
    FROM   dp_type_mstr_mak            dptmm   with(nolock)
    WHERE  dptmm.dptm_deleted_ind   IN (0, 4, 6)
    AND    dptmm.dptm_cd           LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    dptmm.dptm_desc         LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
    AND    dptmm.dptm_created_by     = @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'DPTM_SELC'
  BEGIN
  --
    SELECT dptmm.dptm_id               dptm_id
         , dptmm.dptm_cd               dptm_cd
         , dptmm.dptm_desc             dptm_desc
         , dptmm.dptm_rmks             dptm_rmks
         , ''                          errmsg
    FROM   dp_type_mstr_mak            dptmm   with(nolock)
    WHERE  dptmm.dptm_deleted_ind   IN (0, 4, 6)
    AND    dptmm.dptm_cd           LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    dptmm.dptm_desc         LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
    AND    dptmm.dptm_lst_upd_by    <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'EXCSM_SEARCH'
  BEGIN
  --
    SELECT DISTINCT excsm.excsm_exch_cd   excsm_exch_cd
    FROM   exch_seg_mstr                  excsm   with(nolock)
    WHERE  excsm.excsm_deleted_ind      = 1
  --
  END
  ELSE IF @PA_ACTION = 'EXCSM_SEARCHM'
  BEGIN
  --
    SELECT DISTINCT excsmm.excsm_exch_cd    excsm_exch_cd
    FROM   exch_seg_mstr_mak                excsmm   with(nolock)
    WHERE  excsmm.excsm_deleted_ind      IN (0, 4, 6)
    AND    excsmm.excsm_created_by        = @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'EXCSM_SEARCHC'
  BEGIN
  --
    SELECT DISTINCT excsmm.excsm_exch_cd    excsm_exch_cd
    FROM   exch_seg_mstr_mak                excsmm   with(nolock)
    WHERE  excsmm.excsm_deleted_ind      IN (0, 4, 6)
    AND    excsmm.excsm_created_by       <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @pa_action = 'EXCSM_SEL'
  BEGIN
  --
    SELECT excsm.excsm_id                 excsm_id
         , excsm.excsm_exch_cd            excsm_exch_cd
         , excsm.excsm_seg_cd             excsm_seg_cd
         , excsm.excsm_sub_seg_cd         excsm_sub_seg_cd
         , excsm.excsm_rmks               remarks
         , excm.excm_short_name           excm_short_name
         , excm.excm_desc                 excm_desc
         --, isnull(citrus_usr.fn_get_excsm_bit(excsm.excsm_id,1,1),'')  busm_dtlsid
         --, isnull(citrus_usr.fn_get_excsm_bit(excsm.excsm_id,2,1),'')  busm_dtls 
         , ISNULL((SELECT TOP 1 excsm_exch_cd + '_' + excsm_seg_cd + '_' + excsm_sub_seg_cd  
                   FROM   exch_seg_mstr e WITH (NOLOCK)  
                   WHERE  e.excsm_id = excsm.excsm_parent_id),'') excsm_desc  
         ,excsm.excsm_parent_id,excsm_compm_id,'' as errmsg  
         ,excsm.excsm_exch_cd + '_' + excsm.excsm_seg_cd + '_' + excsm.excsm_sub_seg_cd excsm_parent_desc  
    FROM  exch_seg_mstr               excsm WITH (NOLOCK)  
         ,exchange_mstr              excm  WITH (NOLOCK)
    WHERE excm.excm_cd              = excsm.excsm_exch_cd
    AND   excsm_deleted_ind         = 1  
    AND   excm_deleted_ind          = 1  
    AND   excsm.excsm_exch_cd         LIKE CASE WHEN LTRIM(RTRIM(@pa_cd))   = '' THEN '%' ELSE @pa_cd END
    AND   excsm.excsm_seg_cd          LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @pa_desc + '%' END
    ORDER BY excsm_id  
    --
  --
  END
  ELSE IF @PA_ACTION = 'EXCSM_SELM'
  BEGIN
  --
    SELECT excsmm.excsm_id                   excsm_id
         , excsmm.excsm_exch_cd              excsm_exch_cd
         , excsmm.excsm_seg_cd               excsm_seg_cd
         , excsmm.excsm_sub_seg_cd           excsm_sub_seg_cd
         , ISNULL(excsmm.excsm_parent_id, 0) excsm_parent_id
         , excsmm.excsm_compm_id             excsm_compm_id
         , excmm.excm_short_name              excm_short_name
         , excmm.excm_desc                    excm_desc
         --, ISNULL(citrus_usr.fn_get_excsm_bit(excsmm.excsm_id,1,1),'')  busm_dtlsid
         --, ISNULL(citrus_usr.fn_get_excsm_bit(excsmm.excsm_id,2,1),'')  busm_dtls 
         , excsmm.excsm_exch_cd+'_'+excsmm.excsm_seg_cd+'_'+excsmm.excsm_sub_seg_cd   excsm_desc
         , a.excsm_desc                      parent_desc
         , excsmm.excsm_rmks                 remarks
         , ''                                errmsg
    FROM   exch_seg_mstr_mak                 excsmm   with(nolock)
         ,(SELECT excsm.excsm_id             excsm_id
                , excsm.excsm_desc           excsm_desc
           FROM   exch_seg_mstr              excsm   with(nolock)
           WHERE  excsm.excsm_deleted_ind  = 0
          ) a
          , excm_mak                          excmm
    WHERE  excsmm.excsm_parent_id           = a.excsm_id
    AND    excmm.excm_cd                    = excsmm.excsm_exch_cd
    AND    excsmm.excsm_deleted_ind       IN (0, 4, 6)
    AND    excmm.excm_deleted_ind         IN (0, 4, 6)
    AND    excsmm.excsm_exch_cd         LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    excsmm.excsm_seg_cd          LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC + '%' END
    AND    excsmm.excsm_lst_upd_by        = @PA_LOGIN_NAME
    ORDER  BY excsmm.excsm_id;
  --
  END
  ELSE IF @PA_ACTION = 'EXCSM_SELC'
  BEGIN
  --
    SELECT excsmm.excsm_id                   excsm_id
         , excsmm.excsm_exch_cd              excsm_exch_cd
         , excsmm.excsm_seg_cd               excsm_seg_cd
         , excsmm.excsm_sub_seg_cd           excsm_sub_seg_cd
         , ISNULL(excsmm.excsm_parent_id, 0) excsm_parent_id
         , excsmm.excsm_compm_id             excsm_compm_id
         , excmm.excm_short_name              excm_short_name
         , excmm.excm_desc                    excm_desc
         --, ISNULL(citrus_usr.fn_get_excsm_bit(excsmm.excsm_id,1,1),'')  busm_dtlsid
         --, ISNULL(citrus_usr.fn_get_excsm_bit(excsmm.excsm_id,2,1),'')  busm_dtls 
         , excsmm.excsm_exch_cd+'_'+excsmm.excsm_seg_cd+'_'+excsmm.excsm_sub_seg_cd   excsm_desc
         , a.excsm_desc                      parent_desc
         , excsmm.excsm_rmks                 remarks
         , ''                                errmsg
    FROM   exch_seg_mstr_mak                 excsmm    with(nolock)
         ,(SELECT excsm.excsm_id             excsm_id
                , excsm.excsm_desc           excsm_desc
           FROM   exch_seg_mstr              excsm    with(nolock)
           WHERE  excsm.excsm_deleted_ind  = 0
          ) a
          , excm_mak                          excmm
    WHERE  excsmm.excsm_parent_id          = a.excsm_id
    AND    excmm.excm_cd                    = excsmm.excsm_exch_cd
    AND    excsmm.excsm_deleted_ind       IN (0, 4, 6)
    AND    excmm.excm_deleted_ind         IN (0, 4, 6)
    AND    excsmm.excsm_exch_cd         LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    excsmm.excsm_seg_cd          LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC + '%' END
    AND    excsmm.excsm_lst_upd_by        <> @PA_LOGIN_NAME
    ORDER  BY excsmm.excsm_id
  --
  END
  ELSE IF @PA_ACTION = 'CONCM_SEARCH'
  BEGIN
  --
    SELECT DISTINCT concm.concm_cd   concm_cd
          ,concm.concm_desc          concm_desc
    FROM   conc_code_mstr            concm    with(nolock)
    WHERE  concm.concm_deleted_ind = 1
    AND    (CASE concm.concm_cli_yn&2 WHEN 2 THEN 'C'
                                      WHEN 0 THEN 'A' END) LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC END                       
  --
  END
  ELSE IF @PA_ACTION = 'CONCM_SEARCHM'
  BEGIN
  --
    SELECT DISTINCT concmm.concm_cd    concm_cd
          ,concmm.concm_desc           concm_desc
    FROM   conc_code_mstr_mak          concmm    with(nolock)
    WHERE  concmm.concm_deleted_ind IN (0, 4, 6)
    AND    concmm.concm_created_by   = @PA_LOGIN_NAME
    AND    (CASE concmm.concm_cli_yn&2 WHEN 2 THEN 'C'
                                      WHEN 0 THEN 'A' END) LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC END                       
  --
  END
  ELSE IF @PA_ACTION = 'CONCM_SEARCHC'
  BEGIN
  --
    SELECT DISTINCT concmm.concm_cd    concm_cd
          ,concmm.concm_desc           concm_desc
    FROM   conc_code_mstr_mak          concmm   with(nolock)
    WHERE  concmm.concm_deleted_ind IN (0, 4, 6)
    AND    concmm.concm_created_by  <> @PA_LOGIN_NAME
    AND    (CASE concmm.concm_cli_yn&2 WHEN 2 THEN 'C'
                                      WHEN 0 THEN 'A' END) LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC END                       
  --
  END
  ELSE IF @PA_ACTION = 'CONCM_SEL'
  BEGIN
  --
    SELECT concm.concm_id                                              concm_id
         , concm.concm_cd                                              concm_cd
         , concm.concm_desc                                            concm_desc
         , concm.concm_cli_yn & 1                                      concm_cli_yn
         , CASE concm.concm_cli_yn & 2  WHEN 2 THEN 'C' 
                                        WHEN 0 THEN 'A' END             concm_cli
         , ISNULL(citrus_usr.fn_get_concm_bit(concm.concm_id,1,0),'')  busm_dtlsid
         , ISNULL(citrus_usr.fn_get_concm_bit(concm.concm_id,2,0),'')  busm_dtls 
         , ISNULL(concm.concm_rmks,'')                                  remarks
         , ''                                                           errmsg
    FROM   conc_code_mstr                         concm   WITH(NOLOCK)
    WHERE  concm.concm_deleted_ind               = 1
    AND    concm.concm_cd                        LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    (CASE concm.concm_cli_yn&2 WHEN 2 THEN 'C'
                                                WHEN 0 THEN 'A' END) LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC END                       
    ORDER BY CASE WHEN ISNUMERIC(concm.concm_rmks) = 0 THEN 10000 ELSE CONVERT(NUMERIC, concm.concm_rmks) END 
            ,4
            ,concm.concm_cd
  --
  END
  ELSE IF @PA_ACTION = 'CONCM_SELM'
  BEGIN
  --
    SELECT concmm.concm_id                           concm_id
         , concmm.concm_cd                           concm_cd
         , concmm.concm_desc                         concm_desc
         , (concmm.concm_cli_yn&1)                   concm_cli_yn
         , CASE concmm.concm_cli_yn & 2 WHEN 2 THEN 'C' 
                                        WHEN 0 THEN 'A' END   concm_cli
         , ISNULL(citrus_usr.fn_get_concm_bit(concmm.concm_id,1,1),'')  busm_dtlsid
         , ISNULL(citrus_usr.fn_get_concm_bit(concmm.concm_id,2,1),'')  busm_dtls 
         , isnull(concmm.concm_rmks,'')              remarks
         , ''                                        errmsg
    FROM   conc_code_mstr_mak                        concmm   with(nolock)
    WHERE  concmm.concm_deleted_ind               IN (0, 4, 6)
    AND    concmm.concm_cd                        LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    (CASE (concmm.concm_cli_yn&2) WHEN 2 THEN 'C'
                                                WHEN 0 THEN 'A' END) LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC END                       
    AND    concmm.concm_created_by                = @PA_LOGIN_NAME
    ORDER BY CASE WHEN ISNUMERIC(concmm.concm_rmks) = 0 THEN 10000 ELSE CONVERT(NUMERIC, concmm.concm_rmks) END
            ,4
            , concmm.concm_cd
  --
  END
  ELSE IF @PA_ACTION = 'CONCM_SELC'
  BEGIN
  --
    SELECT concmm.concm_id                                              concm_id
         , concmm.concm_cd                                              concm_cd
         , concmm.concm_desc                                            concm_desc
         , (concmm.concm_cli_yn&1)                                      concm_cli_yn
         , CASE concmm.concm_cli_yn & 2  WHEN 2 THEN 'C' 
                                         WHEN 0 THEN 'A' END            concm_cli
         , ISNULL(citrus_usr.fn_get_concm_bit(concmm.concm_id,1,1),'')  busm_dtlsid
         , ISNULL(citrus_usr.fn_get_concm_bit(concmm.concm_id,2,1),'')  busm_dtls 
         , isnull(concmm.concm_rmks,'')                                 remarks
         , ''                                                           errmsg
    FROM   conc_code_mstr_mak                        concmm   with(nolock)
    WHERE  concmm.concm_deleted_ind               IN (0, 4, 6)
    AND    concmm.concm_cd                      LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    (CASE (concmm.concm_cli_yn&2) WHEN 2 THEN 'C'
                                                WHEN 0 THEN 'A' END) LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC END                       
    AND    concmm.concm_lst_upd_by              <>@PA_LOGIN_NAME
    ORDER BY CASE WHEN ISNUMERIC(concmm.concm_rmks) = 0 THEN 10000 ELSE CONVERT(NUMERIC, concmm.concm_rmks) END
           , 4
           , concmm.concm_cd
  --
  END
  ELSE IF @PA_ACTION = 'DOCM_SEARCH'
  BEGIN
  --    
    SELECT DISTINCT docm.docm_cd   docm_cd
          ,docm.docm_desc          docm_desc  
          ,docm.docm_doc_id        docm_doc_id  
          ,ISNULL(docm.docm_rmks,'') docm_rmks
    FROM   document_mstr           docm    with(nolock)
    WHERE  docm.docm_doc_id        LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    docm.docm_deleted_ind = 1
    
  --
  END
  ELSE IF @PA_ACTION = 'DOCM_SEARCHM'
  BEGIN
  --
    SELECT DISTINCT docmm.docm_cd   docm_cd
         , docmm.docm_desc          docm_desc  
         , docmm.docm_doc_id        docm_doc_id    
         , docmm.docm_rmks          docm_rmks
    FROM   document_mstr_mak        docmm    with(nolock)
    WHERE  docmm.docm_deleted_ind IN (0, 4, 6)
    AND    docmm.docm_doc_id      LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD END
    AND    docmm.docm_created_by  = @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'DOCM_SEARCHC'
  BEGIN
  --
    SELECT DISTINCT docmm.docm_cd  docm_cd
          ,docmm.docm_desc          docm_desc  
          ,docmm.docm_doc_id        docm_doc_id   
    FROM   document_mstr_mak        docmm    with(nolock)
    WHERE  docmm.docm_deleted_ind IN (0, 4, 6)
    AND    docmm.docm_created_by  <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION ='RDOCM'  
  BEGIN  
  --  
    SELECT DISTINCT excsm.excsm_exch_cd   excsm_exch_cd  
                  , excsm.excsm_seg_cd    excsm_seg_cd  
                  , prom.prom_id          prom_id  
                  , prom.prom_desc        prom_desc  
                  , enttm.enttm_id        enttm_id  
                  , enttm.enttm_desc      enttm_desc  
                  , clicm.clicm_id        clicm_id  
                  , clicm.clicm_desc      clicm_desc  
                  , case docm.docm_mdty when 1 then 'M' else 'N'end   docm_mdty
                  , docm.docm_id          docm_id
                  , docm.docm_cd          docm_cd  
                  , docm.docm_desc        docm_desc
                  , docm.docm_rmks        docm_rmks   
                  , excsm.excsm_exch_cd + '-' + excsm.excsm_seg_cd    excsm_cd 
                  , docm.docm_deleted_ind docm_deleted_ind   
    FROM           document_mstr         docm    with(nolock)
                 , exch_seg_mstr         excsm    with(nolock)
                 , client_ctgry_mstr     clicm   with(nolock)
                 , entity_type_mstr      enttm   with(nolock)
                 , excsm_prod_mstr       excpm   with(nolock)
                 , product_mstr          prom   with(nolock)
    WHERE  docm.docm_excpm_id           = excpm.excpm_id  
    AND    docm.docm_clicm_id           = clicm.clicm_id  
    AND    docm.docm_enttm_id           = enttm.enttm_id  
    AND    prom.prom_id                 = excpm.excpm_prom_id  
    AND    excpm.excpm_excsm_id         = excsm.excsm_id  
    AND    clicm.clicm_deleted_ind      = 1  
    AND    enttm.enttm_deleted_ind      = 1  
    AND    excpm.excpm_deleted_ind      = 1  
    AND    prom.prom_deleted_ind        = 1  
    AND    excsm.excsm_deleted_ind      = 1  
    AND    docm.docm_deleted_ind        = 1  
    AND    docm.docm_doc_id            = convert(NUMERIC,@PA_CD)  
    ORDER BY excsm.excsm_exch_cd ,excsm.excsm_seg_cd,prom.prom_desc,enttm.enttm_desc ,clicm.clicm_desc  
  --   
  END   
  ELSE IF @PA_ACTION='LDOCM'  
  BEGIN  
  --  
    SELECT DISTINCT excsm.excsm_exch_cd  
                   ,excsm.excsm_seg_cd  
                   ,prom_desc,prom_id  
    FROM            excsm_prod_mstr excpm    with(nolock)
                    left outer join exch_seg_mstr excsm     with(nolock)
    ON              excpm.excpm_excsm_id = excsm.excsm_id  
                    right outer join product_mstr prom    with(nolock)
    ON              excpm.excpm_prom_id = prom.prom_id 
    WHERE           excpm.excpm_deleted_ind=1
    AND             excsm.excsm_deleted_ind=1
    AND             prom_deleted_ind       =1
    ORDER BY        excsm.excsm_exch_cd,excsm.excsm_seg_cd,prom_desc  
  --  
  END  
  ELSE IF @PA_ACTION = 'RDOCMMAK' --only show those records which the maker has created.  
  BEGIN  
  --  
    SELECT DISTINCT excsm.excsm_exch_cd   excsm_exch_cd  
             , excsm.excsm_seg_cd             excsm_seg_cd  
             , prom.prom_id                   prom_id  
             , prom.prom_desc                 prom_desc  
             , enttm.enttm_id                 enttm_id  
             , enttm.enttm_desc               enttm_desc  
             , clicm.clicm_id                 clicm_id  
             , clicm.clicm_desc               clicm_desc  
             , CASE  docmm.docm_mdty WHEN  1 THEN  'M' ELSE 'N'  END docm_mdty
             ,docmm.docm_deleted_ind         docm_deleted_ind   
    FROM   document_mstr_mak              docmm    with(nolock)
         , exch_seg_mstr                  excsm    with(nolock)
         , client_ctgry_mstr              clicm   with(nolock)
         , entity_type_mstr               enttm   with(nolock)
         , excsm_prod_mstr                excpm   with(nolock)
         , product_mstr                   prom   with(nolock)
    WHERE  docmm.docm_excpm_id          = excpm.excpm_id  
    AND    docmm.docm_clicm_id          = clicm.clicm_id  
    AND    docmm.docm_enttm_id          = enttm.enttm_id  
    AND    prom.prom_id                 = excpm.excpm_prom_id  
    AND    excpm.excpm_excsm_id         = excsm.excsm_id  
    AND    clicm.clicm_deleted_ind      = 1  
    AND    enttm.enttm_deleted_ind      = 1  
    AND    excpm.excpm_deleted_ind      = 1  
    AND    prom.prom_deleted_ind        = 1  
    AND    excsm.excsm_deleted_ind      = 1  
    AND    docmm.docm_deleted_ind       = 0  
    AND    docmm.docm_doc_id            = CONVERT(NUMERIC,@PA_CD)  
    AND    docmm.docm_created_by        = @PA_LOGIN_NAME  
    ORDER BY excsm.excsm_exch_cd  
           , excsm.excsm_seg_cd  
           , prom.prom_desc  
           , enttm.enttm_desc  
           , clicm.clicm_desc  
  --  
  END  
  ELSE IF @PA_ACTION = 'RDOCMCHK' --only show those records which the checker has not created.  
  BEGIN  
  --  
    SELECT DISTINCT excsm.excsm_exch_cd   excsm_exch_cd  
                 ,excsm.excsm_seg_cd             excsm_seg_cd  
                 , prom.prom_id                   prom_id  
                 , prom.prom_desc                 prom_desc  
                 , enttm.enttm_id                 enttm_id  
                 , enttm.enttm_desc               enttm_desc  
                 , clicm.clicm_id                 clicm_id  
                 , clicm.clicm_desc               clicm_desc
                 , docmm.docm_id                  docm_id
                 , docmm.docm_cd                  docm_cd  
                 , docmm.docm_desc                docm_desc
                 , docmm.docm_rmks                docm_rmks
                 , excsm.excsm_exch_cd + '-' + excsm.excsm_seg_cd  excsm_cd
                 , CASE docmm.docm_mdty WHEN 1 THEN 'M'ELSE 'N'END docm_mdty  
                 ,docmm.docm_deleted_ind         docm_deleted_ind       
    FROM          document_mstr_mak              docmm   with(nolock)
                 , exch_seg_mstr                  excsm  with(nolock) 
                 , client_ctgry_mstr              clicm  with(nolock) 
                 , entity_type_mstr               enttm  with(nolock) 
                 , excsm_prod_mstr                excpm  with(nolock) 
                 , product_mstr                   prom   with(nolock)
    WHERE  docmm.docm_excpm_id          = excpm.excpm_id  
    AND    docmm.docm_clicm_id          = clicm.clicm_id  
    AND    docmm.docm_enttm_id          = enttm.enttm_id  
    AND    prom.prom_id                 = excpm.excpm_prom_id  
    AND    excpm.excpm_excsm_id         = excsm.excsm_id  
    AND    clicm.clicm_deleted_ind      = 1  
    AND    enttm.enttm_deleted_ind      = 1  
    AND    excpm.excpm_deleted_ind      = 1  
    AND    prom.prom_deleted_ind        = 1  
    AND    excsm.excsm_deleted_ind      = 1  
    AND    docmm.docm_deleted_ind       IN (0,4,6)
    --AND    docmm.docm_doc_id            = CONVERT(NUMERIC,@PA_CD)  
    AND    docmm.docm_lst_upd_by       <> @PA_LOGIN_NAME 
    ORDER  BY excsm.excsm_exch_cd  
            , excsm.excsm_seg_cd  
            , prom.prom_desc  
            , enttm.enttm_desc  
            , clicm.clicm_desc  
            , docmm.docm_cd
  --  
  END  
  ELSE IF @PA_ACTION = 'ENTPM_SEARCH'
  BEGIN
  --
    SELECT DISTINCT entpm.entpm_cd   entpm_cd
    ,entpm.entpm_prop_id            entpm_id
    ,entpm.entpm_prop_id        ENTDM_ENTPM_ID
    ,entpm.entpm_desc           entpm_desc
    FROM   entity_property_mstr      entpm  with(nolock)
    WHERE  entpm.entpm_deleted_ind = 1
  --
  END
  ELSE IF @PA_ACTION = 'ENTPM_SEARCHM'
  BEGIN
  --
    SELECT DISTINCT entpmm.entpm_cd    entpm_cd
    ,entpmm.entpm_prop_id               entpm_id
    ,entpmm.entpm_prop_id              entdm_entpm_id
    ,entpmm.entpm_desc                 entpm_desc
    FROM   entity_property_mstr_mak    entpmm   with(nolock)
    WHERE  entpmm.entpm_deleted_ind IN (0, 4, 6)
    AND    entpmm.entpm_created_by   = @PA_LOGIN_NAME
    
    UNION
    
    SELECT DISTINCT entpm.entpm_cd    entpm_cd
         ,entpm.entpm_prop_id         entpm_id
         ,entpm.entpm_prop_id         entdm_entpm_id
         ,entpm.entpm_desc            entpm_desc
    FROM   entity_property_mstr       entpm   with(nolock)
    WHERE  entpm.entpm_deleted_ind = 1
  --
  END
  ELSE IF @PA_ACTION = 'ENTPM_SEARCHC'
  BEGIN
  --
    SELECT DISTINCT entpmm.entpm_cd    entpm_cd
    ,entpmm.entpm_id                    entpm_id
    ,entpmm.entpm_prop_id              entdm_entpm_id
    ,entpmm.entpm_desc                 entpm_desc
    FROM   entity_property_mstr_mak    entpmm  with(nolock)
    WHERE  entpmm.entpm_deleted_ind IN (0, 4, 6)
    AND    entpmm.entpm_created_by  <> @PA_LOGIN_NAME
  --
  END
  IF @PA_ACTION ='RENTPM'    
  BEGIN    
  --    
    SELECT DISTINCT excsm.excsm_exch_cd   excsm_exch_cd    
                  , excsm.excsm_seg_cd    excsm_seg_cd    
                  , prom.prom_id          prom_id    
                  , prom.prom_desc        prom_desc    
                  , enttm.enttm_id        enttm_id    
                  , enttm.enttm_desc      enttm_desc    
                  , clicm.clicm_id        clicm_id    
                  , clicm.clicm_desc      clicm_desc    
                  , entpm.entpm_id                entpm_id    
                  , entpm.entpm_cd                entpm_cd    
                  , entpm.entpm_desc              entpm_desc    
                  , entpm.entpm_rmks              entpm_rmks 
                  , excsm.excsm_exch_cd  + '-' + excsm.excsm_seg_cd    excsm_cd    
                  , case entpm.entpm_mdty when 1 then 'M' else 'N'end   entpm_mdty
                  , entpm.entpm_deleted_ind       entpm_deleted_ind
                  , entpm.entpm_datatype  entpm_datatype    
     FROM           entity_property_mstr  entpm   with(nolock)  
                  , exch_seg_mstr         excsm   with(nolock)   
                  , client_ctgry_mstr     clicm   with(nolock)  
                  , entity_type_mstr      enttm   with(nolock)  
                  , excsm_prod_mstr       excpm   with(nolock)  
                  , product_mstr          prom    with(nolock) 
     WHERE  entpm.entpm_excpm_id         = excpm.excpm_id    
     AND    entpm.entpm_clicm_id         = clicm.clicm_id    
     AND    entpm.entpm_enttm_id         = enttm.enttm_id    
     AND    prom.prom_id                 = excpm.excpm_prom_id    
     AND    excpm.excpm_excsm_id         = excsm.excsm_id    
     AND    clicm.clicm_deleted_ind      = 1    
     AND    enttm.enttm_deleted_ind      = 1    
     AND    excpm.excpm_deleted_ind      = 1    
     AND    prom.prom_deleted_ind        = 1    
     AND    excsm.excsm_deleted_ind      = 1    
     AND    entpm.entpm_deleted_ind      = 1    
     AND    entpm.entpm_prop_id          = CONVERT(NUMERIC,@PA_CD)    
     ORDER BY excsm.excsm_exch_cd ,excsm.excsm_seg_cd,prom.prom_desc,enttm.enttm_desc ,clicm.clicm_desc    
   --     
   END     
   ELSE IF @PA_ACTION='LENTPM'    
   BEGIN    
   --    
     SELECT DISTINCT excsm.excsm_exch_cd    
                    ,excsm.excsm_seg_cd    
                    ,prom_desc,prom_id    
     FROM            excsm_prod_mstr excpm      with(nolock)
                     left outer join exch_seg_mstr excsm      with(nolock)
     ON              excpm.excpm_excsm_id = excsm.excsm_id    
                     right outer join product_mstr prom      with(nolock)
     ON              excpm.excpm_prom_id = prom.prom_id    
     AND             excpm.excpm_deleted_ind=1
     AND             excsm.excsm_deleted_ind=1
     AND             prom.prom_deleted_ind  =1
     ORDER BY        excsm.excsm_exch_cd,excsm.excsm_seg_cd,prom_desc    
   --    
   END    
   ELSE IF @PA_ACTION = 'RENTPMMAK' --only show those records which the maker has created.    
   BEGIN    
   --    
     SELECT DISTINCT excsm.excsm_exch_cd   excsm_exch_cd    
               , excsm.excsm_seg_cd             excsm_seg_cd    
               , prom.prom_id                   prom_id    
               , prom.prom_desc                 prom_desc    
               , enttm.enttm_id                 enttm_id    
               , enttm.enttm_desc               enttm_desc    
               , clicm.clicm_id                 clicm_id    
               , clicm.clicm_desc               clicm_desc    
               , CASE  entpmm.entpm_mdty WHEN  1 THEN  'M' ELSE 'N'  END entpm_mdty    
               , entpmm.entpm_deleted_ind       entpm_deleted_ind
      FROM       entity_property_mstr_mak       entpmm     with(nolock) 
               , exch_seg_mstr                  excsm     with(nolock)
               , client_ctgry_mstr              clicm     with(nolock)
               , entity_type_mstr               enttm     with(nolock)
               , excsm_prod_mstr                excpm     with(nolock)
               , product_mstr                   prom     with(nolock)
      WHERE      entpmm.entpm_excpm_id          = excpm.excpm_id    
      AND        entpmm.entpm_clicm_id          = clicm.clicm_id    
      AND        entpmm.entpm_enttm_id          = enttm.enttm_id    
      AND        prom.prom_id                   = excpm.excpm_prom_id    
      AND        excpm.excpm_excsm_id           = excsm.excsm_id    
      AND        clicm.clicm_deleted_ind        = 1    
      AND        enttm.enttm_deleted_ind        = 1    
      AND        excpm.excpm_deleted_ind        = 1    
      AND        prom.prom_deleted_ind          = 1    
      AND        excsm.excsm_deleted_ind        = 1    
      AND        entpmm.entpm_deleted_ind       = 0    
      AND        entpmm.entpm_prop_id           = CONVERT(NUMERIC,@PA_CD)    
      AND        entpmm.entpm_created_by        = @PA_LOGIN_NAME    
      ORDER BY   excsm.excsm_exch_cd    
               , excsm.excsm_seg_cd    
               , prom.prom_desc    
               , enttm.enttm_desc    
               , clicm.clicm_desc    
   --    
   END    
   ELSE IF @PA_ACTION = 'RENTPMCHK' --only show those records which the checker has not created.    
   BEGIN    
   --    
     SELECT DISTINCT excsm.excsm_exch_cd +'-'+excsm.excsm_seg_cd excsm_cd    
             , prom.prom_id                   prom_id    
             , prom.prom_desc                 prom_desc    
             , enttm.enttm_id                 enttm_id    
             , enttm.enttm_desc               enttm_desc    
             , clicm.clicm_id                 clicm_id    
             , clicm.clicm_desc               clicm_desc    
             , entpmm.entpm_id                entpm_id  
             , entpmm.entpm_cd                entpm_cd  
             , entpmm.entpm_desc              entpm_desc  
             , entpmm.entpm_rmks              entpm_rmks   
             , CASE entpmm.entpm_mdty WHEN 1 THEN 'M'ELSE 'N'END entpm_mdty    
             , entpmm.entpm_deleted_ind       entpm_deleted_ind
             , entpmm.entpm_datatype          entpm_datatype  
     FROM      entity_property_mstr_mak       entpmm     with(nolock)
             , exch_seg_mstr                  excsm     with(nolock)
             , client_ctgry_mstr              clicm     with(nolock)
             , entity_type_mstr               enttm     with(nolock)
             , excsm_prod_mstr                excpm     with(nolock)
             , product_mstr                   prom     with(nolock)
     WHERE  entpmm.entpm_excpm_id          = excpm.excpm_id    
     AND    entpmm.entpm_clicm_id          = clicm.clicm_id    
     AND    entpmm.entpm_enttm_id          = enttm.enttm_id    
     AND    prom.prom_id                   = excpm.excpm_prom_id    
     AND    excpm.excpm_excsm_id           = excsm.excsm_id    
     AND    clicm.clicm_deleted_ind        = 1    
     AND    enttm.enttm_deleted_ind        = 1    
     AND    excpm.excpm_deleted_ind        = 1    
     AND    prom.prom_deleted_ind          = 1    
     AND    excsm.excsm_deleted_ind        = 1    
     AND    entpmm.entpm_deleted_ind       IN(0,4,6)
     AND    entpmm.entpm_lst_upd_by       <> @pa_login_name    
     ORDER  BY excsm_cd  
             , prom.prom_desc    
             , enttm.enttm_desc    
             , clicm.clicm_desc    
  --    
  END 
  ELSE IF @PA_ACTION = 'ENTDM_SEARCH'
  BEGIN
  --
  
    SELECT DISTINCT entdm.entdm_cd   entdm_cd
          ,entdm.entdm_desc          entdm_desc
    FROM   entpm_dtls_mstr           entdm  with(nolock)
    WHERE  entdm.entdm_deleted_ind = 1
  --
  END
  ELSE IF @PA_ACTION = 'ENTDM_SEARCHM'
  BEGIN
  --
    SELECT DISTINCT entdmm.entdm_cd    entdm_cd
          ,entdmm.entdm_desc           entdm_desc
    FROM   entpm_dtls_mstr_mak         entdmm   with(nolock)
    WHERE  entdmm.entdm_deleted_ind IN (0, 4, 6)
    AND    entdmm.entdm_created_by   = @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'ENTDM_SEARCHC'
  BEGIN
  --
    SELECT DISTINCT entdmm.entdm_cd    entdm_cd
          ,entdmm.entdm_desc           entdm_desc
    FROM   entpm_dtls_mstr_mak         entdmm   with(nolock)
    WHERE  entdmm.entdm_deleted_ind IN (0, 4, 6)
    AND    entdmm.entdm_created_by  <> @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'ENTDM_SEL'
  BEGIN
  --
    SELECT DISTINCT entdm.entdm_id        entdm_id
         , entpm.entpm_prop_id            entdm_entpm_id
         , entdm.entdm_cd                 entdm_cd
         , entdm.entdm_desc               entdm_desc
         , entpm.entpm_cd                 entpm_cd
         , entdm.entdm_rmks               entdm_rmks
         , entdm_datatype                 entdm_datatype
         , entpm.entpm_datatype           entpm_datatype
         , entdm.entdm_mdty               entdm_mdty
         , ''                             errmsg
    FROM   entpm_dtls_mstr                entdm   with(nolock)
         , entity_property_mstr           entpm   with(nolock)
    WHERE  entdm.entdm_entpm_prop_id    = entpm.entpm_prop_id
    AND    entdm.entdm_deleted_ind      = 1
    AND    CONVERT(VARCHAR(20),entdm.entdm_entpm_prop_id) LIKE CASE WHEN LTRIM(RTRIM(@PA_CD)) = '' THEN '%' ELSE @PA_CD  END
    AND    entdm.entdm_desc               LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
  --
  END
  ELSE IF @PA_ACTION = 'ENTDM_SELM'
  BEGIN
  --
    SELECT DISTINCT entdmm.entdm_id        entdm_id
           , entpm.entpm_prop_id           entdm_entpm_id
           , entdmm.entdm_cd               entdm_cd
           , entdmm.entdm_desc             entdm_desc
           , entpm.entpm_cd                entpm_cd
           , entdmm.entdm_rmks             entdm_rmks
           , entdmm.entdm_datatype         entdm_datatype
           , entpm.entpm_datatype          entpm_datatype 
           , entdmm.entdm_mdty             entdm_mdty
           , ''                            errmsg
    FROM   entpm_dtls_mstr_mak             entdmm  with(nolock)
         , entity_property_mstr            entpm   with(nolock)
    WHERE  entdmm.entdm_entpm_prop_id    = entpm.entpm_prop_id
    AND    entdmm.entdm_deleted_ind     IN (0, 4, 6)
    AND    CONVERT(VARCHAR(20),entdmm.entdm_entpm_prop_id)    LIKE CASE WHEN LTRIM(RTRIM(@PA_CD)) = '' THEN '%' ELSE @PA_CD  END
    AND    entdmm.entdm_desc          LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
    AND    entdmm.entdm_created_by       = @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'ENTDM_SELC'
  BEGIN
  --
    SELECT DISTINCT entdmm.entdm_id        entdm_id
         , entpm.entpm_prop_id             entdm_entpm_id
         , entdmm.entdm_cd                 entdm_cd
         , entdmm.entdm_desc               entdm_desc
         , entpm.entpm_cd                  entpm_cd
         , entdmm.entdm_rmks               entdm_rmks
         , entdmm.entdm_datatype           entdm_datatype   
         , entpm.entpm_datatype            entpm_datatype 
         , entdmm.entdm_mdty               entdm_mdty
         , ''                              errmsg
    FROM   entpm_dtls_mstr_mak             entdmm   with(nolock)
         , entity_property_mstr            entpm    with(nolock)
    WHERE  entdmm.entdm_entpm_prop_id    = entpm.entpm_prop_id
    AND    entdmm.entdm_deleted_ind     IN (0, 4, 6)
    --AND    entdmm.entdm_entpm_prop_id    = @PA_CD
    AND    entdmm.entdm_desc           LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
    AND    entdmm.entdm_lst_upd_by      <> @PA_LOGIN_NAME
  --
  END  
  ELSE IF @PA_ACTION = 'PROM_SEARCH'
  BEGIN
  --
    SELECT DISTINCT PROM.PROM_ID PROM_ID
    
         , prom.prom_cd          prom_cd
         , prom.prom_desc        prom_desc
    FROM   product_mstr            prom   with(nolock)
    WHERE  prom.prom_deleted_ind = 1
  --
  END
  ELSE IF @PA_ACTION = 'PROM_SEARCHM'
  BEGIN
  --
    SELECT DISTINCT  PROMM.PROM_ID PROM_ID
         , promm.prom_cd           prom_cd
         , promm.prom_desc         prom_desc
    FROM   product_mstr_mak           promm   with(nolock)
    WHERE  promm.prom_deleted_ind IN (0, 4, 6)
    AND    promm.prom_created_by   = @PA_LOGIN_NAME
  --
  END
  ELSE IF @PA_ACTION = 'PROM_SEARCHC'
  BEGIN
  --
    SELECT DISTINCT  PROMM.PROM_ID  PROM_ID
         , promm.prom_cd            prom_cd
         , promm.prom_desc          prom_desc
    FROM   product_mstr_mak           promm   with(nolock)
    WHERE  promm.prom_deleted_ind  IN (0, 4, 6)
    AND    promm.prom_created_by   <> @pa_login_name
  --
  END
  ELSE IF @PA_ACTION='PROM_SEL'
  BEGIN
  --
    SELECT excsm.excsm_id     prom_excsm_id
         , prom.prom_cd       prom_cd
         , prom.prom_desc     prom_desc
         , prom.prom_id       prom_id
         , prom_rmks          prom_rmks
         , prom_deleted_ind              prom_deleted_ind
         , compm.compm_short_name+'-'+excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd  comp
         , ''                 errmsg
    FROM   product_mstr       prom   WITH (NOLOCK)
         , exch_seg_mstr      excsm  WITH (NOLOCK)
         , excsm_prod_mstr    excpm  WITH (NOLOCK)
         , company_mstr       compm  WITH (NOLOCK)
    WHERE(prom.prom_id            = excpm.excpm_prom_id)
    AND   compm.compm_id          = excsm.excsm_compm_id
    AND   excsm.excsm_id          = excpm.excpm_excsm_id
    AND   PROM.PROM_DELETED_IND   = 1
    AND   excsm.excsm_deleted_ind = 1
    AND   excpm.excpm_deleted_ind = 1
    AND   prom.prom_id   LIKE CASE WHEN LTRIM(RTRIM(@pa_cd))   = '' THEN '%' ELSE @PA_CD END --changed by tushar 13/09/07
    --AND   prom.prom_desc LIKE CASE WHEN LTRIM(RTRIM(@pa_desc)) = '' THEN '%' ELSE @PA_DESC +'%' END
  -- 
  END
  ELSE IF @PA_ACTION='PROM_SELM'
  BEGIN
  --
    SELECT DISTINCT PROMM.PROM_ID       PROM_ID
         , PROMM.PROM_CD       PROM_CD
         , PROMM.PROM_DESC     PROM_DESC
         , PROMM.PROM_RMKS     PROM_RMKS
         , COMPM.COMPM_SHORT_NAME+'-'+EXCSM.EXCSM_EXCH_CD+'-'+EXCSM.EXCSM_SEG_CD  COMP
         , PROM_EXCSM_ID       PROM_EXCSM_ID
         , EXCSM.EXCSM_ID      EXCSM_ID
         , ''                  ERRMSG
    FROM   PRODUCT_MSTR_MAK    PROMM WITH (NOLOCK)
         , EXCH_SEG_MSTR       EXCSM WITH (NOLOCK)
         , COMPANY_MSTR        COMPM WITH (NOLOCK)
         , excsm_prod_mstr     excpm WITH (NOLOCK)
    WHERE  PROMM.PROM_EXCSM_ID    = EXCSM.EXCSM_ID
    AND    COMPM.COMPM_ID         = EXCSM.EXCSM_COMPM_ID
    AND    excsm.excsm_id         = excpm.excpm_excsm_id
    AND    PROM_DELETED_IND       IN (0,4,6)
    AND    PROM_CREATED_BY        = @PA_LOGIN_NAME
    AND    PROMM.PROM_ID   LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))   = '' THEN '%' ELSE @PA_CD   END
    --AND    PROMM.PROM_DESC LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
  --
  END
  ELSE IF @PA_ACTION='PROM_SELC'
  BEGIN
  --
    SELECT DISTINCT  PROMM.PROM_ID   PROM_ID
          , PROMM.PROM_CD                PROM_CD
          , PROMM.PROM_DESC              PROM_DESC
          , PROMM.PROM_RMKS              PROM_RMKS
          , PROM_EXCSM_ID                PROM_EXCSM_ID
          , COMPM.COMPM_SHORT_NAME+'-'+EXCSM.EXCSM_EXCH_CD+'-'+EXCSM.EXCSM_SEG_CD  COMP
          , EXCSM.EXCSM_ID               EXCSM_ID
          ,'' ERRMSG
          ,PROM_DELETED_IND             PROM_DELETED_IND
    FROM   PRODUCT_MSTR_MAK             PROMM   with(nolock)
         , EXCH_SEG_MSTR                EXCSM   with(nolock)
         , COMPANY_MSTR                 COMPM   with(nolock)
         , excsm_prod_mstr              excpm   with(nolock)
    WHERE  PROMM.PROM_EXCSM_ID        = EXCSM.EXCSM_ID 
    AND    COMPM.COMPM_ID             = EXCSM.EXCSM_COMPM_ID
    AND    excsm.excsm_id             = excpm.excpm_excsm_id
    AND    PROM_DELETED_IND IN (0,4,6)
    AND    PROM_lst_upd_by <> @PA_LOGIN_NAME
    AND    PROMM.PROM_ID   LIKE CASE WHEN LTRIM(RTRIM(@PA_CD)) = '' THEN '%' ELSE @PA_CD END
    --AND    PROMM.PROM_DESC LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC)) = '' THEN '%' ELSE @PA_DESC +'%' END
  --
  END
  ELSE IF @PA_ACTION = 'LOGN_SEARCH'
  BEGIN
  --
    SELECT rol.rol_id                        rol_id
         , rol.rol_desc                      rol_desc
         , ISNULL(entro.entro_rol_id, 0)     entro_rol_id
    FROM   roles                             rol
         , entity_roles                      entro
    WHERE  entro.entro_rol_id            = rol.rol_id
    AND    ISNULL(entro.entro_logn_name, @PA_LOGIN_NAME) = @PA_LOGIN_NAME
    AND    rol.rol_deleted_ind              = 1
    AND    ISNULL(entro.entro_deleted_ind, 1)  = 1;
  --
  END
  ELSE IF @PA_ACTION = 'LOGN_SEL' 
  BEGIN
  --
    SELECT logn.logn_name             logn_name
         , logn.logn_pswd             logn_pswd
         , logn.logn_short_name       logn_short_name
         , logn.logn_enttm_id         logn_enttm_id
         , logn.logn_ent_id           logn_ent_id
         , logn.logn_from_dt          lognfromdt
         , logn.logn_to_dt            logntodt
         , logn_psw_exp_on            logn_psw_exp_on
         , logn_total_att             logn_total_att
         , logn_status                logn_status
         , logn_usr_email             logn_usr_email
         , logn_usr_ip                logn_usr_ip   
         , logn_menu_pref             logn_menu_pref   
         , isnull(logn.logn_sbum_id,0)logn_sbum_id
    FROM   login_names                logn
    WHERE  logn.logn_deleted_ind    = 1
    AND    logn.logn_name        LIKE ISNULL(@pa_login_name, '%');
  --
  END
  ELSE IF @PA_ACTION = 'SCRC_SEL'
  BEGIN
  --
    SELECT scrc.scrc_scr_id      scr_id
         , scrc.scrc_comp_id     comp_id
         , scrc.scrc_comp_desc   comp_desc
    FROM   screen_component      scrc
    ORDER  BY scrc.scrc_scr_id
            , scrc.scrc_comp_desc;
  --
  END
  ELSE IF @PA_ACTION = 'WFPA_SEARCH' 
  BEGIN
  --
    SELECT DISTINCT wfpm.wfpm_cd      wfpm_cd
    FROM   WF_PROCESS_MSTR    wfpm with(nolock)
    WHERE  wfpm.wfpm_deleted_ind    = 1
  --
  END
  ELSE IF @PA_ACTION = 'WFPA_SEL' 
  BEGIN
  --
    SELECT wfpm.wfpm_id               wfpm_id
         , wfpm.wfpm_cd               wfpm_cd
         , wfpm.wfpm_desc             wfpm_desc
         , wfpm.wfpm_rmks             wfpm_rmks
         , ''                         errmsg
    FROM   wf_process_mstr            wfpm   with(nolock)
    WHERE  wfpm.wfpm_deleted_ind    = 1
    AND    wfpm.wfpm_cd          LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD END
    AND    wfpm.wfpm_desc        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC END
  --
  END
  ELSE IF @PA_ACTION = 'WFA_SEARCH' 
  BEGIN
  --
    SELECT DISTINCT wfa.wfa_act_cd    wfa_act_cd
    FROM   WF_ACTIONS                wfa with(nolock)
    WHERE  wfa.wfa_deleted_ind    = 1
  --
  END
  ELSE IF @PA_ACTION = 'WFA_SEL' 
  BEGIN
  --
    SELECT wfa.wfa_id               WFPM_id
         , wfa.wfa_act_cd           wfa_act_cd
         , wfa.wfa_desc             wfa_desc
         , wfa.wfa_rmks             wfa_rmks
         , ''                       errmsg
    FROM   WF_ACTIONS               wfa   with(nolock)
    WHERE  wfa.wfa_deleted_ind    = 1
    AND    wfa.wfa_act_cd      LIKE CASE WHEN LTRIM(RTRIM(@PA_CD))     = '' THEN '%' ELSE @PA_CD END
    AND    wfa.wfa_desc        LIKE CASE WHEN LTRIM(RTRIM(@PA_DESC))   = '' THEN '%' ELSE @PA_DESC END
  --
  END
  ELSE IF @pa_action = 'BITRM_ENTP_SEL'
  BEGIN
  --
    SELECT bitrm.bitrm_parent_cd      bitrm_parent_cd
         , bitrm.bitrm_child_cd       bitrm_child_cd
         , bitrm.bitrm_values         bitrm_values
    FROM   bitmap_ref_mstr            bitrm
    WHERE  bitrm.bitrm_deleted_ind  = 1
    AND    bitrm.bitrm_tab_type    IN ('ENTPM', 'ENTDM')
  --
  END
  ELSE IF @PA_ACTION = 'BROM_SEL' 
  BEGIN
  --
    IF isnull(@PA_DESC,'') = ''
    BEGIN
    --
      SELECT DISTINCT brom.brom_id         brom_id  
           , brom.brom_desc                brom_desc  
      FROM   brokerage_mstr                brom  
--           , excsm_prod_mstr               excpm
--           , product_mstr                  prom  
--      WHERE  brom.brom_excpm_id          = excpm.excpm_id  
--      AND    prom.prom_cd                = '01'
--      AND    excpm.excpm_excsm_id        = CONVERT(NUMERIC,@PA_CD)
--      AND    excpm.excpm_PROM_id         = prom.prom_id  AND
      WHERE   brom.brom_desc                LIKE CASE WHEN LTRIM(RTRIM(@PA_VALUES))   = '' THEN '%' ELSE @PA_VALUES +'%' END  
--      AND    excpm.excpm_deleted_ind     = 1  
      AND    brom_deleted_ind            = 1 
      AND    isnull(BROM_ACTIVE_YN,'') IN ('A', '1') 
   --   
   END
   ELSE
   BEGIN
   --
     SELECT DISTINCT brom.brom_id         brom_id
           ,brom.brom_desc                brom_desc
     FROM   brokerage_mstr                brom
--           ,excsm_prod_mstr               excpm
--     WHERE  brom.brom_excpm_id          = excpm.excpm_id
--     AND    excpm.excpm_excsm_id        = CONVERT(NUMERIC,@PA_CD)
--     AND    excpm.excpm_id              = CONVERT(NUMERIC,@PA_DESC) AND    
     WHERE brom.brom_desc                LIKE CASE WHEN LTRIM(RTRIM(@PA_VALUES))   = '' THEN '%' ELSE @PA_VALUES +'%' END
     --AND    excpm.excpm_deleted_ind     = 1
     AND    brom_deleted_ind            = 1
      AND    isnull(BROM_ACTIVE_YN,'A') = 'A' 
   --
   END
    
  --
  END
  ELSE IF @PA_ACTION = 'SCR_LEV_RPT' 
  BEGIN
  --
--    SELECT excsm_id excsm_id,CONVERT(VARCHAR,excsm.excsm_id) +'|*~|' + CONVERT(VARCHAR,scr.scr_id) +'|*~|' + act.act_cd scrvalues   
--          ,excsm_exch_cd + '-' + excsm_seg_cd + '-' + excsm_sub_seg_cd Excsm_desc 
--          ,scr_desc as scr_desc 
--          ,CASE WHEN act.act_cd='READ'   THEN 'Yes' ELSE 'No' END as ReadAction  
--          ,CASE WHEN act.act_cd='WRITE'  THEN 'Yes' ELSE 'No' END as WriteAction  
--          ,CASE WHEN act.act_cd='EXPORT' THEN 'Yes' ELSE 'No' END as ExportAction  
--          ,CASE WHEN act.act_cd='PRINT'  THEN 'Yes' ELSE 'No' END as PrintAction 
--     FROM  actions            act   
--          ,roles_actions           rola   
--          ,screens                 scr   
--          ,roles                   rol   
--          ,exch_seg_mstr           excsm   
--          ,company_mstr            compm   
--    WHERE (act.act_id = rola.rola_act_id) 
--    AND    scr.scr_id            = act.act_scr_id   
--    AND    rol.rol_id            = rola.rola_rol_id   
--    AND    compm.compm_id        = excsm.excsm_compm_id   
--    AND    rola.rola_rol_id      = CONVERT(NUMERIC,@pa_id)
--    AND    CITRUS_USR.fn_get_comp_access( CONVERT(NUMERIC,@pa_id), 0, 0, rola_access1, 0, excsm.excsm_desc) > 0   
--    ORDER BY EXCSM_EXCH_CD + '-' + EXCSM_SEG_CD + '-' + EXCSM_SUB_SEG_CD  

SELECT 0 excsm_id,CONVERT(VARCHAR,0) +'|*~|' + CONVERT(VARCHAR,scr.scr_id) +'|*~|' + act.act_cd scrvalues   
          ,'' Excsm_desc 
          ,scr_desc as scr_desc 
          ,CASE WHEN act.act_cd='READ'   THEN 'Yes' ELSE 'No' END as ReadAction  
          ,CASE WHEN act.act_cd='WRITE'  THEN 'Yes' ELSE 'No' END as WriteAction 
          ,CASE WHEN act.act_cd='EXPORT' THEN 'Yes' ELSE 'No' END as ExportAction
          ,CASE WHEN act.act_cd='PRINT'  THEN 'Yes' ELSE 'No' END as PrintAction 
     FROM  actions            act   
          ,roles_actions           rola   
          ,screens                 scr   
          ,roles                   rol   
         -- ,exch_seg_mstr           excsm
         -- ,company_mstr            compm
    WHERE (act.act_id = rola.rola_act_id) 
    AND    scr.scr_id            = act.act_scr_id   
    AND    rol.rol_id            = rola.rola_rol_id 
   -- AND    compm.compm_id        = excsm.excsm_compm_id   
    AND    rola.rola_rol_id      = CONVERT(NUMERIC,@pa_id)
    --AND    CITRUS_USR.fn_get_comp_access( CONVERT(NUMERIC,@pa_id), 0, 0, rola_access1, 0, excsm.excsm_desc) > 0   



  --
  END
  ELSE IF @PA_ACTION = 'COM_LEV_RPT' 
  BEGIN
  --
    SELECT excsm_id exch_id,CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+ CONVERT(VARCHAR,scr.scr_id) +'|*~|'+ CONVERT(VARCHAR,rolc.rolc_comp_id) +'|*~|'+ CASE rolc.rolc_disable WHEN 1 THEN 'READ ONLY' ELSE  'MANDATORY' END  componentvalues   
          ,excsm_exch_cd + '-' + excsm_seg_cd + '-' + excsm_sub_seg_cd excsm_desc 
          ,scr_desc  scr_desc 
          ,scrc.scrc_comp_name  comp_desc 
          ,CASE WHEN rolc.rolc_disable=0 THEN 'Yes' ELSE 'No' END  mandatory 
          ,CASE WHEN rolc.rolc_disable=1 THEN 'Yes' ELSE 'No' END  readonly 
    FROM   roles_components          rolc   
          ,screen_component          scrc   
          ,screens                   scr   
          ,exch_seg_mstr             excsm   
          ,company_mstr              compm   
    WHERE(rolc.rolc_scr_id = scrc.scrc_scr_id) 
    AND    rolc.rolc_comp_id       = scrc.scrc_comp_id   
    AND    scr.scr_id              = scrc.scrc_scr_id   
    AND    compm.compm_id          = excsm.excsm_compm_id   
    AND    scrc.scrc_deleted_ind   = 1   
    AND    excsm.excsm_deleted_ind = 1   
    AND    rolc.rolc_rol_id        = CONVERT(NUMERIC,@pa_id)
    AND    CITRUS_USR.fn_get_comp_access(CONVERT(NUMERIC,@pa_id), 0, 0, rolc.rolc_mdtry, 0, excsm.excsm_desc) > 0 
  --
  END
  ELSE IF @PA_ACTION = 'ADDREF'       
  BEGIN      
  --      
    DECLARE @l_country  VARCHAR(100)      
           ,@l_state    VARCHAR(100)      
           ,@l_city     VARCHAR(100)      
           ,@l_zip      VARCHAR(100)  
           ,@l_value    VARCHAR(20)   
    --       
    DECLARE @ref_temp   TABLE(t_country_id   numeric
                             ,t_country      varchar(100)
                             ,t_state_id     numeric 
                             ,t_state        varchar(100)
                             ,t_city_id      numeric 
                             ,t_city         varchar(100)
                             ,t_area         varchar(100)
                             ,t_zip_id       numeric 
                             ,t_zip          varchar(100)
                             )      
    --      
    INSERT INTO @ref_temp
    SELECT coum.coum_id
         , coum.coum_name
         , statem.statem_id
         , statem.statem_name      
         , citm.citm_id
         , citm.citm_name      
         , zipm.zipm_area_name
         , zipm.zipm_id
         , zipm.zipm_cd       
    FROM   country_mstr coum      
           left outer join       
           state_mstr statem on coum.coum_id = statem.statem_coum_id      
           left outer join       
           city_mstr  citm on citm.citm_statem = statem.statem_id      
           left outer join       
           zip_mstr  zipm on zipm.zipm_citm_id  = citm.citm_id      
    --       
    SET    @l_country  = citrus_usr.fn_splitval(@pa_values, 1)             
    SET    @l_state    = citrus_usr.fn_splitval(@pa_values, 2)      
    SET    @l_city     = citrus_usr.fn_splitval(@pa_values, 3)      
    SET    @l_zip      = citrus_usr.fn_splitval(@pa_values, 4)      
    SET    @l_value    = citrus_usr.fn_splitval(@pa_values, 5)      
    -----@l_valuel---  
    IF @l_country <> '' and @l_state = '' and @l_city = '' and @l_zip = ''  and @l_value <> ''     
    BEGIN      
    --      
      SELECT distinct t_country_id country_id, t_country country_name      
      FROM   @ref_temp      
      WHERE  t_country LIKE CASE WHEN LTRIM(RTRIM(@l_country)) = '' THEN '%' ELSE @l_country + '%'   END      
    --      
    END  
    IF @l_country = '' and @l_state <> '' and @l_city = '' and @l_zip = ''  and @l_value <> ''     
    BEGIN      
    --      
      SELECT distinct t_state_id state_id, t_state state_name      
      FROM   @ref_temp      
      WHERE  t_state LIKE CASE WHEN LTRIM(RTRIM(@l_state))   = '' THEN '%' ELSE @l_state + '%'   END      
      AND    t_country like @l_value + '%'
    --      
    END  
    IF @l_country = '' and @l_state = '' and @l_city <> '' and @l_zip = '' and @l_value <> ''     
    BEGIN      
    --      
      SELECT distinct t_city_id city_id, t_city city_name      
      FROM   @ref_temp      
      WHERE  t_city LIKE CASE WHEN LTRIM(RTRIM(@l_city))   = '' THEN '%' ELSE @l_city + '%'   END      
      AND    t_state like @l_value + '%'  
      AND    t_state  <> ''
    --      
    END  
    IF @l_country = '' and @l_state = '' and @l_city = '' and @l_zip <> '' and @l_value <> ''     
    BEGIN      
    --      
      SELECT distinct t_zip_id zip_id, t_zip zip_cd       
      FROM   @ref_temp      
      WHERE  t_zip LIKE CASE WHEN LTRIM(RTRIM(@l_zip))   = '' THEN '%' ELSE @l_zip + '%' END      
      AND    t_city like @l_value + '%' --@l_city
      AND    t_city  <> ''
    --      
    END  
    ----**----          
    IF @l_country <> '' and @l_state <> '' and @l_city = '' and @l_zip = ''    
    BEGIN      
    --      
      SELECT t_state_id state_id,t_state State_Name      
      FROM   @ref_temp      
      WHERE  t_state LIKE CASE WHEN LTRIM(RTRIM(@l_state))   = '' THEN '%' ELSE @l_state + '%'   END      
      AND    t_country = @l_country      
    --      
    END      
    ELSE IF @l_country <> '' and @l_state <> '' and @l_city <> '' and @l_zip = ''      
    BEGIN      
    --      
      SELECT t_city_id city_id, t_city City_Name      
      FROM   @ref_temp      
      WHERE  t_city LIKE CASE WHEN LTRIM(RTRIM(@l_city))   = '' THEN '%' ELSE @l_city + '%'   END      
      AND    t_state   = @l_state      
      AND    t_country = @l_country
      AND    t_state <> ''
    --      
    END      
    ELSE IF @l_country <> '' and @l_state <> '' and @l_city <> '' and @l_zip <> ''      
    BEGIN      
    --      
      SELECT t_zip_id zip_id, t_zip zip_cd       
      FROM   @ref_temp      
      WHERE  t_zip LIKE CASE WHEN LTRIM(RTRIM(@l_zip))   = '' THEN '%' ELSE @l_zip + '%' END      
      AND    t_city    = @l_city      
      AND    t_state   = @l_state      
      AND    t_country = @l_country
      AND    t_state  <> ''
      AND    t_city   <> ''
    --      
    END      
  --      
  END
  ELSE IF @PA_ACTION = 'ADDREF_SEARCH' 
  BEGIN
  --
    IF @pa_cd = 'Country'
    BEGIN
    --
      SELECT DISTINCT coum.coum_name  country_name
           , coum.coum_id             coum_id  
      FROM   country_mstr coum
             left outer join 
             state_mstr statem on coum.coum_id = statem.statem_coum_id
             left outer join 
             city_mstr  citm   on citm.citm_statem = statem.statem_id
             left outer join 
             zip_mstr   zipm   on zipm.zipm_citm_id  = citm.citm_id
      WHERE  coum.coum_name     = @pa_desc             
    --
    END
    --
    IF @pa_cd = 'State'
    BEGIN
    --
      SELECT DISTINCT coum.coum_name        country_name
           , statem.statem_name             state_name
           , statem.statem_id               statem_id
      FROM   country_mstr coum
             left outer join 
             state_mstr statem  on coum.coum_id = statem.statem_coum_id
             left outer join 
             city_mstr  citm    on citm.citm_statem = statem.statem_id
             left outer join 
             zip_mstr  zipm     on zipm.zipm_citm_id  = citm.citm_id
      WHERE  statem.statem_name = @pa_desc
      AND    statem.statem_id   = @pa_id 
    --
    END
    --
    IF @pa_cd = 'City'
    BEGIN
    --
      SELECT DISTINCT coum.coum_name        country_name 
           , statem.statem_name             state_name 
           , citm.citm_name                 city_name
           , citm.citm_id                   citm_id
      FROM   country_mstr coum      
             left outer join 
             state_mstr statem  on coum.coum_id = statem.statem_coum_id
             left outer join 
             city_mstr  citm    on citm.citm_statem = statem.statem_id
             left outer join 
             zip_mstr  zipm     on zipm.zipm_citm_id  = citm.citm_id
      WHERE  citm.citm_name     = @pa_desc
      AND    citm.citm_id       = @pa_id
    --
    END
    --
    IF @pa_cd = 'Zipcode'
    BEGIN
    --
      --SELECT DISTINCT coum.coum_name        country_name 
      --     , statem.statem_name             state_name
      --     , citm.citm_name                 city_name
      --     , zipm.zipm_cd                   zip_cd
      --     , zipm.zipm_id                   zipm_id, zipm_area_name
      --FROM   country_mstr coum
      --       left outer join 
      --       state_mstr statem  on coum.coum_id = statem.statem_coum_id
      --       left outer join 
      --       city_mstr  citm    on citm.citm_statem = statem.statem_id
      --       left outer join 
      --       zip_mstr  zipm     on zipm.zipm_citm_id  = citm.citm_id
      --WHERE  zipm.zipm_cd       =  @pa_desc            
      --union all
      
       SELECT DISTINCT 'INDIA'        country_name 
		, zipm.PM_STATE_NAME             state_name
		, zipm.PM_DISTRICT_NAME                 city_name
		, zipm.PM_PIN_CODE                   zip_cd
		, PM_CITYREF_NO                   zipm_id, '' zipm_area_name
		FROM   pin_mstr zipm
		WHERE  zipm.PM_PIN_CODE       =  @pa_desc
    --
    END
  --
  END
  --
  ELSE IF @PA_ACTION = 'ADDREF_SEARCH_ALL' 
  BEGIN
  --
    IF @pa_cd = 'Country'
    BEGIN
    --
      SELECT coum.coum_id id, coum.coum_name  name
      FROM   country_mstr coum
      WHERE  coum.coum_name LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))   = '' THEN '%' ELSE @pa_desc + '%'   END
    --
    END
    IF @pa_cd = 'State'
    BEGIN
    --
      SELECT statem.statem_id id, statem.statem_name    name
      FROM   state_mstr statem
      WHERE  statem.statem_name LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))   = '' THEN '%' ELSE @pa_desc + '%'   END
    --
    END
    IF @pa_cd = 'City'
    BEGIN
    --
      --SELECT DISTINCT citm.citm_name       name
      --FROM   city_mstr citm
      --WHERE  citm.citm_name LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))   = '' THEN '%' ELSE @pa_desc + '%'   END
      SELECT citm.citm_id id, citm.citm_name name
      FROM   city_mstr citm
      WHERE  citm.citm_name LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))  = '' THEN '%' ELSE @pa_desc + '%' END
      AND    citm.citm_name <> ''
      ORDER BY citm.citm_name
    --
    END
    IF @pa_cd = 'Zipcode'
    BEGIN
    --
      SELECT zipm.zipm_id id, zipm.zipm_cd name
      FROM   zip_mstr  zipm  
      WHERE  zipm.zipm_cd LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))   = '' THEN '%' ELSE @pa_desc + '%'   END   
    --
    END
  --
  END
  ELSE IF @PA_ACTION = 'BUSM_SEL' 
  BEGIN
  --
    IF LTRIM(RTRIM(ISNULL(@PA_CD,''))) <> '' -- FOR ADDRESSES SCREEN
	BEGIN
	    SELECT busm.busm_id            busm_id  
             , busm.busm_cd            busm_cd  
	         , busm.busm_desc          busm_desc  
	    FROM   business_mstr           busm  
	    WHERE  busm.busm_deleted_ind = 1
	    AND	   busm_cd not in('NSDLDEPOSITORY','CDSLDEPOSITORY')	     
	    order by busm_desc
	END
	ELSE 
	BEGIN --FOR OTHER SCREENS
	    SELECT busm.busm_id            busm_id  
             , busm.busm_cd            busm_cd  
	         , busm.busm_desc          busm_desc  
	    FROM   business_mstr           busm  
	    WHERE  busm.busm_deleted_ind = 1  
 	    AND	   busm_cd not in('CLIDEPOSITORY','ACCDEPOSITORY')
	    order by busm_desc
	END  
  --
  END
  --
  ELSE IF @PA_ACTION = 'SBUM_SEARCH' 
  BEGIN
  --
    SELECT distinct sbum_cd     sbum_cd
                  , sbum_desc   sbum_desc
    FROM   sbu_mstr             WITH (NOLOCK)   
    WHERE  sbum_deleted_ind   = 1
    
  --
  END
  --
  ELSE IF @PA_ACTION = 'SBUM_SEARCHM' 
  BEGIN
  --
    SELECT distinct  sbum_cd       sbum_cd    
                   , sbum_desc     sbum_desc
    FROM   sbu_mstr_mak            WITH (NOLOCK)   
    WHERE  sbum_deleted_ind        IN (0,4,6)
    AND    sbum_created_by       = @PA_LOGIN_NAME
    
  --
  END
  --
  ELSE IF @PA_ACTION = 'SBUM_SEARCHC'
  BEGIN
  --
    SELECT DISTINCT sbum_cd        sbum_cd
                  , sbum_desc      sbum_desc
    FROM   sbu_mstr_mak            WITH (NOLOCK)   
        WHERE  sbum_deleted_ind    IN (0,4,6)
    AND    sbum_created_by      <> @PA_LOGIN_NAME
  --
  END
  --
  ELSE IF @PA_ACTION = 'SBUM_SEL' 
  BEGIN
  --
    SELECT sbum_id, sbum_cd, sbum_desc, sbum_rmks, isnull(sbum_start_no,'00000') sbum_start_no, isnull(sbum_end_no,'00000') sbum_end_no, isnull(sbum_cur_no,'00000') sbum_cur_no, '' errmsg 
    FROM   sbu_mstr          WITH (NOLOCK)   
    WHERE  sbum_deleted_ind = 1 
    AND    sbum_cd       LIKE CASE WHEN LTRIM(RTRIM(@pa_cd))     = '' THEN '%' ELSE @pa_cd  END
    AND    sbum_desc     LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))   = '' THEN '%' ELSE @pa_desc +'%' END
  --
  END
  --
  ELSE IF @PA_ACTION = 'SBUM_SELM' 
  BEGIN
  --
    SELECT sbum_id, sbum_cd, sbum_desc, sbum_rmks,isnull(sbum_start_no,'00000') sbum_start_no, isnull(sbum_end_no,'00000') sbum_end_no, isnull(sbum_cur_no,'00000') sbum_cur_no, '' errmsg 
    FROM   sbu_mstr_mak        WITH (NOLOCK)   
    WHERE  sbum_deleted_ind IN (0, 4, 6)
    AND    sbum_cd         LIKE CASE WHEN LTRIM(RTRIM(@pa_cd))     = '' THEN '%' ELSE @pa_cd  END
    AND    sbum_desc       LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))   = '' THEN '%' ELSE @pa_desc +'%' END
    AND    sbum_created_by   =  @pa_login_name
  --
  END
  --
  ELSE IF @PA_ACTION = 'SBUM_SELC' 
  BEGIN
  --
    SELECT sbum_id, sbum_cd, sbum_desc, sbum_rmks,isnull(sbum_start_no,'00000') sbum_start_no, isnull(sbum_end_no,'00000') sbum_end_no, isnull(sbum_cur_no,'00000') sbum_cur_no, '' errmsg 
    FROM   sbu_mstr_mak        WITH (NOLOCK)   
    WHERE  sbum_deleted_ind IN (0, 4, 6)
    AND    sbum_cd         LIKE CASE WHEN LTRIM(RTRIM(@pa_cd))     = '' THEN '%' ELSE @pa_cd  END
    AND    sbum_desc       LIKE CASE WHEN LTRIM(RTRIM(@pa_desc))   = '' THEN '%' ELSE @pa_desc +'%' END
    AND    sbum_created_by  <>  @pa_login_name
  --
  END
--
END

GO
