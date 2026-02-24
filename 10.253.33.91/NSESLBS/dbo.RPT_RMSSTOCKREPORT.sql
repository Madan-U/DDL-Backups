-- Object: PROCEDURE dbo.RPT_RMSSTOCKREPORT
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC RPT_RMSSTOCKREPORT      
 (      
 @SDATE VARCHAR(11),      
 @FROMFAMILY VARCHAR(15),      
 @FROMPARTY VARCHAR(15),      
 @SCRIPCD VARCHAR(15),      
 @STATUSNAME VARCHAR(25),      
 @STATUSID VARCHAR(15)      
 )      
      
 AS      
      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
 SELECT       
  C1.family,       
  D.party_code,       
  C1.long_name,       
  scrip_cd = RTRIM(SCRIP_NAME) + ' (' + RTRIM(SCRIP_CD) + ') (' + RTRIM(CERTNO) + ')',       
  HoldQty = sum(Case When HoldFlag = 'HOLD' Then DebitQty Else 0 End),      
  PendingQty = sum(Case When HoldFlag = 'PAY' Then DebitQty Else 0 End),  
  ShrtQty = sum(Case When HoldFlag = 'SHRT' Then ShrtQty Else 0 End),  
  Cl_Rate = (Case When Sum(DebitQty + ShrtQty) > 0       
    Then Round(sum(Cl_Rate*(DebitQty + ShrtQty))/Sum(DebitQty + ShrtQty),2)       
    Else 0 End)       
 FROM       
  Deldebitsummarynew D (NOLOCK),       
  Client1 C1 (NOLOCK),       
  Client2 C2 (NOLOCK)       
       
 Where       
  C1.Cl_Code = C2.Cl_Code       
  And C2.Party_Code = D.Party_Code       
  And RunDate LIKE @SDATE + '%'      
  AND c1.family like @FROMFAMILY + '%'       
  AND D.party_code like @FROMPARTY + '%'       
  AND scrip_cd like @SCRIPCD + '%'       
                AND @STATUSNAME = (         
                CASE       
                 WHEN @STATUSID = 'BRANCH'       
                 THEN C1.BRANCH_CD       
                 WHEN @STATUSID = 'SUBBROKER'       
                 THEN C1.SUB_BROKER       
                 WHEN @STATUSID = 'TRADER'       
                 THEN C1.TRADER       
                 WHEN @STATUSID = 'FAMILY'       
                 THEN C1.FAMILY       
                 WHEN @STATUSID = 'AREA'       
                 THEN C1.AREA       
                 WHEN @STATUSID = 'REGION'       
                 THEN C1.REGION       
                 WHEN @STATUSID = 'CLIENT'       
                 THEN C2.PARTY_CODE       
                 ELSE 'BROKER' END)       
       
 Group By       
  C1.family,       
  D.party_code,       
  C1.long_name,       
RTRIM(SCRIP_NAME) + ' (' + RTRIM(SCRIP_CD) + ') (' + RTRIM(CERTNO) + ')'   
 having Sum(DebitQty+ShrtQty) > 0       
 Order By       
  C1.family,       
  D.party_code,       
RTRIM(SCRIP_NAME) + ' (' + RTRIM(SCRIP_CD) + ') (' + RTRIM(CERTNO) + ')'

GO
