-- Object: PROCEDURE dbo.SP_VOUCHERREPORT_NEW
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.SP_VOUCHERREPORT_NEW    Script Date: 9/17/2007 10:25:06 AM ******/  
  
/****** RECREATED BY BHARAT ON SEP 11 2007 ******/   
/****** Execute SP_VOUCHERREPORT_NEW '2','Jan  1 2008', 'Apr 16 2008','BANK01','ZZZZZZZZZZZZ', '0A146','0A146','broker', 'broker','VOUDT','', '','',100000,  '',''  ****/  
  
CREATE PROCEDURE SP_VOUCHERREPORT_NEW    
(    
 @VNOTYPE VARCHAR(2),     
 @FROMDATE VARCHAR(11),     
 @TODATE VARCHAR(11),     
 @FROMBANKCD VARCHAR(10),     
 @TOBANKCD VARCHAR(10),     
 @FROMCLIENTID VARCHAR(10),     
 @TOCLIENTID VARCHAR(10),     
 @STATUSID VARCHAR(12),     
 @STATUSNAME VARCHAR(12),     
 @DATETYPE VARCHAR(6),    
 @FROMVAMT VARCHAR(20),    
 @TOVAMT VARCHAR(20),    
 @CHQNUM  VARCHAR(15),    
 @FROMVNO VARCHAR(12),    
 @TOVNO VARCHAR(12)    
)    
AS  
DECLARE @@SQL AS VARCHAR(1000)  
  
PRINT UPPER(@STATUSID)  
  
