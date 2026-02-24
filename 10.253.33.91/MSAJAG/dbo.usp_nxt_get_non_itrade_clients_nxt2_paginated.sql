-- Object: PROCEDURE dbo.usp_nxt_get_non_itrade_clients_nxt2_paginated
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/*
EXEC usp_nxt_get_non_itrade_clients_nxt2_paginated 'cbho','',100,0
EXEC usp_nxt_get_non_itrade_clients_nxt2_paginated 'cbho','A1002405'
EXEC usp_nxt_get_non_itrade_clients_nxt2_paginated 'cbho',''
*/
CREATE PROCEDURE usp_nxt_get_non_itrade_clients_nxt2_paginated 
	-- Add the parameters for the stored procedure here
	@subbroker varchar(100),
	@clientCode varchar(100)= '',
	@PageNo INT = 100000000,
	@PageSize INT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON;

if (isnull(@clientCode,'')='')
Begin
print 'BBB'
select Cl_code into #Vw_VBB_SCHEME_NAME from Vw_VBB_SCHEME_NAME (nolock)
where sub_broker = @subbroker
select row_number() over (order by isnull(cl_code ,'')asc) as rn,cl_code,long_name,sub_broker into #clientDetails from client_details with(nolock) 
where sub_broker = @subbroker

select count(*) totalClients into #totalClient
 
from #clientDetails WITH(NOLOCK) 
where cl_code not in (SELECT cl_code FROM #Vw_VBB_SCHEME_NAME WITH(NOLOCK))
if @pagesize = 0 and @pageno = 0 
begin
set @pagesize = 0 
set @pageno = 100000000
end
SELECT rn,cl_code,long_name,
(select totalClients from #totalClient) totalClients FROM #clientDetails WITH(NOLOCK) 
WHERE 
cl_code not in (SELECT cl_code FROM #Vw_VBB_SCHEME_NAME WITH(NOLOCK) )
ORDER BY rn 
offset @PageSize ROWS FETCH NEXT 
@pageno ROWS ONLY
END
ELSE
BEGIN
print'AAA'
SELECT cl_code,long_name FROM client_details WITH(NOLOCK) 
WHERE 
cl_code not in (SELECT cl_code FROM Vw_VBB_SCHEME_NAME WITH(NOLOCK))
and cl_code = @clientCode
END
	
END

GO
