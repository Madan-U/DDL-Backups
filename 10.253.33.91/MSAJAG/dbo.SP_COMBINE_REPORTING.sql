-- Object: PROCEDURE dbo.SP_COMBINE_REPORTING
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE PROCEDURE [dbo].[SP_COMBINE_REPORTING]
(
                @STATUSID           VARCHAR(50),
                @STATUSNAME    VARCHAR(50),
                @MARGINDATE VARCHAR(11),
                @MARGINDATE_TO VARCHAR(11),
                @FROMPARTY VARCHAR(10),
                @TOPARTY            VARCHAR(10),
                @FROMBRANCH VARCHAR(15),
                @TOBRANCH VARCHAR(15),
                @LEVEL VARCHAR(1)
)
  AS
-- SP_COMBINE_REPORTING 'BROKER','BROKER','20/11/2020','20/11/2020','0','ZZZZZZZ','0','ZZZZZZZ','1'
BEGIN
                SET @TOBRANCH = (CASE WHEN @TOBRANCH = ''  OR @TOBRANCH = '%' THEN 'ZZZZZZZZZZ' ELSE @TOBRANCH END)
                SELECT  
                 @MARGINDATE = CASE WHEN LEN(@MARGINDATE) = 10 AND CHARINDEX('/', @MARGINDATE) > 0
     THEN CONVERT(VARCHAR(11), CONVERT(DATETIME, @MARGINDATE, 103), 109)
     ELSE @MARGINDATE END 

                SELECT  
                 @MARGINDATE_TO = CASE WHEN LEN(@MARGINDATE_TO) = 10 AND CHARINDEX('/', @MARGINDATE_TO) > 0
     THEN CONVERT(VARCHAR(11), CONVERT(DATETIME, @MARGINDATE_TO, 103), 109)
     ELSE @MARGINDATE_TO END 

                IF @LEVEL='1'
                
                BEGIN
                
                
                                SELECT MARGIN_DATE=MARGINDATE,PARTY_CODE=LTRIM(RTRIM(C.PARTY_CODE)),PARTY_NAME=LTRIM(RTRIM(LONG_NAME)),
                                       BRANCH_CD,SUB_BROKER,TDAY_LEDGER,TDAY_MARGIN,TDAY_MTM,TDAY_CASHCOLL,
                                                   TDAY_FDBG, MTF_ADJUST = CONVERT(NUMERIC(18,4),0),
                                                   TDAY_CASH,TDAY_NONCASH,TDAY_MARGIN_SHORT,TDAY_MTM_SHORT,T1DAY_LEDGER,T1DAY_MARGIN,
                                                   T1DAY_MTM,T1DAY_CASHCOLL,T1DAY_FDBG,T1DAY_CASH,T1DAY_NONCASH,T1DAY_MARGIN_SHORT,T1DAY_MTM_SHORT,
                                                   T2DAY_LEDGER,T2DAY_MARGIN,T2DAY_MTM,T2DAY_CASHCOLL,T2DAY_FDBG,T2DAY_CASH,T2DAY_NONCASH,T2DAY_MARGIN_SHORT,
                                                   T2DAY_MTM_SHORT,
                                                   FAMILY_AMOUNT=CONVERT(VARCHAR(400),0),
                                                   FAMILY_CODE=CONVERT(VARCHAR(400),''),
                                                   FAMILY='',
                                                   CASHMARGIN_SHORT=CONVERT(NUMERIC(18,4),0),
                                                   CASHMTOM_SHORT=CONVERT(NUMERIC(18,4),0),
                                                   FOMARGIN_SHORT=CONVERT(NUMERIC(18,4),0),
                                                   FOMTOM_SHORT=CONVERT(NUMERIC(18,4),0),
                                                   CDSMARGIN_SHORT=CONVERT(NUMERIC(18,4),0),
                                                   CDSMTOM_SHORT=CONVERT(NUMERIC(18,4),0),
                                                   MCDXMARGIN_SHORT=CONVERT(NUMERIC(18,4),0),
                                                   MCDXMTOM_SHORT=CONVERT(NUMERIC(18,4),0),
                                                   NCDXMARGIN_SHORT=CONVERT(NUMERIC(18,4),0),
                                                   NCDXMTOM_SHORT=CONVERT(NUMERIC(18,4),0),
                                                   PEAKCASHMARGIN=CONVERT(NUMERIC(18,4),0),
                                                   PEAKCASHMARGIN_SHORT=CONVERT(NUMERIC(18,4),0),
                                                   PEAKFOMARGIN=CONVERT(NUMERIC(18,4),0),
                                                   PEAKFOMARGIN_SHORT=CONVERT(NUMERIC(18,4),0),
                                                   PEAKCDSMARGIN=CONVERT(NUMERIC(18,4),0),
                                                   PEAKCDSMARGIN_SHORT=CONVERT(NUMERIC(18,4),0),
                                                   PEAKMCDXMARGIN=CONVERT(NUMERIC(18,4),0),
                                                   PEAKMCDXMARGIN_SHORT=CONVERT(NUMERIC(18,4),0),
                                                   PEAKNCDXMARGIN=CONVERT(NUMERIC(18,4),0),
                                                   PEAKNCDXMARGIN_SHORT=CONVERT(NUMERIC(18,4),0)
                                                   INTO #DATA
                                FROM TBL_COMBINE_REPORTING T, CLIENT_DETAILS C (NOLOCK) 
                                WHERE MARGINDATE BETWEEN @MARGINDATE AND @MARGINDATE_TO
                                AND T.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
                                AND C.BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH 
                                AND C.CL_CODE = T.PARTY_CODE 
                                -- AND C.CL_CODE = '556284'  
                                AND @STATUSNAME =
                (CASE
                    WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD
                    WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER
                    WHEN @STATUSID = 'TRADER' THEN C.TRADER
                    WHEN @STATUSID = 'FAMILY' THEN C.FAMILY
                    WHEN @STATUSID = 'AREA' THEN C.AREA
                    WHEN @STATUSID = 'REGION' THEN C.REGION
                    WHEN @STATUSID = 'CLIENT' THEN C.CL_CODE
                ELSE
                    'BROKER'
                END)

