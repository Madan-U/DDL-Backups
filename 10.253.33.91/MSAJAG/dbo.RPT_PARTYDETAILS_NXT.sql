-- Object: PROCEDURE dbo.RPT_PARTYDETAILS_NXT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



   CREATE PROCEDURE [dbo].[RPT_PARTYDETAILS_NXT]                   

                  

@PARTYCODE AS VARCHAR(20),                  
@Exchange AS VARCHAR(20),
@Segment AS VARCHAR(20)   
                      

AS                   

                  

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                              

SELECT CL2.CL_CODE,                                  

 CL2.PARTY_CODE,                                  

CL1.EMAIL,                                    

MOBILE_PAGER                                         

 FROM                                  

  CLIENT2 CL2 (NOLOCK), CLIENT1 CL1 LEFT OUTER JOIN CLIENT5 C5  (NOLOCK) ON ( C5.CL_CODE = CL1.CL_CODE ) ,                                  

  SUBBROKERS S1 (NOLOCK),BRANCH B1 (NOLOCK), TAXES T     (NOLOCK), CLIENTSTATUS S (NOLOCK)       

  ,MSAJAG..client_brok_details CB  (nolock)                          

  WHERE CL1.CL_CODE = CL2.CL_CODE                                  

  AND CL2.TRAN_CAT = T.TRANS_CAT                                  

  AND S1.SUB_BROKER = CL1.SUB_BROKER                                    

  AND CL2.PARTY_CODE =@PARTYCODE                                                                  

  AND B1.BRANCH_CODE = CL1.BRANCH_CD                                  

  AND CL1.CL_STATUS = S.CL_STATUS               

 and t.to_date='2049-12-31 23:59:59.000'      

 AND CB.Exchange = @Exchange AND CB.Segment= @Segment   

  And Cl1.cl_code = CB.cl_code

GO
