-- Object: FUNCTION citrus_usr.fn_ucc_dp
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_ucc_dp](@pa_exch        CHAR(20)  
                        ,@pa_crn_no      NUMERIC  
                        ,@pa_party_code  VARCHAR(25)   
                        )  
RETURNS varchar (8000)  
AS  
BEGIN  
--  
  DECLARE @l_dep_id             VARCHAR(25)  
        , @l_dep_name1          VARCHAR(4)  
        , @l_beneficial         VARCHAR(16)  
        , @l_type               VARCHAR(4)  
        , @l_dpm_dpid           VARCHAR(20)  
        , @l_string             VARCHAR(8000)   
  --  
  IF @pa_exch = 'NSE' OR @pa_exch = 'BSE' OR @pa_exch = 'MCX' OR @pa_exch = 'NCDEX'  
  BEGIN  
  --  
    SELECT @l_dpm_dpid                          = dpm.dpm_dpid          
         , @l_dep_id                            = CASE WHEN excm.excm_cd = 'NSDL' THEN 'IN000018' WHEN excm.excm_cd= 'CDSL' THEN 'IN00026' END  
         , @l_dep_name1                         = CASE WHEN excm.excm_cd = 'NSDL' THEN 'NSDL' WHEN excm.excm_cd= 'CDSL' THEN 'CDSL' END  
         , @l_beneficial                        = clidpa.clidpa_dp_id  
         , @l_type                              = excm.excm_cd  
    FROM   client_accounts                        clia     WITH (NOLOCK)      
         , client_dp_accts                        clidpa   WITH (NOLOCK)       
         , client_sub_accts                       clisba   WITH (NOLOCK)       
         , dp_mstr                                dpm      WITH (NOLOCK)       
         , exchange_mstr                          excm     WITH (NOLOCK)    
         , exch_seg_mstr                          excsm    WITH (NOLOCK)       
         , company_mstr                           compm    WITH (NOLOCK)  
         , excsm_prod_mstr                        excpm    WITH (NOLOCK)  
    WHERE  compm.compm_id                       = excsm.excsm_compm_id       
    AND    clisba.clisba_crn_no                 = clia.clia_crn_no       
    AND    clisba.clisba_acct_no                = clia.clia_acct_no       
    AND    clidpa.clidpa_clisba_id              = clisba.clisba_id       
    AND    dpm.dpm_id                           = clidpa.clidpa_dpm_id  
    AND    excpm.excpm_excsm_id                 = excsm.excsm_id                
    AND    clisba.clisba_excpm_id               = excpm.excpm_id  
    AND    dpm.dpm_excsm_id                     = excsm.excsm_id  
    AND    clia.clia_deleted_ind                = 1       
    AND    clisba.clisba_deleted_ind            = 1       
    AND    clidpa.clidpa_deleted_ind            = 1       
    AND    dpm.dpm_deleted_ind                  = 1       
    AND    excsm.excsm_deleted_ind              = 1       
    AND    compm.compm_deleted_ind              = 1  
    AND    excpm.excpm_deleted_ind              = 1    
    AND    excm.excm_deleted_ind                = 1    
    AND    ISNULL(citrus_usr.fn_get_single_access(clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc),0) <> 0       
    AND    clia.clia_acct_no                    = @pa_party_code     
    AND    clia.clia_crn_no                     = @pa_crn_no  
    --AND    2 & clidpa.clidpa_flg              = 2  
    AND    excsm.excsm_exch_cd                  = @pa_exch  
  --  
  END  
  ELSE IF @pa_exch = 'c2jm'  
  BEGIN--c2jm  
  --  
    SELECT TOP 1 @l_dpm_dpid                    = dpm.dpm_dpid          
         , @l_dep_id                            = CASE WHEN excm.excm_cd = 'NSDL' THEN 'IN000018' WHEN excm.excm_cd= 'CDSL' THEN 'IN00026' END  
         , @l_dep_name1                         = CASE WHEN excm.excm_cd = 'NSDL' THEN 'NSDL' WHEN excm.excm_cd = 'CDSL' THEN 'CDSL' END  
         , @l_beneficial                        = clidpa.clidpa_dp_id  
         , @l_type                              = excm.excm_cd  
    FROM   client_accounts                        clia     WITH (NOLOCK)      
         , client_dp_accts                        clidpa   WITH (NOLOCK)       
         , client_sub_accts                       clisba   WITH (NOLOCK)       
         , dp_mstr                                dpm      WITH (NOLOCK)  
         , exchange_mstr              excm     WITH (NOLOCK)    
         , exch_seg_mstr                          excsm    WITH (NOLOCK)       
         , company_mstr                           compm    WITH (NOLOCK)  
         , excsm_prod_mstr                        excpm    WITH (NOLOCK)  
    WHERE  compm.compm_id                       = excsm.excsm_compm_id       
    AND    clisba.clisba_crn_no                 = clia.clia_crn_no       
    AND    clisba.clisba_acct_no                = clia.clia_acct_no       
    AND    clidpa.clidpa_clisba_id              = clisba.clisba_id       
    AND    dpm.dpm_id                           = clidpa.clidpa_dpm_id  
    AND    excpm.excpm_excsm_id                 = excsm.excsm_id                
    AND    clisba.clisba_excpm_id               = excpm.excpm_id  
    AND    dpm.dpm_excsm_id                     = excsm.excsm_id  
    AND    clia.clia_deleted_ind                = 1       
    AND    clisba.clisba_deleted_ind            = 1       
    AND    clidpa.clidpa_deleted_ind            = 1       
    AND    dpm.dpm_deleted_ind                  = 1       
    AND    excsm.excsm_deleted_ind              = 1       
    AND    compm.compm_deleted_ind              = 1  
    AND    excpm.excpm_deleted_ind              = 1   
    AND    excm.excm_deleted_ind                = 1   
    AND    ISNULL(citrus_usr.fn_get_single_access(clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc),0) <> 0       
    AND    clia.clia_acct_no                    = @pa_party_code     
    AND    clia.clia_crn_no                     = @pa_crn_no  
  --  
  END--c2jm  
  ELSE IF @pa_exch = 'c2jm_all'  
  BEGIN--c2jm_all  
  --  
    DECLARE @c_dp                  CURSOR  
          , @l_append              VARCHAR(8000)  
          , @l_dpm_id              NUMERIC  
          , @l_clia_acct_no        VARCHAR(20)  
          , @l_dpm_name            VARCHAR(50)  
          , @l_dpm_type            VARCHAR(20)  
          , @l_clidpa_flg          SMALLINT  
          , @l_clidpa_dp_id        VARCHAR(20)  
          , @l_clidpa_created_dt   DATETIME  
          , @l_clidpa_lst_Upd_dt   DATETIME  
          , @l_modified            CHAR(1)  
    --  
    SET @c_dp  = CURSOR FAST_FORWARD FOR        
    SELECT dpm.dpm_id                 dpm_id  
         , clia.clia_acct_no          clia_acct_no   
         , dpm.dpm_name               dpm_name    
         , excm.excm_cd               dpm_type   
         , dpm.dpm_dpid               dpm_dpid   
         , clidpa.clidpa_flg          clidpa_flg   
         , clidpa.clidpa_dp_id        clidpa_dp_id   
         , clidpa.clidpa_created_dt   clidpa_created_dt  
         , clidpa.clidpa_lst_Upd_dt   clidpa_lst_Upd_dt   
         , CASE WHEN clidpa.clidpa_created_dt = clidpa.clidpa_lst_upd_dt   
                THEN 'I' ELSE 'U' END  modified  
    FROM   client_accounts                        clia     WITH (NOLOCK)      
         , client_dp_accts                        clidpa   WITH (NOLOCK)       
         , client_sub_accts                       clisba   WITH (NOLOCK)       
         , dp_mstr                                dpm      WITH (NOLOCK)  
         , exchange_mstr                          excm     WITH (NOLOCK)  
         , exch_seg_mstr                          excsm    WITH (NOLOCK)       
         , company_mstr                           compm    WITH (NOLOCK)  
         , excsm_prod_mstr                        excpm    WITH (NOLOCK)  
    WHERE  compm.compm_id                       = excsm.excsm_compm_id       
    AND    clisba.clisba_crn_no                 = clia.clia_crn_no       
    AND    clisba.clisba_acct_no                = clia.clia_acct_no       
    AND    clidpa.clidpa_clisba_id              = clisba.clisba_id       
    AND    dpm.dpm_id                           = clidpa.clidpa_dpm_id  
    AND    excpm.excpm_excsm_id                 = excsm.excsm_id                
    AND    clisba.clisba_excpm_id               = excpm.excpm_id  
    AND    dpm.dpm_excsm_id                     = excsm.excsm_id  
    AND    clia.clia_deleted_ind                = 1       
    AND    clisba.clisba_deleted_ind            = 1       
    AND    clidpa.clidpa_deleted_ind            = 1       
    AND    dpm.dpm_deleted_ind                  = 1       
    AND    excsm.excsm_deleted_ind              = 1       
    AND    compm.compm_deleted_ind              = 1  
    AND    excpm.excpm_deleted_ind              = 1    
    AND    excm.excm_deleted_ind                = 1       
    AND    ISNULL(citrus_usr.fn_get_single_access(clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc),0) <> 0       
    AND    clia.clia_acct_no                    = @pa_party_code      
    AND    clia.clia_crn_no                     = @pa_crn_no  
    --  
    OPEN @c_dp  
    --  
    FETCH NEXT FROM @c_dp  
    INTO @l_dpm_id  
       , @l_clia_acct_no   
       , @l_dpm_name    
       , @l_dpm_type   
       , @l_dpm_dpid   
       , @l_clidpa_flg   
       , @l_clidpa_dp_id   
       , @l_clidpa_created_dt  
       , @l_clidpa_lst_Upd_dt   
       , @l_modified  
    --     
    WHILE @@FETCH_STATUS = 0    
    BEGIN--c#    
    --  
      SET @l_append = ISNULL(@l_append,'')+ISNULL(CONVERT(VARCHAR(10),@l_dpm_id),'')+'|*~|'+ISNULL(CONVERT(VARCHAR(20),@l_clia_acct_no),'')+'|*~|'+ISNULL(CONVERT(VARCHAR(50),@l_dpm_name),'')+'|*~|'+ISNULL(CONVERT(VARCHAR(20),@l_dpm_type),'')+'|*~|'+ISNULL(CONVERT(VARCHAR(20),@l_dpm_dpid),'')+'|*~|'+ISNULL(CONVERT(VARCHAR, @l_clidpa_flg),'')+'|*~|'+ISNULL(CONVERT(VARCHAR(20), @l_clidpa_dp_id),'')+'|*~|'+CONVERT(VARCHAR(11),@l_clidpa_created_dt,103)+'|*~|'+CONVERT(VARCHAR(11),@l_clidpa_lst_Upd_dt,103)+'|*~|0|*~|'+ISNULL(@l_modified,'')+'|*~|*|~*'  
      --  
      FETCH NEXT FROM  @c_dp  
      INTO  @l_dpm_id  
         ,  @l_clia_acct_no   
         ,  @l_dpm_name    
         ,  @l_dpm_type   
         ,  @l_dpm_dpid   
         ,  @l_clidpa_flg   
         ,  @l_clidpa_dp_id   
         ,  @l_clidpa_created_dt  
         ,  @l_clidpa_lst_Upd_dt   
         ,  @l_modified  
    --  
    END--c#  
    --  
    CLOSE @c_dp   
    DEALLOCATE @c_dp   
  --    
  END--c2jm_all  
  --  
  IF @pa_exch = 'MCX'  
  BEGIN  
  --    
    IF @l_type = 'NSDL'  
    BEGIN  
    --  
       SET @l_string = CONVERT(VARCHAR(4),ISNULL(@l_dep_name1,''))+','+','+','+CONVERT(VARCHAR(8), ISNULL(@l_beneficial,''))+','+','+','+','  
    --  
    END  
    ELSE IF @l_type = 'CDSL'  
    BEGIN  
    --  
      SET @l_string = ','+','+','+','+CONVERT(VARCHAR(4),ISNULL(@l_dep_name1,''))+','+','+CONVERT(VARCHAR(8), ISNULL(@l_beneficial,''))  
    --  
    END  
    ELSE  
    BEGIN  
    --  
      SET @l_string = ','+','+','+','+','+','+','  
    --  
    END  
  --    
  END  
  --  
  RETURN CASE WHEN @pa_exch = 'NSE' THEN   
                   CONVERT(VARCHAR(25), ISNULL(@l_dep_id,''))+'|'+CONVERT(VARCHAR(4), ISNULL(@l_dep_name1,''))+'|'+CONVERT(VARCHAR(16), ISNULL(@l_beneficial,''))  
              WHEN @pa_exch = 'BSE' THEN  
                   CONVERT(VARCHAR(50), ISNULL(@l_dep_name1,''))+'|'+'|'+CONVERT(VARCHAR(50), ISNULL(@l_dep_id,''))  
              WHEN @pa_exch = 'MCX' THEN  
                   @l_string  
              WHEN @pa_exch = 'NCDEX' THEN   
                   CONVERT(VARCHAR(25), ISNULL(@l_dep_id,''))+'|'+CONVERT(VARCHAR(4), ISNULL(@l_dep_name1,''))+'|'+CONVERT(VARCHAR(16), ISNULL(@l_beneficial,''))  
              WHEN @pa_exch = 'c2jm' THEN   
                   @l_dpm_dpid+'|*~|'+@l_beneficial+'|*~|'  
              WHEN @pa_exch = 'c2jm_all' THEN   
                   CONVERT(varchar(8000), @l_append)  
              END  
--  
END

GO
