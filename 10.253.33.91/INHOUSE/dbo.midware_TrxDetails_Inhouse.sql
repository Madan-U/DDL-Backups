-- Object: PROCEDURE dbo.midware_TrxDetails_Inhouse
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE procedure midware_TrxDetails_Inhouse    
as    
set nocount on              
    
declare @sdate as varchar(11)    
select top 1 @sdate=convert(varchar(13),sauda_DAte) from MSAJAG.dbo.settlement with (nolock)  
--print @sdate    
    
truncate table inhouse.dbo.settlement   
insert into inhouse.dbo.settlement   
select * from MSAJAG.dbo.settlement with (nolock) where sauda_date >= @sdate+' 00:00:00' and  sauda_date <= @sdate+' 23:59:59'     
    
truncate table inhouse.dbo.isettlement   
insert into inhouse.dbo.isettlement   
select * from MSAJAG.dbo.isettlement with (nolock) where sauda_date >= @sdate+' 00:00:00' and  sauda_date <= @sdate+' 23:59:59'     

truncate table inhouse.dbo.CMBILLVALAN  
insert into inhouse.dbo.CMBILLVALAN    
select * from MSAJAG.dbo.CMBILLVALAN with (nolock) where sauda_date >= @sdate+' 00:00:00' and  sauda_date <= @sdate+' 23:59:59'     
    
set nocount off

GO
