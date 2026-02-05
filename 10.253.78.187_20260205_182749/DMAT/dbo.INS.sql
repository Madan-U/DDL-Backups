-- Object: PROCEDURE dbo.INS
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

/*
Authore : neeraj prasad sharma (please dont remove this :))
Example (1) Exec [dbo].[INS]  'Dbo.test where 1=1'
        (2) Exec [dbo].[INS]  'Dbo.test where name =''neeraj''' * for string

here Dbo is schema and test is tablename and 1=1 is condition

*/


CREATE procedure  [dbo].[INS]                              
(                                                          
   @Query  Varchar(MAX)                                                          
)                              

AS                              

       Set nocount ON                  

DEclare @WithStrINdex as INT                            
DEclare @WhereStrINdex as INT                            
DEclare @INDExtouse as INT                            

Declare @SchemaAndTAble VArchar(270)                            
Declare @Schema_name  varchar(30)                            
Declare @Table_name  varchar(240)                            
declare @Condition  Varchar(MAX)                             

SET @WithStrINdex=0                            

SELECT @WithStrINdex=CHARINDEX('With',@Query )                            
, @WhereStrINdex=CHARINDEX('WHERE', @Query)                            

IF(@WithStrINdex!=0)                            
Select @INDExtouse=@WithStrINdex                            
ELSE                            
Select @INDExtouse=@WhereStrINdex                            

Select @SchemaAndTAble=Left (@Query,@INDExtouse-1)                                                     
select @SchemaAndTAble=Ltrim (Rtrim( @SchemaAndTAble))                            

Select @Schema_name= Left (@SchemaAndTAble, CharIndex('.',@SchemaAndTAble )-1)                            
,      @Table_name = SUBSTRING(  @SchemaAndTAble , CharIndex('.',@SchemaAndTAble )+1,LEN(@SchemaAndTAble) )                            

,      @CONDITION=SUBSTRING(@Query,@WhereStrINdex+6,LEN(@Query))--27+6                            


Declare   @COLUMNS  table (Row_number SmallINT , Column_Name VArchar(Max) )                              
Declare @CONDITIONS as varchar(MAX)                              
Declare @Total_Rows as SmallINT                              
Declare @Counter as SmallINT              

declare @ComaCol as varchar(max)            
select @ComaCol=''                   

Set @Counter=1                              
set @CONDITIONS=''                              

INsert INTO @COLUMNS                              
Select  Row_number()Over (Order by ORDINAL_POSITION ) [Count] ,Column_Name FRom INformation_schema.columns Where Table_schema=@Schema_name                              
And table_name=@Table_name         
and Column_Name not in ('SyncDestination','PendingSyncDestination' ,'SkuID','SaleCreditedto')                  

select @Total_Rows= Count(1) FRom  @COLUMNS                              

             Select @Table_name= '['+@Table_name+']'                      

             Select @Schema_name='['+@Schema_name+']'                      

While (@Counter<=@Total_Rows )                              
begin                               
--PRINT @Counter                              

    select @ComaCol= @ComaCol+'['+Column_Name+'],'            
    FROM @COLUMNS                              
Where [Row_number]=@Counter                          

select @CONDITIONS=@CONDITIONS+ ' +Case When ['+Column_Name+'] is null then ''Null'' Else ''''''''+                              

 Replace( Convert(varchar(Max),['+Column_Name+']  ) ,'''''''',''''  )                              

  +'''''''' end+'+''','''                              

FROM @COLUMNS                              
Where [Row_number]=@Counter                              

SET @Counter=@Counter+1                              

End                              

select @CONDITIONS=Right(@CONDITIONS,LEN(@CONDITIONS)-2)                              

select @CONDITIONS=LEFT(@CONDITIONS,LEN(@CONDITIONS)-4)              
select @ComaCol= substring (@ComaCol,0,  len(@ComaCol) )                            

select @CONDITIONS= '''INSERT INTO '+@Schema_name+'.'+@Table_name+ '('+@ComaCol+')' +' Values( '+'''' + '+'+@CONDITIONS                              

select @CONDITIONS=@CONDITIONS+'+'+ ''')'''                              

Select @CONDITIONS= 'Select  '+@CONDITIONS +'FRom  ' +@Schema_name+'.'+@Table_name+' With(NOLOCK) ' + ' Where '+@Condition                              
print(@CONDITIONS)                              
Exec(@CONDITIONS)

GO
