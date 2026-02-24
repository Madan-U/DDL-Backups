-- Object: PROCEDURE citrus_usr.PR_SEARCH_CLIM_14DEC2010
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--begin tran
--rollback
-- exec PR_SEARCH_CLIM 'a','','','','','','','','','','CLIM_NEW','HET',1,'*|~*','|*~|','CLIENTS'	
-- pr_search_clim '','','','','','','','','ahppk1195c','','CLIM_PAN_SEARCH','HO',2,'*|~*','|*~|',''

CREATE PROCEDURE [citrus_usr].[PR_SEARCH_CLIM_14DEC2010]
							 (
							   @PA_CRN_NO        VARCHAR(10)          
                              ,@PA_ACCT_NO       VARCHAR(25)          
                              ,@PA_SHORT_NAME    VARCHAR(250)          
                              ,@PA_STAM_CD       VARCHAR(20)          
                              ,@PA_CLICM_CD      VARCHAR(20)          
                              ,@PA_ENTTM_CD      VARCHAR(20)          
                              ,@PA_DOB           VARCHAR(11)          
                              ,@PA_ENTPM_CD      VARCHAR(20)          
                              ,@PA_ENTP_VALUE    VARCHAR(50)          
                              ,@PA_SBUM_ID       VARCHAR(10)          
                              ,@PA_TAB           VARCHAR(50)          
                              ,@PA_LOGIN_NAME    VARCHAR(20)          
                              ,@PA_CHK_YN        NUMERIC          
                              ,@ROWDELIMITER     VARCHAR(4) = '*|~*'          
                              ,@COLDELIMITER     VARCHAR(4) = '|*~|'          
                              ,@PA_REF_CUR       VARCHAR(8000) OUTPUT          
                              )          
