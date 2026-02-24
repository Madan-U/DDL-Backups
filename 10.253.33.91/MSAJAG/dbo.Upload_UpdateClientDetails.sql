-- Object: PROCEDURE dbo.Upload_UpdateClientDetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc Upload_UpdateClientDetails --'update_clientdetails1.txt'                           
(                                                    
@filename as varchar(100)                                                          
)                                                      
as                     
          
create table #t             
(           
Cl_Code varchar(10),            
L_Add1 varchar(500),            
L_City varchar(100),            
L_Add2 varchar(500),            
L_State varchar(200),          
L_Add3 varchar(500),             
L_Zip varchar(30),            
Mobile_pager varchar(25),            
EmailId varchar(150)          
--RowId int identity            
)              
        
declare @path as varchar(100)                    
declare @sql as varchar(1000)                
        
--select @path =  uploadserver from [CSOKYC-6].upload.dbo.global_upload where upd_srno = 2              
--set @path = @path+'\KycUpdatePartyDetails\'+@filename         
--print  @path         
set @path='\\AngelNseCM\d$\upload1\KycUpdatePartyDetails\'+ @filename      
                          
SET @SQL = 'BULK INSERT #t FROM '''+@Path+''' WITH (FIELDTERMINATOR = ''\t'', FirstRow=2,KeepNULLS)'                                                     
exec (@sql)             
select @@RowCount as [count]           
          
create table #temp             
(            
Cl_Code varchar(10),            
L_Add1 varchar(500),            
L_City varchar(100),            
L_Add2 varchar(500),            
L_State varchar(200),          
L_Add3 varchar(500),             
L_Zip varchar(30),            
Mobile_pager varchar(25),            
EmailId varchar(150),          
RowId int identity            
)            
          
insert into #temp          
select * from #t          
          
          
Declare @Cl_Code varchar(10),@L_Add1 varchar(50),@L_City varchar(10),@L_Add2 varchar(50),@L_State varchar(20),@L_Add3 varchar(50),@L_Zip varchar(10),@Mobile_pager varchar(25),@EmailId varchar(50)          
Declare @MinRowId int,@MaxRowId int,@CurrRowId int            
select @MinRowId=min(RowId),@MaxRowId=max(RowId) from #temp              
while(@MinRowId <=@MaxRowId)            
Begin            
select @Cl_Code=Cl_Code,@L_Add1=L_Add1,@L_City=L_City,@L_Add2=L_Add2,@L_State=L_State,@L_Add3=L_Add3,@L_Zip=L_Zip,@Mobile_pager=Mobile_pager,@EmailId=EmailId from #temp(nolock)            
where RowId=@MinRowId           
          
if @L_Add1<>''          
update Client_details set l_address1=@L_Add1 where cl_code=@Cl_Code          
if @L_City<>''          
update Client_details set l_city=@L_City where cl_code=@Cl_Code          
if @L_Add2<>''          
update Client_details set l_address2=@L_Add2 where cl_code=@Cl_Code          
if @L_State<>''          
update Client_details set l_state=@L_State where cl_code=@Cl_Code          
if @L_Add3<>''          
update Client_details set l_address3=@L_Add3 where cl_code=@Cl_Code          
if @L_Zip<>''          
update Client_details set l_zip=@L_Zip where cl_code=@Cl_Code          
if @Mobile_pager<>''          
update Client_details set mobile_pager=@Mobile_pager where cl_code=@Cl_Code          
if @EmailId<>''          
update Client_details set email=@EmailId where cl_code=@Cl_Code          
          
set @MinRowId=@MinRowId+1             
end

GO
