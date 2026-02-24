-- Object: PROCEDURE dbo.acc_addacmast1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.acc_addacmast1    Script Date: 01/04/1980 1:40:34 AM ******/


create procedure acc_addacmast1 as 
select grpname,grpcode ,grpmain ,
maingrpname =(case 
		when  left(grpmain,2)='A0' then (select grpname from grpmast where grpcode ='A0000000000') 
	        else
	        	(case when  left(grpmain,2)='L0' then (select grpname from grpmast where grpcode ='L0000000000')  
			else 
				(case when  left(grpmain,2)='N0' then (select grpname from grpmast where grpcode ='N0000000000')
				else 
					(case when  left(grpmain,2)='X0' then (select grpname from grpmast where grpcode ='X0000000000')
						end)
					 end) 		
				end ) 
	 		  end)
from grpmast order by grpcode

GO