UPDATE #DATA SET  FOMARGIN_SHORT = PRADNYA.DBO.FNMIN(D.FOMARGIN_SHORT,0),
                  FOMTOM_SHORT = PRADNYA.DBO.FNMIN(D.FOMTOM_SHORT,0),
                                                                  CDSMARGIN_SHORT = PRADNYA.DBO.FNMIN(D.CDSMARGIN_SHORT,0),
                  CDSMTOM_SHORT = PRADNYA.DBO.FNMIN(D.CDSMTOM_SHORT,0),
                                                                  CASHMARGIN_SHORT = PRADNYA.DBO.FNMIN(D.CASHMARGIN_SHORT,0),
                  CASHMTOM_SHORT = PRADNYA.DBO.FNMIN(D.CASHMTOM_SHORT,0),
                                                                  MCDXMARGIN_SHORT = PRADNYA.DBO.FNMIN(D.MCDXMARGIN_SHORT,0),
                                                                  MCDXMTOM_SHORT = PRADNYA.DBO.FNMIN(D.MCDXMTOM_SHORT,0),
                                                                  NCDXMARGIN_SHORT = 0,
                                                                  NCDXMTOM_SHORT = PRADNYA.DBO.FNMIN(D.NCDXMTOM_SHORT,0),
                                                                  TDAY_NONCASH = TDAY_NONCASH - D.MTF_ADJUST,
                                                                  MTF_ADJUST = D.MTF_ADJUST

