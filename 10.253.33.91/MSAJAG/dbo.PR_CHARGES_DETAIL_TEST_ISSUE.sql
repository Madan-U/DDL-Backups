-- Object: PROCEDURE dbo.PR_CHARGES_DETAIL_TEST_ISSUE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


--SP_CURRENT_PROCESS 109


--[PR_CHARGES_DETAIL_TEST_ISSUE] '2020148','n','K142657','K142657'    

CREATE PROC [dbo].[PR_CHARGES_DETAIL_TEST_ISSUE]                       

(                    

 @F_SETT_NO VARCHAR(7),                      

 @F_SETT_TYPE VARCHAR(2),                      

 @FROM_PARTY VARCHAR(10),                      

 @TO_PARTY VARCHAR(10)                    

)                      

 AS                      

DECLARE                     

 @SETTCUR CURSOR,                    

 @PARTY_CODE VARCHAR(10),                            

 @SETT_NO VARCHAR(7),                            

 @SETT_TYPE VARCHAR(2),                            

 @SAUDA_DATE VARCHAR(11),                            

 @CONTRACTNO VARCHAR(14),                            

 @TRADE_NO VARCHAR(20),                            

 @ORDER_NO VARCHAR(16),                            

 @SCRIP_CD VARCHAR(12),                            

 @SERIES VARCHAR(3),                         

 @BUYRATE MONEY,                            

 @SELLRATE MONEY,                            

 @TRDBUYQTY INT,                            

 @TRDSELLQTY INT,                            

 @DELBUYQTY INT,                            

 @DELSELLQTY INT,                      

 @TRDBUYQTYORG INT,                            

 @TRDSELLQTYORG INT,                            

 @DELBUYQTYORG INT,                            

 @DELSELLQTYORG INT,                      

 @TRDBUY_TURNOVER MONEY,                            

 @TRDSELL_TURNOVER MONEY,                            

 @DELBUY_TURNOVER MONEY,                            

 @DELSELL_TURNOVER MONEY,                            

 @SP_COMPUTATIONLEVEL CHAR(1),                            

 @SP_COMPUTATIONON CHAR(1),                            

 @SP_COMPUTATIONTYPE CHAR(1),                       

 @SCHEMEID INT,                         

 @MIN_BROKAMT MONEY,                            

 @MAX_BROKAMT MONEY,                            

 @MIN_SCRIPAMT MONEY,                            

 @MAX_SCRIPAMT MONEY,                            

 @SP_TRD_TYPE CHAR(3)                   

DECLARE                     

 @SCHEMECUR CURSOR,                            

 @SP_COMPUTATION_LEVEL CHAR(1),                            

 @SP_MULTIPLIER MONEY,                            

 @SP_BUY_BROK_TYPE CHAR(1),                            

 @SP_SELL_BROK_TYPE CHAR(1),                            

 @SP_BUY_BROK NUMERIC (18,4),                            

 @SP_SELL_BROK NUMERIC (18,4),                            

 @SP_VALUE_FROM NUMERIC (18,4),                            

 @SP_VALUE_TO NUMERIC (18,4),                            

 @BUYFLAG INT,                            

 @SELLFLAG INT,                            

 @SP_SCHEME_TYPE INT                            

                            

DECLARE                             

 @BUY_TURNOVER MONEY,                            

 @NEWBUYTURNOVER MONEY,                            

 @NEWBUYTURNOVER_1 MONEY,                      

 @NEWBUYTURNOVERORG MONEY,                            

 @SELL_TURNOVER MONEY,                            

 @NEWSELLTURNOVER MONEY,                            

 @NEWSELLTURNOVER_1 MONEY,                            

 @NEWSELLTURNOVERORG MONEY,                            

 @BUYBROKERAGE MONEY,                            

 @SELLBROKERAGE MONEY,                      

 @BUYBROKERAGE_1 MONEY,                            

 @SELLBROKERAGE_1 MONEY,                

                

 @SEBI_LIMIT MONEY                

                    

TRUNCATE TABLE VBB_CHARGES_DETAIL_TEMP                      

TRUNCATE TABLE VBB_CHARGES_DETAIL_TEMP_1                      

TRUNCATE TABLE VBB_CHARGES_DETAIL_TEMP_2                      

TRUNCATE TABLE VBB_SETTLEMENT                      

TRUNCATE TABLE TRD_SCHEME_MAPPING                    

TRUNCATE TABLE TRD_CONTRACT_ROUNDING                     

                

SELECT @SEBI_LIMIT = 2.5   

        

                    

SET NOCOUNT ON                          

INSERT INTO VBB_SETTLEMENT SELECT SETT_NO,SETT_TYPE,SAUDA_DATE,                    

 PARTY_CODE,CONTRACTNO,TRADE_NO,ORDER_NO,SCRIP_CD,SERIES,                    

 MARKETRATE,SELL_BUY,BILLFLAG,TRADEQTY,NBROKAPP,AUCTIONPART                    

FROM                    

 HISTORY                    

WHERE                    

 SETT_NO = @F_SETT_NO AND                 

 SETT_TYPE = @F_SETT_TYPE AND                    

 PARTY_CODE BETWEEN  @FROM_PARTY AND @TO_PARTY AND                    

 TRADEQTY > 0                 

 --ORDER BY   PARTY_CODE         

            

/*

DROP INDEX [partyidx] ON [dbo].[VBB_Settlement] 



CREATE CLUSTERED INDEX [partyidx] ON [dbo].[VBB_Settlement] 

(

	[Sett_No] ASC,

	[Sett_Type] ASC,

	[Party_Code] ASC

)

*/



SELECT DISTINCT PARTY_CODE, SAUDA_DATE = CONVERT(DATETIME,LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11))                       

INTO #SETT                      

FROM VBB_SETTLEMENT                      



CREATE CLUSTERED INDEX [partyidx] ON [dbo].#SETT 

(

	[Party_Code] ASC

)

            

TRUNCATE TABLE TRD_SETT_MST                  

INSERT INTO TRD_SETT_MST                  

  SELECT *                  

  FROM   SETT_MST                  

  WHERE  SETT_NO = @F_SETT_NO AND                       

 SETT_TYPE = @F_SETT_TYPE             

              

TRUNCATE TABLE TRD_CLIENT2                

INSERT INTO TRD_CLIENT2              

SELECT CL_CODE,EXCHANGE,TRAN_CAT,SCRIP_CAT,PARTY_CODE,TABLE_NO,SUB_TABLENO,MARGIN,TURNOVER_TAX,                

SEBI_TURN_TAX,INSURANCE_CHRG,SERVICE_CHRG,STD_RATE,P_TO_P,EXPOSURE_LIM,DEMAT_TABLENO,BANKID,                

CLTDPNO,PRINTF,ALBMDELCHRG,ALBMDELIVERY,ALBMCF_TABLENO,MF_TABLENO,SB_TABLENO,BROK1_TABLENO,                

BROK2_TABLENO,BROK3_TABLENO,BROKERNOTE,OTHER_CHRG,BROK_SCHEME,CONTCHARGE,MINCONTAMT,ADDLEDGERBAL,                

DUMMY1,DUMMY2,INSCONT,SERTAXMETHOD,DUMMY6,DUMMY7,DUMMY8,DUMMY9,DUMMY10                

