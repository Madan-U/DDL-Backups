-- Object: PROCEDURE dbo.CBO_GETUSERMAINTAINSEARCH
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





CREATE      PROC CBO_GETUSERMAINTAINSEARCH
        @Id INT,
        @UserId VARCHAR(20),
        @UserName VARCHAR(25),
        @STATUSID VARCHAR(25) ,
	     @STATUSNAME VARCHAR(25) 
AS	
IF @STATUSID <> 'Administrator'
	BEGIN
		RAISERROR ('This Procedure is accessible to Administrator', 16, 1)
		RETURN
	END

/*IF  @UserId  = '%' or @UserName = '%'
BEGIN
    IF @UserId  = '%'
            BEGIN		IF EXISTS(select 1 from	tblPradnyausers t 
							  where fldadminauto = @Id and fldcategory = '0'
							  and fldusername like @UserId  + '%' )
					 select fldusername,fldfirstname,fldlastname,fldphone1,fldphone2,fldauto, fldcategoryname = '' from	tblPradnyausers t 
					  where fldadminauto = @Id and fldcategory = '0'
					  and fldusername like @UserId  + '%' 
				     order by t.fldusername
				          
                 select t.fldusername,t.fldfirstname,t.fldlastname,t.fldphone1,t.fldphone2,t.fldauto,c.fldcategoryname from tblPradnyausers t,tblcategory c 
					 where t.fldcategory = c.fldcategorycode 
					 and  t.fldadminauto = @Id and t.fldusername like @UserID + '%' 
					 order by c.fldcategoryname,t.fldusername
		  END
      
ELSE
        BEGIN
          IF EXISTS(select 1 from tblPradnyausers	 t 
						 where fldadminauto = @Id  and fldcategory = '0'
						 and fldusername like @UserName + '%' )

	          select fldusername,fldfirstname,fldlastname,fldphone1,fldphone2,fldauto, fldcategoryname = '' from tblPradnyausers	 t 
				 where fldadminauto = @Id  and fldcategory = '0'
				 and fldusername like @UserName + '%' 
			    order by t.fldusername

			   
				 select t.fldusername,t.fldfirstname,t.fldlastname,t.fldphone1,t.fldphone2,t.fldauto,c.fldcategoryname from tblPradnyausers t,tblcategory c 
				 where t.fldcategory = c.fldcategorycode 
				 and  t.fldadminauto = @Id	 and t.fldfirstname like @UserName + '%'
				 order by c.fldcategoryname,t.fldusername
	   

END*/

 
IF  @UserId  <> '' or @UserName <>'' 
BEGIN
    IF @UserId <> ''
        BEGIN
				IF EXISTS(select 1 from	tblPradnyausers t 
							  where fldadminauto = @Id and fldcategory = '0'
							  and fldusername like @UserId  + '%' )
					  select fldusername,fldfirstname,fldlastname,fldphone1,fldphone2,fldauto, fldcategoryname = '' from	tblPradnyausers t 
					  where fldadminauto = @Id and fldcategory = '0'
					  and fldusername like @UserId  + '%' 
				     order by t.fldusername 
				ELSE
	             select t.fldusername,t.fldfirstname,t.fldlastname,t.fldphone1,t.fldphone2,t.fldauto,c.fldcategoryname from tblPradnyausers t,tblcategory c 
					 where t.fldcategory = c.fldcategorycode 
					 and  t.fldadminauto = @Id and t.fldusername like @UserID + '%' 
					 order by c.fldcategoryname,t.fldusername
		  END
ELSE
       BEGIN
          IF EXISTS(select 1 from tblPradnyausers	 t 
						 where fldadminauto = @Id  and fldcategory = '0'
						 and fldusername like @UserName + '%' )

	          select fldusername,fldfirstname,fldlastname,fldphone1,fldphone2,fldauto, fldcategoryname = '' from tblPradnyausers	 t 
				 where fldadminauto = @Id  and fldcategory = '0'
				 and fldusername like @UserName + '%' 
			    order by t.fldusername
			ELSE
				 select t.fldusername,t.fldfirstname,t.fldlastname,t.fldphone1,t.fldphone2,t.fldauto,c.fldcategoryname from tblPradnyausers t,tblcategory c 
				 where t.fldcategory = c.fldcategorycode 
				 and  t.fldadminauto = @Id	 and t.fldfirstname like @UserName + '%'
				 order by c.fldcategoryname,t.fldusername
END

END

GO
