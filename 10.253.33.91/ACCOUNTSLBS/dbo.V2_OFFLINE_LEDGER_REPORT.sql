-- Object: PROCEDURE dbo.V2_OFFLINE_LEDGER_REPORT
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

 
CREATE PROC V2_OFFLINE_LEDGER_REPORT            
(            
@startDate varchar(11),            
@endDate varchar(11),          
@fromParty varchar(10),          
@toParty varchar(10),      
@Selectionby VARCHAR(3),
@SortBy varchar(6),
@EXCSEGMENT VARCHAR(11)         
)            
AS          
    
/*    
EXEC V2_OFFLINE_LEDGER_REPORT 'SEP  1 2007','SEP 17 2007','0a141','0a141','VDT'    
*/    
    
DECLARE @@QRY AS VARCHAR(8000)    
DECLARE @@CLOSEBALQRY as VARCHAR(8000)
DECLARE @@OPENDATE AS VARCHAR(11)    
DECLARE @@FINSTART AS DATETIME    
DECLARE @@FINSTARTCHAR AS VARCHAR(11)    
    
SELECT @@QRY = "  "
SELECT @@CLOSEBALQRY = " SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED "    
    
SELECT @@FINSTART = SDTCUR, @@FINSTARTCHAR = LEFT(SDTCUR,11) FROM PARAMETER (NOLOCK) WHERE CONVERT(DATETIME,@startDate,109) BETWEEN SDTCUR AND LDTCUR      
    
IF UPPER(@SELECTIONBY) = 'VDT'    
BEGIN    
 SELECT @@OPENDATE = (SELECT LEFT(CONVERT(VARCHAR,ISNULL(MAX(VDATE),0),109),11) FROM V2_OFFLINE_LEDGER_ENTRIES (NOLOCK) WHERE VOUCHERTYPE = 18    
      AND VDATE <= @@FINSTART)    
    
    
END    
ELSE    
BEGIN    
 SELECT @@OPENDATE = (SELECT LEFT(CONVERT(VARCHAR,ISNULL(MAX(EDATE),0),109),11) FROM V2_OFFLINE_LEDGER_ENTRIES (NOLOCK) WHERE VOUCHERTYPE = 18    
      AND EDATE <= @@FINSTART)    
