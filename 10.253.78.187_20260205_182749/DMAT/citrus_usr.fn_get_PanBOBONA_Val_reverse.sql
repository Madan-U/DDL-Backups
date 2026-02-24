-- Object: FUNCTION citrus_usr.fn_get_PanBOBONA_Val_reverse
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE   function [citrus_usr].[fn_get_PanBOBONA_Val_reverse]
(
@pa_cd varchar(100), @pa_desc varchar(200)
)
returns char(200)
as
begin

declare @l_val char(200)

IF @PA_CD='ANNUAL_INCOMENI'
BEGIN
Select @l_val = 
case 
when ISNULL(@pa_desc,'')=  '1'  then   'BELOW RS. 1 LAC'
when ISNULL(@pa_desc,'')=   '6' then  'Rs. 1 lac to Rs. 5 lacs'
when ISNULL(@pa_desc,'')= '7' then  'Rs. 5 lacs to Rs. 10 lacs' 
when ISNULL(@pa_desc,'')=  '8'  then           'Rs. 10 lacs to Rs. 25 lacs'  --RS. 10 LACS TO RS. 25 LAC                                   
when ISNULL(@pa_desc,'')=  '10'  then    'Rs. 25 lacs to Rs. 1 crore'
when ISNULL(@pa_desc,'')=   '11' then     'MORE THAN RS. 1 CRORE'


 else '' end 
 

END 
ELSE IF @PA_CD='ANNUAL_INCOME'
BEGIN
Select @l_val = 
case 

when ISNULL(@pa_desc,'')= '1'  then      'UPTO 1 LAKHS'
when ISNULL(@pa_desc,'')=  '6' then      '1 Lakh To 5 Lakhs'
when ISNULL(@pa_desc,'')=   '7'  then    '5 Lakh To 10 Lakhs'
when ISNULL(@pa_desc,'')=  '8'then  '10 LACS - 25 LACS'
when ISNULL(@pa_desc,'')=  '9' then  '> 25 LACS'

 else '' end 
 


END
ELSE IF @PA_CD in ('PANVC','PANVC2','PANVC3')
BEGIN
Select @l_val = case 

when ISNULL(@pa_desc,'')= '0'  then      '0 PAN NOT VERIFIED'
when ISNULL(@pa_desc,'')=  '1' then      '1 PAN VERIFIED BUT AADHAR NOT LINKED'
when ISNULL(@pa_desc,'')=   '2'  then    '2 PAN VERIFICATION REVERSED'
when ISNULL(@pa_desc,'')=  '3'  then  '3 PAN VERIFIED & AADHAR LINKED'
when ISNULL(@pa_desc,'')=  '4' then  '4 PAN EXEMPTED'
when ISNULL(@pa_desc,'')=  '5' then  '5 PAN VERIFIED & AADHAR LINKED TO BE CHECKED'
when ISNULL(@pa_desc,'')=  '6' then  '6 PAN VERIFIED & AADHAR LINKED AS CONFIRMED BY DP'
when ISNULL(@pa_desc,'')=  '7' then  '7 AADHAR EXEMPTED CASES'

 else '' end 
end
ELSE IF @PA_CD in ('BOOS')
BEGIN
Select @l_val = 
case
when ISNULL(@pa_desc,'')=  '1'  then  'ONLINE A/C OPEN BY BO'
when ISNULL(@pa_desc,'')=  '2' then'A/C BASE ON PHYSICAL DOCS'   else '' end
end
ELSE IF @PA_CD in ('BONAFIDE')
BEGIN
Select @l_val = 
case
when ISNULL(@pa_desc,'')= 'E'  then  'ELECTRONIC (EASI EASIEST)'
when ISNULL(@pa_desc,'')= 'P' then    'PHYSICAL'
when ISNULL(@pa_desc,'')=  'A'  then 'ONLINE AC OPENBY DPPORTAL' else '' end 
end

 
 


return ltrim(rtrim(isnull(@l_val,'')))
end

GO
