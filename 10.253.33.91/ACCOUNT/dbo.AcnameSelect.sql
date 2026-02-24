-- Object: PROCEDURE dbo.AcnameSelect
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.AcnameSelect    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.AcnameSelect    Script Date: 11/28/2001 12:23:39 PM ******/

/****** Object:  Stored Procedure dbo.AcnameSelect    Script Date: 11/24/2001 10:30:11 AM ******/
/* Modified by Vaishali on 05/11/2001 Added flags from 4 to 6*/
/****** Object:  Stored Procedure dbo.AcnameSelect    Script Date: 10/08/2001 3:11:54 AM ******/
CREATE Proc AcnameSelect
@flag integer
As
If @flag = 1 
begin 	
	Select acname,a.accat,actyp,catname,cltcode from acmast a,
        catmast c where c.accat = a.accat and c.accat not in  ('1','2','14') 
        order by acname 
end
else if @flag = 2
begin
	Select acname,a.accat,actyp,catname,cltcode from acmast a,
        	catmast c where c.accat = a.accat and c.accat not in  ('14') 
        	order by acname 
end  
else if @flag = 3
begin
        Select acname,a.accat,actyp,catname,cltcode from acmast a,
        catmast c where c.accat = a.accat and c.accat  in  ('4') 
        order by acname 
end  

else if @flag = 4  /* For selecting Cash name and code*/
begin
	Select acname,cltcode from acmast 
        	where  accat  =  '1'         	
end

else if @flag = 5 /* For selecting Bank name and code*/
begin
	Select acname,cltcode from acmast 
        	where  accat  =  '2'         	
end

else if @flag = 6   /* For selecting Party name and code*/
begin
	Select acname,cltcode from acmast 
        	where  accat  =  '4'         	
end

else if @flag = 7   /* For selecting all accounts other than party */
begin
	Select acname,cltcode from acmast 
        	where  accat <> '4'         	
end

GO
