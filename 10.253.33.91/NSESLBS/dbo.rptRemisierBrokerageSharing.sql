-- Object: PROCEDURE dbo.rptRemisierBrokerageSharing
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE rptRemisierBrokerageSharing 
(      
	@StatusId VarChar(50),
	@StatusName VarChar(50),
	@ReportOption VarChar(5),
	@ReportType Int,
	@Sett_No Varchar(7), 
	@Sett_Type Varchar(2),   
	@SubBrokerOrBranchCode VarChar(10) = '',                   
	@RemPartyCode VarChar(10) = ''
)
AS
BEGIN
	--1. Remisier Brokerage Sharing For Sub Broker 
	IF @ReportOption = 'SUB' AND @ReportType = 1
		SELECT 
			Sett_No,
			Sett_Type,
			RemCode,
			RemName=Sbu_Name,
			RemPartyCd,
			Branch_CD,
			Brokerage=SUM(Brokerage),
			RemBrokeragePayable=SUM(RemBrokeragePayable),
			Rem_TDS=SUM(Rem_TDS),
			Rem_ST=SUM(Rem_ST),
			Rem_Cess=SUM(Rem_Cess),
			Rem_EdnCess=SUM(Rem_EdnCess),
			NetPayable = SUM(RemBrokeragePayable - Rem_TDS + Rem_ST + Rem_Cess + Rem_EdnCess)
		FROM RemisierBrokerageTrans R,
			Sbu_Master S
		WHERE R.Sett_No = @Sett_No AND R.Sett_Type = @Sett_Type 
			AND R.RemType = 'SUB' AND R.RemCode = S.Sbu_Code
		GROUP BY 
			Sett_No,
			Sett_Type,
			RemCode,
			Sbu_Name,
			RemPartyCd,
			Branch_CD
		ORDER BY R.RemCode

	--- 1st Drill down report 1	(Remisier Brokerage Sharing For Sub Broker )
	IF @ReportOption = 'SUB' AND @ReportType = 2
		SELECT 
			Sett_No,
			Sett_Type,
			RemCode,
			RemName=Sbu_Name,
			RemPartyCd,
			Branch_CD,
			Exchange,
			BrokerageType = CASE WHEN SlabType IN ('FLAT', 'INCR') THEN 'Slab' ELSE 'Scheme' END,
			SlabType,
			Share_Per,
			Brokerage,
			RemBrokeragePayable,
			Rem_TDS,
			Rem_ST,
			Rem_Cess,
			Rem_EdnCess,
			NetPayable = (RemBrokeragePayable - Rem_TDS + Rem_ST + Rem_Cess + Rem_EdnCess)
		FROM RemisierBrokerageTrans R,
			Sbu_Master S
		WHERE R.Sett_No = @Sett_No AND R.Sett_Type = @Sett_Type  
			AND R.RemType = 'SUB' AND R.RemCode = S.Sbu_Code
			AND R.RemCode = @SubBrokerOrBranchCode AND R.RemPartyCd = @RemPartyCode 
		ORDER BY R.RemCode, R.RemPartyCd, R.Exchange 

	--- 2nd Drill down report 1	(Remisier Brokerage Sharing For Sub Broker )
	IF @ReportOption = 'SUB' AND @ReportType = 3
		SELECT 
			SettNo,
			SettType,
			SubBrokerCode,
			SubBrokerParty,
			BranchCode,
			PartyCode,
			PartyName = Dbo.GetPartyNameForGivenPartyCode(PartyCode),
			SaudaDate,
			Exchange,
			TurnOver,
			Brokerage = BrokEarned,
			RemBrokeragePayable =RemBrokPayable
-- -- 			Rem_TDS,
-- -- 			Rem_ST,
-- -- 			Rem_Cess,
-- -- 			Rem_EdnCess,
-- -- 			NetPayable = (RemBrokeragePayable - Rem_TDS + Rem_ST + Rem_Cess + Rem_EdnCess)
		FROM RemisierBrokerageTransDatewise 
		WHERE SettNo = @Sett_No AND SettType = @Sett_Type 
			AND SubBrokerCode = @SubBrokerOrBranchCode AND SubBrokerParty = @RemPartyCode	AND RemBrokPayable > 0
		ORDER BY SubBrokerCode, SubBrokerParty, Exchange, SaudaDate 

	--1. Remisier Brokerage Sharing For Broker
	IF @ReportOption = 'BR' AND @ReportType = 1
		SELECT 
			R.Sett_No,
			R.Sett_Type,
			R.Branch_CD,
			BranchName =Branch,
			R.RemPartyCd,
			Brokerage=SUM(R.Brokerage),
			SubBrokerSharing = SubBrokerSharing,--SUM(S.SubBrokerSharing),
			BrachSharing = SUM(R.RemBrokeragePayable),
			Rem_TDS=SUM(R.Rem_TDS),
			Rem_ST=SUM(R.Rem_ST),
			Rem_Cess=SUM(R.Rem_Cess),
			Rem_EdnCess=SUM(R.Rem_EdnCess),
			NetPayable = SUM(R.RemBrokeragePayable + R.Rem_TDS + R.Rem_ST + R.Rem_Cess + R.Rem_EdnCess)
		FROM RemisierBrokerageTrans R,
			Branch B, 
			(SELECT Sett_No=SettNo, Sett_Type=SettType, Branch_Cd=BranchCode, SubBrokerSharing = SUM(RemBrokPayable) 
				FROM RemisierBrokerageTransDateWise SB 
				WHERE SB.RemBrokPayable > 0 AND SB.SettNo = @Sett_No AND SB.SettType = @Sett_Type 
				GROUP BY SettNo, SettType, BranchCode ) AS S
		WHERE R.Sett_No = @Sett_No AND R.Sett_Type = @Sett_Type 
			AND R.RemType = 'BR' AND R.Branch_Cd = B.Branch_Code
			AND R.Sett_No = S.Sett_No AND R.Sett_Type = S.Sett_Type 
			AND R.Branch_Cd = S.Branch_Cd --AND R.RemPartyCd = S.RemPartyCd
		GROUP BY 
			R.Sett_No,
			R.Sett_Type,
			R.RemPartyCd,
			R.Branch_CD,
			B.Branch,
			S.SubBrokerSharing
		ORDER BY R.Branch_CD, R.RemPartyCd