IF UPPER(@STATUSID) = 'BROKER'  
BEGIN  
  
  
 IF @VNOTYPE = '1' OR @VNOTYPE = '4'  
 -- RECEIPT CASH   OR PAYMENT CASH  
  BEGIN  
  
  SET @@SQL =" "  
  SET @@SQL = @@SQL + " SELECT L.VTYP, L.CLTCODE, L.VNO, CONVERT(VARCHAR(11),L.VDT,109) VDT,L.ACNAME, L.DRCR, L.VAMT, L.NARRATION "  
  SET @@SQL = @@SQL + " FROM LEDGER L INNER JOIN "  
  SET @@SQL = @@SQL + " (SELECT VNO, CLTCODE ACNAME, VTYP, BOOKTYPE FROM LEDGER WHERE VTYP = " + @VNOTYPE + " AND "  
            
          IF @VNOTYPE = '1'  
          BEGIN        
     SET @@SQL = @@SQL + " DRCR = 'D' "  
          END   
          ELSE IF @VNOTYPE = '4'  
          BEGIN     
     SET @@SQL = @@SQL + " DRCR = 'C' "   
          END   
       
          IF @FROMBANKCD <> ''  
          BEGIN  
           SET @@SQL = @@SQL + " AND (CLTCODE > = '" + @FROMBANKCD + "' AND CLTCODE < = '" + @TOBANKCD + "') "   
          END  
  
  SET @@SQL = @@SQL + " ) D ON L.VNO = D.VNO AND L.VTYP = D.VTYP AND L.BOOKTYPE = D.BOOKTYPE "  
  SET @@SQL = @@SQL + " WHERE L.VNO <> '' AND L.VTYP = " + @VNOTYPE + " AND "  
    
  IF @VNOTYPE = '1'  
  BEGIN  
  SET @@SQL = @@SQL + " L.DRCR = 'C' "   
  END  
  ELSE IF @VNOTYPE = '4'  
  BEGIN  
  SET @@SQL = @@SQL + " L.DRCR = 'D' "   
  END   
     
  SET @@SQL = @@SQL + " AND L.VDT > = '" + @FROMDATE + " 00:00:00' AND L.VDT < = '" + @TODATE + " 23:59:59' "   
    
  IF @FROMVAMT <> '' OR @TOVAMT <> ''  
  BEGIN   
  SET @@SQL = @@SQL + " AND L.VAMT BETWEEN " + @FROMVAMT + " AND " + @TOVAMT + " "  
  END  
  
  IF @FROMVNO <> '' OR @TOVNO <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND L.VNO BETWEEN '" + @FROMVNO + "' AND '" + @TOVNO + "' "  
  END   
    
  IF @FROMCLIENTID <> '' OR @TOCLIENTID <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND L.CLTCODE BETWEEN '" + @FROMCLIENTID + "' AND '" + @TOCLIENTID + "' "  
  END  
  
  SET @@SQL = @@SQL + " ORDER BY L.VNO, L.VDT, L.DRCR DESC "   
 END  
   
 ELSE IF @VNOTYPE = '2' OR @VNOTYPE = '3' OR @VNOTYPE = '5' OR @VNOTYPE = '16' OR @VNOTYPE = '17'    
      -- RECEIPT BANK   OR PAYMENT BANK   OR CONTRY ENTRY   OR CHEQUE CANCEL   OR CHEQUE RETURN  
 BEGIN  
  SET @@SQL = " "  
  SET @@SQL = @@SQL + " SELECT L1.DDNO, L.VTYP, L.CLTCODE, L.VNO, L.ACNAME, L.DRCR, L.VAMT, L.NARRATION, "  
    
  IF UPPER(@DATETYPE) = 'VOUDT'  
  BEGIN   
  SET @@SQL = @@SQL + " CONVERT(VARCHAR(11),L.VDT,109) VDT, "  
  END  
  ELSE   
  BEGIN  
  SET @@SQL = @@SQL + " CONVERT(VARCHAR(11),L.PDT,109) PDT, "  
  END  
  
  SET @@SQL = @@SQL + " CONVERT(VARCHAR(11),L1.DDDT,109) CDT, L.CLTCODE AS ctl FROM LEDGER L INNER JOIN "  
  SET @@SQL = @@SQL + " (SELECT VNO, CLTCODE ACNAME, VTYP, BOOKTYPE, LNO FROM LEDGER WHERE VTYP = " + @VNOTYPE + " "  
          IF @VNOTYPE = '2' OR @VNOTYPE = '16'    
          BEGIN        
     SET @@SQL = @@SQL + " AND DRCR = 'D' "  
          END   
          ELSE IF @VNOTYPE = '3' OR @VNOTYPE = '17'  
          BEGIN     
     SET @@SQL = @@SQL + " AND DRCR = 'C' "   
          END   
            
          IF @FROMBANKCD <> ''  
          BEGIN  
           SET @@SQL = @@SQL + " AND (CLTCODE > = '" + @FROMBANKCD + "' AND CLTCODE < = '" + @TOBANKCD + "') "   
          END  
  
  SET @@SQL = @@SQL + " ) D ON L.VNO = D.VNO AND L.VTYP = D.VTYP AND L.BOOKTYPE = D.BOOKTYPE "  
    
  IF @VNOTYPE = '5'  
  BEGIN   
  SET @@SQL = @@SQL + " AND L.LNO = D.LNO "    
  END   
  SET @@SQL = @@SQL + " INNER JOIN LEDGER1 L1 ON L.VNO = L1.VNO AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE "  
     
  IF @VNOTYPE = '5'  
  BEGIN  
  SET @@SQL  = @@SQL + " AND L1.LNO = L.LNO "  
  END  
    
  SET @@SQL = @@SQL + " WHERE L.VNO <> '' AND L.VTYP = " + @VNOTYPE + " "  
    
  IF @VNOTYPE = '2' OR @VNOTYPE = '16'  
  BEGIN  
  SET @@SQL = @@SQL + " AND L.DRCR = 'C' "   
  END  
  ELSE IF @VNOTYPE = '3' OR @VNOTYPE = '17'  
  BEGIN  
  SET @@SQL = @@SQL + " AND L.DRCR = 'D' "   
  END   
    
  IF UPPER(@DATETYPE) = 'VOUDT'    
  BEGIN   
  SET @@SQL = @@SQL + " AND L.VDT > = '" + @FROMDATE + " 00:00:00' AND L.VDT < = '" + @TODATE + " 23:59:59' "   
  END  
  ELSE  
  BEGIN  
  SET @@SQL = @@SQL + " AND L.PDT > = '" + @FROMDATE + " 00:00:00' AND L.PDT < = '" + @TODATE + " 23:59:59' "   
  END  
    
  IF @CHQNUM <> ''      
       BEGIN  
  SET @@SQL = @@SQL + " AND L1.DDNO = '" + @CHQNUM + "' "     
      END  
    
  IF @FROMVAMT <> '' OR @TOVAMT <> ''  
  BEGIN   
  SET @@SQL = @@SQL + " AND L.VAMT BETWEEN " + @FROMVAMT + " AND " + @TOVAMT + " "  
  END  
  
  IF @FROMVNO <> '' OR @TOVNO <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND L.VNO BETWEEN '" + @FROMVNO + "' AND '" + @TOVNO + "' "  
  END   
    
  IF @FROMCLIENTID <> '' OR @TOCLIENTID <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND L.CLTCODE BETWEEN '" + @FROMCLIENTID + "' AND '" + @TOCLIENTID + "' "  
  END  
 END  
  
 ELSE IF @VNOTYPE = '6' OR @VNOTYPE = '7' OR @VNOTYPE = '8'  
        --   DEBIT NOTE        OR CREDIT NOTE      OR JOURNAL VOUCHER  
 BEGIN  
  SET @@SQL = " "  
  SET @@SQL = @@SQL + " SELECT L.VTYP, L.CLTCODE, L.VNO, CONVERT(VARCHAR(11), L.VDT, 109) VDT, L.ACNAME, L.DRCR, "  
   SET @@SQL = @@SQL + " L.VAMT, L.NARRATION, CONVERT(VARCHAR(11), L.CDT, 109) CDT  "  
   SET @@SQL = @@SQL + " FROM LEDGER L "  
   SET @@SQL = @@SQL + " WHERE L.VNO <> '' AND L.VTYP = " + @VNOTYPE + " "  
  SET @@SQL = @@SQL + " AND L.VDT > = '" + @FROMDATE + " 00:00:00' AND L.VDT < = '" + @TODATE + " 23:59:59' "    
    
  IF @FROMVAMT <> '' OR @TOVAMT <> ''  
  BEGIN   
  SET @@SQL = @@SQL + " AND L.VAMT BETWEEN " + @FROMVAMT + " AND " + @TOVAMT + " "  
  END  
  
  IF @FROMVNO <> '' OR @TOVNO <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND L.VNO BETWEEN '" + @FROMVNO + "' AND '" + @TOVNO + "' "  
  END   
  
  IF @FROMCLIENTID <> '' OR @TOCLIENTID <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND L.CLTCODE BETWEEN '" + @FROMCLIENTID + "' AND '" + @TOCLIENTID + "' "  
  END  
    
  SET @@SQL = @@SQL + " ORDER BY L.VNO, L.VDT, L.DRCR DESC "   
 END     
   
 ELSE IF @VNOTYPE = '19' OR @VNOTYPE = '20'  
 --MARGIN BANK RECEIVED  OR MARGIN BANK PAYMENT  
 BEGIN   
  SET @@SQL = " "  
  SET @@SQL = @@SQL + " SELECT ML.VNO, ML.VTYP, ML.BOOKTYPE, ML.PARTY_CODE CLTCODE, L.NARRATION, "  
  SET @@SQL = @@SQL + " CONVERT(VARCHAR(11),ML.VDT, 109) VDT, A.ACNAME, ML.AMOUNT VAMT, ML.DRCR, L1.DDNO, "  
  SET @@SQL = @@SQL + " CONVERT(VARCHAR(11), L1.DDDT, 109) CDT "   
  SET @@SQL = @@SQL + " FROM LEDGER L INNER JOIN MARGINLEDGER ML ON L.VNO = ML.VNO AND L.VTYP = ML.VTYP AND"  
  SET @@SQL = @@SQL + " L.BOOKTYPE = ML.BOOKTYPE INNER JOIN LEDGER1 L1 ON ML.VNO = L1.VNO AND ML.VTYP = L1.VTYP AND "  
  SET @@SQL = @@SQL + " ML.BOOKTYPE = L1.BOOKTYPE INNER JOIN ACMAST A ON ML.PARTY_CODE = A.CLTCODE "  
  SET @@SQL = @@SQL + " WHERE ML.VTYP = " + @VNOTYPE + " AND ML.VDT > = '" + @FROMDATE + " 00:00:00' AND ML.VDT < = '" + @TODATE + " 23:59:59' "   
  
  IF @CHQNUM <> ''  
  BEGIN   
  SET @@SQL = @@SQL + " AND L1.DDNO = '" + @CHQNUM + "' "  
  END   
    
  IF @FROMVAMT <> '' OR @TOVAMT <> ''  
  BEGIN   
  SET @@SQL = @@SQL + " AND ML.VAMT BETWEEN " + @FROMVAMT + " AND " + @TOVAMT + "  "  
  END    
      
  IF @FROMVNO <> '' OR @TOVNO <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND ML.VNO BETWEEN '" + @FROMVNO + "' AND '" + @TOVNO + "' "  
  END   
  
  IF @FROMBANKCD <> ''  
  BEGIN    
   SET @@SQL = @@SQL + " AND (ML.PARTY_CODE > = '" + @FROMBANKCD + "' AND ML.PARTY_CODE < = '" + @TOBANKCD + "') "  
  END   
    
  IF @FROMCLIENTID <> '' OR @TOCLIENTID <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND ML.PARTY_CODE BETWEEN '" + @FROMCLIENTID + "' AND '" + @TOCLIENTID + "' "  
  END  
    
  SET @@SQL = @@SQL + " ORDER BY ML.VNO, ML.VDT, ML.DRCR DESC "       
 END   
   
 ELSE IF @VNOTYPE = '22' OR @VNOTYPE = '23' OR @VNOTYPE = '24'  
 --MARGIN CASH RECEIVED  OR MARGIN CASH PAYMENT  
 BEGIN  
  SET @@SQL = " "  
  SET @@SQL = @@SQL + " SELECT ML.VNO, ML.VTYP, ML.BOOKTYPE, ML.PARTY_CODE CLTCODE, L.NARRATION, "  
  SET @@SQL = @@SQL + " CONVERT(VARCHAR(11), ML.VDT, 109) VDT, A.ACNAME, ML.AMOUNT VAMT, ML.DRCR "  
   SET @@SQL = @@SQL + " FROM LEDGER L INNER JOIN MARGINLEDGER ML ON L.VNO = ML.VNO AND L.VTYP = ML.VTYP AND "   
  SET @@SQL = @@SQL + " L.BOOKTYPE = ML.BOOKTYPE INNER JOIN ACMAST A ON ML.PARTY_CODE = A.CLTCODE "  
  SET @@SQL = @@SQL + " WHERE ML.VTYP = " + @VNOTYPE + " "  
  
  IF @FROMVAMT <> '' OR @TOVAMT <> ''  
  BEGIN   
  SET @@SQL = @@SQL + " AND ML.VAMT BETWEEN " + @FROMVAMT + " AND " + @TOVAMT + " "  
  END    
      
  IF @FROMVNO <> '' OR @TOVNO <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND ML.VNO BETWEEN '" + @FROMVNO + "' AND '" + @TOVNO + "' "  
  END   
  
  IF @FROMBANKCD <> ''  
  BEGIN    
   SET @@SQL = @@SQL + " AND (ML.PARTY_CODE > = '" + @FROMBANKCD + "' AND ML.PARTY_CODE < = '" + @TOBANKCD + "') "  
  END   
    
  IF @FROMCLIENTID <> '' OR @TOCLIENTID <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND ML.PARTY_CODE BETWEEN '" + @FROMCLIENTID + "' AND '" + @TOCLIENTID + "' "  
  END  
    
  SET @@SQL = @@SQL + " ORDER BY ML.VNO, ML.VDT, ML.DRCR DESC "   
 END   
