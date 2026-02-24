-- Object: PROCEDURE dbo.rptRemisierBrokerageMasterDetails
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


--Report: Remisier Brokerage Master (Scheme/Slab)
CREATE PROCEDURE rptRemisierBrokerageMasterDetails
(
	@RemType VARCHAR(10),
	@Segment VARCHAR(10),
	@Exchange VARCHAR(5),
	@SchemeOrSlab VARCHAR(7),
	@ExecDate VARCHAR(11)
)
AS
BEGIN

	IF @RemType = 'ALL'
		SET @RemType = ''

	--- NSE BROK TABLE
	SELECT *, SEGMENT=CONVERT(CHAR(10), 'CAPITAL'), EXCHANGE=CONVERT(CHAR(5), 'NSECM') INTO #BrokTable FROM MSAJAG.DBO.BROKTABLE
	
	--- BSE BROK TABLE
	INSERT INTO #BrokTable SELECT *, SEGMENT=CONVERT(CHAR(10), 'CAPITAL'), EXCHANGE=CONVERT(CHAR(5), 'BSECM') FROM BSEDB.DBO.BROKTABLE
	
	--- NSEFO BROK TABLE
	INSERT INTO #BrokTable SELECT *, SEGMENT=CONVERT(CHAR(10), 'FUTURES'), EXCHANGE=CONVERT(CHAR(5), 'NSEFO') FROM NSEFO.DBO.BROKTABLE
	
	--- NCDX BROK TABLE
	INSERT INTO #BrokTable SELECT *, SEGMENT=CONVERT(CHAR(10), 'COMMODITY'), EXCHANGE=CONVERT(CHAR(5), 'NCDX') FROM NCDX.DBO.BROKTABLE
	
	--- MCDX BROK TABLE
	INSERT INTO #BrokTable SELECT *, SEGMENT=CONVERT(CHAR(10), 'COMMODITY'), EXCHANGE=CONVERT(CHAR(5), 'MCDX') FROM MCDX.DBO.BROKTABLE

