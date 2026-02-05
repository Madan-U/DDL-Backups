-- Object: PROCEDURE citrus_usr.PR_GET_ACCESS
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE   PROCEDURE [citrus_usr].[PR_GET_ACCESS] (@PA_CR_NO NUMERIC        
                               , @PA_ACCT_NO VARCHAR(25)        
                               , @PA_EXCH_SEG VARCHAR(8000)        
                               , @PA_MSG VARCHAR(8000) OUTPUT        
                               )        
        
  AS        
  /*******************************************************************************        
   System         : CLASS        
        
   Module Name    : PR_GET_ACCESS        
        
   Description    : For Getting The Access To Different Segements        
        
   Copyright(c)   : ENC Software Solutions Pvt. Ltd.        
        
   Version History:        
        
   Vers.  Author          Date         Reason        
   -----  -------------   ----------   ------------------------------------------------        
   1.0    Hari R          13/07/06     Initial Version.        
        
  **********************************************************************************/        
    --        
    -- Variables to be declared here        
    --        
SET NOCOUNT ON          
DECLARE @@l_access1 INTEGER,          
@@l_access2 INTEGER          
        
DECLARE @t_tblbitrm TABLE (bitrm_parent_cd VARCHAR(20),bitrm_child_cd VARCHAR(20),bitrm_bit_location INTEGER)          
        
        
 IF (isnull(@PA_CR_NO,0) = 0 or isnull(@PA_EXCH_SEG,'') = '')          
 BEGIN          
  SET @PA_MSG = 'Client code and Exchange descriptors can not be null'          
   RETURN           
 END          
        
IF ISNULL(@PA_ACCT_NO,'') = ''          
  BEGIN          
   SELECT @@l_access1=clia.clia_access1        
        ,@@l_access2=clia.clia_access2          
   FROM   Client_accounts clia WITH(NOLOCK)          
   WHERE  Clia.clia_crn_no  = @PA_CR_NO          
   AND    Clia.clia_deleted_ind = 1          
  END          
ELSE          
  BEGIN          
   SELECT @@l_access1=clia.clia_access1        
        ,@@l_access2=clia.clia_access2          
   FROM   Client_accounts clia WITH(NOLOCK)          
   WHERE  Clia.clia_crn_no  = @PA_CR_NO          
   AND    Clia.clia_acct_no = @PA_ACCT_NO          
   AND    Clia.clia_deleted_ind = 1          
  END          
         
INSERT INTO @t_tblbitrm(bitrm_parent_cd        
           ,bitrm_child_cd,bitrm_bit_location)           
 SELECT     bitrm.bitrm_parent_cd        
           ,bitrm.bitrm_child_cd        
           ,bitrm.bitrm_bit_location          
 FROM       bitmap_ref_mstr bitrm WITH(NOLOCK)          
 WHERE      bitrm.bitrm_parent_cd IN ('ACCESS1','ACCESS2')          
 AND        bitrm.bitrm_deleted_ind =1          
          
 IF @PA_EXCH_SEG = 'ALL'          
 BEGIN          
  SELECT bitrm_child_cd        
       , bitstate= CASE WHEN bitrm_parent_cd = 'ACCESS1' THEN power(2,CONVERT(INT,bitrm_bit_location)-1) & @@l_access1          
                        ELSE power(2,CONVERT(INT,bitrm_bit_location)-1) & @@l_access2         
                        END           
  FROM @t_tblbitrm           
 END           
 ELSE          
 BEGIN          
  SELECT bitrm_child_cd        
        ,bitstate= CASE WHEN bitrm_parent_cd = 'ACCESS1' THEN power(2,CONVERT(INT,bitrm_bit_location)-1) & @@l_access1          
                        ELSE power(2,CONVERT(INT,bitrm_bit_location)-1) & @@l_access2         
                        END           
  FROM @t_tblbitrm WHERE charindex(bitrm_child_cd,@PA_EXCH_SEG,1) <> 0          
 END

GO