FROM CLIENT2                

WHERE EXISTS (SELECT PARTY_CODE FROM #SETT WHERE #SETT.PARTY_CODE = CLIENT2.PARTY_CODE)          

ORDER BY CL_CODE            

            

TRUNCATE TABLE TRD_CLIENT1            

INSERT INTO TRD_CLIENT1            

SELECT CL_CODE,SHORT_NAME,LONG_NAME,L_ADDRESS1,L_ADDRESS2,L_CITY,L_STATE,L_NATION,L_ZIP,FAX,RES_PHONE1,            

RES_PHONE2,OFF_PHONE1,OFF_PHONE2,EMAIL,BRANCH_CD,CREDIT_LIMIT,CL_TYPE,CL_STATUS,GL_CODE,FD_CODE,FAMILY,            

PENALTY,SUB_BROKER,CONFIRM_FAX,PHONEOLD,L_ADDRESS3,MOBILE_PAGER,PAN_GIR_NO,TRADER,WARD_NO,REGION,AREA,CLRATING            

FROM CLIENT1            

WHERE EXISTS (SELECT PARTY_CODE FROM #SETT WHERE #SETT.PARTY_CODE = CLIENT1.CL_CODE)         

ORDER BY CL_CODE            

                    

DECLARE @SAUDA_DATE_FROM VARCHAR(11)                    

                    

SELECT @SAUDA_DATE_FROM = MIN(SAUDA_DATE) FROM VBB_SETTLEMENT                    

                    

/* POPULATE TRD TABLES FOR BROKERAGE MAPPING AND ROUNDING */                    

                    

  INSERT INTO TRD_SCHEME_MAPPING                    

  SELECT *                    

  FROM   SCHEME_MAPPING M                    

  WHERE  SP_DATE_TO > @SAUDA_DATE_FROM                     

         AND EXISTS (SELECT DISTINCT PARTY_CODE                    

                     FROM   VBB_SETTLEMENT S                    

                     WHERE  M.SP_PARTY_CODE = S.PARTY_CODE)           

   ORDER BY   SP_PARTY_CODE               

                    

  INSERT INTO TRD_CONTRACT_ROUNDING                    

  SELECT *                    

  FROM   CONTRACT_ROUNDING M                    

  WHERE  CR_DATE_TO > @SAUDA_DATE_FROM                     

         AND EXISTS (SELECT DISTINCT PARTY_CODE                    

                     FROM   VBB_SETTLEMENT S                    

                     WHERE  M.CR_PARTY_CODE = S.PARTY_CODE)           

  ORDER BY   CR_PARTY_CODE                   

                    

/* DELETE RECORDS FROM TEMPORARY VBB SETTLEMENT TABLE FOR CLIENT WHERE VBB IS NOT DEFINED */                    

                    

  DELETE FROM VBB_SETTLEMENT                    

  WHERE       NOT EXISTS (SELECT DISTINCT PARTY_CODE                    

                          FROM   (SELECT PARTY_CODE = SP_PARTY_CODE                    

                                  FROM   TRD_SCHEME_MAPPING (nolock)                   

                                  WHERE  SAUDA_DATE BETWEEN SP_DATE_FROM AND SP_DATE_TO                    

           UNION                     

                                  SELECT PARTY_CODE = CR_PARTY_CODE                    

                                  FROM   TRD_CONTRACT_ROUNDING (nolock)                    

                                  WHERE  SAUDA_DATE BETWEEN CR_DATE_FROM AND CR_DATE_TO) A                    

                          WHERE  A.PARTY_CODE = VBB_SETTLEMENT.PARTY_CODE)                    

                    

/*------------------------------------------------------------------------------------------*/                    

INSERT INTO VBB_CHARGES_DETAIL_TEMP_1                       

SELECT                     

 PARTY_CODE,SETT_NO,SETT_TYPE,SAUDA_DATE,CONTRACTNO='0',                    

 TRADE_NO,ORDER_NO,SCRIP_CD,SERIES,                      

 BUYRATE = (CASE WHEN SUM(TRDBUY_QTY+DELBUY_QTY) > 0                       

           THEN SUM((TRDBUY_QTY+DELBUY_QTY)*BUYRATE) / SUM(TRDBUY_QTY+DELBUY_QTY)                       

    ELSE 0                      

      END),                      

 SELLRATE = (CASE WHEN SUM(TRDSELL_QTY+DELSELL_QTY) > 0                       

           THEN SUM((TRDSELL_QTY+DELSELL_QTY)*SELLRATE) / SUM(TRDSELL_QTY+DELSELL_QTY)                       

    ELSE 0                       

      END),                      

 TRDBUY_QTY=SUM(TRDBUY_QTY),                      

 TRDSELL_QTY=SUM(TRDSELL_QTY),                      

 DELBUY_QTY=SUM(DELBUY_QTY),                      

 DELSELL_QTY=SUM(DELSELL_QTY),                      

 TRDBUYBROKERAGE=(CASE WHEN SUM(RND_TRDBUY_TURNOVER) >= SUM(TRDBUY_TURNOVER) AND SUM(DELBUY_TURNOVER) > 0                       

         THEN SUM(TRDBUYBROKERAGE_1)                       

         ELSE SUM(TRDBUYBROKERAGE_1)                      

    END),                      

 TRDSELLBROKERAGE=(CASE WHEN SUM(RND_TRDSELL_TURNOVER) >= SUM(TRDSELL_TURNOVER) AND SUM(DELSELL_TURNOVER) > 0                       

         THEN SUM(TRDSELLBROKERAGE_1)                       

         ELSE SUM(TRDSELLBROKERAGE_1)                      

    END),                      

 DELBUYBROKERAGE=SUM(DELBUYBROKERAGE),                      

 DELSELLBROKERAGE=SUM(DELSELLBROKERAGE),                      

 TOTALBROKERAGE = 0,                      

 TRDBUY_TURNOVER=SUM(TRDBUY_TURNOVER),                      

 TRDSELL_TURNOVER=SUM(TRDSELL_TURNOVER),                      

 DELBUY_TURNOVER=SUM(DELBUY_TURNOVER),                      

 DELSELL_TURNOVER=SUM(DELSELL_TURNOVER),                      

 SP_COMPUTATION_LEVEL,                      

 SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT                      

FROM                     

(                      

 SELECT                     

  PARTY_CODE,SETT_NO,SETT_TYPE,SAUDA_DATE,CONTRACTNO='0',                      

  TRADE_NO = (CASE WHEN SP_COMPUTATION_LEVEL = 'T' THEN TRADE_NO ELSE '' END),                            

  ORDER_NO = (CASE WHEN SP_COMPUTATION_LEVEL IN ('T', 'O') THEN ORDER_NO ELSE '' END),                      

  SCRIP_CD = (CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SCRIP_CD ELSE '' END),                            

  SERIES = (CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SERIES ELSE '' END),                      

  BUYRATE = (CASE WHEN SUM(TRDBUY_QTY+DELBUY_QTY) > 0                       

            THEN SUM((TRDBUY_QTY+DELBUY_QTY)*MARKETRATE) / SUM(TRDBUY_QTY+DELBUY_QTY)                       

  ELSE 0                       

       END),          

  SELLRATE = (CASE WHEN SUM(TRDSELL_QTY+DELSELL_QTY) > 0                       

            THEN SUM((TRDSELL_QTY+DELSELL_QTY)*MARKETRATE) / SUM(TRDSELL_QTY+DELSELL_QTY)                       

  ELSE 0                       

       END),                        

  TRDBUY_QTY=SUM(TRDBUY_QTY),                      

  TRDSELL_QTY=SUM(TRDSELL_QTY),                      

  DELBUY_QTY=SUM(DELBUY_QTY),                      

  DELSELL_QTY=SUM(DELSELL_QTY),                      

  TRDBUY_TURNOVER=SUM(TRDBUY_TURNOVER),                      

  TRDSELL_TURNOVER=SUM(TRDSELL_TURNOVER),                      

  RND_TRDBUY_TURNOVER = PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDBUY_TURNOVER),SP_MULTIPLIER),      

  RND_TRDSELL_TURNOVER = PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDSELL_TURNOVER),SP_MULTIPLIER),                      

  DELBUY_TURNOVER=SUM(DELBUY_TURNOVER),                      

  DELSELL_TURNOVER=SUM(DELSELL_TURNOVER),                      

  TRDBUYBROKERAGE_1 = (CASE WHEN SP_SCHEME_TYPE = 0                             

                     THEN  (PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDBUY_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                

                            (CASE WHEN SP_BUY_BROK_TYPE = 'P'                             

                           THEN SP_BUY_BROK/100                             

                           ELSE SP_BUY_BROK                             

                           END))                             

             WHEN (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) >= SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 1)                             

        OR (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) > SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 3)                            

             THEN (PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDBUY_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                             

           (CASE WHEN SP_BUY_BROK_TYPE = 'P'                             

                 THEN SP_BUY_BROK/100                             

          ELSE SP_BUY_BROK                             

            END))                            

             ELSE (PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDBUY_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                             

           (CASE WHEN SP_SELL_BROK_TYPE = 'P'                             

     THEN SP_SELL_BROK/100                             

          ELSE SP_SELL_BROK                             

            END))                            

         END),                      

    TRDSELLBROKERAGE_1 = (CASE WHEN SP_SCHEME_TYPE = 0                             

             THEN  (PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDSELL_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                             

                         (CASE WHEN SP_SELL_BROK_TYPE = 'P'                             

       THEN SP_SELL_BROK/100                             

                 ELSE SP_SELL_BROK                             

                      END))                            

             WHEN (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) >= SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 1)                             

        OR (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) > SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 3)                            

             THEN (PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDSELL_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                             

           (CASE WHEN SP_SELL_BROK_TYPE = 'P'                             

                 THEN SP_SELL_BROK/100                             

          ELSE SP_SELL_BROK                             

            END))                            

             ELSE (PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDSELL_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                             

           (CASE WHEN SP_BUY_BROK_TYPE = 'P'                             

          THEN SP_BUY_BROK/100                             

          ELSE SP_BUY_BROK   

            END))                            

         END),                      

  TRDBUYBROKERAGE_2 = (CASE WHEN SUM(TRDBUY_TURNOVER) > 0 THEN (CASE WHEN SP_SCHEME_TYPE = 0                             

                     THEN  ((PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDBUY_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER-1) *                             

                            (CASE WHEN SP_BUY_BROK_TYPE = 'P'                             

                           THEN SP_BUY_BROK/100                             

                           ELSE SP_BUY_BROK                             

                           END))                             

             WHEN (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) >= SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 1)                             

        OR (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) > SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 3)                            

             THEN ((PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDBUY_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER-1) *                             

           (CASE WHEN SP_BUY_BROK_TYPE = 'P'                             

                 THEN SP_BUY_BROK/100                             

          ELSE SP_BUY_BROK                             

            END))                    

             ELSE ((PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDBUY_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER-1) *                             

           (CASE WHEN SP_SELL_BROK_TYPE = 'P'                             

          THEN SP_SELL_BROK/100                             

          ELSE SP_SELL_BROK                             

           END))                            

         END) ELSE 0 END),                      

    TRDSELLBROKERAGE_2 = (CASE WHEN SUM(TRDSELL_TURNOVER) > 0 THEN (CASE WHEN SP_SCHEME_TYPE = 0                             

             THEN  ((PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDSELL_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER-1) *                             

                         (CASE WHEN SP_SELL_BROK_TYPE = 'P'                             

                 THEN SP_SELL_BROK/100                             

                 ELSE SP_SELL_BROK                             

    END))                            

             WHEN (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) >= SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 1)                             

        OR (SUM(TRDBUY_TURNOVER+DELBUY_TURNOVER) > SUM(TRDSELL_TURNOVER+DELSELL_TURNOVER) AND SP_SCHEME_TYPE = 3)                            

     THEN ((PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDSELL_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER-1) *                             

           (CASE WHEN SP_SELL_BROK_TYPE = 'P'                             

                 THEN SP_SELL_BROK/100                           

          ELSE SP_SELL_BROK                             

            END))                            

             ELSE ((PRADNYA.DBO.ROUNDEDTURNOVER(SUM(TRDSELL_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER-1) *                             

           (CASE WHEN SP_BUY_BROK_TYPE = 'P'                             

          THEN SP_BUY_BROK/100                             

          ELSE SP_BUY_BROK                             

            END))                            

         END) ELSE 0 END),                      

  DELBUYBROKERAGE=(PRADNYA.DBO.ROUNDEDTURNOVER(SUM(DELBUY_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                             

      (CASE WHEN SP_BUY_BROK_TYPE = 'P'                             

                        THEN SP_BUY_BROK/100                             

                        ELSE SP_BUY_BROK                             

                   END)),                      

  DELSELLBROKERAGE=(PRADNYA.DBO.ROUNDEDTURNOVER(SUM(DELSELL_TURNOVER),SP_MULTIPLIER)/SP_MULTIPLIER *                             

                  (CASE WHEN SP_SELL_BROK_TYPE = 'P'        

                        THEN SP_SELL_BROK/100                             

                        ELSE SP_SELL_BROK                             

             END)),                      

  SP_COMPUTATION_LEVEL,SP_BROK_COMPUTEON,SP_BROK_COMPUTETYPE,SP_SCHEME_TYPE,SP_SCHEME_ID,SP_MULTIPLIER,                      

  SP_BUY_BROK,SP_SELL_BROK,SP_RES_MULTIPLIER,SP_RES_BUY_BROK,SP_RES_SELL_BROK,SP_VALUE_FROM,SP_VALUE_TO,                      

  SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT,SP_BUY_BROK_TYPE,SP_SELL_BROK_TYPE                      

 FROM (                      

  SELECT                         

     S.PARTY_CODE,S.SETT_NO,S.SETT_TYPE,SAUDA_DATE=LEFT(START_DATE,11), CONTRACTNO='0',                     

     TRADE_NO=PRADNYA.DBO.REPLACETRADENO(TRADE_NO),                       

     ORDER_NO, S.SCRIP_CD, S.SERIES, MARKETRATE, SELL_BUY,      

     TRDBUY_QTY = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2 THEN TRADEQTY ELSE 0 END),                            

     TRDSELL_QTY = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3 THEN TRADEQTY ELSE 0 END),                            

     DELBUY_QTY = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 4 THEN TRADEQTY ELSE 0 END),                            

     DELSELL_QTY = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 5 THEN TRADEQTY ELSE 0 END),                      

     TRDBUY_TURNOVER = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                       

        THEN CASE WHEN SP_BROK_COMPUTEON = 'T'                       

