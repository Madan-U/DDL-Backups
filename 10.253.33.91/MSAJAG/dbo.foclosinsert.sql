-- Object: PROCEDURE dbo.foclosinsert
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foclosinsert    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.foclosinsert    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.foclosinsert    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.foclosinsert    Script Date: 20-Mar-01 11:38:49 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE proc foclosinsert
       (	
	@Cl_Rate money,		
	@Expirydate smalldatetime,		
	@Trade_Date smalldatetime,	
	@Inst_Type varchar(6),
	@Symbol	varchar(12),
	@Strike_price money,
	@Cor_Act_level int,
	@MarketType  varchar(2),
	@Option_type  varchar(2)
	)
 as
 /*Used in NSE FO */ 
 /*Control Name :FoClosing Module Name :Getresult()*/
 /*Table Used : write  only :FoClosing*/
 /*Function:This is used records in foclosing table*/
 /*Written By :Ranjeet Choudhary */ 

	insert into foclosing values
		(
		 @Cl_Rate,
		 @Expirydate,
		 @Trade_Date,
		 @Inst_Type,
		 @Symbol,
  		 @Strike_price,
		 @Cor_Act_level,
 		 @MarketType ,
		 @Option_type 
		)

GO
