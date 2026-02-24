-- Object: PROCEDURE dbo.CBO_GETTERMLIST
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------






CREATE       PROC CBO_GETTERMLIST
        @UserId VARCHAR(20) ='',
        @Tradelimit VARCHAR(25)='',
        @STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'

AS	

IF @STATUSID <> 'BROKER'
	BEGIN
		RAISERROR ('This Procedure is accessible to Broker', 16, 1)
		RETURN
	END

IF  @UserId = '%'
		BEGIN
			SELECT
				UserId,
                                Tradelimit
			FROM
				Termlimit
			
			ORDER BY
				UserId
		END

 IF @UserId <> ''
BEGIN

                 SELECT 
			UserId,TradeLimit 
		FROM 
			Termlimit 
                WHERE 
                   		UserId LIKE @UserId + '%'
                 ORDER BY 
              
				     UserId
	              
END

GO
