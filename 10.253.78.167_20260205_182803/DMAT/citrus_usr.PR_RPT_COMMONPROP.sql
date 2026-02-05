-- Object: PROCEDURE citrus_usr.PR_RPT_COMMONPROP
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create PROCEDURE PR_RPT_COMMONPROP
(
@PA_LOGIN_NAME VARCHAR(20)
)
AS
BEGIN
SELECT * FROM TMP_PROP_BULK
END

GO
