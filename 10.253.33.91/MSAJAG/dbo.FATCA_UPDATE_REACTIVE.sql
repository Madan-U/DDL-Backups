-- Object: PROCEDURE dbo.FATCA_UPDATE_REACTIVE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE PROC [dbo].[FATCA_UPDATE_REACTIVE]
AS


	UPDATE A SET InActive_From ='2049-12-31 00:00:00.000',
	Imp_Status =0,Modifiedon = GETDATE(),
	Modifiedby ='FATCA_AUTO',
	Deactive_value = 'R',
	Deactive_Remarks = 'FATCA_SUMMITED'
	FROM CLIENT_BROK_DETAILS A WITH (NOLOCK), [MIS].KYC.DBO.FATCA_BO_ClientList B WITH (NOLOCK)
	WHERE  A.CL_CODE = B.[CLIENTCODE]
	--AND A.Exchange =B.Exchange
	--AND A.Segment =B.Segment
	AND InActive_From <= GETDATE()
    AND CONVERT(VARCHAR(10),B.ProcessDate,120) = CONVERT(VARCHAR(10),GETDATE(),120)

GO
