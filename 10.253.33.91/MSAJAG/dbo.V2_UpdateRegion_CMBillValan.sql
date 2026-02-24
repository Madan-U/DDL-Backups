-- Object: PROCEDURE dbo.V2_UpdateRegion_CMBillValan
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



--V2_CMBillValan '2005001','2006999'

CREATE Proc V2_UpdateRegion_CMBillValan 
(
@fromSett varchar(7)  
)
As  
  
  
set nocount on  
  
if len(@fromsett) <> 7
begin  
 print 'From Sett is Mandatory'  
 return  
end  
  

  
/*  
create table V2_REGION_Update_process  
(  
 sett_no varchar(7),  
 sett_type varchar(2),
 updtdate datetime
)  
*/  

Declare  
 @Sett Cursor,  
 @sett_no varchar(7),
 @sett_type varchar(2)
  
set transaction isolation level read uncommitted
  Set @Sett = Cursor For  
  Select distinct   
   sett_no, Sett_type
  from   
   CMBillvalan (nolock)
  where   
   sett_no > @fromsett
  order by 1 asc
  
  Open @Sett  
  Fetch Next from @Sett   
  into   
   @sett_no,@Sett_type

  While @@fetch_status = 0  
         Begin  


Set transaction isolation level read uncommitted
Update CMBillValan 
Set Region = C1.Region,
Area = C1.Area
From Client1 C1 (nolock), Client2 C2 ( nolock)
Where C1.Cl_Code = C2.Cl_Code
And C2.Party_Code = CMBillValan.Party_Code
and cmbillvalan.sett_no = @sett_no
and cmbillvalan.sett_type = @sett_type


    insert into V2_REGION_Update_process   values (@sett_no,@sett_type, getdate())


  Fetch Next from @Sett   
  into   
   @sett_no,@Sett_type
  end  
  Close @Sett

GO