--Report: Remisier Brokerage Scheme Master (Scheme)
	IF @SchemeOrSlab = 'SCHEME'
		SELECT DISTINCT
		Rm.FromDate,
		Rm.ToDate,
		BrokScheme = (SELECT [Desc] FROM MSAJAG.DBO.Schemes WHERE SchemeID = Rs.BrokScheme),
		'TRADING' AS Brokerage,
		Rm.SchemeID, 
		CASE RemType WHEN 'BR' THEN 'BRANCH' WHEN 'SUB' THEN 'SBU' WHEN 'PARTY' THEN 'Party' END AS RemType,
		RemCode,
		RemPartyCd,
		RemPartyName=Dbo.GetPartyNameForGivenPartyCode(RemPartyCd),
		EntityCode,
		Rm.Segment,
		Rm.Exchange,
		BrokType,
		Rs.TrdTableNo AS TableNo, 
		Trd.Line_No AS LNo,
		Trd.Val_Perc,
		Trd.Lower_Lim,
		Trd.Upper_Lim,
		Trd.Day_Puc,
		Trd.Day_Sales,
		Trd.Sett_Purch,
		Trd.Sett_Sales,
		Trd.Normal,
		Trd.Round_To
		FROM RemisierBrokerageMaster AS Rm, RemisierBrokerageScheme AS Rs, #BrokTable AS Trd
		WHERE 
		Rm.SchemeID = Rs.SchemeID
		AND Rm.SchemeOrSlab = 'SCHEME'
		AND Rs.TrdTableNo = Trd.Table_No
		--AND Trd.Trd_Del= 'T'
		AND RemType = CASE WHEN @RemType = '' THEN RemType ELSE @RemType END
		AND SchemeOrSlab = CASE WHEN @SchemeOrSlab = '' THEN SchemeOrSlab ELSE @SchemeOrSlab END
		AND FromDate <= CASE @ExecDate WHEN '' THEN FromDate ELSE @ExecDate END 
		AND ToDate >= CASE @ExecDate WHEN '' THEN ToDate ELSE @ExecDate END 
		AND Rm.Segment = CASE @Segment WHEN 'ALL' THEN Rm.Segment ELSE @Segment END
		AND Rm.Exchange = CASE @Exchange WHEN 'ALL' THEN Rm.Exchange ELSE @Exchange END
		AND Trd.Segment = CASE WHEN Rm.Segment IN ('CAPITAL', 'ALL') THEN 'CAPITAL' END
		AND Trd.Exchange = CASE WHEN Rm.Exchange IN ('ALL', 'NSECM', 'BSECM') THEN Trd.Exchange END
		
		UNION ALL
		
		SELECT DISTINCT  
		Rm.FromDate,
		Rm.ToDate,
		BrokScheme = (SELECT [Desc] FROM MSAJAG.DBO.Schemes WHERE SchemeID = Rs.BrokScheme),
		'DELIVERY' AS Brokerage,
		Rm.SchemeID,
		CASE RemType WHEN 'BR' THEN 'BRANCH' WHEN 'SUB' THEN 'SBU' WHEN 'PARTY' THEN 'Party' END AS RemType,
		RemCode,
		RemPartyCd,
		RemPartyName=Dbo.GetPartyNameForGivenPartyCode(RemPartyCd),
		EntityCode,
		Rm.Segment,
		Rm.Exchange,	
		BrokType,
		Rs.DelTableNo AS TableNo, 
		Del.Line_No AS LNo,
		Del.Val_Perc,
		Del.Lower_Lim,
		Del.Upper_Lim,
		Del.Day_Puc,
		Del.Day_Sales,
		Del.Sett_Purch,
		Del.Sett_Sales,
		Del.Normal,
		Del.Round_To
		FROM RemisierBrokerageMaster AS Rm, RemisierBrokerageScheme AS Rs, #BrokTable AS Del
		WHERE 
		Rm.SchemeID = Rs.SchemeID
		AND Rm.SchemeOrSlab = 'SCHEME'
		AND Rs.DelTableNo = Del.Table_No
		--AND Del.Trd_Del= 'D'
		AND RemType = CASE WHEN @RemType = '' THEN RemType ELSE @RemType END
		AND SchemeOrSlab = CASE WHEN @SchemeOrSlab = '' THEN SchemeOrSlab ELSE @SchemeOrSlab END
		AND FromDate <= CASE @ExecDate WHEN '' THEN FromDate ELSE @ExecDate END 
		AND ToDate >= CASE @ExecDate WHEN '' THEN ToDate ELSE @ExecDate END 
		AND Rm.Segment = CASE @Segment WHEN 'ALL' THEN Rm.Segment ELSE @Segment END
		AND Rm.Exchange = CASE @Exchange WHEN 'ALL' THEN Rm.Exchange ELSE @Exchange END
		AND Rm.Segment IN ('CAPITAL', 'ALL') AND Rm.Exchange IN ('ALL', 'NSECM', 'BSECM')
		AND Del.Segment = CASE WHEN Rm.Segment IN ('CAPITAL', 'ALL') THEN 'CAPITAL' END
		AND Del.Exchange = CASE WHEN Rm.Exchange IN ('ALL', 'NSECM', 'BSECM') THEN Del.Exchange END

		UNION ALL
	
		SELECT DISTINCT 
		Rm.FromDate,
		Rm.ToDate,
		BrokScheme = (SELECT [Desc] FROM NSEFO.DBO.Schemes WHERE SchemeID = Rs.BrokScheme),
		'FUTURES' AS Brokerage,
		Rm.SchemeID,
		CASE RemType WHEN 'BR' THEN 'BRANCH' WHEN 'SUB' THEN 'SBU' WHEN 'PARTY' THEN 'Party' END AS RemType,
		RemCode,
		RemPartyCd,
		RemPartyName=Dbo.GetPartyNameForGivenPartyCode(RemPartyCd),
		EntityCode,
		Rm.Segment,
		Rm.Exchange,
		BrokType,
		Rs.FutTableNo AS TableNo, 
		Fut.Line_No AS LNo,
		Fut.Val_Perc,
		Fut.Lower_Lim,
		Fut.Upper_Lim,
		Fut.Day_Puc,
		Fut.Day_Sales,
		Fut.Sett_Purch,
		Fut.Sett_Sales,
		Fut.Normal,
		Fut.Round_To
		FROM RemisierBrokerageMaster AS Rm, RemisierBrokerageScheme AS Rs, #BrokTable AS Fut
		WHERE 
		Rm.SchemeID = Rs.SchemeID
		AND Rm.SchemeOrSlab = 'SCHEME'
		AND Rs.FutTableNo = Fut.Table_No
		--AND Fut.Trd_Del= 'T'
		AND RemType = CASE WHEN @RemType = '' THEN RemType ELSE @RemType END
		AND SchemeOrSlab = CASE WHEN @SchemeOrSlab = '' THEN SchemeOrSlab ELSE @SchemeOrSlab END
		AND FromDate <= CASE @ExecDate WHEN '' THEN FromDate ELSE @ExecDate END 
		AND ToDate >= CASE @ExecDate WHEN '' THEN ToDate ELSE @ExecDate END 
		AND Rm.Segment = CASE @Segment WHEN 'ALL' THEN Rm.Segment ELSE @Segment END
		AND Rm.Exchange = CASE @Exchange WHEN 'ALL' THEN Rm.Exchange ELSE @Exchange END
		AND Fut.Segment = CASE WHEN Rm.Segment IN ('FUTURES', 'ALL') THEN 'FUTURES' WHEN Rm.Segment IN ('COMMODITY', 'ALL') THEN 'COMMODITY' END
		AND Fut.Exchange = CASE WHEN Rm.Exchange IN ('ALL', 'NSEFO', 'NCDX', 'MCDX') THEN Fut.Exchange END

		UNION ALL
	
		SELECT DISTINCT 
		Rm.FromDate,
		Rm.ToDate,
		BrokScheme = (SELECT [Desc] FROM NSEFO.DBO.Schemes WHERE SchemeID = Rs.BrokScheme),
		'OPTIONS' AS Brokerage,
		Rm.SchemeID,
		CASE RemType WHEN 'BR' THEN 'BRANCH' WHEN 'SUB' THEN 'SBU' WHEN 'PARTY' THEN 'Party' END AS RemType,
		RemCode,
		RemPartyCd,
		RemPartyName=Dbo.GetPartyNameForGivenPartyCode(RemPartyCd),
		EntityCode,
		Rm.Segment,
		Rm.Exchange,
		BrokType,
		Rs.OptTableNo AS TableNo, 
		Opt.Line_No AS LNo,
		Opt.Val_Perc,
		Opt.Lower_Lim,
		Opt.Upper_Lim,
		Opt.Day_Puc,
		Opt.Day_Sales,
		Opt.Sett_Purch,
		Opt.Sett_Sales,
		Opt.Normal,
		Opt.Round_To
		FROM RemisierBrokerageMaster AS Rm, RemisierBrokerageScheme AS Rs, #BrokTable AS Opt
		WHERE 
		Rm.SchemeID = Rs.SchemeID
		AND Rm.SchemeOrSlab = 'SCHEME'
		AND Rs.OptTableNo = Opt.Table_No
		--AND Opt.Trd_Del= 'T'
		AND RemType = CASE WHEN @RemType = '' THEN RemType ELSE @RemType END
		AND SchemeOrSlab = CASE WHEN @SchemeOrSlab = '' THEN SchemeOrSlab ELSE @SchemeOrSlab END
		AND FromDate <= CASE @ExecDate WHEN '' THEN FromDate ELSE @ExecDate END 
		AND ToDate >= CASE @ExecDate WHEN '' THEN ToDate ELSE @ExecDate END 
		AND Rm.Segment = CASE @Segment WHEN 'ALL' THEN Rm.Segment ELSE @Segment END
		AND Rm.Exchange = CASE @Exchange WHEN 'ALL' THEN Rm.Exchange ELSE @Exchange END
		AND Opt.Segment = CASE WHEN Rm.Segment IN ('FUTURES', 'ALL') THEN 'FUTURES' WHEN Rm.Segment IN ('COMMODITY', 'ALL') THEN 'COMMODITY' END
		AND Opt.Exchange = CASE WHEN Rm.Exchange IN ('ALL', 'NSEFO', 'NCDX', 'MCDX') THEN Opt.Exchange END

		UNION ALL
	
		SELECT DISTINCT
		Rm.FromDate,
		Rm.ToDate,
		BrokScheme = (SELECT [Desc] FROM NSEFO.DBO.Schemes WHERE SchemeID = Rs.BrokScheme),
		'FUT-FINAL' AS Brokerage,
		Rm.SchemeID,
		CASE RemType WHEN 'BR' THEN 'BRANCH' WHEN 'SUB' THEN 'SBU' WHEN 'PARTY' THEN 'Party' END AS RemType,
		RemCode,
		RemPartyCd,
		RemPartyName=Dbo.GetPartyNameForGivenPartyCode(RemPartyCd),
		EntityCode,
		Rm.Segment,
		Rm.Exchange,
		BrokType,
		Rs.FutFinalTableNo AS TableNo, 
		FutFinal.Line_No AS LNo,
		FutFinal.Val_Perc,
		FutFinal.Lower_Lim,
		FutFinal.Upper_Lim,
		FutFinal.Day_Puc,
		FutFinal.Day_Sales,
		FutFinal.Sett_Purch,
		FutFinal.Sett_Sales,
		FutFinal.Normal,
		FutFinal.Round_To
		FROM RemisierBrokerageMaster AS Rm, RemisierBrokerageScheme AS Rs, #BrokTable AS FutFinal
		WHERE 
		Rm.SchemeID = Rs.SchemeID
		AND Rm.SchemeOrSlab = 'SCHEME'
		AND Rs.FutFinalTableNo = FutFinal.Table_No
		--AND FutFinal.Trd_Del= 'T'
		AND RemType = CASE WHEN @RemType = '' THEN RemType ELSE @RemType END
		AND SchemeOrSlab = CASE WHEN @SchemeOrSlab = '' THEN SchemeOrSlab ELSE @SchemeOrSlab END
		AND FromDate <= CASE @ExecDate WHEN '' THEN FromDate ELSE @ExecDate END 
		AND ToDate >= CASE @ExecDate WHEN '' THEN ToDate ELSE @ExecDate END 
		AND Rm.Segment = CASE @Segment WHEN 'ALL' THEN Rm.Segment ELSE @Segment END
		AND Rm.Exchange = CASE @Exchange WHEN 'ALL' THEN Rm.Exchange ELSE @Exchange END
		AND FutFinal.Segment = CASE WHEN Rm.Segment IN ('FUTURES', 'ALL') THEN 'FUTURES' WHEN Rm.Segment IN ('COMMODITY', 'ALL') THEN 'COMMODITY' END
		AND FutFinal.Exchange = CASE WHEN Rm.Exchange IN ('ALL', 'NSEFO', 'NCDX', 'MCDX') THEN FutFinal.Exchange END

		UNION ALL
	
		SELECT DISTINCT 
		Rm.FromDate,
		Rm.ToDate,
		BrokScheme = (SELECT [Desc] FROM NSEFO.DBO.Schemes WHERE SchemeID = Rs.BrokScheme),
		'OPT-EXERCISE' AS Brokerage,
		Rm.SchemeID,
		CASE RemType WHEN 'BR' THEN 'BRANCH' WHEN 'SUB' THEN 'SBU' WHEN 'PARTY' THEN 'Party' END AS RemType,
		RemCode,
		RemPartyCd,
		RemPartyName=Dbo.GetPartyNameForGivenPartyCode(RemPartyCd),
		EntityCode,
		Rm.Segment,
		Rm.Exchange,
		BrokType,
		Rs.OptExTableNo AS TableNo, 
		OptEx.Line_No AS LNo,
		OptEx.Val_Perc,
		OptEx.Lower_Lim,
		OptEx.Upper_Lim,
		OptEx.Day_Puc,
		OptEx.Day_Sales,
		OptEx.Sett_Purch,
		OptEx.Sett_Sales,
		OptEx.Normal,
		OptEx.Round_To
		FROM RemisierBrokerageMaster AS Rm, RemisierBrokerageScheme AS Rs, #BrokTable AS OptEx
		WHERE 
		Rm.SchemeID = Rs.SchemeID
		AND Rm.SchemeOrSlab = 'SCHEME'
		AND Rs.OptExTableNo = OptEx.Table_No
		--AND OptEx.Trd_Del= 'T'
		AND RemType = CASE WHEN @RemType = '' THEN RemType ELSE @RemType END
		AND SchemeOrSlab = CASE WHEN @SchemeOrSlab = '' THEN SchemeOrSlab ELSE @SchemeOrSlab END
		AND FromDate <= CASE @ExecDate WHEN '' THEN FromDate ELSE @ExecDate END 
		AND ToDate >= CASE @ExecDate WHEN '' THEN ToDate ELSE @ExecDate END 
		AND Rm.Segment = CASE @Segment WHEN 'ALL' THEN Rm.Segment ELSE @Segment END
		AND Rm.Exchange = CASE @Exchange WHEN 'ALL' THEN Rm.Exchange ELSE @Exchange END
		AND OptEx.Segment = CASE WHEN Rm.Segment IN ('FUTURES', 'ALL') THEN 'FUTURES' WHEN Rm.Segment IN ('COMMODITY', 'ALL') THEN 'COMMODITY' END
		AND OptEx.Exchange = CASE WHEN Rm.Exchange IN ('ALL', 'NSEFO', 'NCDX', 'MCDX') THEN OptEx.Exchange END

		ORDER BY FromDate, RemCode, RemPartyCd, Rm.SchemeID, Brokerage, TableNo, LNo

