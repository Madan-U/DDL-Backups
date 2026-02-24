-- Object: PROCEDURE citrus_usr.Pr_VAccess
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--Pr_VAccess '03/04/2016','10',''  
create procedure Pr_VAccess  
(  
@pa_VDT varchar(20)  
,@pa_days varchar(10)  
,@pa_ref_cur varchar(100) output  
)  
as  
begin  
SELECT CASE WHEN CONVERT(DATETIME,@pa_VDT,103)   
BETWEEN DATEADD(D,-1*@pa_days,CONVERT(VARCHAR(11),GETDATE(),109)) and GETDATE() THEN 0 ELSE 1 END    
end

GO
