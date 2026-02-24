-- Object: PROCEDURE citrus_usr.pr_getimgpath
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE Procedure [citrus_usr].[pr_getimgpath](@pa_id varchar(10),@pa_slip_no varchar(10))
as
Select scanimage from maker_scancopy 
where slip_no = @pa_slip_no AND DELETED_IND=1

GO
