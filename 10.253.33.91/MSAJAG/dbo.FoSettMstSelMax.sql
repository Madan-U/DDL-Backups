-- Object: PROCEDURE dbo.FoSettMstSelMax
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FoSettMstSelMax    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.FoSettMstSelMax    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.FoSettMstSelMax    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.FoSettMstSelMax    Script Date: 20-Mar-01 11:38:50 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE proc FoSettMstSelMax as
 /*Used in NSE FO */
 /*Control Name :FoScrip2 ,Module Name :CmdSave_Click()*/
 /*Table Used : Read Only :Fosett_mst (Fo settlement master)*/
 /*Function:this store procedure is used to select max of settlement number fosett_mst (fosettlement master)*/
 /*Written By :Ranjeet Choudhary */   

select isnull(max(sett_no),0) from fosett_mst

GO