THEN TRADEQTY*MARKETRATE                       

           ELSE TRADEQTY                       

             END                       

        ELSE 0                      

                        END),                            

     TRDSELL_TURNOVER = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3                       

        THEN CASE WHEN SP_BROK_COMPUTEON = 'T'                       

           THEN TRADEQTY*MARKETRATE                       

           ELSE TRADEQTY                       

             END                       

        ELSE 0                      

                        END),                           

     DELBUY_TURNOVER = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 4                       

        THEN CASE WHEN SP_BROK_COMPUTEON = 'T'            

           THEN TRADEQTY*MARKETRATE                       

           ELSE TRADEQTY                       

             END                       

        ELSE 0                      

                        END),                      

     DELSELL_TURNOVER = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 5                       

        THEN CASE WHEN SP_BROK_COMPUTEON = 'T'                       

           THEN TRADEQTY*MARKETRATE                       

           ELSE TRADEQTY                       

             END                       

        ELSE 0                      

                        END),                        

     SP_COMPUTATION_LEVEL, SP_BROK_COMPUTEON, SP_BROK_COMPUTETYPE, SP_SCHEME_TYPE, SP_SCHEME_ID, SP_MULTIPLIER,                      

     SP_BUY_BROK,SP_SELL_BROK,SP_RES_MULTIPLIER, SP_RES_BUY_BROK,SP_RES_SELL_BROK,SP_VALUE_FROM,SP_VALUE_TO,                      

     SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT, SP_BUY_BROK_TYPE,SP_SELL_BROK_TYPE,SP_TRD_TYPE                        

   FROM VBB_SETTLEMENT S, TRD_SCHEME_MAPPING M, TRD_SETT_MST SM, TRD_CLIENT1 C1, TRD_CLIENT2 C2                      

   WHERE C1.CL_CODE = C2.CL_CODE                      

   AND C2.PARTY_CODE = S.PARTY_CODE                      

   AND C1.CL_TYPE <> 'INS'                      

   AND SAUDA_DATE BETWEEN SP_DATE_FROM AND SP_DATE_TO                            

   AND S.PARTY_CODE = SP_PARTY_CODE                      

   AND S.SETT_NO = SM.SETT_NO AND S.SETT_TYPE = SM.SETT_TYPE                      

   AND SCRIP_CD LIKE (CASE WHEN SP_SCRIP = 'ALL' THEN '%' ELSE SP_SCRIP END)                   

   AND 1 = (CASE WHEN SP_SCRIP = 'ALL' AND SCRIP_CD NOT IN                             

        (SELECT SP_SCRIP FROM TRD_SCHEME_MAPPING M                      

         WHERE SAUDA_DATE BETWEEN SP_DATE_FROM AND SP_DATE_TO                            

                       AND S.PARTY_CODE = SP_PARTY_CODE)                      

                 THEN 1                               

                 ELSE (CASE WHEN SP_SCRIP = 'ALL' THEN 0 ELSE 1 END)                      

     END)                      

            AND SP_TRD_TYPE = (CASE WHEN BILLFLAG < 4                       

               THEN 'TRD'                       

                                    ELSE 'DEL'                

                               END)                      

   AND AUCTIONPART NOT LIKE 'A%' AND AUCTIONPART NOT LIKE 'F%'                      

   AND TRADE_NO NOT LIKE '%C%'                      

   AND MARKETRATE > 0 AND TRADEQTY > 0                      

   AND SP_BROK_COMPUTETYPE = 'V'                     

  )     

  SETT_MAPPING                      

 GROUP BY                     

  PARTY_CODE,SETT_NO,SETT_TYPE,SAUDA_DATE,                      

  (CASE WHEN SP_COMPUTATION_LEVEL = 'T' THEN TRADE_NO ELSE '' END),                            

  (CASE WHEN SP_COMPUTATION_LEVEL IN ('T', 'O') THEN ORDER_NO ELSE '' END),                      

  (CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SCRIP_CD ELSE '' END),                            

  (CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SERIES ELSE '' END),                      

  SP_COMPUTATION_LEVEL,SP_BROK_COMPUTEON,SP_BROK_COMPUTETYPE,SP_SCHEME_TYPE,SP_SCHEME_ID,SP_MULTIPLIER,                      

  SP_BUY_BROK,SP_SELL_BROK,SP_RES_MULTIPLIER,SP_RES_BUY_BROK,SP_RES_SELL_BROK,SP_VALUE_FROM,SP_VALUE_TO,                      

  SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT,SP_BUY_BROK_TYPE,SP_SELL_BROK_TYPE,                     

  SP_TRD_TYPE                      

 HAVING (CASE WHEN SP_TRD_TYPE = 'TRD'                       

       THEN SUM(TRDBUY_TURNOVER+TRDSELL_TURNOVER)                      

       ELSE SUM(DELBUY_TURNOVER+DELSELL_TURNOVER)                      

  END)                      

   > SP_VALUE_FROM                         

     AND                         

        (CASE WHEN SP_TRD_TYPE = 'TRD'                       

       THEN SUM(TRDBUY_TURNOVER+TRDSELL_TURNOVER)                      

       ELSE SUM(DELBUY_TURNOVER+DELSELL_TURNOVER)                      

  END)                      

   <=   (CASE WHEN SP_VALUE_TO = -1                             

              THEN (CASE WHEN SP_TRD_TYPE = 'TRD'                       

                  THEN SUM(TRDBUY_TURNOVER+TRDSELL_TURNOVER)                      

             ELSE SUM(DELBUY_TURNOVER+DELSELL_TURNOVER)                      

             END)                      

              ELSE SP_VALUE_TO                            

         END)                      

 ) SETT_MAPPINGFINAL                      

