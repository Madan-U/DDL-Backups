-- Object: PROCEDURE citrus_usr.PR_UPD_MISMATCH_ENTR
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[PR_UPD_MISMATCH_ENTR]
AS
BEGIN 

DECLARE @SQL	VARCHAR(8000)
SET @SQL = 'SELECT * INTO ENTITY_RELATIONSHIP' + '_' + REPLACE(CONVERT(VARCHAR(11),GETDATE(),105),'-','') + ' FROM ENTITY_RELATIONSHIP'
PRINT @SQL
EXEC(@SQL) 

declare @entr_sba	varchar(16),
		@l_min_from	varchar(20),
		@l_max_from	varchar(20)

declare cursor1 cursor fast_forward for
select entr_sba
from entity_relationship 
where getdate() between entr_from_dt and isnull(entr_to_dt,getdate())
and entr_deleted_ind =1 
group by entr_sba
having count(entr_sba) = 2

 
open cursor1
fetch next from cursor1 into @entr_sba

while @@fetch_status = 0
begin

	select @l_min_from = min(ENTR_FROM_DT)
	,	@l_max_from = max(ENTR_FROM_DT) 
	from entity_relationship 
	where entr_sba = @entr_sba

	update entity_relationship
	set entr_to_dt = dateadd(dd, -1, @l_max_from)
	where entr_sba = @entr_sba
	and ENTR_FROM_DT = @l_min_from

	fetch next from cursor1 into @entr_sba

end
close cursor1
deallocate cursor1

END

GO