AS          
/*******************************************************************************          
 SYSTEM         : CLASS          
 MODULE NAME    : PR_SEARCH_CLIM          
 DESCRIPTION    : SCRIPT TO SELECT CLIENT_MSTR WITH VARIOUS SEARCH CRITERIA          
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.          
 VERSION HISTORY:          
 VERS.  AUTHOR             DATE         REASON          
 -----  -------------      ----------   ------------------------------------------------          
 1.0    SUKHVINDER/TUSHAR  11-JAN-2007  INITIAL VERSION.          
 2.0    SUKHVINDER/TUSHAR  12-JAN-2007  ID'S COLUMN WERE ADDED IN SELECT          
 3.0    VISHAL KOUL        23-MAY-2007  SBU ID VALUE FETCHED FROM LOGINAME TABLE & PASSED TO CLIENT SEARCH QUERY          
**********************************************************************************/          
BEGIN          
--          
IF @PA_CHK_YN = 0  or @PA_CHK_YN = 2          
BEGIN          
--          
  DECLARE @l_string VARCHAR(8000)        
  IF @PA_TAB = 'CLIM_NEW'          
  BEGIN          
  --          
    DECLARE @l_ent_id           NUMERIC          
          , @l_entem_col_name   VARCHAR(20)          
          , @l_sbum_id          VARCHAR(10)          
          , @l_search           VARCHAR(8000)      
          , @l_col_name         varchar(500)      
        
    SELECT @l_ent_id         = logn.logn_ent_id          
         , @l_entem_col_name = entem.entem_entr_col_name           
         , @l_sbum_id        = isnull(logn_sbum_id,'0')          
    FROM   login_names               logn          
         , enttm_entr_mapping        entem          
         , entity_type_mstr          enttm          
    WHERE  logn.logn_enttm_id      = enttm.enttm_id          
    AND    entem.entem_enttm_cd    = enttm.enttm_cd          
    AND    logn.logn_name          = @pa_login_name          
    AND    logn.logn_deleted_ind   = 1          
    AND    entem.entem_deleted_ind = 1          
    AND    enttm.enttm_deleted_ind = 1          
        
    SET @l_string =   'SELECT DISTINCT clim.clim_crn_no               clim_crn_no                                  '      
                    + '       , clim.clim_name1                       clim_name1                                   '      
                    + '       , ISNULL(clim.clim_name2, '' '')         clim_name2                                    '      
                    + '       , ISNULL(clim.clim_name3, '' '')        clim_name3                                    '      
                    + '       , clim.clim_short_name                  clim_short_name                               '      
                    + '       , clim.clim_gender                      clim_gender                                   '      
                    + '       , CONVERT(VARCHAR,clim.clim_dob,103)    clim_dob                                      '      
                    + '       , enttm.enttm_cd                enttm_cd                                      '      
                    + '       , enttm.enttm_id                        enttm_id                                    '      
                    + '       , enttm.enttm_desc                      enttm_desc                                    '      
                    + '       , clim.clim_stam_cd                     clim_stam_cd                                  '      
                    + '       , clim.clim_clicm_cd                    clim_clicm_cd                                 '      
                    + '       , clicm.clicm_id                        clicm_id                                      '      
                    + '       , CLIA.clia_acct_no                     clia_acct_no '       
                    + '  FROM   client_mstr                           clim                                          '      
                    + '         left outer join                                                                     '      
                    + '         client_accounts                       clia   on clia.clia_crn_no = clim.clim_crn_no '         
                    + '         left outer join                                                                     '      
                    + '         entity_properties                     entp   on  entp.entp_ent_id = clim.clim_crn_no'       
                    + '       , entity_type_mstr                      enttm'         
                    + '       , client_ctgry_mstr                     clicm'          
                    + '       , entity_relationship                   entr'          
                    + '  WHERE  ISNULL(clim.clim_enttm_cd,''CLIENT'')     = enttm.enttm_cd '          
                    + '  AND    ISNULL(clim.clim_clicm_cd,''NOR'')  = clicm.clicm_cd '          
                    + '  AND    entr.entr_crn_no                    = clim.clim_crn_no'          
                    + '  AND    clim.clim_deleted_ind               = 1'          
                    + '  AND    enttm.enttm_deleted_ind             = 1'          
                    + '  AND    ISNULL(clia.clia_deleted_ind, 1)    = 1'          
                    + '  AND    ISNULL(entp.entp_deleted_ind, 1)    = 1'          
                    + '  AND    clicm.clicm_deleted_ind             = 1'          
                    + '  AND    entr.entr_deleted_ind               = 1'      
                    + '  AND    clim.clim_sbum_id                      LIKE CASE WHEN LTRIM(RTRIM('''+@l_sbum_id+'''))    = ''0'' THEN ''%'' ELSE ''' +  @l_sbum_id +'''    END    '      
        
      IF @pa_short_name <> ''          
      BEGIN          
      --          
        SET @l_string = @l_string + '  AND    clim.clim_short_name                   LIKE CASE WHEN LTRIM(RTRIM('''+@pa_short_name+''')) = '''' THEN ''%'' ELSE '''+ @pa_short_name + '%'''+' END    '          
      --          
      END          
      IF @pa_stam_cd <> ''          
      BEGIN          
      --          
        SET @l_string = @l_string + '  AND    clim.clim_stam_cd                      LIKE CASE WHEN LTRIM(RTRIM('''+@pa_stam_cd+'''))    = '''' THEN ''%'' ELSE ''' + @pa_stam_cd + '''    END    '            
      --          
      END          
      IF @pa_clicm_cd <> ''          
      BEGIN          
      --          
        SET @l_string = @l_string + '  AND    ISNULL(clim.clim_clicm_cd,''NOR'')    LIKE CASE WHEN LTRIM(RTRIM('''+@pa_clicm_cd+'''))   = '''' THEN ''%'' ELSE '''+@pa_clicm_cd+'''   END    '          
      --          
      END          
      IF @pa_enttm_cd <> ''          
      BEGIN          
      --          
        SET @l_string = @l_string + '  AND    ISNULL(clim.clim_enttm_cd,''CLIENT'') LIKE CASE WHEN LTRIM(RTRIM('''+@pa_enttm_cd+'''))   = '''' THEN ''%'' ELSE '''+@pa_enttm_cd+'''   END    '          
      --          
END          
      IF @PA_DOB <> ''          
      BEGIN          
      --          
        SET @l_string = @l_string + '  AND    CONVERT(VARCHAR(11),CLIM.CLIM_DOB,103) =    CASE WHEN LTRIM(RTRIM('''+@pa_dob+'''))        = '''' THEN   CONVERT(VARCHAR(11),CLIM.CLIM_DOB,103) ELSE '''+@PA_DOB+''' END    '          
 --          
      END          
      IF @pa_acct_no <> ''          
      BEGIN          
      --          
        SET @l_string = @l_string + '  AND    ISNULL(CLIA.CLIA_ACCT_NO, ''%'')         LIKE CASE WHEN LTRIM(RTRIM('''+@pa_acct_no+'''))    = '''' THEN ''%'' ELSE '''+@pa_acct_no + '%'''+' END    '          
      --          
      END          
      IF @pa_entpm_cd <> ''          
      BEGIN          
      --          
        SET @l_string = @l_string + '  AND    ISNULL(ENTP.ENTP_ENTPM_CD,''%'')         LIKE CASE WHEN LTRIM(RTRIM('''+@pa_entpm_cd+'''))   = '''' THEN ''%'' ELSE '''+@pa_entpm_cd+'''   END    '          
      --          
      END          
      IF @pa_entp_value <> ''          
      BEGIN          
      --          
        SET @l_string = @l_string + '  AND    ISNULL(ENTP.ENTP_VALUE,''%'')            LIKE CASE WHEN LTRIM(RTRIM('''+@pa_entp_value+''')) = '''' THEN ''%'' ELSE '''+@pa_entp_value+ '%'''+' END    '          
      --          
      END        
	
		 SET @l_col_name = CASE  WHEN @l_entem_col_name = 'ENTR_HO'      
                              THEN 'AND    entr.entr_ho                           = ' +CONVERT(VARCHAR,@l_ent_id)      
                              WHEN @l_entem_col_name = 'ENTR_RE'      
                              THEN 'AND    entr.entr_re                           = ' +CONVERT(VARCHAR,@l_ent_id)      
                              WHEN @l_entem_col_name = 'ENTR_AR'      
                              THEN 'AND    entr.entr_ar                           = ' +CONVERT(VARCHAR,@l_ent_id)      
                              WHEN @l_entem_col_name = 'ENTR_BR'      
                              THEN 'AND    entr.entr_br                           = ' +CONVERT(VARCHAR,@l_ent_id)      
                              WHEN @l_entem_col_name = 'ENTR_SB'      
                              THEN 'AND    entr.entr_sb                           = ' +CONVERT(VARCHAR,@l_ent_id)      
                              WHEN @l_entem_col_name = 'ENTR_DL'      
                              THEN 'AND    entr.entr_dl                           = ' +CONVERT(VARCHAR,@l_ent_id)      
                              WHEN @l_entem_col_name = 'ENTR_RM'      
                              THEN 'AND    entr.entr_rm                           = ' +CONVERT(VARCHAR,@l_ent_id)      
                              WHEN @l_entem_col_name = 'ENTR_DUMMY1'      
                              THEN 'AND    entr.entr_dummy1                       = ' +CONVERT(VARCHAR,@l_ent_id)      
                              WHEN @l_entem_col_name = 'ENTR_DUMMY2'      
                              THEN 'AND    entr.entr_dummy2                       = ' +CONVERT(VARCHAR,@l_ent_id)      
                              WHEN @l_entem_col_name = 'ENTR_DUMMY3'      
                              THEN 'AND    entr.entr_dummy3                       = ' +CONVERT(VARCHAR,@l_ent_id)      
                              WHEN @l_entem_col_name = 'ENTR_DUMMY4'      
                              THEN 'AND    entr.entr_dummy4                       = ' +CONVERT(VARCHAR,@l_ent_id)      
                              WHEN @l_entem_col_name = 'ENTR_DUMMY5'      
                              THEN 'AND    entr.entr_dummy5                       = ' +CONVERT(VARCHAR,@l_ent_id)      
                              WHEN @l_entem_col_name = 'ENTR_DUMMY6'      
                              THEN 'AND    entr.entr_dummy6                       = ' +CONVERT(VARCHAR,@l_ent_id)      
                              WHEN @l_entem_col_name = 'ENTR_DUMMY7'      
                              THEN 'AND    entr.entr_dummy7                       = ' +CONVERT(VARCHAR,@l_ent_id)   
                              WHEN @l_entem_col_name = 'ENTR_DUMMY8'      
                              THEN 'AND    entr.entr_dummy8                       = ' +CONVERT(VARCHAR,@l_ent_id)      
                              WHEN @l_entem_col_name = 'ENTR_DUMMY9'      
                              THEN 'AND    entr.entr_dummy9                       = ' +CONVERT(VARCHAR,@l_ent_id)      
                              WHEN @l_entem_col_name = 'ENTR_DUMMY10'      
                              THEN 'AND    entr.entr_dummy10                      = ' +CONVERT(VARCHAR,@l_ent_id)      
                              END      
                                       
      SET @l_string = @l_string + @l_col_name + ' UNION '      
        
      SET @l_string = @l_string + 'SELECT DISTINCT clim.clim_crn_no      clim_crn_no'          
                    + ', clim.clim_name1                       clim_name1    '      
                    + ', ISNULL(clim.clim_name2, '' '')        clim_name2    '      
                    + ', ISNULL(clim.clim_name3, '' '')        clim_name3    '      
                    + ', clim.clim_short_name                  clim_short_name    '      
                    + ', clim.clim_gender                      clim_gender'          
                    + ', CONVERT(VARCHAR,clim.clim_dob,103)    clim_dob    '      
                    + ', enttm.enttm_cd                        enttm_cd    '      
                    + ', enttm.enttm_id                        enttm_id    '      
                    + ', enttm.enttm_desc                      enttm_desc  '        
                    + ', clim.clim_stam_cd                     clim_stam_cd '         
                    + ', clim.clim_clicm_cd                    clim_clicm_cd '         
                    + ', clicm.clicm_id                        clicm_id    '      
                    + '       , CLIA.clia_acct_no                     clia_acct_no '       
                    + ' FROM   client_mstr                         clim  '      
                    + '       left outer join  client_accounts clia  on ( clia.clia_crn_no   = clim.clim_crn_no )  '      
                    + '       left outer join  entity_properties  entp    on (entp.entp_ent_id  = clim.clim_crn_no  )  '      
                    + '     , client_ctgry_mstr                     clicm   '      
                    + '     , entity_type_mstr                      enttm    '      
                    + 'WHERE  ISNULL(clim.clim_enttm_cd,''CLIENT'')     = enttm.enttm_cd    '      
                    + 'AND    ISNULL(clim.clim_clicm_cd,''NOR'')        = clicm.clicm_cd  '      
                    + 'AND    clim.clim_deleted_ind               = 1    '      
                    + 'AND    enttm.enttm_deleted_ind             = 1    '      
                    + 'AND    ISNULL(clia.clia_deleted_ind, 1)    = 1    '      
                    + 'AND    ISNULL(entp.entp_deleted_ind, 1)    = 1    '      
                    + 'AND    clicm.clicm_deleted_ind             = 1    '      
                    + 'AND    clim.clim_crn_no                       NOT IN (SELECT distinct entr_crn_no from entity_relationship)    '      
      --            
      IF @pa_short_name <> ''          
      BEGIN          
      --          
        SET @l_string = @l_string + '  AND    clim.clim_short_name                   LIKE CASE WHEN LTRIM(RTRIM('''+@pa_short_name+''')) = '''' THEN ''%'' ELSE '''+ @pa_short_name + '%'''+' END    '          
      --          
      END          
      IF @pa_stam_cd <> ''          
      BEGIN          
      --          
        SET @l_string = @l_string + '  AND    clim.clim_stam_cd                      LIKE CASE WHEN LTRIM(RTRIM('''+@pa_stam_cd+'''))    = '''' THEN ''%'' ELSE ''' + @pa_stam_cd + '''    END    '            
      --          
      END          
      IF @pa_clicm_cd <> ''          
      BEGIN          
      --          
        SET @l_string = @l_string + '  AND    clim.clim_clicm_cd                     LIKE CASE WHEN LTRIM(RTRIM('''+@pa_clicm_cd+'''))   = '''' THEN ''%'' ELSE '''+@pa_clicm_cd+'''   END    '          
      --          
      END          
      IF @pa_enttm_cd <> ''          
      BEGIN          
      --          
        SET @l_string = @l_string + '  AND    clim.clim_enttm_cd                     LIKE CASE WHEN LTRIM(RTRIM('''+@pa_enttm_cd+'''))   = '''' THEN ''%'' ELSE '''+@pa_enttm_cd+'''   END    '          
      --          
      END          
      IF @PA_DOB <> ''          
      BEGIN          
      --          
        SET @l_string = @l_string + '  AND    CONVERT(VARCHAR(11),CLIM.CLIM_DOB,103) =    CASE WHEN LTRIM(RTRIM('''+@pa_dob+'''))        = '''' THEN   CONVERT(VARCHAR(11),CLIM.CLIM_DOB,103) ELSE '''+@PA_DOB+''' END    '          
      --          
      END          
      IF @pa_acct_no <> ''          
      BEGIN          
      --          
        SET @l_string = @l_string + '  AND    ISNULL(CLIA.CLIA_ACCT_NO, ''%'')         LIKE CASE WHEN LTRIM(RTRIM('''+@pa_acct_no+'''))    = '''' THEN ''%'' ELSE '''+@pa_acct_no + '%'''+' END    '          
      --          
      END          
      IF @pa_entpm_cd <> ''          
       BEGIN          
      --          
        SET @l_string = @l_string + '  AND    ISNULL(ENTP.ENTP_ENTPM_CD,''%'')         LIKE CASE WHEN LTRIM(RTRIM('''+@pa_entpm_cd+'''))   = '''' THEN ''%'' ELSE '''+@pa_entpm_cd+'''   END    '          
      --          
      END          
      IF @pa_entp_value <> ''          
      BEGIN          
      --          
       SET @l_string = @l_string + '  AND    ISNULL(ENTP.ENTP_VALUE,''%'')            LIKE CASE WHEN LTRIM(RTRIM('''+@pa_entp_value+''')) = '''' THEN ''%'' ELSE '''+@pa_entp_value+ '%'''+' END    '          
      --          
      END          
      print   @l_string
      EXECUTE(@l_string)       
            
   --          
 END        
 ELSE IF @PA_TAB = 'ENTM_NEW'          
 BEGIN          
 --          
   SELECT DISTINCT ENTM.ENTM_ID          ENTM_ID          
                 , ENTM.ENTM_NAME1       ENTM_NAME1          
                 , ENTM.ENTM_NAME2       ENTM_NAME2          
                 , ENTM.ENTM_NAME3       ENTM_NAME3          
                 , ENTM.ENTM_SHORT_NAME  ENTM_SHORT_NAME          
                 , ENTM.ENTM_PARENT_ID   PARENT_ID          
                 , CLICM.CLICM_ID        CLICM_ID          
                 , CLICM.CLICM_CD         CLICM_CD          
                 , ENTTM.ENTTM_ID        ENTTM_ID          
                 , ENTTM.ENTTM_CD         ENTTM_CD          
                 , ENTM.ENTM_NAME1       PARENT_NAME1          
                           
   FROM  ENTITY_MSTR       ENTM WITH (NOLOCK)          
   LEFT OUTER JOIN  ENTITY_PROPERTIES ENTP WITH (NOLOCK)          
   ON ENTP.ENTP_ENT_ID                 = ENTM.ENTM_ID          
   ,    CLIENT_CTGRY_MSTR  CLICM           
   ,    ENTITY_TYPE_MSTR   ENTTM          
             
   WHERE  ENTM.ENTM_CLICM_CD=CLICM.CLICM_CD           
   AND   ENTM.ENTM_ENTTM_CD=ENTTM.ENTTM_CD          
   AND   CONVERT(VARCHAR, ENTM.ENTM_ID)   LIKE CASE WHEN LTRIM(RTRIM(@PA_CRN_NO))     = '' THEN '%' ELSE @PA_CRN_NO     END          
   AND   ENTM.ENTM_SHORT_NAME        LIKE CASE WHEN LTRIM(RTRIM(@PA_SHORT_NAME)) = '' THEN '%' ELSE @PA_SHORT_NAME + '%' END          
   AND   ENTM.ENTM_ENTTM_CD               LIKE CASE WHEN LTRIM(RTRIM(@PA_ENTTM_CD))   = '' THEN '%' ELSE @PA_ENTTM_CD   END          
   AND   ISNULL(ENTP.ENTP_ENTPM_CD, '%')  LIKE CASE WHEN LTRIM(RTRIM(@PA_ENTPM_CD))   = '' THEN '%' ELSE @PA_ENTPM_CD   END          
   AND   ISNULL(ENTP.ENTP_VALUE, '%')     LIKE CASE WHEN LTRIM(RTRIM(@PA_ENTP_VALUE)) = '' THEN '%' ELSE @PA_ENTP_VALUE + '%' END          
   AND   ENTM.ENTM_CLICM_CD               LIKE CASE WHEN LTRIM(RTRIM(@PA_CLICM_CD))   = '' THEN '%' ELSE @PA_CLICM_CD   END          
   AND   ENTM.ENTM_DELETED_IND            = 1          
   AND   CLICM.CLICM_DELETED_IND          = 1          
   AND   ENTTM.ENTTM_DELETED_IND          = 1          
 --          
 END          
 ELSE IF @PA_TAB = 'ENTP_CLI'           BEGIN          
 --          
    SELECT DISTINCT ENTPM.ENTPM_CD     PROPERTY_CODE          
         , ENTPM.ENTPM_DESC            PROPERTY_DESC          
    FROM   ENTITY_PROPERTY_MSTR        ENTPM  WITH (NOLOCK)          
         , ENTITY_TYPE_MSTR            ENTTM  WITH (NOLOCK)          
    WHERE  ENTPM.ENTPM_ENTTM_ID      = ENTTM.ENTTM_ID          
    AND    ENTPM.ENTPM_DELETED_IND   = 1          
    AND    ENTTM.ENTTM_DELETED_IND   = 1          
     AND    ENTTM.ENTTM_CLI_YN & 2    = 2         
 --          
 END          
 ELSE IF @PA_TAB = 'ENTP_ENT'          
 BEGIN          
 --          
   SELECT DISTINCT ENTPM.ENTPM_CD  PROPERTY_CODE          
        , ENTPM.ENTPM_DESC         PROPERTY_DESC          
   FROM ENTITY_PROPERTY_MSTR       ENTPM WITH (NOLOCK)          
      , ENTITY_TYPE_MSTR           ENTTM WITH (NOLOCK)          
   WHERE  ENTPM.ENTPM_ENTTM_ID      = ENTTM.ENTTM_ID          
   AND    ENTPM.ENTPM_DELETED_IND   = 1          
   AND    ENTTM.ENTTM_DELETED_IND   = 1          
   AND    ENTTM.ENTTM_CLI_YN & 1       = 1          
 --          
 END          
 ELSE IF @pa_tab = 'CLIM_PAN_SEARCH'          
 BEGIN          
 --          
