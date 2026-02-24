-- Object: PROCEDURE dbo.rpt_datediff
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_datediff    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report : ageing report
   file : ageingreport.asp
*/
/* calculates difference between last balance date and date typed by user */
CREATE PROCEDURE rpt_datediff 
@vdt varchar(20),
@date1 varchar(10)
AS
select datediff=datediff(d, @vdt , @date1)

GO