GROUP BY                     

 PARTY_CODE,SETT_NO,SETT_TYPE,SAUDA_DATE,CONTRACTNO,TRADE_NO,ORDER_NO,SCRIP_CD,SERIES,                      

 SP_COMPUTATION_LEVEL,SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT                      
 

SET @SETTCUR = CURSOR FOR                      

SELECT PARTY_CODE,SETT_NO,SETT_TYPE,SAUDA_DATE,CONTRACTNO,                      

  TRADE_NO = (CASE WHEN SP_COMPUTATION_LEVEL = 'T' THEN TRADE_NO ELSE '' END),                            

  ORDER_NO = (CASE WHEN SP_COMPUTATION_LEVEL IN ('T', 'O') THEN ORDER_NO ELSE '' END),                      

  SCRIP_CD = (CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SCRIP_CD ELSE '' END),                            

  SERIES = (CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SERIES ELSE '' END),                      

  BUYRATE = (CASE WHEN SUM(TRDBUY_QTY+DELBUY_QTY) > 0                       

                  THEN SUM((TRDBUY_QTY+DELBUY_QTY)*MARKETRATE) / SUM(TRDBUY_QTY+DELBUY_QTY)                       

    ELSE 0                       

             END),              

  SELLRATE = (CASE WHEN SUM(TRDSELL_QTY+DELSELL_QTY) > 0                       

                  THEN SUM((TRDSELL_QTY+DELSELL_QTY)*MARKETRATE) / SUM(TRDSELL_QTY+DELSELL_QTY)                       

    ELSE 0                       

             END),                        

