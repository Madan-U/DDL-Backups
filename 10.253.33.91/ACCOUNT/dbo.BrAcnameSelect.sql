-- Object: PROCEDURE dbo.BrAcnameSelect
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.BrAcnameSelect    Script Date: 02/28/2002 6:47:58 PM ******/
CREATE Proc BrAcnameSelect
@flag integer,
@branchcode varchar (10)
As
If @flag = 1 		/*Used in Cash and Bank Entries Control */
begin 	
	Select acname,a.accat,actyp,catname,cltcode from acmast a,
        	catmast c where c.accat = a.accat and c.accat not in  ('1','2','14') 
	and (branchcode like @branchcode or branchcode = 'ALL')
        	order by acname 
end
else if @flag = 2      	 /*Used in Margin Entry ( JV ) Control*/
begin
	Select acname,a.accat,actyp,catname,cltcode from acmast a,
        	catmast c where c.accat = a.accat and c.accat  in   ('3','4','14')
	and (branchcode like @branchcode or branchcode = 'ALL')
        	order by acname 
end  
else if @flag = 3		/*Used in Margin Entry and Margin Entries Control*/	
begin
        	Select acname,a.accat,actyp,catname,cltcode from acmast a,
        	catmast c where c.accat = a.accat and c.accat  in   ('4')
	and (branchcode like @branchcode or branchcode = 'ALL')
        	order by acname 
end  

else if @flag = 4  		/* For selecting Cash name and code in Cash entries  and Margin Entries control*/
begin
	Select acname,cltcode ,accat from acmast 
        	where  accat  =  '1'  and( branchcode like @branchcode or branchcode = 'ALL' )      	
end

else if @flag = 5 		/* For selecting Bank name and code in Bank entries and  Margin Entries control*/
begin
	Select acname,cltcode ,accat from acmast 
        	where  accat  =  '2'  and (branchcode like @branchcode or branchcode = 'ALL' )
end

else if @flag = 6 		/*For selecting everything except margin a/c Used in Ledger Entry Control*/
begin			
	Select acname,a.accat,actyp,catname,cltcode from acmast a,
        	catmast c where c.accat = a.accat and c.accat not in  ('14') 
	and (branchcode like @branchcode or branchcode = 'ALL')
        	order by acname 
end

else if @flag = 7 		/*Used in Ledger Edit when vtyp = 1 or 4 casg received and paid*/
begin				
	Select acname,a.accat,actyp,catname,cltcode from acmast a,
        	catmast c where c.accat = a.accat and c.accat in  ('1','3','4','18') 
	and (branchcode like @branchcode or branchcode = 'ALL')
        	order by acname 
end
else if @flag = 8 		/*Used in Ledger Edit when vtyp = 2 or 3 bank received and paid */
begin
	Select acname,a.accat,actyp,catname,cltcode from acmast a,
        	catmast c where c.accat = a.accat and c.accat  in  ('2','3','4','18') 
	and (branchcode like @branchcode or branchcode = 'ALL')
        	order by acname 
end
else if @flag = 9 		/*Used in Ledger Edit when vtyp = 5 contra entry */
begin
	Select acname,a.accat,actyp,catname,cltcode from acmast a,
        	catmast c where c.accat = a.accat and c.accat  in  ('1','2') 
	and (branchcode like @branchcode or branchcode = 'ALL')
        	order by acname 
end

GO
