-- Object: PROCEDURE dbo.RPT_CLIENTMARGINREPORT_ALL
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






CREATE  PROC RPT_CLIENTMARGINREPORT_ALL
 (  
 @MDATE VARCHAR(11),  
 @FROMBRANCH VARCHAR(15),  
 @TOBRANCH VARCHAR(15),  
 @FROMPARTY VARCHAR(15),
 @TOPARTY VARCHAR(15),  
 @STATUSID VARCHAR(15),  
 @STATUSNAME VARCHAR(25),
 @FROMSUBBROKER VARCHAR(15) = '',
 @TOSUBBROKER VARCHAR(15) = 'zzzzzzzz'
 )  
   
 AS 

if @TOPARTY ='' begin set @TOPARTY = 'zzzzzzzz' end
if @TOBRANCH ='' begin set @TOBRANCH = 'zzzzzzzz' end
if @TOSUBBROKER ='' begin set @TOSUBBROKER = 'zzzzzzzz' end
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

CREATE TABLE #MARGINDETAILS
(
	EXCHANGE  varchar(10),
	SEGMENT  varchar(12),
	MDT_FD Money,
	MDT_BG Money,
	MDT_SEC Money,
	MDT_CASH Money,
	MDT_TOTAL Money,
	MAR_UTILISED Money,
	MDT1_FD Money,
	MDT1_BG Money,
	MDT1_SEC Money,
	MDT1_CASH Money,
	MDT1_TOTAL Money,
	MAR_ADJUSTMENT Money,
	MAR_STATUS Money,
	PARTY_CODE varchar(10),
	LONG_NAME varchar(100),
	L_ADDRESS1  varchar(100),
	L_ADDRESS2  varchar(100),
	L_ADDRESS3  varchar(100),
	L_CITY  varchar(50),
	L_ZIP  varchar(10),
	L_STATE  varchar(100),
	L_NATION  varchar(50),
	EMAIL  varchar(100),
	PAN_GIR_NO  varchar(20),
	BRANCH_CD  varchar(10),
	SUB_BROKER  varchar(10)
)

CREATE TABLE #COMPANYDETAILS
(
	COMPANY VARCHAR(50) NULL,
	ADDR1 VARCHAR(100) NULL,
	ADDR2 VARCHAR(100) NULL,
	CITY VARCHAR(20) NULL,
	ZIP VARCHAR(10) NULL,
	PHONE VARCHAR(25) NULL,
	ExchangeSeg VARCHAR(12) NULL
)

Declare @strSQl varchar(2000)
Declare @strSQl1 varchar(2000)
Declare @servername varchar(50)
Declare @dbname varchar(50)
Declare @ExchangeSeg varchar(10)
Declare @MultiServer cursor

Set @MultiServer = Cursor For 
				Select ShareDb,ShareServer,
				Exchange=ltrim(rtrim(upper(Exchange)))+ltrim(rtrim(upper(Segment)))
				From Pradnya.dbo.MultiCompany 
				Where Exchange in ('NSE','BSE') AND PrimaryServer=1
Open @MultiServer
Fetch From @MultiServer into @dbname,@servername,@ExchangeSeg
while @@Fetch_status =0
begin
	if (@ExchangeSeg='NSECAPITAL') OR (@ExchangeSeg='BSECAPITAL') OR (@ExchangeSeg='NSEFUTURES')
	begin
		Set @strSQL = "EXEC " + @servername + "." + @dbname + ".dbo.RPT_CLIENTMARGINREPORT '" 
		Set @strSQl = @strSql +  @MDATE + "','"
		Set @strSQl = @strSql +  @FROMBRANCH + "','"
		Set @strSQl = @strSql +  @TOBRANCH + "','"
		Set @strSQl = @strSql +  @FROMPARTY + "','"
		Set @strSQl = @strSql +  @TOPARTY + "','"
		Set @strSQl = @strSql +  @STATUSID + "','"
		Set @strSQl = @strSql +  @STATUSNAME + "','"
		Set @strSQl = @strSql +  @FROMSUBBROKER + "','"
		Set @strSQl = @strSql +  @TOSUBBROKER + "'"
		
		IF (@ExchangeSeg='NSEFUTURES')
		BEGIN
			SET @strSQl1 = "SELECT COMPANY,ADDR1,ADDR2,CITY,ZIP,PHONE, ExchangeSeg='" + @ExchangeSeg +"' FROM " + @servername + "." + @dbname + ".dbo.FOOWNER"
		END
		ELSE
			SET @strSQl1 = "SELECT COMPANY,ADDR1,ADDR2,CITY,ZIP,PHONE, ExchangeSeg='" + @ExchangeSeg +"' FROM " + @servername + "." + @dbname + ".dbo.OWNER"
		
		INSERT INTO #MARGINDETAILS 
		EXEC (@strSQl)
		INSERT INTO #COMPANYDETAILS
		EXEC (@strSQl1)
	end
	Fetch From @MultiServer into @dbname,@servername,@ExchangeSeg
end
Close @MultiServer
DeAllocate @MultiServer

/*
ALTER TABLE #MARGINDETAILS
ADD COMPANY VARCHAR(50) DEFAULT ('')
ALTER TABLE #MARGINDETAILS
ADD ADDR1 VARCHAR(100) DEFAULT ('')
ALTER TABLE #MARGINDETAILS
ADD ADDR2 VARCHAR(100) DEFAULT ('')
ALTER TABLE #MARGINDETAILS
ADD CITY VARCHAR(20) DEFAULT ('')
ALTER TABLE #MARGINDETAILS
ADD ZIP VARCHAR(10) DEFAULT ('')
ALTER TABLE #MARGINDETAILS
ADD PHONE VARCHAR(25) DEFAULT ('')

UPDATE #MARGINDETAILS 
	SET 
	COMPANY = C.COMPANY, 
	ADDR1 = C.ADDR1,
	ADDR2 = C.ADDR2,
	CITY  = C.CITY,
	ZIP   = C.ZIP,	
	PHONE = C.PHONE
FROM #COMPANYDETAILS C
WHERE ExchangeSeg = (EXCHANGE+SEGMENT)*/


SELECT * FROM #MARGINDETAILS, #COMPANYDETAILS C WHERE ExchangeSeg = (EXCHANGE+SEGMENT)
ORDER BY Branch_Cd,Sub_Broker,Party_Code,Exchange,Segment

DROP TABLE #MARGINDETAILS
DROP TABLE #COMPANYDETAILS


SET QUOTED_IDENTIFIER OFF

GO
