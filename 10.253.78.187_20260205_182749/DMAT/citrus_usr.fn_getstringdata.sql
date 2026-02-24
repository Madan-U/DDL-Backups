-- Object: FUNCTION citrus_usr.fn_getstringdata
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_getstringdata]()
returns varchar(8000)
as
begin
      declare @res varchar(8000)
      select   @res = coalesce(@res + ',', '') +  convert(varchar,bitrm_parent_cd)
      from bitmap_ref_mstr
      --where somefield = @id
      group by bitrm_parent_cd
      return (@res)
END


--select * from bitmap_ref_mstr

--select citrus_usr.fn_getstringdata()

GO
