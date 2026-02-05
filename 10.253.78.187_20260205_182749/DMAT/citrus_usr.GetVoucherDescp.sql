-- Object: FUNCTION citrus_usr.GetVoucherDescp
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[GetVoucherDescp](@vouchertype int) returns varchar(10)  
as  
begin  
declare @vchdescp varchar(10)  
if @vouchertype = 0  
begin  
 set @vchdescp = 'OPENING'  
end  
else if @vouchertype = 1  
begin  
 set @vchdescp = 'PAYMENT'  
end  
else if @vouchertype = 2  
begin  
 set @vchdescp = 'RECEIPT'  
end  
else if @vouchertype = 3  
begin  
 set @vchdescp = 'JV'  
end  
else if @vouchertype = 4  
begin  
 set @vchdescp = 'CONTRA'  
end  
else if @vouchertype = 6  
begin  
 set @vchdescp = 'CREDIT NOTE'  
end 
else if @vouchertype = 7  
begin  
 set @vchdescp = 'DEBIT NOTE'  
end 
else if @vouchertype = 5  
begin  
 set @vchdescp = 'BILL'  
end  
 return @vchdescp  
end

GO