TRDBUY_QTY=SUM(TRDBUY_QTY),                      

TRDSELL_QTY=SUM(TRDSELL_QTY),                      

DELBUY_QTY=SUM(DELBUY_QTY),                      

DELSELL_QTY=SUM(DELSELL_QTY),                      

TRDBUY_TURNOVER=SUM(TRDBUY_TURNOVER),             

TRDSELL_TURNOVER=SUM(TRDSELL_TURNOVER),                      

DELBUY_TURNOVER=SUM(DELBUY_TURNOVER),                      

DELSELL_TURNOVER=SUM(DELSELL_TURNOVER),                      

SP_COMPUTATION_LEVEL,SP_BROK_COMPUTEON,SP_BROK_COMPUTETYPE,SP_SCHEME_ID,                      

SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT,SP_TRD_TYPE                      

FROM (                     

 SELECT                         

  S.PARTY_CODE,S.SETT_NO,S.SETT_TYPE,SAUDA_DATE=LEFT(START_DATE,11), CONTRACTNO='0',                     

  TRADE_NO=PRADNYA.DBO.REPLACETRADENO(TRADE_NO),                       

  ORDER_NO, SCRIP_CD, S.SERIES, MARKETRATE, SELL_BUY,                      

  TRDBUY_QTY = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2 THEN TRADEQTY ELSE 0 END),                            

  TRDSELL_QTY = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3 THEN TRADEQTY ELSE 0 END),                            

  DELBUY_QTY = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 4 THEN TRADEQTY ELSE 0 END),                            

  DELSELL_QTY = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 5 THEN TRADEQTY ELSE 0 END),                      

  TRDBUY_TURNOVER = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 2                       

  THEN CASE WHEN SP_BROK_COMPUTEON = 'T'                       

  THEN TRADEQTY*MARKETRATE                       

  ELSE TRADEQTY         

    END                       

  ELSE 0                      

               END),                            

  TRDSELL_TURNOVER = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 3                       

  THEN CASE WHEN SP_BROK_COMPUTEON = 'T'                       

  THEN TRADEQTY*MARKETRATE                       

  ELSE TRADEQTY                       

    END                       

  ELSE 0                      

               END),                           

  DELBUY_TURNOVER = (CASE WHEN SELL_BUY = 1 AND BILLFLAG = 4                       

  THEN CASE WHEN SP_BROK_COMPUTEON = 'T'                       

  THEN TRADEQTY*MARKETRATE                       

  ELSE TRADEQTY                       

    END                       

  ELSE 0                      

               END),                           

  DELSELL_TURNOVER = (CASE WHEN SELL_BUY = 2 AND BILLFLAG = 5                       

  THEN CASE WHEN SP_BROK_COMPUTEON = 'T'                       

  THEN TRADEQTY*MARKETRATE                       

  ELSE TRADEQTY                       

    END                       

  ELSE 0                      

               END),                        

  SP_COMPUTATION_LEVEL,SP_BROK_COMPUTEON,SP_BROK_COMPUTETYPE,SP_SCHEME_ID,                      

  SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT,SP_TRD_TYPE                      

 FROM                     

  VBB_SETTLEMENT S, TRD_SCHEME_MAPPING M, TRD_SETT_MST SM, TRD_CLIENT1 C1, TRD_CLIENT2 C2                      

 WHERE C1.CL_CODE = C2.CL_CODE                      

 AND C2.PARTY_CODE = S.PARTY_CODE                      

 AND C1.CL_TYPE <> 'INS'                      

 AND SAUDA_DATE BETWEEN SP_DATE_FROM AND SP_DATE_TO                            

 AND S.PARTY_CODE = SP_PARTY_CODE                      

 AND SCRIP_CD LIKE (CASE WHEN SP_SCRIP = 'ALL' THEN '%' ELSE SP_SCRIP END)                      

 AND 1 = (CASE WHEN SP_SCRIP = 'ALL' AND SCRIP_CD NOT IN                             

          (SELECT SP_SCRIP FROM TRD_SCHEME_MAPPING M                      

    WHERE SAUDA_DATE BETWEEN SP_DATE_FROM AND SP_DATE_TO                            

                     AND S.PARTY_CODE = SP_PARTY_CODE)                      

               THEN 1                               

               ELSE (CASE WHEN SP_SCRIP = 'ALL' THEN 0 ELSE 1 END)                      

   END)                      

          AND SP_TRD_TYPE = (CASE WHEN BILLFLAG < 4                       

             THEN 'TRD'                       

                                  ELSE 'DEL'                       

                           END)                      

 AND AUCTIONPART NOT LIKE 'A%' AND AUCTIONPART NOT LIKE 'F%'                      

 AND TRADE_NO NOT LIKE '%C%'                      

 AND S.SETT_NO = SM.SETT_NO                      

 AND S.SETT_TYPE = SM.SETT_TYPE                      

 AND MARKETRATE > 0 AND TRADEQTY > 0                      

 AND SP_BROK_COMPUTETYPE = 'I'                      

    AND SP_VALUE_FROM = (SELECT MIN(SP_VALUE_FROM) FROM                             

        TRD_SCHEME_MAPPING                      

       WHERE SP_SCHEME_ID = M.SP_SCHEME_ID)                      

)                      

SETT_MAPPING                

GROUP BY PARTY_CODE,SETT_NO,SETT_TYPE,SAUDA_DATE,CONTRACTNO,             

(CASE WHEN SP_COMPUTATION_LEVEL = 'T' THEN TRADE_NO ELSE '' END),                            

(CASE WHEN SP_COMPUTATION_LEVEL IN ('T', 'O') THEN ORDER_NO ELSE '' END),                      

(CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SCRIP_CD ELSE '' END),                            

(CASE WHEN SP_COMPUTATION_LEVEL <> 'C' THEN SERIES ELSE '' END),                      

SP_COMPUTATION_LEVEL,SP_BROK_COMPUTEON,SP_BROK_COMPUTETYPE,SP_SCHEME_ID,                      

SP_MIN_BROKAMT,SP_MAX_BROKAMT,SP_MIN_SCRIPAMT,SP_MAX_SCRIPAMT,SP_TRD_TYPE                      

                      

OPEN @SETTCUR                      

FETCH NEXT FROM @SETTCUR INTO                       

 @PARTY_CODE, @SETT_NO, @SETT_TYPE, @SAUDA_DATE, @CONTRACTNO, @TRADE_NO, @ORDER_NO, @SCRIP_CD, @SERIES, @BUYRATE,                       

 @SELLRATE, @TRDBUYQTY, @TRDSELLQTY, @DELBUYQTY, @DELSELLQTY, @TRDBUY_TURNOVER, @TRDSELL_TURNOVER, @DELBUY_TURNOVER,                       

 @DELSELL_TURNOVER, @SP_COMPUTATIONLEVEL, @SP_COMPUTATIONON, @SP_COMPUTATIONTYPE,                       

 @SCHEMEID, @MIN_BROKAMT, @MAX_BROKAMT, @MIN_SCRIPAMT, @MAX_SCRIPAMT, @SP_TRD_TYPE                      

