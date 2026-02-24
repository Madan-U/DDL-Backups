-- Object: PROCEDURE dbo.INSDELEARLYPAYINUPDATE_OLD
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC INSDELEARLYPAYINUPDATE_OLD (@REFNO INT) AS    
DECLARE @SNO NUMERIC(18,0),    
@SETT_NO VARCHAR(7),    
@SETT_TYPE VARCHAR(2),    
@CERTNO VARCHAR(12),    
@FROMNO VARCHAR(16),    
@QTY INT,    
@DPID VARCHAR(8),    
@CLTDPID VARCHAR(16),    
@DELCUR CURSOR,    
@RECCUR CURSOR,    
@PARTY_CODE VARCHAR(10),    
@DELQTY INT,    
@DELSNO NUMERIC(18,0),    
@EXCHANGE VARCHAR(3)    
    
SET @DELCUR = CURSOR FOR    
 SELECT SNO, SETT_NO, SETT_TYPE, CERTNO, FROMNO, QTY, DPID, CLTDPID FROM DELTRANSPI    
 WHERE CLTDPID IN (SELECT DPCLTNO FROM DELIVERYDP WHERE DPTYPE = 'CDSL' )    
 AND PARTY_CODE = 'PARTY' AND REASON = 'Early Pay-In'  
 ORDER BY SNO, SETT_NO, SETT_TYPE, CERTNO, FROMNO    
