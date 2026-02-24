-- Object: PROCEDURE dbo.LEDGER_GL_MFSS_FINAL_LEDGER_NXT_V3
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE LEDGER_GL_MFSS_FINAL_LEDGER_NXT_V3   
(      
@SDATE VARCHAR(12),                          
@EDATE VARCHAR(12),       
@FCODE VARCHAR(10)      
)       
      
AS      
BEGIN      
SELECT CreditAmount, DebitAmount, NARRATION, VoucherDate, VoucherNumber, VoucherType FROM
(SELECT 
    CreditAmount = (CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END), 
    DebitAmount = (CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END), 
    NARRATION = REPLACE(REPLACE(L.NARRATION,'''',''),'""',''),
    VoucherDate = FORMAT(L.VDT, 'dd/MM/yyyy'),
    VoucherNumber = CONVERT (varchar(50), L.VNO),
    VoucherType = TRIM(SHORTDESC),
    L.VDT as VDate,
    L.VNO as VNo
FROM 
    LEDGER L with(nolock)
LEFT OUTER JOIN
    VMAST V with(nolock) ON L.VTYP = V.Vtype
	WHERE (L.VDT >= @SDATE AND L.VDT <= @EDATE) AND L.CLTCODE = @FCODE AND L.VTYP <> 18 AND L.VTYP = VTYPE 
	) AS A
    ORDER BY VDate, VNo
END

GO
