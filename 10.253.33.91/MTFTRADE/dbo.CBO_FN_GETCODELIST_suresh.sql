-- Object: PROCEDURE dbo.CBO_FN_GETCODELIST_suresh
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------


CREATE procedure   [dbo].[CBO_FN_GETCODELIST_suresh](
                @STATUSID   VARCHAR(25),
                @STATUSNAME VARCHAR(25),
                @FROMCODE   VARCHAR(25),
                @TOCODE     VARCHAR(25),
                @SEARCHWHAT VARCHAR(20) = 'CLIENT')
                
        AS            
                
                CREATE TABLE [DBO].#CLIENTLOGIN ( 
                        [ENT_CODE]    [VARCHAR](25) NOT NULL,
                        [ENT_NAME]    [VARCHAR](100) NOT NULL,
                        [PARTY_CODE]  [VARCHAR](10) NOT NULL,
                        [PARENTCODE]  [VARCHAR](10) NOT NULL,
                        [AREA]        [VARCHAR](20) NOT NULL,
                        [REGION]      [VARCHAR](20) NOT NULL,
                        [BRANCH_CD]   [VARCHAR](10) NOT NULL,
                        [SUB_BROKER]  [VARCHAR](10) NOT NULL,
                        [TRADER]      [VARCHAR](20) NOT NULL,
                        [FAMILY]      [VARCHAR](10) NOT NULL,
                        [CL_TYPE]     [VARCHAR](10) NOT NULL,
                        [CL_STATUS]   [VARCHAR](10) NOT NULL,
                        [RELMGR]      [VARCHAR](10) NOT NULL,
                        [SBU]         [VARCHAR](10) NOT NULL,
                        [GROUPCODE]   [VARCHAR](10) NOT NULL)


BEGIN
      INSERT INTO #CLIENTLOGIN
      SELECT E.ENT_CODE, 
             E.ENT_NAME, 
             PARTY_CODE, 
             PARENTCODE = PARTY_CODE, 
             AREA, 
             REGION, 
             BRANCH_CD, 
             SUB_BROKER, 
             TRADER, 
             FAMILY, 
             CL_TYPE, 
             CL_STATUS, 
             ISNULL(REL_MGR,''), 
             ISNULL(SBU,''), 
             ISNULL(C_GROUP,'')
      FROM   MSAJAG..CLIENT_DETAILS C, 
             ABVSCITRUS.NBFC.DBO.CBO_TB_ENTITYMASTER E 
      WHERE  PARTY_CODE BETWEEN @FROMCODE AND @TOCODE
             AND E.ENT_TYPE = @SEARCHWHAT 
             AND ENT_CODE = (CASE
                               WHEN @SEARCHWHAT = 'BRANCH'     THEN C.BRANCH_CD
                               WHEN @SEARCHWHAT = 'SUBBROKER'  THEN C.SUB_BROKER
                               WHEN @SEARCHWHAT = 'TRADER'     THEN C.TRADER
                               WHEN @SEARCHWHAT = 'FAMILY'     THEN C.FAMILY
                               WHEN @SEARCHWHAT = 'AREA'       THEN C.AREA
                               WHEN @SEARCHWHAT = 'REGION'     THEN C.REGION
                               WHEN @SEARCHWHAT = 'CLIENT'     THEN C.PARTY_CODE
                               WHEN @SEARCHWHAT = 'CLTYPE'     THEN C.CL_TYPE
                               WHEN @SEARCHWHAT = 'CLSTATUS'   THEN C.CL_STATUS
                               WHEN @SEARCHWHAT = 'RELMGR'     THEN C.REL_MGR
                               WHEN @SEARCHWHAT = 'SBU'        THEN C.SBU
                               WHEN @SEARCHWHAT = 'GROUPCODE'  THEN C.C_GROUP
                               ELSE ''
                             END)
             AND @STATUSNAME = (CASE
                                  WHEN @STATUSID = 'BRANCH'    THEN C.BRANCH_CD
                                  WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER
                                  WHEN @STATUSID = 'TRADER'    THEN C.TRADER
                                  WHEN @STATUSID = 'FAMILY'    THEN C.FAMILY
                                  WHEN @STATUSID = 'AREA'      THEN C.AREA
                                  WHEN @STATUSID = 'REGION'    THEN C.REGION
                                  WHEN @STATUSID = 'CLIENT'    THEN C.PARTY_CODE
                                  ELSE 'BROKER'
                                END)


    

    END

GO
