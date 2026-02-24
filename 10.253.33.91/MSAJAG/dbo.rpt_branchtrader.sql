-- Object: PROCEDURE dbo.rpt_branchtrader
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_branchtrader    Script Date: 04/27/2001 4:32:33 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchtrader    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchtrader    Script Date: 20-Mar-01 11:38:54 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchtrader    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchtrader    Script Date: 12/27/00 8:58:53 PM ******/

/* report : branch
   file : option.asp
*/
/* selects names of all traders of a particular branch */
/* report : branch turnover
   file : brokerbranchwiseturn.asp, branchwise.asp
*/
/* displays list of traders under a selected branch */
CREATE PROCEDURE rpt_branchtrader
@statusid varchar(15),
@statusname varchar(25),
@branch varchar(10)
AS
if @statusid='broker'
begin
select distinct short_name  from branches where branch_cd=@branch
end 
if @statusid='branch'
begin
select distinct short_name  from branches where branch_cd=@statusname
end

GO