-- -- 	IF @ReportOption = 'BR' AND @ReportType = 1
-- -- 		SELECT 
-- -- 			R.Sett_No,
-- -- 			R.Sett_Type,
-- -- 			R.Branch_CD,
-- -- 			BranchName =Branch,
-- -- 			R.RemPartyCd,
-- -- 			Brokerage=SUM(R.Brokerage),
-- -- 			SubBrokerSharing = SUM(ISNULL(SB.RemBrokeragePayable, 0)),
-- -- 			BrachSharing = SUM(R.RemBrokeragePayable),
-- -- 			Rem_TDS=SUM(R.Rem_TDS),
-- -- 			Rem_ST=SUM(R.Rem_ST),
-- -- 			Rem_Cess=SUM(R.Rem_Cess),
-- -- 			Rem_EdnCess=SUM(R.Rem_EdnCess),
-- -- 			NetPayable = SUM(R.RemBrokeragePayable + R.Rem_TDS + R.Rem_ST + R.Rem_Cess + R.Rem_EdnCess)
-- -- 		FROM RemisierBrokerageTrans R
-- -- 			 LEFT OUTER JOIN RemisierBrokerageTrans SB ON ( 
-- -- 					R.Sett_No = SB.Sett_No AND R.Sett_Type = SB.Sett_Type 
-- -- 					AND R.Branch_Cd = SB.Branch_Cd AND R.RemPartyCd = SB.RemPartyCd
-- -- 					AND SB.RemType = 'SUB'), Branch B
-- -- 		WHERE R.Sett_No = @Sett_No AND R.Sett_Type = @Sett_Type 
-- -- 			AND R.RemType = 'BR' AND R.Branch_Cd = B.Branch_Code
-- -- 		GROUP BY 
-- -- 			R.Sett_No,
-- -- 			R.Sett_Type,
-- -- 			R.RemPartyCd,
-- -- 			R.Branch_CD,
-- -- 			B.Branch
-- -- 		ORDER BY R.Branch_CD, R.RemPartyCd

	--- 1st Drill down report 2 (Remisier Brokerage Sharing For Branch )
	IF @ReportOption = 'BR' AND @ReportType = 2
		SELECT 
			R.Sett_No,
			R.Sett_Type,
			R.Branch_CD,
			BranchName =Branch,
			R.RemPartyCd,
			R.Exchange,
			BrokerageType = CASE WHEN R.SlabType IN ('FLAT', 'INCR') THEN 'Slab' ELSE 'Scheme' END,
			R.SlabType,
			R.Share_Per,
			Brokerage=SUM(R.Brokerage),
			SubBrokerSharing = SubBrokerSharing,--SUM(S.SubBrokerSharing),
			BrachSharing = SUM(R.RemBrokeragePayable),
			Rem_TDS=SUM(R.Rem_TDS),
			Rem_ST=SUM(R.Rem_ST),
			Rem_Cess=SUM(R.Rem_Cess),
			Rem_EdnCess=SUM(R.Rem_EdnCess),
			NetPayable = SUM(R.RemBrokeragePayable + R.Rem_TDS + R.Rem_ST + R.Rem_Cess + R.Rem_EdnCess)
		FROM RemisierBrokerageTrans R,
			Branch B, 
			(SELECT Sett_No=SettNo, Sett_Type=SettType, Branch_Cd=BranchCode, Exchange, SubBrokerSharing = SUM(RemBrokPayable) 
				FROM RemisierBrokerageTransDateWise SB 
				WHERE SB.RemBrokPayable > 0 AND SB.SettNo = @Sett_No AND SB.SettType = @Sett_Type 
				GROUP BY SettNo, SettType, BranchCode, Exchange ) AS S
		WHERE R.Sett_No = @Sett_No AND R.Sett_Type = @Sett_Type 
			AND R.RemType = 'BR' AND R.Branch_Cd = B.Branch_Code
			AND R.Sett_No = S.Sett_No AND R.Sett_Type = S.Sett_Type 
			AND R.Branch_Cd = S.Branch_Cd --AND R.RemPartyCd = S.RemPartyCd
			AND R.Exchange =S.Exchange AND R.Branch_Cd = @SubBrokerOrBranchCode
			AND R.RemPartyCd = @RemPartyCode
		GROUP BY 
			R.Sett_No,
			R.Sett_Type,
			R.RemPartyCd,
			R.Branch_CD,
			B.Branch,
			S.SubBrokerSharing,
			R.RemPartyCd,
			R.Exchange,
			CASE WHEN R.SlabType IN ('FLAT', 'INCR') THEN 'Slab' ELSE 'Scheme' END,
			R.SlabType,
			R.Share_Per
		ORDER BY R.Branch_CD, R.RemPartyCd, R.Exchange

	--- 2nd Drill down report 2	(Remisier Brokerage Sharing For Branch )
	IF @ReportOption = 'BR' AND @ReportType = 3
		SELECT 
			SettNo,
			SettType,
			SubBrokerCode,
			BranchParty,
			BranchCode,
			PartyCode,
			PartyName = Dbo.GetPartyNameForGivenPartyCode(PartyCode),
			SaudaDate,
			Exchange,
			TurnOver,
			Brokerage=BrokEarned,
			SubBrokerSharing = RemBrokPayable,
			BranchSharing = RemBrokPayableForBranch
