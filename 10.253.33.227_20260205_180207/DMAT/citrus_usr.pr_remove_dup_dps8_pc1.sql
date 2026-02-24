-- Object: PROCEDURE citrus_usr.pr_remove_dup_dps8_pc1
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


--begin tran
--exec pr_remove_dup_dps8_pc1
--commit
CREATE  proc [citrus_usr].[pr_remove_dup_dps8_pc1]
as
begin 

select BOID , count(1) CT INTO #T1 from dps8_pc1 
GROUP BY BOId 
HAVING COUNT (1)> 1 

insert into dps8_pc1_bak_dnd_new 
SELECT * , 'duplicate date found', getdate ()  FROM dps8_pc1 WHERE BOId IN (SELECT BOId  FROM #T1)


drop table tmpdata1
select boid  into tmpdata1
from dps8_pc1
group by boid 
having count(boid)>1;
 
 
WITH CTE (boid, DuplicateCount)
AS
(
SELECT boid ,
ROW_NUMBER() OVER(PARTITION BY BOID  ORDER BY BOID  ) ASDuplicateCount
FROM dps8_pc1 

WHERE BOID in (select BOID from tmpdata1)
)
delete   
FROM CTE
WHERE DuplicateCount >1



drop table #T1

end

GO
