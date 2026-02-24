-- Object: PROCEDURE dbo.filldata
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE proc filldata 
as
declare @@sql varchar(200)
set @@sql = 'select * from abc '
exec (@@sql)
set @@sql = 'select * from ledger'
exec (@@sql)

GO
