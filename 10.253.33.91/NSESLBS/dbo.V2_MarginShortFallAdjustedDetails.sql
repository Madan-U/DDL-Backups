-- Object: PROCEDURE dbo.V2_MarginShortFallAdjustedDetails
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROC V2_MarginShortFallAdjustedDetails
	(
		@MarginDate varchar(11),		--- Mandatory
		@Party_Code varchar(10),		--- Optional
		@Exchange VarChar(3),    		--- Optional 
		@ScripCd VarChar(12),			--- Optional
		@Isin Varchar(20)   				--- Optional
	) AS    
BEGIN          
	SET NOCOUNT ON

	SET @Party_Code = CASE WHEN @Party_Code = '' THEN NULL ELSE @Party_Code END
	SET @Exchange = CASE WHEN @Exchange = '' THEN NULL ELSE @Exchange END
	SET @ScripCd = CASE WHEN @ScripCd = '' THEN NULL ELSE @ScripCd END
	SET @Isin = CASE WHEN @Isin = '' THEN NULL ELSE @Isin END
	
/*

	IF Exchange = 'NSE' AND Segment = 'CAPITAL' Then DelTrans Data For NSE
	IF Exchange = 'NSE' AND Segment = 'CAPITAL' Then DelTrans Data For BSE
	IF Exchange = 'NSE' AND Segment = 'FREEBAL' Then POA FreeBalance For NSE

*/

	SELECT Party_Code, Exchange, Segment, Scrip_Cd, ISIN, Scrip_Cd, ISIN, HoldQty, 
		BDPType, BDPID, BDDPID, Cl_Rate, HoldAmt, HairCutPercentage, AdjustedAmtAfterHairCut
		FROM MSAJAG.DBO.FOMarginShortFallAdjusted
		WHERE MarginDate Like @MarginDate + '%'
		AND Party_Code = ISNULL(@Party_Code, Party_Code)
		AND InternalExchange = ISNULL(@Exchange, InternalExchange)
		AND Scrip_Cd = ISNULL(@ScripCd, Scrip_Cd)
		AND Isin = ISNULL(@Isin, Isin)

	SET NOCOUNT OFF

END


/*

DECLARE
	@MarginDate varchar(11),
	@Party_Code varchar(10),
	@Exchange VarChar(3),    
	@ScripCd VarChar(12),
	@Isin Varchar(20)   

SET	@MarginDate = 'JUL 24 2007'
SET	@Party_Code = '' --'0A149'
SET	@Exchange = ''
SET	@ScripCd = NULL --'502420'
SET	@Isin = ''-- 'INE006A01019'

EXEC V2_MarginShortFallAdjustedDetails
		@MarginDate,
		@Party_Code,
		@Exchange,
		@ScripCd,
		@Isin


select * from bsedb.dbo.scrip2 where scrip_cd = '500105'
select * from msajag.dbo.scrip2 where scrip_cd = 'IPCL'




*/

GO
