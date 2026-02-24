-- Object: PROCEDURE dbo.LEDGER_GL_MFSS_FINAL_LEDGER_NXT_V1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE LEDGER_GL_MFSS_FINAL_LEDGER_NXT_V1 
(  
@SDATE VARCHAR(11),                      
@EDATE VARCHAR(11),                       
@FDATE VARCHAR(11),                     
@TDATE VARCHAR(11),   
@FCODE VARCHAR(10),  
@TCODE VARCHAR(10)  
)   
  
AS  
BEGIN  
Create table #Financial_Ledger_OneTime  
(  
FY Varchar(200)  
,Date date  
,VoucherType Varchar(200)  
,VrNo Varchar(200)  
,ChequeNo Varchar(200)  
,Particulars Varchar(2000)  
,DebitAmt numeric(18,2)  
,CreditAmt numeric(18,2)  
,Balance numeric(18,2)  
,SBCode Varchar(200)  
)  
  
  
Insert into #Financial_Ledger_OneTime  
EXEC usp_get_Financial_Ledger_OneTime_v1 @FCODE,@SDATE,@EDATE  
  
SELECT  L.BOOKTYPE, VOUDT=L.VDT, EFFDT=L.EDT, ISNULL(SHORTDESC,'') SHORTDESC,   
DRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),    
CRAMT=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END),   
L.VNO,  
DDNO= ISNULL((SELECT MAX(DDNO) FROM LEDGER1 L1 WITH(NOLOCK) WHERE L1.VNO=L.VNO AND L1.VTYP=L.VTYP   
AND L1.BOOKTYPE=L.BOOKTYPE AND L1.LNO = L.LNO),''),  
NARRATION = REPLACE(REPLACE(L.NARRATION,'''',''),'""','') ,  
L.CLTCODE, A.LONGNAME, VTYP, L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT,   
CONVERT(VARCHAR,L.EDT,103) EDT, L.ACNAME, EDIFF=DATEDIFF(D,L.EDT,GETDATE())   
FROM LEDGER L  WITH(NOLOCK) LEFT OUTER JOIN ACMAST A  WITH(NOLOCK) 
ON L.CLTCODE = A.CLTCODE , VMAST  WITH(NOLOCK)      
  
WHERE L.VDT >= @FDATE  AND   L.VDT <= @TDATE +' 23:59:59'                        
AND L.VTYP <> 18   
AND L.CLTCODE = A.CLTCODE   
AND L.CLTCODE >= @FCODE   AND L.CLTCODE <= @TCODE    
AND L.VTYP = VTYPE   
  
UNION  
  
Select   
'01' BOOKTYPE,Date VOUDT,Date EFFDT,replace(VoucherType,'-','') SHORTDESC,DebitAmt DRAMT,  
CreditAmt CRAMT,VrNo VNO,'' DDNO,Particulars NARRATION,SBCode CLTCODE,'' LONGNAME,'' VTYP,  
'' BOOKTYPE,convert(varchar(100),Date) VDT,'' EDT,''  ACNAME,'' EDIFF  
From   
#Financial_Ledger_OneTime with(nolock)  
Where (Particulars not in ('Closing Balance','Opening Balance') or isnull(Particulars,'')='')  
ORDER BY L.CLTCODE, VOUDT,  L.VNO   
  
  
END

GO
