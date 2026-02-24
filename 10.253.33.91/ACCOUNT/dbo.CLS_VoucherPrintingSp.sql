-- Object: PROCEDURE dbo.CLS_VoucherPrintingSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



--EXEC VOUCHERPRINTINGSP '17','01','01','','','200705020001','200705020001',1,1   
            
--EXEC CLS_VoucherPrintingSp '4','01','01','Apr  1 2022','','','',1,0                
              
/****** OBJECT:  STORED PROCEDURE DBO.VOUCHERPRINTINGSP    SCRIPT DATE: 06/24/2004 8:32:35 PM ******/                  
                  
/****** OBJECT:  STORED PROCEDURE DBO.VOUCHERPRINTINGSP    SCRIPT DATE: 05/10/2004 5:29:36 PM ******/                  
/* COMM. NARR REPLACED LINE NARRATION  BY AMIT REQUIRMENT IN MOSL ON 18/10/2002*/                  
                  
CREATE PROC [dbo].[CLS_VoucherPrintingSp]                   
@VTYP VARCHAR(2),                  
@BOOKTYPEFROM VARCHAR(2),                  
@BOOKTYPETO VARCHAR(2),                  
@STARTDATE VARCHAR(11),                  
@ENDDATE VARCHAR(11),                  
@VNOFROM VARCHAR(12),                  
@VNOTO VARCHAR(12),                  
@VNOVDTFLAG INT,                  
@FLAG INT,
@PDFFLAG VARCHAR(1) = 'N',
@VNOSTR VARCHAR(MAX) ='',
@FCLT VARCHAR(10)='',
@TCLT VARCHAR(10)=''
AS                  
IF @FLAG = 0                  
BEGIN                  
   IF @STARTDATE = ''                   
      BEGIN 
	      /* CONDITIONS OF VNO ONLY */                  
			SELECT   CLTCODE = ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20  OR L.VTYP = 24                   
			THEN (SELECT PARTY_CODE FROM MARGINLEDGER M WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                   
			ELSE L.CLTCODE END ),0),                   
			ACNAME= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                   
			THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                   
			ELSE L.ACNAME END ),0),                    
			ISNULL(L.VAMT,0) VAMT, L.DRCR, L.VTYP,L.VNO, L.LNO , L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CONVERT(VARCHAR,L.EDT,103) EDT,                  
			BANK = ISNULL(BNKNAME,''), BRANCH = ISNULL(BRNNAME,'') , ISNULL(DD,'') DD  ,ISNULL(DDNO,'') DDNO, DDDT  =  CONVERT(VARCHAR,DDDT,103)  ,                  
			NARR = ISNULL(L.NARRATION,'') ,                  
			/*CNAR = ISNULL((SELECT NARR FROM LEDGER3 L3 WHERE L3.VTYP = L.VTYP AND L3.VNO = L.VNO AND L3.NARATNO = 0 AND L3.BOOKTYPE = L.BOOKTYPE),'') ,*/                  
			CNAR = ISNULL(L.NARRATION,'') ,                  
			CLTCODE2 = CLTCODE, ACNAME2 = ACNAME ,
			UPPER(ENTEREDBY) AS 'ENTEREDBY',      UPPER(CHECKEDBY) AS 'CHECKEDBY'                    
			FROM LEDGER L ,LEDGER1 L1                  
			WHERE L1.VTYP = L.VTYP AND L1.VNO = L.VNO AND L1.BOOKTYPE = L.BOOKTYPE                    
			AND L.VTYP = @VTYP AND L.BOOKTYPE >= @BOOKTYPEFROM AND L.BOOKTYPE <= @BOOKTYPETO                   
			AND L.VNO >= @VNOFROM  AND L.VNO <= @VNOTO                   
			ORDER BY L.VDT, L.VTYP, L.BOOKTYPE, L.VNO, /*L.DRCR DESC, */L.LNO        
      END                  
   ELSE                  
   IF @VNOFROM = ''                   
      BEGIN     
			/* CONDITIONS ON VDT ONLY */                  
			SELECT CLTCODE = ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                    
			THEN (SELECT PARTY_CODE FROM MARGINLEDGER M WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                   
			ELSE L.CLTCODE END),0),                   
			ACNAME= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                   
			THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                   
			ELSE L.ACNAME END ),0),                    
			ISNULL(L.VAMT,0) VAMT, L.DRCR, 
			vtyp=L.VTYP,
			(SELECT VDESC FROM VMAST WHERE VTYPE = L.VTYP)AS VDESC,
			L.VNO, L.LNO , L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CONVERT(VARCHAR,L.EDT,103) EDT,                  
			BANK = ISNULL(BNKNAME,''), BRANCH = ISNULL(BRNNAME,'') , ISNULL(DD,'') DD  ,ISNULL(DDNO,'') DDNO, DDDT  =  CONVERT(VARCHAR,DDDT,103)  ,                  
			NARR = ISNULL(L.NARRATION,'') ,                  
			/*CNAR = ISNULL((SELECT NARR FROM LEDGER3 L3 WHERE L3.VTYP = L.VTYP AND L3.VNO = L.VNO AND L3.NARATNO = 0 AND L3.BOOKTYPE = L.BOOKTYPE),''), */                  
			CNAR = ISNULL(L.NARRATION,'') ,                  
			CLTCODE2 = CLTCODE, ACNAME2 = ACNAME ,
			UPPER(ENTEREDBY) AS 'ENTEREDBY',      UPPER(CHECKEDBY) AS 'CHECKEDBY'      
			FROM LEDGER L ,LEDGER1 L1                  
			WHERE   L.VTYP = @VTYP AND L.BOOKTYPE >= @BOOKTYPEFROM AND L.BOOKTYPE <= @BOOKTYPETO AND VDT >= @STARTDATE + ' 00:00:00'                  
			AND L1.VTYP = L.VTYP AND L1.VNO = L.VNO 
   
			AND
			(
			(@VNOSTR <> '' AND L.VNO IN(SELECT ITEMS FROM DBO.SPLIT(@VNOSTR,'~') WHERE ISNULL(ITEMS,'') <> ''))
			OR
			(@VNOSTR = ''  AND (L.VNO >= (CASE WHEN @VNOFROM = '' THEN L.VNO ELSE @VNOFROM END) AND L.VNO <= (CASE WHEN @VNOTO = '' THEN L.VNO ELSE @VNOTO END) ))	
			) 
			AND (CLTCODE >= (CASE WHEN @FCLT <> '' THEN @FCLT ELSE CLTCODE END) AND CLTCODE <= (CASE WHEN @TCLT <> '' THEN @TCLT ELSE CLTCODE END))
			AND L1.BOOKTYPE = L.BOOKTYPE                   
			AND VDT <=@ENDDATE + ' 23:59:59'                  
			ORDER BY L.VDT, L.VTYP, L.BOOKTYPE, L.VNO, L.LNO                  
                  
      END                  
   ELSE                  
      BEGIN   
            /* CONDITIONS ON VDT AND VNO */                  
			SELECT CLTCODE = ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20  OR L.VTYP = 24                   
			THEN (SELECT PARTY_CODE FROM MARGINLEDGER M WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                   
			ELSE L.CLTCODE END ),0),                   
			ACNAME= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                   
			THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                   
			ELSE L.ACNAME END ),0),                    
			ISNULL(L.VAMT,0) VAMT, L.DRCR, L.VTYP,
			(SELECT VDESC FROM VMAST WHERE VTYPE = L.VTYP)AS VDESC,
			L.VNO, L.LNO , L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CONVERT(VARCHAR,L.EDT,103) EDT,                  
			BANK = ISNULL(BNKNAME,''), BRANCH = ISNULL(BRNNAME,'') , ISNULL(DD,'') DD  ,ISNULL(DDNO,'') DDNO, DDDT  =  CONVERT(VARCHAR,DDDT,103)  ,                  
			NARR = ISNULL(L.NARRATION,'') ,                  
			/*CNAR = ISNULL((SELECT NARR FROM LEDGER3 L3 WHERE L3.VTYP = L.VTYP AND L3.VNO = L.VNO AND L3.NARATNO = 0 AND L3.BOOKTYPE = L.BOOKTYPE),'') ,*/                  
			CNAR = ISNULL(L.NARRATION,'') ,                  
			CLTCODE2 = CLTCODE, ACNAME2 = ACNAME ,
			UPPER(ENTEREDBY) AS 'ENTEREDBY',      UPPER(CHECKEDBY) AS 'CHECKEDBY'                    
			FROM LEDGER L ,LEDGER1 L1                  
			WHERE L1.VTYP = L.VTYP AND L1.VNO = L.VNO AND L1.BOOKTYPE = L.BOOKTYPE                    
			AND L.VTYP = @VTYP AND L.BOOKTYPE >= @BOOKTYPEFROM AND L.BOOKTYPE <= @BOOKTYPETO                   
			--AND L.VNO >= @VNOFROM  AND L.VNO <= @VNOTO    
			AND
			(
			(@VNOSTR <> '' AND L.VNO IN(SELECT ITEMS FROM DBO.SPLIT(@VNOSTR,'~') WHERE ISNULL(ITEMS,'') <> ''))
			OR
			(@VNOSTR = ''  AND (L.VNO >= (CASE WHEN @VNOFROM = '' THEN L.VNO ELSE @VNOFROM END) AND L.VNO <= (CASE WHEN @VNOTO = '' THEN L.VNO ELSE @VNOTO END) ))	
			)                
			/* FOLL CONDITION ADDED BY KALPANA ON 19/09/2002 */                  
			AND VDT >= (CASE WHEN @STARTDATE <> ''  THEN @STARTDATE  + ' 00:00:00'                  
			ELSE 'JAN  1 1900' + ' 00:00:00'                  
			END)                   
			AND VDT <= (CASE WHEN @ENDDATE <> ''  THEN @ENDDATE + ' 23:59:59'                  
			ELSE GETDATE()                  
			END)                   
			ORDER BY L.VDT, L.VTYP, L.BOOKTYPE, L.VNO, /*L.DRCR DESC, */L.LNO -- DESC                  
      END                  
