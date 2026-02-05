-- Object: FUNCTION citrus_usr.fn_new_line_arragement
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--SELECT CITRUS_USR.[fn_new_line_arragement]('1. THIS IS A COMPUTER GENEREATED STATEMENT AND DOES NOT REQUIRE THE DP''S SEAL OR SIGNATURE.<BR>2. ANY DISCREPANCY IN THE STATEMENT SHOULD BE BROUGHT TO THE NOTICE OF "KJMC CAPITAL MARKET SERVICES LTD." WITHIN 30 DAYS FROM THE DATE OF STATEMENT.<BR>3. FOR CLIENTS NOT HAVING TRADING A/C WITH US, THE DP CHARGES MAY BE PAID THROUGH  CHEQUE  /  D.D. DRAWN  IN FAVOUR "KJMC CAPITAL MARKET SERVICES LTD." FOR OUTSTATION CLIENT''S ONLY DEMAND DRAFT WILL BE ACCEPTED. PLEASE MENTION THE BILL NO. & BO ID ON THE REVERSE OF THE CHEQUE / DD. PAYMENTS MADE BY CHEQUE ARE SUBJECT TO REALISATION.<BR>4. FOR CLIENTS HAVING TRADING A/C WITH "KJMC CAPITAL MARKET SERVICES LTD", THE DP CHARGES WILL BE DEBITED TO THE TRADING A/C.<BR>5.  THE COMPUTATION OF THE CHARGES IS BASED ON THE RATES PROVIDED BY CDSL.<BR>6. KINDLY NOTE THAT INTEREST @ 18%P.A.(COMPUTED ON DAILY BASIS)  WOULD BE LEVIED ON THE OUTSTANDING AMOUNT FROM DUE DATE.<BR>7. OUR SERVICE TAX REGISTRATION NO.IS  : AAACK2239EST001.<BR>8.FOR ANY ENQUIRY AND GRIEVANCE,PLEASE CONTACT US AT TEL.NO : 40945500 EXTN NO.136/ 130 OR FAX NO.: 22852892 OR EMAIL US AT :  DPGRIEVANCE@KJMC.COM. <BR>',75)      
CREATE FUNCTION [citrus_usr].[fn_new_line_arragement](@pa_string varchar(8000),@l_valid_ln numeric)      
returns varchar(8000)      
as      
begin      
declare @l_count int      
 , @l_counter int      
 , @l_string  varchar(8000)      
 , @l_main_string  varchar(8000)      
 , @l_remain   int      
set @l_counter = 1      
set @l_string =''      
      
set @l_main_string = @pa_string      
      
select @l_count = citrus_usr.ufn_countstring(@l_main_string,'<br>')      
      
while @l_count>=@l_counter      
begin      
  if @l_valid_ln = 75    
  begin    
    set @l_remain    = len(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))/75   
   
    if len(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>')) between 74 and 75 
    set @l_remain = 1
    if len(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>')) between 149 and 150 
    set @l_remain = 2
    if len(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>')) between 224 and 225 
    set @l_remain = 3
    if len(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>')) between 299 and 300 
    set @l_remain = 4
    if len(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>')) between 374 and 375 
    set @l_remain = 5



        
    if @l_remain = 0      
    set @l_string = @l_string + convert(char(75),ltrim(rtrim(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))))      
    if @l_remain = 1      
    set @l_string = @l_string + convert(char(150),ltrim(rtrim(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))))      
    if @l_remain = 2      
    set @l_string = @l_string + convert(char(225),ltrim(rtrim(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))))      
    if @l_remain = 3      
    set @l_string = @l_string + convert(char(300),ltrim(rtrim(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))))    
    if @l_remain = 4      
    set @l_string = @l_string + convert(char(375),ltrim(rtrim(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))))        
    if @l_remain = 5    
    set @l_string = @l_string + convert(char(450),ltrim(rtrim(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))))        
  end    
  else if @l_valid_ln = 158  
  begin    
    set @l_remain    = len(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))/158     
        
    if @l_remain = 0      
    set @l_string = @l_string + convert(char(158),ltrim(rtrim(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))))      
    if @l_remain = 1      
    set @l_string = @l_string + convert(char(316),ltrim(rtrim(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))))      
    if @l_remain = 2      
    set @l_string = @l_string + convert(char(474),ltrim(rtrim(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))))      
    if @l_remain = 3      
    set @l_string = @l_string + convert(char(632),ltrim(rtrim(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))))     
    if @l_remain = 4      
    set @l_string = @l_string + convert(char(790),ltrim(rtrim(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))))       
    if @l_remain = 5     
    set @l_string = @l_string + convert(char(948),ltrim(rtrim(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))))        
    if @l_remain = 6    
    set @l_string = @l_string + convert(char(1106),ltrim(rtrim(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))))        
  end    
--  else if @l_valid_ln = 145
--  begin    
--    set @l_remain    = len(citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))/145     
--        
--    if @l_remain = 0      
--    set @l_string = @l_string + convert(char(145),citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))      
--    if @l_remain = 1      
--    set @l_string = @l_string + convert(char(290),citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))      
--    if @l_remain = 2      
--    set @l_string = @l_string + convert(char(435),citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))      
--    if @l_remain = 3      
--    set @l_string = @l_string + convert(char(580),citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))     
--    if @l_remain = 4      
--    set @l_string = @l_string + convert(char(725),citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))       
--    if @l_remain = 5     
--    set @l_string = @l_string + convert(char(870),citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))        
--    if @l_remain = 6    
--    set @l_string = @l_string + convert(char(1015),citrus_usr.fn_splitval_by(@l_main_string,@l_counter,'<br>'))        
--  end    
--       
  set @l_counter = @l_counter +  1      
end       
      
return @l_string       
      
end       
      
      
      
--select citrus_usr.fn_splitval_by('sdsdsdsd <br> sdsadsdsdsadsadsadsadsadsadsa <br> dsdsdsfdsdsfd fdfdfd fdfsd sdfds <br>',2,'<br>')

GO
