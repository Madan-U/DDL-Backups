-- Object: PROCEDURE dbo.Angel_KYC_TRACK
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure [dbo].[Angel_KYC_TRACK]          
as           
set nocount on          
set transaction isolation level read uncommitted          
  
declare @str as varchar(500),@stdt as varchar(500)          
--set @stdt = 'Feb 01 2007'  
  
set @stdt = convert(varchar,getdate()-1,112)          
set @str= 'V2_OFFLINE_CLIENTMASTER '''+@stdt+''',''I'','''','''',''All'',''All'''          
--print @str           
          
truncate table ang_temp_track          
-- exec(@str)          
insert into ang_temp_track exec(@str)         
        
insert into ABVSKYCMIS.kyc.dbo.tbl_track select * from ang_temp_track        
        
insert into ABVSKYCMIS.kyc.dbo.bse_kyc select cl_code,Long_name,'','','','','','','','','','','','',convert(varchar(11),getdate()-1,111) from ang_temp_track where bse = 'NEW'        
insert into ABVSKYCMIS.kyc.dbo.nse_kyc select cl_code,Long_name,'','','','','','','','','','','','',convert(varchar(11),getdate()-1,111) from ang_temp_track where nse = 'NEW'        
insert into ABVSKYCMIS.kyc.dbo.nsefo_kyc select cl_code,Long_name,'','','','','','','','','','','','',convert(varchar(11),getdate()-1,111) from ang_temp_track where fo = 'NEW'        
insert into ABVSKYCMIS.kyc.dbo.mcdx_kyc select cl_code,Long_name,'','','','','','','','','','','','',convert(varchar(11),getdate()-1,111) from ang_temp_track where mcx = 'NEW'        
insert into ABVSKYCMIS.kyc.dbo.ncdx_kyc select cl_code,Long_name,'','','','','','','','','','','','',convert(varchar(11),getdate()-1,111) from ang_temp_track where ncdx = 'NEW'        
        
truncate  table angel_kyc_track_update        
        
insert into angel_kyc_track_update values (getdate())        
        
set nocount off

GO
