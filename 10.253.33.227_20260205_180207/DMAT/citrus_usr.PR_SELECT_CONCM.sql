-- Object: PROCEDURE citrus_usr.PR_SELECT_CONCM
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_SELECT_CONCM](@PA_MAK_YN     VARCHAR(20)
                               ,@PA_CONCM_CODE VARCHAR(20)
                               ,@PA_CONCM_TYPE VARCHAR(20)
                               ,@PA_LOGIN_NAME VARCHAR(20)
                               ,@PA_REF_CUR    VARCHAR(8000) OUTPUT
                               )
AS
BEGIN
--
  IF @PA_CONCM_TYPE = ''
  BEGIN
  --
    IF @PA_MAK_YN ='MAK'
    BEGIN
    --
      SELECT  CONCM_ID
             ,CONCM_CD
             ,CONCM_DESC
             ,CONCM_CLI    = (CASE WHEN 2 & CONCM_CLI_YN =2 THEN 'C' ELSE 'A' END)
             ,CONCM_CLI_YN = (CASE WHEN 1 & CONCM_CLI_YN =1 THEN '1' ELSE '0' END)
             ,CONCM_RMKS REMARKS
             ,'' ERRMSG
      FROM   CONC_CODE_MSTR_MAK  WITH (NOLOCK)
      WHERE  CONCM_DELETED_IND = 0
      AND    CONCM_CD LIKE @PA_CONCM_CODE+'%%'
      AND    CONCM_LST_UPD_BY <> @PA_LOGIN_NAME
    --
    END
    ELSE
    BEGIN
      --
       SELECT CONCM_ID
             ,CONCM_CD   --CODE
             ,CONCM_DESC  --[DESCRIPTION]
             ,CONCM_CLI    =(CASE WHEN 2 & CONCM_CLI_YN =2 THEN 'C' ELSE 'A' END)
             ,CONCM_CLI_YN =(CASE WHEN 1 & CONCM_CLI_YN =1 THEN '1' ELSE '0' END)
             ,CONCM_RMKS REMARKS
             ,'' ERRMSG
      FROM    CONC_CODE_MSTR WITH (NOLOCK)
      WHERE   CONCM_DELETED_IND = 1
      AND     CONCM_CD LIKE @PA_CONCM_CODE+'%%'
      --
    END
  END
  ELSE
  BEGIN
    --
    IF @PA_MAK_YN ='MAK'
    BEGIN
      --
      SELECT CONCM_ID
             ,CONCM_CD   --CODE
             ,CONCM_DESC  --[DESCRIPTION]
             ,CONCM_CLI    = (CASE WHEN 2 & CONCM_CLI_YN =2 THEN 'C' ELSE 'A' END)
             ,CONCM_CLI_YN = (CASE WHEN 1 & CONCM_CLI_YN =1 THEN '1' ELSE '0' END)
             ,CONCM_RMKS REMARKS
             ,'' ERRMSG
      FROM   CONC_CODE_MSTR_MAK WITH (NOLOCK)
      WHERE  CONCM_DELETED_IND = 0
      AND    CONCM_CD LIKE @PA_CONCM_CODE+'%%'
      AND    2 & CONCM_CLI_YN = (CASE WHEN @PA_CONCM_TYPE='C' THEN  2 ELSE 0 END )
      AND    CONCM_LST_UPD_BY <> @PA_LOGIN_NAME
      --
    END
    ELSE
    BEGIN
      --
      SELECT  CONCM_ID
             ,CONCM_CD   --CODE
             ,CONCM_DESC  --[DESCRIPTION]
             ,CONCM_CLI    = (CASE WHEN 2 & CONCM_CLI_YN =2 THEN 'C' ELSE 'A' END)
             ,CONCM_CLI_YN = (CASE WHEN 1 & CONCM_CLI_YN =1 THEN '1' ELSE '0' END)
             ,CONCM_RMKS REMARKS
             ,'' ERRMSG
      FROM   CONC_CODE_MSTR  WITH (NOLOCK)
      WHERE  CONCM_DELETED_IND = 1
      AND    CONCM_CD LIKE @PA_CONCM_CODE+'%%'
      AND    2 & CONCM_CLI_YN = (CASE WHEN @PA_CONCM_TYPE='C' THEN  2 ELSE 0 END )
      --
    END
    --
  END
  --
END

GO
