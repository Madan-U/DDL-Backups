-- Object: PROCEDURE citrus_usr.insertempdetails
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc insertempdetails(@action varchar(10), @EmpId  int , @empname varchar(200),@qual varchar(200))      
as      
begin      
if @action = 'Add'      
 begin      
 insert into citrus_usr.empdetailss(empname,      
 empQual)values(@empname,@qual)      
 end      
      
if @action = 'Edit'      
 begin      
 update   citrus_usr.empdetailss set empname =@empname, empQual='@qual' where Empid = @EmpId      
 end      
    
if @action = 'Show'      
 begin      
 SELECT empid,empname,    
empQual FROM    citrus_usr.empdetailss        
 end    

if @action = 'Delete'      
 begin      
 DELETE FROM citrus_usr.empdetailss WHERE empid = @EmpId
 end      
end

GO
