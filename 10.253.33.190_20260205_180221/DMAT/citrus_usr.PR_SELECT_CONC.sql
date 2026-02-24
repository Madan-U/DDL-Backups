-- Object: PROCEDURE citrus_usr.PR_SELECT_CONC
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_SELECT_CONC](@PA_ID        VARCHAR(20)
                              ,@ROWDELIMITER VARCHAR(4)
                              ,@COLDELIMITER VARCHAR(4)
                              ,@PA_REF_CUR   VARCHAR(8000) OUTPUT
                              )
AS
/*********************************************************************************
   System         : CLASS
   Module Name    : PR_SELECT_CONC
   Description    : Script to select from contact channels
   Copyright(c)   : ENC Software Solutions Pvt. Ltd.
   Version History:
   Vers.  Author          Date         Reason
   -----  -------------   ----------   ------------------------------------------------
   1.0    SUKHI/TUSHAR    18-dec-2006  Initial Version.
*********************************************************************************/

BEGIN
--
  DECLARE @VALUES1            VARCHAR(8000)
         ,@VALUES2            VARCHAR(8000)
         ,@@C_ACCESS_CURSOR   CURSOR

  BEGIN
  --
   SET @VALUES1          = ''
   SET @VALUES2          = ''
   SET @ROWDELIMITER     = '*|~*'
   SET @COLDELIMITER     = '|*~|'
   SET @@C_ACCESS_CURSOR = CURSOR FAST_FORWARD FOR
   --
   SELECT ISNULL(ENTAC.ENTAC_CONCM_CD+@COLDELIMITER+CONC.CONC_VALUE+@COLDELIMITER+@ROWDELIMITER,'') VALUE
   FROM   CONTACT_CHANNELS   CONC   WITH (NOLOCK)
         ,ENTITY_ADR_CONC    ENTAC  WITH (NOLOCK)
   WHERE  ENTAC.ENTAC_ADR_CONC_ID = CONC.CONC_ID
   AND    ENTAC.ENTAC_ENT_ID      = @PA_ID
   AND    CONC.CONC_DELETED_IND   = 1
   AND    ENTAC.ENTAC_DELETED_IND = 1
   --
   OPEN @@C_ACCESS_CURSOR
   FETCH NEXT FROM @@C_ACCESS_CURSOR INTO @VALUES1
   --
   WHILE @@FETCH_STATUS = 0
   BEGIN
   --
      SET @VALUES2 = @VALUES1 +@VALUES2
      FETCH NEXT FROM @@C_ACCESS_CURSOR INTO @VALUES1
   --
   END
   --
   CLOSE @@C_ACCESS_CURSOR
   DEALLOCATE @@C_ACCESS_CURSOR
   SELECT @VALUES2
 --
 END
--
END

GO