SELECT Top 1 tmp.* from (   
SELECT DISTINCT clim.clim_crn_no           clim_crn_no          
        , clim.clim_name1                     clim_name1          
        , ISNULL(clim.clim_name2, '')         clim_name2          
        , ISNULL(clim.clim_name3, '')         clim_name3          
        , clim.clim_short_name                clim_short_name          
        , enttm.enttm_id                      enttm_id          
        , clicm.clicm_id                      clicm_id          
        , entp.entp_value                     entp_value,2 Mkrchkr          
   FROM   client_mstr                         clim  WITH (NOLOCK)     LEFT OUTER JOIN             
          entity_properties                   entp  WITH (NOLOCK)            
   ON     (entp.entp_ent_id                 = clim.clim_crn_no)               
        , entity_type_mstr                    enttm WITH (NOLOCK)          
        , client_ctgry_mstr                   clicm WITH (NOLOCK)          
   WHERE  isnull(clim.clim_enttm_cd,'cli') = enttm.enttm_cd          
   AND    clicm.clicm_cd                    = isnull(clim.clim_clicm_cd,'nrm')          
   AND    entp.entp_entpm_cd                = 'PAN_GIR_NO'          
   AND    ISNULL(entp.entp_value,'%')      = LTRIM(RTRIM(@pa_entp_value)) 
   AND    clim.clim_deleted_ind             = 1          
   AND    enttm.enttm_deleted_ind           = 1          
   AND    ISNULL(entp.entp_deleted_ind, 1)  = 1          
   AND    clicm.clicm_deleted_ind           = 1          
        
   UNION        
        
   SELECT DISTINCT clim.clim_crn_no           clim_crn_no          
        , clim.clim_name1                     clim_name1          
        , ISNULL(clim.clim_name2, ' ')        clim_name2          
        , ISNULL(clim.clim_name3, ' ')        clim_name3          
        , clim.clim_short_name                clim_short_name          
        , enttm.enttm_id                      enttm_id          
        , clicm.clicm_id       clicm_id          
        , entp.entp_value                     entp_value ,1 Mkrchkr         
   FROM   client_mstr_MAK                     clim  WITH (NOLOCK)     LEFT OUTER JOIN             
          entity_properties_MAK               entp  WITH (NOLOCK)            
   ON     (entp.entp_ent_id                 = clim.clim_crn_no)               
        , entity_type_mstr                    enttm WITH (NOLOCK)          
        , client_ctgry_mstr                   clicm WITH (NOLOCK)          
   WHERE  isnull(clim.clim_enttm_cd,'cli') = enttm.enttm_cd          
   AND    clicm.clicm_cd                    = isnull(clim.clim_clicm_cd,'nrm')         
   AND    entp.entp_entpm_cd                = 'PAN_GIR_NO'          
   AND    ISNULL(entp.entp_value,'%')      = LTRIM(RTRIM(@pa_entp_value)) 
   AND    clim.clim_deleted_ind             IN (0,8)        
   AND    enttm.enttm_deleted_ind           = 1          
   AND    ISNULL(entp.entp_deleted_ind, 0)  IN (0,8) 
   AND    clicm.clicm_deleted_ind           = 1     
   )
   TMP
   order by Mkrchkr asc      
 --          
 END      
 ELSE IF @pa_tab = 'CLI_RPT'        
 BEGIN      
 --      
   IF @pa_short_name <> ''      
   BEGIN      
   --      
         
     DECLARE @t_ent_id  table(ent_id NUMERIC)      
      
     DECLARE @l_counter NUMERIC      
           , @l         NUMERIC      
           , @l_entm_id NUMERIC      
      
     SET @l = 1      
      
     SET @l_counter = citrus_usr.ufn_countstring(@pa_short_name,'|*~|')      
      
     WHILE @l <= @l_counter      
     BEGIN      
     --      
      
       SELECT @l_entm_id =  entm_id FROM entity_mstr WHERE entm_short_name = (citrus_usr.fn_splitval(@pa_short_name,@l))      
      
       INSERT INTO @t_ent_id VALUES(@l_entm_id)       
      
       SET @l = @l + 1      
     --      
     END      
      
     SELECT clim.clim_crn_no        crn_no       
          , enttm.enttm_id          enttm_id       
          , clim.clim_enttm_cd      enttm_cd       
          , clim.clim_name1         name1       
          , clim.clim_name2         name2       
          , clim.clim_name3         name3       
          , clim.clim_short_name    short_name       
          , clim.clim_gender        gender       
          , convert(varchar, clim.clim_dob, 103)   dob       
          , clim_stam_cd            stam_cd       
          , stam.stam_desc          stam_desc       
         , clicm.clicm_id          clicm_id      
          , clim.clim_clicm_cd      clicm_cd       
          , clicm.clicm_desc        clicm_desc       
          , clim.clim_rmks          remarks      
     FROM   client_mstr             clim       
        ,   entity_type_mstr        enttm       
        ,   status_mstr             stam       
        ,   client_ctgry_mstr       clicm       
     WHERE clim.clim_enttm_cd     = enttm.enttm_cd       
     AND   clim.clim_stam_cd      = stam.stam_cd       
     AND   clim.clim_clicm_cd     = clicm.clicm_cd       
     AND   enttm.enttm_deleted_ind= 1       
     AND   clim.clim_deleted_ind  = 1       
     and   clim.clim_crn_no       like case when ltrim(rtrim(@pa_crn_no))     = '' then '%' else @pa_crn_no     end           
     AND   clim_lst_upd_by        IN (SELECT logn_name FROM login_names , @t_ent_id WHERE logn_ent_id = ent_id AND logn_deleted_ind = 1)      
 --      
 END      
 ELSE IF @pa_crn_no <> ''      
 BEGIN     
 --      
   SELECT clim.clim_crn_no        crn_no       
        , enttm.enttm_id          enttm_id       
        , clim.clim_enttm_cd      enttm_cd       
        , clim.clim_name1         name1       
        , clim.clim_name2         name2       
        , clim.clim_name3         name3       
        , clim.clim_short_name    short_name       
        , clim.clim_gender        gender       
        , convert(varchar, clim.clim_dob, 103)   dob       
        , clim_stam_cd            stam_cd       
        , stam.stam_desc          stam_desc       
        , clicm.clicm_id          clicm_id      
        , clim.clim_clicm_cd      clicm_cd       
        , clicm.clicm_desc        clicm_desc       
        , clim.clim_rmks          remarks      
   FROM   client_mstr             clim       
      ,   entity_type_mstr        enttm       
      ,   status_mstr             stam       
      , client_ctgry_mstr       clicm       
   WHERE clim.clim_enttm_cd     = enttm.enttm_cd       
   AND   clim.clim_stam_cd      = stam.stam_cd       
   AND   clim.clim_clicm_cd     = clicm.clicm_cd       
   AND   enttm.enttm_deleted_ind= 1       
   AND   clim.clim_deleted_ind  = 1       
   and   clim.clim_crn_no       like case when ltrim(rtrim(@pa_crn_no))     = '' then '%' else @pa_crn_no     end           
 --      
 END      
         
      
      
