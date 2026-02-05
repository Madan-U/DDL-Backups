-- Object: FUNCTION citrus_usr.DPBM_FN_GETBRANCHNAME_New
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [citrus_usr].[DPBM_FN_GETBRANCHNAME_New]

(
@BANKNAME VARCHAR(500)
)RETURNS VARCHAR(500)
BEGIN

DECLARE @VARIABLE VARCHAR(8000)

IF CHARINDEX(' - ',@BANKNAME) <> 0 
	BEGIN
		SELECT @VARIABLE=rtrim(ltrim(substring(@BANKNAME,(len(citrus_usr.FN_GETBANKNAME(@BANKNAME))+len(' - '))+1,len(@BANKNAME)-len(citrus_usr.FN_GETBANKNAME(@BANKNAME)))))
	END
ELSE IF CHARINDEX(' -',@BANKNAME) <> 0 
	BEGIN
		SELECT @VARIABLE=rtrim(ltrim(substring(@BANKNAME,(len(citrus_usr.FN_GETBANKNAME(@BANKNAME))+len(' -'))+1,len(@BANKNAME)-len(citrus_usr.FN_GETBANKNAME(@BANKNAME)))))
	END

ELSE IF CHARINDEX('- ',@BANKNAME) <> 0
	BEGIN
		SELECT @VARIABLE=rtrim(ltrim(substring(@BANKNAME,(len(citrus_usr.FN_GETBANKNAME(@BANKNAME))+len('- '))+1,len(@BANKNAME)-len(citrus_usr.FN_GETBANKNAME(@BANKNAME)))))
	END

ELSE IF CHARINDEX('-',@BANKNAME) <> 0
	BEGIN
		SELECT @VARIABLE=rtrim(ltrim(substring(@BANKNAME,(len(citrus_usr.FN_GETBANKNAME(@BANKNAME))+len('-'))+1,len(@BANKNAME)-len(citrus_usr.FN_GETBANKNAME(@BANKNAME)))))
	END

ELSE
	BEGIN
		SELECT @VARIABLE=@BANKNAME
	END

RETURN @VARIABLE
END

GO
