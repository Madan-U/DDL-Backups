-- Object: PROCEDURE citrus_usr.PrCollege
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--exec PrCollege @action=N'Add',@CollegeId=0,@CollegeName=N'dddssa',@CollegeAdd=N'aasd',@CollegeGrade=N'A',@CollegePhone=N'02352123'


create proc [citrus_usr].[PrCollege] (@action varchar(10),@CollegeId varchar(100),@CollegeName varchar(100),  
@CollegeAdd varchar(500),@CollegeGrade varchar(10),@CollegePhone varchar(12))    
    
as    
begin    
  

        if @action = 'show'    
            
        begin    
   select Cllg_Id,Clg_Name,Clg_Address,Clg_Grade,Clg_Phone,Clg_Created_Date,Clg_Updated_Date from College_mstr    
   
   
        end           
    
  if @action = 'Add'    
  begin     
   insert into College_mstr values(@CollegeName,@CollegeAdd,@CollegeGrade,@CollegePhone,getdate(),getdate())    
  end    
 if @action = 'Edit'    
  begin     
update  College_mstr  set Clg_Name = @CollegeName,Clg_Address = @CollegeAdd , Clg_Grade = @CollegeGrade,Clg_Phone = @CollegePhone,Clg_Updated_Date=getdate()  WHERE Cllg_Id = @CollegeId    
  end    
      
      
   if @action = 'Delete'    
  begin     
delete from  College_mstr where Cllg_Id = @CollegeId    
  end    

      
    
end    
     

 
 --create table employees (EmpId int identity(1,1),EmpName varchar(100),EmpQual varchar(100))

GO
