-- Object: PROCEDURE dbo.CBO_GETDPTYPELIST
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

















--Select Distinct DpCltNo From DeliveryDp
--@Account_server + "." +@Account_db + ".dbo.multicompany	
--Select BseCode From bsedb.dbo.Scrip2 Where BSECODE >= '500000' And Len(BSECODE) = 6 
--Select Distinct Scrip_Cd From Scrip2
--select * from Scrip2
--Select Distinct DpCltNo From DeliveryDp Where DpId = '11000011'
--Select Distinct DpId From DeliveryDp
--Select Distinct DpCltNo From DeliveryDp Where DpId = ''



 --Select Distinct Scrip_Cd From Scrip2 
--If RefNo = 110 Then
  --Select Distinct Scrip_Cd From Scrip2
--Else
   -- Select BseCode From Scrip2 Where BSECODE >= '500000' And Len(BSECODE) = 6 
--End If
--EXEC CBO_GETDPTYPELIST 'T','NSDL','BROKER','BROKER'
CREATE   PROCEDURE [dbo].[CBO_GETDPTYPELIST]
	     @FLAG   VARCHAR(1),
        @DPTYPE VARCHAR(10),
        @CLPTDPNO VARCHAR(10),
        @STATUSID VARCHAR(25) = 'BROKER',
	     @STATUSNAME VARCHAR(25) = 'BROKER'
AS
DECLARE
	@SQL Varchar(2000)
		
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	IF @FLAG <> 'N' AND @FLAG <> 'T' AND @FLAG <> 'S' AND @FLAG <> 'P'AND @FLAG <> 'I'
		BEGIN
			RAISERROR ('Add/Edit Flags Not Set Properly', 16, 1)
			RETURN
		END
        
	IF @FLAG = 'N'
		BEGIN
			Select Distinct DpId From DeliveryDp
		END

	ELSE IF @FLAG = 'T'
	             BEGIN
	                  SET @SQL="Select Distinct DpId from MultiCltId WHERE DPID IS NOT NULL And CltDpNo = '"+@CLPTDPNO+"' And DpType = '"+@DPTYPE+"' "
	                   EXEC(@SQL)
	              END
        
  ELSE IF @FLAG = 'S'
	             BEGIN
	                  SET @SQL="Select Distinct CltDpNo from MultiCltId WHERE CLTDPNO IS NOT NULL And DpType = '"+@DPTYPE+"' "
	                   EXEC(@SQL)
	              END

--select Isnull(Sum(Qty),0)AS PRADIP from bsedb.dbo.DelTrans D With(Index(DelHold), NoLock) Where Party_Code Like '0a141' And Scrip_Cd = '500013' And Series = 'BSE' And Delivered = '0' And  DrCr = 'D' And Filler2 = '1' And BDpId = '12034400' And BCltDpId = '1203440000006324'

GO
