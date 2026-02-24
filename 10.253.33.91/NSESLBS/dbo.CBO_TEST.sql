-- Object: PROCEDURE dbo.CBO_TEST
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC CBO_TEST
(
	@USER_NAME VARCHAR(25) output,
	@PASS VARCHAR(25) output,
	@PWDMINLENGTH varchar(20) OUTPUT
)

AS

SELECT  @PWDMINLENGTH='10' ,	@USER_NAME= 'ee', @PASS ='rrr'

GO
