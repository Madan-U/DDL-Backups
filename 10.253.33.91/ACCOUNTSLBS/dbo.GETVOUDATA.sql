-- Object: PROCEDURE dbo.GETVOUDATA
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROC [dbo].[GETVOUDATA]          
@Fdate Varchar(11),            /* As Mmm Dd Yyyy */                  
@Tdate Varchar(11),            /* As Mmm Dd Yyyy */              
@BANKCODE VARCHAR(10),   
@VAMT MONEY = 0,  
@DDNO VARCHAR(20) = '',   
@CLTCODE VARCHAR(10) = '',          
@PageSize varchar(3) = '25'          
AS          
  
          
CREATE TABLE #GETDATA_EDIT          
(          
 VNO VARCHAR(12),  
 BOOKTYPE VARCHAR(3),  
 VTYPE INT,           
 CLTCODE VARCHAR(10),           
 ACNAME VARCHAR(100),           
 VAMT MONEY,           
 NARRATION VARCHAR(250),           
 DDNO VARCHAR(20),   
 DDDT VARCHAR(10),          
 BNKNAME VARCHAR(35),  
 BRNNAME VARCHAR(20),   
 MICRNO INT,  
 RELDT VARCHAR(10),      
 VDT VARCHAR(10),  
 LNO INT   
         
)          
          
DECLARE          
@@SQL VARCHAR(2000)          
          
SET @@SQL = " INSERT INTO #GETDATA_EDIT "          
SET @@SQL = @@SQL + " SELECT "     
SET @@SQL = @@SQL + " L.VNO,L.BOOKTYPE,L.VTYP, CLTCODE, ACNAME, VAMT = CASE L.DRCR WHEN 'D' THEN -VAMT ELSE VAMT END, NARRATION, DDNO,CONVERT(VARCHAR(10), DDDT, 111), BNKNAME,L1.Brnname,L1.micrno , CONVERT(VARCHAR(10), RELDT, 103),CONVERT(VARCHAR(10), VDT
, 103), L.LNO "          
SET @@SQL = @@SQL + " FROM "          
SET @@SQL = @@SQL + " LEDGER L, LEDGER1 L1 "          
SET @@SQL = @@SQL + " WHERE "          
SET @@SQL = @@SQL + " L.VNO = L1.VNO "          
SET @@SQL = @@SQL + " AND L.VTYP = L1.VTYP and L.VTYP = 3 "          
SET @@SQL = @@SQL + " AND L.BOOKTYPE = L1.BOOKTYPE "   
SET @@SQL = @@SQL + " AND L1.RELDT = '1900-01-01 00:00:00.000' AND "   
SET @@SQL = @@SQL + "   not exists ( "  
SET @@SQL = @@SQL + " Select b.bpvno from stalecheque_vlog b  where l.vno = b.bpvno and l.vtyp =b.bpvtype and  l.booktype = b.bpbooktype) "  
  
SET @@SQL = @@SQL + " AND vdt between '" + @Fdate + "' and  '"  +  @Tdate  + "'"  
SET @@SQL = @@SQL +   " and CLTCODE = '" + @BANKCODE + "' "  
SET @@SQL = @@SQL +   " and clear_mode <> 'C' "  
  
SET @@SQL = @@SQL + " select  TOP " + @PageSize + " A.VNO,A.BOOKTYPE,A.VTYP ,A.CLTCODE,A.ACNAME,A.VAMT,A.NARRATION,B.DDNO,B.DDDT,B.BNKNAME,B.RELDT,CONVERT(VARCHAR(10), A.VDT, 103) as VDT ,B.BRNNAME,B.MICRNO from ledger A,#GETDATA_EDIT B "  
SET @@SQL = @@SQL + " where A.VNO = B.VNO and A.VTYP = B.Vtype and A.BOOKTYPE = B.BOOKTYPE "  
  
If @VAMT <> 0  
BEGIN  
 SET @@SQL = @@SQL + " and  A.VAMT = " + CONVERT(VARCHAR, @VAMT)  
END  
  
If @DDNO <> ""   
BEGIN  
 SET @@SQL = @@SQL + " and DDNO = '" + @DDNO + "' "  
END  
  
If @CLTCODE <> ""   
BEGIN  
 SET @@SQL = @@SQL + " and A.CLTCODE =  '" + @CLTCODE + "' "  
END  
  SET @@SQL = @@SQL +  " and A.CLTCODE  <> B.CLTCODE "   
  
print @@SQL      
EXEC (@@SQL)   
  
DROP TABLE  #GETDATA_EDIT

GO
