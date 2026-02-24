-- Object: PROCEDURE dbo.CBO_DematInstructionConfirmAndReject
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE CBO_DematInstructionConfirmAndReject
(
	@SNoList VARCHAR(8000),			 ---  (Non selected item in the list box) 2,3,6,10
	@ExecutionDate VARCHAR(10),
	@BatchNo VARCHAR(10), 
	@SlipNo VARCHAR(10),
	@PartyCode 	VARCHAR(10),
	@SettNo 	VARCHAR(10),
	@SettType CHAR(2),
	@ScripCode	VARCHAR(12),
	@statusId varchar(25) = 'BROKER',
	@statusName varchar(25) = 'BROKER'
)
AS
/*
exec CBO_DematInstructionConfirmAndReject @SNoList = '4285,4475,4557,', @ExecutionDate = '19/10/2007', @BatchNo = '72', @SlipNo = '1', @PartyCode = '0A146', @SettNo = '2004046', @SettType = 'N', @ScripCode = 'RELIANCE', @STATUSID = N'Broker', @STATUSNAME = N'Broker'
*/
BEGIN
	DECLARE @@Delimiter CHAR(1)
	DECLARE @@T_SNo TABLE(SrNo INT)
		
	SET @@Delimiter = ','

	--- Split the given SNo list and put into the table
	INSERT INTO @@T_SNo(SrNo) SELECT * FROM Dbo.CBOFN_Split(@SNoList, @@Delimiter)

	IF EXISTS(SELECT 1 FROM @@T_SNo)
	BEGIN									--- Demat Rejection Process
	   UPDATE DelTrans SET 
			delivered=0, 
			filler2=0,
			HolderName='Rejected' 
		FROM DelTrans D, @@T_SNo T
		WHERE D.Sno = T.SrNo
	            
		INSERT INTO DelTrans (
			Sett_No,
			Sett_type,
			RefNo,
			TCode,
			TrType,
			Party_Code,
			scrip_cd,
			series,
			Qty,
			FromNo,
			ToNo,
			CertNo,
			FolioNo,
			HolderName,
			Reason,
			DrCr,
			Delivered,
			OrgQty,
			DpType,
			DpId,
			CltDpId,
			BranchCd,
			PartipantCode,
			SlipNo,
			BatchNo,
			ISett_No,
			ISett_Type,
			ShareType,
			TransDate,
			Filler1, 
			Filler2,
			Filler3,
			BDpType,
			BDpId,
			BCltDpId,
			Filler4,
			Filler5)
		SELECT 
			DT.Sett_No,
			DT.Sett_type,
			DT.RefNo,
			DT.TCode,
			DT.TrType,
			DT.Party_Code,
			DT.scrip_cd,
			DT.series,
			DT.Qty,
			DT.FromNo,
			DT.ToNo,
			DT.CertNo,
			DT.FolioNo,
			DT.HolderName,
			DT.Reason,
			DT.DrCr,
			0,
			DT.OrgQty,
			DT.DpType,
			DT.DpId,
			DT.CltDpId,
			DT.BranchCd,
			DT.PartipantCode,
			DT.SlipNo,
			DT.BatchNo,
			DT.ISett_No,
			DT.ISett_Type,
			DT.ShareType,
			DT.TransDate,
			DT.Filler1, 
			DT.Filler2,
			DT.Filler3,
			D.BDpType,
			D.BDpId,
			D.BCltDpId,
			DT.Filler4,
			DT.Filler5
		FROM DelTransTemp DT, DelTrans D,  @@T_SNo T 
		WHERE DT.SNo = T.SrNo 
			AND D.SNo = T.SrNo
			AND DT.SNo = D.SNo
			AND D.Filler2 = 1
	            
		DELETE DelTransTemp FROM DelTransTemp D, @@T_SNo T 
		WHERE D.Sno = T.SrNo
	END					--- IF EXISTS(SELECT 1 FROM @@T_SNo)


	---- Demat Confirmation Process
	UPDATE DelTrans SET 
		Filler2 = 0 
	FROM 	DelTransTemp D
	WHERE D.TransDate LIKE CONVERT(CHAR(11),CONVERT(DATETIME, @ExecutionDate, 103), 109)
		AND D.BatchNo = CASE WHEN @BatchNo <> '' THEN CONVERT(INT, @BatchNo) ELSE D.BatchNo END 
	 	AND D.SlipNo = CASE WHEN @SlipNo <> '' THEN @SlipNo ELSE D.SlipNo END 
	 	AND D.Sett_No = CASE WHEN @SettNo <> '' THEN @SettNo ELSE D.Sett_No END 
	 	AND D.Sett_Type = CASE WHEN @SettType <> '' THEN @SettType ELSE D.Sett_Type END 
	 	AND D.Party_Code = CASE WHEN @PartyCode <> '' THEN @PartyCode ELSE D.Party_Code END 
	 	AND D.Scrip_Cd = CASE WHEN @ScripCode <> '' THEN @ScripCode ELSE D.Scrip_Cd END 
		AND D.Sett_No = DelTrans.Sett_No 
		And D.Sett_Type = DelTrans.Sett_Type 
		AND D.Scrip_Cd = DelTrans.Scrip_Cd 
		And D.Series = DelTrans.Series 
		And D.Party_Code = DelTrans.Party_Code 
		And D.SNo = DelTrans.Sno 
		And DelTrans.Delivered = 'G' 
		And DelTrans.Filler2 = 1 
	
   INSERT INTO DelTrans (
		Sett_No,
		Sett_type,
		RefNo,
		TCode,
		TrType,
		Party_Code,
		scrip_cd,
		series,
		Qty,
		FromNo,
		ToNo,
		CertNo,
		FolioNo,
		HolderName,
		Reason,
		DrCr,
		Delivered,
		OrgQty,
		DpType,
		DpId,
		CltDpId,
		BranchCd,
		PartipantCode,
		SlipNo,
		BatchNo,
		ISett_No,
		ISett_Type,
		ShareType,
		TransDate,
		Filler1, 
		Filler2,
		Filler3,
		BDpType,
		BDpId,
		BCltDpId,
		Filler4,
		Filler5)
	SELECT
		Sett_No,
		Sett_type,
		RefNo,
		TCode,
		TrType,
		Party_Code,
		scrip_cd,
		series,
		Qty,
		FromNo,
		ToNo,
		CertNo,
		FolioNo,
		HolderName,
		Reason,
		DrCr,
		Delivered,
		OrgQty,
		DpType,
		DpId,
		CltDpId,
		BranchCd,
		PartipantCode,
		SlipNo,
		BatchNo,
		ISett_No,
		ISett_Type,
		ShareType,
		TransDate,
		Filler1, 
		Filler2,
		Filler3,
		BDpType,
		BDpId,
		BCltDpId,
		Filler4,
		Filler5
	FROM DelTransTemp
	WHERE TransDate LIKE CONVERT(CHAR(11),CONVERT(DATETIME, @ExecutionDate, 103), 109)
		AND BatchNo = CASE WHEN @BatchNo <> '' THEN CONVERT(INT, @BatchNo) ELSE BatchNo END 
		AND SlipNo = CASE WHEN @SlipNo <> '' THEN @SlipNo ELSE SlipNo END 
		AND Sett_No = CASE WHEN @SettNo <> '' THEN @SettNo ELSE Sett_No END 
		AND Sett_Type = CASE WHEN @SettType <> '' THEN @SettType ELSE Sett_Type END 
		AND Party_Code = CASE WHEN @PartyCode <> '' THEN @PartyCode ELSE Party_Code END 
		AND Scrip_Cd = CASE WHEN @ScripCode <> '' THEN @ScripCode ELSE Scrip_Cd END 

	DELETE FROM DelTransTemp
	WHERE TransDate LIKE CONVERT(CHAR(11),CONVERT(DATETIME, @ExecutionDate, 103), 109)
		AND BatchNo = CASE WHEN @BatchNo <> '' THEN CONVERT(INT, @BatchNo) ELSE BatchNo END 
		AND SlipNo = CASE WHEN @SlipNo <> '' THEN @SlipNo ELSE SlipNo END 
		AND Sett_No = CASE WHEN @SettNo <> '' THEN @SettNo ELSE Sett_No END 
		AND Sett_Type = CASE WHEN @SettType <> '' THEN @SettType ELSE Sett_Type END 
		AND Party_Code = CASE WHEN @PartyCode <> '' THEN @PartyCode ELSE Party_Code END 
		AND Scrip_Cd = CASE WHEN @ScripCode <> '' THEN @ScripCode ELSE Scrip_Cd END 


END

GO
