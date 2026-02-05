-- Object: PROCEDURE citrus_usr.pr_search_clidp
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--exec [pr_search_clidp] 'a','','','','','','','','','','client_dp_new','HO',2,'*|~*','|*~|',''
CREATE  PROCEDURE [citrus_usr].[pr_search_clidp](@pa_crn_no        varchar(1000)        
                               ,@pa_form_no       varchar(25)        
                               ,@pa_sba_no        varchar(25)        
                               ,@pa_short_name    varchar(50)        
                               ,@pa_stam_cd       varchar(20)        
                               ,@pa_clicm_cd      varchar(20)        
                               ,@pa_enttm_cd      varchar(20)        
                               ,@pa_dob           varchar(11)        
                               ,@pa_entpm_cd      varchar(20)        
                               ,@pa_entp_value    varchar(50)        
                               ,@pa_tab           varchar(50)        
                               ,@pa_login_name    varchar(20)        
                               ,@pa_chk_yn        numeric        
                               ,@rowdelimiter     varchar(4) = '*|~*'        
                               ,@coldelimiter     varchar(4) = '|*~|'        
                               ,@pa_ref_cur       varchar(8000) output        
                               )        
AS        
/*    
*******************************************************************************        
 SYSTEM         : CITRUS        
 MODULE NAME    : PR_SEARCH_CLIDP        
 DESCRIPTION    : SCRIPT TO SELECT CLIENT_DP_MSTR WITH VARIOUS SEARCH CRITERIA        
 COPYRIGHT(C)   : MARKETPLACE TECHNOLOGIES PVT. LTD.        
 VERSION HISTORY:        
 VERS.  AUTHOR          DATE         REASON        
 -----  -------------   ----------   ---------------------------------------    
 1.0    SUKHVINDER      17-AUG-2007  INITIAL VERSION.        
 -----  -------------   ----------   ---------------------------------------    
 ******************************************************************************    
*/     
BEGIN    
--    
  DECLARE @l_string       varchar(8000)    
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


  IF @pa_chk_yn = 0  or @pa_chk_yn = 2       
  BEGIN--chk_0_2    
  --    
   IF @pa_tab = 'client_dp_new'    
   BEGIN    
   --           
    
     SET @l_string = 'SELECT DISTINCT cm.clim_crn_no  clim_crn_no '      
     SET @l_string = @l_string + ' , cm.clim_name1 clim_name1 '    
     SET @l_string = @l_string + ' , cm.clim_name2 clim_name2 '    
     SET @l_string = @l_string + ' , cm.clim_name3 clim_name3 '    
     SET @l_string = @l_string + ' , cm.clim_short_name clim_short_name '    
     SET @l_string = @l_string + ' , cm.clim_gender clim_gender '    
     SET @l_string = @l_string + ' , convert(varchar, cm.clim_dob, 103) clim_dob '    
     SET @l_string = @l_string + ' , stam.stam_id stam_id '    
     SET @l_string = @l_string + ' , stam.stam_cd stam_cd '    
     SET @l_string = @l_string + ' , stam.stam_desc stam_desc '    
     SET @l_string = @l_string + ' , sm.sbum_id sbum_id '    
     SET @l_string = @l_string + ' , sm.sbum_cd sbum_cd '    
     SET @l_string = @l_string + ' , sm.sbum_desc  sbum_desc '   
      SET @l_string = @l_string + ', dpam_sba_no , citrus_usr.fn_ucc_entp(clim_crn_no,''PAN_GIR_NO'','''') [pan no]'       
     SET @l_string = @l_string + ' FROM client_mstr cm      WITH (NOLOCK) '    
    -- IF @pa_sba_no <> ''    or   @pa_form_no <> ''  or @pa_clicm_cd <> '' or @pa_enttm_cd <> '' or @pa_stam_cd <> ''
     --SET @l_string = @l_string + ' left outer join  dp_acct_mstr dpam       WITH (NOLOCK)  on dpam.dpam_crn_no      = cm.clim_crn_no  '    
	 IF @pa_entpm_cd ='BBO_CODE'
	begin
     SET @l_string = @l_string + ' left outer join  dp_acct_mstr dpam       WITH (NOLOCK)  on dpam.dpam_crn_no      = cm.clim_crn_no and dpam_deleted_ind=1 '    
	end
	else
	begin 
	 SET @l_string = @l_string + ' left outer join  dp_acct_mstr dpam       WITH (NOLOCK)  on dpam.dpam_crn_no      = cm.clim_crn_no  '    
	end
     IF (@pa_entp_value <> '' AND  @pa_entpm_cd <>'BBO_CODE')  
     SET @l_string = @l_string + ' ,entity_properties entp  WITH (NOLOCK)' 
	 IF @pa_entpm_cd ='BBO_CODE' 
     SET @l_string = @l_string + ' ,account_properties accp  WITH (NOLOCK)'   
     IF isnull(@l_ent_id,'0') <> '0'
     SET @l_string = @l_string + ' ,entity_relationship entr       WITH (NOLOCK)  '
     SET @l_string = @l_string + ' ,status_mstr stam        WITH (NOLOCK)'    
     SET @l_string = @l_string + ' ,sbu_mstr sm             WITH (NOLOCK)'    
     SET @l_string = @l_string + ' ,entity_type_mstr enttm  WITH (NOLOCK)'    
     SET @l_string = @l_string + ' ,client_ctgry_mstr clicm WITH (NOLOCK)'    
     SET @l_string = @l_string + ' WHERE  clim_sbum_id = sm.sbum_id'    
     SET @l_string = @l_string + ' AND    ISNULL(cm.clim_clicm_cd,''NRM'') = clicm.clicm_cd'    
     SET @l_string = @l_string + ' AND    ISNULL(cm.clim_enttm_cd,''CLI'')    = enttm.enttm_cd'    
     SET @l_string = @l_string + ' AND    cm.clim_sbum_id                      LIKE CASE WHEN LTRIM(RTRIM('''+@l_sbum_id+'''))    = ''0'' THEN ''%'' ELSE ''' +  @l_sbum_id +'''    END    '    
     IF isnull(@l_ent_id,'0') <> '0'
     SET @l_string = @l_string + 'and entr.ENTR_CRN_NO = cm.clim_crn_no and entr.entr_deleted_ind = 1 and (entr_ho =' + convert(varchar,@l_ent_id )  + ' or entr_ar = ' + convert(varchar,@l_ent_id )  + ' )'     
     -- 

      if isnull(@pa_crn_no,'') <> ''
	  SET @l_string = @l_string   + ' AND   cm.clim_name1 + '' '' + isnull(cm.clim_name2,'''')+ '' '' + isnull(cm.clim_name3,'''')                        LIKE CASE WHEN LTRIM(RTRIM('''+@pa_crn_no+'''))     = '''' THEN ''%''      ELSE '''+ @pa_crn_no        +'%''  END          '
	
     
     IF @pa_short_name <> ''        
     BEGIN        
     --        
       SET @l_string = @l_string + ' and cm.clim_short_name like case when ltrim(rtrim('''+@pa_short_name+''')) = '''' THEN ''%'' ELSE '''+ @pa_short_name + '%'''+' END '        
     --        
     END    
     --    
     IF @pa_stam_cd <> ''        
     BEGIN        
     --        
       SET @l_string = @l_string + ' and dpam.dpam_stam_Cd like case when ltrim(rtrim('''+@pa_stam_cd+'''))    = '''' THEN ''%'' ELSE ''' + @pa_stam_cd + '''    END '          
     --        
     END    
     --    
     IF @PA_DOB <> ''        
     BEGIN        
     --        
       SET @l_string = @l_string + ' and convert(varchar(11),cm.clim_dob,103) = CASE WHEN ltrim(rtrim('''+@pa_dob+'''))        = '''' THEN   CONVERT(VARCHAR(11),cm.clim_dob,103) ELSE '''+@pa_dob+''' END '        
     --        
     END    
     --    
     IF (@pa_entpm_cd <> ''  and @pa_entpm_cd <>'BBO_CODE')
     BEGIN        
     --        
       SET @l_string = @l_string + ' and isnull(entp.entp_entpm_cd,''%'') like case when ltrim(rtrim('''+@pa_entpm_cd+'''))   = '''' THEN ''%'' ELSE '''+@pa_entpm_cd+'''   END '        
     --        
     END        
     --    
     IF ( @pa_entpm_cd ='BBO_CODE')
     BEGIN        
     --        
       SET @l_string = @l_string + ' and isnull(accp.ACCP_ACCPM_PROP_CD,'''') = '''+@pa_entpm_cd+''''        
     --        
     END 
     IF (@pa_entp_value <> ''  and @pa_entpm_cd <>'BBO_CODE' )
     BEGIN        
     --        
       SET @l_string = @l_string + ' and isnull(entp.entp_value,''%'') like case when ltrim(rtrim('''+@pa_entp_value+''')) = '''' THEN ''%'' ELSE '''+@pa_entp_value+ '%'''+' END '        
       SET @l_string = @l_string + ' and entp.entp_ent_id      = cm.clim_crn_no '    
       SET @l_string = @l_string + ' and entp.entp_deleted_ind = 1 ' 
     --         
     END    
     --    
     IF (@pa_entpm_cd ='BBO_CODE' )
     BEGIN        
     --        
       SET @l_string = @l_string + ' and isnull(accp.accp_value,'''') = '''+@pa_entp_value+ ''''        
       SET @l_string = @l_string + ' and accp.accp_clisba_id      = dpam.dpam_id '    
       SET @l_string = @l_string + ' and accp.accp_deleted_ind = 1 ' 
     --         
     END    
     --    
     IF @pa_sba_no <> ''          
     BEGIN        
     --        
       SET @l_string = @l_string + ' and dpam.dpam_sba_no = ''' + @pa_sba_no + ''''        
     --        
     END        
     --    
     IF @pa_form_no <> ''        
     BEGIN        
     --        
        SET @l_string = @l_string + ' and dpam.dpam_acct_no = ''' + @pa_form_no + ''''       
     --        
     END        
     IF @pa_clicm_cd <> ''        
     BEGIN        
     --        
       SET @l_string = @l_string + ' AND   dpam.dpam_clicm_cd       = ''' +@pa_clicm_cd + '''' 
     --        
     END  
    IF @pa_enttm_cd <> ''        
     BEGIN        
     --        
       SET @l_string = @l_string + ' AND   dpam.dpam_enttm_cd    = '''+ @pa_enttm_cd +''''
     --        
     END  
     --    
     SET @l_string = @l_string + ' and cm.clim_stam_cd       = stam.stam_cd '    
     SET @l_string = @l_string + ' and cm.clim_deleted_ind   = 1 '    
     SET @l_string = @l_string + ' and stam.stam_deleted_ind = 1 '    
     SET @l_string = @l_string + ' and sm.sbum_deleted_ind   = 1 '    
     SET @l_string = @l_string + ' and sm.sbum_deleted_ind   = 1 '    
   


     
     --   
     print  @l_string
     execute(@l_string)    
   
   --    
   END    
  --     
  END--chk_0_2    
  -------------------------------------------------------------------------------------------------------------------------    
  ELSE IF @pa_chk_yn = 1     
  BEGIN    
  --    
    IF @pa_tab = 'client_dp_new'    
    BEGIN--chk_1   
     
    --    
      SET @l_string = 'SELECT distinct clim.clim_crn_no                clim_crn_no          '
      SET @l_string = @l_string   + '     , clim.clim_name1                          clim_name1          '
      SET @l_string = @l_string   + '     , isnull(clim.clim_name2, '''')              clim_name2         ' 
      SET @l_string = @l_string   + '     , isnull(clim.clim_name3, '''')              clim_name3         ' 
      SET @l_string = @l_string   + '     , clim.clim_short_name                     clim_short_name      '    
      SET @l_string = @l_string   + '     , clim.clim_gender       clim_gender          '
      SET @l_string = @l_string   + '     , convert(varchar(11), clim.clim_dob, 103) clim_dob          '
      SET @l_string = @l_string   + '     , ISNULL(enttm.enttm_cd,''CLI'')          enttm_cd          '
      SET @l_string = @l_string   + '     , enttm.enttm_id                           enttm_id          '
      SET @l_string = @l_string   + '     , enttm.enttm_desc                         enttm_desc          '
      SET @l_string = @l_string   + '     , clim.clim_stam_cd                        clim_stam_cd         ' 
      SET @l_string = @l_string   + '     , ISNULL(clim.clim_clicm_cd,''NRM'')         clim_clicm_cd        '  
      SET @l_string = @l_string   + '     , clicm.clicm_id                           clicm_id          '
      SET @l_string = @l_string   + ' , dpam_sba_no   ,citrus_usr.fn_ucc_entp_mak(clim_crn_no,''PAN_GIR_NO'','''') [pan no]'        
      SET @l_string = @l_string   + ' FROM  client_mstr                 clim          WITH (NOLOCK)          '
      SET @l_string = @l_string   + '       left outer join           dp_acct_mstr dpam  WITH (NOLOCK)   ON (dpam.dpam_crn_no  =  clim.clim_crn_no)       '   
      SET @l_string = @l_string   + '       left outer join           entity_properties  entp  WITH (NOLOCK) ON   (entp.entp_ent_id =  dpam.dpam_crn_no)  '        
      SET @l_string = @l_string   + '    ,  entity_type_mstr            enttm         WITH (NOLOCK)    '
      IF isnull(@l_ent_id,'0') <> '0'
      SET @l_string = @l_string + ' ,entity_relationship entr       WITH (NOLOCK)  '
      SET @l_string = @l_string   + '  ,  client_ctgry_mstr           clicm         WITH (NOLOCK)    '
      SET @l_string = @l_string   + ' WHERE clim.clim_deleted_ind                  = 1          '
      SET @l_string = @l_string   + ' AND   isnull(dpam.dpam_deleted_ind,1)        = 1          '
      SET @l_string = @l_string   + ' AND   isnull(entp.entp_deleted_ind,1)        = 1          '
      SET @l_string = @l_string   + ' AND   enttm.enttm_deleted_ind                = 1           '
      SET @l_string = @l_string   + ' AND   clicm.clicm_deleted_ind                = 1          '
      SET @l_string = @l_string   + ' AND   clicm.clicm_cd                         = ISNULL(clim.clim_clicm_cd,''NRM'')'          
      SET @l_string = @l_string   + ' AND   enttm.enttm_cd                         = ISNULL(clim.clim_enttm_cd,''CLI'')'     
      IF isnull(@l_ent_id,'0') <> '0'
       SET @l_string = @l_string + 'and entr.ENTR_CRN_NO = clim.clim_crn_no and entr.entr_deleted_ind = 1 and (entr_ho =' + convert(varchar,@l_ent_id )  + ' or entr_ar = ' + convert(varchar,@l_ent_id )  + ' )'     
       if isnull(@pa_crn_no,'') <> ''
	  SET @l_string = @l_string   + ' AND   clim.clim_name1 + '' '' + isnull(clim.clim_name2,'''')+ '' '' + isnull(clim.clim_name3,'''')                        LIKE CASE WHEN LTRIM(RTRIM('''+@pa_crn_no+'''))     = '''' THEN ''%''      ELSE '''+ @pa_crn_no        +'%''  END          '
	 if isnull(@pa_short_name,'') <> ''
	 SET @l_string = @l_string   + ' AND   clim.clim_short_name                   LIKE CASE WHEN LTRIM(RTRIM('''+@pa_short_name+''')) = '''' THEN ''%''      ELSE '''+ @pa_short_name   +'%'' END         '
	 if isnull(@pa_stam_cd,'') <> ''
	 SET @l_string = @l_string   + ' AND   dpam.dpam_stam_cd                      LIKE CASE WHEN LTRIM(RTRIM('''+@pa_stam_cd+'''))    = '''' THEN ''%''      ELSE '''+ @pa_stam_cd        + ''' END         ' 
	 if isnull(@pa_clicm_cd,'') <> ''
	 SET @l_string = @l_string   + ' AND   dpam.dpam_clicm_cd     = '''+@pa_clicm_cd+''''
	 if isnull(@pa_enttm_cd,'') <> ''
	 SET @l_string = @l_string   + ' AND   dpam.dpam_enttm_cd    = '''+@pa_enttm_cd+''''
	 if isnull(@pa_dob,'') <>''
	 SET @l_string = @l_string   + ' AND   convert(varchar(11),clim.clim_dob,103) =    CASE WHEN LTRIM(RTRIM('+@pa_dob+'))        = '''' THEN convert(varchar(11),clim.clim_dob,103) ELSE '  + @pa_dob  + ' END        '
	 if isnull(@pa_form_no,'') <> ''
	 SET @l_string = @l_string   + ' AND   dpam.dpam_acct_no   = ''' + @pa_form_no+''''
     if isnull(@pa_sba_no,'') <> ''
	 SET @l_string = @l_string   + ' AND   dpam.dpam_sba_no         ='''+@pa_sba_no+''''
	 if isnull(@pa_entpm_cd,'') <> ''
	 SET @l_string = @l_string   + ' AND   isnull(entp.entp_entpm_cd,''%'')         LIKE CASE WHEN LTRIM(RTRIM('''+@pa_entpm_cd+'''))   = '''' THEN ''%''      ELSE '''+ @pa_entpm_cd        + ''' END          '
	 if isnull(@pa_entp_value,'') <> ''
	 SET @l_string = @l_string   + ' AND   isnull(entp.entp_value,''%'')            LIKE CASE WHEN LTRIM(RTRIM('''+@pa_entp_value+''')) = '''' THEN ''%''     ELSE ''' +@pa_entp_value + + '%'' END    '
      SET @l_string = @l_string   + ' AND   clim.clim_crn_no                       IN (SELECT DISTINCT clim_crn_no FROM client_list WHERE clim_deleted_ind = 1 and clim_status in(0,1,4,20) ) '         
      SET @l_string = @l_string   + ' UNION    '
      SET @l_string = @l_string   + ' SELECT distinct clim.clim_crn_no                clim_crn_no          '
      SET @l_string = @l_string   + '      , clim.clim_name1                          clim_name1          '
      SET @l_string = @l_string   + '      , isnull(clim.clim_name2, '''')              clim_name2          '
      SET @l_string = @l_string   + '      , isnull(clim.clim_name3, '''')              clim_name3          '
      SET @l_string = @l_string   + '      , clim.clim_short_name                     clim_short_name   '       
      SET @l_string = @l_string   + '      , clim.clim_gender                         clim_gender       '   
      SET @l_string = @l_string   + '      , convert(varchar(11), clim.clim_dob, 103) clim_dob          '
      SET @l_string = @l_string   + '      , ISNULL(enttm.enttm_cd,''CLI'')          enttm_cd          '
      SET @l_string = @l_string   + '      , enttm.enttm_id                           enttm_id          '
      SET @l_string = @l_string   + '      , enttm.enttm_desc                         enttm_desc         ' 
      SET @l_string = @l_string   + '      , clim.clim_stam_cd                        clim_stam_cd       '   
      SET @l_string = @l_string   + '      , ISNULL(clim.clim_clicm_cd,''NRM'')         clim_clicm_cd      '    
      SET @l_string = @l_string   + '      , clicm.clicm_id                           clicm_id          '
      SET @l_string = @l_string + ' , dpam_sba_no   ,citrus_usr.fn_ucc_entp_mak(clim_crn_no,''PAN_GIR_NO'','''') [pan no]'       
      SET @l_string = @l_string   + ' FROM   client_mstr_mak                 clim     WITH (NOLOCK)    '      
      SET @l_string = @l_string   + '        left outer join  dp_acct_mstr_mak  dpam     WITH (NOLOCK)  ON  (dpam.dpam_crn_no = clim.clim_crn_no) '
      SET @l_string = @l_string   + '        left outer join      entity_properties_mak  entp WITH (NOLOCK)  ON     (entp.entp_ent_id = dpam.dpam_crn_no)  '          
      SET @l_string = @l_string   + '      , entity_type_mstr                enttm    WITH (NOLOCK)    '
      SET @l_string = @l_string   + '      , client_ctgry_mstr               clicm    WITH (NOLOCK)    '
      IF isnull(@l_ent_id,'0') <> '0'
      SET @l_string = @l_string + ' ,entity_relationship_mak entr      WITH (NOLOCK)  '
      SET @l_string = @l_string   + ' WHERE  clim.clim_deleted_ind                 IN (0,4,8)          '
      SET @l_string = @l_string   + ' AND    isnull(dpam.dpam_deleted_ind,0)       IN (0,4,8)          '
      SET @l_string = @l_string   + ' AND    isnull(entp.entp_deleted_ind,0)       IN (0,4,8)          '
      SET @l_string = @l_string   + ' AND    enttm.enttm_deleted_ind  = 1           '
      SET @l_string = @l_string   + ' AND    clicm.clicm_deleted_ind                = 1          '
      SET @l_string = @l_string   + ' AND    clicm.clicm_cd                         = ISNULL(clim.clim_clicm_cd,''NRM'')          '
      SET @l_string = @l_string   + ' AND    enttm.enttm_cd                         = ISNULL(clim.clim_enttm_cd,''CLI'')  '   
      IF isnull(@l_ent_id,'0') <> '0'
      SET @l_string = @l_string + 'and entr.ENTR_CRN_NO = clim.clim_crn_no  and (entr_ho =' + convert(varchar,@l_ent_id )  + ' or entr_ar = ' + convert(varchar,@l_ent_id )  + ' )'     
       if isnull(@pa_crn_no,'') <> ''
	  SET @l_string = @l_string   + ' AND   clim.clim_name1 + '' '' + isnull(clim.clim_name2,'''')+ '' '' + isnull(clim.clim_name3,'''')                        LIKE CASE WHEN LTRIM(RTRIM('''+@pa_crn_no+'''))     = '''' THEN ''%''      ELSE '''+ @pa_crn_no        +'%''  END          '
      if isnull(@pa_short_name,'') <> ''
						SET @l_string = @l_string   + ' AND   clim.clim_short_name                   LIKE CASE WHEN LTRIM(RTRIM('''+@pa_short_name+''')) = '''' THEN ''%''      ELSE '''+ @pa_short_name  +'%'' END         '
						if isnull(@pa_stam_cd,'') <> ''
						SET @l_string = @l_string   + ' AND   dpam.dpam_stam_cd                      LIKE CASE WHEN LTRIM(RTRIM('''+@pa_stam_cd+'''))    = '''' THEN ''%''      ELSE '''+ @pa_stam_cd        + ''' END         ' 
						if isnull(@pa_clicm_cd,'') <> ''
						SET @l_string = @l_string   + ' AND   dpam.dpam_clicm_cd    ='''+@pa_clicm_cd+''''
						if isnull(@pa_enttm_cd,'') <> ''
						SET @l_string = @l_string   + ' AND   dpam.dpam_enttm_cd)    ='''+@pa_enttm_cd+''''
						if isnull(@pa_dob,'') <>''
						SET @l_string = @l_string   + ' AND   convert(varchar(11),clim.clim_dob,103) =    CASE WHEN LTRIM(RTRIM('+@pa_dob+'))        = '''' THEN convert(varchar(11),clim.clim_dob,103) ELSE '  + @pa_dob  + ' END        '
						if isnull(@pa_form_no,'') <> ''
						SET @l_string = @l_string   + ' AND   dpam.dpam_acct_no        ='''+@pa_form_no+''''
                        if isnull(@pa_sba_no,'') <> ''
						SET @l_string = @l_string   + ' AND   dpam.dpam_sba_no        ='''+@pa_sba_no+''''
						if isnull(@pa_entpm_cd,'') <> ''
						SET @l_string = @l_string   + ' AND   isnull(entp.entp_entpm_cd,''%'')         LIKE CASE WHEN LTRIM(RTRIM('''+@pa_entpm_cd+'''))   = '''' THEN ''%''      ELSE '''+ @pa_entpm_cd        + ''' END          '
						if isnull(@pa_entp_value,'') <> ''
						SET @l_string = @l_string   + ' AND   isnull(entp.entp_value,''%'')            LIKE CASE WHEN LTRIM(RTRIM('''+@pa_entp_value+''')) = '''' THEN ''%''     ELSE ''' +@pa_entp_value ++ '%''  END    '
						SET @l_string = @l_string   + ' AND   clim.clim_crn_no                       IN (SELECT DISTINCT clim_crn_no FROM client_list WHERE clim_deleted_ind = 1 and clim_status in(0,1,4,10,20) ) '         
      SET @l_string = @l_string   + ' AND    clim.clim_crn_no                   NOT IN (SELECT DISTINCT clim_crn_no FROM client_mstr WHERE clim_deleted_ind = 1)  '      
      
      print @l_string 
      exec (@l_string )
    --     
    END--chk_1     
  --    
  END    
--    
END

GO
