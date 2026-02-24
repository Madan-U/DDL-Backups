-- Object: VIEW citrus_usr.ImportDpprofiles
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

Create View [citrus_usr].[ImportDpprofiles]
as
select brom_id,Brom_desc,Exchange=EXCSM_EXCH_CD from brokerage_mstr,exch_seg_mstr where brom_excpm_id = excsm_id

GO
