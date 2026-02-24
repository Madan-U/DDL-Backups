-- Object: PROCEDURE citrus_usr.pr_ins_upd_bulkbrok
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*
create table bulkbrok_chng_accno
(bulk_sba_no varchar(20))

*/


create procedure [citrus_usr].[pr_ins_upd_bulkbrok]
(@pa_bulk_sba_no varchar(20),
 @pa_out varchar(8000) output
)
as
begin
--
	Insert into bulkbrok_chng_accno (bulk_sba_no) values(@pa_bulk_sba_no)
--
end

GO
