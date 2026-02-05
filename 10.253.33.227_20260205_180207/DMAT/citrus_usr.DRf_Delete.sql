-- Object: PROCEDURE citrus_usr.DRf_Delete
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


create proc [citrus_usr].[DRf_Delete] 
 (@pa_drf varchar (20))
as
begin 

exec drf_backup @pa_drf

dECLARE @PA_DRM_ID NUMERIC (9)
 
SELECT @PA_DRM_ID = DEMRM_ID  FROM DEMAT_REQUEST_MSTR WHERE DEMRM_SLIP_SERIAL_NO = @pa_drf

DELETE FROM dmat_dispatch WHERE DISP_DEMRM_ID = @PA_DRM_ID

delete from DEMAT_TRAN_TRANM_DTLS_mak where DEMTTD_DEMRM_ID = @PA_DRM_ID
delete from demrd_mak where DEMRD_DEMRM_ID = @PA_DRM_ID
delete  from demrm_mak where DEMRM_SLIP_SERIAL_NO = @pa_drf

delete  from used_slip where uses_slip_no = @pa_drf

delete from DEMAT_TRAN_TRANM_DTLS where DEMTTD_DEMRM_ID = @PA_DRM_ID
delete from DEMAT_REQUEST_DTLS  where DEMRD_DEMRM_ID = @PA_DRM_ID
delete from DEMAT_REQUEST_MSTR  where DEMRM_SLIP_SERIAL_NO = @pa_drf



SELECT * FROM dmat_dispatch WHERE DISP_DEMRM_ID = @PA_DRM_ID

SELECT * from DEMAT_TRAN_TRANM_DTLS_mak where DEMTTD_DEMRM_ID = @PA_DRM_ID
SELECT * from demrd_mak where DEMRD_DEMRM_ID = @PA_DRM_ID
SELECT * from demrm_mak where DEMRM_SLIP_SERIAL_NO = @pa_drf

SELECT *  from used_slip where uses_slip_no = @pa_drf

SELECT * from DEMAT_TRAN_TRANM_DTLS where DEMTTD_DEMRM_ID = @PA_DRM_ID
SELECT * from DEMAT_REQUEST_DTLS  where DEMRD_DEMRM_ID = @PA_DRM_ID
SELECT * from DEMAT_REQUEST_MSTR  where DEMRM_SLIP_SERIAL_NO = @pa_drf


END

GO
