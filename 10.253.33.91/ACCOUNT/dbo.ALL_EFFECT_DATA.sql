-- Object: PROCEDURE dbo.ALL_EFFECT_DATA
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

  
  
  
CREATE PROC [dbo].[ALL_EFFECT_DATA]    
(    @A INT  
  
)  
AS  
   
 DECLARE @TODATE VARCHAR (10) =CONVERT(VARCHAR(11),GETDATE()- @A ,120)  
  
 TRUNCATE TABLE NSE_DATE  
  
 INSERT INTO NSE_DATE  
 EXEC EFFCT_DATA @A  
  
 TRUNCATE TABLE BSE_DATE  
  
 INSERT INTO BSE_DATE  
 EXEC AngelBSECM.ACCOUNT_AB.DBO.EFFCT_DATA @A  
  
 TRUNCATE TABLE NSEFO_DATE  
  
 INSERT INTO NSEFO_DATE  
 EXEC ANGELFO.ACCOUNTFO.DBO.EFFCT_DATA @A  
   
 TRUNCATE TABLE NSX_DATE  
  
 INSERT INTO NSX_DATE  
 EXEC ANGELFO.ACCOUNTCURFO.DBO.EFFCT_DATA @A  
   
 TRUNCATE TABLE MCX_DATE  
  
 INSERT INTO MCX_DATE  
 EXEC [AngelCommodity].ACCOUNTMCDX.DBO.EFFCT_DATA @A  
   
 TRUNCATE TABLE NCX_DATE  
  
 INSERT INTO NCX_DATE  
 EXEC [AngelCommodity].ACCOUNTNCDX.DBO.EFFCT_DATA @A  
   
 TRUNCATE TABLE MTF_DATE  
  
 INSERT INTO MTF_DATE  
 EXEC MTFTRADE.DBO.EFFCT_DATA @A  
   
 TRUNCATE TABLE BSX_DATE  
  
 INSERT INTO BSX_DATE  
 EXEC [AngelCommodity].ACCOUNTCURBFO.DBO.EFFCT_DATA @A  
  
  
  
  
  
  
  
  
  
  
  
  
-- Declare @execution_id bigint  
--EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Package.dtsx',  
--    @execution_id=@execution_id OUTPUT,  
--    @folder_name=N'Deployed Projects',  
--   @project_name=N'Integration Services Project1',  
--   @use32bitruntime=False,  
--   @reference_id=Null  
--Select @execution_id  
--DECLARE @var0 smallint = 1  
--EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  
--    @object_type=50,  
--   @parameter_name=N'LOGGING_LEVEL',  
--   @parameter_value=@var0  
--EXEC [SSISDB].[catalog].[start_execution] @execution_id  
--GO

GO
