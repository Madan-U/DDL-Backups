-- Object: PROCEDURE dbo.CBO_GetBranchByRegion
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure [dbo].[CBO_GetBranchByRegion] 
@Region_Code varchar(20)
As
select 
       branch_code
        from
          region
               where RegionCode=@Region_Code

GO
