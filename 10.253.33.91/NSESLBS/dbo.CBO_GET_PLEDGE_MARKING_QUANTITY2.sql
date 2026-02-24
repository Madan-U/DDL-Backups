-- Object: PROCEDURE dbo.CBO_GET_PLEDGE_MARKING_QUANTITY2
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
--EXECUTE CBO_GET_PLEDGE_MARKING_QUANTITY2 'I','12034400','1203440000006324','500013','BSE','0A141','BROKER','BROKER'

CREATE     PROCEDURE [dbo].[CBO_GET_PLEDGE_MARKING_QUANTITY2]
	    @FLAG   VARCHAR(1),
        @DPID VARCHAR(10),
        @CLTDPID VARCHAR(30),
        @SCRIPCODE VARCHAR(10),
        @SERIES VARCHAR(10),
        @PARTYCODE  VARCHAR(10),
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
	
        
	
        ELSE IF @FLAG = 'I'
			BEGIN
                     SET @SQL="select Isnull(Sum(Qty),0)AS Quantity from bsedb.dbo.DelTrans D With(Index(DelHold), NoLock) Where Party_Code ='"+@PARTYCODE+"' And Scrip_Cd = '"+@SCRIPCODE+"' And Series = '"+@SERIES+"' And Delivered = '0' And  DrCr = 'D' And Filler2 = '1' And BDpId = '"+@DPID+"' And BCltDpId = '"+@CLTDPID+"' "
                      EXEC(@SQL)
                                -- select Isnull(Sum(Qty),0)AS Quantity from bsedb.dbo.DelTrans D With(Index(DelHold), NoLock) Where Party_Code Like '0a141' And Scrip_Cd = '500013' And Series = 'BSE' And Delivered = '0' And  DrCr = 'D' And Filler2 = '1' And BDpId = '12034400' And BCltDpId = '1203440000006324'
				          -- SET @SQL="select Isnull(Sum(Qty),0)AS Quantity from bsedb.dbo.DelTrans D With(Index(DelHold), NoLock) Where Party_Code ='"+@PARTYCODE+"' And Scrip_Cd = '"+@SCRIPCODE+"' And Series = '"+@SERIES+"' And Delivered = '0' And  DrCr = 'D' And Filler2 = '1' And BDpId = '"+@DPID+"' And BCltDpId = '"+@CLTDPID+"'" 
	                      --  EXEC(@SQL)
			END


--SET @SQL = "UPDATE " + @AccountServer + "." + @AccountDB + ".DBO.MultiBankId  "
--  SET @SQL = @SQL + "SET DEFAULTBANK='0' "
-- SET @SQL = @SQL + "WHERE CLTCODE = '" +  @SQLVAR1  + "'AND ACCNO='" + @SQLVAR5  + "'"
--select Isnull(Sum(Qty),0)AS PRADIP from bsedb.dbo.DelTrans D With(Index(DelHold), NoLock) Where Party_Code Like '0a141' And Scrip_Cd = '500013' And Series = 'BSE' And Delivered = '0' And  DrCr = 'D' And Filler2 = '1' And BDpId = '12034400' And BCltDpId = '1203440000006324'

GO
