-- Object: PROCEDURE dbo.CBO_ADDEDITDEL_MAPTERMINALID
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE  PROCEDURE [dbo].[CBO_ADDEDITDEL_MAPTERMINALID]
	@USER_ID VARCHAR(15),
	@PARTY_CODE VARCHAR(21),
	@PRO_CLI VARCHAR(50),
	@EXCEPT_PARTY VARCHAR(50),
	@FLAG   VARCHAR(10)='A',
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
	IF @FLAG = 'E'
		BEGIN
			UPDATE
				TERMPARTY WITH (ROWLOCK)
			SET
			Party_Code=@PARTY_CODE,
			Procli=@PRO_CLI,
			Exceptparty=@EXCEPT_PARTY 
			WHERE
		         userid = @USER_ID
		END
	ELSE IF @FLAG = 'A'
		INSERT INTO TERMPARTY
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
             ELSE IF @FLAG = 'D'
		BEGIN
			DELETE FROM
				TERMPARTY
			WHERE
				userid =@USER_ID
		END

GO
