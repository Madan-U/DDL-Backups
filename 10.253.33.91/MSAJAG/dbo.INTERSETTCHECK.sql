-- Object: PROCEDURE dbo.INTERSETTCHECK
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.INTERSETTCHECK    Script Date: 5/7/01 4:58:30 PM ******/
CREATE PROC INTERSETTCHECK (@SETT_NO VARCHAR(7),@SETT_TYPE VARCHAR(2)) AS
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
@@fromno varchar(16),
@@tono varchar(16),
@@certno varchar(16),
@@foliono varchar(16),
@@RecieptNo int,
@@SubRecNo int,
@@CINTER CURSOR,
@@DINTER CURSOR

SET @@CINTER = CURSOR FOR
select party_code,scrip_cd,QTY,Psettno,Psett_type,fromno,tono,certno,foliono,RecieptNo,SubRecNo from certinfo 
where sett_no = @SETT_NO and sett_type = @SETT_TYPE and tono = 'Inter Transfer'
ORDER BY party_code,scrip_cd,Psettno,Psett_type,fromno,tono,certno,foliono,RecieptNo,SubRecNo
OPEN @@CINTER
FETCH NEXT FROM @@CINTER INTO @@party_code,@@scrip_cd,@@CQTY,@@Psettno,@@Psetttype,@@fromno,@@tono,@@certno,@@foliono,@@RecieptNo,@@SubRecNo
WHILE @@FETCH_STATUS = 0 
BEGIN
	SET @@DINTER = CURSOR FOR
	select Isin,TransNo,LEFT(CONVERT(VARCHAR,Date,109),11),qty from DematDelivery 
	where sett_no = @SETT_NO and sett_type = @SETT_TYPE and cltaccno = @@PSETTNO and party_code = 'Party'
	AND SCRIP_CD = @@SCRIP_CD ORDER BY sett_no,sett_type,party_code,scrip_cd,Isin,TransNo,Date
	OPEN @@DINTER
	FETCH NEXT FROM @@DINTER INTO @@ISIN,@@TRANSNO,@@TDATE,@@DQTY
	if @@FETCH_STATUS = 0 
	BEGIN
		if @@cqty = @@dqty 
		begin
			update certinfo set fromno = @@TRANSNO,date = @@TDate 
			where sett_no = @SETT_NO and sett_type = @SETT_TYPE and tono = 'Inter Transfer'
			and qty = @@cqty and Psettno = @@Psettno and PSett_Type = @@Psetttype 
			and fromno = @@fromno and tono = @@tono and certno = @@certno 
			and foliono = @@foliono and recieptno = @@RecieptNo and subrecno = @@SubRecNo

			delete from DematDelivery 
			where sett_no = @SETT_NO and sett_type = @SETT_TYPE and cltaccno = @@PSETTNO and Party_code = 'Party'
			AND SCRIP_CD = @@SCRIP_CD and isin = @@isin and transno = @@transno				
		end
		else if @@cqty > @@dqty 
		begin
			insert into certinfo 
			select Sett_no,Sett_type,scrip_cd,series,@@Cqty-@@Dqty,party_code,date,fromno,tono,reason,certno,foliono,holdername,
			TargetParty,inout,Delivered,PSettNo,Psett_Type,RecieptNo,OrgQty,SubRecNo,DpType,PODpId,POCltNo,SlipNo
			from certinfo where sett_no = @SETT_NO and sett_type = @SETT_TYPE and tono = 'Inter Transfer'
			and qty = @@cqty and Psettno = @@Psettno and PSett_Type = @@Psetttype 
			and fromno = @@fromno and tono = @@tono and certno = @@certno 
			and foliono = @@foliono and recieptno = @@RecieptNo and subrecno = @@SubRecNo

			update certinfo set fromno = @@TRANSNO,date = @@TDate,Qty = @@Dqty 
			where sett_no = @SETT_NO and sett_type = @SETT_TYPE and tono = 'Inter Transfer'
			and qty = @@cqty and Psettno = @@Psettno and PSett_Type = @@Psetttype 
			and fromno = @@fromno and tono = @@tono and certno = @@certno 
			and foliono = @@foliono and recieptno = @@RecieptNo and subrecno = @@SubRecNo
 			
			delete from DematDelivery 
			where sett_no = @SETT_NO and sett_type = @SETT_TYPE and cltaccno = @@PSETTNO and Party_code = 'Party'
			AND SCRIP_CD = @@SCRIP_CD and isin = @@isin and transno = @@transno	
		end
		else
		begin
			insert into dematdelivery
			select Sett_no,sett_type,Party_code,Isin,BankCode,@@DQty-@@CQty,Scrip_cd,series,InOut,CltAccno,TransNo,Date,DpType
			from dematdelivery where sett_no = @SETT_NO and sett_type = @SETT_TYPE and cltaccno = @@PSETTNO and Party_code = 'Party'
			AND SCRIP_CD = @@SCRIP_CD and isin = @@isin and transno = @@transno and qty = @@DQty
			
			update certinfo set fromno = @@TRANSNO,date = @@TDate 
			where sett_no = @SETT_NO and sett_type = @SETT_TYPE and tono = 'Inter Transfer'
			and qty = @@cqty and Psettno = @@Psettno and PSett_Type = @@Psetttype 
			and fromno = @@fromno and tono = @@tono and certno = @@certno and qty = @@CQty
			and foliono = @@foliono and recieptno = @@RecieptNo and subrecno = @@SubRecNo				
		end
	END
	close @@DINTER
	Deallocate @@DInter
	FETCH NEXT FROM @@CINTER INTO @@party_code,@@scrip_cd,@@CQTY,@@Psettno,@@Psetttype,@@fromno,@@tono,@@certno,@@foliono,@@RecieptNo,@@SubRecNo
END
Close @@CInter
Deallocate @@CInter

GO
