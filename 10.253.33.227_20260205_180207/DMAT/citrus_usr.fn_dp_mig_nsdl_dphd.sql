-- Object: FUNCTION citrus_usr.fn_dp_mig_nsdl_dphd
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_dp_mig_nsdl_dphd](@pa_tab      varchar(10)
                                   ,@pa_demat_id varchar(20)
                                   ,@pa_code     varchar(25)
                                   )
RETURNS VARCHAR(8000)
AS
--
BEGIN
--
  DECLARE @l_addr1              varchar(36)
        , @l_addr2              varchar(36)
        , @l_addr3              varchar(36)
        , @l_city               varchar(36)
        , @l_state              varchar(36)
        , @l_country            varchar(36)
        , @l_pincode            varchar(7)
        , @l_conc_value         varchar(24)
        , @l_value              varchar(400)    
  --
  IF @pa_tab  = 'ADDR'
  BEGIN
  --
    SELECT @l_addr1   = a.adr_1
         , @l_addr2   = a.adr_2
         , @l_addr3   = a.adr_3
         , @l_city    = a.adr_city
         , @l_state   = a.adr_state
         , @l_country = a.adr_country
         , @l_pincode = a.adr_zip
         --, concm.concm_cd
         --, concm.concm_desc
    FROM  (SELECT accac.accac_concm_id      concm_id
                , adr.adr_1                 adr_1
                , adr.adr_2                 adr_2
                , adr.adr_3                 adr_3
                , adr.adr_city              adr_city
                , adr.adr_state             adr_state
                , adr.adr_country           adr_country
                , adr.adr_zip               adr_zip
           FROM   addresses                 adr    WITH (NOLOCK)
                , account_adr_conc          accac  WITH (NOLOCK)
           WHERE  accac.accac_adr_conc_id = adr.adr_id
           AND    accac.accac_clisba_id     = convert(varchar, @pa_demat_id)
           AND    adr.adr_deleted_ind     = 1
           AND    accac.accac_deleted_ind = 1
          ) a
           JOIN
           conc_code_mstr                   concm  WITH (NOLOCK)
           ON (concm.concm_id             = a.concm_id and concm.concm_cd = @pa_code) 
    WHERE  concm.concm_deleted_ind        = 1
    AND    1 & concm.concm_cli_yn         = 1
    AND    2 & concm.concm_cli_yn         = 0
    ORDER  BY concm.concm_desc
    --
    SELECT @l_value = isnull(@l_addr1,'')+'|*~|'+isnull(@l_addr2,'')+'|*~|'+isnull(@l_addr3,'')+'|*~|'+isnull(@l_city,'')+'|*~|'+isnull(@l_state,'')+'|*~|'+isnull(@l_country,'')+'|*~|'+isnull(@l_pincode,'')+'|*~|'
  --  
  END  
  --
  IF @pa_tab = 'CONC'
  BEGIN
  --
    SELECT @l_value = isnull(a.conc_value,'')
         --, concm.concm_cd
         --, concm.concm_desc
    FROM  (SELECT accac.accac_concm_id      concm_id
                , conc.conc_value           conc_value
           FROM   contact_channels          conc  WITH (NOLOCK)
                , account_adr_conc          accac WITH (NOLOCK)
           WHERE  accac.accac_adr_conc_id = conc.conc_id
           AND    accac.accac_clisba_id     = convert(varchar, @pa_demat_id)
           AND    conc.conc_deleted_ind   = 1
           AND    accac.accac_deleted_ind = 1
          ) a
           JOIN
           conc_code_mstr                     concm  WITH (NOLOCK)
           ON (concm.concm_id              =  a.concm_id and concm.concm_cd = @pa_code) 
    WHERE  concm.concm_deleted_ind        = 1
    AND    1 & concm.concm_cli_yn         = 1
    AND    2 & concm.concm_cli_yn         = 2
    ORDER  BY concm.concm_desc
  --  
  END  
  --
  
  RETURN convert(varchar(8000), @l_value)
--
END

GO
