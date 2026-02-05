-- Object: PROCEDURE dbo.insertempdetails
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

   
CREATE proc insertempdetails(@action varchar(10), @EmpId  int , @empname varchar(200),@qual varchar(200))    
as    
begin    
if @action = 'Add'    
 begin    
 insert into empDetailss(empname,    
 empQualification)values(@empname,@qual)    
 end    
    
if @action = 'Edit'    
 begin    
 update   empDetailss set empname =@empname, empQualification=@qual where Empid = @EmpId    
 end   
  
if @action = 'Show'    
 begin    
 SELECT Empid,empname,  
empQualification FROM    empDetailss      
 end     
  
if @action = 'Delete'    
 begin    
 delete FROM empDetailss where Empid = @EmpId    
 end     
end

GO
