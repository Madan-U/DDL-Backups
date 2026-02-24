-- Object: PROCEDURE dbo.sub_rpt_settno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sub_rpt_settno    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_settno    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_settno    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** created by neelambari on 7 feb 
report : Subbills > billmain .asp 

******/
CREATE PROCEDURE
 sub_rpt_settno
@settype varchar(3)
 AS
select distinct sett_no from trdbackup where sett_type = @settype

GO
