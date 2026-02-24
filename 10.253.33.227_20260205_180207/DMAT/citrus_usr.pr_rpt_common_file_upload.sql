-- Object: PROCEDURE citrus_usr.pr_rpt_common_file_upload
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



CREATE PROCEDURE pr_rpt_common_file_upload

(

@pa_action varchar(50),

@pa_output varchar(8000) output

)

AS

BEGIN

	

if @pa_action = 'FILETYPE'

begin

	select distinct comm_text,comm_value from common_file_type

end



END

GO
