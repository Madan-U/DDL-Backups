-- Object: PROCEDURE dbo.FoImptrdSelSettMst
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FoImptrdSelSettMst    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.FoImptrdSelSettMst    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.FoImptrdSelSettMst    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.FoImptrdSelSettMst    Script Date: 20-Mar-01 11:38:50 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


CREATE proc FoImptrdSelSettMst
  (@insttype varchar(6),
   @symbol   varchar(13),
   @expirydate varchar(11)) as
 /*Used in NSE FO */ 
 /*Control Name :FoImportTrade Module Name :CmdContract_Click()*/
 /*table Used : read  only :fosettlement*/
 /*Function:This is used to select some fields from foconfirmview*/
 /*Written By :Ranjeet Choudhary */ 

 select s1.sett_no,s1.sett_type from fosett_mst s1 
          where s1.inst_type=@insttype AND 
	 	s1.symbol= @symbol AND 
		left(convert(varchar,s1.expirydate,105),11)=@expirydate

GO
