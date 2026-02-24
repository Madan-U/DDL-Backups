-- Object: PROCEDURE citrus_usr.DIS_getclnt
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


Create PROCEDURE  [citrus_usr].[DIS_getclnt](@PA_ACCOUNT_ID varchar(50))
AS
BEGIN
	 select DPAM_SBA_NAME from DP_ACCT_MSTR where DPAM_SBA_NO = @PA_ACCOUNT_ID
return 
END

GO
