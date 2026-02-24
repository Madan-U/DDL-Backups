-- Object: PROCEDURE dbo.UPDATE_EDT_WITH_RELDT
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

      
      
CREATE PROC [dbo].[UPDATE_EDT_WITH_RELDT]        
      
AS      
DECLARE @COUNT_NSE INT      
DECLARE @COUNT_BSE INT      
DECLARE @COUNT_NSEFO INT      
DECLARE @COUNT_NSX INT      
DECLARE @COUNT_MCX INT      
DECLARE @COUNT_NCX INT      
DECLARE @COUNT_BSX INT      
DECLARE @COUNT_BSEFO INT      
DECLARE @COUNT_MCD INT      
      
 SELECT @COUNT_NSE =count(1)  FROM LEDGER L, LEDGER1 L1      
 WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
 AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
 AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
 AND L.VTYP=L1.VTYP AND reldt <> ''      
 AND L.EDT >='2020-11-30'      
IF @COUNT_NSE = 0       
 BEGIN       
 PRINT 'NSE HAS NO COUNT'      
 END      
      
IF @COUNT_NSE > 0 OR @COUNT_NSE < 5000      
 BEGIN       
  UPDATE L SET EDT = reldt   FROM LEDGER L, LEDGER1 L1      
  WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
  AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
  AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
  AND L.VTYP=L1.VTYP AND reldt  <> ''      
  AND L.EDT >='jan 31 2049'      
 END       
      
