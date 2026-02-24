-- Object: PROCEDURE dbo.LEDGER_GL_MFSS_FINAL_LEDGER_NXT_V2
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE LEDGER_GL_MFSS_FINAL_LEDGER_NXT_V2 --'Apr 1 2023','Mar 31 2024','Apr 1 2023','Mar 31 2024','48BBLM','48BBML'   
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
    
SELECT      
CreditAmount=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END),  
DebitAmount=(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),      
NARRATION = REPLACE(REPLACE(L.NARRATION,'''',''),'""','') ,
VoucherDate = FORMAT(L.VDT, 'dd/MM/yyyy'),
VoucherNumber = CONVERT (varchar(50), L.VNO), 
VoucherType = TRIM(SHORTDESC),
L.VDT as VDate,
L.VNO as VNo       
FROM LEDGER L  WITH(NOLOCK) LEFT OUTER JOIN ACMAST A  WITH(NOLOCK)   
ON L.CLTCODE = A.CLTCODE , VMAST  WITH(NOLOCK)    
WHERE L.VDT >= @FDATE  AND   L.VDT <= @TDATE +' 23:59:59'                          
AND L.VTYP <> 18     
AND L.CLTCODE = A.CLTCODE     
AND L.CLTCODE >= @FCODE   AND L.CLTCODE <= @TCODE      
AND L.VTYP = VTYPE     
    
UNION    
    
Select     
DebitAmt DebitAmount,    
CreditAmt CreditAmount,Particulars NARRATION,FORMAT(Date, 'dd/MM/yyyy') VoucherDate,VrNo VoucherNumber,replace(VoucherType,'-','') VoucherType,   
convert(varchar(100),Date) VDT,VrNo as VNo    
From     
#Financial_Ledger_OneTime with(nolock)    
Where (Particulars not in ('Closing Balance','Opening Balance') or isnull(Particulars,'')='')    
ORDER BY VDate, VNo
    
    
END

GO
