-- Object: PROCEDURE dbo.CBO_GET_PARA_DIRECTPAYIN
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------











CREATE  PROCEDURE [dbo].[CBO_GET_PARA_DIRECTPAYIN]
(
	
 	@SETTNO VARCHAR(20)='',
	@Flag  Varchar(10)
)
AS
 
declare
@dpid varchar(25),
	@partyCode varchar(25)


		IF @Flag='SettNo'
		BEGIN
		select distinct sett_no from  deliveryclt  order by sett_no
		END
		if @Flag='SettType'
		BEGIN
		select distinct sett_type from  deliveryclt  where sett_no = @SETTNO order by sett_type
		END
		if @Flag='DpId'
		BEGIN
		select dpid from multicltid where party_code = @SETTNO
		END	
		if @Flag='ClDpNo'
		BEGIN
		SET @dpid = LTRIM(RTRIM(.dbo.PIECE(@SETTNO, '|', 2)))
		SET @partyCode = LTRIM(RTRIM(.dbo.PIECE(@SETTNO, '|', 1)))

		select CltDpNo from multicltid where party_code = @partyCode and dpid = @dpid
		END

GO
