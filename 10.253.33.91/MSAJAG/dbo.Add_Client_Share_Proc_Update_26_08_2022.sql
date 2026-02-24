-- Object: PROCEDURE dbo.Add_Client_Share_Proc_Update_26_08_2022
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



  

          
Create PROC [dbo].[Add_Client_Share_Proc_Update_26_08_2022] (                        

@EXCHANGE VARCHAR(3),                         

@SEGMENT VARCHAR(7),                         

@BRANCH_CD VARCHAR(10),                         

@FROMPARTY VARCHAR(10),                        

@TOPARTY VARCHAR(10),                        

@MAINDATE VARCHAR(30),                        

@DETDATE VARCHAR(30)                        

) 

AS                        

/*                        

STATUS = 'U', IMP_STATUS = '0' -- FOR FRESH INSERT                        

IF IMP_STATUS = '0' THEN --DON'T UPDATE STATUS FEILD                        

ELSE --UPDATE STATUS FEILD AS 'U'AND IMP_STATUS AS '0'                        

*/                        

                        

TRUNCATE TABLE CLIENT_DETAILS_TMP                        

TRUNCATE TABLE CLIENT_BROK_DETAILS_TMP                        

    /*                    

INSERT INTO CLIENT_DETAILS_TMP                        

SELECT C.*                         

       FROM MSAJAG.DBO.CLIENT_DETAILS C With(Nolock), MSAJAG.DBO.CLIENT_BROK_DETAILS D      With(Nolock)                  

       WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

       AND C.CL_CODE = D.CL_CODE                        

       AND (C.IMP_STATUS = '0' OR D.IMP_STATUS = '0')                         

       AND C.BRANCH_CD LIKE @BRANCH_CD                        

       AND C.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                         

       AND C.MODIFIDEDON <= @MAINDATE AND D.MODIFIEDON <= @DETDATE                        

                        

INSERT INTO CLIENT_BROK_DETAILS_TMP                        

SELECT D.*                         

       FROM MSAJAG.DBO.CLIENT_DETAILS C With(Nolock), MSAJAG.DBO.CLIENT_BROK_DETAILS D   With(Nolock)                     

       WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

       AND C.CL_CODE = D.CL_CODE                        

       AND (C.IMP_STATUS = '0' OR D.IMP_STATUS = '0')                         

       AND C.BRANCH_CD LIKE @BRANCH_CD                        

       AND C.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                         

       AND C.MODIFIDEDON <= @MAINDATE AND D.MODIFIEDON <= @DETDATE      */


	   SELECT C.CL_CODE INTO #CLT_ADD                        
       FROM MSAJAG.DBO.CLIENT_DETAILS C WITH(NOLOCK), MSAJAG.DBO.CLIENT_BROK_DETAILS D      WITH(NOLOCK)                  
       WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          
       AND C.CL_CODE = D.CL_CODE                        
       AND (C.IMP_STATUS = '0' OR D.IMP_STATUS = '0')                        
		AND C.BRANCH_CD LIKE @BRANCH_CD                        
       AND C.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                        
       AND C.MODIFIDEDON <= @MAINDATE AND D.MODIFIEDON <= @DETDATE

		INSERT INTO CLIENT_DETAILS_TMP                        
		SELECT C.*                        
			   FROM MSAJAG.DBO.CLIENT_DETAILS C WITH(NOLOCK)
			   INNER JOIN  #CLT_ADD D      WITH(NOLOCK)                  
			   ON C.CL_CODE = D.CL_CODE                        
              

	INSERT INTO CLIENT_BROK_DETAILS_TMP                        
	SELECT D.*                        
		   FROM #CLT_ADD C WITH(NOLOCK)
		   INNER JOIN  MSAJAG.DBO.CLIENT_BROK_DETAILS D   WITH(NOLOCK)     ON C.CL_CODE = D.CL_CODE               
		   WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT           




           

--       CREATE NONCLUSTERED INDEX [cl_inx] ON [dbo].[CLIENT_DETAILS_TMP]     

--(    

-- [Cl_Code] ASC    

     

-- )    

     

    

--CREATE NONCLUSTERED INDEX [cl_inx] ON [dbo].[CLIENT_BROK_DETAILS_TMP]     

--(    

-- [Cl_Code] ASC    

     

--)                       

                        

