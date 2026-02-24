-- Object: PROCEDURE dbo.test_rep
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

--select * from Automate_name
CREATE  proc test_rep
(@Flag int)
as

declare @C varchar(1000)
If @Flag = 1
begin
	insert into Automate_name
	select 'A'
	
	select @C = count(1) from Automate_name where CL ='A'
	select @C +' '+'inserted for A'

end

If @Flag = 2
begin
	insert into Automate_name
	select 'B'
	
	
	select @C = count(1) from Automate_name where CL ='B'
	select @C +' '+'inserted for B'
	
end

GO
