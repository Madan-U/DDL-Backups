-- Object: PROCEDURE dbo.CBO_NEWGETTRADER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE CBO_NEWGETTRADER
(
	@shortname VARCHAR(20) = '',
  @longname VARCHAR(50)='',
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
  IF (@shortname = '' OR @shortname = '%')and(@longname = '' OR @longname = '%')
	   BEGIN
	SELECT
    Short_Name,
    Long_Name,
    Address1,
    Address2,
    City,
    State,
    Nation,
    Zip,
    Phone1,
    Phone2,
    Fax,
    Email,
    Security_Net,
    Money_Net,
    Contact_Person,
    Com_Perc,
    Terminal_Id,
    Branch_Cd
	FROM
		BRANCHES
  ORDER BY
		Short_Name
	END
   ELSE IF @shortname <> ''
		BEGIN
		SELECT
		Short_Name,
    Long_Name,
    Address1,
    Address2,
    City,
    State,
    Nation,
    Zip,
    Phone1,
    Phone2,
    Fax,
    Email,
    Security_Net,
    Money_Net,
    Contact_Person,
    Com_Perc,
    Terminal_Id,
    Branch_Cd
			FROM
				BRANCHES
			WHERE
				Short_Name LIKE @shortname + '%'
			ORDER BY
				Short_Name
		END
   Else
    BEGIN
		SELECT
		Short_Name,
    Long_Name,
    Address1,
    Address2,
    City,
    State,
    Nation,
    Zip,
    Phone1,
    Phone2,
    Fax,
    Email,
    Security_Net,
    Money_Net,
    Contact_Person,
    Com_Perc,
    Terminal_Id,
    Branch_Cd
			FROM
				BRANCHES
			WHERE
				Long_Name LIKE @longname + '%'
			ORDER BY
				Long_Name
		END

GO
