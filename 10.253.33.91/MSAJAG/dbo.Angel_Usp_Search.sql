-- Object: PROCEDURE dbo.Angel_Usp_Search
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc Angel_Usp_Search (@category as varchar(20),@clcode as varchar(20))  
as   
  
set nocount on  
  
if @category = 'Client'  
begin  
select short_name,branch_cd,sub_broker,email,res_phone1 from client_details where party_code = @clcode  
end  
  
if @category = 'Branch'  
begin  
select long_name,branch,branch_code,email,Phone1 from Branch where Branch_code = @clcode  
end  
  
if @category = 'Subbroker'  
begin  
select name,branch_code,sub_broker,email,phone1 from Subbrokers where sub_broker = @clcode  
end 
 
else
begin
select * from tbl_category_item_master where fld_issue_type = @category  and Fld_code = @clcode 
end
  
set nocount off

GO
