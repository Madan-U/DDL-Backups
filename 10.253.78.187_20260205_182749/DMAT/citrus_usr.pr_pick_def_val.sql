-- Object: PROCEDURE citrus_usr.pr_pick_def_val
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--begin tran
--pr_pick_def_val 180615,'DP' 
--SELECT * FROM citrus_usr.ENTITY_PROPERTIES_MAK WHERE ENTP_ENT_ID = 180615
--rollback 
--SELECT * FROM CLIENT_MSTR_mak order by 1 desc
--select * from 
--select * from accp_mak  order by 1 desc
--select * from entity_properties_mak order by 1 desc
--select * from  dp_acct_mstr_MAK order by 1 desc
--select * from client_ctgry_mstr
--select * from account_property_mstr where accpm_default_val is not null
create PROCEDURE [citrus_usr].[pr_pick_def_val](@pa_crn_no NUMERIC,@pa_tab VARCHAR(50))  
AS  
BEGIN  
  
  DECLARE @L_ACCP_VALUE VARCHAR(8000)  
  , @L_accpd_VALUE VARCHAR(8000)  
  , @l_entp_value VARCHAR(8000)  
  , @l_entpd_value  VARCHAR(8000)  
  , @l_clicm_id NUMERIC  
  , @l_enttm_id NUMERIC  
  , @l_excpm_id NUMERIC  
  , @L_DPAM_ID NUMERIC   
  , @L_BEN_ACCT_NO VARCHAR(20)
 Declare @c_cursor cursor
  
  IF EXISTS(SELECT id FROM sysobjects WHERE NAME = 'L_TEMP_ENTPM' )
  DROP TABLE L_TEMP_ENTPM
  IF EXISTS(SELECT id FROM sysobjects WHERE NAME = 'L_TEMP_ENTDM' )
  DROP TABLE L_TEMP_ENTDM
  IF EXISTS(SELECT id FROM sysobjects WHERE NAME = 'L_TEMP_ACCPM' )
  DROP TABLE L_TEMP_ACCPM
  IF EXISTS(SELECT id FROM sysobjects WHERE NAME = 'L_TEMP_ACCDM' )
  DROP TABLE L_TEMP_ACCDM  
  
  CREATE TABLE L_TEMP_ENTPM (VAL VARCHAR(8000))  
  CREATE TABLE L_TEMP_ENTDM (VAL VARCHAR(8000))
  CREATE TABLE L_TEMP_ACCPM (VAL VARCHAR(8000))
  CREATE TABLE L_TEMP_ACCDM (VAL VARCHAR(8000))
    SET @l_clicm_id=0
    SET @l_enttm_id=0
     
  IF @pa_tab = 'DP'  
  BEGIN  
    SELECT @l_clicm_id    = clicm_id   
         , @l_enttm_id    = enttm_id   
    FROM client_mstr_MAK , client_ctgry_mstr , entity_type_mstr   
    WHERE clicm_cd        = CLIM_CLICM_CD   
    AND enttm_cd          = clim_enttm_cd   
    AND clim_deleted_ind  = 0  
    AND clicm_deleted_ind = 1   
    AND enttm_deleted_ind = 1  
    AND clim_crn_no = @pa_crn_no  
    
   
  
    IF @l_clicm_id <> 0
    BEGIN
      INSERT INTO L_TEMP_ENTPM SELECT DISTINCT CONVERT(VARCHAR,entpm_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(entpm_default_val)),'')) + '|*~|*|~*' FROM entity_PROPERTY_MSTR WHERE ISNULL(entpm_default_val,'') <> ''  AND entpm_deleted_ind = 1 AND ENTPM_CLICM_ID = @l_clicm_id AND entpm_enttm_id = @l_enttm_id 
      INSERT INTO L_TEMP_ENTDM SELECT DISTINCT CONVERT(VARCHAR,entpm_prop_id) + '|*~|' + CONVERT(VARCHAR,entdm_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(entdm_default_val)),'')  + '|*~|*|~*' FROM entity_PROPERTY_MSTR , entpm_dtls_mstr   WHERE entdm_entpm_prop_ID = entpm_PROP_ID AND ISNULL(entdm_default_val,'')<>'' AND entpm_deleted_ind = 1 AND entdm_deleted_ind = 1 AND  ENTPM_CLICM_ID = @l_clicm_id AND entpm_enttm_id = @l_enttm_id 
      SELECT @l_entp_value  = ISNULL(@l_entp_value,'') + ISNULL(VAL,'') FROM L_TEMP_ENTPM
      SELECT @l_entpd_value  = ISNULL(@l_entpd_value,'') + ISNULL(VAL,'') FROM L_TEMP_ENTDM
    END
    ELSE
    BEGIN
    
    INSERT INTO L_TEMP_ENTPM SELECT DISTINCT CONVERT(VARCHAR,entpm_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(entpm_default_val)),'')) + '|*~|*|~*' FROM entity_PROPERTY_MSTR WHERE ISNULL(entpm_default_val,'') <> ''  AND entpm_deleted_ind = 1 OR ( ENTPM_CLICM_ID = @l_clicm_id AND entpm_enttm_id = @l_enttm_id  )
    INSERT INTO L_TEMP_ENTDM SELECT DISTINCT CONVERT(VARCHAR,entpm_prop_id) + '|*~|' + CONVERT(VARCHAR,entdm_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(entdm_default_val)),'')  + '|*~|*|~*' FROM entity_PROPERTY_MSTR , entpm_dtls_mstr   WHERE entdm_entpm_prop_ID = entpm_PROP_ID AND ISNULL(entdm_default_val,'')<>'' AND entpm_deleted_ind = 1 AND entdm_deleted_ind = 1 OR( ENTPM_CLICM_ID = @l_clicm_id AND entpm_enttm_id = @l_enttm_id  )   
      
    SELECT @l_entp_value  = ISNULL(@l_entp_value,'') + ISNULL(VAL,'') FROM L_TEMP_ENTPM
    SELECT @l_entpd_value  = ISNULL(@l_entpd_value,'') + ISNULL(VAL,'') FROM L_TEMP_ENTDM
    END
    
    EXEC pr_ins_upd_entp '1','EDT','MIG',@pa_crn_no,'',@L_ENTP_VALUE,@L_ENTPD_VALUE,1,'*|~*','|*~|',''    
    
    SET @l_clicm_id=0
    SET @l_enttm_id=0
    SET @L_ENTP_VALUE =''
    SET @L_ENTPD_VALUE =''
 
    
    
    
     SET @c_cursor  = CURSOR fast_forward FOR  
     SELECT DPAM_ID ,DPAM_SBA_NO , clicm_id   
         , enttm_id   
		FROM client_ctgry_mstr , entity_type_mstr , DP_aCCT_MSTR_MAK  
		WHERE clicm_CD        = DPAM_CLICM_CD   
		AND enttm_CD          = DPAM_enttm_cd   
		AND DPAM_deleted_ind  = 0  
		AND clicm_deleted_ind = 1   
		AND enttm_deleted_ind = 1  
		AND DPAM_CRN_NO = @pa_crn_no            
    
    
     OPEN @c_cursor        
  FETCH NEXT FROM @c_cursor       
     INTO @L_DPAM_ID ,@L_BEN_ACCT_NO, @l_clicm_id  
         , @l_enttm_id
   
    
    
    WHILE @@fetch_status = 0                                                                                                              
    BEGIN --#cursor       

