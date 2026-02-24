-- Object: PROCEDURE dbo.ANGEL_CLIENT_RECEIPT_RECO
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

Create Proc ANGEL_CLIENT_RECEIPT_RECO
as
Begin
Set NoCount On
	Exec account.dbo.ANGEL_CLIENT_RECEIPT_RECO
Set NoCount Off
End

GO
