-- Object: PROCEDURE dbo.ClientDetailsTrigTbl_Cleanup
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------


CREATE Procedure [dbo].[ClientDetailsTrigTbl_Cleanup]
as
set nocount on

declare @lastdate as datetime
select @lastdate=min(batchtaskstartTime) from
(select top 2 * from [CSOKYC-6].general.dbo.Rms_SSISBatchTaskJob_log where batchid=1 and batchtaskid=3 and batchTaskStatus='Y' order by batchtaskstartTime desc) x
--print @lastdate

delete from msajag.dbo.client_brok_details_trig where updateDate < @lastdate

delete from msajag.dbo.client_details_trig where updateDate < @lastdate

set nocount off

GO
