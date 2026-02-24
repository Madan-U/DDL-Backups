-- Object: PROCEDURE dbo.datetest
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--exec datetest '05/12/2007;
create proc datetest
	@mydate varchar(10)

as
select convert(varchar(11), convert(datetime, @mydate, 103), 109)

GO
