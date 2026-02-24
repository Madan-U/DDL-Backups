-- Object: PROCEDURE dbo.add_area
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE proc add_area
     @area_code  varchar(20),
     @desc       varchar(50),
     @code_bran  varchar(10)
AS
 INSERT INTO AREA
		(Areacode,Description,Branch_Code)
	VALUES
		(@area_code,@desc,@code_bran)

GO
