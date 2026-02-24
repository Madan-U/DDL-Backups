-- Object: PROCEDURE dbo.EDIT_PARTICIPANT
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC EDIT_PARTICIPANT
	@FIXEDDATA VARCHAR(8000),
	@VARIABLEDATA VARCHAR(8000),
	@STATUSNAME VARCHAR(50),
	@FROMWHERE VARCHAR(100),
	@LEVEL VARCHAR(5)
AS
/*
	EXEC EDIT_PARTICIPANT 'ISettlement,16/02/2006', '0000020,UTIBK,ROLTA,EQ,2006031,N,2,bnpj0001|', 'AshokS/Broker/127.0.0.1', '/InsApp/innerReport.aspx', '501'
	BEGIN TRAN
	SELECT * FROM INST_LOG
	INSERT INTO INST_LOG SELECT DISTINCT 	'UTIBK', 	'UTIBK', 	CONVERT(DATETIME, '16/02/2006', 103), 	'2006031', 	'N', 	'ROLTA', 	'EQ', 	ORDER_NO, 	'%', 	2, 	'0000020', 	'0000020', 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	PARTIPANTCODE, 	'bnpj0001', 	'AshokS/Broker/127.0.0.1', 	'EDIT PARTICIPANT / /InsApp/innerReport.aspx', 	'EDIT_PARTICIPANT', 	GETDATE(), 	'', 	'', 	'' FROM ISettlement WHERE PARTY_CODE = 'UTIBK' AND SETT_NO = '2006031' AND SETT_TYPE = 'N' AND SCRIP_CD = 'ROLTA' AND SERIES = 'EQ' AND SELL_BUY = 2 AND CONVERT(VARCHAR(10), SAUDA_DATE, 103) = '16/02/2006' AND CONTRACTNO = '0000020' 
	UPDATE ISettlement SET PARTIPANTCODE = 'bnpj0001' WHERE PARTY_CODE = 'UTIBK' AND SETT_NO = '2006031' AND SETT_TYPE = 'N' AND SCRIP_CD = 'ROLTA' AND SERIES = 'EQ' AND SELL_BUY = 2 AND CONVERT(VARCHAR(10), SAUDA_DATE, 103) = '16/02/2006' AND CONTRACTNO = '0000020' 
	ROLLBACK

*/
	DECLARE
		@TABLE VARCHAR(25),
		@SAUDADATE VARCHAR(11),
		@CONTRACTNO VARCHAR(7),
		@PARTYCODE VARCHAR(10),
		@SCRIPCODE VARCHAR(10),
		@SERIES VARCHAR(2),
		@SETTNO VARCHAR(7),
		@SETTTYPE VARCHAR(3),
		@SELLBUY INT,
		@NEWINST VARCHAR(15),
		@SQL VARCHAR(8000),
		@RECORD VARCHAR(1000),
		@RECNO INT

IF CONVERT(NUMERIC(4), @LEVEL) = 501
	BEGIN
		SET @TABLE = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 1)))
		SET @SAUDADATE = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 2)))
		SET @RECNO = 1
		WHILE 1 = 1
			BEGIN
				SET @RECORD = .dbo.PIECE(@VARIABLEDATA, '|', @RECNO)
				IF @RECORD = '' OR @RECORD IS NULL
					BEGIN
						BREAK
					END
				SET @CONTRACTNO = LTRIM(RTRIM(.dbo.PIECE(@RECORD, ',', 1)))
				SET @PARTYCODE = LTRIM(RTRIM(.dbo.PIECE(@RECORD, ',', 2)))
				SET @SCRIPCODE = LTRIM(RTRIM(.dbo.PIECE(@RECORD, ',', 3)))
				SET @SERIES = LTRIM(RTRIM(.dbo.PIECE(@RECORD, ',', 4)))
				SET @SETTNO = LTRIM(RTRIM(.dbo.PIECE(@RECORD, ',', 5)))
				SET @SETTTYPE = LTRIM(RTRIM(.dbo.PIECE(@RECORD, ',', 6)))
				SET @SELLBUY = LTRIM(RTRIM(.dbo.PIECE(@RECORD, ',', 7)))
				SET @NEWINST = LTRIM(RTRIM(.dbo.PIECE(@RECORD, ',', 8)))

				SET @SQL = "INSERT INTO INST_LOG "
				SET @SQL = @SQL + "SELECT DISTINCT "
				SET @SQL = @SQL + "	'" + @PARTYCODE + "', "
				SET @SQL = @SQL + "	'" + @PARTYCODE + "', "
				SET @SQL = @SQL + "	CONVERT(DATETIME, '" + @SAUDADATE + "', 103), "
				SET @SQL = @SQL + "	'" + @SETTNO + "', "
				SET @SQL = @SQL + "	'" + @SETTTYPE + "', "
				SET @SQL = @SQL + "	'" + @SCRIPCODE + "', "
				SET @SQL = @SQL + "	'" + @SERIES + "', "
				SET @SQL = @SQL + "	ORDER_NO, "
