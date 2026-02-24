-- Object: PROCEDURE dbo.CBO_ADDEDIT_DIRECTPAYIN
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------









Create PROCEDURE [dbo].[CBO_ADDEDIT_DIRECTPAYIN]

	@Sett_No VARCHAR(10),
	@Sett_Type VARCHAR(2),
	@Party_Code VARCHAR(10),
	@Scrip_Cd VARCHAR(12),
	@Series VARCHAR(4),
	@Isin  VARCHAR(12),
	@Sellqty INT,
	@Directpayqty INT,
	@Dpid VARCHAR(8),
	@Dptype VARCHAR(5),
	@Cltdpid VARCHAR(16),
	@Batchno INT,
	@Locked INT,
	@FLAG VARCHAR(10),
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
AS
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	
	IF @FLAG = 'E'
	BEGIN
		delete from DelBseDirectPI where  sett_no = @Sett_No and sett_type = @Sett_Type

		insert into 
			DelBseDirectPI 
		   (Party_code,
			scrip_cd,
			Isin,
			SellQty,
			DirectpayQty,
			dpid,
			Cltdpid,
			dptype,
			Batchno,
			sett_no,
			sett_type,
			series,
			locked) 
			values( 
			@Party_Code,
			@Scrip_Cd,
			@Isin,
			@Sellqty,
			@Directpayqty,
			@Dpid,
			@Cltdpid,
			@Dptype,
			@Batchno,
			@Sett_No,
			@Sett_Type,
			@Series,
			@Locked )
	END

GO
