-- Object: PROCEDURE citrus_usr.pr_fetch_binaryImage
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create procedure pr_fetch_binaryImage
(
	@pa_action varchar(50),
	@pa_output varchar(max) output
)
as
begin
	select img_binary from Image_db
end

GO
