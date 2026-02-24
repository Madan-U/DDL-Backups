-- Object: PROCEDURE dbo.Intraday_loss
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE  proc [dbo].[Intraday_loss]
as

select top 2 Start_date into #stdate from sett_mst 
where start_date <=convert(varchar(11),getdate(),120) and sett_type ='N'
order by Start_date  desc

select sett_no into #sett from sett_mst where Start_date in (select * from #stdate)
and sett_type='N'

select sett_no into #bsett from AngelBSECM.bsedb_ab.dbo.sett_mst where Start_date in (select * from #stdate)
and sett_type='D'

select party_code,sum(loss) as loss,Exchange from (
select party_code,sum(pamttrd-samttrd) loss,'NSE' as exchange from cmbillvalan where sett_no in (select * from #sett)
group by party_code
having sum(pamttrd-samttrd) >0
union all
select party_code,sum(pamttrd-samttrd),'BSE' as exchange from AngelBSECM.bsedb_ab.dbo.cmbillvalan where sett_no in (select * from #bsett)
group by party_code
having sum(pamttrd-samttrd) >0 )a 
group by party_code,Exchange

GO
