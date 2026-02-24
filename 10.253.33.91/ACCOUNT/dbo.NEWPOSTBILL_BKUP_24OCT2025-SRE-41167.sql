-- Object: PROCEDURE dbo.NEWPOSTBILL_BKUP_24OCT2025-SRE-41167
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

 CREATE PROCEDURE [dbo].[NEWPOSTBILL_BKUP_24OCT2025-SRE-41167]      
(    
      @VTYP SMALLINT,      
      @BOOKTYPE VARCHAR(2),      
      @VNO VARCHAR(12),      
      @VDT VARCHAR(11),      
      @EDTDR VARCHAR(11),      
      @EDTCR VARCHAR(11),      
      @CDT VARCHAR(11),      
      @PDT VARCHAR(11),      
      @ENTEREDBY VARCHAR(25),      
      @CHECKEDBY VARCHAR(25),      
      @SETT_NO VARCHAR(7),      
      @SETT_TYPE VARCHAR(3),      
      @UNAME VARCHAR(25),       
      @EXCHANGE VARCHAR(10),     
      @OVNO VARCHAR(12) = ''    
)    
    
AS      
      
/*=================================================================================================    
--EXEC NEWPOSTBILL 15, '01', '200500001530', 'DEC  5 2005', 'DEC  5 2005', 'DEC  7 2005', 'DEC  6 2005', 'DEC  6 2005', 'SYSTEM', 'SYSTEM', '2005230', 'N', 'YATIN'      
--EXEC NEWPOSTBILL 21, '01', '200500001530', 'DEC  5 2005', 'DEC  5 2005', 'DEC  7 2005', 'DEC  6 2005', 'DEC  6 2005', 'SYSTEM', 'SYSTEM', '2005230', 'N', 'YATIN'      
=================================================================================================*/    
    
SET NOCOUNT ON      
    
DECLARE      
 @@OBJID AS INT,      
 @@EDTDR AS VARCHAR(11),      
 @@EDTCR AS VARCHAR(11),      
 @@LEDCNT AS INT    
      
--BEGIN TRANSACTION    
    
 SELECT @@OBJID = ISNULL(OBJECT_ID('BFBILLMATCH'), 0)    
    
/*=================================================================================================    
      CHECK FOR DELETE IF RE-POSTING IS BEING DONE    
=================================================================================================*/    
      IF @OVNO <> ''    
      BEGIN    
           SELECT @@LEDCNT = COUNT(1) FROM BILLPOSTED WITH(NOLOCK) WHERE VNO = @OVNO AND VTYP = @VTYP AND BOOKTYPE = @BOOKTYPE    
           IF @@LEDCNT > 0     
           BEGIN     
                DELETE FROM LEDGER WHERE VNO = @OVNO AND VTYP = @VTYP AND BOOKTYPE = @BOOKTYPE      
--                DELETE FROM LEDGER1 WHERE VNO = @OVNO AND VTYP = @VTYP AND BOOKTYPE = @BOOKTYPE      
                DELETE FROM LEDGER2 WHERE VNO = @OVNO AND VTYPE = @VTYP AND BOOKTYPE = @BOOKTYPE      
--                DELETE FROM LEDGER3 WHERE VNO = @OVNO AND VTYP = @VTYP AND BOOKTYPE = @BOOKTYPE      
                DELETE FROM BILLMATCH WHERE VNO = @OVNO AND VTYPE = @VTYP AND BOOKTYPE = @BOOKTYPE      
                DELETE FROM BILLPOSTED WHERE VNO = @OVNO AND VTYP = @VTYP AND BOOKTYPE = @BOOKTYPE      
                IF @@OBJID <> 0      
                BEGIN      
                     DELETE FROM BFBILLMATCH WHERE VNO = @OVNO AND VTYPE = @VTYP AND BOOKTYPE = @BOOKTYPE      
                END      
           END    
      END    
    
      TRUNCATE TABLE POSTBILLLEDGER      
      TRUNCATE TABLE POSTBILLLEDGER2    
    
    
