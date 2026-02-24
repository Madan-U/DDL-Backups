-- Object: PROCEDURE dbo.rpt_clientdetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clientdetails    Script Date: 01/19/2002 12:15:13 ******/

/****** Object:  Stored Procedure dbo.rpt_clientdetails    Script Date: 01/04/1980 5:06:26 AM ******/




/****** Object:  Stored Procedure dbo.rpt_clientdetails    Script Date: 2/17/01 5:19:41 PM ******/


/****** Object:  Stored Procedure dbo.rpt_clientdetails    Script Date: 04/27/2001 4:32:34 PM ******/
/* report : allpartyledger
   file : cumledger.asp
*/
/* displays details of a client */

/*changed by mousami on 01/03/2001
  removed hardcoding 
 for sharedatabase */
 
CREATE PROCEDURE rpt_clientdetails
@clcode varchar(6)
AS
select c1.Res_Phone1,Off_Phone1, c2.tran_cat,c1.short_name, branch_cd, sub_broker, family, trader, cl_type
from client1 c1,client2 c2 
where c1.cl_code=@clcode and c2.cl_code=@clcode

GO
