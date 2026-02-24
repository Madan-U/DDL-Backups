-- Object: PROCEDURE dbo.CBO_GETBRANCH
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE CBO_GETBRANCH
(
	@branchcode VARCHAR(80) = '',
             @branch VARCHAR(20)='',
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
  IF (@branchcode = '' OR @branchcode = '%')and(@branch = '' OR @branch = '%')
	   BEGIN
	SELECT
    Branch_Code,
    branch,
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
    Remote,
    Security_Net,
    Money_Net,
    Excise_Reg,
    Contact_Person,
    Prefix,
    RemPartyCode
	FROM
	 branch
  ORDER BY
	 Branch_Code	
	END
   ELSE IF @branchcode <> ''
		BEGIN
		SELECT
		Branch_Code,
    branch,
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
    Remote,
    Security_Net,
    Money_Net,
    Excise_Reg,
    Contact_Person,
    Prefix,
    RemPartyCode
			FROM
				branch
			WHERE
				Branch_Code LIKE @branchcode + '%'
			ORDER BY
				Branch_Code
		END
   Else
    BEGIN
		SELECT
		Branch_Code,
    branch,
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
    Remote,
    Security_Net,
    Money_Net,
    Excise_Reg,
    Contact_Person,
    Prefix,
    RemPartyCode	
			FROM
				branch
			WHERE
				branch LIKE @branch + '%'
			ORDER BY
				branch
		END

GO
