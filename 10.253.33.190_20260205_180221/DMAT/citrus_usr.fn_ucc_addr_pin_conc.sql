-- Object: FUNCTION citrus_usr.fn_ucc_addr_pin_conc
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select dbo.fn_ucc_addr_pin_conc('NSE',40)              
--select dbo.fn_ucc_addr_pin_conc('NSE',46)              
CREATE function [citrus_usr].[fn_ucc_addr_pin_conc](@pa_exch     char(4)              
                                   ,@pa_crn_no   numeric              
                                   )              
RETURNS VARCHAR(500)               
AS              
--              
BEGIN              
--              
  DECLARE @l_addr               varchar(255)              
        , @l_addr1              varchar(75)              
        , @l_addr2              varchar(75)              
        , @l_addr3              varchar(50)              
        , @l_city               varchar(25)              
        , @l_state              varchar(25)              
        , @l_country            varchar(25)              
        , @l_pincode            varchar(10)                
        , @l_telephone          varchar(25)              
        , @l_email              varchar(50)              
        , @l_dob                varchar(11)              
        , @l_std_code           varchar(10)              
  --              
  DECLARE @conc TABLE (code     varchar(20)              
                      ,value    varchar(50)
                      ,ctgry    varchar(100)                  
                      )              
  --                                 
  DECLARE @addr TABLE (code     varchar(20)              
                      ,adr1     varchar(50)              
                      ,adr2     varchar(50)                  
                      ,adr3     varchar(50)                  
                      ,city     varchar(50)                  
                      ,state    varchar(50)                  
                      ,country  varchar(50)                  
                      ,zip      varchar(50) 
                      ,ctgry    varchar(100)                  
                      )                                 
  --              
  INSERT INTO @conc              
  SELECT entac.entac_concm_cd              
       , convert(varchar(50), conc.conc_value) 
       , clicm_desc             
  FROM   contact_channels          conc    WITH (NOLOCK)              
       , entity_adr_conc           entac   WITH (NOLOCK)  
       , client_mstr               clim    WITH (NOLOCK) 
       , client_ctgry_mstr        clicm    WITH (NOLOCK) 
  WHERE  entac.entac_adr_conc_id = conc.conc_id  
  and    entac.entac_ent_id      = clim.clim_crn_no 
  and    clim.clim_clicm_cd      = clicm.clicm_cd    
  AND    entac.entac_ent_id      = CONVERT(numeric, @pa_crn_no)              
  AND    conc.conc_deleted_ind   = 1              
  AND    entac.entac_deleted_ind = 1         
  --              
  INSERT INTO @addr              
  SELECT entac.entac_concm_cd              
       , adr.adr_1              
       , adr.adr_2              
       , adr.adr_3              
       , adr.adr_city              
       , adr.adr_state              
       , adr.adr_country              
       , adr.adr_zip
       , clicm_desc              
  FROM   addresses                 adr     WITH (NOLOCK)              
       , entity_adr_conc           entac   WITH (NOLOCK)  
       , client_mstr               clim    WITH (NOLOCK) 
       , client_ctgry_mstr        clicm    WITH (NOLOCK)              
  WHERE  entac.entac_adr_conc_id = adr.adr_id 
  and    entac.entac_ent_id      = clim.clim_crn_no 
  and    clim.clim_clicm_cd      = clicm.clicm_cd                 
  AND    entac.entac_ent_id      = CONVERT(numeric, @pa_crn_no)              
  AND    adr.adr_deleted_ind     = 1              
  AND    entac.entac_deleted_ind = 1              
  --              
  IF @pa_exch = 'NSE'              
  BEGIN              
  --              
    SELECT @l_addr                = CONVERT(varchar(255), ISNULL(adr1,'')+' '+ISNULL(adr2,'')+' '+ISNULL(adr3,'')+' '+ISNULL(city,'')+' '+ISNULL(state,'')+' '+ISNULL(country,''))              
         , @l_pincode             = CONVERT(varchar(6), isnull(zip,''))                 
    FROM   @addr              
    WHERE  code                   = 'COR_ADR1'              
    --              
    SELECT @l_telephone           = CONVERT(varchar(25), value)               
    FROM   @conc              
    WHERE  code                   = Case when ctgry not in ('INDIVIDUAL','NRI','HINDU UNDIVIDED FAMILY') then 'OFF_PH1' else 'RES_PH1' end 
    --and    ctgry not in ('INDIVIDUAL','NRI','HINDU UNDIVIDED FAMILY')   
                 
    --                 
    SELECT @l_dob                 = CONVERT(varchar(11), clim_dob, 103)              
    FROM   client_mstr              WITH (NOLOCK)              
    WHERE  clim_crn_no            = CONVERT(numeric, @pa_crn_no)              
  --              
 END              
  ELSE IF @pa_exch = 'BSE'              
  BEGIN              
  --              
    SELECT @l_addr                = CONVERT(varchar(250), ISNULL(adr1,'')+' '+ISNULL(adr2,'')+' '+ISNULL(adr3,''))               
         , @l_city                = CONVERT(varchar(25), city)              
         , @l_state               = CONVERT(varchar(25), state)              
         , @l_country             = CONVERT(varchar(25), country)              
         , @l_pincode             = CONVERT(varchar(10), zip)            
         , @l_std_code            = CONVERT(varchar(10), '022')              
    FROM   @addr              
    WHERE  code                   = 'COR_ADR1'              
    --              
    --SELECT @l_telephone           = CONVERT(varchar(25), value)              
    --FROM   @conc              
    --WHERE  code                   IN ('MOB1','RES_PH1','RES_PH2')              
    SELECT @l_telephone           = CONVERT(varchar(25), value)               
    FROM   @conc              
    WHERE  code                   = Case when ctgry not in ('INDIVIDUAL','NRI','HINDU UNDIVIDED FAMILY') then 'OFF_PH1' else 'RES_PH1' end 
    --              
    SELECT @l_email               = CONVERT(varchar(50), value)               
    FROM   @conc              
    WHERE  code                   = 'EMAIL1'              
  --              
  END              
  ELSE IF @pa_exch = 'MCX'              
  BEGIN              
  --              
    SELECT @l_addr1               = CONVERT(varchar(75), adr1)              
         , @l_addr2               = CONVERT(varchar(75), adr2)              
         , @l_addr3               = CONVERT(varchar(50), adr3)               
         , @l_city                = CONVERT(varchar(20), city)              
         , @l_state               = CONVERT(varchar(20), state)              
         , @l_country             = CONVERT(varchar(15), country)              
         , @l_pincode             = CONVERT(varchar(6), zip)              
    FROM   @addr              
    WHERE  code                   = 'COR_ADR1'              
    --              
    SELECT @l_telephone           = CONVERT(varchar(25), value)              
    FROM   @conc              
    WHERE  code                   = 'RES_PH1'              
  --              
  END              
  --              
  --ISNULL(@l_addr,'')+'|'+ISNULL(@l_city,'')+'|'+ISNULL(@l_state,'')+'|'+ISNULL(@l_country,'')+'|'+ISNULL(@l_pincode,'')+'|'+ISNULL(@l_std_code,'')+'|'+ISNULL(CONVERT(varchar(15),@l_telephone),'')+'|'+ISNULL(CONVERT(varchar(50),@l_email),'')             
  
  RETURN  CASE WHEN @pa_exch = 'NSE' THEN               
                    ISNULL(@l_addr,'')+'|'+ISNULL(@l_pincode,'')+'|'+ISNULL(@l_telephone,'')+'|'--+ISNULL(REPLACE(CONVERT(Varchar(11),CONVERT(DateTime, @l_dob,103),106),' ','-'),'')              
               WHEN @pa_exch = 'BSE' THEN               
                    ISNULL(@l_addr,'')+'|'+ISNULL(@l_city,'')+'|'+ISNULL(@l_state,'')+'|'+ISNULL(@l_country,'')+'|'+ISNULL(@l_pincode,'')+'||'+ISNULL(CONVERT(varchar(15),@l_telephone),'')+'|'               
               WHEN @pa_exch = 'MCX' THEN               
                    REPLACE(ISNULL(@l_addr1,''),',',' ')+','+REPLACE(ISNULL(@l_addr2,''),',',' ')+','+REPLACE(ISNULL(@l_addr3,''),',',' ')+','+REPLACE(ISNULL(@l_city,''),',',' ')+','+REPLACE(ISNULL(@l_state,''),',',' ')+','+REPLACE(ISNULL(@l_country,''),'
,',' ')+','+REPLACE(ISNULL(@l_pincode,''),',',' ')+','+REPLACE(ISNULL(@l_telephone,''),',',' ')                    
               END                   
--                
END

GO
