-- Object: PROCEDURE dbo.CBO_GETPOBANKsrch
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE  PROC CBO_GETPOBANKsrch
	@BANK_NAME VARCHAR(50),
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
AS
	
	IF @BANK_NAME <> ''
		BEGIN
			SELECT
					BANKID,
					BANK_NAME,
					BRANCH_NAME,
					ADDRESS1,
					ADDRESS2,
					CITY,
					STATE,
					NATION,
					ZIP,
					PHONE1,
					PHONE2,
					FAX,
					EMAIL

			FROM
				POBANK
			WHERE
				BANK_NAME LIKE @BANK_NAME + '%'
			ORDER BY
				BANKID
			
			END

GO
