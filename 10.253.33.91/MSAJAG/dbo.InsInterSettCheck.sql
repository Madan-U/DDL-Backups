-- Object: PROCEDURE dbo.InsInterSettCheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.InsInterSettCheck    Script Date: 05/08/2002 12:35:04 PM ******/



/****** Object:  Stored Procedure dbo.InsInterSettCheck    Script Date: 4/12/01 1:05:15 PM ******/
CREATE PROC InsInterSettCheck(@SETT_NO VARCHAR(7),@SETT_TYPE VARCHAR(2),@RefNo int) AS
DECLARE
@@PARTY_CODE VARCHAR(10),
@@SCRIP_CD VARCHAR(12),
@@CQTY INT,
@@PSETTNO VARCHAR(7),
@@PSETTTYPE VARCHAR(2),
@@ISIN VARCHAR(16),
@@TRANSNO VARCHAR(10),
@@TDATE VARCHAR(11),
@@DQTY INT,
@@certno varchar(16),
@@SNo Numeric(18,0),
@@TCode Numeric(18,0),
@@DSNo Numeric(18,0),
@@DTCode Numeric(18,0),
@@CINTER CURSOR,
@@DINTER CURSOR

SET @@CINTER = CURSOR FOR
select party_code,scrip_cd,QTY,sett_no,sett_type,certno,SNo,TCode from DelTrans
where Isett_no = @SETT_NO and Isett_type = @SETT_TYPE and TrType = 907 and RefNo = @RefNo and Delivered <> 'D'  
and DrCr = 'D' and Filler2 = 1  
ORDER BY party_code,scrip_cd,sett_no,sett_type,certno
OPEN @@CINTER
FETCH NEXT FROM @@CINTER INTO @@party_code,@@scrip_cd,@@CQTY,@@Psettno,@@Psetttype,@@certno,@@SNo,@@TCode
WHILE @@FETCH_STATUS = 0 
BEGIN
	SET @@DINTER = CURSOR FOR
	select Isin,TransNo,LEFT(CONVERT(VARCHAR,TrDate,109),11),qty,Sno,TCode from DematTrans where sett_no = @SETT_NO 
	and sett_type = @SETT_TYPE and cltaccno = @@PSETTNO and party_code = 'Party' and DrCr = 'C'  
	AND SCRIP_CD = @@SCRIP_CD and TrType = 907 ORDER BY sett_no,sett_type,party_code,scrip_cd,Isin,TransNo,TrDate
	OPEN @@DINTER
	FETCH NEXT FROM @@DINTER INTO @@ISIN,@@TRANSNO,@@TDATE,@@DQTY,@@DSno,@@DTCode
	if @@FETCH_STATUS = 0 
	BEGIN
		if @@cqty = @@dqty 
		begin
			Update DematTrans Set Party_Code = @@Party_Code where sett_no = @SETT_NO and 
			sett_type = @SETT_TYPE and cltaccno = @@PSETTNO and party_code = 'Party'
			AND SCRIP_CD = @@SCRIP_CD and TrType = 907 and SNo = @@DSNo and TCode = @@DTCode	
			and TransNo = @@TransNo and Isin = @@Isin and DrCr = 'C'   
			
			Update DelTrans Set Delivered = 'D' where Isett_no = @SETT_NO and Isett_type = @SETT_TYPE 
			and TrType = 907 and RefNo = @RefNo and Delivered <> 'D' and Sno = @@Sno and TCode = @@TCode
			and certno = @@certno and DrCr = 'D' and Filler2 = 1  
			
		end
		else if @@cqty > @@dqty 
		begin
			
			insert into deltrans(Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,qty,FromNo,ToNo,CertNo,FolioNo
			,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3)
			Select Sett_No,Sett_type,RefNo,TCode,TrType,Party_Code,scrip_cd,series,@@Cqty-@@Dqty,FromNo,ToNo,CertNo,FolioNo
			,HolderName,Reason,DrCr,Delivered,OrgQty,DpType,DpId,CltDpId,BranchCd,PartipantCode,SlipNo,BatchNo,ISett_No,ISett_Type,ShareType,TransDate,Filler1,Filler2,Filler3
			from DelTrans where Isett_no = @SETT_NO and Isett_type = @SETT_TYPE  
			and TrType = 907 and RefNo = @RefNo and Delivered <> 'D' and Sno = @@Sno and TCode = @@TCode
			and certno = @@certno and DrCr = 'D' and Filler2 = 1  

			Update DelTrans Set Delivered = 'D',Qty = @@Dqty where Isett_no = @SETT_NO and Isett_type = @SETT_TYPE 
			and TrType = 907 and RefNo = @RefNo and Delivered <> 'D' and Sno = @@Sno and TCode = @@TCode  
			and certno = @@certno and DrCr = 'D' and Filler2 = 1  

			Update DematTrans Set Party_Code = @@Party_Code where sett_no = @SETT_NO and 
			sett_type = @SETT_TYPE and cltaccno = @@PSETTNO and party_code = 'Party'
			AND SCRIP_CD = @@SCRIP_CD and TrType = 907 and SNo = @@DSNo and TCode = @@DTCode	
			and TransNo = @@TransNo and Isin = @@Isin and DrCr = 'C'   
		end
		else
		begin
			insert into DematTrans (Sett_No,Sett_Type,RefNo,TCode,TrType,Party_Code,Scrip_Cd,Series,Qty,TrDate,CltAccNo,DpId,DpName,IsIn,Branch_Cd,PartiPantCode,DpType,TransNo,DrCr)
			select Sett_No,Sett_Type,RefNo,TCode,TrType,Party_Code,Scrip_Cd,Series,@@DQty-@@CQty,TrDate,CltAccNo,DpId,DpName,IsIn,Branch_Cd,PartiPantCode,DpType,TransNo,DrCr
			from DematTrans where sett_no = @SETT_NO and 
			sett_type = @SETT_TYPE and cltaccno = @@PSETTNO and party_code = 'Party'
			AND SCRIP_CD = @@SCRIP_CD and TrType = 907 and SNo = @@DSNo and TCode = @@DTCode	
			and TransNo = @@TransNo and Isin = @@Isin and DrCr = 'C' 
			
			Update DematTrans Set Party_Code = @@Party_Code,Qty = @@CQty where sett_no = @SETT_NO and 
			sett_type = @SETT_TYPE and cltaccno = @@PSETTNO and party_code = 'Party'
			AND SCRIP_CD = @@SCRIP_CD and TrType = 907 and SNo = @@DSNo and TCode = @@DTCode	
			and TransNo = @@TransNo and Isin = @@Isin and DrCr = 'C'  

			Update DelTrans Set Delivered = 'D' where Isett_no = @SETT_NO and Isett_type = @SETT_TYPE 
			and TrType = 907 and RefNo = @RefNo and Delivered <> 'D' and Sno = @@Sno and TCode = @@TCode 			
			and certno = @@certno and DrCr = 'D'	and Filler2 = 1  		
		end
	END
	close @@DINTER
	Deallocate @@DInter
	FETCH NEXT FROM @@CINTER INTO @@party_code,@@scrip_cd,@@CQTY,@@Psettno,@@Psetttype,@@certno,@@SNo,@@TCode
END
Close @@CInter
Deallocate @@CInter

GO
