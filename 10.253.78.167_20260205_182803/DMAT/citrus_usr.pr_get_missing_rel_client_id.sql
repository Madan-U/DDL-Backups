-- Object: PROCEDURE citrus_usr.pr_get_missing_rel_client_id
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create proc citrus_usr.pr_get_missing_rel_client_id
as
begin
--create table missingrel(clientid varchar(16))
truncate table missingrel

insert into missingrel
select entr_sba from entity_relationship
where (ISNULL(entr_re,0) = 0  or ISNULL(ENTR_BR,0) = 0  or  ISNULL(ENTR_AR,0) = 0  or  ISNULL(ENTR_DUMMY4,0) = 0 )



end

GO
