-- Object: PROCEDURE dbo.CBO_ADDEDIT_MAP_TERMINALID
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------






CREATE     PROCEDURE [dbo].[CBO_ADDEDIT_MAP_TERMINALID]
	@USER_ID VARCHAR(15),
	@PARTY_CODE VARCHAR(21),
	@PRO_CLI VARCHAR(50),
	@EXCEPT_PARTY VARCHAR(50),
	@FLAG   VARCHAR(10),
        @STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
AS
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	IF @FLAG <> 'A' AND @FLAG <> 'E' AND @FLAG <> 'D'
		BEGIN
			RAISERROR ('Add/Edit Flags Not Set Properly', 16, 1)
			RETURN
		END
	--IF @FLAG = 'E'
		--BEGIN
			--UPDATE
				--CUSTODIAN WITH (ROWLOCK)
			--SET
				--SHORT_NAME = @SHORT_NAME,
				--LONG_NAME = @LONG_NAME,
				--ADDRESS1 = @ADDRESS1,
				--ADDRESS2 = @ADDRESS2,
				--CITY = @CITY,
			--	STATE = @STATE,
			--	NATION = @NATION,
			--	ZIP = @ZIP,
				--FAX = @FAX,
				--OFF_PHONE1 = @OFF_PHONE1,
				--OFF_PHONE2 = @OFF_PHONE2,
				--EMAIL = @EMAIL,
				--CLTDPNO = @CLTDPNO,
				--DPID = @DPID,
				--SEBIREGNO = @SEBIREGNO
			--WHERE
				--CUSTODIANCODE = @CUSTODIANCODE
		--END
	 IF @FLAG = 'A'
         begin
		INSERT INTO TermParty
		(
			userid,
			Party_Code,
			Procli,
			Exceptparty
			
		)
		VALUES
		(
			@USER_ID ,
	                @PARTY_CODE ,
	                @PRO_CLI ,
	                @EXCEPT_PARTY 
			
		)
             end

GO
