-- Object: FUNCTION citrus_usr.fn_get_busm_access
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_get_busm_access](@pa_parent_cd VARCHAR(100)
)
RETURNS INTEGER
AS
BEGIN
--
		DECLARE @FINAL_BIT INTEGER
									,@BITRM_BIT_LOCATION NUMERIC

		DECLARE CURSOR_TEMP CURSOR FOR
		SELECT  bitrm_bit_location 
		FROM    bitmap_ref_mstr 
		WHERE   bitrm_parent_cd LIKE  @pa_parent_cd  
		AND     bitrm_deleted_ind = 1

		OPEN CURSOR_TEMP
		FETCH NEXT FROM CURSOR_TEMP INTO @BITRM_BIT_LOCATION 


		WHILE (@@FETCH_STATUS=0)
		BEGIN

				SET @FINAL_BIT =  POWER(2, @BITRM_BIT_LOCATION-1) | ISNULL(@FINAL_BIT,0)


				FETCH NEXT FROM CURSOR_TEMP INTO @BITRM_BIT_LOCATION 

		END

		CLOSE CURSOR_TEMP
		DEALLOCATE CURSOR_TEMP

		RETURN @FINAL_BIT 
--
END

GO