SET @L_ACCP_VALUE = ''
SET @L_accpd_VALUE = '' 
    
    
    IF @l_clicm_id <> 0
    BEGIN
      INSERT INTO L_TEMP_ACCPM SELECT DISTINCT CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(accpm_default_val)),'')) + '|*~|*|~*' FROM ACCOUNT_PROPERTY_MSTR WHERE ISNULL(accpm_default_val,'') <> ''  AND accpm_deleted_ind = 1   AND  (accpm_clicm_id = @l_clicm_id AND accpm_enttm_id = @l_enttm_id)
      INSERT INTO L_TEMP_ACCDM SELECT DISTINCT CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ACCDM_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(accdm_default_val)),'')  + '|*~|*|~*' FROM ACCOUNT_PROPERTY_MSTR , ACCPM_DTLS_MSTR  WHERE ACCDM_ACCPM_PROP_ID = ACCPM_PROP_ID AND ISNULL(accdm_default_val,'')<>'' AND accpm_deleted_ind = 1 AND accdm_deleted_ind = 1        and (accpm_clicm_id = @l_clicm_id AND accpm_enttm_id = @l_enttm_id)

    SELECT  @L_ACCP_VALUE = isnull(@L_ACCP_VALUE,'') + ISNULL(VAL,'') FROM L_TEMP_ACCPM

    SELECT  @L_accpd_VALUE = isnull(@L_accpd_VALUE,'') + ISNULL(VAL,'') FROM L_TEMP_ACCDM
    END
    ELSE
    BEGIN
    
     INSERT INTO L_TEMP_ACCPM SELECT DISTINCT CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(accpm_default_val)),'')) + '|*~|*|~*' FROM ACCOUNT_PROPERTY_MSTR WHERE ISNULL(accpm_default_val,'') <> ''  AND accpm_deleted_ind = 1   OR (accpm_clicm_id = @l_clicm_id AND accpm_enttm_id = @l_enttm_id)
      INSERT INTO L_TEMP_ACCDM SELECT DISTINCT CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ACCDM_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(accdm_default_val)),'')  + '|*~|*|~*' FROM ACCOUNT_PROPERTY_MSTR , ACCPM_DTLS_MSTR  WHERE ACCDM_ACCPM_PROP_ID = ACCPM_PROP_ID AND ISNULL(accdm_default_val,'')<>'' AND accpm_deleted_ind = 1 AND accdm_deleted_ind = 1        OR (accpm_clicm_id = @l_clicm_id AND accpm_enttm_id = @l_enttm_id)

    
    SELECT  @L_ACCP_VALUE = isnull(@L_ACCP_VALUE,'') + ISNULL(VAL,'') FROM L_TEMP_ACCPM
    SELECT @L_accpd_VALUE = isnull(@L_accpd_VALUE,'') + ISNULL(VAL,'') FROM L_TEMP_ACCDM
    END 
  
    IF ISNULL(@L_BEN_ACCT_NO ,'') <> ''  
    EXEC pr_ins_upd_accp @pa_crn_no ,'EDT','MIG',@L_DPAM_ID,@L_ben_acct_no,'DP',@L_ACCP_value,@L_accpd_VALUE ,1,'*|~*','|*~|',''  
    
  SET @L_ACCP_VALUE = ''
