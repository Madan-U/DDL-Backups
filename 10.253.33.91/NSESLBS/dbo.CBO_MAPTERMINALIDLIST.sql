-- Object: PROCEDURE dbo.CBO_MAPTERMINALIDLIST
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



create   PROCEDURE [dbo].[CBO_MAPTERMINALIDLIST]
(
	@USER_ID VARCHAR(15) = '',
        @PARTY_CODE VARCHAR(25)='',  
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS
/*
	EXEC CBO_CUSTODIANLIST '123456', 'BROKER', 'BROKER'
	SELECT @@ERROR
*/
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	IF (@USER_ID= '' OR @USER_ID = '%')and( @PARTY_CODE  = '' OR  @PARTY_CODE  = '%')
		BEGIN
	SELECT
		Userid,
                Party_Code,
                Exceptparty,
                procli
	FROM
		TERMPARTY
			
		END
	ELSE IF @USER_ID <> ''
		BEGIN
			SELECT
			      Userid,
                              Party_Code,
                              Exceptparty,
                              procli
			FROM
				TERMPARTY
			WHERE
				Userid LIKE @USER_ID + '%'
			
		END
	Else
                BEGIN
			SELECT
			      Userid,
                              Party_Code,
                              Exceptparty,
                              procli
			FROM
				TERMPARTY
			
			WHERE
				Party_Code LIKE  @PARTY_CODE + '%'
			
		END

GO
