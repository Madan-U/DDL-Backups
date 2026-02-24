-- Object: PROCEDURE citrus_usr.PR_SELECT_EXCSM
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE  [citrus_usr].[PR_SELECT_EXCSM](@PA_MAK_YN     VARCHAR(20)
                               , @PA_EXCH_CD    VARCHAR(20)
                               , @PA_SEG_CD     VARCHAR(20)
                               , @PA_LOGIN_NAME VARCHAR(20)
                               , @PA_REF_CUR    VARCHAR(8000) OUTPUT
                                 )
/*
*********************************************************************************
 SYSTEM         : CLASS

 MODULE NAME    : PR_SELECT_EXCSM

 DESCRIPTION    : THIS PROCEDURE FETCHES THE VALUE FROM EXCHANGE_SEG_MSTR

 COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.

 VERSION HISTORY:

 VERS.  AUTHOR          DATE         REASON
 -----  -------------   ----------   -------------------------------------------------
 1.0    HARI R          10-OCT-2006  INITIAL VERSION.
 2.0    SUKHVINDER      10-OCT-2006  INITIAL VERSION.
-----------------------------------------------------------------------------------*/
--
-- VARIABLES TO BE DECLARED HERE
--
AS
BEGIN
 IF @PA_EXCH_CD = ''
 BEGIN
   --
   IF @PA_MAK_YN ='MAK'
   BEGIN
     --
     SELECT EXCSM_ID
            ,EXCSM_EXCH_CD
            ,EXCSM_SEG_CD
            ,EXCSM_SUB_SEG_CD
            ,EXCSM_RMKS REMARKS
            ,ISNULL((SELECT TOP 1 EXCSM_EXCH_CD + '_' + EXCSM_SEG_CD + '_' + EXCSM_SUB_SEG_CD
                     FROM   EXCH_SEG_MSTR_MAK E WITH (NOLOCK)
                     WHERE  E.EXCSM_ID = M.EXCSM_PARENT_ID),'') EXCSM_DESC
            ,EXCSM_PARENT_ID,EXCSM_COMPM_ID,'' AS ERRMSG
            ,EXCSM_EXCH_CD + '_' + EXCSM_SEG_CD + '_' + EXCSM_SUB_SEG_CD EXCSM_PARENT_DESC
      FROM   EXCH_SEG_MSTR_MAK  M WITH (NOLOCK)
      WHERE  EXCSM_DELETED_IND = 0
      AND    EXCSM_LST_UPD_BY <>  @PA_LOGIN_NAME
      ORDER BY EXCSM_ID     --
   END
   ELSE
   BEGIN
     --
      SELECT EXCSM_ID
            ,EXCSM_EXCH_CD
            ,EXCSM_SEG_CD
            ,EXCSM_SUB_SEG_CD
            ,EXCSM_RMKS REMARKS
            ,ISNULL((SELECT TOP 1 EXCSM_EXCH_CD + '_' + EXCSM_SEG_CD + '_' + EXCSM_SUB_SEG_CD
                     FROM   EXCH_SEG_MSTR E WITH (NOLOCK)
                     WHERE  E.EXCSM_ID = M.EXCSM_PARENT_ID),'') EXCSM_DESC
            ,EXCSM_PARENT_ID,EXCSM_COMPM_ID,'' AS ERRMSG
            ,EXCSM_EXCH_CD + '_' + EXCSM_SEG_CD + '_' + EXCSM_SUB_SEG_CD EXCSM_PARENT_DESC
      FROM EXCH_SEG_MSTR  M WITH (NOLOCK)
      WHERE EXCSM_DELETED_IND = 1
      ORDER BY EXCSM_ID
     --
   END

   --
 END
 ELSE
 BEGIN
   --
   IF @PA_MAK_YN ='MAK'
   BEGIN
     --
      SELECT EXCSM_ID
            ,EXCSM_EXCH_CD
            ,EXCSM_SEG_CD
            ,EXCSM_SUB_SEG_CD
            ,EXCSM_RMKS REMARKS
            ,ISNULL((SELECT TOP 1 EXCSM_EXCH_CD + '_' + EXCSM_SEG_CD + '_' + EXCSM_SUB_SEG_CD
                    FROM   EXCH_SEG_MSTR_MAK E WITH (NOLOCK)
                    WHERE  E.EXCSM_ID = M.EXCSM_PARENT_ID),'') EXCSM_DESC
            ,EXCSM_PARENT_ID,EXCSM_COMPM_ID,'' AS ERRMSG
            ,EXCSM_EXCH_CD + '_' + EXCSM_SEG_CD + '_' + EXCSM_SUB_SEG_CD EXCSM_PARENT_DESC
      FROM EXCH_SEG_MSTR_MAK  M WITH (NOLOCK)
      WHERE EXCSM_DELETED_IND = 0
      AND   M.EXCSM_EXCH_CD   = @PA_EXCH_CD
      AND   M.EXCSM_SEG_CD LIKE @PA_SEG_CD + '%'
      AND   EXCSM_LST_UPD_BY <>  @PA_LOGIN_NAME
      ORDER BY EXCSM_ID
     --
   END
   ELSE
   BEGIN
     --
     SELECT  EXCSM_ID
            ,EXCSM_EXCH_CD
            ,EXCSM_SEG_CD
            ,EXCSM_SUB_SEG_CD
            ,EXCSM_RMKS REMARKS
            ,ISNULL((SELECT TOP 1 EXCSM_EXCH_CD + '_' + EXCSM_SEG_CD + '_' + EXCSM_SUB_SEG_CD
                     FROM   EXCH_SEG_MSTR E WITH (NOLOCK)
                     WHERE  E.EXCSM_ID = M.EXCSM_PARENT_ID),'') EXCSM_DESC
            ,EXCSM_PARENT_ID,EXCSM_COMPM_ID,'' AS ERRMSG
            ,EXCSM_EXCH_CD + '_' + EXCSM_SEG_CD + '_' + EXCSM_SUB_SEG_CD EXCSM_PARENT_DESC
      FROM EXCH_SEG_MSTR  M WITH (NOLOCK)
      WHERE EXCSM_DELETED_IND = 1
      AND    M.EXCSM_EXCH_CD   = @PA_EXCH_CD
      AND    M.EXCSM_SEG_CD LIKE @PA_SEG_CD + '%'
      ORDER BY EXCSM_ID
     --
   END
   --
 END
--
END

GO
