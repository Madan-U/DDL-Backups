-- Object: PROCEDURE dbo.FotrdSelSm
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FotrdSelSm    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.FotrdSelSm    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.FotrdSelSm    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.FotrdSelSm    Script Date: 20-Mar-01 11:38:50 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


CREATE proc FotrdSelSm as
 /*Used in NSE FO */ 
 /*Control Name :FoImportTrade Module Name :CmdErrCorrect_Click()*/
 /*table Used : read only Fotrade,client2,foscrip2*/
 /*Function:This is used to select some fields from fotrade where party code from fotrade is not present in client2 table*/
 /*         or expirydate from fotrade not prsent in scrip2 table */            
 /*Written By :Ranjeet Choudhary */ 
SELECT inst_type,symbol,expirydate,option_type,strike_price,User_Id,
       Party_Code From foTrade where fotrade.party_code 
         not in (select distinct party_code from client2)
         or fotrade.expirydate not in (select expirydate from foscrip2
                                       where foscrip2.inst_type=fotrade.inst_type and
                                       foscrip2.symbol=fotrade.symbol  and 
                                       foscrip2.option_type = fotrade.option_type and
                                       foscrip2.strike_price = fotrade.strike_price and
                                       foscrip2.expirydate = fotrade.expirydate
                                        )

GO
