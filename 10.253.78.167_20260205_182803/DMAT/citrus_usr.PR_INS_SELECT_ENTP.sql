-- Object: PROCEDURE citrus_usr.PR_INS_SELECT_ENTP
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_INS_SELECT_ENTP](@PA_CRN_NO     NUMERIC
                                  ,@PA_CLICM_ID   NUMERIC
                                  ,@PA_ENTTM_ID   NUMERIC
                                  ,@PA_TAB        VARCHAR(20)                                  
                                  ,@ROWDELIMITER  VARCHAR(20)  ='*|~*'
                                  ,@COLDELIMITER  VARCHAR(20)  = '|*~|'
                                  ,@PA_REF_CUR    VARCHAR(8000) OUTPUT
                                  )
AS
/*******************************************************************************
SYSTEM         : CLASS
MODULE NAME    : PR_INS_SELECT_ENTP
DESCRIPTION    : SCRIPT TO SELECT FROM THE ENTITY_PROPERTY
COPYRIGHT(C)   : ENC SOFTWARE SOLUTIONS PVT. LTD.
VERSION HISTORY:
VERS.  AUTHOR          DATE         REASON
-----  -------------   ----------   ------------------------------------------------
1.0    TUSHAR          13-FEB-2007  INITIAL VERSION.
**********************************************************************************/
--
BEGIN
--
  IF @PA_TAB = 'CLIP'
  BEGIN
  --
    SELECT X.EXCSM_EXCH_CD       EXCSM_EXCH_CD
         , X.EXCSM_SEG_CD        EXCSM_SEG_CD   
         , X.PROM_ID             PROM_ID 
         , X.PROM_DESC           PROM_DESC
         , X.ENTPM_PROP_ID       ENTPM_PROP_ID
         , X.ENTPM_CLICM_ID      ENTPM_CLICM_ID
         , X.ENTP_ID             ENTP_ID
         , X.ENTPM_ENTTM_ID      ENTPM_ENTTM_ID
         , X.ENTPM_ID            ENTPM_ID
         , X.ENTPM_CD            ENTPM_CD
         , X.ENTPM_DESC          ENTPM_DESC
         , X.ENTP_VALUE          ENTP_VALUE
         , Y.ENTDM_CD            ENTDM_CD
         , Y.ENTPD_VALUE         ENTPD_VALUE
         , Y.ENTDM_DESC          ENTDM_DESC
         , X.ENTPM_MDTY          ENTPM_MDTY
         , X.ENTPM_DATATYPE      ENTPM_DATATYPE
         , Y.ENTDM_DATATYPE      ENTDM_DATATYPE
    FROM (SELECT DISTINCT EXCSM.EXCSM_EXCH_CD        EXCSM_EXCH_CD    
               , EXCSM.EXCSM_SEG_CD                  EXCSM_SEG_CD    
               , PROM.PROM_ID                        PROM_ID 
               , ENTPM.ENTPM_ENTTM_ID                ENTPM_ENTTM_ID
               , ISNULL(PROM.PROM_DESC,'')           PROM_DESC  
               , ISNULL(ENTP.ENTP_VALUE,'')          ENTP_VALUE
               , ENTPM.ENTPM_PROP_ID                 ENTPM_PROP_ID
               , ENTPM.ENTPM_CD                      ENTPM_CD
               , ISNULL(ENTPM.ENTPM_DESC,'')         ENTPM_DESC    
               , ENTPM.ENTPM_CLICM_ID                ENTPM_CLICM_ID    
               , ENTP.ENTP_ID                        ENTP_ID
               , ENTPM.ENTPM_ID                      ENTPM_ID
               , ENTP.ENTP_ENT_ID                    ENTP_ENT_ID
               , CASE ENTPM.ENTPM_MDTY WHEN 1     THEN 'M' ELSE 'N' END ENTPM_MDTY
               , CASE EXCSM_EXCH_CD    WHEN 'BSE' THEN CONVERT(VARCHAR,1) WHEN 'NSE'THEN CONVERT(VARCHAR,2) ELSE CONVERT(VARCHAR,3) END  ORD1  
               , ENTPM.ENTPM_DATATYPE                ENTPM_DATATYPE 
          FROM   ENTITY_PROPERTY_MSTR   ENTPM    WITH(NOLOCK)    
          LEFT OUTER JOIN 
                 ENTITY_PROPERTIES      ENTP     WITH(NOLOCK)     
          ON     (ENTPM.ENTPM_PROP_ID = ENTP.ENTP_ENTPM_PROP_ID AND ISNULL(ENTP_ENT_ID, 0) = @PA_CRN_NO) 
               , EXCH_SEG_MSTR          EXCSM    WITH(NOLOCK)    
               , EXCSM_PROD_MSTR        EXCPM    WITH(NOLOCK)    
               , PRODUCT_MSTR           PROM     WITH(NOLOCK)    
          WHERE  ENTPM.ENTPM_EXCPM_ID                 = EXCPM.EXCPM_ID    
          AND    PROM.PROM_ID                         = EXCPM.EXCPM_PROM_ID    
          AND    EXCPM.EXCPM_EXCSM_ID                 = EXCSM.EXCSM_ID    
          AND    EXCPM.EXCPM_DELETED_IND              = 1    
          AND    ISNULL(ENTP_DELETED_IND, 1)          = 1  
          AND    PROM.PROM_DELETED_IND                = 1    
          AND    EXCSM.EXCSM_DELETED_IND              = 1    
          AND    ENTPM.ENTPM_DELETED_IND              = 1    
          AND    ENTPM_CLICM_ID                       = @PA_CLICM_ID
          AND    ENTPM_ENTTM_ID                       = @PA_ENTTM_ID 
         ) 
         X
     LEFT OUTER JOIN
         (SELECT A.ENTDM_ENTPM_PROP_ID     ENTDM_ENTPM_ID
               , B.ENTPD_ENTP_ID           ENTPD_ENTP_ID
               , A.ENTDM_CD                ENTDM_CD
               , B.ENTPD_VALUE             ENTPD_VALUE
               , A.ENTDM_DESC              ENTDM_DESC
               , A.ENTDM_ENTPM_PROP_ID     ENTDM_ENTPM_PROP_ID
               , A.ENTDM_DATATYPE          ENTDM_DATATYPE              
          FROM   ENTPM_DTLS_MSTR A       WITH (NOLOCK)
     LEFT OUTER JOIN
                 ENTITY_PROPERTY_DTLS B  WITH (NOLOCK)
     ON (A.ENTDM_ID=B.ENTPD_ENTDM_ID)  AND ENTPD_ENTP_ID IN  (SELECT ENTP_ID FROM ENTITY_PROPERTIES  WITH (NOLOCK) WHERE ENTP_ENT_ID=@PA_CRN_NO)) Y
     ON (X.ENTPM_PROP_ID = Y.ENTDM_ENTPM_PROP_ID)
     ORDER BY X.ORD1  
                   ,X.EXCSM_EXCH_CD
                   ,X.EXCSM_SEG_CD  
                   ,X.PROM_ID  
                   ,X.ENTPM_DESC 
   --
   END
   --
   IF @PA_TAB = 'ENTP'
   BEGIN
   --
     SELECT X.ENTPM_PROP_ID       ENTPM_PROP_ID
          , X.ENTPM_CLICM_ID      ENTPM_CLICM_ID
          , X.ENTP_ID             ENTP_ID
          , X.ENTPM_ENTTM_ID      ENTPM_ENTTM_ID
          , X.ENTPM_CD            ENTPM_CD
          , X.ENTPM_DESC          ENTPM_DESC
          , X.ENTP_VALUE          ENTP_VALUE
          , ENTDM.ENTDM_CD        ENTDM_CD
          , ENTPD.ENTPD_VALUE     ENTPD_VALUE
          , ENTDM.ENTDM_DESC      ENTDM_DESC
          , X.ENTPM_MDTY          ENTPM_MDTY
          , X.ENTPM_DATATYPE      ENTPM_DATATYPE 
     FROM (SELECT DISTINCT ENTPM.ENTPM_ENTTM_ID                       ENTPM_ENTTM_ID
                , ENTPM.ENTPM_PROP_ID                                 ENTPM_PROP_ID
                , ISNULL(ENTP.ENTP_VALUE,'')                          ENTP_VALUE
                , ENTPM.ENTPM_CD                                      ENTPM_CD
                , ISNULL(ENTPM.ENTPM_DESC,'')                         ENTPM_DESC    
                , ENTPM.ENTPM_CLICM_ID                                ENTPM_CLICM_ID    
                , ENTP.ENTP_ID                                        ENTP_ID
                , ENTP.ENTP_ENT_ID                                    ENTP_ENT_ID
                , CASE ENTPM.ENTPM_MDTY WHEN 1 THEN 'M' ELSE 'N' END  ENTPM_MDTY
                , ENTPM.ENTPM_DATATYPE            ENTPM_DATATYPE 
           FROM   ENTITY_PROPERTY_MSTR   ENTPM   WITH(NOLOCK)    
           LEFT OUTER JOIN 
                  ENTITY_PROPERTIES      ENTP    WITH(NOLOCK)    
           ON     (ENTPM.ENTPM_PROP_ID = ENTP.ENTP_ENTPM_PROP_ID AND ISNULL(ENTP_ENT_ID, 0) = @PA_CRN_NO)
           WHERE  ISNULL(ENTP_DELETED_IND, 1)          = 1  
           AND    ENTPM.ENTPM_DELETED_IND              = 1    
           AND    ENTPM_CLICM_ID                       = @PA_CLICM_ID
           AND    ENTPM_ENTTM_ID                       = @PA_ENTTM_ID
           )
           X
     LEFT OUTER JOIN
           ENTPM_DTLS_MSTR ENTDM 
     ON    (X.ENTPM_PROP_ID   = ENTDM.ENTDM_ENTPM_PROP_ID AND  ISNULL(X.ENTP_ENT_ID,0) = @PA_CRN_NO)
           LEFT OUTER JOIN
     ENTITY_PROPERTY_DTLS ENTPD 
     ON    (ENTDM.ENTDM_ID = ENTPD.ENTPD_ENTDM_ID) 
     WHERE  ISNULL(ENTDM_DELETED_IND,1) = 1 AND ISNULL(ENTPD.ENTPD_DELETED_IND, 1) = 1 
     ORDER BY X.ENTPM_DESC        
   --
   END
--   
END

GO
