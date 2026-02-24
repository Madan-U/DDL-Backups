-- Object: PROCEDURE dbo.isClientCodeRegisteredForITRADE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



--isClientCodeRegisteredForITRADE  'rp61','cbho'
CREATE proc [dbo].[isClientCodeRegisteredForITRADE]
@client_code varchar (100),
@sub_tag varchar(100)
as
begin

--RETURN 0
select top 1 *
from 
(
select 0 as status
union
select 1 as status from Vw_VBB_SCHEME_NAME with(nolock) where cl_code = @client_code and sub_broker = @sub_tag
) as tab order by tab.status desc


end

GO
