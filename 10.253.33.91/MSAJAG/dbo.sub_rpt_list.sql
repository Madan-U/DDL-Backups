-- Object: PROCEDURE dbo.sub_rpt_list
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sub_rpt_list    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_list    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_list    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_list    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_list    Script Date: 12/27/00 8:59:16 PM ******/




/* report: bill report
   file :  
*/
CREATE PROCEDURE sub_rpt_list
@settno varchar(7),
@settype varchar(3),
@name varchar(21),
@membercode varchar(10)
AS
SELECT distinct s.partipantcode,m.name from  trdbackup s ,multibroker m
where m.cltcode = s.partipantcode and 
s.sett_no=@settno and s.sett_type=@settype 
and m.name like ltrim(@name)+'%'
and s.partipantcode like ltrim(@membercode)+'%'

GO