END  
ELSE   
BEGIN  
 IF @VNOTYPE = '1' OR @VNOTYPE = '4'  
 -- RECEIPT CASH   OR PAYMENT CASH  
  BEGIN  
  SET @@SQL =" "  
  SET @@SQL = @@SQL + " SELECT L.VTYP, L.CLTCODE, L.VNO, CONVERT(VARCHAR(11),L.VDT,109) VDT,L.ACNAME, L.DRCR, L.VAMT, L.NARRATION "  
  SET @@SQL = @@SQL + " FROM LEDGER L INNER JOIN "  
  SET @@SQL = @@SQL + " (SELECT VNO, CLTCODE ACNAME, VTYP, BOOKTYPE FROM LEDGER WHERE VTYP = " + @VNOTYPE + " AND "  
            
          IF @VNOTYPE = '1'  
          BEGIN        
     		SET @@SQL = @@SQL + " DRCR = 'D' "  
          END   
          ELSE IF @VNOTYPE = '4'  
          BEGIN     
   		  SET @@SQL = @@SQL + " DRCR = 'C' "   
          END   
       
          IF @FROMBANKCD <> ''  
          BEGIN  
           SET @@SQL = @@SQL + " AND (CLTCODE > = '" + @FROMBANKCD + "' AND CLTCODE < = '" + @TOBANKCD + "') "   
          END  
  
  SET @@SQL = @@SQL + " ) D ON L.VNO = D.VNO AND L.VTYP = D.VTYP AND L.BOOKTYPE = D.BOOKTYPE "  
  SET @@SQL = @@SQL + " INNER JOIN ACMAST A ON L.CLTCODE = A.CLTCODE "   
  SET @@SQL = @@SQL + " WHERE L.VNO <> '' AND L.VTYP = " + @VNOTYPE + " AND "  
  SET @@SQL = @@SQL + " A.BRANCHCODE = '" + @STATUSNAME + "' AND "  
    
  IF @VNOTYPE = '1'  
  BEGIN  
  SET @@SQL = @@SQL + " L.DRCR = 'C' "   
  END  
  ELSE IF @VNOTYPE = '4'  
  BEGIN  
  SET @@SQL = @@SQL + " L.DRCR = 'D' "   
  END   
     
  SET @@SQL = @@SQL + " AND L.VDT > = '" + @FROMDATE + " 00:00:00' AND L.VDT < = '" + @TODATE + " 23:59:59' "   
    
  IF @FROMVAMT <> '' OR @TOVAMT <> ''  
  BEGIN   
  SET @@SQL = @@SQL + " AND L.VAMT BETWEEN " + @FROMVAMT + " AND " + @TOVAMT + " "  
  END  
  
  IF @FROMVNO <> '' OR @TOVNO <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND L.VNO BETWEEN '" + @FROMVNO + "' AND '" + @TOVNO + "' "  
  END   
    
  IF @FROMCLIENTID <> '' OR @TOCLIENTID <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND L.CLTCODE BETWEEN '" + @FROMCLIENTID + "' AND '" + @TOCLIENTID + "' "  
  END  
  
  SET @@SQL = @@SQL + " ORDER BY L.VNO, L.VDT, L.DRCR DESC "   
 END  
  
 ELSE IF @VNOTYPE = '2' OR @VNOTYPE = '3' OR @VNOTYPE = '16' OR @VNOTYPE = '17'  
      -- RECEIPT BANK   OR PAYMENT BANK   OR CHEQUE CANCEL   OR CHEQUE RETURN  
 BEGIN  
  SET @@SQL = " "  
  SET @@SQL = @@SQL + " SELECT L1.DDNO, L.VTYP, L.CLTCODE, L.VNO, L.ACNAME, L.DRCR, L.VAMT, L.NARRATION, "  
    
  IF UPPER(@DATETYPE) = 'VOUDT'  
  BEGIN   
  SET @@SQL = @@SQL + " CONVERT(VARCHAR(11),L.VDT,109) VDT, "  
  END  
  ELSE   
  BEGIN  
  SET @@SQL = @@SQL + " CONVERT(VARCHAR(11),L.PDT,109) PDT, "  
  END  
  
  SET @@SQL = @@SQL + " CONVERT(VARCHAR(11),L1.DDDT,109) CDT, L.CLTCODE AS ctl FROM LEDGER L INNER JOIN "  
  SET @@SQL = @@SQL + " (SELECT VNO, CLTCODE ACNAME, VTYP, BOOKTYPE FROM LEDGER WHERE VTYP = " + @VNOTYPE + " "  
          IF @VNOTYPE = '2' OR @VNOTYPE = '16'    
          BEGIN        
     SET @@SQL = @@SQL + " AND DRCR = 'D' "  
          END   
          ELSE IF @VNOTYPE = '3' OR @VNOTYPE = '17'  
          BEGIN     
     SET @@SQL = @@SQL + " AND DRCR = 'C' "   
          END   
       
          IF @FROMBANKCD <> ''  
          BEGIN  
           SET @@SQL = @@SQL + " AND (CLTCODE > = '" + @FROMBANKCD + "' AND CLTCODE < = '" + @TOBANKCD + "') "   
          END  
  
  SET @@SQL = @@SQL + " ) D ON L.VNO = D.VNO AND L.VTYP = D.VTYP AND L.BOOKTYPE = D.BOOKTYPE "  
  SET @@SQL = @@SQL + " INNER JOIN ACMAST A ON L.CLTCODE = A.CLTCODE "  
  SET @@SQL = @@SQL + " INNER JOIN LEDGER1 L1 ON L.VNO = L1.VNO AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE "  
  SET @@SQL = @@SQL + " WHERE L.VNO <> '' AND L.VTYP = " + @VNOTYPE + " AND "  
  SET @@SQL = @@SQL + " A.BRANCHCODE = '" + @STATUSNAME + "' "  
    
  IF @VNOTYPE = '2' OR @VNOTYPE = '16'  
  BEGIN  
  SET @@SQL = @@SQL + " AND L.DRCR = 'C' "   
  END  
  ELSE IF @VNOTYPE = '3' OR @VNOTYPE = '17'  
  BEGIN  
  SET @@SQL = @@SQL + " AND L.DRCR = 'D' "   
  END   
    
  IF UPPER(@DATETYPE) = 'VOUDT'    
  BEGIN   
  SET @@SQL = @@SQL + " AND L.VDT > = '" + @FROMDATE + " 00:00:00' AND L.VDT < = '" + @TODATE + " 23:59:59' "   
  END  
  ELSE  
  BEGIN  
  SET @@SQL = @@SQL + " AND L.PDT > = '" + @FROMDATE + " 00:00:00' AND L.PDT < = '" + @TODATE + " 23:59:59' "   
  END  
    
  IF @CHQNUM <> ''      
       BEGIN  
  SET @@SQL = @@SQL + " AND L1.DDNO = '" + @CHQNUM + "' "     
      END  
    
  IF @FROMVAMT <> '' OR @TOVAMT <> ''  
  BEGIN   
  SET @@SQL = @@SQL + " AND L.VAMT BETWEEN " + @FROMVAMT + " AND " + @TOVAMT + " "  
  END  
  
  IF @FROMVNO <> '' OR @TOVNO <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND L.VNO BETWEEN '" + @FROMVNO + "' AND '" + @TOVNO + "' "  
  END   
    
  IF @FROMCLIENTID <> '' OR @TOCLIENTID <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND L.CLTCODE BETWEEN '" + @FROMCLIENTID + "' AND '" + @TOCLIENTID + "' "  
  END  
 END  
  
 ELSE IF @VNOTYPE = '5' OR @VNOTYPE = '6' OR @VNOTYPE = '7'  
 ---     CONTRY ENTRY   OR DEBIT NOTE     OR CREDIT NOTE  
 BEGIN  
  SET @@SQL = " "  
  SET @@SQL = @@SQL + " SELECT L.VTYP, L.CLTCODE, L.VNO, CONVERT(VARCHAR(11),L.VDT,109) VDT, L.ACNAME, L.DRCR, L.VAMT, L.NARRATION, "   
  SET @@SQL = @@SQL + " CONVERT(VARCHAR(11), L.CDT, 109) CDT, A.POBANKNAME, A.POBANKCODE "  
  SET @@SQL = @@SQL + " FROM LEDGER L INNER JOIN ACMAST A ON L.CLTCODE = A.CLTCODE "  
  SET @@SQL = @@SQL + " WHERE A.BRANCHCODE = '" + @STATUSNAME + "' AND L.VTYP = '" + @VNOTYPE + "' AND L.VDT > = '" + @FROMDATE + " 00:00:00' AND L.VDT < = '" + @TODATE + " 23:59:59' "   
    
  IF @CHQNUM <> ''      
       BEGIN  
  SET @@SQL = @@SQL + " AND L1.DDNO = '" + @CHQNUM + "' "     
      END  
    
  IF @FROMVAMT <> '' OR @TOVAMT <> ''  
  BEGIN   
  SET @@SQL = @@SQL + " AND L.VAMT BETWEEN " + @FROMVAMT + " AND " + @TOVAMT + " "  
  END  
  
  IF @FROMVNO <> '' OR @TOVNO <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND L.VNO BETWEEN '" + @FROMVNO + "' AND '" + @TOVNO + "' "  
  END   
    
  IF @FROMCLIENTID <> '' OR @TOCLIENTID <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND L.CLTCODE BETWEEN '" + @FROMCLIENTID + "' AND '" + @TOCLIENTID + "' "  
  END  
    
  SET @@SQL = @@SQL + " ORDER BY L.VNO, L.VDT, L.DRCR DESC "   
 END  
  
 ELSE IF @VNOTYPE = '8'  
 -- JOURNAL VOUCHER  
 BEGIN  
  SET @@SQL = " "  
  SET @@SQL = @@SQL + " SELECT L.VTYP, L.CLTCODE, L.VNO, CONVERT(VARCHAR(11), L.VDT, 109) VDT, L.ACNAME, L.DRCR, "  
   SET @@SQL = @@SQL + " L.VAMT, L.NARRATION "  
   SET @@SQL = @@SQL + " FROM LEDGER L INNER JOIN ACMAST A ON L.CLTCODE = A.CLTCODE "  
   SET @@SQL = @@SQL + " WHERE L.VNO <> '' AND L.VTYP = " + @VNOTYPE + " AND A.BRANCHCODE = '" + @STATUSNAME + "' "  
  SET @@SQL = @@SQL + " AND L.VDT > = '" + @FROMDATE + " 00:00:00' AND L.VDT < = '" + @TODATE + " 23:59:59' "    
    
  IF @FROMVAMT <> '' OR @TOVAMT <> ''  
  BEGIN   
  SET @@SQL = @@SQL + " AND L.VAMT BETWEEN " + @FROMVAMT + " AND " + @TOVAMT + " "  
  END  
  
  IF @FROMVNO <> '' OR @TOVNO <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND L.VNO BETWEEN '" + @FROMVNO + "' AND '" + @TOVNO + "' "  
  END   
  
  IF @FROMCLIENTID <> '' OR @TOCLIENTID <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND L.CLTCODE BETWEEN '" + @FROMCLIENTID + "' AND '" + @TOCLIENTID + "' "  
  END  
    
  SET @@SQL = @@SQL + " ORDER BY L.VNO, L.VDT, L.DRCR DESC "   
 END     
   
 ELSE IF @VNOTYPE = '19' OR @VNOTYPE = '20'  
 --MARGIN BANK RECEIVED  OR MARGIN BANK PAYMENT  
 BEGIN   
  SET @@SQL = " "  
  SET @@SQL = @@SQL + " SELECT ML.VNO, ML.VTYP, ML.BOOKTYPE, ML.PARTY_CODE CLTCODE, L.NARRATION, "  
  SET @@SQL = @@SQL + " CONVERT(VARCHAR(11),ML.VDT, 109) VDT, A.ACNAME, ML.AMOUNT VAMT, ML.DRCR, L1.DDNO, "  
  SET @@SQL = @@SQL + " CONVERT(VARCHAR(11), L1.DDDT, 109) CDT "   
  SET @@SQL = @@SQL + " FROM LEDGER L INNER JOIN MARGINLEDGER ML ON L.VNO = ML.VNO AND L.VTYP = ML.VTYP AND"  
  SET @@SQL = @@SQL + " L.BOOKTYPE = ML.BOOKTYPE INNER JOIN LEDGER1 L1 ON ML.VNO = L1.VNO AND ML.VTYP = L1.VTYP AND "  
  SET @@SQL = @@SQL + " ML.BOOKTYPE = L1.BOOKTYPE INNER JOIN ACMAST A ON ML.PARTY_CODE = A.CLTCODE "  
  SET @@SQL = @@SQL + " WHERE ML.VTYP = " + @VNOTYPE + " AND A.BRANCHCODE = '" + @STATUSNAME + "' AND ML.VDT > = '" + @FROMDATE + " 00:00:00' AND ML.VDT < = '" + @TODATE + " 23:59:59' "   
  
  IF @CHQNUM <> ''  
  BEGIN   
  SET @@SQL = @@SQL + " AND L1.DDNO = '" + @CHQNUM + "' "  
  END   
    
  IF @FROMVAMT <> '' OR @TOVAMT <> ''  
  BEGIN   
  SET @@SQL = @@SQL + " AND ML.VAMT BETWEEN " + @FROMVAMT + " AND " + @TOVAMT + "  "  
  END    
      
  IF @FROMVNO <> '' OR @TOVNO <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND ML.VNO BETWEEN '" + @FROMVNO + "' AND '" + @TOVNO + "' "  
  END   
  
  IF @FROMBANKCD <> ''  
  BEGIN    
   SET @@SQL = @@SQL + " AND (ML.PARTY_CODE > = '" + @FROMBANKCD + "' AND ML.PARTY_CODE < = '" + @TOBANKCD + "') "  
  END   
    
  IF @FROMCLIENTID <> '' OR @TOCLIENTID <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND ML.PARTY_CODE BETWEEN '" + @FROMCLIENTID + "' AND '" + @TOCLIENTID + "' "  
  END  
    
  SET @@SQL = @@SQL + " ORDER BY ML.VNO, ML.VDT, ML.DRCR DESC "       
 END   
   
 ELSE IF @VNOTYPE = '22' OR @VNOTYPE = '23' OR @VNOTYPE = '24'  
 --MARGIN CASH RECEIVED  OR MARGIN CASH PAYMENT  
 BEGIN  
  SET @@SQL = " "  
  SET @@SQL = @@SQL + " SELECT ML.VNO, ML.VTYP, ML.BOOKTYPE, ML.PARTY_CODE CLTCODE, L.NARRATION, "  
  SET @@SQL = @@SQL + " CONVERT(VARCHAR(11), ML.VDT, 109) VDT, A.ACNAME, ML.AMOUNT VAMT, ML.DRCR "  
   SET @@SQL = @@SQL + " FROM LEDGER L INNER JOIN MARGINLEDGER ML ON L.VNO = ML.VNO AND L.VTYP = ML.VTYP AND "   
  SET @@SQL = @@SQL + " L.BOOKTYPE = ML.BOOKTYPE INNER JOIN ACMAST A ON ML.PARTY_CODE = A.CLTCODE "  
  SET @@SQL = @@SQL + " WHERE ML.VTYP = " + @VNOTYPE + " AND A.BRANCHCODE = '" + @STATUSNAME + "' "  
  
  IF @FROMVAMT <> '' OR @TOVAMT <> ''  
  BEGIN   
  SET @@SQL = @@SQL + " AND ML.VAMT BETWEEN " + @FROMVAMT + " AND " + @TOVAMT + " "  
  END    
      
  IF @FROMVNO <> '' OR @TOVNO <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND ML.VNO BETWEEN '" + @FROMVNO + "' AND '" + @TOVNO + "' "  
  END   
  
  IF @FROMBANKCD <> ''  
  BEGIN    
   SET @@SQL = @@SQL + " AND (ML.PARTY_CODE > = '" + @FROMBANKCD + "' AND ML.PARTY_CODE < = '" + @TOBANKCD + "') "  
  END   
    
  IF @FROMCLIENTID <> '' OR @TOCLIENTID <> ''   
  BEGIN  
  SET @@SQL = @@SQL + " AND ML.PARTY_CODE BETWEEN '" + @FROMCLIENTID + "' AND '" + @TOCLIENTID + "' "  
  END  
    
  SET @@SQL = @@SQL + " ORDER BY ML.VNO, ML.VDT, ML.DRCR DESC "   
 END  
   
END  
  
PRINT @@SQL  
EXEC (@@SQL)

GO
