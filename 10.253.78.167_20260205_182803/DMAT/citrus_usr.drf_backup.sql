-- Object: PROCEDURE citrus_usr.drf_backup
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[drf_backup](@pa_slip_no varchar (50))
as 
 
insert into demrm_mak_bak_DND
select * , 'bring back to maker', GETDATE () from demrm_mak where DEMRM_SLIP_SERIAL_NO = @pa_slip_no
insert into demrd_mak_bak_DND
select * , 'bring back to maker', GETDATE () from demrd_mak where DEMRD_DEMRM_ID  in(select demrm_id from demrm_mak where DEMRM_SLIP_SERIAL_NO = @pa_slip_no)
insert into DEMAT_TRAN_TRANM_DTLS_mak_bak_DND
select * , 'bring back to maker', GETDATE () from DEMAT_TRAN_TRANM_DTLS_mak where DEMTTD_DEMRM_ID  in(select demrm_id from demrm_mak where DEMRM_SLIP_SERIAL_NO = @pa_slip_no)
insert into used_slip_bak_DND
select * , 'bring back to maker', GETDATE () used_slip_bak_DND from used_slip where uses_slip_no = @pa_slip_no
insert into DEMAT_REQUEST_MSTR_Bak_DND
select * , 'bring back to maker', GETDATE ()  from DEMAT_REQUEST_MSTR  where DEMRM_SLIP_SERIAL_NO = @pa_slip_no
insert into DEMAT_REQUEST_DTLS_Bak_DND
select * , 'bring back to maker', GETDATE ()    from DEMAT_REQUEST_DTLS  where DEMRD_DEMRM_ID in (select demrm_id from DEMAT_REQUEST_MSTR where DEMRM_SLIP_SERIAL_NO = @pa_slip_no)
insert into DEMAT_TRAN_TRANM_DTLS_Bak_DND
select * , 'bring back to maker', GETDATE () from DEMAT_TRAN_TRANM_DTLS where DEMTTD_DEMRM_ID in (select demrm_id from DEMAT_REQUEST_MSTR where DEMRM_SLIP_SERIAL_NO = @pa_slip_no)
insert into used_slip_bAK_DND
select * , 'bring back to maker', GETDATE () from used_slip where USES_SLIP_NO = @pa_slip_no
insert into dmat_dispatch_bAK_DND
select * , 'bring back to maker', GETDATE ()  from dmat_dispatch  where DISP_DEMRM_ID in (select DEMRM_ID  from demrm_mak where DEMRM_SLIP_SERIAL_NO =@pa_slip_no )

GO
