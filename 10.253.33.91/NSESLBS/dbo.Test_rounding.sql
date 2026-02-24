-- Object: PROCEDURE dbo.Test_rounding
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

Create Proc Test_rounding   
@Amt numeric(18,9),  
@Round_To int,  
@ErrNum numeric(18,9),  
@Rofig int,  
@NoZero int   
  
As   
Select ((floor(( @amt * power(10,@Round_To)+ @RoFig + @ErrNum)/(@RoFig + @NoZero )) * (@RoFig + @NoZero))/power(10,@Round_To))

GO
