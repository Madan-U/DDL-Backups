-- Object: PROCEDURE dbo.USP_Closure_Process_MF_bkp14Jun2018
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_Closure_Process_MF_bkp14Jun2018]
	-- Add the parameters for the stored procedure here
	(@party_Code varchar(20),
	@segment varchar(20),
	@empNo varchar(20))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @Deactive_Remarks VARCHAR(500);
DECLARE @RowCount1 BIGINT;
DECLARE @ErrorFlag NVARCHAR(MAX);
DECLARE @tableHTML VARCHAR(MAX);
DECLARE @Subject VARCHAR(200);   


begin try


        SET @Deactive_Remarks =(SELECT TOP 1 ISNULL(Deactive_value, '1')
						  FROM Angelfo.BSEMFSS.dbo.MFSS_Client
						  WHERE Party_code = @party_Code);

        PRINT 'Deactivate Remark: '+@Deactive_Remarks;
        IF(ISNULL(@Deactive_Remarks, '') <> 'C' OR ISNULL(@Deactive_Remarks, '') = '1') 
            BEGIN

                PRINT 'Deactivate Update in BO: '+@party_Code+' '+@segment;
			 
                UPDATE Angelfo.BSEMFSS.dbo.MFSS_Client
                 SET
                     DEACTIVE_REMARKS = 'AS PER CLIENT CLOSURE REQUEST RECEIVED',
                     REMARK = 'AS PER CLIENT CLOSURE REQUEST RECEIVED',
                     INACTIVE_FROM = GETDATE(),
                     DEACTIVE_VALUE = 'C',
				 POAFLAG='NO'
                WHERE Party_code = @party_Code;

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('MF' AS VARCHAR(30)) AS segment, 'MF_DEACTIVATE', GETDATE() AS updatedOn, 'Y' AS Processed, 'N', 'N';

			 select 'Successful Deactivate Update in BO: '+@party_Code+' '+@segment;
            END;
            ELSE
            BEGIN

                PRINT 'Already Deactivated: '+@party_Code+' '+@segment;

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('MF' AS VARCHAR(30)) AS segment, 'ALREADY MF DEACTIVATE', GETDATE() AS updatedOn, 'N' AS Processed, 'N', 'N';

			 select 'Successful Already Deactivated: '+@party_Code+' '+@segment;
            END;

   end try
begin catch

print 'catch'   
    SELECT @ErrorFlag=ERROR_MESSAGE()

	Print @ErrorFlag
    
      set @Subject = 'Error: [anand1].msajag.dbo.USP_Closure_Process_MF '+@party_Code
	  SET @tableHTML =''+cast(@ErrorFlag as varchar(8000))+''
	  exec msdb.dbo.sp_send_dbmail   
     @recipients = 'Priyanka.Shrikant@angelbroking.com',
      @body_format='HTML',                            
      @subject = @Subject,                            
      @body = @tableHTML,                           
      @profile_name ='MimansaTeam'

end catch


END

GO
