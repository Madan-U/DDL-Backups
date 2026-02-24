-- Object: PROCEDURE dbo.CBO_ADDEDITDEL_STATEMASTER1
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------











CREATE      PROCEDURE [dbo].[CBO_ADDEDITDEL_STATEMASTER1]
	@SrNo INT,
	@State VARCHAR(50),
	@TrdStampDuty DECIMAL(18,4),
	@DelStampDuty DECIMAL(18,4),
        @ProStampDuty DECIMAL(18,4),
        @Min_Multiplier DECIMAL(18,4),
        @For_Turnover DECIMAL(18,4),
        @Maximum_Limit DECIMAL(18,4),
        @INCL_IN_NONMAH INT,
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
