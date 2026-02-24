-- Object: PROCEDURE dbo.get_currentopentry
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

Create Proc get_currentopentry 
(@Sdtcur Datetime) AS

Select SdtCur = Left(Convert(Varchar, SdtCur, 109), 11) from parameter
where @Sdtcur between sdtcur and ldtcur

GO
