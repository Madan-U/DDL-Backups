-- Object: PROCEDURE dbo.Third
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

create proc Third
@Area_Code varchar(20)
as
select 
       branch_code
        from
          area
               where AreaCode=@Area_Code

GO
