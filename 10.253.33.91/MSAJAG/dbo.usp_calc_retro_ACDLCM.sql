-- Object: PROCEDURE dbo.usp_calc_retro_ACDLCM
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


create procedure usp_calc_retro_ACDLCM(@fdate as varchar(11),@tdate as varchar(11),@sbcode as varchar(20),@coname as varchar(20))
as

/*                                                                                                                    
declare @fdate as varchar(25)                                                                                                                                                                                    
declare @tdate as varchar(25)                                                                                                                                                                                    
declare @userid as varchar(25)                                                                                                                                                                                    
declare @SBCODE as varchar(25)                                                                                                                                                                                    
declare @CONAME as varchar(25)                                                                                                                                                                                    
set @CONAME='ACDLCM'                                                                                                                                                                                    
set @SBCODE='AAA'                                                                                                                                                                                    
set @fdate='01/08/2009'                                                                                                                                                                                    
set  @tdate='01/10/2009'                                                                                                                                                                                    
set @userid='System'                                                                                                                           
 
*/

select * into #tbl_retro_master     
 from [172.29.2.158,2000].remisior.dbo.tbl_retro_master       
 where frdate>= @fdate and todate<= @tdate and sb=@sbcode and segment=@coname --drop table #tbl_retro_master       

 

 
select a.*  into #NSEDATA_TEMP from MSAJAG.DBO.SETTLEMENT a (nolock) join #tbl_retro_master b 
on a.party_code=b.party_code --drop table  #NSEDATA_TEMP      
-- where convert(datetime,sauda_date,103)>=convert(datetime,convert(datetime,@fdate,103),103) and convert(datetime,sauda_date,103)<=convert(datetime,@tdate,103) and sett_type in ('N','W')                                                                  
 where sauda_date>=CONVERT(VARCHAR(12), convert(datetime,@fdate), 107)  and sauda_date<=CONVERT(VARCHAR(12), convert(datetime,@tdate), 107)  and sett_type in ('N','W')                                                                  

insert into #NSEDATA_TEMP
select a.* from MSAJAG.DBO.history  a (nolock) join #tbl_retro_master b               
on a.party_code=b.party_code
where sauda_date>=CONVERT(VARCHAR(12), convert(datetime,@fdate), 107) and sauda_date<=CONVERT(VARCHAR(12), convert(datetime,@tdate), 107)  and sett_type in ('N','W')                                                                                                                 


insert into  #NSEDATA_TEMP 
select a.* from MSAJAG.DBO.ISETTLEMENT  a (nolock) join #tbl_retro_master b                
on a.party_code=b.party_code
where sauda_date>=CONVERT(VARCHAR(12), convert(datetime,@fdate), 107) and sauda_date<=CONVERT(VARCHAR(12), convert(datetime,@tdate), 107)  and sett_type in ('N','W')                                                                  

insert into  #NSEDATA_TEMP 
select a.* from MSAJAG.DBO.ihistory  a (nolock) join #tbl_retro_master b 
on a.party_code=b.party_code
where sauda_date>=CONVERT(VARCHAR(12), convert(datetime,@fdate), 107) and sauda_date<=CONVERT(VARCHAR(12), convert(datetime,@tdate), 107)  and sett_type in  ('N','W')

GO