/*=========================================================================================================    
      POPULATE DATA FROM ACCBILL (NORMAL CLIENTS) / IACCBILL (INST CLIENTS), ACMAST TO BE USED FOR POSTING    
=========================================================================================================*/    
      IF @VTYP = 15      
      BEGIN      
            INSERT     
            INTO POSTBILLLEDGER     
                  (     
                        VTYP,     
                        VNO,     
                        EDT,     
                        ACNAME,     
                        DRCR,     
                        VAMT,     
                        VDT,     
                        VNO1,     
                        REFNO,     
                        BALAMT,     
                        NODAYS,     
                        CDT,     
                        CLTCODE,     
                        BOOKTYPE,     
                        ENTEREDBY,     
                        PDT,     
                        CHECKEDBY,     
                        ACTNODAYS,     
                        NARRATION,     
                        SETT_NO,     
                        SETT_TYPE,     
                        BILL_NO,     
  ACCAT,     
                        BRANCHCODE    
                  )     
            SELECT     
                  @VTYP,     
                  @VNO,     
                  (    
   CASE     
                              WHEN SELL_BUY = 1     
                              THEN @EDTDR     
                              ELSE @EDTCR     
    END    
                        ),     
                  ACNAME,     
                        (    
                        CASE     
                              WHEN SELL_BUY = 1     
                              THEN 'D'     
                              ELSE 'C'     
                        END    
                        ),     
                  AMOUNT,     
                  @VDT,     
                  @VNO,     
                  '',     
                  0,     
                  0,     
                  CONVERT(VARCHAR(11), GETDATE(), 109),     
                  PARTY_CODE,     
                  @BOOKTYPE,     
                  @ENTEREDBY,     
                  CONVERT(VARCHAR(11), GETDATE(), 109),     
                  @CHECKEDBY,     
                  0,     
                  'SETTNO=' + RTRIM(@SETT_NO) + @EXCHANGE + RTRIM(@SETT_TYPE) + RTRIM(LTRIM(NARRATION)),     
                  @SETT_NO,     
                  @SETT_TYPE,     
                  BILL_NO,     
                  A.ACCAT,     
                  A.BRANCHCODE      
            FROM MSAJAG.DBO.ACCBILL B WITH(NOLOCK),     
                  ACMAST A WITH(NOLOCK)     
            WHERE B.PARTY_CODE = A.CLTCODE     
                  AND B.SETT_NO = @SETT_NO     
                  AND B.SETT_TYPE = @SETT_TYPE     
                  AND B.AMOUNT <> 0    
                  AND     
                        (    
                              A.ACCAT = 4     
                              OR B.BRANCHCD = 'ZZZ'    
                        )     
           
    
            INSERT     
                  INTO POSTBILLLEDGER2     
            SELECT     
                  (CASE WHEN SELL_BUY = 1 THEN 'D' ELSE 'C' END),     
                  AMOUNT,     
                  BRANCHCD,     
                  PARTY_CODE    
            FROM     
                  MSAJAG.DBO.ACCBILL    
            WHERE    
                  SETT_NO = @SETT_NO     
                  AND SETT_TYPE = @SETT_TYPE     
                  AND BRANCHCD <> 'ZZZ'    
                  AND AMOUNT <> 0    
    
      END      
      ELSE      
      IF @VTYP = 21      
      BEGIN      
            INSERT     
            INTO POSTBILLLEDGER     
                  (     
                        VTYP,     
                        VNO,     
                        EDT,     
                        ACNAME,     
                        DRCR,     
                        VAMT,     
                        VDT,     
                        VNO1,     
                        REFNO,     
                        BALAMT,     
                        NODAYS,     
                        CDT,     
                        CLTCODE,     
                        BOOKTYPE,     
                        ENTEREDBY,     
                        PDT,     
                        CHECKEDBY,     
                        ACTNODAYS,     
                        NARRATION,     
                        SETT_NO,     
                        SETT_TYPE,     
                        BILL_NO,     
                        ACCAT,     
                        BRANCHCODE    
                  )     
            SELECT     
                  @VTYP,     
                  @VNO,     
                  (    
                        CASE     
                              WHEN SELL_BUY = 1     
                              THEN @EDTDR     
                              ELSE @EDTCR     
                        END    
                  ),     
                  ACNAME,     
                        (    
                        CASE     
                              WHEN SELL_BUY = 1     
                              THEN 'D'     
                              ELSE 'C'     
        END    
                        ),     
                  AMOUNT,     
                  @VDT,     
                  @VNO,     
                  '',     
                  0,     
                  0,     
                  CONVERT(VARCHAR(11), GETDATE(), 109),     
                  PARTY_CODE,     
                  @BOOKTYPE,     
                  @ENTEREDBY,     
                  CONVERT(VARCHAR(11), GETDATE(), 109),     
                  @CHECKEDBY,     
                  0,     
                  'SETTNO=' + RTRIM(@SETT_NO) + @EXCHANGE + RTRIM(@SETT_TYPE) + RTRIM(LTRIM(NARRATION)),     
                  @SETT_NO,     
                  @SETT_TYPE,     
                  BILL_NO,     
                  A.ACCAT,     
                  A.BRANCHCODE      
            FROM MSAJAG.DBO.IACCBILL B WITH(NOLOCK),     
                  ACMAST A WITH(NOLOCK)     
            WHERE B.PARTY_CODE = A.CLTCODE     
                  AND B.SETT_NO = @SETT_NO     
                  AND B.SETT_TYPE = @SETT_TYPE     
                  AND B.AMOUNT <> 0    
                  AND     
                        (    
                              A.ACCAT = 4     
                       OR B.BRANCHCD = 'ZZZ'    
                        )     
    
            INSERT     
                  INTO POSTBILLLEDGER2     
            SELECT     
                  (CASE WHEN SELL_BUY = 1 THEN 'D' ELSE 'C' END),     
                  AMOUNT,     
                  BRANCHCD,     
                  PARTY_CODE    
            FROM     
                  MSAJAG.DBO.IACCBILL    
            WHERE    
                  SETT_NO = @SETT_NO     
                  AND SETT_TYPE = @SETT_TYPE     
                  AND AMOUNT <> 0    
                  AND BRANCHCD <> 'ZZZ'    
    
      END      
      
    
