-- Object: PROCEDURE citrus_usr.PR_PANEL_MSTR
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--exec PR_PANEL_MSTR 'pass','newcm'
CREATE PROCEDURE [citrus_usr].[PR_PANEL_MSTR]
(@PA_LOGIN_NAME VARCHAR(30),@pa_ref_cur varchar(20) output)
AS 
BEGIN
SELECT columnname,
columntype,
maxlength,
actualdatatype,
actualdatatypemaxlength,
hiddenyn,
ord,
displayname,
isnull(defaultval,'') defaultval,
enable FROM PANELTABLESTRUCTURE WHERE HIDDENYN='N' ORDER BY ORD
END

GO
