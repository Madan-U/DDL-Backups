-- Object: FUNCTION citrus_usr.fn_get_cd_rel
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


CREATE function [citrus_usr].[fn_get_cd_rel](@pa_val varchar(100))
returns varchar(20)
as
begin 
return(
case when @pa_val = 'SPOUSE' then  '01'
when @pa_val = 'SON' then '02'
when @pa_val = 'DAUGHTER' then '03'
when @pa_val = 'FATHER' then '04'
when @pa_val = 'MOTHER' then '05'
when @pa_val = 'BROTHER' then '06'
when @pa_val = 'SISTER' then '07' 
when @pa_val = 'GRAND-SON' then  '08'
when @pa_val = 'GRAND-DAUGHTER' then '09'
when @pa_val = 'GRAND-FATHER' then '10'
when @pa_val = 'GRAND-MOTHER' then '11'
when @pa_val = 'NOT PROVIDED' then '12'
when @pa_val = 'OTHERS' then '13'
when @pa_val = '01' then  'SPOUSE'
when @pa_val = '02' then 'SON'
when @pa_val = '03' then 'DAUGHTER'
when @pa_val = '04' then 'FATHER'
when @pa_val = '05' then 'MOTHER'
when @pa_val = '06' then 'BROTHER'
when @pa_val = '07' then 'SISTER' 
when @pa_val = '08' then  'GRAND-SON'
when @pa_val = '09' then 'GRAND-DAUGHTER'

when @pa_val = '1' then  'SPOUSE'
when @pa_val = '2' then 'SON'
when @pa_val = '3' then 'DAUGHTER'
when @pa_val = '4' then 'FATHER'
when @pa_val = '5' then 'MOTHER'
when @pa_val = '6' then 'BROTHER'
when @pa_val = '7' then 'SISTER' 
when @pa_val = '8' then  'GRAND-SON'
when @pa_val = '9' then 'GRAND-DAUGHTER'

when @pa_val = '10' then 'GRAND-FATHER'
when @pa_val = '11' then 'GRAND-MOTHER'
when @pa_val = '12' then 'NOT PROVIDED'
when @pa_val = '13' then 'OTHERS'
else '' end )
end

GO
