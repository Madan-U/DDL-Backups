-- Object: PROCEDURE dbo.FoInsertSettMst
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FoInsertSettMst    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.FoInsertSettMst    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.FoInsertSettMst    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.FoInsertSettMst    Script Date: 20-Mar-01 11:38:50 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE proc FoInsertSettMst 
(@exchange varchar(6),
 @settttype varchar(3),
 @settno varchar(7),
 @insttype varchar(6),
 @symbol varchar(12),
 @startdate smalldatetime,
 @expirydate smalldatetime,
 @series varchar(2)) as
 
 /*Used in NSE FO */
 /*Control Name :FoScrip2 ,Module Name :CmdSave_Click()*/
 /*Table Used : write only :Fosett_mst (Fo settlement master)*/
 /*Function:this store procedure is used to enter records in fosett_mst (fosettlement master)*/
 /*Written By :Ranjeet Choudhary */   

insert into fosett_mst values(@exchange,@settttype,@settno, @insttype,@symbol,@startdate,@expirydate,0,0,0,0,@series,'N',@expirydate)

GO