--      
END      
END--CHK_YN=0          
ELSE IF @PA_CHK_YN=1          
BEGIN          
--          
  IF @PA_TAB = 'CLIM_NEW'          
  BEGIN          
  --          
    SELECT DISTINCT CLIM.CLIM_CRN_NO                         CLIM_CRN_NO          
                  , CLIM.CLIM_NAME1                          CLIM_NAME1          
                  , ISNULL(CLIM.CLIM_NAME2, '')              CLIM_NAME2          
                  , ISNULL(CLIM.CLIM_NAME3, '')              CLIM_NAME3          
                  , CLIM.CLIM_SHORT_NAME                     CLIM_SHORT_NAME          
                  , CLIM.CLIM_GENDER                         CLIM_GENDER          
                  , CONVERT(VARCHAR(11), CLIM.CLIM_DOB, 103) CLIM_DOB          
                  , ENTTM.ENTTM_CD                           ENTTM_CD          
                  , ENTTM.ENTTM_ID                           ENTTM_ID          
                  , ENTTM.ENTTM_DESC                     ENTTM_DESC          
                  , CLIM.CLIM_STAM_CD                        CLIM_STAM_CD          
                  , CLIM.CLIM_CLICM_CD                       CLIM_CLICM_CD          
                  , CLICM.CLICM_ID                           CLICM_ID     
                  , CLIA.clia_acct_no                     clia_acct_no            
    FROM CLIENT_MSTR  CLIM      WITH (NOLOCK)          
         LEFT OUTER JOIN          
         CLIENT_ACCOUNTS CLIA   WITH (NOLOCK)          
    ON  (CLIA.CLIA_CRN_NO = CLIM.CLIM_CRN_NO)          
         LEFT OUTER JOIN  ENTITY_PROPERTIES ENTP WITH (NOLOCK)          
    ON  (ENTP.ENTP_ENT_ID = CLIM.CLIM_CRN_NO)          
        ,ENTITY_TYPE_MSTR      ENTTM          
        ,CLIENT_CTGRY_MSTR     CLICM          
    WHERE CLIM.CLIM_DELETED_IND                  = 1          
    AND   ISNULL(CLIA.CLIA_DELETED_IND,1)        = 1          
    AND   ISNULL(ENTP.ENTP_DELETED_IND,1)        = 1          
    AND   ENTTM.ENTTM_DELETED_IND                = 1           
    AND   CLICM.CLICM_DELETED_IND                = 1          
    AND   CLICM.CLICM_CD                         = CLIM.CLIM_CLICM_CD          
    AND   CLIM.CLIM_ENTTM_CD                     = ENTTM.ENTTM_CD          
    AND   CLIM.CLIM_CRN_NO                       LIKE CASE WHEN LTRIM(RTRIM(@PA_CRN_NO))     = '' THEN '%' ELSE @PA_CRN_NO     END          
    AND   CLIM.CLIM_SHORT_NAME                   LIKE CASE WHEN LTRIM(RTRIM(@PA_SHORT_NAME)) = '' THEN '%' ELSE @PA_SHORT_NAME + '%' END          
    AND   CLIM.CLIM_STAM_CD                      LIKE CASE WHEN LTRIM(RTRIM(@PA_STAM_CD))    = '' THEN '%' ELSE @PA_STAM_CD    END          
    AND   CLIM.CLIM_CLICM_CD                     LIKE CASE WHEN LTRIM(RTRIM(@PA_CLICM_CD))   = '' THEN '%' ELSE @PA_CLICM_CD   END          
    AND   CLIM.CLIM_ENTTM_CD                     LIKE CASE WHEN LTRIM(RTRIM(@PA_ENTTM_CD))   = '' THEN '%' ELSE @PA_ENTTM_CD   END          
    AND   CONVERT(VARCHAR(11),CLIM.CLIM_DOB,103) =    CASE WHEN LTRIM(RTRIM(@PA_DOB))        = '' THEN   CONVERT(VARCHAR(11),CLIM.CLIM_DOB,103) ELSE @PA_DOB END          
    AND   ISNULL(CLIA.CLIA_ACCT_NO, '%')         LIKE CASE WHEN LTRIM(RTRIM(@PA_ACCT_NO))    = '' THEN '%' ELSE @PA_ACCT_NO    + '%' END          
    AND   ISNULL(ENTP.ENTP_ENTPM_CD,'%')         LIKE CASE WHEN LTRIM(RTRIM(@PA_ENTPM_CD))   = '' THEN '%' ELSE @PA_ENTPM_CD   END          
    AND   ISNULL(ENTP.ENTP_VALUE,'%')            LIKE CASE WHEN LTRIM(RTRIM(@PA_ENTP_VALUE)) = '' THEN '%' ELSE @PA_ENTP_VALUE + '%' END            
    AND   CLIM.CLIM_CRN_NO                       IN (SELECT distinct clim_crn_no FROM client_list WHERE clim_deleted_ind=1 and clim_status = 0)          
          
    UNION          
              
    SELECT DISTINCT CLIM.CLIM_CRN_NO                         CLIM_CRN_NO          
                  , CLIM.CLIM_NAME1                          CLIM_NAME1          
                  , ISNULL(CLIM.CLIM_NAME2, '') CLIM_NAME2          
                  , ISNULL(CLIM.CLIM_NAME3, '')              CLIM_NAME3          
                  , CLIM.CLIM_SHORT_NAME                     CLIM_SHORT_NAME          
                  , CLIM.CLIM_GENDER                         CLIM_GENDER          
                  , CONVERT(VARCHAR(11), CLIM.CLIM_DOB, 103) CLIM_DOB          
                  , ENTTM.ENTTM_CD                           ENTTM_CD          
                  , ENTTM.ENTTM_ID                           ENTTM_ID          
                  , ENTTM.ENTTM_DESC                         ENTTM_DESC          
                  , CLIM.CLIM_STAM_CD                        CLIM_STAM_CD          
                  , CLIM.CLIM_CLICM_CD                       CLIM_CLICM_CD          
                  , CLICM.CLICM_ID                           CLICM_ID     
                   , CLIA.clia_acct_no                     clia_acct_no             
    FROM CLIENT_MSTR_MAK  CLIM      WITH (NOLOCK)          
         LEFT OUTER JOIN          
         CLIENT_ACCOUNTS_MAK CLIA   WITH (NOLOCK)          
    ON  (CLIA.CLIA_CRN_NO = CLIM.CLIM_CRN_NO)          
         LEFT OUTER JOIN  ENTITY_PROPERTIES_MAK ENTP WITH (NOLOCK)          
    ON  (ENTP.ENTP_ENT_ID = CLIM.CLIM_CRN_NO)          
        ,ENTITY_TYPE_MSTR      ENTTM          
        ,CLIENT_CTGRY_MSTR     CLICM          
    WHERE CLIM.CLIM_DELETED_IND                  IN(0,8)          
    AND   ISNULL(CLIA.CLIA_DELETED_IND,0)        IN(0,8)           
    AND   ISNULL(ENTP.ENTP_DELETED_IND,0)        IN(0,8)           
    AND   ENTTM.ENTTM_DELETED_IND                = 1           
    AND   CLICM.CLICM_DELETED_IND                = 1          
    AND   CLICM.CLICM_CD                         = CLIM.CLIM_CLICM_CD          
    AND   CLIM.CLIM_ENTTM_CD                     = ENTTM.ENTTM_CD      
    AND   CLIM.CLIM_CRN_NO                       LIKE CASE WHEN LTRIM(RTRIM(@PA_CRN_NO))     = '' THEN '%' ELSE @PA_CRN_NO     END          
    AND   CLIM.CLIM_SHORT_NAME                   LIKE CASE WHEN LTRIM(RTRIM(@PA_SHORT_NAME)) = '' THEN '%' ELSE @PA_SHORT_NAME + '%' END          
    AND   CLIM.CLIM_STAM_CD                      LIKE CASE WHEN LTRIM(RTRIM(@PA_STAM_CD))    = '' THEN '%' ELSE @PA_STAM_CD    END          
    AND   CLIM.CLIM_CLICM_CD                     LIKE CASE WHEN LTRIM(RTRIM(@PA_CLICM_CD))   = '' THEN '%' ELSE @PA_CLICM_CD   END          
    AND   CLIM.CLIM_ENTTM_CD                     LIKE CASE WHEN LTRIM(RTRIM(@PA_ENTTM_CD))   = '' THEN '%' ELSE @PA_ENTTM_CD   END          
    AND   CONVERT(VARCHAR(11),CLIM.CLIM_DOB,103) =    CASE WHEN LTRIM(RTRIM(@PA_DOB))        = '' THEN   CONVERT(VARCHAR(11),CLIM.CLIM_DOB,103) ELSE @PA_DOB END          
    AND   ISNULL(CLIA.CLIA_ACCT_NO, '%')         LIKE CASE WHEN LTRIM(RTRIM(@PA_ACCT_NO))    = '' THEN '%' ELSE @PA_ACCT_NO   + '%' END          
    AND   ISNULL(ENTP.ENTP_ENTPM_CD,'%')         LIKE CASE WHEN LTRIM(RTRIM(@PA_ENTPM_CD))   = '' THEN '%' ELSE @PA_ENTPM_CD   END          
    AND   ISNULL(ENTP.ENTP_VALUE,'%')            LIKE CASE WHEN LTRIM(RTRIM(@PA_ENTP_VALUE)) = '' THEN '%' ELSE @PA_ENTP_VALUE + '%' END            
    AND   CLIM.CLIM_CRN_NO                       IN (SELECT distinct clim_crn_no FROM client_list WHERE clim_deleted_ind=1 and clim_status = 0)          
    AND   CLIM.CLIM_CRN_NO                   NOT IN (SELECT distinct clim_crn_no FROM client_mstr WHERE clim_deleted_ind=1)          
    AND   CLIM.CLIM_LST_UPD_BY                   = @PA_LOGIN_NAME      
              
  --          
  END          
  ELSE IF @PA_TAB = 'ENTM_NEW'           
  BEGIN          
  --          
   SELECT DISTINCT ENTM.ENTM_ID          ENTM_ID          
                 , ENTM.ENTM_NAME1       ENTM_NAME1          
                 , ENTM.ENTM_NAME2       ENTM_NAME2          
                 , ENTM.ENTM_NAME3       ENTM_NAME3          
                 , ENTM.ENTM_SHORT_NAME  ENTM_SHORT_NAME          
                 , ENTM.ENTM_PARENT_ID   PARENT_ID          
                 , CLICM.CLICM_ID        CLICM_ID          
                 , CLICM.CLICM_CD         CLICM_CD          
                 , ENTTM.ENTTM_ID        ENTTM_ID          
                 , ENTTM.ENTTM_CD         ENTTM_CD          
                 , ENTM.ENTM_NAME1       PARENT_NAME1          
                           
   FROM  ENTITY_MSTR  ENTM WITH (NOLOCK)          
   LEFT OUTER JOIN  ENTITY_PROPERTIES ENTP WITH (NOLOCK)          
   ON ENTP.ENTP_ENT_ID                 = ENTM.ENTM_ID          
   ,    CLIENT_CTGRY_MSTR  CLICM           
   ,    ENTITY_TYPE_MSTR   ENTTM          
            
   WHERE  ENTM.ENTM_CLICM_CD=CLICM.CLICM_CD           
   AND   ENTM.ENTM_ENTTM_CD=ENTTM.ENTTM_CD          
   AND   CONVERT(VARCHAR, ENTM.ENTM_ID)   LIKE CASE WHEN LTRIM(RTRIM(@PA_CRN_NO))     = '' THEN '%' ELSE @PA_CRN_NO     END          
   AND   ENTM.ENTM_SHORT_NAME             LIKE CASE WHEN LTRIM(RTRIM(@PA_SHORT_NAME)) = '' THEN '%' ELSE @PA_SHORT_NAME + '%' END          
   AND   ENTM.ENTM_ENTTM_CD               LIKE CASE WHEN LTRIM(RTRIM(@PA_ENTTM_CD))   = '' THEN '%' ELSE @PA_ENTTM_CD   END          
   AND   ISNULL(ENTP.ENTP_ENTPM_CD, '%')  LIKE CASE WHEN LTRIM(RTRIM(@PA_ENTPM_CD))   = '' THEN '%' ELSE @PA_ENTPM_CD   END          
   AND   ISNULL(ENTP.ENTP_VALUE, '%')     LIKE CASE WHEN LTRIM(RTRIM(@PA_ENTP_VALUE)) = '' THEN '%' ELSE @PA_ENTP_VALUE + '%' END          
   AND   ENTM.ENTM_CLICM_CD               LIKE CASE WHEN LTRIM(RTRIM(@PA_CLICM_CD))   = '' THEN '%' ELSE @PA_CLICM_CD   END          
   AND   ENTM.ENTM_DELETED_IND            = 1          
   AND   CLICM.CLICM_DELETED_IND          = 1          
   AND   ENTTM.ENTTM_DELETED_IND          = 1          
   AND   ENTM.ENTM_ID                    IN (SELECT distinct ENTM_ID FROM ENTITY_LIST WHERE ENTM_DELETED_IND=1)          
          
          
   UNION           
          
   SELECT DISTINCT ENTM.ENTM_ID          ENTM_ID          
                 , ENTM.ENTM_NAME1       ENTM_NAME1          
                 , ENTM.ENTM_NAME2       ENTM_NAME2          
    , ENTM.ENTM_NAME3       ENTM_NAME3          
                 , ENTM.ENTM_SHORT_NAME  ENTM_SHORT_NAME          
                 , ENTM.ENTM_PARENT_ID   PARENT_ID          
                 , CLICM.CLICM_ID        CLICM_ID          
                 , CLICM.CLICM_CD         CLICM_CD          
                 , ENTTM.ENTTM_ID        ENTTM_ID          
                 , ENTTM.ENTTM_CD         ENTTM_CD          
                 , ENTM.ENTM_NAME1       PARENT_NAME1          
                           
   FROM  ENTITY_MSTR_MAK       ENTM WITH (NOLOCK)          
   LEFT OUTER JOIN  ENTITY_PROPERTIES_MAK ENTP WITH (NOLOCK)          
   ON ENTP.ENTP_ENT_ID                 = ENTM.ENTM_ID  AND   ENTP.ENTP_DELETED_IND            IN(0,8)            
   ,    CLIENT_CTGRY_MSTR  CLICM           
   ,    ENTITY_TYPE_MSTR   ENTTM          
            
   WHERE  ENTM.ENTM_CLICM_CD=CLICM.CLICM_CD           
   AND   ENTM.ENTM_ENTTM_CD=ENTTM.ENTTM_CD          
   AND   CONVERT(VARCHAR, ENTM.ENTM_ID)   LIKE CASE WHEN LTRIM(RTRIM(@PA_CRN_NO))     = '' THEN '%' ELSE @PA_CRN_NO     END          
   AND   ENTM.ENTM_SHORT_NAME             LIKE CASE WHEN LTRIM(RTRIM(@PA_SHORT_NAME)) = '' THEN '%' ELSE @PA_SHORT_NAME + '%' END          
   AND   ENTM.ENTM_ENTTM_CD               LIKE CASE WHEN LTRIM(RTRIM(@PA_ENTTM_CD))   = '' THEN '%' ELSE @PA_ENTTM_CD   END          
   AND   ISNULL(ENTP.ENTP_ENTPM_CD, '%')  LIKE CASE WHEN LTRIM(RTRIM(@PA_ENTPM_CD))   = '' THEN '%' ELSE @PA_ENTPM_CD   END          
   AND   ISNULL(ENTP.ENTP_VALUE, '%')     LIKE CASE WHEN LTRIM(RTRIM(@PA_ENTP_VALUE)) = '' THEN '%' ELSE @PA_ENTP_VALUE + '%' END          
   AND   ENTM.ENTM_CLICM_CD               LIKE CASE WHEN LTRIM(RTRIM(@PA_CLICM_CD))   = '' THEN '%' ELSE @PA_CLICM_CD   END          
   AND   ENTM.ENTM_DELETED_IND            IN(0,8)          
           
   AND   CLICM.CLICM_DELETED_IND          = 1          
   AND   ENTTM.ENTTM_DELETED_IND          = 1          
   AND   ENTM.ENTM_ID                    IN (SELECT distinct ENTM_ID FROM ENTITY_LIST WHERE ENTM_DELETED_IND=1)          
   AND   ENTM.ENTM_ID                    NOT IN (SELECT distinct ENTM_ID FROM ENTITY_MSTR WHERE ENTM_DELETED_IND=1)          
   AND   ENTM.ENTM_LST_UPD_BY             = @PA_LOGIN_NAME      
             
  --          
  END          
  ELSE IF @PA_TAB = 'ENTP_CLI'          
  BEGIN          
  --          
    SELECT DISTINCT ENTPM.ENTPM_CD     PROPERTY_CODE          
         , ENTPM.ENTPM_DESC            PROPERTY_DESC          
    FROM   ENTITY_PROPERTY_MSTR        ENTPM  WITH (NOLOCK)          
         , ENTITY_TYPE_MSTR            ENTTM  WITH (NOLOCK)          
    WHERE  ENTPM.ENTPM_ENTTM_ID      = ENTTM.ENTTM_ID          
    AND    ENTPM.ENTPM_DELETED_IND   = 1          
    AND    ENTTM.ENTTM_DELETED_IND   = 1          
    AND    ENTTM.ENTTM_CLI_YN & 2    = 2      
 --          
 END          
 ELSE IF @PA_TAB = 'ENTP_ENT'          
 BEGIN          
 --          
   SELECT DISTINCT ENTPM.ENTPM_CD  PROPERTY_CODE          
        , ENTPM.ENTPM_DESC         PROPERTY_DESC          
   FROM ENTITY_PROPERTY_MSTR       ENTPM WITH (NOLOCK)          
      , ENTITY_TYPE_MSTR           ENTTM WITH (NOLOCK)          
   WHERE  ENTPM.ENTPM_ENTTM_ID      = ENTTM.ENTTM_ID          
   AND    ENTPM.ENTPM_DELETED_IND   = 1          
   AND    ENTTM.ENTTM_DELETED_IND   = 1          
   AND    ENTTM.ENTTM_CLI_YN & 1    = 1          
 --          
 END          
 ELSE IF @pa_tab = 'CLIM_PAN_SEARCH'          
 BEGIN          
 --