END    
    
    
IF Upper(@Selectionby) = 'VDT'      
  BEGIN      
  IF @startDate = @@FINSTART     
        Begin      
   If @@Opendate = @@FINSTARTCHAR       
   Begin      
      SELECT @@QRY = @@QRY + " Select EXCHANGE, SEGMENT,"     
      SELECT @@QRY = @@QRY + " 'OPBAL' AS VNAME, "    
      SELECT @@QRY = @@QRY + " '' AS VTYP, "    
      SELECT @@QRY = @@QRY + " '' AS BOOKTYPE, "    
      SELECT @@QRY = @@QRY + " '' as VDt, "            
      SELECT @@QRY = @@QRY + " '' as Edt, "            
      SELECT @@QRY = @@QRY + " '' as GLCode, "    
      SELECT @@QRY = @@QRY + " CltCode,"    
      SELECT @@QRY = @@QRY + " BranchCode,"    
      SELECT @@QRY = @@QRY + " CASE WHEN Sum(DEBITAMT - CREDITAMT) <= 0 THEN ABS(Sum(DEBITAMT - CREDITAMT)) ELSE 0 END AS CREDITAMT, "          
      SELECT @@QRY = @@QRY + " CASE WHEN Sum(DEBITAMT - CREDITAMT) > 0 THEN ABS(Sum(DEBITAMT - CREDITAMT)) ELSE 0 END AS DEBITAMT, "         
      SELECT @@QRY = @@QRY + " 'OPENING BALANCE' AS Narration, "                   
      SELECT @@QRY = @@QRY + " '' AS VNO, "        
      SELECT @@QRY = @@QRY + " '' AS Vdate, "     
      SELECT @@QRY = @@QRY + " '' AS BankName, "   
      SELECT @@QRY = @@QRY + " '' AS BranchName "   
      SELECT @@QRY = @@QRY + " From V2_OFFLINE_LEDGER_ENTRIES (NOLOCK) "       
      SELECT @@QRY = @@QRY + " Where Cltcode >= '" + @FromParty + "' and CLTCODE <= '" + @ToParty + "'"    
      SELECT @@QRY = @@QRY + " And VDATE Like '" + @@Opendate + "%' And VOUCHERTYPE = 18  "   
	  IF ISNULL(@EXCSEGMENT,'ALL') <> 'ALL'
	  BEGIN 
      SELECT @@QRY = @@QRY + " And EXCHANGE + '-' + SEGMENT = '" + @EXCSEGMENT + "'"
	  END
      SELECT @@QRY = @@QRY + " Group By CLTCODE, BRANCHCODE, EXCHANGE, SEGMENT  "    
   End      
   Else      
   Begin      
      SELECT @@QRY = @@QRY + " Select EXCHANGE, SEGMENT,"     
      SELECT @@QRY = @@QRY + " 'OPBAL' AS VNAME, "    
      SELECT @@QRY = @@QRY + " '' AS VTYP, "    
      SELECT @@QRY = @@QRY + " '' AS BOOKTYPE, "    
      SELECT @@QRY = @@QRY + " '' as VDt, "            
      SELECT @@QRY = @@QRY + " '' as Edt, "            
      SELECT @@QRY = @@QRY + " '' as GLCode, "    
      SELECT @@QRY = @@QRY + " CltCode,"    
      SELECT @@QRY = @@QRY + " BranchCode,"    
      SELECT @@QRY = @@QRY + " CASE WHEN Sum(DEBITAMT - CREDITAMT) <= 0 THEN ABS(Sum(DEBITAMT - CREDITAMT)) ELSE 0 END AS CREDITAMT, "          
      SELECT @@QRY = @@QRY + " CASE WHEN Sum(DEBITAMT - CREDITAMT) > 0 THEN ABS(Sum(DEBITAMT - CREDITAMT)) ELSE 0 END AS DEBITAMT, "         
      SELECT @@QRY = @@QRY + " 'OPENING BALANCE' AS Narration, "                   
      SELECT @@QRY = @@QRY + " '' AS VNO, "        
      SELECT @@QRY = @@QRY + " '' AS Vdate, "     
      SELECT @@QRY = @@QRY + " '' AS BankName, "   
      SELECT @@QRY = @@QRY + " '' AS BranchName "      
      SELECT @@QRY = @@QRY + " From V2_OFFLINE_LEDGER_ENTRIES (NOLOCK) "       
      SELECT @@QRY = @@QRY + " Where Cltcode >= '" + @FromParty + "' and CLTCODE <= '" + @ToParty + "'"    
      SELECT @@QRY = @@QRY + " And VDATE >= '" + @@Opendate + " 00:00:00' And VDATE < '" + @@FINSTARTCHAR + "'"    
	  IF ISNULL(@EXCSEGMENT,'ALL') <> 'ALL'
	  BEGIN 
      SELECT @@QRY = @@QRY + " And EXCHANGE + '-' + SEGMENT = '" + @EXCSEGMENT + "'"
	  END
      SELECT @@QRY = @@QRY + " Group By CLTCODE, BRANCHCODE, EXCHANGE, SEGMENT  "    
   End      
        End      
  Else      
        Begin      
      SELECT @@QRY = @@QRY + " Select EXCHANGE, SEGMENT,"     
      SELECT @@QRY = @@QRY + " 'OPBAL' AS VNAME, "    
      SELECT @@QRY = @@QRY + " '' AS VTYP, "    
      SELECT @@QRY = @@QRY + " '' AS BOOKTYPE, "    
      SELECT @@QRY = @@QRY + " '' as VDt, "            
      SELECT @@QRY = @@QRY + " '' as Edt, "            
      SELECT @@QRY = @@QRY + " '' as GLCode, "    
      SELECT @@QRY = @@QRY + " CltCode,"    
      SELECT @@QRY = @@QRY + " BranchCode,"    
      SELECT @@QRY = @@QRY + " CASE WHEN Sum(DEBITAMT - CREDITAMT) <= 0 THEN ABS(Sum(DEBITAMT - CREDITAMT)) ELSE 0 END AS CREDITAMT, "          
      SELECT @@QRY = @@QRY + " CASE WHEN Sum(DEBITAMT - CREDITAMT) > 0 THEN ABS(Sum(DEBITAMT - CREDITAMT)) ELSE 0 END AS DEBITAMT, "         
      SELECT @@QRY = @@QRY + " 'OPENING BALANCE' AS Narration, "                   
      SELECT @@QRY = @@QRY + " '' AS VNO, "        
      SELECT @@QRY = @@QRY + " '' AS Vdate, "     
      SELECT @@QRY = @@QRY + " '' AS BankName, "   
      SELECT @@QRY = @@QRY + " '' AS BranchName "    
      SELECT @@QRY = @@QRY + " From V2_OFFLINE_LEDGER_ENTRIES (NOLOCK) "       
      SELECT @@QRY = @@QRY + " Where Cltcode >= '" + @FromParty + "' and CLTCODE <= '" + @ToParty + "'"    
      SELECT @@QRY = @@QRY + " And VDATE >= '" + @@Opendate + " 00:00:00' And VDATE < '" + @@FINSTARTCHAR + "'"    
	  IF ISNULL(@EXCSEGMENT,'ALL') <> 'ALL'
	  BEGIN 
      SELECT @@QRY = @@QRY + " And EXCHANGE + '-' + SEGMENT = '" + @EXCSEGMENT + "'"
	  END
      SELECT @@QRY = @@QRY + " Group By CLTCODE, BRANCHCODE, EXCHANGE, SEGMENT  "    
        End      
