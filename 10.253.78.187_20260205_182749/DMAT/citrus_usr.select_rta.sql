-- Object: PROCEDURE citrus_usr.select_rta
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


create proc [citrus_usr].[select_rta] 
as
begin
Select ENTM_NAME1,ENTM_ID from entity_mstr where ENTM_SHORT_NAME like 'RTA_%'
end

GO