/*=================================================================================================    
      POST DATA INTO LEDGER    
=================================================================================================*/    
      INSERT     
      INTO LEDGER     
            (    
                  VTYP,     
                  VNO,     
                  EDT,     
                  LNO,     
                  ACNAME,     
                  DRCR,     
                  VAMT,     
                  VDT,     
                  VNO1,     
                  REFNO,     
                  BALAMT,     
                  NODAYS,     
                  CDT,     
                  CLTCODE,     
                  BOOKTYPE,     
                  ENTEREDBY,     
                  PDT,     
                  CHECKEDBY,     
                  ACTNODAYS,     
                  NARRATION    
            )     
      SELECT     
            VTYP,     
            VNO,     
            EDT,     
            LNO,     
            ACNAME,     
            DRCR,     
            VAMT,     
            VDT,     
            VNO1,     
            REFNO,     
            BALAMT,     
            NODAYS,     
            CDT,     
            CLTCODE,     
            BOOKTYPE,     
            ENTEREDBY,     
            PDT,     
            CHECKEDBY,     
            ACTNODAYS,     
            NARRATION     
      FROM POSTBILLLEDGER WITH(NOLOCK)     
    
       
/*=================================================================================================    
      POST DATA INTO LEDGER1    
=================================================================================================*/    
/*      INSERT     
      INTO LEDGER1     
            (    
                  BNKNAME,     
                  BRNNAME,     
                  DD,     
                  DDNO,     
                  DDDT,     
                  RELDT,     
                  RELAMT,     
                  REFNO,     
                  RECEIPTNO,     
                  VTYP,     
                  VNO,     
                  LNO,     
                  DRCR,     
                  BOOKTYPE,     
                  MICRNO,     
                  SLIPNO,     
                  SLIPDATE,     
             CHEQUEINNAME,     
                  CHQPRINTED,     
                  CLEAR_MODE    
            )     
      SELECT     
            RTRIM(LTRIM(SETT_NO)) + @EXCHANGE + RTRIM(LTRIM(SETT_TYPE)) + CONVERT(VARCHAR(10), BILL_NO),     
            '',     
            'B',     
            '0',     
            '',     
            '',     
            VAMT,     
            '0',     
            '',     
            VTYP,     
            VNO,     
            LNO,     
            DRCR,     
            BOOKTYPE,     
            '0',     
            '',     
            '',     
            '',     
            1,     
            'C'     
      FROM POSTBILLLEDGER WITH(NOLOCK)  */  
    
      
/*=================================================================================================    
      POST DATA INTO LEDGER2    
=================================================================================================*/    
    
	  INSERT     
      INTO LEDGER2     
            (    
                  VTYPE,     
                  VNO,     
                  LNO,     
                  DRCR,     
                  CAMT,     
                  COSTCODE,     
                  BOOKTYPE,     
                  CLTCODE    
            )     
      SELECT     
            B.VTYP,     
            B.VNO,     
            B.LNO,     
            B2.DRCR,     
            B2.AMOUNT,     
            C.COSTCODE,     
            B.BOOKTYPE,     
            B.CLTCODE     
      FROM POSTBILLLEDGER B WITH(NOLOCK),     
            COSTMAST C WITH(NOLOCK),    
            POSTBILLLEDGER2 B2     
      WHERE     
            B.CLTCODE = B2.CLTCODE    
            AND B2.BRANCHCODE = C.COSTNAME     
      
    
