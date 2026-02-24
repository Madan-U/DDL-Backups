-- Object: PROCEDURE dbo.BrClosingBalance
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/**************************************************************************************************************************************************************************************************      
	THIS SP  IS USED TO FIND THE CLOSING BALANCE OF A PARTICULAR A/C CODE       
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
	Copy of BrOpeningbalance with change in condition.      
	      
	Added two new parameters viz: @flag and @costcode.       
	These are used to display the bank transactions either for all the branches or for a particular branch       
	Depending on the @flag value       
	If @flag = 0  then show bank transaction for all the branches      
	If @flag = 1 then show bank transaction for a selected branch (i.e for the passed costcode )      

	Version modified by Deepak Maharishi ON Apr 3 2007
		1. Removed Cursors and used simple assignments for all values
		2. Made changes to get the Balance in one query instead of seperate queries for Opening Balance
		2. Corrected the Balance Computation to get Opening Balance as on Reconciliation Date - 1


exec BrClosingBalance '103','Apr  1 2006 23:59:59','Mar 22 2007 23:59:59', 0,0,0
exec BrClosingBalance '103','Apr  1 2006 23:59:59','Mar 23 2007 23:59:59', 0,0,0
exec BrClosingBalance '103','Apr  1 2006 23:59:59','Mar 28 2007 23:59:59', 0,0,0
exec BrClosingBalance '103','Apr  1 2006 23:59:59','Mar 31 2007 23:59:59', 0,0,0


exec acc_PrintReconcile '103','STATEMENT', 'Mar 23 2007 23:59:59', 'Mar 23 2007 23:59:59'
***************************************************************************************************************************************************************************************************/      
    
  
CREATE  Procedure BrClosingBalance 
(
	@cltcode  varchar(10),      
	@sdtcur  varchar(11),      
	@fromdate varchar(11),      
	@vdtedtflag tinyint,      
	@flag   smallint,      
	@costcode  smallint      
)
     
AS      
      
Declare      
	@@openbaldt   varchar(11),      
	@@openentry   money,      
	@@openingbal   money,      
	@@startdate  datetime,      
	@@enddate  datetime 
  
	select @@startdate = sdtcur, @@enddate = ldtcur from parameter where @fromdate between sdtcur  and ldtcur  
  
	If @vdtedtflag = 0      
	begin      
	/*===============================================================================================================*/
		/*If the login is not branch and the user has selected the option 'ALL' as branches, so the user can view the transactions for all branches */      
	/*===============================================================================================================*/
		if @flag = 0       
		begin      
			select @@openingbal = 0      

			select 
				@@openingbal = isnull(sum(case drcr when 'd' then isnull(vamt,0) else isnull(-vamt,0) end),0) 
			from 
				ledger 
			where 
				vdt >= @@startdate 
				and vdt <= @fromdate + ' 23:59:59'
				and cltcode = @cltcode      

			Select @@Openingbal       
		end      
		/*===============================================================================================================*/
			/*IF THE LOGIN = BRANCH THE ONLY THE ENTRIES FOR THAT BRANCH ARE RETRIEVED*/      
		/*===============================================================================================================*/
		else if @flag = 1        
		begin       
			select @@openingbal = 0      
				
			select 
				@@openingbal = isnull(sum(case l.drcr when 'd' then isnull(camt,0) else isnull(-camt,0) end),0) 
			from 
				ledger l,
				ledger2 l2      
			where 
				l.vtyp = l2.vtype 
				and l.vno = l2.vno 
				and l.lno = l2.lno 
				and vdt > = @@openbaldt   
				and vdt >= @@startdate 
				and vdt <= @fromdate + ' 23:59:59'
				and l.cltcode = @cltcode 
				and costcode = @costcode      
				
			select @@openingbal      
		end      

	end      
	else if @vdtedtflag = 1      
	begin      
	/*===============================================================================================================*/
		/*If the login is not branch and the user has selected the option 'ALL' as branches, so the user can view the transactions for all branches */      
	/*===============================================================================================================*/
		if @flag = 0       
		begin      
			select @@openingbal = 0      

			select 
				@@openingbal = isnull(sum(case drcr when 'd' then isnull(vamt,0) else isnull(-vamt,0) end),0) 
			from 
				ledger 
			where 
				vdt between @@startdate and @fromdate + ' 23:59:59'
				and edt <= @fromdate + ' 23:59:59'
				and cltcode = @cltcode 
				
			select @@openingbal      
		end       
		/*===============================================================================================================*/
			/*IF THE LOGIN = BRANCH THE ONLY THE ENTRIES FOR THAT BRANCH ARE RETRIEVED*/      
		/*===============================================================================================================*/
		else if @flag = 1        
		begin       
			select @@openingbal = 0      
				
			select 
				@@openingbal = isnull(sum(case l.drcr when 'd' then isnull(camt,0) else isnull(-camt,0) end),0) 
			from 
				ledger l,
				ledger2 l2      
			where  
				l.vtyp = l2.vtype 
				and l.vno = l2.vno 
				and l.lno = l2.lno 
				and vdt between @@startdate and @fromdate + ' 23:59:59' 
				and edt <= @fromdate + ' 23:59:59'
				and l.cltcode = @cltcode 
				and costcode = @costcode      

			select @@openingbal      
		end       
	end

GO
