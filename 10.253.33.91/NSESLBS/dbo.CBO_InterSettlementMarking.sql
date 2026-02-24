-- Object: PROCEDURE dbo.CBO_InterSettlementMarking
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE CBO_InterSettlementMarking
(
	@NormalOrExcess VARCHAR(10),
	@RefNo INT,
	@TargetExchange VARCHAR(5),
	@AvilableQty INT,
	@TransferQty INT,
	@PartyCode VARCHAR(10),
	@ScripCode VARCHAR(10),
	@Series VARCHAR(5),
	@PoolDPID VARCHAR(16),
	@PoolDPClientID VARCHAR(16),
	@SourceSetType VARCHAR(10),
	@SourceSetNo VARCHAR(15),
	@TargetSetType VARCHAR(10),
	@TargetSetNo VARCHAR(15),
	@SuccessFlag CHAR(1) OUTPUT,
  @STATUSID   VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS
BEGIN
	DECLARE
		@@Reason VARCHAR(25),
		@@Sett_No  VARCHAR(15),
		@@Sett_Type VARCHAR(10),
		@@SNo NUMERIC,
		@@TCode NUMERIC,
		@@Qty	NUMERIC

          IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END

	SET @SuccessFlag = 'N'

	IF (@RefNo = 110 AND @TargetExchange='NSE') OR (@RefNo = 120 AND @TargetExchange='BSE')
	    SET @@Reason = 'Inter Settlement Transfer'
	ELSE
	    SET @@Reason = 'Inter Exchange Transfer'
  
	--- If transfer full qty 	
	IF @NormalOrExcess = 'NORMAL'
	BEGIN
		IF @AvilableQty = @TransferQty 
			UPDATE DelTrans SET 
				TrType = 907,
				ISett_No = @TargetSetNo,
				ISett_Type = @TargetSetType,
				Reason = @@Reason
				WHERE TrType = 904 
				And Party_code = @PartyCode
				And Scrip_Cd = @ScripCode
				And series = @Series
				And Party_Code <> 'BROKER'
				And CertNo <> 'AUCTION' 
				And Filler2 = 1 
				And DrCr = 'D' 
				And BDpId = @PoolDPID
				And BCltDpId = @PoolDPClientID
				And Delivered = '0'
				AND Sett_Type = CASE WHEN @SourceSetType = '' THEN Sett_Type ELSE @SourceSetType END
				AND Sett_No = CASE WHEN @SourceSetNo = '' THEN Sett_No ELSE @SourceSetNo END

			 IF @@ERROR <> 0 
				RETURN
	
		ELSE IF @AvilableQty <> @TransferQty
		BEGIN 
			DECLARE curDelTrans CURSOR FOR SELECT
				Sett_No,
				Sett_Type,
				SNo,
				TCode,
				Qty	
				FROM DelTrans
				WHERE TrType = 904 
				And Party_code = @PartyCode
				And Scrip_Cd = @ScripCode
				And series = @Series
				And Party_Code <> 'BROKER'
				And CertNo <> 'AUCTION' 
				And Filler2 = 1 
				And DrCr = 'D' 
				And BDpId = @PoolDPID
				And BCltDpId = @PoolDPClientID
				And Delivered = '0'
				AND Sett_Type = CASE WHEN @SourceSetType = '' THEN Sett_Type ELSE @SourceSetType END
				AND Sett_No = CASE WHEN @SourceSetNo = '' THEN Sett_No ELSE @SourceSetNo END
			ORDER BY Sett_No, Sett_Type, Qty DESC 
			
			OPEN curDelTrans
			FETCH curDelTrans INTO @@Sett_No, @@Sett_Type, @@SNo, @@TCode, @@Qty		
			WHILE @@FETCH_STATUS = 0 AND @TransferQty > 0
			BEGIN
				IF @@Qty <= @TransferQty  
				BEGIN
					UPDATE DelTrans SET 
						TrType = 907,
						ISett_No = @TargetSetNo,
						ISett_Type = @TargetSetType,
						Reason = @@Reason
						WHERE SNo = @@SNo 
						AND TCode = @@TCode
	
					   IF @@ERROR <> 0 
							RETURN
	
						SET @TransferQty = @TransferQty - @@Qty
				END		--- IF @@Qty <= @TransferQty  
				ELSE IF @@Qty > @TransferQty  
				BEGIN
					INSERT INTO DelTrans
						(
						Sett_No,
						Sett_Type,
						Refno,
						Tcode,
						Trtype,
						Party_Code,
						Scrip_Cd,
						Series,
						Qty,
						Fromno,
						Tono,
						Certno,
						Foliono,
						Holdername,
						Reason,
						Drcr,
						Delivered,
						Orgqty,
						Dptype,
						Dpid,
						Cltdpid,
						Branchcd,
						Partipantcode,
						Slipno,
						Batchno,
						Isett_No,
						Isett_Type,
						Sharetype,
						Transdate,
						Filler1,
						Filler2,
						Filler3,
						Bdptype,
						Bdpid,
						Bcltdpid,
						Filler4,
						Filler5
						)
					SELECT
						Sett_No,
						Sett_Type,
						Refno,
						Tcode,
						Trtype,
						Party_Code,
						Scrip_Cd,
						Series,
						Qty = (Qty - @TransferQty),
						Fromno,
						Tono,
						Certno,
						Foliono,
						Holdername,
						Reason,
						Drcr,
						Delivered,
						Orgqty,
						Dptype,
						Dpid,
						Cltdpid,
						Branchcd,
						Partipantcode,
						Slipno,
						Batchno,
						Isett_No,
						Isett_Type,
						Sharetype,
						Transdate,
						Filler1,
						Filler2,
						Filler3,
						Bdptype,
						Bdpid,
						Bcltdpid,
						Filler4,
						Filler5
						FROM DelTrans
						WHERE SNo = @@SNo 
						AND TCode = @@TCode
	
					 IF @@ERROR <> 0 
						RETURN
	
					UPDATE DelTrans SET 
						TrType = 907,
						ISett_No = @TargetSetNo,
						ISett_Type = @TargetSetType,
						Reason = @@Reason,
						Qty = @TransferQty
						WHERE SNo = @@SNo 
						AND TCode = @@TCode
	
						IF @@ERROR <> 0 
							RETURN
	
						SET @TransferQty = @TransferQty - @@Qty
	
						FETCH curDelTrans INTO @@Sett_No, @@Sett_Type, @@SNo, @@TCode, @@Qty		
				END
			END		--- End of the Cursor  Loop
			CLOSE curDelTrans
			DEALLOCATE curDelTrans
	
		END			--- IF @AvilableQty <> @TransferQty
	END				--- IF @NormalOrExcess = 'NORMAL'
	ELSE IF @NormalOrExcess = 'EXCESS'
	BEGIN
		IF @AvilableQty = @TransferQty 
		BEGIN
			---- Record Type C 
			INSERT INTO DelTrans
				(
				Sett_No,
				Sett_Type,
				Refno,
				Tcode,
				Trtype,
				Party_Code,
				Scrip_Cd,
				Series,
				Qty,
				Fromno,
				Tono,
				Certno,
				Foliono,
				Holdername,
				Reason,
				Drcr,
				Delivered,
				Orgqty,
				Dptype,
				Dpid,
				Cltdpid,
				Branchcd,
				Partipantcode,
				Slipno,
				Batchno,
				Isett_No,
				Isett_Type,
				Sharetype,
				Transdate,
				Filler1,
				Filler2,
				Filler3,
				Bdptype,
				Bdpid,
				Bcltdpid,
				Filler4,
				Filler5
				)
			SELECT
				Sett_No,
				Sett_Type,
				Refno,
				Tcode,
				Trtype,
				Party_Code,
				Scrip_Cd,
				Series,
				Qty,
				Fromno = TransNo,
				Tono = TransNo,
				Certno = IsIn,
				Foliono = TransNo,
				Holdername = DpName,
				Reason = 'Excess Transfer',
				Drcr = 'C',
				Delivered = '0',
				Orgqty = Qty,
				Dptype,
				Dpid,
				Cltdpid = CltAccNo,
				Branchcd = Branch_Cd,
				Partipantcode,
				Slipno = '0',
				Batchno = '0',
				Isett_No = '',
				Isett_Type = '',
				Sharetype = 'DEMAT',
				Transdate = TrDate,
				Filler1,
				Filler2 = 1,
				Filler3 = '',
				Bdptype,
				Bdpid,
				Bcltdpid = BCltAccNo,
				Filler4,
				Filler5
			FROM DematTrans
			WHERE 
				Party_code = @PartyCode
				And Scrip_Cd = @ScripCode
				And series = @Series
				And Party_Code <> 'BROKER'
				And BDpId = @PoolDPID
				And BCltAccNo = @PoolDPClientID
				AND Sett_Type = CASE WHEN @SourceSetType = '' THEN Sett_Type ELSE @SourceSetType END
				AND Sett_No = CASE WHEN @SourceSetNo = '' THEN Sett_No ELSE @SourceSetNo END
				
			--- Record Type = D
			INSERT INTO DelTrans
				(
				Sett_No,
				Sett_Type,
				Refno,
				Tcode,
				Trtype,
				Party_Code,
				Scrip_Cd,
				Series,
				Qty,
				Fromno,
				Tono,
				Certno,
				Foliono,
				Holdername,
				Reason,
				Drcr,
				Delivered,
				Orgqty,
				Dptype,
				Dpid,
				Cltdpid,
				Branchcd,
				Partipantcode,
				Slipno,
				Batchno,
				Isett_No,
				Isett_Type,
				Sharetype,
				Transdate,
				Filler1,
				Filler2,
				Filler3,
				Bdptype,
				Bdpid,
				Bcltdpid,
				Filler4,
				Filler5
				)
			SELECT
				Sett_No,
				Sett_Type,
				Refno,
				Tcode,
				Trtype = 907,
				Party_Code,
				Scrip_Cd,
				Series,
				Qty,
				Fromno = TransNo,
				Tono = TransNo,
				Certno = IsIn,
				Foliono = TransNo,
				Holdername = DpName,
				Reason = @@Reason,
				Drcr = 'D',
				Delivered = '0',
				Orgqty = Qty,
				Dptype,
				Dpid,
				Cltdpid = CltAccNo,
				Branchcd = Branch_Cd,
				Partipantcode,
				Slipno = '0',
				Batchno = '0',
				Isett_No = @TargetSetNo,
				Isett_Type = @TargetSetType,
				Sharetype = 'DEMAT',
				Transdate = TrDate,
				Filler1,
				Filler2 = 1,
				Filler3 = '',
				Bdptype,
				Bdpid,
				Bcltdpid = BCltAccNo,
				Filler4,
				Filler5
			FROM DematTrans
			WHERE 
				Party_code = @PartyCode
				And Scrip_Cd = @ScripCode
				And series = @Series
				And Party_Code <> 'BROKER'
				And BDpId = @PoolDPID
				And BCltAccNo = @PoolDPClientID
				AND Sett_Type = CASE WHEN @SourceSetType = '' THEN Sett_Type ELSE @SourceSetType END
				AND Sett_No = CASE WHEN @SourceSetNo = '' THEN Sett_No ELSE @SourceSetNo END
				
			--- Remove the records from DematTrans 
			DELETE FROM DematTrans
			WHERE 
				Party_code = @PartyCode
				And Scrip_Cd = @ScripCode
				And series = @Series
				And Party_Code <> 'BROKER'
				And BDpId = @PoolDPID
				And BCltAccNo = @PoolDPClientID
				AND Sett_Type = CASE WHEN @SourceSetType = '' THEN Sett_Type ELSE @SourceSetType END
				AND Sett_No = CASE WHEN @SourceSetNo = '' THEN Sett_No ELSE @SourceSetNo END
		END 			-- IF @AvilableQty = @TransferQty 
		ELSE IF @AvilableQty <> @TransferQty 
		BEGIN
			DECLARE curDematTrans CURSOR FOR SELECT
				Sett_No,
				Sett_Type,
				SNo,
				TCode,
				Qty	
			FROM DelTrans
			WHERE 
				Party_code = @PartyCode
				And Scrip_Cd = @ScripCode
				And series = @Series
				And Party_Code <> 'BROKER'
				And BDpId = @PoolDPID
				And BCltDpId = @PoolDPClientID
				AND Sett_Type = CASE WHEN @SourceSetType = '' THEN Sett_Type ELSE @SourceSetType END
				AND Sett_No = CASE WHEN @SourceSetNo = '' THEN Sett_No ELSE @SourceSetNo END
			ORDER BY Sett_No, Sett_Type, Qty DESC 

			OPEN curDematTrans
			FETCH curDematTrans INTO @@Sett_No, @@Sett_Type, @@SNo, @@TCode, @@Qty		
			WHILE @@FETCH_STATUS = 0 AND @TransferQty > 0
			BEGIN
				IF @@Qty <= @TransferQty  
				BEGIN
					---- Record Type C 
					INSERT INTO DelTrans
						(
						Sett_No,
						Sett_Type,
						Refno,
						Tcode,
						Trtype,
						Party_Code,
						Scrip_Cd,
						Series,
						Qty,
						Fromno,
						Tono,
						Certno,
						Foliono,
						Holdername,
						Reason,
						Drcr,
						Delivered,
						Orgqty,
						Dptype,
						Dpid,
						Cltdpid,
						Branchcd,
						Partipantcode,
						Slipno,
						Batchno,
						Isett_No,
						Isett_Type,
						Sharetype,
						Transdate,
						Filler1,
						Filler2,
						Filler3,
						Bdptype,
						Bdpid,
						Bcltdpid,
						Filler4,
						Filler5
						)
					SELECT
						Sett_No,
						Sett_Type,
						Refno,
						Tcode,
						Trtype,
						Party_Code,
						Scrip_Cd,
						Series,
						Qty,
						Fromno = TransNo,
						Tono = TransNo,
						Certno = IsIn,
						Foliono = TransNo,
						Holdername = DpName,
						Reason = 'Excess Transfer',
						Drcr = 'C',
						Delivered = '0',
						Orgqty = Qty,
						Dptype,
						Dpid,
						Cltdpid = CltAccNo,
						Branchcd = Branch_Cd,
						Partipantcode,
						Slipno = '0',
						Batchno = '0',
						Isett_No = '',
						Isett_Type = '',
						Sharetype = 'DEMAT',
						Transdate = TrDate,
						Filler1,
						Filler2 = 1,
						Filler3 = '',
						Bdptype,
						Bdpid ,
						Bcltdpid = BCltAccNo,
						Filler4,
						Filler5
					FROM DematTrans
					WHERE SNo = @@SNo 
							AND TCode = @@TCode
		
					--- Record Type = D
					INSERT INTO DelTrans
						(
						Sett_No,
						Sett_Type,
						Refno,
						Tcode,
						Trtype,
						Party_Code,
						Scrip_Cd,
						Series,
						Qty,
						Fromno,
						Tono,
						Certno,
						Foliono,
						Holdername,
						Reason,
						Drcr,
						Delivered,
						Orgqty,
						Dptype,
						Dpid,
						Cltdpid,
						Branchcd,
						Partipantcode,
						Slipno,
						Batchno,
						Isett_No,
						Isett_Type,
						Sharetype,
						Transdate,
						Filler1,
						Filler2,
						Filler3,
						Bdptype,
						Bdpid,
						Bcltdpid,
						Filler4,
						Filler5
						)
					SELECT
						Sett_No,
						Sett_Type,
						Refno,
						Tcode,
						Trtype = 907,
						Party_Code,
						Scrip_Cd,
						Series,
						Qty,
						Fromno = TransNo,
						Tono = TransNo,
						Certno = IsIn,
						Foliono = TransNo,
						Holdername = DpName,
						Reason = @@Reason,
						Drcr = 'D',
						Delivered = '0',
						Orgqty = Qty,
						Dptype ,
						Dpid,
						Cltdpid = CltAccNo,
						Branchcd = Branch_Cd,
						Partipantcode,
						Slipno = '0',
						Batchno = '0',
						Isett_No = @TargetSetNo,
						Isett_Type = @TargetSetType,
						Sharetype = 'DEMAT',
						Transdate = TrDate,
						Filler1,
						Filler2 = 1,
						Filler3 = '',
						Bdptype,
						Bdpid ,
						Bcltdpid = BCltAccNo,
						Filler4 ,
						Filler5
					FROM DematTrans
					WHERE SNo = @@SNo 
						AND TCode = @@TCode
	
				   IF @@ERROR <> 0 
						RETURN
	
					--- Remove the records from DematTrans
					DELETE FROM DematTrans
					WHERE SNo = @@SNo 
						AND TCode = @@TCode
	
						SET @TransferQty = @TransferQty - @@Qty
				END		--- IF @@Qty <= @TransferQty  
				ELSE IF @@Qty > @TransferQty  
				BEGIN
					---- Record Type C 
					INSERT INTO DelTrans
						(
						Sett_No,
						Sett_Type,
						Refno,
						Tcode,
						Trtype,
						Party_Code,
						Scrip_Cd,
						Series,
						Qty,
						Fromno,
						Tono,
						Certno,
						Foliono,
						Holdername,
						Reason,
						Drcr,
						Delivered,
						Orgqty,
						Dptype,
						Dpid,
						Cltdpid,
						Branchcd,
						Partipantcode,
						Slipno,
						Batchno,
						Isett_No,
						Isett_Type,
						Sharetype,
						Transdate,
						Filler1,
						Filler2,
						Filler3,
						Bdptype,
						Bdpid,
						Bcltdpid,
						Filler4,
						Filler5
						)
					SELECT
						Sett_No,
						Sett_Type,
						Refno,
						Tcode,
						Trtype,
						Party_Code,
						Scrip_Cd,
						Series,
						Qty = @TransferQty,
						Fromno = TransNo,
						Tono = TransNo,
						Certno = IsIn,
						Foliono = TransNo,
						Holdername = DpName,
						Reason = 'Excess Transfer',
						Drcr = 'C',
						Delivered = '0',
						Orgqty = @TransferQty,
						Dptype,
						Dpid,
						Cltdpid = CltAccNo,
						Branchcd = Branch_Cd,
						Partipantcode,
						Slipno = '0',
						Batchno = '0',
						Isett_No = '',
						Isett_Type = '',
						Sharetype = 'DEMAT',
						Transdate = TrDate,
						Filler1,
						Filler2 = 1,
						Filler3 = '',
						Bdptype,
						Bdpid,
						Bcltdpid = BCltAccNo,
						Filler4,
						Filler5
					FROM DematTrans
					WHERE SNo = @@SNo 
							AND TCode = @@TCode
		
					--- Record Type = D
					INSERT INTO DelTrans
						(
						Sett_No,
						Sett_Type,
						Refno,
						Tcode,
						Trtype,
						Party_Code,
						Scrip_Cd,
						Series,
						Qty,
						Fromno,
						Tono,
						Certno,
						Foliono,
						Holdername,
						Reason,
						Drcr,
						Delivered,
						Orgqty,
						Dptype,
						Dpid,
						Cltdpid,
						Branchcd,
						Partipantcode,
						Slipno,
						Batchno,
						Isett_No,
						Isett_Type,
						Sharetype,
						Transdate,
						Filler1,
						Filler2,
						Filler3,
						Bdptype,
						Bdpid,
						Bcltdpid,
						Filler4,
						Filler5
						)
					SELECT
						Sett_No,
						Sett_Type,
						Refno,
						Tcode,
						Trtype = 907,
						Party_Code,
						Scrip_Cd,
						Series,
						Qty = @TransferQty,
						Fromno = TransNo,
						Tono = TransNo,
						Certno = IsIn,
						Foliono = TransNo,
						Holdername = DpName,
						Reason = @@Reason,
						Drcr = 'D',
						Delivered = '0',
						Orgqty = @TransferQty,
						Dptype,
						Dpid,
						Cltdpid = CltAccNo,
						Branchcd = Branch_Cd,
						Partipantcode,
						Slipno = '0',
						Batchno = '0',
						Isett_No = @TargetSetNo,
						Isett_Type = @TargetSetType,
						Sharetype = 'DEMAT',
						Transdate = TrDate,
						Filler1,
						Filler2 = 1,
						Filler3 = '',
						Bdptype,
						Bdpid,
						Bcltdpid = BCltAccNo,
						Filler4,
						Filler5
					FROM DematTrans
					WHERE SNo = @@SNo 
						AND TCode = @@TCode
	
				   IF @@ERROR <> 0 
						RETURN
	
					--- Update the qty in DematTrans
					UPDATE DematTrans SET Qty = (Qty - @TransferQty)
					WHERE SNo = @@SNo 
						AND TCode = @@TCode

				   IF @@ERROR <> 0 
						RETURN

					SET @TransferQty = @TransferQty - @@Qty
				END 	--  IF @@Qty > @TransferQty

				FETCH curDematTrans INTO @@Sett_No, @@Sett_Type, @@SNo, @@TCode, @@Qty		
			END
			CLOSE curDematTrans
			DEALLOCATE curDematTrans
		END 			--  IF @AvilableQty <> @TransferQty 
	END 				--- IF @NormalOrExcess = 'EXCESS'
	
	 IF @@ERROR <> 0 
		RETURN
	 ELSE
		SET @SuccessFlag = 'Y'	

END				--- Procedure End

GO
