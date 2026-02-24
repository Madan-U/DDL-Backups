-- Object: PROCEDURE dbo.rpt_fomodfixeddeposits
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomodfixeddeposits    Script Date: 5/11/01 6:19:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodfixeddeposits    Script Date: 5/7/2001 9:02:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodfixeddeposits    Script Date: 5/5/2001 2:43:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fomodfixeddeposits    Script Date: 5/5/2001 1:24:14 PM ******/
CREATE PROCEDURE rpt_fomodfixeddeposits

@code varchar(10),
@sdate varchar(12)

AS


select party_code,fd_id,fd_type,fd_amt,create_dt,created_by,issue_dt,
maturity_dt,fd_receive_dt,fd_status,fd_name,first_holder,second_holder,fdr_no,release_dt,remarks,update_dt 
from fixeddeposits
where party_code = @code 
and exch_indicator = 'NSE' 
and seg_indicator like 'Fut%' 
and fd_status='V'
and maturity_dt >= @sdate + ' 23:59'

GO
