-- Object: PROCEDURE citrus_usr.PR_SELECT_ADDR
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_SELECT_ADDR](@PA_ID        VARCHAR(20)
                              ,@ROWDELIMITER VARCHAR(4) =  '*|~*'
                              ,@COLDELIMITER VARCHAR(4) =  '|*~|'
                              ,@PA_REF_CUR   VARCHAR(8000) OUTPUT
                              )
AS
/*********************************************************************************
 SYSTEM         : CLASS
 MODULE NAME    : PR_SELECT_ADDR
 DESCRIPTION    : SCRIPT TO SELECT FROM ADDRESSES
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY: 1.0
 VERS.  AUTHOR          DATE         REASON
 -----  -------------   ----------   ------------------------------------------------
 1.0    SUKHI/TUSHAR    18-DEC-2006  INITIAL VERSION.
*********************************************************************************/
BEGIN
--
 DECLARE @VALUES1            VARCHAR(8000)
       , @VALUES2            VARCHAR(8000)
       , @@C_ACCESS_CURSOR   CURSOR
 --
 BEGIN
   --
   SET @VALUES1 = ''
   SET @VALUES2 = ''
   SET @ROWDELIMITER ='*|~*'
   SET @COLDELIMITER ='|*~|'
   --
   SET @@C_ACCESS_CURSOR =  CURSOR FAST_FORWARD FOR
   SELECT ISNULL(ENTAC.ENTAC_CONCM_CD+@COLDELIMITER+ADR.ADR_1+@COLDELIMITER+ADR.ADR_2+@COLDELIMITER+ADR.ADR_3+@COLDELIMITER+ADR.ADR_CITY+@COLDELIMITER+ADR.ADR_STATE+@COLDELIMITER+ADR.ADR_COUNTRY+@COLDELIMITER+ADR.ADR_ZIP+@COLDELIMITER+@ROWDELIMITER, ' ') VALUE
   FROM ADDRESSES       ADR   WITH (NOLOCK)
       ,ENTITY_ADR_CONC ENTAC WITH (NOLOCK)
   WHERE  ENTAC.ENTAC_ADR_CONC_ID = ADR.ADR_ID
   AND    ENTAC.ENTAC_ENT_ID      = @PA_ID
   AND    ADR.ADR_DELETED_IND     = 1
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
   --
   SELECT @VALUES2
   --
 END
--
END

GO
