-- Object: PROCEDURE dbo.CBO_ADDEDITDEL_MAPTERMINAL_ID
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------











CREATE          PROCEDURE [dbo].[CBO_ADDEDITDEL_MAPTERMINAL_ID]
	@USER_ID VARCHAR(10),
	@PARTY_CODE VARCHAR(10),
	@PRO_CLI VARCHAR(50),
	@EXCEPT_PARTY VARCHAR(15),
	@FLAG   VARCHAR(1),
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
             BEGIN
              
                     IF EXISTS (SELECT TOP 1 userid FROM TERMPARTY WHERE userid = @USER_ID)
			BEGIN
					RAISERROR ('UserId already exists...', 16, 1)
				      RETURN
			        END		
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
END
             ELSE IF @FLAG = 'D'
		BEGIN
			DELETE 
				TERMPARTY
			WHERE
				userid =@USER_ID
                         and 
                              Party_Code=@PARTY_CODE 
		END

GO