SET @L_accpd_VALUE = ''
    
    FETCH NEXT FROM @c_cursor       
     INTO @L_DPAM_ID ,@L_BEN_ACCT_NO, @l_clicm_id  
         , @l_enttm_id
    --      
end      

  DELETE  FROM  L_TEMP_ENTPM
  DELETE  FROM  L_TEMP_ENTDM
  DELETE  FROM  L_TEMP_ACCPM
  DELETE  FROM  L_TEMP_ACCDM  
      
close @c_cursor     
deallocate @c_cursor 
     
    IF ISNULL(@L_BEN_ACCT_NO ,'') <> ''  
    EXEC pr_ins_upd_accp @pa_crn_no ,'EDT','MIG',@L_DPAM_ID,@L_ben_acct_no,'DP',@L_ACCP_value,@L_accpd_VALUE ,1,'*|~*','|*~|',''  
    
    SET @l_clicm_id=0
    SET @l_enttm_id=0
    SET @L_ACCP_VALUE =''
    SET @L_accpd_VALUE =''
    
  END  
  ELSE IF @pa_tab = 'CITRUS'  
  BEGIN  
    SELECT @l_clicm_id    = clicm_id   
         , @l_enttm_id    = enttm_id   
    FROM client_mstr_MAK , client_ctgry_mstr , entity_type_mstr   
    WHERE clicm_cd        = CLIM_CLICM_CD   
    AND enttm_cd          = clim_enttm_cd   
    AND clim_deleted_ind  = 0  
    AND clicm_deleted_ind = 1   
    AND enttm_deleted_ind = 1  
    AND clim_crn_no = @pa_crn_no  
      
      
    


    IF @l_clicm_id <> 0
    BEGIN
      INSERT INTO L_TEMP_ENTPM SELECT DISTINCT CONVERT(VARCHAR,entpm_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(entpm_default_val)),'')) + '|*~|*|~*' FROM entity_PROPERTY_MSTR WHERE ISNULL(entpm_default_val,'') <> ''  AND entpm_deleted_ind = 1 AND ENTPM_CLICM_ID = @l_clicm_id AND entpm_enttm_id = @l_enttm_id 
      INSERT INTO L_TEMP_ENTDM SELECT DISTINCT CONVERT(VARCHAR,entpm_prop_id) + '|*~|' + CONVERT(VARCHAR,entdm_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(entdm_default_val)),'')  + '|*~|*|~*' FROM entity_PROPERTY_MSTR , entpm_dtls_mstr   WHERE entdm_entpm_prop_ID = entpm_PROP_ID AND ISNULL(entdm_default_val,'')<>'' AND entpm_deleted_ind = 1 AND entdm_deleted_ind = 1 AND  ENTPM_CLICM_ID = @l_clicm_id AND entpm_enttm_id = @l_enttm_id 
      SELECT @l_entp_value  = ISNULL(@l_entp_value,'') + ISNULL(VAL,'') FROM L_TEMP_ENTPM
      SELECT @l_entpd_value  = ISNULL(@l_entpd_value,'') + ISNULL(VAL,'') FROM L_TEMP_ENTDM
    END
    ELSE
    BEGIN
    
    INSERT INTO L_TEMP_ENTPM SELECT DISTINCT CONVERT(VARCHAR,entpm_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(entpm_default_val)),'')) + '|*~|*|~*' FROM entity_PROPERTY_MSTR WHERE ISNULL(entpm_default_val,'') <> ''  AND entpm_deleted_ind = 1 OR ( ENTPM_CLICM_ID = @l_clicm_id AND entpm_enttm_id = @l_enttm_id  )
    INSERT INTO L_TEMP_ENTDM SELECT DISTINCT CONVERT(VARCHAR,entpm_prop_id) + '|*~|' + CONVERT(VARCHAR,entdm_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(entdm_default_val)),'')  + '|*~|*|~*' FROM entity_PROPERTY_MSTR , entpm_dtls_mstr   WHERE entdm_entpm_prop_ID = entpm_PROP_ID AND ISNULL(entdm_default_val,'')<>'' AND entpm_deleted_ind = 1 AND entdm_deleted_ind = 1 OR( ENTPM_CLICM_ID = @l_clicm_id AND entpm_enttm_id = @l_enttm_id  )   
      
    SELECT @l_entp_value  = ISNULL(@l_entp_value,'') + ISNULL(VAL,'') FROM L_TEMP_ENTPM
    SELECT @l_entpd_value  = ISNULL(@l_entpd_value,'') + ISNULL(VAL,'') FROM L_TEMP_ENTDM
    END
    
    EXEC pr_ins_upd_entp '1','EDT','MIG',@pa_crn_no,'',@L_ENTP_VALUE,@L_ENTPD_VALUE,1,'*|~*','|*~|',''    
    
         
     SET @c_cursor  = CURSOR fast_forward FOR  
     SELECT DPAM_ID ,DPAM_SBA_NO , clicm_id   
         , enttm_id   
		FROM client_ctgry_mstr , entity_type_mstr , DP_aCCT_MSTR_MAK  
		WHERE clicm_CD        = DPAM_CLICM_CD   
		AND enttm_CD          = DPAM_enttm_cd   
		AND DPAM_deleted_ind  = 0  
		AND clicm_deleted_ind = 1   
		AND enttm_deleted_ind = 1  
		AND DPAM_CRN_NO = @pa_crn_no            
    
    
     OPEN @c_cursor        
  FETCH NEXT FROM @c_cursor       
     INTO @L_DPAM_ID ,@L_BEN_ACCT_NO, @l_clicm_id  
         , @l_enttm_id
   
    
    
    WHILE @@fetch_status = 0                                                                                                              
    BEGIN --#cursor       

