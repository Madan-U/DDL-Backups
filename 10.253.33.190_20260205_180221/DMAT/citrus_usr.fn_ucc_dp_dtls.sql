-- Object: FUNCTION citrus_usr.fn_ucc_dp_dtls
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_ucc_dp_dtls](@pa_crn_no       NUMERIC    
                               ,@pa_party_code  VARCHAR(25)    
                               )    
RETURNS varchar (8000)    
AS    
BEGIN    
--  
  --select top 1 * from exchange_mstr  
  --select top 1 * from exch_seg_mstr    
  --select top 1 * from dp_mstr  
  DECLARE @l_dep_id             VARCHAR(25)    
        , @l_dep_name1          VARCHAR(4)    
        , @l_beneficial         VARCHAR(16)    
        , @l_type               VARCHAR(4)    
        , @l_dpm_dpid           VARCHAR(20)    
        , @l_string             VARCHAR(8000)    
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
       , exchange_mstr                          excm     WITH (NOLOCK)    
       , exch_seg_mstr                          excsm    WITH (NOLOCK)    
       , company_mstr                           compm    WITH (NOLOCK)    
       , excsm_prod_mstr                        excpm    WITH (NOLOCK)    
  WHERE  compm.compm_id                       = excsm.excsm_compm_id    
  AND    clisba.clisba_crn_no                 = clia.clia_crn_no    
  AND    clisba.clisba_acct_no                = clia.clia_acct_no    
  AND    clidpa.clidpa_clisba_id              = clisba.clisba_id    
  AND    dpm.dpm_id                           = clidpa.clidpa_dpm_id    
  AND    excm.excm_cd                         = excsm.excsm_exch_cd    
  AND    dpm.dpm_excsm_id                     = excsm.excsm_id    
  AND    excpm.excpm_excsm_id                 = excsm.excsm_id    
  AND    clisba.clisba_excpm_id               = excpm.excpm_id    
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
  RETURN @l_dpm_dpid+'|*~|'+@l_beneficial+'|*~|'    
--    
END

GO
