-- Object: PROCEDURE dbo.rpt_datediff
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_datediff    Script Date: 7/8/01 3:28:40 PM ******/

/****** Object:  Stored Procedure dbo.rpt_datediff    Script Date: 2/17/01 5:19:44 PM ******/


/****** Object:  Stored Procedure dbo.rpt_datediff    Script Date: 3/21/01 12:50:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_datediff    Script Date: 20-Mar-01 11:38:55 PM ******/



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
