-- Object: PROCEDURE dbo.S_RPT_BANKDETAILS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


        
CREATE PROC [dbo].[S_RPT_BANKDETAILS]       
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
  SCLIENT4 C (NOLOCK)          
   JOIN SPOBANK P (NOLOCK)          
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
                      When ISNULL(C.ACCTYPE,'')  = 'SAVING' Then 'SAVING'       
               When ISNULL(C.ACCTYPE,'')  = 'CURRENT' Then 'CURRENT'         
                           When ISNULL(C.ACCTYPE,'')  = 'OD' Then 'OVER DRAFT'         
                           ELSE 'OTHER'        
                  END)       
    
     
--ACTYPE = (Case When ISNULL(C.ACCTYPE,'')  = 'SB' Then 'SAVING'         
  --                         When ISNULL(C.ACCTYPE,'')  = 'CA' Then 'CURRENT'         
    --                       When ISNULL(C.ACCTYPE,'')  = 'OD' Then 'OVER DRAFT'         
      --                     ELSE 'OTHER'        
        --          END)          
 FROM          
  ACCOUNT.DBO.SMULTIBANKID C (NOLOCK)          
   JOIN SPOBANK P (NOLOCK)          
   ON (P.BANKID = C.BANKID)          
 WHERE          
  C.CLTCODE = @PARTYCODE        
  AND  ACCNO NOT IN (SELECT CLTDPID FROM SCLIENT4         
  WHERE DEPOSITORY NOT IN ('CDSL','NSDL')          
  AND PARTY_CODE = @PARTYCODE  AND SCLIENT4.BANKID = C.BANKID)        
          
 ORDER BY           
  BANKNAME

GO
