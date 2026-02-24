-- Object: PROCEDURE dbo.CBO_GETExcessSharePayout
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--Select top 50 * from DelTrans where RefNo = '110' and Sett_No = '2004046' and Sett_Type = 'N' and Party_Code = '0a141' and Scrip_CD like '%' and Series like '%'  and Drcr = 'D' And Filler2 = 1



CREATE   PROCEDURE CBO_GETExcessSharePayout
(
   @SET VARCHAR(10),
	@SETTNO VARCHAR(80),
   @SETTYPE VARCHAR(20),
   @PARTYCODE VARCHAR(20),
   @SCRIP VARCHAR(20),
   @SERIES VARCHAR(20),
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
DECLARE
		@Result VARCHAR(10),
		@SQL VARCHAR(200)
BEGIN
SELECT TOP 50  * FROM DELTRANS  WHERE  RefNo = '110' and Sett_No = '2004046' and Sett_Type = 'N' and Party_Code = '0a141' and Scrip_CD like '%' and Series like '%' and Drcr = 'D' And Filler2 = 1

END

GO
