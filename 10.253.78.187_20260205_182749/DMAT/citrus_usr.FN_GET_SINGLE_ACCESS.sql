-- Object: FUNCTION citrus_usr.FN_GET_SINGLE_ACCESS
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[FN_GET_SINGLE_ACCESS](@PA_CRN_NO    NUMERIC
                                   ,@PA_ACCT_NO   VARCHAR(25)
                                   ,@PA_EXCH_SEG  VARCHAR(8000)
                                   )
RETURNS VARCHAR(20)
AS
BEGIN
--
   DECLARE @L_PARENT_CD  VARCHAR(25)
         , @L_BIT_LOCN   NUMERIC
         , @L_ACCESS     NUMERIC
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
     SELECT @L_ACCESS        = POWER(2, @L_BIT_LOCN-1) & CLIA_ACCESS1
     FROM   CLIENT_ACCOUNTS  WITH (NOLOCK)
     WHERE  CLIA_ACCT_NO     = @PA_ACCT_NO
     AND    CLIA_CRN_NO      = @PA_CRN_NO
     AND    CLIA_DELETED_IND = 1
   --
   END
   ELSE
   BEGIN
   --
     SELECT @L_ACCESS        = POWER(2, @L_BIT_LOCN-1) & CLIA_ACCESS2
     FROM   CLIENT_ACCOUNTS  WITH (NOLOCK)
     WHERE  CLIA_ACCT_NO     = @PA_ACCT_NO
     AND    CLIA_CRN_NO      = @PA_CRN_NO
     AND    CLIA_DELETED_IND = 1
   --
   END
   --
   RETURN @L_ACCESS
--
END

GO
