-- Object: PROCEDURE dbo.CBO_CHECK_SETTOHIS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





CREATE  PROCEDURE CBO_CHECK_SETTOHIS
(
     
@SETNOFROM VARCHAR(25),
@SETNOTO VARCHAR(25),
@TYPE VARCHAR(10),   
@Datain VARCHAR(10)='' OUTPUT,
@SettToHistory VARCHAR(10)= '0' OUTPUT,
@ISettRec VARCHAR(10) = 'False' OUTPUT,
@IHistRec VARCHAR(10)= 'False' OUTPUT,
@SettNoRec INT OUTPUT,
@HistNoRec INT OUTPUT
)
AS
DECLARE @CNT INT

	Select @SettNoRec=IsNull(Count(*),0) from settlement where sett_no >= @SETNOFROM and sett_no <= @SETNOTO and sett_type = @TYPE
	IF @SettNoRec > 0
	BEGIN
	SET @SettToHistory='1'
  	SET @Datain ='SETT'
	END

	Select @HistNoRec=IsNull(Count(*),0) from History  where sett_no >= @SETNOFROM and sett_no <= @SETNOTO and sett_type = @TYPE
	IF @HistNoRec > 0
	BEGIN
	SET @SettToHistory='2'
  	SET @Datain ='HIST'
	END 

	Select @CNT=IsNull(Count(*),0) from isettlement  where sett_no >= @SETNOFROM and sett_no <= @SETNOTO and sett_type = @TYPE
	IF @CNT > 0
	BEGIN
	SET @ISettRec ='True'
	END 
	ELSE
	BEGIN
	SET @ISettRec ='False'
	END

	Select @CNT=IsNull(Count(*),0) from iHistory   where sett_no >= @SETNOFROM and sett_no <= @SETNOTO and sett_type = @TYPE
	IF @CNT > 0
	BEGIN
	SET @IHistRec ='True'
	END 
	ELSE
	BEGIN
	SET @IHistRec ='False'
	END

GO
