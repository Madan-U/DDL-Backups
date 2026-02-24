-- Object: PROCEDURE dbo.RPT_AREALISTING
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC [dbo].[RPT_AREALISTING]
	(
    @FROMAREACODE VARCHAR(15),
	@TOAREACODE VARCHAR(15),
	@FROMBRANCH VARCHAR(15),
	@TOBRANCH VARCHAR(15)
	)
	
AS
    if @FROMAREACODE = '' begin set @FROMAREACODE = '0'  end
    if @TOAREACODE = '' begin set @TOAREACODE = 'zzzzzz' end
    if @FROMBRANCH = '' begin set @FROMBRANCH = '0'  end
    if @TOBRANCH = '' begin set @TOBRANCH = 'zzzzzz' end

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT 
			Areacode = UPPER(Areacode),
			Description = UPPER(Description),
			Branch_Code = UPPER(Branch_Code)

From 
    AREA

Where
    Areacode between @FROMAREACODE and @TOAREACODE
    AND Branch_Code between @FROMBRANCH and @TOBRANCH
    

Order by
		Areacode,Description,Branch_Code

GO
