-- Object: PROCEDURE citrus_usr.pr_GetArchivaldate
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--pr_GetArchivaldate 'C',''

CREATE Procedure [citrus_usr].[pr_GetArchivaldate]
(@pa_flag char(1)
,@pa_rflag varchar(10)
,@pa_msg varchar(1000) output
)
as 

begin
	if @pa_flag = 'C'
	begin
		select convert(varchar(11),FINH_START_DT) + '-' + convert(varchar(11),FINH_END_DT ) DTVAL from FIN_CURRENT_MSTR
	end

	if @pa_flag = 'H'
	begin
		select convert(varchar(11),FINH_START_DT) + '-' + convert(varchar(11),FINH_END_DT ) DTVAL from FIN_HISTORIAL_MSTR
	end
end

GO
