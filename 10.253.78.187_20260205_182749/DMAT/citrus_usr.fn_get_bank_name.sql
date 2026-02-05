-- Object: FUNCTION citrus_usr.fn_get_bank_name
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create function citrus_usr.fn_get_bank_name(@pa_micr varchar(100),@pa_rtgs varchar(100))
returns varchar(1000)
as
begin 

return (select top 1 banm_name from bank_mstr where BANM_MICR =  @pa_micr and @pa_rtgs = banm_rtgs_cd and banm_deleted_ind = 1)

end

GO
