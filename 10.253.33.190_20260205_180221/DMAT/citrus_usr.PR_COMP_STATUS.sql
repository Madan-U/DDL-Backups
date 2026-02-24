-- Object: PROCEDURE citrus_usr.PR_COMP_STATUS
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_COMP_STATUS](@PA_LOGIN_NAME  VARCHAR(20)
                              ,@PA_ENT_ID      NUMERIC
                              ,@PA_ROL_IDS     VARCHAR(8000)
                              ,@PA_SCR_ID      NUMERIC
                              ,@ROWDELIMITER   VARCHAR(4) = '*|~*'
                              ,@COLDELIMITER   VARCHAR(4) = '|*~|'
                              ,@PA_REF_CUR     VARCHAR(8000) OUTPUT
                              )
AS
/*******************************************************************************
 SYSTEM         : CLASS
 MODULE NAME    : PR_COMP_STATUS
 DESCRIPTION    : THIS PROCEDURE WILL GIVE THE ACTION/S THAT CAN BE PERFORMED AND THE STATUS OF THE COMPONENTS
 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
 VERSION HISTORY:
 VERS.  AUTHOR             DATE         REASON
 -----  -------------      ----------   ------------------------------------------------
 1.0    SUKHVINDER/TUSHAR  07-01-2007  INITIAL VERSION.
 2.0    SUKHVINDER/TUSHAR  06-02-2007  MULTIPLE ROLE_ID IN A STRING
**********************************************************************************/
BEGIN
--
  SET NOCOUNT ON
  --
  DECLARE @@C_SCR_CURSOR         CURSOR
         ,@@C_MDTRY_CURSOR       CURSOR
         ,@@C_DISABLE_CURSOR     CURSOR
         ,@@L_ACT_CD             VARCHAR(10)
         ,@@L_SCR_RIGHTS         VARCHAR(8000)
         ,@@L_BIT_LOCN           NUMERIC
         ,@@L_COUNTER            INT
         ,@@L_STRING             VARCHAR(250)
         ,@@L_MAX_NO             NUMERIC
         ,@@L_ROLC_COMP_ID       NUMERIC
         ,@@L_SCRC_TAB_ID        NUMERIC
         ,@@L_SCRC_TAB_NAME      VARCHAR(50)
         ,@@L_PREV_TAB_NAME      VARCHAR(50)
         ,@@L_SCRC_COMP_NAME     VARCHAR(50)
         ,@@L_ROLC_MDTRY         INT
         ,@@L_EXCSM_ID           NUMERIC
         ,@@L_MDTRY_VAR_ALL      VARCHAR(8000)
         ,@@L_MDTRY_VAR_FEW      VARCHAR(8000)
         ,@@L_ROLC_DISABLE       INT
         ,@@L_SCRC_DISABLE_VAR   VARCHAR(8000)
         ,@@DELIMETER            VARCHAR(10)
         ,@@DELIMETERLENGTH      INT
         ,@@REMAININGSTRING      VARCHAR(8000)
         ,@@CURRSTRING           VARCHAR(8000)
         ,@@FOUNDAT              INT
  --
  SET @@DELIMETER              = '%'+ @ROWDELIMITER + '%'
  SET @@DELIMETERLENGTH        = LEN(@ROWDELIMITER)
  SET @@REMAININGSTRING        = @PA_ROL_IDS
  --
  CREATE TABLE #T_ROLE_ID
  (ROLEID  NUMERIC)
  --
  WHILE @@REMAININGSTRING <> ''
  BEGIN --#01
  --
    SET @@FOUNDAT = 0
    SET @@FOUNDAT =  PATINDEX('%'+@@DELIMETER+'%',@@REMAININGSTRING)
    --
    IF @@FOUNDAT > 0
    BEGIN
    --
      SET @@CURRSTRING      = SUBSTRING(@@REMAININGSTRING, 0, @@FOUNDAT)
      SET @@REMAININGSTRING = SUBSTRING(@@REMAININGSTRING, @@FOUNDAT+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING)- @@FOUNDAT+@@DELIMETERLENGTH)
    --
    END
    ELSE
    BEGIN
    --
      SET @@CURRSTRING      = @@REMAININGSTRING
      SET @@REMAININGSTRING = ''
    --
    END
    --
    IF @@CURRSTRING <> ''
    BEGIN
    --
      INSERT INTO #T_ROLE_ID VALUES(CONVERT(NUMERIC, @@CURRSTRING))
    --
    END
  --
  END  --#01
  --
  --SCR_RIGHTS--
  SET @@C_SCR_CURSOR =  CURSOR FAST_FORWARD FOR
  SELECT DISTINCT ACT.ACT_CD     ACT_CD
  FROM   ACTIONS                 ACT  WITH(NOLOCK)
       , ROLES_ACTIONS           ROLA WITH(NOLOCK)
  WHERE  ROLA.ROLA_ACT_ID      = ACT.ACT_ID
  AND    ACT.ACT_DELETED_IND   = 1
  AND    ROLA.ROLA_DELETED_IND = 1
  AND    ACT.ACT_SCR_ID        = @PA_SCR_ID
  AND    ROLA.ROLA_ROL_ID      IN (SELECT ROLEID FROM #T_ROLE_ID)
  --
  OPEN @@C_SCR_CURSOR FETCH NEXT FROM @@C_SCR_CURSOR INTO @@L_ACT_CD
  --
  WHILE @@FETCH_STATUS = 0
  BEGIN
  --
    SET @@L_SCR_RIGHTS = ISNULL(@@L_SCR_RIGHTS,'')+@@L_ACT_CD+@ROWDELIMITER
    FETCH NEXT FROM @@C_SCR_CURSOR INTO @@L_ACT_CD
  --
  END
  --
  CLOSE @@C_SCR_CURSOR
  DEALLOCATE @@C_SCR_CURSOR
  --SCR_RIGHTS--
  SET @@REMAININGSTRING   = @PA_ROL_IDS
  SET @@CURRSTRING        = NULL
  --
  WHILE @@REMAININGSTRING <> ''
  BEGIN
  --
    SET @@FOUNDAT = 0
    SET @@FOUNDAT =  PATINDEX('%'+@@DELIMETER+'%',@@REMAININGSTRING)
    --
    IF @@FOUNDAT > 0
    BEGIN
    --
      SET @@CURRSTRING      = SUBSTRING(@@REMAININGSTRING, 0, @@FOUNDAT)
      SET @@REMAININGSTRING = SUBSTRING(@@REMAININGSTRING, @@FOUNDAT+@@DELIMETERLENGTH, LEN(@@REMAININGSTRING)- @@FOUNDAT+@@DELIMETERLENGTH)
    --
    END
    ELSE
    BEGIN
    --
      SET @@CURRSTRING      = @@REMAININGSTRING
      SET @@REMAININGSTRING = ''
    --
    END
    --
    IF @@CURRSTRING <> ''
    BEGIN
    --
      SELECT @@L_BIT_LOCN      = MAX(BITRM_BIT_LOCATION)
      FROM   BITMAP_REF_MSTR WITH(NOLOCK)
      WHERE  BITRM_PARENT_CD   IN ('ACCESS1', 'ACCESS2')
      AND    BITRM_DELETED_IND = 1
      --
      WHILE @@L_COUNTER <= @@L_BIT_LOCN
      BEGIN
      --
        SET @@L_STRING =ISNULL(@@L_STRING,'') + CONVERT(VARCHAR,1)
        --
        SET @@L_COUNTER = @@L_COUNTER + 1
      --
      END
      --
      SET @@L_MAX_NO =  citrus_usr.TO_DEC(@@L_STRING, 2)
      -------------------------------------------------------------------------------------------------
      SET @@C_MDTRY_CURSOR =  CURSOR FAST_FORWARD FOR
      SELECT ROLC.ROLC_COMP_ID       ROLC_COMP_ID
           , SCRC.SCRC_TAB_ID       SCRC_TAB_ID
           , SCRC.SCRC_TAB_NAME     SCRC_TAB_NAME
           , SCRC.SCRC_COMP_NAME    SCRC_COMP_NAME
           , ROLC.ROLC_MDTRY        ROLC_MDTRY
           , EXCSM.EXCSM_ID         EXCSM_ID
      FROM ROLES_COMPONENTS   ROLC  WITH(NOLOCK)
          ,SCREEN_COMPONENT   SCRC  WITH(NOLOCK)
          ,EXCH_SEG_MSTR      EXCSM WITH(NOLOCK)
      WHERE  ROLC.ROLC_SCR_ID   = SCRC.SCRC_SCR_ID
      AND    ROLC.ROLC_COMP_ID  = SCRC.SCRC_COMP_ID
      AND    EXCSM.EXCSM_DELETED_IND = 1
      AND    ROLC.ROLC_ROL_ID   = @@CURRSTRING
      AND    ROLC.ROLC_SCR_ID   = @PA_SCR_ID
      AND    citrus_usr.FN_GET_COMP_ACCESS(@@CURRSTRING, @PA_SCR_ID, ROLC.ROLC_COMP_ID, ROLC.ROLC_MDTRY, ROLC.ROLC_DISABLE, EXCSM.EXCSM_DESC) > 0
      ORDER  BY ROLC_COMP_ID
      --
      OPEN @@C_MDTRY_CURSOR
      FETCH NEXT FROM @@C_MDTRY_CURSOR INTO @@L_ROLC_COMP_ID, @@L_SCRC_TAB_ID, @@L_SCRC_TAB_NAME, @@L_SCRC_COMP_NAME, @@L_ROLC_MDTRY ,@@L_EXCSM_ID
      WHILE @@FETCH_STATUS = 0
      BEGIN
      --
        IF @@L_ROLC_MDTRY = @@L_MAX_NO
        BEGIN
        --
          SET @@L_MDTRY_VAR_ALL = ISNULL(@@L_MDTRY_VAR_ALL,'')+@@L_SCRC_COMP_NAME+@COLDELIMITER+CONVERT(VARCHAR,@@L_SCRC_TAB_ID)+@ROWDELIMITER
        --
        END
        ELSE
        BEGIN
        --
          IF @@L_PREV_TAB_NAME = @@L_SCRC_TAB_NAME
          BEGIN
          --
            SET @@L_MDTRY_VAR_FEW = ISNULL(@@L_MDTRY_VAR_FEW, '')+@COLDELIMITER+CONVERT(VARCHAR, @@L_EXCSM_ID)
          --
          END
          ELSE IF ISNULL(@@L_PREV_TAB_NAME,'') <> @@L_SCRC_TAB_NAME
          BEGIN
          --
            SET @@L_MDTRY_VAR_FEW = ISNULL(@@L_MDTRY_VAR_FEW,'')+@ROWDELIMITER+@@L_SCRC_COMP_NAME+@COLDELIMITER+CONVERT(VARCHAR,@@L_SCRC_TAB_ID)+@COLDELIMITER+CONVERT(VARCHAR,@@L_EXCSM_ID)
          --
          END
        --
        END
        --
        SET @@L_PREV_TAB_NAME = @@L_SCRC_TAB_NAME
        FETCH NEXT FROM @@C_MDTRY_CURSOR INTO @@L_ROLC_COMP_ID ,@@L_SCRC_TAB_ID ,@@L_SCRC_TAB_NAME ,@@L_SCRC_COMP_NAME ,@@L_ROLC_MDTRY ,@@L_EXCSM_ID
      --
      END
      CLOSE @@C_MDTRY_CURSOR
      DEALLOCATE @@C_MDTRY_CURSOR
      -------------------------------------------------------------------------------------------------
      SET @@C_DISABLE_CURSOR =  CURSOR FAST_FORWARD FOR
      SELECT SCRC.SCRC_COMP_NAME   SCRC_COMP_NAME
           , ROLC.ROLC_DISABLE     ROLC_DISABLE
      FROM   ROLES_COMPONENTS      ROLC WITH(NOLOCK)
           , SCREEN_COMPONENT      SCRC WITH(NOLOCK)
      WHERE  ROLC.ROLC_SCR_ID      = SCRC.SCRC_SCR_ID
      AND    ROLC.ROLC_COMP_ID     = SCRC.SCRC_COMP_ID
      AND    ROLC.ROLC_ROL_ID      = @@CURRSTRING
      AND    ROLC.ROLC_SCR_ID      = @PA_SCR_ID
      AND    ROLC.ROLC_DELETED_IND = 1
      AND    SCRC.SCRC_DELETED_IND = 1
      AND    ROLC.ROLC_DISABLE     > 0
      --
      OPEN @@C_DISABLE_CURSOR
      FETCH NEXT FROM @@C_DISABLE_CURSOR INTO @@L_SCRC_COMP_NAME ,@@L_ROLC_DISABLE
      WHILE @@FETCH_STATUS = 0
      BEGIN
      --
        SET @@L_SCRC_DISABLE_VAR = ISNULL(@@L_SCRC_DISABLE_VAR, '')+@@L_SCRC_COMP_NAME+@ROWDELIMITER
        FETCH NEXT FROM @@C_DISABLE_CURSOR INTO @@L_SCRC_COMP_NAME ,@@L_ROLC_DISABLE
      --
      END
      CLOSE @@C_DISABLE_CURSOR
      DEALLOCATE @@C_DISABLE_CURSOR
    --
    END --@@CURRSTRING <> ''
  --
  END --@@REMAININGSTRING
  --
  SELECT  ISNULL(@@L_SCR_RIGHTS, ' ') SCR_RIGHTS , ISNULL(@@L_MDTRY_VAR_ALL, ' ') COMP_MDTRY_ALL , ISNULL(@@L_SCRC_DISABLE_VAR, ' ') COMP_DISABLE, ISNULL(@@L_MDTRY_VAR_FEW, '') COMP_MDTRY_FEW
--
END

GO
