-- Object: PROCEDURE dbo.Rpt_NseNetnsedatewise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/* report : nseposition report 
    file : nseposition 
*/
/* oppalbmscrpnsedatewisenot$ , plusonealbmScripnseposnot$ ,  oppalbmScripnsepos$, PlusOneAlbmScrip$  were cretated  new because if 
in previous view if i add tmark to group whole do while looping  in all files  would be changed*/

CREATE proc Rpt_NseNetnsedatewise 
(@sett_no varchar(7),@sett_type varchar(2), @flag varchar(1) )


as
/* if  setttype selected by user is n,w */
if @flag= 1 
begin 
select * from finalsumScrip where sett_no = @sett_no and sett_type = @sett_type  
union all
select * from oppalbmScrip where sett_no = @sett_no and sett_type = @sett_type  
union all
select * from PlusOneAlbmScrip where sett_no = ( select min(Sett_no) from sett_mst where sett_no > @sett_no  and sett_type = 'L' ) and sett_type = @sett_type 
order by Scrip_Cd,Series
end

/* if settype selected by user is  n-l(p) */
if @flag=2
begin
select * from finalsumScrip where sett_no = @sett_no and sett_type = @sett_type  
union all
select * from oppalbmScripnsedatewisenot$  where sett_no = @sett_no and sett_type = @sett_type 
union all
select * from plusonealbmScripnseposnot$  where sett_no = ( select min(Sett_no) from sett_mst where sett_no > @sett_no  and sett_type = 'L' ) and sett_type = @sett_type 
order by Scrip_Cd,Series
end

/* if settype selected by user is  n-l(d) */
if @flag=3
begin
select * from finalsumScrip where sett_no = @sett_no and sett_type = @sett_type  
union all
select * from oppalbmScripnsepos$  where sett_no = @sett_no and sett_type = @sett_type  
union all
select * from PlusOneAlbmScrip$  where sett_no = ( select min(Sett_no) from sett_mst where sett_no > @sett_no  and sett_type = 'L' ) and sett_type = @sett_type 
order by Scrip_Cd,Series
end

GO