FROM (
SELECT    PARTY_CODE, MARGINDATE, 
                                                                  MTF_ADJUST = SUM(CASE WHEN   EXCHANGE='MTF' AND SEGMENT='MTF' THEN  TDAY_NONCASH  ELSE 0 END),
                                                                  FOMARGIN_SHORT = SUM(CASE WHEN   EXCHANGE='NSE' AND SEGMENT='FUTURES' THEN  T_MARGINAVL  ELSE 0 END) ,
                  FOMTOM_SHORT =  SUM(CASE WHEN   EXCHANGE='NSE' AND SEGMENT='FUTURES' THEN  T_MTMAVL ELSE 0 END) ,
                                                                  CDSMARGIN_SHORT = SUM(CASE WHEN   EXCHANGE='NSX' AND SEGMENT='FUTURES' THEN  T_MARGINAVL  ELSE 0 END) ,
                  CDSMTOM_SHORT =  SUM(CASE WHEN   EXCHANGE='NSX' AND SEGMENT='FUTURES' THEN  T_MTMAVL ELSE 0 END) ,
                                                                  CASHMARGIN_SHORT = SUM(CASE WHEN   EXCHANGE='NSE' AND SEGMENT='CAPITAL' THEN  T_MARGINAVL  ELSE 0 END) ,
                  CASHMTOM_SHORT =  SUM(CASE WHEN   EXCHANGE='NSE' AND SEGMENT='CAPITAL' THEN  T_MTMAVL ELSE 0 END),                
                                                                  MCDXMARGIN_SHORT = SUM(CASE WHEN   EXCHANGE='MCX' AND SEGMENT='FUTURES' THEN  T_MARGINAVL  ELSE 0 END) ,
                  MCDXMTOM_SHORT =  0 ,
                  NCDXMTOM_SHORT =  0                                                                                                                                                                                                                                                                                                                                                                             
FROM TBL_COMBINE_REPORTING_DETAIL  
WHERE MARGINDATE BETWEEN @MARGINDATE AND @MARGINDATE_TO
                                AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY --- AND PARTY_CODE = '556284' 
                                GROUP BY PARTY_CODE, MARGINDATE  ) D
WHERE  #DATA.MARGIN_DATE = D.MARGINDATE
AND   #DATA.PARTY_CODE = D.PARTY_CODE


UPDATE #DATA SET  PEAKCASHMARGIN = PRADNYA.DBO.FNMAX(D.PEAKCASHMARGIN,0),
                  PEAKCASHMARGIN_SHORT = PRADNYA.DBO.FNMIN(D.PEAKCASHMARGIN_SHORT,0),
                                                                  PEAKFOMARGIN = PRADNYA.DBO.FNMAX(D.PEAKFOMARGIN,0),
                  PEAKFOMARGIN_SHORT = PRADNYA.DBO.FNMIN(D.PEAKFOMARGIN_SHORT,0),
                                                                  PEAKCDSMARGIN = PRADNYA.DBO.FNMAX(D.PEAKCDSMARGIN,0),
                  PEAKCDSMARGIN_SHORT = PRADNYA.DBO.FNMIN(D.PEAKCDSMARGIN_SHORT,0),
                                                                  PEAKMCDXMARGIN = PRADNYA.DBO.FNMAX(D.PEAKMCDXMARGIN,0),
                                                                  PEAKMCDXMARGIN_SHORT = PRADNYA.DBO.FNMIN(D.PEAKMCDXMARGIN_SHORT,0),
                                                                  PEAKNCDXMARGIN = PRADNYA.DBO.FNMAX(D.PEAKNCDXMARGIN,0),
                                                                  PEAKNCDXMARGIN_SHORT = PRADNYA.DBO.FNMIN(D.PEAKNCDXMARGIN_SHORT,0)