select top 1 * from           
  ( SELECT DISTINCT clim.clim_crn_no           clim_crn_no          
        , clim.clim_name1                     clim_name1          
        , ISNULL(clim.clim_name2, '')         clim_name2          
        , ISNULL(clim.clim_name3, '')         clim_name3          
        , clim.clim_short_name                clim_short_name          
        , enttm.enttm_id                      enttm_id          
        , clicm.clicm_id                      clicm_id          
        , entp.entp_value                     entp_value,2 mkrchkr          
   FROM   client_mstr                         clim  WITH (NOLOCK)     LEFT OUTER JOIN             
          entity_properties                   entp  WITH (NOLOCK)            
   ON     (entp.entp_ent_id                 = clim.clim_crn_no)               
        , entity_type_mstr                    enttm WITH (NOLOCK)          
        , client_ctgry_mstr                   clicm WITH (NOLOCK)          
   WHERE  isnull(clim.clim_enttm_cd,'cli') = enttm.enttm_cd          
   AND    clicm.clicm_cd                    = isnull(clim.clim_clicm_cd,'nrm')          
   AND    entp.entp_entpm_cd                = 'PAN_GIR_NO'          
   AND    ISNULL(entp.entp_value,'%')       = LTRIM(RTRIM(@pa_entp_value)) 
   AND    clim.clim_deleted_ind             = 1          
   AND    enttm.enttm_deleted_ind           = 1          
   AND    ISNULL(entp.entp_deleted_ind, 1)  = 1          
   AND    clicm.clicm_deleted_ind           = 1          
        
   UNION        
        
   SELECT DISTINCT clim.clim_crn_no           clim_crn_no          
        , clim.clim_name1                     clim_name1          
        , ISNULL(clim.clim_name2, ' ')        clim_name2          
        , ISNULL(clim.clim_name3, ' ')        clim_name3          
        , clim.clim_short_name                clim_short_name          
        , enttm.enttm_id                      enttm_id          
        , clicm.clicm_id       clicm_id          
        , entp.entp_value                     entp_value, 1 mkrchkr          
   FROM   client_mstr_MAK                     clim  WITH (NOLOCK)     LEFT OUTER JOIN             
          entity_properties_MAK               entp  WITH (NOLOCK)            
   ON     (entp.entp_ent_id                 = clim.clim_crn_no)               
        , entity_type_mstr                    enttm WITH (NOLOCK)          
        , client_ctgry_mstr                   clicm WITH (NOLOCK)          
   WHERE  isnull(clim.clim_enttm_cd,'cli') = enttm.enttm_cd          
   AND    clicm.clicm_cd                    = isnull(clim.clim_clicm_cd,'nrm')         
   AND    entp.entp_entpm_cd                = 'PAN_GIR_NO'          
   AND    ISNULL(entp.entp_value,'%')      = LTRIM(RTRIM(@pa_entp_value)) 
   AND    clim.clim_deleted_ind             IN (0,8)        
   AND    enttm.enttm_deleted_ind           = 1          
   AND    ISNULL(entp.entp_deleted_ind, 0)  IN (0,8)        
        
   AND    clicm.clicm_deleted_ind           = 1 
)
tmp 
order by mkrchkr asc         
 --     

 END          
