-- Object: PROCEDURE dbo.CBO_PledgeMarkingUnMarking
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

-- select * from deltrans where party_code = '0A141' and scrip_cd = '500013'
/*

declare @SuccessFlag CHAR(1) 

EXEC CBO_PledgeMarkingUnMarking 904, 909, 110, 10, '0A141', '500013', 'BSE', '12034400', '1203440000006324',
'Pledge Transfer', @SuccessFlag OUTPUT
print @SuccessFlag


	@TrType INT,
	@NewTrType INT,
	@AvilableQty INT,
	@TransferQty INT,
	@PartyCode VARCHAR(10),
	@ScripCode VARCHAR(10),
	@Series VARCHAR(5),
	@PoolDPID VARCHAR(16),
	@PoolDPClientID VARCHAR(16),
	@Reason VARCHAR(25),
	@SuccessFlag CHAR(1) OUTPUT



*/
  CREATE PROCEDURE CBO_PledgeMarkingUnMarking  
(  
 @TrType INT,  
 @NewTrType INT,  
 @AvilableQty INT,  
 @TransferQty INT,  
 @PartyCode VARCHAR(10),  
 @ScripCode VARCHAR(10),  
 @Series VARCHAR(5),  
 @PoolDPID VARCHAR(16),  
 @PoolDPClientID VARCHAR(16),  
 @Reason VARCHAR(25),  
 @SuccessFlag CHAR(1) OUTPUT  
)  
AS  
BEGIN  
 DECLARE  
  @@Sett_No  VARCHAR(15),  
  @@Sett_Type VARCHAR(10),  
  @@SNo NUMERIC,  
  @@TCode NUMERIC,  
  @@Qty NUMERIC  
  
 SET @SuccessFlag = 'N'  
  
 --- If transfer full qty    
 IF @AvilableQty = @TransferQty  
  UPDATE DelTrans SET   
   TrType = @NewTrType,  
   Reason = @Reason  
   WHERE TrType = @TrType   
   And Party_code Like @PartyCode  
   and Scrip_Cd = @ScripCode  
   and series = @Series  
   And Filler2 = 1   
   And DrCr = 'D'   
   And BDpId = @PoolDPID  
   And BCltDpId = @PoolDPClientID  
   And Delivered = '0'  
  
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
   WHERE TrType = @TrType   
   And Party_code Like @PartyCode  
   and Scrip_Cd = @ScripCode  
   and series = @Series  
   And Filler2 = 1   
   And DrCr = 'D'   
   And BDpId = @PoolDPID  
   And BCltDpId = @PoolDPClientID  
   And Delivered = '0'  
  ORDER BY Sett_No, Sett_Type, Qty DESC   
    
  OPEN curDelTrans  
  FETCH curDelTrans INTO @@Sett_No, @@Sett_Type, @@SNo, @@TCode, @@Qty    
  WHILE @@FETCH_STATUS = 0 AND @TransferQty > 0  
  BEGIN  
   IF @@Qty <= @TransferQty    
   BEGIN  
    UPDATE DelTrans SET   
     TrType = @NewTrType,  
     Reason = @Reason  
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
     TrType = @NewTrType,  
     Reason = @Reason,  
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
--select * from demattrans

GO