OPEN @DELCUR    
FETCH FROM @DELCUR INTO @SNO, @SETT_NO, @SETT_TYPE, @CERTNO, @FROMNO, @QTY, @DPID, @CLTDPID    
WHILE @@FETCH_STATUS = 0    
BEGIN     
 SET @RECCUR = CURSOR FOR    
  SELECT SNO, PARTY_CODE, QTY, EXCHANGE = 'NSE' FROM MSAJAG.DBO.DELTRANS    
  WHERE ISETT_NO = @SETT_NO AND ISETT_TYPE = @SETT_TYPE    
  AND CERTNO = @CERTNO AND FILLER2 = 1 AND DRCR = 'D'    
  AND DELIVERED = 'G' AND TRTYPE = 1000    
  AND ((DPID = @DPID AND CLTDPID = @CLTDPID) OR ( BDPID = @DPID AND BCLTDPID = @CLTDPID))  
  AND HOLDERNAME = 'Early Payin'  
  UNION    
  SELECT SNO, PARTY_CODE, QTY, EXCHANGE = 'BSE' FROM BSEDB.DBO.DELTRANS    
  WHERE ISETT_NO = @SETT_NO AND ISETT_TYPE = @SETT_TYPE    
  AND CERTNO = @CERTNO AND FILLER2 = 1 AND DRCR = 'D'    
  AND DELIVERED = 'G' AND TRTYPE = 1000    
  AND ((DPID = @DPID AND CLTDPID = @CLTDPID) OR ( BDPID = @DPID AND BCLTDPID = @CLTDPID))  
  AND HOLDERNAME = 'Early Payin'    
  ORDER BY PARTY_CODE    
 OPEN @RECCUR    
 FETCH FROM @RECCUR INTO @DELSNO, @PARTY_CODE, @DELQTY, @EXCHANGE    
 WHILE @@FETCH_STATUS = 0 AND @QTY > 0    
 BEGIN    
  IF @DELQTY <= @QTY    
  BEGIN    
   IF @EXCHANGE = 'NSE'     
    UPDATE MSAJAG.DBO.DELTRANS SET DELIVERED = 'D'    
    WHERE ISETT_NO = @SETT_NO AND ISETT_TYPE = @SETT_TYPE    
    AND CERTNO = @CERTNO AND FILLER2 = 1 AND DRCR = 'D'    
    AND DELIVERED = 'G' AND TRTYPE = 1000    
    AND ((DPID = @DPID AND CLTDPID = @CLTDPID) OR ( BDPID = @DPID AND BCLTDPID = @CLTDPID))  
    AND HOLDERNAME = 'Early Payin'  
    AND PARTY_CODE = @PARTY_CODE    
    AND SNO = @DELSNO    
   ELSE    
    UPDATE BSEDB.DBO.DELTRANS SET DELIVERED = 'D'    
    WHERE ISETT_NO = @SETT_NO AND ISETT_TYPE = @SETT_TYPE    
    AND CERTNO = @CERTNO AND FILLER2 = 1 AND DRCR = 'D'    
    AND DELIVERED = 'G' AND TRTYPE = 1000    
    AND ((DPID = @DPID AND CLTDPID = @CLTDPID) OR ( BDPID = @DPID AND BCLTDPID = @CLTDPID))  
    AND HOLDERNAME = 'Early Payin'  
    AND PARTY_CODE = @PARTY_CODE    
    AND SNO = @DELSNO    
       
   IF @DELQTY = @QTY     
   BEGIN    
    UPDATE DELTRANSPI SET PARTY_CODE = @PARTY_CODE    
    WHERE SNO = @SNO    
    SET @QTY = 0    
   END    
   ELSE      
   BEGIN    
    INSERT INTO DELTRANSPI    
    SELECT Sett_No,Sett_Type,Refno,Tcode,Trtype,@Party_Code,Scrip_Cd,Series,    
    Qty = @DELQTY,Fromno,Tono,Certno,Foliono,Holdername,Reason,Drcr,Delivered,Orgqty,Dptype,    
    Dpid,Cltdpid,Branchcd,Partipantcode,Slipno,Batchno,Isett_No,Isett_Type,Sharetype,    
    Transdate,Filler1,Filler2,Filler3,Bdptype,Bdpid,Bcltdpid,Filler4,Filler5    
    FROM DELTRANSPI     
    WHERE SNO = @SNO    
    
    UPDATE DELTRANSPI SET QTY = @QTY - @DELQTY    
    WHERE SNO = @SNO    
    SET @QTY = @QTY - @DELQTY    
   END     
  END    
  ELSE    
  BEGIN    
   UPDATE DELTRANSPI SET PARTY_CODE = @PARTY_CODE    
   WHERE SNO = @SNO    
    
   IF @EXCHANGE = 'NSE'     
   BEGIN     
    INSERT INTO MSAJAG.DBO.DELTRANS    
    SELECT Sett_No,Sett_Type,Refno,Tcode,Trtype,@Party_Code,Scrip_Cd,Series,    
    Qty = @QTY,Fromno,Tono,Certno,Foliono,Holdername,Reason,Drcr,'D',Orgqty,Dptype,    
    Dpid,Cltdpid,Branchcd,Partipantcode,Slipno,Batchno,Isett_No,Isett_Type,Sharetype,    
    Transdate,Filler1,Filler2,Filler3,Bdptype,Bdpid,Bcltdpid,Filler4,Filler5    
    FROM MSAJAG.DBO.DELTRANS    
    WHERE SNO = @DELSNO    
     
    UPDATE MSAJAG.DBO.DELTRANS SET QTY = @DELQTY - @QTY     
    WHERE SNO = @DELSNO    
   END    
   ELSE    
   BEGIN     
    INSERT INTO BSEDB.DBO.DELTRANS    
    SELECT Sett_No,Sett_Type,Refno,Tcode,Trtype,@Party_Code,Scrip_Cd,Series,    
    Qty = @QTY,Fromno,Tono,Certno,Foliono,Holdername,Reason,Drcr,'D',Orgqty,Dptype,    
    Dpid,Cltdpid,Branchcd,Partipantcode,Slipno,Batchno,Isett_No,Isett_Type,Sharetype,    
    Transdate,Filler1,Filler2,Filler3,Bdptype,Bdpid,Bcltdpid,Filler4,Filler5    
    FROM BSEDB.DBO.DELTRANS    
    WHERE SNO = @DELSNO    
     
    UPDATE BSEDB.DBO.DELTRANS SET QTY = @DELQTY - @QTY     
    WHERE SNO = @DELSNO    
   END          
   SET @QTY = 0    
  END    
  FETCH NEXT FROM @RECCUR INTO @DELSNO, @PARTY_CODE, @DELQTY, @EXCHANGE    
 END    
 CLOSE @RECCUR    
 DEALLOCATE @RECCUR    
 FETCH NEXT FROM @DELCUR INTO @SNO, @SETT_NO, @SETT_TYPE, @CERTNO, @FROMNO, @QTY, @DPID, @CLTDPID    
END    
CLOSE @DELCUR    
DEALLOCATE @DELCUR

GO