-----------------------------------------------------------------------------------------------------------------
	ELSE--Report: Remisier Brokerage Scheme Master (Slab)
		SELECT 
			Rm.FromDate,
			Rm.ToDate,
			Rm.SchemeID,
			CASE RemType WHEN 'BR' THEN 'BRANCH' WHEN 'SUB' THEN 'SBU' WHEN 'PARTY' THEN 'Party' END AS RemType,
			RemCode,
			RemPartyCd,
			RemPartyName=Dbo.GetPartyNameForGivenPartyCode(RemPartyCd),
			EntityCode,
			Segment,
			Exchange,
			BrokType,
			Rs.ValPerc,
			Rs.LineNumber,
			Rs.LowerLimit,
			Rs.UpperLimit,
			Rs.SharePer
			FROM RemisierBrokerageMaster AS Rm, RemisierBrokerageScheme AS Rs
			WHERE Rm.SchemeID = Rs.SchemeID
			AND Rm.SchemeOrSlab = 'SLAB'
			AND RemType = CASE WHEN @RemType = '' THEN RemType ELSE @RemType END
			AND SchemeOrSlab = CASE WHEN @SchemeOrSlab = '' THEN SchemeOrSlab ELSE @SchemeOrSlab END
			AND FromDate <= CASE @ExecDate WHEN '' THEN FromDate ELSE @ExecDate END 
			AND ToDate >= CASE @ExecDate WHEN '' THEN ToDate ELSE @ExecDate END 
			AND Rm.Segment = CASE @Segment WHEN 'ALL' THEN Rm.Segment ELSE @Segment END
			AND Rm.Exchange = CASE @Exchange WHEN 'ALL' THEN Rm.Exchange ELSE @Exchange END
			ORDER BY Rm.FromDate, Rm.SchemeID, LineNumber
END	

/*
	@RemType VARCHAR(10),
	@Segment VARCHAR(10),
	@Exchange VARCHAR(5),
	@SchemeOrSlab VARCHAR(7),
	@ExecDate VARCHAR(11)

EXEC rptRemisierBrokerageMasterDetails '', 'ALL', 'ALL', 'SCHEME', ''

EXEC rptRemisierBrokerageMasterDetails 'ALL', 'CAPITAL', 'ALL', 'SLAB', ''

*/

GO