SET @L_ACCP_VALUE = ''
SET @L_accpd_VALUE = '' 
    IF ISNULL(@L_BEN_ACCT_NO ,'') = ''
    BEGIN
       SELECT @L_DPAM_ID = CLISBA_ID ,@L_BEN_ACCT_NO = CLISBA_NO 
    FROM CLIENT_SUB_ACCTS_MAK  
    WHERE CLISBA_deleted_ind  = 0  
    AND CLISBA_CRN_NO = @pa_crn_no 
    END
    
    IF @l_clicm_id <> 0
    BEGIN
      INSERT INTO L_TEMP_ACCPM SELECT DISTINCT CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(accpm_default_val)),'')) + '|*~|*|~*' FROM ACCOUNT_PROPERTY_MSTR WHERE ISNULL(accpm_default_val,'') <> ''  AND accpm_deleted_ind = 1   AND  (accpm_clicm_id = @l_clicm_id AND accpm_enttm_id = @l_enttm_id)
      INSERT INTO L_TEMP_ACCDM SELECT DISTINCT CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ACCDM_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(accdm_default_val)),'')  + '|*~|*|~*' FROM ACCOUNT_PROPERTY_MSTR , ACCPM_DTLS_MSTR  WHERE ACCDM_ACCPM_PROP_ID = ACCPM_PROP_ID AND ISNULL(accdm_default_val,'')<>'' AND accpm_deleted_ind = 1 AND accdm_deleted_ind = 1        and (accpm_clicm_id = @l_clicm_id AND accpm_enttm_id = @l_enttm_id)

    SELECT  @L_ACCP_VALUE = isnull(@L_ACCP_VALUE,'') + ISNULL(VAL,'') FROM L_TEMP_ACCPM

    SELECT  @L_accpd_VALUE = isnull(@L_accpd_VALUE,'') + ISNULL(VAL,'') FROM L_TEMP_ACCDM
    END
    ELSE
    BEGIN
    
     INSERT INTO L_TEMP_ACCPM SELECT DISTINCT CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + upper(ISNULL(LTRIM(RTRIM(accpm_default_val)),'')) + '|*~|*|~*' FROM ACCOUNT_PROPERTY_MSTR WHERE ISNULL(accpm_default_val,'') <> ''  AND accpm_deleted_ind = 1   OR (accpm_clicm_id = @l_clicm_id AND accpm_enttm_id = @l_enttm_id)
      INSERT INTO L_TEMP_ACCDM SELECT DISTINCT CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + CONVERT(VARCHAR,ACCDM_ID) + '|*~|'  + ISNULL(LTRIM(RTRIM(accdm_default_val)),'')  + '|*~|*|~*' FROM ACCOUNT_PROPERTY_MSTR , ACCPM_DTLS_MSTR  WHERE ACCDM_ACCPM_PROP_ID = ACCPM_PROP_ID AND ISNULL(accdm_default_val,'')<>'' AND accpm_deleted_ind = 1 AND accdm_deleted_ind = 1        OR (accpm_clicm_id = @l_clicm_id AND accpm_enttm_id = @l_enttm_id)

    
    SELECT  @L_ACCP_VALUE = isnull(@L_ACCP_VALUE,'') + ISNULL(VAL,'') FROM L_TEMP_ACCPM
    SELECT @L_accpd_VALUE = isnull(@L_accpd_VALUE,'') + ISNULL(VAL,'') FROM L_TEMP_ACCDM
    END 
  
    IF ISNULL(@L_BEN_ACCT_NO ,'') <> ''  
    EXEC pr_ins_upd_accp @pa_crn_no ,'EDT','MIG',@L_DPAM_ID,@L_ben_acct_no,'DP',@L_ACCP_value,@L_accpd_VALUE ,1,'*|~*','|*~|',''  
    
  SET @L_ACCP_VALUE = ''
SET @L_accpd_VALUE = ''
    
    FETCH NEXT FROM @c_cursor       
     INTO @L_DPAM_ID ,@L_BEN_ACCT_NO, @l_clicm_id  
         , @l_enttm_id
    --      
end      

  DELETE  FROM  L_TEMP_ENTPM
  DELETE  FROM  L_TEMP_ENTDM
  DELETE  FROM  L_TEMP_ACCPM
  DELETE  FROM  L_TEMP_ACCDM  
      
close @c_cursor     
deallocate @c_cursor     
    
  END  
  
END

GO