--				SET @SQL = @SQL + "	'%', "
				SET @SQL = @SQL + "	'%', "
				SET @SQL = @SQL + "	" + CONVERT(VARCHAR(1), @SELLBUY) + ", "
				SET @SQL = @SQL + "	'" + @CONTRACTNO + "', "
				SET @SQL = @SQL + "	'" + @CONTRACTNO + "', "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	PARTIPANTCODE, "
				SET @SQL = @SQL + "	'" + @NEWINST + "', "
				SET @SQL = @SQL + "	'" + @STATUSNAME + "', "
				SET @SQL = @SQL + "	'" + @FROMWHERE + "', "
				SET @SQL = @SQL + "	'EDITPARTICIPANT', "
				SET @SQL = @SQL + "	GETDATE(), "
				SET @SQL = @SQL + "	'EDIT_PARTICIPANT', "
				SET @SQL = @SQL + "	'', "
				SET @SQL = @SQL + "	'' "
				SET @SQL = @SQL + "FROM " + @TABLE + " "
				SET @SQL = @SQL + "WHERE PARTY_CODE = '" + @PARTYCODE + "' "
				SET @SQL = @SQL + "AND SETT_NO = '" + @SETTNO + "' AND SETT_TYPE = '" + @SETTTYPE + "' "
				SET @SQL = @SQL + "AND SCRIP_CD = '" + @SCRIPCODE + "' AND SERIES = '" + @SERIES + "' "
				SET @SQL = @SQL + "AND SELL_BUY = " + LTRIM(RTRIM(CONVERT(VARCHAR(18), @SELLBUY))) + " "
				SET @SQL = @SQL + "AND CONVERT(VARCHAR(10), SAUDA_DATE, 103) = '" + @SAUDADATE + "' "
				SET @SQL = @SQL + "AND CONTRACTNO = '" + @CONTRACTNO + "' "
				EXEC (@SQL)
--				PRINT @SQL
				SET @SQL = "UPDATE " + @TABLE + " "
				SET @SQL = @SQL + "SET PARTIPANTCODE = '" + @NEWINST + "' "
				SET @SQL = @SQL + "WHERE PARTY_CODE = '" + @PARTYCODE + "' "
				SET @SQL = @SQL + "AND SETT_NO = '" + @SETTNO + "' AND SETT_TYPE = '" + @SETTTYPE + "' "
				SET @SQL = @SQL + "AND SCRIP_CD = '" + @SCRIPCODE + "' AND SERIES = '" + @SERIES + "' "
				SET @SQL = @SQL + "AND SELL_BUY = " + LTRIM(RTRIM(CONVERT(VARCHAR(18), @SELLBUY))) + " "
				SET @SQL = @SQL + "AND CONVERT(VARCHAR(10), SAUDA_DATE, 103) = '" + @SAUDADATE + "' "
				SET @SQL = @SQL + "AND CONTRACTNO = '" + @CONTRACTNO + "' "
				EXEC (@SQL)
--				PRINT @SQL
				SET @RECNO = @RECNO + 1
			END
	END