/*=================================================================================================    
      POST DATA INTO LEDGER3    
=================================================================================================*/    
      /*INSERT     
      INTO LEDGER3     
            (    
                  NARATNO,    
                  NARR,    
         REFNO,    
                  VTYP,    
                  VNO,    
                  BOOKTYPE    
            )     
      SELECT     
            LNO,     
            NARRATION,     
            '',     
            VTYP,     
            VNO,     
            BOOKTYPE     
      FROM POSTBILLLEDGER   */  
      
    
/*=================================================================================================    
      POST DATA INTO BILLMATCH    
=================================================================================================*/    
      
	  
	  INSERT     
      INTO BILLMATCH     
            (    
                  EXCHANGE,     
                  SEGMENT,     
                  SETT_TYPE,     
                  SETT_NO,     
                  BILLNO,     
                  DATE,     
                  PARTY_CODE,     
                  AMOUNT,     
                  DRCR,     
                  BALAMT,     
                  VTYPE,     
                  VNO,     
                  LNO,     
                  BRANCH,     
                  BOOKTYPE    
            )     
      SELECT     
            LEFT(@EXCHANGE, 3),     
            'CAPITAL',     
            SETT_TYPE,     
            SETT_NO,     
            BILL_NO,     
            VDT,     
            CLTCODE,     
            VAMT,     
            DRCR,     
            0,     
            VTYP,     
            VNO,     
            LNO,     
            BRANCHCODE,     
            BOOKTYPE     
      FROM POSTBILLLEDGER WITH(NOLOCK)      
      WHERE ACCAT = '4'     
      
/*=================================================================================================    
      POST DATA INTO BFBILLMATCH    
=================================================================================================*/    
      IF @@OBJID <> 0      
      BEGIN      
            INSERT     
            INTO BFBILLMATCH     
                  (    
                        EXCHANGE,     
              SEGMENT,     
                        SETT_TYPE,     
                        SETT_NO,     
                        BILLNO,     
                        DATE,     
                        PARTY_CODE,     
                        AMOUNT,     
                        DRCR,     
                        BALAMT,     
                        VTYPE,     
                        VNO,     
                        LNO,     
                        BRANCH,     
                        BOOKTYPE,     
                        BANKPOSTDATE,     
                        BANKPOSTAMOUNT,     
                        BANKSTATUS,     
                        BANKREASON    
                  )     
            SELECT     
                  LEFT(@EXCHANGE, 3),     
                  'CAPITAL',     
                  SETT_TYPE,     
                  SETT_NO,     
                  BILL_NO,     
                  VDT,     
                  CLTCODE,     
                  VAMT,     
   DRCR,     
                  0,     
                  VTYP,     
                  VNO,     
                  LNO,     
                  BRANCHCODE,     
                  BOOKTYPE,     
                  '',     
                  0,     
                  '',     
                  ''     
            FROM POSTBILLLEDGER WITH(NOLOCK)     
            WHERE ACCAT = '4'     
      END      
       
/*=================================================================================================    
      POST DATA INTO POSTBILLLEDGER    
=================================================================================================*/    
      SELECT     
            @@EDTDR = MIN(EDT),     
            @@EDTCR = MAX(EDT)     
      FROM POSTBILLLEDGER     
    
      INSERT     
      INTO BILLPOSTED     
            (    
                  VNO,     
                  VTYP,     
                  BOOKTYPE,     
                  VDT,     
                  BILLDATE,     
                  SETT_NO,     
                  SETT_TYPE,     
                  NARRATION,     
                  USERNAME,     
                  POSTDATE,     
                  EDTDR,     
                  EDTCR    
            )     
      SELECT     
            TOP 1 VNO,     
            VTYP,     
            BOOKTYPE,     
            CONVERT(VARCHAR(11), VDT, 109),     
         CONVERT(VARCHAR(11), VDT, 109),     
            SETT_NO,     
            SETT_TYPE,     
            NARRATION,     
            @UNAME,     
            CONVERT(VARCHAR(11), GETDATE(), 109),     
            @@EDTDR,     
            @@EDTCR     
      FROM POSTBILLLEDGER WITH(NOLOCK)     
    
--COMMIT TRANSACTION

GO
