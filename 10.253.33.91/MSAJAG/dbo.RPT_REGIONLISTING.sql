-- Object: PROCEDURE dbo.RPT_REGIONLISTING
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[RPT_REGIONLISTING]
	(
    	@FROMREGION VARCHAR(15),
	@TOREGION VARCHAR(15),
	@FROMBRANCH VARCHAR(15),
	@TOBRANCH VARCHAR(15)
	)
	
AS
    if @FROMREGION = '' begin set @FROMREGION = '0'  end
    if @TOREGION = '' begin set @TOREGION = 'zzzzzz' end
    if @FROMBRANCH = '' begin set @FROMBRANCH = '0'  end
    if @TOBRANCH = '' begin set @TOBRANCH = 'zzzzzz' end

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT 
			Regioncode = UPPER(Regioncode),
			Description = UPPER(Description),
			Branch_Code = UPPER(Branch_Code)

From 
    Region

Where
    Regioncode between @FROMREGION and @TOREGION
    AND Branch_Code between @FROMBRANCH and @TOBRANCH
    

Order by
		Regioncode,Description,Branch_Code

GO
