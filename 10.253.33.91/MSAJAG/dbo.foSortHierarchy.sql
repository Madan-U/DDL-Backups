-- Object: PROCEDURE dbo.foSortHierarchy
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foSortHierarchy    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.foSortHierarchy    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.foSortHierarchy    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.foSortHierarchy    Script Date: 20-Mar-01 11:38:50 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE proc foSortHierarchy
(@inst as varchar(6),
 @symbol as varchar(12)) as
/* This store procedure sorts the expiry date from fohierarchy table */
/* for the given hierarchy */
select min(near_expirydate) as expirydate from fohierarchy 
       where valid_date >=(select getdate()) and
                   inst_type=@inst and
                   symbol =@symbol
Union All 
select near_expirydate from fohierarchy
      where near_expirydate  > (select min(near_expirydate) from fohierarchy 
	             		       where valid_date >=(select getdate()) and
		                             inst_type=@inst and
		                             symbol =@symbol
                           ) and 
            near_expirydate < ( select max(far_expirydate) from fohierarchy 
                                       where valid_date >=(select getdate()) and
		                             inst_type=@inst and
		                             symbol =@symbol
                           ) 
Union All 
select max(far_expirydate) from fohierarchy
where valid_date >=(select getdate()) and
		                     inst_type=@inst and
		                     symbol =@symbol

GO
