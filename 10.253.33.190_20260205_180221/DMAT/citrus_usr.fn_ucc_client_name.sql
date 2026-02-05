-- Object: FUNCTION citrus_usr.fn_ucc_client_name
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select dbo.fn_ucc_client_name('NSE',46)      
CREATE function [citrus_usr].[fn_ucc_client_name](@pa_exch       char(4)       
                                 ,@pa_crn_no     numeric      
                                 )      
RETURNS VARCHAR(8000)      
AS      
BEGIN      
--      
  DECLARE @l_short_name          varchar(60)      
         ,@l_first_name          varchar(50)      
         ,@l_middle_name         varchar(50)      
         ,@l_last_name           varchar(50)   
         ,@l_ctgry               varchar(50)  
  --             
  /*IF @pa_exch = 'NSE'      
  BEGIN      
  --      
    SELECT @l_short_name     = clim_short_name      
    FROM   client_mstr         WITH (NOLOCK)      
    WHERE  clim_crn_no       = CONVERT(numeric, @pa_crn_no)      
    AND    clim_deleted_ind  = 1      
  --        
  END      
  ELSE */      
  IF @pa_exch = 'BSE' OR @pa_exch = 'MCX'  or  @pa_exch = 'NSE'     
  BEGIN      
  --      
    SELECT @l_first_name     = clim_name1      
         , @l_middle_name    = clim_name2      
         , @l_last_name      = clim_name3      
         , @l_short_name     = clim_short_name      
         , @l_ctgry          = clim_clicm_cd  
    FROM   client_mstr         WITH (NOLOCK)      
    WHERE  clim_crn_no       = CONVERT(numeric, @pa_crn_no)      
    AND    clim_deleted_ind  = 1      
  --      
  END      
  --      
  RETURN CASE WHEN @pa_exch = 'NSE' THEN       
                   Ltrim(Rtrim(CONVERT(VARCHAR(100), ISNULL(CONVERT(VARCHAR(50), @l_last_name),'')+' '+ISNULL(CONVERT(VARCHAR(50), @l_first_name),'')+' '+ISNULL(CONVERT(VARCHAR(50), @l_middle_name),''))))      
              WHEN @pa_exch = 'BSE' THEN      
                   Ltrim(Rtrim(CONVERT(VARCHAR(100), ISNULL(CONVERT(VARCHAR(50), @l_first_name),'')+' '+ISNULL(CONVERT(VARCHAR(50), @l_middle_name),'')+' '+ISNULL(CONVERT(VARCHAR(50), @l_last_name),''))))+  case when @l_ctgry in ('IND','NRI','SP') then '|'+ISNULL(CONVERT(VARCHAR(50), @l_last_name),'')+'|'+ISNULL(CONVERT(VARCHAR(50), @l_first_name),'')+'|'+ISNULL(CONVERT(VARCHAR(50),@l_middle_name),'')  else '|||' end      
              WHEN @pa_exch = 'MCX' THEN           
                   ISNULL(CONVERT(VARCHAR(100), @l_first_name),'')+','+ISNULL(CONVERT(VARCHAR(20), @l_middle_name),'')+','+ISNULL(CONVERT(VARCHAR(20), @l_last_name),'')       
              END      
--      
END

GO
