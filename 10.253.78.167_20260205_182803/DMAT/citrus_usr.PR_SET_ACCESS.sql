-- Object: PROCEDURE citrus_usr.PR_SET_ACCESS
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_SET_ACCESS](@PA_CR_NO     NUMERIC
                             ,@PA_ACCT_NO   VARCHAR(25)
                             ,@PA_EXCH_SEG  VARCHAR(8000)
                             ,@PA_YN        VARCHAR(1)
                             ,@PA_MSG       VARCHAR(8000)  OUTPUT
                             )
AS
/*******************************************************************************
SYSTEM         : CLASS
MODULE NAME    : PR_SET_ACCESS
DESCRIPTION    : FOR SETTING THE ACCESS TO DIFFERENT SEGEMENTS
COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
VERSION HISTORY:
VERS.  AUTHOR          DATE         REASON
-----  -------------   ----------   ------------------------------------------------
1.0    HARI R          18/07/06     INITIAL VERSION.
**********************************************************************************/
BEGIN
--
  SET NOCOUNT ON
  --
  DECLARE
  @@C_ACCESS_CURSOR      CURSOR,
  @@L_BITRM_PARENT_CD    VARCHAR(20),
  @@L_BITRM_CHILD_CD     VARCHAR(20),
  @@L_BITRM_BIT_LOCATION INTEGER,
  @@L_BITSTATE           INTEGER,
  @@L_ACCESS1            INTEGER,
  @@L_ACCESS2            INTEGER,
  @@L_UPD_ACCESS1        INT,
  @@L_UPD_ACCESS2        INT
  --
  SET @@L_BITSTATE = 0
  --
  DECLARE @T_TBLBITRM TABLE
  (BITRM_PARENT_CD    VARCHAR(20)
  ,BITRM_CHILD_CD     VARCHAR(20)
  ,BITRM_BIT_LOCATION INTEGER
  )
  --
  IF ISNULL(@PA_CR_NO, 0) = 0
  BEGIN
  --
     SET @PA_MSG  =  'CLIENT CODE DESCRIPTORS CAN NOT BE NULL'
     RETURN
  --
  END
  --
  IF ISNULL(@PA_EXCH_SEG,'') = ''
  BEGIN
  --
    SET @PA_MSG  =  'EXCHANGE DESCRIPTORS CAN NOT BE NULL'
    RETURN
  --
  END
  --
  IF ISNULL(@PA_YN,'') = ''
  BEGIN
  --
    SET @PA_MSG  =  'ACCESS TYPE NOT SPECIFIED'
    RETURN
  --
  END
  --
  IF ISNULL(@PA_ACCT_NO, '') = ''
  BEGIN
  --
     SELECT @@L_ACCESS1 = CLIA.CLIA_ACCESS1
           ,@@L_ACCESS2 = CLIA.CLIA_ACCESS2
     FROM  CLIENT_ACCOUNTS CLIA WITH(NOLOCK)
     WHERE CLIA.CLIA_CRN_NO = @PA_CR_NO
     AND   CLIA.CLIA_DELETED_IND  =  1
  --
  END
  ELSE
  BEGIN
  --
     SELECT @@L_ACCESS1 = CLIA.CLIA_ACCESS1
           ,@@L_ACCESS2 = CLIA.CLIA_ACCESS2
     FROM   CLIENT_ACCOUNTS CLIA WITH(NOLOCK)
     WHERE  CLIA.CLIA_CRN_NO  = @PA_CR_NO
     AND    CLIA.CLIA_ACCT_NO = @PA_ACCT_NO
     AND    CLIA.CLIA_DELETED_IND  =  1
  --
  END
  --
  INSERT INTO @T_TBLBITRM
  (BITRM_PARENT_CD
  ,BITRM_CHILD_CD
  ,BITRM_BIT_LOCATION
  )
  SELECT  BITRM.BITRM_PARENT_CD
         ,BITRM.BITRM_CHILD_CD
         ,BITRM_BIT_LOCATION = CONVERT(INTEGER, BITRM.BITRM_BIT_LOCATION)
  FROM    BITMAP_REF_MSTR BITRM WITH(NOLOCK)
  WHERE   BITRM.BITRM_PARENT_CD IN ('ACCESS1','ACCESS2')
  AND     BITRM.BITRM_DELETED_IND  = 1
  --
  IF @PA_EXCH_SEG  =  'ALL'
  BEGIN
  --
    SET @@C_ACCESS_CURSOR  =  CURSOR FAST_FORWARD FOR
    SELECT BITRM_PARENT_CD
         ,BITRM_CHILD_CD
         ,BITRM_BIT_LOCATION
    FROM @T_TBLBITRM
  --
  END
  ELSE
  BEGIN
  --
     SET @@C_ACCESS_CURSOR  =   CURSOR FAST_FORWARD FOR
     SELECT BITRM_PARENT_CD
           ,BITRM_CHILD_CD,BITRM_BIT_LOCATION
     FROM  @T_TBLBITRM
     WHERE CHARINDEX(BITRM_CHILD_CD,@PA_EXCH_SEG,1) <> 0 FOR READ ONLY
  --
  END

  OPEN @@C_ACCESS_CURSOR
  FETCH NEXT FROM @@C_ACCESS_CURSOR INTO @@L_BITRM_PARENT_CD , @@L_BITRM_CHILD_CD, @@L_BITRM_BIT_LOCATION
  --
  WHILE @@FETCH_STATUS = 0
  BEGIN
  --
     IF @@L_BITRM_PARENT_CD = 'ACCESS1'
     BEGIN
     --
       SET @@L_BITSTATE =  POWER(2,@@L_BITRM_BIT_LOCATION-1) & @@L_ACCESS1
       IF @PA_YN = 'Y' AND @@L_BITSTATE = 0
       BEGIN
       --
          SET @@L_ACCESS1 =  POWER(2,@@L_BITRM_BIT_LOCATION-1) | @@L_ACCESS1
          SET @@L_UPD_ACCESS1 = 1
       --
       END
       --
       IF @PA_YN  =  'N' AND @@L_BITSTATE > 0
       BEGIN
       --
          SET @@L_ACCESS1 =  POWER(2,@@L_BITRM_BIT_LOCATION-1) ^ @@L_ACCESS1
          SET @@L_UPD_ACCESS1 = 1
       --
       END
     --
     END
     ELSE
     BEGIN
     --
        SET @@L_BITSTATE =  POWER(2,@@L_BITRM_BIT_LOCATION-1) & @@L_ACCESS2
        IF @PA_YN  =  'Y' AND @@L_BITSTATE  =  0
        BEGIN
        --
           SET @@L_ACCESS2 =  POWER(2,@@L_BITRM_BIT_LOCATION-1) | @@L_ACCESS2
           SET @@L_UPD_ACCESS2 = 1
        --
        END
        --
        IF @PA_YN = 'N' AND @@L_BITSTATE > 0
        BEGIN
        --
           SET @@L_ACCESS2 =  POWER(2,@@L_BITRM_BIT_LOCATION-1) | @@L_ACCESS2
           SET @@L_UPD_ACCESS2 = 1
        --
        END
     --
     END
     FETCH NEXT FROM @@C_ACCESS_CURSOR INTO @@L_BITRM_PARENT_CD , @@L_BITRM_CHILD_CD,@@L_BITRM_BIT_LOCATION
  --
  END
  CLOSE @@C_ACCESS_CURSOR
  DEALLOCATE @@C_ACCESS_CURSOR
  --
  IF ISNULL(@PA_ACCT_NO,'')  =  ''
  BEGIN
  --
    IF @@L_UPD_ACCESS1 = 1
    BEGIN
    --
       UPDATE CLIENT_ACCOUNTS
       SET CLIA_ACCESS1 =  @@L_ACCESS1
       WHERE CLIENT_ACCOUNTS.CLIA_CRN_NO = @PA_CR_NO
    --
    END
    IF @@L_UPD_ACCESS2 = 1
    BEGIN
    --
      UPDATE CLIENT_ACCOUNTS
      SET CLIA_ACCESS2 = @@L_ACCESS2
      WHERE CLIENT_ACCOUNTS.CLIA_CRN_NO = @PA_CR_NO
    --
    END
  --
  END
 --
 IF ISNULL(@PA_ACCT_NO,'') <> ''
 BEGIN
 --
    IF @@L_UPD_ACCESS1  =  1
    BEGIN
    --
      UPDATE CLIENT_ACCOUNTS
      SET CLIA_ACCESS1 = @@L_ACCESS1
      WHERE CLIENT_ACCOUNTS.CLIA_CRN_NO = @PA_CR_NO
      AND CLIA_ACCT_NO = @PA_ACCT_NO
    --
    END
    IF @@L_UPD_ACCESS2 = 1
    BEGIN
    --
      UPDATE CLIENT_ACCOUNTS
      SET CLIA_ACCESS2 = @@L_ACCESS2
      WHERE CLIENT_ACCOUNTS.CLIA_CRN_NO = @PA_CR_NO
      AND CLIA_ACCT_NO = @PA_ACCT_NO
    --
    END
  --
  END
--
END
  --*************************** <PR_SET_ACCESS> ***************************--

GO
