-- Object: PROCEDURE citrus_usr.charge
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create proc charge(@pa_brom_id numeric)
as
select  * from charge_mstr where cham_slab_no in (select proc_slab_no from profile_charges where PROC_PROFILE_ID =@pa_brom_id )

GO
