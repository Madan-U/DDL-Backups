-- Object: FUNCTION citrus_usr.FN_STRING_FOR_PRINT
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select citrus_usr.[FN_STRING_FOR_PRINT] ('Any discrepancy in the statement should be brough to the notice of ''BASIS POINT SECURITIES PRIVATE LIMITED'' within one month from the date of the statement<br>',158)
--select citrus_usr.[fn_new_line_arragement]('Any discrepancy in the statement should be brough to the notice of ''BASIS POINT SECURITIES PRIVATE LIMITED'' within one month from the date<br>',158)  
CREATE FUNCTION [citrus_usr].[FN_STRING_FOR_PRINT](@PA_STRING VARCHAR(8000),@PA_LEN NUMERIC)
RETURNS VARCHAR(8000)
AS
BEGIN
declare @l_modified  varchar(8000)
,@l_remain    varchar(8000)
,@l_string    varchar(8000)
,@L_ORG_STRGIN VARCHAR(8000)
,@L_ORG_LEN BIGINT
set @l_modified = ''
set @l_string = ''
SET @L_ORG_LEN = 0 

set @pa_string = citrus_usr.[fn_new_line_arragement](@PA_STRING,@PA_LEN)  
set @l_remain   = ltrim(rtrim(@pa_string))

while len(@l_remain) > @PA_LEN
begin
 

 SELECT @L_ORG_STRGIN = ltrim(rtrim(citrus_usr.pr_pick_upto(left(@pa_string,@PA_LEN),CASE WHEN citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|')-2 < 0 THEN 1 ELSE citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|')-2 END )))
 
 SELECT @L_ORG_LEN = LEN(@L_ORG_STRGIN)
 
 if @PA_LEN = 75
 select @l_string = @l_string + convert(char(75),@L_ORG_STRGIN)
 
if @PA_LEN = 150
 select @l_string = @l_string + convert(char(150),@L_ORG_STRGIN)

if @PA_LEN = 15
 select @l_string = @l_string + convert(char(15),@L_ORG_STRGIN)

if @PA_LEN = 32
 select @l_string = @l_string + convert(char(32),@L_ORG_STRGIN)

if @PA_LEN = 20
 select @l_string = @l_string + convert(char(20),@L_ORG_STRGIN)

if @PA_LEN = 16
 select @l_string = @l_string + convert(char(16),@L_ORG_STRGIN)

if @PA_LEN = 158
 select @l_string = @l_string + convert(char(158),@L_ORG_STRGIN)

if @PA_LEN = 145
 select @l_string = @l_string + convert(char(145),@L_ORG_STRGIN)





 set @pa_string = ltrim(rtrim(substring(LTRIM(RTRIM(@pa_string)) ,@L_ORG_LEN + 1,len(@pa_string)))) 
 


 set @l_remain = ltrim(rtrim(substring(LTRIM(RTRIM(@l_remain)) ,@L_ORG_LEN +  1,len(@l_remain)))) 

 

end 

set @pa_string = @pa_string + '    '

if @PA_LEN = 75
begin

SELECT @L_ORG_STRGIN = ltrim(rtrim(citrus_usr.pr_pick_upto(left(@pa_string,75),CASE WHEN citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|')-2 < 0 THEN 1 ELSE citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|') END )))
select @l_string = @l_string + convert(char(75),@L_ORG_STRGIN)
end 
 
if @PA_LEN = 150
begin
SELECT @L_ORG_STRGIN = ltrim(rtrim(citrus_usr.pr_pick_upto(left(@pa_string,150),CASE WHEN citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|')-2 < 0 THEN 1 ELSE citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|') END )))
select @l_string = @l_string + convert(char(150),@L_ORG_STRGIN)
end 

if @PA_LEN = 15
begin
SELECT @L_ORG_STRGIN = ltrim(rtrim(citrus_usr.pr_pick_upto(left(@pa_string,15),CASE WHEN citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|')-2 < 0 THEN 1 ELSE citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|') END )))
select @l_string = @l_string + convert(char(15),@L_ORG_STRGIN)
end 

if @PA_LEN = 32
begin
SELECT @L_ORG_STRGIN = ltrim(rtrim(citrus_usr.pr_pick_upto(left(@pa_string,32),CASE WHEN citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|')-2 < 0 THEN 1 ELSE citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|') END )))
select @l_string = @l_string + convert(char(32),@L_ORG_STRGIN)
end 

if @PA_LEN = 20
begin
SELECT @L_ORG_STRGIN = ltrim(rtrim(citrus_usr.pr_pick_upto(left(@pa_string,20),CASE WHEN citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|')-2 < 0 THEN 1 ELSE citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|') END )))
select @l_string = @l_string + convert(char(20),@L_ORG_STRGIN)
end 

if @PA_LEN = 16
begin
SELECT @L_ORG_STRGIN = ltrim(rtrim(citrus_usr.pr_pick_upto(left(@pa_string,16),CASE WHEN citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|')-2 < 0 THEN 1 ELSE citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|') END )))
select @l_string = @l_string + convert(char(16),@L_ORG_STRGIN)
end 


if @PA_LEN = 158
begin
SELECT @L_ORG_STRGIN = ltrim(rtrim(citrus_usr.pr_pick_upto(left(@pa_string,158),CASE WHEN citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|')-2 < 0 THEN 1 ELSE citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|') END )))
select @l_string = @l_string + convert(char(158),@L_ORG_STRGIN)
end 

if @PA_LEN = 145
begin
SELECT @L_ORG_STRGIN = ltrim(rtrim(citrus_usr.pr_pick_upto(left(@pa_string,145),CASE WHEN citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|')-2 < 0 THEN 1 ELSE citrus_usr.ufn_countstring(replace(left(@pa_string,@PA_LEN),' ','|'),'|') END )))
select @l_string = @l_string + convert(char(145),@L_ORG_STRGIN)
end 


 


RETURN @l_string

END

GO
