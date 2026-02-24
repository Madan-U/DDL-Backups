-- Object: PROCEDURE dbo.PROC_SCRIP_MAPPING_UPLOAD
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE  PROCEDURE [dbo].[PROC_SCRIP_MAPPING_UPLOAD]
(
 @FilePath VARCHAR(800)
 )
AS

exec NSE_SCRIPMAPPINGUPLOAD @FilePath

exec NSE_SCRIPMAPPINGINSERT

GO