END                
                  
ELSE IF @FLAG = 1                  
BEGIN                  
  IF @STARTDATE = ''                   
     BEGIN 
	   
		/* CONDITIONS OF VNO ONLY */                  
		SELECT   CLTCODE = ISNULL((CASE WHEN  L.VTYP = 22 OR L.VTYP = 23 OR L.VTYP = 24                   
		THEN (SELECT PARTY_CODE FROM MARGINLEDGER M WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                   
		ELSE L.CLTCODE END ),0),                   
		ACNAME= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 22 OR L.VTYP = 23 OR L.VTYP = 24                   
		THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                   
		ELSE L.ACNAME END ),0),                    
		ISNULL(L.VAMT,0) VAMT, L.DRCR, L.VTYP,L.VNO, L.LNO , L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CONVERT(VARCHAR,L.EDT,103) EDT,                  
		NARR = ISNULL(L.NARRATION,'') ,                  
		/*CNAR = ISNULL((SELECT NARR FROM LEDGER3 L3 WHERE L3.VTYP = L.VTYP AND L3.VNO = L.VNO AND L3.NARATNO = 0 AND L3.BOOKTYPE = L.BOOKTYPE),'') ,*/                  
		CNAR = ISNULL(L.NARRATION,'') ,                  
		CLTCODE2 = CLTCODE, ACNAME2 = ACNAME ,
			UPPER(ENTEREDBY) AS 'ENTEREDBY',      UPPER(CHECKEDBY) AS 'CHECKEDBY'                    
		FROM LEDGER L                   
		WHERE  L.VTYP = @VTYP --AND L.BOOKTYPE >= @BOOKTYPEFROM AND L.BOOKTYPE <= @BOOKTYPETO                   
		--AND L.VNO >= @VNOFROM  AND L.VNO <= @VNOTO
		AND
			(
			(@VNOSTR <> '' AND L.VNO IN(SELECT ITEMS FROM DBO.SPLIT(@VNOSTR,'~') WHERE ISNULL(ITEMS,'') <> ''))
			OR
			(@VNOSTR = ''  AND (L.VNO >= (CASE WHEN @VNOFROM = '' THEN L.VNO ELSE @VNOFROM END) AND L.VNO <= (CASE WHEN @VNOTO = '' THEN L.VNO ELSE @VNOTO END) ))	
			)                  
		--AND L.DRCR IN (CASE WHEN @VTYP='6' THEN 'C' ELSE CASE WHEN @VTYP='7' THEN 'D' ELSE 'C''D' END END)                
		ORDER BY L.VDT, L.VTYP, L.BOOKTYPE, L.VNO, /*L.DRCR DESC, */L.LNO --DESC                  
     END                  
 ELSE                  
 IF @VNOFROM = ''                   
     BEGIN                  
                /* CONDITIONS ON VDT ONLY */                  
                    
   SELECT   CLTCODE = ISNULL((CASE WHEN  L.VTYP = 22 OR L.VTYP = 23 OR L.VTYP = 24                   
                     THEN (SELECT PARTY_CODE FROM MARGINLEDGER M WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                   
                      ELSE L.CLTCODE END ),0),                   
     ACNAME= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 22 OR L.VTYP = 23 OR L.VTYP = 24                   
                        THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                   
                         ELSE L.ACNAME END ),0),                    
     ISNULL(L.VAMT,0) VAMT, L.DRCR, L.VTYP,L.VNO, L.LNO , L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CONVERT(VARCHAR,L.EDT,103) EDT,                  
     NARR = ISNULL(L.NARRATION,'') ,                  
 /*CNAR = ISNULL((SELECT NARR FROM LEDGER3 L3 WHERE L3.VTYP = L.VTYP AND L3.VNO = L.VNO AND L3.NARATNO = 0 AND L3.BOOKTYPE = L.BOOKTYPE),'') , */                  
   CNAR = ISNULL(L.NARRATION,'') ,                  
   CLTCODE2 = CLTCODE, ACNAME2 = ACNAME ,
			UPPER(ENTEREDBY) AS 'ENTEREDBY',      UPPER(CHECKEDBY) AS 'CHECKEDBY'                    
    FROM LEDGER L                   
    WHERE   L.VTYP = @VTYP AND L.BOOKTYPE >= @BOOKTYPEFROM AND L.BOOKTYPE <= @BOOKTYPETO 
    AND VDT >= @STARTDATE + ' 00:00:00'                   
    AND VDT <=@ENDDATE + ' 23:59:59'                  
    ORDER BY L.VDT, L.VTYP, L.BOOKTYPE, L.VNO                  
     END                  
   ELSE                   
          /* CONDITIONS ON VDT AND VNO */                  
      BEGIN                   
    SELECT   CLTCODE = ISNULL((CASE WHEN  L.VTYP = 22 OR L.VTYP = 23 OR L.VTYP = 24                   
                    THEN (SELECT PARTY_CODE FROM MARGINLEDGER M WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                   
                     ELSE L.CLTCODE END ),0),                   
     ACNAME= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 22 OR L.VTYP = 23 OR L.VTYP = 24                   
                        THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                   
                       ELSE L.ACNAME END ),0),                    
   ISNULL(L.VAMT,0) VAMT, L.DRCR, L.VTYP,L.VNO, L.LNO , L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CONVERT(VARCHAR,L.EDT,103) EDT,                  
     NARR = ISNULL(L.NARRATION,'') ,                  
     /*CNAR = ISNULL((SELECT NARR FROM LEDGER3 L3 WHERE L3.VTYP = L.VTYP AND L3.VNO = L.VNO AND L3.NARATNO = 0 AND L3.BOOKTYPE = L.BOOKTYPE),'') ,*/                  
   CNAR = ISNULL(L.NARRATION,'') ,                  
   CLTCODE2 = CLTCODE, ACNAME2 = ACNAME  ,
			UPPER(ENTEREDBY) AS 'ENTEREDBY',      UPPER(CHECKEDBY) AS 'CHECKEDBY'                   
     FROM LEDGER L                   
    WHERE  L.VTYP = @VTYP AND L.BOOKTYPE >= @BOOKTYPEFROM AND L.BOOKTYPE <= @BOOKTYPETO                   
    AND L.VNO >= @VNOFROM  AND L.VNO <= @VNOTO                   
