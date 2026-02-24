-- Object: PROCEDURE dbo.CBO_GetBranchByArea
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure [dbo].[CBO_GetBranchByArea] 
@Area_Code varchar(20)
As
select 
       branch_code
        from
          area
               where AreaCode=@Area_Code

GO
