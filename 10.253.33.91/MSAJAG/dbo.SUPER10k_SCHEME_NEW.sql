-- Object: PROCEDURE dbo.SUPER10k_SCHEME_NEW
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[SUPER10k_SCHEME_NEW]       
(      
 @PARTY VARCHAR(20)       
)      
AS       
      
BEGIN       
      
 DECLARE @TABLE_NAME VARCHAR(20) =  'SUPER10 k'      
 SELECT  @PARTY  AS PARTY_CODE, @TABLE_NAME AS  TABLE_NAME INTO #CST      
       
 EXEC SUPER10k_SCHEME @PARTY      
 EXEC [AngelBSECM].BSEDB_AB.DBO.SUPER10k_SCHEME @PARTY       
 EXEC [AngelFO].NSEFO.DBO.SUPER10k_SCHEME @PARTY       
 EXEC [AngelFO].NSECURFO.DBO.SUPER10k_SCHEME @PARTY       
 EXEC [AngelCommodity].MCDX.DBO.SUPER10k_SCHEME @PARTY       
 EXEC [AngelCommodity].NCDX.DBO.SUPER10k_SCHEME @PARTY       
 EXEC [AngelCommodity].BSECURFO.DBO.SUPER10k_SCHEME @PARTY       
       
      
  INSERT INTO INTRANET.RISK.DBO.Tbl_ClientScheme       
  SELECT *,GETDATE() D,'C_E77491' E FROM  #CST       
      
END

GO
