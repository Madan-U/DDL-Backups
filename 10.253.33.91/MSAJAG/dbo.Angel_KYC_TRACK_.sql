-- Object: PROCEDURE dbo.Angel_KYC_TRACK_
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure [dbo].[Angel_KYC_TRACK_](@stdt as varchar(50))                      
as          
                       
set nocount on                      
set transaction isolation level read uncommitted                      
--         
-- declare @stdt as varchar(100)        
-- set @stdt = '13/02/2007'        
    
declare @str as varchar(100)            
declare @fdate as varchar(50)        
set @fdate = convert(datetime,@stdt,103)        
     
set @stdt =  convert(varchar(8),convert(datetime,@stdt,103),112)            
set @str= 'ANGEL_CLIENTMASTER '''+@stdt+''',''I'','''','''',''All'',''All'''                      
                   
truncate table ang_temp_track                      
          
insert into ang_temp_track exec(@str)                     
                    
--insert into ABVSKYCMIS.kyc.dbo.tbl_track select * from ang_temp_track                    
                    
insert into ABVSKYCMIS.kyc.dbo.bse_kyc select cl_code,Long_name,'','','','','','','','','','','','',@fdate from ang_temp_track where bse = 'NEW' and cl_code not in (select cl_code from ABVSKYCMIS.kyc.dbo.bse_kyc)                   
insert into ABVSKYCMIS.kyc.dbo.nse_kyc select cl_code,Long_name,'','','','','','','','','','','','',@fdate from ang_temp_track where nse = 'NEW' and cl_code not in (select cl_code from ABVSKYCMIS.kyc.dbo.nse_kyc)                              
insert into ABVSKYCMIS.kyc.dbo.nsefo_kyc select cl_code,Long_name,'','','','','','','','','','','','',@fdate from ang_temp_track where fo = 'NEW' and cl_code not in (select cl_code from ABVSKYCMIS.kyc.dbo.nsefo_kyc)                              
insert into ABVSKYCMIS.kyc.dbo.mcdx_kyc select cl_code,Long_name,'','','','','','','','','','','','',@fdate from ang_temp_track where mcx = 'NEW' and cl_code not in (select cl_code from ABVSKYCMIS.kyc.dbo.mcdx_kyc)                              
insert into ABVSKYCMIS.kyc.dbo.ncdx_kyc select cl_code,Long_name,'','','','','','','','','','','','',@fdate from ang_temp_track where ncdx = 'NEW' and cl_code not in (select cl_code from ABVSKYCMIS.kyc.dbo.ncdx_kyc)                              
                    
-- truncate  table angel_kyc_track_update                --                     
-- insert into angel_kyc_track_update values (getdate())                    
      
declare @bse as varchar(20)      
declare @nse as varchar(20)      
declare @nsefo as varchar(20)       
declare @mcdx as varchar(20)       
declare @ncdx as varchar(20)       
declare @total as varchar(20)      
      
select @bse = count(*) from  ang_temp_track where bse = 'NEW' and cl_code in (select cl_code from ABVSKYCMIS.kyc.dbo.bse_kyc)                   
select @nse = count(*)  from  ang_temp_track where nse = 'NEW' and cl_code in (select cl_code from ABVSKYCMIS.kyc.dbo.nse_kyc)                   
select @nsefo = count(*) from  ang_temp_track where fo = 'NEW' and cl_code in (select cl_code from ABVSKYCMIS.kyc.dbo.nsefo_kyc)                   
select @mcdx = count(*) from  ang_temp_track where mcx = 'NEW' and cl_code in (select cl_code from ABVSKYCMIS.kyc.dbo.mcdx_kyc)                   
select @ncdx = count(*) from  ang_temp_track where ncdx = 'NEW' and cl_code in (select cl_code from ABVSKYCMIS.kyc.dbo.ncdx_kyc)                   
select @total = count(*) from  ang_temp_track      
      
insert into ABVSKYCMIS.kyc.dbo.kyc_sum (bse,nse,nsefo,mcdx,ncdx,dt,total) values (@bse,@nse,@nsefo,@mcdx,@ncdx,getdate(),@total)      
                    
set nocount off

GO