END       
ELSE     
  BEGIN      
  If @StartDate = @@FINSTARTCHAR And @@Opendate = @@FINSTARTCHAR      
        Begin      
      SELECT @@QRY = @@QRY + " Select EXCHANGE, SEGMENT,"     
      SELECT @@QRY = @@QRY + " 'OPBAL' AS VNAME, "    
      SELECT @@QRY = @@QRY + " '' AS VTYP, "    
      SELECT @@QRY = @@QRY + " '' AS BOOKTYPE, "    
      SELECT @@QRY = @@QRY + " '' as VDt, "            
      SELECT @@QRY = @@QRY + " '' as Edt, "            
      SELECT @@QRY = @@QRY + " '' as GLCode, "    
      SELECT @@QRY = @@QRY + " CltCode,"    
      SELECT @@QRY = @@QRY + " BranchCode,"    
      SELECT @@QRY = @@QRY + " CASE WHEN Sum(DEBITAMT - CREDITAMT) <= 0 THEN ABS(Sum(DEBITAMT - CREDITAMT)) ELSE 0 END AS CREDITAMT, "          
      SELECT @@QRY = @@QRY + " CASE WHEN Sum(DEBITAMT - CREDITAMT) > 0 THEN ABS(Sum(DEBITAMT - CREDITAMT)) ELSE 0 END AS DEBITAMT, "         
      SELECT @@QRY = @@QRY + " 'OPENING BALANCE' AS Narration, "                   
      SELECT @@QRY = @@QRY + " '' AS VNO, "        
      SELECT @@QRY = @@QRY + " '' AS Vdate, "     
      SELECT @@QRY = @@QRY + " '' AS BankName, "   
      SELECT @@QRY = @@QRY + " '' AS BranchName "    
      SELECT @@QRY = @@QRY + " From V2_OFFLINE_LEDGER_ENTRIES (NOLOCK) "       
      SELECT @@QRY = @@QRY + " Where Cltcode >= '" + @FromParty + "' and CLTCODE <= '" + @ToParty + "'"    
      SELECT @@QRY = @@QRY + " And EDate Like '" + @@Opendate + "%' And VOUCHERTYPE = 18  "    
	  IF ISNULL(@EXCSEGMENT,'ALL') <> 'ALL'
	  BEGIN 
      SELECT @@QRY = @@QRY + " And EXCHANGE + '-' + SEGMENT = '" + @EXCSEGMENT + "'"
	  END
      SELECT @@QRY = @@QRY + " Group By CLTCODE, BRANCHCODE, EXCHANGE, SEGMENT  "    
        End      
  Else      
        Begin      
    
      SELECT @@QRY = @@QRY + " Select EXCHANGE, SEGMENT,"     
      SELECT @@QRY = @@QRY + " 'OPBAL' AS VNAME, "    
      SELECT @@QRY = @@QRY + " '' AS VTYP, "    
      SELECT @@QRY = @@QRY + " '' AS BOOKTYPE, "    
      SELECT @@QRY = @@QRY + " '' as VDt, "            
      SELECT @@QRY = @@QRY + " '' as Edt, "            
      SELECT @@QRY = @@QRY + " '' as GLCode, "    
      SELECT @@QRY = @@QRY + " CltCode,"    
      SELECT @@QRY = @@QRY + " BranchCode,"    
      SELECT @@QRY = @@QRY + " (CASE WHEN SUM(OPBAL) <= 0 THEN ABS(SUM(OPBAL)) ELSE 0 END) AS CREDITAMT, "          
      SELECT @@QRY = @@QRY + " (CASE WHEN SUM(OPBAL) > 0 THEN ABS(SUM(OPBAL)) ELSE 0 END) AS DEBITAMT, "         
      SELECT @@QRY = @@QRY + " 'OPENING BALANCE' AS Narration, "                   
      SELECT @@QRY = @@QRY + " '' AS VNO, "        
      SELECT @@QRY = @@QRY + " '' AS Vdate, "     
      SELECT @@QRY = @@QRY + " '' AS BankName, "   
      SELECT @@QRY = @@QRY + " '' AS BranchName "     
      SELECT @@QRY = @@QRY + " FROM "     
      SELECT @@QRY = @@QRY + " (Select EXCHANGE, SEGMENT, CLTCODE, BRANCHCODE, Opbal = Sum(DEBITAMT - CREDITAMT) "     
      SELECT @@QRY = @@QRY + " From V2_OFFLINE_LEDGER_ENTRIES (NOLOCK) "       
      SELECT @@QRY = @@QRY + " Where Cltcode >= '" + @FromParty + "' and CLTCODE <= '" + @ToParty + "'"    
      SELECT @@QRY = @@QRY + " And EDate Like '" + @@Opendate + "%' And VOUCHERTYPE = 18  "    
	  IF ISNULL(@EXCSEGMENT,'ALL') <> 'ALL'
	  BEGIN 
      SELECT @@QRY = @@QRY + " And EXCHANGE + '-' + SEGMENT = '" + @EXCSEGMENT + "'"
	  END
      SELECT @@QRY = @@QRY + " Group By EXCHANGE, SEGMENT, CLTCODE, BRANCHCODE  "    
      SELECT @@QRY = @@QRY + " UNION ALL  "    
      SELECT @@QRY = @@QRY + " Select EXCHANGE, SEGMENT, CLTCODE, BRANCHCODE, Opbal = Sum(DEBITAMT - CREDITAMT) "     
      SELECT @@QRY = @@QRY + " From V2_OFFLINE_LEDGER_ENTRIES (NOLOCK) "       
      SELECT @@QRY = @@QRY + " Where Cltcode >= '" + @FromParty + "' and CLTCODE <= '" + @ToParty + "'"    
      SELECT @@QRY = @@QRY + " And VDATE >= '" + @@Opendate + " 00:00:00' And EDATE < '" + @@FINSTARTCHAR + "' AND VOUCHERTYPE <> 18"    
	  IF ISNULL(@EXCSEGMENT,'ALL') <> 'ALL'
	  BEGIN 
      SELECT @@QRY = @@QRY + " And EXCHANGE + '-' + SEGMENT = '" + @EXCSEGMENT + "'"
	  END
      SELECT @@QRY = @@QRY + " Group By EXCHANGE, SEGMENT, CLTCODE, BRANCHCODE ) T"     
      SELECT @@QRY = @@QRY + " GROUP BY EXCHANGE, SEGMENT, CLTCODE, BRANCHCODE "    
        End      
  End      
    
    
 SELECT @@QRY = @@QRY + " UNION ALL "    
 SELECT @@QRY = @@QRY + " select A.Exchange, A.Segment, "     
 SELECT @@QRY = @@QRY + " UPPER(ISNULL(V.SHORTDESC,'')) AS VNAME, "       
 SELECT @@QRY = @@QRY + " A.VOUCHERTYPE AS VTYP, "    
 SELECT @@QRY = @@QRY + " A.BOOKTYPE AS BOOKTYPE, "      
 SELECT @@QRY = @@QRY + " Convert(varchar,a.Vdate,105) as VDt, "            
 SELECT @@QRY = @@QRY + " Convert(varchar,a.Edate,105) as Edt, "            
 SELECT @@QRY = @@QRY + " a.OppCode as GLCode, "    
 SELECT @@QRY = @@QRY + " a.CltCode,"    
 SELECT @@QRY = @@QRY + " a.BranchCode,"    
 SELECT @@QRY = @@QRY + " a.CreditAmt, "          
 SELECT @@QRY = @@QRY + " a.DebitAmt,"           
 SELECT @@QRY = @@QRY + " a.Narration, "                   
 SELECT @@QRY = @@QRY + " a.VoucherNo as VNO, "        
 SELECT @@QRY = @@QRY + " a.Vdate, "     
 SELECT @@QRY = @@QRY + " a.BankName, "   
 SELECT @@QRY = @@QRY + " a.BranchName "   
 SELECT @@QRY = @@QRY + " from "        
 SELECT @@QRY = @@QRY + " v2_offline_ledger_entries a (NOLOCK) "    
 SELECT @@QRY = @@QRY + " LEFT OUTER JOIN "    
 SELECT @@QRY = @@QRY + " VMAST V ON (V.VTYPE = A.VOUCHERTYPE) "       
 SELECT @@QRY = @@QRY + " Where 1=1 "        
 IF Upper(@Selectionby) = 'VDT'    
 BEGIN      
 SELECT @@QRY = @@QRY + " And a.vDATE >= convert(datetime,'" + @startDate + "',109) "           
 SELECT @@QRY = @@QRY + " and a.vDATE <= convert(datetime,'" + @endDate + " 23:59:59',109) "           
 END    
 ELSE    
 BEGIN    
 SELECT @@QRY = @@QRY + " And a.EDATE >= convert(datetime,'" + @startDate + "',109) "           
 SELECT @@QRY = @@QRY + " and a.EDATE <= convert(datetime,'" + @endDate + " 23:59:59',109) "    
 END    
 SELECT @@QRY = @@QRY + " and a.CltCode >= '" + @FromParty + "' "         
 SELECT @@QRY = @@QRY + " and a.CltCode <= '" + @ToParty + "'"         
 SELECT @@QRY = @@QRY + " AND A.VOUCHERTYPE <> '18'"      
 	  IF ISNULL(@EXCSEGMENT,'ALL') <> 'ALL'
	  BEGIN 
      SELECT @@QRY = @@QRY + " And EXCHANGE + '-' + SEGMENT = '" + @EXCSEGMENT + "'"
	  END 


      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " Select EXCHANGE, SEGMENT,"     
      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " 'CLOSEBAL' AS VNAME, "    
      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " '' AS VTYP, "    
      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " '' AS BOOKTYPE, "    
      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " '' as VDt, "            
      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " '' as Edt, "            
      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " '' as GLCode, "    
      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " CltCode,"    
      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " BranchCode,"    
      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " (CASE WHEN SUM(CREDITAMT) - SUM(DEBITAMT) > 0 THEN SUM(CREDITAMT) - SUM(DEBITAMT) ELSE 0 END) AS CREDITAMT, "          
      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " (CASE WHEN SUM(CREDITAMT) - SUM(DEBITAMT) <= 0 THEN SUM(DEBITAMT) - SUM(CREDITAMT) ELSE 0 END) AS DEBITAMT, "         
      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " 'CLOSING BALANCE' AS Narration, "                   
      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " '' AS VNO, "        
      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " '31-DEC-2049' AS Vdate, "     
      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " '' AS BankName, "   
      SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " '' AS BranchName "  
	  SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " FROM "
	  SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " ( "
	  SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + @@QRY
	  SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " ) X " 
	  SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " GROUP BY EXCHANGE, SEGMENT, CLTCODE, BRANCHCODE " 
	  SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " UNION ALL " 
	  SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + @@QRY
	if @SORTBY = 'DTASC'
	begin
	  SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " Order by  CLTCODE, Exchange, Segment, Vdate asc" 
	end
	else
	begin
	  SELECT @@CLOSEBALQRY = @@CLOSEBALQRY + " Order by  CLTCODE, Exchange, Segment, Vdate desc" 
	end
EXEC (@@CLOSEBALQRY)

GO