WHILE @@FETCH_STATUS = 0                       

BEGIN                       

                      

  SET @SCHEMECUR = CURSOR FOR                            

  SELECT                            

   SP_COMPUTATION_LEVEL,                            

   SP_MULTIPLIER,                            

   SP_BUY_BROK_TYPE,                            

   SP_SELL_BROK_TYPE,                            

   SP_BUY_BROK,                            

   SP_SELL_BROK,                            

   SP_VALUE_FROM,                       

   SP_VALUE_TO,                            

   SP_SCHEME_TYPE                            

  FROM TRD_SCHEME_MAPPING                            

  WHERE                            

   @SAUDA_DATE BETWEEN SP_DATE_FROM AND SP_DATE_TO                            

   AND SP_PARTY_CODE = @PARTY_CODE                        

   AND SP_TRD_TYPE = @SP_TRD_TYPE                       

          AND SP_SCHEME_ID = @SCHEMEID                      

  ORDER BY SP_VALUE_FROM                      

                      

  OPEN @SCHEMECUR                            

  FETCH NEXT FROM                             

  @SCHEMECUR INTO @SP_COMPUTATION_LEVEL,@SP_MULTIPLIER,@SP_BUY_BROK_TYPE,@SP_SELL_BROK_TYPE,                            

  @SP_BUY_BROK,@SP_SELL_BROK,@SP_VALUE_FROM,@SP_VALUE_TO,@SP_SCHEME_TYPE                            

                       

 IF @SP_TRD_TYPE = 'TRD'                      

 BEGIN                       

 SET @NEWBUYTURNOVER  = @TRDBUY_TURNOVER                         

 SET @NEWSELLTURNOVER    = @TRDSELL_TURNOVER                       

 SET @BUY_TURNOVER = @TRDBUY_TURNOVER                         

 SET @SELL_TURNOVER = @TRDSELL_TURNOVER                      

 SET @NEWBUYTURNOVER_1   = 0                      

 SET @NEWSELLTURNOVER_1   = 0                      

 END                      

 ELSE                      

 BEGIN                      

 SET @NEWBUYTURNOVER     = @DELBUY_TURNOVER                         

 SET @NEWSELLTURNOVER    = @DELSELL_TURNOVER                          

 SET @BUY_TURNOVER = @DELBUY_TURNOVER                         

 SET @SELL_TURNOVER = @DELSELL_TURNOVER                           

 SET @NEWBUYTURNOVER_1   = 0                      

 SET @NEWSELLTURNOVER_1   = 0                      

 END                      

        SET @NEWBUYTURNOVERORG  = 0                         

        SET @NEWSELLTURNOVERORG = 0                         

        SET @BUYBROKERAGE       = 0                         

        SET @SELLBROKERAGE      = 0                            

        SET @BUYBROKERAGE_1    = 0                         

        SET @SELLBROKERAGE_1      = 0                            

                      

 WHILE @@FETCH_STATUS = 0 AND (@NEWBUYTURNOVER > 0 OR @NEWSELLTURNOVER > 0)                         

 BEGIN         

        /*--------------------------------------------------------------------*/                         

        SET @BUYBROKERAGE      = 0                         

        SET @SELLBROKERAGE     = 0                         

        SET @BUYBROKERAGE_1       = 0                         

        SET @SELLBROKERAGE_1      = 0                            

 SET @TRDBUYQTYORG = 0                      

 SET @DELBUYQTYORG = 0                      

 SET @TRDSELLQTYORG = 0                      

 SET @DELSELLQTYORG = 0                      

 IF @NEWBUYTURNOVER > 0                         

 BEGIN                         

 IF @BUY_TURNOVER >= @SP_VALUE_TO AND @SP_VALUE_TO > -1                         

 BEGIN           

         SET @NEWBUYTURNOVER    = (@SP_VALUE_TO - @SP_VALUE_FROM)/@SP_MULTIPLIER                         

         SET @NEWBUYTURNOVERORG = @NEWBUYTURNOVER * @SP_MULTIPLIER                      

  SET @TRDBUYQTYORG = 0                      

  SET @DELBUYQTYORG = 0                      

  SET @NEWBUYTURNOVER_1 = @NEWBUYTURNOVER                      

 END                         

 ELSE                         

 BEGIN                     

  SET @NEWBUYTURNOVER     = @BUY_TURNOVER - @SP_VALUE_FROM                         

  IF @NEWBUYTURNOVER < 0                          

   SET @NEWBUYTURNOVER     = 0                         

  SET @NEWBUYTURNOVERORG  = @NEWBUYTURNOVER                         

  SELECT  @NEWBUYTURNOVER = PRADNYA.DBO.ROUNDEDTURNOVER(@NEWBUYTURNOVER,@SP_MULTIPLIER)                         

  SELECT  @NEWBUYTURNOVER = @NEWBUYTURNOVER / @SP_MULTIPLIER                         

                      

  IF @SP_TRD_TYPE = 'TRD'                       

   SET @NEWBUYTURNOVER_1 = @NEWBUYTURNOVER - 1                        

  ELSE                      

   SET @NEWBUYTURNOVER_1 = @NEWBUYTURNOVER                      

                      

  SELECT  @BUYFLAG        = 1                      

  SET @TRDBUYQTYORG = @TRDBUYQTY                      

  SET @DELBUYQTYORG = @DELBUYQTY                       

 END                         

 IF @NEWBUYTURNOVER    > 0                         

 BEGIN             

  SELECT  @BUYBROKERAGE = CASE WHEN @SP_SCHEME_TYPE = 0                       

          THEN CASE WHEN @SP_BUY_BROK_TYPE ='P'                         

                                  THEN @NEWBUYTURNOVER * @SP_BUY_BROK /100                         

                                         ELSE @NEWBUYTURNOVER * @SP_BUY_BROK              

                                    END                         

                               ELSE                 

                                    CASE WHEN (@NEWBUYTURNOVER >= @NEWSELLTURNOVER AND @SP_SCHEME_TYPE = 1) OR (@NEWBUYTURNOVER   >= @NEWSELLTURNOVER AND @SP_SCHEME_TYPE =3)                         

                                  THEN CASE WHEN @SP_BUY_BROK_TYPE ='P'                       

                                     THEN @NEWBUYTURNOVER * @SP_BUY_BROK /100                       

                                                   ELSE @NEWBUYTURNOVER * @SP_BUY_BROK                       

                                END                         

                                  ELSE                       

                                CASE WHEN @SP_SELL_BROK_TYPE ='P'                         

                                                   THEN @NEWBUYTURNOVER * @SP_SELL_BROK /100                         

                                                          ELSE @NEWBUYTURNOVER * @SP_SELL_BROK                       

                                                     END                         

                                           END                         

                          END                      

  SELECT  @BUYBROKERAGE_1 = CASE WHEN @SP_SCHEME_TYPE = 0                       

          THEN CASE WHEN @SP_BUY_BROK_TYPE ='P'                         

                                  THEN @NEWBUYTURNOVER_1 * @SP_BUY_BROK /100                         

                ELSE @NEWBUYTURNOVER_1 * @SP_BUY_BROK                       

                                    END                         

                               ELSE                         

                                    CASE WHEN (@NEWBUYTURNOVER >= @NEWSELLTURNOVER AND @SP_SCHEME_TYPE = 1) OR (@NEWBUYTURNOVER   >= @NEWSELLTURNOVER AND @SP_SCHEME_TYPE =3)                         

                                  THEN CASE WHEN @SP_BUY_BROK_TYPE ='P'                       

                                     THEN @NEWBUYTURNOVER_1 * @SP_BUY_BROK /100                       

                                   ELSE @NEWBUYTURNOVER_1 * @SP_BUY_BROK                       

                                END                         

                                  ELSE                         

                                CASE WHEN @SP_SELL_BROK_TYPE ='P'                         

                                                   THEN @NEWBUYTURNOVER_1 * @SP_SELL_BROK /100                         

           ELSE @NEWBUYTURNOVER_1 * @SP_SELL_BROK                       

      END                         

                                           END                      

                          END                 