-- -- 			Rem_TDS,
-- -- 			Rem_ST,
-- -- 			Rem_Cess,
-- -- 			Rem_EdnCess,
-- -- 			NetPayable = (RemBrokeragePayable - Rem_TDS + Rem_ST + Rem_Cess + Rem_EdnCess)
		FROM RemisierBrokerageTransDatewise 
		WHERE SettNo = @Sett_No AND SettType = @Sett_Type 
			AND BranchCode = @SubBrokerOrBranchCode AND BranchParty = @RemPartyCode 
			AND RemBrokPayableForBranch > 0
		ORDER BY SubBrokerCode, SubBrokerParty, Exchange, SaudaDate 

	-- 3. Remisier Sharing Datewise Details 
	IF @ReportOption = 'PARTY' AND @ReportType = 1
		SELECT 
			SettNo,
			SettType,
			SubBrokerCode,
			SubBrokerParty,
			BranchCode,
			BranchParty,
			PartyCode,
			PartyName = Dbo.GetPartyNameForGivenPartyCode(PartyCode),
--			SaudaDate,
-- -- 	Exchange,
			Brokerage=SUM(BrokEarned),
			TurnOver =SUM(TurnOver),
			SubBrokerSharing = SUM(RemBrokPayable),
			BranchSharing = SUM(RemBrokPayableForBranch),
			NetSharingBrokerage = SUM(RemBrokPayable+RemBrokPayableForBranch)
		FROM RemisierBrokerageTransDatewise 
		WHERE SettNo = @Sett_No AND SettType = @Sett_Type 
		GROUP BY
			SettNo,
			SettType,
			SubBrokerCode,
			SubBrokerParty,
			BranchCode,
			BranchParty,
			PartyCode,
			Dbo.GetPartyNameForGivenPartyCode(PartyCode)
			--SaudaDate	
		ORDER BY BranchCode, SubBrokerCode--, SaudaDate 

	-- 4. Remisier Sharing Datewise & Exchangewise Details
	IF @ReportOption = 'PARTY' AND @ReportType = 2
		SELECT 
			SettNo,
			SettType,
			SubBrokerCode,
			SubBrokerParty,
			BranchCode,
			BranchParty,
			PartyCode,
			PartyName = Dbo.GetPartyNameForGivenPartyCode(PartyCode),
			SaudaDate,
			Exchange,
			TurnOver,
			Brokerage=BrokEarned,
			SubBrokerSharing = RemBrokPayable,
			BranchSharing = RemBrokPayableForBranch,
			NetSharingBrokerage = RemBrokPayable+RemBrokPayableForBranch
		FROM RemisierBrokerageTransDatewise 
		WHERE SettNo = @Sett_No AND SettType = @Sett_Type 
			AND SubBrokerCode = @SubBrokerOrBranchCode
			AND SubBrokerParty = @RemPartyCode

		ORDER BY BranchCode, SubBrokerCode, Exchange, SaudaDate 

END	


/*

EXEC rptRemisierBrokerageSharing 'broker', 'broker', 'SUB', 1, '2006001', 'RM', '', ''

EXEC rptRemisierBrokerageSharing 'broker', 'broker', 'BR',2, '2006001', 'RM', 'AL001', 'ALWC000001'


EXEC rptRemisierBrokerageSharing 'broker', 'broker','PARTY', 1, '2006001', 'RM', 'ALSUB01', '0A147'

EXEC rptRemisierBrokerageSharing 'broker', 'broker','PARTY', 2, '2006001', 'RM', 'ALSUB01', '0A147'

 	

SELECT * FROM RemisierBrokerageTrans

SELECT * FROM RemisierBrokerageTransDatewise

*/

GO
