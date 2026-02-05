-- Object: PROCEDURE citrus_usr.bitmapresetvalue_for_transaction
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[bitmapresetvalue_for_transaction]
AS
BEGIN
declare @l_max_bitmap numeric(10,0)
,@l_dptd_id numeric(10,0)
,@l_dtls_id numeric(10,0)

DELETE FROM BITMAP_REF_MSTR WHERE BITRM_PARENT_CD IN ('DPTDC_ID','DPTDC_DTLS_ID','DPTD_ID','DPTD_DTLS_ID')

select @l_max_bitmap = max(bitrm_id)+1 from bitmap_ref_mstr
select @l_dptd_id = isnull(max(dptdc_id),0) + 1 from dptdc_mak


insert into bitmap_ref_mstr 
values(@l_max_bitmap,'DPTDC_ID','DPTDC_ID', @l_dptd_id, '','','HO',getdate(),'HO',getdate(),1)


select @l_max_bitmap = max(bitrm_id)+1 from bitmap_ref_mstr
select @l_dtls_id = isnull(max(dptdc_dtls_id),0) + 1 from dptdc_mak

insert into bitmap_ref_mstr 
values(@l_max_bitmap,'DPTDC_DTLS_ID','DPTDC_DTLS_ID',@l_dtls_id , '','','HO',getdate(),'HO',getdate(),1)


select @l_max_bitmap = max(bitrm_id)+1 from bitmap_ref_mstr
select @l_dptd_id = isnull(max(dptd_id),0) + 1 from dptd_mak

insert into bitmap_ref_mstr 
values(@l_max_bitmap,'DPTD_ID','DPTD_ID',@l_dptd_id , '','','HO',getdate(),'HO',getdate(),1)



select @l_max_bitmap = max(bitrm_id)+1 from bitmap_ref_mstr
select @l_dtls_id = isnull(max(dptd_dtls_id),0) + 1 from dptd_mak

insert into bitmap_ref_mstr 
values(@l_max_bitmap,'DPTD_DTLS_ID','DPTD_DTLS_ID',@l_dtls_id , '','','HO',getdate(),'HO',getdate(),1)

select * from bitmap_ref_mstr

END

GO
