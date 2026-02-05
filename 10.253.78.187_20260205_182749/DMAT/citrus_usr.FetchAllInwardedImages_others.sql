-- Object: FUNCTION citrus_usr.FetchAllInwardedImages_others
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE  function [citrus_usr].[FetchAllInwardedImages_others](@inward_id numeric)
RETURNS VARCHAR(8000)       
AS      
--      
BEGIN   
		DECLARE other_images_cursor CURSOR FOR
		SELECT indpo_id,indpo_inward_id,indpo_image,indpo_urls
		FROM INWARD_DOC_PATH_OTHERS
		WHERE indpo_inward_id = @inward_id

		DECLARE @StringOfImages varchar(8000)
		declare @l_indpo_id numeric,@l_indpo_inward_id numeric,@l_indpo_image varchar(100),@l_indpo_urls varchar(100)
						
		OPEN other_images_cursor
		FETCH NEXT FROM other_images_cursor into @l_indpo_id,@l_indpo_inward_id,@l_indpo_image,@l_indpo_urls

		WHILE @@FETCH_STATUS = 0
		   BEGIN
				if @StringOfImages = ''
				begin
					set @StringOfImages = convert(varchar,@l_indpo_id) + '~' + convert(varchar,@l_indpo_inward_id) + '~' + @l_indpo_image + '~' + @l_indpo_urls
				end
				else
				begin
					set @StringOfImages = @StringOfImages + '|*~|' + convert(varchar,@l_indpo_id) + '~' + convert(varchar,@l_indpo_inward_id) + '~' + @l_indpo_image + '~' + @l_indpo_urls
				end
		FETCH NEXT FROM other_images_cursor into @l_indpo_id,@l_indpo_inward_id,@l_indpo_image,@l_indpo_urls
		END
		

		CLOSE other_images_cursor
		DEALLOCATE other_images_cursor
		return @StringOfImages
end

GO