END                         

ELSE                      

BEGIN                          

 SELECT  @BUYBROKERAGE = 0    --SELECT @NEWBUYTURNOVER = 0                          

 SELECT  @BUYBROKERAGE_1 = 0                      

END                      

END                           

IF @NEWSELLTURNOVER     > 0                         

BEGIN                         

 IF @SELL_TURNOVER >= @SP_VALUE_TO AND @SP_VALUE_TO        > -1                         

 BEGIN                         

  SET @NEWSELLTURNOVER    = (@SP_VALUE_TO - @SP_VALUE_FROM)/@SP_MULTIPLIER                         

  SET @NEWSELLTURNOVERORG = @NEWSELLTURNOVER * @SP_MULTIPLIER                       

  SET @TRDSELLQTYORG = 0                      

  SET @DELSELLQTYORG = 0                      

  SET @NEWSELLTURNOVER = @NEWSELLTURNOVER                      

 END                         

 ELSE                         

 BEGIN                         

  SET @NEWSELLTURNOVER     = @SELL_TURNOVER - @SP_VALUE_FROM                         

  IF @NEWSELLTURNOVER < 0                          

   SET @NEWSELLTURNOVER     = 0                         

  SET @NEWSELLTURNOVERORG  = @NEWSELLTURNOVER                         

  SELECT  @NEWSELLTURNOVER = PRADNYA.DBO.ROUNDEDTURNOVER(@NEWSELLTURNOVER,@SP_MULTIPLIER)                         

  SELECT  @NEWSELLTURNOVER = @NEWSELLTURNOVER / @SP_MULTIPLIER                         

  SELECT  @SELLFLAG        = 1                      

  SET @TRDSELLQTYORG = @TRDSELLQTY                      

  SET @DELSELLQTYORG = @DELSELLQTY                          

  IF @SP_TRD_TYPE = 'TRD'                       

   SET @NEWSELLTURNOVER_1 = @NEWSELLTURNOVER - 1                        

  ELSE                      

   SET @NEWSELLTURNOVER = @NEWSELLTURNOVER                      

                       

 END                         

  IF @NEWSELLTURNOVER    > 0                         

  BEGIN                          

   SELECT  @SELLBROKERAGE =                         

          CASE                       

                  WHEN @SP_SCHEME_TYPE = 0                       

                  THEN                         

                  CASE                       

                          WHEN @SP_SELL_BROK_TYPE ='P'                         

                          THEN @NEWSELLTURNOVER * @SP_SELL_BROK /100                         

                          ELSE @NEWSELLTURNOVER * @SP_SELL_BROK                       

                  END                         

                  ELSE                         

                  CASE                       

                          WHEN (@NEWBUYTURNOVER >= @NEWSELLTURNOVER                       

                          AND @SP_SCHEME_TYPE    =1)                         

                          OR (@NEWBUYTURNOVER   >= @NEWSELLTURNOVER                       

                          AND @SP_SCHEME_TYPE    =3)                         

                          THEN          

                          CASE                       

                                  WHEN @SP_SELL_BROK_TYPE ='P'                         

                                  THEN @NEWSELLTURNOVER * @SP_SELL_BROK /100                                                           

          ELSE @NEWSELLTURNOVER * @SP_SELL_BROK                       

                          END                         

                          ELSE                         

                          CASE                       

                                  WHEN @SP_BUY_BROK_TYPE ='P'                         

                                  THEN @NEWSELLTURNOVER * @SP_BUY_BROK /100                         

                                  ELSE @NEWSELLTURNOVER * @SP_BUY_BROK                       

                          END                         

                  END                         

          END                        

                      

   SELECT  @SELLBROKERAGE_1 =                         

          CASE                       

                  WHEN @SP_SCHEME_TYPE = 0                       

                  THEN                         

                  CASE                       

                          WHEN @SP_SELL_BROK_TYPE ='P'                         

                          THEN @NEWSELLTURNOVER_1 * @SP_SELL_BROK /100                         

                          ELSE @NEWSELLTURNOVER_1 * @SP_SELL_BROK                       

                  END                         

                  ELSE                         

                  CASE                       

                          WHEN (@NEWBUYTURNOVER >= @NEWSELLTURNOVER                       

                          AND @SP_SCHEME_TYPE    =1)                         

                          OR (@NEWBUYTURNOVER   >= @NEWSELLTURNOVER                       

                          AND @SP_SCHEME_TYPE    =3)                         

                  THEN                         

                          CASE                       

                      WHEN @SP_SELL_BROK_TYPE ='P'                         

                                  THEN @NEWSELLTURNOVER_1 * @SP_SELL_BROK /100                         

                              ELSE @NEWSELLTURNOVER_1 * @SP_SELL_BROK                       

                          END                         

                          ELSE                         

                          CASE                       

                         WHEN @SP_BUY_BROK_TYPE ='P'                         

                                  THEN @NEWSELLTURNOVER_1 * @SP_BUY_BROK /100                         

                                  ELSE @NEWSELLTURNOVER_1 * @SP_BUY_BROK                       

                          END                         

                 END                         

          END                       

  END                         

 ELSE                         

 BEGIN                      

  SELECT  @SELLBROKERAGE = 0                      

  SELECT  @SELLBROKERAGE_1 = 0                      

 END                       

 END                           

--INSERT INTO TEMP TABLE                      
SELECT * FROM VBB_CHARGES_DETAIL_TEMP_1
IF (@NEWBUYTURNOVER > 0 OR @NEWSELLTURNOVER > 0)                      

INSERT INTO VBB_CHARGES_DETAIL_TEMP                      