/* FOLL CONDITION ADDED BY KALPANA ON 19/09/2002 */                  
  AND VDT >= (CASE WHEN @STARTDATE <> ''  THEN @STARTDATE  + ' 00:00:00'                  
    ELSE 'JAN  1 1900' + ' 00:00:00'         
    END)                   
  AND VDT <= (CASE WHEN @ENDDATE <> ''  THEN @ENDDATE + ' 23:59:59'                  
    ELSE GETDATE()                  
    END)                   
    ORDER BY L.VDT, L.VTYP, L.BOOKTYPE, L.VNO, /*L.DRCR DESC, */L.LNO --DESC                  
      END                    
END                  
                
ELSE IF @FLAG = 2                  
BEGIN   
    
 IF @STARTDATE = ''                   
  BEGIN                  
  /* CONDITIONS OF VNO ONLY */                  
  SELECT   CLTCODE = ISNULL((CASE WHEN A.ACCAT = 14  THEN (SELECT PARTY_CODE FROM MARGINLEDGER M WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                   
          ELSE L.CLTCODE END ),0),                  
     ACNAME = ISNULL((CASE WHEN A.ACCAT = 14   THEN (SELECT ACMAST.ACNAME FROM MARGINLEDGER M ,ACMAST WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND M.PARTY_CODE = ACMAST.CLTCODE)                   
          ELSE L.ACNAME END ),0),                  
     L.VAMT,L.DRCR,L.VTYP,L.VNO,L.LNO,L.BOOKTYPE,VDT = CONVERT(VARCHAR,L.VDT,103),EDT = CONVERT(VARCHAR,L.EDT,103),                  
     NARR = ISNULL(L.NARRATION,'') ,                  
     /* CNAR = ISNULL((SELECT NARR FROM LEDGER3 L3 WHERE L3.VTYP = L.VTYP AND L3.VNO = L.VNO AND L3.NARATNO = 0 AND L3.BOOKTYPE = L.BOOKTYPE),'') ,*/                  
                        CNAR = ISNULL(L.NARRATION,'') ,                  
   CLTCODE2 = L.CLTCODE, ACNAME2 = L.ACNAME ,
			UPPER(ENTEREDBY) AS 'ENTEREDBY',      UPPER(CHECKEDBY) AS 'CHECKEDBY'                    
   FROM LEDGER L, ACMAST A                  
    WHERE L.CLTCODE = A.CLTCODE AND L.VTYP = 24  AND L.BOOKTYPE >= @BOOKTYPEFROM AND L.BOOKTYPE <= @BOOKTYPETO                   
    AND L.VNO >= @VNOFROM  AND L.VNO <= @VNOTO                   
    ORDER BY L.VDT, L.VTYP, L.BOOKTYPE, L.VNO, /*L.DRCR DESC, */L.LNO --DESC                  
  END                   
    ELSE                  
 IF @VNOFROM = ''                   
     BEGIN                  
       print @VNOFROM
	            /* CONDITIONS ON VDT ONLY */                    
    SELECT   CLTCODE = ISNULL((CASE WHEN A.ACCAT = 14 THEN (SELECT PARTY_CODE FROM MARGINLEDGER M WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                   
                    ELSE L.CLTCODE END ),0),                  
     ACNAME = ISNULL((CASE WHEN A.ACCAT = 14  THEN (SELECT ACMAST.ACNAME FROM MARGINLEDGER M ,ACMAST WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND M.PARTY_CODE = ACMAST.CLTCODE)                   
           ELSE L.ACNAME END ),0),                  
    L.VAMT,L.DRCR,L.VTYP,L.VNO,L.LNO,L.BOOKTYPE,VDT = CONVERT(VARCHAR,L.VDT,103),EDT = CONVERT(VARCHAR,L.EDT,103),                  
    NARR = ISNULL(L.NARRATION,'') ,                  
    /*CNAR = ISNULL((SELECT NARR FROM LEDGER3 L3 WHERE L3.VTYP = L.VTYP AND L3.VNO = L.VNO AND L3.NARATNO = 0 AND L3.BOOKTYPE = L.BOOKTYPE),'') ,*/                  
  CNAR = ISNULL(L.NARRATION,'') ,                  
  CLTCODE2 = L.CLTCODE, ACNAME2 = L.ACNAME ,
			UPPER(ENTEREDBY) AS 'ENTEREDBY',      UPPER(CHECKEDBY) AS 'CHECKEDBY'                    
  FROM LEDGER L, ACMAST A                  
    WHERE L.CLTCODE = A.CLTCODE AND L.VTYP = 24  AND L.BOOKTYPE >= @BOOKTYPEFROM AND L.BOOKTYPE <= @BOOKTYPETO AND VDT >= @STARTDATE + ' 00:00:00'                   
    AND VDT <=@ENDDATE + ' 23:59:59'                  
    ORDER BY L.VDT, L.VTYP, L.BOOKTYPE, L.VNO, L.LNO                  
                  
                      
  END                   
  ELSE                   
     
	PRINT 'SELECT'     /* CONDITIONS ON VDT AND VNO */                  
  BEGIN                  
    SELECT   CLTCODE = ISNULL((CASE WHEN A.ACCAT = 14  THEN (SELECT PARTY_CODE FROM MARGINLEDGER M WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                   
          ELSE L.CLTCODE END ),0),                  
     ACNAME = ISNULL((CASE WHEN A.ACCAT = 14   THEN (SELECT ACMAST.ACNAME FROM MARGINLEDGER M ,ACMAST WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND M.PARTY_CODE = ACMAST.CLTCODE)                   
          ELSE L.ACNAME END ),0),                  
     L.VAMT,L.DRCR,L.VTYP,L.VNO,L.LNO,L.BOOKTYPE,VDT = CONVERT(VARCHAR,L.VDT,103),EDT = CONVERT(VARCHAR,L.EDT,103),                  
     NARR = ISNULL(L.NARRATION,'') ,                  
     /*CNAR = ISNULL((SELECT NARR FROM LEDGER3 L3 WHERE L3.VTYP = L.VTYP AND L3.VNO = L.VNO AND L3.NARATNO = 0 AND L3.BOOKTYPE = L.BOOKTYPE),'') ,*/                  
   CNAR = ISNULL(L.NARRATION,'') ,                  
   CLTCODE2 = L.CLTCODE, ACNAME2 = L.ACNAME ,
			UPPER(ENTEREDBY) AS 'ENTEREDBY',      UPPER(CHECKEDBY) AS 'CHECKEDBY'               
   FROM LEDGER L, ACMAST A                  
    WHERE L.CLTCODE = A.CLTCODE AND L.VTYP = 24  AND L.BOOKTYPE >= @BOOKTYPEFROM AND L.BOOKTYPE <= @BOOKTYPETO                   
    AND L.VNO >= @VNOFROM  AND L.VNO <= @VNOTO                   
/* FOLL CONDITION ADDED BY KALPANA ON 19/09/2002 */                  
  AND VDT >= (CASE WHEN @STARTDATE <> ''  THEN @STARTDATE  + ' 00:00:00'                  
    ELSE 'JAN  1 1900' + ' 00:00:00'                  
    END)                  
  AND VDT <= (CASE WHEN @ENDDATE <> ''  THEN @ENDDATE + ' 23:59:59'                  
    ELSE GETDATE()                  
    END)                   
    ORDER BY L.VDT, L.VTYP, L.BOOKTYPE, L.VNO, /*L.DRCR DESC, */L.LNO                  
  END                   
                  
END                  
ELSE IF @FLAG = 3                  
BEGIN                  
   IF @STARTDATE = ''                   
      BEGIN                  
/* CONDITIONS OF VNO ONLY */                  
   SELECT   CLTCODE = ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20  OR L.VTYP = 24                  
                    THEN (SELECT PARTY_CODE FROM MARGINLEDGER M WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                   
                     ELSE L.CLTCODE END ),0),                   
     ACNAME= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                   
                       THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                   
                        ELSE L.ACNAME END ),0),                    
     ISNULL(L.VAMT,0) VAMT, L.DRCR, L.VTYP,L.VNO, L.LNO , L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CONVERT(VARCHAR,L.EDT,103) EDT,                  
     BANK = ISNULL(BNKNAME,''), BRANCH = ISNULL(BRNNAME,'') , ISNULL(DD,'') DD  ,ISNULL(DDNO,'') DDNO, DDDT  =  CONVERT(VARCHAR,DDDT,103)  ,                  
     NARR = ISNULL(L.NARRATION,'') ,                  
     /*CNAR = ISNULL((SELECT NARR FROM LEDGER3 L3 WHERE L3.VTYP = L.VTYP AND L3.VNO = L.VNO AND L3.NARATNO = 0 AND L3.BOOKTYPE = L.BOOKTYPE),'') ,*/                  
   CNAR = ISNULL(L.NARRATION,'') ,                  
   CLTCODE2 = CLTCODE, ACNAME2 = ACNAME  ,
			UPPER(ENTEREDBY) AS 'ENTEREDBY',      UPPER(CHECKEDBY) AS 'CHECKEDBY'                   
    FROM LEDGER L ,LEDGER1 L1                  
    WHERE L1.VTYP = L.VTYP AND L1.VNO = L.VNO AND L1.BOOKTYPE = L.BOOKTYPE AND L.LNO = L1.LNO                  
    AND L.VTYP = @VTYP AND L.BOOKTYPE >= @BOOKTYPEFROM AND L.BOOKTYPE <= @BOOKTYPETO                   
    AND L.VNO >= @VNOFROM  AND L.VNO <= @VNOTO                   
  ORDER BY L.VDT, L.VTYP, L.BOOKTYPE, L.VNO, /*L.DRCR DESC, */L.LNO --DESC                  
      END                  
   ELSE                  
   IF @VNOFROM = ''                   
      BEGIN                  
         /* CONDITIONS ON VDT ONLY */                  
  SELECT   CLTCODE = ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                    
               THEN (SELECT PARTY_CODE FROM MARGINLEDGER M WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                   
                    ELSE L.CLTCODE END ),0),                   
    ACNAME= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                   
                      THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                   
                       ELSE L.ACNAME END ),0),                    
    ISNULL(L.VAMT,0) VAMT, L.DRCR, L.VTYP,L.VNO, L.LNO , L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CONVERT(VARCHAR,L.EDT,103) EDT,                  
    BANK = ISNULL(BNKNAME,''), BRANCH = ISNULL(BRNNAME,'') , ISNULL(DD,'') DD  ,ISNULL(DDNO,'') DDNO, DDDT  =  CONVERT(VARCHAR,DDDT,103)  ,                  
    NARR = ISNULL(L.NARRATION,'') ,                  
     /*CNAR = ISNULL((SELECT NARR FROM LEDGER3 L3 WHERE L3.VTYP = L.VTYP AND L3.VNO = L.VNO AND L3.NARATNO = 0 AND L3.BOOKTYPE = L.BOOKTYPE),''), */                  
  CNAR = ISNULL(L.NARRATION,'') ,                  
  CLTCODE2 = CLTCODE, ACNAME2 = ACNAME  ,
			UPPER(ENTEREDBY) AS 'ENTEREDBY',      UPPER(CHECKEDBY) AS 'CHECKEDBY'                   
    FROM LEDGER L ,LEDGER1 L1                 
   WHERE   L.VTYP = @VTYP AND L.BOOKTYPE >= @BOOKTYPEFROM AND L.BOOKTYPE <= @BOOKTYPETO AND VDT >= @STARTDATE + ' 00:00:00'                  
   AND L1.VTYP = L.VTYP AND L1.VNO = L.VNO AND L1.BOOKTYPE = L.BOOKTYPE  AND L.LNO = L1.LNO                  
    AND VDT <=@ENDDATE + ' 23:59:59'                  
    ORDER BY L.VDT, L.VTYP, L.BOOKTYPE, L.VNO, L.LNO                  
                  
      END                  
   ELSE                  
      BEGIN                  
         /* CONDITIONS ON VDT AND VNO */                  
   SELECT   CLTCODE = ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20  OR L.VTYP = 24                   
                 THEN (SELECT PARTY_CODE FROM MARGINLEDGER M WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND BOOKTYPE = L.BOOKTYPE)                   
                     ELSE L.CLTCODE END ),0),                   
     ACNAME= ISNULL((CASE WHEN L.VTYP = 19 OR L.VTYP = 20 OR L.VTYP = 24                   
                       THEN (SELECT ACNAME FROM MARGINLEDGER M , ACMAST A WHERE VTYP = L.VTYP AND M.VNO = L.VNO AND LNO = L.LNO AND M.BOOKTYPE = L.BOOKTYPE AND PARTY_CODE = CLTCODE)                   
                        ELSE L.ACNAME END ),0),                    
 ISNULL(L.VAMT,0) VAMT, L.DRCR, L.VTYP,L.VNO, L.LNO , L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CONVERT(VARCHAR,L.EDT,103) EDT,                  
     BANK = ISNULL(BNKNAME,''), BRANCH = ISNULL(BRNNAME,'') , ISNULL(DD,'') DD  ,ISNULL(DDNO,'') DDNO, DDDT  =  CONVERT(VARCHAR,DDDT,103)  ,                  
     NARR = ISNULL(L.NARRATION,'') ,                  
     /*CNAR = ISNULL((SELECT NARR FROM LEDGER3 L3 WHERE L3.VTYP = L.VTYP AND L3.VNO = L.VNO AND L3.NARATNO = 0 AND L3.BOOKTYPE = L.BOOKTYPE),'') ,*/                  
   CNAR = ISNULL(L.NARRATION,'') ,                  
   CLTCODE2 = CLTCODE, ACNAME2 = ACNAME ,
			UPPER(ENTEREDBY) AS 'ENTEREDBY',      UPPER(CHECKEDBY) AS 'CHECKEDBY'                    
  FROM LEDGER L ,LEDGER1 L1                  
    WHERE L1.VTYP = L.VTYP AND L1.VNO = L.VNO AND L1.BOOKTYPE = L.BOOKTYPE   AND L.LNO = L1.LNO                  
    AND L.VTYP = @VTYP AND L.BOOKTYPE >= @BOOKTYPEFROM AND L.BOOKTYPE <= @BOOKTYPETO                   
    AND L.VNO >= @VNOFROM  AND L.VNO <= @VNOTO                   
/* FOLL CONDITION ADDED BY KALPANA ON 19/09/2002 */                  
  AND VDT >= (CASE WHEN @STARTDATE <> ''  THEN @STARTDATE  + ' 00:00:00'                  
    ELSE 'JAN  1 1900' + ' 00:00:00'                  
    END)                   
  AND VDT <= (CASE WHEN @ENDDATE <> ''  THEN @ENDDATE + ' 23:59:59'                  
    ELSE GETDATE()                  
    END)                   
    ORDER BY L.VDT, L.VTYP, L.BOOKTYPE, L.VNO, /*L.DRCR DESC, */L.LNO --DESC                  
      END                 
END                

IF @PDFFLAG = 'Y'
BEGIN
	SELECT VDESC FROM VMAST WHERE VTYPE=@VTYP
END

GO