FROM (
SELECT    PARTY_CODE, MARGINDATE, 
                                                                  PEAKFOMARGIN_SHORT = SUM(CASE WHEN   EXCHANGE='NSE' AND SEGMENT='FUTURES' THEN  T_MARGINAVL  ELSE 0 END) ,
                  PEAKFOMARGIN =  SUM(CASE WHEN   EXCHANGE='NSE' AND SEGMENT='FUTURES' THEN  TDAY_MARGIN ELSE 0 END) ,
                                                                  PEAKCDSMARGIN_SHORT = SUM(CASE WHEN   EXCHANGE='NSX' AND SEGMENT='FUTURES' THEN  T_MARGINAVL  ELSE 0 END) ,
                  PEAKCDSMARGIN =  SUM(CASE WHEN   EXCHANGE='NSX' AND SEGMENT='FUTURES' THEN  TDAY_MARGIN ELSE 0 END) ,
                                                                  PEAKCASHMARGIN_SHORT = SUM(CASE WHEN   EXCHANGE='NSE' AND SEGMENT='CAPITAL' THEN  T_MARGINAVL  ELSE 0 END) ,
                  PEAKCASHMARGIN =  SUM(CASE WHEN   EXCHANGE='NSE' AND SEGMENT='CAPITAL' THEN  TDAY_MARGIN ELSE 0 END),                
                                                                  PEAKMCDXMARGIN_SHORT = SUM(CASE WHEN   EXCHANGE='MCX' AND SEGMENT='FUTURES' THEN  T_MARGINAVL  ELSE 0 END) ,
                  PEAKMCDXMARGIN =  SUM(CASE WHEN   EXCHANGE='MCX' AND SEGMENT='FUTURES' THEN TDAY_MARGIN ELSE 0 END)       ,
                                                                  PEAKNCDXMARGIN_SHORT = SUM(CASE WHEN   EXCHANGE='NCX' AND SEGMENT='FUTURES' THEN  T_MARGINAVL  ELSE 0 END) ,
                  PEAKNCDXMARGIN =  SUM(CASE WHEN   EXCHANGE='NCX' AND SEGMENT='FUTURES'  THEN TDAY_MARGIN ELSE 0 END)       
FROM TBL_COMBINE_REPORTING_PEAK_DETAIL  
WHERE MARGINDATE BETWEEN @MARGINDATE AND @MARGINDATE_TO
                                AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY --- AND PARTY_CODE = '556284' 
                                GROUP BY PARTY_CODE, MARGINDATE  ) D
