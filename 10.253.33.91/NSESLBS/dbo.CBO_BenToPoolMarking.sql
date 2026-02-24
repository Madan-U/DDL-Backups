-- Object: PROCEDURE dbo.CBO_BenToPoolMarking
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE CBO_BenToPoolMarking    
(    
 @RefNo INT,    
 @TargetExchange VARCHAR(5),    
 @AvilableQty INT,    
 @TransferQty INT,    
 @PartyCode VARCHAR(10),    
 @ScripCode VARCHAR(10),    
 @Series VARCHAR(5),    
 @PoolDPID VARCHAR(16),    
 @PoolDPClientID VARCHAR(16),    
 @TargetSetType VARCHAR(10),    
 @TargetSetNo VARCHAR(15),    
 @SuccessFlag CHAR(1)   OUTPUT,    
 @STATUSID   VARCHAR(25) = 'BROKER',    
 @STATUSNAME VARCHAR(25) = 'BROKER'    
)    
AS    
BEGIN    
 DECLARE    
  @SourceSetType VARCHAR(10),    
  @SourceSetNo VARCHAR(15),    
  @@Reason VARCHAR(25),    
  @@Sett_No  VARCHAR(15),    
  @@Sett_Type VARCHAR(10),    
  @@SNo NUMERIC,    
  @@TCode NUMERIC,    
  @@Qty NUMERIC    
    
                        IF @STATUSID <> 'BROKER'    
  BEGIN    
   RAISERROR ('This Procedure is accessible to Broker', 16, 1)    
   RETURN    
  END    
    
 SET @SourceSetType = ''    
 SET @SourceSetNo = ''    
 SET @SuccessFlag = 'N'    
    
 IF (@RefNo = 110 AND @TargetExchange='NSE') OR (@RefNo = 120 AND @TargetExchange='BSE')    
     SET @@Reason = 'Inter Ben Transfer'    
 ELSE    
     SET @@Reason = 'Inter Sett Ben Transfer'    
    
 --- If transfer full qty      
 IF @AvilableQty = @TransferQty    
  UPDATE DelTrans SET     
   TrType = 1000,    
   ISett_No = @TargetSetNo,    
   ISett_Type = @TargetSetType,    
   Reason = @@Reason,    
   HolderName=@@Reason    
   WHERE TrType = 904     
   And Party_code = @PartyCode    
   and Scrip_Cd = @ScripCode    
   and series = @Series    
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
   and Scrip_Cd = @ScripCode    
   and series = @Series    
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
     TrType = 1000,    
     ISett_No = @TargetSetNo,    
     ISett_Type = @TargetSetType,    
     Reason = @@Reason,    
     HolderName=@@Reason    
     WHERE SNo = @@SNo     
     AND TCode = @@TCode    
    
       IF @@ERROR <> 0     
      RETURN    
    
     SET @TransferQty = @TransferQty - @@Qty    
   END  --- IF @@Qty <= @TransferQty      
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
     TrType = 1000,    
     ISett_No = @TargetSetNo,    
     ISett_Type = @TargetSetType,    
     Reason = @@Reason,    
     HolderName=@@Reason,    
     Qty = @TransferQty    
     WHERE SNo = @@SNo     
     AND TCode = @@TCode    
    
     IF @@ERROR <> 0     
      RETURN    
    
     SET @TransferQty = @TransferQty - @@Qty    
    
     FETCH curDelTrans INTO @@Sett_No, @@Sett_Type, @@SNo, @@TCode, @@Qty      
   END    
  END  --- End of the Cursor  Loop    
  CLOSE curDelTrans    
  DEALLOCATE curDelTrans    
    
 END   --- IF @AvilableQty <> @TransferQty    
    
  IF @@ERROR <> 0     
  RETURN    
  ELSE    
  SET @SuccessFlag = 'Y'     
    
END    --- Procedure End

GO
