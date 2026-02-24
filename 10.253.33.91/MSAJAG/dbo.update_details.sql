-- Object: PROCEDURE dbo.update_details
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create proc update_details
@Sett_no varchar(10),
@Sett_type Varchar(3)

as

delete from details where sett_no = @sett_no and sett_type = @sett_type

insert into details select distinct left(convert(varchar,sauda_date,109),11),sett_no,sett_type,party_code,'S'
from settlement where sett_no = @sett_no and sett_type = @sett_type
order by 1,2,3,4

GO
