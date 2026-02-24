-- Object: PROCEDURE citrus_usr.pr_get_log_dtls_for_mailer
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

 create procedure pr_get_log_dtls_for_mailer
(
	@pa_boid        varchar(16),
	@pa_ref_cur     VARCHAR(8000) OUTPUT 
)
as
begin
--select '1203320005301469|MITA ASHIT GHELANI|mita.ghelani99@gmail.com|AJWPG4793P|'
select boid +'|'+ ltrim(rtrim (Name))+' '+ltrim(rtrim (MiddleName ))+ ' ' +ltrim(rtrim ( SearchName ))+'|'
+ltrim(rtrim (emailid))+'|'+ ltrim(rtrim (pangir)) +'|' from dps8_pc1 
where boid = @pa_boid

end

GO
