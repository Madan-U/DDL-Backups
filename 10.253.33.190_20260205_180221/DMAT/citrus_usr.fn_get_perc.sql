-- Object: FUNCTION citrus_usr.fn_get_perc
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create function citrus_usr.fn_get_perc(@pa_val varchar(100))

returns varchar(5)

begin 

  

  if citrus_usr.ufn_countstring(@pa_val,'.') = 0 

  set @pa_val = @pa_val+'.0'



  return(

case when citrus_usr.fn_splitval_by(@pa_val,1,'.')<>'' then 

case when len( citrus_usr.fn_splitval_by(@pa_val,1,'.'))=1 then '00' + citrus_usr.fn_splitval_by(@pa_val,1,'.')

when len( citrus_usr.fn_splitval_by(@pa_val,1,'.'))=2 then '0' + citrus_usr.fn_splitval_by(@pa_val,1,'.')

when len( citrus_usr.fn_splitval_by(@pa_val,1,'.'))=3 then '' + citrus_usr.fn_splitval_by(@pa_val,1,'.') end  end 

+

case when citrus_usr.fn_splitval_by(@pa_val,2,'.')<>'' then 

case when len( citrus_usr.fn_splitval_by(@pa_val,2,'.'))=0 then '00' + citrus_usr.fn_splitval_by(@pa_val,2,'.')

when len( citrus_usr.fn_splitval_by(@pa_val,2,'.'))=1 then citrus_usr.fn_splitval_by(@pa_val,2,'.') +'0'

when len( citrus_usr.fn_splitval_by(@pa_val,2,'.'))=2 then  citrus_usr.fn_splitval_by(@pa_val,2,'.') end  end 

)



end 

 

--select citrus_usr.fn_get_perc('1.2')

GO