ELSE IF CONVERT(NUMERIC(4), @LEVEL) = 502
	BEGIN
		DECLARE
			@ORDERNO VARCHAR(16)
		SET @TABLE = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 1)))
		SET @SAUDADATE = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 2)))
		SET @CONTRACTNO = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 3)))
		SET @PARTYCODE = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 4)))
		SET @SCRIPCODE = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 5)))
		SET @SERIES = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 6)))
		SET @SETTNO = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 7)))
		SET @SETTTYPE = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 8)))
		SET @SELLBUY = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 9)))
		SET @RECNO = 1
		WHILE 1 = 1
			BEGIN
				SET @RECORD = .dbo.PIECE(@VARIABLEDATA, '|', @RECNO)
				IF @RECORD = '' OR @RECORD IS NULL
					BEGIN
						BREAK
					END
				SET @ORDERNO = LTRIM(RTRIM(.dbo.PIECE(@RECORD, ',', 1)))
				SET @NEWINST = LTRIM(RTRIM(.dbo.PIECE(@RECORD, ',', 2)))

				SET @SQL = "INSERT INTO INST_LOG "
				SET @SQL = @SQL + "SELECT DISTINCT "
				SET @SQL = @SQL + "	'" + @PARTYCODE + "', "
				SET @SQL = @SQL + "	'" + @PARTYCODE + "', "
				SET @SQL = @SQL + "	CONVERT(DATETIME, '" + @SAUDADATE + "', 103), "
				SET @SQL = @SQL + "	'" + @SETTNO + "', "
				SET @SQL = @SQL + "	'" + @SETTTYPE + "', "
				SET @SQL = @SQL + "	'" + @SCRIPCODE + "', "
				SET @SQL = @SQL + "	'" + @SERIES + "', "
				SET @SQL = @SQL + "	ORDER_NO, "
				SET @SQL = @SQL + "	'%', "
				SET @SQL = @SQL + "	" + CONVERT(VARCHAR(1), @SELLBUY) + ", "
				SET @SQL = @SQL + "	'" + @CONTRACTNO + "', "
				SET @SQL = @SQL + "	'" + @CONTRACTNO + "', "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	PARTIPANTCODE, "
				SET @SQL = @SQL + "	'" + @NEWINST + "', "
				SET @SQL = @SQL + "	'" + @STATUSNAME + "', "
				SET @SQL = @SQL + "	'" + @FROMWHERE + "', "
				SET @SQL = @SQL + "	'EDITPARTICIPANT', "
				SET @SQL = @SQL + "	GETDATE(), "
				SET @SQL = @SQL + "	'EDIT_PARTICIPANT', "
				SET @SQL = @SQL + "	'', "
				SET @SQL = @SQL + "	'' "
				SET @SQL = @SQL + "FROM " + @TABLE + " "
				SET @SQL = @SQL + "WHERE PARTY_CODE = '" + @PARTYCODE + "' "
				SET @SQL = @SQL + "AND SETT_NO = '" + @SETTNO + "' AND SETT_TYPE = '" + @SETTTYPE + "' "
				SET @SQL = @SQL + "AND SCRIP_CD = '" + @SCRIPCODE + "' AND SERIES = '" + @SERIES + "' "
				SET @SQL = @SQL + "AND SELL_BUY = " + LTRIM(RTRIM(CONVERT(VARCHAR(18), @SELLBUY))) + " "
				SET @SQL = @SQL + "AND CONVERT(VARCHAR(10), SAUDA_DATE, 103) = '" + @SAUDADATE + "' "
				SET @SQL = @SQL + "AND CONTRACTNO = '" + @CONTRACTNO + "' "
				SET @SQL = @SQL + "AND ORDER_NO = '" + @ORDERNO + "' "
				EXEC (@SQL)
--				PRINT @SQL
				SET @SQL = "UPDATE " + @TABLE + " "
				SET @SQL = @SQL + "SET PARTIPANTCODE = '" + @NEWINST + "' "
				SET @SQL = @SQL + "WHERE PARTY_CODE = '" + @PARTYCODE + "' "
				SET @SQL = @SQL + "AND SETT_NO = '" + @SETTNO + "' AND SETT_TYPE = '" + @SETTTYPE + "' "
				SET @SQL = @SQL + "AND SCRIP_CD = '" + @SCRIPCODE + "' AND SERIES = '" + @SERIES + "' "
				SET @SQL = @SQL + "AND SELL_BUY = " + LTRIM(RTRIM(CONVERT(VARCHAR(18), @SELLBUY))) + " "
				SET @SQL = @SQL + "AND CONVERT(VARCHAR(10), SAUDA_DATE, 103) = '" + @SAUDADATE + "' "
				SET @SQL = @SQL + "AND CONTRACTNO = '" + @CONTRACTNO + "' "
				SET @SQL = @SQL + "AND ORDER_NO = '" + @ORDERNO + "' "
				EXEC (@SQL)
--				PRINT @SQL
				SET @RECNO = @RECNO + 1
			END
	END
