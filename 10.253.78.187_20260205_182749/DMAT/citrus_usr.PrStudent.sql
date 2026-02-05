-- Object: PROCEDURE citrus_usr.PrStudent
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec PrStudent @action=N'Add',@StudentId=0,@StudentName=N'dddssa',@StudentAdd=N'aasd',@StudentGrade=N'A',@StudentPhone=N'02352123'


CREATE proc [citrus_usr].[PrStudent] (@action varchar(10),@StudentId INT,@StudentF_Name varchar(100),@StudentM_Name  varchar(100),
@StudentL_Name varchar(100),@StudentPer_Add varchar(500),  @StudentCurr_Add varchar(500),
@Stud_Prev_Clg int,@Stud_Current_Clg int,@Student_Mobile varchar(500),@Stud_Cast varchar(12))    
as    
begin    
        if @action = 'show'   
        begin    
			   select Stud_Id,Stud_FirstName,Stud_MiddelName,Stud_LastName,Stud_Permanant_Add,Stud_Temp_Add,
Stud_P_Clg = (select Clg_Name from College_mstr where Cllg_Id = Stud_Prev_Clg)
,Stud_C_Clg = (select Clg_Name from College_mstr where Cllg_Id = Stud_Current_Clg),
Stud_Prev_Clg,Stud_Current_Clg,Stud_Mobile,Stud_Cast,Stud_Created_Date,Stud_Update_Date from Student_mstr 
        end           
    
		  if @action = 'Add'    
		  begin     
				   insert into Student_mstr values(@StudentF_Name,@StudentM_Name,@StudentL_Name,@StudentPer_Add,@StudentCurr_Add,@Stud_Prev_Clg,
				   @Stud_Current_Clg,@Student_Mobile,@Stud_Cast,getdate(),getdate())    
		  end   
		   
		  if @action = 'Edit'    
		  begin     
					update  Student_mstr  set Stud_FirstName=@StudentF_Name ,Stud_MiddelName=@StudentM_Name,Stud_LastName=@StudentL_Name
					,Stud_Permanant_Add=@StudentPer_Add,Stud_Temp_Add=@StudentCurr_Add,Stud_Prev_Clg=@Stud_Prev_Clg,
					Stud_Current_Clg=@Stud_Current_Clg,Stud_Mobile=@Student_Mobile,Stud_Cast=@Stud_Cast,Stud_Created_Date=getdate(),Stud_Update_Date=getdate()
					where stud_id = @StudentId
		  end    
      
      
		  if @action = 'Delete'    
		  begin     
					delete from  Student_mstr where stud_id = @StudentId    
		  end    
end    
     
     
 --create table employees (EmpId int identity(1,1),EmpName varchar(100),EmpQual varchar(100))

GO
