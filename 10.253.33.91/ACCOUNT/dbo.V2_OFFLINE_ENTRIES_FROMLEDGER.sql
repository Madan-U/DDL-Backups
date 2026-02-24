-- Object: PROCEDURE dbo.V2_OFFLINE_ENTRIES_FROMLEDGER
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE Proc [dbo].[V2_OFFLINE_ENTRIES_FROMLEDGER]    
(@EXCHANGE VARCHAR(3), @SEGMENT VARCHAR(10))  
  
as    
  
--INSERT INTO V2_OFFLINE_LEDGER_ENTRIES  
Select z.*  from     
(    
Select l.Vtyp, l.BookTYpe,  
Lno =(case when L.vtyp not in ('6','7','8') then    
 CAST(L.LNO AS INT) - 1   
else  
 l.lno  
   end    
 ),  
vdt =cast(left(l.Vdt,11) as datetime), evdt =cast(left(l.edt,11) as datetime), l.CltCode,CreditAmt= Case when L.drcr = 'C' then l.Vamt else 0 end ,    
DebitAmt = Case when L.drcr = 'D' then l.Vamt else 0 end,     
l.Narration,     
OppCode = (case when L.vtyp not in (6,7,8) then    
  case when L.lno = 1 then l.CltCode     
   else    
    (Select top 1 CltCode from Ledger x where x.vno = l.vno and x.vtyp = l.vtyp and x.booktype = l.booktype and x.lno = 1)    
   end    
    else '' end),    
MARGINCODE = '',  
BankName= l1.BNKNAME,    
BankBranch = L1.BRNNAME, a.BranchCode,     
DDNo = L1.DDNO,     
ChqMode =  L1.DD,  
ChqDt = L1.DDDT,     
ChqName = L1.CHEQUEINNAME,    
ClearMode = L1.CLEAR_MODE,     
TPACNum = (CASE WHEN A.ACNAME = L1.CHEQUEINNAME THEN 1 ELSE 0 END),   
Exchange='NSE',    
Segment='CAPITAL',    
TPFlag = '0',    
AddDt = l.pdt,     
AddBy = l.EnteredBy,    
StatusId= 'STATUSID',    
StatusName = 'STATUSNAME',    
RowState = 1,    
ApprovalFlag = 1,    
ApprovedDt = l.pdt,     
ApprovedBy = l.CheckedBy,     
VoucherNo = l.Vno,     
UploadDt = l.Pdt,     
LedgerVno = l.vno,     
ClientName = a.AcName,     
OppCodeName = a.AcName,     
MarginCodeName = '',    
SettNo = '',    
SettType = '',    
ProductType = '',    
RevAmt = 0,    
RevCode = '',    
MICR = L1.MICRNO
From Ledger l    
join acmast a    
on (a.cltcode = l.cltcode)    
LEFT OUTER JOIN LEDGER1 L1  
ON (L1.VTYP = L.VTYP AND L1.VNO = L.VNO AND L1.BOOKTYPE = L.BOOKTYPE AND L1.LNO = L.LNO)  
LEFT OUTER JOIN LEDGER2 L2
	LEFT OUTER JOIN COSTMAST CM
		LEFT OUTER JOIN CATEGORY C ON (C.CATCODE = CM.CATCODE)
		ON (CM.COSTCODE = L2.COSTCODE)
ON (L2.VTYPE = L.VTYP AND L2.VNO = L.VNO AND L2.BOOKTYPE = L.BOOKTYPE AND L2.LNO = L.LNO)  
Where l.Vtyp < '10'    
) z     
where z.cltcode <> z.oppcode    
Order by VTyp    
    
--INSERT INTO V2_OFFLINE_CC_ENTRIES  
SELECT V.FLDAUTO, 
CCCREDIT = CASE WHEN L2.DRCR = 'D' THEN CAMT ELSE 0 END,
CCDEBIT = CASE WHEN L2.DRCR = 'C' THEN CAMT ELSE 0 END,
V.CLTCODE, 
V.OPPCODE,
V.BRANCHCODE,
C.CATEGORY,
CM.COSTNAME,
V.ADDBY,
V.STATUSID,
V.STATUSNAME,
V.ADDDT
FROM AngelBSECM.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES V
LEFT OUTER JOIN LEDGER2 L2
	LEFT OUTER JOIN COSTMAST CM
		LEFT OUTER JOIN CATEGORY C ON (C.CATCODE = CM.CATCODE)
		ON (CM.COSTCODE = L2.COSTCODE)
ON (L2.VTYPE = V.VOUCHERTYPE AND L2.VNO = V.LEDGERVNO AND L2.BOOKTYPE = V.BOOKTYPE AND L2.LNO = V.SNO)  
WHERE ISNULL(C.CATEGORY,'') <> ''

GO
