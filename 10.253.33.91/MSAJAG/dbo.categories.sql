-- Object: PROCEDURE dbo.categories
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




CREATE  procedure categories as   
select a.FLDCATEGORY,b.fldcategoryname,count(fldcategory) AS NOOFusers      
into q_all    
 from tblpradnyausers a ,tblcategory b    
 where    
 a.fldcategory=b.fldcategorycode     
  and a.fldcategory in    
('26',
'27',
'28',
'36',
'37',
'40',
'46',
'47',
'50',
'58',
'59',
'61',
'72',
'73',
'74',
'81',
'97',
'125',
'154',
'157',
'164',
'179',
'199',
'206',
'209',
'210',
'211',
'212',
'215',
'219',
'220',
'221',
'222',
'223',
'224',
'225',
'226',
'227',
'229',
'230',
'231',
'232',
'233',
'236',
'239',
'240',
'242',
'244',
'245',
'246',
'247',
'248',
'249',
'251',
'252')

GROUP BY a.FLDCATEGORY,b.fldcategoryname    
order by 3   
  
  
select * into q1_ALL_new from q_all   
  
select distinct b.fldusername,b.fldcategory,max(c.adddt) as lastaccess    
 into q2_ALL_new    
 from q1_ALL_new a ,tblpradnyausers b,V2_Report_Access_Log c    
where    
a.fldcategory=b.fldcategory and     
b.fldusername=c.username     
group by  b.fldusername,b.fldcategory    
order by 2    
   
select a.*,b.fldcategoryname into q3_ALL_new from     
 q2_ALL_new a ,tblcategory b    
 where a.fldcategory=b.fldcategorycode    
 order by 2    
   
     
select a.fldcategory,MAX(a.lastaccess)lastaccess,b.fldcategoryname into q4_all_new from q3_ALL_new a ,tblcategory  b    
where a.fldcategory=b.fldcategorycode    
group by a.fldcategory,b.fldcategoryname    
order by 2    
    
    
  
select * from q4_all_new

GO
