-- Object: PROCEDURE dbo.FoSelSettmst
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FoSelSettmst    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.FoSelSettmst    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.FoSelSettmst    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.FoSelSettmst    Script Date: 20-Mar-01 11:38:50 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE proc FoSelSettmst
  (@insttype varchar(6),
   @symbol   varchar(13),
   @expirydate smalldatetime) as
  
 /*Used in NSE FO */
 /*Control Name :FoScrip2 ,Module Name :CmdSave_Click()*/
 /*Table Used : Read Only :Fosett_mst (Fo settlement master)*/
 /*Function:this store procedure is used to check whether the record exist in fosett_mst (fosettlement master)
   for the above parameter*/
 /*Written By :Ranjeet Choudhary */   

 
   select s1.inst_type,s1.symbol,s1.expirydate from fosett_mst s1 
   where s1.inst_type=@insttype AND 
         s1.symbol=@symbol AND 
         s1.expirydate=@expirydate

GO
