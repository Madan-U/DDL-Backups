-- Object: PROCEDURE dbo.foSelBrokTab
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foSelBrokTab    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.foSelBrokTab    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.foSelBrokTab    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.foSelBrokTab    Script Date: 20-Mar-01 11:38:50 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


CREATE proc foSelBrokTab 
(@flag as int)
as 

if @flag =1 
begin
select distinct table_no,table_name 
from broktable 
order by table_name 
end 

if @flag=2 
begin
select distinct table_no,table_name from broktable 
where normal > 0
order by table_name 
end

GO
