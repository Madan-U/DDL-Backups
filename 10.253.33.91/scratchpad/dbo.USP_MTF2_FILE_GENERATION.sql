-- Object: PROCEDURE dbo.USP_MTF2_FILE_GENERATION
-- Server: 10.253.33.91 | DB: scratchpad
--------------------------------------------------


CREATE PROCEDURE [dbo].[USP_MTF2_FILE_GENERATION]
(@SAUDA_DATE DATETIME)

AS

DECLARE @COUNT int, @count1 int, @count2 int,@count3 int, @count4 int,@count5 int, @count6 int,@count7 int,@count8 int

select @COUNT= count(1) from Mtftrade.dbo.TBL_PRODUCT_HOLD_DATA where sauda_date =@SAUDA_DATE and holdflag='MTFCOLL'

IF (@COUNT>20000)

BEGIN

Exec MIMANSA.CLIENTSERVICE.DBO.FillMTFReportingBaseBBG  'A','ZZZZZZZZ',@SAUDA_DATE,@SAUDA_DATE

Update MIMANSA.CLIENTSERVICE.DBO.MTFReportingBase Set BodValue = MtfExchangeDataV1.EodValue  From MIMANSA.CLIENTSERVICE.DBO.MtfExchangeDataV1 Where MtfExchangeDataV1.party_code = MTFReportingBase.Party_code and MtfExchangeDataV1.Scrip_Cd =MTFReportingBase.Scrip_Cd and MtfExchangeDataV1.Series = MTFReportingBase.Series

Update MIMANSA.CLIENTSERVICE.DBO.MTFReportingBase Set DayBuyValue = MTFReportingBase.DayBuyValue + MtfExchangeDataV1.ClientAmount from MIMANSA.CLIENTSERVICE.DBO.MtfExchangeDataV1
Where MtfExchangeDataV1.party_code = MTFReportingBase.Party_code
and MtfExchangeDataV1.Scrip_Cd = MTFReportingBase.Scrip_Cd
and MtfExchangeDataV1.Series = MTFReportingBase.Series

Update MIMANSA.CLIENTSERVICE.DBO.MTFReportingBase Set EodValue = BodValue + Daybuyvalue - Daysellvalue

Exec MIMANSA.CLIENTSERVICE.DBO.ProcessMTF

 EXEC ('DROP TABLE CLIENTSERVICE..MtfExchangeDataV1') AT MIMANSA
  EXEC ('DROP TABLE CLIENTSERVICE..MTFReportingBaseV1') AT MIMANSA
--Drop table MIMANSA.CLIENTSERVICE..MtfExchangeDataV1
--Drop table MIMANSA.CLIENTSERVICE..MTFReportingBaseV1


--Select * into MIMANSA.CLIENTSERVICE..MtfExchangeDataV1 from MIMANSA.CLIENTSERVICE..MtfExchangeData

--Select * into MIMANSA.CLIENTSERVICE.DBO.MTFReportingBaseV1 from MIMANSA.CLIENTSERVICE.DBO.MTFReportingBase

Update MIMANSA.CLIENTSERVICE.DBO.MtfExchangeDataV1 Set Daysellvalue = DaySellValue + ClientAmount
Update MIMANSA.CLIENTSERVICE.DBO.MtfExchangeDataV1 Set EodValue = BodValue + DayBuyValue - Daysellvalue


select @count1=COUNT(1)  from MIMANSA.CLIENTSERVICE.DBO.MtfExchangeDataV1  where EODvalue < 0 and EODQty = 0 
select @count2=COUNT(1)  from MIMANSA.CLIENTSERVICE.DBO.MtfExchangeDataV1  where EODvalue > 0 and EODQty = 0


IF (@count1!=0 OR @count2!=0)

BEGIN

select * into #rcsmis from MIMANSA.CLIENTSERVICE.DBO.MtfExchangeDataV1  where EODvalue <> 0 and EODQty = 0

select party_code,Scrip_Cd,daysellvalue_1=DaySellValue+EodValue into #rcsa from #rcsmis order by daysellvalue_1 desc
 
update A
set a.DaySellValue = b.daysellvalue_1,a.EodValue=0
from MIMANSA.CLIENTSERVICE.DBO.MtfExchangeDataV1 a, #rcsa b
where a.party_code=b.party_code
and a.scrip_cd=b.scrip_cd

END


