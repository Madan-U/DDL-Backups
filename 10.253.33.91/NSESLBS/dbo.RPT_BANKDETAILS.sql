-- Object: PROCEDURE dbo.RPT_BANKDETAILS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_BANKDETAILS     
 (     
 @PARTYCODE VARCHAR(10)     
 )    
    
 --EXEC RPT_BANKDETAILS 'O123'    
     
 AS    
     
 SET NOCOUNT ON     
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
 SELECT     
  BANKNAME = ISNULL(P.BANK_NAME,''),    
  BRANCH = ISNULL(P.BRANCH_NAME,''),    
  ACNUM = ISNULL(C.CLTDPID,''),    
  ACTYPE = ISNULL(C.DEPOSITORY,'')    
 FROM    
  CLIENT4 C (NOLOCK)    
   JOIN POBANK P (NOLOCK)    
   ON (P.BANKID = C.BANKID)    
 WHERE    
  C.DEPOSITORY NOT IN ('CDSL','NSDL')    
  AND C.PARTY_CODE = @PARTYCODE    
    
------    
UNION    
------    
      
 SELECT     
  BANKNAME = ISNULL(P.BANK_NAME,''),    
  BRANCH = ISNULL(P.BRANCH_NAME,''),    
  ACNUM = ISNULL(C.ACCNO,''),    
  ACTYPE = (Case When ISNULL(C.ACCTYPE,'')  = 'SB' Then 'SAVING'   
                           When ISNULL(C.ACCTYPE,'')  = 'CA' Then 'CURRENT'   
                           When ISNULL(C.ACCTYPE,'')  = 'OD' Then 'OVER DRAFT'   
                           ELSE 'OTHER'  
                  END)    
 FROM    
  ACCOUNTSLBS.DBO.MULTIBANKID C (NOLOCK)    
   JOIN POBANK P (NOLOCK)    
   ON (P.BANKID = C.BANKID)    
 WHERE    
  C.CLTCODE = @PARTYCODE  
  AND  ACCNO NOT IN (SELECT CLTDPID FROM CLIENT4   
  WHERE DEPOSITORY NOT IN ('CDSL','NSDL')    
  AND PARTY_CODE = @PARTYCODE  AND CLIENT4.BANKID = C.BANKID)  
    
 ORDER BY     
  BANKNAME

GO
