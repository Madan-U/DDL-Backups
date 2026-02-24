-- Object: FUNCTION citrus_usr.fn_ucc_client_ctgry
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--select dbo.fn_ucc_client_ctgry('NSE' ,46)      
CREATE function [citrus_usr].[fn_ucc_client_ctgry](@pa_exch       CHAR(20)       
                                  ,@pa_crn_no     NUMERIC      
                                  )      
RETURNS varchar(30)      
AS      
BEGIN      
--      
  DECLARE @l_ctgry    varchar(15)      
        , @l_status   varchar(11)      
        , @l_ctgry_desc varchar(100)      
  --      
  IF @pa_exch = 'NSE' OR @pa_exch = 'MCX' OR @pa_exch = 'NCDEX'      
  BEGIN      
  --      
    /*SELECT @l_ctgry          = clim_clicm_cd      
    FROM   client_mstr         WITH (NOLOCK)      
    WHERE  clim_crn_no       = @pa_crn_no      
    AND    clim_deleted_ind  = 1*/      
    SELECT @l_ctgry          = clim_clicm_cd      
          ,@l_ctgry_desc     = clicm_desc      
    FROM   client_mstr         WITH (NOLOCK)      
          ,client_ctgry_mstr   WITH (NOLOCK)      
    WHERE  clim_crn_no       = @pa_crn_no      
    AND    clim_clicm_cd     = clicm_cd      
    AND    clim_deleted_ind  = 1      
  --       
  END      
  ELSE IF @pa_exch = 'BSE'         
  BEGIN      
  SELECT @l_status = CASE WHEN CLIM_ENTTM_CD IN ('CL_BR','CL_SB','CL_FLY_BR','CL_FLY_SB','CLIENT') THEN 'CL' WHEN CLIM_ENTTM_CD IN ('INS_BR','INS_SB','INS_FLY_BR','INS_FLY_SB','INS') THEN 'INS' ELSE '' END     
                     FROM CLIENT_MSTR WHERE CLIM_CRN_NO = @pa_crn_no     
    
  --      
    SELECT @l_ctgry          = clim_clicm_cd               
         , @l_ctgry_desc     = clicm_desc      
    FROM   client_mstr         WITH (NOLOCK)      
          ,client_ctgry_mstr   WITH (NOLOCK)      
    WHERE  clim_crn_no       = @pa_crn_no      
    AND    clim_clicm_cd     = clicm_cd      
    AND    clim_deleted_ind  = 1            
  --      
  END      
  --      
  RETURN CASE WHEN @pa_exch = 'NSE' THEN      
                                    CASE WHEN ISNULL(@l_ctgry_desc,'')  = 'INDIVIDUAL'                       THEN '1'       
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'PARTNERSHIP FIRM'                 THEN '2'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'PARTNERSHIP'                      THEN '2'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'HINDU UNDIVIDED FAMILY'           THEN '3'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'PUBLIC LTD COMPANY'               THEN '4'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'PVT LTD COMPANY'                  THEN '4'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'BODIES CORPARATE'                 THEN '4'      
           WHEN ISNULL(@l_ctgry_desc,'')  = 'CORPORATE - LOCAL'                THEN '4'      
           WHEN ISNULL(@l_ctgry_desc,'')  = 'CORPORATE'                        THEN '4'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'TRUST'                            THEN '5'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'SOCIETY'                          THEN '5'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'MUTUAL FUND'                      THEN '6'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'DOSMESTIC FINANCIAL INSTITUTIONS' THEN '7'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'BANK'                             THEN '8'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'INSURANCE'                        THEN '9'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'STATUTORY BODIES'                 THEN '10'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'NRI'                              THEN '11'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'NON-RESIDENT INDIVIDUAL'          THEN '11'      
            WHEN ISNULL(@l_ctgry_desc,'')  = 'FOREIGN INSTITUTIONAL INVESTORS (FII)'  THEN '12'      
       WHEN ISNULL(@l_ctgry_desc,'')  = 'OVERSEAS CORPORATE BODY'          THEN '13'       
                                         ELSE ''      
                                         END                                      
              WHEN @pa_exch = 'BSE' THEN                                            
                   ISNULL(@l_status,'')+'|'+ CASE WHEN ISNULL(@l_ctgry_desc,'')  = 'INDIVIDUAL'                       THEN 'I'       
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'PARTNERSHIP FIRM'                 THEN 'PF'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'PARTNERSHIP'                      THEN 'PF'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'HINDU UNDIVIDED FAMILY'           THEN 'HUF'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'PUBLIC LTD COMPANY'               THEN 'CO'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'PVT LTD COMPANY'                  THEN 'CO'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'CORPORATE - LOCAL'                THEN 'CO'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'CORPORATE'                        THEN 'CO'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'TRUST'                            THEN 'O'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'MUTUAL FUND'                      THEN 'MF'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'SOCIETY'                          THEN 'O'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'BANK'                             THEN 'B'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'INSURANCE'                        THEN 'INS'      
                                         --WHEN ISNULL(@l_ctgry_desc,'')  = 'STATUTORY BODIES'                 THEN 'SB'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'NRI'                              THEN 'NRI'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'NON-RESIDENT INDIVIDUAL'          THEN 'NRI'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'FOREIGN INSTITUTIONAL INVESTORS (FII)'  THEN 'FII'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'OVERSEAS CORPORATE BODY'          THEN 'OCB'       
                                         ELSE ISNULL(@l_ctgry_desc,'')      
                                         END                                       
              WHEN @pa_exch = 'MCX' THEN      
                                    CASE WHEN ISNULL(@l_ctgry_desc,'')  = 'INDIVIDUAL'                       THEN '01'       
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'MUTUAL FUND'                      THEN '06'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'BODY CORPORATE'                   THEN '13'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'NON-TAX PAYING ENTITY'            THEN '14'       
                                         ELSE '99' end      
              WHEN @pa_exch = 'NCDEX' THEN      
                                    CASE WHEN ISNULL(@l_ctgry_desc,'')  = 'INDIVIDUAL'                       THEN '01'       
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'PARTNERSHIP'                      THEN '02'       
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'HUF'                              THEN '03'       
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'PVT LIMITED COS'                  THEN '04'      
                WHEN ISNULL(@l_ctgry_desc,'')  = 'LIMITED COS'                      THEN '05'      
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'FII''S'                           THEN '06'       
                                         WHEN ISNULL(@l_ctgry_desc,'')  = 'CO-OPERATIVES'                    THEN '07'      
                                         ELSE '99'                                               
                                               
                                         END                     
      
              end         
--      
END

GO
