-- Object: PROCEDURE dbo.CBO_ExcessSharePayout
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------






--select * from bsedb.dbo.demattrans
--select * from bsedb.dbo.DELtrans
--execute CBO_DeliveryExcessMarking '2','BSE','Y'
-- ALTER      PROCEDURE CBO_DeliveryExcessMarking
-- (
-- 	@SNo INT,
-- 	@PartyCode VARCHAR(10),
-- 	@SuccessFlag CHAR(1) OUTPUT,
--    @STATUSID   VARCHAR(25) = 'BROKER',
-- 	@STATUSNAME VARCHAR(25) = 'BROKER'
-- )
-- AS
-- BEGIN
-- 	
--     IF @STATUSID <> 'BROKER'
-- 		BEGIN
-- 			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
-- 			RETURN
-- 		END
-- 
-- 	SET @SuccessFlag = 'Y'
-- 
-- 			---- Record Type C 
-- 			INSERT INTO bsedb.dbo.DelTrans
-- 				(
-- 				Sett_No,
-- 				Sett_Type,
-- 				Refno,
-- 				Tcode,
-- 				Trtype,
-- 				Party_Code,
-- 				Scrip_Cd,
-- 				Series,
-- 				Qty,
-- 				Fromno,
-- 				Tono,
-- 				Certno,
-- 				Foliono,
-- 				Holdername,
-- 				Reason,
-- 				Drcr,
-- 				Delivered,
-- 				Orgqty,
-- 				Dptype,
-- 				Dpid,
-- 				Cltdpid,
-- 				Branchcd,
-- 				Partipantcode,
-- 				Slipno,
-- 				Batchno,
-- 				Isett_No,
-- 				Isett_Type,
-- 				Sharetype,
-- 				Transdate,
-- 				Filler1,
-- 				Filler2,
-- 				Filler3,
-- 				Bdptype,
-- 				Bdpid,
-- 				Bcltdpid,
-- 				Filler4,
-- 				Filler5
-- 				)
-- 			SELECT
-- 				Sett_No,
-- 				Sett_Type,
-- 				Refno,
-- 				Tcode,
-- 				Trtype,
-- 				Party_Code = @PartyCode,
-- 				Scrip_Cd,
-- 				Series,
-- 				Qty,
-- 				Fromno = TransNo,
-- 				Tono = TransNo,
-- 				Certno = IsIn,
-- 				Foliono = TransNo,
-- 				Holdername = '',
-- 				Reason = 'Excess Transfer',
-- 				Drcr = 'C',
-- 				Delivered = '0',
-- 				Orgqty = Qty,
-- 				Dptype,
-- 				Dpid,
-- 				Cltdpid = CltAccNo,
-- 				Branchcd = Branch_Cd,
-- 				Partipantcode,
-- 				Slipno = '0',
-- 				Batchno = '0',
-- 				Isett_No = '',
-- 				Isett_Type = '',
-- 				Sharetype = 'DEMAT',
-- 				Transdate = TrDate,
-- 				Filler1,
-- 				Filler2 = 1,
-- 				Filler3 = '',
-- 				Bdptype,
-- 				Bdpid,
-- 				Bcltdpid = BCltAccNo,
-- 				Filler4,
-- 				Filler5
-- 			FROM bsedb.dbo.DematTrans
-- 			WHERE SNo = @SNo
-- 				
-- 			--- Record Type = D
-- 			INSERT INTO bsedb.dbo.DelTrans
-- 				(
-- 				Sett_No,
-- 				Sett_Type,
-- 				Refno,
-- 				Tcode,
-- 				Trtype,
-- 				Party_Code,
-- 				Scrip_Cd,
-- 				Series,
-- 				Qty,
-- 				Fromno,
-- 				Tono,
-- 				Certno,
-- 				Foliono,
-- 				Holdername,
-- 				Reason,
-- 				Drcr,
-- 				Delivered,
-- 				Orgqty,
-- 				Dptype,
-- 				Dpid,
-- 				Cltdpid,
-- 				Branchcd,
-- 				Partipantcode,
-- 				Slipno,
-- 				Batchno,
-- 				Isett_No,
-- 				Isett_Type,
-- 				Sharetype,
-- 				Transdate,
-- 				Filler1,
-- 				Filler2,
-- 				Filler3,
-- 				Bdptype,
-- 				Bdpid,
-- 				Bcltdpid,
-- 				Filler4,
-- 				Filler5
-- 				)
-- 			SELECT
-- 				Sett_No,
-- 				Sett_Type,
-- 				Refno,
-- 				Tcode,
-- 				Trtype= 904,
-- 				Party_Code = 'BROKER',
-- 				Scrip_Cd,
-- 				Series,
-- 				Qty,
-- 				Fromno = TransNo,
-- 				Tono = TransNo,
-- 				Certno = IsIn,
-- 				Foliono = TransNo,
-- 				Holdername = '',
-- 				Reason = 'Excess Received Transfered',
-- 				Drcr = 'D',
-- 				Delivered = '0',
-- 				Orgqty = Qty,
-- 				Dptype = '',
-- 				Dpid = '',
-- 				Cltdpid = '',
-- 				Branchcd = Branch_Cd,
-- 				Partipantcode,
-- 				Slipno = '0',
-- 				Batchno = '0',
-- 				Isett_No = '',
-- 				Isett_Type = '',
-- 				Sharetype = 'DEMAT',
-- 				Transdate = TrDate,
-- 				Filler1,
-- 				Filler2 = 1,
-- 				Filler3 = '',
-- 				Bdptype,
-- 				Bdpid,
-- 				Bcltdpid = BCltAccNo,
-- 				Filler4,
-- 				Filler5
-- 			FROM bsedb.dbo.DematTrans
-- 			WHERE SNo = @SNo 
-- 				
-- 			--- Remove the records from DematTrans 
-- 			DELETE FROM bsedb.dbo.DematTrans	WHERE SNo = @SNo
-- END



CREATE PROCEDURE CBO_ExcessSharePayout
(
   @SNo varchar(10),
   @DpType varchar(10),
   @AccNo  varchar(10),
   @BankId varchar(10),
   @Reason varchar(10),
   @Scrip varchar(10),
   @RefNo varchar(10),
	@SuccessFlag CHAR(1) OUTPUT,
   @STATUSID   VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS
BEGIN
	
    IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END

	SET @SuccessFlag = 'Y'

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
				Holdername='',
				Reason=@Reason,
				Drcr = 'D',
				Delivered='0',
				Orgqty = Qty,
				Dptype=@DpType,
				Dpid=@BankId,
				Cltdpid = @AccNo,
				Branchcd = Branch_Cd,
				Partipantcode,
				Slipno = '0',
				Batchno = '0',
 				Isett_No = '',
 				Isett_Type = '',
 				Sharetype = 'DEMAT',
 				Transdate = TrDate,
				Filler1,
				Filler2 = '1',
				Filler3 = '',
				Bdptype,
				Bdpid,
				Bcltdpid = BCltAccNo,
				Filler4,
				Filler5
			FROM DematTrans
			WHERE SNo = @SNo and Scrip_cd =@Scrip   and RefNo =@RefNo 
         

			Update DelTrans 
			Set Filler2 = 0,
				 Filler3 = 70,
             Reason = @Reason,
             HolderName = 'CHANGED DEFAULT PAYOUT ID'
         Where Sno =@SNo
         and Scrip_cd = @Scrip 
         and RefNo =@RefNo



			
END

GO
