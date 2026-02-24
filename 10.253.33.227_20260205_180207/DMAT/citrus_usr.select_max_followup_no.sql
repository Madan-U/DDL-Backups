-- Object: PROCEDURE citrus_usr.select_max_followup_no
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


create  proc [citrus_usr].[select_max_followup_no]
(@count varchar(max))
as
begin
insert into followup_no values(getdate(),'',@count)
 select max(followupno) id from followup_no return

end

GO