ELSE IF CONVERT(NUMERIC(4), @LEVEL) = 503
	BEGIN
		DECLARE
			@ORDERNO_NEW VARCHAR(16),
			@TRADENO VARCHAR(14)
		SET @TABLE = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 1)))
		SET @SAUDADATE = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 2)))
		SET @CONTRACTNO = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 3)))
		SET @PARTYCODE = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 4)))
		SET @SCRIPCODE = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 5)))
		SET @SERIES = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 6)))
		SET @SETTNO = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 7)))
		SET @SETTTYPE = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 8)))
		SET @SELLBUY = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 9)))
		SET @ORDERNO_NEW = LTRIM(RTRIM(.dbo.PIECE(@FIXEDDATA, ',', 10)))
		SET @RECNO = 1
		WHILE 1 = 1
			BEGIN
				SET @RECORD = .dbo.PIECE(@VARIABLEDATA, '|', @RECNO)
				IF @RECORD = '' OR @RECORD IS NULL
					BEGIN
						BREAK
					END
				SET @TRADENO = LTRIM(RTRIM(.dbo.PIECE(@RECORD, ',', 1)))
				SET @NEWINST = LTRIM(RTRIM(.dbo.PIECE(@RECORD, ',', 2)))

				SET @SQL = "INSERT INTO INST_LOG "
				SET @SQL = @SQL + "SELECT DISTINCT "
				SET @SQL = @SQL + "	'" + @PARTYCODE + "', "
				SET @SQL = @SQL + "	'" + @PARTYCODE + "', "
				SET @SQL = @SQL + "	CONVERT(DATETIME, '" + @SAUDADATE + "', 103), "
				SET @SQL = @SQL + "	'" + @SETTNO + "', "
				SET @SQL = @SQL + "	'" + @SETTTYPE + "', "
				SET @SQL = @SQL + "	'" + @SCRIPCODE + "', "
				SET @SQL = @SQL + "	'" + @SERIES + "', "
				SET @SQL = @SQL + "	ORDER_NO, "
				SET @SQL = @SQL + "	TRADE_NO, "
				SET @SQL = @SQL + "	" + CONVERT(VARCHAR(1), @SELLBUY) + ", "
				SET @SQL = @SQL + "	'" + @CONTRACTNO + "', "
				SET @SQL = @SQL + "	'" + @CONTRACTNO + "', "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	0, "
				SET @SQL = @SQL + "	PARTIPANTCODE, "
				SET @SQL = @SQL + "	'" + @NEWINST + "', "
				SET @SQL = @SQL + "	'" + @STATUSNAME + "', "
				SET @SQL = @SQL + "	'" + @FROMWHERE + "', "
				SET @SQL = @SQL + "	'EDITPARTICIPANT', "
				SET @SQL = @SQL + "	GETDATE(), "
				SET @SQL = @SQL + "	'EDIT_PARTICIPANT', "
				SET @SQL = @SQL + "	'', "
				SET @SQL = @SQL + "	'' "
				SET @SQL = @SQL + "FROM " + @TABLE + " "
				SET @SQL = @SQL + "WHERE PARTY_CODE = '" + @PARTYCODE + "' "
				SET @SQL = @SQL + "AND SETT_NO = '" + @SETTNO + "' AND SETT_TYPE = '" + @SETTTYPE + "' "
				SET @SQL = @SQL + "AND SCRIP_CD = '" + @SCRIPCODE + "' AND SERIES = '" + @SERIES + "' "
				SET @SQL = @SQL + "AND SELL_BUY = " + LTRIM(RTRIM(CONVERT(VARCHAR(18), @SELLBUY))) + " "
				SET @SQL = @SQL + "AND CONVERT(VARCHAR(10), SAUDA_DATE, 103) = '" + @SAUDADATE + "' "
				SET @SQL = @SQL + "AND CONTRACTNO = '" + @CONTRACTNO + "' "
				SET @SQL = @SQL + "AND ORDER_NO = '" + @ORDERNO_NEW + "' "
				SET @SQL = @SQL + "AND TRADE_NO = '" + @TRADENO + "' "
				EXEC (@SQL)
--				PRINT @SQL
				SET @SQL = "UPDATE " + @TABLE + " "
				SET @SQL = @SQL + "SET PARTIPANTCODE = '" + @NEWINST + "' "
				SET @SQL = @SQL + "WHERE PARTY_CODE = '" + @PARTYCODE + "' "
				SET @SQL = @SQL + "AND SETT_NO = '" + @SETTNO + "' AND SETT_TYPE = '" + @SETTTYPE + "' "
				SET @SQL = @SQL + "AND SCRIP_CD = '" + @SCRIPCODE + "' AND SERIES = '" + @SERIES + "' "
				SET @SQL = @SQL + "AND SELL_BUY = " + LTRIM(RTRIM(CONVERT(VARCHAR(18), @SELLBUY))) + " "
				SET @SQL = @SQL + "AND CONVERT(VARCHAR(10), SAUDA_DATE, 103) = '" + @SAUDADATE + "' "
				SET @SQL = @SQL + "AND CONTRACTNO = '" + @CONTRACTNO + "' "
				SET @SQL = @SQL + "AND ORDER_NO = '" + @ORDERNO_NEW + "' "
				SET @SQL = @SQL + "AND TRADE_NO = '" + @TRADENO + "' "
				EXEC (@SQL)
--				PRINT @SQL
				SET @RECNO = @RECNO + 1
			END
	END

GO
