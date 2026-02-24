-- Object: PROCEDURE citrus_usr.pr_getpara
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create proc [citrus_usr].[pr_getpara](@pa_rpt_name varchar(100))



as 
begin 

select distinct ProcName,RptName
 from SENTOMAKER_PARA where isnull(br_flag,0) in (0) and RptName = @pa_rpt_name -- HO level


end

GO
