-- Object: PROCEDURE dbo.CLIENTBROKTABLE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC CLIENTBROKTABLE
(
		 @PARTY_COODE VARCHAR(20)
)
	AS
		BEGIN

    SELECT DISTINCT B.* FROM  Clientbrok_Scheme a WITH (NOLOCK),broktable  b WITH (NOLOCK)
	where Party_Code = @PARTY_COODE and To_Date > GETDATE() and A.Table_No =B.Table_No 

		End

GO
