-- Object: PROCEDURE dbo.V2_CONTCUMBILL_HEADER_DETAIL
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE  PROC V2_CONTCUMBILL_HEADER_DETAIL(
           @STATUSID       VARCHAR(15),
           @STATUSNAME     VARCHAR(25),
           @SAUDA_DATE     VARCHAR(11),
           @SETT_NO        VARCHAR(7),
           @SETT_TYPE      VARCHAR(2),
           @FROMPARTY_CODE VARCHAR(10),
           @TOPARTY_CODE   VARCHAR(10),
           @FROMBRANCH     VARCHAR(10),
           @TOBRANCH       VARCHAR(10),
           @FROMSUB_BROKER VARCHAR(10),
           @TOSUB_BROKER   VARCHAR(10),
           @CONTFLAG       VARCHAR(10))
AS

  DECLARE  @ColName VARCHAR(6)
  
  SELECT @ColName = ''
  
  IF @CONTFLAG = 'CONTRACT'
    SELECT @ColName = RPT_CODE
    FROM   V2_CONTRACTPRINT_SETTING
    WHERE  RPT_TYPE = 'ORDER'
           AND RPT_PRINTFLAG = 1
  ELSE
    SELECT @ColName = RPT_CODE
    FROM   V2_CONTRACTPRINT_SETTING
    WHERE  RPT_TYPE = 'ORDER'
           AND RPT_PRINTFLAG_DIGI = 1
                                    
  SELECT   ORDERBYFLAG = (CASE 
                            WHEN @ColName = 'ORD_N' THEN PARTYNAME
                            WHEN @ColName = 'ORD_P' THEN M.PARTY_CODE
                            WHEN @ColName = 'ORD_BP' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(M.PARTY_CODE))
                            WHEN @ColName = 'ORD_BN' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(PARTYNAME))
                            WHEN @ColName = 'ORD_DP' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(M.PARTY_CODE))
                            WHEN @ColName = 'ORD_DN' THEN RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(PARTYNAME))
                            ELSE RTRIM(LTRIM(BRANCH_CD)) + RTRIM(LTRIM(SUB_BROKER)) + RTRIM(LTRIM(TRADER)) + RTRIM(LTRIM(M.PARTY_CODE))
                          END),
           *
  FROM     CONTRACT_MASTER M WITH (NOLOCK)
  WHERE    M.SETT_TYPE = @SETT_TYPE
           AND M.SETT_NO = @SETT_NO
           AND M.PARTY_CODE BETWEEN @FROMPARTY_CODE
                                    AND @TOPARTY_CODE
           AND BRANCH_CD BETWEEN @FROMBRANCH
                                 AND @TOBRANCH
           AND SUB_BROKER BETWEEN @FROMSUB_BROKER
                                  AND @TOSUB_BROKER
           AND @StatusName = (CASE 
                                WHEN @StatusId = 'BRANCH' THEN M.BRANCH_CD
                                WHEN @StatusId = 'SUBBROKER' THEN M.SUB_BROKER
                                WHEN @StatusId = 'Trader' THEN M.TRADER
                                WHEN @StatusId = 'Family' THEN M.FAMILY
                                WHEN @StatusId = 'Area' THEN M.AREA
                                WHEN @StatusId = 'Region' THEN M.REGION
                                WHEN @StatusId = 'Client' THEN M.PARTY_CODE
                                ELSE 'BROKER'
                              END)
           AND PRINTF <> (CASE 
                            WHEN @CONTFLAG = 'CONTRACT' THEN 1
                            ELSE 9
                          END)
  ORDER BY ORDERBYFLAG,
           BRANCH_CD,
           SUB_BROKER,
           TRADER,
           M.PARTY_CODE,
           PARTYNAME,
           M.SETT_NO,
           M.SETT_TYPE

GO