SELECT @PARTY_CODE, @SETT_NO, @SETT_TYPE, @SAUDA_DATE, @CONTRACTNO, @TRADE_NO, @ORDER_NO, @SCRIP_CD, @SERIES, @BUYRATE,                       

 @SELLRATE, @TRDBUYQTYORG, @TRDSELLQTYORG, @DELBUYQTYORG, @DELSELLQTYORG,                       

 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @BUYBROKERAGE ELSE 0 END),                       

 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @SELLBROKERAGE ELSE 0 END),                       

 (CASE WHEN @SP_TRD_TYPE = 'DEL' THEN @BUYBROKERAGE ELSE 0 END),                       

 (CASE WHEN @SP_TRD_TYPE = 'DEL' THEN @SELLBROKERAGE ELSE 0 END),                      

 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @BUYBROKERAGE_1 ELSE 0 END),                       

 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @SELLBROKERAGE_1 ELSE 0 END),                       

 (CASE WHEN @SP_TRD_TYPE = 'DEL' THEN @BUYBROKERAGE_1 ELSE 0 END),                       

 (CASE WHEN @SP_TRD_TYPE = 'DEL' THEN @SELLBROKERAGE_1 ELSE 0 END),                      

  CD_TOTALBROKERAGE = 0,                      

 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @NEWBUYTURNOVERORG ELSE 0 END),                       

 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @NEWSELLTURNOVERORG ELSE 0 END),                       

 (CASE WHEN @SP_TRD_TYPE = 'DEL' THEN @NEWBUYTURNOVERORG ELSE 0 END),                       

 (CASE WHEN @SP_TRD_TYPE = 'DEL' THEN @NEWSELLTURNOVERORG ELSE 0 END),                      

 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @NEWBUYTURNOVER*@SP_MULTIPLIER ELSE 0 END),                       

 (CASE WHEN @SP_TRD_TYPE = 'TRD' THEN @NEWSELLTURNOVER*@SP_MULTIPLIER ELSE 0 END),                       

 @SP_COMPUTATIONLEVEL, @MIN_BROKAMT, @MAX_BROKAMT, @MIN_SCRIPAMT, @MAX_SCRIPAMT                      

                      

IF @SP_VALUE_TO  = -1                         

BEGIN                         

 SELECT  @NEWBUYTURNOVER  = 0                         

 SELECT  @NEWSELLTURNOVER = 0                         

END                         

/*--------------------------------------------------------------------*/                         

FETCH NEXT                       

FROM      @SCHEMECUR                      

INTO    @SP_COMPUTATION_LEVEL,                      

        @SP_MULTIPLIER,                      

        @SP_BUY_BROK_TYPE,                      

 @SP_SELL_BROK_TYPE,                         

        @SP_BUY_BROK,                      

        @SP_SELL_BROK,                      

        @SP_VALUE_FROM,                      

        @SP_VALUE_TO,                      

        @SP_SCHEME_TYPE                         

END                         

CLOSE @SCHEMECUR                         

DEALLOCATE @SCHEMECUR                         

                            

 FETCH NEXT FROM @SETTCUR INTO                       

  @PARTY_CODE, @SETT_NO, @SETT_TYPE, @SAUDA_DATE, @CONTRACTNO, @TRADE_NO, @ORDER_NO, @SCRIP_CD, @SERIES, @BUYRATE,                       

  @SELLRATE, @TRDBUYQTY, @TRDSELLQTY, @DELBUYQTY, @DELSELLQTY, @TRDBUY_TURNOVER, @TRDSELL_TURNOVER, @DELBUY_TURNOVER,                       

  @DELSELL_TURNOVER, @SP_COMPUTATIONLEVEL, @SP_COMPUTATIONON, @SP_COMPUTATIONTYPE,                      

  @SCHEMEID, @MIN_BROKAMT, @MAX_BROKAMT, @MIN_SCRIPAMT, @MAX_SCRIPAMT, @SP_TRD_TYPE                      

END                      

                      

INSERT INTO VBB_CHARGES_DETAIL_TEMP_1                      

SELECT CD_PARTY_CODE,CD_SETT_NO,CD_SETT_TYPE,CD_SAUDA_DATE,CD_CONTRACTNO,CD_TRADE_NO,CD_ORDER_NO,CD_SCRIP_CD,CD_SERIES,                      

BUYRATE = (CASE WHEN SUM(CD_TRDBUY_QTY+CD_DELBUY_QTY) > 0                       

          THEN SUM((CD_TRDBUY_QTY+CD_DELBUY_QTY)*CD_BUYRATE) / SUM(CD_TRDBUY_QTY+CD_DELBUY_QTY)                       

   ELSE 0                      

     END),                      

SELLRATE = (CASE WHEN SUM(CD_TRDSELL_QTY+CD_DELSELL_QTY) > 0                       

          THEN SUM((CD_TRDSELL_QTY+CD_DELSELL_QTY)*CD_SELLRATE) / SUM(CD_TRDSELL_QTY+CD_DELSELL_QTY)                       

   ELSE 0                       

     END),                      

TRDBUY_QTY=SUM(CD_TRDBUY_QTY),                      

TRDSELL_QTY=SUM(CD_TRDSELL_QTY),                      

DELBUY_QTY=SUM(CD_DELBUY_QTY),                      

DELSELL_QTY=SUM(CD_DELSELL_QTY),                      

TRDBUYBROKERAGE=(CASE WHEN SUM(CD_RND_TRDBUY_TURNOVER) >= SUM(CD_TRDBUY_TURNOVER) AND SUM(CD_DELBUY_TURNOVER) > 0                       

        THEN SUM(CD_TRDBUYBROKERAGE)      --SUM(CD_TRDBUYBROKERAGE_1)                       

        ELSE SUM(CD_TRDBUYBROKERAGE)                      

   END),                      

TRDSELLBROKERAGE=(CASE WHEN SUM(CD_RND_TRDSELL_TURNOVER) >= SUM(CD_TRDSELL_TURNOVER) AND SUM(CD_DELSELL_TURNOVER) > 0                       

        THEN SUM(CD_TRDSELLBROKERAGE) -- SUM(CD_TRDSELLBROKERAGE_1)                       

        ELSE SUM(CD_TRDSELLBROKERAGE)                      

   END),                      

DELBUYBROKERAGE=SUM(CD_DELBUYBROKERAGE),                      

DELSELLBROKERAGE=SUM(CD_DELSELLBROKERAGE),                      

CD_TOTALBROKERAGE = 0,                      

TRDBUY_TURNOVER=SUM(CD_TRDBUY_TURNOVER),                      

TRDSELL_TURNOVER=SUM(CD_TRDSELL_TURNOVER),                      

DELBUY_TURNOVER=SUM(CD_DELBUY_TURNOVER),                      

DELSELL_TURNOVER=SUM(CD_DELSELL_TURNOVER),                      

CD_COMPUTATION_LEVEL,                      

CD_MIN_BROKAMT,CD_MAX_BROKAMT,CD_MIN_SCRIPAMT,CD_MAX_SCRIPAMT                      

FROM VBB_CHARGES_DETAIL_TEMP                      

GROUP BY CD_PARTY_CODE,CD_SETT_NO,CD_SETT_TYPE,CD_SAUDA_DATE,                      

CD_CONTRACTNO,CD_TRADE_NO,CD_ORDER_NO,CD_SCRIP_CD,CD_SERIES,                      

CD_COMPUTATION_LEVEL,CD_MIN_BROKAMT,CD_MAX_BROKAMT,CD_MIN_SCRIPAMT,CD_MAX_SCRIPAMT                      

                     SELECT 10
       SELECT * FROM VBB_CHARGES_DETAIL_TEMP_1                 
	   

UPDATE VBB_CHARGES_DETAIL_TEMP_1 SET CD_TOTALBROKERAGE = CD_TRDBUYBROKERAGE + CD_TRDSELLBROKERAGE + CD_DELBUYBROKERAGE + CD_DELSELLBROKERAGE                      
SELECT 11
       SELECT * FROM VBB_CHARGES_DETAIL_TEMP_1

GO
