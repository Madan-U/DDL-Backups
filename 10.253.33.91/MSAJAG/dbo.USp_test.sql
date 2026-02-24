-- Object: PROCEDURE dbo.USp_test
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc USp_test
as
BEGIN TRY

select NO=1/0

END TRY

BEGIN CATCH
SELECT      
        ERROR_NUMBER() AS ErrorNumber      
        ,ERROR_SEVERITY() AS ErrorSeverity      
        ,ERROR_STATE() AS ErrorState      
        ,ERROR_PROCEDURE() AS ErrorProcedure      
        ,ERROR_LINE() AS ErrorLine      
        ,ERROR_MESSAGE() AS ErrorMessage      
  ,getdate() as date;   

END CATCH

GO
