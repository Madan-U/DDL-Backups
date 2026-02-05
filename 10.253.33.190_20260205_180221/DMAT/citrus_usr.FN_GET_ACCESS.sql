-- Object: FUNCTION citrus_usr.FN_GET_ACCESS
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[FN_GET_ACCESS](@PA_EXCH_SEG VARCHAR(8000)
                            , @PA_CRN_NO   NUMERIC 
                             )      
RETURNS VARCHAR(20)      
AS      
BEGIN      
--      
   DECLARE @L_PARENT_CD  VARCHAR(25)      
         , @L_BIT_LOCN   INT    
         , @L_ACCESS     INT
   --      
   SET @L_ACCESS   = 0      
   SET @L_BIT_LOCN = 0      
   --      
   SELECT @L_PARENT_CD      = BITRM_PARENT_CD      
        , @L_BIT_LOCN       =  BITRM_BIT_LOCATION      
   FROM   BITMAP_REF_MSTR WITH (NOLOCK)      
   WHERE  BITRM_PARENT_CD  IN ('ACCESS1', 'ACCESS2')      
   AND    BITRM_CHILD_CD    = @PA_EXCH_SEG      
   AND    BITRM_DELETED_IND = 1      
   --      
   IF @L_PARENT_CD = 'ACCESS1'      
   BEGIN      
   --
     IF NOT EXISTS(SELECT * FROM CC_MSTR WHERE ccm_id = @pa_crn_no AND ccm_deleted_ind = 1)  
     BEGIN
     --
       SELECT @L_ACCESS        = POWER(2, @L_BIT_LOCN-1) & convert(int,ccm_excsm_bit)      
							FROM   CCM_MAK            WITH (NOLOCK)      
							WHERE  CCM_ID           = @PA_CRN_NO      
							AND    ccm_DELETED_IND = 0      
     --
     END
     ElSE
			  BEGIN
     --
							SELECT @L_ACCESS        = POWER(2, @L_BIT_LOCN-1) & convert(int,ccm_excsm_bit)      
							FROM   CC_MSTR            WITH (NOLOCK)      
							WHERE  CCM_ID           = @PA_CRN_NO      
							AND    ccm_DELETED_IND = 1      
					--
					END
   --      
   END      
   RETURN @L_ACCESS      
--      
END

GO
