-- Object: PROCEDURE dbo.FoNseNSpMarginPercent
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FoNseNSpMarginPercent    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.FoNseNSpMarginPercent    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.FoNseNSpMarginPercent    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.FoNseNSpMarginPercent    Script Date: 20-Mar-01 11:38:50 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

/*The procedure was last updated on 6 th feb 2001*/

CREATE PROC FoNseNSpMarginPercent
(@inst varchar(6),
 @symbol varchar(12),
 @expirydate smalldatetime
  ) as
select nonspreadmargin from fonsenspmargin
 where expirydate=@expirydate and 
      /* valiD_date >=(select getdate()) and*/
       inst_type=@inst and
       symbol=@symbol and   
       date=(select max(date) from fonsenspmargin
                    where inst_type =@inst AND
                          SYMBOL =@symbol and 
                          expirydate=@expirydate and
                         /*The below line has been added on 2nd feb 2001 since the non spread margin was not taking properly it new non spread margin was taken*/
                         /*The below condition was not added */
                         date <=(select getdate())
            )

GO
