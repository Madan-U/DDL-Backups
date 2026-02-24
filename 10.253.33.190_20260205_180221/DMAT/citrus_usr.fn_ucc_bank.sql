-- Object: FUNCTION citrus_usr.fn_ucc_bank
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select dbo.fn_ucc_bank('NSE',40)    
--select citrus_usr.fn_ucc_bank('BSE',29,'111')    
--select citrus_usr.fn_ucc_bank('NSE',129,'PC02')    
CREATE function [citrus_usr].[fn_ucc_bank](@pa_exch       char(4)    
                          ,@pa_crn_no     numeric    
                          ,@pa_party_code varchar(25)     
                          )    
RETURNS varchar (8000)    
AS    
BEGIN    
--    
  DECLARE @l_banm_id                   numeric    
        , @l_bank_name                 varchar(60)    
        , @l_bank_addr                 varchar(255)     
        , @l_bank_acct_type            varchar(20)    
        , @l_bank_acct_no              varchar(25)    
  --    
  IF @pa_exch = 'NSE' OR @pa_exch = 'MCX'      
  BEGIN    
  --    
    SELECT @l_banm_id                  = banm.banm_id       
         , @l_bank_name                = banm.banm_name     
         , @l_bank_acct_type           = CASE WHEN cliba.cliba_ac_type = 'SAVINGS' THEN '10'     
                                              WHEN cliba.cliba_ac_type = 'CURRENT' THEN '11'     
                                              WHEN cliba.cliba_ac_type = 'OTHERS'  THEN '99'      
                                              END    
         , @l_bank_acct_no             = cliba.cliba_ac_no     
    FROM   client_accounts               clia          WITH (NOLOCK)    
         , client_bank_accts             cliba         WITH (NOLOCK)    
         , client_sub_accts              clisba        WITH (NOLOCK)    
         , bank_mstr                     banm          WITH (NOLOCK)    
         , exch_seg_mstr                 excsm         WITH (NOLOCK)    
         , company_mstr                  compm         WITH (NOLOCK)    
         , excsm_prod_mstr               excpm         WITH (NOLOCK)    
    WHERE  compm.compm_id              = excsm.excsm_compm_id    
    AND    clisba.clisba_crn_no        = clia.clia_crn_no    
    AND    clisba.clisba_acct_no       = clia.clia_acct_no    
    AND    cliba.cliba_clisba_id       = clisba.clisba_id    
    AND    banm.banm_id                = cliba.cliba_banm_id    
    AND    excpm.excpm_excsm_id        = excsm.excsm_id                  
    AND    clisba.clisba_excpm_id      = excpm.excpm_id    
    AND    cliba.cliba_deleted_ind     = 1    
    AND    banm.banm_deleted_ind       = 1    
    AND    clia.clia_deleted_ind       = 1    
    AND    clisba.clisba_deleted_ind   = 1    
    AND    excsm.excsm_deleted_ind     = 1    
    AND    compm.compm_deleted_ind     = 1    
    AND    excpm.excpm_deleted_ind     = 1      
    AND    ISNULL(citrus_usr.fn_get_single_access(clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc),0) > 0    
    AND    clia.clia_acct_no           = @pa_party_code       
    AND    clia.clia_crn_no            = convert(numeric, @pa_crn_no)    
    --AND    2 & cliba.cliba_flg         = 2    
    AND    cliba.cliba_flg             = 1    
    AND    excsm.excsm_exch_cd         = @pa_exch    
    --    
    SELECT @l_bank_addr                = ISNULL(adr.adr_1,'')+' '+ISNULL(adr.adr_2,'')+' '+ISNULL(adr.adr_3,'')+' '+ISNULL(adr.adr_city,'')+' '+ISNULL(adr.adr_state,'')+' '+ISNULL(adr.adr_country,'')+' '+ISNULL(adr.adr_zip,'')  
    FROM   addresses                     adr    WITH (NOLOCK)    
         , entity_adr_conc               entac  WITH (NOLOCK)    
    WHERE  entac.entac_adr_conc_id     = adr.adr_id    
    AND    entac.entac_ent_id          = @l_banm_id     
    AND    adr.adr_deleted_ind         = 1    
    AND    entac.entac_deleted_ind     = 1    
  --    
  END    
  ELSE IF @pa_exch = 'BSE'    
  BEGIN    
  --    
    SELECT DISTINCT @l_banm_id         = banm.banm_id       
         , @l_bank_name                = banm.banm_name     
         , @l_bank_acct_type           = cliba.cliba_ac_type     
         , @l_bank_acct_no             = cliba.cliba_ac_no     
    FROM   client_accounts               clia     WITH (NOLOCK)    
         , client_bank_accts             cliba    WITH (NOLOCK)    
         , client_sub_accts              clisba   WITH (NOLOCK)    
         , bank_mstr                     banm     WITH (NOLOCK)    
         , exch_seg_mstr                 excsm    WITH (NOLOCK)    
         , company_mstr                  compm    WITH (NOLOCK)    
    WHERE  compm.compm_id              = excsm.excsm_compm_id    
    AND    clisba.clisba_crn_no        = clia.clia_crn_no    
    AND    clisba.clisba_acct_no       = clia.clia_acct_no    
    AND    cliba.cliba_clisba_id       = clisba.clisba_id    
    AND    banm.banm_id                = cliba.cliba_banm_id    
    AND    cliba.cliba_deleted_ind     = 1    
    AND    banm.banm_deleted_ind       = 1    
    AND    clia.clia_deleted_ind       = 1    
    AND    clisba.clisba_deleted_ind   = 1    
    AND    excsm.excsm_deleted_ind     = 1    
    AND    compm.compm_deleted_ind     = 1    
    AND    ISNULL(citrus_usr.fn_get_single_access(clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc),0) <> 0    
    AND    clia.clia_crn_no            = CONVERT(NUMERIC, @pa_crn_no)    
    AND    clia.clia_acct_no           = @pa_party_code       
    AND    cliba.cliba_flg             = 1    
    AND    excsm.excsm_exch_cd         = @pa_exch    
  
    --    
    SELECT @l_bank_addr                = ISNULL(ISNULL(adr.adr_1,'')+' '+ISNULL(adr.adr_2,'')+' '+ISNULL(adr.adr_3,'')+' '+ISNULL(adr.adr_city,'')+' '+ISNULL(adr.adr_state,'')+' '+ISNULL(adr.adr_country,'')+' '+ISNULL(adr.adr_zip,''),'')    
    FROM   addresses                     adr    WITH (NOLOCK)    
         , entity_adr_conc               entac  WITH (NOLOCK)    
    WHERE  entac.entac_adr_conc_id     = adr.adr_id    
    AND    entac.entac_ent_id          = @l_banm_id     
    AND    adr.adr_deleted_ind         = 1    
    AND    entac.entac_deleted_ind     = 1    
  --    
  END    
  --    
  RETURN CASE WHEN @pa_exch = 'NSE' THEN    
                   CONVERT(VARCHAR(60), ISNULL(@l_bank_name,''))+'|'+CONVERT(VARCHAR(255),ISNULL(@l_bank_addr,''))+'|'+CONVERT(VARCHAR(2), ISNULL(@l_bank_acct_type,''))+'|'+CONVERT(VARCHAR(25), ISNULL(@l_bank_acct_no,''))    
              WHEN @pa_exch = 'BSE' THEN     
                   CONVERT(VARCHAR(50), ISNULL(@l_bank_name,''))+'|'+CONVERT(VARCHAR(200),ISNULL(@l_bank_addr,''))+'|'+CONVERT(VARCHAR(20), ISNULL(@l_bank_acct_type,''))+'|'+CONVERT(VARCHAR(20), ISNULL(@l_bank_acct_no,''))    
              WHEN @pa_exch = 'MCX' THEN     
                   REPLACE(CONVERT(VARCHAR(60),ISNULL(@l_bank_name,'')),',',' ')+','+REPLACE(CONVERT(VARCHAR(255),ISNULL(@l_bank_addr,'')),',',' ')+','+REPLACE(CONVERT(VARCHAR(25), ISNULL(@l_bank_acct_no,'')),',',' ')+','+REPLACE(CONVERT(VARCHAR(2),ISNULL
(@l_bank_acct_type,'')),',',' ')                           
              END         
 --      
END

GO