--          
END      
--      
IF @pa_tab = 'CLIENT_DP'      
BEGIN      
--      
  SET @l_string = 'SELECT DISTINCT cm.clim_crn_no  clim_crn_no '        
  SET @l_string = @l_string + ', cm.clim_name1 clim_name1 '      
  SET @l_string = @l_string + ', cm.clim_name2 clim_name2 '      
  SET @l_string = @l_string + ', cm.clim_name3 clim_name3 '      
  SET @l_string = @l_string + ', cm.clim_short_name clim_short_name '      
  SET @l_string = @l_string + ', cm.clim_gender clim_gender '      
  SET @l_string = @l_string + ', convert(varchar, cm.clim_dob, 103) clim_dob '      
  SET @l_string = @l_string + ', stam.stam_id stam_id '      
  SET @l_string = @l_string + ', stam.stam_cd stam_cd '      
  SET @l_string = @l_string + ', stam.stam_desc stam_desc '      
  SET @l_string = @l_string + ', sm.sbum_id sbum_id '      
  SET @l_string = @l_string + ', sm.sbum_cd sbum_cd '      
  SET @l_string = @l_string + ', sm.sbum_desc  sbum_desc '       
  SET @l_string = @l_string + 'FROM client_mstr cm      WITH (NOLOCK) '      
  SET @l_string = @l_string + ',dp_acct_mstr dpam       WITH (NOLOCK) '      
  SET @l_string = @l_string + ',entity_properties entp  WITH (NOLOCK) '      
  SET @l_string = @l_string + ',status_mstr stam        WITH (NOLOCK) '      
  SET @l_string = @l_string + ',sbu_mstr sm             WITH (NOLOCK) '      
  SET @l_string = @l_string + 'WHERE  clim_sbum_id = sm.sbum_id '      
  --        
  IF @pa_short_name <> ''          
  BEGIN          
  --          
    SET @l_string = @l_string + 'and cm.clim_short_name like case when ltrim(rtrim('''+@pa_short_name+''')) = '''' THEN ''%'' ELSE '''+ @pa_short_name + '%'''+' END '          
  --          
  END      
  --      
  IF @pa_stam_cd <> ''          
  BEGIN          
  --          
    SET @l_string = @l_string + 'and cm.clim_stam_cd like case when ltrim(rtrim('''+@pa_stam_cd+'''))    = '''' THEN ''%'' ELSE ''' + @pa_stam_cd + '''    END '            
  --          
  END      
  --      
  IF @PA_DOB <> ''          
  BEGIN          
  --          
    SET @l_string = @l_string + 'and convert(varchar(11),cm.clim_dob,103) = CASE WHEN ltrim(rtrim('''+@pa_dob+'''))        = '''' THEN   CONVERT(VARCHAR(11),cm.clim_dob,103) ELSE '''+@pa_dob+''' END '          
  --          
  END      
  --      
  IF @pa_entpm_cd <> ''          
  BEGIN          
  --          
    SET @l_string = @l_string + 'and isnull(entp.entp_entpm_cd,''%'') like case when ltrim(rtrim('''+@pa_entpm_cd+'''))   = '''' THEN ''%'' ELSE '''+@pa_entpm_cd+'''   END '          
  --          
  END          
  --      
  IF @pa_entp_value <> ''          
  BEGIN          
  --          
    SET @l_string = @l_string + 'and isnull(entp.entp_value,''%'') like case when ltrim(rtrim('''+@pa_entp_value+''')) = '''' THEN ''%'' ELSE '''+@pa_entp_value+ '%'''+' END '          
  --          
  END      
  --      
  IF @pa_acct_no <> ''          
  BEGIN          
  --          
    SET @l_string = @l_string + 'and isnull(dpam.dpam_sba_no, ''%'') like case when ltrim(rtrim('''+@pa_acct_no+'''))    = '''' THEN ''%'' ELSE '''+@pa_acct_no + '%'''+' END '          
  --          
  END          
  --      
  --SET @l_string = @l_string + 'and cm.clim_crn_no        = convert(numeric, '''+@pa_crn_no+''') '      
  SET @l_string = @l_string + 'and cm.clim_stam_cd       = stam.stam_cd '      
  SET @l_string = @l_string + 'and dpam.dpam_crn_no      = cm.clim_crn_no '      
  SET @l_string = @l_string + 'and entp.entp_ent_id      = cm.clim_crn_no '      
  SET @l_string = @l_string + 'and cm.clim_deleted_ind   = 1 '      
  SET @l_string = @l_string + 'and stam.stam_deleted_ind = 1 '      
  SET @l_string = @l_string + 'and sm.sbum_deleted_ind   = 1 '      
  SET @l_string = @l_string + 'and sm.sbum_deleted_ind   = 1 '      
  SET @l_string = @l_string + 'and entp.entp_deleted_ind = 1 '      
  --      
  --print @l_string      
  execute(@l_string)      
--      
END      
--          
END

GO
