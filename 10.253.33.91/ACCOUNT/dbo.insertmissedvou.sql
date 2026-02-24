-- Object: PROCEDURE dbo.insertmissedvou
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

create proc insertmissedvou
@vnopart varchar(6)
as

declare
@@sessionid varchar(15),
@@vno varchar(12),
@@branchflag tinyint,
@@costcenterflag tinyint,
@@costenable char(1),

@@ncursor as cursor

set @@ncursor = cursor for
select distinct sessionid, vno from tempacdlledger2 where category = 'BRANCH' and vno like @vnopart + '%'
open @@ncursor
fetch next from @@ncursor 
into @@sessionid, @@vno

while @@fetch_status = 0
begin
   exec inserttoacdlledger2 @@sessionid, @@vno, 1, 1, 0
   fetch next from @@ncursor into @@sessionid, @@vno
end

GO