DELETE FROM CLIENT1 WHERE CL_CODE IN ( SELECT C.CL_CODE                         

       FROM CLIENT_DETAILS_TMP C , CLIENT_BROK_DETAILS_TMP D                      

       WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

       AND C.CL_CODE = D.CL_CODE)                        

                        

/* CLIENT1 INSERT QUERY */                        

INSERT INTO CLIENT1                        

SELECT C.CL_CODE,SHORT_NAME,LONG_NAME,L_ADDRESS1,L_ADDRESS2,L_CITY,L_STATE,L_NATION,L_ZIP,FAX,RES_PHONE1,                        

RES_PHONE2,OFF_PHONE1,OFF_PHONE2,EMAIL,BRANCH_CD,CREDIT_LIMIT,CL_TYPE,CL_STATUS,GL_CODE='',FD_CODE='',FAMILY,                        

PENALTY=0,SUB_BROKER,CONFIRM_FAX=0,PHONEOLD='',L_ADDRESS3,MOBILE_PAGER,PAN_GIR_NO,TRADER,WARD_NO,REGION,AREA,CLRATING=''                        

FROM CLIENT_DETAILS_TMP C  (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                       

WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

AND C.CL_CODE = D.CL_CODE                         

                        

DELETE FROM CLIENT2 WHERE PARTY_CODE IN ( SELECT PARTY_CODE                         

       FROM CLIENT_DETAILS_TMP C , CLIENT_BROK_DETAILS_TMP D                       

       WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

       AND C.CL_CODE = D.CL_CODE )                        

                 

/* CLIENT2 INSERT QUERY */                        

INSERT INTO CLIENT2                        

SELECT C.CL_CODE,D.EXCHANGE,TRAN_CAT='TRD',SCRIP_CAT=0,PARTY_CODE=C.CL_CODE,TRD_BROK,DEL_BROK,MARGIN=0,                        

TURNOVER_TAX=FUT_TRAN_CHRGS,                        

SEBI_TURN_TAX=FUT_SEBI_FEES,                        

INSURANCE_CHRG=FUT_STT,                        

SER_TAX,STD_RATE=FUT_BROK,P_TO_P=0,                        

EXPOSURE_LIM=0,DEMAT_TABLENO=DEL_BROK,BANKID=PARTICIPANT_CODE,CLTDPNO=CUSTODIAN_CODE,PRINTF=PRINT_OPTIONS,                        

ALBMDELCHRG=0,ALBMDELIVERY=0,ALBMCF_TABLENO=0,MF_TABLENO=DEL_BROK,SB_TABLENO=0,                    

BROK1_TABLENO=FUT_FUT_FIN_BROK,BROK2_TABLENO=FUT_OPT_BROK,BROK3_TABLENO=0,                        

BROKERNOTE=FUT_STAMP_DUTY,                        

OTHER_CHRG=FUT_OTHER_CHRGS,                        

D.BROK_SCHEME,CONTCHARGE=0,MINCONTAMT=0,ADDLEDGERBAL=0,DUMMY1=FUT_BROK_APPLICABLE,           

DUMMY2=FUT_OPT_BROK,INSCONT=(CASE WHEN INST_CONTRACT = '' OR INST_CONTRACT IS NULL THEN 'N' ELSE INST_CONTRACT END),          

SERTAXMETHOD=SER_TAX_METHOD,DUMMY6=STP_PROVIDER,                     

DUMMY7=STP_RP_STYLE,DUMMY8=REL_MGR,DUMMY9=C_GROUP,DUMMY10=SBU, PARENTCODE, PRODUCTCODE                

FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D   (NOLOCK)                      

WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

AND C.CL_CODE = D.CL_CODE                         

                        

DELETE FROM CLIENT3 WHERE PARTY_CODE IN ( SELECT PARTY_CODE                         

       FROM CLIENT_DETAILS_TMP C , CLIENT_BROK_DETAILS_TMP D                    

       WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

       AND C.CL_CODE = D.CL_CODE)                        

                        

/* CLIENT3 INSERT QUERY */                        

INSERT INTO CLIENT3                        

SELECT C.CL_CODE,C.PARTY_CODE,EXCHANGE,MARKETTYPE=SEGMENT,MARGIN=0,NOOFTIMES=MULTIPLIER,MARGIN_RECD=CHARGED,MTOM=0,                        

PMARGINRATE=0,MTOMDATE=GETDATE(),INITIALMARGIN=0,MAINENANCETMARGIN=MAINTENANCE,MARGINEXCHANGE=REQD_BY_EXCH,MARGINBROKER=0,                        

DUMMY1=0,DUMMY2=0                        

FROM CLIENT_DETAILS_TMP C (NOLOCK) , CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

AND C.CL_CODE = D.CL_CODE                         

                      

                        

INSERT INTO CLIENT4                        

SELECT C.CL_CODE,PARTY_CODE,INSTRU=0,BANKID=DPID1,CLTDPID1,DEPOSITORY1,DEF=1                         

FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

AND C.CL_CODE = D.CL_CODE                         

AND DPID1 <> '' AND CLTDPID1 <> ''                         

AND DEPOSITORY1 IN ('NSDL', 'CDSL')                         

AND C.PARTY_CODE NOT IN (SELECT PARTY_CODE FROM CLIENT4 WHERE DEPOSITORY IN ('NSDL', 'CDSL') )                        

                        

INSERT INTO MULTICLTID                        

SELECT PARTY_CODE, CLTDPID1, DPID1, LONG_NAME, DEPOSITORY1, POA1                         

FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

AND C.CL_CODE = D.CL_CODE                         

AND DPID1 <> '' AND CLTDPID1 <> ''                         

AND DEPOSITORY1 IN ('NSDL', 'CDSL')                        

AND C.PARTY_CODE NOT IN (SELECT PARTY_CODE FROM MULTICLTID WHERE DPID = DPID1 AND CLTDPNO = CLTDPID1)                        

                        

/* MULTICLTID INSERT QUERY */                        

INSERT INTO MULTICLTID                        

SELECT PARTY_CODE, CLTDPID2, DPID2, LONG_NAME, DEPOSITORY2, POA2                         

FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT         

AND C.CL_CODE = D.CL_CODE                         

AND DPID2 <> '' AND CLTDPID2 <> ''                        

AND DEPOSITORY2 IN ('NSDL', 'CDSL')                        

AND C.PARTY_CODE NOT IN (SELECT PARTY_CODE FROM MULTICLTID WHERE DPID = DPID2 AND CLTDPNO = CLTDPID2)                   

                        

/* MULTICLTID INSERT QUERY */                        

INSERT INTO MULTICLTID                        

SELECT PARTY_CODE, CLTDPID3, DPID3, LONG_NAME, DEPOSITORY3, POA3                         

FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

AND C.CL_CODE = D.CL_CODE                         

AND DPID3 <> '' AND CLTDPID3 <> ''                        

AND DEPOSITORY3 IN ('NSDL', 'CDSL')                        

AND C.PARTY_CODE NOT IN (SELECT PARTY_CODE FROM MULTICLTID WHERE DPID = DPID3 AND CLTDPNO = CLTDPID3)                        

                        

DELETE FROM CLIENT4 WHERE CL_CODE IN ( SELECT C.CL_CODE                         

       FROM CLIENT_DETAILS_TMP C , CLIENT_BROK_DETAILS_TMP D                       

       WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

       AND C.CL_CODE = D.CL_CODE )                        

       AND DEPOSITORY NOT IN ('NSDL', 'CDSL')                        

       

       

   SELECT DISTINCT BANK_NAME,Branch_Name into  #POBANK FROM POBANK     

       

   CREATE NONCLUSTERED INDEX [cl_inx] ON [dbo].[#POBANK]     

(    

 [BANK_NAME] ASC    

     

)                        

    

    

INSERT INTO POBANK (BANK_NAME,BRANCH_NAME)                        

SELECT DISTINCT BANK_NAME, BRANCH_NAME  =left(BRANCH_NAME,40)                      

       FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

       WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

       AND C.CL_CODE = D.CL_CODE                        

       AND BANK_NAME NOT IN (SELECT BANK_NAME FROM #POBANK WHERE #POBANK.BANK_NAME = C.BANK_NAME AND #POBANK.BRANCH_NAME = C.BRANCH_NAME )        

             

     

   SELECT PARTY_CODE into #CLIENT4 FROM CLIENT4 WHERE DEPOSITORY NOT IN ('CDSL','NSDL')       

       

      CREATE NONCLUSTERED INDEX [cl_inx] ON [dbo].[#CLIENT4]     

(    

 [PARTY_CODE] ASC    

     

)                        

                        

/* CLIENT4 INSERT QUERY */    

INSERT INTO CLIENT4                         

SELECT C.CL_CODE,PARTY_CODE,INSTRU=1,BANKID=MAX(P.BANKID),CLTDPID=AC_NUM,                        

DEPOSITORY=ISNULL((CASE WHEN AC_TYPE = 'S' THEN 'SAVING'                         

                        WHEN AC_TYPE = 'C' THEN 'CURRENT'                         

                        ELSE 'OTHER' END), 'OTHER'),          DEF=0                    

FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK), POBANK P                        

WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

AND C.CL_CODE = D.CL_CODE                        

AND AC_TYPE <> ''                        

AND C.PARTY_CODE NOT IN (SELECT PARTY_CODE FROM #CLIENT4)      

AND P.BANK_NAME = C.BANK_NAME AND P.BRANCH_NAME = C.BRANCH_NAME            

GROUP BY C.CL_CODE,PARTY_CODE,AC_NUM,AC_TYPE--  ADD BY SURESH TO ADD DISTICNT RECORDS FROM POBANK  MAX(P.BANKID)                       

      

      

      

      

                         

DELETE FROM CLIENT5 WHERE CL_CODE IN ( SELECT C.CL_CODE                         

       FROM CLIENT_DETAILS_TMP C , CLIENT_BROK_DETAILS_TMP D                    

       WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT            

       AND C.CL_CODE = D.CL_CODE)                        

                        

/* CLIENT5 INSERT QUERY */                        

INSERT INTO CLIENT5                        

SELECT C.CL_CODE,BIRTHDATE=DOB,SEX,ACTIVEFROM=ACTIVE_DATE,INTERACTMODE,                        

REPATRIATAC=(CASE WHEN LEN(REPATRIAT_BANK) = 0 THEN 1 ELSE 0 END),                        

REPATRIATBANK=REPATRIAT_BANK,REPATRIATACNO=REPATRIAT_BANK_AC_NO,                        

INTRODUCER,APPROVER,KYCFORM=CHK_KYC_FORM,BANKCERT=CHK_BANK_CERTIFICATE,                        

PASSPORT=(CASE WHEN PASSPORT_NO <> '' THEN 1 ELSE 0 END), PASSPORTDTL=PASSPORT_NO,                        

VOTERSID=(CASE WHEN VOTERSID_NO <> '' THEN 1 ELSE 0 END), VOTERSIDDTL = VOTERSID_NO,                        

ITRETURN=(CASE WHEN IT_RETURN_YR <> '' THEN 1 ELSE 0 END), ITRETURNDTL=IT_RETURN_YR,                        

DRIVELICEN=(CASE WHEN LICENCE_NO <> '' THEN 1 ELSE 0 END), DRIVELICENDTL = LICENCE_NO,                        

RATIONCARD=(CASE WHEN RAT_CARD_NO <> '' THEN 1 ELSE 0 END), RATIONCARDDTL = RAT_CARD_NO,                        

CORPDTLRECD=CHK_CORPORATE_DEED,CORPDEED=CHK_CORP_DTLS_RECD,                        

ANUALREPORT=CHK_ANNUAL_REPORT,NETWORTHCERT=CHK_NETWORTH_CERT,INACTIVEFROM=INACTIVE_FROM,                        

P_ADDRESS1,P_ADDRESS2,P_ADDRESS3,P_CITY,P_STATE,P_NATION,P_PHONE,P_ZIP,ADDEMAILID,                        

PASSPORTDATEOFISSUE=PASSPORT_ISSUED_ON,PASSPORTPLACEOFISSUE=PASSPORT_ISSUED_AT,             

VOTERIDDATEOFISSUE=VOTERSID_ISSUED_ON,VOTERIDPLACEOFISSUE=VOTERSID_ISSUED_AT,                        

ITRETURNDATEOFFILING=IT_RETURN_FILED_ON,LICENCENODATEOFISSUE=LICENCE_ISSUED_ON,                        

LICENCENOPLACEOFISSUE=LICENCE_ISSUED_AT,RATIONCARDDATEOFISSUE=RAT_CARD_ISSUED_ON,                        

RATIONCARDPLACEOFISSUE=RAT_CARD_ISSUED_AT,CLIENT_AGRE_DT=CLIENT_AGREEMENT_ON,REGR_NO=REGR_NO,                        

REGR_PLACE=REGR_AT,REGR_DATE=REGR_ON,REGR_AUTH=REGR_AUTHORITY,INTROD_CLIENT_ID=INTRODUCER_ID,                        

INTROD_RELATION=INTRODUCER_RELATION,                      

ANY_OTHER_ACC=OTHER_AC_NO,SETT_MODE,DEALING_WITH_OTHRER_TM=ISNULL(DEALING_WITH_OTHER_TM,''),                        

SYSTUMDATE=SYSTEMDATE,PASSPORTEXPDATE=PASSPORT_EXPIRES_ON,DRIVEEXPDATE=LICENCE_EXPIRES_ON/*,DIRECTOR_NAME     */                    

FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

AND C.CL_CODE = D.CL_CODE                        

                        

DELETE FROM INSTCLIENT_TBL WHERE PARTYCODE IN ( SELECT PARTY_CODE               

       FROM CLIENT_DETAILS_TMP C , CLIENT_BROK_DETAILS_TMP D                         

       WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

       AND C.CL_CODE = D.CL_CODE )                        

                        

/* INSTCLIENT_TBL INSERT QUERY */                        

INSERT INTO INSTCLIENT_TBL                        

SELECT PARTY_CODE, ROUNDMARKETRATE, ROUNDBROKERAGE, ROUNDNETRATE, NO_OF_COPIES, RES1 = 0, RES2 = 0, RES3 = 0, RES4 = 0                        

FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK), ROUNDPARAM R                        

WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                          

AND C.CL_CODE = D.CL_CODE                         

AND D.ROUND_STYLE = R.ROUNDSTYLE                        

          

                  

IF @SEGMENT = 'CAPITAL'              

BEGIN            

                          

 UPDATE CLIENTBROK_SCHEME SET TO_DATE = LEFT(BROK_EFF_DATE - 1,11) + ' 23:59'              

 FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

   WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                        

   AND C.CL_CODE = D.CL_CODE                         

   AND C.PARTY_CODE = CLIENTBROK_SCHEME.PARTY_CODE                        

   AND TO_DATE LIKE 'DEC 31 2049%'                        

                         

 /* CLIENTBROK_SCHEME INSERT QUERY FOR TRD NORMAL */                        

 INSERT INTO CLIENTBROK_SCHEME                        

 SELECT PARTY_CODE, TABLE_NO = TRD_BROK, SCHEME_TYPE = 'TRD', SCRIP_CD = 'ALL',                         

 TRADE_TYPE = 'NRM', BROK_SCHEME, FROM_DATE = LEFT(BROK_EFF_DATE,11), TO_DATE = 'DEC 31 2049 23:59'                        

 FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

 WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                        

 AND C.CL_CODE = D.CL_CODE                        

                         

 /* CLIENTBROK_SCHEME INSERT QUERY FOR DEL NORMAL */                        

 INSERT INTO CLIENTBROK_SCHEME                        

 SELECT PARTY_CODE, TABLE_NO = DEL_BROK, SCHEME_TYPE = 'DEL', SCRIP_CD = 'ALL',                         

 TRADE_TYPE = 'NRM', BROK_SCHEME, FROM_DATE = LEFT(BROK_EFF_DATE,11), TO_DATE = 'DEC 31 2049 23:59'                        

 FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

 WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                        

 AND C.CL_CODE = D.CL_CODE                        

                         

 /* CLIENTBROK_SCHEME INSERT QUERY FOR TRD INS */                        

 INSERT INTO CLIENTBROK_SCHEME                        

 SELECT PARTY_CODE, TABLE_NO = TRD_BROK, SCHEME_TYPE = 'TRD', SCRIP_CD = 'ALL',                         

 TRADE_TYPE = 'INS', BROK_SCHEME, FROM_DATE = LEFT(BROK_EFF_DATE,11), TO_DATE = 'DEC 31 2049 23:59'                        

 FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                        

 AND C.CL_CODE = D.CL_CODE                        

                         

 /* CLIENTBROK_SCHEME INSERT QUERY FOR DEL INS */                        

 INSERT INTO CLIENTBROK_SCHEME                        

 SELECT PARTY_CODE, TABLE_NO = DEL_BROK, SCHEME_TYPE = 'DEL', SCRIP_CD = 'ALL',                         

 TRADE_TYPE = 'INS', BROK_SCHEME, FROM_DATE = LEFT(BROK_EFF_DATE,11), TO_DATE = 'DEC 31 2049 23:59'                        

 FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

 WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                        

 AND C.CL_CODE = D.CL_CODE                        

                       

 UPDATE CLIENTTAXES_NEW SET TODATE = LEFT(TRD_EFF_DT - 1,11) + ' 23:59'                  

 FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

   WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                        

   AND C.CL_CODE = D.CL_CODE                         

   AND C.PARTY_CODE = CLIENTTAXES_NEW.PARTY_CODE                        

   AND CLIENTTAXES_NEW.TODATE LIKE 'DEC 31 2049%'                        

                           

 /* CLIENTTAXES_NEW INSERT QUERY FOR TRD */                        

 INSERT INTO CLIENTTAXES_NEW                        

 SELECT D.EXCHANGE, 1, PARTY_CODE, CL_TYPE, TRANS_CAT = 'TRD', INSURANCE_CHRG = TRD_STT,                        

 TURNOVER_TAX = TRD_TRAN_CHRGS, OTHER_CHRG = TRD_OTHER_CHRGS, SEBITURN_TAX = TRD_SEBI_FEES,                         

 BROKER_NOTE = TRD_STAMP_DUTY, DEMAT_INSURE = 0, SERVICE_TAX = 0, TAX1 = 0, TAX2 = 0, TAX3 = 0, TAX4 = 0,                         

 TAX5 = 0, TAX6 = 0, TAX7 = 0, TAX8 = 0, TAX9 = 0, TAX10 = 0, LATEST = 1, STATE = '', FROMDATE = LEFT(TRD_EFF_DT,11),                        

 TODATE = 'DEC 31 2049 23:59',                         

 ROUND_TO = ROUND_TO_DIGIT, ROFIG = ROUND_TO_PAISE,                         

 ERRNUM = (CASE WHEN ROUNDING_METHOD = 'ACTUAL'                         

       THEN 0.5                 

       WHEN ROUNDING_METHOD = 'NEXT'                        

       THEN (CASE WHEN ROUND_TO_PAISE = 1                         

         THEN -0.01               

         ELSE -0.1                        

       END)                                       

   WHEN ROUNDING_METHOD = 'PREVIOUS'                         

       THEN (CASE WHEN ROUND_TO_PAISE = 1                         

         THEN 0.01                        

         ELSE 0.1                        

       END)                                       

   WHEN ROUNDING_METHOD = 'BANKER'       

       THEN (CASE WHEN ROUND_TO_PAISE = 5                        

         THEN -2.5                  

         ELSE 2.5                        

       END)                                       

     END ),                         

 NOZERO = (CASE WHEN ROUND_TO_PAISE <> 0 THEN 0 ELSE 1 END)                        

 FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

 WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                        

 AND C.CL_CODE = D.CL_CODE                        

                         

 /* CLIENTTAXES_NEW INSERT QUERY FOR DEL */                        

 INSERT INTO CLIENTTAXES_NEW     

 SELECT D.EXCHANGE, 1, PARTY_CODE, CL_TYPE, TRANS_CAT = 'DEL', INSURANCE_CHRG = DEL_STT,                        

 TURNOVER_TAX = DEL_TRAN_CHRGS, OTHER_CHRG = DEL_OTHER_CHRGS, SEBITURN_TAX = DEL_SEBI_FEES,                         

 BROKER_NOTE = DEL_STAMP_DUTY, DEMAT_INSURE = 0, SERVICE_TAX = 0, TAX1 = 0, TAX2 = 0, TAX3 = 0, TAX4 = 0,                         

 TAX5 = 0, TAX6 = 0, TAX7 = 0, TAX8 = 0, TAX9 = 0, TAX10 = 0, LATEST = 1, STATE = '', FROMDATE = LEFT(DEL_EFF_DT,11),                         

 TODATE = 'DEC 31 2049 23:59',                         

 ROUND_TO = ROUND_TO_DIGIT, ROFIG = ROUND_TO_PAISE,                         

 ERRNUM = (CASE WHEN ROUNDING_METHOD = 'ACTUAL'                         

       THEN 0.5                        

       WHEN ROUNDING_METHOD = 'NEXT'                        

       THEN (CASE WHEN ROUND_TO_PAISE = 1                         

         THEN -0.01                     

         ELSE -0.1                        

       END)                                       

   WHEN ROUNDING_METHOD = 'PREVIOUS'                         

       THEN (CASE WHEN ROUND_TO_PAISE = 1                         

         THEN 0.01                        

         ELSE 0.1                        

       END)                                       

   WHEN ROUNDING_METHOD = 'BANKER'                         

       THEN (CASE WHEN ROUND_TO_PAISE = 5                        

         THEN -2.5                        

         ELSE 2.5                        

      END)                                       

     END ),                         

 NOZERO = (CASE WHEN ROUND_TO_PAISE <> 0 THEN 0 ELSE 1 END)                        

 FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

 WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                        

 AND C.CL_CODE = D.CL_CODE                        

END          

                     

DELETE FROM UCC_CLIENT                        

WHERE PARTY_CODE IN ( SELECT PARTY_CODE                         

      FROM CLIENT_DETAILS_TMP C , CLIENT_BROK_DETAILS_TMP D                     

      WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                        

      AND C.CL_CODE = D.CL_CODE)                         

                        

INSERT INTO UCC_CLIENT                        

SELECT PARTY_CODE, LONG_NAME, CONTRACT_PERSON = INTRODUCER, CLEARINGNO1 = '', CLEARINGNO2 = '', CLEARINGNO3 = '',                        

CLEARINGNO4 = '', MAPIDID = MAPIN_ID, FMCODE = ISNULL(C.FMCODE,''), DEALING_WITH_OTHER_TM, ANY_OTHER_ACC = OTHER_AC_NO,                         

FAMILY_CODE1 = '', FAMILY_CODE2 = '', FAMILY_CODE3 = '', FAMILY_CODE4 = '', REMARK = '', UCC_CODE,                         

STPPROVIDER = '', DUMMY1 = '', DUMMY2 = ''                        

FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                        

AND C.CL_CODE = D.CL_CODE                    

                    

DELETE FROM DELPARTYFLAG                       

WHERE PARTY_CODE IN ( SELECT PARTY_CODE                         

      FROM CLIENT_DETAILS_TMP C, CLIENT_BROK_DETAILS_TMP D                  

      WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                        

      AND C.CL_CODE = D.CL_CODE)                    

        

INSERT INTO DELPARTYFLAG                    

SELECT PARTY_CODE, DEBIT_BALANCE, INTER_SETT                    

FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)                        

WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT                        

AND C.CL_CODE = D.CL_CODE                    

IF @SEGMENT = 'FUTURES'              

BEGIN            

            

 UPDATE FOCLIENTBROKSCHEME SET DATE_TO = LEFT(BROK_EFF_DATE - 1,11) + ' 23:59:59'          

 FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)              

 WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT          

 AND C.CL_CODE = D.CL_CODE               

 AND C.PARTY_CODE = FOCLIENTBROKSCHEME.PARTY_CODE              

 AND DATE_TO LIKE 'DEC 31 2049%'          

          

 INSERT INTO FOCLIENTBROKSCHEME              

 SELECT PARTY_CODE, DATE_FROM = LEFT(BROK_EFF_DATE,11), DATE_TO = 'DEC 31 2049 23:59:59',          

 FUT_BROKTABLE = FUT_BROK, OPT_BROKTABLE = FUT_OPT_BROK,           

 FUT_EXP_BROKTABLE = FUT_FUT_FIN_BROK, OPT_EXC_BROKTABLE = FUT_OPT_EXC,          

 COMM_DEL_BROKTABLE = DEL_BROK, BROK_SCHEME,           

 OPT_BROK_COMPUTEON = (CASE WHEN FUT_BROK_APPLICABLE = 0          

           THEN 'PRICE'           

       WHEN FUT_BROK_APPLICABLE = 1          

       THEN 'SPRICE'             

           ELSE 'SSPRICE'           

          END)          

 FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)              

 WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT              

 AND C.CL_CODE = D.CL_CODE          

          

 UPDATE FOCLIENTTAXES SET DATE_TO = TRD_EFF_DT - 1               

 FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)              

 WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT              

 AND C.CL_CODE = D.CL_CODE               

 AND C.PARTY_CODE = FOCLIENTTAXES.PARTY_CODE              

 AND FOCLIENTTAXES.DATE_TO LIKE 'DEC 31 2049%'          

          

 INSERT INTO FOCLIENTTAXES              

 SELECT PARTY_CODE, DATE_FROM = LEFT(TRD_EFF_DT,11), DATE_TO = 'DEC 31 2049 23:59',          

 FUT_INSURANCE_CHRG = TRD_STT, FUT_TURNOVER_TAX = TRD_TRAN_CHRGS,           

 FUT_OTHER_CHRG = TRD_OTHER_CHRGS, FUT_SEBITURN_TAX = TRD_SEBI_FEES,               

 FUT_BROKER_NOTE = TRD_STAMP_DUTY,          

 OPT_INSURANCE_CHRG = DEL_STT, OPT_TURNOVER_TAX = DEL_TRAN_CHRGS,           

 OPT_OTHER_CHRG = DEL_OTHER_CHRGS, OPT_SEBITURN_TAX = DEL_SEBI_FEES,               

 OPT_BROKER_NOTE = DEL_STAMP_DUTY,          

 ROUND_TO = ROUND_TO_DIGIT, ROFIG = (CASE WHEN ROUNDING_METHOD = 'ACTUAL' THEN 0 ELSE ROUND_TO_PAISE END),               

 ERRNUM = (CASE WHEN ROUNDING_METHOD = 'ACTUAL'               

                THEN 0.5              

                WHEN ROUNDING_METHOD = 'NEXT'              

                THEN (CASE WHEN ABS(ROUND_TO_PAISE) = 1               

                           THEN -0.01              

                           ELSE -0.1              

                      END)                             

         WHEN ROUNDING_METHOD = 'PREVIOUS'               

                THEN (CASE WHEN ABS(ROUND_TO_PAISE) = -1          

                           THEN 0.000001           

                        ELSE 0.000001            

                      END)                             

         WHEN ROUNDING_METHOD = 'BANKER' OR ROUNDING_METHOD = 'BANKERS'          

                THEN (CASE WHEN ABS(ROUND_TO_PAISE) = 5              

                           THEN -2.5              

                           ELSE 2.5              

                      END)                

           END ),               

 NOZERO = (CASE WHEN ROUNDING_METHOD = 'ACTUAL' THEN 1           

      ELSE 0 END)          

 FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)              

 WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT              

 AND C.CL_CODE = D.CL_CODE          

          

 DELETE FROM FOCLIENTTAXES WHERE DATE_FROM > DATE_TO          

 DELETE FROM FOCLIENTBROKSCHEME WHERE DATE_FROM > DATE_TO            

            

