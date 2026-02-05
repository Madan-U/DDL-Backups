-- Object: PROCEDURE citrus_usr.PR_FetchAllInwardedImages_others
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [PR_FetchAllInwardedImages_others]
(
@pa_inward_id numeric,
@pa_ref_cur varchar(8000) output
)
    
AS      
--      
BEGIN   

		SELECT convert(varchar,indpo_id) + '~' + convert(varchar,indpo_inward_id) + '~' + indpo_image + '~' + indpo_urls as result
		FROM INWARD_DOC_PATH_OTHERS
		WHERE indpo_inward_id = @pa_inward_id 

--		DECLARE other_images_cursor CURSOR FOR
--		SELECT indpo_id,indpo_inward_id,indpo_image,indpo_urls
--		FROM INWARD_DOC_PATH_OTHERS
--		WHERE indpo_inward_id = @pa_inward_id
--
--		DECLARE @StringOfImages varchar(8000)
--		DECLARE @StringOfImages_OTH varchar(8000)
--		declare @l_indpo_id numeric,@l_indpo_inward_id numeric,@l_indpo_image varchar(100),@l_indpo_urls varchar(100)
--						
--		OPEN other_images_cursor
--		FETCH NEXT FROM other_images_cursor into @l_indpo_id,@l_indpo_inward_id,@l_indpo_image,@l_indpo_urls
--
--		WHILE @@FETCH_STATUS = 0
--		   BEGIN
--			PRINT convert(varchar,@l_indpo_id) + '~' + convert(varchar,@l_indpo_inward_id) + '~' + @l_indpo_image + '~' + @l_indpo_urls
--				if @StringOfImages = ''
--				begin
--					set @StringOfImages = convert(varchar,@l_indpo_id) + '~' + convert(varchar,@l_indpo_inward_id) + '~' + @l_indpo_image + '~' + @l_indpo_urls
--				end
--				else
--				begin
--					SET @StringOfImages_OTH = convert(varchar,@l_indpo_id) + '~' + convert(varchar,@l_indpo_inward_id) + '~' + @l_indpo_image + '~' + @l_indpo_urls
--					 --set @StringOfImages = @StringOfImages + '|*~|' + convert(varchar,@l_indpo_id) + '~' + convert(varchar,@l_indpo_inward_id) + '~' + @l_indpo_image + '~' + @l_indpo_urls
--					 CONCAT(@StringOfImages,@StringOfImages_OTH)
--				end
--
--		FETCH NEXT FROM other_images_cursor into @l_indpo_id,@l_indpo_inward_id,@l_indpo_image,@l_indpo_urls
--		END
--		
--SELECT @StringOfImages
--		CLOSE other_images_cursor
--		DEALLOCATE other_images_cursor
end

GO