/*      
      
----------------------------BSE-------------------      
       
 SELECT @COUNT_BSE =count(1)  FROM [AngelBSECM].ACCOUNT_AB.DBO.LEDGER L, [AngelBSECM].ACCOUNT_AB.DBO.LEDGER1 L1      
 WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
 AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
 AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
 AND L.VTYP=L1.VTYP AND reldt <> ''      
 AND L.EDT >='2020-11-30'      
IF @COUNT_BSE = 0       
 BEGIN       
 PRINT 'BSE HAS NO COUNT'      
 END      
 PRINT @COUNT_BSE      
      
IF @COUNT_BSE > 0 OR @COUNT_BSE < 5000      
 BEGIN       
  UPDATE L SET EDT = reldt   FROM [AngelBSECM].ACCOUNT_AB.DBO.LEDGER L, [AngelBSECM].ACCOUNT_AB.DBO.LEDGER1 L1      
  WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
  AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
  AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
  AND L.VTYP=L1.VTYP AND reldt  <> ''      
  AND L.EDT >='jan 31 2049'      
 END       
----------------------------NSEFO-------------------      
       
 SELECT @COUNT_NSEFO =count(1)  FROM [AngelFO].ACCOUNTFO.DBO.LEDGER L, [AngelFO].ACCOUNTFO.DBO.LEDGER1 L1      
 WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
 AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
 AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
 AND L.VTYP=L1.VTYP AND reldt <> ''      
 AND L.EDT >='2020-11-30'      
IF @COUNT_NSEFO = 0       
 BEGIN       
  PRINT 'NSEFO HAS NO COUNT'      
 END      
 PRINT @COUNT_NSEFO      
      
IF @COUNT_NSEFO > 0 OR @COUNT_NSEFO < 5000      
 BEGIN       
  UPDATE L SET EDT = reldt   FROM [AngelFO].ACCOUNTFO.DBO.LEDGER L, [AngelFO].ACCOUNTFO.DBO.LEDGER1 L1      
  WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
  AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
  AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
  AND L.VTYP=L1.VTYP AND reldt  <> ''      
  AND L.EDT >='jan 31 2049'      
 END        
----------------------------NSX-------------------       
 SELECT @COUNT_NSX =count(1)  FROM [AngelFO].ACCOUNTCURFO.DBO.LEDGER L, [AngelFO].ACCOUNTCURFO.DBO.LEDGER1 L1      
 WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
 AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
 AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
 AND L.VTYP=L1.VTYP AND reldt <> ''      
 AND L.EDT >='2020-11-30'      
IF @COUNT_NSX = 0       
 BEGIN       
 PRINT 'NSX HAS NO COUNT'      
 END      
 PRINT @COUNT_NSX      
      
IF @COUNT_NSX > 0 OR @COUNT_NSX < 5000      
 BEGIN       
  UPDATE L SET EDT = reldt   FROM [AngelFO].ACCOUNTCURFO.DBO.LEDGER L, [AngelFO].ACCOUNTCURFO.DBO.LEDGER1 L1      
  WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
  AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
  AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
  AND L.VTYP=L1.VTYP AND reldt  <> ''      
  AND L.EDT >='jan 31 2049'      
 END        
----------------------------MCX-------------------      
 SELECT @COUNT_MCX =count(1)  FROM [AngelCommodity].ACCOUNTMCDX.DBO.LEDGER L, [AngelCommodity].ACCOUNTMCDX.DBO.LEDGER1 L1      
 WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
 AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
 AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
 AND L.VTYP=L1.VTYP AND reldt <> ''      
 AND L.EDT >='2020-11-30'      
IF @COUNT_MCX = 0       
 BEGIN       
 PRINT 'MCX HAS NO COUNT'      
 END      
 PRINT @COUNT_MCX      
      
IF @COUNT_MCX > 0 OR @COUNT_MCX < 5000      
 BEGIN       
  UPDATE L SET EDT = reldt   FROM [AngelCommodity].ACCOUNTMCDX.DBO.LEDGER L, [AngelCommodity].ACCOUNTMCDX.DBO.LEDGER1 L1      
  WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
  AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
  AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
  AND L.VTYP=L1.VTYP AND reldt  <> ''      
  AND L.EDT >='jan 31 2049'      
 END       
      
----------------------------NCX-------------------      
 SELECT @COUNT_NCX =count(1)  FROM [AngelCommodity].ACCOUNTNCDX.DBO.LEDGER L, [AngelCommodity].ACCOUNTNCDX.DBO.LEDGER1 L1      
 WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
 AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
 AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
 AND L.VTYP=L1.VTYP AND reldt <> ''      
 AND L.EDT >='2020-11-30'      
IF @COUNT_NCX = 0       
 BEGIN       
 PRINT 'NCX HAS NO COUNT'      
 END      
 PRINT @COUNT_NCX      
      
IF @COUNT_NCX > 0 OR @COUNT_NCX < 5000      
 BEGIN       
  UPDATE L SET EDT = reldt   FROM [AngelCommodity].ACCOUNTNCDX.DBO.LEDGER L, [AngelCommodity].ACCOUNTNCDX.DBO.LEDGER1 L1      
  WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
  AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
  AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
  AND L.VTYP=L1.VTYP AND reldt  <> ''      
  AND L.EDT >='jan 31 2049'      
 END       
      
----------------------------BSX-------------------      
 SELECT @COUNT_BSE =count(1)  FROM [AngelCommodity].ACCOUNTCURBFO.DBO.LEDGER L, [AngelCommodity].ACCOUNTCURBFO.DBO.LEDGER1 L1      
 WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
 AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
 AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
 AND L.VTYP=L1.VTYP AND reldt <> ''      
 AND L.EDT >='2020-11-30'      
IF @COUNT_BSE = 0       
 BEGIN       
 PRINT 'BSX HAS NO COUNT'      
 END      
 PRINT @COUNT_BSE      
      
IF @COUNT_BSE > 0 OR @COUNT_BSE < 5000      
 BEGIN       
  UPDATE L SET EDT = reldt   FROM [AngelCommodity].ACCOUNTCURBFO.DBO.LEDGER L, [AngelCommodity].ACCOUNTCURBFO.DBO.LEDGER1 L1      
  WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
  AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
  AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
  AND L.VTYP=L1.VTYP AND reldt  <> ''      
  AND L.EDT >='jan 31 2049'      
 END       
      
----------------------------MCD-------------------      
 SELECT @COUNT_MCD =count(1)  FROM [AngelCommodity].ACCOUNTMCDXCDS.DBO.LEDGER L, [AngelCommodity].ACCOUNTMCDXCDS.DBO.LEDGER1 L1      
 WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
 AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
 AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
 AND L.VTYP=L1.VTYP AND reldt <> ''      
 AND L.EDT >='2020-11-30'      
IF @COUNT_MCD = 0       
 BEGIN       
  PRINT 'MCD HAS NO COUNT'      
 END      
 PRINT @COUNT_MCD      
      
IF @COUNT_MCD > 0 OR @COUNT_MCD < 5000      
 BEGIN       
  UPDATE L SET EDT = reldt   FROM [AngelCommodity].ACCOUNTMCDXCDS.DBO.LEDGER L, [AngelCommodity].ACCOUNTMCDXCDS.DBO.LEDGER1 L1      
  WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
  AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
  AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
  AND L.VTYP=L1.VTYP AND reldt  <> ''      
  AND L.EDT >='jan 31 2049'      
 END       
----------------------------BSEFO-------------------      
 SELECT @COUNT_BSEFO =count(1)  FROM [AngelCommodity].ACCOUNTBFO.DBO.LEDGER L, [AngelCommodity].ACCOUNTBFO.DBO.LEDGER1 L1      
 WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
 AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
 AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
 AND L.VTYP=L1.VTYP AND reldt <> ''      
 AND L.EDT >='2020-11-30'      
IF @COUNT_BSEFO = 0       
 BEGIN       
 PRINT 'BSEFO HAS NO COUNT'      
 END      
 PRINT @COUNT_BSEFO      
      
IF @COUNT_BSEFO > 0 OR @COUNT_BSEFO < 5000      
 BEGIN       
  UPDATE L SET EDT = reldt   FROM [AngelCommodity].ACCOUNTBFO.DBO.LEDGER L, [AngelCommodity].ACCOUNTBFO.DBO.LEDGER1 L1      
  WHERE VDT >='2019-04-01' AND  L.VNO=L1.VNO      
  AND ENTEREDBY NOT IN ('B_TPR','B_ONLINE','ANIMESH','VIRTUAL')      
  AND L.VTYP=2 AND L.BOOKTYPE =L1.BookType      
  AND L.VTYP=L1.VTYP AND reldt  <> ''      
  AND L.EDT >='jan 31 2049'      
 END       
      
      
      
      
 */

GO
