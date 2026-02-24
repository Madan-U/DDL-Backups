-- Object: PROCEDURE dbo.CBO_ADDEDITDEL_STATEMASTER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------










CREATE       PROCEDURE [dbo].[CBO_ADDEDITDEL_STATEMASTER]
	@SrNo VARCHAR(15),
	@State VARCHAR(50),
	@TrdStampDuty VARCHAR(50),
	@DelStampDuty VARCHAR(50),
        @ProStampDuty VARCHAR(50),
        @Min_Multiplier VARCHAR(50),
        @For_Turnover VARCHAR(50),
        @Maximum_Limit VARCHAR(50),
        @INCL_IN_NONMAH VARCHAR(50),
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
	IF @FLAG = 'E'
		BEGIN
			UPDATE
				State_Master WITH (ROWLOCK)
			SET
                     State=@State ,
	             TrdStampDuty=@TrdStampDuty ,
	             DelStampDuty=@DelStampDuty ,
		     ProStampDuty=@ProStampDuty ,
		     Min_Multiplier=@Min_Multiplier,
		     For_Turnover=@For_Turnover ,
		     Maximum_Limit=@Maximum_Limit,
		     INCL_IN_NONMAH=@INCL_IN_NONMAH
			 
			WHERE
		         SrNo = @SrNo
		END

	ELSE IF @FLAG = 'A'
             BEGIN
              
                     
		INSERT INTO State_Master
		(
			State,
	             TrdStampDuty,
	             DelStampDuty,
		     ProStampDuty,
		     Min_Multiplier,
		     For_Turnover,
		     Maximum_Limit,
		     INCL_IN_NONMAH
			
		)
		VALUES
		(
		     @State ,
	             @TrdStampDuty ,
	             @DelStampDuty ,
		     @ProStampDuty ,
		     @Min_Multiplier,
		     @For_Turnover ,
		     @Maximum_Limit,
		     @INCL_IN_NONMAH
			
		)
END
             ELSE IF @FLAG = 'D'
		BEGIN
			DELETE 
				State_Master
			WHERE
				SrNo = @SrNo
		END

GO
