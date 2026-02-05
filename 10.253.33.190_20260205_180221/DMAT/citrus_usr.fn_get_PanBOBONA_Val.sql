-- Object: FUNCTION citrus_usr.fn_get_PanBOBONA_Val
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE   function [citrus_usr].[fn_get_PanBOBONA_Val]
(
@pa_desc varchar(100),@pa_cd varchar(20)
)
returns char(2)
as
begin

declare @l_val char(2)

IF @PA_CD='ANNUAL_INCOMENI'
BEGIN
Select @l_val = 
case 
when ISNULL(@pa_desc,'')=  'BELOW RS. 1 LAC' then '1'   
when ISNULL(@pa_desc,'')=  'Rs. 1 lac to Rs. 5 lacs' then '6'
when ISNULL(@pa_desc,'')= 'Rs. 5 lacs to Rs. 10 lacs' then '7'
when ISNULL(@pa_desc,'')=  'Rs. 10 lacs to Rs. 25 lacs' then '8'                                               
when ISNULL(@pa_desc,'')=  'Rs. 25 lacs to Rs. 1 crore' then '10'   
when ISNULL(@pa_desc,'')=  'MORE THAN RS. 1 CRORE' then '11'   


 else '' end 
 

END 
ELSE IF @PA_CD='ANNUAL_INCOME'
BEGIN
Select @l_val = 
case 

when ISNULL(@pa_desc,'')=  'UPTO 1 LAKHS' then '1'   
when ISNULL(@pa_desc,'') IN('1 Lakh To 5 Lakhs','1 LAC - 5 LACS') then '6'   
when ISNULL(@pa_desc,'')IN (  '5 Lakh To 10 Lakhs','5 LACS - 10 LACS') then '7'   
when ISNULL(@pa_desc,'')=  '10 LACS - 25 LACS' then '8'
when ISNULL(@pa_desc,'')=  '> 25 LACS' then '9'

 else '' end 
 


END
ELSE IF @PA_CD in ('PANVC','PANVC2','PANVC3')
BEGIN
Select @l_val = LEFT(isnull(@pa_desc,''),1)
end
ELSE IF @PA_CD in ('BOOS')
BEGIN
Select @l_val = 
case
when ISNULL(@pa_desc,'')='ONLINE A/C OPEN BY BO' then '1'  
when ISNULL(@pa_desc,'')='A/C BASE ON PHYSICAL DOCS' then '2'   else '' end
end
ELSE IF @PA_CD in ('BONAFIDE')
BEGIN
Select @l_val = 
case
when ISNULL(@pa_desc,'')='ELECTRONIC (EASI EASIEST)' then 'E'  
when ISNULL(@pa_desc,'')='PHYSICAL' then 'P'  
when ISNULL(@pa_desc,'')='ONLINE AC OPENBY DPPORTAL' then 'A'  else '' end 
end

 
 


return ltrim(rtrim(isnull(@l_val,'')))
end

GO
