-- Object: PROCEDURE dbo.spx_ANGELPRIME0TO15_PlanUpdate_ALL
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[spx_ANGELPRIME0TO15_PlanUpdate_ALL]       
(      
@ClientCode varchar(20)='',      
@CampaignType varchar(50) ,      
@Msg varchar(50) output      
)      
AS       
      
BEGIN       
      
       
 EXEC spx_ANGELPRIME0TO15_PlanUpdate @ClientCode ,@CampaignType ,@Msg=@Msg out      
 EXEC [AngelBSECM].BSEDB_AB.DBO.spx_ANGELPRIME0TO15_PlanUpdate @ClientCode , @CampaignType ,@Msg=@Msg out      
 EXEC [AngelFO].NSEFO.DBO.spx_ANGELPRIME0TO15_PlanUpdate @ClientCode ,@CampaignType ,@Msg=@Msg out      
 EXEC [AngelFO].NSECURFO.DBO.spx_ANGELPRIME0TO15_PlanUpdate @ClientCode ,@CampaignType ,@Msg=@Msg out      
 EXEC [AngelCommodity].MCDX.DBO.spx_ANGELPRIME0TO15_PlanUpdate @ClientCode ,@CampaignType ,@Msg=@Msg out      
 EXEC [AngelCommodity].NCDX.DBO.spx_ANGELPRIME0TO15_PlanUpdate @ClientCode ,@CampaignType ,@Msg=@Msg out      
 EXEC [AngelCommodity].BSECURFO.DBO.spx_ANGELPRIME0TO15_PlanUpdate @ClientCode ,@CampaignType ,@Msg=@Msg out      
       
      
  INSERT INTO INTRANET.RISK.DBO.Tbl_ClientScheme       
  SELECT @ClientCode,@CampaignType,GETDATE() D,'C_E77491' E       
      
END

GO
