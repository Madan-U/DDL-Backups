-- Object: PROCEDURE dbo.rpt_acccostsummaincosttree
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccostsummaincosttree    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_acccostsummaincosttree    Script Date: 11/28/2001 12:23:46 PM ******/


/* makes a tree for selected main cost center */

CREATE PROCEDURE rpt_acccostsummaincosttree

@catcode  smallint,
@grpcode varchar(20),
@vdt datetime,
@nextgrpcode varchar(20),
@samelevelgrpcode varchar(20),
@zeros smallint

AS

/* if main cost center is selected then (e.g. br00000000) */
if @zeros = 8 
begin
/* finds for drcr same grpcode */
select catcode, flag='main' , grpcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0) ,costname,costcode
from rpt_acccostwisedrcr 
where catcode=@catcode and grpcode =@grpcode and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode , costcode, costname
union all 

/* finds for drcr for level below grpcode selected */

select catcode, flag='next' , grpcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0)  ,costname,costcode
from rpt_acccostwisedrcr 
where catcode=@catcode and (grpcode like @nextgrpcode and grpcode not like @grpcode) and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode , costcode, costname
union all 

/* finds for drcr for same level as selected  grpcode */

select catcode, flag='same' , grpcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0)  ,costname,costcode
from rpt_acccostwisedrcr 
where catcode= @catcode and grpcode like @samelevelgrpcode and grpcode not like  @grpcode and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode , costcode, costname
order by catcode,grpcode 

end

/* if any level other than main cost center (i.e br00000000) is selected ) then only difference is here the last part to display main cost centers  other than selected one
see last query which is extra */
else
begin

/* finds for drcr same grpcode */
select catcode, flag='main' , grpcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0) ,costname,costcode
from rpt_acccostwisedrcr 
where catcode=@catcode and grpcode =@grpcode and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode , costcode, costname
union all 

/* finds for drcr for level below grpcode selected */

select catcode, flag='next' , grpcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0)  ,costname,costcode
from rpt_acccostwisedrcr 
where catcode=@catcode and (grpcode like @nextgrpcode and grpcode not like @grpcode) and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode , costcode, costname
union all 

/* finds for drcr for same level as selected  grpcode */
/* here in not like  left(@grpcode,2) + '00000000'  condition is used 
    because we don't want to get level br00000000 when we have clicked br01000000 as it is not same level as  br01000000 
    since we are sending br__000000 in samelevelgrpcode */

select catcode, flag='same' , grpcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0)  ,costname,costcode
from rpt_acccostwisedrcr 
where catcode= @catcode and (grpcode like @samelevelgrpcode and grpcode not like  @grpcode  and grpcode not like left(@grpcode,2) + '00000000'  )and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode , costcode, costname

union all

/* finds for drcr for other main cost centers other than selected cost centers */

select catcode, flag='same' , grpcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0)  ,costname,costcode
from rpt_acccostwisedrcr 
where catcode= @catcode and (grpcode like  '__00000000'  and grpcode not like  left(@grpcode,2) + '%'  ) and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode , costcode, costname

union all


/* finds drcr for  main cost center whose sub cost center is selected   
     since flag is main  it will not calculate total of all its sub centers as per program
     so this will only show main cost center whose sub cost center is selected  
*/


select catcode, flag='main' , grpcode, dramt=isnull(sum(dramt),0),cramt=isnull(sum(cramt),0)  ,costname,costcode
from rpt_acccostwisedrcr 
where catcode= @catcode and (grpcode  like  left(@grpcode,2) + '00000000'  ) and vdt <= @vdt + ' 23:59:59'
group by catcode, grpcode , costcode, costname
order by catcode,grpcode 
	
end

GO