END          

INSERT INTO CONTRACT_ROUNDING          

SELECT PARTY_CODE, MINCONTRACTAMOUNT = 30, MAXCONTRACTAMT = -1,          

CR_DATE_FROM = LEFT(GETDATE(), 11), CR_DATE_TO = 'DEC 31 2049 23:59:59',           

CR_CREATEDBY = 'SYSTEM', CR_CREATEDON = GETDATE(), CR_MODIFIEDBY = '',          

CR_MODIFIEDON = ''          

FROM CLIENT_DETAILS_TMP C (NOLOCK), CLIENT_BROK_DETAILS_TMP D  (NOLOCK)          

WHERE D.EXCHANGE = @EXCHANGE AND D.SEGMENT = @SEGMENT           

AND C.CL_CODE = D.CL_CODE          

AND C.CL_CODE NOT IN (SELECT CR_PARTY_CODE FROM CONTRACT_ROUNDING)          

AND C.CL_TYPE NOT IN ( 'INS', 'AGS')  

-------------------------GST

UPDATE TBL_CLIENT_GST_DATA SET EFF_TO_DATE = LEFT(GETDATE()-1,11) + ' 23:59:59'
FROM CLIENT_DETAILS_TMP
WHERE TBL_CLIENT_GST_DATA.PARTY_CODE = CLIENT_DETAILS_TMP.CL_CODE
AND EFF_TO_DATE >= LEFT(GETDATE(),11)

DELETE FROM TBL_CLIENT_GST_DATA
WHERE EFF_FROM_DATE > EFF_TO_DATE

INSERT INTO TBL_CLIENT_GST_DATA 
SELECT PARTY_CODE, BRANCH_CD, SUB_BROKER, LONG_NAME, L_ADDRESS1, L_ADDRESS2, L_ADDRESS3, L_CITY, L_STATE, L_ZIP, L_NATION, GST_NO, GST_LOCATION,
EFF_FROM_DATE = LEFT(GETDATE(),11), EFF_TO_DATE = 'DEC 31 2049 23:59:59', CREATED_ON = GETDATE()
FROM CLIENT_DETAILS_TMP

--------------------------END GST


-- code added by brijesh on 21/02/2015 for Ci phase 2 



---exec MULTIBANKINSERT_CI

exec SCHEME_MAP

GO
