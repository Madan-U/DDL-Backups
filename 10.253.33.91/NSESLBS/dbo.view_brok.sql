-- Object: PROCEDURE dbo.view_brok
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure view_brok 

as
declare @clcd varchar(10)
DECLARE @find varchar(30)
SET @find = (select table_no from client2 where cl_code like @clcd)
SELECT *
FROM broktable
WHERE table_no LIKE @find

GO