WHERE  #DATA.MARGIN_DATE = D.MARGINDATE
AND   #DATA.PARTY_CODE = D.PARTY_CODE

                                --SELECT SUM(PEAKCASHMARGIN),SUM(PEAKFOMARGIN),SUM(PEAKCDSMARGIN),SUM(PEAKMCDXMARGIN),SUM(PEAKNCDXMARGIN) FROM #DATA 
                                --SELECT * INTO BAK_PEAK FROM #DATA ORDER BY PARTY_CODE,BRANCH_CD,MARGIN_DATE,FAMILY
                                SELECT * FROM #DATA ORDER BY PARTY_CODE,BRANCH_CD,MARGIN_DATE,FAMILY
                END
                IF @LEVEL='2'
                BEGIN
                               
                
                                SELECT EXCHANGE, SEGMENT,MARGINDATE,C.PARTY_CODE,PARTY_NAME=LONG_NAME,BRANCH_CD,SUB_BROKER,TDAY_LEDGER,TDAY_MARGIN,TDAY_MTM,
                                                   TDAY_CASHCOLL,TDAY_FDBG,TDAY_NONCASH,TDAY_MARGIN_SHORT=T_MARGINAVL+ 0,TDAY_MTM_SHORT=T_MTMAVL,
                                                   T1DAY_LEDGER,T1DAY_MARGIN,T1DAY_MTM,T1DAY_CASHCOLL,T1DAY_FDBG,T1DAY_NONCASH,
                                                   T1DAY_MARGIN_SHORT,T1DAY_MTM_SHORT,T2DAY_LEDGER,T2DAY_MARGIN,T2DAY_MTM,T2DAY_CASHCOLL,
                                                   T2DAY_FDBG,T2DAY_NONCASH,T2DAY_MARGIN_SHORT,T2DAY_MTM_SHORT,
                                                   PEAKMARGIN=CONVERT(NUMERIC(18,4),0),PEAKMARGIN_SHORT=CONVERT(NUMERIC(18,4),0)
                                                   iNTO #DATADET
                                FROM TBL_COMBINE_REPORTING_DETAIL T, CLIENT_DETAILS C (NOLOCK) 
                                WHERE MARGINDATE BETWEEN @MARGINDATE AND @MARGINDATE_TO
                                AND T.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
                                AND C.BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH 
                                AND C.CL_CODE = T.PARTY_CODE                   
                                AND T.PARTY_CODE IN (SELECT PARTY_CODE FROM TBL_COMBINE_REPORTING 
                                WHERE MARGINDATE BETWEEN @MARGINDATE AND @MARGINDATE_TO  )
                                AND @STATUSNAME =
                (CASE
                    WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD
                    WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER
                    WHEN @STATUSID = 'TRADER' THEN C.TRADER
                    WHEN @STATUSID = 'FAMILY' THEN C.FAMILY
                    WHEN @STATUSID = 'AREA' THEN C.AREA
                    WHEN @STATUSID = 'REGION' THEN C.REGION
                    WHEN @STATUSID = 'CLIENT' THEN C.CL_CODE
                ELSE
                    'BROKER'
                END)

                                UPDATE #DATADET SET PEAKMARGIN = D.TDAY_MARGIN, PEAKMARGIN_SHORT=D.T_MARGINAVL
                                FROM TBL_COMBINE_REPORTING_PEAK_DETAIL D
                                WHERE D.MARGINDATE BETWEEN @MARGINDATE AND @MARGINDATE_TO 
                                AND #DATADET.MARGINDATE = D.MARGINDATE
                                AND #DATADET.PARTY_CODE = D.PARTY_CODE
                                AND #DATADET.EXCHANGE = D.EXCHANGE
                                AND #DATADET.SEGMENT  = D.SEGMENT 

                                SELECT * FROM #DATADET
                                ORDER BY exchange, segment,PARTY_CODE,BRANCH_CD,MARGINDATE
                END
                IF @LEVEL='3'
                BEGIN
                                
                                SELECT    POOLHOLD=(CASE WHEN BANK_CODE='1' THEN'Y'ELSE'N'END),C.PARTY_CODE,PARTY_NAME=LONG_NAME,BRANCH_CD,SUB_BROKER,COLL_TYPE,SCRIP_CD,SERIES,ISIN,QTY,FD_TYPE,FD_BG_NO,CL_RATE=CONVERT(NUMERIC(18,4),MRG_CL_RATE),
                                                                  VAR_HAIRCUT=CONVERT(NUMERIC(18,4),MRG_VAR_MARGIN),AMOUNTAFTERVAR=CONVERT(NUMERIC(18,4),MRG_FINALAMOUNT) 
                                FROM V2_TBL_COLLATERAL_MARGIN_COMBINE T, CLIENT_DETAILS C (NOLOCK) 
                                WHERE EFFDATE BETWEEN @MARGINDATE AND @MARGINDATE_TO
                                AND T.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
                                AND C.BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH 
                                AND C.CL_CODE = T.PARTY_CODE   
                                AND T.PARTY_CODE IN (SELECT PARTY_CODE FROM TBL_COMBINE_REPORTING T 
                                WHERE MARGINDATE BETWEEN @MARGINDATE AND @MARGINDATE_TO   )                    
                                AND @STATUSNAME =
                (CASE
                    WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD
                    WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER
                    WHEN @STATUSID = 'TRADER' THEN C.TRADER
                    WHEN @STATUSID = 'FAMILY' THEN C.FAMILY
                    WHEN @STATUSID = 'AREA' THEN C.AREA
                    WHEN @STATUSID = 'REGION' THEN C.REGION
                    WHEN @STATUSID = 'CLIENT' THEN C.CL_CODE
                ELSE
                    'BROKER'
                END)
                                                ORDER BY C.PARTY_CODE,EXCHANGE,SEGMENT,COLL_TYPE,SCRIP_CD,SERIES
                END
END

GO
