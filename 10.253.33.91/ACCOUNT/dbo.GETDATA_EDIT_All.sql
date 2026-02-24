-- Object: PROCEDURE dbo.GETDATA_EDIT_All
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------





CREATE PROC [dbo].[GETDATA_EDIT_All]          
@Fdate Varchar(11),            /* As Mmm Dd Yyyy */                  
@Tdate Varchar(11),            /* As Mmm Dd Yyyy */              
@VTYP INT,          
@BANKCODE VARCHAR(10),      
@VNO_FR VARCHAR(12),          
@VNO_TO VARCHAR(12),          
@VDT VARCHAR(11) = '',          
@VAMT MONEY = 0,            
@BOOKTYPE VARCHAR(3),          
@CLTCODE VARCHAR(10) = '',          
@PageSize varchar(3) = '25'          
AS          
          
CREATE TABLE #GETDATA_EDIT          
(          
 VNO VARCHAR(12),           
 CLTCODE VARCHAR(10),           
 ACNAME VARCHAR(100),           
 VAMT MONEY,           
 NARRATION VARCHAR(250),           
 DDNO VARCHAR(20),           
 RELDT VARCHAR(10),          
 BNKNAME VARCHAR(100),      
 VDT VARCHAR(10),  
 LNO INT          
)          
          
DECLARE          
@@SQL VARCHAR(1000)          
          
SET @@SQL = " INSERT INTO #GETDATA_EDIT "          
SET @@SQL = @@SQL + " SELECT TOP " + @PageSize        
SET @@SQL = @@SQL + " L.VNO, CLTCODE, ACNAME, VAMT = CASE L.DRCR WHEN 'D' THEN -VAMT ELSE VAMT END, NARRATION, DDNO, RELDT = CONVERT(VARCHAR(10), RELDT, 103), BNKNAME, CONVERT(VARCHAR(10), VDT, 103), L.LNO "          
SET @@SQL = @@SQL + " FROM "          
SET @@SQL = @@SQL + " LEDGER L, LEDGER1 L1 "          
SET @@SQL = @@SQL + " WHERE "          
SET @@SQL = @@SQL + " L.VNO = L1.VNO "          
SET @@SQL = @@SQL + " AND L.VTYP = L1.VTYP "          
SET @@SQL = @@SQL + " AND L.BOOKTYPE = L1.BOOKTYPE "          
IF @VTYP = 5   
BEGIN  
SET @@SQL = @@SQL + " AND L.LNO = L1.LNO "          
END  
IF @VTYP <> 5   
BEGIN  
 SET @@SQL = @@SQL + " AND L.LNO =1 "          
END  
--SET @@SQL = @@SQL + " AND L.VNO = L2.VNO "          
--SET @@SQL = @@SQL + " AND L.VTYP = L2.VTYP "          
--SET @@SQL = @@SQL + " AND L.BOOKTYPE = L2.BOOKTYPE "          
SET @@SQL = @@SQL + " AND L.CLTCODE = '" + @BANKCODE + "'"       
IF @VDT = ''           
 BEGIN           
 SET @@SQL = @@SQL + " AND VDT BETWEEN '" + @Fdate + "' And '" + @Tdate + " 23:59:59' "      
END      
ELSE      
BEGIN      
 SET @@SQL = @@SQL + " AND VDT LIKE '" + @VDT + "%' "      
END      
SET @@SQL = @@SQL + " AND L.VTYP = " + CONVERT(VARCHAR, @VTYP)          
SET @@SQL = @@SQL + " AND L.VNO BETWEEN '" + @VNO_FR + "' AND '" + @VNO_TO +"' "          
SET @@SQL = @@SQL + " AND L.BOOKTYPE = '" + @BOOKTYPE + "' "        
        
IF @VAMT <> 0          
 BEGIN          
 SET @@SQL = @@SQL + " AND L.VAMT = " + CONVERT(VARCHAR,@VAMT) + " "          
 END          
          
IF @CLTCODE <> ''          
 BEGIN          
 SET @@SQL = @@SQL + " AND L.CLTCODE = '" + @CLTCODE + "' "          
 END          
          
/*IF @VDT = ''           
 BEGIN           
  SET @@SQL = @@SQL + " AND L.VDT BETWEEN '" + @Fdate + "' And '" + @Tdate + " 23:59:59' "          
 END           
ELSE           
 BEGIN           
  SET @@SQL = @@SQL + " AND L.VDT LIKE '" + @VDT + "%' "          
 END     */      
  SET @@SQL = @@SQL + " ORDER BY L.VNO "          
        
print @@SQL      
EXEC (@@SQL)          
          
/*DELETE FROM #GETDATA_EDIT          
WHERE           
EXISTS           
 (      
  SELECT VNO FROM LEDGER L WHERE L.VNO = #GETDATA_EDIT.VNO AND L.VTYP = @VTYP AND L.BOOKTYPE = @BOOKTYPE          
  GROUP BY VNO, VTYP, BOOKTYPE HAVING COUNT(1) > 2         
 )*/          
  
IF @VTYP = 5  
BEGIN  
 UPDATE G SET RELDT = L1.RELDT FROM #GETDATA_EDIT G, LEDGER1 L1  
 WHERE L1.VNO = G.VNO AND L1.VTYP = @VTYP AND L1.RELDT <> ''  
END  
          
SELECT * FROM #GETDATA_EDIT    

set quoted_identifier off

GO