select @count3=count(1) from MIMANSA.CLIENTSERVICE.DBO.MtfExchangeDataV1  where DaySellValue < 0---1  
select @count4=count(1)from MIMANSA.CLIENTSERVICE.DBO.MtfExchangeDataV1  where DayBuyValue < 0---1
select @count5=count(1) from MIMANSA.CLIENTSERVICE.DBO.MtfExchangeDataV1  where BodValue < 0---0
select @count6 =count(1) from MIMANSA.CLIENTSERVICE.DBO.MtfExchangeDataV1  where BodValue > 0 and bodqty =0---0
select @count7 =count(1) from MIMANSA.CLIENTSERVICE.DBO.MtfExchangeDataV1  where ClientAmount <0


IF (@count3=0 AND @count4=0 AND @count5=0 AND @count6=0  AND @count7=0  )

BEGIN

DELETE FROM MIMANSA.CLIENTSERVICE.DBO.MtfExchangeFileData where reportingdate=@SAUDA_DATE

Insert into MIMANSA.CLIENTSERVICE.DBO.MtfExchangeFileData 
Select * from MIMANSA.CLIENTSERVICE.DBO.MtfExchangeDataV1

IF OBJECT_ID(N'SCRATCHPAD..MTF_FILE_GENERATION') IS NOT NULL
DROP TABLE MTF_FILE_GENERATION

SELECT * INTO MTF_FILE_GENERATION from  MIMANSA.CLIENTSERVICE.DBO.MtfExchangeFileData with(nolock)  where reportingdate =@SAUDA_DATE

select  @count8=COUNT(1) from MIMANSA.CLIENTSERVICE.DBO.MtfExchangeFileData where reportingdate =@SAUDA_DATE

DECLARE @FILENAME VARCHAR(100) = 'J:\Backoffice\VAIBHAV\' +'MTF_27022025' + '.CSV'        
DECLARE @ALL VARCHAR(MAX)                  
                  
SET @all = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''Srn'''',''''NextDate'''',''''NextCash'''',''''ReportingDate'''',''''Party_code'''',''''ExchangeSegment'''',''''Scrip_Cd'''',''''SERIES'''',''''BODQty'''',''''BodValue'''',''''DayBuyQty'''',''''DayBuyValue'''',''''DaySellQty'''',''''DaySellValue'''',''''EodQty'''',''''EodValue'''',''''EodAdjustValue'''',''''EodCashCollateralDiff'''',''''AdjBuyCash'''',''''AdjSellCash'''',''''ADJCashCollateral'''',''''MtFLedgerBalance'''',''''YesterdayCashCollateral'''',''''CashCollateral'''',''''PleadgedFlag'''',''''ClientAmount'''''
SET @all = @all+ ' UNION ALL SELECT Convert(varchar(max),Srn),Convert(varchar(max),NextDate),Convert(varchar(max),NextCash),Convert(varchar(max),ReportingDate),Party_code,ExchangeSegment,Scrip_Cd,SERIES,Convert(varchar(max),BODQty),Convert(varchar(max),BodValue),Convert(varchar(max),DayBuyQty),Convert(varchar(max),DayBuyValue),Convert(varchar(max),DaySellQty),Convert(varchar(max),DaySellValue),Convert(varchar(max),EodQty),Convert(varchar(max),EodValue),Convert(varchar(max),EodAdjustValue),Convert(varchar(max),EodCashCollateralDiff),Convert(varchar(max),AdjBuyCash),Convert(varchar(max),AdjSellCash),Convert(varchar(max),ADJCashCollateral),Convert(varchar(max),MtFLedgerBalance),Convert(varchar(max),YesterdayCashCollateral),Convert(varchar(max),CashCollateral),PleadgedFlag,Convert(varchar(max),ClientAmount) FROM SCRATCHPAD.DBO.MTF_FILE_GENERATION'                
            
set @all=@all+' " queryout ' +@filename+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'
                 
EXEC(@all)    

DROP TABLE MTF_FILE_GENERATION

SELECT 'MTF FILE FOR ' + CONVERT (Varchar(11),@SAUDA_DATE) + ' IS EXPORTED TO ' + @FILENAME + ' AND TOTAL COUNT is '+ CONVERT(VARCHAR(MAX),@count8) AS 'REMARK'

END


ELSE
BEGIN

SELECT 'MTF FILE GENERATION PROCESS IS NOT COMPLETED..KINDLY CONTACT WITH BO TEAM'

END

END

ELSE

BEGIN
SELECT 'MTF PROCESS COUNT IS LESS THAN EXPECTED LIMIT..KINDLY CONTACT WITH BO TEAM'
END

GO
