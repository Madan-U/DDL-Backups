-- Object: FUNCTION citrus_usr.udfConvertBase10NumberToAnyBase
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

/*select BITRM_child_cd , excsm_exch_cd,right(CCM_CD,6) from cc_mstr   
, bitmap_ref_mstr, exch_seg_mstr   
where  len(citrus_usr.udfConvertBase10NumberToAnyBase(convert(int,CCM_EXCSM_BIT),2,0,0)) = bitrm_bit_location  
and  bitrm_parent_cd = 'access1'  
and  bitrm_child_cd = excsm_Desc  
  
*/  
  
  
CREATE FUNCTION [citrus_usr].[udfConvertBase10NumberToAnyBase]  
( @iNumber   INT,  
 @iNewBase   INT,  
 @bitUppercaseOnly BIT = 0,  
 @bitNoNumbers  BIT = 0)  --1 to use only alphas  
RETURNS VARCHAR(120)  
AS  
BEGIN  
 DECLARE @vUppers VARCHAR(26)  
 DECLARE @vLowers VARCHAR(26)  
 DECLARE @vNumbers VARCHAR(10)  
  
 SELECT @vUppers = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'  
 SELECT @vLowers = 'abcdefghijklmnopqrstuvwxyz'  
 SELECT @vNumbers= '0123456789'  
  
 DECLARE @vCharactersInBase VARCHAR(62) --Max possible of 10 digits, 26 upper, 26 lower  
 SELECT @vCharactersInBase = @vUppers --all options allow this  
  
 IF @bitNoNumbers = 0  
 BEGIN  
  SELECT @vCharactersInBase = @vNumbers + @vCharactersInBase  
 END  
  
 IF @bitUppercaseOnly = 0  
 BEGIN  
  SELECT @vCharactersInBase = @vCharactersInBase + @vLowers  
 END  
  
 --If caller requests a "base" size > number of characters in conversion-characters-set, return error  
 IF LEN(@vCharactersInBase) < @iNewBase  
 BEGIN  
  RETURN 'udfConvertBase10NumberToAnyBase - ERROR: Requested Base-size greater than available characters in @vCharactersInBase'  
 END  
  
 DECLARE @vNewNumber VARCHAR(120)  
 SELECT @vNewNumber = ''  
  
  
 -- Algorithm for generating equivalant number in the new "base":  
 -- 1) The orignial (base-10) number is continually divided by the new base until the product  
 --    of the old number divided by the base is zero (meaning the number is finally smaller than the new base).  
 -- 2) On each cycle (loop iteration), the remainder is added to the number, which is each digit of the new base.  
 WHILE @iNumber <> 0  
 BEGIN  
  SELECT @vNewNumber = SUBSTRING(@vCharactersInBase, (@iNumber % @iNewBase) + 1, 1) + @vNewNumber  
  SELECT @iNumber = @iNumber / @iNewBase  
 END --While  
  
 RETURN @vNewNumber  
  
END --Procedure

GO
