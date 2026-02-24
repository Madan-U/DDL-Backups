-- Object: PROCEDURE dbo.sub_rpt_billsettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sub_rpt_billsettno    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_billsettno    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_billsettno    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_billsettno    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_billsettno    Script Date: 12/27/00 8:59:16 PM ******/




/* report : bill report
    file : subbillmain.asp 
    report : settlementwise brokerage
    file : brokmain.asp  
 */
/* displays settlement numbers from trdbackup */
CREATE PROCEDURE sub_rpt_billsettno
@settype varchar(3)
AS 
select distinct sett_no from trdbackup
where sett_type=@settype

GO
