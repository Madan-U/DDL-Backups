-- Object: FUNCTION dbo.fnclient_filter
-- Server: 10.253.33.227 | DB: inhouse
--------------------------------------------------

CREATE FUNCTION dbo.fnclient_filter
(@sbcode varchar(20),@party_code varchar(30))
RETURNS TABLE
AS RETURN
(
	SELECT DISTINCT PARTY_CODE,LONG_NAME,BRANCH_CD,SUB_BROKER 
	FROM [196.1.115.132].RISK.DBO.CLIENT_DETAILS WHERE
	SUB_BROKER LIKE @sbcode AND PARTY_CODE LIKE @party_code 
)

GO
