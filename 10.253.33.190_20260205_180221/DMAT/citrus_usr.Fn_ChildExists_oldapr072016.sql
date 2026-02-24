-- Object: FUNCTION citrus_usr.Fn_ChildExists_oldapr072016
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select citrus_usr.Fn_ChildExists(3,14)  
create function [citrus_usr].[Fn_ChildExists_oldapr072016]  
(@Parentcode int,@Childcode int) returns int  
as  
-- returns 1 when child node exist under parent node else 0  
begin  
 declare @@grpcode int,  
 @@retval int  
  
 set @@grpcode = 0  
  
  
  
  
 Select @@grpcode = fingt_group_code from fin_group_trans  
 where fingt_Sub_group_code = @Childcode  
  
 if @@grpcode = @Parentcode  
 begin  
    
  select @@retval = 1  
 end  
  
 if isnull(@@grpcode,0) <> 0  
 begin  
  select @@retval = citrus_usr.fn_ChildExists(@Parentcode,@@grpcode)  
  
          if @@grpcode = @Parentcode  
   begin  
       
    select @@retval = 1  
   end  
  
 end  
 else if @@grpcode <> @Parentcode  
 begin  
    
  select @@retval =0  
 end  
  
 return @@retval  
end

GO
