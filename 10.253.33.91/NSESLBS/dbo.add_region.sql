-- Object: PROCEDURE dbo.add_region
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE proc add_region
     @region_code  varchar(20),
     @desc       varchar(50),
     @code_bran  varchar(10)
AS
 INSERT INTO REGION
		(Regioncode,Description,Branch_Code)
	VALUES
		(@region_code,@desc,@code_bran)

GO
