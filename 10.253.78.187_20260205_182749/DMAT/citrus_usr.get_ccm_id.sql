-- Object: FUNCTION citrus_usr.get_ccm_id
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create function [citrus_usr].[get_ccm_id](@pa_exch_cd varchar(50)) returns varchar(6)
as
begin
 declare @l_ccm_id varchar(6)
select @l_ccm_id  = '0000'+fillm_file_value from cc_mstr   
, bitmap_ref_mstr, exch_seg_mstr , file_lookup_mstr   
where  len(citrus_usr.udfConvertBase10NumberToAnyBase(convert(int,CCM_EXCSM_BIT),2,0,0)) = bitrm_bit_location  
and  bitrm_parent_cd = 'access1'  
and  bitrm_child_cd  = excsm_Desc  
and  fillm_file_name = 'CC_MSTR_CDSL'
and  excsm_exch_cd   = @pa_exch_cd
and  fillm_db_value  = ccm_id
  
return isnull(@l_ccm_id,'000000')

end

GO
