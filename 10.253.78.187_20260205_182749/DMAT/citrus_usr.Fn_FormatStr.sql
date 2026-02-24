-- Object: FUNCTION citrus_usr.Fn_FormatStr
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--SELECT citrus_usr.FN_FORMATSTR('3.00100',12,3,'L','0') 
--select CITRUS_USR.FN_FORMATSTR('64444',12,3,'L','0')
CREATE function [citrus_usr].[Fn_FormatStr]      
(      
@pa_val varchar(100),      
@pa_Intcnt int,      
@pa_decimalcnt int,      
@pa_appendpos char(1),      
@pa_appendchar char(1)       
)      
Returns varchar(8000)      
as       
Begin       
Declare @l_txt_nos varchar(100),      
@l_paint_val varchar(100),      
@l_padec_val varchar(100)      
set @l_paint_val = Substring(@pa_val,0,charindex('.',@pa_val) )    
    
if @l_paint_val = ''    
set @l_paint_val=@pa_val     
    
--set @l_padec_val = Abs(Substring(@pa_val,charindex('.',@pa_val)+1,len(@pa_val)))
if charindex('.',@pa_val) = 0
begin
	set @l_padec_val = replicate(@pa_appendchar,@pa_decimalcnt)
end
else
begin
	set @l_padec_val = Substring(@pa_val,charindex('.',@pa_val)+1,@pa_decimalcnt)     
end
--
    
if @l_padec_val = @pa_val    
set @l_padec_val='0'    
    
--      
if @pa_appendpos='L'      
Begin      
 set @l_txt_nos = replicate(@pa_appendchar,@pa_Intcnt - len(@l_paint_val)) + @l_paint_val      
      
 if @pa_decimalcnt <> 0      
 begin      
  set @l_txt_nos = @l_txt_nos + replicate(@pa_appendchar,@pa_decimalcnt - len(@l_padec_val)) + @l_padec_val      
 end      
End      
if @pa_appendpos='R'      
Begin      
 set @l_txt_nos =  @l_paint_val + replicate(@pa_appendchar,@pa_Intcnt - len(@l_paint_val))      
      
 if @pa_decimalcnt <> 0      
 begin      
  set @l_txt_nos = @l_txt_nos +  @l_padec_val + replicate(@pa_appendchar,@pa_decimalcnt - len(@l_padec_val))       
 end      
End      
      
      
      
Return  @l_txt_nos      
End

GO
